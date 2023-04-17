Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA3B6E4E42
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjDQQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQQ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:26:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F8930D0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681748765; x=1713284765;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=y2XlnYTEY82RomRB6XA+ckkLGRnHgTWvZUlQW68eeWw=;
  b=QzzR8iwc7ggqvSismslxWWQ/whqztIaxdIboXQ38p9NM3dn2w9fy+2Qo
   tWTIQE3stmygLpJb+NDz0+C2uhTfcXuoR0Kx7l9yOgZT8DqQ/yb6vyzCi
   NJUU/b+qVXUK1kqyEtx3OdM93a/W9bclguA5XGzkPoW/AHw4LHsAIqRRR
   sTGZ/LGQn0WRBnE9YZdYqo5h2swgF5Umf3kQdmjVrwGqoYGEIQ9+v2NJ4
   SA9CHuwd8BhkWRCry4QFq1mpHi3WEVUo57phQabZHAtgczv3o8bQkdiis
   l5PEddihl3LFgYoeerrxK7igmlQ2xrNVkHz/o1a05EovJNW8AnA7ifcJe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="329105431"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="329105431"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 09:26:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="693286066"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="693286066"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 17 Apr 2023 09:26:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 09:26:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 09:26:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 09:26:03 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 09:26:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJSjoiLRV5HRVA/NrbcDPmNH2AnTO6uPpXJPOdgtu1JCfKSx1eNUSNcv/2/KCL3YkjcPKrmClUPJatjxaLRi5V1XEJu2K/O7ohNCnwkE4RABNQA9XUP4QSBfjLPJCU4NNaedRQAO2r6w+HJ2uHd56QSJxGXsW8wqVJMjin6ehq95GXaS2JwFVo4LqysJsXdtN4SDUl0xd0JNJzlkBpy39D7y9AL8beHxl1dhXoCIobAgt1O7Z+7RkoRwPW0ifLyhXuIaImLWUB2sh3MxWBd25V7Xw88R4IWpg5oKNBwqPt5lhGc4n9LGR+uNZtnLAKNwTWEA5AWhuDVWBA0nl3XGig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V20JY4U/iW9nCh9S66LENryehRMQMoFFopKAzIJRt5U=;
 b=QzrSkGsA4y5bU9ol/FLda5Kv6lMktBAxl6TQ2c2s2atMo01AJF6Z/pSNPLGlVWGWRbDcbC4rrgQa4kPnjoJCErjlz+LT/+ELSj78cZZvKereql0uxXICy2saFEaCke+agz0fiBw2AMsq4WfiC4Z3S1ap/DrFfGV7FEtOOuvFdhOQP3FFeSXLeYYlJ0e+qAL7f8kCs//9+9l/hZ8t08wGhjYdX/3j+TOWCI0kKjfQzOT7neYpaMEWwKSwKyf9P9Sbw9r6rRnBMSV8XtBB0ba6vjdA2psuBKYiE8NEqmjUPMQgz06dhSBFF5cgWv2wSgGDO7tAzyH3mv49cu3F3yQhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS7PR11MB6296.namprd11.prod.outlook.com (2603:10b6:8:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 16:26:01 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47%3]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 16:26:01 +0000
Message-ID: <fc36fc45-9357-ff84-f7b7-bda4001974c9@intel.com>
Date:   Mon, 17 Apr 2023 09:25:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] ice: document RDMA devlink parameters
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>
References: <20230414162614.571861-1-jacob.e.keller@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230414162614.571861-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0057.namprd08.prod.outlook.com
 (2603:10b6:a03:117::34) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS7PR11MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 64dfb05e-af53-4124-f6cc-08db3f606ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lqZ884U0F9jtgFKu+xNQctilokTFmj8hcpuNmXv/Yo/9WT6CmVVKFjHPl64+nJYkyypP6IECuqwGDkRoh7pnGdX2CiEIjcUByaymsgT+1jdmek+g5cytog42lyVuJDSvL3/fNUV3NEd6IyeLABE2gGZI8nhZ8YmYqPCzvFutN+rt8zrmd02mgtQt3NclDzseFAx7bICMcER1DNettTo96eEXMXDGXfMuSGnUyb6JQeeVKgbwbzK1jqXYIP9z/WKoeg8yoJRasJ0yt8O0bC08wTAUMy9tKE9BuMZ3zBpoEXtyKdRYMkXecqX2gxDHNEheX76THPlaeg2yxq3a/cUllv3a9r182svEYIUux3fEXAmdy0lD0S/PjXj3vwzYTFWpij2nAxfOkqWXeePAT8IuYidlSvOxzDn/5h/iGyWBiiCbAN8Mh0MxAcWLdSMB0KmiZIA059If8HWR+hc2as1DNk889dGxRfICNZTFU/hxis/YpeUInCmnCdoaxFTbQGMmpfvsSZg0ncHw3JZXklLicescE3pF3wpYptQ14NqyrEtzPwuIG/JJ5AngzKVpgvMZYRsHQGGSkzkVX84v7OxXlHAKelZIxnLPI/xeYNAAc0VLcGNVa6PKjUyV8HsnIZuA/cYQYUs6jMvZJatetjAgjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(66946007)(31686004)(66476007)(31696002)(53546011)(66556008)(26005)(6506007)(6512007)(36756003)(2906002)(2616005)(6486002)(186003)(86362001)(5660300002)(8936002)(8676002)(38100700002)(478600001)(41300700001)(316002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2ZDN0JabUZIclRsVTZxa014UHF6Y2djeFI2NmNjOHU2Vlc0cTIwd0JvdmNq?=
 =?utf-8?B?ZCtFMFpLNjJvQzRpeWltc3JqckhKNUF6ZmorSUJxUktWbWs0T09aRERRemVl?=
 =?utf-8?B?RHR0N2tyMXJURkpoUHZNN1FCdzN5bVFVdGZ6cEd6WjdkNHgvWFI0SmxoV1dZ?=
 =?utf-8?B?bkVWNW9PUDN5M1grKzBMdnRhZ1FBUjZOS21Ccnc2QU1yT1Nmd2NlV043bkxn?=
 =?utf-8?B?REhLWEwxMHFtRVNRQU5Ja3hjeHRibHdUSjBtbWl6K1h3OE03U1RvdXd4RmVz?=
 =?utf-8?B?RFkrcEFEM0tjQ3VGTkdhT2tWbVVla2NCYlE5VFIyUTRsS3RXTXlOd0pqcFJL?=
 =?utf-8?B?VEY0eWhyNmpMYUU3TU9oSGc0ckw5UVVhQTV2Y29ST01HTXBtNXhvanBkbFBX?=
 =?utf-8?B?aGtVUmp6NWdFRUNPOTEvUWQ2cGREOGNEcngvTkJUWHFXRXl1MGdKM3BSL0JY?=
 =?utf-8?B?d2QxWlExRFRrcFNKVEJDM0l0Q0dESDBCMTNIb3d1eTRvQk5UUFo0QXQ5WnpH?=
 =?utf-8?B?YmlIQUhtcmdwb3FTRjVZZlE1RUthQ1dmMUx4MlJlaHlZbEJQZ0ZDUlhUc2xq?=
 =?utf-8?B?eGJHVERiZVM0cnBtYnBDQzlyVDRGSnhtVFlBQXJRMUdCWXhoL1FuQWJCWmJs?=
 =?utf-8?B?dVpKSm5lQ214N2VPSkNQend5ZmtrY05ndXo4TmxUSWdNTTZMZy8vY0phRmZB?=
 =?utf-8?B?TjBWRzJOMmJqenF4TnM1OWpUZ1dLakhudU9nUFFEQU53cVVQOFhDaElpU0ls?=
 =?utf-8?B?VGhoeGI1ZUpPTUVUTlBLSVFGWGE2Qm5raEtVa3ZTbHhLZ0lBTVdTME5qNUFp?=
 =?utf-8?B?QVgra1g0TnBLbFFtRDlPYnRDU3piUUVMclkvSm8zbW8rRXhtbG9URnorRVpQ?=
 =?utf-8?B?MjVXQkNpdXdYcFNmVXlmWW0zS1RPYlF5c1RMcGtFQXJpVE53TG1MV0VVZjha?=
 =?utf-8?B?TEtNZ1krN0tieGt6YUI4WDhRL0ZNNmFQaTNza01wVUQvRHFvam5FNCtNelFP?=
 =?utf-8?B?THEzeXZkbWpNT0ZmSXVEdS91ckVCRGFNalJSb0JYTFRYZkUrTGZCSXdlejFx?=
 =?utf-8?B?YzZwL3pkdWNZTzBIWTlMSUlhMXhvTTlOZDFFSGYxb3l6dDBxYi8weVZKRm8z?=
 =?utf-8?B?SHV1SjJsU1FreTBxUjgrK0ZLdnpEcmdweG1rQXdvaERrendPTDF5R2V3THhJ?=
 =?utf-8?B?bG5pVVFidFlzU3o0VGoyTnE0YkdMWG1yVTY3SlE1ejZjV243WTNLd2pHMkhP?=
 =?utf-8?B?RmJLMnNxQnBneE16MVlrVlE3akk0ZmEyVWJUMjY1OXNuK2lnQytaVjBvWUxD?=
 =?utf-8?B?VU1YQ1hJMkZkS3lEc1F4ZEkyZFA5Ty9ySXJiSWtJQUtVS0J5cERBWTBtM0NE?=
 =?utf-8?B?RnFYaTgrQXRQaXV2d0pEQWNENllySHIwaDI4V2xVSGl3bE9RcUhTWkppbXEx?=
 =?utf-8?B?QzJIOTVHUUxMM3g5YkxTM0FhK3A0Z3FxMk4vaHQ0N2tyTTBra21tMmE4cldB?=
 =?utf-8?B?QVdHdjJoY2c1ZktyL0d2SnAxSXM2Q1NpY2t0d3VPYWRyUjBuWXg0cTNXV2xs?=
 =?utf-8?B?NFhXc09aNi9SMW5aRTVxOHRoaGRsNGpsc1pOV1lHeEJHcXR0SjAzdUVraUJS?=
 =?utf-8?B?YzVwZlBlaHJldnhNOVpWeFh6S1dUbldWNk55WnUrTE8xK2p5aXpNS0Faa0Fo?=
 =?utf-8?B?ZXppMmpCQ3UxOXRZbllDd3FuSEJjRTduQ2RqR2NwUitnSXBaMmhDdmhubkRE?=
 =?utf-8?B?NnplMFhjbVN6TVo5ZWdUbzNiampZYkJjc3loc3IwSkpiOHYvZ0N5bUVtOTBH?=
 =?utf-8?B?clVCTGVGYlpTV0lEaVJIa051VnBHdFNuTWNrWVk1eHZUVXBtOUxSMXpNbWJt?=
 =?utf-8?B?bk1KWnF1eVpubTl0MDBjeUwxLy91NHRPWmlad3NJSVhvRFJoSjFuZjc1NGxr?=
 =?utf-8?B?T1U5d3RKSU8wU2Y1RkJuU0J1QTdYbnI2TlBiZ0VTK05KcEJVelEvc3pMcEx5?=
 =?utf-8?B?QnZJYVdhMTJONWlvYW9Dc0p2YVl5dzJVTWlkK3MxMzdwM0htSlM0WGJVQS9S?=
 =?utf-8?B?UVhJbFMzTHFPRzVEVHUvbnFCcTJIcHlwOXpqNERjQW5iSllCOGpCUXhzTCtC?=
 =?utf-8?B?ekp6ZnMyT3htTk9zNElCU1hvNzZya2JKcWRyYmNua08yeWVSV2hEdWdvVDVL?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64dfb05e-af53-4124-f6cc-08db3f606ecd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 16:26:01.3760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7Hp3BtXm7aRLTP0pfiUKD3O6FU2eF9E/BlgcbtpzQDgxNVI7zegCJrQQ/ZlZ7CCx1ZmKjcB14+1PdTv4vuj/pdDoA9zA8JTTXBcwIOd9Uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6296
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/2023 9:26 AM, Jacob Keller wrote:
> Commit e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce
> devlink param") added support for the enable_roce and enable_iwarp
> parameters in the ice driver. It didn't document these parameters in the
> ice devlink documentation file. Add this documentation, including a note
> about the mutual exclusion between the two modes.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> ---
>   Documentation/networking/devlink/ice.rst | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
> index 10f282c2117c..0e39a0caba55 100644
> --- a/Documentation/networking/devlink/ice.rst
> +++ b/Documentation/networking/devlink/ice.rst
> @@ -7,6 +7,21 @@ ice devlink support
>   This document describes the devlink features implemented by the ``ice``
>   device driver.
>   
> +Parameters
> +==========
> +
> +.. list-table:: Generic parameters implemented
> +
> +   * - Name
> +     - Mode
> +     - Notes
> +   * - ``enable_roce``
> +     - runtime
> +     - mutually exclusive with ``enable_iwarp``
> +   * - ``enable_iwarp``
> +     - runtime
> +     - mutually exclusive with ``enable_roce``
> +
>   Info versions
>   =============
>   
