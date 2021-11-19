Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C91456CFD
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhKSKKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:10:11 -0500
Received: from mail-bn1nam07on2043.outbound.protection.outlook.com ([40.107.212.43]:55345
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229879AbhKSKKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 05:10:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDaOXnErZEF+QftVY5rqt5JL4DSzwh8TReVHhfT/Xn8y3t/wRj703kOP7xrsGUQgbaFheCAAz6lHv3jcD7Sxuplz7n4hX39tpVwjl2gsm1TloFgtl2uNiJ7K1S2iP4qYrl0EwAgnTE0ObbYQWeroPAoN1jC4g2/O3Wws3jTxuaeM9HOZ0bzCJhrfoJZSdXfrx9NK5olUur/mZPnUwYRXmqGFs53ppSmKlSijg0/6XM644z8HmlvktyKrWvKfA5QH66sYLBPRGTMZdfGh/hDAMUhQ2BS3hG46WIn+7VB4BNmeBuksC08ORAkiV4TKMyq+MogjEUIScrTOzx9nJw/l1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lt6V1vD6HRczrlclE7LaIQDwhQ7GuzBCghmnpK1H0MQ=;
 b=kG3RF82R5VZQm46/gooprQASiABw8vGv2jhLSySMtSBM6OS7JF/5TNgGhjusEaFZ0ekIQhCrc0yeaWT5HNJ30z7EkZJnumM/nLuotZ0TSvuReyOhSrbrSKOOAcPzaoyxc/qlGoXPK2pZVX/Nj410ppEqBjWDtIfvJyHQO1lnd0Zx+vTgocZQKKuGG4tO3jBS0M30skNKm1a39l4J2V7Dbv/XFfjE9LYCUK4BGZdrelw8Arntv0pjHl4/dydkzn5jKqNV2Y1I6y1tviO5ZxBxR1JbIqhvBgl0Ny+CBUQvK2nAVbaYdQHSGagXQQSA57TlHF9V23uqhb+6GTLahfakvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lt6V1vD6HRczrlclE7LaIQDwhQ7GuzBCghmnpK1H0MQ=;
 b=AdPdyJcD99dcI+NuTf8LZhCCOvqjuxJPTYWF3wEuJPU5NiLgXCCFUJXHh/r007yyHYKwb5zAOWtSLRwjhhLSnG8ZLXfXfCze4w7gve+RnSLYAXgET93Em0ZK3ngOSRNxpC1fSgexy236YKoKcELImAt8ZiJjhljkZyQO31OoHyTQY0hFPLyPpgPRz7NHR9a5m898ve1kcLaVNBJMwBNypiX/IUYKIzYdtVEr+BJVOhuKcrBbdxP2H5QzRoNVmCQ3ybIXPtReeOdD9xhXlDA8gZ2wM9H5vZ0XPbv+9nIf1HoFVManxdbOPsme8Rcu8EFa7zZ1pYxoR9pxSMkkhGVMJw==
Received: from DM6PR13CA0050.namprd13.prod.outlook.com (2603:10b6:5:134::27)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 10:07:06 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::83) by DM6PR13CA0050.outlook.office365.com
 (2603:10b6:5:134::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.12 via Frontend
 Transport; Fri, 19 Nov 2021 10:07:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Fri, 19 Nov 2021 10:07:06 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 19 Nov 2021 10:07:03
 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6i3t2zg.fsf@nvidia.com>
 <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
 <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c240e0e0-256c-698b-4a98-47490869faa3@huawei.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <davem@davemloft.net>, <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
In-Reply-To: <c240e0e0-256c-698b-4a98-47490869faa3@huawei.com>
Message-ID: <8735nstq62.fsf@nvidia.com>
Date:   Fri, 19 Nov 2021 11:07:01 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0087db48-3a65-4174-73d3-08d9ab445763
X-MS-TrafficTypeDiagnostic: SA0PR12MB4366:
X-Microsoft-Antispam-PRVS: <SA0PR12MB436652555AC63887067989B7D69C9@SA0PR12MB4366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 08iyFsK24YE4s4g2qH2CN1S5mUgux4AhnKmuGjXE1pA2LHyfU+zWOfuMeDRSlaiyRk34vVzvwDZlDseuhVSoh6KsmexsWRHKHXFBUyobunf0ZJlRoGmUrH1xeDkNhPyJhoRqsU1HVqd+K3hnf2o6bSkBjha0fDTPooHzZqsz5RhNzk04vb2Xc9jGous7Ldjhm+KzfPNANgO7mtNzCKkRdlYAMm14NCOm7OtA3006dxmhjPG+2ED1fZReytSGr3R7x9Y7XyvStgMzmVBRKkMnTQwNYgEwRgR/cjOE6cEccPFektFuTJixT2k1b/I7naKd/okDXLX5OP8eiD0Y6DOm3bxWKB656s9roI2mcABDbfcnzydz5LQ7ZuHhDL/Jr2ov4ADCpHf/OgH3SFzugmAn9jWC1TFjJko9rwE0KJG06zmjXQ0qCXSzBmvMmJLa7MzVUx/yJBjnUUudIGrtd03awYR45n6GmhQ7XMKw7frZozmX8SyIAruTUugNKyXjzt4hIW3RGw+fj8vnFAxXdmiWU99odO0T9lX2wHCOhu0iwVq8AqC5sZY4x2EYPz08Y0Etq/hRQ+5r6SxHjhFWZIcxLx5lOOl4Dbt+ap3IJ2WuevVKbG8/wSWFD4LmjZTK/UCzeWPISgnGz0FSu8heewc1vQnOo4gjp2AumFYGJ555zTKH+AYFffiB2jSnhOBMcwPhjBGgToIcVzxDLiIJLYH7dA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(4744005)(2616005)(5660300002)(86362001)(336012)(54906003)(36906005)(6916009)(47076005)(70586007)(8936002)(36860700001)(4326008)(186003)(26005)(16526019)(2906002)(316002)(508600001)(36756003)(356005)(7636003)(70206006)(8676002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 10:07:06.0787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0087db48-3a65-4174-73d3-08d9ab445763
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:

> I need some time to test my some ideas. And anyone has good ideas, please
> do not be stingy.

Jakub Kicinski <kuba@kernel.org> writes:

> I think we should move the dev_hold() to ndo_init(), otherwise it's
> hard to reason if destructor was invoked or not if
> register_netdevice() errors out.

That makes sense to me. We always put real_dev in the destructor, so we
should always hold it in the constructor...
