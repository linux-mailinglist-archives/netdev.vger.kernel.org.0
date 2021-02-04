Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C1130FFC2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhBDV4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhBDV4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:56:15 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F23C0613D6;
        Thu,  4 Feb 2021 13:55:35 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id z22so3597714qto.7;
        Thu, 04 Feb 2021 13:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TpNR/qUQzjMgrNMY8WiD0ezGe7uykjtuTLC9thjn8a4=;
        b=RNpwBclZVwN9RxcPCe+47atq297vQ3yjHyfe3aRBa0mPQyIzbTyjxaQLuP2D35m1HZ
         aHLGzjzAiiItFIkjqEbKdKfcoofm5NnPSCK9xY0em2J1NLgx1YGFwSFutZcO/4Ex7796
         U/WCHURkUYWOOrLYgnIzL0Cn1zTF5RbGEEqENiyXG/fJER1YJPUtq16vqJa67Rck5Ql/
         GrqL03lMn3kbGbKMMpLQp+V1ws74gKDpRub9eyN4ky0E+DuXiiC5lOCZf0fTAaAthSvZ
         RsQLKLRRkGRKCh9ZOlkq/+3xcFKfR3C0bUG2stT3yg7To/6QPy18i7+9/asarXLnMFlp
         dBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TpNR/qUQzjMgrNMY8WiD0ezGe7uykjtuTLC9thjn8a4=;
        b=bvBjvTcjtKQ5nMhImSWB9dbMUvHhaoid+jE4BONIKUiICpLSDxQ9hpqnjTGK/tvl8J
         RN+HSpYGtKBnwBiOrgr5Jl0BLCyFOJQqQedd1lvdqr/g60veK+sYMDoKd9Wd35ioQnBX
         rmZmRrteFe5uoD3j4g8XnNdTn2S3hAAFB7+dL5DCwM8Ivvu91gM3yX7RoGai3E79lw/q
         RffSguzZAVMfIdihtHmfSSW9G+JiZOYv98WKkh5FaIFXRRrEsVXBLEjJbEfS0K+hA9rS
         w934hNpBslXuwHAlmFb9Y+w8qQ9AB5j+4MEtn0aNx0aVft97lVE5kaEET72ZnYBG95e+
         UM/Q==
X-Gm-Message-State: AOAM530t93wSX5ynEl6QCtXFVRlYk3Iog3w0kRptUDQS7ilwyf7DqGou
        kQWq+68QlN8CIKNI4HmqmEA=
X-Google-Smtp-Source: ABdhPJzlpDuhn/mJzhWCfkUnpQCI85+erWHahrbX/wavXQ+zIuymbwaFTRyApeqeHTmTBEzDIL8QKQ==
X-Received: by 2002:ac8:5995:: with SMTP id e21mr1665445qte.294.1612475734577;
        Thu, 04 Feb 2021 13:55:34 -0800 (PST)
Received: from localhost.localdomain ([45.87.214.195])
        by smtp.googlemail.com with ESMTPSA id l30sm5366573qtv.54.2021.02.04.13.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:55:33 -0800 (PST)
From:   ameynarkhede02@gmail.com
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Amey Narkhede <ameynarkhede02@gmail.com>
Subject: [PATCH] staging: qlge/qlge_main: Use min_t instead of min
Date:   Fri,  5 Feb 2021 03:24:51 +0530
Message-Id: <20210204215451.69928-1-ameynarkhede02@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amey Narkhede <ameynarkhede02@gmail.com>

Use min_t instead of min function in qlge/qlge_main.c
Fixes following checkpatch.pl warning:
WARNING: min() should probably be min_t(int, MAX_CPUS, num_online_cpus())

Signed-off-by: Amey Narkhede <ameynarkhede02@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 402edaeff..29606d1eb 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3938,7 +3938,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 	int i;
 	struct rx_ring *rx_ring;
 	struct tx_ring *tx_ring;
-	int cpu_cnt = min(MAX_CPUS, (int)num_online_cpus());
+	int cpu_cnt = min_t(int, MAX_CPUS, (int)num_online_cpus());

 	/* In a perfect world we have one RSS ring for each CPU
 	 * and each has it's own vector.  To do that we ask for
--
2.30.0
