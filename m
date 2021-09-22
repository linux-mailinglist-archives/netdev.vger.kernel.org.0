Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF1041419C
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhIVGXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:23:25 -0400
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:49505
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232367AbhIVGXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 02:23:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbW75evRlBbBVqbHRB5Nlc7Y5J7Wwe55JF22mvxcIc7+nov8hV4NybKOOi3bUqG79igTaOiq1m56vK7k2BesIm7pk7sgE/NsoZoerAX6AeY0YIsYsKiwj0VOVq2PeqD9C0EKG0K44w9PUbcyklibO6odh1WixFy/5GoJjQMntEu3SWTUR11kuc//4cRlatwx+jsDloBiueQAKBGaQBeSUTfHKmX1nvw3NID+IiLabuPIGKbePLqVBqMAoY4yErFSBSOA6hlH5V8agfM7jZRHnEmFW5k6408VhXrNdcJoyibJQiIjHrfeAoWcNQ1FOuzQqgkPVyfoE3GWMTTbGQK+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=o7buKrpdkF1eyFEgT/r3QPDWOtls06quynzfFcTmgek=;
 b=ig7LgTt+0+3R/5opeQ/qH2r2yKOvmRuxb/wGtzZQ7/zaCfg1xSWC9D0nGDlct1xR5OJ5wfRLw0Gaviylkq/Nfus/RMuTjJ9YRkOOKTDm1emNnP4Lt+bHFN4GzRctVwDWN/2ZywrYWWO+NAP2FvXqHIIbxdS6FgAsAfnpK7dFnMGk2dY4eGM2D5Re6CdzlmRHwtl6VvGrPMDB53qia/rlEV/lD39U1S5F8Zj53OSJ3fWue1iiAMYz7d7DXGsEuC00nNVB14a/Wl+UDGQQUsZFIIbCl9dVe0tHjd/iR5gYVHNoCH4yIf9IzD593SWKu8emXZ9t8+MpurQRSsZylKTi4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=sony.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7buKrpdkF1eyFEgT/r3QPDWOtls06quynzfFcTmgek=;
 b=TlGfBI6xGIwv2c4anBmcQjPx+TwL0wJvPPtizPTXa3aUORnpLTkDYvDbL9XiMjeqQFdQ9gy2ufNZDPhRfdrxW7rhoF++aqRf0uX8IWlygpafqt+qswNU9fR8VWysmwWUKZ8N8lCQIVTDLh12jI+SeZJI/bvGBKXQH2Gny1tApoQ1zze/DvGjyFQKgTziGnXxx0yiEoiA+aqfR8M1hz2fk4BtiqBadN7mxwYf68Lo42BR/unGJnnhIkQfeRA//Pz7+INWLL8L3kuXeHPaLRY9gl5hba6dpmPTz56kXRvqDpjCZjusevO4QbyGo+/k+ditVM0mycbx6l0Sv+DE0EvpTg==
Received: from DM6PR14CA0052.namprd14.prod.outlook.com (2603:10b6:5:18f::29)
 by BN8PR12MB3284.namprd12.prod.outlook.com (2603:10b6:408:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 06:21:53 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::d2) by DM6PR14CA0052.outlook.office365.com
 (2603:10b6:5:18f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Wed, 22 Sep 2021 06:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; sony.com; dkim=none (message not signed)
 header.d=none;sony.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 06:21:53 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 23:21:52 -0700
Received: from localhost (172.20.187.5) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep 2021 06:21:52
 +0000
Date:   Wed, 22 Sep 2021 09:21:48 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     <Patrick.Mclean@sony.com>
CC:     <greg@kroah.com>, <stable@vger.kernel.org>,
        <regressions@lists.linux.dev>, <ayal@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <Aaron.U'ren@sony.com>, <Russell.Brown@sony.com>,
        <Victor.Payno@sony.com>
Subject: Re: mlx5_core 5.10 stable series regression starting at 5.10.65
Message-ID: <YUrLfMhATS3u6jq5@unreal>
References: <BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com>
 <YUl8PKVz/em51KHR@kroah.com>
 <BY5PR13MB3604527F4A98D0F86B02AC98EEA19@BY5PR13MB3604.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BY5PR13MB3604527F4A98D0F86B02AC98EEA19@BY5PR13MB3604.namprd13.prod.outlook.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1609205a-38e9-4d4b-3e69-08d97d914537
X-MS-TrafficTypeDiagnostic: BN8PR12MB3284:
X-Microsoft-Antispam-PRVS: <BN8PR12MB32847D4A3AB165B6BBECCD3ABDA29@BN8PR12MB3284.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJthUFRiBwHP9jncmpRuunvCE3LYEHq4h7wxgJOJs4tBvHuD6+BDCDC1RczWgChr5mdpMPigASIYSeUdPArnORtWSc9Q9QxwVheLQ7QBICsOBKEBKe5Wfn/Y+jNgdFpbo6tHC7hhRoLIKSFqlyKMILzU01xtD2ho5ikegEHILaWN3h+sZI6bqp6CloYQ8XjdQjpf3zGC0BI9w7iOveOQHJQlUvgRKIMelO2YOtndBJUAQ41A6ZVmpJLYwSq8pvMWoC3vHC/BKm1dR59McpzqYWnzVJgy/8+x1qwVLfiwOUt1yKAioG93Ek5FAe5dRyRGLosJKH4bSyt6XRH0w41I8ri2mnx2oUNqlvzwfjrgRk4E8zjYyPbm7nKfqyuyR4MwpMm7JrRy6lDUr2cnAuodcg0dngLx9q5JMGxRfh76R+DGNUE2oj1JpVDPZpA8SjWcuz/dE4gusj+ZbrGjmfkdpH+k8x2Gqy6nTR8+X+piD9CBeSa1BsrWt9FWaUPjnsIq20wPO7iGSvnr1U0PIfq/bJD/WkYfN8WKp/rXm1vpU4iVgW0FBQypEEr9L5YVvzqS1/ItP/DMTv3TztW5T3LOfs1e9tpItlj/xsZG5wqHQSMsqqAlvEhHn8xg61B0+p6wbT4mldsAfgIsQocAerFG1JN6k7fqwnMI84AlBuatC8TQtfeEZAPrgyvsTH2oE5cYkGi7c66qThnEHAlHCMyeAs+IQA7tJ0gMAJ2McmpL2grCYaEOL8L9Sz2pFRHTkUn6rY7Ois7xm65Q9S9SkTBMXt0mEJuiNjv/vqeSJc9gzwk=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(36840700001)(46966006)(8936002)(70586007)(5660300002)(16526019)(316002)(8676002)(356005)(54906003)(6916009)(336012)(70206006)(86362001)(47076005)(426003)(83380400001)(26005)(2906002)(186003)(33716001)(7636003)(36860700001)(966005)(508600001)(82310400003)(4326008)(9686003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 06:21:53.3624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1609205a-38e9-4d4b-3e69-08d97d914537
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3284
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 10:22:57PM +0000, Patrick.Mclean@sony.com wrote:
> > On Mon, Sep 20, 2021 at 08:22:44PM +0000, Patrick.Mclean@sony.com wrote:
> > > In 5.10 stable kernels since 5.10.65 certain mlx5 cards are no longer usable (relevant dmesg logs and lspci output are pasted below).
> > >
> > > Bisecting the problem tracks the problem down to this commit:
> > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=fe6322774ca28669868a7e231e173e09f7422118__;!!JmoZiZGBv3RvKRSx!phUrsR595UusBY2Q9eNJQS7-VNtnb72Rcvhe-W0QKDPir1WY9mvWOkLLfe63k-6Uvw$
> > >
> > > Here is how lscpi -nn identifies the cards:
> > > 41:00.0 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5] [15b3:1017]
> > > 41:00.1 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5] [15b3:1017]
> > >
> > > Here are the relevant dmesg logs:
> > > [   13.409473] mlx5_core 0000:41:00.0: firmware version: 16.31.1014
> > > [   13.415944] mlx5_core 0000:41:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> > > [   13.707425] mlx5_core 0000:41:00.0: Rate limit: 127 rates are supported, range: 0Mbps to 24414Mbps
> > > [   13.718221] mlx5_core 0000:41:00.0: E-Switch: Total vports 2, per vport: max uc(128) max mc(2048)
> > > [   13.740607] mlx5_core 0000:41:00.0: Port module event: module 0, Cable plugged
> > > [   13.759857] mlx5_core 0000:41:00.0: mlx5_pcie_event:294:(pid 586): PCIe slot advertised sufficient power (75W).
> > > [   17.986973] mlx5_core 0000:41:00.0: E-Switch: cleanup
> > > [   18.686204] mlx5_core 0000:41:00.0: init_one:1371:(pid 803): mlx5_load_one failed with error code -22
> > > [   18.701352] mlx5_core: probe of 0000:41:00.0 failed with error -22
> > > [   18.727364] mlx5_core 0000:41:00.1: firmware version: 16.31.1014
> > > [   18.743853] mlx5_core 0000:41:00.1: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> > > [   19.015349] mlx5_core 0000:41:00.1: Rate limit: 127 rates are supported, range: 0Mbps to 24414Mbps
> > > [   19.025157] mlx5_core 0000:41:00.1: E-Switch: Total vports 2, per vport: max uc(128) max mc(2048)
> > > [   19.053569] mlx5_core 0000:41:00.1: Port module event: module 1, Cable unplugged
> > > [   19.062093] mlx5_core 0000:41:00.1: mlx5_pcie_event:294:(pid 591): PCIe slot advertised sufficient power (75W).
> > > [   22.826932] mlx5_core 0000:41:00.1: E-Switch: cleanup
> > > [   23.544747] mlx5_core 0000:41:00.1: init_one:1371:(pid 803): mlx5_load_one failed with error code -22
> > > [   23.555071] mlx5_core: probe of 0000:41:00.1 failed with error -22
> > >
> > > Please let me know if I can provide any further information.
> > 
> > If you revert that single change, do things work properly?
> 
> Yes, things work properly after reverting that single change (tested with 5.10.67).

The stable@ kernel is missing commit 3d347b1b19da ("net/mlx5: Add support for devlink traps
in mlx5 core driver"), which added mlx5 devlink callbacks (.trap_init and .trap_fini).

I don't know why the commit that you reverted was added to stable@ in
the first place. It doesn't fix any bug and has no Fixes tag.

Thanks
