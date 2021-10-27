Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE843CC93
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhJ0Oo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:44:56 -0400
Received: from mail-bn7nam10on2102.outbound.protection.outlook.com ([40.107.92.102]:36960
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238869AbhJ0Ooy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:44:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdocVvuo74X/OQ5CneZhnju5QK0Szv4KGaBuTzznWn1q/mf5uESjzBuLORGYxrJ45QTV178eqgASvoMGxFKoDFLqhipvzqIHP8EN55PPrStphwDvqGVOCDh9pQPdlOBjFPKCkYGSvvmgRK1Uwwzk+JG1SghnYBwL7B0lhkwxnJ3tN3UHo4HcP5wiCPXBTY5nMZjfBW5A0UffI6OIUmBTWF0GW5jq6oHBAXq/WgLj5aKtXPVqY1dHOlKn6sYfotKC5jwqKnkNbIHpMB+pa1Ry/PJZQqzsJrrFzsyHqgQhgDB8rSS1BovvgxK6mKCTK7lckaY1oAej9JCpHXpCz2vt1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fdl9Yf77Oqz+2uxSNzV+UCo2Avw9/dzoMjmDVPzkr6Y=;
 b=NV2GZhZ6YSt2LELehEDrGFN4EvI+/N9bd7rnnuKCBkIo6EXh5bgEBk6DiwEtu1L7ShpvPiICucACsjpCNDp3vq3k7ETKKxQ+OHW4s48Yk7GQvPTGKnWoIwtdEMSdXbBB7Qqy5eP5XN24CM00Rj5d2DgmBwA7q+eH9kri/lHXAlHMCEaLa4e4z8c/sF+CXhul3l4tqZ0yhntxOOQXXxOFCC6ltGsO8LQO6/aYupZyOPrsAvxpzzrYMWYgHbNzEKoFQ8FOSIY6T87YR9ijQLp1OidvjNScyLpNoGtwNe/vfnScjuQvlrgJIJk7pLuiT8uN+LhnOWbD6SQVYeM2BVAB+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fdl9Yf77Oqz+2uxSNzV+UCo2Avw9/dzoMjmDVPzkr6Y=;
 b=WyKyAizY4Tm0AHKTIxoKI7rgGeBxiOf0aGIHmTnIyi4Bk78Q9VPbh/JCzNX7e1Y09rY7WtlgD0PC3RZUFeo6xMXwya6T/1QAhqnndDo7jqiurpW7iYEBr5KYkuBjcRyxkog0NzgDF6xizaWTsEg7QGN5ByJWByIh0otAiRupP8Q=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5640.namprd13.prod.outlook.com (2603:10b6:510:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Wed, 27 Oct
 2021 14:42:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 14:42:27 +0000
Date:   Wed, 27 Oct 2021 16:42:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v2 4/5] flow_offload: add reoffload process
 to update hw_count
Message-ID: <20211027144219.GB25471@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
 <20211001113237.14449-5-simon.horman@corigine.com>
 <ygnhk0iwbqkh.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhk0iwbqkh.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR03CA0074.eurprd03.prod.outlook.com
 (2603:10a6:207:5::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM3PR03CA0074.eurprd03.prod.outlook.com (2603:10a6:207:5::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Wed, 27 Oct 2021 14:42:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 018c970e-f963-4db4-2103-08d99957ff5c
X-MS-TrafficTypeDiagnostic: PH0PR13MB5640:
X-Microsoft-Antispam-PRVS: <PH0PR13MB56402A1500A9C6893D60BDEFE8859@PH0PR13MB5640.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkoxpbW3i6vMHgjRtaU4o+g6+DJvFRzoUXsxCl6xlhX3PFJU92OU7R1oeTVkgfV0zy6JbJ3J0/0ixKTnhkyax5W0IXp9iQH4SR/vOJ86GX0wZ7QFd+Clfvn8KovYxH30pZ+WGoJlWXRUm64Fm9SISOaLjnUSldY4Pj+rfCsq5brGXByNS+Get8BxG6y5lqJfSDGLJy3LJsOjOeSV3EsZcSAe2rJfxbNOtBZAn/byffYLLkadbplkkUsbanBqDHs23fGNb8or7BFNdKQ6qtDPoLotkdvp37+ASQcRZUKjYBCjQpNqDE65d1+qrAqYnxODsxVFJjGpDUY5PIJzp692kK91Ab8uDxuhbBYP4SRU7UltlFJmMCKjzf8LdRq7d8Pal3+VVwsECvlO5dz6Fjx2fIRxLOGfsF5YC1Gnfat4+3nLgMBteM8+R/cNt4mlUTJxhjYCfFMRviC9YBZ1b2w3fQPh2WbD3mgP/PEK7EHd1Da/Db7z/LLpE9Ncxsy1gnRAPVUhkCRBFoWzxX2ZH9j6z06v2qc/ReFgGR1ksvIySmQnz8jnqgij6loawqDn/Kui1hShs76O3XU0yhbPi1pBvuS9eGK6T8xdDdMwh6F4fepaIVa/agx2YOqpatHNBYXO/iv4ZtA7LvBTPJ4WUK8Eug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(66946007)(6666004)(2616005)(38100700002)(7696005)(5660300002)(52116002)(6916009)(4326008)(186003)(8676002)(508600001)(44832011)(2906002)(36756003)(8886007)(1076003)(66476007)(55016002)(54906003)(83380400001)(107886003)(316002)(8936002)(86362001)(33656002)(15650500001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MMcKPsv8w6WVbyLzPZyTtco1fc9BtFkPvchD+2DbTzfojyWiilJ/N/4HB3OH?=
 =?us-ascii?Q?UDYQVjVFAtNgS26QIQrqWW2iUH2rKg+8AzFvUvuuy0RmL7jB0MJA6ilpnSDm?=
 =?us-ascii?Q?I5WNiPJjhPp2RWugASG/PcB3cg3Dt9r91a6EgE+oQZ+cmp8s8mIBJktOpiqd?=
 =?us-ascii?Q?b10qhrvaXEBMuZdGN/ONwiY9dD7+ZVtkyZR1tiirHmRzgaRGTwsu3vJ+Ffio?=
 =?us-ascii?Q?PebfBasVhOdIXJ9tnVtXhZORTmVJj+7MxUZqa5F9jJhoUDAJMr2YpZKG5+Su?=
 =?us-ascii?Q?wBdM5BYmEB1sc4FKdx5TR7x2v1tpR46fk1MPy7EEdY0iHU9XoFTO4vfnC3NB?=
 =?us-ascii?Q?BJrsO6xETge4b1O+9nTbz6erXb/HQGGXnBnvgMUPPCCerOqW7owqSYayrK53?=
 =?us-ascii?Q?kzvRJUAPfVc3OChPjv3JYcs8ag7SfvTPzNUb+7QoPhFecvFKHf0KclMcweEV?=
 =?us-ascii?Q?eUYhWwtkvZZLOZo69QrqXG+lGG8hWVNY1alAkfY3P+ngOdw79UNwGZ92RMg4?=
 =?us-ascii?Q?qTocTOHe0yCr7GZQ6Sfss5+2bX/FLV+80ah2/DTOIegG5WB3/UAlUwQaTwNo?=
 =?us-ascii?Q?b3NskNqz2WjUIH3im9312pgJhRUFhyqvIC/SFDjK3QRuAYTgC4p3bBWx7PgI?=
 =?us-ascii?Q?x31wz54kr3WD1pq8qRHI/gnysaIxyIycpQR3RsFp1oCRs8BAieHLQcpl+bdZ?=
 =?us-ascii?Q?oRDwuy3E2ieFJprpyebquuaDIIFbz+xbNPeruOCw1zRQOmyDINlTpwERKVy/?=
 =?us-ascii?Q?lZ2+yqqOcHWn25l7ss7SWfpWCF2UpmZMoXG1GX3RLfC946yN/6CGJkaHHs5X?=
 =?us-ascii?Q?O2E3f0O2/0jT8r4tpPZ3R/wCU3YZn4n6vtBRpl7I5g0/f1s5RfyVLNqZpEN7?=
 =?us-ascii?Q?PLud4iKVFk0iomw7E1SCYg5Adco2he1sElpYutltO6ZWsKkxAYFOrA+o6vdI?=
 =?us-ascii?Q?kE++WRAba55RQhROvh2cTnlT2xpxmRTUsfevdU/Ns7MgygUnOw5UBcF/gX7I?=
 =?us-ascii?Q?QkSD+QAhH46VGfzyEylr7NBS/VQnQO+QEolIKlxqS4eDlyLG85Mw75RmHEJc?=
 =?us-ascii?Q?eqwTTy+dCLvpS5KOXiIwBErkYUZfudfof/uZgj3yd6CAX60A4+XEkpFvfPS7?=
 =?us-ascii?Q?mq2Mua6hdxfIiaPM/rXwK4qy9BOnl80EzPRv+LUfVdYEWPSHpU9P6IQhgGvA?=
 =?us-ascii?Q?YqCfsTrSBNnzSVkAtU1QnXmSe4IbzbAPd4Bfe/RYCVkP8oniqadu6I5VmBy/?=
 =?us-ascii?Q?8nBfOVi1FDNtBLGtXsFTcwRfsQphbS/qkXGyZtjxNlrJtL9TpEx9VGFMSxvB?=
 =?us-ascii?Q?I6axjeKj/do13etYSJDjmMtZ5iUQTcmTQGvjXdH/nVmg5NQMhyKRJHEMw9pq?=
 =?us-ascii?Q?vpUQ8S7Er4XarlhJqepBLRGwUQuEP4scS3Wetr9OB3KXndVOFQ4s2GT81f+S?=
 =?us-ascii?Q?OIEV8OcHfrhO41fCEQnZWHFY34SSzxr8kLU4P/7mLl2Re+VyQHSGvaHsD0LK?=
 =?us-ascii?Q?ed8G3ed4GZsion3l2Ytf8DzImf3fCUohtZ+1r5qvPSdGRaipp6TZRqDUhlRL?=
 =?us-ascii?Q?zCe2sf/8cBhBY5MX5u5vLv97nnQyPD70G6kh8RKd/f2zdpF+6TSVFi+xGzg6?=
 =?us-ascii?Q?ev2WWDjyRJn/b57YbyVwnPiIX9zhaGAu0kAuTi02sPmxk8iKCa30xj63udUV?=
 =?us-ascii?Q?urYOrv9zvzz5jTF31FhaSbZfw1+kHIAeX5IFXlUWu+KdT/aVKCiMSM8iMlXl?=
 =?us-ascii?Q?qp3nOUa//l+VnoUK0HVIJ5FaF0KMAk0=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 018c970e-f963-4db4-2103-08d99957ff5c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 14:42:27.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/0d3ukU03tN+olQpjKodh4IsNpUWbKTiqwEDOb+XnTC068ZKn7LN5uEtSErnIchw5nb0lOGk1yIoaCLgHkGDxy/XwzGX0p1pVikZmqlI9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Fri, Oct 01, 2021 at 08:30:38PM +0300, Vlad Buslov wrote:
> 
> On Fri 01 Oct 2021 at 14:32, Simon Horman <simon.horman@corigine.com> wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> >
> > Add reoffload process to update hw_count when driver
> > is inserted or removed.
> >
> > When reoffloading actions, we still offload the actions
> > that are added independent of filters.

As per comment on 2/4.

	Thanks for your review and sorry for the delay in responding.
	I believe that at this point we have addressed most of the points
	your raised and plan to post a v3 shortly.

	At this point I'd like to relay some responses from Baowen who
	has been working on addressing your review.

> > Change the lock usage to fix sleeping in invalid context.
>
> What does this refer to? Looking at the code it is not clear to me which
> lock usage is changed. Or is it just a change log from v1?

Sorry, this is an artifact of our development process that shouldn't have
been left here. Please ignore.

...

> > @@ -44,6 +45,9 @@ struct tc_action {
> >  	u8			hw_stats;
> >  	u8			used_hw_stats;
> >  	bool			used_hw_stats_valid;
> > +	bool                    add_separate; /* indicate if the action is created
> > +					       * independent of any flow
> > +					       */
> 
> This looks like a duplication of flags since this value is derived from
> BIND flag. I understand that you need this because currently all flags
> that are not visible to the userspace are cleared after action is
> created, but maybe it would be better to refactor the code to preserve
> all flags and to only apply TCA_ACT_FLAGS_USER_MASK when dumping to user
> space.

Thanks, we've cleaned things up as you suggest for v3.

...
