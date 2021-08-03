Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1926C3DEBF5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbhHCLfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:35:44 -0400
Received: from mail-mw2nam10on2138.outbound.protection.outlook.com ([40.107.94.138]:60353
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235443AbhHCLfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:35:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfICvUs9SaCMB0rgNVdH4LLgdkYqKjLvSZZbGvrdumzBWof/vCAOdVT5FNyc1lDoRMbt+qJ0tZwiUZeqeSf2OllvrgZ5CsUrg3FgKtPr7EynWYyo1AFDjLJon5omnckBl9pZ5HNdpJwKO0UQW2hsZny/U4fqFojCfn4d6yX5m8q4zaoNEulDU8d1/DF701BIHgJ+YhayhZCMKyB8iwH4y5B8aL4L4CbEnsv8owInlBvZ8GvDi5GmPO21VLBZN6tWs873XkwXq9D1NDz3YGCDZCAtOWuWnlPsGadB6e9OptNOfU3GHCQcVigB395PLY/yrzkDZMTmAk1NG2JmSUrB2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DekMgFF7Nspif0G7l4LHZ4crAFaagRNpCmMgwpcPwvo=;
 b=nZR0F/RmIsUXF0K+I197JuaBuKYOlgGvDfWPxAZrHVDmAvG05H1SCFWx6O/QW8BVHdYNjgkmXYjSCtElA3h2985miq18J6Cfq1b9nxthle6C0iYEg+laWqKeY/Mxicvr4rCncR3fySm+0EF+zumFmk5NaPQkLZKOPsdY96YS72cl0Pyxt2HuVIf7qcMZlLyi0p3To25WPQTEnk27c74E2rwA3wQQsSbNmVY/GR1G1TKSLzAB9gI6P7rwYrV8lJGCgafPshk6Kv3I+dTeYZqNX0HOuL03ywBA4kd3LUIxspZ/1lJCYbYpBGtutnJbi81fyY0fuj+EEfJAVASVBqSITg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DekMgFF7Nspif0G7l4LHZ4crAFaagRNpCmMgwpcPwvo=;
 b=n+fD3VgyjQtCxzX4nJplNCutwYs2tMHOjpzXgV+Rt0VjbtQTkLV3CUZUliQYfQ0mwcN9PYYPUzXOjVizoM+u91WC+3cmRHRIWs/zsUPyNtp+KYIy+HOOfl7dPrlhpZpW6tkb3a8xK1m8/Yl+38ZO2/ofXn3RJaipMvl79DjKx4w=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5068.namprd13.prod.outlook.com (2603:10b6:510:90::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9; Tue, 3 Aug
 2021 11:35:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 11:35:31 +0000
Date:   Tue, 3 Aug 2021 13:35:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 3/3] flow_offload: add process to update action
 stats from hardware
Message-ID: <20210803113525.GB23765@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-4-simon.horman@corigine.com>
 <f9a130e8-f692-69c4-8183-dc04a5340430@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9a130e8-f692-69c4-8183-dc04a5340430@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0068.eurprd03.prod.outlook.com (2603:10a6:207:5::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Tue, 3 Aug 2021 11:35:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93cd7319-b62e-4a09-ca28-08d95672ccba
X-MS-TrafficTypeDiagnostic: PH0PR13MB5068:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50688573AFC9820D9CD41073E8F09@PH0PR13MB5068.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26W++twGiBBFKwPyoxs39MnUv8I20zqpakQm7Oxcy53FyYMjSmjIgIJcAxg5EVIchZtwNtETBRDtI81jips0kmXgqUkNtBh4scbnFDVodbz8Li6nCqor5s6WNS8DbZ49V9Dl6M30m4xqsjMwusLNchynlj6rFwGv4gHMpvdRanA92bxe5yBCXrQe2YCmV8xs74wRqzT9ZZdDgwjAq+ggr7nqYTeymyLKapZfAUZijwOH+batUqyZR8zsGkiBgRXJ81cPJStZnkjqzBKJoKS5SQUz7mnDX2MsAxssCtmOvNDlC2/8ouE/zlqITGnaXZnkZUirLuRI+Ibu1FahLWZvJA45KEYsBnZrXzxf9qQoygExxFVn39Hq9QHMOzfRTSxjoZbtDZvu9mAc8jquogkzsOdGrVSie3W0z67G++uK7XuQveMMMr4MTwTsdWIQsSwZjmlXyPlUyi5a4H2+nuais60V5Ga91rcL9yzZ+UKQoj++F3PBqOfrqT2dY5J9bWYeFFbAk4IEARNgdn5fU0TCzPJULbGvLMmsp5E1PyHjfhhC/OcqSkX3hJ86MXARQqYaSOZzp10zTedIe9dCIjzYtNtWxEAYPIvQcQsIVjfXxuBjLPtFjelzbOOVJy2dHQy3v3l0/I0/iRigo/hcVh2BIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39830400003)(376002)(396003)(66556008)(66476007)(66946007)(38100700002)(36756003)(4326008)(107886003)(6916009)(1076003)(44832011)(186003)(8676002)(53546011)(8936002)(2616005)(508600001)(5660300002)(52116002)(7696005)(8886007)(55016002)(54906003)(316002)(15650500001)(83380400001)(2906002)(6666004)(86362001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?84Oz78qtM/4ptuOOlJC2/ujKhr3UukuF5CZpY3Vc6fmTIVSCEqugxfYwlXwe?=
 =?us-ascii?Q?8qKDfCLosQ4cQNakgCLmegjQDRE7Sspd+MdhuIt1ORekmoE1PtXR3J0eYKbp?=
 =?us-ascii?Q?EswvUjNuyz9fTNGmF1LFiX3gsakNDSTiVjHMhZ8RK9GBINOYMl61GllfnWH2?=
 =?us-ascii?Q?mlkDSbfcdd9XBca0qecjgaQdaox+iS0muwjBmOzbqQ0Kx9RNU3WacjRaxoZC?=
 =?us-ascii?Q?ecdqBz0dn3xI/n3swUMySM2iod8BrKZbR4cR7tmgFKE0kqF5Usobvqg8UH26?=
 =?us-ascii?Q?8Ux3XcZE6Kt6FafXQYd2/zoArvTnAmdLp+R2pt3NaJkztk9afE6nGgSQ/MPV?=
 =?us-ascii?Q?SH1tA5MMYLF1YVdY7dr4oX6kIvGD3k5idbercIMAgCNYhoxUL74atYgmNpyL?=
 =?us-ascii?Q?rYx9Xt1EH3Sa6puNZ9X2XegJwe7r0kbEWh2cGbHidYK7eViEQwLwRDagBsRR?=
 =?us-ascii?Q?d1TuJPJiHhv9YWAuPTzWQ0kxWkkIg7sswh6bvuNFxk5odFr9Pxl07yb/GXuV?=
 =?us-ascii?Q?88ON+mHzIRI6FozUwn5/998RezOizVoGKg5HQPafoDpPjZEt9QcLNDsNVkCh?=
 =?us-ascii?Q?R1m+TUVWzlu0ZIW7bqsfIf27PtCcCgGKZhWKRHev9HoXexILHghHVyt2XaoJ?=
 =?us-ascii?Q?Gc1kQTgLPaWy6vRG4knA5wKHfG8QyXlHWr2R2dHeVY6Gl9+hMUunJ85VH3Ef?=
 =?us-ascii?Q?SU7CEW2N9mNlx8UUyf4KmGJgUD2qYE1xUifdDIJz45NRKxP7A8OTQj2xaSMh?=
 =?us-ascii?Q?Y5kL94JEvMv/IHj1hKyj1oG7EYf1SX6ZHwW0uFh+wfSPUx1clt6VvcqoJHNs?=
 =?us-ascii?Q?xnwPxS/Dp9+uwN6HiKfrgSnm3J9LDRlTXK9a3m/uDcyGhkaHTBJsdAujFKSv?=
 =?us-ascii?Q?WCp3W5y/fDpvIWBOXpKcYFOwMTs093VyhGp9mUkULt0b/D0BaFWoJBWMlsmp?=
 =?us-ascii?Q?JSwRAWKwExc5a41pKnnaplgwm4mnvZNR5fsw9Ui+3HGdICTLFJW2Y2vVASeW?=
 =?us-ascii?Q?+8WPpOmSdIzQ68KH6Sv+n3FkSOKU3KhCd3bFgGdM8JfNmsTcGC0+a5dlfQJS?=
 =?us-ascii?Q?tFAAghXlmeWs6hXRrajHp+ECWDqv9OKsRc4T6zSYy9YTFqO5o7NkJed8Zy1O?=
 =?us-ascii?Q?LS+L+NpNmiR6ZP97zh/LDVg3NwuNL1LqSByKlrc4/nVlc20ODklyOifmBVIH?=
 =?us-ascii?Q?m7x/WjtHQdFR++vByhGnv6jEswEBP7GlRvuLW24xXkGvG8OVMrENFWfkIRaB?=
 =?us-ascii?Q?rpkG+Adan8i2yv1LP2n5VRiNDo2gq2pl5jk2BmPE6OKvgSf4c2ERrGaJdNR2?=
 =?us-ascii?Q?JzIYy9MDtEz9Ug9Hv50IXezcpoQU/iLBbk3kf87paoACTfyLQGQqw20n+okW?=
 =?us-ascii?Q?t0RQDSDZ5E4xIgkCO6uznjUoIRCY?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cd7319-b62e-4a09-ca28-08d95672ccba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 11:35:31.1864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLIqZN0LX3eS3gTAIrEPPqGcsE6ntrF89oIn0Iq/3dgN1tCTMoN/5THVCNlVf/ovJJ5dAQj0RQSLbw2jkvMJ6xRlM443tvGQ0GMewl8adXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 07:24:47AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-22 5:19 a.m., Simon Horman wrote:
> 
> [..]
> 
> >   /* offload the tc command after deleted */
> >   int tcf_action_offload_del_post(struct flow_offload_action *fl_act,
> >   				struct tc_action *actions[],
> > @@ -1255,6 +1293,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
> >   	if (p == NULL)
> >   		goto errout;
> > +	/* update hw stats for this action */
> > +	tcf_action_update_hw_stats(p);
> 
> This is more a curiosity than a comment on the patch: Is the
> driver polling for these stats synchronously and what we get here
> is the last update or do we end up invoking beyond
> the driver when requesting for the stats?

I would have to double check but I believe the driver will report
back stats already received from the HW, rather than going all the way
to HW when the above call is made.

> Overall commentary from looking at the patch set:
> I believe your patches will support the individual tc actions
> add/del/get/dump command line requests.

Yes, that is the aim of this patchset.

> What is missing is an example usage all the way to the driver. I am sure
> you have additional patches that put this to good  use. My suggestion
> is to test that cli with that pov against your overall patches and
> show this in your commit logs - even if those patches are to follow
> later.

Thanks, I'll see about making that so.

Just to be clear. We do have patches for the driver. And we do plan to post
them for inclusion in mainline. But I do believe that from a review
perspective its easier if one thing follows another.
