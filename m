Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E1763A079
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 05:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiK1ESD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 23:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiK1ERj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 23:17:39 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701B413E0B;
        Sun, 27 Nov 2022 20:16:29 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r18so8851107pgr.12;
        Sun, 27 Nov 2022 20:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjAI8qVVGO07FKShcXF7iZ9qNBkTNGT0At3i/50Q48k=;
        b=JLZgMTR9BOAPybvjm50I3AQUB33vas5DdKuy0k9v2P748nXZxKLk0c63OAjrXjNHFx
         PGkVNuTr4X1bF3iUcO12xiHsgM5OoM+xLcfULaNLSRg+MuWg/s3p+heUIkxzQLvBOhik
         TYDto1Y7G6fGT2xiLSxhysa9T3M8lkyEfOpfJZqwr/3GuUnOpeYgBJF7j0bKgx3sYqlx
         GoKK4MDF/COx22I2qk7BQ/r4x7FxloGX3PUCJvhK0I4nxh1bkKepI8q+4mpurser7IOU
         bK4Tjm70sR8YG1tSBz9j/fgLomd0NzmCZGI/u0shfnk3DJFK2djaGbZNozTQFPF70P3/
         LbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JjAI8qVVGO07FKShcXF7iZ9qNBkTNGT0At3i/50Q48k=;
        b=FAsCv5DtPL86kZPD44JQHxsff1k36z3ovJF7pDWnCc9XnOD+RlZfjlY9MxWUIoMvxw
         cKmEYu3bpmoPTeOZ/Md5SPuYY5l3hcQMHlA+ab2Rielh8rGeduYCklxN3K6JPl65ntNF
         JfTU9xvaBJeKCQU/AFlUzfNkBN7+RFAe2Ij/DK6i/+XRP0Lw5D1PaflEeeRVAv/xJTg3
         GW28wQj9cY/vmzr0XWkHXh8TiUCuf0bkdvXTIYw6I8F1uKUP/UgAbdrmMQdDIIH7QOH3
         1OYAfiKyWxSMfYW4R/kn8McoKA2QCcSwMCCYqeU+0IkXf21Bt2XxcVjEQ5KSB9n0xVEb
         M6Hg==
X-Gm-Message-State: ANoB5pk605GwSXY9pgSWPyQOrvD7XEgr6wRyWzpiQQLoQdOw0Ekdo8bn
        iyToQICaE8uGTffMylLB2wk=
X-Google-Smtp-Source: AA0mqf4CCt+n+QAsQM8eiB3dp3akEkIzsrNN80n0dkmFQEmRSn8uwWg9qVBG5WFbtZAmX21TV6aNpQ==
X-Received: by 2002:a63:1563:0:b0:477:8fed:811f with SMTP id 35-20020a631563000000b004778fed811fmr26480617pgv.343.1669608989152;
        Sun, 27 Nov 2022 20:16:29 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id z5-20020aa79f85000000b0056bbebbcafbsm6927107pfr.100.2022.11.27.20.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 20:16:28 -0800 (PST)
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
Subject: [PATCH net-next v4 3/3] net: devlink: make the devlink_ops::info_get() callback optional
Date:   Mon, 28 Nov 2022 13:15:45 +0900
Message-Id: <20221128041545.3170897-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221128041545.3170897-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221128041545.3170897-1-mailhol.vincent@wanadoo.fr>
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

Some drivers only reported the driver name in their
devlink_ops::info_get() callback. Now that the core provides this
information, the callback became empty. For such drivers, just
removing the callback would prevent the core from executing
devlink_nl_info_fill() meaning that "devlink dev info" would not
return anything.

Make the callback function optional by executing
devlink_nl_info_fill() even if devlink_ops::info_get() is NULL.

Remove all the empty devlink_ops::info_get() functions from the
drivers.

N.B.: the drivers with devlink support which previously did not
implement devlink_ops::info_get() will now also be able to report
the driver name.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 .../net/ethernet/fungible/funeth/funeth_devlink.c   |  7 -------
 .../net/ethernet/marvell/octeontx2/af/rvu_devlink.c |  7 -------
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c   |  8 --------
 net/core/devlink.c                                  | 13 ++++++-------
 4 files changed, 6 insertions(+), 29 deletions(-)

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
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3babc16eeb6b..817d978bb729 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6773,9 +6773,11 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto err_cancel_msg;
 
 	req.msg = msg;
-	err = devlink->ops->info_get(devlink, &req, extack);
-	if (err)
-		goto err_cancel_msg;
+	if (devlink->ops->info_get) {
+		err = devlink->ops->info_get(devlink, &req, extack);
+		if (err)
+			goto err_cancel_msg;
+	}
 
 	err = devlink_nl_driver_info_get(dev->driver, &req);
 	if (err)
@@ -6796,9 +6798,6 @@ static int devlink_nl_cmd_info_get_doit(struct sk_buff *skb,
 	struct sk_buff *msg;
 	int err;
 
-	if (!devlink->ops->info_get)
-		return -EOPNOTSUPP;
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
@@ -6824,7 +6823,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < start || !devlink->ops->info_get)
+		if (idx < start)
 			goto inc;
 
 		devl_lock(devlink);
-- 
2.25.1

