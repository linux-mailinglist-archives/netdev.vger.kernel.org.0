Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD105B2D4B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 06:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIIERL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 00:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIIERK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 00:17:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB40F121129;
        Thu,  8 Sep 2022 21:17:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so4207950pjq.3;
        Thu, 08 Sep 2022 21:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=mTQeerp6vrMHbtmhw1xtF+7F71feU54gGWD+y0Ql+EQ=;
        b=ieUxokWwlpFX4V1oPWfeXKPgp9sMWrIi9HvmN+/guLJDZ+1MMEd2sQgtffkyE54x6M
         ECD7YfWvqIv1U9x5wrXaYnNZpZdAXGaGxePhcvgNo6q8Y3lS2e+0C+ikhetG5NLN2Ab0
         GXHY/lXZvKyASTMh+3AMLdrawzTD2xjhnqYJurm6ZLEVpCcDBSOwnh4HRuGw5Tna4qZ/
         RgyS7PS//xTPdKISycrzkiv4oL5TPkuZ39iu4MmfEKpkutbVUutdLQbdayCq25vqskMx
         XiTxDUmFqZWheepj6mPqgVYDBVo+BdJjrYhnu+/F6yoyBBKf5U+jEfJX6VmMvHRwoxdt
         HbSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=mTQeerp6vrMHbtmhw1xtF+7F71feU54gGWD+y0Ql+EQ=;
        b=NMG/+GvVrSopuPljIV5VuMBAPdgadErxYZ5uWRlVE2OCZDMIBNWMBiOpNrfaIRlhh9
         cSkTIx1YhF2bvO0R6Fh0GADB0snKVsGSX/SVHaBgO6sz29YwCuhrv+ceFbdDMFva4sMs
         a0GcMQZyKJrxFsDHxcENAtjw1daJ5rhsJLeFHHPAdrzIU9fgLX2GlImByPqWinOqvfSb
         rHjVOIXxMURyTYHtiimHKbiiVRe4Azed+924uhEuSqXiiIWQjBhQqOnFGNKlbtUtf8nG
         BCyS6o1or4LHbbhm8kdWIUGxe/wG2wBrQau5l2T7zkX+lFkBz7WaGuoSxTDJwV0pWhcW
         RNlw==
X-Gm-Message-State: ACgBeo3NUohefAntrHYsVfijB49h1oVQ+47QIMJqgW54KrqVDRxM25iY
        A8IhGZxC9CQE2OfLAdNvAF7iQwCOjEUx/Q==
X-Google-Smtp-Source: AA6agR6tI5hZ/pdKzlFF9Xd6nDWbiwnsidZF0TRH5j/J4eIkqLrwjcxaG8BlA8Fjktf7uldjQj2USg==
X-Received: by 2002:a17:90b:358e:b0:200:9d8a:7a70 with SMTP id mm14-20020a17090b358e00b002009d8a7a70mr7430140pjb.61.1662697027216;
        Thu, 08 Sep 2022 21:17:07 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id 201-20020a6217d2000000b0053e5daf1a25sm476194pfx.45.2022.09.08.21.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 21:17:06 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v1] drivers/net/ethernet/intel/e100: check the return value of e100_exec_cmd()
Date:   Thu,  8 Sep 2022 21:16:45 -0700
Message-Id: <20220909041645.2612842-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the return value of e100_exec_cmd() which could return error code
when execution fails.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 drivers/net/ethernet/intel/e100.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 11a884aa5082..3b84745376fe 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1911,7 +1911,8 @@ static inline void e100_start_receiver(struct nic *nic, struct rx *rx)
 
 	/* (Re)start RU if suspended or idle and RFA is non-NULL */
 	if (rx->skb) {
-		e100_exec_cmd(nic, ruc_start, rx->dma_addr);
+		if (!e100_exec_cmd(nic, ruc_start, rx->dma_addr))
+			return;
 		nic->ru_running = RU_RUNNING;
 	}
 }
-- 
2.25.1

