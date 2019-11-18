Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532EB1000D1
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfKRI5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41184 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRI5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:03 -0500
Received: by mail-pl1-f196.google.com with SMTP id d29so9410023plj.8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LOR2qjfx8H6Cidz6hryfY0zF3GzzGeK+/UaSjoLG/K0=;
        b=BPpV+I5sWBETNmKH4iWITQYRAuRBOnML3xPJQX4O13cioUUIlTJv5PoG7ard+B6ygS
         1epquGqEL5kwZ9yIdn6InZCCM+9MUAGKMTTphVN+avT7/ox3t17ATcxFhng3Bw3LqGtO
         BkZMBD6C0W+SrZNV7P+qf6AVrXT5bqUJiQrC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LOR2qjfx8H6Cidz6hryfY0zF3GzzGeK+/UaSjoLG/K0=;
        b=V5FWHzd1/0rqhBIqqBeduDM70dmkIZWSgdsdrSX7ZkLls0c4bAVLuTb3FejvUvIWhZ
         6B2MuJlYejbxwbJVMxTlQTW/q0XryOnul+Okve+BjYjRo/5tHAdLbJ8uGZK6g9a44E13
         /S+/UdFyPQgDeCVRdSIoj61wK+Qxos8Mw83E3BIzGxLJsoYZJlOC/gaQ4mKsnNclgCdP
         p/fVH3n1Gkrboe1p4UqcZePzL0tdsXoQkotAJRyOfC08TMt1mF5NqfWBj21IR2W67SoB
         0v0YeGzsTFw5ecPWNx8JHWPq+S54SMiDOeggnbzRCk75YFPT5gevZ9R/AlWSiYrLV9YM
         arXA==
X-Gm-Message-State: APjAAAWlDwBw7bw6IQ9vFEv46BT/Avf6+Dla1rcstUM2dtT4SqShtwuU
        tNR7n1Rc9Y65BstPRMZ1GtWetw==
X-Google-Smtp-Source: APXvYqxL2X1/E7vnuCUkLJlsbOCZ9KqreFz6+vT/htJ4tUWtePI3ysdGttW45SruNc8xwY45RbEJ+w==
X-Received: by 2002:a17:90a:bd95:: with SMTP id z21mr38338553pjr.10.1574067422908;
        Mon, 18 Nov 2019 00:57:02 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:02 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 3/9] bnxt_en: Increase firmware response timeout for coredump commands.
Date:   Mon, 18 Nov 2019 03:56:37 -0500
Message-Id: <1574067403-4344-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Use the larger HWRM_COREDUMP_TIMEOUT value for coredump related
data response from the firmware.  These commands take longer than
normal commands.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7a5f6bf..c5cd8d8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3040,7 +3040,8 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg, int msg_len,
 	mutex_lock(&bp->hwrm_cmd_lock);
 	while (1) {
 		*seq_ptr = cpu_to_le16(seq);
-		rc = _hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+		rc = _hwrm_send_message(bp, msg, msg_len,
+					HWRM_COREDUMP_TIMEOUT);
 		if (rc)
 			break;
 
-- 
2.5.1

