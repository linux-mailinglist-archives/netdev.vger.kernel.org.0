Return-Path: <netdev+bounces-8533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB3572478E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB8E51C20A74
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F672DBCF;
	Tue,  6 Jun 2023 15:23:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F93537B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:23:16 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB824E40
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686064994; x=1717600994;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aDeL6XIIf4x7PS2tiNOwvwhMHGraEX8LolZ3R8c8lLk=;
  b=h5JTJKfh3Jv8FXDebrtJYVvufyjaf0K9Bhk/SZKH0TsDc2UMRJ5F/rMq
   xiaSNE1bjugOxOI+OU8tgobUMykpKHIKkIQy2vwCzoCSd4gU+uSQ0aeWe
   ecXGC/bW5TI7uwEWMVvE0r8YhH5sPdoMid6l4qWnL1QUJ1FgUC0eaAnGQ
   scZWJ8seIrHmU8eoXLlCu5ptV1MAOhUGyCcJPJ+1dC9eElwdr9NR1LhBs
   /PJ6vxEMe4wZV/rIVXnV3L5RluRznG4Mkn7u7l0HoV4c25DYTqBtJCaGy
   wx8EcuMI6wCmJ8XF/uNBMSnv/J3p+Ngi9zPBecobe8Y/23A4UzxjJTyEe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="356717962"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="356717962"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 08:23:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="798898749"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="798898749"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 08:23:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 08:23:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 08:23:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 08:23:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 08:23:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLTHUBHmYquADon0ZFgoAlBdnsC2ggZ0jpXEC+MWLuJNqFpQjNt6+FbQyKDy9aFW4H1WSEUe3nrj7YxuQUVH2UVoJ1qcXAieIy6d8v/NBXnWXnqMnc6NebMLErdwl0l+eEkMtuAD8zHMP+jI/2mzUAEi0MdJO9bo3VZkc3G0RRTbXOEbTDYNDB10wkntsUkB5LI5xUtGElIQrMGzRi5BL4EUnnENUlWERNUPoJWxI9be8P2Zqk+Vu/fbXYGHQDpuIb/M8gy+JPPedfQdRru/gHR186JHb1ae0UpdBwwsNwHmbaWqKSNP62M0u35HkdaR7um5scdF3J/msiUjygYbkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCes8Ei14r0c18pcNvarJUfM/KMaaIXPJ4go/UgPXCE=;
 b=f+vGr5d6wkK+fIuImVol7TQd4ieqljaip0DaTDrm0skbtKXyhK1bD0kizJfaY40mn50r8ph5POL2fcnVyXlg/GRA7RXVbIOOCd6tUBvhJH5uEbdNHo1xhW6PV6EUvn7DuDIV5ejCuWsk6zfslGJpATQ+JsUooTSM8coST0URWvWlHgTb+oqxNIr07z0dkWvuUq1lOSNoAAjVsum4XMCDBYsvurui2vohOsecA87eeEYqjEk52USq1MgKBXe0JxsaonHRkDusPCeOS4pGBEboRCmuh92Gd2oqEdA7xUzatNTBEDKBg3Mm33XmtMlIH5lWWxm+ZgaA5oW7KKFNIxdZBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20)
 by MN0PR11MB6207.namprd11.prod.outlook.com (2603:10b6:208:3c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 15:23:11 +0000
Received: from SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::5194:555b:c468:f14f]) by SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::5194:555b:c468:f14f%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 15:23:11 +0000
Message-ID: <7e80c3ba-38ca-eda7-45eb-ff67628e7357@intel.com>
Date: Tue, 6 Jun 2023 09:23:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Rafal Romanowski <rafal.romanowski@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-4-anthony.l.nguyen@intel.com> <ZH42phazuTdyiNTm@boxer>
 <9b4c8cfb-f880-d1a0-7be9-c5e4833f3844@intel.com> <ZH8J5ZypMeSESSZd@boxer>
Content-Language: en-US
From: Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <ZH8J5ZypMeSESSZd@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0112.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::11) To SN7PR11MB7420.namprd11.prod.outlook.com
 (2603:10b6:806:328::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7420:EE_|MN0PR11MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e6b46f-89e1-4c80-9f37-08db66a1f019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kdu1pyvJgZML+r7uxahgM+hyU1Tq3DfS23kAXIiEWLXPTXCv1x8yxtAA+g8YdI0GvgX74+7RmYfOJldxGzs/XAVOV4c5CHedDPvlZ0Br8jvhK/8U0ULsg1ZixKb8CtNa6E9TfNBVz5tOIwaz1c4gyk4cVrekmsGi4MlU+q3geGK2cIbrG6v6MVIGbSTCrmffMjpyNxGN2KXR5NR8kkIlyCcdwXtZip2uzSBh1OS6fldT4LFZ2QTsRDmuL672+J7GGHzNWw1etZveifW+ky8vaVg1Vd3PuJCO7wnZkKmZtDV7HNJgTUTaC780+s0X9xTLyz2TAEDYjmCgjROmyTsuoQslPmitECIIuhhytHW88UgkvBzpLA7ysKS+pMDWTc0N+EGalwo1vI27wXhA+BBiWWpxL/MaFHoMjWyuZ8WUh7wcD2i5qmsancVHxulP1O9mJ12/1vMNANSplYfShpSKD+utEJ9as6UM3AyprHSw49OItMp0L609ewhhaIEXFDQ/do9qNbTIVbLnpANFuzwYA+xAoMuohGruK+MxSg6zcrtz4JMEQivpK6Aw6E5+azZmfJhgTRnAHCMH2JWmU2dU77kvAVmAIq5ijucK0GX6eTCzQpCVY1yi4RAPvVnkI/bP1nU5vueyEiHtP4rcT22gIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199021)(83380400001)(38100700002)(86362001)(31696002)(82960400001)(478600001)(41300700001)(37006003)(6666004)(966005)(6486002)(54906003)(5660300002)(8676002)(6862004)(44832011)(66476007)(66946007)(4326008)(8936002)(6636002)(66556008)(316002)(2906002)(2616005)(26005)(6506007)(53546011)(6512007)(107886003)(36756003)(31686004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEtkVTZBUDhmREFTaVd5ZTF6bUZiM1M4TjduNm4waDJxdFNtQjlVa3I4bG9N?=
 =?utf-8?B?QkVyL0hTeThrSFlFSi9Jcm5EYkh5NE1yV0ZxWGRpanNVbnl2VWM1blN4bXdZ?=
 =?utf-8?B?ajlTbGFldS9MdkZWV3RZUXo1SnNsKzh3ZWhSbzh0QmlJb2RRQzFwdHhsaDlq?=
 =?utf-8?B?VnkvUGRGdFZMdGZSL2dQS1MvTGc4d0k5M0k3K0lnTHFhVklPZmY4cDJ2R1gx?=
 =?utf-8?B?WU5XS2NNU0ZKSG0xbWIvS3ZxdHZKY2w1eExCMHRsVjBXeURGaEVQbEc5MzF1?=
 =?utf-8?B?ZFFvckZ2WkNUZHI1ejNRWXNEWCs2Rm1rRExvc2x3TnBBRFl2alQ5WktuOXl4?=
 =?utf-8?B?RnpNbUlPd3RpVFlZNTlvZldzVE9seGJLdnJvNTQ2ZG1oV1VQVFhSakVZdTYr?=
 =?utf-8?B?M3ZwUXZqKzdNTXhsYm0vOTJjS21SQ1NwQmhPYmJ3OXZyazR4WHIyQjV1Qzdo?=
 =?utf-8?B?Y3pRTVMxNjVFNk5kVTl6dVVDWHBmaHZQbHdjcnE5dWd6bk8xdUpqdnI1RkVX?=
 =?utf-8?B?a2tBbDVKbVJDNGFyUFI2anB5OTFYSTRTZnN5VkljZm50THFpOGsyWUlhK1NS?=
 =?utf-8?B?VkJmZGltemMyalFRa2xWT1kyOGJWajFNc0JnbHpmaC9sTmRnQ09wVGd6RmlY?=
 =?utf-8?B?aHJwV3Q5UEVVU3dCdit4NjJramRqZjBzRVZkZCs2dUptUmFvQnVzZzBDQU52?=
 =?utf-8?B?RlVUamUxUG5GcU5nejZLN28ydm9MTlJXaU11Myt6YlJlNmI1aU5nVEE3WjJl?=
 =?utf-8?B?eFNwNmFEeWV0WmxZbHo1YjFUZDdJVW12VUtxSW11SlM1WmczQW55QXlPbXRJ?=
 =?utf-8?B?cDJ2VHpvcHd4aEkxSEc1dWtaRzFSSHFkeW01U3NWQzJYYWxmMjJIZXl2bkp5?=
 =?utf-8?B?YnFXSnlrRUtSa0RHT0NJY2ptOFBnUWVCVzFoUUhJazU2aVpoSldYWE15ZFFq?=
 =?utf-8?B?UXBYUksydERmYW5XYjNvWWRudGtMYyttQlR4V2FiWkZRekZPa0NORUo3ZU9Z?=
 =?utf-8?B?UEF5TEtlaVNPcUtocnRLWXVDUGRtSXgwN05qUWFQZFFRVUV6ZFJ6Q0Y5bjgv?=
 =?utf-8?B?TmFFVWYvVWM4M0luSElGdjUvb1Vsc1FFWmI0ME84TC80QVZDZmwxbHdINGRZ?=
 =?utf-8?B?SFlsUjJ2YVlrcE5Sdy9tdzR2WkZCVU5aVEdlMGowNVhqUzJOVk9UcWdWV0ZF?=
 =?utf-8?B?M2lHMWFUVWZGRC82d3kzdDVKanl4eHMwMDJiSWlqVFZjVUNVY2RmTmdwR1Yw?=
 =?utf-8?B?aTMreC9CQUl3VkhJcVFJanBXb2JBMGpseHFOdFFHR3NBeFMxN0RQY2dYRmJ0?=
 =?utf-8?B?S3ExWmZvUXFab3lMSG1wM1Q5KzFZMi9YRnR6Mk80RlNZZk5INHIzaGpQVFFp?=
 =?utf-8?B?VGJ3NUF3WEZaYXIyK3VSSGpVU1piSllUbFE3VHlkT3YzWGdabTJBQ3hPV2pO?=
 =?utf-8?B?V05McWVqdU02dzhxTDFIVS80SFpCaVFvdTdPVmxoS2pQM3JQVVl2UUxaTzVk?=
 =?utf-8?B?VXo0VVhreEx3bFd0N2RBUUdaYUVqN0VCTGFKWUVkMnluZ0x3Y1FvMXNwRVpi?=
 =?utf-8?B?T3hQUHIzbmhETVNoR3VJb3VXcmhIZ0s5eDJQUjI0UWlONVZ5SnpLdEJsNzVV?=
 =?utf-8?B?ZWtBWE96cjZvR3BhR1NjanVXajNTT1RUWjV0amM5MWdNb0EremVnZXhJRms2?=
 =?utf-8?B?eTJ5KzVCRjd5WHRTVVgwZmpMNGJIMmRKekdJTG1OUUhFa1hoRmxWZTNqajJR?=
 =?utf-8?B?bXNQYVJsRit6ZjZHcFVKNks0N1hqankvZFdqZXJQZzVTV2J4Ulljb3RtZHpa?=
 =?utf-8?B?c3Z3Zm1hc1VUNzBzLzB3THVHU2ZCM0k4VnhQTFA2Mjd0cGdXdTRyOXdWUkpH?=
 =?utf-8?B?bzFob2ptYlNTMXViUWpkWS9aN0N2ak9QUGhHOTQ0aG1DYUxPc1lFRDBHSG9p?=
 =?utf-8?B?d1lxbkFpeXFzSnVrZmVMdzlZS1dzUmVuelJIMjhmcUN6VVRYTUd6aU1PK3pZ?=
 =?utf-8?B?cnl4UloyanFVNmZDTS9nL0NBRWZQK0thaC9KZC9CRUVFU1dtRmdGNEZWNGFi?=
 =?utf-8?B?SGtjZlpBeHFiQ2s1NzNHSXVSelFEMGw3UG41dHVGcWw4ckh6Lyt1V1IrYm9T?=
 =?utf-8?Q?ictlAzs/Xm6sa50iRgzm+IRwY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e6b46f-89e1-4c80-9f37-08db66a1f019
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:23:10.9687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwRDUp7uc+qv9ZIqGnmKZIGOk9J8XlYcLusVy1/QK7HlRMYVWA6+46Rai9YjOFr/+CA66jQnJnnzMgFRXRFyBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6207
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023-06-06 04:26, Maciej Fijalkowski wrote:
> On Mon, Jun 05, 2023 at 01:56:48PM -0600, Ahmed Zaki wrote:
>> On 2023-06-05 13:25, Maciej Fijalkowski wrote:
>>> On Fri, Jun 02, 2023 at 10:13:02AM -0700, Tony Nguyen wrote:
>>>> From: Ahmed Zaki <ahmed.zaki@intel.com>
>>>>
>>>> Enable more than 32 IRQs by removing the u32 bit mask in
>>>> iavf_irq_enable_queues(). There is no need for the mask as there are no
>>>> callers that select individual IRQs through the bitmask. Also, if the PF
>>>> allocates more than 32 IRQs, this mask will prevent us from using all of
>>>> them.
>>>>
>>>> The comment in iavf_register.h is modified to show that the maximum
>>>> number allowed for the IRQ index is 63 as per the iAVF standard 1.0 [1].
>>> please use imperative mood:
>>> "modify the comment in..."
>>>
>>> besides, it sounds to me like a bug, we were not following the spec, no?
>> yes, but all PF's were allocating  <= 16 IRQs, so it was not causing any
>> issues.
>>
>>
>>>> link: [1] https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ethernet-adaptive-virtual-function-hardware-spec.pdf
>>>> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
>>>> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
>>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>>
>>>> ---
>>>>    drivers/net/ethernet/intel/iavf/iavf.h          |  2 +-
>>>>    drivers/net/ethernet/intel/iavf/iavf_main.c     | 15 ++++++---------
>>>>    drivers/net/ethernet/intel/iavf/iavf_register.h |  2 +-
>>>>    3 files changed, 8 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
>>>> index 9abaff1f2aff..39d0fe76a38f 100644
>>>> --- a/drivers/net/ethernet/intel/iavf/iavf.h
>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
>>>> @@ -525,7 +525,7 @@ void iavf_set_ethtool_ops(struct net_device *netdev);
>>>>    void iavf_update_stats(struct iavf_adapter *adapter);
>>>>    void iavf_reset_interrupt_capability(struct iavf_adapter *adapter);
>>>>    int iavf_init_interrupt_scheme(struct iavf_adapter *adapter);
>>>> -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask);
>>>> +void iavf_irq_enable_queues(struct iavf_adapter *adapter);
>>>>    void iavf_free_all_tx_resources(struct iavf_adapter *adapter);
>>>>    void iavf_free_all_rx_resources(struct iavf_adapter *adapter);
>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> index 3a78f86ba4f9..1332633f0ca5 100644
>>>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> @@ -359,21 +359,18 @@ static void iavf_irq_disable(struct iavf_adapter *adapter)
>>>>    }
>>>>    /**
>>>> - * iavf_irq_enable_queues - Enable interrupt for specified queues
>>>> + * iavf_irq_enable_queues - Enable interrupt for all queues
>>>>     * @adapter: board private structure
>>>> - * @mask: bitmap of queues to enable
>>>>     **/
>>>> -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask)
>>>> +void iavf_irq_enable_queues(struct iavf_adapter *adapter)
>>>>    {
>>>>    	struct iavf_hw *hw = &adapter->hw;
>>>>    	int i;
>>>>    	for (i = 1; i < adapter->num_msix_vectors; i++) {
>>>> -		if (mask & BIT(i - 1)) {
>>>> -			wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
>>>> -			     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
>>>> -			     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
>>>> -		}
>>>> +		wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
>>>> +		     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
>>>> +		     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
>>>>    	}
>>>>    }
>>>> @@ -387,7 +384,7 @@ void iavf_irq_enable(struct iavf_adapter *adapter, bool flush)
>>>>    	struct iavf_hw *hw = &adapter->hw;
>>>>    	iavf_misc_irq_enable(adapter);
>>>> -	iavf_irq_enable_queues(adapter, ~0);
>>>> +	iavf_irq_enable_queues(adapter);
>>>>    	if (flush)
>>>>    		iavf_flush(hw);
>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_register.h b/drivers/net/ethernet/intel/iavf/iavf_register.h
>>>> index bf793332fc9d..a19e88898a0b 100644
>>>> --- a/drivers/net/ethernet/intel/iavf/iavf_register.h
>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf_register.h
>>>> @@ -40,7 +40,7 @@
>>>>    #define IAVF_VFINT_DYN_CTL01_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTL01_INTENA_SHIFT)
>>>>    #define IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT 3
>>>>    #define IAVF_VFINT_DYN_CTL01_ITR_INDX_MASK IAVF_MASK(0x3, IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT)
>>>> -#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...15 */ /* Reset: VFR */
>>> so this was wrong even before as not indicating 31 as max?
>> Correct, but again no issues.
>>
>> Given that, should I re-send to net ?
> probably with older kernels PFs would still be allocating <= 16 irqs,
> right? not sure if one could take a PF and hack it to request for more
> than 32 irqs and then hit the wall with the mask you're removing.
>
Unlikely since the VF currently never requests more than 16 queues, so 
any IRQs > 16 are useless.

The "fix" is needed for another patch that will enable up to 256 queues 
though.


