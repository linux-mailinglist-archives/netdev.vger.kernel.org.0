Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B35C4FDF2B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350145AbiDLMGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354073AbiDLMEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:04:21 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BC547ADC;
        Tue, 12 Apr 2022 04:07:00 -0700 (PDT)
X-UUID: 676868af6406413787f0d702b42f98eb-20220412
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:51df6b48-84d7-4058-bb75-9795b7018160,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:50,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:50
X-CID-INFO: VERSION:1.1.4,REQID:51df6b48-84d7-4058-bb75-9795b7018160,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:50,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:50
X-CID-META: VersionHash:faefae9,CLOUDID:8e5ae6a8-d103-4e36-82b9-b0e86991b3df,C
        OID:IGNORED,Recheck:0,SF:13|15|28|17|19|48,TC:nil,Content:0,EDM:-3,File:ni
        l,QS:0,BEC:nil
X-UUID: 676868af6406413787f0d702b42f98eb-20220412
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 417370313; Tue, 12 Apr 2022 19:06:56 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 12 Apr 2022 19:06:55 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Apr 2022 19:06:55 +0800
Message-ID: <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
From:   Deren Wu <deren.wu@mediatek.com>
To:     Kalle Valo <kvalo@kernel.org>, Philippe Schenker <dev@pschenker.ch>
CC:     <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        <linux@leemhuis.info>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Sean Wang" <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        "YN Chen" <YN.Chen@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>
Date:   Tue, 12 Apr 2022 19:06:54 +0800
In-Reply-To: <87y20aod5d.fsf@kernel.org>
References: <20220412090415.17541-1-dev@pschenker.ch>
         <87y20aod5d.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
> Philippe Schenker <dev@pschenker.ch> writes:
> 
> > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
> > 
> > This commit introduces a regression on some systems where the
> > kernel is
> > crashing in different locations after a reboot was issued.
> > 
> > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest
> > firmware.
> > 
> > Link: 
> > https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!CTRNKA9wMg0ARbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14J4iDycWA9cq36Y$
> >  
> > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> 
> Can I take this to wireless tree? Felix, ack?
> 
> I'll also add:
> 
> Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> 

Hi Kalle,

We have a patch for a similar problem. Can you wait for the
verification by Philippe?
Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure after
reboot")
Link: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/mediatek/mt76?id=602cc0c9618a819ab00ea3c9400742a0ca318380

I can reproduce the problem in my v5.16-rc5 desktop. And the issue can
be fixed when the patch applied.


Hi Philippe,

Can you please help to check the patch in your platform?


Regards,
Deren

