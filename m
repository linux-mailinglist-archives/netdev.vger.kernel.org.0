Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC529410EBE
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhITDMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbhITDM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:12:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCB9C0617AD;
        Sun, 19 Sep 2021 20:10:08 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j14so2972956plx.4;
        Sun, 19 Sep 2021 20:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A0xq/rLxDex9b8Ex71OL3CndFUoZBhsozJlG/ecmG+U=;
        b=bEaP/Bty1T5b11swdf7NIsbeXYscNiwie9ZRgawYGkP2bJe3cLEhBe0cyxp4GPj0GD
         tRmkZxPdD9VnXqzlGIs44r8fdMCCUBGnX4UYZgIlSQTkfR/mcnUDSBJY4jtP0vw0Oq/C
         Y3OTam3Atd0LZ1kHAUPyG7w0//Vee63V124ElhtQeV9G2Fr8aiW6HdxM2VQVkGEkjndD
         M9ZCeMpWPfogtnuWSTVW+H+YDgs4JqmcJvswJgSFzY2UH4UG8SSmXek3zVXl9xmXRG0k
         kAzp435nh0LhqGro89L8+65FxocVWWRDmJPJIXvTZv29TvoMmydRxE3teogtrx6BE4Pq
         aktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A0xq/rLxDex9b8Ex71OL3CndFUoZBhsozJlG/ecmG+U=;
        b=q+3HzMGVdkPir4unf10LDx7ltxXP7A6sRv+ikdzwgvGAtQXK2WHCseSSkp6MfnnWkf
         KQ+AoW672wVHvgo9DdTW5vCzlqCIjfSBN+IpWma//pIdCm3DABrF90RAPSX1JaNtZ+1Y
         7vDxDWVSLbAB7z9ax4m0BVN2WLHjQXZIZCBsdTOCUN4MicwJnOVSGJfeB2+UDB7NYL/U
         DrbLl8MY2nplbPvg3s/DX8T0e0F7c7us+83J153dnyzEykA086LBbUb8R1XIKMr/lsnY
         1j0Hzx8T3qexDTDBEDaLIye+QnMmqnUPxZULeUgpah3zn3Gm1YRax7e4kqJzjXMXDygU
         sNfw==
X-Gm-Message-State: AOAM5332vTt/gqA6n1t7QGLTU5VZto8e7pX03c9as7s1UOF72Iwiazpp
        rsteVZ87Jd8wvk0uipzW81AZTMnksj/MJA9b
X-Google-Smtp-Source: ABdhPJyCkqD8rMV7e2k2keBSezz9ogKpyjG+e0uThkJeZmQ8zZeIbQOJz2WfGIGxNLZiOvIbA84AeQ==
X-Received: by 2002:a17:902:930c:b029:12c:d5c8:61c4 with SMTP id bc12-20020a170902930cb029012cd5c861c4mr20754678plb.73.1632107408204;
        Sun, 19 Sep 2021 20:10:08 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:10:07 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 15/17] net: ipa: Add IPA v2.6L initialization sequence support
Date:   Mon, 20 Sep 2021 08:38:09 +0530
Message-Id: <20210920030811.57273-16-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The biggest changes are:

- Make SMP2P functions no-operation
- Make resource init no-operation
- Skip firmware loading
- Add reset sequence

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_main.c     | 19 ++++++++++++++++---
 drivers/net/ipa/ipa_resource.c |  3 +++
 drivers/net/ipa/ipa_smp2p.c    | 11 +++++++++--
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index ea6c4347f2c6..b437fbf95edf 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -355,12 +355,22 @@ static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
 	u32 granularity;
 	u32 val;
 
+	if (ipa->version <= IPA_VERSION_2_6L) {
+		iowrite32(1, ipa->reg_virt + IPA_REG_COMP_SW_RESET_OFFSET);
+		iowrite32(0, ipa->reg_virt + IPA_REG_COMP_SW_RESET_OFFSET);
+
+		iowrite32(1, ipa->reg_virt + ipa_reg_comp_cfg_offset(ipa->version));
+	}
+
 	/* IPA v4.5+ has no backward compatibility register */
-	if (version < IPA_VERSION_4_5) {
+	if (version >= IPA_VERSION_2_5 && version < IPA_VERSION_4_5) {
 		val = data->backward_compat;
 		iowrite32(val, ipa->reg_virt + ipa_reg_bcr_offset(ipa->version));
 	}
 
+	if (ipa->version <= IPA_VERSION_2_6L)
+		return;
+
 	/* Implement some hardware workarounds */
 	if (version >= IPA_VERSION_4_0 && version < IPA_VERSION_4_5) {
 		/* Disable PA mask to allow HOLB drop */
@@ -412,7 +422,8 @@ static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
 static void ipa_hardware_deconfig(struct ipa *ipa)
 {
 	/* Mostly we just leave things as we set them. */
-	ipa_hardware_dcd_deconfig(ipa);
+	if (ipa->version > IPA_VERSION_2_6L)
+		ipa_hardware_dcd_deconfig(ipa);
 }
 
 /**
@@ -765,8 +776,10 @@ static int ipa_probe(struct platform_device *pdev)
 
 	/* Otherwise we need to load the firmware and have Trust Zone validate
 	 * and install it.  If that succeeds we can proceed with setup.
+	 * But on IPA v2.6L we don't need to do firmware loading :D
 	 */
-	ret = ipa_firmware_load(dev);
+	if (ipa->version > IPA_VERSION_2_6L)
+		ret = ipa_firmware_load(dev);
 	if (ret)
 		goto err_deconfig;
 
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index e3da95d69409..36a72324d828 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -162,6 +162,9 @@ int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 {
 	u32 i;
 
+	if (ipa->version <= IPA_VERSION_2_6L)
+		return 0;
+
 	if (!ipa_resource_limits_valid(ipa, data))
 		return -EINVAL;
 
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index df7639c39d71..fa4a9f1c196a 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -233,6 +233,10 @@ int ipa_smp2p_init(struct ipa *ipa, bool modem_init)
 	u32 valid_bit;
 	int ret;
 
+	/* With IPA v2.6L and earlier SMP2P interrupts are used */
+	if (ipa->version <= IPA_VERSION_2_6L)
+		return 0;
+
 	valid_state = qcom_smem_state_get(dev, "ipa-clock-enabled-valid",
 					  &valid_bit);
 	if (IS_ERR(valid_state))
@@ -302,6 +306,9 @@ void ipa_smp2p_exit(struct ipa *ipa)
 {
 	struct ipa_smp2p *smp2p = ipa->smp2p;
 
+	if (!smp2p)
+		return;
+
 	if (smp2p->setup_ready_irq)
 		ipa_smp2p_irq_exit(smp2p, smp2p->setup_ready_irq);
 	ipa_smp2p_panic_notifier_unregister(smp2p);
@@ -317,7 +324,7 @@ void ipa_smp2p_disable(struct ipa *ipa)
 {
 	struct ipa_smp2p *smp2p = ipa->smp2p;
 
-	if (!smp2p->setup_ready_irq)
+	if (!smp2p || !smp2p->setup_ready_irq)
 		return;
 
 	mutex_lock(&smp2p->mutex);
@@ -333,7 +340,7 @@ void ipa_smp2p_notify_reset(struct ipa *ipa)
 	struct ipa_smp2p *smp2p = ipa->smp2p;
 	u32 mask;
 
-	if (!smp2p->notified)
+	if (!smp2p || !smp2p->notified)
 		return;
 
 	ipa_smp2p_power_release(ipa);
-- 
2.33.0

