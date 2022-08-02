Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94375874DB
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 02:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbiHBAiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 20:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiHBAiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 20:38:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33961115B
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 17:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659400699; x=1690936699;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=94y8s3e53ZO9W30QGQ6jBOffHfvveAqvpSvB3yscLJI=;
  b=O6DMb63I25ljHmHp/z5amA3KVnLNDixnibauGeZ72KIkffYK1n8vdB5J
   C8h6DDMk5WccW6XX8WK5v6RzweMOF0skSKa+ynRz7u5ymk/KQuPo0zUAP
   KBqlj8F/4ANNfyDFkuUm+McGGMP0lLn6mX6nO79Wm93SUAzisEYks0AG4
   lnnJPGBZYNbmFX7QXrrBZGXCDM19hBuvCZoh5IoxvGr8Gr2Ol8goHWU5B
   vTEq1WebuSBXCNEWC1SfJTeUPKTEmn+Iw4b2fWYXYhhKTuKQk7HNlu1gA
   nYxC2YsuIVHMYLdhAg1nDBZLF3sUfC5/zzQ6rEyl1SjX4bmxismFAfxco
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="353289248"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="353289248"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 17:38:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="599122010"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2022 17:38:19 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 17:38:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 17:38:18 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 1 Aug 2022 17:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMGbQH3+rg95VmChpIBNSYW6Y6d2aTvZ0naBV17BmksonEqL+//P9BQhQRrNSCThMDiaWY59OxhH4IXVmeOgWUPWM5jcqd3nmAd8qzhb2XXFCcbTMSB4N5Brm4iUz6FNhatvonM3vJY+BVqJv1gV5fAcBhBdvM7eD7zPhF1ce3apTuu/MDCciTGWTjUXmp304n+YgGknFeFlb7k+pA5K4UgmpGmU5iSDGmVXvwd0vN3vmYHnX9R83SdYqnKeLSQ9oPrpBEkrRC4IIBZ1UVN7RO2/JKe4TE7sAbvB2pCwKeTos9iGHPq+gvATs7oaTre0/MlDhpWajOuK+EB7fp6Eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvYlJPFG8mfBbeZOmtpSXlPkfsL5jWLDEh4h4e6YKmA=;
 b=BZHgEs51KM4NtipVslwAZvg2QCLwDuHBW+0zHLccW0DJQx27lzZhWrxUj7xQ2zlYArN/U+fF/PMjem+OETzrPzP9zIETkGcGZpW/MH1NQua6N66QIs6q3xQ8VgwB21dPwE0WyMBMDkfHN6b0rH++avs9Nx4onQOqM2GS1iG7XhMzZsYgeohiZ4OtmbY6oohgwDROjHUFrrTZEIkeWovEpLbG7Wh/A7YpFsG+uNx3so2boWcTr44Hj91oWNYZoD3k/1OUlULo4NIXYeixADXRhLYXjxNI/bqNjO+Y7qhbIsUZ7Yw2aT7cauGm+xbaLLJiLKj/VG4VeqhxSaGrpfVsSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BYAPR11MB2678.namprd11.prod.outlook.com (2603:10b6:a02:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Tue, 2 Aug
 2022 00:38:15 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 00:38:15 +0000
Message-ID: <4dab53a0-a9de-ff9a-69f5-ab2a005659e0@intel.com>
Date:   Mon, 1 Aug 2022 17:38:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: Fwd: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
Content-Language: en-US
To:     Alison Chaiken <achaiken@aurora.tech>
CC:     Ilya Evenbach <ievenbach@aurora.tech>,
        Steve Payne <spayne@aurora.tech>, <jesse.brandeburg@intel.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
References: <20220801133750.7312-1-achaiken@aurora.tech>
 <CO1PR11MB508966EB7A3CF01A58553536D69A9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAFzL-7tX845o2kJmE4o8EhbeD-=vkR6rmaiz_ZEWfSD4W+iWEA@mail.gmail.com>
 <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
 <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com>
 <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com>
 <CAFzL-7uBrzQNmYCXvaL-OokE07cWT-jr4tgGR2VgeaUeayLfxw@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <CAFzL-7uBrzQNmYCXvaL-OokE07cWT-jr4tgGR2VgeaUeayLfxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0129.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2646bd58-c019-4e60-b399-08da741f4974
X-MS-TrafficTypeDiagnostic: BYAPR11MB2678:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7OPUY3k354fkjZS26givtBMd+oFiKQ33mDTt9D+6ky1F1kYZr9B8XiIss8mbWecyX8tu7prrYDB3M43hSbYHeaQ7fgDRxcnKwM6bsf5mewmmScrsQG5Pe2PLknVKUouz0VrijvAFn44iAb+QH79iqAhQlCRJP4Vt1xjuAtrloRbjedUEY2d6Mwen3XXoy6i1VxmbEN+b5OuH7L+BwQf5gyq18+DSt9gIAZX/8+bProzXp0y9QXaDZZXGQLCo8coxx1IRoc1SPdN1XC3rKnCmH8WtzGUgtE6LzqY0in4vfcoEdRuXpS9iD7zePNPqX1WgPiyQVHSv5W623Nn8ZoH3gm2Bibnax7QbxYD8wNARpE9Is6QSjsedKty49rCnKj+vtrgrlC7RpQq+SDDuJ3HPMdD16yNr6tSJOLNC7hH/sjhnp1T6Yq5j4Cdt92T2YM4C28ATjSXTWJj3T5J8O5FBQNmNBZEQXdhOAS/GccIHL1sBwO8gL2MxqrKQIl2P+aIvs7sfn2KoW8wMeO/Ze0wDZyoFZ2N1tqjRBBWNXlq+/8nrzN/XT6mCZaFcRGfNv4wXKvW2Yl0bpJGQgM7KmsqYj0D8jSn7fuPOP+GN5Tv3eun/YOyl+uwLebQpGZkafT1/2I5FegZun4jHwdh2tTUy2859FneHnvRLUPeEnSZQNRb0k+patR7FNb3icjzWk2qmiAhh6E2kXbBs8U0KtDSXCar+uZnPk48WF3elLe85NEL9zci4yRPWno1dZ1COLspX8O1mU2/5AwukZHEPYeifTOoJozJkZu3U+JMEnqpfuPeFnCiuznHDo6zvCY+G6SPlakttQnO9pgXJzaoxfkv3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(136003)(39860400002)(366004)(186003)(26005)(6512007)(8676002)(38100700002)(66476007)(36756003)(31686004)(66946007)(2616005)(66556008)(5660300002)(8936002)(478600001)(83380400001)(2906002)(316002)(54906003)(6916009)(6486002)(41300700001)(53546011)(86362001)(6506007)(82960400001)(6666004)(31696002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RURoV0lOeHN4YUZUWUN3WVlMUXk2Z3VCSnFIVG5LNElrUjUzdVNZZ2lOYVZU?=
 =?utf-8?B?QzcyQVRxUlZ4SUNtQVN1OFBIT0E0UkJNbFl0bnVEYnlDMmJqSHgxelY0K1JI?=
 =?utf-8?B?dmNYNzR4eVdGR0RyS2IzNjVUQkJSVk9GUHc1NVovTHRMajNPTUhNZmYxQVZx?=
 =?utf-8?B?Zk80cHo2Qm5RLzNIMXR1RHBuaEg5T09kWDdxVGNKdnUzeDJHdGlXS2x5VlZJ?=
 =?utf-8?B?c1lIM1hoMDd5czdaSXI4Nm4yMmc3R204WithV2FJVkdSZnVpTlBuc0hjeU45?=
 =?utf-8?B?Vlo5YzltSVFzd0Z5S3gxM0Q1QzJVeTZ0MzRReWxWVmlRQXVPQTMyaFJibkJR?=
 =?utf-8?B?ZHIyZWtjZDRmZWcxVXZzR09VWlNiQURMcmFiS2VOYmZIWUNzQlFPeVdIaGRD?=
 =?utf-8?B?TnVNbmFYNW80N2dxZnBQYXdDYXJqRUlHVXpRZWJ1L1JlTjF6Wnp6NmVHQVR5?=
 =?utf-8?B?dDgweVh5MTluU1dxd2JvK1NPWDRrcjJvaDFWRkFaclp1MjhDV20yY0lNQWNl?=
 =?utf-8?B?cUt1ZUZQT1lUWUoxOXdGam0xUVlSc0ZtcFFHMXU0d25XUDc5NU1nOUVqMjBr?=
 =?utf-8?B?ZlluYldNT3lLWFVCQlhHWU1tTTRTZElUanpURnNBUklYbk0wSUNJSis3TmJi?=
 =?utf-8?B?aGdxZWhvL2dvUmYvZVdiekxxY2xySXJwdnpoK24zZ2FFOGVBR0xaUkFBMnRG?=
 =?utf-8?B?UHErdmJabkVtSEFLUkV4aERrVWhtdnJYUWl1UmhBTjdvcC83dlc1WWRKbVVC?=
 =?utf-8?B?YUR4dXNqQjNjT2pLekZwaTg2Mzl2dERuVkdzL0pyT29ReUxWYWlhWnp6Vkoz?=
 =?utf-8?B?MWVrRGxveFpmRHFVQmxqYk52aGVrVmFXRFdLUkIzYUM2ZVZxLzNZcnhuQ3dU?=
 =?utf-8?B?ZERrN1R0MVZYdld3eVdEWGM0VHhkME01M0hnSWhtd0NEOTF4RW1TTktrMzh5?=
 =?utf-8?B?VzZjbURHbEdXYjdOWW9oZkxHTUhQUktPRGZBZE53WWZYSFZ5REpjNmszdXBX?=
 =?utf-8?B?MWF6VVNUaTFldEpROWFJMWpZYmtUTnhvSnpBL2tCbWJxdG5wS0VkS2Y0SkhN?=
 =?utf-8?B?OTZiUGM3Z3lPaVhOWVd5VG1LN3dpZHJmVUZON3diUGZ4NWd4VGhxbmZiUzNa?=
 =?utf-8?B?b0ZMNFoycWRvNXVSdzkwTnB1NVdWL3lNWXlUaWNCbStKNjAyKzdkanBBT3Rl?=
 =?utf-8?B?L08zLzdYYVg2VXNNaXk4SFpKR2crSG90TisvZWRXbFl3MVB1THBGZGMvbDNS?=
 =?utf-8?B?R0YvNndNa0R0alBhNVliSlQ5WEdkMXJyY3ZlQjFxTWplTDdIekZmTnErWG4v?=
 =?utf-8?B?Q0lQVkZYdmJNb0lRaUdhcVltVmxPM2xlMHdnRjZvazVNRGt4VGY0cEszK2FN?=
 =?utf-8?B?dGJGRitTT0FWVGM2RTAxL09yNTduaGI0OUMyaFgwdnhiT3lxd2x1dW5DQlo5?=
 =?utf-8?B?MkY2UUZVdDJOWjBIeG85Yk5hR3BVaGo2ZW9FY1cxS09yejlTaFdKM2hPQ1pI?=
 =?utf-8?B?K3Y3VHlvUU9VWlJ3dCs3czlNR1IvRGRla2FoRExuelBSSnlpQzdMa0haVVI0?=
 =?utf-8?B?TFh3YVZxb3Bod0dYOGJrRnNGaUVSVWVMY0k0ZVFxdEo1QjYzckFETXVwRmQ4?=
 =?utf-8?B?cTlRbTlyUklmTlhyeHFIanFGd3EzTExsT3Z3SXBORzZZY25LS25KR21xbjlj?=
 =?utf-8?B?NGRqSzI5QjVlZXRvOGVjRDREeFRpY3BuMGNQTG9ZQWxBK0JvbkRObHdaSVBU?=
 =?utf-8?B?a0piMms0eERWOVRSd2ZNSjVSQkJoSHhhUEdDK21ncEt2N2dDbS8zN1RkLzF6?=
 =?utf-8?B?MDREMDZRVlJOcU5sU3htTDVRLzBMR3VSQ2lMTFl6eHdrOWFNbGJOenY3Rk1X?=
 =?utf-8?B?QVVNT2xlazFVNnJYYjU3ckpJV3JaZGN4ekpGeXZEdTVtRWZTWWJaM3pFWFRp?=
 =?utf-8?B?YXozcmlWUFZDM1F3NVdaOUFwWTNzbnNiemJUTkJXYVVyNDlKSnM4UWFiaFMr?=
 =?utf-8?B?aDZpL2hjdWY4T1E3SEhyM2RoOTRDR0VyUW5oeXdoK3ZQMGJCMjJ1NkxZNzF2?=
 =?utf-8?B?S3FYWVVBS09jaUNzLzl3c2p4U2RTSUpycU9kN0YrM3NlL3M0RmxMSDZaMld1?=
 =?utf-8?B?NGF6N2dCR25CRzErMlV0NGNTV0xObzZNUkxBSUlVVHBxdE5RblE4bEpTVGh0?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2646bd58-c019-4e60-b399-08da741f4974
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 00:38:15.5757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6w5Kc/DVbIdkBWeqvy89AQr8oLymZtTR2Jp0M5fmBO1yt474CJmujErwPQmgwM4kGVR8LuY7QPUSY9d4PQMKg5fzz7/fPBw93Mz00udfGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2022 5:24 PM, Alison Chaiken wrote:
> On Mon, Aug 1, 2022 at 4:29 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>>
>>
>>
>> On 8/1/2022 4:00 PM, Ilya Evenbach wrote:
>>>>> -----Original Message-----
>>>>> From: achaiken@aurora.tech <achaiken@aurora.tech>
>>>>> Sent: Monday, August 01, 2022 6:38 AM
>>>>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>;
>>>>> richardcochran@gmail.com
>>>>> Cc: spayne@aurora.tech; achaiken@aurora.tech; alison@she-devel.com;
>>>>> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
>>>>> Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
>>>>>
>>>>> From: Steve Payne <spayne@aurora.tech>
>>>>>
>>>>> For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
>>>>> from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
>>>>> by a seemingly inconsistent amount, which causes discontinuities in
>>>>> time synchronization. Explicitly reset the NIC's PHC to
>>>>> `CLOCK_REALTIME` whenever the NIC goes up or down by calling
>>>>> `ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.
>>>>>
>>>>> Signed-off-by: Steve Payne <spayne@aurora.tech>
>>>>> Signed-off-by: Alison Chaiken <achaiken@aurora.tech>
>>>>>
>>>>
>>>> Resetting PTP could be a problem if the clock was not being synchronized with the kernel CLOCK_REALTIME,
>>>
>>> That is true, but most likely not really important, as the unmitigated
>>> problem also introduces significant discontinuities in time.
>>> Basically, this patch does not make things worse.
>>>
>>
>> Sure, but I am trying to see if I can understand *why* things get wonky.
>> I suspect the issue is caused because of how we're resetting the
>> cyclecounter.
>>
>>>>
>>>> and does result in some loss of timer precision either way due to the delays involved with setting the time.
>>>
>>>  That precision loss is negligible compared to jumps resulting from
>>> link down/up, and should be corrected by normal PTP operation very
>>> quickly.
>>>
>>
>> Only if CLOCK_REALTIME is actually being synchronized. Yes, that is
>> generally true, but its not necessarily guaranteed.
>>
>>>>
>>>> Do you have an example of the clock jump? How much is it?
>>>
>>> 2021-02-12T09:24:37.741191+00:00 bench-12 phc2sys: [195230.451]
>>> CLOCK_REALTIME phc offset        61 s2 freq  -36503 delay   2298
>>> 2021-02-12T09:24:38.741315+00:00 bench-12 phc2sys: [195231.451]
>>> CLOCK_REALTIME phc offset       169 s2 freq  -36377 delay   2294
>>> 2021-02-12T09:24:39.741407+00:00 bench-12 phc2sys: [195232.451]
>>> CLOCK_REALTIME phc offset 195213702387037 s2 freq +100000000 delay
>>> 2301
>>> 2021-02-12T09:24:40.741489+00:00 bench-12 phc2sys: [195233.452]
>>> CLOCK_REALTIME phc offset 195213591220495 s2 freq +100000000 delay
>>> 2081
>>>
>>
>> Thanks.
>>
>> I think what's actually going on is a bug in the
>> ixgbe_ptp_start_cyclecounter function where the system time registers
>> are being reset.
>>
>> What hardware are you operating on? Do you know if its an X550 board?
> 
> Indeed it is.
> 
>> It
>> looks like this has been the case since a9763f3cb54c ("ixgbe: Update PTP
>> to support X550EM_x devices").
> 
> The current test results come from v5.15.49-rt47. We observed the same
> problem in 5.4.93-rt51, which contains a9763f3cb54c.
> 
>> The start_cyclecounter was never supposed to modify the current time
>> registers, but resetting it to 0 as it does for X550 devices would give
>> the exact behavior you're seeing.
> 
> That certainly sounds plausible.
> 
> Thanks,
> Alison Chaiken
> Aurora Innovation

I just posted a fix which moves the SYSTIME clearing out of
start_cyclecounter and into ixgbe_ptp_reset. I'm fairly confident that
its the correct fix, based on the function comments. I think the
implementor for the X550 simply didn't understand the separation of
ixgbe_ptp_start_cyclecouter and ixgbe_ptp_reset.

Thanks,
Jake
