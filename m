Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BB16A1890
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBXJOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBXJO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:14:29 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B42723
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677230068; x=1708766068;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sBWxBtp6TiGOnllZTuEh0NFZD3Y8bo0yns0lIVTfg7c=;
  b=ChxrjWHNQIyAKIJK+9NmT0CUh4rmKPNZfDfe1XaA/vo04uYx3tj9N/xr
   KsyItdGKjatGV97OMdRZ1wGSPgQxaJv5qflre/hLJ3wkv2rmT+RGLFSs6
   /aiEyO+b3K1spX6U/ltWPCR6OxK+dURqDpOLcththci5DzOJ8z9+CZGB7
   iLsHkcgqj+g71qil0IJM1nN28D8BYNqOhs8HtJivuYxLBRF/XB7jy4Hv/
   lIghh+5oculVuLmZaInC9f6H9fAtWV5xTfWtuB9a4RjcFeULTZZDwSk0Y
   Ohf0cGBfoKGbB70FixA3axyqZ7bw8cyNe217afr6gqtDMuuebDvt72KV7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="395944455"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="395944455"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:14:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="703125054"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="703125054"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 24 Feb 2023 01:14:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 01:14:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 01:14:22 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 01:14:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jh4peVJ/bEy7txJTBeT+E6Nx9Io4esvCwR0utoFe3tdkFKEoPUaPpPEabyGVWaY5DY6N30UqPTnbxihj3lkprPvoRdP+HR8YYeowdFhL/JZLrFpbBVecCGfqLZMUUMNMjpHuXpdP2j6YT3hteFTiCpqCgUMC+WJPoR8wbriFdQRHNZT3b9u4Ks7JP53+stFObC5bI9A/8TaZ+wctqRyoqvNWIUDLKgQsGjEJtxhhH1hpStjtnX6fcY2apEDibmZ0tQpCCqrgvT+ynxyGpJJDXP/jUAQ4LAu2f+FQqYOhs3XmVr8icgYtRyNxf2hm6Z1ZE0P/OuVaHv6v+xzgGT0ykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKhwUjiww2XbUqAqxjn2weDwGFPTFauXd+oU+lhRWcQ=;
 b=MBieO1a7Dj3R9xB0RMP+i3IJCJG2a45EvWyP/JjaQ1M30MfIkrtRVifcVz/4PwZ8zRPAY3YHQj9X5g4aO+GAeWTA7wZY2z42R4rDQNflKmCiSxOcoei+f/IgmqRzlaXe8kxLlj6+p/SakMxFHWtE3uszfN/eW914klDF4dT9tbl98pzuDegPaLbct9Wxetvp8T+tMuIVuAqqDjJWlBRNVSH3TCVeStD+TlORGQa7CSJWKzf/d7F3smb/Uglxs6r91kUI1k2OGViXf5DX3wrMBtGohLKKakzabORX4+ij/rhAEjnn5cGjPB1QuzZHThSv++bHLo6FzLLnO8L2GDk0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by DS0PR11MB7903.namprd11.prod.outlook.com (2603:10b6:8:f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 09:14:19 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f%12]) with mapi id 15.20.6134.021; Fri, 24 Feb
 2023 09:14:19 +0000
Message-ID: <34993e14-2c33-8eaf-67a9-e3412778e6f0@intel.com>
Date:   Fri, 24 Feb 2023 01:14:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: Kernel interface to configure queue-group parameters
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Alexander H Duyck <alexander.duyck@gmail.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        "Saeed Mahameed" <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
 <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
 <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
 <20230216093222.18f9cefe@kernel.org>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
In-Reply-To: <20230216093222.18f9cefe@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To MWHPR11MB1293.namprd11.prod.outlook.com
 (2603:10b6:300:1e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR11MB1293:EE_|DS0PR11MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bb4a919-74c9-43d2-a3c1-08db1647822e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHN7n3cltDJbgmYS4vtI7mPBHD72avX3V6v+QbsGB/TbwE40MAGq/9ky9BqzyGQTA3AaD6vUhrW07l72y+bjhpSj/aauaX/JMkAqq3Ob9Lqrza+ZQLrH5ViXOzuMb2zAbHl5WnkxyhctA3MS9lQaXAgtbUKWeki3kpd5TZPDo7ZymIQbnMbdCTD6a4PCQUYsgArVSHWaWFEQxo+/cFVyh3K3ahnNKl9N1Mn6RMPZpeskLcnDlEVE//tPBZDY1NsajAiGaSbOtarUNGgAYb8CxedV92QsKUPBfGaJvre2PumwzOkjHiVjlEgZ/r3wxIDw8nq2y8X6Geci6mphCEyNQ1k7owsgmc5Q+HtXWtIWusIt4tpA9Ag51NeFe0QCE86MQ/IYqcmauAbfNfKJKlqWNgQsPgllkbiaqwv05zNwSqiNQMKoINANkgxNU9E6RPoLCHvJeQQcFeBqalYjgfKoWPS+bk8teBGQeojR35hVR8a5e5u1Z7uXdNTOsex64x7gBXMrN1VpGmUCsRBtNNgCWFx+5n61vM/sTCvXZij7JjMoI8UFNjdkChKP0BS0/Sny2iCwb0ScZJ0eCXpeUhryjS5CsWLEqOoPvCDvk68V1Fb4wZnfJsA0MQYYsmi6dreY9UrY6U2DCrROPan5u6OgcpC1sM007lltUspUzfcTlYe3OmBWDKbz2akl/ZIN/hkGRsTlOtDk7HyHAV3MgOnxhf3vjEc1tgTnFwHNWq8RyUQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199018)(6666004)(66476007)(66556008)(66946007)(4326008)(6916009)(8676002)(6506007)(186003)(107886003)(6512007)(36756003)(53546011)(26005)(478600001)(6486002)(2616005)(316002)(86362001)(31696002)(54906003)(82960400001)(8936002)(31686004)(38100700002)(5660300002)(2906002)(41300700001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0ZxZFc0cjFIdEoyMEErL1JpRk4veFpuUmNQWFNaVXNRcGMyekxSckJkRS9V?=
 =?utf-8?B?Z3p6Vy9GR04vcG5WT2JLTHgrT0luSi9PMWFaWFBFYys1UEJqazY4eHIvY1JS?=
 =?utf-8?B?Z2pwUDZ5VDNxYlU3UThUb3JvZlFPL2R4bSs2bDBIVW1uSXd3bGlVdVNoZlQv?=
 =?utf-8?B?NXozQSthbk5xcVpZUWcxV2JjcXBrZ05pVnlib2YxcmhNOXprdzBtSVZPWlg5?=
 =?utf-8?B?R1hmOFlvdG0ySDJrMGtFZHduWFVXaWlWQUJkSlFsOGd6OFU0L0szTFU5UnhE?=
 =?utf-8?B?VGl1ZllPOXE5U2prK29aeVMyMEh0M0trVU9FVUdXWHVPTTFLSHVuaTVMVUd2?=
 =?utf-8?B?d2JaM1J5NHFOeGhJNVVaSTFjdFFYbmNmTmp6WGduVjR3MmR1aG93OFpjTm15?=
 =?utf-8?B?Y3d1T2tRL3JyeDI4bkQ5ejh0MmFEK1ZIL2FHMm1zQ01ISEdBWkhsVnFsYUFP?=
 =?utf-8?B?K3ZpZHViQkViVFBwT1dvZlZaWnhGTFY4NlBVZGtqWjlmNHNVS2l6U1NhYkNh?=
 =?utf-8?B?K1NaZ1JtWXZkeDMvaFRYdkptUGpPdlRiQ3dTVFcxQnY3ckt6bzNYRkhIdTNN?=
 =?utf-8?B?VEZOYnFjNFBmZnZNanUwd2xiUHcybzlUTGRURjgvYjVORWxudUU0MTR0OHpk?=
 =?utf-8?B?REl3U2xxTDVBTFJMdnF0Y3RuTFFBUENqRUFiV0s2N3Q0Ukd2bXlnQVY0ZUxM?=
 =?utf-8?B?WjRDSXZENi9qN3ZRblF2RThOdDdESUJIcGJrMWhmaGZzV0VFSDR6VHE4eFA3?=
 =?utf-8?B?SGVjKzMrQ0NQTUFsTVVHdVJzS1Rtc0xTOFZHVzBuNVVsaTl2RERGemhqQUwx?=
 =?utf-8?B?WDNhd2YrSy9lcEZRdUJoWktJMUF0VlV3alNzMjEzeW5SNk0vL0R0aW5IQys4?=
 =?utf-8?B?WC8rSzlXZmRuU2VCNjhhby9zRThUa0VkTUYxbitjVVZ2RlByVVozRFV3b2dR?=
 =?utf-8?B?QjNLV3Q3d0w3bkpSUHpXU0tLb1R2NCtWc3ZqcVlhU0g2ZWxvYXVUTldQdHd4?=
 =?utf-8?B?ZmUreWIrOHJLVG85cjR4SCtkb2w5VjB0cEZTSFhEVFpMbTBwV0k0UkxGMTM2?=
 =?utf-8?B?cFNiK3kwVnl5N1IyeFc5RlMxei94U0FvemFyZFB5anNxUGx1QzdJRC9iZkNS?=
 =?utf-8?B?U1pEbkJxYVdQdmNDVU1OUStUQzN5THNLYUpqUVd1MUl5K2VLMTRVS3ZGVWJR?=
 =?utf-8?B?REVvckJXRk9EWllDb3g2amllVnBwbzcwOGZXdEkzUDRWa1ZDS1g5aVhBWklH?=
 =?utf-8?B?RmE5VTBOZkdkeXNGWWZDWlF6VUFaVHkyN3AzK3R4cU56QWtpa3l5b1A1TWZ1?=
 =?utf-8?B?L2RxUnNKcEI1U3RCUmpKN2RIK2tOMzYyL2V3a3hsdTRJbkQxTDdEUkVEMDRB?=
 =?utf-8?B?dE9CaFZiNmFSbnZ6R0txSTlnTzZSN240MmNTMXVra1g1TVBNcE5yWldYVUha?=
 =?utf-8?B?SjBzREVDbkxvVDE5T2RCMWlnQU9LdmYwMkNqdzl2M0dzb3JkRFdaRjdqQW9R?=
 =?utf-8?B?QkI3K3A1MlJVQ25MazcvMGYwczkwWklOWjVoaGlrWGpZTlhDODJEUktoVys4?=
 =?utf-8?B?dnVFNzIvU0ZrN3dHUTQrTVYxSXJVTzNUVlFMa2xsbXV5NVhwTzlVZ0thT2ZT?=
 =?utf-8?B?Tk1pSUNaZTNrK1pWK2I4UGc0VjExdDNNemoxbjZydFlPWUhFL1NRajZFYTIy?=
 =?utf-8?B?VUU1Q0Y0K0laZm9sTHRKT2VPWTZMNEtFRWYzWnVvSFo0Q25Gd0NLelphdkF3?=
 =?utf-8?B?cEhmZnc0UG1hdmR4dkprT0dQY25MbWp5aVBZVzRFSGZwTjEvbUwvN3ZaUXNU?=
 =?utf-8?B?SXlLYUpPZWV0aEVxSlk1YmVORE5LZGRnVnhTVzBuZ2RYbE52UjdiUXdQVzFK?=
 =?utf-8?B?dDhIUTNQSHB0ZzZHekphU2pWclVKcHZlengxaUkzbkowRmI5SktCV3lubjBo?=
 =?utf-8?B?aUN3N3JIVGM1bEJLM0JaTlRjMWFPWDVJVFlGcEV0WDNoMEFmZEhHQzNsaHdP?=
 =?utf-8?B?QWFJNVkyR2dxQVBMMlNEQVFZWmtSWUFsNVpkMHhGZXhZNHBSZmRFSTJrTXdV?=
 =?utf-8?B?ZDljVitUdG9KQ25yeGdhSjhWbEt3SlZncDVvcDZJQkdGdldVZDFUb0xBaHVt?=
 =?utf-8?B?N1EwRTlabjBleXN3YVpBZEhhTEFxOE5SVmNXT2dpODdTUlJmOGpOem9aWUdF?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb4a919-74c9-43d2-a3c1-08db1647822e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 09:14:18.9703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PXL0IYsUrS6xyZFCqyTG0GtYswklEIYok3JXJlsyeNigUJaHVJG6m47pCUvfQ+OG3W17te2dSPBlp53SYlR0EgtR31z2Wr0muKuWZcz9Znw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7903
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/2023 9:32 AM, Jakub Kicinski wrote:
> On Thu, 16 Feb 2023 02:35:35 -0800 Nambiar, Amritha wrote:
>>> The biggest issue I see is that there isn't any sort of sysfs interface
>>> exposed for NAPI which is what you would essentially need to justify
>>> something like this since that is what you are modifying.
>>
>> Right. Something like /sys/class/net/<iface>/napis/napi<0-N>
>> Maybe, initially there would be as many napis as queues due to 1:1
>> association, but as the queues bitmap is tuned for the napi, only those
>> napis that have queue[s] associated with it would be exposed.
> 
> Forget about using sysfs, please. We've been talking about making
> "queues first class citizen", mapping to pollers is part of that
> problem space. And it's complex enough to be better suited for netlink.

Okay. Can ethtool netlink be an option for this? For example,

ethtool --show-napis
	Lists all the napi instances and associated queue[s] list for each napi 
for the specified network device.

ethtool --set-napi
	Configure the attributes (say, queue[s] list) for each napi
	
	napi <napi_id>
		The napi instance to configure
	
	queues <q_id1, q_id2, ...>
		The queue[s] that are to be serviced by the napi instance.
	
Example:	
ethtool --set-napi eth0 napi 1477 queues 1,2,5

The 'set-napi' command for the napi<->queue[s] association would have 
the following affect :
1. If multiple napis are impacted due to an update, remove the queue[s] 
from the existing napi instance it is associated with.
2. Driver updates queue[s]<->vector mapping and associates with new napi 
instance.
3. Report the impacted napis and its new queue[s] list back to the stack.

The 'show-napi' command should now list all the napis and the updated 
queue[s] list.
This could also be extended for other napi attributes beyond queue[s] list.
