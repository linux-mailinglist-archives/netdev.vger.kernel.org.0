Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7716990A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBWRbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 12:31:50 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38878 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWRbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 12:31:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id t6so3028846plj.5
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 09:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=6dGIVo3UjYXXlVZT0JsSFZVfq9hKCePvJYVI5H5zSQo=;
        b=YFAQUHVf0zt2MyAZu8lM7gR31cJMlyX3gRQMJY4BGR4+Mswf1dI2bGkInLnMWyhcd9
         IyG0rJdifSJViR8u76TSRi0GtlHnoveVNMJ2BfpC1Mg9RwSMs0yvhUI5jJkBhvbYuZvY
         R2E6Z5xWCLNE7XB4Xn6SAF3ENAurHPn96gjVpoU+3zJJvLA8r4cb8avrIFKTAoTwVj9M
         EOGWNljgRdFdExU0MmXpGIyZ5mSPyfRccUxUvqE2nT6643BIb3++Jp/KBnqllEhmsSQ0
         ghG5XZ8q+Ly9u2d5D7dCpy+r2nMSuRO2BHFxGubYrcJCWzYI3UCSj6vxwoHrINAkqWrg
         kMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=6dGIVo3UjYXXlVZT0JsSFZVfq9hKCePvJYVI5H5zSQo=;
        b=f70x58vKl5rWF0/gYWnh8SIWEJKX3YhgdDG2zpqegQ4tnDKYlbsqomZ3IVFjrfOvBv
         brsSTCIGNNmENiTph+WUFXNfm3YobWB3Y/ZljkqZvqWl7IseijkLUfdabm4GLk45RzZg
         iFoQ0Dk/+ByVIdZwqnFulsK5Ks2D3nW4qRKYwuHdoSE78SS4H9BYawW4oAthQB1TTX/7
         NIfyuuGaLh5omGL+22ursRBisuaAVbjdsVhBv7d95hbq9dO0PgqiFrcY4/hLEvpnEeRK
         GHAZqww8+qajC1ZWg6AvOMqhqyldKTG5CXG6cGqI+mMfv/4GZXTW86uhRUVHW18Ny8KN
         V9lg==
X-Gm-Message-State: APjAAAX+chvs+Hf+NDvKmtmS9gHZ79UmXr3x/xrdO3az/5sDjBF1KwSr
        Vc7q7/HDRvHGcG4e8Oll26hRuUtIH8TUQg==
X-Google-Smtp-Source: APXvYqyGBBa7ZW0D45+gTA7LVysPbChpy5fRDtiGdXslH4WVte23Qpr+iojvcMjWyPXg+SI34n23Cw==
X-Received: by 2002:a17:902:9308:: with SMTP id bc8mr48071753plb.268.1582479101749;
        Sun, 23 Feb 2020 09:31:41 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.179])
        by smtp.gmail.com with ESMTPSA id l5sm9030480pgu.61.2020.02.23.09.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 Feb 2020 09:31:41 -0800 (PST)
Date:   Sun, 23 Feb 2020 23:01:32 +0530
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] staging: qlge: emit debug and dump at same level
Message-ID: <20200223173132.GA13649@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
instead of existing functions so that the debug and dump are
emitted at the same KERN_<LEVEL>

Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
---

changes since v1: make code of ql_mpi_core_to_log() simpler.
changes since v2: directly call the function instead of defining a
macro.

Also, can you please help me understand how are are numbers 32 and 4
chosen for the function print_hex_dump()?

----
---
 drivers/staging/qlge/qlge_dbg.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index c7af2548d119..44fb3a317b8d 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
 {
 	struct ql_adapter *qdev =
 		container_of(work, struct ql_adapter, mpi_core_to_log.work);
-	u32 *tmp, count;
-	int i;
 
-	count = sizeof(struct ql_mpi_coredump) / sizeof(u32);
-	tmp = (u32 *)qdev->mpi_coredump;
-	netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
-		     "Core is dumping to log file!\n");
-
-	for (i = 0; i < count; i += 8) {
-		pr_err("%.08x: %.08x %.08x %.08x %.08x %.08x "
-			"%.08x %.08x %.08x\n", i,
-			tmp[i + 0],
-			tmp[i + 1],
-			tmp[i + 2],
-			tmp[i + 3],
-			tmp[i + 4],
-			tmp[i + 5],
-			tmp[i + 6],
-			tmp[i + 7]);
-		msleep(5);
-	}
+	print_hex_dump(KERN_DEBUG, "Core is dumping to log file!\n",
+		       DUMP_PREFIX_OFFSET, 32, 4, qdev->mpi_coredump,
+		       sizeof(*qdev->mpi_coredump), false);
 }
 
 #ifdef QL_REG_DUMP
-- 
2.17.1

