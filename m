Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E001255FC40
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiF2JlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbiF2JlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:41:14 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB333B574
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lECjNTOu6JIFs0HAjCNL9/8nCYuK59eBuZYsR7JjdPAweexTt+kOXFQQ19nHYO+IzWS7fWhCQRMT1nvNnWiib7ieZXI9QsnHSx97ZT3BJlMgMiyJmEqeNutT8fqi5biItkius3BhmcqBnPC4nh2NswVnWg1yHkIEk1vkiDva+t1niDdq4lpg2ihkwGps5UXqPZ9gdocrQpFtclFIm/nrb6qkLdPZED7US0VC+dHPTx20hNsrbG3VLqKrnCQObL99ZewpQU3iTQUdUXy6E6sU32I/jgqtVkRKvBa1glUSukqu7cBc+d+exHEUZLQDhUcnG0uwsqrnQ5lRI/hwCQ9zhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCp9r79aVrrrmidq6j5HteGL0Vr3BUBqp31bMSZvy/g=;
 b=mSN8LB5cyxnrN4UyDRGbEj+rfpneyo7U1m6jJUBsUYEP7M9VYyJW21jGoVu64TG0EBtCEFjUjGQXsAz+q1bGDGHVj5S/WWspdWi4+U2+mfjn4hVAR1+OjSarKj49KcYdz6hzZGX7uUdXdvbqP79ib1tFev+WRpRd9p4r6u00T5mtNMkcsasyiEQ3HZOa/bI1g/EqQgofSfCwv019Rmdz4/tsFwIa5B1FGMkhfLjNU0Y7ik6nRDKy4xUWyss07Q3zvYevi3i85GJGeFhHXksYaVSBkiv6fG9IZ+35Lw/rLGOfqQbYyUHII1jVZ0zHMxJ80ctaOyhhduDE5V5kiephsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCp9r79aVrrrmidq6j5HteGL0Vr3BUBqp31bMSZvy/g=;
 b=Tfe+Idf2iQioLwF/hMqAAlq3yx0E92iVtv/XapabA7CNImRdXlltGX2nbG5oIMlJZuvwKY4VArcEEQ2i9oQmJTurcgEmSZzKlBm8WNWf5v1AUMIO1/xwoOi1mGmz+KC6zEdhA056XAX6v5BNCNdNXBftIAKjQX8+SWPmw7VYi6USeC0kSjoE6M9FaN13PRGEu2pAPqt87QrtXZCEJo9fpDOKRDXccH9LVzYj4gTmJWMBsaLtt4k+kKX3lYUoCYsdFnk5zRM6DC//J3H9KIiJ5amk6ZyfGqtjtwNdcKU8o6CKKQhKKYFywGAy7cSkpQrrn8KWlf91g+2JAtIF4bZPog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:41:11 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:41:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: spectrum_switchdev: Implement mlxsw_sp_mc_mdb_entry_{init, fini}()
Date:   Wed, 29 Jun 2022 12:40:04 +0300
Message-Id: <20220629094007.827621-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0075.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdb2416a-70c7-494a-4d68-08da59b3800f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hv7N/p0iANRJm5+RyPllMaL9oIAF8o22QjpGRIolIDoLXkFSB+6VodVuUw6YQ/BqLn/Z01LXFC4NFPGp3zDNaamX0vcRB4SYScwEnoPsFENW2gGDZWGVwOMycJ8GiZyEqsjolt+y6Bl7qPubDfEN2Zy1aPPkHlGeoQZQiyKRf9HEowIse8wkOmB23Q0HDK6cC7juXrKwOtlpHmYB1GKTkMf3vZZv7mKv1glSuvXpDRuwqrT+Sw7DtMM/pJ/ksmLYODeO8iw1mxlRR1sLVcLJ6teSdc9VkjVsPeDhoAnUO39k9H5r5DitE2zg8sKZy+2cCYKfNVrJOHnz0ILZNNFE8nWjSBTx1aggr/zuJMRl4SFjdYo1PqpS+TAhp9hw73jYlOJm439OAI7n3MuZhqJwRHDY/dUu6heuX9r7w8vYMbvtKE+JF19V6hhcp0Q/KBBKgjQsMMM3GMvW8+ii4S7Q1vdcfXs8EGepY9uOjURRrYhlLOMPDEfgxaJUn34InzQu8cNc85blWZ1WYnwoHFHPvDRdG9QErs+UQPbGTcRWX721keTfDlNPAzUUCMCxteGTxjYieZJoe3KICvVDCSEOQ6j+WvBli3Wh4nWPXaDmWeS7J1CviPPCBTb+uBj7CjNNGElCof3hwP7dYCP/pw5UDuTG4hV4NUVwy0vN0n7AuKk8TiI5StBLMOjljtzvdoPltf4EtiRe9PZ5qMiWX401J9bVez/3E8zN0DScMDbkxg9HCjPKw7RTKce6jL/DPL4J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(66574015)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JG9k8cRKvTqRFZ/LqB9VxatXsN9Pfh7z5bKkOk06cXosChrA4O4tPn57heBY?=
 =?us-ascii?Q?4kf2Wu2PMjrqt3U3qCqerbwoKCPrulumaT2lf30LzNo/apVR+jZ0/PWeN2IJ?=
 =?us-ascii?Q?EDQ0+NsfpkCYFer0hLDeXrSrItApwYrpSiTtJAx2FV1ZFMsn6bVwxWbMlSyF?=
 =?us-ascii?Q?fBkBCqWSwJ/VENfYqWViOWIZkwRcLkwniNSrtYl6MZ0DGFYREBIi1zZ9pzj6?=
 =?us-ascii?Q?LvciFSbosIZkaK3NmAxI34MK4z/zU8zjhInJEOUzagGx1/i4YAY33FCyp8NV?=
 =?us-ascii?Q?OQ8p9U1z/JF5x4zQsVzontq8dJLz9RLMvSEnKgXBI8Z79b31tJmcf30NoakX?=
 =?us-ascii?Q?FbAUHkvDxlRLTnhHACnmDjR+tZ+bYPnleSYP2p84RAmnMHlXT86cT05/l4GW?=
 =?us-ascii?Q?7FWiUGvZ3ZM8HwQswzATDG4yKVk1ZIkoqmGajXlx46oAK+r0jPOavesx7O/U?=
 =?us-ascii?Q?MBd/kWDXZYjyZ00ohNd+fPHfGRwVj5cOXXh441PGoWqlveO3QcpFHPhVxHEU?=
 =?us-ascii?Q?rnwn2HoY//YMQfCegMoJrR5Hf+8x2sV4LBXzCxZLAoCyrLeD9LGssDlu2U5+?=
 =?us-ascii?Q?jRBQ9seAf8mnIR6QYoSKUdMfvZ091q8G4IDs7Ldf9S++BEd6TSouujYvo4cw?=
 =?us-ascii?Q?9JeOtMSoQhEdCYcQKVsbUbPchmGYqLi4l9HOpOgRyv7hmj6Qma5qT9bYp/+K?=
 =?us-ascii?Q?qruvF1F+4fQF7+I2cDTlbspdmPbwNms1lVYLarL2kNBn390RYuMYWsRHYVbF?=
 =?us-ascii?Q?nHXLq0hdjkIWKZ5XALidV/OfneuwJdm1Zh9WbP5xIoSVsTRdgay9oGIyVHQN?=
 =?us-ascii?Q?c581P0iYycYWobN6WaWLf9Raelg4F3qCcqleznsj27a/qN+bfRTJzK6X1ksq?=
 =?us-ascii?Q?j1OCEEDG44tRaweMwZ+qb8sFdaQXa9YSF5DGfAogiV417gmZiMAjemq8UqU2?=
 =?us-ascii?Q?KNCUG+6ZRk2omgxNrhJ73hg/d5B1o6flHus8QmEIfO9SiIzob/8ppC0BG+jK?=
 =?us-ascii?Q?iHhzraHQsWdDvv7MVuJAYqkMDRySFf8NsdFAw5MxkF4BAXf7AXhPcEHXNACJ?=
 =?us-ascii?Q?U6Th6WrZ4VToeaoQCHOPGCrkfOWu0No8GCNku/eTD2wRmF9Tn228I+bQCIlZ?=
 =?us-ascii?Q?z+WbitPA1RLIuCVZ8ojvRG/VyN49C8gW72vKW4qha5uBy9mlNDCskV9QKn6x?=
 =?us-ascii?Q?sMhZXKusy7XfkE4LWseJMfta9dusNLePlCKatlN/K8DtlR5IOmkJw0mAAhSs?=
 =?us-ascii?Q?laPYdcavrZAFyBXQZPlEJ5imXWVFeNAwGtFwWxBicIFy3FYkjcFl0uJ0nyzG?=
 =?us-ascii?Q?ESS4ASjVPbjn/fKo97WRIqOWG8VPLe3Llgww1EmBpiE/sdeRYfGTeaBJZBsA?=
 =?us-ascii?Q?4c6v73WYM2n5kGsbQh7XHQq6k+Z72IxOtKr/yUcbFumHh5Txr8IPbxEm4G7q?=
 =?us-ascii?Q?jjvzMewJnKXOE+BOVv7yzx9hGXQ9xe/ty5kbIPnHg65ky1qnD6h5jy28EZmP?=
 =?us-ascii?Q?JO5Ji9+eBsQSokoiju0RGroQzIPaiQVC7Jurwonk8L80LMl18BnMQE4CkUl+?=
 =?us-ascii?Q?whB73rw47vbBoHyQu52ZU6KR+0pTw73ybniSJmrH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb2416a-70c7-494a-4d68-08da59b3800f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:41:11.0881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pG0HuXKqMITbvj/EcBb5cNIjHv9pg8pFs9JcnkAUmjtdba+EyyNF9OO+jQ5JVG8Tuw6GlXDsYRbxBzeP5Oum7A==
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

The next patches will convert MDB code to use PGT APIs. The change will
move the responsibility of allocating MID indexes and writing PGT
configurations to hardware to PGT code. As part of this change, most of the
MDB code will be changed and improved.

As a preparation for the above mentioned change, implement
mlxsw_sp_mc_mdb_entry_{init, fini}(). Currently, there is a function
__mlxsw_sp_mc_alloc(), which does not only allocate MID. In addition,
there is no an equivalent function to free the MID. When
mlxsw_sp_port_remove_from_mid() removes the last port, it handles MID
removal. Instead, add init() and fini() functions, which use PGT APIs.

The differences between the existing and the new functions are as follows:
1. Today MDB code does not update SMID when port is added/removed while
   multicast is disabled. It maintains a bitmap of ports and once multicast
   is enabled, it writes the entry to hardware. Instead, using PGT APIs,
   the entry will be updated also when multicast is disabled, but the
   mapping between {MAC, FID}->{MID} (is configured using SFD) will be
   updated according to multicast state. It means that SMID will be updated
   all the time and disable/enable multicast will impact only SFD
   configuration.

2. Today the allocation of MID index is done as part of
   mlxsw_sp_mc_write_mdb_entry(). The fact that the entry will be
   written in hardware all the time, moves the allocation of the index to
   be as part of the MDB entry initialization. PGT API is used for the
   allocation.

3. Today the update of multicast router ports is done as part of
   mlxsw_sp_mc_write_mdb_entry(). Instead, add functions to add/remove
   all multicast router ports when entry is first added or removed. When
   new multicast router port will be added/removed, the dedicated API will
   be used to add/remove it from the existing entries.

4. A list of ports will be stored per MDB entry instead of the exiting
   bitmap. The list will contain the multicast router ports and maintain
   reference counter per port.

Add mlxsw_sp_mdb_entry_write() which is almost identical to
mlxsw_sp_port_mdb_op(). Use more clear name and align the MID index to
bridge model using PGT API. The existing function will be removed in the
next patches.

Note that PGT APIs configure the firmware using SMID register, like the
driver already does today for MDB entries, so PGT APIs can be used also
using legacy bridge model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 176 +++++++++++++++++-
 1 file changed, 174 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index d1b0eddad504..bb2694ef6220 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1018,7 +1018,7 @@ mlxsw_sp_mdb_entry_port_lookup(struct mlxsw_sp_mdb_entry *mdb_entry,
 	return NULL;
 }
 
-static __always_unused struct mlxsw_sp_mdb_entry_port *
+static struct mlxsw_sp_mdb_entry_port *
 mlxsw_sp_mdb_entry_port_get(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_mdb_entry *mdb_entry,
 			    u16 local_port)
@@ -1060,7 +1060,7 @@ mlxsw_sp_mdb_entry_port_get(struct mlxsw_sp *mlxsw_sp,
 	return ERR_PTR(err);
 }
 
-static __always_unused void
+static void
 mlxsw_sp_mdb_entry_port_put(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_mdb_entry *mdb_entry,
 			    u16 local_port, bool force)
@@ -1801,6 +1801,37 @@ mlxsw_sp_port_fdb_set(struct mlxsw_sp_port *mlxsw_sp_port,
 						   vid, adding, false);
 }
 
+static int mlxsw_sp_mdb_entry_write(struct mlxsw_sp *mlxsw_sp,
+				    const struct mlxsw_sp_mdb_entry *mdb_entry,
+				    bool adding)
+{
+	char *sfd_pl;
+	u16 mid_idx;
+	u8 num_rec;
+	int err;
+
+	sfd_pl = kmalloc(MLXSW_REG_SFD_LEN, GFP_KERNEL);
+	if (!sfd_pl)
+		return -ENOMEM;
+
+	mid_idx = mlxsw_sp_pgt_index_to_mid(mlxsw_sp, mdb_entry->mid);
+	mlxsw_reg_sfd_pack(sfd_pl, mlxsw_sp_sfd_op(adding), 0);
+	mlxsw_reg_sfd_mc_pack(sfd_pl, 0, mdb_entry->key.addr,
+			      mdb_entry->key.fid, MLXSW_REG_SFD_REC_ACTION_NOP,
+			      mid_idx);
+	num_rec = mlxsw_reg_sfd_num_rec_get(sfd_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfd), sfd_pl);
+	if (err)
+		goto out;
+
+	if (num_rec != mlxsw_reg_sfd_num_rec_get(sfd_pl))
+		err = -EBUSY;
+
+out:
+	kfree(sfd_pl);
+	return err;
+}
+
 static int mlxsw_sp_port_mdb_op(struct mlxsw_sp *mlxsw_sp, const char *addr,
 				u16 fid, u16 mid_idx, bool adding)
 {
@@ -2040,6 +2071,147 @@ static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
+static int mlxsw_sp_mc_mdb_mrouters_add(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_ports_bitmap *ports_bm,
+					struct mlxsw_sp_mdb_entry *mdb_entry)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+	unsigned int nbits = ports_bm->nbits;
+	int i;
+
+	for_each_set_bit(i, ports_bm->bitmap, nbits) {
+		mdb_entry_port = mlxsw_sp_mdb_entry_mrouter_port_get(mlxsw_sp,
+								     mdb_entry,
+								     i);
+		if (IS_ERR(mdb_entry_port)) {
+			nbits = i;
+			goto err_mrouter_port_get;
+		}
+	}
+
+	return 0;
+
+err_mrouter_port_get:
+	for_each_set_bit(i, ports_bm->bitmap, nbits)
+		mlxsw_sp_mdb_entry_mrouter_port_put(mlxsw_sp, mdb_entry, i);
+	return PTR_ERR(mdb_entry_port);
+}
+
+static void mlxsw_sp_mc_mdb_mrouters_del(struct mlxsw_sp *mlxsw_sp,
+					 struct mlxsw_sp_ports_bitmap *ports_bm,
+					 struct mlxsw_sp_mdb_entry *mdb_entry)
+{
+	int i;
+
+	for_each_set_bit(i, ports_bm->bitmap, ports_bm->nbits)
+		mlxsw_sp_mdb_entry_mrouter_port_put(mlxsw_sp, mdb_entry, i);
+}
+
+static int
+mlxsw_sp_mc_mdb_mrouters_set(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_bridge_device *bridge_device,
+			     struct mlxsw_sp_mdb_entry *mdb_entry, bool add)
+{
+	struct mlxsw_sp_ports_bitmap ports_bm;
+	int err;
+
+	err = mlxsw_sp_port_bitmap_init(mlxsw_sp, &ports_bm);
+	if (err)
+		return err;
+
+	mlxsw_sp_mc_get_mrouters_bitmap(&ports_bm, bridge_device, mlxsw_sp);
+
+	if (add)
+		err = mlxsw_sp_mc_mdb_mrouters_add(mlxsw_sp, &ports_bm,
+						   mdb_entry);
+	else
+		mlxsw_sp_mc_mdb_mrouters_del(mlxsw_sp, &ports_bm, mdb_entry);
+
+	mlxsw_sp_port_bitmap_fini(&ports_bm);
+	return err;
+}
+
+static __always_unused struct mlxsw_sp_mdb_entry *
+mlxsw_sp_mc_mdb_entry_init(struct mlxsw_sp *mlxsw_sp,
+			   struct mlxsw_sp_bridge_device *bridge_device,
+			   const unsigned char *addr, u16 fid, u16 local_port)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
+	int err;
+
+	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
+	if (!mdb_entry)
+		return ERR_PTR(-ENOMEM);
+
+	ether_addr_copy(mdb_entry->key.addr, addr);
+	mdb_entry->key.fid = fid;
+	err = mlxsw_sp_pgt_mid_alloc(mlxsw_sp, &mdb_entry->mid);
+	if (err)
+		goto err_pgt_mid_alloc;
+
+	INIT_LIST_HEAD(&mdb_entry->ports_list);
+
+	err = mlxsw_sp_mc_mdb_mrouters_set(mlxsw_sp, bridge_device, mdb_entry,
+					   true);
+	if (err)
+		goto err_mdb_mrouters_set;
+
+	mdb_entry_port = mlxsw_sp_mdb_entry_port_get(mlxsw_sp, mdb_entry,
+						     local_port);
+	if (IS_ERR(mdb_entry_port)) {
+		err = PTR_ERR(mdb_entry_port);
+		goto err_mdb_entry_port_get;
+	}
+
+	if (bridge_device->multicast_enabled) {
+		err = mlxsw_sp_mdb_entry_write(mlxsw_sp, mdb_entry, true);
+		if (err)
+			goto err_mdb_entry_write;
+	}
+
+	err = rhashtable_insert_fast(&bridge_device->mdb_ht,
+				     &mdb_entry->ht_node,
+				     mlxsw_sp_mdb_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	list_add_tail(&mdb_entry->list, &bridge_device->mdb_list);
+
+	return mdb_entry;
+
+err_rhashtable_insert:
+	if (bridge_device->multicast_enabled)
+		mlxsw_sp_mdb_entry_write(mlxsw_sp, mdb_entry, false);
+err_mdb_entry_write:
+	mlxsw_sp_mdb_entry_port_put(mlxsw_sp, mdb_entry, local_port, false);
+err_mdb_entry_port_get:
+	mlxsw_sp_mc_mdb_mrouters_set(mlxsw_sp, bridge_device, mdb_entry, false);
+err_mdb_mrouters_set:
+	mlxsw_sp_pgt_mid_free(mlxsw_sp, mdb_entry->mid);
+err_pgt_mid_alloc:
+	kfree(mdb_entry);
+	return ERR_PTR(err);
+}
+
+static __always_unused void
+mlxsw_sp_mc_mdb_entry_fini(struct mlxsw_sp *mlxsw_sp,
+			   struct mlxsw_sp_mdb_entry *mdb_entry,
+			   struct mlxsw_sp_bridge_device *bridge_device,
+			   u16 local_port, bool force)
+{
+	list_del(&mdb_entry->list);
+	rhashtable_remove_fast(&bridge_device->mdb_ht, &mdb_entry->ht_node,
+			       mlxsw_sp_mdb_ht_params);
+	if (bridge_device->multicast_enabled)
+		mlxsw_sp_mdb_entry_write(mlxsw_sp, mdb_entry, false);
+	mlxsw_sp_mdb_entry_port_put(mlxsw_sp, mdb_entry, local_port, force);
+	mlxsw_sp_mc_mdb_mrouters_set(mlxsw_sp, bridge_device, mdb_entry, false);
+	WARN_ON(!list_empty(&mdb_entry->ports_list));
+	mlxsw_sp_pgt_mid_free(mlxsw_sp, mdb_entry->mid);
+	kfree(mdb_entry);
+}
+
 static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
-- 
2.36.1

