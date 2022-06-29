Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA555FC4E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiF2JlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiF2Jky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:40:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BCA39B8F
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K44ko4u4UnBPCVPbC9An2PUr5o/m60yCZht2T92kXPU2x0C+7ZVf7thLfXttzsaCUxwpu4YA9Ttb8DGXrotn3/qbKMR7d0NI/JA3hLdjIFJhFMAUgr4TWF1yDavxSSrsG+k5kaYrrDoYY0Sc1Unx3sAhHwisCrPUh2gBZ9826t5d60Abq/QX+A0Aas6XJbUWJ/cRasuIovn9tUUvoJ37ESyu0uD5ATS98bcSFWebdWOeu34+eg/idi1is12QNrhSZlzDV4kArnntLp7Xyjawl0SzY7EnowfZuL8C61WKBqvK6t8Z5LCk4QAlKeaNUcfDcl3Pr1mkDBo7xtmwtiIYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QM2mciemxoNxnXnMibzZJDd3nmHfrzoMLVnNdVKqCY0=;
 b=N7OB9SIwK8/ftjmVHWGkdDzFYcrQMmBPuI4jCjIillgFCwVptj1EG/aJ2Ap1/5LAlGfu2gS1L7xVVsjFio+ViUdZG4wAtjVjgaV9PSkORAE3p/bo+jD0PWjjcQEieWwsRz1JuZcJI38gS+Fwt7cL3FzqIb+pPwdtgDkilGwHg0n0+2a1w1AvqJAppbxkJi0tt8E/ZXjovoeNulyyiHwvQxFZ2SB2WkrBolGf1rbRUOW0U+4++DfnWfRtRHiH+OHe4Q+//ta3onjhCeujdZBMVDrYZhkoM3GHTrE6cCnJYyh5ydz9zLAAvV6tHuLquXPyK6RgHrQ13B2oA5IvQ0cVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QM2mciemxoNxnXnMibzZJDd3nmHfrzoMLVnNdVKqCY0=;
 b=tdgzpgbx16PykfzuDTFdfxeCGOHwhKPnwDWd9/7/POnzIf2BlIfeUBLOzWgIEqsf8zrJOu7zYIJruu6mn2inR4PsdbtSKN5ssrJZYyIvHzOtD7OWIoSOMpXcLclNbsT5tLcePnk7h8pHlZMRHpyS8QudtNecK2OvBrmcaygJmXdQZV5LHLG+YbTZ37QBCeLEF4P1oijo2aLa5JQR8T8tJG4k1M+aJe3YxhX72VK1pGrDdH66YtkhvNYratVkmyhdQ5eFu3EPU+sELJgXxaZeVj1QcFXaYGvI1RGlhTwwyoc7ps/tWpKKrzxMbWLco0pqxewIwCHJeoaWoUoM9m5PvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:40:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:40:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum_switchdev: Save MAC and FID as a key in 'struct mlxsw_sp_mdb_entry'
Date:   Wed, 29 Jun 2022 12:40:01 +0300
Message-Id: <20220629094007.827621-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0164.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57c6b515-fc8d-4280-fcff-08da59b37481
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ix1JVfjbHA4u3qCC68pdWQAEsSaJsAZwdPkrSkMO0Hr13z3vJuJzrGh//VUWy7whgjt5h2OlsXBBS/vwMCv1MPpOiOkSEQwr3PSKyDtmw10WBR3/X5WTn1a1fuIiB8Bg6+RaRW2wtPaSbqIRgOvrIQ+crikDmq4LEiJThsGgb0KniWnh+pbEl4dgNXHmxoecoUbP3HGsXnx/EQIQx5/sgkeNTJyRgzEAp5cGJos9N7CBa8DhMm111/hdJMZVML2+GToyFod15OkINJlRdjvD3K7EKUFR99S/kylQ+Ny0S9VQkXNyX4pVwJk3594XcTUL4vO19mE5bjigZEu8C1v2/aSmV+MqMCldbcOcJNBgm5Z+LHOmU2vCfIfaUPSeTm2XgPSScrinJePzGlfviWND6kLJpAmI5NA7rySsnkERCQ+KyJUM3/wCZeb0T1EWcBTYA8EXXMeqVw0LlVqGFWI4w6VkBSGc6V0Up6AGtW0/eUzJk7E6DxhzzbGwJgGqx1gS/X4n0FHS3fNHPDC01ROAMHN81CRFur28nwRKh3J4RDv0nq72Ujw+UPu0QQlIJ+vu36aDxjFUzyfX5LrXnfHAfoGwxfsrNP5KJ3/3n4ZoQsnoz+DY5Ku5HkBceImcM2FPtXV2u68ROw8zJQ2UA+HWSi/yzFMxEiYaI9w+HxubyeDF+aO9nZF7oivKIg03z5ExSdYjoszIniwTnHRl5UJ72s41ZP9v55MGrebtF5h6QyZAqkJpZaTaz/OmjOQEZrWE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o57NIIBAfJnP03XsP6HWgobp1a/BqDFA6h5vTp3KF2pb7QnXvnf5dDF9j903?=
 =?us-ascii?Q?fsIcb0t7xv7hlIm3C6kcfxsuXEU6pT0XPb4WaXf2iiab84A1Z7yBoIr2ggXR?=
 =?us-ascii?Q?vnJDgiybMkSngHxzlg24NZZ9l5UAHzQX7Wi4s14qwFWsMVGkeEn+w2uAuydf?=
 =?us-ascii?Q?tu3WjSgytVE2Jq1Kxr0JWb3Ahvj1FWra9srKkUcqTPyHQNNrA8Vt9knpd0ki?=
 =?us-ascii?Q?cdpqs6nDmww2aKYSlZfbgsVOgjhVOoUL15yOScgnfC0aIPyiiOdXB8ed14c8?=
 =?us-ascii?Q?vgPsBc/o7qLvddIaqZ2BSJtbXaRnw5Fzz/tyNKu+9d8kaRY+XDUmlr+L/FqV?=
 =?us-ascii?Q?cqSJBhQ+3EVvJBUcV2+XNddDPFskYzGMrqz4pgGO71QKor6IjwY//Z3yLYtz?=
 =?us-ascii?Q?BPiYcDTqseJxOpU492QsVhATNDI4jfBSaiD3lMCczEgmOPaV9goy1iGVe0uK?=
 =?us-ascii?Q?qZuqrQlMe1Ax0fRWY1V6GEQ3/7g+fAsmYJl2ySnFcjgNHVrzyQnd7AG4OdLo?=
 =?us-ascii?Q?HC1RjyKSOi3lI4r1y6LFddXhLk35U9U7H9a9VWhz84wH0yhzPHlYMwS6TCvR?=
 =?us-ascii?Q?peYpSCN1UpW86FVAeRrcQPd4EjTR6Mhy5ojmBge5yi/9kF9mApj8FrTpeEGA?=
 =?us-ascii?Q?FNCVIGOtLyreJC60bvYFMqZ1LJ9YVk/xCFdDd24Z8aBNANEmubILF2WSZLhN?=
 =?us-ascii?Q?Bdrf3mxrG2STvXiw3APJZkYBA6QQxYCrsGznsZMv26bJi2BLyHB9oOg69Ymm?=
 =?us-ascii?Q?idq3+L+X60jRStTFFGnlN7z6tYPyjENSIhrFNKgGV8QyjTEf7h/GnJ+iGKkE?=
 =?us-ascii?Q?qBpU4Jagd25njJXdQcT2ObdPTvQrgFb5CF16SDK4rX54xlOQHEmiybWjcQOP?=
 =?us-ascii?Q?bquEfqdeed2g6u/We+cvgCukhhIANK6+vT9Y17l2bkcpUfozOgWaomXGbyfD?=
 =?us-ascii?Q?rffreNsUjS30RUIqdCbDNAegVE/rdy68iYZ+Z4ZFxspjRv4xkB7FzIGqZTpN?=
 =?us-ascii?Q?DcKd7uNHpmanhaj9W+j9BtbkeLVXMhvBvt+Kjm6Ur4Y2SQnjUelyntIpcVD+?=
 =?us-ascii?Q?8Xg5wunCYnxitRgF6PDzC365ZIPkvtBlH6zyBybBTYvmoRG+ZTp9uNMWKaoE?=
 =?us-ascii?Q?DQ2+09qJRHGSGI8HOGGeui9/++q6MM0BwgfTLMSsf4lk5hvAL6ci5+HNGs29?=
 =?us-ascii?Q?q0xxsQPiq0Clsj+Auh057XEHE7WSfMC2KkSgOTwFB8SGgIIhVFndjB4XViQK?=
 =?us-ascii?Q?koR4GWiqze00r1dtNg3JWTEV/g2h2vzIKX1+YzkA+5DBTui3MSMuCNIF58mV?=
 =?us-ascii?Q?9Ji8KZnO0TJRLcBHKmkz4jm5BLGENTFzBnFrYqAGWsjJiCe+VE4f9fE204L0?=
 =?us-ascii?Q?+Vda8Mv5NBav/N84zzboZMj/W1Oqgkg/+nD4SSohOGPeYNRDq4BS+PZdjRr5?=
 =?us-ascii?Q?cOw2Tgc8uQCOnIgJdrNL81XG8/3vi2UhMtfEssfoMysXqXiZn6U0zed5/pJ6?=
 =?us-ascii?Q?CGeTi3fyZrPeA5/dqrSnEDRcGIFE3yhnxBc1yb5Q+PbxbiFrIxKt/jrvUJjN?=
 =?us-ascii?Q?s1NMppJZgRZ8OLRv5sg4Q9zkYutmku9crzVwyBeS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c6b515-fc8d-4280-fcff-08da59b37481
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:40:51.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tm5kxFlE+oLpJtkKdV8PyuM2njX/eXrthzXT9FuHaLCe3t7XJ0n4tcsMqKD65hCK2sOiZI7ow2ZZItTCyel8vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3850
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The next patch will add support for storing all the MDB entries in a hash
table. As a preparation, save the MAC address and the FID in a
separate structure. This structure will be used later as a key for the
hash table.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index bd182736f44d..d1a1d55b0068 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -102,10 +102,14 @@ struct mlxsw_sp_switchdev_ops {
 	void (*init)(struct mlxsw_sp *mlxsw_sp);
 };
 
-struct mlxsw_sp_mdb_entry {
-	struct list_head list;
+struct mlxsw_sp_mdb_entry_key {
 	unsigned char addr[ETH_ALEN];
 	u16 fid;
+};
+
+struct mlxsw_sp_mdb_entry {
+	struct list_head list;
+	struct mlxsw_sp_mdb_entry_key key;
 	u16 mid;
 	bool in_hw;
 	unsigned long *ports_in_mid; /* bits array */
@@ -1713,8 +1717,8 @@ __mlxsw_sp_mc_get(struct mlxsw_sp_bridge_device *bridge_device,
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 
 	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
-		if (ether_addr_equal(mdb_entry->addr, addr) &&
-		    mdb_entry->fid == fid)
+		if (ether_addr_equal(mdb_entry->key.addr, addr) &&
+		    mdb_entry->key.fid == fid)
 			return mdb_entry;
 	}
 	return NULL;
@@ -1790,8 +1794,8 @@ mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	err = mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->addr, mdb_entry->fid,
-				   mid_idx, true);
+	err = mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->key.addr,
+				   mdb_entry->key.fid, mid_idx, true);
 	if (err)
 		return err;
 
@@ -1808,8 +1812,8 @@ static int mlxsw_sp_mc_remove_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 
 	clear_bit(mdb_entry->mid, mlxsw_sp->bridge->mids_bitmap);
 	mdb_entry->in_hw = false;
-	return mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->addr, mdb_entry->fid,
-				    mdb_entry->mid, false);
+	return mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->key.addr,
+				    mdb_entry->key.fid, mdb_entry->mid, false);
 }
 
 static struct mlxsw_sp_mdb_entry *
@@ -1829,8 +1833,8 @@ __mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 	if (!mdb_entry->ports_in_mid)
 		goto err_ports_in_mid_alloc;
 
-	ether_addr_copy(mdb_entry->addr, addr);
-	mdb_entry->fid = fid;
+	ether_addr_copy(mdb_entry->key.addr, addr);
+	mdb_entry->key.fid = fid;
 	mdb_entry->in_hw = false;
 
 	if (!bridge_device->multicast_enabled)
-- 
2.36.1

