Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAF04A5DB5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 14:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbiBANwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 08:52:35 -0500
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:42346
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230073AbiBANwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 08:52:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7xTOyBgEWWqP6tAYKRrs1Uk5El7zL8B+WH+aGzhME4dUkwE/pIeyuH0oVPvgky6c4hBKSzv7pxdl4kEV+Lij1LKfGCGsW3vMFIz8lD9rNwOpE1m16TNVYop0xiQn/TJP/M1om8qFSDQ9eLwmCOXmu7oJURMMQkmQEvcz+9Ucb9sOW1Q6YoTzvXxnH1lqd37leZ1GYEze3HN2WR2vsolk1PbNVrZOxdRk1QM9NZegNds9lUwRP8B8v8nKU74ZiHjNRtRWt5r2Z8DZgXUNeEldpkPDqIgngt8dIapBoNB9tAO0aYlGFvlcCWSLaatnqRXBm4HqO0KqZht4diLE1f6Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uwUmdNPzFOR6HUIUrRfFN7oDasYymCdrJqOyWkbgjk=;
 b=njfyJLMIrdnjiEvbPknev+NXIybZ7nzVeSESm9o7QGaO/h3VQbMF2z45IncmD+9ZSeiClAl09VauQRAKNt2RXzTHo8Ih/itQ8kr8n85YrqZutd/5pb7CIz3vAipbY21ecn+jWdW6NFsyfToa0ajddDhlxxzRtpuSIYDSgzAwDtJfmMKQ3m4vNZd2zGovVXRAZR0F7mZJXawpAdbVzyZt7O8x0Ots/rdPyl5+A+wPHk9PtvHj5zUyzs6rIDlRmbHK9lz61WNJxS6q/gGcJWzs5Kihn+FTq6kfzwK29ql1LRTF17t/R/JgybETdbr2PujmFVDmCg/ic/Evl1RSk2X9Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uwUmdNPzFOR6HUIUrRfFN7oDasYymCdrJqOyWkbgjk=;
 b=uGbHrQeZjNAi+1PrdpKW2Occ5X1A9nKU2A5CQzCS+F8pjYxfmv+FQq1ajqKvGzqKGL17ph5a+IdAnXV9iNrHqGm81+wXG+oggMY8XptCDYSws4m4Mcb0hDRgMCBM3vPhOeXhkV7ZX/KcPhk5+kEO1ufHWq4DbPmCRihQ0fagzQcC8aE5AcUWz8M9dTn4QcYDPVXFNwaHBAKHs0G2m2fA+oPvPa1UieRJ5Bu3MqEXrXsBv5Ill7CUyQAtTK53JoVgQSGl8nM+Ae2QVNtPpd7XwDqz5TkwgcVtZCYftCrtjDLZ1I+sw7jCFGtsGutFZcQBiATvJhLtXDqH5gvC+E0q6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1740.namprd12.prod.outlook.com (2603:10b6:3:10f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 13:52:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 13:52:33 +0000
Date:   Tue, 1 Feb 2022 09:52:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220201135231.GF1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com>
 <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com>
 <87sft2yd50.fsf@redhat.com>
 <20220201125444.GE1786498@nvidia.com>
 <87mtjayayi.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtjayayi.fsf@redhat.com>
X-ClientProxiedBy: BLAPR03CA0100.namprd03.prod.outlook.com
 (2603:10b6:208:32a::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac5b44db-db98-4f4f-1136-08d9e58a1872
X-MS-TrafficTypeDiagnostic: DM5PR12MB1740:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1740EB3B86B9EF2E0A440DA4C2269@DM5PR12MB1740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2lNUIJHa4KYMpwk6Q1dIboA2R90kysPXmnR7EzACY2jDMVmBcHjC2YHEX4GPQFu5BabDY6cNuui9MtDy8iFNF+eNqqGZEjaTjsnd3sKFsrcOgXGM8aT86fCuXXtWPmQUrDDs9FDgwYMYqzUPfuuOLLPMZhQ6NQ+i1AHF/LciT1bLqA+Io1SqrtODi68woYRoeW1HtwN6dOu+tqpMmXM/MMsajpV9kYjm+2yhUnzZS0PSijlAQTzMvoeTnJxRIDSXrPv6/e07aTuD5ZXN2w7YZAA3ckU6Qbo7QYgfF0U/Vu07ArZ/SO4p9lo5E23WGJEk8DH2i5BtA8vLj3sgc/VYJmQK7jxuOXmQiAaPz5oHZee/kPLp6Bs0rzgc751PiUxRncBg+z+8VtK1cFt+/11cAMnQBwozd0OCDqVAjBB4s121lKObHycXldJs4PwAytyxuYrykFmZDtSSCYCnasX4SK27vUT1/p4Rl5AZTv9xLyao1wvFUYT8w14EQFla8Al5UwAfn7AktZdNDqz0gjmvNBzxWAaOfQDvXE4Uj6bQuT+GUsY82SzRCCHnwBLv29JpKBqUE2y0pyJMe6U/cdIJZqm3LOCfcfaOKOY8zsT+i/cTy6oQhBfmWGuxyA3Rmn0ymulJf4ZOUpENzTFy+6M4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66476007)(66556008)(6486002)(316002)(86362001)(508600001)(4326008)(36756003)(66946007)(8936002)(8676002)(6916009)(6506007)(5660300002)(1076003)(186003)(26005)(6512007)(107886003)(4744005)(2616005)(2906002)(83380400001)(33656002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0rQejb23VY8rUAw2uUc5jgdFpkt0i3rFOzsCF1MERnceY7lALK8HGESoYRov?=
 =?us-ascii?Q?5VZlp3/LX1I9LL2EbKCVm+RM1Nl5jpPk+6gUoRnxpKycGNzfcw5FDRgXgoTS?=
 =?us-ascii?Q?hjZ9uI4Hc7gHHjqxR6Es4giNis+7pr6meC2FzYhMSqw5Dkx8m6lzKa06dCyA?=
 =?us-ascii?Q?+geAz6UZQ2LXQqZpqdT8sGqiTGbFRNTLkYWwzKTvd8N4KflRI5JzQQrgLSOh?=
 =?us-ascii?Q?IAEYWR5vjlcmqekUiLvIBh++hHUvBAEd1Jk+I7VH0Vne/oNL0cC6sH3cUydi?=
 =?us-ascii?Q?2iSGO00hDSTdMLZvhQOfjZMLBnicBcoFX46ZB876VF7vhepmbayNDEdX3xZX?=
 =?us-ascii?Q?uglER2l0yiLVsVGUGlVzjdBEd9NXRbabfSQC3CKtfOgMKvkcvMp2vCexK70d?=
 =?us-ascii?Q?ju5EWvXDjGAoVgk5jpWoWO8Zm2jQCZdpNB89PuA1pwTfuwLC7SPeFE2SQCLK?=
 =?us-ascii?Q?yIShae1ErPYMdg62qVZZVtUXBc0lY02Opr7PWLI13TqI9neMqAxQfrY97sn/?=
 =?us-ascii?Q?q/WXnyBVHkwnSEfpwN+ddwswdgNjSL+lt+gLEbkHG3LY+KH7RnrcgEnt7wM5?=
 =?us-ascii?Q?8wt1I56tmeNqNNf+nLwiHYBYBII1qLEkUcIm6Bd2n0pZFqvzpo5fjg+lDxAO?=
 =?us-ascii?Q?mwnN1PHdAw1v4m0CCn9LuiuTTUxC64SuN7ISX7NIdhy+sCl/ijqz6GHnGzU7?=
 =?us-ascii?Q?4uvzM7V/zK59Y3naa3k8QZlMuAbRno8k07D5x7L6MtIXj6U4xrGGpVamddor?=
 =?us-ascii?Q?hplM+7YsHhhkMTGjIzhiTdjVaK0I9ivkKD82uZYTu9d0Br7vv+joCW022OQb?=
 =?us-ascii?Q?fExXJFgIGQ8X3aUsv1pnie3shgRSDWGlf5CUO8GW3NCBvaAv+AwOFb1b1/QL?=
 =?us-ascii?Q?Hb1ozTG4qjqR1kHkidCTpA3nuMCBJOM6GvbPkznYCMbGIAMA5NI//w3c6tP5?=
 =?us-ascii?Q?PeIKy4nuggXnKSdzYPV6jOjxO7LyaIPUPAyxfntxmkhS0M5oWe0N0gy/fpZQ?=
 =?us-ascii?Q?XJJ+1AotVAX11Oyw0Oc02kbSSBE3Q4fKNsaH3wZHwO5ZhjuunkmSKQShRR+r?=
 =?us-ascii?Q?y1FzWerEgASnGOsSKzj8omJsE7+/X97zcTP6ykvCW82tw+odwt2LWtMGK22D?=
 =?us-ascii?Q?9QAhKB35fj4wx8eJWyFOwRCQgt/E5z3UGmNAjfqCwJltd/DTUYYKGZOANYrf?=
 =?us-ascii?Q?1aNJvvVnpLIgwpHyTShxe6QzImejeogszZ6VIdjkVV4vRGMDSgphXpV8V1gQ?=
 =?us-ascii?Q?cVhMqmZi/lSWJiTyXzg9RDBT7BNehbHD8bQWdf7K2O+t/+FCpRzcxNlxbs4A?=
 =?us-ascii?Q?W8nxRInn3i6V4+r2K0Q9eLYjKKStJeU8klZP4oVErUIlYUHATNh+URQjrTlM?=
 =?us-ascii?Q?30S3IUdLOtH+itMBOhPk5x8pbfPaUn7pRngtTQU8lqnPE2PEJGn+S9hwS+ZA?=
 =?us-ascii?Q?Kyhe8XgOMekkfODPVUsyb/a8uXewNUFLWUEwbIWcJWTKhdEbFISF/A21AQ7b?=
 =?us-ascii?Q?2cHmxwm3EQ4qYQIn3l8Z26Jbky34aAVqwb9n5rICA7OVy/aWkfgdtObQLAuh?=
 =?us-ascii?Q?+TekNDLVzIDZv3bj4r8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5b44db-db98-4f4f-1136-08d9e58a1872
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 13:52:32.9574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUO0nZzLR30PN41wLm73MA48c742aTrPwB8SUIxglS0Q/AK/D+GL5cZQ4/Hd1GXi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1740
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 02:26:29PM +0100, Cornelia Huck wrote:

> > We can certainly defer the kernels removal patch for a release if it
> > makes qemu's life easier?
> 
> No, I'm only talking about the QEMU implementation (i.e. the code that
> uses the v1 definitions and exposes x-enable-migration). Any change in
> the headers needs to be done via a sync with upstream Linux.

If we leave the v1 and v2 defs in the kernel header then qemu can sync
and do the trivial rename and keep going as-is.

Then we can come with the patches to qemu update to v2, however that
looks.

We'll clean the kernel header in the next cylce.

OK?

Jason
