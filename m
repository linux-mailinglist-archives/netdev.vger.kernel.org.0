Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3323F0989
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 18:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhHRQsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 12:48:40 -0400
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:47776
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229768AbhHRQsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 12:48:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQkaZ7zvNLAf+XPXPI6BIugf2JBAE5AJvrW6QD92Ch5rVz+WG4edBetZAbM7R9vMsZK+grMfT1tr6XqA5DtVnilmC5Fux2YfBzxo8lweBa1Ga6RczNXs3FyKd6bQMdviPCbzOVW8M2PYJ6halWm84Zcy5Oz0HJn82iNKgsKm++mJskEDX1rn/IQTZiPsx5yLR8t59QNpTaZk0ZEj+HA0JGu8c31tklDrhUKbb04to3RsvuFdktvCgZsx4j4UKjdGPqc+81+F6bXd5A9yoDD7ZMQrVXTEPc2d+YAAg3+mBj2MQw9kWR/VMEuONkSiPiVEiTuQkohb/7RY/OA6I+yMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwYK5ys9hV+RMI41OLxtXl6PO0pvm3AihKrj+s6Bu7A=;
 b=mue9WYwf9zMk/BxLui69cNwRZ7mWrvoPRCcpws0CoO/ddZqkj8oGIZFOyh2XWI9Y9GBcEQmZkq9lNNzE0v4oy36ikYGR8PrA4fA40+5hM/CxRI6Yn4pB/3Zx6DIBEaL7IIDFau9YD/ecmlCY64LGAkzQGsCK9rDQVRFmaRRRLeELVB1JiDlJ//rdzIEig6pV643aohWjdKrWCNZYzcX8aJ3BpTkPpp4mWc5U7z26wZsQeI5ohWU0XGjgQ9lFQAWEMpPSg2u48yBzn5qSpvsCcKs92QvJAeEsIb7r0pCBd4OXS15Wv3S7zQZu3s+2HdqOF1uMpWA2lggKygjcooIlxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=nxp.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwYK5ys9hV+RMI41OLxtXl6PO0pvm3AihKrj+s6Bu7A=;
 b=Ivns/9ygmnm228caL0WpxyAFs5DF1YapouClU3cPFNaZCSM//+RzUxSIyAmgf3h1SkeSpvvNHS2Sc4ItZbl0RCRf4fgU5xXhQ4yacoDkwQe2wK+S6jotG7twUi5Evb34NsGXkQnLAIQzuHcXyZhO7wACSYiPquBlrNNDOuErSbTwP8Fixy5/825Eu+PzMjSDOlx2WM/cf8Rck4BV3JFVj/fdtQJSIrJIFncR41An2NZ7hh0mRk+/fGotve2tjzyW+Kic32DSLOtT4GRc9ijHBFKkiWhcxSm7np65m0ne2d7bvWL+BwubyP9XOyCyYVqR+YiBL/trmFqOjYZXXk+0rA==
Received: from DM5PR13CA0026.namprd13.prod.outlook.com (2603:10b6:3:7b::12) by
 BY5PR12MB4081.namprd12.prod.outlook.com (2603:10b6:a03:20e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 16:48:02 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::f9) by DM5PR13CA0026.outlook.office365.com
 (2603:10b6:3:7b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend
 Transport; Wed, 18 Aug 2021 16:48:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 16:48:01 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 16:48:00 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Aug 2021 16:47:57 +0000
References: <20210818155210.14522-1-tim.gardner@canonical.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Tim Gardner <tim.gardner@canonical.com>
CC:     <linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jianbo Liu" <jianbol@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH][linux-next] net/mlx5: Bridge, fix uninitialized
 variable in mlx5_esw_bridge_port_changeupper()
In-Reply-To: <20210818155210.14522-1-tim.gardner@canonical.com>
Date:   Wed, 18 Aug 2021 19:47:55 +0300
Message-ID: <ygnh8s0ypumc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd2fbb40-ce88-44d9-ccac-08d96267f10d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4081:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4081105BEAB66BDD95A5EC9DA0FF9@BY5PR12MB4081.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9gQxEJP93APPMW573uJT9pRcDXzUiOqXnfdilBNOKdE6WryxCDp/a7Qw+BDARWbjwWX9tj7j5+rAmEucEw5IaRgUX0b9n4g2KXARIfEm89vVdMF50fbpZMQSdDU3RKzmL0lLJWxHzUKO0byAacbJoT8ia04alB5jc05tC8HT4iKvRYLIInKBA9oLzTTUScizOS9sR/m8JAOgE7I6DPtphRN+OTlQTRHdbur/Fae2uvvWPK2BDivq6IK5M+luD1xmhOs/E4VHxDvsQYC14+OyZWjcnm+UZ/760jqTDHRGrYh3gg/4+LPDbmrJImYtDmBI4n9DVazezE5T5uuBGWAO5YgKu8g9VQWbHmESQVF7xYaEbv+WKxA4mQxAa6zplGOgzT4mJGvpXO8m+EespZyrIOrxDL0H9URxr81MC18Wtp4+nh8E6AePmpcL6tzXABkvIt50wfn/+HxwJWVZcBeWpDhdeNQWMsW80uhWodt0DRU3WvjOQU56+QbawOYPbgJZUOs4vgU5i3L76lqni+rgXQ3Ezwp7/QgB2qdc4I2xdoXRuc9dZNrgnR/6y5BvQRbsCJ/Yujf1sw7TNGMpcotphez+bl0rpdu3Pj/Qy2prUrwPNdw4UR9humpO619/DwJnMxbgYWOxDuF3rkYEu1g44TLvFUwPc1THQQahrfGNK6+ODMb+rP6dD+u/IQy/hy/cAIjQzv/V0OjooDXOLaAzfw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(86362001)(82740400003)(7636003)(8936002)(356005)(426003)(110136005)(316002)(8676002)(4326008)(82310400003)(54906003)(26005)(186003)(16526019)(2906002)(47076005)(5660300002)(70206006)(70586007)(36860700001)(336012)(2616005)(7696005)(36756003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 16:48:01.3893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2fbb40-ce88-44d9-ccac-08d96267f10d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 18 Aug 2021 at 18:52, Tim Gardner <tim.gardner@canonical.com> wrote:
> A recent change removed code that initialized the return code variable 'err'. It
> is now possible for mlx5_esw_bridge_port_changeupper() to return an error code
> using this uninitialized variable. Fix it by initializing to 0.
>
> Addresses-Coverity: ("Uninitialized scalar variable (UNINIT)")
>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Vlad Buslov <vladbu@nvidia.com>
> Cc: Jianbo Liu <jianbol@nvidia.com>
> Cc: Mark Bloch <mbloch@nvidia.com>
> Cc: Roi Dayan <roid@nvidia.com>
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---

Tim, thanks for fixing this!

Saeed, this is the second similar issue that I mentioned in my reply to
Colin. Again, I've already submitted same patch internally and this one
is as good as mine.

Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

[...]


