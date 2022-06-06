Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF053E20D
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiFFIZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiFFIZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:25:44 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAF97A471;
        Mon,  6 Jun 2022 01:25:38 -0700 (PDT)
X-UUID: fdf3a82edc2b41c5894a1353ab188293-20220606
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:b10bb8a7-f534-4e20-91d3-20e88d5a71d4,OB:-327
        68,LOB:-32768,IP:-32768,URL:-32768,TC:-32768,Content:-32768,EDM:-32768,RT:
        -32768,SF:-32768,FILE:-32768,RULE:Release_Ham,ACTION:release,TS:0
X-CID-INFO: VERSION:1.1.5,REQID:b10bb8a7-f534-4e20-91d3-20e88d5a71d4,OB:-32768
        ,LOB:-32768,IP:-32768,URL:-32768,TC:-32768,Content:-32768,EDM:-32768,RT:-3
        2768,SF:-32768,FILE:-32768,RULE:Release_Ham,ACTION:release,TS:0
X-CID-META: VersionHash:2a19b09,CLOUDID:nil,COID:nil,Recheck:0,SF:nil,TC:nil,C
        ontent:nil,EDM:nil,IP:nil,URL:nil,File:nil,QS:0,BEC:nil
X-UUID: fdf3a82edc2b41c5894a1353ab188293-20220606
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1927022851; Mon, 06 Jun 2022 15:38:59 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 6 Jun 2022 15:38:58 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jun 2022 15:38:56 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v2] selftests net: fix bpf build error
Date:   Mon, 6 Jun 2022 15:32:13 +0800
Message-ID: <20220606073213.8957-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <83d04ebf876fc2be804a6351318806cd38fba20b.camel@redhat.com>
References: <83d04ebf876fc2be804a6351318806cd38fba20b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-02 at 12:29 +0200, Paolo Abeni wrote:
> On Wed, 2022-06-01 at 16:48 +0800, Lina Wang wrote:
> > bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add
> > more
> > including path.
> > 
> > Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf
>  CLANG ?= clang
>  CCINCLUDE += -I../../bpf
> -CCINCLUDE += -I../../../../lib
> +CCINCLUDE += -I../../../lib
>  CCINCLUDE += -I../../../../../usr/include/
> ---

Your solution is right,

> (But I still hit the "overriding recipe for target 'clean'" warnings)

I have fixed in v3, the warning is that tools/testing/selftests/net/bpf/Makefile has redefined "clean"

Thanks!
