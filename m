Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99784621A84
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiKHR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiKHR0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFB354B2A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gchs9KkqaD3AdRJOEqsjNYgScwcndhvrja6B793DK1xyV5hZRiWh2yGetLrdYYnzwaJRz31H8Cl/oixVktIl/x+WyWmIOIXcm22REG3/Ba14lYPhylOcaJoNyJPhdO7TIvHwXl/S7DsLtLwKDJb9jownu0Rif38I7IYu9Hri09u/LnQJ2c/hwC1G92N/Vo86ISMrWSXJb+pygt6vd+iP2QWWhJkTrdO+FUq+mpRp7fydvQm913LzhNpkHVJqbAf8N/RmxcD/awg6ouxzROSPMNJhzUVYnY8lLLUe+v4wBU14z10iY/1+55jb1ug17Sgna09kEA6aJq0cvMfSxGab3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wu2gnAQ3GdqgV2oCTvHTjYw4PahNJjVQeQDikoqum+Q=;
 b=eUCHt8NDTl5ptKocqBj1T96xGZkTmsUTwdlcjFfJEEyiq7Jz09Lrz5h/b/XVeO15/FBH/UBRQZ3q6y3ouCvn4ADICRVILZmB9wDMURT/WefnNWJQ+uaNykCG/oIrWX2VBhgAXrLqcbxeHzIi0V+h2dmWP0pVcZttA5MZI3kHYi0DT4o9vzhAy+0KJaSAsJLsDdT9hQ+QLA0keudYRntn8/hdVX52H62Iwwnz/yl4oFCKsBz3rJ8fWGLofTjHFbDDZLm05oe2SSqX0mmV1F1V/zMkkHu4muMQusA4kdyRLUd6y0uUNTTgYqqL9LkiuIiXHtoMi08NGvO0fnXRQ8uetA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wu2gnAQ3GdqgV2oCTvHTjYw4PahNJjVQeQDikoqum+Q=;
 b=zC00IxX3gE9bqyChNd0nMcI62dI50xF/0Gl+di4jkLftvOvpAhrCiG6CIbgBni5Hl1Kj1M4C6mWE8pce4VdfuuwcpWnzBS5wrFVafaTJxJzXE/jZOIs2QI02pM7xaoA2NsCjVuIfrGBqJEqazCGjNF+NG0JgZh5mHqOLDsG5wtE=
Received: from MW4P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::32)
 by MW4PR12MB5627.namprd12.prod.outlook.com (2603:10b6:303:16a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 17:26:22 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::d3) by MW4P221CA0027.outlook.office365.com
 (2603:10b6:303:8b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Tue, 8 Nov 2022 17:26:22 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:21 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:20 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:19 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 07/11] sfc: add functions to allocate/free MAE counters
Date:   Tue, 8 Nov 2022 17:24:48 +0000
Message-ID: <1c1ce96e588ed6116a33347dca4b5a5e9995a7f0.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|MW4PR12MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eb64e30-7484-454f-a356-08dac1ae5b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IN58Eff9EIqaROy5iERFfOK5mdsdRn/LGs2Tj4/nwvADJUDzXB5TXwY8UGA1YuAAanr6cigd6w4F2hPFZUdKV8L8/w724sQiIWJlX+9Hue3yFoWxISKHNutkUEV1VZcTULzHlZ733EYTNBjlVCm9AKtzrzugI1rjlsN3wfPyGgyCADLGN3o1YH7gSSldaFszydk0ki5xMJYl9x1O53darvpije9DTD2PD3ezomwkh2fSy6YZHXdMe7+1QVI4OII6pSnbQtCwjgjDS4PZeCSMW+vwbx79j0UviVdgMCZEE+OAw9aoNXEwxGJ6t3GtdUG9YKrU1tmRCpDa8Wp0U9AZYE7g+v1Gnv6N33lMtcTQlXdOqugH/5RSShwCtu5trOeP3Zy8rySpuDvoEkQjt+pDXghoChWN98XoOVjc8EZ+iV3IGqTulBi85L52Hv3NchbDW76DNaMNYNmCmZ1fio6Cnp8czm0fQmFDDfZdFHX8R9W7OfUcmMu007zQ9Bt7o+PmjWja3j24+dC4UHxaLH8jiMmB8w42bY7Rkh/w90hC56OdFBHLcQr4Tbawh8L8MKh+jrfbznYihYfcoXQj5QiC9uZTyBCbDL7iG9Sq9ZwuCK7SDXGBAswpxoREo1qnvebh/Q3tl1dtQeiQValGBFd4uZWHt9zxFca/Pj+NjzRz7hIHj2W+XBt93I3hpFzMFI4ZNfmuREkAQ/5V9KBQT712g+hmhW+DyPKAlRTQIGQ3cZYiJxEspYEa2+QURpl6ciaUTMfvzzmH/97uWxbuuvIhg9pfFjRpYKfu4nqx1w6y77UdBJmfvS0q85m4snm93ntx
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(426003)(186003)(47076005)(83380400001)(36860700001)(336012)(9686003)(40460700003)(6666004)(2876002)(5660300002)(26005)(82310400005)(2906002)(40480700001)(70206006)(4326008)(110136005)(8936002)(316002)(41300700001)(478600001)(8676002)(6636002)(54906003)(70586007)(36756003)(356005)(81166007)(55446002)(82740400003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:22.5175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb64e30-7484-454f-a356-08dac1ae5b51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5627
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

efx_tc_flower_get_counter_index() will create an MAE counter mapped to
 the passed (TC filter) cookie, or increment the reference if one already
 exists for that cookie.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c         |  51 ++++++++++++
 drivers/net/ethernet/sfc/mae.h         |   3 +
 drivers/net/ethernet/sfc/tc_counters.c | 109 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.h |   7 ++
 4 files changed, 170 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 37722344c1cd..f227b4f2a9a0 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -434,6 +434,57 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 #undef CHECK_BIT
 #undef CHECK
 
+int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTER_ALLOC_V2_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	if (!cnt)
+		return -EINVAL;
+
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_ALLOC_V2_IN_REQUESTED_COUNT, 1);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_ALLOC_V2_IN_COUNTER_TYPE, cnt->type);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTER_ALLOC, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	/* pcol says this can't happen, since count is 1 */
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	cnt->fw_id = MCDI_DWORD(outbuf, MAE_COUNTER_ALLOC_OUT_COUNTER_ID);
+	cnt->gen = MCDI_DWORD(outbuf, MAE_COUNTER_ALLOC_OUT_GENERATION_COUNT);
+	return 0;
+}
+
+int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_FREE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTER_FREE_V2_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_FREE_V2_IN_COUNTER_ID_COUNT, 1);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_FREE_V2_IN_FREE_COUNTER_ID, cnt->fw_id);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_FREE_V2_IN_COUNTER_TYPE, cnt->type);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTER_FREE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	/* pcol says this can't happen, since count is 1 */
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should also never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what counters exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_COUNTER_FREE_OUT_FREED_COUNTER_ID) !=
+		    cnt->fw_id))
+		return -EIO;
+	return 0;
+}
+
 static bool efx_mae_asl_id(u32 id)
 {
 	return !!(id & BIT(31));
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 8f5de01dd962..72343e90e222 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -45,6 +45,9 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack);
 
+int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
+int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act);
 int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id);
 
diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
index 9a4d1d2a1271..6fd07ce61eb7 100644
--- a/drivers/net/ethernet/sfc/tc_counters.c
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -74,6 +74,115 @@ void efx_tc_fini_counters(struct efx_nic *efx)
 	rhashtable_free_and_destroy(&efx->tc->counter_ht, efx_tc_counter_free, NULL);
 }
 
+/* Counter allocation */
+
+static struct efx_tc_counter *efx_tc_flower_allocate_counter(struct efx_nic *efx,
+							     int type)
+{
+	struct efx_tc_counter *cnt;
+	int rc, rc2;
+
+	cnt = kzalloc(sizeof(*cnt), GFP_USER);
+	if (!cnt)
+		return ERR_PTR(-ENOMEM);
+
+	cnt->type = type;
+
+	rc = efx_mae_allocate_counter(efx, cnt);
+	if (rc)
+		goto fail1;
+	rc = rhashtable_insert_fast(&efx->tc->counter_ht, &cnt->linkage,
+				    efx_tc_counter_ht_params);
+	if (rc)
+		goto fail2;
+	return cnt;
+fail2:
+	/* If we get here, it implies that we couldn't insert into the table,
+	 * which in turn probably means that the fw_id was already taken.
+	 * In that case, it's unclear whether we really 'own' the fw_id; but
+	 * the firmware seemed to think we did, so it's proper to free it.
+	 */
+	rc2 = efx_mae_free_counter(efx, cnt);
+	if (rc2)
+		netif_warn(efx, hw, efx->net_dev,
+			   "Failed to free MAE counter %u, rc %d\n",
+			   cnt->fw_id, rc2);
+fail1:
+	kfree(cnt);
+	return ERR_PTR(rc > 0 ? -EIO : rc);
+}
+
+static void efx_tc_flower_release_counter(struct efx_nic *efx,
+					  struct efx_tc_counter *cnt)
+{
+	int rc;
+
+	rhashtable_remove_fast(&efx->tc->counter_ht, &cnt->linkage,
+			       efx_tc_counter_ht_params);
+	rc = efx_mae_free_counter(efx, cnt);
+	if (rc)
+		netif_warn(efx, hw, efx->net_dev,
+			   "Failed to free MAE counter %u, rc %d\n",
+			   cnt->fw_id, rc);
+	/* This doesn't protect counter updates coming in arbitrarily long
+	 * after we deleted the counter.  The RCU just ensures that we won't
+	 * free the counter while another thread has a pointer to it.
+	 * Ensuring we don't update the wrong counter if the ID gets re-used
+	 * is handled by the generation count.
+	 */
+	synchronize_rcu();
+	kfree(cnt);
+}
+
+/* TC cookie to counter mapping */
+
+void efx_tc_flower_put_counter_index(struct efx_nic *efx,
+				     struct efx_tc_counter_index *ctr)
+{
+	if (!refcount_dec_and_test(&ctr->ref))
+		return; /* still in use */
+	rhashtable_remove_fast(&efx->tc->counter_id_ht, &ctr->linkage,
+			       efx_tc_counter_id_ht_params);
+	efx_tc_flower_release_counter(efx, ctr->cnt);
+	kfree(ctr);
+}
+
+struct efx_tc_counter_index *efx_tc_flower_get_counter_index(
+				struct efx_nic *efx, unsigned long cookie,
+				enum efx_tc_counter_type type)
+{
+	struct efx_tc_counter_index *ctr, *old;
+	struct efx_tc_counter *cnt;
+
+	ctr = kzalloc(sizeof(*ctr), GFP_USER);
+	if (!ctr)
+		return ERR_PTR(-ENOMEM);
+	ctr->cookie = cookie;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->counter_id_ht,
+						&ctr->linkage,
+						efx_tc_counter_id_ht_params);
+	if (old) {
+		/* don't need our new entry */
+		kfree(ctr);
+		if (!refcount_inc_not_zero(&old->ref))
+			return ERR_PTR(-EAGAIN);
+		/* existing entry found */
+		ctr = old;
+	} else {
+		cnt = efx_tc_flower_allocate_counter(efx, type);
+		if (IS_ERR(cnt)) {
+			rhashtable_remove_fast(&efx->tc->counter_id_ht,
+					       &ctr->linkage,
+					       efx_tc_counter_id_ht_params);
+			kfree(ctr);
+			return (void *)cnt; /* it's an ERR_PTR */
+		}
+		ctr->cnt = cnt;
+		refcount_set(&ctr->ref, 1);
+	}
+	return ctr;
+}
+
 /* TC Channel.  Counter updates are delivered on this channel's RXQ. */
 
 static void efx_tc_handle_no_channel(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/tc_counters.h b/drivers/net/ethernet/sfc/tc_counters.h
index f998cee324c7..85f4919271eb 100644
--- a/drivers/net/ethernet/sfc/tc_counters.h
+++ b/drivers/net/ethernet/sfc/tc_counters.h
@@ -26,6 +26,7 @@ struct efx_tc_counter {
 	u32 fw_id; /* index in firmware counter table */
 	enum efx_tc_counter_type type;
 	struct rhash_head linkage; /* efx->tc->counter_ht */
+	u32 gen; /* Generation count at which this counter is current */
 };
 
 struct efx_tc_counter_index {
@@ -40,6 +41,12 @@ int efx_tc_init_counters(struct efx_nic *efx);
 void efx_tc_destroy_counters(struct efx_nic *efx);
 void efx_tc_fini_counters(struct efx_nic *efx);
 
+struct efx_tc_counter_index *efx_tc_flower_get_counter_index(
+				struct efx_nic *efx, unsigned long cookie,
+				enum efx_tc_counter_type type);
+void efx_tc_flower_put_counter_index(struct efx_nic *efx,
+				     struct efx_tc_counter_index *ctr);
+
 extern const struct efx_channel_type efx_tc_channel_type;
 
 #endif /* EFX_TC_COUNTERS_H */
