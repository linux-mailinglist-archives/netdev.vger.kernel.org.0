Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900AD57F3DC
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiGXIE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbiGXIE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D020D15FDD
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrGHETzLRLjCVWknw1Uzvt1xdPJUd6XZu5Rv+fGFf38E66UOk8/tSNA3ua5/NyCxN1nfy6KeYPvAUQYxVnuEQwl4TomA0DI2CFhsAH/xhWOjDIIAXxNJW3IP81kbEe8R4rU35GuJlbh4VSBc+RODHxO0+xGzKPPvkHrgcDZ5UA/BGXqwsOxhQI4ZRZFuyroF7zTTgCUjUUeLhxB/mWuwK5ZJSEeo4wImWPZ/msy73rFqoXMPF8MLN5SfcecukSxLP5V7CYXNJUSdxI0WKlW9cVDWhUYCS7n6CfbqG2fl9SKCa9/XCr58SCNALoWPCFJd41Fz9ipt/8DvVjTLRdj9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNsPeONyoz8dkAsaHccEtUDXetA5SUzaOK7ju6BrtQU=;
 b=jeQUoJVmM7e9jwFWvbFvsFJhScwQfj+E5v8p2Z4wGrSIPw/RNGJ5vbyBZFUm+rpPfqbpRj5IhUfZ30bgBbXSDd4igG2s4FRCo/2TEWm/U8eR98JkBon9XZYIeUAxBjA63VxybmmnvYyi1gRe+VHTQkbB7KN7cz5GqqBTl6rtwdrWipkXElHhpafc3zBP4ju2JaJ3Yy9vO8J7FKac0Lhi0rLvcYibmUHqjmfw+kwjKzpKwfyCk7KfUdoV2NzJWhahSQgldXcjjRofVBDwOKqV8RdlHKCbprXTD0/O45PyxjWX0AMR7GvA5wO7LX+C96R0mJ1aqpzVytTa4vg1yTQnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNsPeONyoz8dkAsaHccEtUDXetA5SUzaOK7ju6BrtQU=;
 b=aXFLfy9Dn50ZTJ5Ruw5NeMpZBrEX3m8Df7fXEDPz03SWz8PFPe6HJJR6nzoat8mO5M5hsxyTOtCjfxT+vQt0qkze6r7oI2QncivNk4KGJpaJnCPkmXn8bAffa+LgYS3aCyNlVCF4naPSY6n7ZY8LS/gHYd7T6RhY/yR+/jHN9zfvEosipvAGTRCzrl4UNzekejYJ3IGIAyi+rt8Q3Oi171nXGVvBKgbiDd8oLjhCKuFYgDI4pf00YvWQBCLQ4kMmkfUFjGkmPq7naNP1VAhVvETc73WdHslVlJiVWgotnbsPX7yiybgOXIzKX81oYnXag1MdeCiu2JSi+8Lvaij3fQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/15] mlxsw: Rename mlxsw_reg_mtptptp_pack() to mlxsw_reg_mtptpt_pack()
Date:   Sun, 24 Jul 2022 11:03:15 +0300
Message-Id: <20220724080329.2613617-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0407.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dbde3a3-4f6b-424e-a270-08da6d4b1feb
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xZrFaCxnSK50TkeekCCzcRicRX0Q0XTZhxGt+yRugrzdkR69kqTpNliD1dO+j+2bPpjBpq7R4dHjiaQRD8CfIhpvdfTvkbikv6zFXsprPviaXXHAQJ7IGvBsM5UeqCAWJ+STl5fq9bpFqtF4ch6Z5PljU3nWROgwQLZkaE7lecISamAi6cr2slRVoCbYUxfA+2Z4D299sKhJHnetnOVSvQs+/ZAcKzDc4H6g1F6xPfZWX1HnipowM8ephbcgPDcMOay9nGYC8j0ScULj/eB8oYF9tDFJTi7tCp3uumqNmBP7MoZFzdgAa61OXsbWugFk3CUqQSSCvyQWd9BVKUVpZdHSBlYMPMSvqGA71NJ0QiECymX/EgGaUnrB8zdaMKd7jc8C4ItkuykUqySD/Q2zk1BROFSYX3D+Oh+4uQhnhwQF9u6H3r5BMocRkgsDno8yDz6xiYaTsUEcQxkc7GZL+B8I+ep+TjL2lya8IL6wSvKDf8kYVFagwPT0bxukM4y92VZJiNtthiQXK43Pxi92YmlFD24I4e1Fa2a80b/3ciwOAXFzkZNKLwiHkeHfZZoSXTjcc7NT9c73dym1JYZE4OLPo13UZqoL5Xo3VpLhJr3RsJ2z0NbmFeHhVVkTyox++t1ucPVMqMQPEgNn9Der0bOHQkhDsl9M0Zjofmvu1YUk7F2GE6LkjidblxWU+2f+xh477MfPvEv84IN7BprqVUcbViRoTrkxPVvYb7qRqDzgFgEYFahoK8JQESbzGCD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oEK7vffpLuQkO1BdgkeeVB3cAIogO4IphtYoETJ87Tz23LNzvu5ZiHxNcv+9?=
 =?us-ascii?Q?k2m7MViD8hktAuACWErxPNkfd0nfS7hYkih/te3KocTjydT0CINnUSpZrhpk?=
 =?us-ascii?Q?Gf5kd77+FvgJnlfb53pYCJE5oJhR10lBC8f31Cfu8SfXL3I9LrhB1feK+6fE?=
 =?us-ascii?Q?Bk+4Eyuh2kqsJvh+AdZDvqTss+lJwiNq5igRBaEM91Ypsclh5vIW1ZqcvPK1?=
 =?us-ascii?Q?lXTTLfWHfzZYZq05+PPvK4VksqyBGZIv/H0+gTGqMWhO4IyM8KJccQOEG6Ck?=
 =?us-ascii?Q?Mz5NOzMU+I3UUE3htI0T721QGWayTXGtcN6ttqHxfVmxcnf64TQtPfLkUPrZ?=
 =?us-ascii?Q?wyuiDM78+m39kvv4x6HGPcQH6oZ55twkGLrRn6pwylH+RgLuGtxdMyP9oj0A?=
 =?us-ascii?Q?L5U3v07F+ceZsAQiZdrqPch9tVRjhF9Ddd9Rj964Rqg67UiXZcUBBvJ4Qkej?=
 =?us-ascii?Q?SOiHkilDZ3ZOhwqNqrOno9BTZQY3LGQnRZYYwyyOHMRCMMlf0muXnQxsrWKA?=
 =?us-ascii?Q?yE1/JbnWVdhsUHj55oOcs0pZ0IavYHBqsroN+BcOzUYLBckS5+NrY6wNZKbg?=
 =?us-ascii?Q?UmvQ+73stQRFql8mUu49TzLaCXEj50NjDKHpF3+ZPD6N0X2TYyWAReTo0Tdk?=
 =?us-ascii?Q?RzyAmN2U19cuSat+fdd4vMRJYPtPjmKbpg3AMTKXBhOyhh+MSXQpqEkbOfnG?=
 =?us-ascii?Q?AQtJVjnvQ2i9MIYLjxPTRARx34cRMssb4BmfQ0qqGqUc9cOk8c1PT9Zhypvz?=
 =?us-ascii?Q?4JqoNuur5O0KsD00GC1W3ybnumZ3/dKOT5n8KWF/b8TEabpZNm36wrXNKnkh?=
 =?us-ascii?Q?dG9kTC/nYM4D9qBP3x9TpBRxw3ScNRxHRgJGesZa0hVdN4bzIDD+422+P3YF?=
 =?us-ascii?Q?w5bq1hrFXvySlXfg5k6T/O+Y4VLI0mxbr1YLqWc5g1r8PS1najcaTq2bo+9M?=
 =?us-ascii?Q?wMOzIRQtbBJ3IWeaTBlKROgp1WLNubnoGrCOVPh/b6ummJ6k6FO/rTGC7YAc?=
 =?us-ascii?Q?Rwe46nMKNmLTqz9ZNsGCjWNUlB8jvuhaNMoSx00z/2b/x4H0kWU9eE1GVyJV?=
 =?us-ascii?Q?0X6cIR9dIJIkBeyy8OJVAlShsmtpIx5jfF93mtVATd/4uRW0BxBx5OH09zLB?=
 =?us-ascii?Q?RuRzffEZubGPi5fj9tDZyUMWikggiZk0VVQoSlqBdfGx4AMw6QiV5JUnZVqc?=
 =?us-ascii?Q?/qj9ct93Zo9MJFAtHVUpQ9JWeQSCXI+i4O7VW05BdSgb+6dYSf6XNo2CejHq?=
 =?us-ascii?Q?nQP0X38GucIeASP9caxYUMRrvkaUAp+M6e7RhHVQ8gQ4riQL/AV5jUZ0Yulq?=
 =?us-ascii?Q?vklDbJ/UB0hk/kdsrKsfolLMsue6Q2apQ34vDVcAnEXxqVpz/Cp7puLy9kf6?=
 =?us-ascii?Q?3k0oFFhsFjJERkziMYeiBytUKYRUL8rvGvrIaJ8wPdvhAfqwbpkgrIsVcf1M?=
 =?us-ascii?Q?1fuURqOZv0HM1TqrO0wP62wxh5lJWRjg/itWhZq2ZS9IbbEV4K3AF3smW6aV?=
 =?us-ascii?Q?FLuAV2k5sbrEwivE4cAuGMDa80ZJEguhloN/xlSsfZg/xiAFf9jdv/LImYoB?=
 =?us-ascii?Q?Ro7d1xcbiCfu4h3TFhdMTRNcbIrlCeGcnC4n4QWc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dbde3a3-4f6b-424e-a270-08da6d4b1feb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:25.2795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvfZawvVD19seIhXnlUvrCL0FoitqHO1Mw0fcwfWCrf3AqbAWlJFZqNGwZeGxus/nU7Y9yguc0LV/ADUXrlbQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The right name of the register is MTPTPT, which refers to Monitoring
Precision Time Protocol Trap Register.

Therefore, rename the function mlxsw_reg_mtptptp_pack() to
mlxsw_reg_mtptpt_pack().

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h          | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 17ce28e65464..0ed2a805ce83 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11045,9 +11045,9 @@ MLXSW_ITEM32(reg, mtptpt, trap_id, 0x00, 0, 4);
  */
 MLXSW_ITEM32(reg, mtptpt, message_type, 0x04, 0, 16);
 
-static inline void mlxsw_reg_mtptptp_pack(char *payload,
-					  enum mlxsw_reg_mtptpt_trap_id trap_id,
-					  u16 message_type)
+static inline void mlxsw_reg_mtptpt_pack(char *payload,
+					 enum mlxsw_reg_mtptpt_trap_id trap_id,
+					 u16 message_type)
 {
 	MLXSW_REG_ZERO(mtptpt, payload);
 	mlxsw_reg_mtptpt_trap_id_set(payload, trap_id);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 35422e64d89f..a976c7fbb04a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -694,7 +694,7 @@ static int mlxsw_sp_ptp_mtptpt_set(struct mlxsw_sp *mlxsw_sp,
 {
 	char mtptpt_pl[MLXSW_REG_MTPTPT_LEN];
 
-	mlxsw_reg_mtptptp_pack(mtptpt_pl, trap_id, message_type);
+	mlxsw_reg_mtptpt_pack(mtptpt_pl, trap_id, message_type);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mtptpt), mtptpt_pl);
 }
 
-- 
2.36.1

