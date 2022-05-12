Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78FD52493F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352165AbiELJja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241594AbiELJja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:39:30 -0400
Received: from spamsz.greatwall.com.cn (spamfw.greatwall.com.cn [111.48.58.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF97BA9A3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:39:26 -0700 (PDT)
X-ASG-Debug-ID: 1652348362-0ec57242fe0af90001-BZBGGp
Received: from greatwall.com.cn (mailsz.greatwall.com.cn [10.46.20.97]) by spamsz.greatwall.com.cn with ESMTP id unDnuY66kCCtFvAq for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:39:22 +0800 (CST)
X-Barracuda-Envelope-From: lianglixue@greatwall.com.cn
X-Barracuda-RBL-Trusted-Forwarder: 10.46.20.97
Received: from localhost.localdomain (unknown [223.104.68.49])
        by mailsz.greatwall.com.cn (Coremail) with SMTP id YRQuCgBnyHA21HxisIcUAA--.11038S2;
        Thu, 12 May 2022 17:32:39 +0800 (CST)
From:   lixue liang <lianglixue@greatwall.com.cn>
X-Barracuda-RBL-IP: 223.104.68.49
X-Barracuda-Effective-Source-IP: UNKNOWN[223.104.68.49]
X-Barracuda-Apparent-Source-IP: 223.104.68.49
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Cc:     lixue liang <lianglixue@greatwall.com.cn>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 2/2] igb_main: Assign random MAC address instead of fail in case of invalid one
Date:   Thu, 12 May 2022 09:39:18 +0000
X-ASG-Orig-Subj: [PATCH v2 2/2] igb_main: Assign random MAC address instead of fail in case of invalid one
Message-Id: <20220512093918.86084-1-lianglixue@greatwall.com.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: YRQuCgBnyHA21HxisIcUAA--.11038S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1rtry3JF4rKw1xCr45KFg_yoW8Wr1Upa
        95Xa4SgrykZr4UX3ykJa18Zas0kayYqas8G3sIyw1F9Fn0vrZ8Ar1UKry7JryrJrZ5uFsI
        qr47ZFWDua1DCFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUym14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
        14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: xold0w5ol03v46juvthwzdzzoofrzhdfq/
X-Barracuda-Connect: mailsz.greatwall.com.cn[10.46.20.97]
X-Barracuda-Start-Time: 1652348362
X-Barracuda-URL: https://spamfw.greatwall.com.cn:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at greatwall.com.cn
X-Barracuda-Scan-Msg-Size: 1536
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4221 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.97952
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
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

Since the MAC address can be modified ,then add a random valid MAC address
to replace the invalid MAC address in the driver can be workable, it can
continue to finish the loading ,and output the relevant log reminder.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: lixue liang <lianglixue@greatwall.com.cn>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a513570c2ad6..746233befade 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3359,10 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		eth_random_addr(netdev->dev_addr);
-		memcpy(hw->mac.addr, netdev->dev_addr, netdev->addr_len);
-		dev_info(&pdev->dev,
-			 "Invalid Mac Address, already got random Mac Address\n");
+		eth_hw_addr_random(netdev);
+		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
+		dev_err(&pdev->dev,
+			"Invalid MAC Address, already assigned random MAC Address\n");
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

