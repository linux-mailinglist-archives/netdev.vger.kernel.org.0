Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0DC3F07AF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbhHRPRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:17:23 -0400
Received: from mail-bn8nam08on2069.outbound.protection.outlook.com ([40.107.100.69]:21569
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239506AbhHRPRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHrYih/dlv43F154Jc7Ahpep476cCPHGfDy7eUqGG2MWAjkNiFIm3ngMGbNUUiy6IBX7A2pAa1lfSidfJ2EGIuIkQfbMu8OmfyltwO/Qgt4KK00hJeN9PjhQOjCSmhummKgJmDu1KZ/ZyCt3iudgVy7VDkPMkxNCSuSl2XRiWaUVkt14jOX+S6i7CyBTOAWA0CtpRnN19JH4JgPVnuBghM1dGhTUgP7mU3oRFnumliVNZgYfdFbwaTDyaEfFMzqiedLMmtzIjdgWU5kGUitHZkI8mxZFRf3xJLYJpGvU6QoVoV3u4cwSnWs81NX0HY0/2cRKm0crKZZlcFqPvENTew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjGt0ZrgiVUahAClMZ01A9kmYaGRiC1cnvt82jrutMw=;
 b=Hen2g53dp0pFhxR1vKkuxTr5RFJwSchCM1DZawPFq4CEgr29wVByHHuiyxI9695MFfMcRpOYAL0K4ynFZf0vQs8Jayr9nGp20JE0hD10kQiGvXuuMwYwDgpui4Sfmcawmtaj2yxaHNpQk5qJAPGaRKx5SeSGIU8Jn1qGOfgZtfviRzAIBRpQPHrWWC251KG0BkS4RnScQcT2dPNJFolALoe8pmToY7h+ZaZOn2h9tldSIkkBILpBqy7e4kvk3McT0Zv/E6ZjhkyWqQr/I5RyZawcJ2B7apKuObsqkxy8SrzSMSaJn/R0TheuAe4anjWLRAoYQA1InJGpudWTurwtYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjGt0ZrgiVUahAClMZ01A9kmYaGRiC1cnvt82jrutMw=;
 b=RNGZYrroPTTud6awNFA4WSC8ABxRWoEYxIfArCcT+pjjlsfThWPbCJE+BResabdpSQrwYH5u+pswjsVve0vQSSBm+LYeO8GF+/rMupWdbIVHiyvEdobqXQPrSfEKNtz/ws7WBrHr1UVwQSEAyK02pb1c/J0HD1oYLoWalaYeye30zYHdkSL5g9I9691IqH+acrDN0sGqfvM2KeYXVMoI8iGtZ3BiSV/tAQf7jJujdkMHy47tezu5brqJp+gHcwWpoPiwNtx5XpNj8604suvwmxZ2+HDSdTHIaX9yqyDG661AMiyzY6qx9YzhEjLB7JsOoHMvcTxOgB55XvX9Ygbdhw==
Received: from BN9PR03CA0005.namprd03.prod.outlook.com (2603:10b6:408:fa::10)
 by MWHPR1201MB0205.namprd12.prod.outlook.com (2603:10b6:301:4e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Wed, 18 Aug
 2021 15:16:37 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::11) by BN9PR03CA0005.outlook.office365.com
 (2603:10b6:408:fa::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:16:36 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:16:35 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Aug 2021 15:16:32 +0000
References: <20210818142558.36722-1-colin.king@canonical.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Colin King <colin.king@canonical.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net/mlx5: Bridge: Fix uninitialized variable err
In-Reply-To: <20210818142558.36722-1-colin.king@canonical.com>
Date:   Wed, 18 Aug 2021 18:16:30 +0300
Message-ID: <ygnhbl5upyup.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bc646ba-0488-447e-04ba-08d9625b2bd2
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0205:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0205DFBE8260DBACDE442F4EA0FF9@MWHPR1201MB0205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVuZJZdUVcKmT3kV5T28F1gn1jRwue4T4LgTLlHDMb06x3zAAcK+8T5p8tLgZkk0Ckff1dY+ACtVQZs3dKvVsjLwqdSUZ3O2w/QSntcpN7TO/Azs95tjun42UcHs1lYVOpGGmiTs5kSTu/CGpNasNePRv195y3ADbhcNW8QKUTzMzP7wKy98ImE77CwDkGzEzWQxeY3mGiFhcIhzMIXouohGxwzTACNA24q4Y9sZWZpDplfULChlaSunKiF+1Bx7EtuHVZ5RgWxR9/CCbp18nRs0xo5a9TJxSPNdIdk43sRUbwq9X+4vmviH9LelhO5rh8eTqxklo3tmTEYNu5r6cdjfJEyEGHEoDHG5lAsIe6xufpsocTpl81iA+VJ7OG7INaqriITscea7nQ1jL8MPKmC5YuD+cWQrXFqI9WYXLuQJ8N/c84aFU9srhJA3MG6+fmiZrYUCPmH6c17D1cTXE1Tu95zenu7+c9nM2gAX0b3H4s2MB0LhRH+SXHfvPu7PL5rG0MIDQsLQMNMMRvac+xKZ9cAESVYylt/gUKb95t+8sw7Bs8CgxXN3VeYaLuFCE7GbkoMN8WdpIsb/Zhs50ckUzFE0qwQH7BpwRuNP1a5MTbdbHHmGArUKQ4LeMl7xBZ5sCsIpAYsnCbvrTliw9SlQOOpBGgqilAbQeTn4ChtZmjJhyOf9zrUwfdbxDo/6IZhKvfyKpi9vVSPfGPJkBQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(36840700001)(46966006)(47076005)(2906002)(8676002)(2616005)(36756003)(4326008)(26005)(86362001)(336012)(426003)(186003)(16526019)(7696005)(82310400003)(54906003)(70586007)(110136005)(316002)(5660300002)(8936002)(356005)(82740400003)(36860700001)(7636003)(478600001)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:16:36.3317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc646ba-0488-447e-04ba-08d9625b2bd2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 18 Aug 2021 at 17:25, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> A recent change removed the assignment of err to the return from
> the call mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get, so now
> err is uninitialized. This is problematic in the switch statement
> where attr-id is SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS, there
> is now a possibility of err not being assigned and the function
> returning a garbage value in err. Fix this by initializing err
> to zero.
>
> Addresses-Coverity; ("Uninitialized scalar variable")
> Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Colin, thanks for fixing this!

Saeed, I've already submitted fix for this and another similar Coverity
issue (in mlx5_esw_bridge_port_changeupper()) internally. This patch is
exactly the same one line fix as mine, so you can take whichever you
prefer.

Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

[...]


