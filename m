Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344336399AC
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 09:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiK0IRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 03:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiK0IQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 03:16:55 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF601114A;
        Sun, 27 Nov 2022 00:16:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso11246645pjt.0;
        Sun, 27 Nov 2022 00:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uaOXK+3zj1VRT6U3g5h3Ky+R8tcH0ZCUYvy33QfB7vM=;
        b=ifVBNcP32bWIkNZkPVHGPmhBD7EYsQ8f4oy3RqHII0Z8/SwDG7tbP1hOmyJ+RX9RWI
         +N1FmQkYpl9q5DzO6JWt26CrMNcA3QOT//FHn0TOSL3knf4EikL7CxKVhwKVfjlgUtZd
         bsFIK5/jXRJxZiCHv7tBPt97OljhUlcunJpoBbiTCWh2K4hyRsXe6CiTBPh56QmLhfZa
         gtq/OFeQVdLsfUArQRaYV/NLO1dUjVVPF5eJgZF4McINAxYOpoDRZD+TfkHPlBnn6UkN
         fHI0f3jrLJ4rVz3Y6pyWc7bgIIK5+ilcWDWno5TduNkmqv0mhNEvphXo3O7C7k63cMvA
         AsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uaOXK+3zj1VRT6U3g5h3Ky+R8tcH0ZCUYvy33QfB7vM=;
        b=i8FFmqizAnR7yFSzeZQFARKhxdrPMzRolKTKXx2Irc5EqZ58Pc14XzeObWJKxlluX8
         5Jh2lmknDz/mUqaInccSuh+GnQpLUr0YFCndtgugKTtPSdLieJzyg0y+If0IEGKDO7d4
         7snLW6AVgtigp3teKO4cuXtNRZ1OM/vQuptN0PRiEvByS7aiVQF0vEFRaUOW552tbHEd
         IutRcz+NrXlYmtv7Pqd+mkY6gebTZaWacLE+GXzdQiQJ1ekBYtij0KsPQ2tbt/SF5BL2
         yp3DlCt7z/eLHed1je3BlSDfDiPzDuWNPU3EhpkdW9x6QD3SPoNTI7kEX9x8anj3lxZI
         dvUA==
X-Gm-Message-State: ANoB5plNaq0u6nyWiDO707nd5DoOrQJF3xejbzsFyc8lTym8Q1XYqDbe
        YrBI+FoyKkv9Fl48AFMct98=
X-Google-Smtp-Source: AA0mqf5VHz3WzW4yABHf3SMGky4I1aN6x5psCE6vYqJXlVtP74c71tuH5yn2LW5vSPh7UnwtWVA+Cg==
X-Received: by 2002:a17:902:a989:b0:188:d6c7:e7b7 with SMTP id bh9-20020a170902a98900b00188d6c7e7b7mr26560851plb.16.1669537006426;
        Sun, 27 Nov 2022 00:16:46 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id a3-20020aa794a3000000b00572c12a1e91sm5799915pfl.48.2022.11.27.00.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 00:16:46 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 2/5] mlxsw: core: fix mlxsw_devlink_info_get() to correctly report driver name
Date:   Sun, 27 Nov 2022 17:16:01 +0900
Message-Id: <20221127081604.5242-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221127081604.5242-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127081604.5242-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

[1] https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714

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

