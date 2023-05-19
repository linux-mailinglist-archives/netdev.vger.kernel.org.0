Return-Path: <netdev+bounces-3774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0785708CD8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 396E21C211B7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 00:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A381E18F;
	Fri, 19 May 2023 00:25:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF37C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 00:25:49 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDB810FC;
	Thu, 18 May 2023 17:25:32 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d18d772bdso1569052b3a.3;
        Thu, 18 May 2023 17:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684455931; x=1687047931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X7LSztTgvuTG/1LRG7rLGwi1XpsK273SzAIspcW50Sw=;
        b=r5g0rd74gzmwM9IK6Pm4C1P66N8ea4c0hLbvF8+Kw11dnEnGuJjnrsUvV8iXMI1m4E
         yzkwWbNbBo7IWy7BNZYjdx28A23ZWhbyX1yQPACdK/rfjOxPV+KCiDE1++Lwdf2RPbix
         P75kxZMOEMr0FsCLspJcxMhIV56lHHfs/pBvBudhO9rzIEsHG0/AMjCAaQaeGLWGmNEL
         eNe9RQd0lLpHTyDB0XqYRf2Y+/licUOj/P5N8ZiSywTKEUIVfDbl4jOktqFaq+UsJfhK
         D4ppWsAdYNpQlRttSZhZq04x5eUTNp/rb06JYuQVBXlry3MNG2FqXSF2JFsD22nz5ATo
         TAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684455931; x=1687047931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7LSztTgvuTG/1LRG7rLGwi1XpsK273SzAIspcW50Sw=;
        b=cus/Iv+A8nHoYnSjTZXQH2M46+t2hNXW9k/MRTjH0j/CY+zZLWRSaNnwErWXbYee1+
         GGSfFU2e91EWbjvOJIkk/7BAHF052l9fUUuSfGw9AiZ5BVWI5DCQOCxpUyT5Mmr4iDmL
         2nRpOFEieG9oX41Ltb1h4UYthHw62ISTOoiXQsJNVE3ZM90kB1TsWGaCSmDP5Bv5ztOq
         AP2cwxKD96x8g558ioWeQ/1KARcKJSB9C6eFuwSkeyHfveVlIMnMagj1IupM83o7gLiq
         Qi742rsjIMtUi9czodTud9/1fHDwMfDFg0z1dcI+wDWChgO/4+j/xyKG1YFiqE3OnEUs
         KUSg==
X-Gm-Message-State: AC+VfDxdgWXoPANDYrQj4CWkaz/guZIdF8Xp91TlHBo1noULSKqpviti
	COVCeXuQ1+bTuUwNEXMv7eI=
X-Google-Smtp-Source: ACHHUZ6Cp9812QVrJ99pDHsU2f7yl3xWCuWgrcVsItIUf0yvdilus/B0BzdVR5+viHcZ1+7jwCVZJA==
X-Received: by 2002:a05:6a21:33a6:b0:105:b75e:9e0d with SMTP id yy38-20020a056a2133a600b00105b75e9e0dmr319961pzb.1.1684455931481;
        Thu, 18 May 2023 17:25:31 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id m8-20020aa79008000000b00643889e30c2sm1864056pfo.180.2023.05.18.17.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 17:25:31 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Min-Hua Chen <minhuadotchen@gmail.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: use le32_to_cpu for p->des0 and p->des1
Date: Fri, 19 May 2023 08:25:21 +0800
Message-Id: <20230519002522.3648-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use le32_to_cpu for p->des0 and p->des1 to fix the
following sparse warnings:

drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 13c347ee8be9..3d094d83e975 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
 	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
 
 	if (likely(desc_valid && ts_valid)) {
-		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
+		if ((le32_to_cpu(p->des0) == 0xffffffff) &&
+		    (le32_to_cpu(p->des1) == 0xffffffff))
 			return -EINVAL;
 		return 0;
 	}
-- 
2.34.1


