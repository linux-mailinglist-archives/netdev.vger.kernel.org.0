Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAE1EE436
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfKDPuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:50:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39393 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDPuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 10:50:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id t26so12511827wmi.4;
        Mon, 04 Nov 2019 07:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SkDHTTRlQ/CZrGDi0TAIeTRHauM7VQ2avf6fHxmDcKE=;
        b=PNzfdmXKbmry9AGkoaUjak8TNHUzEXH2hZyHtDQPsq/6TkxtYgliNWcJNgHN3AoFl1
         Slm0CVLfmWfmjqCIGXtYUig8kuBojM9cCEL5q5zsOgytsSAmGUPSHd9g4RzSKA1FIx5g
         4sRR/CbamUi97NIFL0K2LkgdvmacFL9gQiDbcQlbHK212nk+1ABCrYcE6q4l+1cgc/UU
         z61BiyTVqO9xIdgqKmXoQWcIL/mogB63GF+6dO/a4yDiV3WitfqjLbOkIuhgiDd5cl3F
         oR0i4HhZMLgbsKJfb6I6F9gg/53VpihSlAoaKH3yAHXhfYLz/FRYiUmiaXnjfAEJOAwp
         Vxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SkDHTTRlQ/CZrGDi0TAIeTRHauM7VQ2avf6fHxmDcKE=;
        b=Z9eWcBJF1WzSuq2aYYLKag3un2m9I1Zq48y2wIOigPT3+O7I7bQNA3nP8tDNDy+FIG
         Ly5LVjIUdIwYi6V4L5gaa3AhQV20N9hIwUlf4TpfN0HCAR+FEJlV9+whVyf2IPHvF612
         0z8P7YQNY+QG9EuRf+lGy2CTn1dY0eb1uOr5biyJjhQ2DY+OW2X1a4YzRTaJIBQ+HCxT
         0OLPVpnflw4Mn69OlqifVDjXLAybYRc/zJdAV0G1AC8CUYZeIfsyY3zW7bvMLOS5wsYj
         U0IWW3kQII6eCneOuA1VfZCtFgfTiZzANazFNhmDFkC5A9poPFQNqqtCQZkJRgRY5MaX
         gewg==
X-Gm-Message-State: APjAAAXJMnlLdTAoYHqHjx2QaxaMGGHJQ6EjCMjpJWBkt4TEfqokHAR1
        +9sKq+mtob9niub3bltj58/4og1XURI=
X-Google-Smtp-Source: APXvYqxOAG7JaysBKhL3FMGHmQL2xM2hlcnC/n92i52MFUZMghRgkrRVDUZbYeEy4tOc4zB70umyjg==
X-Received: by 2002:a1c:b1d4:: with SMTP id a203mr2349544wmf.160.1572882610396;
        Mon, 04 Nov 2019 07:50:10 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id d11sm20513135wrf.80.2019.11.04.07.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 07:50:09 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: fec: add missed clk_disable_unprepare in remove
Date:   Mon,  4 Nov 2019 23:50:00 +0800
Message-Id: <20191104155000.8993-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver forgets to disable and unprepare clks when remove.
Add calls to clk_disable_unprepare to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 22c01b224baa..a9c386b63581 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3645,6 +3645,8 @@ fec_drv_remove(struct platform_device *pdev)
 		regulator_disable(fep->reg_phy);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	clk_disable_unprepare(fep->clk_ahb);
+	clk_disable_unprepare(fep->clk_ipg);
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-- 
2.23.0

