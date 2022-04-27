Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1B251213F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbiD0Po4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbiD0Pos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DE833887
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFF3618DC
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BAFC385AC;
        Wed, 27 Apr 2022 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074087;
        bh=nyS/qzNVzmEkSaJ3nVwgO/8/CzgNMfDoJNAtOdzapMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsA3/rfIEXXBNKeCJPz2x4h7cIaFsJsJ3ef4fI+QFc0NG/fSJ0ycurvqB9pvw0SAC
         gf+8ySQagWvqMdTgFNXhQBEOKRtSc3ZUOdnBw7Px/FU9tsnq+aui9ZC9hiZyLs9mjO
         beTYIxa+AYGUBJX3UrNRXv7AaMKs/2FEM5GMNLbojulF9Ae6GOVENvW9awPY/ob/ze
         eEMtuK2uL/V8WPZTPiLtfFHnEKq1jOWVAN8X67HGwV0ey2Z03OMg2lxwZMarcFDfc1
         2FcLmLMkozC3y1ZU2B1GYjzmXV1A24f2BYJsPPj5rBwJ31XNlNJA2PD0RtrrZZtfPW
         YoQTgUVnmG+ag==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jdmason@kudzu.us, zhengyongjun3@huawei.com,
        christophe.jaillet@wanadoo.fr
Subject: [PATCH net-next 12/14] eth: vxge: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:09 -0700
Message-Id: <20220427154111.529975-13-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427154111.529975-1-kuba@kernel.org>
References: <20220427154111.529975-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jdmason@kudzu.us
CC: zhengyongjun3@huawei.com
CC: christophe.jaillet@wanadoo.fr
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index aa7c093f1f91..db4dfae8c01d 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4351,7 +4351,7 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 	}
 	ll_config->tx_steering_type = TX_MULTIQ_STEERING;
 	ll_config->intr_type = MSI_X;
-	ll_config->napi_weight = NEW_NAPI_WEIGHT;
+	ll_config->napi_weight = NAPI_POLL_WEIGHT;
 	ll_config->rth_steering = RTH_STEERING;
 
 	/* get the default configuration parameters */
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.h b/drivers/net/ethernet/neterion/vxge/vxge-main.h
index 63f65193dd49..da9d2c191828 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.h
@@ -167,8 +167,6 @@ struct macInfo {
 struct vxge_config {
 	int		tx_pause_enable;
 	int		rx_pause_enable;
-
-#define	NEW_NAPI_WEIGHT	64
 	int		napi_weight;
 	int		intr_type;
 #define INTA	0
-- 
2.34.1

