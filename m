Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBBC67705C
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjAVP7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 10:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjAVP7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 10:59:23 -0500
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FED21A4BF;
        Sun, 22 Jan 2023 07:59:21 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sun, 22 Jan
 2023 18:59:17 +0300
Received: from localhost (10.0.253.157) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Sun, 22 Jan
 2023 18:59:17 +0300
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        <lvc-project@linuxtesting.org>
Subject: [PATCH 5.10 0/1] mt76: move mt76_init_tx_queue in common code
Date:   Sun, 22 Jan 2023 07:59:10 -0800
Message-ID: <20230122155910.32635-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112115850.9208-2-n.zhandarovich@fintech.ru>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.157]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My apologies, I should've have explained my reasoning for the patch better (and sooner).

1. My issue with 5.10 version of mt7615_init_tx_queues() in drivers/net/wireless/mediatek/mt76/mt7615/dma.c is that return value of final call to mt7615_init_tx_queue() is not taken into account
when returning result of mt7615_init_tx_queues(). So, if last mt7615_init_tx_queue() fails (due to memory issues, for instance), parent function will still erroneously return 0.

2. To correct the issue, I turned to Lorenzo's patch in b671da33d1c5973f90f098ff66a91953691df582 which solves my petit problem as well as rewrites a single mt76_init_tx_queue() function to be used
across all mt76 drivers.

3. I was torn between writing my own little patch to fix a single mistake or use an existing one that increases code readability and uniformity. I settled on latter.

4. As for this patch exclusivity to 5.10.y branch, I have an incentive to prioritize 5.10 of all others. Wasn't sure I should be the one to suggest the patch for other branches but it does make sense.

Keep having issues with quoting emails properly, hope this one worked fine.

Thanks,

Nikita
