Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49D76024A2
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJRGl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJRGl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:41:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC51DA87B7
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl9R/5R6CDu6I51rAI4kHA3aogkrzsOZbnFuIJf+gp1dUe1mK4S3DbbspHvHVYnUect1k/HiR8zR1A5VUAfTJk5y74s6/C45xptKBcs8Vp35GWoqU2rbl4rcvITctmSlVRzXfZklbTI77u8FGDbtKwxsyiLwmlZpDPs+sAsMg7L20Ei9AvrnaQW7aZrPQ4hOkJjPnPo2lPuRzWuQgKr9tmJUzUPJHeE9lkjQqSAgz0SuXMfrTmCBNCta8hxz5DES8ymxWpjZDtZco+LRpOGSb1AN57nbGQ3VuOmqFhbLilN6l+UndDDa8xr/3VQHKdeAd6QBk4PjggBGd9/Z7wnZvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OLA8im292j50G4H7CGX2bZcE99PG35GfR8G4o7ySLk=;
 b=Fvb/z/bVXYKyqC2BfmuehlDUoqZ8f3POh+eZoO18q1HBbQUxQe0qB/Bm+h40EqK1GxEez/q+HnG78Xh8wGqt6/XZ/tB7YPBKawZIm7sda6v2G0E7WbC9PlJN7CXxJRcxZMFvV+EtV6KDf09VmsYRJY5oT1QnpX913f9dvBXUFOcUzu/jAH+h4GJ883Xaf+hguysKjAXJPseoSyQGSivAg4zV379qEyBBIqYWD2wgVCYHijKKJj455sE2jpwz6lUBTpKCAwnQvCFqkm/0/AfK358SoYnU0/F9tfi4xIS+NqU6gcEG0xnIyMAUTuYfBSba94MYF0DfX3IccQq+Y2PASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OLA8im292j50G4H7CGX2bZcE99PG35GfR8G4o7ySLk=;
 b=gc9nxTPs9YYYBjHrAt2ecEXyCfvy60jQTovRXzb7f1GLu9vRf1MOqSNLGNfLGSxDb2SNPVnTcY7p6lXo2uEvCw9Ih0gwSjKBnadk5eLiB5NT4vb8yKF62UnDGovEqGBd2dT1BfMxd4BGgauToWIIxSt1PnJYvIV3wRvWsZX0AJgxSppA5Ro/H1bo+KQ15J0Qt7Tot2Ybzu8Kn045r/Km01lgr77Go1hCSu133L/6JIALK9ODmc2vIyNMFs46sUxN3/V1W5NYtgsotdh9bqNrplUs8INenx/nI4SAQB6gHv3ok4Chk619SDVi1DMRO2lueHy1wVVO1H6J96s2zNeUaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 06:41:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:41:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] selftests: bridge_igmp: Remove unnecessary address deletion
Date:   Tue, 18 Oct 2022 09:39:59 +0300
Message-Id: <20221018064001.518841-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018064001.518841-1-idosch@nvidia.com>
References: <20221018064001.518841-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0053.eurprd09.prod.outlook.com
 (2603:10a6:802:1::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: f89058a0-f4f4-4957-8444-08dab0d3c5cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I13mfomJmgDuKFJRg3uwDsTlP69X6vW1u+KySsWNNHS5TAgb5tQX14j/AhQhDNDnXFCsGAZkrANf4IUVL3SbwFfLV8fcdPp5s/aCqAXpfJXV6orIR16i5k28/LvzbajFf1h0fWZvYuB/SfJt0juQqu8uw8HuKxDUQpiCypZKDhEQbOiRV1CZRJHhdlxlAE/jMMY8HzbAgUeWmhjSOPD2Pgk55eJd3TrO9uc2Y1KNKJw1upajCJqhDTNm4H0KWEE93HRC7ex9BEZoO3rYhlniCSBOvIOgDHsWH0w+IKlh7EHKVYPvFKYzxOT9DtBgaxkLltKAnCyuYIU0+oeGUQkCEm0p0kHA065khCQwj3f+7ow9W/hMohu1h8H+sCJKEHJhtxqSHiwXygyTLgnWR5920C3wGou0YAZucDYhMp7ueWryHGVmwtAjrytHjdcdKSNyQl9NssgaMLPpxSkRVBbKO8pxQ2swc/yqblhVAf6I9PN8nqCUqOJn747ZHVMKdszV9ylZ2TpRwt5Yxfyke+SxwPlmyxJnVQ2N1fev+kzdJGQgPK8mbsoEAWGqeOmb4wWq0ewoL00b/UAmYYpHNj02HXo/r1YlZvraILW/O93/+ZnJA30T/3iyvJpqn72MJ+R7JA6sav9Z7a9e2ktYpcty7RTIf8zFQqmq4Pju/ECEOLQUimjiqMcir5KEzmXcQlhulHgGgNsJBiyc5TIb+kjuRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(36756003)(86362001)(6512007)(4326008)(26005)(6506007)(8676002)(8936002)(4744005)(6666004)(5660300002)(41300700001)(66556008)(66476007)(107886003)(478600001)(6486002)(66946007)(316002)(38100700002)(1076003)(186003)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZjAr63909+1sOGDQDfI9LaD/rOQ9YGym9+j0QLeNrU8V/k2BoMzgFSIGzrjj?=
 =?us-ascii?Q?ALGbkZVuOt1J5clIEMJeead7wG5FkKSHMe+cE4KmQf1qaQv+1WkvR9dS0vVu?=
 =?us-ascii?Q?+ums/MT08mrTcfXIPxS1pwvkXbcJ02z2ZL7SOI8jjawbLvjGyQVatn3YX4iM?=
 =?us-ascii?Q?wzIIZYSEtWBR5JlkSMuiFEXhNgEGWhFQxtL6XIovuYmWN2z0lHQz0HBe3aiK?=
 =?us-ascii?Q?l1ggXzGsv2vHoa++5Tkev/KvmDIwjyYqVnmXqJ/pdM0+50HJPur/rvpv0HPv?=
 =?us-ascii?Q?XLtwqhL/CfzGpKy1NY7bjFIXHAbRqKtOHWBe2hIsGuwgh7R/kja9seAb218N?=
 =?us-ascii?Q?Lh0/BFOjjTlApzgG7DBK011qgqKwwELYRm5IoZCgYrqTSFHlFrPSPL+TD7qx?=
 =?us-ascii?Q?X3RH6U33MfwmtHC156Ng1xBEEWXBwtgfbBVB0HwSMxVp1V+V7785ta0a3xV1?=
 =?us-ascii?Q?IClu9z266ElC9oBVTcLDdy3bn4+EHtJXX4TOkl1drv01YWs/ipuuVI5rP7wm?=
 =?us-ascii?Q?DCCXN05yvLricn7QvL34L5vbnQgWc1eRgxz2LJo3KEoJCASYyHd5e52wwjvw?=
 =?us-ascii?Q?1ksLPArkx41j9Yr/+vJvLjZ8TK7ZIYcUunOiFsKCO0LBGWHQEhuU1TqUIfuN?=
 =?us-ascii?Q?S9wTyw6gg/t5UVoBgThq0W2ZAZZO/9c1Q9a227rZ12w24SvdS9dfys855v2v?=
 =?us-ascii?Q?Ld6cau/3Z1SQMYY6nvtqbS1EIERRtbgoWx3d0e0s5haD10LlM80h7L0mlORK?=
 =?us-ascii?Q?u+lPMWoHdEkfrTqE4Pmfbcd+jN73AcK/ZHNJkbbs2+DbuI/rky8WHpNzpcRP?=
 =?us-ascii?Q?EjfnriMaG3f439CFdJmEEx9Li6BN8hO9AS/HGu9XItiQyBihtl+4m9JzhY3w?=
 =?us-ascii?Q?kmDUsiEuuehiMifp6o1yPFQMax5TjZW13QN3CqvHuPIgbUAQKpn2+ZM1vM9w?=
 =?us-ascii?Q?7NWOiqP99tQuDIv8tFUlqjwY7Qv4fAhhRf/F+jAoZcZ2n18oF/4hhvxOV0XI?=
 =?us-ascii?Q?mCZR+upFjWjugm0suSPK55o21i3CnkcHvs0ZtrfHvtuIbhVAGKsW0UqZklag?=
 =?us-ascii?Q?yi7S3Vp8td4jv1d2gKNvBc23vfVOp8TuSO61nSoGgd0teJ6fORu4q1Uh2+Tw?=
 =?us-ascii?Q?iHe4cXvScJ4jiWirHVWk+5S5TNakdJywLekV3BLt2rXQHbx4GuE0QYKoanB4?=
 =?us-ascii?Q?UBU/KNrUZzfIIlIyJWBpfm1SN4/npEwOEg7mVeteXBB6whvZj4XLaJAg5j9/?=
 =?us-ascii?Q?VVcrnXPncWz1YkbRE2U01BCv0oQGPYCmn4sa4rmf5/rI+NIvtQaN0kyuBqM1?=
 =?us-ascii?Q?Hepjo7eX5qtmnj3/4FLPOetroPM0bj8HhWXHoThWVJMoQxCE3MuwxT7vcgVg?=
 =?us-ascii?Q?0iViXiU16s80qajaTIrIjsWc/1EWs0GfI6RMlSc56uJ+cCiWC2++IdpflYa3?=
 =?us-ascii?Q?v12fS0Qcll4s3PYhPmaq/7kmTIxV9PrRXZdXjMgMJuYodxYoFQbtzH8CnBz8?=
 =?us-ascii?Q?mDhbn/ICB8Jnpfg77lb8bUjyqd8/t4vZUO7KjrdNDV0ynANZpFGcIzCuafP8?=
 =?us-ascii?Q?a5Js88dsRPgD7ths86C6e7x6ciuRd76fDOi4JCAi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f89058a0-f4f4-4957-8444-08dab0d3c5cd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 06:41:23.0920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nTgbAAxzIrpAJ7unenCSKSJb4Lzf4rD5VwzXsI5djssln/KqejkmOgqCgcXqVTh+U6Ubph8RSSEFZlH7OceN5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5385
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test group address is added and removed in v2reportleave_test().
There is no need to delete it again during cleanup as it results in the
following error message:

 # bash -x ./bridge_igmp.sh
 [...]
 + cleanup
 + pre_cleanup
 [...]
 + ip address del dev swp4 239.10.10.10/32
 RTNETLINK answers: Cannot assign requested address
 + h2_destroy

Solve by removing the unnecessary address deletion.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/bridge_igmp.sh | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 1162836f8f32..2aa66d2a1702 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -96,9 +96,6 @@ cleanup()
 
 	switch_destroy
 
-	# Always cleanup the mcast group
-	ip address del dev $h2 $TEST_GROUP/32 2>&1 1>/dev/null
-
 	h2_destroy
 	h1_destroy
 
-- 
2.37.3

