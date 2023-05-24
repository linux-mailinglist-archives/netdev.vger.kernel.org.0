Return-Path: <netdev+bounces-5034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 166BD70F78C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEAAC1C20BAB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136471775C;
	Wed, 24 May 2023 13:25:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F236B60868
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:25:35 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A8C9B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684934734; x=1716470734;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wxov+l6t1cDW8cv1CXR8hxRpf9nkS5UBILkNYVRlR+M=;
  b=I5dsAASrl3X4AIB2AT00m8dsZFyG32+IK5yfhsDlD03fOmIbSA+BrO/P
   HpnP3L2u621djnXfJmYUDImGUo8TWoO5D2Uf3Rsit1gn1Wo3LaUcT2vhW
   x6733J67DUKyHcI4n6ruT+EMROq9bWQSJeYyD+J/RorhzhmeG0g8cktQK
   c0t0eKDJ1pUrDPvM4zePeY8OOFtE0GyUwVsln+bBu4cilS1QTMqHYoyan
   OEe9V80NNp3Z3tWDTVEe4uUAYeApEDSd0dI3O1J2ToQowN19WYUmVlE0O
   dCFRPcGA7BTkJWQQ6j8vyBhjyZrnUvFvZ3PrQfOPP2+rht7nVm9H7DDab
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="356788473"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="356788473"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 06:25:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="654794173"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="654794173"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 24 May 2023 06:25:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 06:25:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 06:25:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 06:25:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 06:25:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwsJaVVF6PYpN2/V5dxOGOY0u/gqpJ7U8PwCClqPq0W7w3phjFvM8TdWcMmedeFthr/PSaerFjekAw8RAxQoIvdIYhhqcqAK3n5CNREh8IWGJjicKPtv4GIsAsMuRSFwEp9WdcbZLIqGYmvR+2wGGQK3vc69KGPGBtOggRtenk8x5saDxEBsWznKMIrLfG89KQLba7GhPPPW2mBIjxETr7qEU63KJyPKtXQvQ375G735eNw89rlKB/I/1ObzjRyC9Rlrf+ETtEW42Auf1I7T93hRVRgJDReKzCcMuHu8dXxoVLE8LVTSDWu5RmSPKXa+VVmCLzRMhVi8LIRoc/70Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1c5FrsFIB8pPXCuhtzsFh8dhcwGLl0D4DEXb4f6cig=;
 b=PNcdoYlzh7LcFbAbnMiqXs8pSnDuMmwtD5U5SAz6n0p9U6bLMfAzE/gDe9xrvoaD5k1ZH2GWVG9PqS7td7W1BCdT2Ya0junND5dU048SVto7MZZJnUdQhmFyyW2PuLx5Q6Q1m5AWhXmskRtPlyKYhXiHIEamF5CjMHjvs1718fJ1pJL/HwodYEdMXwrdlqZ1vyQGcWSSULUFSVPqDRjL8PhuA6Bl3kBCsuxCz3i6n2qc8GJTJjuFQG6KLscIBdEDCsLZYc4vhWh369PL8zqFtx1C4pcqAdJIn02EL+lLkjL+DKI5hsJdvb9eeFmIUW/I32D8eaXhU2o04JPyJb71HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DS7PR11MB7929.namprd11.prod.outlook.com (2603:10b6:8:e5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Wed, 24 May 2023 13:25:30 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92%6]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 13:25:30 +0000
Message-ID: <98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
Date: Wed, 24 May 2023 15:25:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, <lukasz.czapnik@intel.com>,
	<przemyslaw.kitszel@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
 <ZG367+pNuYtvHXPh@nanopsycho>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <ZG367+pNuYtvHXPh@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0266.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::11) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DS7PR11MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: e1dbded1-7a8d-4005-8afe-08db5c5a5809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6ZOmkip7ah8rNIlkzfM6BGTHAH6ozOPy63nbPZUcUof3Yhi8vCcrzLJLHiKyLA/Lla02m3l9j5c5Z4D1wXa3Lj18p/eycRzJZaCaw5u/OTzGmUdzNOVt2/2gTZnJNvHCEstQyFU8J0EqHBopc/+iPtYWylYWuqrD1if6+99Su4RzRJ1NpQvSI4UU4TtnGR5qkM0BDsJDmeagC0LW8DaG/yhF1J8b2KZ4fTRZCRHX73YCQ+VzPvv6xFBUGKAtOHbpj69tacjBE7ppYHBiIpD3Bp4EorrZZmscOsc0m9ld8oD29R+wyAC7OtW6CCRGbpK/XVYDK2tgcPlDVTGy9rbWWnL+yg0lLsMz3s4A+fSberQF+8dKfpte/7NSJ/ve7S9bXfUFbtDl+4chEPOwecN2Vnh97/36CUINS6Tc4tnc/YGMwz9fjf8PU2MqtutguQqFF1kygbOUVcq3FAh8A61n/xj6o6TTJU/7/ndEms2MwrDk16LfKiisOs4B5No/SW6jREJ9dxPhO2ffED1x86pEqnVYFM+p8GGvgHGfX/E/ffR3avAN2JgUszujf/61V57wsPA8sEHA7rGuunArZYVMqHdRqCddYjBiWW6BnkGjzTipAazkfaobAGfp2ykS0cHxNcfk+JAryB3T0BVroteYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199021)(316002)(82960400001)(478600001)(110136005)(38100700002)(6666004)(31686004)(4326008)(66946007)(66476007)(66556008)(6636002)(41300700001)(6486002)(86362001)(8676002)(8936002)(31696002)(5660300002)(186003)(107886003)(53546011)(6512007)(6506007)(26005)(36756003)(83380400001)(2616005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qjh4OGJuYWt4ZFBlS0FweVo5Q0VrVUxWMUJNY3YrbXFDQmJkaVkzd0U0cG5n?=
 =?utf-8?B?azZ2ajhwUXNPeE9POVBXZDVTUWlFTXZ6RFYwUm5MQjdKaVQzRGhqN2YzSEVI?=
 =?utf-8?B?SkUxNmJHMzQzaTdhRzJwODRNbms3TCt1UW9zU2xkcDRQekNzdlg5dVI0RkRa?=
 =?utf-8?B?UDVQbnNDMlFSYTdOUGczQkZZamxBQkZ4cERXZHh5UzUxZ0orRm5BQVpmSko4?=
 =?utf-8?B?QlNsYjBwb3V6cWU0b1BKbncrUkV1ODN2Ymt6YnVyOHJnWEFaUldBNGNEekMv?=
 =?utf-8?B?L0JLSG52RE1qemxHV1AzTFBncnNyaXowTVFGeEZsc2ZMRnAzRWNveGoyM3NG?=
 =?utf-8?B?MDlSLzU1U2tzeTRPRjhoRXRGcFlFVTNGa3FyVkh6dEU4SmRyRjFNeVlLTVYr?=
 =?utf-8?B?VWJzNW9BcU5wNWdFVmZ0Y1FORXludGNkK0VLRzI4WHdLWWRSbFJrblYrNi9x?=
 =?utf-8?B?a0x3TmVGWk5VcHh1M3AzZE9sTXQ4TjlkdzRPRzMwbExkcjdnS1d1ZVRGWmZq?=
 =?utf-8?B?SVNFbW12a29TVWpvV2p5NVQ5TkVrWHdBeUVHWnFMZ0MxTXBjbnMzS2lhNVpt?=
 =?utf-8?B?M2wwby93TTQ4c004OHJ6b05mNVhTNjA0dDI5cjB3c2g3aUJMZHBTckRCMXpj?=
 =?utf-8?B?VFdtM3hSNWM5TUFUeVpMWll6Tk05QUthVkcycmpkQ1RXeEhhYkFnRjJhekEr?=
 =?utf-8?B?Z2Vtc1N6ZEtRbEJnZzlxeDFMMDF3M0NEYm53Z1dnYWgrTkUzMzRmNWhIODJo?=
 =?utf-8?B?a3o0bXNBbCtxcmlKdVBUTDlSQ3JNdmRhWXFmREdETTcweGFkRXExZHdoZkc5?=
 =?utf-8?B?aUtXLy9hYW9Rdk9rRE00STA0NnNRZmdVcWtXeHhuMys5OGtXQmJoMjIxSHdy?=
 =?utf-8?B?TStzeUt5M01UV04yakU3Rmt5TC9IRWdraCtXci9qSnlmcE9rejJ5YURXSDlE?=
 =?utf-8?B?bWlCR2NsaDNUd1p5WkEyd2h0YnYva3h1Q2NQeUoxekk2Q2tuOTdmT05ZczFi?=
 =?utf-8?B?RE5kQXRkdUduUkxiVWxqbU5sUXJlT2tEbUJTQXF5YXN2N0VjQ3daVFF3Ryt2?=
 =?utf-8?B?TlMvby9YU2c0U2M2Sy9ZMUlYazRGT1lKODg4ZVlLODR0YTBxY1RRYlFiNzhp?=
 =?utf-8?B?TkZYWUFNSzJCcXJZN2VlRDI2Nys3RU9La1JVZHhOM2VWZ2J3MGswVUIwMWhn?=
 =?utf-8?B?TVlwT2c5NEpYNTRVL3E1VDNhbHZRRm5XMkNNNkdIWTU4aVNIcHpmcHlyOHUr?=
 =?utf-8?B?N1lrc1N0cFd0R1J1YUJRc0pjSU9FQmVtVmNhQXZBdk5yb3UxblkxVnc3ajJO?=
 =?utf-8?B?cXJjS0VFYmpYR0JnYnhURW9nY3V1Mm9kdmo2b2xmZ1MrdFROWGlkajFHOXBn?=
 =?utf-8?B?bDRWOG80b0o0bE1ZZGxCWUNxUG10TmlBbEc3SVZJTGJ5NHFMSHhwb3dYZ2Vw?=
 =?utf-8?B?TW5GV2VPTkhlY2pQaVhzbDJRVWhnaGt1QXBON3QyN3ZPZ2I0YXFxeVovOXNL?=
 =?utf-8?B?bm01QmdZVHU0ZFZBOENiY2VxZGpRZEhYQVNKYTcwU1JhQUwza3NDeGV3YmN6?=
 =?utf-8?B?Q2pBOFVxRmNBK3hMUjVNYTZRcm1iVGwzTHN2Y0hHRGNETTcvUWJHVnNsaDBG?=
 =?utf-8?B?ZTdpdjgwYW9uSHI4L3A2RnFhazFGeW1LK0hFVldlMGJDM1Rpd3NiUU9qYzhr?=
 =?utf-8?B?Q1JOZ25VVHJMVW9uRk9BTStDY2V6WllJNHk2MGY5Q1hBb2R2RVhIRmxYNVJS?=
 =?utf-8?B?MkUxMjRLek1KMkY3dmFwUnk3RW4wSlBtTm90Nm5HZWFoczNWRHdYRXhRNWsx?=
 =?utf-8?B?V3FxSXBsRVdYMlVHbnNFYVVDaDMxOW1kVDV3Rk95NTdkQTZvVE1JY1dGeE1G?=
 =?utf-8?B?d3EzaUhKUnJkc0VKd2I4ZUhyd3YzQXNBSFBIN3JqQVVIaEVuYmJaSDNhbUVW?=
 =?utf-8?B?d3A1NkRIaEUxZFB6RVhWVThXMm5FOG12QW5SUVpHaWZDcFJhTUQwS000NUxR?=
 =?utf-8?B?ZHdQYmdhc1FuVitoQnBSRjR6WElCK1BrcHgrUEZ3Y0dCbUdDbEtVM2dXbE5k?=
 =?utf-8?B?a2htYTBCSVg1Q2JKeGhac2lwSWw1YnVZT1A3TTRwaSsrMGpFd2Q4aDd0Z3FX?=
 =?utf-8?B?emc4OVpJYjNCR0c4M0NXUmVHd1RnRzdyVGE0NTBsajJTdGVaNG85QS9iT3ZV?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dbded1-7a8d-4005-8afe-08db5c5a5809
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 13:25:30.0059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0XTxt9zkvKp3GmQimm7Oc+D5a0ksU+YJ3vRsKJCeZe2OmB6jlJol9eKicELDXqObA89qXghiGgDuXJfTcv0K7Itxi03zKh8+tK/duZufPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7929
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/24/2023 1:54 PM, Jiri Pirko wrote:
> Tue, May 23, 2023 at 07:40:03PM CEST, anthony.l.nguyen@intel.com wrote:
>> Michal Wilczynski says:
>>
>> For performance reasons there is a need to have support for selectable
>> Tx scheduler topology. Currently firmware supports only the default
>> 9-layer and 5-layer topology. This patch series enables switch from
>> default to 5-layer topology, if user decides to opt-in.
> Why exactly the user cares which FW implementation you use. From what I
> see, there is a FW but causing unequal queue distribution in some cases,
> you fox this. Why would the user want to alter the behaviour between
> fixed and unfixed?

I wouldn't say it's a FW bug. Both approaches - 9-layer and 5-layer have their own pros
and cons, and in some cases 5-layer is preferable, especially if the user desires the performance
to be better. But at the same time the user gives up the layers in a tree that are actually useful in
some cases (especially if using DCB, but also recently added devlink-rate implementation).

Regards,
Michał

>
>
>> The following are changes since commit b2e3406a38f0f48b1dfb81e5bb73d243ff6af179:
>>  octeontx2-pf: Add support for page pool
>> and are available in the git repository at:
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>>
>> Lukasz Czapnik (1):
>>  ice: Add txbalancing devlink param
>>
>> Michal Wilczynski (2):
>>  ice: Enable switching default tx scheduler topology
>>  ice: Document txbalancing parameter
>>
>> Raj Victor (2):
>>  ice: Support 5 layer topology
>>  ice: Adjust the VSI/Aggregator layers
>>
>> Documentation/networking/devlink/ice.rst      |  17 ++
>> .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  31 +++
>> drivers/net/ethernet/intel/ice/ice_common.c   |   6 +
>> drivers/net/ethernet/intel/ice/ice_ddp.c      | 200 ++++++++++++++++++
>> drivers/net/ethernet/intel/ice/ice_ddp.h      |   7 +-
>> drivers/net/ethernet/intel/ice/ice_devlink.c  | 161 +++++++++++++-
>> .../net/ethernet/intel/ice/ice_fw_update.c    |   2 +-
>> .../net/ethernet/intel/ice/ice_fw_update.h    |   3 +
>> drivers/net/ethernet/intel/ice/ice_main.c     | 105 +++++++--
>> drivers/net/ethernet/intel/ice/ice_nvm.c      |   2 +-
>> drivers/net/ethernet/intel/ice/ice_nvm.h      |   3 +
>> drivers/net/ethernet/intel/ice/ice_sched.c    |  34 +--
>> drivers/net/ethernet/intel/ice/ice_sched.h    |   3 +
>> drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
>> 14 files changed, 534 insertions(+), 41 deletions(-)
>>
>> -- 
>> 2.38.1
>>


