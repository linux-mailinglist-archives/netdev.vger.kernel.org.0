Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331D5522E54
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbiEKI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiEKI1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:27:08 -0400
X-Greylist: delayed 1152 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 May 2022 01:26:59 PDT
Received: from spamcs.greatwall.com.cn (mail.greatwall.com.cn [111.48.58.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D90094EDD6
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:26:57 -0700 (PDT)
X-ASG-Debug-ID: 1652257081-0ec56f2003045e0001-BZBGGp
Received: from greatwall.com.cn (mailcs.greatwall.com.cn [10.47.36.11]) by spamcs.greatwall.com.cn with ESMTP id BiE01qbOVzdxXvL8 for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:18:01 +0800 (CST)
X-Barracuda-Envelope-From: lianglixue@greatwall.com.cn
X-Barracuda-RBL-Trusted-Forwarder: 10.47.36.11
Received: from localhost.localdomain (unknown [223.104.68.106])
        by mailcs.greatwall.com.cn (Coremail) with SMTP id CyQvCgCHBu4fbXtiymIrAA--.44629S2;
        Wed, 11 May 2022 16:00:33 +0800 (CST)
From:   lixue liang <lianglixue@greatwall.com.cn>
X-Barracuda-RBL-IP: 223.104.68.106
X-Barracuda-Effective-Source-IP: UNKNOWN[223.104.68.106]
X-Barracuda-Apparent-Source-IP: 223.104.68.106
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Cc:     lixue liang <lianglixue@greatwall.com.cn>
Subject: [PATCH] =?UTF-8?q?igb=5Fmain=EF=BC=9AAdded=20invalid=20mac=20addr?= =?UTF-8?q?ess=20handling=20in=20igb=5Fprobe?=
Date:   Wed, 11 May 2022 08:07:16 +0000
X-ASG-Orig-Subj: [PATCH] =?UTF-8?q?igb=5Fmain=EF=BC=9AAdded=20invalid=20mac=20addr?= =?UTF-8?q?ess=20handling=20in=20igb=5Fprobe?=
Message-Id: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: CyQvCgCHBu4fbXtiymIrAA--.44629S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr47Gw1rAr1ktw4rGrW5trb_yoW8WF13pa
        98ZFW3KrykXr48X3ykJw48Za4Fkayjqa98Gr9xAw1F93W3Zrs8Ar48Kry7GrWrJrZ5uanI
        yr45ZF4DuFn0yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
        wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbWCJPUUUUU==
X-CM-SenderInfo: xold0w5ol03v46juvthwzdzzoofrzhdfq/
X-Barracuda-Connect: mailcs.greatwall.com.cn[10.47.36.11]
X-Barracuda-Start-Time: 1652257081
X-Barracuda-URL: https://10.47.36.10:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at greatwall.com.cn
X-Barracuda-Scan-Msg-Size: 1614
X-Barracuda-Bayes: INNOCENT GLOBAL 0.1899 1.0000 -0.8812
X-Barracuda-Spam-Score: -0.88
X-Barracuda-Spam-Status: No, SCORE=-0.88 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.97927
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

In some cases, when the user uses igb_set_eeprom to modify
the mac address to be invalid, the igb driver will fail to load.
If there is no network card device, the user must modify it to
a valid mac address by other means. It is only the invalid
mac address that causes the driver The fatal problem of
loading failure will cause most users no choice but to trouble.

Since the mac address may be changed to be invalid, it must
also be changed to a valid mac address, then add a random
valid mac address to replace the invalid mac address in the
driver, continue to load the igb network card driver,
and output the relevant log reminder. vital to the user.

Signed-off-by: lixue liang <lianglixue@greatwall.com.cn>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..a513570c2ad6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		dev_err(&pdev->dev, "Invalid MAC Address\n");
-		err = -EIO;
-		goto err_eeprom;
+		eth_random_addr(netdev->dev_addr);
+		memcpy(hw->mac.addr, netdev->dev_addr, netdev->addr_len);
+		dev_info(&pdev->dev,
+			 "Invalid Mac Address, already got random Mac Address\n");
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

