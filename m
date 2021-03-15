Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831DB33BF9C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhCOPVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhCOPVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:21:18 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70E4C061764
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:21:17 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e7so9682192ile.7
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cdjWAvcEPqqoxOkQ5Yghff2TWeEJIKckZ0LUeD8YodY=;
        b=SurpKAYomkVRJ20/mN9GqMSiw+B44DXbzIUGWYPcvOsSjgA3N6qN2NTJfO7MaQ7MoB
         +LGP71XKF2EZOTuEHOj1pxxnEj+t2lxhjBeB3vDPHVyAFh3QAxSBn0aRHhCSkwhze/j5
         TcQuKoJxBnCF3+KOAu5gca7qRnktHtxShGD4OqdLYvwyDDakO6A8d7agAvszOg6VgbQ8
         wHoEYZMrQH7pTk/NlsPX9OX0eUtEsfxPXp7J+OwJYZZSkszYD09seU++nTwR87krEUFb
         LTmvSYgMHSFVEC2wM/e3R0hjP85rbUY6NafS/IybZ/ivfCt1MLvcDaQAkzXus1QyURNF
         Taow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cdjWAvcEPqqoxOkQ5Yghff2TWeEJIKckZ0LUeD8YodY=;
        b=H5D9SYkH0Qgu/x77EfEtvCbdIbKVVyf+gOmse4kMTd2Ji6IieZ2fT+Sfs/dw3FACGn
         ojCLm7CZwBjz2i6kD8WWKUIng8SLNi3FbPS6tGu9URCYqYoSFl8jM/72eeoVaeWoaav6
         TS2MlFCEJ6N7nxR/jJ/uDWl9LKAke5pI1p+OhvepsHupWWg/Gd5jhDDB/bfvtRKqD1jF
         +dbVC1eBV2TiRodFCDIGT9TyhrVkFMx9FsmueJSx7T3Bzq+kevAPkSgiEqyYJDU6xjjt
         QBMtVrXDNuVAJWQISVJO1L4ivRaupY8GAKL8h0DBL93/PI67D16ji2awsBSZ8otCkRAT
         0ZkA==
X-Gm-Message-State: AOAM530Wzya71L1162AszeRB3CWAU0MIWkhcy6+tBCYGJldpk4R+GFOI
        7wqcKbZvscrugdra4rE+Kik0MQ==
X-Google-Smtp-Source: ABdhPJx7sJ08iAydS2SYzucwjoDNvZZ97Wm0cI9av1bcHr0TvEVoJj4zzFgSwYCEpeRsSKWF06MfxA==
X-Received: by 2002:a05:6e02:13cb:: with SMTP id v11mr72539ilj.105.1615821677254;
        Mon, 15 Mar 2021 08:21:17 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l17sm8194275ilt.27.2021.03.15.08.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:21:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     manivannan.sadhasivam@linaro.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ipa: fix another QMI message definition
Date:   Mon, 15 Mar 2021 10:21:11 -0500
Message-Id: <20210315152112.1907968-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315152112.1907968-1-elder@linaro.org>
References: <20210315152112.1907968-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ipa_init_modem_driver_req_ei[] encoding array for the
INIT_MODEM_DRIVER request message has some errors in it.

First, the tlv_type associated with the hw_stats_quota_size field is
wrong; it duplicates the valiue used for the hw_stats_quota_base_addr
field (0x1f) and should use 0x20 instead.  The tlv_type value for
the hw_stats_drop_size field also uses the same duplicate value; it
should use 0x22 instead.

Second, there is no definition for the hw_stats_drop_base_addr
field.  It is an optional 32-bit enumerated type value.

Finally, the hw_stats_quota_base_addr, hw_stats_quota_size, and
hw_stats_drop_size fields are defined as enumerated types; they
should be unsigned 4-byte values.

Reported-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_qmi_msg.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index e00f829a783f6..e4a6efbe9bd00 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -530,7 +530,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 					   hw_stats_quota_base_addr_valid),
 	},
 	{
-		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
 		.elem_size	=
 			sizeof_field(struct ipa_init_modem_driver_req,
@@ -545,37 +545,57 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.elem_size	=
 			sizeof_field(struct ipa_init_modem_driver_req,
 				     hw_stats_quota_size_valid),
-		.tlv_type	= 0x1f,
+		.tlv_type	= 0x20,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   hw_stats_quota_size_valid),
 	},
 	{
-		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
 		.elem_size	=
 			sizeof_field(struct ipa_init_modem_driver_req,
 				     hw_stats_quota_size),
-		.tlv_type	= 0x1f,
+		.tlv_type	= 0x20,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   hw_stats_quota_size),
 	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_drop_base_addr_valid),
+		.tlv_type	= 0x21,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_drop_base_addr_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_drop_base_addr),
+		.tlv_type	= 0x21,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_drop_base_addr),
+	},
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
 		.elem_size	=
 			sizeof_field(struct ipa_init_modem_driver_req,
 				     hw_stats_drop_size_valid),
-		.tlv_type	= 0x1f,
+		.tlv_type	= 0x22,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   hw_stats_drop_size_valid),
 	},
 	{
-		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
 		.elem_size	=
 			sizeof_field(struct ipa_init_modem_driver_req,
 				     hw_stats_drop_size),
-		.tlv_type	= 0x1f,
+		.tlv_type	= 0x22,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   hw_stats_drop_size),
 	},
-- 
2.27.0

