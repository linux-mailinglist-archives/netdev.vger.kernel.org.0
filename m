Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72314B2C00
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351235AbiBKRpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:45:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242919AbiBKRpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:45:22 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A30CD5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:45:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIQuunDzEJmTFqE29FWLTWOCyqEyCeBkpir7BKATQ7XMW7rmyU0GHAd8wHHmfYjjCWun1+WYhZe5aeT2SPsyg4hUCBhgq4Tbdlg/gndOXKhJffQuQpuRCPS6amg2H/ensvf4liP3M1oUQ8zWx+HcO71YSi3nSERT5s5GB2GIr4chX8RRs4hAFNIQnxcCBkfWmJvRuogoFcmFwz/HKqWEQHG9cjYq2Cbc3xzSIwM5CVPmDhHSLpLV2gUo8+V+BA32MNli5NUTDA3vEunuJ0YF7LUhR8s3Q1F3qYK7N9yrx1D8WoBibDEvt4EtcmdJs2YSDIyhMg18xHMu6H62zBp+bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbd1nlKyqZ1Jn24AyN7LcmO10j4nqPa5mGj8HFvphnM=;
 b=Cv1kACx1NI6eSbOOoTfCKSmuFTL3S3p6YiBwDxxpBM1yvPj+wfkhBtJqdzr7tisij5QDLsd2fzDRYiD00fCB/GTsp9pSaEtK83FwrYqvHKRWTMy5Em7MOwVAw5R0aUXI4TT51oxsiXedgsFyEP/HWYBwJlUE16Bf88KABxT6t77lpBg6TEZyB9j4dFA7tWT2y1uwRSGYi6/A1ZjvuloYO3gjHdQJdtQLsKM5VjgrRQFQViWmB1VQDx/T1hlthjbs0OxCGKd3iVPvjg3wouHOsock4h7tx89K67unrqQY2zhUJdCfoBnv6KOotZJljMAKd4rdlIciyWVrxWjftQFCwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbd1nlKyqZ1Jn24AyN7LcmO10j4nqPa5mGj8HFvphnM=;
 b=c5/K9ueNAQe+I5GYWCf71WjR8MaZarLI5OwkbI6Sir+PQcTAG1z2mNYLTHQA4MxVDu+TygO80Q54OCCetccUitBGzahSfWom1301b8BsWoouisL6ZE1NPZ//dk3OBeRHGC3WMG5/0E4cfVMWgOKP0J7BpEGN6eaEPa0oxU00QGU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2427.eurprd04.prod.outlook.com (2603:10a6:3:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 17:45:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 17:45:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: [PATCH net] net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN
Date:   Fri, 11 Feb 2022 19:45:06 +0200
Message-Id: <20220211174506.3874409-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0008.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 271a7792-5ad9-4fad-ca15-08d9ed864413
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2427:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB2427DBC8335A44A258F4EE2AE0309@HE1PR0401MB2427.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJKEdihAGGSbxWv7uDV6vS07kguIUseUshF7mDEMFij0SGIjwGjmpqxEqO7DWiKYbN/My25rjmQjxxR1P93n5m1oxpvyiekSEwTmvo9rS7teOqEzsI3Giu7RSUWmv/i6h/9MwEZTLCRQvH8V3Z/gBfIImKLHO+oWaVtr/RZIuTrzzPUuhIPccCa1wQzMT4d4PpXhIzRcyIaFPHBgdrQVARznzGCSJNgOe4IPCxwcDAjrGGKeZFCiqiNeyLDKkT5XXFBJikRtts4/ZNtl6hcPsBEcB+takJZZ6+i0VYde8IXuur5BRwr4MvTpnH3ad3sfMm3oatsSDEQfr8iqKq3P3qFts9u6C11VsHtYryJAMUPFa+uSMJ8Cx/ViUdWhPDDi4UwDziAzWti0JKYckriscbItPKca0xdz3PBUQQ1+BS0srHdsOEhYM0sMEcSbFxPJnvKi0D6E5D7pDngVpCP6s4XC1VBdRlJ4LEs73mY2K8d19pXj7j2FpBzET5Vewp3X0UTEWO1pe40C6bFn/slnHefa1nJVq5zMvd+H3hq0VHmuxVkLmpnfguNAFcRrH0QeS18ElyBODDh1bWgSTtNQwqnRDowQLyuN1d7/CAlaUxiT0BxV6d3gzXiqFL8DmdHvCmJSiu80SGGP/+tyPumS4rv0RRf0SmaNBKtRXTXMX6qHgS1necfOSW2tNb3JB7Sr2HccS/UrfbTZhXVW43Idng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6916009)(38100700002)(38350700002)(54906003)(26005)(66556008)(8936002)(316002)(44832011)(5660300002)(4326008)(2906002)(8676002)(66946007)(66476007)(86362001)(6512007)(83380400001)(1076003)(2616005)(6486002)(508600001)(52116002)(36756003)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Wd6vj7NTSIc3hO9thrI4F/U1OaIUUuuk7yyGmUjWFh7apJ96o3v6lzYKLDE?=
 =?us-ascii?Q?uBwXC2PIdG6i0tSliWNbPGwRtOaKlpqGoecgTmCSNJRuGmzP1D5n9rFsAmX9?=
 =?us-ascii?Q?oyEFjve+ciseyYRq+elyB3gvoQvWxNvDoyhGOE1d5jv+3pNcANcrXolfKqrv?=
 =?us-ascii?Q?l9w+BoTsw0tM2yZxc7CRIdqEYdWbBYLedsh1QfFKrznmCTMemhXuhXxw/RCs?=
 =?us-ascii?Q?t/eUVYpFEzCe/1wdMEe/Z6CCD5CdMwFotJX6vynE7nFusCktc9PXjmC2woOh?=
 =?us-ascii?Q?Q+MF8FI7Etmr/xOurgNBZbqgGdexqbsCQJtaDluU0f5kjWsInH+hKt9n8UkO?=
 =?us-ascii?Q?g8/cW5WzdE0rS1R/IstcxVfzrncbro1Hjh80W6q9/ydRAtNuHIJXJAvTFLTp?=
 =?us-ascii?Q?wPfRTxR/l+9j8+39Y4C6UyzbL/iOXanUCwNg7VU9chgwBdWsdGRLQvgwXEwo?=
 =?us-ascii?Q?q9qfbbrgs5m66zVcuC5k3Ro9kYA68QVumeDbnng6AQtHNCP7xdd4pV7YGPcb?=
 =?us-ascii?Q?Zb+vCXKjP8rwF00Dx/dTh33hUKE649ylf31DdRqBckVHr+DhJq38HbApDSiK?=
 =?us-ascii?Q?jsLSW2wuJ+MPsNe0t+YVlwUVQtuuGj/KRCDd0X/3ErKHJxahN2eR3fbuJ6Op?=
 =?us-ascii?Q?0kyOWBH9y7AnRyv+8m+npSmC7z3X4hOhFh0emDPod2JSLRc2e1s+jJZTgOSF?=
 =?us-ascii?Q?MisAIorSrl1VTHJ3sZ5gUWhVPPgX3W50E3KPHzRCr8bYK4jycFkJxaxPn5mk?=
 =?us-ascii?Q?xQqdI/DCr0BWdsnbCvr+OXuQLy+mzVyYACxoS+Vu79I9SEEqB8O7Imd01jH4?=
 =?us-ascii?Q?uQ41Czf0MSOaq5KZi3lIM6x73Fc/Hvkz8rgyTqBkG1qX9FscktU9JlOpy5Ft?=
 =?us-ascii?Q?qbTLdgl/EBl8g0Wh/lXusRJaSIBdpoSfFN5s3SYUZGCdjyB6GJFgya81AfGI?=
 =?us-ascii?Q?13dcKuNwL1meo3FotO/8/wl1gH/viDUJ3ODbOZSxLBUyIihdWBmVBFuCkJQw?=
 =?us-ascii?Q?QzKgNArKOBBBY+0b4GyrlJ+Xjfjb0AO7nS+NaYLDSIolAc+6djlk4q8vM8jL?=
 =?us-ascii?Q?LnQrjeaSzw8SOasdxZ0NvcUlAtexaVQG+A7SWUF27py9WeeBkVVM0QkBc1LS?=
 =?us-ascii?Q?w1p+JqjXXUN9KvMO//+/XGNDlBzIEURrzxXxSN5gKa4yiRFkkhTN3QA7QJph?=
 =?us-ascii?Q?lnHOEkggQC9m1VIcYbVrWlE2eIasqEPJjnhh0El8bYl41wm5hLDLerrdL2ok?=
 =?us-ascii?Q?+0aftK5OLT74okTlGu+EIsx9iq7m2esbl473XWQ7x/y8Yy83E5fuoq8erT3+?=
 =?us-ascii?Q?nwR5pKDCjnDhkltS89hfSatf3kv4XyzbJDu8Aq6WlBYdgZQEYcQDbs5p4PJE?=
 =?us-ascii?Q?mSAEpPGHl0SqAEAFrYk+DtHfBxdtqwqUOaNxwBDGlktGAc/3GsB56ENG6vh6?=
 =?us-ascii?Q?JGJ8p6BeJ2OKIqL9S2ao8u0tvJFqJFx07dZibJuz/F/3knmT+/wlrfIoYvIT?=
 =?us-ascii?Q?xgj/IX6Cs9C4g1PfvUcaxkt+X5cn/+2NSBojWArpK+A3qEZv0/EUnbAVszcn?=
 =?us-ascii?Q?7sbBr+xzMfGCNgEVudJjAwhd/IukoH/ZZBLLVcyrkdU9gW1gpulmjTsSRrGS?=
 =?us-ascii?Q?AWyWsibeercSvUGRGoM4orE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271a7792-5ad9-4fad-ca15-08d9ed864413
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 17:45:17.5683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVjqqrFSyQS2bO62TusdXDBC+0wtwM/OUTujtiuu3asU59qOi1Y4R+atzXSeDGiPMwWI+CXmxhFTaUqFguAAxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2427
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx is special among DSA drivers in that it requires the VTU to
contain the VID of the FDB entry it modifies in
mv88e6xxx_port_db_load_purge(), otherwise it will return -EOPNOTSUPP.

Sometimes due to races this is not always satisfied even if external
code does everything right (first deletes the FDB entries, then the
VLAN), because DSA commits to hardware FDB entries asynchronously since
commit c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
notification").

Therefore, the mv88e6xxx driver must close this race condition by
itself, by asking DSA to flush the switchdev workqueue of any FDB
deletions in progress, prior to exiting a VLAN.

Fixes: c9eb3e0f8701 ("net: dsa: Add support for learning FDB through notification")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++++
 include/net/dsa.h                | 1 +
 net/dsa/dsa.c                    | 1 +
 net/dsa/dsa_priv.h               | 1 -
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 85527fe4fcc8..0e78cd7f468d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2404,6 +2404,13 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
+	/* The ATU removal procedure needs the FID to be mapped in the VTU,
+	 * but FDB deletion runs concurrently with VLAN deletion. Flush the DSA
+	 * switchdev workqueue to ensure that all FDB entries are deleted
+	 * before we remove the VLAN.
+	 */
+	dsa_flush_workqueue();
+
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_port_get_pvid(chip, port, &pvid);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 85cb9aed4c51..1456313a1faa 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1232,6 +1232,7 @@ void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
+void dsa_flush_workqueue(void);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index d9d0d227092c..c43f7446a75d 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -349,6 +349,7 @@ void dsa_flush_workqueue(void)
 {
 	flush_workqueue(dsa_owq);
 }
+EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6a3878157b0a..a37f0883676a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -156,7 +156,6 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
-void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
-- 
2.25.1

