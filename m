Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A8D3DB93F
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbhG3NUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:20:19 -0400
Received: from mail-bn7nam10on2100.outbound.protection.outlook.com ([40.107.92.100]:58041
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238890AbhG3NUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:20:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gG7AakmYa9Oxkfkr6sCX2DcU9/DXqi20eYqs1CICCQ/mrxi4vCDmRDVBjo2cSjzZjKxz97CbFpZjE5bbyGa850oenCAUBu5ZG5NCbdJXlMWnRGcBHBNsXVfOhvv4xtdAWlAZjgbv2O/9ud2azKYOvyRGCsPTWiCNFt+6DViahA9UHbCIXKlMPaSHMgDvLktM2KickwwGvPiNQslOgj0RvUCtZxkcWkfC8cw8wU/KasZxqmui+TPpT7Y67tP83zolZPXxhZ4r5wVd2fZOt9NadwiisbzBMAjWk4ZTnBac5SIff9fncOHyJklIDkJ/JjLhgmZ9wsX044gHdOPTACYZsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UU/WURl+Vw8W1fLYEpUbYSm/gtIVorvwwId4TOWKmqo=;
 b=cB27lppHB0kitNxAkS+oqZRcwBynGyblZDxKaQOGtIXhSoW8MlwkvOdh/pjGy5Wbr8ZYpC8lkT806M+Xo8B5YpDi0Z+cSUm8twhNXqxS0I6ZQJjDKCgKSLFacn3RdhmWA/m4TAhZAHFxs/Qb+C5ZhduAJQSJzKGRqUQCIl4ghZw20eVu9ry29J4FyxKid3JAN7X+moSoZplC4x2g1g/Jk6CSuSKpr8n3zOEp8T00oBjN3/P87MWHcAR0VzWPR4IZAlKqnJLyVaqfQ+wH6GcRFYu/VCzMRLqxIE5kbDNSxol+GpeMgVvzAkRC1KRXv6VAMwX8JWocyYuJxNiOOB0z+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UU/WURl+Vw8W1fLYEpUbYSm/gtIVorvwwId4TOWKmqo=;
 b=whkb28tnPY9Y+bReWdjjmtzu4wdQoQy9A0BE0OUbZg8y0PQDUFSwLrNY2sSgvoRFWtIWqG8Cbp0z24wNcpYSmgE1QwlYASYjPROyxeYBvxlq7N9dPzvszk58dYNseyG44epiBvYi62o/69zjpboYBSv2ZUnWksUHLTWrFUm+eHo=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4905.namprd13.prod.outlook.com (2603:10b6:510:77::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11; Fri, 30 Jul
 2021 13:20:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Fri, 30 Jul 2021
 13:20:10 +0000
Date:   Fri, 30 Jul 2021 15:20:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210730132002.GA31790@corigine.com>
References: <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com>
 <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com>
 <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: YT1PR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by YT1PR01CA0061.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 13:20:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d9a6865-0b18-49e1-7c49-08d9535cc1bd
X-MS-TrafficTypeDiagnostic: PH0PR13MB4905:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49057CD8E7015F885B567455E8EC9@PH0PR13MB4905.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfyip7/+K0YidHO7MmV+ODksrezC5MLJt3qT7es6o+156RlIpiu9E6EN2DQCGpVFMD3bd7QV8KXe+99BTE74UjegT2eYx6IAeBu1L6Y5BunGLL9BC6x0QKaEEYA2jARV/qlHVXySkraCsp8UiSkkOVZMaZfVm+8QwG/rximzC3WA9/Aqrwf66eLzgmIsTgUM9GJlG8pr9VyXEUGYLjAWgLkWmR/cigELxzSTzilygKS9Mxq0c38f2rFjcwiqQcavd3YbOJq4gThrNI/HOp4KcU4zjv5U99pTHurYzIBlnkgQriotdVvQguSS6amPWALuIEFT50qyqhWGqj0/767N+rDQNuDVMXcZLdh4ly5L1BK//THtO2dhKSg0sXZBBehFLebsmnaugCdPACFAm8dluZRgegiBLsLGPohniqRSIcJYXwk9REijC/21A2Egr2o+6VgWrJmEOYgRokHskHBnTsOiCCOSwLhBRtuRfty3kmxCMK0ySmKGqky86gBio8R4yuZGKaYHa6RP6QfeFPxNs5rTUefuuUB81YJ2lDe9xZCesmczuEBHT1eMY3240FEdmo2tB/7a7zJo6uNEmGucRrCX66hk5rVXUPxSGizUNDAH272ehdf4GA/Iqyc7t67lZXHJGX9Zm/FhsRk1NRUqrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(136003)(346002)(376002)(38100700002)(33656002)(86362001)(53546011)(186003)(83380400001)(8886007)(6916009)(36756003)(1076003)(8936002)(52116002)(7696005)(8676002)(66556008)(66946007)(66476007)(7416002)(6666004)(44832011)(316002)(2906002)(4326008)(55016002)(5660300002)(2616005)(54906003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pl5kOF0FeDrVO1S3iI0ea3IFy0zYzeV2z2Sy2eI91XT+QKcfXMjqp4afOcQk?=
 =?us-ascii?Q?Wu3oSwNPDVhZeMcqT3AtJ3aiTUexFc8zLc3uDLAxE39aQj24eWcW5V8cAgJC?=
 =?us-ascii?Q?ykZjoZRQRMczK3dXpRN+M2mUR94BtWMp77rB+3lX9dKrCAX3Vvi0Fduj4Lcl?=
 =?us-ascii?Q?GpuqvhRa0OGljfyaRal1Gp9DZaDIx1jQcWCXPorN143kJomMUtDwCV+G1WWn?=
 =?us-ascii?Q?ukKs7hJ1uGa+P4NkuoiNRBerQQEkClCiR8UvFchQfusEEQ+xIeGKRy8vd/YS?=
 =?us-ascii?Q?MbkQaAn5vI9jvKhblxoHX+DyVjZH5hrPyWXLjhlwmagUcj1pMfPseJFZ2SQL?=
 =?us-ascii?Q?5banxLuK/FGwt3mtI4IdfiStslrQY9Po9LSvRmS8rfcvJJJ9QYNBakAPf/vF?=
 =?us-ascii?Q?Gfb8DbiO4ikifZX/mGIN40HHgiubESS6URueaz+4cgiJesV1kOGjP8ISW+nj?=
 =?us-ascii?Q?1dfut3IJ5anNkuGZk++RSPuKubiXoiYhqBHTUiZZi0WKoiNvyeMcjE04Zzfi?=
 =?us-ascii?Q?ClKLWJqTlOBJzGC7mkmbMlQmyHRY9G6W0kwsPsM8WLYe0njKPQB53x6ZOXhf?=
 =?us-ascii?Q?zg5CDVPSgruOb9uGcP4fqJ22lbW4W5K2ct/XVHlW68wev7YLe+qlPo/imNJy?=
 =?us-ascii?Q?j7cEJa8sFO/ohK6uLwtRW4ruG37OSyCNs1hfswQ97LzyzqC0uQ1M+5Eayf7f?=
 =?us-ascii?Q?bgi7cvd4Ro6kvIaEy0Qor3cdt4OLl1I7tPSdgH/YKG5mOgPCAgdYr99bCQ5r?=
 =?us-ascii?Q?Y44TZK2E7JzKft/09fLOk7Pzawdi6qw1ONdx5kWsJP7Hgk5W4mOQ6arTCEZL?=
 =?us-ascii?Q?YChi23tbtYjQ8oLyN/o5XlONotFJ4DkvKW4uXi/miVymSxcLQGks0vWYlmjq?=
 =?us-ascii?Q?O7V6s0T2wby+sFs4mWCqjpoJB9sOoJSTewmgD5YQHctjOmnBWftNYQPQ1C4Z?=
 =?us-ascii?Q?EtBPvj4SzfinzcLvcgWJX+7P9QTL4W5ZOR2aMO82HW8FnySMr9xjuBD4WEs9?=
 =?us-ascii?Q?DBTHnGj3TVis9y8EXA1KzuVNbcqBvZr/t9ZP8KQkRLnHa2ixYMXLAGR/sYl4?=
 =?us-ascii?Q?j5uEc3J9vKW4IpeToC8gWCAZUAiFl+RyEI/wKaY6G8TPl4zAiUYSdqRjU4Sf?=
 =?us-ascii?Q?+i1zJfoG1VT15s6Ey6WxKPqk3QnWUadHI4zy0Qd5tsXfaePCqT7uMjb0LAaS?=
 =?us-ascii?Q?tWF/xaLJ7hoeySg9ZdLvwEZU/grzxRLBeGb5AhZCZyxzjwbEosHiXjh+ujko?=
 =?us-ascii?Q?okZXINScRSI+CnwpgMUz61nW8T/N0VicWYNXYST+E8HnUK6lER4iwPLZ0nJf?=
 =?us-ascii?Q?h1tUVse2q4mu8A0infAOzkmsjmWzPp9Y5VbomgfMahRiLaBIsIuEKCwJS1MX?=
 =?us-ascii?Q?ruM2ZJ/EA18K4WvOBwnJJF3et9j5?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9a6865-0b18-49e1-7c49-08d9535cc1bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 13:20:10.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMtjhjHkIgpW6HIJFRW+OuSj7kz6tEeY9s2ppH4CUpEuU3jZvrqqbl9941bGsBOIX7hD+eq0iERHhUzMdVh6lic5tlXYoJ8+PBo/7Xk+ZM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 06:17:18AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-28 10:46 a.m., Simon Horman wrote:
> > On Wed, Jul 28, 2021 at 09:51:00AM -0400, Jamal Hadi Salim wrote:
> > > On 2021-07-28 3:46 a.m., Simon Horman wrote:
> > > > On Tue, Jul 27, 2021 at 07:47:43PM +0300, Vlad Buslov wrote:
> > > > > On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > > > > On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
> > > > > > > On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
> > > 
> > > [..]
> > > 
> > > > > > > I think we have the same issue with filters - they might not be in
> > > > > > > hardware after driver callback returned "success" (due to neigh state
> > > > > > > being invalid for tunnel_key encap, for example).
> > > > > > 
> > > > > > Sounds like we need another state for this. Otherwise, how do you debug
> > > > > > that something is sitting in the driver and not in hardware after you
> > > > > > issued a command to offload it? How do i tell today?
> > > > > > Also knowing reason why something is sitting in the driver would be
> > > > > > helpful.
> > > > > 
> > > > > It is not about just adding another state. The issue is that there is no
> > > > > way for drivers to change the state of software filter dynamically.
> > > > 
> > > > I think it might be worth considering enhancing things at some point.
> > > > But I agree that its more than a matter of adding an extra flag. And
> > > > I think it's reasonable to implement something similar to the classifier
> > > > current offload handling of IN_HW now and consider enhancements separately.
> > > 
> > > Debugability is very important. If we have such gotchas we need to have
> > > the admin at least be able to tell if the driver returns "success"
> > > and the request is still sitting in the driver for whatever reason
> > > At minimal there needs to be some indicator somewhere which say
> > > "inprogress" or "waiting for resolution" etc.
> > > If the control plane(user space app) starts making other decisions
> > > based on assumptions that filter was successfully installed i.e
> > > packets are being treated in the hardware then there could be
> > > consequences when this assumption is wrong.
> > > 
> > > So if i undestood the challenge correctly it is: how do you relay
> > > this info back so it is reflected in the filter details. Yes that
> > > would require some mechanism to exist and possibly mapping state
> > > between whats in the driver and in the cls layer.
> > > If i am not mistaken, the switchdev folks handle this asynchronicty?
> > > +Cc Ido, Jiri, Roopa
> > > 
> > > And it should be noted that: Yes, the filters have this
> > > pre-existing condition but doesnt mean given the opportunity
> > > to do actions we should replicate what they do.
> > 
> > I'd prefer symmetry between the use of IN_HW for filters and actions,
> > which I believe is what Vlad has suggested.
> 
> It still not clear to me what it means from a command line pov.
> How do i add a rule and when i dump it what does it show?

How about we confirm that once we've implemented the feature.

But I would assume that:

* Existing methods for adding rules work as before
* When one dumps an action (in a sufficiently verbose
  way) the in_hw and in_hw_counter fields are displayed as they are for
  filters.

Does that help?

> > If we wish to enhance things - f.e. for debugging, which I
> > agree is important - then I think that is a separate topic.
> > 
> 
> My only concern is not to repeat mistakes that are in filters
> just for the sake of symmetry. Example the fact that something
> went wrong with insertion or insertion is still in progress
> and you get an indication that all went well.
> Looking at mlnx (NIC) ndrivers it does seem that in the normal case
> the insertion into hw is synchronous (for anything that is not sw
> only). I didnt quiet see what Vlad was referring to.
> We have spent literally hours debugging issues where rules are being
> offloaded thinking it was the driver so any extra info helps.

I do think there is a value to symmetry between the APIs.
And I don't think doing so moves things in a bad direction.
But rather a separate discussion is needed to discuss how to
improve debuggability.

...

> > > > > > I was looking at it more as a (currently missing) feature improvement.
> > > > > > We already have a use case that is implemented by s/w today. The feature
> > > > > > mimics it in h/w.
> > > > > > 
> > > > > > At minimal all existing NICs should be able to support the counters
> > > > > > as mapped to simple actions like drop. I understand for example if some
> > > > > > cant support adding separately offloading of tunnels for example.
> > > > > > So the syntax is something along the lines of:
> > > > > > 
> > > > > > tc actions add action drop index 15 skip_sw
> > > > > > tc filter add dev ...parent ... protocol ip prio X ..\
> > > > > > u32/flower skip_sw match ... flowid 1:10 action gact index 15
> > > > > > 
> > > > > > You get an error if counter index 15 is not offloaded or
> > > > > > if skip_sw was left out..
> > > > > > 
> > > > > > And then later on, if you support sharing of actions:
> > > > > > tc filter add dev ...parent ... protocol ip prio X2 ..\
> > > > > > u32/flower skip_sw match ... flowid 1:10 action gact index 15
> > > > 
> > > > Right, I understand that makes sense and is internally consistent.
> > > > But I think that in practice it only makes a difference "Approach B"
> > > > implementations, none of which currently exist.
> > > > 
> > > 
> > > At minimal:
> > > Shouldnt counters (easily correlated to basic actions like drop or
> > > accept) fit the scenario of:
> > > tc actions add action drop index 15 skip_sw
> > > tc filter add dev ...parent ... protocol ip prio X .. \
> > > u32/flower skip_sw match ... flowid 1:10 action gact index 15
> > > 
> > > ?
> > > 
> > > > I would suggest we can add this when the need arises, rather than
> > > > speculatively without hw/driver support. Its not precluded by the current
> > > > model AFAIK.
> > > > 
> > > 
> > > We are going to work on a driver that would have the "B" approach.
> > > I am hoping - whatever the consensus here - it doesnt require a
> > > surgery afterwards to make that work.
> > 
> > You should be able to build on the work proposed here to add what you
> > suggest into the framework to meet these requirements for your driver work.
> > 
> 
> Then we are good. These are the same patches you have here?

Yes.
