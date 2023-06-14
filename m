Return-Path: <netdev+bounces-10743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B2D73013D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45AC52814A4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFEADDC2;
	Wed, 14 Jun 2023 14:07:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEBDDDC1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:07:32 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3284FCD;
	Wed, 14 Jun 2023 07:07:31 -0700 (PDT)
From: Florian Kauer <florian.kauer@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1686751649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g0kxT8UuGZDLapzulcDZLbRyKl1FZxwDwVUyDtTqgTM=;
	b=OPdXmQc2iWgpOGq0YWxc+qabH7RHLIUl2krzJQZ/IFJrv+4YJ20rpcADfaL7nS836gEDkx
	u4k0lsUWgNLXxRHbEWEZhhjGjkogxaUAsCkIWEvkhBnKbmvqfgF93pXrlB/J5N6daqZTVC
	tfpiBZ8W2Y84WiR4aYUnAFU6Bzz0bvQmh6OSgpW4ltoSQt0QDek19ddsEzhRwHslcL/K8y
	HDWQUEKdjR5Hgm/nXJ59WnPYocD/Bo2as8F4eLbD7xUoCa+BWl/KOyeCSJcNsbaHfH/vOk
	CaD/Vje7dkrxvmO0n1OLjd/grqfTXBiuSR0wnJIYR7WBuH4xExAi6Zroluz+Ag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1686751649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g0kxT8UuGZDLapzulcDZLbRyKl1FZxwDwVUyDtTqgTM=;
	b=fg+FJIuZ8ojp+l7iqa7Xhk+uBKHrS/vn3/BdUvbjOjMeCFYoYcnCe51pBDUV1ILSfW5SCh
	DkHLTPS/Tw0hrhCA==
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
	Malli C <mallikarjuna.chilakala@intel.com>
Cc: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kurt@linutronix.de,
	florian.kauer@linutronix.de
Subject: [PATCH net-next 1/6] igc: Rename qbv_enable to taprio_offload_enable
Date: Wed, 14 Jun 2023 16:07:09 +0200
Message-Id: <20230614140714.14443-2-florian.kauer@linutronix.de>
In-Reply-To: <20230614140714.14443-1-florian.kauer@linutronix.de>
References: <20230614140714.14443-1-florian.kauer@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the current implementation the flags adapter->qbv_enable
and IGC_FLAG_TSN_QBV_ENABLED have a similar name, but do not
have the same meaning. The first one is used only to indicate
taprio offload (i.e. when igc_save_qbv_schedule was called),
while the second one corresponds to the Qbv mode of the hardware.
However, the second one is also used to support the TX launchtime
feature, i.e. ETF qdisc offload. This leads to situations where
adapter->qbv_enable is false, but the flag IGC_FLAG_TSN_QBV_ENABLED
is set. This is prone to confusion.

The rename should reduce this confusion. Since it is a pure
rename, it has no impact on functionality.

Fixes: e17090eb2494 ("igc: allow BaseTime 0 enrollment for Qbv")
Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/intel/igc/igc.h      | 2 +-
 drivers/net/ethernet/intel/igc/igc_main.c | 6 +++---
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 18d4af934d8c..4d22662e8021 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -186,7 +186,7 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
-	bool qbv_enable;
+	bool taprio_offload_enable;
 	u32 qbv_config_change_errors;
 
 	/* OS defined structs */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 88145c30c919..56117846b8da 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6115,16 +6115,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 	switch (qopt->cmd) {
 	case TAPRIO_CMD_REPLACE:
-		adapter->qbv_enable = true;
+		adapter->taprio_offload_enable = true;
 		break;
 	case TAPRIO_CMD_DESTROY:
-		adapter->qbv_enable = false;
+		adapter->taprio_offload_enable = false;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	if (!adapter->qbv_enable)
+	if (!adapter->taprio_offload_enable)
 		return igc_tsn_clear_schedule(adapter);
 
 	if (qopt->base_time < 0)
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 94a2b0dfb54d..c6636a7264d5 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -37,7 +37,7 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
 {
 	unsigned int new_flags = adapter->flags & ~IGC_FLAG_TSN_ANY_ENABLED;
 
-	if (adapter->qbv_enable)
+	if (adapter->taprio_offload_enable)
 		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
 
 	if (is_any_launchtime(adapter))
-- 
2.39.2


