Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309504B0D15
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241301AbiBJMCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:02:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240666AbiBJMCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:02:42 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE66397;
        Thu, 10 Feb 2022 04:02:39 -0800 (PST)
X-UUID: 60d56689ff5c4e618cc8c82ac55ddcd5-20220210
X-UUID: 60d56689ff5c4e618cc8c82ac55ddcd5-20220210
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 310448138; Thu, 10 Feb 2022 20:02:35 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 10 Feb 2022 20:02:34 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 20:02:32 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <maze@google.com>,
        <willemb@google.com>, <edumazet@google.com>,
        <zhuoliang.zhang@mediatek.com>, <chao.song@mediatek.com>,
        "lina . wang" <lina.wang@mediatek.com>
Subject: Re: [PATCH] net: fix wrong network header length
Date:   Thu, 10 Feb 2022 19:56:34 +0800
Message-ID: <20220210115634.18563-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220209170610.10694339@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220209170610.10694339@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: lina.wang <lina.wang@mediatek.com>

On Wed, 2022-02-09 at 17:06 -0800, Jakub Kicinski wrote:
> On Wed, 9 Feb 2022 18:25:07 +0800 lina.wang wrote:
> > We use NETIF_F_GRO_FRAGLIST not for forwarding scenary, just for
> > software udp gro. Whatever NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_FWD,
> > skb_segment_list should not have bugs.
> > 
> > We modify skb_segment_list, not in epbf. One point is traversing
> > the
> > segments costly, another is what @Maciej said, *other* helper may
> > have
> > the same problem. In skb_segment_list, it calls
> > skb_headers_offset_update to update different headroom, which
> > implys
> > header maybe different.
> 
> Process notes:
>  - the patch didn't apply so even if the discussion concludes that 
>    the patch was good you'll need to rebase on netdev/net and repost;
>  - please don't top post.

I have rebased and reposted--
https://patchwork.kernel.org/project/netdevbpf/patch/20220210091655.17231-1-lina.wang@mediatek.com/, 
please check if it can apply.

Thanks!
