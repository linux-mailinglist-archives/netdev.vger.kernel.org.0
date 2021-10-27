Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE0843CC94
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbhJ0Oo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:44:57 -0400
Received: from mail-bn7nam10on2102.outbound.protection.outlook.com ([40.107.92.102]:36960
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229447AbhJ0Oo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:44:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYMUfavr1INgQl2C7e2CUUC+zkWMkZSRcEJIkYO9JHFoMa/4mWkAgXJZ0PrUXkqFC6y7FU1nyMg5XFs7YTofY33ZfCmOc1FaHcA2fdN9rl7mmzbQT85HwmovcTROVM5ZovTNoA0g6LumcPKk8thNJ6LJBu5B2C1NPKCN9joFwG8AdUb7Z/wRSphIEY4MNR8Svk0xTSUPfIOJTly6qtp2E51CQSJ95yTjD+4y+Y5Go7X0AIoQNAl9pri7IRvt+iuqo5wjx0bSkQVvRORqNMpWQA8JDCFuXHkHrokf08lOSSgpGuvIgSl/XFRg0k5u8z5bhXcx0cnBGzIEM75pUJpxng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77kmM747gt5RuFvxC6EwIrXcIG0RiwgzzpoIIl3NX7k=;
 b=FAg2jN6n3+z7qg95xqhrnL1Ig9pBcpSu4FIzDZt9exDlMsFd6DPAjDkXLf1XsVpBw1+duCj/ymt3lh30Xq1+CWeRCcWvx3MPN6rKkXw+edvKD+BSqybfZjig0fUioFKMwP+xIGf6nfS1wqq4BXoa7TvI1QmR8Ux4NwEn1GVL0ugpRmS1R3sAETJF1rgohIjh6SlzLwqQuLxQnD0MQLEe3xmgnnkx0YJ8jWy9s/MZzgnUsUVmeD2B2L8Pgjuv5Of2pd8wOXxkDJeOgKR35xrdvNDHp1ab25/dZkiuoPKHb24f9LJqs2hOy97Rl/CnYbKQR1Ma+PJyrR0OI8CxVnujBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77kmM747gt5RuFvxC6EwIrXcIG0RiwgzzpoIIl3NX7k=;
 b=aFq6QY4bdBvb3BpKxSiPBEVA6j/dbzC5SmNllnJqeWR0O7jzZgR3FKhVMsrYWjs9ZaR7fjBRqGFz/lTBGGEqWertkr29LIGM+zjKelIlBTH7y+zvyU1iBsfMpNEXWBTOcniNgQkPWhTKhx1iJ5jtv+jVOqIM5XraXCVsbkIo5z4=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5640.namprd13.prod.outlook.com (2603:10b6:510:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Wed, 27 Oct
 2021 14:42:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 14:42:28 +0000
Date:   Wed, 27 Oct 2021 16:42:23 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v2 5/5] flow_offload: validate flags of
 filter and actions
Message-ID: <20211027144222.GA25565@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
 <20211001113237.14449-6-simon.horman@corigine.com>
 <ygnhh7e0bpw1.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhh7e0bpw1.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR03CA0074.eurprd03.prod.outlook.com
 (2603:10a6:207:5::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM3PR03CA0074.eurprd03.prod.outlook.com (2603:10a6:207:5::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Wed, 27 Oct 2021 14:42:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69f904b4-0924-4746-45ef-08d99957ffd6
X-MS-TrafficTypeDiagnostic: PH0PR13MB5640:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5640EB077A6CC9DD1B8EB025E8859@PH0PR13MB5640.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yHMHYEyxQ8eii1wf1JRADpx2MtJB2yGFEtUxlLMnhrhphVYeX4OhMzr5NumKAfYH7oihbv5OOWd6IkI6elrBqq9I8DQWij+ZIs2o49goQ6ql1vuLJ7zl7OGtZT8yrw6Cfgj9IycMO1SEYPFDdst8aY25zzmFzkHl5dr9tTaM7jJTvYD6WcNB4KG+QlR4Ncjbts13EvIvCmpWZ4cflwzF9QjgsW1NyBaqO6vXcOpaNAa464zZwlRFeNv/3HVVDmEugDIwGbNfytposPMKQcaeIF9QafrfuzLoy9v5MxijzuFaZIAiQfYBPodoqKIgXzZ+yry5idqdn6q8r6Nqf2Jq+SsfXZVSd893sB6vXElzHALNfEfKgUon/Thd/YNzIqs5UKXuFsJvq/PNMfkpvThpJoHLIjOsExWF/YlHjm5FKNa9vW/5jEt/CbsiefbR3xpHcEAc/XGxYto28VNNPc8I6yEcLpU39akkOmu6L4kFqWIo6+sQQU/WYr8M6/jRuI2YklyVBXmZ99NGvdY+mHMd2ZNgNB7aqfQWTkYQaj7LPdlPCJqZpsI5eRnWQgC1gTf0UeFXTCn3yC8GNcMQpyMGH4wnD5Z7d3JCbfcZ/aRO/Jk2oxwZUs0ppDP2r31NqQWerw5To6jJQSk9s6Hhaghw8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(66946007)(6666004)(2616005)(38100700002)(7696005)(5660300002)(52116002)(6916009)(4326008)(186003)(8676002)(508600001)(44832011)(2906002)(36756003)(8886007)(1076003)(66476007)(55016002)(54906003)(83380400001)(107886003)(316002)(8936002)(86362001)(33656002)(15650500001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SquBryWGZJfuTcNTdkWgBystjl3RYOIp12WOVTuDZNrFySlj6jEDyonDiGnY?=
 =?us-ascii?Q?9126E3GlyZYkHCZkTcDU+EQbKvrQYYjtPAqTEY0lwsxSy2bqAYx4ibnFOCpN?=
 =?us-ascii?Q?FXPEwiZSov0jKyEGktaQH4xh2xtqeCjpf4PziOCY8ljH6WeLgEXDhVf7K0ly?=
 =?us-ascii?Q?AXvTnCIvImD0y8KWPRyPen22vjgHoZu/MVM54Rw7s6c24WaPQ61bgm2n+4Bs?=
 =?us-ascii?Q?BmeLrDQAoTkO5/ndUsg0VsqkYYquTDBEo+fEPxZOMvLdNlZAST+rtxJPzfcS?=
 =?us-ascii?Q?peOXLXHcigpRS6J3oC63EY+FdC/DWC6XAnzlY+cRQckhe5y4P4JrkrQEREwc?=
 =?us-ascii?Q?1V0zYCrlikOueGdeel7WQU23arf8816qoL/FAJrboEQIojqeKVvrngHqKPYa?=
 =?us-ascii?Q?6OeOG2PscfSOGSm99V3HkFRd7H5EfMnd6rDbIXKgu6WhPuf40W4/q2OezDGR?=
 =?us-ascii?Q?1KA8d6d7Bo5chVujbjvNhEnCdXX6XxiBgE2fzW9zQyK9UAcJzl2ruRb2krZn?=
 =?us-ascii?Q?Oa13eVFQkMlASUcmJRqOBcFzQcJEEtC5IqhjmM9EBE3OWbFlxLsIEj8fpojJ?=
 =?us-ascii?Q?sQAEfyjRuGBnujbEGFGgpCFezOKnQ8Dyj864aDCv8NZmEjoLb4cbvM9dyoCA?=
 =?us-ascii?Q?AbGvuP3X34BogLz8ZjyX4iYgVjHlm0JQorU2/Z3US92MYWQh1SJOkrCvAHGM?=
 =?us-ascii?Q?atICayO9PYYX/W0fsQOdSV7U8YKKZv5QGtUUqGPFTt1YMKkqfFuOIjaR95ne?=
 =?us-ascii?Q?IHGdh7GEb50CD2GLZfDrGn6ih/fR5eitaVBEoZhojeBB1GEjBrm+TLudT5LD?=
 =?us-ascii?Q?X2WZzNr+75VwB9nHVNVmIAfFlevMKqkEjcQQouTjEfM8K/e+D9IvXxpe2TKV?=
 =?us-ascii?Q?OzXKSsD2n3jKGzLkFHK67TP36ot2nzWvXzGt6Mbz/eH+Y6e2xha0V8C3y0Y5?=
 =?us-ascii?Q?9AcJmGKN0o+Vu2Y6JC8HIwpgGHefN2DC81Ez9PmYbEWJty6E4ff3Wr5sg93Y?=
 =?us-ascii?Q?Nt7RBOw2GEB804Coz4/kLM2A08Ehie9V+KHS8yIGjd1a9IUAL4wx0L2jXQ5H?=
 =?us-ascii?Q?WLnDEBMFTT3Nkw+xKIccKk8rtBx84XlcOfW5NxGdporSrtf31iKTc2Ix2Suc?=
 =?us-ascii?Q?QK/2QMEqWxRdEJNVdd8CrYI/kXOLmQQeLQUui+9Z7bqxOV5meS2gY1u1HzO7?=
 =?us-ascii?Q?1G5BrU19p57jc87GzI48NaCJR2wmNeG7d6k7orxYNI7+b9ExAMhvIyBNAoA2?=
 =?us-ascii?Q?dClzWhrUlQ55M58+9c6rXFKa6tq2RthQAVAN7ptH4eQvtqHfNokuO6IcF6sw?=
 =?us-ascii?Q?dKQokVXRA6vix37GXzy1IycYxrZXh5Y/5AbVRCLqy/ZnIPXtj9OBLIbB4uad?=
 =?us-ascii?Q?DyzudGSq/DdvuqHuZMJn2EdCLdK2V5r6fdDBMIRO9n4culntH+otOewlz4un?=
 =?us-ascii?Q?ruffHdZYOSXfXPURBlIXNMYm2J5nfpVxcQEESRkNukdzZxDLowRTWPv4En6g?=
 =?us-ascii?Q?ITlGLHayte/rfP0X262YlOfvo4vwQj94MfVFgUTTCPvEJDsTujn1xS43sq5y?=
 =?us-ascii?Q?+CqtkIXS/qdE2YUKrRaREz2Q6DskJaTyna1bkdXYWKZOvA4PwdNXYiHtcTRh?=
 =?us-ascii?Q?ANkdw/1UoHmfnSaSKa6z8imb+esvmnu9bNo5inEIadi+Elmo8si5HQwkuBad?=
 =?us-ascii?Q?VAE9391bsS7G+AKXXW61wlK3jFiUKmYyGmptaLQxk+uQZaWoHU1UfM+Zq94V?=
 =?us-ascii?Q?z3A1oj2jCg0Upl3oTvrYSr1bZUIU1VI=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f904b4-0924-4746-45ef-08d99957ffd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 14:42:28.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XyhZtaCgsobBmd4AaA3Boh6eDHXPoghIDr+jsCO0Ty2PUaaz+NlY+3UVVlXfH+iEZEKvEP8yrWYU4j41lP8Ra3p5EOtsRNpsxjKHcC5ppw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Fri, Oct 01, 2021 at 08:45:18PM +0300, Vlad Buslov wrote:
> 
> On Fri 01 Oct 2021 at 14:32, Simon Horman <simon.horman@corigine.com> wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> >
> > Add process to validate flags of filter and actions when adding
> > a tc filter.

As per comment on 2/4.

        Thanks for your review and sorry for the delay in responding.
        I believe that at this point we have addressed most of the points
        your raised and plan to post a v3 shortly.

        At this point I'd like to relay some responses from Baowen who
        has been working on addressing your review.
...

> > +/**
> > + * tcf_exts_validate_actions - check if exts actions flags are compatible with
> > + * tc filter flags
> > + * @exts: tc filter extensions handle
> > + * @flags: tc filter flags
> > + *
> > + * Returns true if exts actions flags are compatible with tc filter flags
> > + */
> > +static inline bool
> > +tcf_exts_validate_actions(const struct tcf_exts *exts, u32 flags)

...

> There is already a function named tcf_exts_validate() that is called by
> classifiers before this new one and is responsible for action validation
> and initialization. Having two similarly-named functions is confusing
> and additional call complicates classifier init implementations, which
> are already quite complex as they are. Could you perform the necessary
> validation inside existing exts initialization call chain?

Thanks, updated v3 to address this as per your suggestion.

...
