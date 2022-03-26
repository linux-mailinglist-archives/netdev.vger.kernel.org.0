Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213F04E8312
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiCZRWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiCZRWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:22:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEC8949247
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 10:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648315215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0gPCasSItm4Ex2ZMUQbF4T4OAP0GG+ryCRQM09Api5o=;
        b=glkaJGPiWzyjR+c5dYxaf7j5OHemLfbkYVXTbD0Kp8Tv1YLjKa3fKRY3WnCwdq0ah66Fkr
        nnYa5VX1q58sBKYXo7gGxiFnUZyMoanFxNqB9Z4VT7QcegSOUWmLG/3XjWqDoLjJkGjo9s
        4+VWf5NgjYoJevR+6xDs9bKH9oUkN8Y=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-6f1EE1BcPPWN7pxvJJYRew-1; Sat, 26 Mar 2022 13:20:13 -0400
X-MC-Unique: 6f1EE1BcPPWN7pxvJJYRew-1
Received: by mail-qt1-f200.google.com with SMTP id f7-20020a05622a1a0700b002e06d6279d5so3615068qtb.7
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 10:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gPCasSItm4Ex2ZMUQbF4T4OAP0GG+ryCRQM09Api5o=;
        b=SJuAqpMavS0xijgAbvJhI19MIdJ+kQcnUaMDiWdbzWnuxqcDahJ84ptoXOjpjU4wSr
         aaR5D9rkU7u4Kcxo6CQ22yjRXIa8mmHamvunHPCUVWFbDO647apUn5oxK404fpnuPznJ
         FftK28/Bf1kaY3ckEcMtEMUBWxd8AYagloL2rUpt6NhFwERwBqaPwQzmBp+jDi7yh2jH
         BWCB1Wsahsbgv12PEGyJlBHQEkSX9nlDoaH0yZbqb6AJ7MGQ449bEGLzG8sxy3VoH/7T
         9aS6BTTrHVugQ02gfSYkLRepW+t2VCxBPa5g3NvUtj2CZcsnNHv5DwGWNzl1zBPwwHWZ
         j6rw==
X-Gm-Message-State: AOAM531q2oeLr39N1a9ARJBuzA6FFrDKQ0USxQWL+7l0mYk05S54zmxU
        2k+AYtvbcQzPjloU2Ovbx6qM6MlcfMb5qVmfTT10k31pBGllXry4s979fZB2F3oI3TeYGNXtFAy
        MHJOJjSU0Rw23r+Gx
X-Received: by 2002:a05:620a:4047:b0:67d:6729:b241 with SMTP id i7-20020a05620a404700b0067d6729b241mr10750090qko.151.1648315213272;
        Sat, 26 Mar 2022 10:20:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7zW54pmYavrU4oBp5rsLnr4D2xBrbgGeijtC31l8eEaKfEuQDANgOphYIqyt4r41K+AKekA==
X-Received: by 2002:a05:620a:4047:b0:67d:6729:b241 with SMTP id i7-20020a05620a404700b0067d6729b241mr10750077qko.151.1648315213068;
        Sat, 26 Mar 2022 10:20:13 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id t13-20020a05622a148d00b002e22f105099sm8462282qtx.21.2022.03.26.10.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 10:20:12 -0700 (PDT)
From:   trix@redhat.com
To:     shshaikh@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, sucheta.chakraborty@qlogic.com
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] qlcnic: dcb: default to returning -EOPNOTSUPP
Date:   Sat, 26 Mar 2022 10:20:03 -0700
Message-Id: <20220326172003.2906474-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issue
qlcnic_dcb.c:382:10: warning: Assigned value is
  garbage or undefined
  mbx_out = *val;
          ^ ~~~~

val is set in the qlcnic_dcb_query_hw_capability() wrapper.
If there is no query_hw_capability op in dcp, success is
returned without setting the val.

For this and similar wrappers, return -EOPNOTSUPP.

Fixes: 14d385b99059 ("qlcnic: dcb: Query adapter DCB capabilities.")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index 5d79ee4370bcd..7519773eaca6e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -51,7 +51,7 @@ static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_hw_capability)
 		return dcb->ops->get_hw_capability(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_free(struct qlcnic_dcb *dcb)
@@ -65,7 +65,7 @@ static inline int qlcnic_dcb_attach(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->attach)
 		return dcb->ops->attach(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int
@@ -74,7 +74,7 @@ qlcnic_dcb_query_hw_capability(struct qlcnic_dcb *dcb, char *buf)
 	if (dcb && dcb->ops->query_hw_capability)
 		return dcb->ops->query_hw_capability(dcb, buf);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_get_info(struct qlcnic_dcb *dcb)
@@ -89,7 +89,7 @@ qlcnic_dcb_query_cee_param(struct qlcnic_dcb *dcb, char *buf, u8 type)
 	if (dcb && dcb->ops->query_cee_param)
 		return dcb->ops->query_cee_param(dcb, buf, type);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
@@ -97,7 +97,7 @@ static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_cee_cfg)
 		return dcb->ops->get_cee_cfg(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_aen_handler(struct qlcnic_dcb *dcb, void *msg)
-- 
2.26.3

