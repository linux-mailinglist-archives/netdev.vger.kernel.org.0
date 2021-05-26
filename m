Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F13391546
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhEZKre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbhEZKqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:46:55 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C4EC06175F
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b191so448487wmd.1
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UO8qXeTI5vIof7LVbrpbl2mgOXFAY5ipdpSrVB5EOpc=;
        b=J4d0oFgj7hxAogPyfcoDW0q2lCGwbNKgBBe8TQtVmbqT4pXn/iMqFmEO3Ht/AVm7JO
         KwXFVqTbQuPH5jfEbZ0pqIk/V6JRSWpqjwLs6eljA3gniHBSGwL2Vf40P7z/+ilIlfq3
         tfTrX4PK+FQVBwUf/yuqw3olvUaZYs2yWl3blpPd8lKhpi27zqb/c0DYZTdQg8ZIuuys
         TrAhZ1rDgdRV495Qggiq5jvTmR3k79uFHeyLXwPnKjcntoVBmlP4cdyFTWZJCwKPBRrf
         GMgQqzJcg1AAhQ/BnuBNirPyq2DZyeWWgMj+AEENtzbBICYkm9Dvja0z/5oVfMSGejnD
         FPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UO8qXeTI5vIof7LVbrpbl2mgOXFAY5ipdpSrVB5EOpc=;
        b=S1n9096vM2NMARM6Zj8wFVYk2liRPPaw1ks4R4E9FF8s6X5bvgJUz+ugqwAb8bYC79
         jlsNBCD4WOSY8q4H9H6VctCBEz2S5Vgok42EXMzMiuzW6FUtU5xE+dnaqNEn/079AcUm
         nYXYIqXHXgZZHrceky4f0Afe9yhtZlujf6m7+Fan9Y+9uZfcJWLUHHbiqrkRhIBq8Af/
         DGAH3BLAgTQIulFGe415fD2Z4GsmSMJzu6SgnSDdsWj0iu5ijuIHhSsoQv/x5AwhYfd+
         pnhRFNvXG1c7sdG1kZyl3TkVMxegCMBCkva/yWcf9u7VLrOA6PZ1Ntqmbe+JzUmq9HJd
         SDbg==
X-Gm-Message-State: AOAM5317ZTt1dK1wueS1KUSTl+ssXJybm/d71g2RHHA3OFOqjHkFURAS
        9o/hUqqyLutnWvObfYlJDQoFfuM/m6/FSbMAwp8=
X-Google-Smtp-Source: ABdhPJwysX/kCczr3vlpyAVQF0+SlnH3E6YJIJxWafQDFcAGo8GvkCe3Ghu52mipb4nQ8okrNVWvtw==
X-Received: by 2002:a05:600c:2dd7:: with SMTP id e23mr2762968wmh.186.1622025914135;
        Wed, 26 May 2021 03:45:14 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id z12sm19376883wrv.68.2021.05.26.03.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:45:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: [patch net-next 3/3] mlxsw: core: use PSID string define in devlink info
Date:   Wed, 26 May 2021 12:45:09 +0200
Message-Id: <20210526104509.761807-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526104509.761807-1-jiri@resnulli.us>
References: <20210526104509.761807-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of having the string spelled out in the driver, use the global
define with the same value.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index b543d4e87951..e775f08fb464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1444,7 +1444,9 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	err = devlink_info_version_fixed_put(req, "fw.psid", fw_info_psid);
+	err = devlink_info_version_fixed_put(req,
+					     DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
+					     fw_info_psid);
 	if (err)
 		return err;
 
-- 
2.31.1

