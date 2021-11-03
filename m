Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1041244457A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhKCQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:12:59 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:58177
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232101AbhKCQM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:12:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdJ31c4bJ/toVCEhGPaYN0EysWP39+YzsgqJq9AZmWsl2Xhzcbr+ijhkA9sPOtBMMutVQeVJql5Xvz4s/n6EUnLvhN6AVObvyVaHU44QLEJL8xZy7JegJLIbW8CR/CwQHu8LK1hQ423eP2vxJ1LwNxA1xcR33iktoKxbdr0My+qHb9Vw0SG6SMuAdqMEw8Vig7xg4DrKoqnz5+A5+MJQ3dTDIrV37u4AiplE690EhDY+VnODW6Pxa450SQqa/XF/Iofxg1kLs1zOrjmXbfJ01MzWp94F9Wiqd7cgPo+USyUlrEjBgavWoIKqtvAYFduo8Mq8Is82B9P5taHm4bSGSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjSRzzFjsRolrZ6FQgQpoZRwHp0flUA/rWniyDxljBQ=;
 b=nsyW3iz+4rrPybyDMb7xFaWbi6gsDD2TDHy7t0gHYVDsk+DcRcgTQAY5fJLg/W0qobq1e2C4CwgLVSnRKbQxcB1plgrfaKOhWofJNSDnB2K74wjfmH5qg8nHUCUbEdulIAKY0RnzE44z3nHvt4+yyYPfWgZRTtFCoTYRnTAuFri1BhFOpbzBxz1HptneMy613qo185lujtDisBqOyFq3nWd8XTCIhd25edbEahtpTtVKOgmZ/TIVJcDp1JF+ubyL3kywnX0PTByWVRu7M+hymzqkp/xLcjqM79n9fon4xqHzB3EK20tPLMtY7RXMIVsfU5UzRs8Mez5nbnkBHxnTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjSRzzFjsRolrZ6FQgQpoZRwHp0flUA/rWniyDxljBQ=;
 b=WSn/gy2MPl1WL1FFVd9/I228HnXQ4C0cNYQ/pvG+MA6shTq3bxbShT8vZrxu21AIgHFTLJ71ud1a0a0CjxIz2+iYAM37UHt8Uody9DzCYfCy+6sWktV3exgjuHuI9uiz5U3ThSgYCcFxTNQBvkKM2upmaHF2aOO/8fi9aJW27jo2QlWOyMvXbOEh+HwhB4jkDGQQcLPCXhyimspivoVa8e+t6t+ZgMEYFck295xoYd6SSJEaDFRwZrjmitgL+buh1fUXa2XtvsGyvlN0iy2Y+C4SKcOHrsgBOC2u0L/RaYwP+w8zg4qj5j9oKLcNqpuoMWgiWzRfLKHOB7kqfy4xgA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:39a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Wed, 3 Nov 2021 16:10:20 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 16:10:20 +0000
Date:   Wed, 3 Nov 2021 13:10:19 -0300
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
Message-ID: <20211103161019.GR2744544@nvidia.com>
References: <20211028234750.GP2744544@nvidia.com>
 <20211029160621.46ca7b54.alex.williamson@redhat.com>
 <20211101172506.GC2744544@nvidia.com>
 <20211102085651.28e0203c.alex.williamson@redhat.com>
 <20211102155420.GK2744544@nvidia.com>
 <20211102102236.711dc6b5.alex.williamson@redhat.com>
 <20211102163610.GG2744544@nvidia.com>
 <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
 <20211103120955.GK2744544@nvidia.com>
 <20211103094409.3ea180ab.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103094409.3ea180ab.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0084.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::29) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0084.namprd13.prod.outlook.com (2603:10b6:208:2b8::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.5 via Frontend Transport; Wed, 3 Nov 2021 16:10:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1miIqB-005gSG-61; Wed, 03 Nov 2021 13:10:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78cc9c0a-9b3a-4b89-87e6-08d99ee46efc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53909C5B572EACA25AF94CF0C28C9@DM4PR12MB5390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiZjJwRO4mOGfpjoeU7EV0I93CHnKIUVvsMonuT/OzT0o2HOyEoR100zG9SDpeNh73Kr/ntujhUUKPlHeWbe99WQEh54PqMrxt10bxzfPGi8oZqiqx6AiGzR8/WYeMLpss3Bqk2WEBSlhAwR0ns8/S6Oq7iwCJaAf8oMOdpJCuWyCQR0ests42k5ld9aGwsVOOiMYXyMKdf62puQILIA5H+siGOb4mKkm/3oT8ILvLD+X0aBDGEN2QJmIoPq9z4Rjhw6daHzfTeDhKzRh+aOyiDXi5RxuAN2kSKzIzahuHS4MX+T1JNPpGlvd++tFxFTBM7bNSVGCG8IhUsMIj4GZYRxtSuMxyQt3iAkeEeQWgQQFmOv/FTNZYPl2k5gL/eqk5mqK3StzHa2eVqb39SoguYTw2WeHPLreU4Hl0YLnZtRA0x4kXaHExTe9KEaGW9xP3h0Dkf+oDykWc6Cq70cOgl0CPrGVKVXKUKyCDdlUFqk8KypMow9DrUub03a/NNMm3Bb+LRVLfhCYbXKKx4iR+z9E7kbiZciwn3wuDi8FldckAgI7PLs+SEjAEGm5azALb7d0wHUoIWizEeP+q9F6XrzzDbK5cK7ro2Udpf3k9nDEh5yBGmVUJhTTz4Ob3qUDU3enN9cfJ1QsCQYlfhJsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(426003)(508600001)(9746002)(1076003)(9786002)(66476007)(33656002)(86362001)(66556008)(8936002)(4326008)(66946007)(6916009)(26005)(54906003)(5660300002)(316002)(36756003)(186003)(2616005)(8676002)(2906002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pduU4yFYHuNjFXlw7kiN1zCjK0AsaHFNMBYZ7CPjw1t77GUanfsaTef58LtO?=
 =?us-ascii?Q?/NrRGQ1+a8dGEw57nlTL9xtztujn2e3N/jb0QueGVPuGGfKYO27XWOCS/kN0?=
 =?us-ascii?Q?6kdaQHS5FUriYsTuZXv2r5yjAA7UKkYQajeqcBsF1P8gIylDQlJmyigXnviK?=
 =?us-ascii?Q?tNs1EodrqXHA/+KUtMh1o40p2ojccDRBsJwz6K7u9ZO+Da5kxA00EI8MOKy9?=
 =?us-ascii?Q?eazsJMPlcBXXsjmA21/VE901TAZVf473MgPtB8O6c1vcA0dJs3bevf/HK7dr?=
 =?us-ascii?Q?JhsIMdTAkumA4r2q0as5uUDj/4LMki1M5okb5XlcMCi19UsNOcf+DjbERoDW?=
 =?us-ascii?Q?BZRXDHuBjDsFJJ3SXLNHRznbgNfzspQb72WuwWy3oewlxkbeVRX4a9qN8aQj?=
 =?us-ascii?Q?0Z7WyBC8wZq6YzpgKhL5LHiJR/Zl2pwta3jh3c1BddTTKLJlvzyfHtSZSQUy?=
 =?us-ascii?Q?QmmwW0W3rXvxaofZiCNEIDMKRExUzDdTZeou01KnklsQl6+lOdIhiA1qx9mU?=
 =?us-ascii?Q?Yg2pl5F//5A0/MrDXDURPPItXBnqgy63JpWXQfKlAokSxFac08+rvOwNk91P?=
 =?us-ascii?Q?EF+39lI7YZW7JqH5VT9PBLLzaKgTkq5qUscwSmQJoaeWz8G9CJWcFMsOL49o?=
 =?us-ascii?Q?DDQ1nQiCXgi5eUf3A0jpaLLGL8S9pja/mGJP87WUu+Lojp1VejE982HVVVoF?=
 =?us-ascii?Q?wdErtH+LJoOzD65gkPm7kL6NcKRYCh17rLkD2b9PeML70T0YAvRGylRC0/ag?=
 =?us-ascii?Q?BETQBw3laMlMJNEbWEhH/6ssNWI9eucHiOIDwtViwVDJsO/d2o837abxUyuo?=
 =?us-ascii?Q?M/+JUcOT+33EXDB3u7IOtybRyQ53TStmLNxjAG5BkYKl+5BebYGfwXUZqbN/?=
 =?us-ascii?Q?GlSvmYxZ0HM8WLOzYuaVIiUlhxg/4HmeOgWyd/FGHotuGoSY2O8TY/3857Pq?=
 =?us-ascii?Q?yNssoRHtj9qTCbMWARdi9JZzfy+iyeqJ1ORiuyEnZp50oHLZtPerXkIKiIaE?=
 =?us-ascii?Q?AJuk2Z+2QAuymhEw3sTB5UL9+D6GRiHed5fbFlOynKKaqMmKYoaYzwrDV5O9?=
 =?us-ascii?Q?RhOllnOiOf71i4XzRno3TrWAkWY8nwMpQ5Ptu6EgzJLlBrsqSTQ4AvmC5tUw?=
 =?us-ascii?Q?JGQO45qdxy3RGmgM5mcv33/P8jDFXonMsjsREzzF/7oWu8pdtttvAaaLKzCb?=
 =?us-ascii?Q?fkQn8qC3lChScnd47QA1P90do3fQQZ1QsoCcZkb2EsBxFA3KH/Oi4Gzu8XMr?=
 =?us-ascii?Q?5GAoHtsdoXaWPoVYL3LPMxkkvl7pLOU0RZULxfxcpkcMf4kZJnQsNzRTIQ5H?=
 =?us-ascii?Q?Qh4ZBcuTyaSI2Qme5KdOkPZ03a+G6fQf1jC9SJkG4QQUPnuUjOqqHX2+9pXE?=
 =?us-ascii?Q?AtlJqsxdZDIDbD6HmGHkELFmYES3yBiq1F5BAJr1m9Oc0VcdyPG5E1PYZ6uF?=
 =?us-ascii?Q?mrGGpMAnSQwPocV4vIY/pFbuaErEyr+u6PogX0zv18JwinFyeQWa4AldH2Uu?=
 =?us-ascii?Q?Q/gQSqKEmucLlfbGytwAed2C8vmu6abwEtWQn/oSHGZ8IV8lc4ZNI4ZGM7gG?=
 =?us-ascii?Q?sxYq7Up/sNIiAeWNBx8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cc9c0a-9b3a-4b89-87e6-08d99ee46efc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 16:10:20.4736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4B/hlEeNXpoYjVToltE/rj2hhcxX9np+Ael78rrbLD2JWtzlaTh+rO2iaFSkxm5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5390
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 09:44:09AM -0600, Alex Williamson wrote:

> In one email I read that QEMU clearly should not be performing SET_IRQS
> while the device is _RESUMING (which it does) and we need to require an
> interim state before the device becomes _RUNNING to poke at the device
> (which QEMU doesn't do and the uAPI doesn't require), and the next I
> read that we should proceed with some useful quanta of work despite
> that we clearly don't intend to retain much of the protocol of the
> current uAPI long term...

mlx5 implements the protocol as is today, in a way that is compatible
with today's qemu. Qemu has various problems like the P2P issue we
talked about, but it is something working.

If you want to do a full re-review of the protocol and make changes,
then fine, let's do that, but everything should be on the table, and
changing qemu shouldn't be a blocker.

In one email you are are saying we need to document and decide things
as a pre-condition to move the driver forward, and then in the next
email you say whatever qemu does is the specification, and can't
change it.

Part of this messy discussion is my fault as I've been a little
unclear in mixing my "community view" of how the protocol should be
designed to maximize future HW support and then switching to topics
that have direct relevance to mlx5 itself.

I want to see devices like hns be supportable and, from experience,
I'm very skeptical about placing HW design restrictions into a
uAPI. So I don't like those things.

However, mlx5's HW is robust and more functional than hns, and doesn't
care which way things are decided.

> Too much is in flux and we're only getting breadcrumbs of the
> changes to come.

We have no intention to go in and change the uapi after merging beyond
solving the P2P issue.

Since we now have confirmation that hns cannot do P2P I see no issue
to keep the current design as the non-p2p baseline that hns will
implement and the P2P upgrade should be designed separately.

> It's becoming more evident that we're likely to sufficiently modify
> the uAPI to the point where I'd probably suggest a new "v2" subtype
> for the region.

I don't think this is evident. It is really your/community choice what
to do in VFIO.

If vfio sticks with the uAPI "as is" then it places additional
requirements on future HW designs.

If you want to relax these requirements before stabilizing the uAPI,
then we need to make those changes now.

It is your decision. I don't know of any upcoming HW designs that have
a problem with any of the choices.

Thanks,
Jason
