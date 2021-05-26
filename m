Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A8E391544
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbhEZKq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhEZKqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:46:45 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EB3C061756
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:12 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id f75-20020a1c1f4e0000b0290171001e7329so235885wmf.1
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qx6PS7vv9BdHEZk2SlW5DW9gwzNfpE0BrouErYikb44=;
        b=TwIZKUD9ySANv+nClIf/hOWOllt41xd7aj5y64toEY5X2ARjXlwFCjSWmXTghIsjWo
         IYzrJMzxDAhOqYQLClHWOmHJRqVomzYDGaqbcJVXpaWCNYcns5ko1COA9vX46le6Wlo0
         04Mnrzxxtlf80PbkzAUppF5XOkVDhcXVqOc4UAivpNqmUG4pDveYceASpTHEtPFh95d+
         BAHg4DsC3Aynw4JRXD/ZVJXUSALYhkhFHOSnQIFd83z/laByU0bDuYfMfX6LJcJV1be+
         etAeclGDRnaQj3SCBvF/oIYjfyoRGzWo/csH0jud44VvseYWqUb7m9/rv8s9YPvVPFxs
         LGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qx6PS7vv9BdHEZk2SlW5DW9gwzNfpE0BrouErYikb44=;
        b=cB/7T9ISS6KMW3WwzDkIYtTy4/m/KNMW9occ+cAdzuAPvkhMrQHRgTW1JaXaSzOfCO
         JR+WZxmGLgnk8Kzvvhhz+rFOLpxGCsT5LHpM/+Kzm3sgqTSQ4pD4WAE4zDNqq5BUZgnN
         dstuhBRHWYLwAnc0g0hd2mqaAjk8ZruOzn6/Qt9rOPyQsj0dKoAfFNMG12mgSX7ZP3ka
         W3Oj0V4+Kl7e2w1CQUHAtwh+nkY4sLQZO1EpdggfQyATyBIvAJi5O5QJr8TA/SuBJK87
         KoqzcP0ljgPfhTY4zQz1K3Tik+Er49V0VV6cQYiCivHzO8q0fok14sZPn3w0BJT3WVP6
         Xi8Q==
X-Gm-Message-State: AOAM530i3tayqiFu7aIYsCGp1w1XPPwzL/tTI1T9vpnhqrzI96e60ECc
        VRA9uHmq0t0yHs6alfTJ9tpb0djzDE0fhV4de6o=
X-Google-Smtp-Source: ABdhPJyHqACko8Jwde+17YtGOJXTSgQMNkHiQ8rMbItYxB0gjD9uiV4fOQqn/uoz4fJBS8ttMnothQ==
X-Received: by 2002:a1c:6644:: with SMTP id a65mr27427799wmc.103.1622025911606;
        Wed, 26 May 2021 03:45:11 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id z6sm14472360wml.29.2021.05.26.03.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:45:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: [patch net-next 1/3] net/mlx5: Expose FW version over defined keyword
Date:   Wed, 26 May 2021 12:45:07 +0200
Message-Id: <20210526104509.761807-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526104509.761807-1-jiri@resnulli.us>
References: <20210526104509.761807-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

To be aligned with the rest of the drivers, expose FW version under "fw"
keyword in devlink dev info, in addition to the existing "fw.version",
which is currently Mellanox-specific.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 44c458443428..d791d351b489 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -63,6 +63,11 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	err = devlink_info_version_running_put(req, "fw.version", version_str);
 	if (err)
 		return err;
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       version_str);
+	if (err)
+		return err;
 
 	/* no pending version, return running (stored) version */
 	if (stored_fw == 0)
@@ -74,8 +79,9 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	err = devlink_info_version_stored_put(req, "fw.version", version_str);
 	if (err)
 		return err;
-
-	return 0;
+	return devlink_info_version_stored_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       version_str);
 }
 
 static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netlink_ext_ack *extack)
-- 
2.31.1

