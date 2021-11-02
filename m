Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B7E44321D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhKBP5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:57:01 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:41440
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234673AbhKBP47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:56:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TP8/R10QaAPPLnMl8i3TmC6QPe6ubthG9QU2w1yXCwtJosX8u7MFL1hhD/7vbxeo5w50D1JVKJsVUwumJfvCEf0aedLFJwF8saYAVJxOx2vrflfmDeGufuRUY2ejF0gc+GpHh7H+HisbeeVSVhBMhBNPrEvCSbPYmm1//2GqvOp3EFC0AfUvIzeGipMdqz7uGWoP8zl9AGUERDf4kiuhJLrDXfxjsgDpbgxb8f9rACRwMGuj9DXmstuve/bRYVJT7XZOoJM1PpSU5VUn8cXfqT4RMVBmWiji4i73B9ycYYSl9s5OEjUR/e+ja+eJdQ68nUWEzX9UN+U1YinPXD5PAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bq2QYmvwuPYUkW9nzNm/0U6nrqUEF42Htl6S1Da4Ak=;
 b=KNL9usYm64Hu+luRGxy5NCLuEyCLrITVmE5/fdqol5eOQkMS9eZxibcjt7CqnUFdow4NsrYXXgJdKYHl+z86hUWRurdaGdeS5tjdSLi6z419d6ThVt0guESxa1VLqJIKL9id4AZHAEE7yh9CRZwfD7epppBGiYD7q5abpdEIf4GaX7U02V2VdE7THYaXvKcEDI/n/U8HF4MXfkToEOJBmk59QamqCSxX06kEtudZBDG9yVBbmbQBWR1oJjrfuHJnbMxHT76pO1hLcRgpNP0UhQhHZSoE90GdiHylrNA2YMXsF4KgpXpd/lkNXiz3v66TyAZL0A9uzAyd7tjnB6nmPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bq2QYmvwuPYUkW9nzNm/0U6nrqUEF42Htl6S1Da4Ak=;
 b=CIsVra0G9NoBDy+gZZ1Sw30eEaYP+bVzT2U8EixhV33tRXnVS2drWyLAVp8Tr+SB+WhqJHJosCXMgi5J9/BvHg/tfKLEycVAKeAqz9pqr9Yaj/ZYpaDmmSpP1reFr9TMDcB/jDqnCq9vGIVMR+MiK3kykb9IPg6BB0KPtm4dpBiykso2bOzMQ2GQS+BDpia1uQhg+BHlltJyGpmX1uwiXrvKTyq7rd1LPdS28/jXqesh59ul+YOAgbG2ALn6dGTgw9RM3DGVW191vYYA8hw+ScYEYnr8Adgo8WlUshMV8Xbq/ScQbMgTjmdoE9952+7tfDa6/QXeopq9zfDETZnRdQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 15:54:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 15:54:21 +0000
Date:   Tue, 2 Nov 2021 12:54:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211102155420.GK2744544@nvidia.com>
References: <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
 <20211029160621.46ca7b54.alex.williamson@redhat.com>
 <20211101172506.GC2744544@nvidia.com>
 <20211102085651.28e0203c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102085651.28e0203c.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:208:32d::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0048.namprd03.prod.outlook.com (2603:10b6:208:32d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 15:54:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mhw7A-005A2P-FG; Tue, 02 Nov 2021 12:54:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b5f8967-7a9c-4bda-c2b3-08d99e190915
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50618C7C9ABDF20853B74C9BC28B9@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mW4o1ZWjU4SsejLdk3oIGGvS7j5/xVSiVBMbLWn9WFBnf0CpWGBClERwZTPdPqvG7U0opb6HYeMFmQBM7LJNk8JpZjXkrSBxV6Zk9QF5fX/NDR5xEUkt8Hocldx29ZU23i5ZZO2Zi5tHaSNF5OI6LpJctVSfVxXLXSNG9vNcLYWfiiB7LVOSltDjAeHnT17Fy7hDb9HA9rwfRJOLGPJ2jVolXP/VpTFavwgAalbatsA0gybJZ2kUjJqrS1nuYXndypexKKyWaCgOEZ6lkd0/KjvpBde4bNQL3iA2/A6F3pg0lJgxIBj+KAsmQbGIvkQKbtq//S9n/pc9MuSxhQIn6kFWKrlT1LbEcmyce4yjm5B0jf7ZGL7D30vM7SPL98b6d4WudKbJUgr6H4r168mouPQQh3Q0oxQGi4CdkBptttPrvQk1ZyH1Cxvx4uXWmUVIOVGTuoAO+4+7DyA8hiILocUYMm7hKVIhesP9Sh7o3dCHCak84cbNaHWmpz7rC8NQ1FgYNZpTXmc7ilx7kPR/fPzzZHXNETyru6nEqKcoyMC5L2cnT+eH3VtFae47bFJaMPFOmJdEvHYdFBJke4k7sjSlclZc6np7QJtSG2aMT10WiTt0vZFLdNWHGkRwICxMWob7r7S4GxsJXfEUNgh2nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8676002)(508600001)(36756003)(4326008)(1076003)(9746002)(9786002)(26005)(38100700002)(186003)(66556008)(66476007)(66946007)(83380400001)(33656002)(86362001)(2906002)(2616005)(8936002)(6916009)(316002)(426003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0a1jLPIzXxmM+f1nuZU8i86X6aPbF3HLGAbo1AoK+zfCV1BaoYQW3p032rfd?=
 =?us-ascii?Q?D/T51GXpVqhzV9C6A1qStEhFGHUAKhAXmM1eIB2AFU/RGCThPgKy0IG3n984?=
 =?us-ascii?Q?ifgs0XPvmJ09IC9tRyJYYfNnebnIJ8MjC2614ik94U2i4QvU4VDnziLzhLkA?=
 =?us-ascii?Q?o6JJDD/wFCCIrJtipQ4Xtyv6h/94iSukJ4kXMtMXVjHicCBYDShwAbvEn2d9?=
 =?us-ascii?Q?oEmIVSVzcYFat+k6U1BHgywyFARtj5Bki+/tyKNU7JMb1JTu0/2UoGECCvh6?=
 =?us-ascii?Q?my3i9iZwH68VwWVwce90ibVo+ZqvpwQ2RgAhUvmYe4UnvjtDVPRotn3tN3tF?=
 =?us-ascii?Q?cmP2ojtEfRg/kQdrKde5lwxLdlwPIHgjR6PuC3iQPJjLnpGdhcRiG/7z79e2?=
 =?us-ascii?Q?nZowOArDorc1RIJMutvgp3EnLUy/cOUoAKKC1mtnRk1X+Ym8KtUvfoMgJQNO?=
 =?us-ascii?Q?JtLZHtIhXrfnlAFJTMFOssbcz6XLwknbdhdpu9gUAtXKqzQkCnJWSwSDmBOI?=
 =?us-ascii?Q?l/QT0Ebg6dH13+78/RQMTyR4jR9a4CeXLwK0El4zrXxTyVLujt5zXiygm8vR?=
 =?us-ascii?Q?tyhCNMaz/vIHFz/7PnVlRcsnRmZ5f664Xk4ExIp/9VdYTa5Hwj3oDSkY91RJ?=
 =?us-ascii?Q?hXw5HJOLUd5lODxbnc6MOi0u7ToR2U8YnWlFMGqEwAXCmGvFMADCAj4EcHNA?=
 =?us-ascii?Q?RGfdeHdxc1AdfVQDI0rW2Mo3AN+UYXmDgZziqcTtjDSEjoNB8kL+yWiJNaEa?=
 =?us-ascii?Q?6W84KVy68TC0vZPBWm6mU9PTqOR3KGtwu2XKbT2vx0EjOQ8exHooWKvO7kF0?=
 =?us-ascii?Q?A0Fksio2iA9vhNwDB7cui50vtFmhbLQuyZrDT3cp+tKh6b44Iq9/8uHTEZZe?=
 =?us-ascii?Q?+n3zttsco9t0ZCvkkcnUEl/f/U1m03wRbpzknR9v0lT4SZzQcd+yaj3Np20F?=
 =?us-ascii?Q?lV5f/l4KPmg1zbtdRm67YVGwIsg7VwDvDmgUGP6fdgqXB7vsdbFNBYWM4Oms?=
 =?us-ascii?Q?PZoEsGMC0eGa0LQoGNs/zAhBl2OYTwxVGtYDu8Q7/Ork3qfOLKbi3NiREl+k?=
 =?us-ascii?Q?9ysvgaD/kuIibEPz+nHnolncBgEXKiLwCYKdR6RhLKv+nwyu2tCvac4wqZFt?=
 =?us-ascii?Q?rEXcHNFa94AG7fg3kHF80J7dUnlRUQa5mC0W+qlcpa688aOKEQhJpt1LBjc9?=
 =?us-ascii?Q?Atn0M3xxEOb3O8n4VxMK0cdMOzShtvFz995YIPaUEgKGyG+C7Z9+Z0XykDzY?=
 =?us-ascii?Q?cYX2Bh2RpdXhxKX7DhJYHLJ7Xno0zNM4h223zGTzBBMmddG4Cq8t8rNV38ro?=
 =?us-ascii?Q?WFUPIOzLIWA9PdFAkZsjYo+6fXj2H3Kd3jHN7yQSpwa2tH/JEXywsGIWcVc0?=
 =?us-ascii?Q?7vfuOELgsHNhPi2ACaBR6m2Pi11jPtN/lnxYGsU7WhpQ/zVPAvRHX4D/Obut?=
 =?us-ascii?Q?TP5vL3oQ220V0Muz/9PoVQP3VgczcI5saI9YdepwbEpLVVTFIIIB1v50dy1+?=
 =?us-ascii?Q?/xoKCFR30jmsAEVHiXZYH/1oX5ZvFFKUrj+HO0i4TjTb+nWLWFuB8QU0E3P5?=
 =?us-ascii?Q?HGrsPDdgU52n/YH1IvM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5f8967-7a9c-4bda-c2b3-08d99e190915
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 15:54:21.5897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPrIQAduIydczq9Xkp+PVnmeQq6S3kvsPnmrPdO3qZbQJIo5ECfSTkp8cwlURr8B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 08:56:51AM -0600, Alex Williamson wrote:

> > Still, this is something that needs clear definition, I would expect
> > the SET_IRQS to happen after resuming clears but before running sets
> > to give maximum HW flexibility and symmetry with saving.
> 
> There's no requirement that the device enters a null state (!_RESUMING
> | !_SAVING | !_RUNNING), the uAPI even species the flows as _RESUMING
> transitioning to _RUNNING.  

If the device saves the MSI-X state inside it's migration data (as
apparently would be convenient for other OSs) then when RESUMING
clears and the migration data is de-serialized the device will
overwrite the MSI-X data.

Since Linux as an OS wants to control the MSI-X it needs to load it
after RESUMING, but before RUNNING.

> There's no point at which we can do SET_IRQS other than in the
> _RESUMING state.  Generally SET_IRQS ioctls are coordinated with the
> guest driver based on actions to the device, we can't be mucking
> with IRQs while the device is presumed running and already
> generating interrupt conditions.

We need to do it in state 000

ie resume should go 

  000 -> 100 -> 000 -> 001

With SET_IRQS and any other fixing done during the 2nd 000, after the
migration data has been loaded into the device.

> > And we should really define clearly what a device is supposed to do
> > with the interrupt vectors during migration. Obviously there are races
> > here.
> 
> The device should not be generating interrupts while !_RUNNING, pending
> interrupts should be held until the device is _RUNNING.  To me this
> means the sequence must be that INTx/MSI/MSI-X are restored while in
> the !_RUNNING state.

Yes

> > > In any case, it requires that the device cannot be absolutely static
> > > while !_RUNNING.  Does (_RESUMING) have different rules than
> > > (_SAVING)?  
> > 
> > I'd prever to avoid all device touches during both resuming and
> > saving, and do them during !RUNNING
> 
> There's no such state required by the uAPI.

The uAPI comment does not define when to do the SET_IRQS, it seems
this has been missed.

We really should fix it, unless you feel strongly that the
experimental API in qemu shouldn't be changed.

Jason
