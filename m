Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780AF2904BC
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405327AbgJPMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394872AbgJPMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:07:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24177C061755;
        Fri, 16 Oct 2020 05:07:40 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n9so1318268pgf.9;
        Fri, 16 Oct 2020 05:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k9YX9rQZlgFAfivrs5grc+B9grYX9g3LqejLDIU/3NE=;
        b=UBZlJQcLl8KIAaleSLUZoq9dzHobnVdKwnlUnrvqBAXZFd6tgbqaaeYXV3OfuVp49y
         W4ivySVoE6TeNC0vKGUQXVG4HzLGUrlkCYtsm3ejmB//882+6+B4mNRr3zfwv+mvte+B
         H7agIxT6E3KY0l/KoReAkBoU/tScGCY71NN+zaqm2HZWvR0aA8ohVzFPfQBRQH3bZh4c
         hLSueNFeS0htFAMZkgkmSnMIpumV5SVrq+xkakEbPhcT94pv86BoAAuDi/5Rd27+HsqE
         wK6OOgLhc24+C3+dnwpKMUP3pkuZkpZOUsCGM6P4Eu8l/vZwy7UnuzBs5JGbJvqmZkUE
         sYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9YX9rQZlgFAfivrs5grc+B9grYX9g3LqejLDIU/3NE=;
        b=AKic2bbEmPWKY4Tt4Mg/89LDVfDK4vGNGQd5bF+bl4l5opYOdaD+4bHJjcXghB11iX
         dglf2hbUF2P6sKXR32QjfDmAd3hl5owq8AbD1kW0XOQt6WksgHOAcCZ4d8fPc1NSWQ+2
         HUB6u+1juG8RAa4S2gsRdWS6NVptbhItWz+XUVcjPaOGwkeXEdncis3FvpKQxcqeDXqy
         6pfMAsYlvGd70DbyAg/kolS1FhfeU54ZPdORMQOuCKIwBTxXKncoqHSZq2r2IkYBFC9c
         LgpEXF45JRTqII/W5AfKTiKtV/pqbd0YpMNDpQtVRFsQ6nwEANehNbyaAhWKBKxIPBp/
         zVNA==
X-Gm-Message-State: AOAM5311oa8M4RoZ7GBZD8xx+NOMyA0wfkfd7nPKjgh3LQfPXdmm1X1Q
        C82QvNXNqwkGwOBp9Sp1Ziw=
X-Google-Smtp-Source: ABdhPJyKcUGNc0tmqSEhPxCwTLLLobMo8LJCPW/z+CN9zqvSxG4H64w64PWRhtVQo+p1ewLPIFrkXQ==
X-Received: by 2002:a63:a505:: with SMTP id n5mr2744545pgf.71.1602850059671;
        Fri, 16 Oct 2020 05:07:39 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id z20sm2721045pfk.199.2020.10.16.05.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:07:39 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 5/8] staging: qlge: support force_coredump option for devlink health dump
Date:   Fri, 16 Oct 2020 19:54:04 +0800
Message-Id: <20201016115407.170821-6-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016115407.170821-1-coiby.xu@gmail.com>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
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

