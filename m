Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5995B4A5BFA
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiBAMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:13:31 -0500
Received: from mail-bn7nam10on2063.outbound.protection.outlook.com ([40.107.92.63]:21857
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233554AbiBAMN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 07:13:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPwU6ulLjcS0+07r9JXJM54HYYDJTyQE8uZWwOWMcvgpPIMB+IaTLPxGVWcTB562Hj0D2qj5r8bFUCp/UWrO4ShOsLBV6d3nd3A4cfLQ/U17lX69KZdAG4pi81aSAKQ6Lhv0COc2D92bvRiVIcdvOuWF1kNYsulwggVWrBnsRePOvkZycw5JJgUR1Hq28rsI3hfuE/Y60EQZGkHSWi38GygBSvmEAmpr+3ePS6oG+j/kiLXlP64EYX8d1uEWBXp6CO4bJYRzDzbeReZzHDadTg6QnJiuYsLuOCE6WFnU0iMTHSDHKch1/gIOzLHq6/lM/uIEUG3Pdcf1aCN8OWC40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fSVPDZBrGTKTVyebii3gD+2rnyFAFn/mx34xFk7BuI=;
 b=SowCBq4Kf78SxjT0LNiC0vZ2QdnZ+NcCluJ0Zt18o4Q2HLISVquAYGW1bmiTbIkc+N4yM21AllEixjgw2kZJcchMhWupeEulkvgVkKSBleuxJJlIWlmlNFofdWPiU1IUA4zh8r4GRlY5TJQG+zhhHHD793oz4m7kdh35OWZ5VJd9d93oPdAMEvmpf9wcTPG3PoRnm+c7wfbzs63Mk/eMbD+bXCqWkqAJRaah0BzRMEC00OkCctPZCt5O8XiE6cbLCxGP1FQMetarGKhMXq9eKni43022/qyGzBMh8pREcJXpdn2b2SHUoeGQzkiklry918aGaD1BRQ5mAQGp20R3HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fSVPDZBrGTKTVyebii3gD+2rnyFAFn/mx34xFk7BuI=;
 b=pgThTAdGxuVIHbFxV4+LrYDrC7oFADIOpNz/5hYcf/PotTVISOBWwcbd/kJ2r/YEmOSpTItHHIIM+zzvvI1/8jo4wXfWpQpUMo3TZPuu5ge0SceKIAejoZrBcOvYyNUopXoxGAS4oW7pOKzUENae7iIX/lNE1e4pZFpP+dR0vne5mbFf1KmR0Gsdny8G4acMl/WVHbhxjr9I8OCijAk7qZAxswb++KoGJCX4JftcYMt4YYXpgA8NkFTVfIiJa5Z5ugv1Wgn7OSlIhN7ShJ2Gk2DpdKc+rqxVq1FWaX8CrfgeLAxmJ3u9O6Nohe5JGKvurL6XnJM7b02XFwqpck8RVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 12:13:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 12:13:26 +0000
Date:   Tue, 1 Feb 2022 08:13:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220201121325.GB1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com>
 <874k5izv8m.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k5izv8m.fsf@redhat.com>
X-ClientProxiedBy: BL0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:91::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c604a4c-c61d-4349-b14e-08d9e57c3ff6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4418:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4418F7D7D8EDDAA03D3BDA9AC2269@DM6PR12MB4418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMjVhlJ01uyp3fv7Aswc8KZZPjo0aTI1qISSifYvGagDd3qUDTjnUyDzh3My8Xee43Q/mxVzxvZY+DTC/+cuMF2j1F/ZIHCIWojNLwTpX1aBoEC4Ys5OezMG3MYe4F0Xz4CzejpLdSVNc8JMB3UtygjaMWaPLVunI+5O+74uHgX/JpLx01pBaWHG8whGf8zYaDDDioj2hnIxTyYR8FuQlLAudJdWYNHyAcO+lJzGXLGAIOlj8zbPuzoqE8/QPOh31/UERXWrl7Tdi/+lxT0zN7nskXCbqWJq1fikgDFXEFmlUZR2ZvlHLsBsu9IXTU94DM1D+hs/BBlv7xfOHM159L7BYOMZ4G2Zwjt4C52WkKT9Lq83+4/oUBm0TRCwQDZb2YueaGq3UokjV7LxWIcdjE2hEebry7Ex9DiO5cYEwp+bPvsfmzO+t2w7GQBVvZp40qnw6AVWkCXZ7uYkkyjziUbrMXu2pKalKtKR282wFvtd7N3BdtQelzNA9T2TdKxcM3YTjWKaSJ/H+9MK9yxgaLme91gxTDtzZ61GDDODcdWO+clIuJ6Aws0iqbkhWzgsu3sgQpK9JUPgq3IJLHg1T6YOH4WGoHBsF5+/6Zfq1d4+QzDrjhk/imN2+fWpFz/wSA9tCQUepL7Zkk+fbShhZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(6486002)(4326008)(66556008)(66476007)(66946007)(8936002)(8676002)(508600001)(316002)(83380400001)(107886003)(86362001)(6512007)(5660300002)(6916009)(33656002)(6506007)(38100700002)(26005)(2616005)(1076003)(186003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zGe988zK+ZCE2boW0IRs7MEFLpPAuiq2xdEDR2YD0PP8RZEmvgbognbZ9lJ4?=
 =?us-ascii?Q?ff+LGPyc96nms3P7N9BYEP7OeLvpxXgL0P4430GY4CPDZW1Zz+avGMwJJ+mS?=
 =?us-ascii?Q?WIKiT7xv7oL7QPBy/beDF+/VOgmVD1VIQw4wEbctrRpurmR7RuT1A39Ns08x?=
 =?us-ascii?Q?g5ucLzCVTIaQTblvR0gVhPWFjL0yvQPgUrhAe3CfAT+SJbqrCeBp7BWo7C1J?=
 =?us-ascii?Q?pSC2fOkMuAnGyjDUjLY/Luak3ist/7Px8d00GyQRdcKsCNTnV1tVqppplNfl?=
 =?us-ascii?Q?bDfJt13Xf6l6D4CF6B/kN8wUXyVHtr13pS9c+P4RCQgoyYqtoay9j0d5bJwz?=
 =?us-ascii?Q?0U3s0V8VOU7u9ol/jQI++CUkkEE036h+IgiP9pSBPY+7AkOpIvOoiEgmonPw?=
 =?us-ascii?Q?/Yh5UdnBuQvP7cF0UjckpuHErJLy14FYegrXSm4B7Oc/G+J7R9nc3EsZxRt9?=
 =?us-ascii?Q?LmiMTBBxF3HvAue08ttOYvr+zP9AOvLAPoAbuZT6S3ZN6xJaNpl9yp1Gqr6d?=
 =?us-ascii?Q?LmY19pKnvqb6rTWiLXKG3cqUESdSEiTbJwuvqf56Y7wu2eaJQsu1Rjzpg7Qd?=
 =?us-ascii?Q?+4QIDq8cxgv8U2TPeu0TGVmCOXVXIiynC2xZLZD3wXLvyM+6b79IltZY3sBO?=
 =?us-ascii?Q?5iTD8/GXkjLeOpl47TxUPdd6lB+FXxjGdviWG9gF8YUCFu43e7nh3NGGDaa/?=
 =?us-ascii?Q?EfTe+MwXHkZm9MVXZ92vu7Qlf53LwQRZ3RMVrnZ5yUpy39iXUbYdgejuvhIQ?=
 =?us-ascii?Q?OtDUScwsASVurX6J5T14iUmEU8cCCQrg607WdK+3QJsxQChia6H1slHHtOZg?=
 =?us-ascii?Q?PbgcH6siUiVoAF6xaAAIQ5cdIIIccj70Pw4pKFWgHfm3QenP56fZGznCsTrn?=
 =?us-ascii?Q?ZFueNSjB9w1KgAtlP8RS+YmwipLYvML0gaKYM7hJ9XDfJuStfquTT4IijXD8?=
 =?us-ascii?Q?sfdBVe5vp9iWXWFjbig9OOEDMcOpv9J1vPgZKHDagFW9KYrGa0w9SezCGV2J?=
 =?us-ascii?Q?6z+1Age4CheD/bpCJWyGeTpzkaeNjJLCKZzIo0/CLMIjcpmL6yVv3Uv8FkBl?=
 =?us-ascii?Q?R3Y9+mNbmgEqphsL0r8snb4GvRia/TGeJuKmUj+UEhVcY8mro9KHfxBuVccT?=
 =?us-ascii?Q?sv+hQPWPTUQyNhjPG/Zo6cLlEYIn1hi2Y1MwtOecOTZ9WlQ2pN4yeQ+m3+Nt?=
 =?us-ascii?Q?UUR4pe48G1DpsizVG9qKzU41ZcLd/7Fp7CyZyRcl5Mas6PW4+qElKMtEoGxW?=
 =?us-ascii?Q?L30kU4xMwt1JUWrT1ECLYEztI/ho5T2cyEeIRdogm71t+NayruQAixjA/QKI?=
 =?us-ascii?Q?EL570nkcHYQObw9Cm8E4GMrz9qoMjh0+pNkuJU9oaSCEHMqIfviQyEAHVtDY?=
 =?us-ascii?Q?kuZyMMfES+2APmryxglYZIPL2cB8CCAXYQFVdv7ojV+DMsRyQUTz/3w1sZ3W?=
 =?us-ascii?Q?OvLwpr5ygk33TJ3ASjwqm+7vYG1xAumkd9KKMJTch5VXqi0exofxusXX8XGx?=
 =?us-ascii?Q?vNO0gZ9Yc8Qi4PJQxRlO9GRWSxrYPx4xpE2kLWo98tefx/vMysL2p9Dn0bp3?=
 =?us-ascii?Q?lIZPhfWeNzEES+xCGmI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c604a4c-c61d-4349-b14e-08d9e57c3ff6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 12:13:26.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0hfvltLbL7/ICAMw9Ffq+6rmM8yucSoaxb2SnmCmXavhSPoNbaBOiYFwsj3RXvW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 12:23:05PM +0100, Cornelia Huck wrote:
> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> >
> > v1 was never implemented and is replaced by v2.
> >
> > The old uAPI definitions are removed from the header file. As per Linus's
> > past remarks we do not have a hard requirement to retain compilation
> > compatibility in uapi headers and qemu is already following Linus's
> > preferred model of copying the kernel headers.
> 
> If we are all in agreement that we will replace v1 with v2 (and I think
> we are), we probably should remove the x-enable-migration stuff in QEMU
> sooner rather than later, to avoid leaving a trap for the next
> unsuspecting person trying to update the headers.

Once we have agreement on the kernel patch we plan to send a QEMU
patch making it support the v2 interface and the migration
non-experimental. We are also working to fixing the error paths, at
least least within the limitations of the current qemu design.

The v1 support should remain in old releases as it is being used in
the field "experimentally".

> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 9efc35535b29..70c77da5812d 100644
> > +++ b/include/uapi/linux/vfio.h
> > @@ -323,7 +323,6 @@ struct vfio_region_info_cap_type {
> >  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> >  #define VFIO_REGION_TYPE_GFX                    (1)
> >  #define VFIO_REGION_TYPE_CCW			(2)
> > -#define VFIO_REGION_TYPE_MIGRATION              (3)
> 
> Do we want to keep region type 3 reserved? Probably not really needed,
> but would put us on the safe side.

Yes, thanks, this was too zealous to drop it

Jason 
