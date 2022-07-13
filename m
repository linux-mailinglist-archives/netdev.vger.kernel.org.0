Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2C1572F59
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiGMHjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiGMHjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:39:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60E6286DD;
        Wed, 13 Jul 2022 00:39:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so2248844pjl.5;
        Wed, 13 Jul 2022 00:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzhLKayx5ZTvhq0OTzVspj8uwQVYr3uuqnEf5g004ms=;
        b=hoijz3NApAWePoZC6EflevIP1lP2IfOIW4CXtTBbE+s93kgypBTSe+ErqRmKjt/EXl
         47HZDNUrqmK0EmnhLl6Hv9/foTq6icJ5qwpqJCLl6rtiYWjyfkrz1JdmecGvzWnEAQCk
         /fk6hnU/6+RImPX0OFjx4QtwVIoipes+VaaJcmf6IoEc7po0wlgR472c0jWq3jEZcXFy
         8+wkY1OIlOmjnHQXR80jx/93ddf3aJaIwrinEXLykT6jsiYPkBdEN3+aX6XCK+GtcLfK
         AboIPO4jObp+7z0614iogdRnlPg8kJVHQKosLxeEP3qVRTu9x+BV2c2NvFh3AZMNB4mU
         aYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzhLKayx5ZTvhq0OTzVspj8uwQVYr3uuqnEf5g004ms=;
        b=jJFYLDWH/BySExNOFvaDfUMsazAh6En0VkgbAoFV3z7v7iMtC1hWsV6rUf5s/BLVn8
         nllaTp1n+SWwEQm/K+KVcN9MDJnnuVEcVBiKesxpVbqeEMEYBbhqi+Z6sUgEKWLC2tm8
         gs7BMfc29UWyYI5wX118lV2URKWVgha6qxOUZATfLRX7B1dz8WKTIue0ck6HiSBdMULU
         MKxGaeQTIlzdhpl71qE9ORwkNhR/kIULMJysS/jFXr7bA0q4Wtbi/QPnU+fYI7n3F1nl
         HRl+nJJ1mlWWqyVjmDdfGk02NLYCD+QSvLCMbrxEgWGA2OIAuHUYlwhZT6O/Oa1AdWYA
         c27A==
X-Gm-Message-State: AJIora9mrCVZntZiv37uBATn3fpTIyoAZFE9CVi8Wn2j5FnH3CT1XVQU
        XZDOAQAbvv1/vUPXfORHl4bQouOrmgnX/iZK
X-Google-Smtp-Source: AGRyM1vssrB4FS8kuAl24Lgp3QRCJ977Nwknctu1a47TBRR4aexLA5L2YFm8da5Nh7vh5Xg9cdYq6Q==
X-Received: by 2002:a17:903:11d2:b0:167:8a0f:8d33 with SMTP id q18-20020a17090311d200b001678a0f8d33mr1905691plh.95.1657697957145;
        Wed, 13 Jul 2022 00:39:17 -0700 (PDT)
Received: from sebin-inspiron.bbrouter ([103.182.167.131])
        by smtp.gmail.com with ESMTPSA id x190-20020a6286c7000000b005252680aa30sm8167086pfd.3.2022.07.13.00.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 00:39:16 -0700 (PDT)
From:   Sebin Sebastian <mailmesebin00@gmail.com>
Cc:     Sebin Sebastian <mailmesebin00@gmail.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] octeontx2-af: returning uninitialized variable
Date:   Wed, 13 Jul 2022 13:08:58 +0530
Message-Id: <20220713073858.42015-1-mailmesebin00@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix coverity error 'use of uninitialized variable'. err is uninitialized
and is returned which can lead to unintended results. err has been replaced
with -einval.
Coverity issue: 1518921 (uninitialized scalar variable)

Signed-off-by: Sebin Sebastian <mailmesebin00@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index ed8b9afbf731..563bf1497fd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1961,7 +1961,7 @@ int rvu_npc_exact_init(struct rvu *rvu)
 			dev_err(rvu->dev,
 				"%s: failed to set drop info for cgx=%d, lmac=%d, chan=%llx\n",
 				__func__, cgx_id, lmac_id, chan_val);
-			return err;
+			return -EINVAL;
 		}
 
 		err = npc_install_mcam_drop_rule(rvu, *drop_mcam_idx,
-- 
2.34.1

