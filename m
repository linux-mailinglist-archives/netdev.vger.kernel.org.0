Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF58566DB07
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbjAQK1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbjAQK1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:27:34 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F8A279A9;
        Tue, 17 Jan 2023 02:27:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y1so33075418plb.2;
        Tue, 17 Jan 2023 02:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kmOnku77wCpJTbZOm6646yTM8PiOjj7loFTP8/nFzXY=;
        b=JaR9n1yIXU8Xys+G0tkz6C7PSqR9i0vQP6wK/Qb4e6Bby8BKdUMQFaniTYM+6DXD+U
         +meRrjihC59W7zV8CV2T60XZGmhVcOAIlX207PcQhlxwyLB71sqSqq7CoW1TfxQ+WklD
         vpeSGibDIK4/k5TDmZI0uIYTOfuPWayTKOlWMTVSmngoQjlM3Bxl3VyQFCadUor8azxp
         pR8R1EQFXa/ArWCTgLm1ONwDPwjRoksC1bUCQTYvKRyozLphC/P7n0fMbldW40qLqj1b
         Ds5Dazv2fMlTFQ43RwOt06CBvQXRVFzItzBXT7rfmJIVN6MUHnJqY8vlL90U+dQgrybX
         3qiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kmOnku77wCpJTbZOm6646yTM8PiOjj7loFTP8/nFzXY=;
        b=SKyz9FJLTv4KKEoy3if6/1RIvR0FbtBbvn7xIg9kmgZXTyEcNntOK9TH7f+hfgmVrU
         5w7DSWbV4K4oy4gsnmzRkRyEi8LmPlACcZOkB2oldqn76gwwj8r8hqROvh+uy9cso+3v
         1kMZ4CpvNWqF/9OtMnX94J0yFzZwPya9rWQfLvT6KMYt88m9je/IdarG21eYR5mUVrb6
         zwB+X2WsCmKL5d32RjiZ/Ccuw42lIab8l6CI55xVXfsPmWOy6MdikJT9sQlK6OZmrPm4
         WfOx5fuAXInzXAs2rXSuiH0sQTvJdtqIQgvuPzzvWsyX30P/pAPVWMZYbwGaJfENg8td
         8HLA==
X-Gm-Message-State: AFqh2koASa66D+KJzFWZshvfn/k2R3VU9Khsm/jp4tRqAA4V2eRn+HMF
        kGXbXfcpxKvuLqUDYdqBpkE=
X-Google-Smtp-Source: AMrXdXvLAqhc4oGk1i82O5NAA03rkDUCOFcyZ1urDuBJ7SYLHLU0Pr+NOGlOoGVyVwxRluvgf7o48w==
X-Received: by 2002:a17:902:7106:b0:194:66db:7789 with SMTP id a6-20020a170902710600b0019466db7789mr18287556pll.50.1673951253720;
        Tue, 17 Jan 2023 02:27:33 -0800 (PST)
Received: from li540-143.members.linode.com ([2600:3c01::f03c:92ff:fe6e:f0f6])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902eb8b00b00189c93ce5easm20796153plg.166.2023.01.17.02.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:27:33 -0800 (PST)
From:   Jiajia Liu <liujia6264@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiajia Liu <liujia6264@gmail.com>
Subject: [PATCH] e1000e: Add ADP_I219_LM17 to ME S0ix blacklist
Date:   Tue, 17 Jan 2023 10:26:46 +0000
Message-Id: <20230117102645.24920-1-liujia6264@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I219 on HP EliteOne 840 All in One cannot work after s2idle resume
when the link speed is Gigabit, Wake-on-LAN is enabled and then set
the link down before suspend. No issue found when requesting driver
to configure S0ix. Add workround to let ADP_I219_LM17 use the dirver
configured S0ix.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216926
Signed-off-by: Jiajia Liu <liujia6264@gmail.com>
---

It's regarding the bug above, it looks it's causued by the ME S0ix.
And is there a method to make the ME S0ix path work?

 drivers/net/ethernet/intel/e1000e/netdev.c | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 04acd1a992fa..7ee759dbd09d 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6330,6 +6330,23 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 	pm_runtime_put_sync(netdev->dev.parent);
 }
 
+static u16 me_s0ix_blacklist[] = {
+	E1000_DEV_ID_PCH_ADP_I219_LM17,
+	0
+};
+
+static bool e1000e_check_me_s0ix_blacklist(const struct e1000_adapter *adapter)
+{
+	u16 *list;
+
+	for (list = me_s0ix_blacklist; *list; list++) {
+		if (*list == adapter->pdev->device)
+			return true;
+	}
+
+	return false;
+}
+
 /* S0ix implementation */
 static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 {
@@ -6337,6 +6354,9 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
+	if (e1000e_check_me_s0ix_blacklist(adapter))
+		goto req_driver;
+
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
 	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME configure the device for S0ix */
@@ -6346,6 +6366,7 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 		trace_e1000e_trace_mac_register(mac_data);
 		ew32(H2ME, mac_data);
 	} else {
+req_driver:
 		/* Request driver configure the device to S0ix */
 		/* Disable the periodic inband message,
 		 * don't request PCIe clock in K1 page770_17[10:9] = 10b
@@ -6488,6 +6509,9 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	u16 phy_data;
 	u32 i = 0;
 
+	if (e1000e_check_me_s0ix_blacklist(adapter))
+		goto req_driver;
+
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
 	    hw->mac.type >= e1000_pch_adp) {
 		/* Keep the GPT clock enabled for CSME */
@@ -6523,6 +6547,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 		else
 			e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
 	} else {
+req_driver:
 		/* Request driver unconfigure the device from S0ix */
 
 		/* Disable the Dynamic Power Gating in the MAC */
-- 
2.30.2

