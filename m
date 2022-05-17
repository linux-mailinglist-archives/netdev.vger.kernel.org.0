Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8979552975A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiEQC06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQC0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:26:53 -0400
Received: from spamsz.greatwall.com.cn (spamfw.greatwall.com.cn [111.48.58.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CAD9AE5C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 19:26:50 -0700 (PDT)
X-ASG-Debug-ID: 1652754406-0ec57263b407e40001-BZBGGp
Received: from greatwall.com.cn (mailsz.greatwall.com.cn [10.46.20.97]) by spamsz.greatwall.com.cn with ESMTP id V3eY5To10NSIOIpO; Tue, 17 May 2022 10:26:46 +0800 (CST)
X-Barracuda-Envelope-From: lianglixue@greatwall.com.cn
X-Barracuda-RBL-Trusted-Forwarder: 10.46.20.97
Received: from localhost.localdomain (unknown [223.104.68.17])
        by mailsz.greatwall.com.cn (Coremail) with SMTP id YRQuCgA3lVJHBoNiEXwVAA--.9935S2;
        Tue, 17 May 2022 10:19:53 +0800 (CST)
From:   lixue liang <lianglixue@greatwall.com.cn>
X-Barracuda-RBL-IP: 223.104.68.17
X-Barracuda-Effective-Source-IP: UNKNOWN[223.104.68.17]
X-Barracuda-Apparent-Source-IP: 223.104.68.17
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixue liang <lianglixue@greatwall.com.cn>
Subject: [PATCH v3 3/3] igb_main: Assign random MAC address instead of fail in case of invalid one
Date:   Tue, 17 May 2022 02:25:46 +0000
X-ASG-Orig-Subj: [PATCH v3 3/3] igb_main: Assign random MAC address instead of fail in case of invalid one
Message-Id: <20220517022546.86523-1-lianglixue@greatwall.com.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: YRQuCgA3lVJHBoNiEXwVAA--.9935S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1rtry3JF4rKw1xXrW3Awb_yoW8JF4Dpa
        ykJFWIgrykXr4jg3ykXw4xZas0ka90qa45GrZxAw1F9Fn0vrWDAr45K347tryrJrZ5Zanx
        tr4avw4kuan8JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
        W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
        k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
        xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: xold0w5ol03v46juvthwzdzzoofrzhdfq/
X-Barracuda-Connect: mailsz.greatwall.com.cn[10.46.20.97]
X-Barracuda-Start-Time: 1652754406
X-Barracuda-URL: https://spamfw.greatwall.com.cn:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at greatwall.com.cn
X-Barracuda-Scan-Msg-Size: 1262
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4610 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.98058
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, when the user uses igb_set_eeprom to modify the MAC
address to be invalid, the igb driver will fail to load. If there is no
network card device, the user must modify it to a valid MAC address by
other means.

Since the MAC address can be modified, then add a random valid MAC address
to replace the invalid MAC address in the driver can be workable, it can
continue to finish the loading, and output the relevant log reminder.

Signed-off-by: lixue liang <lianglixue@greatwall.com.cn>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 746233befade..40f43534a3af 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3362,7 +3362,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		eth_hw_addr_random(netdev);
 		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
 		dev_err(&pdev->dev,
-			"Invalid MAC Address, already assigned random MAC Address\n");
+			"Invalid MAC address, already assigned random MAC address\n");
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

