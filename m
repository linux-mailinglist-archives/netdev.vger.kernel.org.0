Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E61C34E9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgEDIvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728404AbgEDIvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A24C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:15 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id a4so1601005pgc.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7OGagqEIpUmMRnfnZd2HiB5g7lHps8xMMTGzxBmtUnA=;
        b=OjtzT8i4d9mnLy57zZP1+bgMcjk38gvs0lJM1ltNlO0AtaG/rdSji2t18ChmsT9FOo
         QIiE2Htfuy9ivSwAkGvymiAB0a4Vb72L5kDPgphTbTQlq79VEIwqgjLyPqRWUttwrRda
         3ZfakPsscXrpMIeWYEk/2RLgNQ6AAdw68gQ/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7OGagqEIpUmMRnfnZd2HiB5g7lHps8xMMTGzxBmtUnA=;
        b=Mx2/BpUmCi87GIL4cmAl9rcLp7ls13qZtLzWtgmq2TrI9BILecKjzvgxuTfiNOKaWa
         60WXzQLV8EBkQdGnfejAcSVkh/frCQHk7EMVa68TTYbpdgc9FXM0hq0xvmFO+N8rkLCf
         3ndhg+bh3egJZx4zVDHyd62L1zsEInpzcHW4DWbxnOC70c98ShG9BxRVeINyOOju4yAR
         KSGJYDstBqXyNzRrdb2Yd5a77scP2I8F+bwm+QW16/d0wXIkDmVY5Qva/evBzq+FC7ok
         SSQs9XNIGbXTYijONON7PBI+DuBhaIPS0xUQPzperTpvbIiP7FxptjFSjM4TeAzqHm5e
         u1hw==
X-Gm-Message-State: AGi0PuYwyXuP/b2uxDeEDHDeHGLlr/79Pw+7qcVQmXgEreJ3hwSyOx+N
        pHNStKvXobiEzjrnX6aznAAXoIdi3nc=
X-Google-Smtp-Source: APiQypJxxQU+75ZyLEnNrUg4QSUXSNFA/jtXQaiuBbifJqCsJh7OlHjLM7nrCaJQ3BDbsU/Hej06Qg==
X-Received: by 2002:a65:5186:: with SMTP id h6mr16659075pgq.453.1588582274934;
        Mon, 04 May 2020 01:51:14 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:14 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 09/15] bnxt_en: Define the doorbell offsets on 57500 chips.
Date:   Mon,  4 May 2020 04:50:35 -0400
Message-Id: <1588582241-31066-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the 57500 chip doorbell offsets instead of using the magic
values in the C file.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5919f72..2e56402 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5355,9 +5355,9 @@ static void bnxt_set_db(struct bnxt *bp, struct bnxt_db_info *db, u32 ring_type,
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		if (BNXT_PF(bp))
-			db->doorbell = bp->bar1 + 0x10000;
+			db->doorbell = bp->bar1 + DB_PF_OFFSET_P5;
 		else
-			db->doorbell = bp->bar1 + 0x4000;
+			db->doorbell = bp->bar1 + DB_VF_OFFSET_P5;
 		switch (ring_type) {
 		case HWRM_RING_ALLOC_TX:
 			db->db_key64 = DBR_PATH_L2 | DBR_TYPE_SQ;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1dbc3ae..a3b80409 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -537,6 +537,9 @@ struct nqe_cn {
 #define DBR_TYPE_NQ_ARM					(0xbULL << 60)
 #define DBR_TYPE_NULL					(0xfULL << 60)
 
+#define DB_PF_OFFSET_P5					0x10000
+#define DB_VF_OFFSET_P5					0x4000
+
 #define INVALID_HW_RING_ID	((u16)-1)
 
 /* The hardware supports certain page sizes.  Use the supported page sizes
-- 
2.5.1

