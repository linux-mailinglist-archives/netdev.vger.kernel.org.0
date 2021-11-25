Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E1845D361
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbhKYDGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238540AbhKYDEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:04:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96DAF60E0B;
        Thu, 25 Nov 2021 03:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809286;
        bh=u7Um1JdHZLXlvX08LjJrtLvjfk1/6AnFGWnU4dytDd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hgtS9a+WWEfNJnnMCxxJgmlM3JHxTMr0NW0nAygsiBPJh4ZkRtqDtBZPRGioCkyK+
         2Jz7wl/KTU3DQ7oii6Zsza7iqu6ss0ecKDe8XgyierioItbBzf0HfqFUJ+BBUYqSyc
         b8V7Zqv6M2r7eVY/hJVRtGKGFN3HcuhwvAnvTDwIbF2DdZVa+LFO4fnJHUixEH4ryB
         rAgD30L8pfV1a6Ddyo0Koe3C2CPmeqaDMyNaw2H70b5uTRFmEhnATs1mdiiNpTfVap
         9MeA0uB27FGBh/JA/zBGS0F7YotOb6fKqqGUTC0kEyDN88ZLO0vXnBLYetroD8VtuG
         ku6nUSEv8leEA==
Date:   Wed, 24 Nov 2021 19:01:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH] net-ipv6: changes to ->tclass (via IPV6_TCLASS) should
 sk_dst_reset()
Message-ID: <20211124190125.494f62ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123223208.1117871-1-zenczykowski@gmail.com>
References: <20211123223208.1117871-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 14:32:08 -0800 Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> This is to match ipv4 behaviour, see __ip_sock_set_tos()
> implementation.
>=20
> Technically for ipv6 this might not be required because normally we
> do not allow tclass to influence routing, yet the cli tooling does
> support it:
>=20
> lpk11:~# ip -6 rule add pref 5 tos 45 lookup 5
> lpk11:~# ip -6 rule
> 5:      from all tos 0x45 lookup 5
>=20
> and in general dscp/tclass based routing does make sense.
>=20
> We already have cases where dscp can affect vlan priority and/or
> transmit queue (especially on wifi).
>=20
> So let's just make things match.  Easier to reason about and no harm.
>=20
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Please send related patches as a series. There are dependencies here
which prevent the build bot from doing its job (plus it's less work=20
for me since I apply by series :)).
