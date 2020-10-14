Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCE228DF32
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388247AbgJNKnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730146AbgJNKni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:43:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C81C0613D3;
        Wed, 14 Oct 2020 03:43:37 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w21so1551811plq.3;
        Wed, 14 Oct 2020 03:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k9YX9rQZlgFAfivrs5grc+B9grYX9g3LqejLDIU/3NE=;
        b=nNzeEZfx4U63s4a3aMcwaBwgz9rq54PcoKizd7b+yAmy9zzPHqnMHBUXQCw7Fpzi5s
         u1+ULJIkTk1G2qciIbujRxiUL5aVmO+twyJ06OlN1HyGaYeTwdKrTFCOXk8evf2t/fV4
         ITMEAeG6Pf7atn9rLmNCgTYyATkQxTrN5y7NEBvgIjQPvpVLmRNztZncbjnYioczz/Ly
         e/XowHPwd7sCccGYGMuhmQepTjVZnDJPckpyLZOHx0N99J7TWScikJPoUNYliLRLZzhk
         AsL1+jD7Echb6Q4/V8IeAjOrP4q7o4xGMpb1u7xk4QF7Z+TAg++3DqriXrwa9c+rAKGg
         hmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9YX9rQZlgFAfivrs5grc+B9grYX9g3LqejLDIU/3NE=;
        b=cF9l3IFmexJI+xlcPF4reV8E8Duy+TnjmDGQgpdzb6APTsFpMRX67Y+tce+0grsaPE
         4Tj7aEYcN1Y0m+9299X0K6L5u4/uy6oh0HqXmZfEKXPxS/Q1j1Nwx0OIynEgtJ9d5old
         g4KL7sNijcu/vrHy7b4ZMWrbK5o4KtpeKBy7DNIDyOlPwf2J5SJMt8DloZgZDmRH2H42
         Qo5EM1e9VWI73QBZ3DBWEV9+GaJUzhvUiOnvjOGlnlvs0dBx7iENW790bFjAHQMNuKLp
         peK7v1BuEmEe/pKWDf67/MzsphkoDeao9KaBGNO50oU11/rdhvDixMaK9fC9DAa4U8Jd
         7xSQ==
X-Gm-Message-State: AOAM533B7O2RUTAprifDy/v8OmdsylEd93QIb7bbMTRqa827w1f/tzNH
        8ytnSgiv0kDq0MWfP8aQPBWd7p5FzCEjrGno
X-Google-Smtp-Source: ABdhPJzRhCPIvE3jJwwWVGdoAh5p7xUXUFQJKRU8+V2GHrmjmGUGK8ebA9Wbm+XZ7n5yj/7dlTumTg==
X-Received: by 2002:a17:902:a5c6:b029:d3:8dc1:5240 with SMTP id t6-20020a170902a5c6b02900d38dc15240mr3761125plq.16.1602672216661;
        Wed, 14 Oct 2020 03:43:36 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id bj17sm2545488pjb.15.2020.10.14.03.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 03:43:36 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/7] staging: qlge: support force_coredump option for devlink health dump
Date:   Wed, 14 Oct 2020 18:43:03 +0800
Message-Id: <20201014104306.63756-5-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201014104306.63756-1-coiby.xu@gmail.com>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With force_coredump module parameter set, devlink health dump will
reset the MPI RISC first which takes 5 secs to be finished.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_devlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index b75ec5bff26a..92db531ad5e0 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -56,10 +56,17 @@ static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
 
 	struct qlge_adapter *qdev = devlink_health_reporter_priv(reporter);
 	struct qlge_mpi_coredump *dump;
+	wait_queue_head_t wait;
 
 	if (!netif_running(qdev->ndev))
 		return 0;
 
+	if (test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
+		qlge_queue_fw_error(qdev);
+		init_waitqueue_head(&wait);
+		wait_event_timeout(wait, 0, 5 * HZ);
+	}
+
 	dump = kvmalloc(sizeof(*dump), GFP_KERNEL);
 	if (!dump)
 		return -ENOMEM;
-- 
2.28.0

