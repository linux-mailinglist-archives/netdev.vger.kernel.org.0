Return-Path: <netdev+bounces-10221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A2572D078
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 742FF1C20BBA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADBB522C;
	Mon, 12 Jun 2023 20:32:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ACBEA0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:32:01 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28999C0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686601919; x=1718137919;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eNOy5Yujjys7vTdWlcjoLAaeL60UqQzYCnr2TgDhTLg=;
  b=SDvLFo4PLFIxr0WY9WanzTTprT1YzrBaYCqJgpjkvgNePfcGzp4tSMA0
   DlKU655x0TvMeeVz0Yaql9xE0+gafibjGKQdociT97WqUZ43zuiwgaUoI
   H78dy+3Q0IJ2U5RV2jHu9OMSMBA3uSEHtpMeO2tFonk9ROODL7pF82Z9G
   OVaLliTcwZTwarpyswL5DiYa98vEuNH/VFF04LDaSJr9xH5c7EvdW7DXT
   jcU+GqgIDHIs+ygYjI50ZBnxQUh5lA0eRG1VVj7Jir5G8s3IrX09QPCmc
   TeXjtjz+1YnLZ8Q/8LE9WfT8xzRaKkscuLMg4jRaq1YwZbpPYwPi2guV8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="424036018"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="424036018"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 13:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="688777100"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="688777100"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 12 Jun 2023 13:31:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 13:31:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 13:31:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 13:31:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 13:31:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjfF5YEukTVDAipfmN2aWw7pJDBS80yLNsBoTl0M822cZEJxr5e171UWX4B8N5pUCb4fbOZjhoLeHP6tin5N8b20cUxhHEnfoAH2nt22jxXbmY6qMKBZB4yzE9D1TqriSLKoTksx7dKaoieV05EoZcF09rtw1DjzuQ7SFUCXM64YpKr4GMy4G0UyUBfVaD/+nEh9xMrDY3H+hJCF9iDfUjxYrZ37Iam90L09HECMwtyVbAfUWF4FH0j1lCvPQBmYp2gwt4DOFCJOnqPxMR/7AwmXqLWG1BXQljitr3qIOIQh07fGQHkuAK+rgvfWC0mddqGdqhifTylh2Q1NMQ9GBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JjQMyuFNw7rvwgBGHrtxkMqjvl323kTQ4i4uMjnpvM=;
 b=mDEuUZm4N3tBix9neAY2QucY7DycNHdsF10sVlHSAENUj6JoD0lZLTKdDQLaFepNB/tCDbOHRswLR0BOeDb2fAhtucStY+1jqAxDJ7rOC08EM9vqNRIL9uZNdcJr86zgdOErvebcuZkz1bvpo1w46n2uquK2BQQKvsMHrS6elxKucXHCwo3bOoQPHebc2vRpa3W2LpRhFIOo+3M/44T9m3sNqUzK+gl4Oggx4wX/m1EGhX+3dbwZpMJZvflY4JpEHLz3cUB3uoItovY2OoHYoA8TFb25ncvwD0cPztE4J1vDK2A7Wb/r+0Ga83ot33/AHKQxGHisKPGCu+RipF/jvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM6PR11MB4563.namprd11.prod.outlook.com (2603:10b6:5:28e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 20:31:32 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6455.039; Mon, 12 Jun 2023
 20:31:31 +0000
Message-ID: <a4469ad5-7bac-3c2f-24f9-b2acc882e6c6@intel.com>
Date: Mon, 12 Jun 2023 13:31:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2 3/3] igb: fix nvm.ops.read() error handling
To: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>, "Fijalkowski,
 Maciej" <maciej.fijalkowski@intel.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Pucha, HimasekharX Reddy"
	<himasekharx.reddy.pucha@intel.com>
References: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
 <20230609161058.3485225-4-anthony.l.nguyen@intel.com>
 <ZINTSVYbu9byMMFZ@boxer>
 <SJ0PR11MB5866D9C9759CD6409EECFF00E554A@SJ0PR11MB5866.namprd11.prod.outlook.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <SJ0PR11MB5866D9C9759CD6409EECFF00E554A@SJ0PR11MB5866.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DM6PR11MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 105d9c57-7e2f-4af2-cd56-08db6b84018e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILCO846aSDrs2aMRTz557CQNwxHkxHaFOpyfno4OvnYYrkAndYZlC724e0NpABfHOQyKXuEHaqSrsh5h71PzTP9rS9Gbq/QmMQshFtjo+m8wo8Xz7N9/W0YrDHq2puKr6P5HUJ2ae1ac2shgoPbsX8rJ4F4V6cOAAYMvraNoPA+Xy3Mqf6x3spumFn7jPjbcvlWvJavmRJTwdiw0pQjwwbLcch0BzY1AsLBOnW3Gn5OREB9J56QoWFlGcw05C6ObiWiNGmQIILaontVmgW2lIVYBDlDpItT9jspeJpEEMSb5e46f1P62pnRVBklN7HMymbXY+wwrmceBn3N16V3NJRLhIbWiv6DJt7T8kkmZ4ze3fFC0HrrVt9ouJ70ACUQfvWX3AoMU3Of4/o+kAZcQfMAhRB39IlAQagOtGB1/T7XLVy70535WObrtMg0ZuvGN4zxZ2Q2WFt8IUKTR1e9KqIgjd8LE/JkJ+ieTbawrWvmvhf7ZBqqS95l+oRElx4ZJDUzqote/3z88IAqcraQl+RTbdoyfHbFcgmDPkN0e29kYy/HXVpQsCmZMtDgRMmPRix5tOhavQvWjSfXWASVlkeL4zpSl1PE+t1BO9MgCRPoCxTQxHyyQrF7+di3RwaasF0iy0p+d4UmvLrOwIpOYag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199021)(4744005)(66476007)(6636002)(4326008)(66556008)(66946007)(41300700001)(316002)(110136005)(54906003)(31686004)(8676002)(8936002)(2906002)(5660300002)(6666004)(478600001)(6486002)(6506007)(26005)(186003)(6512007)(107886003)(2616005)(53546011)(82960400001)(83380400001)(36756003)(86362001)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0t5QkNvQ3hnc1RkR2dvZ2IxL1ZadnBtazV6RDRWMmdXL3hoMi9JUFdlalFL?=
 =?utf-8?B?TU9xRDNSUTZDRHhPaGtmUllqSEkrcjZtSndybVNCVStFTTh3cFJCaXhjWFh4?=
 =?utf-8?B?bHdtaDNzeUJUSXl2OWJ0b1hZM29nSUVHeFdEbWQzU1ZPdzNsT3orU042RXlE?=
 =?utf-8?B?VHNYb1U3ZWhsam5IamlWZ0NMY1gyT2xJUFB3TlUvaVRFWUIrbXNhbWI4aWRi?=
 =?utf-8?B?WlY2TkZxR2hBVC9Vd2J0UmdQTjRIM2NhTklEN3IyRS9Hdlo1OVJUSzBBRjlX?=
 =?utf-8?B?SXFaZGJ1MDFxM1JpMzFrSW1XZTRpOEo1bThYVDJRWW5KMk51NU1LU0pMYXBl?=
 =?utf-8?B?OWEvMnMxRWlRb2dqN1lhTkxqSGpYdkQzTlh5aEVsSWk0cGdpSGwzeENGZXVi?=
 =?utf-8?B?VTh5Q1c4VzJTOWxJM05LcnVsenh3OFQ2QmxjQU1FQUxja0ltMmc1RTJ6TzNM?=
 =?utf-8?B?RmRVNVAwL2h6Y1U2WGVYRHNURWJJOGc5UWQzWDJ2NzNMTlNhMXYzRmNlOVFq?=
 =?utf-8?B?TittU0ZrQW92bWpwcVlMa25GK3dpUGV4TWdvWm5rVzdvbTVyRGFUOEJ3eno1?=
 =?utf-8?B?bjJqV3lUYUlRRURKbXFBYm41RS9Id3d0WlR2SWdGTHhtNXBta1l3Smszbmt0?=
 =?utf-8?B?YWdia3dIMHhudXo0WEVtNVIyUFJ3T0YzMEh1dVh5RGNleEp1NnRmWk9rNUVr?=
 =?utf-8?B?bjJDWFh4a2RCd0psQ1E4OVRYRE9tczU2K05IZ1hTbEpUVzJQMG1TWHgwbnNv?=
 =?utf-8?B?SnVsRTJhT3BhYmZmZUFKbXZRbStlRU9TQWZzZlhlNVBKOENqUzExZmJsWWtp?=
 =?utf-8?B?WDZTMGJzTkxBdEpiYjF3TFB0akVkRlhsc0NQUzMwd1pyQndYTWNvckZiNmdY?=
 =?utf-8?B?eVdiTmtaNjFUSUJ3QkpPSEF1RDhtU2UwVlhkdUkrY244U0hkVGNmTGRJbldr?=
 =?utf-8?B?elZxa2QybERENHlDYUlVL3lzM05peWorbVFCRWwvb3U4bkhBdnJ5V3dOb3pn?=
 =?utf-8?B?QURRV3VSenUvTkVtMy9EbHZnOGM4L3hpa0hPbTlXQXNSbjVUVFVoZUI1S0pq?=
 =?utf-8?B?Ui9HZVppMW14d01jalhkd21HT1QyRzltREZCU1o2U3JVMlhneG9EamNxejZJ?=
 =?utf-8?B?dTkwSUN0MUZTZUxQY2pGQnp2bGd1VUZmRndZcU5uT2lBWHVwd0QzdVd6aENu?=
 =?utf-8?B?cHBFb0JGeGc2TDFNRlhTeVhyRUVDTjZuNHVLYlNCclU2NGNWOTJyekZuajhC?=
 =?utf-8?B?RThDenVibjYvcldmS1JsR2FLMnhEdHhmS3gwbGNSSU0zQk9rdkJFQktBaUMx?=
 =?utf-8?B?TDJPYXhjMHArN0I4WFFheFExMXpnVVBMaFNZRVZOVUtLMkFHRDlIRmN6c0t2?=
 =?utf-8?B?alEvV3dxeHJjVlQrMGljYUNHeEtDS1kxdDJxUlFVOFIyOHpMbXpwZUlkeFFY?=
 =?utf-8?B?Ui9UN1hxaXVhbTVHTkIrTnczZmpIaFdycERiTS9TK2FuamNZTlVrdHZWckVr?=
 =?utf-8?B?MThmT0I3UmpQV3FXK2NDamtmYVIvM2p2aUh2Q2VsLzQ3UzVrbDNKZVcvNHFB?=
 =?utf-8?B?YjhaRWU4TzdhaU9UUWVKQmxOL0NiR203bEVwS1AyaGRnSjFnYzRNTzVCQTdv?=
 =?utf-8?B?eGhCVGptSTVHNjJ2S0QyYVgyblNnc0xrQk5RZDRVWUsrM1hXZTFNL2t0aUp1?=
 =?utf-8?B?SDVsM3I2aHFxUGVYazVkdGpnMjVxb0x6dGZVbHlPYytkUGxvbnRQV2pDVDY5?=
 =?utf-8?B?bXpMQnQxSWtyMk41NEZIblFaaXBQa3J2RkNYMlFwRjk3c0I2UGRUK1ZIU3hu?=
 =?utf-8?B?d2FFL280bTZsQUhxOW5ncS8zaUFodkF0M3ZHSStsZGx5REo5SkVpMWk5VEZV?=
 =?utf-8?B?cEZhaTY4WjN0cCthODI2ZkhIb3NNTm9yTXBTWVkzUkFObitLNkRqaVI5aTJw?=
 =?utf-8?B?RjBPWCt4U3BVUW5QOUtETkwzRUEzWWlVdk8xMElyRjRFTGhJakhSYjQ3Umpj?=
 =?utf-8?B?RUZGYi9vN1ZlRzdUY1NMWjhsTHRuMUlLcnIwbXh1Q2l2dHlFUUg1aUY0bkZQ?=
 =?utf-8?B?Q1c4YnVkemxJK2NNM3Q3RkJIcHp1QTZ3dVg0YmFCRjZ1UTl4NEErTmRWeUdT?=
 =?utf-8?B?WmNkak9LaDZGeTZacU5RTDVNNi9Xd0xZS0w3S0kxenVCQmhhdURadmx5cDh5?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 105d9c57-7e2f-4af2-cd56-08db6b84018e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 20:31:31.1033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70AtAomUoGtVQYg6IMIhma8pg0a5DI3l+vLx2TbaE+opXOE9FSDrQu1uHwNLok0/zcNVKHzmcX1E3tDL/EYJdAKmZP3y/dzVSgyZzd9yonI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/12/2023 12:42 PM, Loktionov, Aleksandr wrote:

...

>>> -839,7 +841,7 @@ static int igb_set_eeprom(struct net_device *netdev,
>>>   	/* Update the checksum if nvm write succeeded */
>>>   	if (ret_val == 0)
>>>   		hw->nvm.ops.update(hw);
>>> -
>>> +out:
>>>   	igb_set_fw_version(adapter);
>>
>> why would you want to call the above in case of fail? just move out below
>> and stick only to kfree() and return error code.
> 
> You're right it's better to move out: one line below.
> @Nguyen, Anthony L can you make it?

I'll update and re-send.

Thanks,
Tony

>>>   	kfree(eeprom_buff);
>>>   	return ret_val;
>>> --
>>> 2.38.1
>>>
>>>

