Return-Path: <netdev+bounces-3023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DABD5705103
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F4011C20E37
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA7828C02;
	Tue, 16 May 2023 14:41:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8334CD7;
	Tue, 16 May 2023 14:41:16 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E999BBC;
	Tue, 16 May 2023 07:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684248074; x=1715784074;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5tteAo7dBg2zuqVEzg/gLHTV2w2psuHWusNMLhVM/tM=;
  b=HPFoiiudiBJkl3qx+9MAAV3kW89yeuSvL3FP4W0px/VQRaOLY0Mbp7S6
   ybdUhlbW/HBrH4uI/67J6eFp91XtoBujJypkaX4NZFjw/xqcfhdwuNrpY
   LGg6W9jCmIJQlFkGtdVWm/vlSQZty+LpFVS2se/X0WECdpqPvbJNFnB3m
   SEWq79mHBoGRQ8FjUBzOvMJF5Uv6pwYwot1B/hQFn/rTulVLEMD5odXas
   jYxoF6lq8MoiAGOMO+G99S7eGHvs81UjG4RuTpdnSXEP0bSsJtFZNvD5y
   vXm35amQjeyH1vrqxGvNEiCXkO29ZVVZfPbnII70VHONBG3ljcRiA8DEz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="379673580"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="379673580"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 07:41:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="947882196"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="947882196"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 16 May 2023 07:41:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 07:41:05 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 07:41:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 07:41:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 07:41:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5AebYyUZA5D21dBfJDTxXP530lPFQBLs3XG/WQtI8ebAsEUn74Ui9rcTbvkB/z9DGh7C8tiIyvwKnPX1k8DFquVz49AeTcp6yAdnw+W06CCGM+bQttAJPi4Gaet8PoGl7iufGT7FlS3U/BELHRFT0glzmPgg6qr/1wvD+2kZEDdDtysz9w6M0uqUrg7nb3wwBdDp2GbyXV0c8UGVLPfgDawcExS/clKehRNVlT4D1gMexGWjBUbDx1nZejbz+iUqJHWTZ1Fxx5RijcXJgX9cKfx0mrsxkFxCE9DxhcRZcsUAhQd864ynWU798HWz6TltlizxKZXSnoTbwg6yjhNbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8qWmch3byy9wtTDqMKcoclhc5VyrgaoRjchGCIWGMI=;
 b=IkgnnExYA+1t7uGqxgwpHqdATUXSCUD1uZ0v4oVDP2/H4CuYCcAnEFBxnXa271LZ1tEwkrgOfQ5mj6XOGLWJFOZsZfVL6x7edDPM7mHO0V3Raaak1NMX/0q8KseMExTSf9vnd2cWYmFXA0tDWu55iq/YgrWHZbEC/kOf3bXwunHNI3ldAR/9pFr/yQnMHPvCrBYrZdVlbpJkcXoanmy5fVyhhu1MNKTkDGMvqoqmD9IDKNWvzVC9XKZT5EGOEEIIRfr11FXL+BHBg06qxXdm0SYcFTW/5YRb75z2a6qyXJrgGhcM3ow1kb1345utgZrH4kNPy7Wnn73xMaQEjHkA0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA0PR11MB7881.namprd11.prod.outlook.com (2603:10b6:208:40b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 14:41:03 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 14:41:02 +0000
Date: Tue, 16 May 2023 16:40:44 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
CC: <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<yhs@fb.com>, <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
	<haoluo@google.com>, <jolsa@kernel.org>, <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH bpf-next v2 07/10] selftests/xsx: test for huge pages
 only once
Message-ID: <ZGOV7BkUgb83clqV@boxer>
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
 <20230516103109.3066-8-magnus.karlsson@gmail.com>
 <ZGN98qXSvzggA1Yu@boxer>
 <CAJ8uoz0dGgi2K0G_QdGO6iVLtQSfP296Hi9dcBeFVUhtd4=9Jg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJ8uoz0dGgi2K0G_QdGO6iVLtQSfP296Hi9dcBeFVUhtd4=9Jg@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0204.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA0PR11MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: c6394916-a94b-445b-b783-08db561b9217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lYNwlh4rIztIWAlZzR+NtxcDGqtUuke/kbnoGAXh3ckMdslkzNy1Y2efqhQqCL8KHssKLUzL0AAdp/JmdiP6I8yrmwVh5gyotZIrRKhWPBv7peg3myg26PeY4H+682Im4YYIz2N52jX+G5YCB0qukEf0Zp6AUKPlB70YpTFQaDuMBlaNX1XGv4YdlZw2Q7HZT+4H95aDJyiI1U4giW7ZQ4266jMa0FeawkVfvBoO8gUzqaqpAPp/RJWXJn5C98Mm1dKv1CrNuBIxOdL+mT42iTMW/Qf5KqwsChDu7mrNYLHWR6ZA0dAxqqlw4s5gjM8dURgQDSeHqPEKyIEgQITEYcMzo4fI4uOFeP4IEe9LRcOm8BtFPQv1P85YcQ9pzdE9ecL3yJpUpFOMsxlytAVGXjLNXGj0wc7MQK7aYDAHofW5/sh0IBqG9nDT7MBCucxPIMA2sT1XA4ijue6chn7Gxlpy+gkXmtEGqAfDJ3bhkHrSNupBjIHE7oFF5uKe5us41k1Al3dP9CVbuhxy9a8kQGNZijkaKVdYxgpx8aAqaaPqcFe+3SRDsbWX03sWAmmHe3+GReEontKbRoMHEoTnlb1do5P0AmP69dc1TdW1NjU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199021)(38100700002)(26005)(107886003)(186003)(83380400001)(9686003)(82960400001)(2906002)(8676002)(44832011)(6506007)(41300700001)(7416002)(5660300002)(6512007)(8936002)(6486002)(478600001)(66556008)(33716001)(66946007)(6666004)(66476007)(6916009)(316002)(4326008)(86362001)(14583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5YTenr+CrQxqR/k9TWkUjT6oShkJigMuLCf15bBK9AUpwosBjMBwEHk8k8UV?=
 =?us-ascii?Q?vhRv5IBFTRD3YDu+plRuDJU37ukLVgCV7I4FC4DM1X88CJiTd/j9fxUk+7HV?=
 =?us-ascii?Q?xq4HV/Co7KA6YLpV4+a6yN6MrCXA4Ay7AWvmvjg2oXcgSEqze0gAtfFUQTVr?=
 =?us-ascii?Q?nxYWmkHtAVK+fmWKWQ4knYe7CoPIVT5NPb4rvMcUsDfkzx4lC4aFMhCmsjeO?=
 =?us-ascii?Q?Z602OoTP/tQVHjC5xyx5XHri9n1Xw9ACBbPw1QEZd/T18c8QqjerWhmneO9c?=
 =?us-ascii?Q?JjYECJFM8e4wn5d6R6nlSw4o5+4lwHxVd7AhSBmf6DBqU1KrzPVcw9hEUy/B?=
 =?us-ascii?Q?h0GcaecO35IofejTFgVsWeLNUPLjFbyUTXC8npvLDWEJCjGtx9Wt/JrhQUvi?=
 =?us-ascii?Q?KJpRnxqGDxHNWKLt+ACMP8H6LouEIjDS1aLwm/o6TFc+QvZrUOwCR4aATGyT?=
 =?us-ascii?Q?3K540z8+ADj+TyOT5rWeERsnUqVpQ4/lNZkZCtxbbcXNdc4B3HHNg8RbbCxF?=
 =?us-ascii?Q?vak95bw9UF2rjV/ALwqU3ASplQrHT21l12GfHzl/ch+bUQvMldpbGbQ/yLT8?=
 =?us-ascii?Q?iOJZwktTh/Cibe1umdw23sIIbzYJJh00tuA/vMPnk/q1ABhsuS5NJeC5E1+e?=
 =?us-ascii?Q?il4x/Hbg3JS3PYznu85NdRRMPlKEyo+Y+3rNm1LH1KFKbvOg++gObD/S3kOk?=
 =?us-ascii?Q?Eu3pKaoI2X0LmHVw3Q8oHCnij9sbZ3TMZoGZB6F4RWkBPrdgd9CJievF9suO?=
 =?us-ascii?Q?mHd5vQrNiGxtI5T08q3Y1unqfhgvyN5+dvqxOA+nWy+tLJDuvMvrv5v/1A11?=
 =?us-ascii?Q?eQjndtyQ97pxKzgW6yIJ9uSsLSVUW5pxAR6BFeqb+4CSr+EYs/2fGWXAn7St?=
 =?us-ascii?Q?lj5rI+QH3ZAAQQDxCCqARytJOiiOfMNQlwoRij9T3B/th9AvjBuFfZHTE1D+?=
 =?us-ascii?Q?m/aR353dZh3DMZ5VDcHShYb0OrbXamXQQLHBqNuyuc4SvOh5giu8s5/1Uuke?=
 =?us-ascii?Q?MDCdQTIbperg3pwgGpBZLGop64VGvtzQLbOm7xggkoBtSJ2ymnAbYAGIqCop?=
 =?us-ascii?Q?MqmqccAE//4ktDlDL9Dgvb7sZ7yYNUjHlaSn+GTYe8kkjUeuE/b/VP1EnOPy?=
 =?us-ascii?Q?S1JN19PfZ4fax8+XAoSojszXoiiGms7iHJjBFOv4yJcMi1UJw8bx1c6AINWf?=
 =?us-ascii?Q?6te1g0I4QeLGjW6oKm7ZVun9wyoVIr0PBtsZNQmA43y3zGj6oUineRLyd0UA?=
 =?us-ascii?Q?A3YkmS6z1CXhes+ZldxFqWWNf8IbI2NJBpDGhJfdcahON69GHyEu+JjgnbaI?=
 =?us-ascii?Q?lBS3xzS6ggj+Qlnf03nwY2vhygQVgygKDQBrM4YpYp9Jd1RMv/+32U972tnU?=
 =?us-ascii?Q?+59B4+feZDkAkChl7SrzLnt4+CpP15R7DKrqSOiuzV6Trkm1s8vHXgyrAfaq?=
 =?us-ascii?Q?Ct6Za+dc3y/t5vlLFIBlVhEYgLcNuFIAjPfibvdHfvW+gfkEx+An7chQiP7g?=
 =?us-ascii?Q?hk6SGCioNlOXJ0yvjSisAIjPRcpOluvvRfMW6FyYAgeet7NfriV7pfv31l2n?=
 =?us-ascii?Q?GgJx+lQAbNC3/yGTCxh0bFS50PnOxaE/ZwnLcwCKW/uXI/6FnXSj0kdSSBNe?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6394916-a94b-445b-b783-08db561b9217
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 14:41:02.7160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIo/IGbsmAULrRiGKML1ZzYHnNpR/gL3hpea0eDqBMBSkjRAs+7pnhG/2+Oo1jo6XTSu9oL7LOCTv2VotUdsb8RVqBs6HadkqNOcmmb2gqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 04:25:30PM +0200, Magnus Karlsson wrote:
> On Tue, 16 May 2023 at 14:58, Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Tue, May 16, 2023 at 12:31:06PM +0200, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Test for hugepages only once at the beginning of the execution of the
> > > whole test suite, instead of before each test that needs huge
> > > pages. These are the tests that use unaligned mode. As more unaligned
> > > tests will be added, so the current system just does not scale.
> > >
> > > With this change, there are now three possible outcomes of a test run:
> > > fail, pass, or skip. To simplify the handling of this, the function
> > > testapp_validate_traffic() now returns this value to the main loop. As
> > > this function is used by nearly all tests, it meant a small change to
> > > most of them.
> >
> > I don't get the need for that change. Why couldn't we just store the
> > retval to test_spec and then check it in run_pkt_test() just like we check
> > test->fail currently? Am i missing something?
> 
> I think it is nicer to have the test return fail/pass/skip, just like
> most functions return non-zero if there is an error, instead of using
> a variable embedded in a struct. But maybe it is too much for a single
> patch. How about breaking out the void -> int conversion of the return
> value in one patch and then have the "remember unaligned mode" in a
> separate one? The first one is just a means to be able to reach the
> second one. What do you think?

Yes, please, this would make this patch content to do only what subject of
it relates to. s/void/int does not belong here and is a good candidate for
a preceding patch, so please just pull it out. Thanks!

> 
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/testing/selftests/bpf/xskxceiver.c | 186 +++++++++++------------
> > >  tools/testing/selftests/bpf/xskxceiver.h |   2 +
> > >  2 files changed, 94 insertions(+), 94 deletions(-)
> > >

