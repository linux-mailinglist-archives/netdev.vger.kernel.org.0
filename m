Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646A34A5C00
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbiBAMOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:14:02 -0500
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:11617
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231532AbiBAMOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 07:14:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvviMLrFn6Zc5oB9rkmQVQ+JnDMHD3GEuy+C8x4AphHZEFhU3oDF0tscRRo9KmcF3ClMSWKaeIlvNFbgaWm2zI8vcyt05PnEAkSNO+hBrxLcmG3blbh9kziM85L8bpRik52IrP4qSCp3XtrD/lRIn1Db/L+ilGjpjH16rgGZCSl+0ycwENmyQoeA9vcWESEBtSBFyNgJLVzGARJ9sHYCLx6eQ7+uAuY5QReYDmCl5vzhlkUx9XHqO2pz2OhZIkCtrgtesi+FPw/Lu6tcAxoNS/b3xfMK3KUELtWtKoWNGVE306Jp1RPEy0Rt/MOFm2ZZ21Ly/4UjsXq59NqFTJSQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfdZgXXFi9yFuTBXtEbWKHcIahA7O+A2owCoKPYJyh8=;
 b=SfpJTgPXxKGLf4uwmwKwxdUUhoLGXXJF9HmFIxLAwy4v6iZ4y5n+acohyDgahQzpAQyRM7XPn1CNd1cOLqt9qlw1Flugx8uAI7Q8gTGLBnwQqIlvGJcqStJGJaEVLIgWSAfVpEBt3fT2FLVWI1JVtcack+AwSZXTSd+iItBdEfk6jN1uLezB3EFP8yaDtxUMoepcHY8FKyQxFCR7eX6NMcyacX618ZxqrXrr/xLpRguMMAKIBqZR3DHztZlx1CuPj8Gw4TzODS+NHmo3p/IjqG5c9kOLYNceKPq/wuwTC8iSBwlRtQGAupzmOmoWclHB2jD2pfDlTwbrCcClRYWnnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfdZgXXFi9yFuTBXtEbWKHcIahA7O+A2owCoKPYJyh8=;
 b=GnOsJab1vXclag3FFcgNdLra9R5UuPS7bFjI3DHQgTAjGR5mLt2i8aHXqLp1rlFlq8yJau46cpGB2bkYko0yulCvTVFatchrJ0Yruq0tbaWKeqcQf8eEIrLgJ4dXKByOQhcSCgf7TrJTsk1urwQWy7dRz+UIVGwdU4+KOe2wPb0kFugA0wNRaZkYN2RPDc5u+r1EvuDgSaJa1/QsyEi/0GGFvqTQh/mjHa7jCpCK/Yno5NKSqMhObKTPJzRLCmCOKxDdtLntl+cOAeKbtu6hZKkYs3LQyt4m/xR6lyTk96Z0tVIe06fUQG3gJzxBCMqrQEAPTnAU+IyMGCbIDZqHFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 12:13:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 12:13:59 +0000
Date:   Tue, 1 Feb 2022 08:13:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220201121357.GC1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-10-yishaih@nvidia.com>
 <871r0mztst.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871r0mztst.fsf@redhat.com>
X-ClientProxiedBy: MN2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:208:23e::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4df33f0-fccf-4ce3-bd7e-08d9e57c53d7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4418:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4418B7031BEC25A1CFE58AC3C2269@DM6PR12MB4418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: piFciXj3YNiW9HKfeEBZxFB8mQEx0XyoaHWHkwmq4xYyqpvGvgJsGWJQGlLi/HyvB/fGdLChKtT08QqrcTiBQmCXFjQaoDWeEuA2Vbv7LB3MeYtbiG1Q4KvtozRqeZpcR/WKgUvmGBFqc7/1scGHl87dFJBalruNycl+TJxxUhoiPFji6eMg3ToSWRShLsZqDEBDWHs4IWCtjg5w3yhXJVXuapxio0QapSnqlfRoMDkfJ0+hEsQbnxVS11e2RLyWf0gZkBt6YKKtGbLb2VJl4umhYDX4JMuwe10teHgfoRsGuyKoLY/XdgwS3StoO21IES3EuG6twSphK0CbOZwjVIBgFN3L2x8U+iQxp3A5pHJJcv37xAlb4XWxlT8Yvc7bD9XihfxamZw2m0adlhPKwr1zWXnJW9BNUPg1qA1v7Q1e3svyHEDR3s01dbrt2lNLPZg0qVzzKf8q3G9+fufQEIj3+jfFCpfUydITNgLnN5C+6SrOu61h9fylPEPlSOe9gSWlh5nDpueoRiO+YT0voiJSbiE3MBU3slHA3NCN00ca1Z/MY9g6wmZp5+K1rMs0coIGcCA7mAZMKPej5F67FyKukCc09JjINXrsEi1zXTjY4c41Wg1xj56Wj/+sfV2lZFEoVBsCbQSoEoty45AFJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(6486002)(4744005)(4326008)(66556008)(66476007)(66946007)(8936002)(8676002)(508600001)(316002)(107886003)(86362001)(6512007)(5660300002)(6916009)(33656002)(6506007)(38100700002)(26005)(2616005)(1076003)(186003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fb/cR+kXZsHCXYKSDckWEogZg4Lw6ro9gDC6JhjLTZdzNlbQsJm4pd/puX6P?=
 =?us-ascii?Q?TFQQ7SHL0+2H8m/F+oNcTcXsr+1mfVwubvc6Ph5Iq71LNiiFiRCkDe0y+8Bi?=
 =?us-ascii?Q?leNyIusaD9M0b73pDIv6Up4xE0ZZEUWbEgfk5k00QeA8Kj+4TB0CJ1+v36g4?=
 =?us-ascii?Q?GsON+ZZAb/e2Pzh8d37Y3VjRzla75nOhZcR2dgGIC0OvYapeHvDtuEOKG20j?=
 =?us-ascii?Q?YpqgP5JxLdKONjqJeDSOxx/ogbMHrWo9e5msntywDiQIukoinLCU7UNnv422?=
 =?us-ascii?Q?qUPkdvSuY0PG3FzohKkt22VvxsSmDcaqG4oJw2MRe3zbamWbcbsRaoc/N07v?=
 =?us-ascii?Q?KKsJRGDbm0JhpBbzIpQaACUMZ57cxglCjRHZV4gcDs7pRAVyZ6NQDZWwdPsA?=
 =?us-ascii?Q?0ZPblx/HMrtBlJg/itKLkvFXv6IrqOnfWR6oXXPHuYghfdq3hXYg3RKpEOVz?=
 =?us-ascii?Q?ZFIK1v12GtN3IhmJFuU2Swi2DFAwvAedEJn5dTLSBrKbyXBcxAl1h6dWyJsj?=
 =?us-ascii?Q?9DIe0bYMbxLU/qxcsA0ec3jzJywz2FDE3+MP40Hk/TAbUGjrEq+qtpCG48ux?=
 =?us-ascii?Q?TiYPC/8ApheUNwHgUxoSQiN+6sSwyqMp+FThmuVrM1/S+TxbVUw1hhkHpJhs?=
 =?us-ascii?Q?S8eolwGiWMJZSS6rDkqDGdWdLh4pZHb3rkz4oM4vEsR5VmbCIwkxV//uqewR?=
 =?us-ascii?Q?XRU6ZphvMYET6JBLDyng2tlaDpyRV9wvKKvX4R5lk0P69SpEJTwV8lII03Kf?=
 =?us-ascii?Q?g1qLe7oK5g4bOBIfU35HVscyM00ewL+EknTSTDMa5qswniY+mA3P6Tlv8pak?=
 =?us-ascii?Q?IteitgcD6eA7pIF9zZFQ7dFY7kvVGhXc8KwtrP6NioVoARZTC9TDtNA4pFNV?=
 =?us-ascii?Q?ia06GCzEyOopfydpbMNDIBzY2/DC/jCzupThU0DT/PxWpKAZKAP7tgzQjWlI?=
 =?us-ascii?Q?oeVGwyzxc2KURUMGigVCB4OhZjQ5oyOTaYIwIN4UHD2SQYLjj1/D5TjA9qsX?=
 =?us-ascii?Q?WVn/d2mj8sAHY8xCU6JwmzVIHCXVXRMLvgIv6mg9Y18ZpaBkBFE7TLZCNmut?=
 =?us-ascii?Q?eOuemtX/yGjYmh3E7uFScDOyI0kBmuQJiKMLt7x8U1yI2wlXC6PEIy1Taom0?=
 =?us-ascii?Q?T4mM/aUenY0mjkVckN1x+UCeUpYbMxkjaeon6aPdwtbmV4wmLsA3/qmPu4q+?=
 =?us-ascii?Q?WuxKAGx5gINBRlfSyrQ/lO9cjlQBFUm7aLbUy5myyP1b4oLb4w76SVFTRvgv?=
 =?us-ascii?Q?YM4kpkQ3B6eCez1VQVv6wl2gQAlGXn0BmF4/pj3dmPSgrcBJlZw2Tm/1x6SW?=
 =?us-ascii?Q?DJyQCj9kCh2JM/5ZZeiPzO3EYGS+knBUBABBi4oNXIQwYsh6Rx3O8bPrVNE4?=
 =?us-ascii?Q?cGvGUMZ8O1lLyrf7ws5yhzYRycDzR9FP522GLUDpxv/ih7Tql6ZpbWThqIzW?=
 =?us-ascii?Q?z8AQbY/egNNq8vfGalI20q/RNrRUZ/4GKYPqRN6l6Wl5H+KEwZbGRA5MwE6G?=
 =?us-ascii?Q?NcYNAZl5/tI5OF3Z6mSh+gNyDVPWUBNIRvnX5fRb95mLDtZzngsnQhIdz8N9?=
 =?us-ascii?Q?/dQj1T6e16Ka8vSZ1xo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4df33f0-fccf-4ce3-bd7e-08d9e57c53d7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 12:13:59.6238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaDHRJGm6Htxc+sWQ7wZHsyCzk6Dx9DK5GMgSVdrI2roOJp0r8HuC8+/k3C2E7+q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 12:54:10PM +0100, Cornelia Huck wrote:
> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > @@ -44,6 +45,7 @@ struct vfio_device {
> >  /**
> >   * struct vfio_device_ops - VFIO bus driver device callbacks
> >   *
> > + * @flags: Global flags from enum vfio_device_ops_flags
> 
> You add this here, only to remove it in patch 15 again. Leftover from
> some refactoring?

Yes, thanks, it is a rebasing error :\

Jason
