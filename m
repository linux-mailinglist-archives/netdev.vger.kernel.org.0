Return-Path: <netdev+bounces-3891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5CB7096C6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C60361C210BB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261E28C16;
	Fri, 19 May 2023 11:50:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D658BEE
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:50:37 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4436511F;
	Fri, 19 May 2023 04:50:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-2537a79b9acso609935a91.3;
        Fri, 19 May 2023 04:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684497036; x=1687089036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hQGAuByaIDxbyojHoKmHrl+Nk6GqKopJ1ZhmVD31Npc=;
        b=gunVkUnD7D4jkTN/U/zUqKXL2XEJa5twGkfe4HTgztsK/5C89ynhd6QbT3z7m0Iqfm
         oeqjVPhzJzgc8EamP7G+QEn2+7n+YCbaqDep1azYXCx1SyIpOe27xfSa5xnR96AlLooV
         PzKMYNCtt31yvvz0xAjrReNxyG/QMkCaQY9z0lJg4GZKYDgYRSWkjjuVtw+489YSZCT3
         F8qSGTt7IsVLLjjmjN2LPUcO9kyWDManwqtE79Lk8lXj+ZlchKawFbqlDytge3OCbT+f
         zT8nJ/REBMfCgIMq86rPkcDq7sLstL/WvIK7pUs3nqAqbWrSqne3MOPAYI7cZgT4Hzt0
         /AjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684497036; x=1687089036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hQGAuByaIDxbyojHoKmHrl+Nk6GqKopJ1ZhmVD31Npc=;
        b=ZuvRDbuKXdptguuKabVnh2HHxZ/Z55Dqllj28eyIkenkfmDhjEXIGBeR4Z+4BXMGpW
         osIuJLcttkkN3gdeBQU3xwTZZ5e117gqCnwkM9vbSMuQb4GGp/dpYGBUYuMHPXqQf0CZ
         fqbW1avfkVuwFMQYXhyN/+rWBr+9FesX+W/wy8DmGW2l9TwAEivfZUxtxtWDy6eSd/CE
         6KBdSwZmrw4mdIAzaU7ChG0Kloou7igqYWoOnpfOcbCgYzYSMw3EpXPEvTk+BIOhcZAY
         /1yz4jhB7D6NzlZ5RlcilPN150OchP0mdpnLdEb4daJA1+WlzTEvrJJZaUVpopsoWZY4
         fiMA==
X-Gm-Message-State: AC+VfDy2HNMyLyLtXDae4j/lx2ltaMkvG3OAhJzbkMDVK2Hw8y4hDwdE
	Y9k6cBJKs6PXOm8AAikLeeQ=
X-Google-Smtp-Source: ACHHUZ7pPIhbppvLnQ1vgjftgAajPnjW22pA73/CudJr5YDBYqN2Ag+3yy0FJSQutFhspU/Hkvhegw==
X-Received: by 2002:a17:90a:d513:b0:24d:d377:d1 with SMTP id t19-20020a17090ad51300b0024dd37700d1mr1776498pju.45.1684497035724;
        Fri, 19 May 2023 04:50:35 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a468f00b00250334d97dasm1259507pjf.31.2023.05.19.04.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:50:35 -0700 (PDT)
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
	Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32 type values
Date: Fri, 19 May 2023 19:50:28 +0800
Message-Id: <20230519115030.74493-1-minhuadotchen@gmail.com>
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

Use cpu_to_le32 to convert the constants to __le32 type
before comparing them with p->des0 and p->des1 (they are __le32 type)
and to fix following sparse warnings:

drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
---

Change since v1:
use cpu_to_le32 to the constants

Change since v2:
remove unnecessary parentheses

---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 13c347ee8be9..ffe4a41ffcde 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
 	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
 
 	if (likely(desc_valid && ts_valid)) {
-		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
+		if (p->des0 == cpu_to_le32(0xffffffff) &&
+		    p->des1 == cpu_to_le32(0xffffffff))
 			return -EINVAL;
 		return 0;
 	}
-- 
2.34.1


