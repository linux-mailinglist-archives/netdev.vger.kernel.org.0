Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B604166F27
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 06:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgBUFYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 00:24:52 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37903 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgBUFYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 00:24:52 -0500
Received: by mail-oi1-f195.google.com with SMTP id r137so473044oie.5;
        Thu, 20 Feb 2020 21:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/k1sZ+cnmOUANpT53mM2H5yfgMY19H5epCa2pIy6TU=;
        b=HBd4QMBcVXIf55/hE9c/wiNETb99mXC1ejXxvSxH4yfwxEfPXNsnJ1UV9I97pNluQS
         bmhdUz46epWDZJav+GITaDud6DkLzyb17bWvJxNuUzi43JGaI5ihh0lXlFnWt9Ihqr2N
         0LUWssAJqSfJ3gWxROrSLGYKEkp3KPtgcBPE5VJYbpEFgt4J1XtFbfaahG7WMBTwhP6n
         4yDcNYj/F7AqEZf52K577MuFYTPhZ+DAOX6Nw5SK54fY/4vgJHhJazqgaOvjEL6vjKO7
         gHkHop7dVAJHR3CWvew4cEsS7uZhmkx7644Yf39qRI8Q9IvNWbM0jT6wPxyWBHkUFdu5
         DPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/k1sZ+cnmOUANpT53mM2H5yfgMY19H5epCa2pIy6TU=;
        b=MLtUS/pZpjBD+4XWRD1TF0EyIvmRA9uGm+wYmC8MysXaIykvuTNGVJTorbS0tChiC7
         SZ3Iz9HHFzQkSgUWU4x7lk9wm68jpRJcdsFzNJxbIoL08l7+EM28sbq+F91Qx69vyu9w
         Ehd0PhYsB79ck+jzPFfJx7FxRNbg6rifjLj/4TFDqfw+Y/rXjj3Tp+Yrjf5P1AUvPayM
         Ott14uL+istK9oPV8EyRJ/iRD3mnmBBmmVwNo7zwa7eK9eRm8D22eShRUCN2qt7b31w7
         VsV7vLYZbMBRWc6ycK5rZkvsKCsqSxozMHHR7UCO6FcBeXAT/5EDcitKwzRoU37zWTzL
         wASg==
X-Gm-Message-State: APjAAAWJtKG80lLGWVSOPXRKMDkFX0nQ0DjGYo95LBV71cxYB6tevV5L
        Y8aMVkXGZDgghwmOo/Gzwvl2sFmnU+Y=
X-Google-Smtp-Source: APXvYqwvfB6MwrssVhb4WD21BdS03tdh97HJpq0IW01xj307MOXolcQaSO2bmc2/TWKtfw+kq3KT3w==
X-Received: by 2002:aca:4a0b:: with SMTP id x11mr582391oia.37.1582262690999;
        Thu, 20 Feb 2020 21:24:50 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id i2sm661408oth.39.2020.02.20.21.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 21:24:50 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Aya Levin <ayal@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] net/mlx5: Fix header guard in rsc_dump.h
Date:   Thu, 20 Feb 2020 22:24:37 -0700
Message-Id: <20200221052437.2884-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

 In file included from
 ../drivers/net/ethernet/mellanox/mlx5/core/main.c:73:
 ../drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h:4:9: warning:
 '__MLX5_RSC_DUMP_H' is used as a header guard here, followed by #define
 of a different macro [-Wheader-guard]
 #ifndef __MLX5_RSC_DUMP_H
         ^~~~~~~~~~~~~~~~~
 ../drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h:5:9: note:
 '__MLX5_RSC_DUMP__H' is defined here; did you mean '__MLX5_RSC_DUMP_H'?
 #define __MLX5_RSC_DUMP__H
         ^~~~~~~~~~~~~~~~~~
         __MLX5_RSC_DUMP_H
 1 warning generated.

Make them match to get the intended behavior and remove the warning.

Fixes: 12206b17235a ("net/mlx5: Add support for resource dump")
Link: https://github.com/ClangBuiltLinux/linux/issues/897
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
index 3b7573461a45..148270073e71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #ifndef __MLX5_RSC_DUMP_H
-#define __MLX5_RSC_DUMP__H
+#define __MLX5_RSC_DUMP_H
 
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
-- 
2.25.1

