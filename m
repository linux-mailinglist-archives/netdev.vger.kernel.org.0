Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F17F639AD6
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 14:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiK0NKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 08:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiK0NKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 08:10:14 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058CBDF6D;
        Sun, 27 Nov 2022 05:10:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso11580595pjt.0;
        Sun, 27 Nov 2022 05:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvGCayvT1wrZ4HfMEpEiFtD2YHJkr4R5tohql3dWU+g=;
        b=okN2Y2Wp7abBRiLot6BlIxc1Ou6BKAOMwsBvM79Xvllqiid1BUG0KMPKC4bevz4q2H
         tq5wRTNFFIyS2e6tTU3EJV6YKxM9EGMBvptMol6Pmsxhao7cpfMiUTmA9PugCdmNdw7D
         znImuKAaIX2KbwZ2XzxsYHHq4SpvK5pr1XJBUGvw91oyBM0fmkb6X43l928wk/xYHTjH
         drGGgiaq5PtjtzWMNHF5VFYiKFLThDobS9OFD+MRAQPlRcNny9blkw1FE303IRT8o9na
         qnuvBldQ85CXRfGWKnpuhOHD60T5bCcqv4Uy/F1YpvFE8+GUm678yM00qar2D76JCa5Z
         dFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IvGCayvT1wrZ4HfMEpEiFtD2YHJkr4R5tohql3dWU+g=;
        b=oFL4xJmVuHhKXHi1ZqPusZ324OJWTsD+jBRNIWOysgQI/i9DKb3VqN6lMYDXBLpcmJ
         pvPsiAjLX6z0K3tAseWJCAsVeYFlKEoXHdES8KsYbR9Zw2HvfPhVgJD4IZ9RnV49iDNW
         bwz+pjIqGgDTYx+MHkRt0ItMJtKMI0xsCjvAJ32/+MzzV9OV8Hv2Bv9SdXZ/Kxb024k9
         O0BHvNjTA5cZY5DXshYS3NKje3eOQGVYTSDn/e7pHerEd9tjE6F48NosBECbik/DECvV
         9IjVR5SYqzyCqVCz8OdfV+S5PuMc4AsnnRYikyMYsLui6yirgNJQfyL+9Nf0Ewonhq6y
         T5bg==
X-Gm-Message-State: ANoB5plFFDBwhfP+rMf7v9qL+eQqAFngQodZhHrb7V4XA5S5AEOWDKUQ
        6HNgoc3cqkmFb2FOuh/aQwQ=
X-Google-Smtp-Source: AA0mqf4Dk9WPi4BLnpif8989C+H6hbvudTv8XZdKjK1ZGzmT2xqFwp6N/1Exmp8XwVBk2OfSw25ClQ==
X-Received: by 2002:a17:902:bd42:b0:186:9c2b:3a39 with SMTP id b2-20020a170902bd4200b001869c2b3a39mr27661689plx.115.1669554607585;
        Sun, 27 Nov 2022 05:10:07 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902eb9100b00188a908cbddsm6710225plg.302.2022.11.27.05.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 05:10:07 -0800 (PST)
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
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 2/5] mlxsw: core: fix mlxsw_devlink_info_get() to correctly report driver name
Date:   Sun, 27 Nov 2022 22:09:16 +0900
Message-Id: <20221127130919.638324-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
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

Currently, mlxsw_devlink_info_get() reports the device_kind. The
device_kind is not necessarily the same as the device_name. For
example, the mlxsw_i2c implementation sets up the device_kind as
ic2_client::name in [1] which indicates the type of the device
(e.g. chip name).

Fix it so that it correctly reports the driver name.

[1] mlxsw_i2c_probe() from drivers/net/ethernet/mellanox/mlxsw/i2c.c
Link: https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714

Fixes: a9c8336f6544 ("mlxsw: core: Add support for devlink info command")
CC: Shalom Toledo <shalomt@mellanox.com>
CC: Ido Schimmel <idosch@mellanox.com>
CC: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a83f6bc30072..d8b1bb03cdb0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1453,6 +1453,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 		       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct device *dev = mlxsw_core->bus_info->dev;
 	char fw_info_psid[MLXSW_REG_MGIR_FW_INFO_PSID_SIZE];
 	u32 hw_rev, fw_major, fw_minor, fw_sub_minor;
 	char mgir_pl[MLXSW_REG_MGIR_LEN];
@@ -1460,7 +1461,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	int err;
 
 	err = devlink_info_driver_name_put(req,
-					   mlxsw_core->bus_info->device_kind);
+					   dev_driver_string(dev->parent));
 	if (err)
 		return err;
 
-- 
2.37.4

