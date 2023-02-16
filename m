Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6813F699BC7
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjBPSEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBPSEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:04:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC1238662
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676570683; x=1708106683;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JC+DNWTYFiBQDoWvbuR2LTjybhChKKkLRMcoFd8UOuo=;
  b=oJY9+rLGL1/qG5kHZlK6BD6/5XJJgaUOqvHQ9JJ9ZNaM6p+sP5fOHJTP
   K9sJLGJOz5x1MSvOF+SEZX3ehWPmBbU6NW74Cs3qRMQlTOs0IZNZcQGi6
   NRLEW99NmzPL6p8mtvbjTHn0LqscKcOJqzFj/4FDTkaVY3h3Lu04ByjUt
   Bgw5dZVHIImzKvGBre2mzhZhY3Nt1PA7Xldo4bvtYggN2LS4oBK/KGGw0
   Sh4XlVewlkXgvmgxC/dld0+EVhTZOX8LF6Ddo4CvGRdxT6tM8DOMXvl1M
   6+A9yf+8LUrKvFbMva7FWTXbphPnpSPx1Z2cgyalRxD3iyD3C7+qNa+0+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="315498909"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="315498909"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 10:04:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="670206913"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="670206913"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 16 Feb 2023 10:04:42 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 10:04:42 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 10:04:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 10:04:41 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 10:04:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHRVgLjVKIMKQQzT/kIFh4c3kadywmNXiP8ZI1Th/i8NVwXeK0dZ4zBDHzck5CFatBdFyigeSqHRcTdpoiSJC3aXD4s6gLH1RwkHyOc8tQ1jzMeAoLaee2bzqG+bVDuBgWoODCuDSokihGd2oWXd2/9t7DKSpCpCY7i1EyG7PZvSgSeFvhu5zKwYVVqV//UDa0iW9bzDc3ELOXIh5Yr0Hpm84JnlQtkdJk1T6CChvqqaW1EqTplQ1eiYVtIICQ3DhLJ+5CM2J2efFTj9zdYNIuR0OHfvo4BeXv8GLnXHhmfqsO+P3tDwab27erqeMvgp9xW2dR5e4rYi6/So2Sfb5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBJBmGcUeB/1Uo8glg5lDcYN97s8RAkjNjSudkun6w0=;
 b=V8yVBgjoEZvFaC5GM2H6tLqlTWrTp8abDAm888+Ab2VJTV7UmPYwU0g5/M3GqZu29nEfATsBpqgSf/V00bS82jOXqqHR/pzHQRS7XhQ/GW7kQK+lDutzUv8TfOjGN9thR4dwmj66QRR+P4M6ElAdTYWKqZq/jPNopCqiNPQIkiGB9K+7JsVbXh8i/1qOZ7dstOreQUehZK+gAaz4WvMejPfMkzdw2VsZeH/oCbV3nxDqWPxhOLjKkIdGihKor2Hk/IUQgXIjf9eYjp9cYK+UEnBijMowMUv0sfB6RoO7A7s65vbJ0ZehwnOw5THySMDp4MQGtmIwvlNfxq38jBxxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5125.namprd11.prod.outlook.com (2603:10b6:510:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 18:04:40 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 18:04:39 +0000
Message-ID: <7d94aaa9-7caf-474d-d722-fe25869f2a4f@intel.com>
Date:   Thu, 16 Feb 2023 19:03:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 0/2] flower add cfm support
Content-Language: en-US
To:     Zahari Doychev <zahari.doychev@linux.com>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <hmehrtens@maxlinear.com>
References: <20230215192554.3126010-1-zahari.doychev@linux.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215192554.3126010-1-zahari.doychev@linux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5125:EE_
X-MS-Office365-Filtering-Correlation-Id: 848c1388-1907-46dd-7cef-08db104845a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68W4X+iVa3n6yAT/Byq6bP/Bb/SIUjsVzTGIYc+Ek7G7ZCBrfHmOr8EFc6WMCtuxjjnF76RpcE52HMtNI4m8864Lc9m4LeqDvGNHkq5wJ23Gl6GEDrpVcPtElygCpQ7JOjrUjxGgV+Q1oFnCLthDSds1xXhEbcdfSQt+cK5sMCKFL/04PMR6bEsjF9/XL41LJmzn41RGYbybtZhkNmjl1iJuMUWQnN/vx5cSgZ+YGTXF9cS+KLE+AEmFpYiizX2kjr77b7CTf9kIR+6DEM9mHevvW9duL4zxw7ap4V4AlvrovCMzrfrI9hpVcAVhl41glQarJ3wadWjPQer5FpqnyOZoYJsfBmcO9fifCqSTNIEgmlh1Pg2YuaJQf1I1THbhFeHRLmfdNjETuFzQIlo3rh8sMVZ4wpkrcwYpBT/qntkjUme8Kco6MhvvsqOgTBetZMIi1RnnQcEC6Bzsuhf0YB4K5Yxda0Iced+MJfkk4Dh1job6FnK88J//ce8n1+WpOYIChHytQueNx8DLl6IOa694V/8odwI7u5K/QAqd5SiP6V03sGZoCkZPIyLZ13xP/kafbJ+bV/iAJJLDr+UiDsV7jy1mY7YA9I7fHawHKtW7hpOefeTDK86OW0eKG18j9k3DYcnMUNl7QCjMM59hZwsvlHOp9RLTgd/pB4BhTirtP4nvCIA9VzzcY3ML3yyGchH+bTfy0nBmbEq/4URfCTJ0w3KcjhVp89fL6NjNtOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199018)(31686004)(86362001)(31696002)(83380400001)(6512007)(186003)(36756003)(26005)(2616005)(6506007)(66556008)(2906002)(5660300002)(4326008)(6916009)(66946007)(7416002)(8676002)(41300700001)(66476007)(8936002)(6666004)(6486002)(82960400001)(478600001)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE15NWo2Nm5TK0w3bEtscENaYklGeTdKYnhXSlZXbVc5bmxsZFlKV2RXbWJM?=
 =?utf-8?B?ZUtPa1IwTzVHUHBPQ2RnVjVuS2htS2ZzQlFWbllrTVVrZ3hTUUNMcytUZ3pV?=
 =?utf-8?B?d2JseTFyOGZHMmRKU0IrdVVmdkNDVlRhOVUzdy9rOWNZTzI5bjhsazFuVHFR?=
 =?utf-8?B?cDRHM2hJSE50TG9yZkVWTDY3WjdCY3JpOWVwUnpmamhOMEJHbm4wdEV5WkhD?=
 =?utf-8?B?UUI1RWtNOCtGVFBFK3Z5VUNTZWFIVDB1L043bk5ydU1qb1ZjNDhKcU5zMy90?=
 =?utf-8?B?eFkzc1RxQ3lvZE5jV2VHREs2UXNCL3BMTzUrVVYybWwxTy90NkFYOWdPYW1r?=
 =?utf-8?B?V3lmSWRuNDE2Si9RN084K0pDTE9XanFtUElVTDM2R2tuR05HNk9SZGZPVXFD?=
 =?utf-8?B?cHQxUlZDOWN2Wkd2VWErbGl2STZYMGMyMHUxQlFkVHRKZlJkeXc0azRlUXNJ?=
 =?utf-8?B?bXZOOW8yMzk4Z1N6WUtUMjR6bTJsWFdxTmM1OTM0L1Q2L3hMbDFRc2ZiRm9p?=
 =?utf-8?B?emtOcjVLSTFxb0Q3dWlPOERrellLdnMvdWVOUzlMSTk2a05wWUpBbXgrU1d1?=
 =?utf-8?B?SDJHOFYvaW9zUklzNUE1Q0VUbzZZWWE5Nzh5OWhEbTlJUEpIQzhhb0ZyNkNZ?=
 =?utf-8?B?ZWhXUFArdzY4SmhIRHhJVGtMZW9oZTRmWSs1WDVOOUQzSlJ4M1dQazJPNWpz?=
 =?utf-8?B?bjhxWTFuUXhyQ1kzamsySGMyL1p2aUVUMlVPQ1R4eEh6cjVFSXk3d3lqakRo?=
 =?utf-8?B?RVNXd1E3YnUxUmZPcFZTLzBtZUJnYnkrMk9CV05aUTlxM0h2THFWbVFRNHdC?=
 =?utf-8?B?bFptUDBTc3VKVWRZb3l0NzdUdE5pNVhYYXVGZWdGU3dDMHFLK25NSUlHengz?=
 =?utf-8?B?K0l4Vy9vbVNBY3VqV3FIQ3kxRnlJTlVkQmtOTFFyT2V1Q0hMN1pCaGJWZThS?=
 =?utf-8?B?QlgrbGFKUWRFbDFpZ0RUQWY2ZFBuNGVaOXJTTUdvbXF2WmNkckgyZCszMlA3?=
 =?utf-8?B?eTJwNm54QUdFbHVDdWZiSHR3Y3o0TkdnelRUbktWSEdOam9rUS9hNUNJZ005?=
 =?utf-8?B?aER1dTJlZEoreDA1RStuaEVHSUMvV1JCYitQTmlBSnJJUFJZV0FXNnZVQldP?=
 =?utf-8?B?NnhWSkk2UzdEUFBmcldDM1REZUtCckQrQWlqbnREZWtFMk9DQS83YmFmaU9s?=
 =?utf-8?B?czduZFlWMmZnQTBHSlNEUzZLNno1Sk1YNThWbkVWa1VtWDdrZXo5b3BlOEY5?=
 =?utf-8?B?T2t2dTRNSU5BRTFXZ3l2dVhERjhoWkFjY3FCUmNwNU1FSHBXWmdKV0thaVZs?=
 =?utf-8?B?VGdBVnZlamxtRWR3cDJhdkFoRTN1Sm1XSDhEQVl0aGovQzJtbnhQUDJZNXNr?=
 =?utf-8?B?b01Mc0QxVUZ5QXQ4b05BUVFDMUpHUlhPbmVYc25NSEJlWFA4VzJsQTZLbmVl?=
 =?utf-8?B?NzFvRXRwaWhTVmEzMjhTbzRucnd3cVF2eWlSKzFqSlIwd29ZWFc1UDBqdURm?=
 =?utf-8?B?akk2SWtFemZkSWNqTDZCSGVmeTF6VWl5eVh0WUNzTGdZRDEvUkRYejlnNXhO?=
 =?utf-8?B?V0ZTMVpjUzR1aVpsUXNYMDNMeTNyanZIbDlsWnEwZDI4UU5vejh2ekl0Y2JU?=
 =?utf-8?B?OXh3MEhqY1B1QWo1L3h1R0ZhWm5VSDk5OFJ3MTJ3L0lYMTNqTHhOczQ2UTl6?=
 =?utf-8?B?cmthSUg2ZWZNUXNMRGhsQzZuZVBKWmc0V0p6cTJ1OG95N2tHd3dyeEpmeThn?=
 =?utf-8?B?K3YxMjYwaEJVaVNvYVU5MlB3WkE2V3NKUWdBK253OU5SVVZnNXNuSC9vQS9E?=
 =?utf-8?B?MEF0ZlRsbVpLd2VPZy81ZngvY2NJZ3FSRzF5QnFFdzJkVUNhaXlGZlBaSll0?=
 =?utf-8?B?ZWRmTHNweWxvTDl3eDdqUTRlOStadlJHalB6cDJIdDAxWHlrRGZISlJaMXNJ?=
 =?utf-8?B?NEJqTE9aTGYrZUQvZUVnZHgvaDAraDhjR0pFRUI0K3ArWXRWN0RNRzh1MVVh?=
 =?utf-8?B?aWZxSjdVejh0T0ZML3B2MWljL1BRd3p4YitERGNnaXhyK25IVzJQajlHN1Rl?=
 =?utf-8?B?aFFCblBUTlovc0tzZmlFZGhqdlk4dkIyM0s2NElFZmU3dzVUODVVeU1SNFl1?=
 =?utf-8?B?VWZzODkzQ2lFMHZBbzlpeTFuTW9MRnRNQXBXRm9RY2NRZzd4VHc0MUw3ZHZu?=
 =?utf-8?Q?zbjBi3zKUe4qfGtdACYa0Xw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 848c1388-1907-46dd-7cef-08db104845a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 18:04:39.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtAggKMzj7l8WhKaAwkqQK2SexcJkc+krcjK8m97gbXKXQXnqmsQy3ruii1k4aAX6fBz8848mxr0oDWJWIOR98oJ1omPs6kUj5JBhnuT698=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5125
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zahari.doychev@linux.com>
Date: Wed, 15 Feb 2023 20:25:52 +0100

> [PATCH net-next 0/2] flower add cfm support

Some badly formed subject here. You likely need this prefix:

net/sched: flower:

and then "add CFM support". i.e. smth like

[PATCH net-next 0/2] net/sched: flower: add cfm support

> The first patch adds cfm support to the flower classifier. 
> The second adds a selftest for the flower cfm functionality.
> 
> iproute2 changes will come in follow up patches.
> 
> rfc->v1:
>  - add selftest to the makefile TEST_PROGS.
> 
> Zahari Doychev (2):
>   net: flower: add support for matching cfm fields
>   selftests: net: add tc flower cfm test
> 
>  include/net/flow_dissector.h                  |  11 ++
>  include/uapi/linux/pkt_cls.h                  |  12 ++
>  net/core/flow_dissector.c                     |  41 +++++
>  net/sched/cls_flower.c                        | 118 +++++++++++-
>  .../testing/selftests/net/forwarding/Makefile |   1 +
>  .../selftests/net/forwarding/tc_flower_cfm.sh | 168 ++++++++++++++++++
>  6 files changed, 350 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
> 

Thanks,
Olek
