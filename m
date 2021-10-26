Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B262043B778
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbhJZQoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:44:37 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:47712
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234249AbhJZQog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:44:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJpH6QjY035NXKyrHgaxKxkMqb+GaswTGZd0qVYigpEfm45dPQERf7V9vUoFUgFARBIBNWWmtbhS2Z/zNByzg/uXdFqkUIuO7isvCmGAG+O7HdY2qxX84lbU+5H8Sbm3M1pJpxXSWHzy+UFz0uC3w4SBeSbznRq+e+C5bSQDweDJHG/XdeYnAM3uOdYq12AjMrWspKOVPKyVgSI5CP5JiDp2VHWSwE8F7sunedKiHU3bl9VYlaENXYI37U/hUCbdrbQotJVzfvLJXW84nPKky0mA0FL3LeFjwHk4HOSK6yvVwnQ97Kyw45vux659c9cq9o6kBUNaUKHFml9qI9G43A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fax4GHmX9B4xZhul+aCaBW2h7k1nMv/2HXLo2bdXqv0=;
 b=XD9HDvECVEPjn8xwBePdn5xZ2qy9K05rWvs6UKxL98cbEch1Qz/x+EOInJ1aMYMf8CyjW5dE3gT0rFqzAQ54EcCYBqiFgz/EI3mi1yfd569lx2FuCp8a4XtM7OqnFV4rmVxLUv3CgSXRpKY+WP19ehsclUqcBwXtsQv51bTeFLyQnowvwgXUzM5V6LPlG/evsUWG/wlX+6drSmcm5yxQzbKfGV/bENdcw/ps35hdScgOWkyi3gzfymlcGrWJxReoRgBmHKA0c1/A6XV8A5bbuNntd4t7ddOIKZ0IFu1uwJJdBEY+cptWv6H+29xFnE5GEpNquBsaq8i+jKT27jGB3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fax4GHmX9B4xZhul+aCaBW2h7k1nMv/2HXLo2bdXqv0=;
 b=r46Udb27loGqpT7Q7R07FQCH/T5N4dCO3WXnTsmXvKYo9/6yoNXNddX27RfD6nQqSHq+LqgkRDY0yeWom6xcVWH9YO9WuhPg6gadoyf+79hc12NsnjX0rQhE9yBkJhJIRCahF7ZMDpK/uXFkQE60SGSQjdfZIuXcgL7TpWoHRZ3H3MqCRag1DBPU4/FFrj5C0jWKWvtaFtfhw5DIFav7gCh2cIru8w82yV+XCsadgZpR6FuDuMDujZxjzry0AKWdELXrz0kF5zAGgVhumSrzGJmOoJ83ZnLh5d0VnhV2kIKEm1ILMies2MtdQSs1h2kBYAC4h6jwzGNRtYybImKrcw==
Received: from BN0PR07CA0025.namprd07.prod.outlook.com (2603:10b6:408:141::28)
 by MWHPR1201MB2543.namprd12.prod.outlook.com (2603:10b6:300:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:42:11 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::24) by BN0PR07CA0025.outlook.office365.com
 (2603:10b6:408:141::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 16:42:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:42:10 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 16:42:06 +0000
Date:   Tue, 26 Oct 2021 19:42:03 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 mlx5-next 06/13] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR
 macro
Message-ID: <YXgv29Og1Ds2mMSS@unreal>
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-7-yishaih@nvidia.com>
 <87pmrrdcos.fsf@redhat.com>
 <YXgqO0/jUFvDWVHv@unreal>
 <87h7d3d9x3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87h7d3d9x3.fsf@redhat.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17ceeb8c-7cc6-44d7-7757-08d9989f8e85
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2543:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2543C4C11442A5598C1F668BBD849@MWHPR1201MB2543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5co8utob1c+bAkj39lQJlVYSmP5cjY7xRYFPRToNk25mhcKm2gSor0+NeAY5mZprRPXBYoQeUkeS4PxPl+6qenZyAvFv4J2j61OvaBfHTFeKdFpKEobk1UWjrKvoK+gwFhUPBdbLDvXip4Oqg5SK/pu0FidE6TbwsWtBQTMMnttNhHWIwwiscmonyn24s68N21oCnuVzrpSLSwW7Q9zEDExQrQJTpkUxmqRdudwvWjrY4/88a9+ic5crm3ai5BUv43szSaPxZ91xKmWMnMeAkaw9cLQVy9A4gqMomurYQoUykbbVd48vqTJ1z83rOEJdxQ3MDppRLTM95YiFn1aTRsQFriXhhyrc8zNrveLAwoRO9pDIIWrzZtu+8He7BpbU1wMXlNFNcm49Jg3RxTt5yxzzKA5t59ubyE0RvzwghTijmwmKJz7jzl5hSCCySDxR6UkbAa7K0WdG9lYXjbZLv4l8/C0BQ36/FOdN9n+qmozhFw8TQA744DHjh8CvRMRq6ejcAGXFx5KJ2tKgatoc3dLNiwXCp3IshzHihJ+kV4YwtOP7PsPwQdMdhD0TfoeA6We1oUJg6kBuJ0G0dc0urXTCOx8ovZlrgHDyeKBpUg6aQRVMBMkeH6Thtrta2pjlCN8wnKdY4IHZ1Ze4RgnXHBEIKy1w9dXZR3M39ez8TU0nBwg7guH8J9LLJfARJ2H3PafUcLIRApaHmkn+eTC4Lg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(36840700001)(46966006)(8936002)(2906002)(33716001)(4326008)(336012)(8676002)(82310400003)(70206006)(6666004)(508600001)(5660300002)(16526019)(186003)(54906003)(426003)(9686003)(7636003)(83380400001)(316002)(47076005)(36906005)(107886003)(6916009)(356005)(70586007)(86362001)(36860700001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:42:10.3012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ceeb8c-7cc6-44d7-7757-08d9989f8e85
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 06:32:08PM +0200, Cornelia Huck wrote:
> On Tue, Oct 26 2021, Leon Romanovsky <leonro@nvidia.com> wrote:
> 
> > On Tue, Oct 26, 2021 at 05:32:19PM +0200, Cornelia Huck wrote:
> >> On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:
> >> 
> >> > Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
> >> > instead of STATE).
> >> >
> >> > Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
> >> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >> 
> >> This s-o-b chain looks weird; your s-o-b always needs to be last.
> >
> > It is not such clear as it sounds.
> >
> > Yishai is author of this patch and at some point of time, this patch passed
> > through my tree and it will pass again, when we will merge it. This is why
> > my SOB is last and not Yishai's.
> 
> Strictly speaking, the chain should be Yishai->you->Yishai and you'd add
> your s-o-b again when you pick it. Yeah, that looks like overkill; the
> current state just looks weird to me, but I'll shut up now.

We will get checkpatch warning about duplicated signature.

WARNING: Duplicate signature
#11:
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
total: 0 errors, 1 warnings, 86 lines checked

Thanks

> 
