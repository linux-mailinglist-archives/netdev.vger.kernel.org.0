Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2A63BD59
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiK2Jxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiK2JxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:53:07 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3072193EF;
        Tue, 29 Nov 2022 01:52:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w79so13187333pfc.2;
        Tue, 29 Nov 2022 01:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRMinq7k8Rp6x2pTL5xVUf/39/IR4pJUwqlpijwhsQ8=;
        b=oqIH2yTunmVjjXDHYNlUinxnxGW49OErAZelZct0jEWFO6BnXwKg1vfD2dGKmHWxmB
         un+UxeNiqOuQByawttlpYgSjjkKR1FPnyJ5lXb/c42Da2r7PaZw+1XUjlmtSknDD2EqB
         o5j8cQtrV2woKecwlFsgTJmX6xbYthyJrrEqgucmgov7sZ1mQL/uXSNxnzPdzQf1JBqR
         g7TLtCYviUD8oCSuMHwd78bHpb1+RKtVQ+UrNLNIgLAXfBiLhPvylbIHZsIKDYkBaxxO
         kScM/2yVWzC3YMSVYizokfzZcVQpOSjpAmEEi5tjdrOMmw5LeiA6UjOljlQaTW1iPhfI
         pUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sRMinq7k8Rp6x2pTL5xVUf/39/IR4pJUwqlpijwhsQ8=;
        b=gFA6FSmdurYfnNRJOqJHC7AQfbWOF4gVFwB/C+jiUECVBIfsyPa/RyxM7ilSgfw7B7
         VUCThSlxI9SCsFFpt14Y9u1N1MDlPBHDDUrQBM16yJHw/MDeK751YoW69eGvQBv8N1b0
         z7n4qIRQMGwjYk5x7pAXjwBybjt2L2dX6Zir52vhWJSPr1gxxMj/rxhlP5NXDND3sCZv
         dN7pH3hrIT+Mj/w8A0DUiK0X6J6xHr9mTgXi9bbpg6hWM0Ix8bQuXNBtydEqSKDGUPhj
         fDMsQafbJfFvKQoUeHmhHEARP1EA+mjt7J1Be5+jbluFeN7HWcwQyGE86r2LZAk7AYQi
         H/PQ==
X-Gm-Message-State: ANoB5pmXVzHJD7VsvV7zJ9+mBea75NEyAoeL1XYbv5OiVuSd30EPmb6U
        6yDUOKBcqZETnNl8Z5EwMaQ=
X-Google-Smtp-Source: AA0mqf5u6z67DbifkBMUy3hi5AKKsu673ZUUXV8SFZGZ6XVPZWR3+A17osZujQsrllkqhTg1QnkiyA==
X-Received: by 2002:a63:4944:0:b0:44e:466f:4759 with SMTP id y4-20020a634944000000b0044e466f4759mr31555695pgk.194.1669715574047;
        Tue, 29 Nov 2022 01:52:54 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id mv15-20020a17090b198f00b0021937b2118bsm941346pjb.54.2022.11.29.01.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:52:53 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v6 3/3] net: devlink: clean-up empty devlink_ops::info_get()
Date:   Tue, 29 Nov 2022 18:51:40 +0900
Message-Id: <20221129095140.3913303-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
References: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
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
Reviewed-by: Jacob Keller  <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
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

