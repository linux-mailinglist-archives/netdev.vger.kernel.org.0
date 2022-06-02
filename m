Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAF253B363
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiFBGNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiFBGNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:13:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FB22A1D6F;
        Wed,  1 Jun 2022 23:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJvR2jV/1a5l0buroogPzaT3xY+jU7eOwFUFuCqOsUVZAhzyHBBgLUvvU80BuzV2W8ffkJ9k+X72ParBFkLnHM7+UoGPqXbW8dEtq76+LR89DF91CtELKwW6u1xe+7gzXT6vX2EfYVry2t8glcyGS7d6akvc2LGSYKVr21phKk6n36LbDmtuPDUVPiE2UJgteaHiVfFaQPc2eN3YkVQJvmyLEne2ljoVeSMN8vR8hB7F1FsNy0+U6i1KdmTqgO2QrjQVMNvApvWivlDwPueBChVO53WOosPaSJXDuCH/bEGOsuh4wak/CBugQI+oW6PSN1IugEkWPv6ibhxaW+sihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC9VjVJeLskg+glQTHs1bLxDw4MSt6blFqZ55P2amt4=;
 b=SkxLBAvc7kI2kykUJJ4wIOBXr0vOoTt9zW0Nlphgu5ARwLJmYPCZM/6rNK7SQlFqxeghDcCb5zoomTnqIWud/LBDpEgJppCXPRX8xrOy00DUrmGlPQqumYLHKbgum4subsmUrEldVuezQSlgb5FBLyJkf3kK72bCG5sjoyOBrz9VscUp29ckPA1tU63hhJ4ZNw2UIm666EtMBhl/fYIytMcA5JeISgn8SeabRzxvi1pZdpeK5IUQRQ0gRGQTgyexmrIZ+dUTfFZVk3yIj43NG+WOYaeuobaywkkvbgN7cQLhsxFeC4XKMS5pSdgZmy+KFOLuvGPHrRMvF3ZCvEE0ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC9VjVJeLskg+glQTHs1bLxDw4MSt6blFqZ55P2amt4=;
 b=crf/j0HddS8nBAFC1+D5S2FS1HuoQ6yLSsNJRayOtRKpj3tPXGoMgnedsCksauHuI2HQyFFf3x+PkDm/y0ieEcvgDBSS76BqUZhN1kARYIzXEPoewgwXp9qDPrseAMITXw8VWH646C3llw/2qkeBCCt3k+eaxkX9h0pNHgOsZeRq1X4s3ZRabmHTtoYmot8ftXzbWWuGOXYte857r86CUMwP1jwVGnza4IQzriYVTGhRwMjURk5cMKrQlqfb81SCW5ADHN7iC83pwY6wWrWU1I9U5IFfNQpg+GilYwI6yzEnyfH0sKvcfwgrkadzh8jfmWSlYfkmInMpH5OaydxWbQ==
Received: from MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::17)
 by BN6PR12MB1778.namprd12.prod.outlook.com (2603:10b6:404:106::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.16; Thu, 2 Jun
 2022 06:13:32 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::71) by MW4P223CA0012.outlook.office365.com
 (2603:10b6:303:80::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Thu, 2 Jun 2022 06:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 06:13:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 2 Jun
 2022 06:13:31 +0000
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 1 Jun 2022
 23:13:30 -0700
Date:   Thu, 2 Jun 2022 09:13:27 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to
 TLS support removal
Message-ID: <YphVB3EGzcLtZxvQ@unreal>
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
 <Ypc85O47YoNzUTr5@unreal>
 <20220601103032.28d14fc4@kicinski-fedora-PC1C0HJN>
 <YperBiCh1rkKDmSR@unreal>
 <20220601122618.78b93038@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220601122618.78b93038@kernel.org>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d105b601-0e97-4436-9a6d-08da445f04ec
X-MS-TrafficTypeDiagnostic: BN6PR12MB1778:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1778731AC1EE781073B5E1D7BDDE9@BN6PR12MB1778.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsHockwrJTFFDsZirzpBqKjyJpSJbJ/2YrZQJxHyNCxLTFdqHLNMYsLQC4/c0Sl4SYLafJDtq2mEFccN5EPLBmEsxs0PjnXvVnb2Uty8CiSHBhzaw/bt312EeeZHqrJAL+sKm7KnUtYXUBjJoRJTU4xZ2DB/oIgZKGLQdO34gaDFhSdjsfyPG8a3DFpxCj9wKdpro5JaDyOrcvsyF47hRlij1IL/hi2HEY6/6iYDpYh1RIXRtFA4KT72SzRhcqZ4neCz87hDV7EetYlq0AkcR8HJFWFhJzWoRblGEcmPxb4qnd7r1H6IqG6dB47fBhDORqiNN/hBQx0+egc1tat1qyQ+GnIMpQeV3eoJ/hAaOTfdnta9fjOAccUzVkZKS04tfhvtChSgrGkEnSkzxCYxbaYEK5WOPadmExBYod/AOeMh6oXpzUxy9DxeZCiovoNsCvEmzxCCPU8LFj/MLuo2YqZXrQ+NH2pzdfZMDARWzrcQPpcMgUhSL8wxKKmesI86dBeLmGlouvu/xLOjQsXF35deGuXmhblYDu8dA6B7BIq+VeRU7hlU3o361rLX3MGa9v65q1l28G2kmyQ+SrUhZiqAh6dDLW7oCGCTPJsBg7G0PUPhzBIpW7ULtVhtmkYtsArgcotdXs55F+nBrljsIZApo6czWssd7KsX0Csv/jNc3HBSL61ItQhkqU19SjOtcgJ5yqLnx7/5JhXOr4m3d2CaH7fPG+6EnKx4lkk1SSUXO3PUxD/FwPNDlf54++NhWpaK4/OGEw5F0Y7Ik1UJuCZyCM+wcmx6sBppqXgZQzNLvmAZ7bKT+6VB4sXCxQFWTNBDLswjEV3M1PASNLIIKA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(7916004)(4636009)(36840700001)(46966006)(40470700004)(186003)(70206006)(426003)(40460700003)(356005)(336012)(316002)(16526019)(2906002)(54906003)(86362001)(5660300002)(508600001)(6916009)(47076005)(8936002)(107886003)(966005)(6666004)(81166007)(83380400001)(82310400005)(33716001)(9686003)(26005)(8676002)(36860700001)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 06:13:32.0449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d105b601-0e97-4436-9a6d-08da445f04ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1778
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:26:18PM -0700, Jakub Kicinski wrote:
> On Wed, 1 Jun 2022 21:08:06 +0300 Leon Romanovsky wrote:
> > On Wed, Jun 01, 2022 at 10:30:39AM -0700, Jakub Kicinski wrote:
> > > > Thanks, we will submit it once net-next will be open.  
> > > 
> > > It should go via net FWIW.  
> > 
> > I'm slightly confused here.
> > 
> > According to net policy, the patches that goes there should have Fixes
> > line, but Fixes lines are added for bugs [1].
> > 
> > This forgotten line in MAINTAINERS doesn't cause to any harm to
> > users/developers.
> 
> Fair, maybe I worded it too strongly. I should have said something like
> "FWIW it's okay for MAINTAINERS updates to go via net".
> 
> Documentation/ patches and MAINTAINERS are special, they can go into
> net without a Fixes tag so that changes to get_maintainer output and
> https://www.kernel.org/doc/html/latest/ propagate quickly.

Awesome, thanks

> 
> > So when should I put Fixes line in netdev?
> > 
> > [1] https://lore.kernel.org/netdev/20211208070842.0ace6747@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> 
