Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557E84D5B9C
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 07:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346540AbiCKGbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 01:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiCKGba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 01:31:30 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110801903DF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:30:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5LmUJh0duTUKYmBpsnezllCLhdYLFDwwDnRBDNgstzpqCGu+gRXXeop5aMVXdnr2VTKVccEjcfktRF5fDJfygyKkAAAKZnZwBYk4whguH0b7H2+2wvsUQoR3bcUkAzafS3hKxvY4BUE7T1HfYy0pxr1lnDaDQEW1ySTTO3hYlsQtXIJZgyXfj2UqXumh9Hf1LIk0XwYoyc0Q1ZT8K3kogJ+6Ly6AONBloQl1kRcNACn1xi/oYWUDbPb/Yx5eRj13139LTy6N+XNB8rY5suXbrgaysI876SMMurMzWCGEQlvjH/S0zMZ1Rv4LaaidcxpJhOI5++mOG6TmpWtwkrgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78Y9jdS9AgL30PyMBnpg3h2N6v3HEIqkACWyHGNCElA=;
 b=dMLEXCKfWoNoUv9eVGnPsdq4W0TwX6IiN65ddWngCzKdHu2zzECxdFq5UD1Z1EeG26lDC6yBhUwKkknyxSBkF1XZ6PKaNF7eXnZQBWKGYpRPfD6H9FOg0PuD7CoHwSaCbhYKOzgMMDDpQHs7GJ01I8mAShIcxZ/xT5cUS317C9eWv2em58kDVb9ugfjn3fIk0x0FQrwK7vUGkf5KvMsMsTbZddjt5JX0uB0P4SwQW4LwbVhDyg1VOR1JwdA/BDwYjljc4KLZt6tCLCq4rwSPn0yEOzaYLZOrh0NaOtNdJ9wNoIGWUnvl8XUhuPfI3Ek6vb1eoHtb2QGx77WjeFl9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78Y9jdS9AgL30PyMBnpg3h2N6v3HEIqkACWyHGNCElA=;
 b=Ck4KgmxwrJZVPD2HKnLohCpMkWXQQR0dhnHUZlhzEn9kHgXBPKkKzB5cFg4WL1vUo8IjasoWPnnz9CJq/BiifFzYpCQBm1NpVe0KUgCaKqpLhIHTF6EhWcnLbDldruPh5Ow67RTMgPQ7NnJ64eVX0TsTUXXqBMJHyIlhmbiby6dwQvdOOXpsUTBfP3wV6r2Q8i1fvxxKcfuJfSbFJz80UT7VGT6y6YP7NgPoGDAGdBPQS1lnJh4wnv6yZ21MMsw6/0Ky1GhQeK4h11MMV6ZkLVz2YYjFIAI38xygrQLHyZ3Fi6EiiCJqOzNZygoLOAnnR4ySDYO2PAiMC1CsFaYxrA==
Received: from DM5PR21CA0066.namprd21.prod.outlook.com (2603:10b6:3:129::28)
 by BL0PR12MB5522.namprd12.prod.outlook.com (2603:10b6:208:17d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 06:30:26 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::9b) by DM5PR21CA0066.outlook.office365.com
 (2603:10b6:3:129::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.10 via Frontend
 Transport; Fri, 11 Mar 2022 06:30:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 06:30:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 06:30:25 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 22:30:23 -0800
Date:   Fri, 11 Mar 2022 08:30:20 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <YirsfJF/T13qsVSu@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <Yim/wpHAN/d0S9MC@unreal>
 <20220310121348.35d8fc41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220310121348.35d8fc41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0934537-0f09-4432-e339-08da0328a135
X-MS-TrafficTypeDiagnostic: BL0PR12MB5522:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB55229FD8411483EC20A36D08BD0C9@BL0PR12MB5522.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q6ZZlHq7m5I9ICbF0bGrpYL4A197KVn5AFDgvjE83zh1EBdZ9fdYi8cYhENLftEhfmRr4TPfklbZN4Qw5lqzAKAN2KkBhCxWz/F3nIiJHR2ftbgwCoAM5Xsp8Qvq6witnhShTLUZc5EEy6wRrgSAhHk8JgA6YdfHEum3f9gEgWrp25P/jSgylH8g3JUyOJ9qyo8/bZWDH+rX/yW7Oykrf82uCA8Jq47b9BEBXIEglm5oqXNpJPNDSHxzf8fIlfxp9D9nwFmRTXow6ziMBSU+hA2k8QlE3GDhFz2dFoz/2ZI8V3NR3XEEW9gsVcoKCTGHm6nD5uX35JjxIM+UxxUTtdj/DKFK9zdCdQ3mr5FfIk9s+bFlaOA8PIH5OSpTV6vyuoV0rH6mF5wZkHP1OTEIJ8/4UV0a+nH5iq+HxQIXOUi2qaWCtpKzxAAdq2wH7pofry8/xofJ5D0Ld9e1RLG9189Edx21+sSufwX8cE5oeQMVrIYvOADwm9zkop0BRooTg3PUj2vpnO3gAWISeo0WXS+Dzq3wZNRgGEbvBkbz6u0G0Q7u7eb4flvJqXCvFgJ5VQSD9093G0S3YnUGwDDIRb4VUXNxn9JEFxXOdphWW0Ae90ojM/2zLuDArwlvHryOpr1Nr6FnXgkUkwe/TYv2IwdaxH43r1NxsVXCaGyGHgX6hNz9efhzEsLNtNQ/rkJMYSf+z1JV3f5le7rmg16LbA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(36840700001)(46966006)(40470700004)(81166007)(54906003)(356005)(36860700001)(40460700003)(47076005)(83380400001)(336012)(86362001)(82310400004)(426003)(26005)(186003)(16526019)(6916009)(2906002)(8676002)(70206006)(4326008)(8936002)(5660300002)(70586007)(33716001)(9686003)(316002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 06:30:26.3335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0934537-0f09-4432-e339-08da0328a135
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5522
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 12:13:48PM -0800, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 11:07:14 +0200 Leon Romanovsky wrote:
> > On Wed, Mar 09, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> > > This series puts the devlink ports fully under the devlink instance
> > > lock's protection. As discussed in the past it implements my preferred
> > > solution of exposing the instance lock to the drivers. This way drivers
> > > which want to support port splitting can lock the devlink instance
> > > themselves on the probe path, and we can take that lock in the core
> > > on the split/unsplit paths.
> > > 
> > > nfp and mlxsw are converted, with slightly deeper changes done in
> > > nfp since I'm more familiar with that driver.
> > > 
> > > Now that the devlink port is protected we can pass a pointer to
> > > the drivers, instead of passing a port index and forcing the drivers
> > > to do their own lookups. Both nfp and mlxsw can container_of() to
> > > their own structures.
> > > 
> > > I'd appreciate some testing, I don't have access to this HW.
> >
> > Thanks for pursuing in cleanup this devlink mess.
> > 
> > Do you plan to send a series that removes devlink_mutex?
> 
> I would like to convert enough to explicit locking to allow simpler
> reload handling. I'm happy to leave devlink_mutex removal to someone
> else, but if there are no takers will do it as well. Let's see how 
> it goes.

Alright, let's see.

The main obstacle to remove devlink_mutex was netdevsim port creation sysfs,
so after your locking series, that change will be more or less trivial.

Thanks
