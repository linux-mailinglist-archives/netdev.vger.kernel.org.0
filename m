Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05AE2976C1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750118AbgJWSSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750086AbgJWSSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 14:18:43 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFBF6208E4;
        Fri, 23 Oct 2020 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603477123;
        bh=ylITAyPxL1iTJDK7oIOh/4MeeDKSIBOSRZU9Lcrcnl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sF864kXITXfnbH35wqTtEx/g7TDbHkqBfFTLfisF3CDHjRcDAiIVkY6wT6P9rRA8i
         i4lApyeRYlYtpeHsZsrGaWzpEfMvU7cb+yQmCLsUsCvWOPakqaNaUtGeLArl2DLSN3
         Gu/U0Wscm7wjCw+HP5/try4AP8w+TOU74N8S4tt8=
Date:   Fri, 23 Oct 2020 11:18:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCHv3 net 2/2] IPv6: reply ICMP error if the first fragment
 doesn't include all headers
Message-ID: <20201023111841.5b0991cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023064347.206431-3-liuhangbin@gmail.com>
References: <20201021042005.736568-1-liuhangbin@gmail.com>
        <20201023064347.206431-1-liuhangbin@gmail.com>
        <20201023064347.206431-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 14:43:47 +0800 Hangbin Liu wrote:
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index ec448b71bf9a..0bda77d7e6b8 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -145,6 +145,7 @@ static bool is_ineligible(const struct sk_buff *skb)
>  	int ptr =3D (u8 *)(ipv6_hdr(skb) + 1) - skb->data;
>  	int len =3D skb->len - ptr;
>  	__u8 nexthdr =3D ipv6_hdr(skb)->nexthdr;
> +	unsigned int offs =3D 0;
>  	__be16 frag_off;
> =20
>  	if (len < 0)

net/ipv6/icmp.c: In function =E2=80=98is_ineligible=E2=80=99:
net/ipv6/icmp.c:148:15: warning: unused variable =E2=80=98offs=E2=80=99 [-W=
unused-variable]
  148 |  unsigned int offs =3D 0;
      |               ^~~~
