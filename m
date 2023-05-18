Return-Path: <netdev+bounces-3771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 692D3708C40
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0598B28181F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1940720F4;
	Thu, 18 May 2023 23:23:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30DE20EE
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:23:23 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362EEE6E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684452202; x=1715988202;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YPtBUc7F/rcCE9uhQNwnKe1JAlow+caaR4vi3qsSpc8=;
  b=na3xzMhGFnPuAXT9TC65WpXdPmEKJyh0pioZl9PpAQEYVzoIy92CmcFF
   amFAohkKWQqyBsZvHcRK103Cdp9iav9oMinrXyB/LvtteNkT5r8QSIoxL
   yRfMeSIRmRW9vgqj/HOoNwKICYtOZ/64Y7ORW0ljQ6/PkfqG2rsm8wNLY
   d0yC7wlLh2AMv4rPBypP2YdCUPMQGa4eAHuyEE1XzsVL3URVEb1YIA1dw
   Qse6f9lqTfatp35tJVT0Kfm5Hng2RaIGldWKD4iwUMjE9B9Kl/9+eqAFO
   g/Pd8h+ytvirVm4wIJg7MX+YFSU11GGPILB0dfJktmgIFoJMrPLFK8o4z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="354568048"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="354568048"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 16:23:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="1032378512"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="1032378512"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 18 May 2023 16:23:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 16:23:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 16:23:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 16:23:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMMmd3O5AUwSgTbdMAHV6Y4s/MPDgeZXgbX2NIe+xI/shND1lnmz4YeWLGPHppAxUv1iWtz1waU7/7MaGx4dtdroABLj4prWpDqgB0SOxty9oqieiW500j7wO5BW8sNTTy7XEjrdH2kYrk2XG3UmhPl6mvbgkvSNXcfGGLQvcYSnE9QeAYYvfcXSgJrUyRq2qBk5M4C/uTSQj8JJZQR82itV8sQfYPI28PROf8oYxvXhmIG93IDFVMifJQKsuIpKdGHxvCf6Mv/Oaa19UebFOcuOBrgXSHKnxEy6/7Ei+uR5E1hAAkARS9Qx2oI7xhZ+bIGaZRUQxTWGtZcRx8aRbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUre+rTaq+iX1HpOwTd0bbbLuoB5UFUvCKq/N0INY80=;
 b=GqjC03F/8yWDPGkBCNKwpGEvaaK28Z87IkkeRA1yVcOL/LNeM1XUXunAKrlixH/lD433kALdzcpC/zzBF8MPDQ+q9ystJFc1TFwq/201p4XQe/bL7rZWAargDfoPWMk0ojzrZ7XR86eif1xTK5uZAkcOlKX5Xp49imWGTMFxShfFxGVuSpThzxCleHHOXdZLUy65NFkNwvAtKh2gc6mWXjQYZuzL7tuyncqQ9yGo1yuxpNu7sPDIA0n0ZmFoAuatQ9cod2GIhDK0WL4C40dSdslH6H44o/K24iRSAcs3PHVfd9U7/M4/WhO9nXESqf57NqVpNuUz9rQP8NcqLr557g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by LV2PR11MB6000.namprd11.prod.outlook.com (2603:10b6:408:17c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 23:23:13 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%6]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 23:23:13 +0000
Message-ID: <32cb61b3-16f6-5b2b-4d57-5764dc8499cc@intel.com>
Date: Thu, 18 May 2023 16:23:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
To: Richard Cochran <richardcochran@gmail.com>
CC: Jakub Kicinski <kuba@kernel.org>, =?UTF-8?Q?K=c3=b6ry_Maincent?=
	<kory.maincent@bootlin.com>, <netdev@vger.kernel.org>, <glipus@gmail.com>,
	<maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
	<vadim.fedorenko@linux.dev>, <gerhard@engleder-embedded.com>,
	<thomas.petazzoni@bootlin.com>, <krzysztof.kozlowski+dt@linaro.org>,
	<robh+dt@kernel.org>, <linux@armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
 <ZGVZXTEn+qnMyNgV@hoboy.vegasvil.org>
Content-Language: en-US
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ZGVZXTEn+qnMyNgV@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::38) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|LV2PR11MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b65f507-4939-47d4-3ba0-08db57f6d9ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qk6F0RqdnuB/q5JfFkdQRSb4hkEx6BFXZ4MFzVKiO4AjWMcMPwxt1q1klltbQIMs5F+JvXQ6mEobCi7M8g0nRMyBkcil6BYWpfqtx+Vkd73hlGfvvmvPCHH/V/fglRpVZHYA5vSmsvqU1YtzvhAmOaLjztA7p8BAKGnJOgZ4phX/+Z32g4kTdbEjYPj9+iPiUVlFt1VIib0G+GqSYPxa+o3uYw4Ag8DsrKaOQXVwqNWJtxMIxUQsMYd2GtPOz2pKNBdZLEklaAWRo8dEi5+x/4CVTpRVuXtY87iR7XKASjfmpEURr0Sd8kuUYbS8dL9+UpE4x99dJKbUY9+aYaviQYRjGjkA0vK0/9zDD/bDPcSYCIYmWt7kj9JB/0ndPwPc9ANYW+JAobd6x5nZn9EYXSmDBMVrvbeye++Y+XPfZV+caULIF6I/UzMzEIdpTA5HMq7F8mQrVzB4sl6WP2r8TuzhPAoVqIcq4Rem7C489SUwV5QBSWtTBEaT2bOemAmbd3P1a+fb0N5EFH2JZCBDo3s7eD8suvH8OEvWNO/hU3b6zZesraekthk7mPu53ej+WFKmgCRD7OF9HCkecWl5Skk9/ix/+lXtiTdgolJn7cU32M68ux1cMnNoE8bZK+JMPMZLTgnU/t/FWvZ91QYkCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(8676002)(7416002)(86362001)(31686004)(8936002)(5660300002)(41300700001)(2906002)(82960400001)(66476007)(6916009)(66556008)(38100700002)(66946007)(31696002)(478600001)(54906003)(4326008)(36756003)(83380400001)(6486002)(316002)(2616005)(26005)(186003)(6506007)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3ljSjBjNjhHMk9FVUxralRLWG1tZmlHOHF5MkFSMkFSM2p1S3orOVdNcDc1?=
 =?utf-8?B?NW1WbVhJMHNORHlxRThuQTNxZDZ4a21NRTFvSHR6czFBeGRZYmpaazRicjBp?=
 =?utf-8?B?SDFUK0xUZ2xkeG52OHlKM3JHc1BRRXM4NllMQUxna0FGNGRTR3NhbFY5S3Zp?=
 =?utf-8?B?VU5wZEF4TmEzWXFsVDZoOGo2Y3BoV1hTZDc3YUFPK253OXpwRmtXUjRPM2dW?=
 =?utf-8?B?RisrYy83V3psMWVxS0F6eVBDOEdDZWlabE53Slh6RlBldGxYbHozMWh5cTdt?=
 =?utf-8?B?RW5XR1l0VThRMXBDV0RHeHgyenZLMFp2cTFGc2Q4aGxlTitXYnRHRFE0akVH?=
 =?utf-8?B?bFhCWkQzYlhHVUk4ZVlpZC9vek44bVdYRFJscjJ6ekliZFVWaWdrSWlTQ0ND?=
 =?utf-8?B?RFNGeUR2TXZobjQ2NUxZVjVVYmhBeUFudUhhVTZqaHhMZXp4QThxekpTeEVX?=
 =?utf-8?B?eGtFcktoVDJVRW1QVng3K1MrZE9mSHFoWmJSWnorOUhLb0haOHhyOEtOSTVt?=
 =?utf-8?B?OWVoUnZ0VGVoWjRUWHJla0pQZDIyTTNYQkg0VGhaQkJDRlBoZkhSM3laQ2ls?=
 =?utf-8?B?MTRaMDEwdUE0SzNtdUp2NDRhMFFMaGNrdy9SM0xocTJvUnAxUkRNZTRPMWpX?=
 =?utf-8?B?UzVycUhmWGFQQmZHR0E5MjlIbWNEOFBPY0hFSnhNU0txZ1J2L3FlSW5PSDVk?=
 =?utf-8?B?cWJLVlVtOWU5ZVFVWFdxZUF2eG0rbUx0cXF4UUFxNTRWcm5vdFhycnpHTWV6?=
 =?utf-8?B?RFpxRDNUeEFlaS9TMTkwNER1anFEUzZvb0dUZzAwRGFiZ2FKV1AreiswdGRj?=
 =?utf-8?B?K1FuRUpTUVIrVGNoMFFuTmlRU05Rc0w4dWcxbFZIRzI3OFVEMnh0UDlWQmR4?=
 =?utf-8?B?MWVCQTE5MzZKVDRqVXZhaHJaSG81T3NYbDcrUTlEYTVRU2hvUVQ2ZEdrSzZy?=
 =?utf-8?B?bC8zNXFqc05HQjY4bDJYWlFidWdGWFFQb0ZpbEUwT1c2NmsvN2Z3YXpOU3JC?=
 =?utf-8?B?TkZtd29pZWhGZThta1VuQmpNa2FtcVJSNjJEcmpEaWU4NCtjK1R5VE5PRzdL?=
 =?utf-8?B?aUtPTk0zSkh6MHo5YVM1dzBxMnRMb0t3N1hVZTYyUHJwRnZQQVloUkFUSDBH?=
 =?utf-8?B?VHg5SHp0eDRsNVYxSUJrWG83c3BncE5GZFhZRlFWaHNNbjdyQVBJZllSRjRG?=
 =?utf-8?B?UjByVDVOWDdLUEZOT0w4MjJzcEJrdVJFTXhWdjdONld6VXE5aTA0SHBnaHhB?=
 =?utf-8?B?c2FveTUzbkpWSkMzV1k3YTk5dVo1SW94SFZVeEtNV1F0bk1aa211T1N6OHph?=
 =?utf-8?B?amVySmtnVWZJSUpkc0lIZzBScUNtT0NwaW5KWERYN2x2TktyZE9KTXNGWUJ4?=
 =?utf-8?B?Y3FSa21vYVY5dXA2YjVWNmVTRHZRNnowNGlXUThINm9HaDNZcUd3Tm50bW13?=
 =?utf-8?B?U2l4UjRMK0plRnJRWGVRakFqdXQwNHc0ZzI2NFZKdkpTR2thT2trY0VtS0xh?=
 =?utf-8?B?N1lucXJBbktGeW5WZ2tETnlLa2lmVWJ2OUZ4L0hzajRDNWMvay9DTEtQc1Vj?=
 =?utf-8?B?RDV1Nm1PTDI5U3RRSS9OY1A0aytpaE1MSFdsMkR2UWNUeUFMQkJKTHBEQi9O?=
 =?utf-8?B?UFhrL013UVJTK1BoejlTL2FqUFVDcFQ5NUl0TTRmQjYyeCtha0czNU1FZmth?=
 =?utf-8?B?ZUxtTnBWcjVYblByWlNLTTJ6c2ROd3lhbU1WcHlwOXlnblFKMVdMcVZScGhU?=
 =?utf-8?B?MmwzL1BMYmlXN3dUdjNCT3RyQTUyVE1HRjdRbEhuMlJqWmNDWnNkMkZrQUQ2?=
 =?utf-8?B?TWczWEZhazlLemQ3WGRvUFFWOXpYN1FMNUJVN1hCU0QzS3dMbEhyWE9nRm9M?=
 =?utf-8?B?ZE51UkpKTkZUSENCalFoNnRhMWVVTGNndEt5a2l0bGdZRVY0cnIyMk5DbStU?=
 =?utf-8?B?aG53Syt2VGdGNGFxQXd3SEZZT3I3TlllVzlpL25TeWFtQ1VFbkExSFV4U0dY?=
 =?utf-8?B?Vk9TY2d5RDRZYk1SS01ZMzRKaUVTdVROeHlpeDVnSkxXU0xQSnFvRXgyajQ4?=
 =?utf-8?B?KzlKUFdUUVZuQ3p5bkJ6T0prbVZJbnZVY1BaSjA3VGtKZzE3dzRRdE5Hc2F2?=
 =?utf-8?B?MFF6b3haYWFxZmVXQUhzTmhuOHZ4VGorOTl4V1lNOHhOY0Mrc2ozb2lVWHpF?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b65f507-4939-47d4-3ba0-08db57f6d9ee
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 23:23:13.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAceGgwDjmgf4QZsVUoAwdbE2ct2JGJBhC55e9Sbd4akqmgBLMxTYyQxnPNuPax8E3/ODTZpRRQrAqJjw2D/JwXKLw/XOyTn7tetCy1F74E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6000
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/17/2023 3:46 PM, Richard Cochran wrote:
> On Wed, May 17, 2023 at 03:13:06PM -0700, Jacob Keller wrote:
> 
>> For example, ice hardware captures timestamp data in its internal PHY
>> well after the MAC layer finishes, but it doesn't expose the PHY to the
>> host at all..
>>
>> From a timing perspective it matters that its PHY, but from an
>> implementation perspective there's not much difference since we don't
>> support MAC timestamping at all (and the PHY isn't accessible through
>> phylink...)
> 
> Here is a crazy idea:  Wouldn't it be nice to have all PHYs represented
> in the kernel driver world, even those PHYs that are built in?
> 

I agree. I've wanted us to enable phylib/phylink/something for our
internal PHYs, but never got traction here to actually make it happen.
There was a push a few years ago for using it in igb, but ultimately
couldn't get enough support to make the development happen :( Similar
with using the i2c interfaces... These days, so much of the control
happens only in firmware that it has its own challenges.

> I've long thought that having NETWORK_PHY_TIMESTAMPING limited to
> PHYLIB (and in practice device tree) systems is unfortunate.
> 

It is a bit unfortunate. In the ice driver case, we just report the
timestamps in the usual way for a network driver, which is ok enough
since no other timestamps exist for us.

> Thanks,
> Richard

