Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB41930DB0A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhBCNX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:23:29 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7814 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhBCNX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 08:23:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601aa3a70002>; Wed, 03 Feb 2021 05:22:47 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 13:22:46 +0000
Date:   Wed, 3 Feb 2021 15:22:43 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>
CC:     <coreteam@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, <lvs-devel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next v1 3/4] net/core: move gro function declarations
 to separate header
Message-ID: <20210203132243.GM3264866@unreal>
References: <20210203101612.4004322-1-leon@kernel.org>
 <20210203101612.4004322-4-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210203101612.4004322-4-leon@kernel.org>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612358567; bh=W9V+E7YJOYX62ra3dha0U221aVuh7TmZXSzu1IxejSE=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:X-Originating-IP:X-ClientProxiedBy;
        b=ZAsNQ2TPIO7zk65P7mhskDy04d8hISs21+u3TdG/8sFxXefPoTbO8AhWVXAyYlVJY
         kjGfHzCojzRJwtUSs02zbZgEAOFHvbPjUr1VMnA5/0YAFljLTT+URxloJW5c6m1xfC
         +jltOxmb20pg10rnIIODIp35dF6NbfRW1z03Yq1/tvkpA6BS8XLQPjkTR2wQuF36NA
         KLFOOxosng9e7mcrI6EaPAXf8KybSnKzzmL5AVnOBvX3Hkmuz0xMoDjp02Ggm4Er8i
         dc4GXCLORnqN3ncuvYkgd8IRzZEYsXeT+tqVZdv2VfT28sQjUvfA2GwDVskaGUFhEb
         2dbD5/BS1arvA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 12:16:11PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Fir the following compilation warnings:
>  1031 | INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *s=
kb)
>
> net/ipv6/ip6_offload.c:182:41: warning: no previous prototype for =E2=80=
=98ipv6_gro_receive=E2=80=99 [-Wmissing-prototypes]
>   182 | INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct l=
ist_head *head,
>       |                                         ^~~~~~~~~~~~~~~~
> net/ipv6/ip6_offload.c:320:29: warning: no previous prototype for =E2=80=
=98ipv6_gro_complete=E2=80=99 [-Wmissing-prototypes]
>   320 | INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb=
, int nhoff)
>       |                             ^~~~~~~~~~~~~~~~~
> net/ipv6/ip6_offload.c:182:41: warning: no previous prototype for =E2=80=
=98ipv6_gro_receive=E2=80=99 [-Wmissing-prototypes]
>   182 | INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct l=
ist_head *head,
>       |                                         ^~~~~~~~~~~~~~~~
> net/ipv6/ip6_offload.c:320:29: warning: no previous prototype for =E2=80=
=98ipv6_gro_complete=E2=80=99 [-Wmissing-prototypes]
>   320 | INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb=
, int nhoff)
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/net/gro.h | 12 ++++++++++++
>  net/core/dev.c    |  7 +------
>  2 files changed, 13 insertions(+), 6 deletions(-)
>  create mode 100644 include/net/gro.h

I sent it too fast, sorry for that.
There is a need to add #include <net/gro.h> to the ip6_offload.c.

I will resend.

Thanks
