Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2444026E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhJ2Su2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:50:28 -0400
Received: from mail-mw2nam10on2042.outbound.protection.outlook.com ([40.107.94.42]:42464
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230163AbhJ2SuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 14:50:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKrQkgupA33FFv/UVWfVI14bfhd6HzDG2Tt4CcY6sUYXW0YU7hJ0IzaTtyo0oYRuOfT/TS0yg9iZZgqN2KY1eVcARo68AKeKr7zPSFXoFy4AXsAuNYq1RXSox9++UTeHsH6m09pkQGK+FF/zi+c6+l/ctjLY5Zg9D0BNZEBNj4511bCHRa9vj8nF2Jae2n9f56T27Ry1C4sC28AfNIcWK+SIbp9AvT/WoAJ0r2OtOShtQ9HSZjNA1NcuhYyt4gs5LF1pJFLGdxcFE78SB+XDj5ox/o3dnc6vaVtcSjrOiPxqUmVs1PdqhkJkNfG9pSvG/Up9nbURYD2gbpZ644m1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aeh1aAzkPcxz00NfaU/GDPkcXjEgDpbmBgYSk0YpTTM=;
 b=VU78VFOYPlF2QYBozqAV7Ftt0gmsAvM8/7P/61HWK+ZUSbbB1TgV6D0GSZx/cxFaoduGIiOmKoLbVMJ3N6tC2yBqQrdFxm4lgZD/cmLZ+qs8fAlkMbU8sbU7CWc3tgdP6oUCFKEck8Lz6a1VbvjtM2oo1onXhztc4uj842dI5WWxhTl9khfcT4XpbGC/0rU+t3vcndXn3cJEPPtxOI73RgZySMe9Ckma7OmviS43sElgz9kHXZoroU3ewyM3TADvYcHWEQYuuk5Qa7SvOC3Oxhyp/2emgGgQ+hhO/WRBpXlnvIIVxX/maEqa870+cTz53BDbg2KqtjIoMYlpehHz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aeh1aAzkPcxz00NfaU/GDPkcXjEgDpbmBgYSk0YpTTM=;
 b=ObHAWOYX8Clxb4x8eqHMbjw8Lmp6dG3FAEzmLEVRsN4ohFj1bCowW0IRtkof0cgBx9cZjJ8XMAv2GW6fNA3UN9apfdQhenAH3PtGMzJEV5pnbUOrQJ0HkV3zqOLVk8HOKCCnZbZKMfezy94QE/EqOlgxHxEGNPzAaYiOMZSEoXIcFL8gw77vid6sEd/pkW1yXqopcsjx1072heSJos4ioYijxtiJHC5SMRNVVW3lWDScWpdIpKpFPVhtI/v/TnCr8nnv5jzmfYpxYBNhMSe+vni6FIjYmXHqL5N+Rxwyvnxux5xG2dLyqN2skcMbrGTJWwB9OXhm76hEGEKuXBBEcg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 18:47:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 18:47:54 +0000
Date:   Fri, 29 Oct 2021 15:47:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211029184752.GI2744544@nvidia.com>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
 <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211028114503.GM2744544@nvidia.com>
 <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b573b01c-2cc9-4722-6289-f7b9e0a43e19@huawei.com>
 <20211029121324.GT2744544@nvidia.com>
 <20211029064610.18daa788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029064610.18daa788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 18:47:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mgWuu-003gMV-Je; Fri, 29 Oct 2021 15:47:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a9b1deb-12ec-42ec-11f0-08d99b0c9db4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5239:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5239761D55C7A5E39FD4B666C2879@BL1PR12MB5239.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: muT3yXJ5eV1u64DoGJQXOrJl5B0DQS7Chm7KBOoail5VKbtTiIYf0EFs9xiecS0PUB+oXrOQIYaTotUi25NFl3EamNgdto5rzJTIlE1UOBMNU211RWiyG5LUK0sqDQdruIhlrg2IczDL3+XxMIVkI5fIkVuqg1/IQkgjd+1bS7DaE792Ziz6bxjk9p1+gsRKhVycdTV8yL8jHj2N/NWlVhKWvbOghAYnuXCbD64WMOgWjidwRRWuJ2T01NP/dUuhFKJWRYmNhq8ViOS0HrX7spYCGVgplKUDWk5M0nh/Hf0JqOQ7C5zgi0N/E95WFFFlnfJCQ4+CwklizEQdbpmUJzSVC34UyPaSxlTdvNekkWk+I8aRw45pqTNvY7pYLz3M/VLc8dtSvFlzUgBYxMEIxEIpZjRN6Ai8ZM7HgDp5+Sxs5oRIvjYnBXQ/S7EZXAAc0ROUgWCliWLLAPHsFnQaQXYI3FpO2xSF3wSbt/qD3U3OSAmtJwGWvz6jkwgPsTYN/F0CcZv0N6Tx0ovQhT9HPWjmHDKomylhYISqrLJqo1edME8dRlPY4HkGELkBnen6E31vhGLAgGKRLdhycuCkMtREAu8rOnz5agaoXRgilhBc3oih0G8JDch/Nk5wxYi5iHQCBtTw2l/S5ay5M3hB7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(86362001)(8936002)(316002)(2616005)(9786002)(66556008)(26005)(66476007)(66946007)(36756003)(186003)(9746002)(2906002)(508600001)(4744005)(8676002)(4326008)(426003)(5660300002)(1076003)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVcXnSeJgEWBGizGLY81AFZfwPt6t1DMA1wHRD/GpHztbLnha1DsrOeiPB3l?=
 =?us-ascii?Q?XT+WAvTt90ZICTFGjQtTBn9PBmTi1yt3TlC4PISrd1ofnCpFi7OnSicpSDQS?=
 =?us-ascii?Q?P9jQiO5MSmmxZ7iPYwoIJ90vWAHlKwEbCejQmACifodeF0Zhsrk/9p8WhaNM?=
 =?us-ascii?Q?owg22jmq5q5JeMNd47saLHNiO3TIIvLEw66Ie5jOjvGDQ4LdluO2gLMkxC4u?=
 =?us-ascii?Q?a2GNGzdvaLHRoixhata9IGTI1faHX9SHYCO4w9LtdUJ0p1XyZXJjaz8G4rdc?=
 =?us-ascii?Q?oWNmI33/O4xfz5ziB4/sle/VWbYQYifFVPyNO7o8U617+nC4VadU+rzCp1oJ?=
 =?us-ascii?Q?mIoiPHF7SNEWylsCG+ooWUcdKOH5PPgtMwilO1xzBfuZ9lWUYeSjR3m6YmrY?=
 =?us-ascii?Q?uAVBUaE+Bgm93Jy4C7zU7ddwUTcCjvjGeNnv8cMMkKES975erhzdYQckoc6W?=
 =?us-ascii?Q?2dMmYjC8wFx/OqAeOx5CFkbS3ENB81YzXUKCFbevl4SypYvAdh+rkayEVwE7?=
 =?us-ascii?Q?UCRBvfJ12yUtaVIbU7nLwAoJ3jrKLB3GL34i7NX6ENTQay9tXUCpKFvNmd4b?=
 =?us-ascii?Q?YkuTrQv2Ts+5/poSvGvgR88hIGvKfs5Trkb8ExkoClASMarhr91Ao2rr/AmP?=
 =?us-ascii?Q?p2v9ooQDP7jh9xEeO25JBeMokzrA0hWWxGxAMw5+Z0q6J8b7zVPJrn6N7Iee?=
 =?us-ascii?Q?KEo50MrTI8wDhcvSO/tkePLPrEcxdAlaK6aLkrJf+zpLLoy0xga4tX/lMAcH?=
 =?us-ascii?Q?pebDBJYkmVlkLEnW2ozY3AlYwjwgDYlQboGrmsLT6bvWxbW/o9IftHcxH5R6?=
 =?us-ascii?Q?c6xLW4gHXg8Rix5JGI35yqv1mSWOPfdRz0xFotn7Mi0opHR/mjMj6NKyEXiM?=
 =?us-ascii?Q?eHYUpM/Yjo3xg31EuHO/mUqwZFpZzrMlTkHqHz/0mgKs+TSS6SMbTb3bXADg?=
 =?us-ascii?Q?oyNn19q4CyyjPonHdpNBz9ESf/sB25Gs/COzchUSwoANfbdYAVtOGLVEWTBQ?=
 =?us-ascii?Q?nvh0mqKqpAhIXvdOw0xSe7kMQgiCwvMr4PS7+QbeyZHHY4iAbFuhdM9Hcf4e?=
 =?us-ascii?Q?WUZYLYr4TBSILiV3ZlPbyqL4+zbAcNcxxilxPJPOh7lREStseTTVUt44YOqg?=
 =?us-ascii?Q?iZfcUaA1nvh9heZf7yWfh9N3q/2XkvJvwg6tFXS9JDEvIG9FyUGI/w/wFisZ?=
 =?us-ascii?Q?0g/fMFSnvw5jwxnqbJaRRf1BtYw5V4zMKXbRIHKnH2Obsr6wnRpm/qgm1CUZ?=
 =?us-ascii?Q?DXkEdj/qhp7dQrWewY4QnxMVL9HMv9BDuvSMBTMRPVhGGcYO1f9idbKaYdK7?=
 =?us-ascii?Q?7lA2j7zTjjFbR81hh6zOCrGXe2EiILun+EyapE/L7nCEmJ2aHUjC10W2fTVl?=
 =?us-ascii?Q?coV3kHFtWcWn/eDQowbIdpJ3b9raDMW8HfKqDJ8MSJEgPqMkpsUDoY2iJKaO?=
 =?us-ascii?Q?HEP5a+sVaG+uAKpZw8R1mAE8GpFZhm/xLPm6jQCnCqTZAiNfcczvdZCTBcq8?=
 =?us-ascii?Q?wQBfRTujIV6kIaeELZnEbw4WVPn8BzmHCCBvDh8DX4Ku3/AdFc5WlqojhI0z?=
 =?us-ascii?Q?0W25zoyv1f5QM58qN2M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9b1deb-12ec-42ec-11f0-08d99b0c9db4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 18:47:54.0220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuVahBUW4FYNPKHS29FgsQISlGWfaa1aMQ7EZDF8BmiWWko3EInskMDSx32iQxDf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 06:46:10AM -0700, Jakub Kicinski wrote:
> On Fri, 29 Oct 2021 09:13:24 -0300 Jason Gunthorpe wrote:
> > Jakub's path would be to test vlan_dev->reg_state != NETREG_REGISTERED
> > in the work queue, but that feels pretty hacky to me as the main point
> > of the UNREGISTERING state is to keep the object alive enough that
> > those with outstanding gets can compelte their work and release the
> > get. Leaving a wrecked object in UNREGISTERING is a bad design.
> 
> That or we should investigate if we could hold the ref for real_dev all
> the way until vlan_dev_free().

The latter is certainly better if it works out, no circular deps, etc.

Thanks,
Jason
