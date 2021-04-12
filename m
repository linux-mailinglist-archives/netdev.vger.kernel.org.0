Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F935B80D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 03:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhDLBWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 21:22:11 -0400
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:52638
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236329AbhDLBWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 21:22:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAt42nsr6RVd/62zFV9T83Wi4XqeKGWFpRwB6y6G11hgyXakcDF7Ac4gTRJrUVnpxR1H7FzOmzOjyjV50JKF0Gm3YKL2xR9OhepqYVFHn6FsYs1ZqjXfSf7gpgpGTf4PwUmxpt3TmOgndeXWTY+2wbxV0nCfU+dIduOMRSIFcjfI+Wvti/E+h4je+F3Zsdd+/0gEBPnFNcDcXrAjxTNSfBCaQOQ5wXsGGze1iaxyzrCxXBu5KNNCj4h2VSYid03cr5fFdlFf3rqr4ND3o6CcNbgkabEC/G7bJVG5k5RzFT0wL13TR9YCw52rboezLa5QuqD47lTHOYjAmxOUyLoS/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIGqNQ9Ov+aOjHAlvjopAb7Wz2MxxwQmR3T/0jdfCaw=;
 b=QunoLfuj5VpjhT9/DdZRChNMzxBG+pFKEc5+bv6VHGIfxnjgzKqux+eTqZQaBLG29cCNKkUl0p7Y5Jpe4IVQBiqD/M6zoF6MKBNlVjmQigemB4UNReyS3KI+86D/o/dBSQByuUYY+j8aH+4Hvum0Dx/NIWiU3XFHxEwOBbaPQL172hsXA7+utlYo1NvSPswlYLKlQU4sG6gpf8PsnIjy6shzD2/PBsxfpGMxWcpdTE3trQDSYX2l786QluOZLID9V8KvE/pLXwvADNRPL20VeCLRWDnmyLcHNhP1eKktcogyaTR2DYN1o5MaIyVPLpSMu7VBWlzJ8wyH8lEQeH3SLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIGqNQ9Ov+aOjHAlvjopAb7Wz2MxxwQmR3T/0jdfCaw=;
 b=RXJLO/uLxP3D1uwZL7bv/4+PR7cVPNaAm43RQpETejrtwFN0osnL2df+wqJt2Zmn9LWkcRSGILwMpi3DC6d+YhyZBzFTeGXg993A9L+JJ90dFuLHg7OjbPG7kEDQtvoTZGSjpQ7YaMzIgVXkgFSug1e88YMaQjsxzTPUQJ6r3LxjTpvd4100Adi0jf+mphG/pX2yR4gZrfT8Ao9c0n6fM27huAr7jM2ceV6VWva8A7mQHY3PwLJbXHORjHHdM3lYI7CeMv+2xVc0jYcwja8w2vcGKR7LoA5179gqlXJjKXG1VaUL3g/eXzSucNouJvWqvfpvKityNATYFFxBQPcsMQ==
Received: from CO2PR06CA0062.namprd06.prod.outlook.com (2603:10b6:104:3::20)
 by BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 01:21:52 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::b1) by CO2PR06CA0062.outlook.office365.com
 (2603:10b6:104:3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 01:21:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 01:21:52 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 01:21:51 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Apr 2021 01:21:50 +0000
Date:   Mon, 12 Apr 2021 01:21:47 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net] net: flow_offload: Fix UBSAN invalid-load warning in
 tcf_block_unbind
Message-ID: <20210412012146.GA26164@vdi.nvidia.com>
References: <20210408074718.14331-1-jianbol@nvidia.com>
 <20210408141619.7dd765b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210409062555.GA1191@vdi.nvidia.com>
 <20210409090104.3e2a95e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210409090104.3e2a95e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d239d7a-f413-4629-c6be-08d8fd515a5f
X-MS-TrafficTypeDiagnostic: BN9PR12MB5179:
X-Microsoft-Antispam-PRVS: <BN9PR12MB517956A75CD236E7D1FCCD6EC5709@BN9PR12MB5179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FEoYaTCubykz61Wux9um6DWqD1GLwvfALRAaeV2JqDsmRQwdGWhySmC9gSKqC8RgFUn7A3qoFX01jLXgfi3/s+5u2+8CdDR4BUsVbdVC1JUOSHQ+NykED+wevWeLeRAmy5pk/RsFYbHWz7hJ+8D0sOdI6zNFyDz39vUosuWwDBvS63zzOSJVdlmXA1Nrlc32SIe1czYyIDEkWiWQ1f5oUrdECTwnEkWJyRzTymAzAW8hCX/ued+dkeiyhoGejwFFW3GdIzA3vQ2thZk2hBWb/XWFy892KC7TOLK2az5aS3xUROQVbbI8QZf0ZNl9BTpk4PBqdiSVlT8Vs4MaUFUTyNjdkkqNZ31XYw6b2xVe7xwKzPyz+CxSbfhK95X5uiwUGFD953p39hIBMMR2UA6blZtBbwsQE1tutx/z2nwF2fpDJZuDdNUjPDhIZXGnnGPTmD8A+rzwyfiWssg0RfkxhV2BpjGG4lOy7B5Cy8tFWsspwcVkPhKIlcSVyOF64KEreUaRFOUP6YXt7zOvfq5Hn5Ec+gnW4sfaBpmAxLYSIM5czNDFxhd80zJOPWUrBgfXuOr8dUXM+D2P9gthNf3TkMJnsC8CrBxV2rPUh7qlKZBP3kzggnYXKuNEiy09KIeYlzQtE3iAoorI0kNpelwETQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(316002)(6916009)(4326008)(7696005)(70586007)(47076005)(26005)(55016002)(70206006)(5660300002)(478600001)(2906002)(54906003)(36860700001)(426003)(356005)(8676002)(82740400003)(86362001)(8936002)(36906005)(83380400001)(1076003)(82310400003)(6666004)(7636003)(336012)(186003)(107886003)(33656002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 01:21:52.1930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d239d7a-f413-4629-c6be-08d8fd515a5f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/09/2021 09:01, Jakub Kicinski wrote:
> On Fri, 9 Apr 2021 06:25:56 +0000 Jianbo Liu wrote:
> > The 04/08/2021 14:16, Jakub Kicinski wrote:
> > > On Thu, 8 Apr 2021 07:47:18 +0000 Jianbo Liu wrote:  
> > > > When device is removed, indirect block is unregisterd. As
> > > > bo->unlocked_driver_cb is not initialized, the following UBSAN is
> > > > triggered.
> > > > 
> > > > UBSAN: invalid-load in net/sched/cls_api.c:1496:10
> > > > load of value 6 is not a valid value for type '_Bool'
> > > > 
> > > > This patch fixes the warning by calling device's indr block bind
> > > > callback, and unlocked_driver_cb is assigned with correct value.
> > > > 
> > > > Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> > > > Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> > > > Reviewed-by: Roi Dayan <roid@nvidia.com>  
> > > 
> > > It's been a while since I looked at this code but I don't understand
> > > what you're doing here.  
> > 
> > To fix the UBSAN warning in tcf_block_unbind. It's easily triggered when
> > netdev is removed before tunnel netdev.
> > 
> > > The init in tc_block_indr_cleanup() makes sense. What's the change to
> > > setup_cb achieving? Thanks.  
> > 
> > But unlocked_driver_cb of flow_block_offload is not initialized in init.
> > Calling setup_cb is to get the correct value from driver.
> 
> I'm trying to understand what became of this code :/ Was there no call
> with FLOW_BLOCK_UNBIND to the driver when driver was unregistering
> before your change?

Yes, I think so.
> 

-- 
