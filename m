Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856AA4BAFB1
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 03:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiBRC3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 21:29:32 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiBRC3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 21:29:32 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BB1BF3;
        Thu, 17 Feb 2022 18:29:16 -0800 (PST)
X-UUID: 08657ab6883d452fa20ea281cf2356aa-20220218
X-UUID: 08657ab6883d452fa20ea281cf2356aa-20220218
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1321124463; Fri, 18 Feb 2022 10:29:13 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 18 Feb 2022 10:29:12 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 18 Feb 2022 10:29:08 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3] net: fix wrong network header length
Date:   Fri, 18 Feb 2022 10:23:15 +0800
Message-ID: <20220218022315.2560-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <CAADnVQJEXOOH6--uA7BvFUPmXY42zeOQVweHmaMqkbj_g5TLqA@mail.gmail.com>
References: <CAADnVQJEXOOH6--uA7BvFUPmXY42zeOQVweHmaMqkbj_g5TLqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-17 at 09:05 -0800, Alexei Starovoitov wrote:
> On Thu, Feb 17, 2022 at 12:45 AM Paolo Abeni <pabeni@redhat.com>
> wrote:
> > To clarify: Alexei is asking to add a test under:
> > 
> > tools/testing/selftests/net/
> > 
> > to cover this specific case. You can propbably extend the existing
> > udpgro_fwd.sh.
> 
> Exactly.
> I suspect the setup needs a bit more than just iperf udp test.
> Does it need a specific driver and hw?

My hw is Android phone, Android system has improved clatd with bpf. When 
clatd starts, cls_bpf_classify will handle ingress packets with bpf progs.
bpf_skb_proto_6_to_4 is used here.

> Can it be reproduced with veth or other virtual netdev?

I am not sure. I have no idea how to verify it in linux system. 

> Also commit talks about bpf_skb_proto_6_to_4.
> So that bpf helper has to be somehow involved, but iperf udp test
> says nothing about it.
> Please craft a _complete_ selftest.

Thanks!


