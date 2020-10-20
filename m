Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA27A294096
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394703AbgJTQeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394687AbgJTQeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 12:34:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99CCB2224A;
        Tue, 20 Oct 2020 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603211647;
        bh=k/CzWaaRtw2aJTqNhOY3m0LJsco5GLdq4nD5iASwUx8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eHHMAEtwlcQ1vJr+a+c8+8oyQyY1h+DRiRuXExmMfwO3UAlP8zNHtScitDcF3X2Tl
         x1aotzkzuGhhoakKWR6Mli4K7PWRRfiVs5DYlvVQ5TeiajkHy5Gcid/hs1WjiM25RS
         BejACx70FVNBJpukgCeUBcOb8U0H4Ea1XVswbbMQ=
Date:   Tue, 20 Oct 2020 09:34:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
Message-ID: <20201020093405.59079473@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160319106221.15822.2629789706666194966.stgit@toke.dk>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
        <160319106221.15822.2629789706666194966.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 12:51:02 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> +struct bpf_nh_params {
> +	u8 nh_family;
> +	union {
> +		__u32 ipv4_nh;
> +		struct in6_addr ipv6_nh;
> +	};
> +};

Folks, not directly related to this set, but there's a SRv6 patch going
around which adds ifindex, otherwise nh can't be link local.

I wonder if we want to consider this use case from the start (or the
close approximation of start in this case ;)).
