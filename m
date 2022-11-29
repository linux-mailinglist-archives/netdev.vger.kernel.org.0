Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B063B659
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiK2AH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiK2AGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:06:49 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D804B3F04D;
        Mon, 28 Nov 2022 16:06:39 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t17so11074346pjo.3;
        Mon, 28 Nov 2022 16:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiKBx41kPdklVq60u1rvSJT+pX4e/ZYzQPE8Kx535cw=;
        b=cuYXqB47/KfnW4v14eUYsIp/vJ4Xx7KNP3dVstFmdoO9bHZ630CWx03yYvrh492DjD
         FHeaIW3sEwLURX7kvf2KKh9YFyW0Rpkd0OyiwVta4kAuxLqd0kdoduja3BGgFNO2CED4
         V8vA6wK1ORYrSrV6VmUkU78b1OpyleUkYtxV6kfMtdZipam2QQR61cq/aMpkP97Alntx
         TnxPvdz5jPlV1RrFK5ZN+5lWIg/nkoGelr3V4jDtYFTChnHIhGEBRPnVGIV6sC7xaHmV
         JuzQ11I+cJKSJ5zwhIOR5LlOGBOD7ygXObJwKMmdjz1hS8pEHL4d9/WDR16T6EyY/pU+
         DWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DiKBx41kPdklVq60u1rvSJT+pX4e/ZYzQPE8Kx535cw=;
        b=swntjTGq5e0/pwXKzQjLBlXqwx3mqEtIG4HwGYGUapMuRORQqXdttbIX+O9ZBftrVj
         EN0RZfK5Dg0ll/yZ5XSK4LZ0DZDuSiNPMeYT6h+mRl7hiB5etnoy9r8JoQ6bNaUkNWVl
         qdgGtAFgAf2dAx4P6kFfDavguVkxQwARShB+4vtO43aZmAwpHrjpvHZSTfu9u4BtIdIz
         NyWmuwQWZbKK94lpBao/XEfH/dCdWa5cCQ2JjDfvn+yejXw4OLEI7wjcZ0qMcyf5/lQs
         y+rGKmLPjtiwiR0hc64Aq9oUt3Rkdz3Ak4iwCIaCiL+j4QYqjLTd3BhDiWr0j7c27+xX
         Azdg==
X-Gm-Message-State: ANoB5pnudhG9/Aq8CD7/hKCvp1KoxjHqJ9jo1SfULCJuOIHs4mG5xTFx
        nrWgJrN82232T4mcD5ADWXg=
X-Google-Smtp-Source: AA0mqf7NWa4KQ4nPAzCG7HfcheFPSyelxCkNDpoEQT4zt9ZPHHQI1VJ4G1srcs2lK8zDtdNBf9YxiA==
X-Received: by 2002:a17:903:40c5:b0:186:738e:5703 with SMTP id t5-20020a17090340c500b00186738e5703mr46684785pld.136.1669680399242;
        Mon, 28 Nov 2022 16:06:39 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id r2-20020aa79ec2000000b00572198393c2sm8588147pfq.194.2022.11.28.16.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 16:06:38 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v5 4/4] net: devlink: clean-up empty devlink_ops::info_get()
Date:   Tue, 29 Nov 2022 09:05:50 +0900
Message-Id: <20221129000550.3833570-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink_ops::info_get() is now optional and devlink will continue to
report information even if that callback gets removed.

Remove all the empty devlink_ops::info_get() callbacks from the
drivers.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/ethernet/fungible/funeth/funeth_devlink.c     | 7 -------
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c   | 7 -------
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c | 8 --------
 3 files changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
index 6668375edff6..4fbeb3fd71a8 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
@@ -3,14 +3,7 @@
 #include "funeth.h"
 #include "funeth_devlink.h"
 
-static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
-			   struct netlink_ext_ack *extack)
-{
-	return 0;
-}
-
 static const struct devlink_ops fun_dl_ops = {
-	.info_get = fun_dl_info_get,
 };
 
 struct devlink *fun_devlink_alloc(struct device *dev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index f15439d26d21..bda1a6fa2ec4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1547,14 +1547,7 @@ static int rvu_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	return 0;
 }
 
-static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
-				struct netlink_ext_ack *extack)
-{
-	return 0;
-}
-
 static const struct devlink_ops rvu_devlink_ops = {
-	.info_get = rvu_devlink_info_get,
 	.eswitch_mode_get = rvu_devlink_eswitch_mode_get,
 	.eswitch_mode_set = rvu_devlink_eswitch_mode_set,
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 5cc6416cf1a6..63ef7c41d18d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -77,15 +77,7 @@ static const struct devlink_param otx2_dl_params[] = {
 			     otx2_dl_mcam_count_validate),
 };
 
-static int otx2_devlink_info_get(struct devlink *devlink,
-				 struct devlink_info_req *req,
-				 struct netlink_ext_ack *extack)
-{
-	return 0;
-}
-
 static const struct devlink_ops otx2_devlink_ops = {
-	.info_get = otx2_devlink_info_get,
 };
 
 int otx2_register_dl(struct otx2_nic *pfvf)
-- 
2.25.1

