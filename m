Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ADA61FD3E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiKGSTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiKGSTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:19:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2621625E80
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667845118; x=1699381118;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LoT4qiZYqaG/0Lk48sbCbz6lwxqWkV+TkOmFD0ipKEs=;
  b=ZVIh0dkjy7dB1Vfe+ASaDWF6EC8jIJOMNcXAiUaEOtqZNJDtwZX5Pkvf
   Ip06POXTkTjui92LG+Uf1YPU7gu9uQfzn0Ea6G5qUjWIM8WeNH99BgXxP
   NgkqCjqaK+s32sdbEVuejTjnEAAaoPNKdETddialESdrKkvJOxbfIMReM
   gUrc4f8qqTGXkyugit1g3mhAqSc1XwI/ROS4cfYH24gIIEsrBJYru3fgN
   s7cp1CJXlHOQNEYGQ+vnnTxBKitbFrVDDQo2WiA/AJYPYAYyt3w4g6IQd
   8t1WrR2PUGwxrhaon8zYiEI+FRIyykyKWYpJDFhC/GxewHZystlLB4pUt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293853109"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293853109"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:18:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="965264662"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="965264662"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 07 Nov 2022 10:18:26 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:18:20 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:18:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 10:18:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 10:18:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwXcfdHlxis1I3FL7M9j2VtsHzpCSMKoovIDPvV4nGajVHSh3HTqP5I7/Pb8qqFr0SK/j7BlKUkjDoFluXOb79FHp12+k6SLdfHqL0k5gBYEULIMrCfDkT3Lz+QoBRhC6S8JY0+JbGJQ5gdLldeAe0hdjIU5thiJ+wxQTDVs5XdFD/7XuEeAg7pU2ZT/8PeNvM+vwOEqAPgmkUaJp8q2k/BlZsL5GRPHG1Fl/0ovgCYO/2/d+8g+EpAbcWhlux4oq4zNATtQ1ymVk+Rr4s5o7uwlytkM+D3rTywGAFjenUtnViWWFOyugAXtzMY+AWXgBaQjaBTEXupMnfo6iuHtPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qmbs02JUypGaLBCbWNlGYTuDCQygPUueQcU55+WVuU=;
 b=YWjqXpq8UBgU3nWdDJdmUm1tgMMpluG16Qea6tm+XXMO9dKl7iOT5lXJYdNXqW+9PExn6k7VwkgVZnM4z2Y6Hq2knujnfukGMRXzsP9lsfje5x4o7nTj839/UgdILW+H2gNlXYxqbG2cNU1hCmGif4IoDU7YihYiKbQIbDE3sv8I6g1hgERKAwli22IGbcgT3JvxnWi15xZgvnbcB+UqVKduyrl+3jbzkbIbeuomzN3biIe1pC5ZclRdtPoOHkSHztxrbDcxR0che24WSXtFmNamSEY3tHTJB4EWrD6hXKlmHH2Sax1vYuMdtA3gsXQXNbmU3WvsCKqtf80c3vDQZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SN7PR11MB7465.namprd11.prod.outlook.com (2603:10b6:806:34e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 18:18:16 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Mon, 7 Nov 2022
 18:18:16 +0000
Message-ID: <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
Date:   Mon, 7 Nov 2022 19:18:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend it
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104190533.266e2926@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221104190533.266e2926@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::19) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SN7PR11MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: bc7ba03b-6ce0-40e3-3ce9-08dac0ec70d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuu5yY2QQlzMT1mTTD+v6CpwLM+QvRu4irzrULwKlB6m7C3IMqD9wmvnIHz2rmnlunrB1ai2RcA41C4QKJ+flQj+VWpY+hXpRnDb5Mf1BwyixPKTDhfqazc4LyhpUVJnGYZ2GiP+rGyZfQcp/pXsgfNx/Y1sUk0TjRChn9jINGbeVKpAQElCV23luwC7oaQntsuqnmHG5UK7m17nI0gGcJ0cw+adg6r+GQuSFEDgWwnPaiIQho4UUz5RaFgKX/m5Rmd7QCDK+dnwN7m5HIHRA2TFg359LQxwnYmebBs9zkpfT2gA8BJB9X1t6ZH3RrVh+P4edjYZHOjAJjyx7spk5z5ZxKVo0wX7p3R2Mh0jcg9bnGrgashMZbT4azylIBP2TBwb+Edo05UTt+vxwyu1ZXIkq/qO2z3XrC9j3NYRI+kA+hzGGAQbwl+gnFZSH1LXL/pnyX+8OjF7LxQXoDNcmyvF3tdu7RP3769JfqVCi5JcEFUak9Rf5Wl22PQQ8Jv/HyTN5b3rOYxNi+8Zg3P8KkWpUG5k6nY0JbMV1cP9a+ujDi3sRSp7JeRNr6h9/HY8CR3Sq0PxwAWeKIVIm0lz59f1vyKtG6zqmV1SC0bj3/CA7BDmxRPnIXT41eAd08Kb28toUqnOmIEHY3vGOjrJUGFOdxHTatpgOhjqBFiKuZ99S2zPY2ZYhJKv9A1Phma8e6SrT6FvDIdeti1sm108UJh0De15fkLuBoOZA+VZ5lWwo59g0Z5TNR5MOFvmrB0sIMieVZ3nu3PDVxPGyoz8q1DqqUna7OEfhxNdPm6bWxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199015)(36756003)(31686004)(38100700002)(86362001)(6486002)(478600001)(41300700001)(82960400001)(83380400001)(31696002)(6666004)(6512007)(26005)(186003)(6506007)(66476007)(66946007)(53546011)(4326008)(8936002)(5660300002)(8676002)(316002)(6916009)(2906002)(2616005)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlZnN2lIclFyYUZDV1lTQTQ0bHJ2RkZleFl1S0ZDanRYdmVtZVN5bElJejIy?=
 =?utf-8?B?WUhQNFRCT3FWK2hRYk85T3gyUjYrOTRISU02RmRyMUR4emJnQWdYTXViRHpl?=
 =?utf-8?B?UDJKOEthK0hvejAveDdzUDRod1ZYaUU2aVpnbS9pd1hDcDgrU2xBNURJSEdh?=
 =?utf-8?B?WWJrRkxiRi9CQi9iV2E0QmtOblZsUkFXbllMN3orcHZ2WnIrWS9tRzBrSDhs?=
 =?utf-8?B?VDFuVVhFYzNYS3g0a0NCRzMvWlB4dHV2QWNNTGticmVuTFR6YnMvUWxCMTRy?=
 =?utf-8?B?d1pvSHEzUGNuNFEwTStScWN1Qzg2c0swNS9XK1FJbXNLTWVmK1drZzBWUGNq?=
 =?utf-8?B?ejhOTEdjZ2x4OEJJMnBLWmVKaVBBTHBMZjEydDZkMm1qQWpLVHRTaHRwempl?=
 =?utf-8?B?Zm5jelZDT3VvdUpPU2ltQnVLbjJwWUVnSTROMTgyWVg5QlVUanhCaUo0cEVB?=
 =?utf-8?B?cHIyWTc5ZFliMGVGeUJUdHc4ZGdueXd0NFBYbXRBV1RHcEpPT3FCZVpvbURS?=
 =?utf-8?B?MWlZT3VpN3dFVzBVcVFBcnd4MDdhcmRoMlY1YklRSkREbytGYTZobnpvQkZE?=
 =?utf-8?B?K1lyTWNQUC96ZHZ3T1hMSmZ0bXdLaGdxK1FmWmI1OVlZMGZCUU9uOGY5OEtw?=
 =?utf-8?B?WTlobnpXczdqUFpQL3pSTWlTa204U3dPcExlVTNLQnZaV0xla3d0LzQzNmxj?=
 =?utf-8?B?UERjZzlESG01NXBURjliYzAzK1pmWUpqWnZQRFhxN01iUjUrYXRJMFhOQTRx?=
 =?utf-8?B?R1MwRTBWdTJwdTJkeGdmUWdFYzR2UEN6VjI5dVQ4ZXBlVlo4NzIzd09RY1dP?=
 =?utf-8?B?aHpQc0dLMzVrWlAvWHVmem44Ykd6YmJ6cG80Q2pHaitPZmR0SUY2MzIxZmt1?=
 =?utf-8?B?TWNudnhGcENUb0xTb2VEZXgweVZ2aDFwTzlFTnpBREM2U3VGSVdPOUpnM3dy?=
 =?utf-8?B?UC9qdm5rVWNBQkNzcE1VNDNQc1VIRm8rYkM1SHErZjVuaktzSlAyQ0ZKcHJN?=
 =?utf-8?B?Z3VKMTArWTRWOERxc3B4RGtySXp1NG9SR3RtTUNCRWJvMlZyQWZsT2M4VDVi?=
 =?utf-8?B?UlZYRGJucEhETkJJOE1XejhQbWZhZlFKamNWVzlEdDRRYm1LcFJLTUdKYzlC?=
 =?utf-8?B?VUt0M25PSWsrV0tXMWdoaFp0K0wxbDh3MjRiZ3hwVjJDQlNGZldQM3RvTHN3?=
 =?utf-8?B?VnFZekNHR0w0c3Jpb2lUVCtCemUrY1czQmtyVG42TU1CT3E3NVVzQzBsdEpk?=
 =?utf-8?B?aDdKblRlWjZFVjJZbm5Da2xRUmV0K0MwSG5kYmgyUWx2WUxBVnpadEI4bE96?=
 =?utf-8?B?NE02bkxNUjJpaFZDeVFVVWc5QUUzODFUTWFsZU1WR1dtdENYRktlemhlNlRQ?=
 =?utf-8?B?d29HUEkvdlZockFYQ1ZKUGk5M1U3S2xtVTVXNy9NanJINXJFdnVZaFltV0ta?=
 =?utf-8?B?RzVrdXg5ZE4vb2JNeG9sZmp4Mk02MFVtdGFCdmVYTHlSbVZWWTlrdktSc2ZW?=
 =?utf-8?B?M0hZdDRyak1TVjd4NXdQQUxSMnFuWHowbzlhUXlZbHY5QjJSdWMrWUVpUzBo?=
 =?utf-8?B?aTd0eDJQT2ptUGR0RlZMWXBrNHhlSnlRaDVlR3BkVkdFOUJWYnZqYkxJeFQ2?=
 =?utf-8?B?ZDNXREdtQUJGQWFxSzhlckt5cFg4RXBqbnhnOTVVM3lFRGhIZFM2N3JGbEJh?=
 =?utf-8?B?UFVLbEoreG9pVGlWdDVqR0FuZkx2MlBkdDNpOVNaY0NVK3VVUVdOSmc1dFRl?=
 =?utf-8?B?MDRjSGl5TGJyaGtDVzNBcnUvUGZRRncvWlZMRWN6R3NZVFYzRXllVTl2c3Fn?=
 =?utf-8?B?cG1zYzYvbEhFWGJmODVqVGtySzFXa1o1Mk53N3FXbzUxNzdRY09scC9CTEE2?=
 =?utf-8?B?eXNwY1o1bXBraTUrOXFlWXJYOWYrRTVDZVJkMEVBMXdqWVBuVFdiTE1FTytu?=
 =?utf-8?B?ZHF0THJJQ2JzK0VYTDQwNVRKQ1czNU11WEFNNHhXK0RRbXkraElkOC8wUStP?=
 =?utf-8?B?UC9GNzd1Mm0rd2svL0FVYTZPR05sSkUyeHdIQ1c1YkM5c09sYzh0b1UxM3N6?=
 =?utf-8?B?SUhONGpIYkZ2T01GNEZLQWxCaFdCSTMrQ0p6YTRuRS9GNFZUVzh4all0d1dL?=
 =?utf-8?B?eWhUdUpDR3lOWE56TnBRK3ZnOW5MK25ZN3V4TlBzb05lbEx5ckJkTU9CbFor?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7ba03b-6ce0-40e3-3ce9-08dac0ec70d2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 18:18:16.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rj9LTkLadP38JTPZb3NuQbEIPi2x+xG5rzW03GpX2hUZQJe9rY0iiBxhfY+772bEmC/LzHJdsqvEDa8gSEWZllSSkp6xUgJSZyOl2pHOzEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7465
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/2022 3:05 AM, Jakub Kicinski wrote:
> On Fri,  4 Nov 2022 15:30:53 +0100 Michal Wilczynski wrote:
>>   .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
>>   drivers/net/ethernet/intel/ice/ice_common.c   |   7 +-
>>   drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
>>   drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
>>   drivers/net/ethernet/intel/ice/ice_devlink.c  | 483 ++++++++++++++++++
>>   drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
>>   drivers/net/ethernet/intel/ice/ice_repr.c     |  13 +
>>   drivers/net/ethernet/intel/ice/ice_sched.c    | 101 +++-
>>   drivers/net/ethernet/intel/ice/ice_sched.h    |  31 +-
>>   drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
>>   .../mellanox/mlx5/core/esw/devlink_port.c     |  14 +-
>>   drivers/net/netdevsim/dev.c                   |   9 +-
>>   include/net/devlink.h                         |  18 +-
>>   include/uapi/linux/devlink.h                  |   3 +
>>   net/core/devlink.c                            | 133 ++++-
> Please provide some documentation.

I provided some documentation in v10 in ice.rst file.
Unfortunately there is no devlink-rate.rst as far as I can
tell and at some point we even discussed adding this with Edward,
but honestly I think this could be added in a separate patch
series to not unnecessarily prolong merging this.

BR,
Michał


