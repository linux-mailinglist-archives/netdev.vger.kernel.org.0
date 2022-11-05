Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59A561DDE0
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 20:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiKETtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 15:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKETtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 15:49:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE6910571;
        Sat,  5 Nov 2022 12:49:48 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id y14so21065793ejd.9;
        Sat, 05 Nov 2022 12:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XNGGWZ6zU750lS4mF7crv8Fbn/LeLMY1NyuuVpO6zPs=;
        b=Mh8FZiBPjmFaDt7ZQlPySqFcz/LaxiIfgNYqwSCg2uSzNCiedQL/UTmXUyJSf5WcVd
         hOE+gJ3rQtKn7FzK4lWyviGpKV4yQtUKwZ+2EJRBfZxrTCdk8NbkKughVGPfDKBHzdoJ
         Ni5J+cNbeEL6Oz+w+VbghkhnN61a9HaV6Qa85wzfG1/HKaUbmjYZkJzzi278/2NDotjl
         5fhoiFh2UDDIz+/TUOVkq8qLMDQ0vzoS67KEBuDDPG6urdOfeiPv2kYYVodhGcnqtVrr
         yjpEFKcSPGEy6h3NIpYSkb4sjKsEOGY8O8s7YPv0ARWyvkSii9EF1m7D9em+YzPwcMid
         PKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNGGWZ6zU750lS4mF7crv8Fbn/LeLMY1NyuuVpO6zPs=;
        b=77exhTKFCQDPplRNXB2O+aArKNqaX7MYizhN0NhjXTmM2lkZvjmkkge6JjIHrm9o0o
         MQzuKLl0EZVdU9stoGsWcHS7/6cx4QpaQbafNFCw0UQTzKMZOu/qcKOfjTaHsvj9RTnX
         nEac8LpNJ3H5p81CGHOqZ1irfgdAh5g/YcF95qmWk517WjA7t5KxaNC3f1VW1mYpL1nL
         PVk0aIO+/Bi5LCcMgcaua/mGokMWKHPC+XYZvJKaq8HuogLGI1RMIlVLGMlmsz4/54Fd
         aRiX+ROYnM6WHNoBDV8ixKTofHUZAsDEfjpceN+I2cAacKFBkxqnlry0bHv0nhnymv9n
         OCIw==
X-Gm-Message-State: ACrzQf0dD6zCllyKF4N8HBh8WufFvUBCYNJ566afATQQXWtcjraG4N3N
        +qt6ekZC/jlA/STos5d04Ac=
X-Google-Smtp-Source: AMsMyM4PMnBmGhge8boYpR+/vT7VI0pVYOR28ruySN7vCrXt/Z6nw4oy9Hj6y6GGngNX0EON3MI3Ug==
X-Received: by 2002:a17:906:847c:b0:7ad:d6c8:35d7 with SMTP id hx28-20020a170906847c00b007add6c835d7mr30749561ejc.170.1667677787252;
        Sat, 05 Nov 2022 12:49:47 -0700 (PDT)
Received: from fedora.. (dh207-96-23.xnet.hr. [88.207.96.23])
        by smtp.googlemail.com with ESMTPSA id et19-20020a170907295300b0079b9f7509a0sm1289409ejc.52.2022.11.05.12.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 12:49:46 -0700 (PDT)
From:   Robert Marko <robimarko@gmail.com>
To:     mani@kernel.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ansuelsmth@gmail.com, Robert Marko <robimarko@gmail.com>
Subject: [PATCH 1/2] bus: mhi: core: add SBL state callback
Date:   Sat,  5 Nov 2022 20:49:42 +0100
Message-Id: <20221105194943.826847-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SBL state callback in MHI core.

It is required for ath11k MHI devices in order to be able to set QRTR
instance ID in the SBL state so that QRTR instance ID-s dont conflict in
case of multiple PCI/MHI cards or AHB + PCI/MHI card.
Setting QRTR instance ID is only possible in SBL state and there is
currently no way to ensure that we are in that state, so provide a
callback that the controller can trigger off.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 drivers/bus/mhi/host/main.c | 1 +
 include/linux/mhi.h         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
index df0fbfee7b78..8b03dd1f0cb8 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -900,6 +900,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
 			switch (event) {
 			case MHI_EE_SBL:
 				st = DEV_ST_TRANSITION_SBL;
+				mhi_cntrl->status_cb(mhi_cntrl, MHI_CB_EE_SBL_MODE);
 				break;
 			case MHI_EE_WFW:
 			case MHI_EE_AMSS:
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index a5441ad33c74..beffe102dd19 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -34,6 +34,7 @@ struct mhi_buf_info;
  * @MHI_CB_SYS_ERROR: MHI device entered error state (may recover)
  * @MHI_CB_FATAL_ERROR: MHI device entered fatal error state
  * @MHI_CB_BW_REQ: Received a bandwidth switch request from device
+ * @MHI_CB_EE_SBL_MODE: MHI device entered SBL mode
  */
 enum mhi_callback {
 	MHI_CB_IDLE,
@@ -45,6 +46,7 @@ enum mhi_callback {
 	MHI_CB_SYS_ERROR,
 	MHI_CB_FATAL_ERROR,
 	MHI_CB_BW_REQ,
+	MHI_CB_EE_SBL_MODE,
 };
 
 /**
-- 
2.38.1

