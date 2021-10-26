Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E213543B57F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhJZP1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:27:53 -0400
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:30785
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236579AbhJZP1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:27:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHq9K4K9hiTUmG7n6Q5dJLDJ/T2JFJL82VOUTrtQ8bsI2R5+45gQYsoiuWiifv7+5TSLzC+8ZH8GdfGYkthB2ucpXdvmJ9YfjaE7unH8tRkay6jjHsQTkR05W0iLOdKSgRl0XtUZA7Ds+5rICrXCGPVpMedDFv6AS+YAEksQFhdt8rH5CK79OrDcQpnZXZWXn2jU6wRX67Ihjit0Y6MduLh7soXM8nZOiy5+JyKkw2Ey3JTt+HTMC5MBQFaiPZAdMImErBDo3lxZNr9xJWrDsq0ziDxycDfg5ARC3KFcNtpXp0chuqA1ryAixLjn80fJygnUZEYz5iENazfmiB4OQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qL8RNolejkny0gTQ//dyU1eBrTqCX4ZIm51atYjBR68=;
 b=LvRxlXNFbolcNZiFdQbu1Se9jlcYy/PoOgEHwafdUBWLfSTLokKCQO9wWv8HxpfT/15XpBK6AfEoFPkdUjGg2ymkomP6r9NbUL47ThN1zMLwbzUOeKGlZ+iQ9bPHuHKtH5q1OWabiTTFZAKonnIKas4KArbGknrNnS1MA5m+I+19+o3P9R0+50Mr/f5viSPqFkycyHw56KV9swPsq4mumQ7TLQqfDbIT0k4P7EU9rlbJMeDYWfwa7jkWsGMPEOJstsmQ4i2SF6srSNzw+XXAU1mKaJNzCAkTqiEcCo/V/sn83gXCxRzRWORcKzCOu6gfwNVRvBnycYU9zfe0RfOSpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qL8RNolejkny0gTQ//dyU1eBrTqCX4ZIm51atYjBR68=;
 b=NxpxNpBpPI8BssA2dTtTFGe+0TJeiNL5KsI+3mDr9unkjuBBnClT9nbgeD3dnpVJ+zVIaheyXBGNxr0GquqVdblfDbWr9osAIKBPNKerdDIFklxMVZ9WmfqertxpifLCi765mNVf6mOnZCxs8/Cg36c84PjfjMaQPVFNF6A/rfVBBDxbxkys5f9101bGgWc/mMfkAyf0Si1FhRSell/NP+46YStUUEn84aFkgo1tU/FJOQ7o59oaNbZ3s15YQ+g0FANS0I8xwvV+Ibvx8VyurD1LyIWLhhXbredf3Nl/B/Llk99kvkxVnM1RV67Bl+WxdaBVfjQKWqTojjgVoH+S+w==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 15:25:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 15:25:27 +0000
Date:   Tue, 26 Oct 2021 12:25:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026152524.GX2744544@nvidia.com>
References: <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
 <YXb7wejD1qckNrhC@work-vm>
 <20211026082920.1f302a45.alex.williamson@redhat.com>
 <YXgV6ehhsSlydiEl@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXgV6ehhsSlydiEl@work-vm>
X-ClientProxiedBy: YT1PR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0047.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 15:25:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfOKK-0027Vh-Nw; Tue, 26 Oct 2021 12:25:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0959944-586b-4fe3-2880-08d99894d66d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-Microsoft-Antispam-PRVS: <BL1PR12MB528592979080D5E67A184BB5C2849@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDKj8+yiLLGCxqEg73XzhLkeXpYAhaOBeaH4ZEB1+sFCAAT7j3ps+6YflR7AhfIy/F+HqIiaXzEImncK2mh29bD3fEEkJUjPseZFDjySbcX9qmcPtQmTOoHKof980WdGqNuST/TYx9TpdzWY147/r2/MjzKAO3oVZEV6SkLIuDfdRX/ZPtd2D2giqexqhFIxXu4oP4xQK8r3pGhRKrWqDehGSH0wfGU3S2LvJd2H3FjUg90VEEb9X/fdYQKbjHggzE4o4KAMhLoTXN7czfORyLvZLp+D1sEbWJ8AYP++xYnqLztXo/9iou+tBYrgn9EEnnoRFNQPq56iZljTXflRvzzStKW/tDSqJ+8nccQT3CygxcYDnBjJlhzyFGiVqwhCcinLitAawxw6Q127JpmVa28lbCIISFXSNOnAim+CSzyNmzXsBE1kZpoSLqV5wPGD2svNesuPcTif3BX+LiaQf6dyB7RLfeEWTvbEbYAt6mP+JngjfHP0uqFXyvPmvsA/zFPdltp/eJPSlpKCIW83a73/CXoFyL9Bl3U166mezkzM7RMm0f1JpXj2WAT66PuQPUNRmulAGC1yV53/x7Ia30+H1VuKn6aTzT0oxJ2YZB6ebVh4aZToYjtPLU0XwEiZgOkSmgsoRAAsXhT0dRN9Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(316002)(6916009)(186003)(5660300002)(8676002)(54906003)(508600001)(9786002)(9746002)(38100700002)(4326008)(8936002)(33656002)(36756003)(2906002)(426003)(86362001)(4744005)(26005)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ifgDtwaOTUO1c9S4MSfLE0WhUnVpoOUekfihStgsFRmkrszKjQbrC2O89Ld?=
 =?us-ascii?Q?lEyu2xlaN9NoF0iMqlyOeMKWdmWJOFcaarZ9VrBvLjQIQHpg6xpv48TpiAcn?=
 =?us-ascii?Q?8Zw+/D2wTzMbfHaN+TLw8ZryP96ZxVt4o9rd9bFU/AQfLKx/9M8g6Hv4eieh?=
 =?us-ascii?Q?N76DG4RwjRiKZtYEJ5x/BnX/7s2JakhCOn1SUz+aq6ZIAw379cN57gDfu2Wx?=
 =?us-ascii?Q?q6W+GmRywfBZb7wKeGSudH7O1+NLapPfK3gulQsEcmuWp4P9QD0HEc7IpQ51?=
 =?us-ascii?Q?k9y7YIOmssKY0fW3y+YMTOEft+0iyyqLyPaIa3K8+ERESqf72XkMrKMM6o3D?=
 =?us-ascii?Q?ZI0Uy5Ux910eaIkQ/LDZH29sA+6X0kp12Oo9nU09KTZOc9dVZ363o9bGI7vA?=
 =?us-ascii?Q?FkBzTHWNPvoAtBxpa1J/NBr/+Z0CaVklCoJFAPPPDQ9hpITTZkN5uhx19ZBd?=
 =?us-ascii?Q?rkQLWwtHDFxVdCIqZYnt2qrLfNHv8NaYCeXEMBjA4RAoMesTTOAFp1LpyBxt?=
 =?us-ascii?Q?U9MmkxWY2ys6HX2ijcDaVt+nYT343tRtHkP3sgi/TqJ5ShYf8XXw5mDSCAvV?=
 =?us-ascii?Q?B5gXbb34IuZofKs32sihsi5zwXYdP2Q/OLRdH/7iyrEPsfZ+Ehtlrw86kVLf?=
 =?us-ascii?Q?R2Lx4fA5o9SeAvIU4v0lQO+mx62SEk0BBdx+tVeZ58F327e0DJGsZBPxbOHL?=
 =?us-ascii?Q?cAtqUkMNY5rGmxDsuPjNOo0mPg0TRn+qjrml36ulWI0Avxo1OLMVVEOqNwSI?=
 =?us-ascii?Q?y3ILqH8o0Eg6Hy306rb2R18Jdqt1bMgnAstvr3jOoZ6waznLDwU8PB4s46kj?=
 =?us-ascii?Q?xBob7ZGf5x0aDc3CAKC54b1ePVuLQFASy+PPv0JLvtz1e1f+4xn2WT2+9ujN?=
 =?us-ascii?Q?CmBfHFJyJ9HUaqcL/8obsQeInyo8iDATBiDnuH9itkQ+iSJO5SvmSfJYzEkk?=
 =?us-ascii?Q?b5YNbb4pTlalu7aa/KLu8LcuBdHAjDdIxAemzSg9t+zo8F8mUA7ip4c5v+wH?=
 =?us-ascii?Q?SI26gr5QrWt/AUp5EhPZgARWNmgqPSPZrZBDquJ9pEB0ffx+5A44j22VPZCJ?=
 =?us-ascii?Q?jAzQ8DYjGzldyYwTQB3/pa3Q11/rTbeQuToeS/6SbEOBKz/g5Eu6IvJzxOCd?=
 =?us-ascii?Q?wkv8AO+lDCaoV+XXc/DxRSrO0AYxa4Wx0rmmCt2EKsJIdA4U2IItRbTHv6Fn?=
 =?us-ascii?Q?LStsHHiIQgXiEko6ODgzUzyFJxdcRvAbNRMMN0ORdPijRxg7lAW1M8MrTXs8?=
 =?us-ascii?Q?IWwA6oRccytYRCuppous3RG/AB6dERzJ1/B6yQ8Ksl9h1WVGQrLtb0FjeboK?=
 =?us-ascii?Q?rLkEvEQX3qHA58YjCqNvjVs7sitLMp8o7qJG0ovAioB1p9kDEp5xSV80J784?=
 =?us-ascii?Q?6v28kw1b0Ah7kjNUS5+qC3x0mF5ORuWps86aunnHyLSKEy0YahRZZlOKKEpN?=
 =?us-ascii?Q?VzKsBgkTXDbM6npwNQFwFpZbxQMOmN2hofu8hKGg+E0R7hHpNMR0JZM/yxy4?=
 =?us-ascii?Q?gMr9NH3BJjorXJki38TqJYDfgvliUcfiE2pkNXyMdwgTKobwrUF1/OHjX3DL?=
 =?us-ascii?Q?Fhf6xyUbCI5ppHyBsC0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0959944-586b-4fe3-2880-08d99894d66d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 15:25:27.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0JAgP7xj1rCv++VKCkgSYeceAgq50ThiJx6yykCCyq0BI2B84ja8ewAIN2DTjBQj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 03:51:21PM +0100, Dr. David Alan Gilbert wrote:

> > It's more than asking nicely, we define the device_state bits as
> > synchronous, the device needs to enter the state before returning from
> > the write operation or return an errno.
> 
> I don't see how it can be synchronous in practice; can it really wait to
> complete if it has to take many cycles to finish off an inflight DMA
> before it transitions?

The fencing of outbound DMAs in the device must be synchronous, how
could anything work if it isn't?

Jason
