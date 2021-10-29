Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801F143F3E2
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 02:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhJ2A3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 20:29:54 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:7878
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230211AbhJ2A3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 20:29:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEcoh93JIrI6htNYHfyKSC7sOGjcz838GwMZ8o5CYST5Yq7EDsRTJ2rzNDOhCw/M/g8d06j/y8jlU06sJZlZkyw4RLIb/afPJZ9sgaSSQCRmVaItMHwtiV2QVWNhExqbpuboo7rnYTC7QdxnJf4wY8TkFks5yweDqtL+pjgCg2O1LQ4Whi7OLGNACKyzltyrbhmOcZm5uBBnS32THfMfellDXWf5IDya/tfi6KzJv0Mu6rGzxeV4b+xdS7HpvuY7A7SaRMns+3/Rud+fKyyONbpQz83nigDbf/InILVaIB/BRgXSUBJ2QJ4V1EC3oWqOF7+oFnNWIiTNamZQfxNp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Qa7K4SkrX8N7LHTMAbLGfVqPf0OygQZzo4UJC5n4B8=;
 b=Gd0s6iOiOFDunrCzxai0ZFcSSmb9ryAjb+bDZprO7vMaiRIX0e4IZrtC9bKtSf3lFzpp8l6Se3GRkCIugL8YTrJ8Wzmz/qHCdr0CEyrJJcO1o7bFmAEod78CG7SvAdSPr4+TgUFnKClgH/d1McZdTylifCUTRlO2uoe8vuz1BTwYk9ogNG7KEPhrHXZim6DQA49/C4ayUOSie66SlY27dVUdE2PAR4qxD8WaL2qQZ5H5L7TP31tnrv+WKMK1GyiKZxolvcspsEy2PRZJhJmJs2Kl5hAih1q50P4gkhTmRQlVfRm8PcCQ6MyHeL1m9FqOy4mchoKydEz5+qiCjDbrUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Qa7K4SkrX8N7LHTMAbLGfVqPf0OygQZzo4UJC5n4B8=;
 b=c4nSNOTHYcFjQO3Eg4kcV52rkB1XN5Hqebk69L7XR6qKn77O+LpOODpG/QVoRb08r8sQKcuxo/alm499ujeAqzwBp7tqE1ftg9ZaeCkKMP5uMUc7Cxr8fCS9KRJe8rTn9kRS201SzLizqwmxVR/wSh48c48RRar+KEolijtm9lQOyrLEDr0wPifH8BPJ3R+MWuDlR40ePfpJTHapa5pV/Db9CLtLjAleea1/+tjI1H9EGqw8I9MC33nfF/FbeaPuKvhRwHnoXtu4tBkklgvpUeY9bfUkNFmEosO8g7DOtqpx4KNxut/VZNDsgDUHTptHKLuuMC9pNat4wVcW7Tza0g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 00:27:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 00:27:24 +0000
Date:   Thu, 28 Oct 2021 21:26:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211029002637.GS2744544@nvidia.com>
References: <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <87zgqtb31g.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgqtb31g.fsf@redhat.com>
X-ClientProxiedBy: CH2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:610:54::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR11CA0014.namprd11.prod.outlook.com (2603:10b6:610:54::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 00:27:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mgFjB-003C6E-9G; Thu, 28 Oct 2021 21:26:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d38c3a8b-db06-4f16-9cd2-08d99a72e0ef
X-MS-TrafficTypeDiagnostic: BL1PR12MB5317:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53174D8FF98A09150125202FC2879@BL1PR12MB5317.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1fLIsX1Nf9qbYduLkjRkx6qynq1f9rtP3ieiqKGhIvAPVxZa++lfepOKKOqMQQqnxIVDyshw8SPEXp6HgwnCoQTBaxzNg10X0YXmJXz2r8BzxOQVQrZ2BVGYOZPdlcKRF3UPIJd9xAKSOUYo/KuPVOVS40iOuxrph+rjIVJ+96hRueZMXC/Ox9UowpbM3WS4KfKjxc7lcw6eJ8qsIjNtpyo/OfovjxDYnv0wgxi9NPsc3suoQEjfSbfqN1VdoRG/rsADcum15jAo7ZTULK7XCpShTggws7xeDezyW4u0hlIIZhS512UdaCRdud2fgz7F13L3+IO3aN5KBhNh1z6VyXAsS2dWB9c0DC4VtqLPU7ulB6DerGVc0AVWTEKw3VXFdQBrhKt2Z65RLdvFfegeUuDvSfelqi2lqDAZRjLfWrZGsX5IKf6Z1P/zl746od+6BDiMP8k/+g/8UCNVqrNApmjtgHVEb+S8s2UhLszWNicQ5NETa6pxfWmNC+eT1M3ez7Dh8pTTj7pEHoaP2YaJnZ9aVCTDrYKehU+XuReClNxl2v+/gmRLp1BlrGE3Q/GYsibi6U81OTwJvVIOsHU+M9QIVnahAH6uR7RGZRzqQ8FNLCBK32EX0zS9qJfoicgpxn2E7c5w65Rh/G64BxfoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9746002)(9786002)(5660300002)(66556008)(1076003)(508600001)(8936002)(66946007)(83380400001)(66476007)(38100700002)(186003)(316002)(8676002)(54906003)(6916009)(2906002)(86362001)(26005)(426003)(33656002)(36756003)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ta9OeTPrcR7cuk3wcbKz2cAJvcTjif5hfFD+4oMdpI+pEfwSDywK00eFguvz?=
 =?us-ascii?Q?yEDpp5nVUHkfS/6HRgo7x6L2ymbW6JOddFk8f+94WtwqlHG2b/KtCUyWQB7q?=
 =?us-ascii?Q?1Q/rPJzFKe5Q3Nqzqg+LwGDbWuv3LIMt1Qzb9ACW5vBwrC89QnD6/q7iGdfc?=
 =?us-ascii?Q?HMjkuAF2/Hb+jRKFffn/NPphCILDFztfkjQ/jSheDDBuRoNddSAWshKhTqsH?=
 =?us-ascii?Q?wcAoPCdlPhdBe2culUzxttYCpyFx6eYEd1ZHpLm83AIROOl8L/jpSM643l4N?=
 =?us-ascii?Q?fOgwc7QQ2eyq8PTfGwYLhoSWt85LktQEshBfu3fdbdaAmZ7lkpjEsrOHLpe5?=
 =?us-ascii?Q?wbc0nWd66OJrJfc1uZgDmiheb1ZtupS9nK8zAz3jnZWmfKGX4v6AZtGPHviy?=
 =?us-ascii?Q?NLo4fPOguNxAxfxT3BFg69TlRH5Pi6UDHiFZ9MzNZqs0r6s1ZUwKKP7O9DfU?=
 =?us-ascii?Q?0WCawLKgOQ+wHeHbLmkss22Vj6FmyKYR6b8nO1bZ6MrCaFySXXQmWs/OECdr?=
 =?us-ascii?Q?ysqyrhGNM2VUmP043uxvkCGZUcIXywGrzJYpaJTgIp4TGdT2ojU0kx+nqDl9?=
 =?us-ascii?Q?yS61/dKyLEQuX+Rd1yKjhp8LGeBW58cgKrm2U/sOJmf5JG2p5tCX/i5RsSdf?=
 =?us-ascii?Q?NY9hIaI28sGwqiDoMC2QcxBrL7qkP5NSKcMiIQvMeZVIoFdE1XRfPOZ0qXvr?=
 =?us-ascii?Q?XmOv1LvQ3U11lnKHwPgAeM07eb6wS66+esQm9o2vzemq4msdj9rw0t6896LQ?=
 =?us-ascii?Q?14mM9+B9kZPKOb1njzT94zGkU64+XYKt0XzOu+8WDmg5TN8hX2rYVp9ay+Ja?=
 =?us-ascii?Q?+7V0zBio+ojvltL1JC2a9DbCuyF9bLpn+1sQjnMo8bUajVUmpZBPVmtD2Etz?=
 =?us-ascii?Q?lIQomECbJIEPlgd/c9FKfVuFug6805H/70DXztD9pPIf4bj7r/XCRtCEunAf?=
 =?us-ascii?Q?juaC4jcVqlH4JqrFs9YV7zvWzfEToK2hiYMCGfJTyoSQAEFmtIYSUGYa3i+w?=
 =?us-ascii?Q?pb9+t0MQq/YqsHhgAOhAwlhQIlXvZewX+//2Y2CyXfUb46oXlbNG3JclVYCL?=
 =?us-ascii?Q?aCn/Wa5328lOkeU3rvpQQn5Eid7mSxdIOdZBxHL55rcbpOuCYHUrPHzsVflK?=
 =?us-ascii?Q?0inybCFi2Lq/cpagVmd8b/w5aC8e0eA7THSq1UvPHlj+JrbVo2xtN/iWCtqy?=
 =?us-ascii?Q?AnwSrRyx2exSSxuHO9RlnvYw8heGdqtgZ41y+qC261uB93wbl4NtJy5VpM+Y?=
 =?us-ascii?Q?WRRjp4G1wqGi90J4RUVES4AF3SM3StxOlRq3Kfvy5B0+1LdTF0QvgOsRRjAN?=
 =?us-ascii?Q?EGPZDXr6PLSTeQu4kuhkcIgAqf4D/dUacNDcvt8w2yvUip6baLlEWCmI56IW?=
 =?us-ascii?Q?D92bHRfXEpMGEf9zlzhJgLk6hjXveyGd8UqGX/eEMrNrZXKHoNBqZON5fp3T?=
 =?us-ascii?Q?VpZY4lM3/Xrh8UR1/ssMKp7OG4kFAdwn+mIpIIEtCtyOm9w09ob89dqjdlO+?=
 =?us-ascii?Q?XHXFDcyA+DfwfXibl1U+Pds9HCSUZenVLyozN8z9ivqrJ85AQ6czufFYLGMf?=
 =?us-ascii?Q?155FYRn6SGWQ7w3Fkqs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38c3a8b-db06-4f16-9cd2-08d99a72e0ef
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 00:27:24.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ki+61vKYTYxmKIZ//rAz8eJ4MUuNO8uCRSQI4mqiRUxk9w2759/n/IeSj2QOBIiG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 05:08:11PM +0200, Cornelia Huck wrote:

> that should go in right now. Actually, I'd already consider it too late
> even if we agreed now; I would expect a change like this to get at least
> two weeks in linux-next before the merge window.

Usually linux-next is about sorting out integration problems so we
have an orderly merge window. Nobody is going to test this code just
because it is in linux-next, it isn't mm or something with coverage
there.

> > Yes, if qemu becomes deployed, but our testing shows qemu support
> > needs a lot of work before it is deployable, so that doesn't seem to
> > be an immediate risk.
> 
> Do you have any patches/problem reports you can share?

Yishai has some stuff, he was doing failure injection testing and
other interesting things. I think we are hoping to start looking at
it.

> If you already identified that there is work to be done in QEMU, I think
> that speaks even more for delaying this. What if we notice that uapi
> changes are needed while fixing QEMU?

I don't think it is those kinds of bugs.

Jason
