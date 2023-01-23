Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00B0678441
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjAWSOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjAWSOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:14:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5941959F7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674497650; x=1706033650;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rgeCrql2YGAAl5UX2IHkrHIYqGPYRVFrtHSDcstIsb8=;
  b=FOpRtQi68PzIVbuNg4uAJZTfxeDxse302ZeL2jc5Vh9pJLlv+eSYxevD
   k4WMg3K1pmumtV6JfwrgD+l90nAjuKXWlaeW+So5ypuZ356yN/1esPLSS
   xTypasetKdeCsLHbz9RtUHtZH5xOdCwJ7kUDPKHnU6XRGPBzfYsoL+1lK
   8e6Cc/ie6gB57AYR1j234f3epflb1LRDTF7xVDuuMXipPh8URvBvkzyt0
   AWEzV1TWGiyoKpb3PiUz1CyLeCtKh0YVIFRLVZ889X/oZX74e6WFISQfN
   0CCksEdJnk0IoHQh412wUXplsgNYrUyvYDqNpJbWOuuBnaHBTRcpAseNX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="327368887"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="327368887"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 10:14:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="730379047"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="730379047"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jan 2023 10:14:09 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 10:14:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 10:14:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 23 Jan 2023 10:14:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 23 Jan 2023 10:14:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwo5Ltn8DKrlu156uBE77FKg796h5wv/PUfBPaCv/6EVopqBlaCmDhdMGw3AQ+Q5Rkj44YvW9pYftENHDmAhz6GscA9YcErF5fwDzkCY/ms/eEKB9PSzdueDeQrrY6AHWglKscodF6B9m56yi/T0luF9WQK7ufRen8J4cVf3giGluDGI1mlTVrgG8uWm9ClUX39bjH6h6pad5Bjvyv/WkmTTXcFOtWhb2OZNaOhMaOYvlu9TNPnLOg5ZXUgXmtP/0zTHvJLAyzJVuOWt2QSuq+u8HhLYwbi4W8OMtq1g+rJCK5CGvISeAhmgg9pFRHKeuIT0QX3Zd3TJ18MtCmwuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tFUgsZoK6/zz7Ra/KXGQrkDx7XbsPjAmOKwN+hSbn0=;
 b=XPd1LZ8ADI8Okou6V8QEv+yJnbZ+xTV4bMLzkqtE9CcojQiAP3vnCxb/yRzz7nNr5dBQi+7Zl88kgk9h/N7n7BDjvoO20KYOa5/ENWRDySrP3gRNDPTREFXjqQwynvjtOXzhktK5P8XMzxO/Q5ezODCz7PIr6ZlTfO9z8QYYhfYYhUhOCMByBvmZ27OIIi1wIzKETSn0g5qlL+qwDSwyY03EoLMKeOmz9YwrAfjPTCllc6/4eEd/29XWzl2yS8r+lMC5+3fCAFWN4phhBBvp+VjZ9ibYN9Yb9obpiJks04qj8BpgXPI32xKWxPUe6PdMHCKYkqSgt2S46dAAhSYCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB7098.namprd11.prod.outlook.com (2603:10b6:510:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 18:14:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:14:06 +0000
Message-ID: <71c3e9a0-d14f-4748-dfe6-6a41b323818f@intel.com>
Date:   Mon, 23 Jan 2023 10:14:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-4-saeed@kernel.org>
 <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
 <20230119194631.1b9fef95@kernel.org> <87tu0luadz.fsf@nvidia.com>
 <20230119200343.2eb82899@kernel.org> <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com> <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <Y83tvS/b0NeSShpv@hoboy.vegasvil.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y83tvS/b0NeSShpv@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 25c7803e-6c94-4be2-776d-08dafd6d9d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q08JMnKzhfeaYOkpIaYLe+zYNY/nALDAdSTnLEJWdSxzZYOfm3KF4mVWr5S7EvC5C7mlcR/Jc4ydBoaUf7DlHnOYLwqNo5d0ZWZQKSgbGcGgPcetp7vuTMtZYlyZWGvd1YkgkkXzcesd+96wRZcE+y2M43S2pSufRB7rbcZEyJusmomr34+VDI7zQIdCyobrNzkbV2BhDiq0lZoiVyPhmGZ+eQQD7tRKE+4Fy7XEHmLGJ06raQdmzoYRsrITlqyotifRn6za8cGSbvznRkTtCPwpOgQtpmUQcY1YMFKeTFADt68ILWTzyzx1GL3vi2K09LDuUqWq1y9G/8Sh1kncve78+RhYMrbeVKieHTCE56H9fD2SDVC4LiCCISM89bIuEukPj3LbjJqYaazcn2XzAbtrpt3j9HBpbIbczcZJqJ/OnZ1ZlaN9jlYqnDsMnNPXIlsw9Fje5dnGDNtYGVYiAwEKjFF6ojrUYQcnYAqHDGqA5UfvaQhIxCM0CCQd7ODNbXY9+W4zqegJlNTbnBB41ldOF1uvsHqbx8lMCSeGhJKM0KpJ25DM8tHOV4HmF8w2uZfPDpAFfb4DOU4PG6pqBJocB3luH+dWlok/FY46uSpm9CEwfqnIe2LSkIcqv2WmJDEUIgkTDYdGCej+Da37W/vkB9zq/g+XG8JRewzcoh0NObuAPPzI8tWGBWtnd641E8fgw5pBuFDoTpDrs3mLDT8pSznpbY86Secw22mXUBw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(6506007)(478600001)(54906003)(53546011)(6486002)(6666004)(31686004)(5660300002)(66556008)(66946007)(186003)(26005)(316002)(4326008)(7416002)(36756003)(41300700001)(2616005)(8936002)(6512007)(66476007)(86362001)(2906002)(83380400001)(6916009)(8676002)(82960400001)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUQ5bTdpTmwyZmZ3bW9rY0o4MndxM1V2M1M4RW9renc3UmZKQThzL2JlREpV?=
 =?utf-8?B?L2kvNWZ6MzFWUzdCenRlWThnL3FzMmJYOThVY3ZxS2ljdDZvcVdkVjRPZVA0?=
 =?utf-8?B?bEUrcHkrWDh3Vmp5SmsvSWhDT0lLTVhUR2lseG5jSW85ZSt3cWZUalZCaGtq?=
 =?utf-8?B?UjVBTjFJY1Njb21QL3lTVVU2aVFsTk5xdUgyeGR3Qk1aaEt0SlcveHV3YXI4?=
 =?utf-8?B?eGVoNFhBUkViaEo4azBsM0ZIbkFmNXBCVHJWdDVuOWQzWVNFM1p5aG4xQzR1?=
 =?utf-8?B?UDNna0k1Ukt1b3JFemJoRjZlay8yNUJGMEYrVG02V0NQTE91OWFYb1o2QXdn?=
 =?utf-8?B?Z09wcHllNFVSVWNqTnJvVERoYUt2aE5VUmFZYkVRQW5tYnhKS2Ixa2hyb2Z2?=
 =?utf-8?B?alk2cFpaRTRCN21PMVdmbE5IMEdpZ3d0TzNvaWlQUnlWakxHN2d3blFjNThu?=
 =?utf-8?B?cHkrbU1ETGhPSG02TFVKU2RiUFpoVFZ5WE91TnB3ZEF4NVFWVisvQ0dPeWdJ?=
 =?utf-8?B?RkdEbTdjTEhIQ1VZVE9pMXdva2VVNkwxUEIwbW15bFluWXhJRTFlZ3dVWXdE?=
 =?utf-8?B?dDhDMzMwYXBZeUEwZU9HaGN6Q3hoeFREU0QxZ25VaGtDWnUvRlBYRVBRYlh0?=
 =?utf-8?B?T1FTeXplejlPMk9xeTV2VENMZDBHTGIxY1JMSmljRHNMZjk4aGJwV0FFOEpF?=
 =?utf-8?B?eklzbHFrVzNsM0ZNYitDQUs5OVlEc3VvTTFyTEh5U21yaGhJcGJNdlRUOEFr?=
 =?utf-8?B?bEl3QzRoMFJNSDlMWitYbnNKYnRNbFdiRnRzeFF4bjdaMmk0WkJDRHRqQ0RO?=
 =?utf-8?B?SUZCRnR5NEwrYmFYbi90UnJoZktYWGNGRnUybXhVS3RFNFpyRUNlN2NhbGF1?=
 =?utf-8?B?dG41UHpNMmVwNjJWd205UDY3a2o3b3ZBdEh1M1A1K1crUGtKY2pya0Z3Sy9l?=
 =?utf-8?B?UDdScURxc3Q5aERmcnQyaHZrdVFjdHY3VUF0MmNiZXVMK3N4bklHR3lXM1FL?=
 =?utf-8?B?QmZQK0oxTnpNZnFPbVB4TEgvaEUrQlhoOWYyTEdtd1JxU0pwRG1NaEpUQnFU?=
 =?utf-8?B?eHBsZXlPR0E3VkpKZ0hkYU5XbW5rNUZUeHhaaUxXSGxxUHBOSkJ5WVF2bG1j?=
 =?utf-8?B?SzlJcERSK2grSTFRVDlRUmZFdDBHc3IwODY2TEdTeDg1TXgwa2tBanBMUHRF?=
 =?utf-8?B?WmlIQUJjaE5qZlVlSjRMem1wQ2l0YktLb2dGTTBMN1NuSnc3cFZWMkRBOU1w?=
 =?utf-8?B?cVlLcmtOcXpONUdMaEZ3TU54ZTVPWGdFbEhBMngyaVJYbGxKSWZxTkoycjh6?=
 =?utf-8?B?aGQvSUR5NjAzUWN0Zmh3bkNWdi9HSGQrQ01MMDdENmlDd2R5YmpTejhoWXky?=
 =?utf-8?B?YUhhK2tQYUdPdzgrYVJKSEpYdVpFUHdQeTFOVjJIVlhPYlJBalJkc1p6R01w?=
 =?utf-8?B?TG1tRm9lWFh3c1ljWHJndkZjVGMwMXFIR2tkckpJUHRMUHBHZUdpdjRsWkFD?=
 =?utf-8?B?T1JGamVWbE1kUTVYaEFEV2o4dkJFUlAxbE1kSDBZOHZleVVtWE1HVzkxN1Rz?=
 =?utf-8?B?WEh1OXBoZTcranN3U0FxV3Q2ZERraGNnREpiaUlxT0RkUklIb05BTEVucW9m?=
 =?utf-8?B?c3Zadm56bDV6bFhNMHBMUitoUGZEL3lOSXhYakJ2N0kwbFd1WW5CeTVhUVIr?=
 =?utf-8?B?akpuNGhTWk5qVGtWTERJTVA1N0dmUk5icXVjdU1vd0ExV0RUVFJQQVlkdi90?=
 =?utf-8?B?azA1RlVNa3JEVnF5YjhIeW9uQ0VUeDBuQjNFRVNJQ2JGWVlTY2JNaXJYYVJr?=
 =?utf-8?B?VUZoMVQzQ0R3ZHRkSmRQWk05TjZNejkxeHVzSzNnUXB5cG1hRDNpWitqUUJm?=
 =?utf-8?B?bVMrNFRWVTUzYlNKN1JUT0s5aldPNUtScVdLVytYYmR1NlhvWkZWRitzV01z?=
 =?utf-8?B?QlA4dHZ4dkJucDFTeXlaRkZJZEI1K0FZKzFOQmxFcEorM1JoRWNxMWEzYVVI?=
 =?utf-8?B?TnBqZzJsSmw3SEpNTitIdXYwWTJsQi9QMVBoNG1tUGRqQ2Q3VG43SjlZV1Ji?=
 =?utf-8?B?dXgwbjhmWnNZeVJ6am9OWDdHOVF0QlBCZWFQMFBsaXJwUTRIY1VRZ2lzY2pN?=
 =?utf-8?B?cE1WalkxYjBsLzlTNS9YWkRYTnhrMDlmRUI2dkF1dWpabTZwRm1DVHkvU0E1?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c7803e-6c94-4be2-776d-08dafd6d9d4c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:14:06.0361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVhATy05tWtc4sOnL8byTNwUy2B9HHCFEYhDMCUA8TFQwRzBmuuJg9pel0omMv0BIqfk1iUnSIrQQoylCCFC9+uqduyFGDva6j7oJxyQFEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7098
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2023 6:15 PM, Richard Cochran wrote:
> Wow, lots of confusion in this thread!
> 
> On Fri, Jan 20, 2023 at 03:58:25PM -0800, Jacob Keller wrote:
> 
>> Sure. I guess what I don't understand is why or when one would want to
>> use adjphase instead of just performing frequency adjustment via the
>> .adjfine operation...
> 
> The difference is in where the frequency adjust is calculated.  There
> are two possibilities:
> 
> 1. It may be done in user space.
>    This is NTP timex's ADJ_FREQUENCY.
>    PHC implements .adjfine
> 
> 2. It may be left to kernel space.
>    This is NTP timex's ADJ_OFFSET.
>    PHC implements .adjphase
> 
> In case of #2, the hardware implements some kind of clock servo.  The
> inputs to the servo are the reported phase offsets.  The output of the
> servo is a frequency adjustment.
> 
>> Especially since "gradual adjustment over time" means it will still be
>> slow to converge (just like adjusting frequency is today).
> 
> It depends on the servo parameters.
>  
>> We should definitely improve the doc to explain the diff between them
>> and make sure that its more clear to driver implementations.
> 
> Sure.
> 
>> It also makes it harder to justify mapping small .adjtime to .adjphase,
> 
> adjtime is totally different.  Don't mix those two up:
> 
> - adjtime  sets the time (phase), plain and simple.
> 
> - adjphase feeds the phase offsets into a servo algorithm in hardware.
> 
> FWIW, the PHC subsystem handles the semantics of timex ADJ_FREQUENCY
> and ADJ_OFFSET in exactly the same way as the NTP subsystem.
> 
> 
> Thanks,
> Richard

Thanks for a succinct summary!
