Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1B5504CD9
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbiDRGrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbiDRGrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:03 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5505C1900D
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRpYoDPMuGfJdhqFyggb7CaDDNbC7GYrLdLOkP8VpHb3tqqi+0Llwk5lqkNjFHmZjnKgfNmjinGfyBKK8M5Gtuhva0Qt9o2X7/wyDCdbCHEmbGwxEVLe1D4MZwdYnEfo8GB0lEfpefykW/jmgm4DBOkmNzkkYvhh7PR+LYBCk7zfHOiKJebIBMmnED/OW63KZjbWc1NO7njWP5TNOrzLXDJKqPB8XRbB6MfY8CTw7+/iq8jFzdzzsKP+CpW6vCznM4ggHEvETgQkC4Ukybli5ARft0ZQWHhWwV552TJz0UbH0zQGC/PdCO/uKLbsgr07PAS7v9PWBCYfhs8MPtkJWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYukPx+lYyQByfxjwlOKRI1so7F4j7h1LTGsIiQZFM4=;
 b=CSX1tyrfmRiKqru8z53z1frIFmoB/Vajd3kyd8x4QwXv2HUGMKfGVMsGct28SkAxIOMil75qmxu+AkGSYIuEfLluAgxf30yNbZuWSP6T7JLswh1TMsTXcbf5guFDqBW+IPa6HYfywPUKbnQ925SZO9kJJxez6aMVQivTP9jcDQJvQhkr6Y2oXGgwLGZKX6QdEJHBtePIeQ6K4LlLMjI3f+jk66kAyYgzThyoyKeT78qeFuD8y8W2ex/Tquh9sRvc30dgbasoOF471/2Wzh0GpSZIekLjzSU+QbPTipInVUPkAP3+mnbM3e1cDAEaAqsxSGDhoJwFXeKxh3a93X8+3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYukPx+lYyQByfxjwlOKRI1so7F4j7h1LTGsIiQZFM4=;
 b=gHG0UHO8TIqrze9ENhQk0xJsTwzbaouNZ6QQNAM2fhU/pwnQVSLuTPALUBLFjOHJ63rHZKU6tK11Q5ZJlGIgDRIBfNWeeUWdvUkDOZO6BmicDyUfQYyvLHitJ8ZgSZr5Zpjw92/ZLAegR/ANfisVpSRV4/yHrsCJw6uHBrEkBBO01VK7iLBxrV9v9K9cSzuz1+RSHAamud2n/u8SbTElD/Jt7K1wxVrpezR8bJ5OZgUQ6f0ZziYeEqlOKihLoyGB/lK1Jmi/wBKzgBUbpU5VSoJqcIn/g6MhMzqztsasbV+SSO6nJperM1BwiKbDg7jfs10xlrMNC7wLLqqP+fuGvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:16 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/17] mlxsw: spectrum: Introduce port mapping change event processing
Date:   Mon, 18 Apr 2022 09:42:33 +0300
Message-Id: <20220418064241.2925668-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0087.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4cc9a36-5a49-4cdf-e0d6-08da2106db84
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB36640FA2D11A3C411D5713FAB2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzDJBnQHC72+6nZ7qCO7gqa59kLmHVRcWWPAVkHp2GLlXuqfByatSblYL8syE3OMD+6+E+Ky/+JtoF1z92xrQtlqMfD9AHGy9vgRz61HW/7cPL8JTBRrVG6zeyXRgBvodkKkQWhnDhNzKTFJt9oI2OOUjr6fDx9LqTKyoYmW3lhxJKgx0AFRme5EXlN1W41o9fQIIpej0oMK5SzMNYfiIDjEvEPJtbQrKZtbOzlqbA2EQfvJzlpCk2PBL2yWxQfBcH6ieYvZD89dJHAIO9TYOQitXa4AHYn4M3V2LTQ49SFPfI46G+j/qtd6Qf0fwPeYK+2W/tO4mZf5K4LGmuenc2VMGOHRZ7v+5lXnX3++G+J45QcfDDyMeXb3bHia2NZindyxMGht+P5QAzcQLjAWm7+L1JO+IoRiyHCLtBhqoY+D3XdlHB/VknNI9T1DU4948kp291lyq7nOgzEaaHwr8Ea4gT1O7uolyB0gP+4oY38IPyW8Qgx1PjW7ClZv3+U6f8VYNmqk4VXsZtidFPzWO9wmb7XdxyiN1xdvbkW9GdTYTRUAKuSd9vCXcHd7eHAXTCc7FPBzXkGsveJ6UHMn9FEEWNR5NNUNf+AnqTZ6lM9qA+qIk037dqVi81wGOM4K2rVofQ9iLZcJWYTahEQF7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(66574015)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?odiIerVhan4Fb+JYcyvH22MTfp8j8KI5bLbuWxwRrHg92Fto5wz842CGj1P5?=
 =?us-ascii?Q?oymIfcwBnvXD6uYoKm6MI6ALQeAnOuvolLUN1i4Fcef943KXTnBNlk2ddMLR?=
 =?us-ascii?Q?ThEm9KTuNsHvGSAcZPMOO7K6j8xAGXdBI0YJdUwbEM7LBlMFMk4YbO7EfhO+?=
 =?us-ascii?Q?gsVB4/V4eNAn10HRxUxCz17PsxY1rWjDrrSGl6QqEUGEVaX1EbI1E5FRwPYg?=
 =?us-ascii?Q?5fYmY73AwLUA4wogZy4eg2slNckT4zGn2TWqSd341OmhouxUZX1dA6nsPhh+?=
 =?us-ascii?Q?NFEnZUcAb9OpNyePzYYQjcTmxNpZooxlCRm1XPFXxE/dtIregxsKZ+A/aymi?=
 =?us-ascii?Q?FY0x9ouGmiR0uc0GbI5xOTxvP/pvLJbc3/+6hh+cccWFCvRlf7SIAQ3ASnep?=
 =?us-ascii?Q?tPXKjtRYCt/hFnMH1aFAoMuOdj0iFiOO9XDRcwGLh4dl5qCe38pYQ8/3tmHz?=
 =?us-ascii?Q?dTIwQXScAwL7ccomCtWsGPuBmTd4ePvDlGoWUd4KEeIjGiMdQWtIDAXc0jHD?=
 =?us-ascii?Q?qOgqanWQzk6aGjeNq57VSoxv/XigJMM4NFBYSozTz57Z7NfZR+sx6ARZftkn?=
 =?us-ascii?Q?txMPmQ3RusRNqfV+BMNiUd7VuW5ZNA8fWS4Jsa+QmXJXgPsQ7xo3ZWx7RS1C?=
 =?us-ascii?Q?qThoIA23k1NUwx0HxBWfHHzlMBh6h0VRP9sULD+FD7/8F86dw9LbO1sup8qE?=
 =?us-ascii?Q?PzMJKfEluJICsJLzIHsOAsT08JJxsEdmrFLvU9WHrMtajnnRqh4QNh5MK0OQ?=
 =?us-ascii?Q?10EsjTnTeMSvhbf7BzfPIMYQZCQjm/VCIC+d+cQWTV44fVV8iaq6y1nJjumU?=
 =?us-ascii?Q?xAw823u+IoJbhOwgMfITtJkop/Vvw/SCgxCZi9ZnFBxLPCXCn+9Yy+AlyRVc?=
 =?us-ascii?Q?i3VwJJZVOsJlTd7/QMmZddJojVrEt/UL6QZim2uUdJf9ctpcVsokLuCGQ4P/?=
 =?us-ascii?Q?Qy5sd5RUPd3nfQuMevNvEzU8BgEIXmC8LzsQNMnKnAr977k7eui7EuE9FtN4?=
 =?us-ascii?Q?Pjkgav6t7QLmCjDwQjicQ+uo97QIDmDyaeY8ENvA4nkqi9l2G1hrGtOu43ID?=
 =?us-ascii?Q?Il+4EDmtLNJK31l1oltHH2HNHYWwseVIuFSwAdTlNA6dOBaH2JwCu6Ir8OtP?=
 =?us-ascii?Q?hoV6mV8tAjTR8F6az+i6cHTldUyqFuv7plYlcI/C0iZo/jNmbT1FoqhTPT+t?=
 =?us-ascii?Q?3JMaecMj9ClF8yH6hVzL9EOVOuMuccTNUoEv5tC7+WVh3QtRu0vl4H8L2Oyx?=
 =?us-ascii?Q?D8CDvXopVlTv2uX3wNBB9/ID5cHG90q81lQTRWZkvMrlEkPklyLIA6kwOYfb?=
 =?us-ascii?Q?scFiubcU70kUwyD6j2fAVr5zlHXgN1d08UvyfOIzJtXX/MChBbVMvENzhm6A?=
 =?us-ascii?Q?0xPp7E1tNtNM2hYc6mwsJ3CCBnq9Wya0WR6G9/Vc75DuAhRaRGGuHgj40rgI?=
 =?us-ascii?Q?JfvqbzydTsCWgDwFHETpKpjvwvn6XRklQtX7sFuPOWuVXNAcAD7SqWeQcwXJ?=
 =?us-ascii?Q?tSrN/oGv0nT/BxZowYOXizb9DjLrhkpznQTYYMTFIO8VjOmKh/MaxcJA1c9n?=
 =?us-ascii?Q?EqHShvUsNS151YHVNspo3QvqxT93vyYlf+TMDyuC3yYfZrL7b9TaluzKWUDK?=
 =?us-ascii?Q?ZG6TUiJ6fyQW3jqeufP0+hDQSlg1sR/0NJjbcwSsEFZ1nq6bMzMcS2Sz5WBA?=
 =?us-ascii?Q?T4exQZ2Ps2VKXPNrrNZeCYPVzbRXMZxfofz1P/7Z4X4kxZduu/BM2i5cEOBi?=
 =?us-ascii?Q?u+pamzb6QQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cc9a36-5a49-4cdf-e0d6-08da2106db84
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:16.4816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XWygQ1q/fakMfRbiIeLbmc6uZXMG0D+WEGiU6l31HT0px6EGz5XYM/76PIR8t64l/2bDd09GweKdArdQ8dy0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Register PMLPE trap and process the port mapping changes delivered
by it by creating related ports. Note that this happens after
provisioning. The INI of the linecard is processed and merged by FW.
PMLPE is generated for each port. Process this mapping change.

Layout of PMLPE is the same as layout of PMLP.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 166 +++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 3 files changed, 166 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c26c160744d0..c3457a216642 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -481,21 +481,16 @@ mlxsw_sp_port_system_port_mapping_set(struct mlxsw_sp_port *mlxsw_sp_port)
 }
 
 static int
-mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
-			      struct mlxsw_sp_port_mapping *port_mapping)
+mlxsw_sp_port_module_info_parse(struct mlxsw_sp *mlxsw_sp,
+				u16 local_port, char *pmlp_pl,
+				struct mlxsw_sp_port_mapping *port_mapping)
 {
-	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	bool separate_rxtx;
 	u8 first_lane;
 	u8 module;
 	u8 width;
-	int err;
 	int i;
 
-	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
-	if (err)
-		return err;
 	module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
 	width = mlxsw_reg_pmlp_width_get(pmlp_pl);
 	separate_rxtx = mlxsw_reg_pmlp_rxtx_get(pmlp_pl);
@@ -534,6 +529,21 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	return 0;
 }
 
+static int
+mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
+			      struct mlxsw_sp_port_mapping *port_mapping)
+{
+	char pmlp_pl[MLXSW_REG_PMLP_LEN];
+	int err;
+
+	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
+	if (err)
+		return err;
+	return mlxsw_sp_port_module_info_parse(mlxsw_sp, local_port,
+					       pmlp_pl, port_mapping);
+}
+
 static int
 mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 			 const struct mlxsw_sp_port_mapping *port_mapping)
@@ -1861,13 +1871,121 @@ static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 	return mlxsw_sp->ports[local_port] != NULL;
 }
 
+static int mlxsw_sp_port_mapping_event_set(struct mlxsw_sp *mlxsw_sp,
+					   u16 local_port, bool enable)
+{
+	char pmecr_pl[MLXSW_REG_PMECR_LEN];
+
+	mlxsw_reg_pmecr_pack(pmecr_pl, local_port,
+			     enable ? MLXSW_REG_PMECR_E_GENERATE_EVENT :
+				      MLXSW_REG_PMECR_E_DO_NOT_GENERATE_EVENT);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmecr), pmecr_pl);
+}
+
+struct mlxsw_sp_port_mapping_event {
+	struct list_head list;
+	char pmlp_pl[MLXSW_REG_PMLP_LEN];
+};
+
+static void mlxsw_sp_port_mapping_events_work(struct work_struct *work)
+{
+	struct mlxsw_sp_port_mapping_event *event, *next_event;
+	struct mlxsw_sp_port_mapping_events *events;
+	struct mlxsw_sp_port_mapping port_mapping;
+	struct mlxsw_sp *mlxsw_sp;
+	struct devlink *devlink;
+	LIST_HEAD(event_queue);
+	u16 local_port;
+	int err;
+
+	events = container_of(work, struct mlxsw_sp_port_mapping_events, work);
+	mlxsw_sp = container_of(events, struct mlxsw_sp, port_mapping_events);
+	devlink = priv_to_devlink(mlxsw_sp->core);
+
+	spin_lock_bh(&events->queue_lock);
+	list_splice_init(&events->queue, &event_queue);
+	spin_unlock_bh(&events->queue_lock);
+
+	list_for_each_entry_safe(event, next_event, &event_queue, list) {
+		local_port = mlxsw_reg_pmlp_local_port_get(event->pmlp_pl);
+		err = mlxsw_sp_port_module_info_parse(mlxsw_sp, local_port,
+						      event->pmlp_pl, &port_mapping);
+		if (err)
+			goto out;
+
+		if (WARN_ON_ONCE(!port_mapping.width))
+			goto out;
+
+		devl_lock(devlink);
+
+		if (!mlxsw_sp_port_created(mlxsw_sp, local_port))
+			mlxsw_sp_port_create(mlxsw_sp, local_port,
+					     false, &port_mapping);
+		else
+			WARN_ON_ONCE(1);
+
+		devl_unlock(devlink);
+
+		mlxsw_sp->port_mapping[local_port] = port_mapping;
+
+out:
+		kfree(event);
+	}
+}
+
+static void
+mlxsw_sp_port_mapping_listener_func(const struct mlxsw_reg_info *reg,
+				    char *pmlp_pl, void *priv)
+{
+	struct mlxsw_sp_port_mapping_events *events;
+	struct mlxsw_sp_port_mapping_event *event;
+	struct mlxsw_sp *mlxsw_sp = priv;
+	u16 local_port;
+
+	local_port = mlxsw_reg_pmlp_local_port_get(pmlp_pl);
+	if (WARN_ON_ONCE(!mlxsw_sp_local_port_is_valid(mlxsw_sp, local_port)))
+		return;
+
+	events = &mlxsw_sp->port_mapping_events;
+	event = kmalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return;
+	memcpy(event->pmlp_pl, pmlp_pl, sizeof(event->pmlp_pl));
+	spin_lock(&events->queue_lock);
+	list_add_tail(&event->list, &events->queue);
+	spin_unlock(&events->queue_lock);
+	mlxsw_core_schedule_work(&events->work);
+}
+
+static void
+__mlxsw_sp_port_mapping_events_cancel(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_port_mapping_event *event, *next_event;
+	struct mlxsw_sp_port_mapping_events *events;
+
+	events = &mlxsw_sp->port_mapping_events;
+
+	/* Caller needs to make sure that no new event is going to appear. */
+	cancel_work_sync(&events->work);
+	list_for_each_entry_safe(event, next_event, &events->queue, list) {
+		list_del(&event->list);
+		kfree(event);
+	}
+}
+
 static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
+	for (i = 1; i < max_ports; i++)
+		mlxsw_sp_port_mapping_event_set(mlxsw_sp, i, false);
+	/* Make sure all scheduled events are processed */
+	__mlxsw_sp_port_mapping_events_cancel(mlxsw_sp);
+
 	devl_lock(devlink);
-	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
+	for (i = 1; i < max_ports; i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
@@ -1880,6 +1998,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	struct mlxsw_sp_port_mapping_events *events;
 	struct mlxsw_sp_port_mapping *port_mapping;
 	size_t alloc_size;
 	int i;
@@ -1890,6 +2009,17 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->ports)
 		return -ENOMEM;
 
+	events = &mlxsw_sp->port_mapping_events;
+	INIT_LIST_HEAD(&events->queue);
+	spin_lock_init(&events->queue_lock);
+	INIT_WORK(&events->work, mlxsw_sp_port_mapping_events_work);
+
+	for (i = 1; i < max_ports; i++) {
+		err = mlxsw_sp_port_mapping_event_set(mlxsw_sp, i, true);
+		if (err)
+			goto err_event_enable;
+	}
+
 	devl_lock(devlink);
 	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
 	if (err)
@@ -1910,9 +2040,15 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	for (i--; i >= 1; i--)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
+	i = max_ports;
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 err_cpu_port_create:
 	devl_unlock(devlink);
+err_event_enable:
+	for (i--; i >= 1; i--)
+		mlxsw_sp_port_mapping_event_set(mlxsw_sp, i, false);
+	/* Make sure all scheduled events are processed */
+	__mlxsw_sp_port_mapping_events_cancel(mlxsw_sp);
 	kfree(mlxsw_sp->ports);
 	mlxsw_sp->ports = NULL;
 	return err;
@@ -2074,6 +2210,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 
 err_port_split_create:
 	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
+
 	return err;
 }
 
@@ -2294,6 +2431,11 @@ static const struct mlxsw_listener mlxsw_sp1_listener[] = {
 	MLXSW_EVENTL(mlxsw_sp1_ptp_ing_fifo_event_func, PTP_ING_FIFO, SP_PTP0),
 };
 
+static const struct mlxsw_listener mlxsw_sp2_listener[] = {
+	/* Events */
+	MLXSW_SP_EVENTL(mlxsw_sp_port_mapping_listener_func, PMLPE),
+};
+
 static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
@@ -3085,6 +3227,8 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
 	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
+	mlxsw_sp->listeners = mlxsw_sp2_listener;
+	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -3115,6 +3259,8 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
 	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
+	mlxsw_sp->listeners = mlxsw_sp2_listener;
+	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -3145,6 +3291,8 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
 	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
+	mlxsw_sp->listeners = mlxsw_sp2_listener;
+	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP4;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 68f71e77b5c7..928c3a63b6b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -150,6 +150,12 @@ struct mlxsw_sp_port_mapping {
 	u8 lane;
 };
 
+struct mlxsw_sp_port_mapping_events {
+	struct list_head queue;
+	spinlock_t queue_lock; /* protects queue */
+	struct work_struct work;
+};
+
 struct mlxsw_sp_parsing {
 	refcount_t parsing_depth_ref;
 	u16 parsing_depth;
@@ -165,6 +171,7 @@ struct mlxsw_sp {
 	const unsigned char *mac_mask;
 	struct mlxsw_sp_upper *lags;
 	struct mlxsw_sp_port_mapping *port_mapping;
+	struct mlxsw_sp_port_mapping_events port_mapping_events;
 	struct rhashtable sample_trigger_ht;
 	struct mlxsw_sp_sb *sb;
 	struct mlxsw_sp_bridge *bridge;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 9e070ab3ed76..7405c400f09b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -133,6 +133,8 @@ enum mlxsw_event_trap_id {
 	MLXSW_TRAP_ID_PTP_ING_FIFO = 0x2D,
 	/* PTP Egress FIFO has a new entry */
 	MLXSW_TRAP_ID_PTP_EGR_FIFO = 0x2E,
+	/* Port mapping change */
+	MLXSW_TRAP_ID_PMLPE = 0x32E,
 };
 
 #endif /* _MLXSW_TRAP_H */
-- 
2.33.1

