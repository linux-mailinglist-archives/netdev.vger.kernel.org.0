Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EA3107B89
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVXip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:38:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44214 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVXio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:38:44 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iYIVc-0001ZG-3T; Fri, 22 Nov 2019 23:38:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qed: remove redundant assignments to rc
Date:   Fri, 22 Nov 2019 23:38:39 +0000
Message-Id: <20191122233839.110620-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rc is assigned with a value that is never read and
it is re-assigned a new value later on.  The assignment is redundant
and can be removed.  Clean up multiple occurrances of this pattern.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 7e0b795230b2..12fc5f3b5cb4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -331,7 +331,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 	u8 sb_index = p_hwfn->p_eq->eq_sb_index;
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EINVAL;
+	int rc;
 	u8 page_cnt, i;
 
 	/* update initial eq producer */
@@ -447,7 +447,7 @@ int qed_sp_pf_update(struct qed_hwfn *p_hwfn)
 {
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EINVAL;
+	int rc;
 
 	/* Get SPQ entry */
 	memset(&init_data, 0, sizeof(init_data));
@@ -471,7 +471,7 @@ int qed_sp_pf_update_ufp(struct qed_hwfn *p_hwfn)
 {
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EOPNOTSUPP;
+	int rc;
 
 	if (p_hwfn->ufp_info.pri_type == QED_UFP_PRI_UNKNOWN) {
 		DP_INFO(p_hwfn, "Invalid priority type %d\n",
@@ -509,7 +509,7 @@ int qed_sp_pf_update_tunn_cfg(struct qed_hwfn *p_hwfn,
 {
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EINVAL;
+	int rc;
 
 	if (IS_VF(p_hwfn->cdev))
 		return qed_vf_pf_tunnel_param_update(p_hwfn, p_tunn);
@@ -546,7 +546,7 @@ int qed_sp_pf_stop(struct qed_hwfn *p_hwfn)
 {
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EINVAL;
+	int rc;
 
 	/* Get SPQ entry */
 	memset(&init_data, 0, sizeof(init_data));
-- 
2.24.0

