Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AE6294275
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437740AbgJTSu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437710AbgJTSu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 14:50:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7072222D;
        Tue, 20 Oct 2020 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603219856;
        bh=Z9eyHQfQRqB9BMwZRnDTlB9ZhBAPjADQ4injAvC7ns4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j9RDhL9AkeZmHQ7m0hrgPi7ZL2T5ALGnkr3j8h16fGsFdTQBtz/QZUCaZCmb0EUwl
         9H4TvHxrLIz30HJSXAc5jsFakVT7XXXfm76wiysxWpRMtp9a9eekL4jy/0jwGUwgRy
         2C7p4K5a3X0ZRSZ9e/gYFfvAjoNBSrfqeXPv+wjk=
Date:   Tue, 20 Oct 2020 11:50:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
Message-ID: <20201020115054.3a097b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e8c261bf-2d43-ca4b-945d-353ada65c20a@gmail.com>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
        <160319106221.15822.2629789706666194966.stgit@toke.dk>
        <20201020093405.59079473@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87zh4g22ro.fsf@toke.dk>
        <e8c261bf-2d43-ca4b-945d-353ada65c20a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 12:14:16 -0600 David Ahern wrote:
> On 10/20/20 12:03 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> >> On Tue, 20 Oct 2020 12:51:02 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote: =20
> >>> +struct bpf_nh_params {
> >>> +	u8 nh_family;
> >>> +	union {
> >>> +		__u32 ipv4_nh;
> >>> +		struct in6_addr ipv6_nh;
> >>> +	};
> >>> +}; =20
> >>
> >> Folks, not directly related to this set, but there's a SRv6 patch going
> >> around which adds ifindex, otherwise nh can't be link local.
> >>
> >> I wonder if we want to consider this use case from the start (or the
> >> close approximation of start in this case ;)). =20
> >=20
> > The ifindex is there, it's just in the function call signature instead
> > of the struct... Or did you mean something different?
>=20
> ifindex as the first argument qualifies the device for the address.

Ah, I should have read closer. Seeing there is a plen I assumed all
args would naturally be in the structure, but I'm guessing the case
where params are NULL will be quite common. Don't mind me.
