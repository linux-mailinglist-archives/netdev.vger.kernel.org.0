Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CFF40B4B2
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhINQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 12:33:58 -0400
Received: from mail-co1nam11on2077.outbound.protection.outlook.com ([40.107.220.77]:8354
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhINQd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 12:33:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvqytSxDq3b4fzL6Q4yXFAsA6aSsFniwGydIMkSmLS6UCmck0RWVh4wAkFG1n75JG7RPgbOL0pXVkE1MnRo/6bVHeEXrjZtkZEtLczHyIfGTdm0FYIRQIWJmN5Qg4kSS33oCuwEtTVJo2xsTwPbWt9ispBAFfWm1oe9BNxbEZS8rvWu0SiCs4IVQQ3bOSM1NA29YtIfIJB2dGLfZW5MOmZXNAD0iiC7d9NxRF3MB6uirTg0LXJH9bRfhA8kA7IVR8eYpNvrRr8kMKXaaAwnkPLG56tG13QdlH1S9pq9qN0d7+jPm03kpnRDh3OtA5pbDfBS6NDJKbfBNjpxkN03lTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PhUxwAgnz1TjRj4Ni2MMXsnFHJMoPGZy9PqT27zEC/E=;
 b=LUHoRYW1gKJpvthRsK+WYgEITXmFpMqKPifhta5LO8cXLo8hZOjYGxaxnE53waVwEAgCpR3+HcVGlR6vD0uWKwLPKZ/h5kdCVpfRaFjfmUK8pxNwjBGsNTbjPUOWDlC/wd2k2yQkv1267DST/HLRdvjO/0HjP05/XnhMXD1hWhWjXBNb4lbC3adM8PdMDxB0fw18OrDNlMVT6ttN/fNB6yugV5loHcYwtAO+sze29r0P/Dd6nxceAJ5FEWBv6AvRlUhi779z4bnYWa8KIvrEhHV8wOOlqWEBSHR5Xp/xVMoNPA1Xwsa4wZ3Tt4TJGahOfYTlRA2ZSCJgnnAUJrNV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhUxwAgnz1TjRj4Ni2MMXsnFHJMoPGZy9PqT27zEC/E=;
 b=evJ5SAn+XFnBCe80DU7UnOWkMJVufBYKw7buXVNs7sNcE3xYZ7bWk+kWP7c+6o0RDMQGZAJYBVtdGgc0n3fU5602qldyJv00zowXe/WMGplYVO07gQlVeeQuA50DkTfHSBnDm/CLBKqbx4SDD0qeNCP/fILNDPIwfQrRq84oeqWO4lDTU0dhDN+rQrQGrk5mRbQ1VzAeqRa59wecu2f3iOgWWgTnFfixjJcl9F0v8aOWy+m6BA+PCriZ3GJibF29XVcrl871eU0cdvo9B2BvzYlCxQzDAirwCKUN6cO3dePvWSR9vOOVEKRYpTdX9Q+ujnN8m99l90dE8i4CZG6Yeg==
Received: from MW4PR03CA0269.namprd03.prod.outlook.com (2603:10b6:303:b4::34)
 by MN2PR12MB3662.namprd12.prod.outlook.com (2603:10b6:208:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Tue, 14 Sep
 2021 16:32:39 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::b6) by MW4PR03CA0269.outlook.office365.com
 (2603:10b6:303:b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Tue, 14 Sep 2021 16:32:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 16:32:38 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 16:32:38 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 14 Sep 2021 16:32:36 +0000
Date:   Tue, 14 Sep 2021 19:32:33 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <john.hurley@netronome.com>, <sriharsha.basavapatna@broadcom.com>,
        <ozsh@mellanox.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Questioning requirement for ASSERT_RTNL in indirect code
Message-ID: <20210914163233.GA10664@mtl-vdi-166.wap.labs.mlnx>
References: <20210914060500.GA233350@mtl-vdi-166.wap.labs.mlnx>
 <20210914072629.3d486b6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210914145439.GA6722@mtl-vdi-166.wap.labs.mlnx>
 <20210914080746.77ed3c7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210914080746.77ed3c7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2296c37-3905-4688-12f6-08d9779d444d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3662:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3662AC22AC86E8479B163E2DABDA9@MN2PR12MB3662.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CG6j33GeZ+TzeNCrKQobnh9+QzT7yq9nPkVMbf2moof6g9m1bRyJlvNlSHrMEIijojgMjSvScRL9L0XZ0GIHKkYgVVVjQTXEI4KH6HKshJxrIj26Qs/jynFidYyWbJY2jM3FF1t8IM9L+EQPvqhjvwkdGek3b1+lSvasU5tVDkyQzBVbLx1tZNMLkHFDf2loYrFHnP8wOOUOKjqQA5uyuKfUPogAPVypPWXEzpebyJ0+PWgfSwpmVctknWr61bCKuX+AQFjjZruT9c3Z8N38vnogGsoO0BC/wc1hxn+yolvmNmpJRzeuQi0/olhCslsSG6prH4aJcGL2+MD2aSq2ROVoaKjL15h0AeRqjP9WPHU5iFMWEinpBwB33TamqVtJnnXeuIS9QqvqyYH5PPt7rDzUmXHFSxmrnuxm8VIBRXB4mnVZiadJNK0m7k53LNqeF3HjmfF6TpTVmhDyu090FvhjV4Ds8ooU0e019QvvwGQSNBiXgSDDz2POgQVS+aqjAFDMh3Eso96JCLicgWsz5SmP/rqY1El4uyGLtVsDS95JY6lhWC+l+96EFrwCGbopsmEHsireJxHTnfkN1TsUlXan+tvjOUweztacNHrc9gH6tCRcnBLju5xpYpWHIVFFTWEWKzrmMNWytxRr+W1OEYHLlaMh+2APj6TZi6Ov7n6TfkoUgcGQyileBakGRU0sp2zOHHtJfBvOg86olFZ7WA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7696005)(6916009)(36906005)(54906003)(316002)(70206006)(8676002)(36860700001)(6666004)(86362001)(5660300002)(26005)(8936002)(4326008)(508600001)(336012)(47076005)(83380400001)(186003)(70586007)(1076003)(9686003)(426003)(7636003)(2906002)(356005)(82310400003)(16526019)(55016002)(33656002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 16:32:38.8005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2296c37-3905-4688-12f6-08d9779d444d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3662
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 08:07:46AM -0700, Jakub Kicinski wrote:
> On Tue, 14 Sep 2021 17:54:39 +0300 Eli Cohen wrote:
> > On Tue, Sep 14, 2021 at 07:26:29AM -0700, Jakub Kicinski wrote:
> > > On Tue, 14 Sep 2021 09:05:00 +0300 Eli Cohen wrote:  
> > > > I see the same assert and the same comment, "All callback list access
> > > > should be protected by RTNL.", in the following locations
> > > > 
> > > > drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:1873
> > > > drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:303
> > > > drivers/net/ethernet/netronome/nfp/flower/offload.c:1770
> > > > 
> > > > I assume the source of this comment is the same. Can you guys explain
> > > > why is this necessary?  
> > > 
> > > Because most drivers (all but mlx5?) depend on rtnl_lock for
> > > serializing tc offload operations.
> > >   
> > 
> > But the assert I am referring to is called as part of setting up the
> > callback that will be used for offload operations, e.g. for adding a new
> > filter with tc. It's not the actual filter insetion code.
> > 
> > And as far as I can see this call sequence is already serialized by
> > flow_indr_block_lock.
> 
> Hm, indeed, should've looked at the code. There doesn't seem to be
> anything on the driver side this is protecting. The assert was added
> before the flow/nftables rewrite of the infra, perhaps that's the
> answer. IOW the lock did not exist back then.

ok, so if there are no objections by my next morning, I will post a
patch to remove these.
