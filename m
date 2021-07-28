Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAC3D890F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhG1Hqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:46:39 -0400
Received: from mail-bn8nam11on2120.outbound.protection.outlook.com ([40.107.236.120]:33953
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232691AbhG1Hqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:46:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5LJfz+tC1+jOAOmqjSVSyAuK0pgkfNQMKon/S1EBBqcrMDplDiWIiCgxvdwFRbwxfRFec5SCRwHlnu0G1iTgN4U0k2URcb/anR5D0gkyjXsjho9qRhFlIO20ZpKtChNFPhdY1WUGSbg2XL2m/Ra/faqiaKH4DTeXnmzJ6S9S1p0bL93RBz/zQw8uNxboEQOO6Kic1iL97/X1wDC16kwQtZKetVlf8aPL6XCeydJrvS5qNphasIPf0s6lzV8onB1tisJtU6mvS+f+DOaON58CVtpAWtQG16TnyYAJNAguTJjTvp1xxv/ZDv+zuU268YEXNbXfQXQ2LIztrdLqy5JyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5AZwO9w4/diPnyuz3U3wi289azLhoNWSedPjIuTny0=;
 b=gEWSPFiijSF3cOywHzjWeW7LiINgV4+keW8P+D1DOlaL3yGK47YNJDJO4VSQqLsDX1ZexTX38rdjkN0wUJL+SIrmNh9cjO7Kms/0jTBB9Ye5F7+fJjT3mJ/AnQc2xraY3Sew7V+6fufZSGGld8RKfqBI6ERjxG9BcRRXGzHRbiyLopC3QaqKodHmOa+wiRFtzLRL9RjUQFrETX0SzCA4S3zchEJu6YJhn4sLq2P/TjC5m6XQatBbNdNopUzY5/BSCI1LgCEYD0s4u7v0FC71/5+sVG8jzcG3lTZ6d3roRJg6tWm9dEfYl50Jrvcxc0e7Fe/4x/+Jnm8yf4VVdIo1jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5AZwO9w4/diPnyuz3U3wi289azLhoNWSedPjIuTny0=;
 b=UsRrJMV5H1HMswTmPQrqDeYocscmVcdhsyUG68Ulr2jGRp2uJ1Got4w+2wW6hnsZl6Uz4tyIGdjfZ2iUFy588O/xkEBzBXV6kEpZqauxYITtj55U/I+pWjlH0XqNfcykf+ekyKJ6tX9UANFjRh83WiopPs6qxw89Jf6R/AipKDI=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4825.namprd13.prod.outlook.com (2603:10b6:510:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9; Wed, 28 Jul
 2021 07:46:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 07:46:34 +0000
Date:   Wed, 28 Jul 2021 09:46:28 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210728074616.GB18065@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com>
 <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnh4kcfr9e8.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR07CA0064.eurprd07.prod.outlook.com
 (2603:10a6:207:4::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0064.eurprd07.prod.outlook.com (2603:10a6:207:4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Wed, 28 Jul 2021 07:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37610817-52a3-4455-a993-08d9519bd27c
X-MS-TrafficTypeDiagnostic: PH0PR13MB4825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48254B1D50CA2CD4AA2FD703E8EA9@PH0PR13MB4825.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: colq3Rd4thzAwKCtfkSyToZ7iDvppdoP3cPyjhYBn+glQG+kbj8sMRieqBQk0jBt6zhNBy0F8ToeYoZId6R0/b7vbdt6iwc2M7ZhQiYxvkA1meJarmDXr8NYa0+KRyt515oCM6GySN9hzVDutvVXoyzwhoC3gJfBqUtAf5B3l16SriK8WRZFv6Y72rAThpsTgt8dk9BAWdA5sHhB5d9tQfTOSjyfrxAyvkmmKG9KwteaOYa/Det47HXryV68uPKQoPhTs2yV9Emxn+lO4l8NBDcu+vEy6rC8LoItMAg83IeY8OY7bWL0HKQ2OAfAMdduO5GtQC2okJtGpZ1oL/DtD0NTXgR0437raNWI+RyUVV+CLdZ51IWsG2joHaCYOTj6NMlAb/ORK9295uJhJ853EomqVIFeFuZbva1yhmDLBZ+o9QE7XdYB3EFIuux5iT2Jnln9OzKeD6WA7FEVM90gxA2/TkgxZzm6Ermvzyo91wcSwQShiHUdAFXJSqsq7uhf7PiUvC/Tvpjox4Hv6PdckQkQfMi0iVGTigFoZHEKRW0/IwQ2WoCVDphsyHcw6iNCYa0Z6yKNBEgJjXTOAwD5re7QvQCPj0MV5ikNwjQbvJg9xHaw5Hj4Bkf5IGirE3zu/tMlPQQC6RnMLKVzrfpYvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39830400003)(396003)(366004)(86362001)(44832011)(6916009)(38100700002)(107886003)(66476007)(316002)(5660300002)(66946007)(2906002)(478600001)(186003)(4326008)(2616005)(66556008)(8886007)(83380400001)(54906003)(6666004)(53546011)(7696005)(8936002)(33656002)(55016002)(1076003)(52116002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fNBewhPHxPH/3qe0Afx728A2ErSOreMX2waP9xhYX8sRqFnO6MnPf1wNrPe3?=
 =?us-ascii?Q?fAL9tNI2yUPyVmGGrKCXs6gB/BEvCQ4JvSwdmaKViNKR70Vbc2fXkti8TzID?=
 =?us-ascii?Q?QG9n+WTIneMwvi6tU8OpwUYmLwHjB95wvrnojsgZOesXxIUO17Fv6q3pWhDw?=
 =?us-ascii?Q?0XG3w/J9VA0Bn8HQRVB6SM5A9/+j+CoLsEtpQKyGZXl9Aes1cC2dZdE7GPTd?=
 =?us-ascii?Q?NSufJSd/wwnJ+73CdFIdDYn78ElzveY1d+rmcFPlb2/mw2htjO+QAzklCRWc?=
 =?us-ascii?Q?+zU3A46ssZ8A/xK2JnmgBO6LVHDaFcc5AQSjfjhJT9ZyoxgNfyK96td3GqRu?=
 =?us-ascii?Q?LCyfA1yDGeJBuubblrHBhmNuMNraJdzAco837Lfiqe/R95a6lNF5zcsFYaBY?=
 =?us-ascii?Q?QNpEjHzKe/L9et6AgycQAales5Uh5y2fGZsq2BjfTs6/YP4C4fxK0K8AeJFF?=
 =?us-ascii?Q?VDEORFTVtT/RHnX9SBJ3/1eRmMPPBWXAtAj5bhZOx0RMTQ+WcivvrmHlyuGt?=
 =?us-ascii?Q?7StnHFlRr0U14vrkhwujbywwAtGQhOE9zmy8X2mckQPn8Qh8rSwGsuWKSmzJ?=
 =?us-ascii?Q?ETA+btKcOOScTxII83PEUNzRyIteHFpuwUmBaR45REnru1fXH/OREgBcF2aU?=
 =?us-ascii?Q?8cHqmgoBC0sgyhEozeMRPknJ8odJ8kQcxpwH+8B4Dn5mPyipxXCYmH4EI6oQ?=
 =?us-ascii?Q?39nVoCftbaS5mduzQSGocKDRFRzqWMw5aT0Ng3qDh05LK6c1MGQsEcYswgUW?=
 =?us-ascii?Q?1XkirLWc9YaO/bold7i+BJW10vXpo16zq0FMvC9RL2WDXNl1cWsPDogOKurD?=
 =?us-ascii?Q?6A3X6+43YDyb59dHpNTjr67f9j3Psd6nef2TkFYUt06xniwqLdzW74s2093H?=
 =?us-ascii?Q?n3lRzhrPAxPDUKlWkz2JU5If0XQRmnbZp8zLID3C1JFpYzecjmhZq0BE5S69?=
 =?us-ascii?Q?ps36RZMSyl7ZTKvRucI6YO9PcCEcvKe08UAbNI2t0vbTL5hV/czNboBGcUCo?=
 =?us-ascii?Q?EnwMdaZNmt6eDKr7iiCwv6IgjvHDhe64XeKNzBi4BvIsQa27qg0hB3xZH4wn?=
 =?us-ascii?Q?tZTz3EX3bsTe/ZGrhYYRNyOa1ZqhyyCSb2KOgszi8lgn38MAAsXAZyYAOr2T?=
 =?us-ascii?Q?0QlEJGn2dGVgSiXBjqnfCTjtDSh2DiJ2evZgnIqQq3ChH+Rz+jKvzu23juiD?=
 =?us-ascii?Q?EvW918GuOCvY24TrMh2s/8u95fUEM5gpi3wIejL356PVJKAEKw8cbApPcSUJ?=
 =?us-ascii?Q?s3xJ0obGHZMKigC/u12nIFw4fQ+BBQVyjBtbVyC7a2zsoMqUPEpjyeAIRWyd?=
 =?us-ascii?Q?sH0kKywUWQFzJlwFzqYMMkRxI5qUDmar9GSC2K34VuwRBz5MCmk562frqEdu?=
 =?us-ascii?Q?IvQ1j7UkT2Ri9LGFQyQxlMy6A+gj?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37610817-52a3-4455-a993-08d9519bd27c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 07:46:34.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TikGErlWvcq7pqBBQX+VXF3KsJmiAfI5UK8Ih3DtOsqrTlwoLnlatgzNS/CpLwCJd40xK0Z6tZKOqUfE5n4nxcCyL7pXIzS1TxGh+q61Vl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 07:47:43PM +0300, Vlad Buslov wrote:
> On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
> >> On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
> >
> >>>>
> >>>> Also showing a tc command line in the cover letter on how one would
> >>>> ask for a specific action to be offloaded.
> >>>
> >>> In practice actions are offloaded when a flow using them is offloaded.
> >>> So I think we need to consider what the meaning of IN_HW is.
> >>>
> >>> Is it that:
> >>>
> >>> * The driver (and potentially hardware, though not in our current
> >>>    implementation) has accepted the action for offload;
> >>> * That a classifier that uses the action has bee offloaded;
> >>> * Or something else?
> >> I think we have the same issue with filters - they might not be in
> >> hardware after driver callback returned "success" (due to neigh state
> >> being invalid for tunnel_key encap, for example).
> >> 
> >
> > Sounds like we need another state for this. Otherwise, how do you debug
> > that something is sitting in the driver and not in hardware after you
> > issued a command to offload it? How do i tell today?
> > Also knowing reason why something is sitting in the driver would be
> > helpful.
> 
> It is not about just adding another state. The issue is that there is no
> way for drivers to change the state of software filter dynamically.

I think it might be worth considering enhancing things at some point.
But I agree that its more than a matter of adding an extra flag. And
I think it's reasonable to implement something similar to the classifier
current offload handling of IN_HW now and consider enhancements separately.

> >>> With regards to a counter, I'm not quite sure what this would be:
> >>>
> >>> * The number of devices where the action has been offloaded (which ties
> >>>    into the question of what we mean by IN_HW)
> >>> * The number of offloaded classifier instances using the action
> >>> * Something else
> >> I would prefer to have semantics similar to filters:
> >> 1. Count number of driver callbacks that returned "success".
> >> 2. If count > 0, then set in_hw flag.
> >> 3. Set in_hw_count to success count.
> >> This would allow user to immediately determine whether action passed
> >> driver validation.

Thanks, that makes sense to me.

> > I didnt follow this:
> > Are we refering to the the "block" semantics (where a filter for
> > example applies to multiple devices)?
> 
> This uses indirect offload infrastructure, which means all drivers
> in flow_block_indr_dev_list will receive action offload requests.
> 
> >>> Regarding a flag to control offload:
> >>>
> >>> * For classifiers (at least the flower classifier) there is the skip_sw and
> >>>    skip_hw flags, which allow control of placement of a classifier in SW and
> >>>    HW.
> >>> * We could add similar flags for actions, which at least in my
> >>>    world view would have the net-effect of controlling which classifiers can
> >>>    be added to sw and hw - f.e. a classifier that uses an action marked
> >>>    skip_hw could not be added to HW.
> >
> > I guess it depends on the hardware implementation.
> > In S/W we have two modes:
> > Approach A: create an action and then 2) bind it to a filter.
> > Approach B: Create a filter and then bind it to an action.
> >
> > And #2A can be repeated multiple times for the same action
> > (would require some index as a reference for the action)
> > To Simon's comment above that would mean allowing
> > "a classifier that uses an action marked skip_hw to be added to HW"
> > i.e
> > Some hardware is capable of doing both option #A and #B.
> >
> > Todays offload assumes #B - in which both filter and action are assumed
> > offloaded.
> >
> > I am hoping whatever approach we end up agreeing on doesnt limit
> > either mode.
> >
> >>> * Doing so would add some extra complexity and its not immediately apparent
> >>>    to me what the use-case would be given that there are already flags for
> >>>    classifiers.
> >> Yeah, adding such flag for action offload seems to complicate things.
> >> Also, "skip_sw" flag doesn't even make much sense for actions. I thought
> >> that "skip_hw" flag would be nice to have for users that would like to
> >> avoid "spamming" their NIC drivers (potentially causing higher latency
> >> and resource consumption) for filters/actions they have no intention to
> >> offload to hardware, but I'm not sure how useful is that option really
> >> is.
> >
> > Hold on Vlad.
> > So you are looking at this mostly as an optimization to speed up h/w
> > control updates? ;->
> 
> No. How would adding more flags improve h/w update rate? I was just
> thinking that it is strange that users that are not interested in
> offloads would suddenly have higher memory usage for their actions just
> because they happen to have offload-capable driver loaded. But it is not
> a major concern for me.

In that case can we rely on the global tc-offload on/off flag
provided by ethtool? (I understand its not the same, but perhaps
it is sufficient in practice.)

> > I was looking at it more as a (currently missing) feature improvement.
> > We already have a use case that is implemented by s/w today. The feature
> > mimics it in h/w.
> >
> > At minimal all existing NICs should be able to support the counters
> > as mapped to simple actions like drop. I understand for example if some
> > cant support adding separately offloading of tunnels for example.
> > So the syntax is something along the lines of:
> >
> > tc actions add action drop index 15 skip_sw
> > tc filter add dev ...parent ... protocol ip prio X ..\
> > u32/flower skip_sw match ... flowid 1:10 action gact index 15
> >
> > You get an error if counter index 15 is not offloaded or
> > if skip_sw was left out..
> >
> > And then later on, if you support sharing of actions:
> > tc filter add dev ...parent ... protocol ip prio X2 ..\
> > u32/flower skip_sw match ... flowid 1:10 action gact index 15

Right, I understand that makes sense and is internally consistent.
But I think that in practice it only makes a difference "Approach B"
implementations, none of which currently exist.

I would suggest we can add this when the need arises, rather than
speculatively without hw/driver support. Its not precluded by the current
model AFAIK.
