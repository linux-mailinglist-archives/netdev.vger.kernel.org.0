Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3731F349995
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCYShA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:37:00 -0400
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:27105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230057AbhCYSg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 14:36:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0EIggEzzwBV0seweHKxmBoHCMbV2EsEPNQGSZJtxyFOg3dqo2ss8Sc5Yw9eacT9k41TEqOSnkI3jVCN/GD30hFhhOaw3G/4xPMunOXzDq1bzndtpAz686xdrOq+9tC++Y3/7kXoKgOgOwl2IrQhiehlxFuHxJ1q/Zv0RkIUUQkPvmJO4B/1v14Pi1fiqVH1C9sVkxHNTUnpD9uvoah8HyJifv13YfmPDfylePRauw3QnO3Mj4jwFRWSHnAk+Yz+QPZcwsMObulIjVP2YjEzDTJvp+SDmfbYf7Z/pDvcf8LULJcTDpFbrGLoi1S033LrlJ0+txl2Y4v2cfBfDOnhnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmVw02fZBvDpm1ti3anjw4aEcT3D0BhksJ87BBwu90s=;
 b=bjGvHh6AtT5bjsy2XYLL9LD0Ax2JICKlJO4/3ZD3ZS7BRtD3ivAfKqM3L8dyFf6l9mG3MMJkwhtz1EZqT5LrsG8Kpv3asJz0QSXlAHGPHHnp4dJCMU/93s1SbSzTVD4GFIr/9fFlT+QXPEIa18lTN/9oq7LoNfumcLF8U47VIEtwJvzVeIVYSiZiolG+z2eDVkEpBtBxDRwRgYcNZhLoKdLOgKKBx0pUjoBhfoi0iKUWWLh2gxRqdKkcd3rugRHu3ysCHYXYTv+9pfnkufMQS8n0GMM3bzxiiUHd/jNpva0GJvLR+OwtAe3wF5Th/PNH7tDjzZoaVYXC7U26GX+BIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmVw02fZBvDpm1ti3anjw4aEcT3D0BhksJ87BBwu90s=;
 b=Bd7jsq8z3R8Z5bn4AHdBbyX96qtTqS8DPUWQB2j9a7B0s3NXv+pKeGF6ZsfP8n7l76NYDnS3cCC4xP4+otmBltz+Wy71fPFB+gJ1IpqzXmDSZdL+KENjpp/ASCmkbq2LSOxhJJaVGcvtgJW+FK+igkUgxMCARlL4reE9IN9XhKo50G8D7ddZmVsF4JKKQNaDXrK+zTjwBunxe1veA1tSxT+CpcEEcfhYedmuRyJrLZPONJXTHVZdZreAaiV5LV6PfpPw1Xwov62/YQBJ81UjB6b/HOlE16JTXw6CrPT4VjcsXSfXU1Fbl9jR5tNEGAjL4866Wc0QtaNtFW10ZoR+Ew==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 18:36:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Thu, 25 Mar 2021
 18:36:57 +0000
Date:   Thu, 25 Mar 2021 15:36:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210325183655.GK2356281@nvidia.com>
References: <20210311214424.GQ2356281@nvidia.com>
 <20210325172144.GA696830@bjorn-Precision-5520>
 <20210325173646.GG2356281@nvidia.com>
 <20210325183157.GA32286@redsun51.ssa.fujisawa.hgst.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325183157.GA32286@redsun51.ssa.fujisawa.hgst.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:610:cd::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0120.namprd03.prod.outlook.com (2603:10b6:610:cd::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 18:36:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPUql-002xkp-3K; Thu, 25 Mar 2021 15:36:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d6b39c2-3284-4ac2-8a19-08d8efbcf87e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB426828905803128E77D70FE7C2629@DM6PR12MB4268.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVg7NL01B0bvL1QynKqcjYO2nSMHOSO8QkIs4KtDUt/eTch7EwBKLSKDJTj6FCnrmami3knfZ3Oqc0S45asMTxy+OukfHocGCm9yDBbdap97ZdTVhZ6CWRoBbFzsPVTNzpx3nZITUqRtGnIQuF3rby5oa/El8sXeYp1r/kcxo0/dhXGljLBBUesih9Lpt95KwpVHy/aPt+I84G61/fyFRYR6LfDQmXYy+EIWilG6dfNzHTSXQrlqI8gfpFkxq4QiNFhqw4+/rzv4VBGAUg1Wq0pq5pzxq0Chj4tu5Ufm0X+LVw0+KZ6hOuAfxurhS35nV0XRYfsOdZFStpO3l+/uJf0p/NcygOZvJvfUrqtfPJ4Z2GwDGRiOAhk6xEtQszS7dGT4gQPY36qlKTczaxgItfjlR/jRp/04RP/dQomH/foXd8ZP5BXxbl0JfRJzwCKm1ERuXklZwtn8xQAtpMLxWt0f/sBmKAQM66LNecZKgxRdbWulKt8uI46+wFJNUBS+cLo0Q4CFbXY9zq5ZVQgQO8OJOkcSW4gUQR9Qyk2V5Aq+2vXIQh4dVx7TAaEf6Ft5j/hNjzAvPMT3gO68qWtAsO7vWAfBa8hoKzPWAdl6AcJtwpkQFDX9QPPOyWg7gKsdSRLEaf1UpHF+J0whxFME0jszY5iI4PkIf3lx2lHlxZw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(66946007)(6916009)(5660300002)(9746002)(186003)(4326008)(4744005)(8936002)(316002)(66556008)(9786002)(36756003)(33656002)(26005)(8676002)(66476007)(7416002)(54906003)(2906002)(426003)(2616005)(1076003)(478600001)(86362001)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UravAHOqmtNUvBUhG59agAv6WpaIWjzxUzi1GOkBTy4YnDH9GFS/FwZo3c98?=
 =?us-ascii?Q?FUvlNbDbr6aKDrr34fDVZUz+3eX2TRTLbZohczQPV+gdatx7f+5b5OUsr3dd?=
 =?us-ascii?Q?kLVmwbqEpzPJ4aIft2WY/wB4ZVs7CjMPWeI4drW8/6wMVrojWv1pLMDNUNld?=
 =?us-ascii?Q?6yolWe2uX2ZQ/UqD4mWE63sMwWOzpizaYrNF7/j3SraQu9qU/qhMwkkwDtm/?=
 =?us-ascii?Q?GdyyDgBNE5N4cWTqFT+CG2wqeoxzrsnVAtAfohosi1zGi2LvVnILBs8NdPJF?=
 =?us-ascii?Q?92cGM6M8u+0km+Rmvv+Vy4GjKfumspqc2IvRBOmjAEIZHr4duf/mLHPpaud2?=
 =?us-ascii?Q?1VsjcsGIj7pvK4QJkts0NFqbs3pT5JkTFLssrfjYdlBmUnF6/RiB5wpbtRir?=
 =?us-ascii?Q?l7Z9MODEkrLzwEY+JudjiicrV5j33AKXOG0tFE+JL3z/HWhAXIMBQnSvqU6f?=
 =?us-ascii?Q?9pWs51r8vNMqdvKigHZ0s13st+x0A3ATMphVyKaLVv/XftrY42VTtQOo0USz?=
 =?us-ascii?Q?p/r37IPu3/lKnJfXpcykBeniJAtwpTDuf5S0i0zQOr6v24O+c5vAKNhB/xr2?=
 =?us-ascii?Q?PNSXcBii6qF+YP7Ze4iYTOkoRn+KOAfk/TJBjeAROemGn63QAdXKCoFmIVgx?=
 =?us-ascii?Q?TXADt8QQxynTfOlnM+WQy/GIvONXuGJXr1LlRHQ0EVA6BNqTSp3OH0Vsy++E?=
 =?us-ascii?Q?lin0stF3y5yp3W0kbN0hVTGb6fZaaCvDipT49wJ1MOKi8PhZCQRF1mP3CaYK?=
 =?us-ascii?Q?10EqWGUm+DHVkyerZSmo1Ip+WSd5kJrWNZB2/kAyLkVlxb7lDowprH+LBW9n?=
 =?us-ascii?Q?Eb4XoXpSWi+VimpIpNBMwPRXu7LUlsseHSixOKARgu+b8uTtECe5TOVXrHZ7?=
 =?us-ascii?Q?DNPYXkmXwF9bFhoIDlbjKipXL2UV16mCklhXFgsY1IMPaFpb85siD9r2EkYw?=
 =?us-ascii?Q?jhD+fYhP+Xy3Wamg6++fRoipq+lZcSSZvXkTNrWw0me6M+UGewZQBbq71tzk?=
 =?us-ascii?Q?PQG9FK+E4Dq6s8/ROQbVc2shquYvC0LXddLWN5JhknJw8I68mfdXJ3a01FC3?=
 =?us-ascii?Q?KLAgA0GrZXXgQwNgDyq/jjLfjkiKmnDz13K3pFZW0d0ANist96NBRqUI6gvP?=
 =?us-ascii?Q?mBQA3yN99GIoxCeRtznDMMyL8OL9MCu4/7tqEz5SGNGzD+FK05dxjoWXku0Z?=
 =?us-ascii?Q?gqUNS9U1alY1feqS9T2mUxet6wmOYi26UKnHeSa2dvBqyIxK4wK14a7nSBM5?=
 =?us-ascii?Q?1UnIWa/fhmMVo5rU3hkqWGm9U+zA0nApQThyj3p6fZu1xRwnXlORryiXTL+T?=
 =?us-ascii?Q?9S9f3H3QITJIfs3FCFP5T5qU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6b39c2-3284-4ac2-8a19-08d8efbcf87e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 18:36:57.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nt/Jhwblvcy2AICL82pinpibwIhbxruf4UOTG1YqejRKiT6QQQlvH2U4B/Md2pAv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 03:31:57AM +0900, Keith Busch wrote:

> The NVMe IO queue resources are assignable just like the MSIx vectors.
> But they're not always assigned 1:1. For example:

But this is all driver configuration, the driver might be running in
some VM.

It seems saner to have two kernel interfaces, one used in the
hypervisor on the PF to setup the MSI vector count

And a second interface that becomes available after the driver is
bound to configure the driver, where-ever/how-ever that driver may be
running.

I don't know how you could combine them in one step except for the
simple case of the driver running in the hypervisor?

Jason
