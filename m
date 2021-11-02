Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7C24433FB
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhKBQy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:54:27 -0400
Received: from mail-mw2nam12on2093.outbound.protection.outlook.com ([40.107.244.93]:51425
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235285AbhKBQw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:52:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKE3WENGy7DpKrOLtUkNhuuxGA0u4FCIwlcf5S7943JKEWEnniGe8IpwpJ3TVy7LFL7/5fDLNMk0yG4+saencibB1XbmVIrzOyeQ0gF0wKABlGGQYGdZtektCLu8XiUVsprRnhm7nDUlW4ZBKHzg3asv7x9tzkOVdb1SfsIIdPCT5UOntHjDFvNkE+ABaJ6fYLcXVLECeaeQxc2RjjndmwEYflCx1ECfeto6duhe9t1RfSR0jAXZCnY2HMfKQiYt8K2OVxHhTuzcUNQBsMORadnodYfOMKgFHEyQboXJFab606t/LXdYoGU9BYvI9FojVvWYst5QHdR8KNgBOI9GfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBHJaq+NMEDg6TZqVLHtdEQ8kitlrnpLUvUENKhPXww=;
 b=LZ3j8BkXm9OfVnS/kyVFdJ4SEkj2P0UCXHj+vqxYU6BK6NNXM6j6w2jzb2BHExWB2Y5R+c30uTqAyKnXGhQI7/YyUEYdYDPUzUSqZ//OlvPTIrLFJTAvxJBkD+dmChQ5mXMNVO6uR0fS2XzlJCYh9VHjSSRf7Vl5N+5IhzDF74dvjNSzNLnTnogcuWoExPQwCZ97MYsl3PsmSMH7RNZagBrjN61s3GFjKIMKsDEExoFLo4ATic7l5UjI/Knm87L9XOslzWBaePQ34Kw8SuPl6qLsO5H37XKICHTx7kZVtokQ9U1N1iYj4E22zo6BTpbR3dJOuiuXy3QFzvlwEF58Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBHJaq+NMEDg6TZqVLHtdEQ8kitlrnpLUvUENKhPXww=;
 b=YhacJdrxC9ohkRMy9r3zSJhcFRoEDp9Ux5dEuOOeen0kgH4qat/3DvXphLg2c/V6ktJsPDIVT+WHPvMfE3HYhF3eBVAPAfZZA8O46I9L3RJjcXf8dak5Ph77EY+WqK87ZZPlHGbYEg2e/zPg6SZIHeRCa5mNAl9YqTkJDUJ22ys=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5575.namprd13.prod.outlook.com (2603:10b6:510:139::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Tue, 2 Nov
 2021 16:15:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 16:15:25 +0000
Date:   Tue, 2 Nov 2021 17:15:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Oz Shlomo <ozsh@nvidia.com>,
        netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Message-ID: <20211102161518.GA26566@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
 <ygnha6io9uef.fsf@nvidia.com>
 <20211102125119.GB7266@corigine.com>
 <ygnhzgqm8tdx.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhzgqm8tdx.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (80.113.23.202) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 16:15:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80df02ed-95f6-4dd3-b20d-08d99e1bfa64
X-MS-TrafficTypeDiagnostic: PH7PR13MB5575:
X-Microsoft-Antispam-PRVS: <PH7PR13MB5575D5C920E80B96594E27C3E88B9@PH7PR13MB5575.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2MKGgWgifmDoycXhX6OSfQzRj39//5ew7p7fBIsZakQ8TImV9lUQDKF4TWzh8gZUtjuwV0cwwd/EPIJJQC1ZOerRT/qoyJjG2Id9tuKZEW61ZFFWSRatrEstUBpmMQZYkHxaHRDxjdoTUNVlHFgQrVa91peIpfaEsidoZaeqbdo43BvRB9U2y+NeV6wExz9esmkEmSMHSCKW3BN5C1P37H+1ODj3f1aRanL3YuDzihWAV14giA8oW+iJuMUAyK/87rp6To6JKx7iq7hLzlYllbRjF0vXE4yGXNpyeB9oJ3GFWaOyhBJZR03xMLqNwle0jG6fEBnWC9Nem5DzChll4eVG0Xxrlwz0iS0+UlStndVpPei1lKoeDYCuhLmnoH7rJH3DEfWzL4GKjP++KY74QWPvlD2PfJDNF8nUxXb3PFpadpmodiQ97kERux/evEAw/LWYhPnPqSQcr1fdKKVRGRrBvZtj03nWsTqZbxX1swCKJeWSaFb8OIP8uY2q+TjT8Jky9YEVc+9fhnkNBS0Mzf9ff3doRiSgqO+1+27nwlgeV2sRcmbSSUgy/99mqgO7uoWYmWnRhsdbCLdSYWYfLPiIL5cXLdVupKtvp7V7FpKyBLCzXu0rHkUqA39vIQ5WjzHVEP0xkuTByt00zra3oGTvaFMCy2/B3EN6C/jP3tF+nZOtd3bin32BBbhJo60nRcQMYlIg0PMo2SFGZr8Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39840400004)(396003)(52116002)(38350700002)(33656002)(8676002)(55016002)(2906002)(6916009)(4326008)(8936002)(5660300002)(508600001)(66556008)(8886007)(956004)(186003)(54906003)(4001150100001)(2616005)(86362001)(7696005)(1076003)(26005)(38100700002)(36756003)(6666004)(66946007)(83380400001)(107886003)(316002)(66476007)(53546011)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzuHqJkxmBIIytkJam4reCE8GAnnK1fplL0kDFreccC/g3M3Bkm5prOoJbnP?=
 =?us-ascii?Q?BBdqqv396QjwsLWlHzz8U29yt4fgwSVWTo7N96rIUD9AUxd26vZyqu2qfb/a?=
 =?us-ascii?Q?ciuXIo+qa/2D23ZD6LV6Hyxt9rqyyw606UpVszHOl1aFUCHE21yHNn8jCMu9?=
 =?us-ascii?Q?+QOj/MV68kvkygoAUxIR/4yxP1qR8bpgsFDRkgME4NCECw6roz3XauxjDhhB?=
 =?us-ascii?Q?WK883IadvvmlihNBu1Ht0C9lffUUYxaic6mUz80hbGKpT6lcvWkuQ2+wBnQP?=
 =?us-ascii?Q?FAzS//DaeIt4elSLp1OQjjnzMpy1D5iGUX8sNaVG3uDL5WlNc+qq0d7n1eZJ?=
 =?us-ascii?Q?XVYrmIhy/FSHZT9zJKAhouVeCx7GlZIj2cHV+6S4+NWsvKQk5wEdFP/Jea4+?=
 =?us-ascii?Q?OTFtHozXHO6sRagCj40dRoYeC6kxmsjC2MzXWyQecWUMwaPl+qjkue0jI2mc?=
 =?us-ascii?Q?Q4qntrbv3mOo/yutJRMFAXVlnYcwC7HEIf8pWD1H2udnZ4wiR9xyT+RgbOvu?=
 =?us-ascii?Q?FVH9rJr3FxLgvKHaUi8KOowbCKr7CIgTSto+M5zgTtrA+VGpSrnU0vwUPXGI?=
 =?us-ascii?Q?9reD6IBeAPEH9N3eGxsFEHtZt8NTznMM1+zpik+eNaPooy31eSj3CTGNplug?=
 =?us-ascii?Q?cLgUvZtYSLJJGdmCZklq4cPblR25qTrosrqXgfOGdL0QugvOQzlFi27Yf9iG?=
 =?us-ascii?Q?fgKpu6pgJ2uAO+UK58r/7oir5ktfI9EENWRwSYBLJk052l4gT5JvULbGabhS?=
 =?us-ascii?Q?pmNWkODQNAtaImOwOtixti81TygGpbWW59zPAvTHSjp9h9P+5ccfyEvBPlrQ?=
 =?us-ascii?Q?tn4qUzdIuF9Feo/ddMMTkps4IS2TAlXPDDUz9oVQNYqXEJD+ZZYFe4e9ikoE?=
 =?us-ascii?Q?Rxg0S+riyCLPfk407DDRL5yLosx4V/GJyn8JNva1MRAlYbU2ILbOfs/W83g9?=
 =?us-ascii?Q?3ZkZ158nHzqkI1UTuoV7D1n5aaaUeF5J38zw0hh1jHh+HLcJ4GP1DaOJND7R?=
 =?us-ascii?Q?NGenL47tN2Zx9YSzwQtmm14NgfFGVm1yLxVJEwSswDoluIcCnsyhvjwYuYqC?=
 =?us-ascii?Q?u8lAcl4ZUyk1wkmRMN/woMrWbqrk7o6441agf6+QAhEyUQIMzKCbdUfmPJLf?=
 =?us-ascii?Q?vEfidO7Gi7NohVJ0RF89f/PieDgGmMoTG5cAurba2PPwrC/iZaIqCKrPdgAT?=
 =?us-ascii?Q?9gMvhKo4ryg9yXyTfQvoyYn2jsR3JlfAkgXrKiZ+Vs0nHfDK0ynV0cQjsW05?=
 =?us-ascii?Q?eiI7FIfdG4WSyaZcabPT4L95jIgdTidbOhbiYVSkQD/8XBLZxRQAgUKJWdXu?=
 =?us-ascii?Q?wrQqI7z6x3E1a2p1fKJPpV/UfquIpRdYTnteDRXKGQHHyufTTyZduDeOPJJE?=
 =?us-ascii?Q?JWEZnitiqvFWtNYKfahPczrh7peVw3B2mjk+jwl10UGpGEVleiwHcR+AhpEX?=
 =?us-ascii?Q?j0J6QT0bvlVYiA7/Cfc2XvBYEly3d8mZgLXx2Hj7mgLG6/SBX/nsQ4Ry+MDQ?=
 =?us-ascii?Q?Hu/cD7TYih0Jl8ldSX4qOJSEJt+H7B4rJOUObCwf0hrWHiBXVl1N2JTB2+Rj?=
 =?us-ascii?Q?UvEiShlhjFJ2iO3/MNQ2LR1fXkAUPbct+Q+AhGVkNcondh6wrnQwAaM6JbtC?=
 =?us-ascii?Q?rYhN/z4Ttjl0tSMMpNYjuUzEpjFsWDv7Yq5MdpVBjnSVQV9A8mMRFBAS13lB?=
 =?us-ascii?Q?EtJUP6/hP1H3KCPj3rPjfT0E2j0=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80df02ed-95f6-4dd3-b20d-08d99e1bfa64
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 16:15:25.4582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdXRcs7Awxs83rfzW74XW1/QxWYPOeLtxXw0AyYV2fLVT5ytqfrdUPAooitu8PomrqlokH4pbTk785pH1888SlemWgfCaByrBMiuTcsVlXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5575
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 05:33:14PM +0200, Vlad Buslov wrote:
> On Tue 02 Nov 2021 at 14:51, Simon Horman <simon.horman@corigine.com> wrote:
> > On Mon, Nov 01, 2021 at 10:01:28AM +0200, Vlad Buslov wrote:
> >> On Sun 31 Oct 2021 at 15:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >> > On 2021-10-31 05:50, Oz Shlomo wrote:
> >> >> 
> >> >> On 10/28/2021 2:06 PM, Simon Horman wrote:
> >
> > ...
> >
> >> >> Actions are also (implicitly) instantiated when filters are created.
> >> >> In the following example the mirred action instance (created by the first
> >> >> filter) is shared by the second filter:
> >> >> tc filter add dev $DEV1 proto ip parent ffff: flower \
> >> >>      ip_proto tcp action mirred egress redirect dev $DEV3
> >> >> tc filter add dev $DEV2 proto ip parent ffff: flower \
> >> >>      ip_proto tcp action mirred index 1
> >> >> 
> >> >
> >> > I sure hope this is supported. At least the discussions so far
> >> > are a nod in that direction...
> >> > I know there is hardware that is not capable of achieving this
> >> > (little CPE type devices) but lets not make that the common case.
> >> 
> >> Looks like it isn't supported in this change since
> >> tcf_action_offload_add() is only called by tcf_action_init() when BIND
> >> flag is not set (the flag is always set when called from cls code).
> >> Moreover, I don't think it is good idea to support such use-case because
> >> that would require to increase number of calls to driver offload
> >> infrastructure from 1 per filter to 1+number_of_actions, which would
> >> significantly impact insertion rate.
> >
> > Hi,
> >
> > I feel that I am missing some very obvious point here.
> >
> > But from my perspective the use case described by Oz is supported
> > by existing offload of the flower classifier (since ~4.13 IIRC).
> 
> Mlx5 driver can't support such case without infrastructure change in
> kernel for following reasons:
> 
> - Action index is not provided by flow_action offload infrastructure for
>   most of the actions, so there is no way for driver to determine
>   whether the action is shared.
> 
> - If we extend the infrastructure to always provide tcfa_index (a
>   trivial change), there would be not much use for it because there is
>   no way to properly update shared action counters without
>   infrastructure code similar to what you implemented as part of this
>   series.
> 
> How do you support shared actions created through cls_api in your
> driver, considering described limitations?

Thanks,

I misread the use case described by Oz, but I believe I understand it now.

I agree that the case described is neither currently supported, nor
supported by this patchset (to be honest I for one had not considered it).

So, I think the question is: does upporting this use-case make sense - from
implementation, use-case, and consistency perspectives - in the context of
this patchset?

Am I on the right track?
