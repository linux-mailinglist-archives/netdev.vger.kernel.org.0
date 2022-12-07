Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1785645694
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLGJfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiLGJfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:35:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E92FFE0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:35:31 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRsZ940mPzJqKB;
        Wed,  7 Dec 2022 17:34:41 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 17:34:59 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <isdn@linux-pingi.de>, <davem@davemloft.net>
Subject: [PATCH net 0/3] mISDN: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 7 Dec 2022 17:32:36 +0800
Message-ID: <20221207093239.3775457-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call consume_skb() from hardware interrupt context
or with interrupts being disabled. This patchset replace dev_kfree_skb()
with dev_consume_skb_irq() under spin_lock_irqsave().

Yang Yingliang (3):
  mISDN: hfcsusb: don't call dev_kfree_skb() under spin_lock_irqsave()
  mISDN: hfcpci: don't call dev_kfree_skb() under spin_lock_irqsave()
  mISDN: hfcmulti: don't call dev_kfree_skb() under spin_lock_irqsave()

 drivers/isdn/hardware/mISDN/hfcmulti.c | 8 ++++----
 drivers/isdn/hardware/mISDN/hfcpci.c   | 4 ++--
 drivers/isdn/hardware/mISDN/hfcsusb.c  | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.25.1

