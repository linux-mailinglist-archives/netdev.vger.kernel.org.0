Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5DCB298A
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 06:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfINECD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 00:02:03 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35987 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfINECD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 00:02:03 -0400
Received: by mail-pg1-f195.google.com with SMTP id m29so23995pgc.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 21:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9XVGe/KPYiUZQvHirvAWLBmMzlVoYs6UukZVu5tT82k=;
        b=XxuP4hFVQ8I2kGBDSOsJWeqqGOud5cRh0cETAjVz9DDHhuYBBpMCBH99ho795Nu6YI
         H1dv+YfCriC+TMvVi5K85mmf2oHmG/LMSVTPLI6JVs+YHDL5Ap1jaS4uLNcMqdcTNLtW
         U04QlOqTyM2yqIL+H+TH2nTLl3a/ab/un4wn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9XVGe/KPYiUZQvHirvAWLBmMzlVoYs6UukZVu5tT82k=;
        b=NGlaaekI4kK2+hd3DlBHKSnTYITd+P+pBKPSkpg8rh49XGfMIkNTUqyyIiU/8KrFcV
         pazie0hv1q1ORapmwi3N4oiiNGw+4JHMwkdp2WBdCYspixHDHPMurTrVt53YCg8qmcgC
         nOBZoC/MVSNG3zu2A4blJSx3UzC9NNbjLA97SX/5lB5Q8YkUFV7epxXhBMu9HX1npvpw
         Zo90Ez7oCmQfN2S+i2yQb978+s0lQQ5M9vzhPFUaeQ8mcdrW5HtjsyTtKxy8T4xEScOg
         3neb9G2Nnxe4Hfv26DS55LFiEHBFZatG4o6hl0h+g7KQhrh9GDkrJCfXNJ4U9c3TOV2S
         PYsw==
X-Gm-Message-State: APjAAAXUhvXFe0YbLnEWdpj3F7gTfEG6m03J6iFeX+IV/8/T3gZ/EcMG
        5Ofu1prAbMVr83o98d2McoJRbovevnU=
X-Google-Smtp-Source: APXvYqziDhPkovug7j8rS9b9JPdHTCmvDaeA9JmoAgwPGt6McPw3lDA0nNpfMZJkpdqZqrP50XERKw==
X-Received: by 2002:a63:546:: with SMTP id 67mr10066570pgf.429.1568433721164;
        Fri, 13 Sep 2019 21:02:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a29sm52363908pfr.152.2019.09.13.21.01.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 21:02:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net-next 2/4] bnxt_en: Increase timeout for HWRM_DBG_COREDUMP_XX commands
Date:   Sat, 14 Sep 2019 00:01:39 -0400
Message-Id: <1568433701-29000-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
References: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Firmware coredump messages take much longer than standard messages,
so increase the timeout accordingly.

Fixes: 6c5657d085ae ("bnxt_en: Add support for ethtool get dump.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 333b0a8..42a8a75 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -648,6 +648,7 @@ struct nqe_cn {
 #define SHORT_HWRM_CMD_TIMEOUT		20
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
+#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
 #define HWRM_RESP_ERR_CODE_MASK		0xffff
 #define HWRM_RESP_LEN_OFFSET		4
 #define HWRM_RESP_LEN_MASK		0xffff0000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 235265e..51c1404 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3112,7 +3112,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 	req.component_id = cpu_to_le16(component_id);
 	req.segment_id = cpu_to_le16(segment_id);
 
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_COREDUMP_TIMEOUT);
 }
 
 static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
-- 
2.5.1

