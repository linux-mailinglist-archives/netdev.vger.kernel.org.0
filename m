Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB2243CF10
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242992AbhJ0Q4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:56:06 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:42593
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239523AbhJ0Q4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:56:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btC+KOpN+2bJq0jYo5U94VgNowVELQH6E4IKNKSmTbzPYNhXybixa2CClcAQF7dMzMULHpmqBqHAoY/05ilXo+WluJQTOIZ5m5NQr67mtjbUUeQ8/l916Vu1eJzoM/gP+Utk4I82R2+X/OZeYvqD/Yq3Wp6K8EjwkuHoOxqny3rLR8bCoQFrpnV0R/Tnpn1wxnnyh/ypW0ghBg3+IUZI0/aVIq62Y1gItKOVGtkH8QBoQ0kkBz6INQcBdKZeY6oYBWp1+k+GjBZ8b3Yt6tBpZIyQ6gTw4DAZmisv+RDIr4UFsoi/Mb+PBFv6C2MbJVXdLEaVdVP0WvKELV+yFZfB0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K69kOi99wKYWhIFkS0zS1IFdt96fwTEjWcBZdRQ1lUs=;
 b=YYaKdLjfVn1n2o+R9sZx0wi0OWNR+vfG81oAkhqkFQ7lWlPIIR9HyEMCwyi/HKeIXF0UyYb2Xi+6p49K65bmtYvI616rtCccF4efNuvuE3OSWfhW798jK1ArjQWWuuWqpQRigMX9ECOM854Lx2eAQht7BJSEK1CfZNRO6cHm1JChiOfaiO/Th7JfT3krvAHDVUgN9xBpvaiLaQQiVlJ6lVf4ZH8bVVOC/wF8M9xFCycfwYJNIt12Q5AoVd+TV9xcIq6EzLPNHXV0sun6DO+XhraMCP1EXkQMKSauqtPVYA67XR+krE/wHvR834cV3dyfHXSEyo3VwzDw4zDLyHCv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K69kOi99wKYWhIFkS0zS1IFdt96fwTEjWcBZdRQ1lUs=;
 b=Xbg1Q6r+bP2syExPgZa/73GXehw7ZNTMeLI+prTA46MWrsE5UHYK7NqcAgxOjRhkX4diJu9fGrds7uwQBHxpvxOxH+2gtYGZhB2z204O6b8jq9i8tGM5yPJJLBJKOsDj3/qUxKiXN2SGXOa/YgQLb4D3neXy2mb5EOMNRejXvRITwFO6xYYduVPCWUcuv0t6FKgMgnrFkwExHTKloIa+tRmSMu8F7+5cInkJNlLNNZljjXzNbmJcadniVog+BUU4lN89lzC6BEN7nGhwz3Ji/O9YC2ozaXnN2B+zGtV0N6nrRO9oXBTO9oApzfwtWOM+bnhsMzfUoy2X09HlDfzN8Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Wed, 27 Oct
 2021 16:53:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Wed, 27 Oct 2021
 16:53:36 +0000
Date:   Wed, 27 Oct 2021 13:53:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 13/13] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20211027165335.GF2744544@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-14-yishaih@nvidia.com>
 <20211026171644.41019161.alex.williamson@redhat.com>
 <20211026235002.GC2744544@nvidia.com>
 <20211027092943.4f95f220.alex.williamson@redhat.com>
 <20211027155339.GE2744544@nvidia.com>
 <20211027104855.7d35be05.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027104855.7d35be05.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:610:e7::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0225.namprd03.prod.outlook.com (2603:10b6:610:e7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Wed, 27 Oct 2021 16:53:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfmBD-002gXk-Ev; Wed, 27 Oct 2021 13:53:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1a751c0-723e-40d2-52bf-08d9996a51ad
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5238E3A98828807311CFD6A7C2859@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8H216t1vQaSofq7csPbdGPoMJWb8eStWR1knNxDpHDCeEytIbcz28GxpbSYoX9yd6wyQIGQBTbykU2ArXopi+vagjgbdF0on+1/vL9uTvlBwjmZEAVGtaB5q5tdftyTMhklb6sJDiaGG04B7TA2Vi9lIo3Rss9WPFcUX9o7MlspFzGEGax/JegQMkZer6PWAUmV4lxgHFdgItW7pekbJX3brXCyuGnCjt4qAWnXWGJ1f2Ux9Qj2YuXTgbEN+URyuWk4BNbBpvd/pT7Cmyfwx8dg3YiQfzm9gN9R7ngz9Go4BpU9JKyHWc8PjcVou9yjO+i8Tv/dFSV2DAyeZqTupTSmg48zjkoLv55PK5GfFCOkbeMXfDt2buAf9sFDPcb4RfQtaI3REtZY65u3dk6T+ciKuzbl1Utmbf9X4evEauilKbxFSxb1s/Pri501gEuxlKy+acX3Gy6HlaSKTAcHmZ+5OJpE+CB1p+xv5dcASEpjrazB7wz9+Iwv93JC8b5dF2C2+GiYKbGz86EUX+pelyXOYrdXS+CY1rOOPKR43PB5KYDJa0nFSK9loOH12ONg7tBwIZjB7rYNBBITTzsWlCLGAQt196WyxMkwRAQH6K+fNihMNPtDdbYPUgU0km9aNBvJVbo7F1h8MGsHNJ8XEKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(33656002)(36756003)(8936002)(4326008)(26005)(186003)(107886003)(316002)(5660300002)(2906002)(2616005)(9786002)(426003)(66476007)(8676002)(66946007)(83380400001)(66556008)(4744005)(38100700002)(9746002)(86362001)(508600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LtGHsG042q68rwYf5ZdOI2ucAWbTLQccpPMJlQk9UrTW+SWieSUCu5e7cVRv?=
 =?us-ascii?Q?hWJZXWlS98tk0vzMieg7S9uUnkmxCRnC/kHa6GSsfqaHHrc68nZfeD3e7HhU?=
 =?us-ascii?Q?Ekco+rEFFYpCHrpzqdwo2S1vc/cjzEnTw79Zn9hZuGiDS9cU8x30LRZl2dg+?=
 =?us-ascii?Q?KKjEAOk9IFl8+pBRLLFG74MnM822hMgLMfZEFMTaJen9GYbyEX44wyw1obqs?=
 =?us-ascii?Q?QqdefYBAStcUv5gJaFubTkhJhKiVj+bAHFa97RwNiBKVVjwJwmVbNzFhoI7M?=
 =?us-ascii?Q?J4hJvJ6lWvL2zVbrMWiin+a2HkVQ863I/jgxVUva/RMYo2GstCvMs5t0K8c7?=
 =?us-ascii?Q?yMUA76qqKuAgLZBrJLqN5WmUO3b9cA5IMaQ9VTWfuqYoDPhXFk4CJH8YdH8Y?=
 =?us-ascii?Q?348qPJ58YtuClZWOzGJ0qGqP68MtPBYXqm9fEPAhlGvZpmUSpR2CYOmQbsNX?=
 =?us-ascii?Q?zaP16pTwfnMmgtcuzqXamJ45fCR+lir3SKwcq6ewy8iWmTquAJfZoQkGE6kV?=
 =?us-ascii?Q?impy6m08pWrWqSexuY0IyxXhkwH4oEjbg0xC4NyJalgqlNY5J/+6hVFUEhte?=
 =?us-ascii?Q?hYnzaJFm73AD4a0xbEVDN289LPEyTLYoB2/7lWEhRrQhTy1ItXI6ObcZD3Di?=
 =?us-ascii?Q?D4dmLZqCr0L2opBkM1xXZbVdofe5nSm9GNRriUxfzKE6TUmObCMQeXyPsk9M?=
 =?us-ascii?Q?HHV726a4/pzaoa3NhGZ/dS06GyWX1Lg5iTDF6ipz0BICT92nBPEQr2bOvJuC?=
 =?us-ascii?Q?Vb4PH4sHDm2I4LgqLpfUrA95+wcsitV4tdrSalHcPTp+IfEDE0vNB91lToWE?=
 =?us-ascii?Q?uPCgFGBSyC8rI3ob0KJbjrlnSdglcsOXDIOiyHLCpY7I9AoqKGR1wo6xa4b1?=
 =?us-ascii?Q?CCpugiQ97y8Sq1TofNntHhZESnO8SM1TkdqSF4sLUm3+ZEfLqijT1o7T64C7?=
 =?us-ascii?Q?glbazAiuV0/PWSXd8C2sT5oCtmxtp4nL6kA4QAxgb6mYox76ieNEAhKYZdlD?=
 =?us-ascii?Q?asJEO3e1xI9eCrktLIBKs9RleY2dwO+9ElYD/x4eBAvmaC8eMzQ/bz3yBTxp?=
 =?us-ascii?Q?P7bSaHMTDeDJbuJeUg9Zaxy5/KreMwd8FdZ9cQVI1S6MnghylUI7q6Luva4c?=
 =?us-ascii?Q?8AHY6L2/9Cew3WzVmzg6KqDs9WYiMB6cjiOhAoWyHRTPWiixrDoY4kyLHdiE?=
 =?us-ascii?Q?UQwqSN6xJ8nZCYsngrAdV3+XtDz8eIVXoXOeoaZy4T/LaTtT21T1YwCr8T3l?=
 =?us-ascii?Q?Ip2Lj1wTtlfZH3Q0tEUssT3m4yXACtIoWXmnDv/CFNDHOy1W6I/86RbuYdSp?=
 =?us-ascii?Q?/o1uHIJzQ28xd1Ljj+sxxdTF/vxwhwAMerPz6VHSoRJNM6Ygf0jGued7OsNm?=
 =?us-ascii?Q?pWOaOEi++r7ijszsDgBrU3FoXqk3ZNX3t0iZ/aDq3OfQa0odHztSG3KDpDEh?=
 =?us-ascii?Q?4ApT4q+2y8GET9xU3zAkiCWxecKcJiWuw/ONhP6HkmXPszWau+JYzDE5yucV?=
 =?us-ascii?Q?E4HNmgxlXi87CR5wGK0mBmzOOTjzYl73vXGSZSGkeKYcMdOBbJZxO0FIJrP8?=
 =?us-ascii?Q?ve5T6/4fMV5Nu5WOLEs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a751c0-723e-40d2-52bf-08d9996a51ad
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:53:36.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yw93iq+LimNOFqiylhzOhxWhFzK7hqX7V3aUBWBpiVsL/Wu+YuKuKvnlVBdIIj75
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:48:55AM -0600, Alex Williamson wrote:

> Ok, I see.  I didn't digest that contention on state_mutex can only
> occur from a concurrent migration region access and the stale state is
> resolved at the end of that concurrent access, not some subsequent
> access.

Ah, I see, yes, that is tricky - the spinlock around the mutex
provides the guarentee: deferral cannot be set at mutex_lock() time.

Jason
