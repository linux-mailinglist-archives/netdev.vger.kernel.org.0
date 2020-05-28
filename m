Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EBC1E6397
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391081AbgE1OTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390924AbgE1OTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:19:02 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC62C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:19:02 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d24so197527eds.11
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KckYKdmFHPBsfr0ffuIuff6CkLQahdwZxYLU45tHehk=;
        b=jniowsVN5yk8Vc5l4T6vJbVkNqwCi4RH/aSYRnX9pVW2TWg43PoAlxpWYEcL4sA16X
         qqUReP2HTbJLJ4ngZpqhwNkoEeKLObkFbOtM04rNeLtqBKYoMVPFWUvj7SY/k9EhFLTx
         cWUdXNtNKvkt3NQGG97ceeFaquLRAvl3ExxKM2KLYj4IbG+GFqa4nHguSHKp1EDiq2IW
         18LzmVE9/y71FDnnIMVyAwt70PomVddJTW+WFqUOy/AseUKU+wMfDEfUBRHx8+ck2GxA
         In+DNYYkqw+g1lKC/2rIp/JiV/fZDhdG3pif4JaQj9EiPd56UFhMrzA5o9sjcDqzhmmE
         6+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KckYKdmFHPBsfr0ffuIuff6CkLQahdwZxYLU45tHehk=;
        b=GA5koxZ7CvWPc1MyfaL3JkGuOMtT8OareElG8IuJTrhDI5d7s21l99MRtNb4WLrZLA
         CRLv6WYId5B38Ody5kIV0qozT1Xcym6Nw5I0JJ+PlSyP/i0vayi+qUcgaZPFcjo9MgxF
         sLl4fNyS2qwRB8FmdAsoysfKdH04+A021vx3+LcV7F6jdBYPnYGGOGE/Bu3zxZdvpXBR
         Wu5154qXJ9iiM0zy9XAKU51PU+PZiE0D9NwsoZYbi2KViGqIJRznNEgvQXufHeJLZTVG
         JOT02EpczX4MpGBB8J6TZ+tV9E3RCWMki1q22o6ziotaCrz59pint/4bf60g57QoncCP
         DvtA==
X-Gm-Message-State: AOAM5327zEITl/pLBteI0SbFF/sE0Dstka5ZR/pK8oNOgf39fZJZPcdg
        X7lutEyLJiEnsW5mVv2QcGxfSw==
X-Google-Smtp-Source: ABdhPJx3o+rAnOWjRvApbYylJ/QAgdy8lR35PjzWhfr4Icvz/832XCGZCl85fsvi4kRKuSCyNjbGLA==
X-Received: by 2002:a05:6402:357:: with SMTP id r23mr3354259edw.230.1590675540956;
        Thu, 28 May 2020 07:19:00 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id a13sm4810745eds.6.2020.05.28.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:19:00 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next] nfp: flower: fix incorrect flag assignment
Date:   Thu, 28 May 2020 16:18:46 +0200
Message-Id: <20200528141846.16468-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

A previous refactoring missed some locations the flags were renamed
but not moved from the previous flower_ext_feats to the new flower_en_feats
variable. This lead to the FLOW_MERGE and LAG features not being enabled.

Fixes: e09303d3c4d9 ("nfp: flower: renaming of feature bits")
Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

 This fix is for net-next as the patch that introduces this problem
 hasn't propagated to Linus's tree yet.

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index d054553c75e0..ca7032d22196 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -708,7 +708,7 @@ static int nfp_flower_sync_feature_bits(struct nfp_app *app)
 	err = nfp_rtsym_write_le(app->pf->rtbl,
 				 "_abi_flower_balance_sync_enable", 1);
 	if (!err) {
-		app_priv->flower_ext_feats |= NFP_FL_ENABLE_LAG;
+		app_priv->flower_en_feats |= NFP_FL_ENABLE_LAG;
 		nfp_flower_lag_init(&app_priv->nfp_lag);
 	} else if (err == -ENOENT) {
 		nfp_warn(app->cpp, "LAG not supported by FW.\n");
@@ -721,7 +721,7 @@ static int nfp_flower_sync_feature_bits(struct nfp_app *app)
 		err = nfp_rtsym_write_le(app->pf->rtbl,
 					 "_abi_flower_merge_hint_enable", 1);
 		if (!err) {
-			app_priv->flower_ext_feats |= NFP_FL_ENABLE_FLOW_MERGE;
+			app_priv->flower_en_feats |= NFP_FL_ENABLE_FLOW_MERGE;
 			nfp_flower_internal_port_init(app_priv);
 		} else if (err == -ENOENT) {
 			nfp_warn(app->cpp,
@@ -840,7 +840,7 @@ static int nfp_flower_init(struct nfp_app *app)
 	return 0;
 
 err_cleanup:
-	if (app_priv->flower_ext_feats & NFP_FL_ENABLE_LAG)
+	if (app_priv->flower_en_feats & NFP_FL_ENABLE_LAG)
 		nfp_flower_lag_cleanup(&app_priv->nfp_lag);
 	nfp_flower_metadata_cleanup(app);
 err_free_app_priv:
-- 
2.20.1

