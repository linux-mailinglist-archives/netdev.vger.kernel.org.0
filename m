Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78712F6988
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbhANS2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbhANS2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:28:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70BB723A50;
        Thu, 14 Jan 2021 18:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610648857;
        bh=+ekRq6+uvmYnay2fHyfawgs0fDHgxr8CClDTPQkuR6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FE40DPDSz5+073s5PDhXDHU6c+oVT0iVJVcEw99PEIQ0fUl6bsnZUrZq1xpuW/4ZR
         8wdqSo+gWWYliwmfgwry9n1hntdUbt8zKrom38hB4anJ+OxJ0RLjvJ8Npicvme38P3
         80q7IMQz30+aYNmYQBwMkyenWEvUjX0BQRi02XXo+eMCbJQBN60v2HoFDfcBts5WA8
         S1rX8pz4xQMJOkQ0TZP1i9lgCRuzslHS4hLNHnnN6ZaQQLhBV+qULSbfuLa+hBaKUH
         nvyQkmKQLgJZrKsO6EGHWLYNdf8aNz0Kvq1k9KhGs0Gd+zLeVkQe/SjaWuFOpaByB9
         ZdAQO8VmoXFoQ==
Date:   Thu, 14 Jan 2021 10:27:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: sit: unregister_netdevice on newlink's error
 path
Message-ID: <20210114102736.037c6494@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f7ddd59c-8446-4771-c1a6-c58819d5bcdb@6wind.com>
References: <20210114012947.2515313-1-kuba@kernel.org>
        <f7ddd59c-8446-4771-c1a6-c58819d5bcdb@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 09:49:48 +0100 Nicolas Dichtel wrote:
> Le 14/01/2021 =C3=A0 02:29, Jakub Kicinski a =C3=A9crit=C2=A0:
> [snip]
> > --- a/net/ipv6/sit.c
> > +++ b/net/ipv6/sit.c
> > @@ -1645,8 +1645,11 @@ static int ipip6_newlink(struct net *src_net, st=
ruct net_device *dev,
> >  	}
> > =20
> >  #ifdef CONFIG_IPV6_SIT_6RD
> > -	if (ipip6_netlink_6rd_parms(data, &ip6rd))
> > +	if (ipip6_netlink_6rd_parms(data, &ip6rd)) {
> >  		err =3D ipip6_tunnel_update_6rd(nt, &ip6rd);
> > +		if (err) =20
> nit: I would prefer 'if (err < 0)' to be consistent with the rest of the =
sit
> code, but it's purely aesthetic (ipip6_tunnel_update_6rd() returns a nega=
tive
> value or 0).

Done.

> With or without this:
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Thanks for the review, applied!
