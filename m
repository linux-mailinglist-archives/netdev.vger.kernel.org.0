Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DD751B783
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243572AbiEEFmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiEEFmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:42:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9936437;
        Wed,  4 May 2022 22:38:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8cwFe8lomTA34eaLTAnmkCwsDYvEHqmKN/qhZxl09ahkabMMrorGu8X0AeeV4IVRbjRc33UVS5u7dUW9Y8yx//UMeqy0oiJ7QVNaSsAUiNSQ9S6fG+KcHrOx96fnIClodDnb5eSQWKKMhhS1mGJywcOfQgyN4NDrCtr9cXvVVe+xUQYF+kmdJLz9yrB8WyE8rWUYYZkpmT3Z+RvzQfrG/mazjQFSF7qG2bI8Aw9WzVMKDUHnTGdVGFJtoZ0EAX0EX/McJ7oPozATHiMr1rwUL6B82PO2Q941BJ6+RijE0Oxv+QUjMjSfbPVDerjJj59F6RY4QuvCeyW1pBruM3KlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDMA6FNYW7hP7X7AEQkrbSWqFbseEvxvsM56j/a+vYw=;
 b=dTs9afhMAkicLBjdRDCM0Uc4QaKWhrb8urY2e5EpEJiUIhastgOP8K9cEK1QCqiqtXfUssRBfHZ5OinNlOY93EIlkTgO8r+hCAsrNja/PcoVxuCE9ffnfCvX98h9LHCqu++QWQaW8rxtdram70JDIaQHZK0PpJSSSjYJWq/U5W24zoxGtTH2mZV+P5qA3yEzHi3QzMmgT3JfLluqO15OvH/F4cpr7ctx0MdMOQMXJn0amYRXZ799H9fphahk4uIqYyGF6dxQw4EmBfN/y5mM8kHbUVa8p3wIbmqTzKkaz7jbBvQAz9Y/Iguq8Ad/cN3ifG/z03rAZjsTTYsntWjMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDMA6FNYW7hP7X7AEQkrbSWqFbseEvxvsM56j/a+vYw=;
 b=RuniM7Iw8FEjqPAC74H0g+2ck6mluYqTFfbn8jml7ip29CE56XCz2IQXBb7v8twSspv3Cwk80U+0OzIaPxmEtqqYpj1yAOz1hYErfLefWucnKu3Fm7A18bZiyb/pDUWFwaDXj5HGSN6GaQ7EYia5Oe3DOsCx2+3vJSBJODkCPlwq3lBvbLDp4NWhyHZ2RKVkR1QmdgS5Dhjr3oU4/lmK+i4WnpQkzo4KRDZpFp0Bz2na8oaBujlhvcD42uVoNv9V8YhR2HvSAII5nKdvOkgz+3HWkmVTfV5fK9WF7zo6VSI+w9PtH8g90sWuu8RpseCpCFH9Qkv1aYf+LqOkY1HjMw==
Received: from DM6PR07CA0132.namprd07.prod.outlook.com (2603:10b6:5:330::25)
 by CH2PR12MB4859.namprd12.prod.outlook.com (2603:10b6:610:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 05:38:18 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::9f) by DM6PR07CA0132.outlook.office365.com
 (2603:10b6:5:330::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 5 May 2022 05:38:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 05:38:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 05:38:16 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 4 May 2022
 22:38:15 -0700
Date:   Thu, 5 May 2022 08:38:12 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, <saeedm@nvidia.com>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Message-ID: <YnNixMpl6bpLE9ZA@unreal>
References: <20220427093120.161402-1-yishaih@nvidia.com>
 <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
 <20220504141919.3bb4ee76.alex.williamson@redhat.com>
 <20220504213309.GM49344@nvidia.com>
 <20220504164817.348f5fd3.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220504164817.348f5fd3.alex.williamson@redhat.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3d67eef-4e99-4096-0e75-08da2e59753e
X-MS-TrafficTypeDiagnostic: CH2PR12MB4859:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB48598162305FECC72B23A8F1BDC29@CH2PR12MB4859.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMiXGBGpatCG2REOmJIMZeKeUjBHTMdf59I6JRZzrSAF7g0LHTZRH8Qlt9HNZg7ml3wg/jeS4ExQMHhnx82ek++9hZwuqPfLq7thXbtcLhGaDGEvKfJs6gc43MBxov2SI8KjbznXn6tHpu91g48H5to53fRlZyFQOWAXDFbYKflrSMbkU5uJNWnox3nFXafFlNsEiux7DmzNHLeG1itzrgsZ0ogSp90IhNg/D9cUBp2nO03jSej1j9HfiEMykoWbaG1zKYSAFtJvFQoUhVkrju0svxY5ACn42b67o8eJEODR1hGElcWHz/fEMYDhcV4fNyb+EuiYc7JYyzltnfyb4uH1fj0NB5Qg4ZYqm14cu8kwkyJeAvztC0Wl1/elHxihSp2lj2K5J1VhpPdkOGLqA3233mZS7xVxDN2s/+4AF6m0hELzEl5D/MAjsA+VR/zTz43Xv+W+cma0QucNYE8UcA8WoQ/19lSzy4PVF6CAoe7aKZ3AHWFzxAyIHJNiBn708g6q5MCkIpHv8WqPmZxPXj5Sd0EAjDs4whd4Pfny4st2AOwMlbAQzCJsNDKmRQgtAHgIUxV/Fv2itmpG3kAOScaLegXvf3qtrXTtBCQHkSZDSEBeQ7eiQDlLBATYEFsnMwYITv3Li4aAQpU2ajfBmuxn2oFKgude7ebrZhX5ytEn7vRMzxrKncW7m4l5KnwB8LbTMc62srYLtAQVUfSN7A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(7916004)(4636009)(36840700001)(40470700004)(46966006)(356005)(81166007)(508600001)(16526019)(54906003)(6916009)(316002)(336012)(6666004)(9686003)(26005)(186003)(47076005)(426003)(40460700003)(83380400001)(4326008)(8676002)(70586007)(82310400005)(33716001)(70206006)(8936002)(5660300002)(2906002)(36860700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:38:17.8908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d67eef-4e99-4096-0e75-08da2e59753e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4859
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 04:48:17PM -0600, Alex Williamson wrote:
> On Wed, 4 May 2022 18:33:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, May 04, 2022 at 02:19:19PM -0600, Alex Williamson wrote:
> > 
> > > > This may go apparently via your tree as a PR from mlx5-next once you'll 
> > > > be fine with.  
> > > 
> > > As Jason noted, the net/mlx5 changes seem confined to the 2nd patch,
> > > which has no other dependencies in this series.  Is there something
> > > else blocking committing that via the mlx tree and providing a branch
> > > for the remainder to go in through the vfio tree?  Thanks,  
> > 
> > Our process is to not add dead code to our non-rebasing branches until
> > we have an ack on the consumer patches.
> > 
> > So you can get a PR from Leon with everything sorted out including the
> > VFIO bits, or you can get a PR from Leon with just the shared branch,
> > after you say OK.
> 
> As long as Leon wants to wait for some acks in the former case, I'm fine
> with either, but I don't expect to be able to shoot down the premise of
> the series.  You folks are the experts how your device works and there
> are no API changes on the vfio side for me to critique here.  Thanks,

I will prepare PR on Sunday/Monday.

Thanks

> 
> Alex
> 
