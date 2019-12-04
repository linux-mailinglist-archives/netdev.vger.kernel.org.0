Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8124A112A67
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfLDLor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:44:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54106 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLDLoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 06:44:46 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1icT5G-0006m3-Ma; Wed, 04 Dec 2019 11:44:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] qed: remove redundant assignments to rc
Date:   Wed,  4 Dec 2019 11:44:42 +0000
Message-Id: <20191204114442.1413895-1-colin.king@canonical.com>
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

V2: re-do variable re-ordering to match the required coding style

---
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 7e0b795230b2..900bc603e30a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -331,8 +331,8 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 	u8 sb_index = p_hwfn->p_eq->eq_sb_index;
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EINVAL;
 	u8 page_cnt, i;
+	int rc;
 
 	/* update initial eq producer */
 	qed_eq_prod_update(p_hwfn,
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

