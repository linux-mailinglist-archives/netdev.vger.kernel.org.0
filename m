Return-Path: <netdev+bounces-3885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B1770967B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04081C2127B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE508BF3;
	Fri, 19 May 2023 11:25:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDE56ABF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:25:16 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9910C6;
	Fri, 19 May 2023 04:25:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae3ed1b0d6so22939965ad.3;
        Fri, 19 May 2023 04:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684495514; x=1687087514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6BlLLSb4t/MYbESNdbnlmX8aWP0pTO6ZrGYiXtEq3JU=;
        b=AdTJK5Yy8ERyK+67dFz4QkLtifLll3Mh81VfJnwH6n2WmKtkscqtfrb18kd61SrlMk
         rEYjInP3g6CL/QzhLYXKtHy2rqbRnLySMQrx4d9+Fa4+g4V0YPPWaFM9nUOoh/LumoFy
         OZUIYQAtJn04uQJu4aXzlS8VovVRqEy9YvQFR2hJL2P2Wkum21BlJljtPLghAKEiQrGn
         B8CT2s+owWDQYOnyySWTIjmu0ZDxrz/bD5FNvUxlZvffgK9XHjUI/Mt84CyrqHvcomQj
         z7kWdqKBUw5VLgIxiSL4YkDb+E6Qc7SWy8cMy4oV3arBSAFbRqVN9I21cxzZ56OkPKbp
         qdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684495514; x=1687087514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6BlLLSb4t/MYbESNdbnlmX8aWP0pTO6ZrGYiXtEq3JU=;
        b=EUn/bFIty/0Pw4ObYols6O/T02bqFszEi3hqzywGNB647lxdfOTZj9fySIIF5M8DHr
         Onuj8X5jDkQsEmo5OXmT2rS5XIpoWAgnZlfe37vcsv31AuTx5NKWTvIojnHKGI7c0yPM
         5OTmUf7745r5bf4zXLn7uZZ7qjrj+jEUQHktg+R6WQcr/24E7wmgrdpS4HmRRF1U7z3C
         vNmihkIdsIs+JYoSSoVJehKBnUdCVS03bk4mkmYpa6y2ngKHrVyW4EXgmjIyBK63XMih
         5ybivHfPdZ0Nj61QC254+YWyFVmUdC/U2rqEZK12YDdi+DpjeNihszsZYhIs/PjsW6vS
         emVA==
X-Gm-Message-State: AC+VfDyq4xQuJ+uEA29SHd4bXYDFFxaS5I3MAMP5ZbapDCeqKTJu6ITu
	QMlCFKet6diMMNuaIzbcI3c=
X-Google-Smtp-Source: ACHHUZ64CiYvdspneYPeXoJ9FG78ZZve8AsKQbiHpjWwuP8+rb6oiNv3DRb2T5J8X8D5z9uBuDDoiQ==
X-Received: by 2002:a17:903:2343:b0:1a9:9a18:3458 with SMTP id c3-20020a170903234300b001a99a183458mr2800765plh.31.1684495514183;
        Fri, 19 May 2023 04:25:14 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001ac95be5081sm3170111plh.307.2023.05.19.04.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:25:13 -0700 (PDT)
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
Subject: [PATCH v2] net: stmmac: compare p->des0 and p->des1 with __le32 type values
Date: Fri, 19 May 2023 19:25:08 +0800
Message-Id: <20230519112509.40973-1-minhuadotchen@gmail.com>
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

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 13c347ee8be9..eefbeea04964 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
 	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
 
 	if (likely(desc_valid && ts_valid)) {
-		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
+		if ((p->des0 == cpu_to_le32(0xffffffff)) &&
+		    (p->des1 == cpu_to_le32(0xffffffff)))
 			return -EINVAL;
 		return 0;
 	}
-- 
2.34.1


