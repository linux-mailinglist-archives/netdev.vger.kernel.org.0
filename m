Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D72942A2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437861AbgJTTBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390864AbgJTTBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 15:01:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF1C72223C;
        Tue, 20 Oct 2020 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603220490;
        bh=CAPUNzgQ+fKiRmkaBvSyuCbyeq4eHgrM3/jOC4mlFw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CJkI9dn0QHgRuVjdVOMMDOSbdDqcAHO/XRutaAHTFqFbLfwb1G1Eta/DZwhWhEwbe
         UsvCxIVmfpTazM7W94T7EmhWSdbj17lUuJ9DV8c7UoRXs3LIx2+55G9zPIBOrCZ7tg
         A5QnQqMyuwtgZFUrsvsXz7Ezq16lqgGEkMNYIqBA=
Date:   Tue, 20 Oct 2020 12:01:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
Message-ID: <20201020120128.338595e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87v9f422jx.fsf@toke.dk>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
        <160319106221.15822.2629789706666194966.stgit@toke.dk>
        <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9f422jx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 20:08:18 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Isn't this backward? The hole could be named in the internal structure.
> > This is a bit of a gray area, but if you name this hole in uAPI and
> > programs start referring to it you will never be able to reuse it.
> > So you may as well not require it to be zeroed.. =20
>=20
> Hmm, yeah, suppose you're right. Doesn't the verifier prevent any part
> of the memory from being unitialised anyway? I seem to recall having run
> into verifier complaints when I didn't initialise struct on the stack...

Good point, in which case we have a convenient way to zero the hole
after nh_family but no convenient way to zero the empty address space
for IPv4 :) (even though that one only needs to be zeroed for the
verifier)
