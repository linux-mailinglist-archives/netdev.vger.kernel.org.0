Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AB257A798
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbiGSTzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiGSTzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:55:48 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B40454AF1;
        Tue, 19 Jul 2022 12:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hvFngS+SbTqGKT0e1yD1Flbk7O+3mk0+bQWnmDbivHg=; b=M7NtTBbllawpOvTPCtUXyQYrO3
        ALhnZaAkIF7GELFRa+HHmcpunYKDBRXEarjjsjqgbaYk5qxIvZxn4RJ7595HAkdjHbv359ZL37BFb
        NhwIsMNhkqm59nWgarDJPIl5SoZA3vvxo1F3NQE6HTjudo4mf1NcQCpWFFopt5+kOCctQs1gGkSzo
        vhH9WYJF1N/oQeLYAOL/w1rEbKcuPSgkuZgtTqMrTNVaBQjMMKrvARQ1M2RvZLOIC6rIO5dDF7KiS
        C3EL0HOtOX6zk5OWjhAfny3yrw7xSrb4hmzoOKuurM/2LLYaD037g0y0hXZ3Fok5yhYKfJ2MZdsIn
        sbn4nutw==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oDtJi-006fNi-SW; Tue, 19 Jul 2022 21:55:39 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Brian Norris <computersforpeace@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 04/13] soc: bcm: brcmstb: Document panic notifier action and remove useless header
Date:   Tue, 19 Jul 2022 16:53:17 -0300
Message-Id: <20220719195325.402745-5-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719195325.402745-1-gpiccoli@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The panic notifier of this driver is very simple code-wise, just a
memory write to a special position with some numeric code. But this
is not clear from the semantic point-of-view, and there is no public
documentation about that either.

After discussing this in the mailing-lists [0] and having Florian
explained it very well, document that in the code for the future
generations asking the same questions. Also, while at it, remove
a useless header.

[0] https://lore.kernel.org/lkml/781cafb0-8d06-8b56-907a-5175c2da196a@gmail.com

Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Justin Chen <justinpopo6@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Markus Mayer <mmayer@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V2:
- Removed the Fixes tag;
- Added Florian's ACK - thanks!

 drivers/soc/bcm/brcmstb/pm/pm-arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index 70ad0f3dce28..2a6adaa29596 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/memblock.h>
 #include <linux/module.h>
-#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/panic_notifier.h>
@@ -664,7 +663,20 @@ static void __iomem *brcmstb_ioremap_match(const struct of_device_id *matches,
 
 	return of_io_request_and_map(dn, index, dn->full_name);
 }
-
+/*
+ * The AON is a small domain in the SoC that can retain its state across
+ * various system wide sleep states and specific reset conditions; the
+ * AON DATA RAM is a small RAM of a few words (< 1KB) which can store
+ * persistent information across such events.
+ *
+ * The purpose of the below panic notifier is to help with notifying
+ * the bootloader that a panic occurred and so that it should try its
+ * best to preserve the DRAM contents holding that buffer for recovery
+ * by the kernel as opposed to wiping out DRAM clean again.
+ *
+ * Reference: comment from Florian Fainelli, at
+ * https://lore.kernel.org/lkml/781cafb0-8d06-8b56-907a-5175c2da196a@gmail.com
+ */
 static int brcmstb_pm_panic_notify(struct notifier_block *nb,
 		unsigned long action, void *data)
 {
-- 
2.37.1

