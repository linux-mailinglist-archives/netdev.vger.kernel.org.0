Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7050986F
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385402AbiDUG7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385443AbiDUG6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:58:47 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C5715A3C;
        Wed, 20 Apr 2022 23:55:56 -0700 (PDT)
X-UUID: c2c7cc54b950481eb43bf43fecc95331-20220421
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:830c6e4e-ed07-45ec-8f49-f9924753a6c2,OB:0,LO
        B:0,IP:0,URL:8,TC:0,Content:0,EDM:0,RT:0,SF:50,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:58
X-CID-INFO: VERSION:1.1.4,REQID:830c6e4e-ed07-45ec-8f49-f9924753a6c2,OB:0,LOB:
        0,IP:0,URL:8,TC:0,Content:0,EDM:0,RT:0,SF:50,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:58
X-CID-META: VersionHash:faefae9,CLOUDID:e67f73f0-da02-41b4-b6df-58f4ccd36682,C
        OID:bfaf4f356833,Recheck:0,SF:13|15|28|17|19|48,TC:nil,Content:0,EDM:-3,Fi
        le:nil,QS:0,BEC:nil
X-UUID: c2c7cc54b950481eb43bf43fecc95331-20220421
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1400714960; Thu, 21 Apr 2022 14:55:48 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 21 Apr 2022 14:55:47 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 21 Apr
 2022 14:55:46 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 21 Apr 2022 14:55:45 +0800
From:   <Lina.Wang@mediatek.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>,
        Maciej enczykowski <maze@google.com>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] selftests: bpf: add test for bpf_skb_change_proto
Date:   Thu, 21 Apr 2022 14:49:24 +0800
Message-ID: <20220421064924.25706-1-Lina.Wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <9dc51533-92d2-1c82-2a6e-96e1ac747bb7@iogearbox.net>
References: <9dc51533-92d2-1c82-2a6e-96e1ac747bb7@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-04-07 at 17:22 +0200, Daniel Borkmann wrote:
> Hi Lina,
> 
> On 4/7/22 10:47 AM, Lina Wang wrote:
> > The code is copied from the Android Open Source Project and the
> > author(
> > Maciej Żenczykowski) has gave permission to relicense it under
> > GPLv2.
> > 
> > The test is to change input IPv6 packets to IPv4 ones and output
> > IPv4 to
> > IPv6 with bpf_skb_change_proto.
> > ---
> 
> Your patch 2/3 is utilizing this program out of
> selftests/net/udpgro_frglist.sh,
> however, this is a bit problematic given BPF CI which runs on every
> BPF submitted
> patch. Meaning, udpgro_frglist.sh won't be covered by CI and only
> needs to be run
> manually. Could you properly include this into test_progs from BPF
> suite (that way,
> BPF CI will also pick it up)? See also [2] for more complex netns

Please check my previous response, do you agree with me? I can move such nat6to4.c to net/, not bpf/, no need to add bpf test progs

Thanks!

