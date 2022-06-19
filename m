Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B845509A1
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiFSKaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiFSKaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:03 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E838CE0C
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAHpcCqt9d76cKmTKXvx5HTGc6mRYX6TWGEUK9oLAWdnom7BBacyRF5mhMK1j7P0JmL9UQ8iIEIwn/WUf6zKmFqb4OvdWFIZe8ifubOczSe+i/xHE3hyQa55XQXX+E0yEKw1vil7zIYOH9RvYxWJ0L5CCFs0Dt5LzeYdQsyIYmer2mqDxaBMnbH4ALBdJXOTkSYHn5kXkKYdDqSwcciprvBISqoq4HOflJPxexdZx5qLahayDye1HWL3TYHYQGpaglrTJ6lQYPDcb2tr42X0LOoP4MnSkhsiJx3KouupfHnlboyOSWc8TW/rCJXZ0INo5aQvGIluTqF/QwyZ7peCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxxVNBrZ4r0vw3uTcY4JjgG2wP9XSDgdm+0xK5VMZqA=;
 b=i9Mt85qbGqPTwd5tIWBRF4KJPd3vBYX06YXlukjHzQJsKSriVIDJtZOyxyYxHEsD+0YfbtVtU0Qtuf7QSNknImsCmjkLZwLjvtGPXQT12jE65RugAG3rYtI4QaCDjO/uZHYQps4GSSWor9xUez5gkgvGQcLs1QymfoFlxoFxkeN/bNCSeubSZj1tjgg+Mbyv2ivdf3ujTBgHWL59YhfBX1tyUaJmeUJ+cOcw907uOrry9rrXRdJg50XOOjrAF6GDhUKu6WOa1n/npASv667mDMQhleDO/Kfv9uHdRs0LhWBZJModnFnJGaMpSMANpjgJ9rSfZJ/hIZgVCEbi7fhSCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxxVNBrZ4r0vw3uTcY4JjgG2wP9XSDgdm+0xK5VMZqA=;
 b=OiNCTwNIylnbqjw3X0D73CqUTKESCHJaxgJefuizkMBdSL5T5coN/1hkVB8IcFn5mJOmqjcIZe/0H8gdcOfRUc6KdQXmF070UEqJVVhgdKerZ/ZjGkkim26C0lTrLaUOoek576xtDdf3iWA6UJgcFQ9kCLtXNvmYdZd6cyJlEcJImz5oh7yhthAyog4MP7pzVHbh5eQmimnHOzhDHLPGjcuFGyf8k6nyryoAFq39232/zui3AoHVgHxqjPOvyzDd0hSHdO03V0ea3P//EnfqzrYU6POw4Xwa5u1KYd77NVMEOFevE+TDo4oNalBwydRB2dNCFsASw9z/pp0w3PKP4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/13] mlxsw: reg: Add 'flood_rsp' field to SFMR register
Date:   Sun, 19 Jun 2022 13:29:09 +0300
Message-Id: <20220619102921.33158-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0033.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50ff892c-fa24-422a-2f77-08da51dea9f5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193FB9B97017F38DA7EF115B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huTCIfH7qoHpHUaVMKmmgRBCGBFwVmj8W1iqtai1YdPICY2AldpKdIF5B1LLR9spvcXXd8XvHT/sUbflV+YEPsgnoSObfc4+HhQ7YPyiufE32MD+SQWzlYE2E4VNh75OFdTCiiIids17F5nEv9nt/edAZl6PHd1lfSS+y9BGgBhI00zLVDYfnL1ombiPPDVuhAFj0AvNn8BuWGcoGNjRN4tC8z+u9dbClny3H8zDokGI2jPfNi1z3hEcPOUsSTB51oso62c26Mg6i1fmDJ2MJhAdfVFZEVTpjEVKsgFjTPuSVN86Ah3+6IbfOsywNVciEilF0vyGZUNheIO6XRbg3on+2DKTiSS4rACP+KIYqfckW7ud4S+swaxllCrKoHtFAZB+Lg17llFfSpCsfL7LcVs3zKOlQl6MqWMltkQfB5cButSCFBqqDJdWlEMAcMJwrVBMzutrphzahTbJpTllN9xdD2Z8DtzeS5Aby7R1sYi21bBCiSD89BXAp3kISZHDi3Y2ERd7E8BlE2BZXSicVGH1MtDnrkLVmgpkuIzox60ZhFEYKgUGF43FQbf4I09WfkHlfcCqFhsyov3Z/mqN6pJ4RPiizt9Bs5sAdIjeJEYk8fvog+wdQFg24IlfrTqe2B0aOfvfI7UJ274iqOqXMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ymuQ+4SN60BTrPj7ly2hotqf78X1vdSvf4w6S5P0rdgBriB/iLo+jK8cWJMd?=
 =?us-ascii?Q?YNuQmlR1faF1GtEcWtL87CqwNhs+r9FAHfWlJLIAEU9+TiD67kQdj/VZs/Z3?=
 =?us-ascii?Q?OGFiul258PjlsuAOjTNboVnwX2xZsT0iUVTST3YxcY4SL3I0f0c8ikf/et+t?=
 =?us-ascii?Q?C1xOL/DdS1zj33UjqDobdxsl828faffgqwsQ3+Zy9YusJGznFoVNEP/MYh2v?=
 =?us-ascii?Q?KPEDQ0w4iCcQRpPWZvIrLdXeK1eUeHr3sylD5jGGT2zlrvXd1ik+jft8H3/E?=
 =?us-ascii?Q?qgBm0kh38ftv3GBTt42QArcUHayb5keqpHNB6z9q+Wb90X9KXVF8f9U0iOia?=
 =?us-ascii?Q?GWJ1l91z8jPn9fYcWhoEb1XezHrTySCMX3MTpfUYflGdXnYi+ZHTh4xuTS7j?=
 =?us-ascii?Q?IYaz+yCZi+Jnt4I09e4svzbdA61XxYjJEf0dyxxdzVW7DS+eiQtOMxc4oGiv?=
 =?us-ascii?Q?QUJw11suAaTKptONocphMgkN+MrMtQxT4YCf6OSezfQrRUU63xRRhf//FRm0?=
 =?us-ascii?Q?3h1ipELCjQP579SMxds0Nzh+NxK8q92DAfXSdCoRY3WEmmV00RuwIM08x7b8?=
 =?us-ascii?Q?nYg1vdu3loLJyBh+NcjkDFxt73ixrG3Z0X8/kOL+t9gvJfPpthZmpE9xpjKU?=
 =?us-ascii?Q?KLxUkptl1m6F8ZHDJx3g6IEvabu1g2KGyROQDWNSfUZ6C8RdlsaxBGqBOWqp?=
 =?us-ascii?Q?VuTkq8d43ClClA5MjL+vVv5FO+Wv+Eibf5jgIRi5a6wCd1oHWozx8T/tvECg?=
 =?us-ascii?Q?z7i5bYh2UPcPikORpGmnScu6NWAZsylNfV35/55iY3qIasU5j4vxelBy1cr/?=
 =?us-ascii?Q?O2rj0TlHTn+8lstUBz82sTGLByY0Ox18MhEVUFsR1Qy8LU1e9zcm3Nhh/Oy8?=
 =?us-ascii?Q?NjyvNHb5+tKif6iXD0Vc71bhrZa66VPVwtBcIfXbl+UcO0DV4R3Va5bcKVbI?=
 =?us-ascii?Q?An/+xc3en48Lym/26TbS/xMOCOQKdIALsaHLuJyCuVS3Pp7hw08OaNGDJLKm?=
 =?us-ascii?Q?23vbRZyPVVNGGt4aIWT4uap0ZnRKHoPhvdo7zPz1YqzaoIkSpNmWsUGnu/JY?=
 =?us-ascii?Q?RmC5HRqzpCOJz75SxlKZH8pQATMKk+RKJqob7KzCzlMtJ+xuwn13IBZEpeJe?=
 =?us-ascii?Q?+dKXmROqw7jvZ5v6IN/ZiuNhnkV1p9Lj/AebsSLvYfwCaH6Z1XAZCiAHbi0g?=
 =?us-ascii?Q?MQMcMbw7IWUjuJNFA6+sTDg3Xi7Ki5ud6eroQA1I/SakxJszvDuNwG0yU/k/?=
 =?us-ascii?Q?L7k9iHBnEDc8h6ZLVCueYcdE1PkWlv2ILW59pa87a2oRo5djmVDsEcZfw0a+?=
 =?us-ascii?Q?zM/X9YPrdbDxhOFMHEDcLnhoLd19ImklsugDYAU6UM3Nx3mYezZHEDwxNtkp?=
 =?us-ascii?Q?kQKZoTFfivxtqFosjdzUxVxV3RVSAdjITfYLP+eBEXJlywlBhXfDUsikEfa2?=
 =?us-ascii?Q?otb5fkzJVErNymisZVsMjYHz6/P6oVRDJTHetFwQCxM0lneHdUYkKLD6vqe+?=
 =?us-ascii?Q?4hpLQFvrEY/5hKN9BTPRv+nu9N5A3zHaqMAX/BLrkpzM0CDwz/xy/KVuZ0xN?=
 =?us-ascii?Q?wZMD2ewRDK1pp1jssbWFTgE2eXDBJjiRIdAhtR/W9tpqZO4p0y0d4UJOKWFQ?=
 =?us-ascii?Q?0slwJxXGhwkuDpNVy+yW6jRz5C1zlMmvFSA8LxafxaCc96+6kGhstnf5BXYz?=
 =?us-ascii?Q?BWu1jby4sWTo5wmNwygWaOTlC6kg0iLSDMqrUlE0NcMZl40bCxWY9mnXHUeA?=
 =?us-ascii?Q?6awHJGZmww=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ff892c-fa24-422a-2f77-08da51dea9f5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:00.3447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b77xVHp19y2oOMNOys8nV0FqrQcHfVecYeT9MDiyK+gS+2qanFbij7pxPHo6T6tYd2vNv2ARIhdsY24njUCRAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SFMR register creates and configures FIDs. As preparation for unified
bridge model, add a field for future use.

In the new model, RITR no longer configures the rFID used for sub-port RIFs
and it has to be created by software via SFMR. Such FIDs need to be created
with special flood indication using 'flood_rsp' field. When set, this bit
instructs the device to manage the flooding entries for this FID in a
reserved part of the port group table (PGT).

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d830a35755a8..18b9fbf11d71 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1764,6 +1764,18 @@ MLXSW_ITEM32(reg, sfmr, op, 0x00, 24, 4);
  */
 MLXSW_ITEM32(reg, sfmr, fid, 0x00, 0, 16);
 
+/* reg_sfmr_flood_rsp
+ * Router sub-port flooding table.
+ * 0 - Regular flooding table.
+ * 1 - Router sub-port flooding table. For this FID the flooding is per
+ * router-sub-port local_port. Must not be set for a FID which is not a
+ * router-sub-port and must be set prior to enabling the relevant RIF.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32(reg, sfmr, flood_rsp, 0x08, 31, 1);
+
 /* reg_sfmr_fid_offset
  * FID offset.
  * Used to point into the flooding table selected by SFGC register if
-- 
2.36.1

