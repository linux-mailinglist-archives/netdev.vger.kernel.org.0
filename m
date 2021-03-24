Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B26D347683
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhCXKuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:50:50 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:44448
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231646AbhCXKur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:50:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjl9L5rRdI1LvlgiU5KjMB7q5SWDPLOdruwE/sBWKJcVIKFeJUwzsEYB/fzBCHJ+1SiuT2co/YAsEtlnDRMVhGQm8+U2ZuUaw25xELOcv2KLprNYXEbIID5D2NPaR3g491q9HqTRzCaT8087+IZnUP4t8884/bMWwGvb+EsosegO4gWLcZ68/bWKToupxW2Uh4wgcV/6C4EFxecmxYkIwO+ALWN9QNB11B/Pt9d4Audz+qJ/gnMzV2oQlH9wmS7nf3lzg044OcZmWb6olENmLJs/zZD8ezXdQtP0q/vatWjuyB3QWomXJPlE2CkGd4QCvgKD50X7yubdVLSGwPngsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=943DM7qx3hq+GwxSl74L25sdkmAKo9pznO6FBvgDoLY=;
 b=mYTipMjNlWlmD/pEyphInlBw/i1mRxOiBngODtQQhfGsaA2Jc3nPgeroxMaoq/bpLa1UVL9bC5xgbxOfCq5Q2OD5z7iO98J+gY8OQBvE17wF/f90EIxGs+aF4gRQge6kvisij26bWksMU2b4IAqyxyzkIWx+yNnGMcpFwmsUQforNYeVsn2RiPVL/psi9fe0r9GE0B90afq06C2/eHAutFY02Yy24kx4ASMoMPmDsTliKjnlam+F45CpVWmxPwilZX39DjwdUoQYsj/wuUy+DuSypM6aNxct6Of6Vdhz/KuaqHIuPFfR1qwHfLsrqZ9jUiqtXYIvL1+U1j0+ccL+xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=943DM7qx3hq+GwxSl74L25sdkmAKo9pznO6FBvgDoLY=;
 b=Mzp7yAUTlu8PKtlXCrH/Fq7uQaFiqYWIplJmLKxAvP2YhbbiiGGP/M1WvCnEW8+zyoyLWdHTVZkjA61LDxK3i1oB3frku+NCWBM7IXMxiDtCiuJy/h0VfcrD9cVA9q7VELxrLyWz3co6r3HGnpo1Qt01xhjI+thhwzazXvSvRsYsQWEk0KWNHQYNhc6187LQEjTNBL92SCcbHVyRhKwWCsbCKzKv6PBP7SB9YJm9zFIAhQX0h4YY5odYFqUDDjUUcdFA1WG7A95RAeDEFs66aN3p5aLCXk4Bn50ddGpCL/A2/RUb75TZUhlGx7+auauDZYaia9/370j+3tuT4UhKlg==
Received: from DS7PR03CA0226.namprd03.prod.outlook.com (2603:10b6:5:3ba::21)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 10:50:46 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::70) by DS7PR03CA0226.outlook.office365.com
 (2603:10b6:5:3ba::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Wed, 24 Mar 2021 10:50:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 24 Mar 2021 10:50:45 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 10:50:40 +0000
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac resume
 back
Message-ID: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
Date:   Wed, 24 Mar 2021 10:50:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8dfadca-c16d-454b-b583-08d8eeb2add5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:
X-Microsoft-Antispam-PRVS: <DM6PR12MB43374BF26264938999ABDD6CD9639@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BU6sDxfCy74thlR/mrsukmRKI5Q6bQmW7ew5wOoQSh/hFiqGjbpRllneWOKdj5I6gD61vXx5yTW+eBbab8myenV6Yy8xQee48ffai4QssRDHAONHpp9PYsTRq3MUrj/jamCoFUyRBXjjqSUVzEvdTVWBJUOnWqTU22l/wAhXpjdfqnP8G3IV0d6eNN1tB9gWNW2Vc79+hDsaZOrFouDu69Wh9l7TRgQIkY5r3jsTQ9+o3z5UN379ZoI1eIAKY4NuDrzutHn2g+tWFzKvCOa/7lI1s5fUjrD+nmUdIeVqKs+EjzkoJeHVO09N+hCgacW4kfF3V1bo+W6by98wfjttrORiqo7XMLJNihUpdVEsMA34MMN+SvCog0XFXYaegf8OH0acXzW/UooWGW7q9BuYd4cVw3w/RzPlSdfWQyiJ8b7/3SKpnR8XWrjCgrDW8+CrFGzoudmO31YX/paLtOSOODHiisFOIUTdT8THSi1ooKg72ukpD92FrYMNX5BDiCSL/ELe6oJIxL76uD+EujnmLGZNFRIT9FNFBPDQ1ehfU7o1qzI40cedXk9Itl/yFYH/yVM0GgtEOfV+Kj7T06F4mVQivnaCxlEy8ETUWEGJ7yPnkosdWXRkJVQkvtR85upjJ+AOTJTqyQUSvOz7e6GByZq2IhPCzf91C/27oglA5zWcCDWqKhzrhiY6ZLJNAffi
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(36840700001)(46966006)(356005)(7636003)(8936002)(82740400003)(82310400003)(26005)(36906005)(4326008)(86362001)(36860700001)(70206006)(8676002)(16576012)(478600001)(316002)(2906002)(2616005)(31686004)(70586007)(5660300002)(31696002)(6916009)(83380400001)(47076005)(36756003)(186003)(54906003)(16526019)(336012)(426003)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 10:50:45.9899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dfadca-c16d-454b-b583-08d8eeb2add5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

Starting with v5.12-rc3 I noticed that one of our boards, Tegra186
Jetson TX2, was not long resuming from suspend. Bisect points to commit
9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume back")
and reverting this on top of mainline fixes the problem.

Interestingly, the board appears to partially resume from suspend and I
see ethernet appear to resume ...

 dwc-eth-dwmac 2490000.ethernet eth0: configuring for phy/rgmii link
 mode
 dwmac4: Master AXI performs any burst length
 dwc-eth-dwmac 2490000.ethernet eth0: No Safety Features support found
 dwc-eth-dwmac 2490000.ethernet eth0: Link is Up - 1Gbps/Full - flow
 control rx/tx

I don't see any crash, but then it hangs at some point. Please note that
this board is using NFS for mounting the rootfs.

Let me know if there is any more info I can provide or tests I can run.

Thanks
Jon


