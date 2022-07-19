Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE9D57936C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiGSGtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236271AbiGSGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E4E275D9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:57 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x91so18313045ede.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rBW/mHE7+MoeZ57YrYfHenG64+IQ0+DrLZq0P9J8Rps=;
        b=fXHVGP/9F/5M1aMIa9bKpecoZZw/fzWVngXq1O5BUge9LV6yGMjDANQh0p2I7Rb+OA
         VtfcbYGt/N8uo4bQPfnwNGiSzbKqW1ial2HKtKJqQmM5Dgyk7gr0Dn87L+y6s1AsFqzO
         h5fLcowP4Kc4DkD9rG61ktgNd6zc55uM7B3DZJ7nO4p61sueqdEN8dRUp/Pt8l1/Ui/t
         tBE5Cxm9Sav6udrxlB2TdCM2ozp6Q/9t1tV4NWj3BwDci8Jbbg2JDlwgJS2U33W/S4qt
         z8b9pYjSU0Y2NCzjeFJdRyi2XtA6hiqFH7tEcwarWq0C5lhaIF2yDJSp2LA5sQmFs46C
         yH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rBW/mHE7+MoeZ57YrYfHenG64+IQ0+DrLZq0P9J8Rps=;
        b=QDOJJmzjFEz6sjg5RflONx7gdDtSz6sMA/0tj0aJLEMwiazB37HCAIitFmklPI1x6J
         jIOfhVRwYqkviGqLU6FQrhY431pgvk3OvY5nGTxZtIQL7CwlpzOLVx143SXWIa+i4xHC
         5owPi8i+li2O1VqcHJIQIC0vdIgN348U10QTcOS0I9qc3wQOWKG12uPvRO4HdpmI0BG7
         dByWSqqvRuHkYZb52yIxWqryprDa5lp+sXjXDi/4ELNAggmOSMfPUe24HI+w9JIQG68c
         7bSp5PulEPcWHZy52yVYULBJU4y3dW8oaSFNi5Kd1UEC7lp7jeEQ+BhFzGZ1XfHg7gzP
         7VeQ==
X-Gm-Message-State: AJIora9NqqE/oEDI20uVh1Bw+2y0OYHfB+6fkUbpzeLa7KKdkXYin8b3
        XzzgWMpQnVTpQcZFLOsfyAQoVXNhdWcOA3sMs/o=
X-Google-Smtp-Source: AGRyM1sSWVtpkGoYbBAhIAjiZUsDKL8Zk4oyLR+RgqK4SyUy4QhemWNBUJtDzyxR8cIc8D6bM6pMdA==
X-Received: by 2002:aa7:cd64:0:b0:43a:4d43:7077 with SMTP id ca4-20020aa7cd64000000b0043a4d437077mr41912144edb.302.1658213336061;
        Mon, 18 Jul 2022 23:48:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m21-20020aa7d355000000b0043a7de4e526sm9941080edr.44.2022.07.18.23.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW revision and INI version
Date:   Tue, 19 Jul 2022 08:48:40 +0200
Message-Id: <20220719064847.3688226-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
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

Implement info_get() to expose HW revision of a linecard and loaded INI
version.

Example:

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
      running:
        ini.version 4

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/mlxsw.rst    | 18 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  4 +++
 .../mellanox/mlxsw/core_linecard_dev.c        | 11 ++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 28 +++++++++++++++++++
 4 files changed, 61 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index cf857cb4ba8f..aededcf68df4 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -58,6 +58,24 @@ The ``mlxsw`` driver reports the following versions
      - running
      - Three digit firmware version
 
+Line card auxiliary device info versions
+========================================
+
+The ``mlxsw`` driver reports the following versions for line card auxiliary device
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``hw.revision``
+     - fixed
+     - The hardware revision for this line card
+   * - ``ini.version``
+     - running
+     - Version of line card INI loaded
+
 Driver-specific Traps
 =====================
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b22db13fa547..87c58b512536 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -599,6 +599,10 @@ mlxsw_linecard_get(struct mlxsw_linecards *linecards, u8 slot_index)
 	return &linecards->linecards[slot_index - 1];
 }
 
+int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
+				    struct devlink_info_req *req,
+				    struct netlink_ext_ack *extack);
+
 int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 			 const struct mlxsw_bus_info *bus_info);
 void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
index f41662936a2b..d0ecefee587b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -97,7 +97,18 @@ void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard)
 	linecard->bdev = NULL;
 }
 
+static int mlxsw_linecard_dev_devlink_info_get(struct devlink *devlink,
+					       struct devlink_info_req *req,
+					       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_linecard_dev *linecard_dev = devlink_priv(devlink);
+	struct mlxsw_linecard *linecard = linecard_dev->linecard;
+
+	return mlxsw_linecard_devlink_info_get(linecard, req, extack);
+}
+
 static const struct devlink_ops mlxsw_linecard_dev_devlink_ops = {
+	.info_get			= mlxsw_linecard_dev_devlink_info_get,
 };
 
 static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 43696d8badca..c427e07b25dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -226,6 +226,34 @@ void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_linecards_event_ops_unregister);
 
+int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
+				    struct devlink_info_req *req,
+				    struct netlink_ext_ack *extack)
+{
+	char buf[32];
+	int err;
+
+	mutex_lock(&linecard->lock);
+	if (WARN_ON(!linecard->provisioned)) {
+		err = 0;
+		goto unlock;
+	}
+
+	sprintf(buf, "%d", linecard->hw_revision);
+	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
+	if (err)
+		goto unlock;
+
+	sprintf(buf, "%d", linecard->ini_version);
+	err = devlink_info_version_running_put(req, "ini.version", buf);
+	if (err)
+		goto unlock;
+
+unlock:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
 static int
 mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 			     u16 hw_revision, u16 ini_version)
-- 
2.35.3

