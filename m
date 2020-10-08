Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBACF2873B4
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgJHL6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgJHL6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:58:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55538C0613D2;
        Thu,  8 Oct 2020 04:58:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so4080474pgf.9;
        Thu, 08 Oct 2020 04:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KQzCKemZS/RK2g3GQ9qxoMzKSIZg3RP0p33btHevshs=;
        b=ceqBsCnf9PxKBZZRJV18dvuuUVKgkIHBsg+3ZK5fULT6K0gDyopsAgvBDPcusREsHA
         KJMT5k2DLduQ9uWfxdP+VWcGvZcsSjK3vy//E9bmx0Uuno0DA6CIyJgJz5VD+rYolf12
         KV5cwWFPYhDZ/6/TgrrXlqQWKZDImd//ox8+TAA3RsdIXpkGQKNo/jtTDb1XxvYu9qGh
         mmZjwxhGfNu+bLR7G5j0wleTkpneESiabQdBbYthFQ1kQOGPuWxU/2/5PPmPr/i4X3cz
         OOiuSHT4f7yyejbl+mQ5fqDl+NIeH19c6sQNBfU7+28/O6Zktr8Z2Ls0Y46/JUQj1+Gf
         QLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KQzCKemZS/RK2g3GQ9qxoMzKSIZg3RP0p33btHevshs=;
        b=s+6bj+VPq4OdEjRPsM4koiF7fxnEugOss0U6rhUkfLua7xNsEJAsL4O6MyFqq69CCa
         WowzsS/H9XjgZOoygGJkl6v3r92Uz2+ojG2fqmn5WbBABeYEqHDb43eNo8MFfuaRBGRK
         zPu6BJkCkgnLZsYUWIQea46Lscban7GMQ03/Z1ltVdCeL/u4MCNp1h+z6UvEmHBgbOL/
         q14/Bb+Dgn/fsL5hz9gP8MF0ETpI8DjkY3hDPH5JSpOj+eQ4hqNv7+yDPX886fg/GZH4
         Ck8Dfv8c9YFUlnrpwCjsLstNg6Amy5JrgmGnftQlaNYponzrLEmkvqp2nlxIvl9j3Lhv
         79ug==
X-Gm-Message-State: AOAM5315YOKxAnSwuuP6NRugGAVS3LFvaE+keo2pFvE5KO4hvByRV3BO
        oGRrHdbfh5+q/V8Ni03xIGs=
X-Google-Smtp-Source: ABdhPJxAkUUxk6Bx5wTttze7DKUa4yHhg0poALtcyr+CH1TpoqzNICh0YqiD39MBSldIMWMhyOedXA==
X-Received: by 2002:a62:7a53:0:b029:152:5482:8935 with SMTP id v80-20020a627a530000b029015254828935mr7409775pfc.31.1602158312899;
        Thu, 08 Oct 2020 04:58:32 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a1sm6676712pjh.2.2020.10.08.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 04:58:32 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/6] staging: qlge: support force_coredump option for devlink health dump
Date:   Thu,  8 Oct 2020 19:58:05 +0800
Message-Id: <20201008115808.91850-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008115808.91850-1-coiby.xu@gmail.com>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With force_coredump module paramter set, devlink health dump will reset
the MPI RISC first which takes 5 secs to be finished.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_devlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index 91b6600b94a9..54257468bc7f 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -56,10 +56,17 @@ static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
 	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
 	struct ql_adapter *qdev = dev->qdev;
 	struct ql_mpi_coredump *dump;
+	wait_queue_head_t wait;
 
 	if (!netif_running(qdev->ndev))
 		return 0;
 
+	if (test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
+		ql_queue_fw_error(qdev);
+		init_waitqueue_head(&wait);
+		wait_event_timeout(wait, 0, 5 * HZ);
+	}
+
 	dump = kvmalloc(sizeof(*dump), GFP_KERNEL);
 	if (!dump)
 		return -ENOMEM;
-- 
2.28.0

