Return-Path: <netdev+bounces-6925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA77718B22
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC3161C20CD5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8223D387;
	Wed, 31 May 2023 20:25:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FBA34CE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:25:49 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7854101
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685564747; x=1717100747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e4FNTrI6AKiq0caEYfmyF7u9AHkl9n0eGvnHc9D7uYQ=;
  b=CvzvMy1lfYzTL6XMqj+CpknZ2S/4Np5QQH0MP77wpN7hP0nIhUXLHTsU
   1ViQlJK8UQzsjgYTfSZ9otiNbO6JhFZsQ+ZSEusXaEuP/BD7J8JNfHN9W
   lK+tl8PNzZyiiM3WiWau0PXCwngkDn1lg5nmyhaA2TK/LhGMbC2czedOw
   RKM1bmeiBsWM0IXHi0BakfkB31xSVAM6w4S0DlwTCbMTBrh3AUxX+y1rJ
   GFdnXqFO6thQsjEawq9QwW+W0IA31AQlLZfL/vnUe/7KTEPlriP1V1sLD
   8psu7ubPU2bjGwZIbczVGHSZ0rFIN41INbeHP9VTedklQSEkRXZWxlab1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="421131480"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="421131480"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 13:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="1037192821"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="1037192821"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 13:25:47 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 13:25:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 13:25:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 13:25:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/NU1GkMw7rgw3ZRjkQIVDEZv8oPNDK0gg17NZVAFG2IbjR7luhNs7AoEvpGCoF7zkv7gQ0of9QelgnO0HASjx8ECsm5Svfzxh++1k3IZlMJcQJDLsu8Vl8OhrVr/Hmm/LlQrDYoQFWd06oC4cvYuwlYs7ZO04BzFrWUTvxR/wNR8HTEgvHXUykTVqdXDohKWL+4WqYl6/SZGl01OTn7gskZ2XcRNNtJOjDw1dsWmH3wixtTEEE0XPXbNKmhVX1yYN8DjPVtm7J9NHEl/jP/+N2aHG3JUhJGvLmq8/iPZGpKV2qy+Z2loh26sUGP8Ucs+mQ/LgSoVI9/Ro26QeaaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlwUUkRdPqlbo7JKPFiJS3DW51FiIgKUbtM8tJhcyjs=;
 b=h+dOTEqsUXPgv8XTJZfDd2FXF/GT5z6x7zIYTLVSbTw13lEKgbSCQz1qGONsy24+yEyHp6R7wxK0CCsL775XuyXoMEVnsqp9PE6evOkCnZmFBMfwxiMyoP/406L5bzh7E4fw4vnl/OER2zt9hmniOmH3F3rAnsz3E+UhQY4zWB9RCXlUakeArEVszsNYXQsnbsAT4snfVe6EI5C1AHceHtYuO9N96jNwtq5mrJ5T+ZydlFquBkg61SmN0F6wbVeqtcNHYb3xpJJh7hrPFn6bJQLBrqcsq0R1k8APeY5DrOO9tYASVCQg6cnh+xImvQaCogZfX/B9AhTVTWm3XEgvpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MN0PR11MB6134.namprd11.prod.outlook.com (2603:10b6:208:3ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 20:25:44 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 20:25:44 +0000
Message-ID: <71622540-4500-5201-1fd0-8d5c76aeb2a5@intel.com>
Date: Wed, 31 May 2023 13:25:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 02/15] idpf: add module register and probe
 functionality
To: Jesse Brandeburg <jesse.brandeburg@intel.com>, "Michael S. Tsirkin"
	<mst@redhat.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Phani Burra
	<phani.r.burra@intel.com>, <pavan.kumar.linga@intel.com>,
	<emil.s.tantilov@intel.com>, <sridhar.samudrala@intel.com>,
	<shiraz.saleem@intel.com>, <sindhu.devale@intel.com>, <willemb@google.com>,
	<decot@google.com>, <andrew@lunn.ch>, <leon@kernel.org>,
	<simon.horman@corigine.com>, <shannon.nelson@amd.com>,
	<stephen@networkplumber.org>, Alan Brady <alan.brady@intel.com>, "Madhu
 Chittim" <madhu.chittim@intel.com>, Shailendra Bhatnagar
	<shailendra.bhatnagar@intel.com>, Krishneil Singh
	<krishneil.k.singh@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-3-anthony.l.nguyen@intel.com>
 <20230531015711-mutt-send-email-mst@kernel.org>
 <95b50b5a-4c76-ac02-37ae-afa176b4ea62@intel.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <95b50b5a-4c76-ac02-37ae-afa176b4ea62@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|MN0PR11MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db3f6d1-2568-4ca5-13b5-08db6215359c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3kL0z2bnIFseWi02yJ5oDmFXX9MjSTh5hQjs1+1BBLE2MhQeQjq0MvMwpk0FKnxBlSxjbN8gu3tNpkuUQgQloEHRY0v6O4lAgU6B6Bm8FQcWgZzpNYm6zVCsIAysPb6i8vD8ropFzCwVTcIWm9r7e25cx998Z3XbG5nfXZ8hXTB+Iu2s7fW3S/wloM626q9QzS79nuTWKucvSLbRzvJXxWjlmMyKfhmmWpsm/bD0K+W4/j009Je2MjHpW86EV7fuZ0nhpfWaVh3PrqI25XBEXCZpzBGm5alFO7AzUr2ULaLr0NdB7MfnwLkibF+wZV/VJ5Snx8DMzJNMDDwTFbDktob+HIJHO7q4thBH5ytfCEWasQPfFrS716LgsGfZx3uZHYdg7CFBeGpnGVe4agCv/x7giR+MzLeFsLU/p0GQFR6HvqcOvEzFJ2aKabXZeB63knTWzYdersAKGTztiI8wyHukT1L2dwxF4Vs7pzwaXaQYf6AdDL7msOz1YHur/epBRjoPXBz+bATi67yDCdbIbpRRISuYn69fwflbA7unjKHbDx2YJcZHcPDRiteRk32ZMGwWWmwYZWl7W5H+F75nY/n0oA3FWpgjJ7gQoRpEoWjNhTgp5BD5QIrI3WnKoC31c6EQ30cJ7ejeVhfo+SJBBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(54906003)(110136005)(5660300002)(8936002)(8676002)(4744005)(2906002)(4326008)(66556008)(66946007)(66476007)(41300700001)(31686004)(7416002)(316002)(478600001)(107886003)(6486002)(6666004)(6512007)(6506007)(53546011)(186003)(966005)(26005)(36756003)(83380400001)(82960400001)(86362001)(2616005)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEJZcmx1cjBmWk16ajIvSHBqdzlva2h3dmFIWDVvbGwxUXJKRG5wd1dyS2cv?=
 =?utf-8?B?S0pmN1RhaXZ4TWNGTXhEZytOeUNKWmU1aFhIejZXU0I4R3A1eTQ4R2IrdXp0?=
 =?utf-8?B?NzY4WWloeG1EU0RGWDFiSEloeTFkSnpMTFZmYWdGOVVVNnJ2cXM2ZDhsN29Y?=
 =?utf-8?B?MWlqQ2FqRW8xdUd1dTRVb1Q2QzVQNTZ0L1F5MkhEY09CaGFIYTdkcHI3YVBp?=
 =?utf-8?B?N3BFaUxYemxhckU5N3Y2d0UyKzMxS0FrQ2pCUVRVSXVmZjM1L1BIZHNkNHJI?=
 =?utf-8?B?M0w5bk9hTndWZHh1ZnVmNW9saWlaNmhZQ3FyZEs5MU55dDRTRVBlS0t4Y1Bw?=
 =?utf-8?B?UWxFMmV3VTVFVDM5ZEk2c25VOU1lYUlsbi9UbzNZblI3OXJaNXMxbGRWbVAz?=
 =?utf-8?B?aTZNZDFiMUJiWWZIUVFlbW1uUDU0KzNxZ1E4cTFSb2xIV2tpR29hNUx6ZVVO?=
 =?utf-8?B?NVZla28zMDR5NWVJTWxra1dpSk8vSFloVmU3N3c3S3RjZzRCbWVFZlR3ZUNY?=
 =?utf-8?B?eUh5VjVQcFF3VUlXN2VKZ3dBa2xrVEdTcVkwcjI3SVhiQzZWUy9iSHRpUWpE?=
 =?utf-8?B?bUJMUTNJcDRZNFQwYy8yN3VMUGV3RGkxR1JSazV4Z3ZHd2ZoK1hISWFUNlZ6?=
 =?utf-8?B?OXdleHgwUDdweFZiemZsWVREUjFYOFdHS2JTdzRoekVlRHc2ZU5RK2pHRkwv?=
 =?utf-8?B?MWRYL05xODJ3NXBJRVh0TUpVZjRuZk1pdXhFZTd2TExhRlJjbEVVOEp6WWV4?=
 =?utf-8?B?RU1sL2FUenZFTFVNZzhOSEw2ZWJJc1ZvK3hRSWlDOGJ6SG1DNUdGRFVUYTJ6?=
 =?utf-8?B?N3hFL1drbndqUE9mZTJUSHFvY0Y1K3NRU1RoYU9YUFdteTZUWXUyMUlwVVRa?=
 =?utf-8?B?RVc4Rmk0VmpRWVY0M0EydDFNM0RXTlcvSXIzc3pXNzIzSjRnK3VwcG16QUZX?=
 =?utf-8?B?UytWZDdjQ2hDQWhhWnlRSTgxRGpOcC9sVi9RY2dZRnBnOUdLc2xGZ1E3cDZa?=
 =?utf-8?B?WklHaDdKaitMaW1CcS9aVFNZd2VBWVJWdEJ4U3FONWJFZkhlNkcyWWRlR2F3?=
 =?utf-8?B?THM4YmNNamdlQXlDd0o0NmRuc3RtL0NlQlRmc2Y2VHhGZnBkUzhHYzk0R0RN?=
 =?utf-8?B?dGhRaEFIdTNwSk9oTVl5T0F6UUV2a3k3anhBUmVuUnRzSzQ3WFdFU1hxMk45?=
 =?utf-8?B?enhPOGdJQVMycWxNazdTSTRIQUZUUkdEeHAxMUtsK3BFM0IyMFZ0d2IzWXhj?=
 =?utf-8?B?MlZ1WWRNTFlrZzgxZnR4WnA4UGVkQlU1TnJRWDBRcVBPbkRydlRpSUNEUTkx?=
 =?utf-8?B?VmVWWXdzSkY3UUxRR3dHYjhKMGIrMVFVNFNtVlA3YnJYOXJTZFRQUzZ1bzlX?=
 =?utf-8?B?cjg0TmFGVkFjYTY0Vi9taXdWVzNLTDhFSDUra0ZqMmFCWEE3YkVEemZUS1hX?=
 =?utf-8?B?emd5amVJeHZaT1NOUDRpSnhuT2ZYTHRVK05RR0ZETDF2M1FYeUpVTm5LUVk4?=
 =?utf-8?B?WFIrdUpwT2xwY3NvYnlXSDRwTTBycHVyQXF4WWZycEJHaEo3RVpUR2ZuZEJw?=
 =?utf-8?B?UUdtYitLV2ZNMlVVZENsU050OTYyVnNZRGQ0TnlFSG1rclFvWDhTWk1BcWxW?=
 =?utf-8?B?bU53UGZCOTdHOFhqeStYVHdWNUswbDVsS21Wc1c4cEg4anNWYm1lZHV4U21z?=
 =?utf-8?B?cHZ2UjVaVDNGTWd2VGZOYVFuODlleGRCQ2RRN1U4cmdLM0trNWNNOHVqcFZI?=
 =?utf-8?B?ckc3Rm5PaTJ6WFFFWkg5b0w0N1h4aUp0NDdhSDBZMXdZYXI4WldXVnZaemJE?=
 =?utf-8?B?OHhWR05jWTZidlNHMzNLRTA5VUQ2WFgvcjhvRnJDOTBLZmE1N0JFTHkwdWsr?=
 =?utf-8?B?czFMMS9Kc3MwbStxYmQrazUzSTJ4eXZRNjhndE5sV3RJek5TZTB1OXdtSEt4?=
 =?utf-8?B?SnladFdxOHdIcFl3Rk0vNHplOGp4eUljZ2JUcmxWVkRMR1llMVRMOWI0YU16?=
 =?utf-8?B?QTM1dEdLNDdPUm4rYmp2dWQzdEtXOU5YQVMxS0NpMU90UkJ4RFVJbG1yQUhV?=
 =?utf-8?B?aCswdVhjbHBVRjZ0NnlLZDAwOEIyY0hnd1E1eXVUcTRpMXh6L3VjcGVPUDR6?=
 =?utf-8?B?M3k2VEdURXJrQVFlTXhId293WWFiQy9KVW9DS3ZZek1tdjRJUjZ0OHpmcy80?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db3f6d1-2568-4ca5-13b5-08db6215359c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 20:25:43.8989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K31VTe2RGv1paYOEH/n30UC26/lRMwTfrV/uB1sSCtFygEuiVWwKCqY+LM53VutBaSUCa3cxG38mvAm7k1MQHXhC/ZMVoXq2d3N4/aXjGCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6134
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/31/2023 11:34 AM, Jesse Brandeburg wrote:

...

>>> +MODULE_DESCRIPTION(DRV_SUMMARY);
>>> +MODULE_LICENSE("GPL");
> Just noticed that we appear to have missed the MODULE_AUTHOR("Intel
> Corporation")

This was in very early version (pre this iwl-next series), but removed 
by request [1].

Thanks,
Tony

[1] 
https://lore.kernel.org/netdev/20200626115236.7f36d379@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

