Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB89388F66
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 15:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345137AbhESNpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 09:45:12 -0400
Received: from mail-sn1anam02on2055.outbound.protection.outlook.com ([40.107.96.55]:52590
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229531AbhESNpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 09:45:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkTdkyHn1yhXkmrdD1R3r0FbkYUoHKtZBqzEzzkfKz14mE+3G2dv45Vt2Kp26Z7/MATHKbqxtkr1HzjI4ncuM2mKwuGbx5fdd0b0vkbPttLelzsWzjVDF1f5YYNBmttTPWIMhVsIEQHFBGDSs8OEbqcjdPAj4nMpN5pbENCYdxQP+xmXO7ApOUc3DixkbE5wylAPOOGvJY506lLWNYegtREGrVqrTny2WI39Y0upf0wvWZEYw5Y42Yv22wvsLNB3lFR5lKOeDWyrWgNm4bvixfdacYb+KzIdQXKOOICufhNQsPfMA+GpPzZ7+dxbv/Wsm2SsaWjMWOCNBBjh12sy8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0grSqURDkuABa8GkfIIvoFxeePN6reretgubE38N0o=;
 b=Nv3EIvJPByso6F/Jacd0aH8thSV/F24zX3P6LcfYME2TYEFTbLYwxUTNSV/zDhxSBCoU0wglnxA3fa7HYo2YFlL3Y5TR/RXVu9r5ZVqPXbcmZHCDQKVLoji2Neb4oxQsgUNqrM9KpZ2BSbBf6habkBI8Tw9TqUoCA5+8bwpNLLUAqD7IgRxvF+NPfl3Q8lsCihC74BSh4WmQC4HNGWOHA8L2nd3+04gOJcQapgD9C1xEUvcy8TyMNRb9nTqfGzDA2H55UvXikre9StUmywfP+q6hxVfe9knHSPlmBEanJ5VqJkBGYqfIIMu4i9kbR3qqIa5D1V00hulXTIo/9ldmFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0grSqURDkuABa8GkfIIvoFxeePN6reretgubE38N0o=;
 b=tyyzw7viY4W37TUgvFSfg47XLGtEYxdRjJrTuL5MOArMoyD3g5u31tvpWLFp1FMG7jiAAEW/qPvqahGDX4JExaew+1jMjp/eqpePDvjr6Kjp0jiEH8vbwvRvfDqE4ho1jTlkod13dnx0Hi8adYyXSrwoVsrGx0fSZ0+1gRIMWsoUNLajDHMxCUb7gLwj/qpiHIYCuqDplf1EMbzJjj77g1Z3wpGUvM8TpyC7iHINO9bMZV5hpUWqesJXGP/NdZEHSbIYHyZhAUuJqvuB33NjbEDs2gOiyyCpK5a80zADtXhdcUEjh4igaB34MbaKFQH/vhysPMb4jb6HWlT2DI1kDw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3836.namprd12.prod.outlook.com (2603:10b6:5:1c3::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 13:43:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 13:43:51 +0000
Date:   Wed, 19 May 2021 10:43:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH v5 06/22] i40e: Register auxiliary devices to provide RDMA
Message-ID: <20210519134349.GK1002214@nvidia.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
 <20210514141214.2120-7-shiraz.saleem@intel.com>
 <YKUJ4rnZf4u4qUYc@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKUJ4rnZf4u4qUYc@unreal>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR11CA0021.namprd11.prod.outlook.com
 (2603:10b6:208:23b::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR11CA0021.namprd11.prod.outlook.com (2603:10b6:208:23b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 13:43:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ljMUH-00AiPp-LP; Wed, 19 May 2021 10:43:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 387ddcd4-12b4-419d-43fd-08d91acc22b9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3836:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3836A4E2A331BA7CFEC03EF9C22B9@DM6PR12MB3836.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwSUOUGDX2SMrN+jT9Pf1KMDUmrW/cb2tbjvsHpzA+363TS6cu0YAuzQaMVFS1BVyfPx9ObQ/ccZZhLH1Qs+WQyd4prn1pisJIyWetX05sCRsiPSj8wjvIVfvvNe+1S/e+4uccvdQnN6CITL6THFARqNl+MCnJCVKqmauD8KGQ71tt87niaNMGWoRkVQlRODiibPYqFxuPKUYmyupz5xh6WhF+XQcbq61fsh9ls1Skk7rAgX8ShygDGa3Quwt7ogsbNUEAIhIn/pXa+TPrrlmQxxgizWC0jL40nLn79L6AcNqfUE15RzL1Rp+UKDTbVX2veBpaB4o9vqw0tjxKdoNwuiHkBHhSZ/HhVBlwAWxoAHQt+tzM6UePEw64ZnPe2KOi4Zky7GmL+MhPAagprRDIi6W7l2EliUeko7iBTvOYG9fyR2L4pmJ0iGNMVrs00cp+IVvri70B9+213CeMkRZYk/7gsdTHOe8kP2NeGlm5Ra5oa/jDL0nyuqGMPVlmgJQ9Oe0Tuc3mzw/hLbb5zYk/hXhdCFaBaPXeCviBHW6hG+SVLya0iIMA3GAl2w2g8K8WF6htLVExcZJthgarztxTuVmet1mlxYczZ2auEGaxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(426003)(83380400001)(86362001)(38100700002)(1076003)(66946007)(26005)(9786002)(4326008)(316002)(2616005)(9746002)(2906002)(66556008)(8936002)(6916009)(66476007)(186003)(33656002)(5660300002)(478600001)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ljERW3N+pLIeYCcJHl1UcILFsK6LGB0g7P7pYQ8A8oDbFO7N/wBR5Yhbja5c?=
 =?us-ascii?Q?DtBZ22aUnIZINY5tPFCM12MwKR5p1fkrEWsv3JMtzqBCX2zseO3aYLfFm6on?=
 =?us-ascii?Q?2MjlI5hQgxEDlzcTpV2TjckbT/c3Mz9R67MKfktx+2kq0uydsoTEa4U5KSrU?=
 =?us-ascii?Q?LlGy62qPBiPsMRsq9Bbw4ZkXSSLWHZNmDaTcfm0hq5GN1vFUHls84PyfzROD?=
 =?us-ascii?Q?qAVIzSjLpH6nOG17UFi2j7VWvsU8v7oVyYUJVdzrG70fWtt6vGpgbbLVceKn?=
 =?us-ascii?Q?fCGxEoCQyFIVwQ6BrfcUTWnGFn8L+4Ckf/7C25YF2PXeDOo+9TzZvC/JrPHJ?=
 =?us-ascii?Q?AbozKoh6CxWclqwPj1j80W73nwMd4ncJyM2A8SCsNzIDUEgripn9yH3KK597?=
 =?us-ascii?Q?3xWzPP09+1g8EH3d+fI5a+HcVcb/ZnVQPPqgI3XMlCjp6IUVL7edfw7TEJC6?=
 =?us-ascii?Q?YwBSgyaC+GC2nYH4trC9X3MG789YyUkgluteNUeAGQv8zJdiZwfu9NgjlWqB?=
 =?us-ascii?Q?8clnx0Kaf4NCZbUS2TpIyxxnUAjkWW3+pEH7c2/y/0Ue2MiLR8sUKzsV+R1y?=
 =?us-ascii?Q?1HAdW9YJe5KKBRBxiKdX7qK/T7Wbrrsj+KyvHZjuSS3DU7ZVxG8i0pYZPtO1?=
 =?us-ascii?Q?xs8Xc9p7QJD+3zc8ggGHVeA03BWl4RAoeIVGC7QYohXoK3JweazW5l3+L6J0?=
 =?us-ascii?Q?Y3NcXtQaLVQZ0K4jXkM+sRJzxukr1+PWqSyAvQdCTirapoNim0bYmlFKrUsP?=
 =?us-ascii?Q?1W/ovgIQNz0dpb5V5qbuqg4M1T+MYWxFrwv2/sScltPq/0h213OeCEShnUSo?=
 =?us-ascii?Q?HHyxbbcbUYJqq8PXOqMJFNmmFGEoLHWbKpddVePgNh2SB2YBbnALAzGxEWTs?=
 =?us-ascii?Q?l1nbMVdszImOHPTr0TFJB1hX/w6eGrykoCaO7uf7JuIw5K8nvZcS63oJQ6xi?=
 =?us-ascii?Q?I95NZIyCpVdgg+3njPte0a4uMjXDUjldBjqLRh2e1PF1zPHNwBP8P5wO8eI4?=
 =?us-ascii?Q?5Nw2Rc/ZcBF75M6cca3XctJJwGBX/kLbqZfZctqAp43a8opLecCxK6bkg65N?=
 =?us-ascii?Q?CCDCXMzk4F+esivssuwl0jFwVNq2O3A07FOXggHG5rFA7ogcNbmCVLlt4Y6u?=
 =?us-ascii?Q?hi5s2hcFbkFLo1CPPQ5DabpuJrV3MHes/TfhvsYugIda1tDRzRbiEPJB+i8q?=
 =?us-ascii?Q?V7HLH6eyk5VWnvsk4RKtFu4cqIxQIsetqGuaJm9OmSNHxQovvG6dSAKOQ68X?=
 =?us-ascii?Q?Q2P4QGZGgjwT7u2nLnj/OpPVvrup0F2+BrupxbK13EpxmxPAuc5nYEnck6T5?=
 =?us-ascii?Q?uMNZJhZGR3K/mk7Twwt/E1+P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387ddcd4-12b4-419d-43fd-08d91acc22b9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 13:43:50.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gMUuZ7TD3UO5hnnWnUfseOaotU2nioaYKxYlPFGWTGYKuZ+L8BOgQDk6cnFMg9q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 03:51:46PM +0300, Leon Romanovsky wrote:
> On Fri, May 14, 2021 at 09:11:58AM -0500, Shiraz Saleem wrote:
> > Convert i40e to use the auxiliary bus infrastructure to export
> > the RDMA functionality of the device to the RDMA driver.
> > Register i40e client auxiliary RDMA device on the auxiliary bus per
> > PCIe device function for the new auxiliary rdma driver (irdma) to
> > attach to.
> > 
> > The global i40e_register_client and i40e_unregister_client symbols
> > will be obsoleted once irdma replaces i40iw in the kernel
> > for the X722 device.
> > 
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> >  drivers/net/ethernet/intel/Kconfig            |   1 +
> >  drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
> >  drivers/net/ethernet/intel/i40e/i40e_client.c | 152 ++++++++++++++++++++++----
> >  drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
> >  4 files changed, 136 insertions(+), 20 deletions(-)
> 
> The amount of obfuscation in this driver is astonishing.
> 
> I would expect that after this series, the i40e_client_add_*() would
> be cleaned, for example simple grep of I40E_CLIENT_VERSION_MAJOR
> shows that i40e_register_client() still have no-go code.

While it would be nice to see i40e fully cleaned I think we agreed to
largely ignore it as-is so long as the new driver's aux implementation
was sane.

Jason
