Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792F257B955
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiGTPNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241224AbiGTPNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:13:01 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B5258854
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:51 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p26-20020a1c545a000000b003a2fb7c1274so1564731wmi.1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nB4jHd0JvJXUiTngdJ0r0r3bONX7cmQcby/sAaGWilM=;
        b=gurmYscj6VwjQCdy0UXla93JoWutLjpEh/rYreTp4hQlaoahN0r7D3Xuot6WLIrzNR
         4M+lsZ34fKSrnLthImt4QTAIVFD10EK/Npbc22pYFi9IDJ5seT8HZ+NBmGSVeRrXJwuR
         xSU7GN01Wi9b5AIRv22GE9sdwK9DiGpp75u+D9OR/sK83NG/mfgCRl7lpkn0YA1V89Xi
         tVuUUD3SceOG9zA3J1SCfU5xEN4j5hSX+VCmCdVQe6LrzM9AeXU/c/sXHb1ejAa1Y+Gf
         OGEMRt0C/nbbXDs3DqiFpvbdje7DIX27S4MNH+30uKEVM2AbjWavw0rIj5AwEbVh5yuD
         cnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nB4jHd0JvJXUiTngdJ0r0r3bONX7cmQcby/sAaGWilM=;
        b=6zyM7P57r7fWTZZG86meR+Fey4eVme1tMRFHGqEgFzp05ox5X9maxwoz2ofOLjXoQX
         x9Cn/n2zMb+gnunvAseG04oVHKoq/f9kwYwM4/FpRkdm9Wo3sNi+pxvoVpFg9ki3NdeV
         MKzCpfc9MLwFeDC4f+6WzgkPfyT8SvJr5gX/OEelZyTCgkSiWJ2kB7DOiudIqTlsxzPz
         ubzSz6QYHW3p8PNnUkY2lG8w3EQadZlMkyqTs7PPk6Ay5S4we1IIYYPAL6WVTs8lNUuU
         vPdagpw0c2qMBjyDyYjuSc2J/+dA1NLtgyWsVKA7J3jMaeVEMgId3eORMXdvJ7sVYWbS
         8lJQ==
X-Gm-Message-State: AJIora9zs4KeAeRWF5K9z0+ZYw4u5eBi/wqZ8VxYPMXO89ZV4kQOXpcA
        o03rhbO00s8bN7upQBM6pLYGmbpVcG0U4+dzFpM=
X-Google-Smtp-Source: AGRyM1tSywLwrfwknxcMMdLL3+6ybF+7eIuEtpmRXJejiHmBGEOk4G1yF31vNApdGysRc/GgEt4ApA==
X-Received: by 2002:a05:600c:3044:b0:3a3:f60:c907 with SMTP id n4-20020a05600c304400b003a30f60c907mr4130849wmh.19.1658329969905;
        Wed, 20 Jul 2022 08:12:49 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c28c800b003a02f957245sm2893387wmd.26.2022.07.20.08.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 08/11] mlxsw: core_linecards: Expose device PSID over device info
Date:   Wed, 20 Jul 2022 17:12:31 +0200
Message-Id: <20220720151234.3873008-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Use tunneled MGIR to obtain PSID of line card device and extend
device_info_get() op to fill up the info with that.

Example:

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
        fw.psid MT_0000000749
      running:
        ini.version 4
        fw 19.2010.1312

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- fixed s/Used/Use/ typo in patch description
---
 Documentation/networking/devlink/mlxsw.rst    |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  1 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 31 +++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index 65ceed98f94d..433962225bd4 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -75,6 +75,9 @@ The ``mlxsw`` driver reports the following versions for line card auxiliary devi
    * - ``ini.version``
      - running
      - Version of line card INI loaded
+   * - ``fw.psid``
+     - fixed
+     - Line card device PSID
    * - ``fw.version``
      - running
      - Three digit firmware version of line card device
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e19860c05e75..a3246082219d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -568,6 +568,7 @@ struct mlxsw_linecard_device_info {
 	u16 fw_major;
 	u16 fw_minor;
 	u16 fw_sub_minor;
+	char psid[MLXSW_REG_MGIR_FW_INFO_PSID_SIZE];
 };
 
 struct mlxsw_linecard {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index a9568d72ba1b..771a3e43b8bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -87,6 +87,27 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
+static int mlxsw_linecard_device_psid_get(struct mlxsw_linecard *linecard,
+					  u8 device_index, char *psid)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mgir_pl;
+	int err;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index, device_index,
+			    MLXSW_REG_MDDT_METHOD_QUERY,
+			    MLXSW_REG(mgir), &mgir_pl);
+
+	mlxsw_reg_mgir_pack(mgir_pl);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgir_fw_info_psid_memcpy_from(mgir_pl, psid);
+	return 0;
+}
+
 static int mlxsw_linecard_device_info_update(struct mlxsw_linecard *linecard)
 {
 	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
@@ -121,6 +142,12 @@ static int mlxsw_linecard_device_info_update(struct mlxsw_linecard *linecard)
 				      linecard->slot_index);
 			return 0;
 		}
+
+		err = mlxsw_linecard_device_psid_get(linecard, device_index,
+						     info.psid);
+		if (err)
+			return err;
+
 		linecard->device.info = info;
 		flashable_found = true;
 	} while (msg_seq);
@@ -293,6 +320,10 @@ int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
 	if (linecard->active) {
 		struct mlxsw_linecard_device_info *info = &linecard->device.info;
 
+		err = devlink_info_version_fixed_put(req,
+						     DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
+						     info->psid);
+
 		sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
 			info->fw_sub_minor);
 		err = devlink_info_version_running_put(req,
-- 
2.35.3

