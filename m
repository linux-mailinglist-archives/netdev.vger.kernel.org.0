Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B3D3433AD
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhCURVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:21:23 -0400
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:37281
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230227AbhCURVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 13:21:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHuEXMkJ93/pcUZF466PbybLf5joEGNXYPcW3yUocxsZh5sKurBvCRAGTzIoRTsLUfD9FlneNy54VfUhADPPgkVMD1Xr+w7/4Jec213mVoluA7tPTlLGr5b6j5FZ6xnK7BO8Td5vPjqsR5F+D3r6A7H4XtgPU6ib0k/TeEKgwGXu3W551tvKvG9SNfPXuRn2HtnwPVXU+xORqCsZaNK094w8SC9O3kQ6p8eGR4eHPxXpV9eeBBzLuLX7irwhDY1wHLG558WGOT2RcIdi4vkQ2TeE2Kxm5hGVHhT/3ScawISHxYwuxrjWdNNrG3UDFid8ABPA2FoE6cqGb4S9TPwL+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHgeqVK/eWp6gfLEUXqoqFTes41MJZAk6855Kztr3Qw=;
 b=dxdXZxXF9atlmxLKubj77PnHtsCwcV4nj+0+kK4qPCkFglWLoV54q/fAdMTv40dj9OBexTBk74dRjy+iWbKxCCAeMHSZKKLtLztwfhziafjMVQ8LHALzWd079xgHhLsz4D+fREFaOFoe9Lg57Qz+1SVdODhu3j0E3Wqx/+38ZY0diVhvB8vBXWcgK8qhAbyCIlVx0uFb3ETa7G5Sgebas017j6PTeaw8OnvB65y2SeWwlP7FIo1f5QCist2lUtTf3eq1a+le/hHErvsqaBJyR+8ccU4aGrv0wsXU3bB0xQ3k5Q0HJayRNDm4P60qOFfCO7C3tcYGVTRX0e8LbJJ0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHgeqVK/eWp6gfLEUXqoqFTes41MJZAk6855Kztr3Qw=;
 b=EkzP9Chzk3OdKL0YuEBVRB9NfUKqsSm48CZQNI/Sc0GYXLljCiwM2SMPhHw19XP21rIpD25rKBj7/x0NhgJgVCFaS/qoFq46Xyfp5q2Pg3PVaXEekzNsoeNWQoH6t8g5HdsL2OnUXmx8dz5NMGhxxOOu9ceN3znnviMjQq1pS8P+UiqouNhEe4ZLm1/xC+7WvEwHWHqVhI2yXb763PxDNDx16SS1VpmEmBLFzXlxhqNmFX3gSzgsSOFj4e+/U7GIlTwAtJL9mtJZUuaxmOYC68mLkIoPCKO2MQOTLJDT88YEeekMsB2IHSlgnsAjAmfm8Kl6Go4WN6CGIG70qQlcsw==
Received: from DS7PR03CA0134.namprd03.prod.outlook.com (2603:10b6:5:3b4::19)
 by BN6PR12MB1236.namprd12.prod.outlook.com (2603:10b6:404:1f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Sun, 21 Mar
 2021 17:21:00 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::d8) by DS7PR03CA0134.outlook.office365.com
 (2603:10b6:5:3b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Sun, 21 Mar 2021 17:21:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Sun, 21 Mar 2021 17:20:59 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 17:20:58 +0000
Date:   Sun, 21 Mar 2021 19:20:55 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: Fix vxlan
 ecn decapsulate value
Message-ID: <YFeAdxAOYcx3CMYJ@shredder.lan>
References: <20210319143314.2731608-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210319143314.2731608-1-liuhangbin@gmail.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b04193f-59c8-4826-d0ec-08d8ec8db231
X-MS-TrafficTypeDiagnostic: BN6PR12MB1236:
X-Microsoft-Antispam-PRVS: <BN6PR12MB12368DA90ED0C99D500C4173B2669@BN6PR12MB1236.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcUpETbrLnMKioZKY9BjAd4W/gqdoD4I9kx2Gy+fbwg1bF6ixbbAPmf1qjsYpy5BTFkdLN1Zk/QESkD1axts6JHReBiOTNQXrb5wQdg0PqcHdAX+e5tcrPcrdU4lzGQfy2rk0fEWzJViQg0Ph+/eGYyy23YLNrgd97z14aF0UlLc6dlNxbI93PkSwrkT22Hb1n29a+twjdguTQ6rli1e6Hkxx0Y2+D7KHmmTCSKIYV/yLffOeKjkGJCy7XjgvYxwMVRT2hBYwBWoE7nlpTZYgdByYyvbWiqueu8utNKlR9/tkIT470LPs1iQv3Te9+0pSYbiT36j+8gg45N6Velr0JxhwbsZNu+2MPMOkBwCLSbS1++VWVr0tkFMTTfbqXfqYXA/IhFUd/V5lySlXx2C79/rgr6uGG6p7tFoi7guU4fIYaMdiY3jn9nE0M7iydf3Xvhb8t+7EIFYFB09Sou/eu3ypKXqyICp8sVyMpNO3v5qO0DKJLcpjlUtrlnvs4hmjZLvJ5EN9RWxg3isUGrvUwizeqGFtQlxqgzbV4iPiKhsLQ44Hh3rAtC5fwma4LgyybitBD38O6NvV5O7U5k4mNg3kNwFDAWwlzHW1oeoI0rkR3XpPYUPdPlTFBg0d2iY0gP0BmZdFutNNhDwmUs2nYW8cJ3MkjG0W6p6STO6TE0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(2906002)(5660300002)(70206006)(4326008)(9686003)(86362001)(7636003)(82740400003)(36756003)(70586007)(36860700001)(426003)(8936002)(478600001)(82310400003)(8676002)(83380400001)(6666004)(54906003)(47076005)(36906005)(336012)(6916009)(26005)(356005)(186003)(16526019)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2021 17:20:59.5918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b04193f-59c8-4826-d0ec-08d8ec8db231
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1236
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 10:33:14PM +0800, Hangbin Liu wrote:
> The ECN bit defines ECT(1) = 1, ECT(0) = 2. So inner 0x02 + outer 0x01
> should be inner ECT(0) + outer ECT(1). Based on the description of
> __INET_ECN_decapsulate, the final decapsulate value should be
> ECT(1). So fix the test expect value to 0x01.
> 
> Before the fix:
> TEST: VXLAN: ECN decap: 01/02->0x02                                 [FAIL]
>         Expected to capture 10 packets, got 0.
> 
> After the fix:
> TEST: VXLAN: ECN decap: 01/02->0x01                                 [ OK ]
> 
> Fixes: a0b61f3d8ebf ("selftests: forwarding: vxlan_bridge_1d: Add an ECN decap test")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")

The commit you cited is from 2018 whereas this one is from 2020. The
test stopped working after the latter. The reason I didn't see it is
because this commit only changed one caller of __INET_ECN_decapsulate().
Another caller is mlxsw which uses the function to understand how to
program the hardware to perform decapsulation. See commit 28e450333d4d
("inet: Refactor INET_ECN_decapsulate()").

After your patch I get:

TEST: VXLAN: ECN decap: 01/02->0x01                                 [FAIL]
        Expected to capture 10 packets, got 0.

Fixed by:

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index b8b08a6a1d10..61eb34e20fde 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -341,7 +341,12 @@ static int mlxsw_sp_ipip_ecn_decap_init_one(struct mlxsw_sp *mlxsw_sp,
        u8 new_inner_ecn;
 
        trap_en = __INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
-       new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
+       if (set_ce)
+               new_inner_ecn = INET_ECN_CE;
+       else if (outer_ecn == INET_ECN_ECT_1)
+               new_inner_ecn = INET_ECN_ECT_1;
+       else
+               new_inner_ecn = inner_ecn;
 
        mlxsw_reg_tidem_pack(tidem_pl, outer_ecn, inner_ecn, new_inner_ecn,
                             trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index e5ec595593f4..74f2c4ce7063 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -913,7 +913,12 @@ static int __mlxsw_sp_nve_ecn_decap_init(struct mlxsw_sp *mlxsw_sp,
        u8 new_inner_ecn;
 
        trap_en = !!__INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
-       new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
+       if (set_ce)
+               new_inner_ecn = INET_ECN_CE;
+       else if (outer_ecn == INET_ECN_ECT_1)
+               new_inner_ecn = INET_ECN_ECT_1;
+       else
+               new_inner_ecn = inner_ecn;
 
        mlxsw_reg_tndem_pack(tndem_pl, outer_ecn, inner_ecn, new_inner_ecn,
                             trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);

I will prepare a patch

> ---
>  tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
> index ce6bea9675c0..0ccb1dda099a 100755
> --- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
> +++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
> @@ -658,7 +658,7 @@ test_ecn_decap()
>  	# In accordance with INET_ECN_decapsulate()
>  	__test_ecn_decap 00 00 0x00
>  	__test_ecn_decap 01 01 0x01
> -	__test_ecn_decap 02 01 0x02
> +	__test_ecn_decap 02 01 0x01
>  	__test_ecn_decap 01 03 0x03
>  	__test_ecn_decap 02 03 0x03
>  	test_ecn_decap_error
> -- 
> 2.26.2
> 
