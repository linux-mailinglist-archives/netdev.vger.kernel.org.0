Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2BD672A3F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjARVSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjARVSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:18:10 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B204761D7D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076688; x=1705612688;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dWweEQ7ejOHncMq+lz0KaFFb9gY22xe85TxPcyi5R4E=;
  b=AjVyJbxJVSGs2Ie8c7F4ZPqIXgDsLcncqgJ3c0EID2YQBY2vjybHe03p
   UyptLbfzRVqIZIyZfk58QR1laScN4qTw95876RKFZ3cO7gZuUwY1grkBI
   zlMPq8dr8E1b/E8RTQdJMBH5MiupJFweACjOxyEAVZZLZL8YKSe7foQof
   KHdyr9q6fAcDoR1z1tSbM7dSXXdiOGFlyLpfvfcZll3fb3MUtsi0ov5T9
   Xaz71I306VgLfeRm3HKvKKA6o63320LD4Bdh8peQ977M94jVAysv6vC9S
   qRGep5Pg3gcyvtzcEhnBmDwUO9CZgV4JrAlZl+V4Irt8+ISSWvRxwNcxh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352354774"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352354774"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:18:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905272728"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="905272728"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2023 13:18:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:18:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:18:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:18:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlO2jm14du3Kim/8Y9LKr1J6BW2cR1w/urgo2cyZ2zURFAYa2LFJfOI2gbwIKVkjJOTGz7d//dWTLZ+ztLMWLNGwALmTD6DX6DlbUu6exn6ix97WhvMz6lcMz4oa2Wb3tNBx+HUApMUZ50F90lqthJh+CUyh72XPyfzE6Fsz/kOergthKduJUyCyVdk+se8k9wqkIJ9+l/Oef1QZ2pC/b1B9S8UCY6KCQx2ygmD7JfVzbOilKocEDp4yhrtmRjaHWqTx9bPp+6SAHoIO/QNOthPtTw83cK8BxC0r4E/xASnfx1K7iZIxVTHhBdEbAB9zq/+XhjyCk/gvu4dDuKBfTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvB8s5aCQVcSKfkEU/gKtmSsbPyPjVj3L9d/d0h/H4k=;
 b=c+N+60ai0QxlhMsWoYzvtBHMZmbq5/O5a2VwWJx3rFYnCn4Gt1DDhAyDZizbWGlpVCOlq6mhsdQ08CvXYH3iruW4EfDGAQaIP0vLlCP3uSfpiN6Kjx7S2WDbPDU2qew542soWbMSvQm07SyvXGNC7VE0ZjQddt3o0NMg09DlAE7ngAToWzd6Yd8wEhYD2v0ZJApFexMSdSEDGpjOkgPG+7r7HWq8nVB23fjnr6JeFvS8Cj1kqjc5COMXeyfXHo0QtY5u4PnTz3/w8A5IKS3IbtiO2TySSDr1r/HnflvTpBmlKeTZWKWA91mynuU2erkAsrj7/faG0aDVtBCONPJyfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:18:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:18:02 +0000
Message-ID: <d016b1dc-c8ee-9826-57e8-1edc7a09a515@intel.com>
Date:   Wed, 18 Jan 2023 13:17:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 05/12] devlink: protect health reporter
 operation with instance lock
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-6-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-6-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: b1e50b63-8047-4d7c-0e72-08daf9997b9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: da00czD58RPxIB29PgCjFPbm/lrnznW+AvWklLCvCxlLLAX72oAEZoRaX5XlC46n5HgGraf/W0brFpaKx0C15FcX/Q42GvS/sxGeMBf0+nRWi/jVqglI1Aue1NsqwOx0JQpsc8E+lfmcc4UBfyibjUeuhIQtkI37j5+LeUY61NfFzPakyJ5dUN9RTU2WRhzFDpXKVU8z/wJCkA9uIQnFrk1pC3iRwvaYwlKCrpOpVo7tUwBuEGvGfyLZJ39GsLU/z7DLDX8RpwgQqXSiKgvyMyNH6RR63gmbwgYuqWsTmAwUbXBPy9WixlhMM8c6O9MvHYI8UftzJAMBRY97YHip2bIPN+rJ+ldG5jLSW+iUxDTtWu0cYn9J6fv3IQ/FBr0JDbJEhr0Zek9HTwLr0Zfr27B1dQAm5BWWk/Zj9fLArv4i+qdEzP0T/mog1dcMFC88ST+NRUPlZY4iZbVz2x7/xsCxLXl3cqY6mw3AF+pw2TC81/45Nqp86G8S80OdcYIbFVBirmmICqB0X1rxDWwmD+uoLeWRVWX+LX74LVlz5GXmeXjJoP8Ml2Ft4rH4ZoxNrz0KC8raavGzBVrRQrS4X3UAidwoMaPTWKwcAkTlf0lKAfIyCMqqtyyzy/3kw/PRGYpJ/tep77qam7BdZfAXfL34KY+cwTRg34Hd2TV5GBm1CRkFGvwAo2nX4LmJ5820hScgchiJwoK6ipKX6c4yQKyshspYUtdrv7MEEvHL1Bk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(2906002)(82960400001)(38100700002)(31686004)(31696002)(36756003)(86362001)(4744005)(316002)(2616005)(7416002)(66946007)(66556008)(6506007)(83380400001)(5660300002)(41300700001)(4326008)(6486002)(26005)(53546011)(478600001)(186003)(8936002)(66476007)(8676002)(6512007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVZkUEx6RFpVaFA2VXJDUGVzbmZjbmlmVnkvZVAyYTZRMk52NnV1Z0YwYmhu?=
 =?utf-8?B?cFIvNnMrLzNNS3B2bnlqSkRJMlhLN1lrTktJWFZSeEcxSTlnaGRFTmwrUFJM?=
 =?utf-8?B?TU9WNUxCcnFMM2hsQXphVHhKR1o3MkhzRTQ0L2lmc2FYbVh0WHZodExjRUR0?=
 =?utf-8?B?aTR2dnNlTmVUQmVJUno4QkUzYXh0ajNwQ2E0VjFLOXZMVTZTWEFWcVZQTDhN?=
 =?utf-8?B?aWRVQzlDMzU5aFlHcFNpck10YjlxZ3I0clVjWS9qRFZRR1plWDZTcWxJYTZL?=
 =?utf-8?B?eDdYRnc5SmNWTzhHMDJ3ZlNrcmZDWFhNeXdUeXhGT01tK3F6RGl1d3pCRTNq?=
 =?utf-8?B?RUlwRm44eE00NExMQ2JvaDY2VFVKend5QS9zU1FnMk9PTy9yTjZFRzhCWlNu?=
 =?utf-8?B?YlB0YllGWncwS29Kdk5pb1FPZjlYTGdadkFudnBXYjBnanVVVjQxQ0E1UWxU?=
 =?utf-8?B?YlkxN3JyM1cvMzRxVGljWDREWWg2UUE0Z1IvdEl1WTB1SXUzcFJjREhKQmtz?=
 =?utf-8?B?eDU1bmVlLzFrYVcySTJJbDZIODlXenhIM2xQd0ZTUllCNHJPOTd1clQ2OVVo?=
 =?utf-8?B?blpZWS8veURDOGJvVld0Y0FSeGhqSm0vd0tSUFZaOEdXLzU3bEhFdGt1SmF4?=
 =?utf-8?B?SHZsZUR1a1R0Y2dML1ozNjRkc0lVb2dyY2dWdkJGZnp6QzB1dVFVM1NRRjhs?=
 =?utf-8?B?MjZ0cW9hdjBveG4zOUs4dm1vRFk5TEVzR3h6WnBxbHBqRE9rNWdaQURIN20x?=
 =?utf-8?B?R0YyYXF5UmlVUjJPZGEvZmgveTlYSWJJQW5PdU1rYnlNY2NEczRCQmt3QUFO?=
 =?utf-8?B?bCttZjBDTkVrUWtMZnQ2RUF5QzhNejNCY3N1M2ZBRE16T3d5TXcxcmhVUGJ5?=
 =?utf-8?B?cXY0RU5DdU5CUWs1RzBueVRyRUFiUkd3Q1lKTmEyYlg1TUpWTEUxT3V5d2oy?=
 =?utf-8?B?d09lcDJLWVc0anVQUlZjNm5MNENWSnRpMUJ0VU0zaTBvbndhVVdlQ1Mvb1Vx?=
 =?utf-8?B?RWVKcW5KQ0ZHZ2FNNzQxaU9rbzJxVzd1U0E0emRMRFF5TVVKdWZSM29hSWlJ?=
 =?utf-8?B?NkRMOHFkUG1kTjd6alEvczdXWXhlMkZHU0JpdHlTcXZNR3ZqdE5FWHA0YmFx?=
 =?utf-8?B?WFc1ZDVQTGE0VmU1dXRJcUQvY2cxUm5EL2hwSHhoYjVFTDhFR08zWnRSZzVx?=
 =?utf-8?B?KzVmUHFkZ2ZLNi80bDFjaDJMalFDTENaRE5nZHZDTVhkQXdlcnFIWXMwOHEx?=
 =?utf-8?B?ZTBueHdHdituTEd2ZENrSGFwMzIwTjVSNVp0bU0xY2FScEM3MGxWWXpUUytB?=
 =?utf-8?B?bjM2L1ZoZHVWRzVJSmJjOU04ZDN4YXoranJXOHk3ZGFweVByY25xTDZ0a1Ex?=
 =?utf-8?B?NXNmKytaM2lnbm5tem51UDRxajVKZXlxbGgzMHlCS0VFNWlLTm5zTDY0ZVBZ?=
 =?utf-8?B?K3F1YS8vbnRseUw5aVNHOVNrR1BIT1EwajVTSUF1ME1DRTdCUVp6djFzdG85?=
 =?utf-8?B?ZHo1bE5OajYrZTk1WDBXRmVhTVduY3FLUWJscmVwamI3NDVlcENGYnBySFJj?=
 =?utf-8?B?NkFyZ3dITmRMNERVV2FVK0k3Z0NwczJsUUNVUzV5bkZjaFFmK1Z1c0Z5VGV0?=
 =?utf-8?B?R2F3ZHRjWWg0SEd4RVp5bjFmZkJNQVdrTkQwbCtEQm5ieFBhTFBoT1UrUXQy?=
 =?utf-8?B?Qk5uUllOY2hIWlVmL1oxMTE3MGw4SGhoVTR5dnlXNUUybUJGZSsxaDlEK2RL?=
 =?utf-8?B?T2t4emE0ejJkL0lnUmUvWHAyczFsNkxoaWFLZURDQ0ROUDU1VnRVNmlGRmxW?=
 =?utf-8?B?Nk9uaWRjSnpGeDVOSFZQWVpSQ2JsUWpuV1pFTWxLcWF4NHNsVnBjbldJNlNB?=
 =?utf-8?B?czNaOHNFekdJN3NrMUJxZ0dhV1gxbzFHbkRiZnJ4T3lPbDdVdk5pOU1GdjBI?=
 =?utf-8?B?VEkweVY0NjZOZXRRbll4RWhpQjk0SnVpRkFVMGRSRGxLNEtmcnBGZHlOVG9Z?=
 =?utf-8?B?Z0dUTU1tOFk4OGFieWRONFFKeXRmQm5telFUU21YYkZYK1g0Vm8rdzJ3aU05?=
 =?utf-8?B?cEk3V3ZWSUIrT3ZZOEk4WDhWYmZpYXdsTFh0Zy90dHFOUWFJVGw2MzdCUTNH?=
 =?utf-8?B?NlZ5VFNXWkFsdnIxTUFFNythNVJqOTh6TW5EOFZlY1M1ckVxbVRJeGlGbzhF?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e50b63-8047-4d7c-0e72-08daf9997b9f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:18:02.7086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ts0ja+ehQ6k7WoY9k1Knj4dXQ2Obhgl0QKAGiODSapIpC+aKCrSJiTmvaxbi7EgSiWVQcSqtEP2di8wPGGAD+xzI99OZbRRoikxGgFSLxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to other devlink objects, protect the reporters list
> by devlink instance lock. Alongside add unlocked versions
> of health reporter create/destroy functions and use them in drivers
> on call paths where the instance lock is held.
> 

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
