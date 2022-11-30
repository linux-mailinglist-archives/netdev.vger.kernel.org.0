Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011EA63E347
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiK3WRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiK3WRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:17:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A89311
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669846667; x=1701382667;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A3xv4pJuu05mCwhlXSF7e7MxMlBcuv2lndhYLpBtWtQ=;
  b=CBmdmp6Kz+DJh0DJTtcg/iRCpJMGIxScpzT3S5RO1L6sS0pxyQAE6RU7
   OuZqcdz/0f/2FIU8S3mkMCy6qFpg/+9tPKQmiqaKlUvwJpiGC/8NYjq9M
   o0ho5pUVN/XzMd1rCsYb1KyNiCZTrBzV5Se2usH/opZdGtMGheNYGiTiG
   4o+DPrRa2HpI8EozZhql1rkycjquL5hmF/jEhLjnrBPxM56wIvIP5DEDe
   Khodqfdy/u0dZ2zNFG6/0FAwppfoAX+8Mbin5BIx4XZ/OeE8B64EMvRTS
   GzypIGQFcEyrEK2GyiJM0E5WSY6YQqi9IIQ8a2H35WhxVOeUYUW90VpLx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="315547905"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="315547905"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 14:17:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707819772"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707819772"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 30 Nov 2022 14:17:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 14:17:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 14:17:46 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 14:17:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCA/LR9TKE9zaappzoGoxAcj22akwBHQebUC1XnhI5pyFhdtQli8EyGfow5X4K+pEnSugXupizNvgqmLitMSSF7PVjUBmGxW86mPRPKdbnAidg4U0434SKNOsGk+rFfu/LgK1lfaP9wVl3t+KZoUMN8H2XKLzBA2cAVfkN6+IpMUmDp0NE/wS3uq5rbWStuB97U56S2j/W+uGnjJPIMn37QoaGiCnsBPPYTL8ShZfZZ6pW3NnOR3zS+ekucs79bsuMt0gWFBYz8boA1PxaFZD4/3U5LfI4Bk7TLbwql/FGwqf0qyNhnr7QOhpmdjlxeMj4hRE1O2TzOiTznjrVu3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A67fAf3Yi8FDuJeR8WqGnUPKwh19R+7b9v6tsaQkxrI=;
 b=h/ZTDcUkVMTkrSktFquSVNyrINoHm+piFsVJiIixwZQpOhL/ACGjkq98C8nunsjkO9zJE5X1afYJWEHOn+733ids+cCg6R1tYURrEB3gPDvy8Gdf3QFCmbXAd6v5mEyhmBdy8f28Zy7ygIWFyvghFTXQFptYrvA0fjXu7pk50o7+nXyZz06ysNELYWppLobivoy1+PY8ZiNkMOdLJlN2nAFm8JgAo96yam1m2G3kH/1sgKp37KaWtTu12FDHJhx2KRH6nLK24AdMzHDJ+CJbIC2kkKFE44JRgvkwxnFsj9Bu0QAE9AvIPTL7yKK0u09DEBncuMBjp3DF2OblkPVXnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6512.namprd11.prod.outlook.com (2603:10b6:930:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 22:17:44 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 22:17:44 +0000
Message-ID: <a2240894-1fd0-3444-fd77-a1112ca2b85e@intel.com>
Date:   Wed, 30 Nov 2022 14:17:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] Ensure check of nlmsg length is performed before actual
 access
To:     <maxdev@posteo.de>, <netdev@vger.kernel.org>
CC:     <BenBE@geshi.org>, <github@crpykng.de>
References: <4fe84646-eef5-1a33-5451-11a7800c3c9d@posteo.de>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <4fe84646-eef5-1a33-5451-11a7800c3c9d@posteo.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: e30137fe-8ecb-40d5-7aa7-08dad320b405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ztpJhNtNXxxJDHJ8PY/ytvT4lYEs5KhPkoE8DNsAX/Cb47b/FUQryjMbBhLnNaxO/VjS0edAneMjqqyHn4X6BkobDv7ypuWo3SqsfUE2I3WkXRVZcmTrdhROjIKf+xyaddE3n7sFVIDRKBZ00OpLZDz5NtF79gy2DScyNvGwBPZrZKUifdIFrVmH7k8CC41YBMtwWWaVJHm2USVPO/8dfK7F8dCgYqf+5U0Qh8Sy6J7PyQsTfJpsw/4vzpw6IzP/T+fO2Ykwp+Dgv39oGRO8wbCSHYClaNO28Y9qQ1bPZoQJBuKwE0HxXsOaFyft9wn5ZaxHTivJ7Rqz/TEkADiUCtFLp7xkbtiuNoiR3ZJ8wOAt8ePA5cg+v54+i+Gr6kR30OsCP/LMGOxjn8bQrRPue7hnTaxHbAS/mElHFfX5lv4dbQDkS5ecoow6fGdlJuZXjj14ceTPV96iZhZ4Y4CzOyVedxgzqqlSwVuE3Yb0oGJVqM3llKWr745XYjmf/7JVdTxhLXf0aXsYM/qqkWog73twZGvZiSe6CPDOr1zBbW2RV+Mk/tm8veObxrx0yyjfSzapIoQjYFcUeOv90wSzdj8/36tyRuAdZwfqBuqQyNNUuDEb+DO/IS5vBQkwuUNJfY+IyP+Tue5HMPAA7o+49OYn5gSJyeylXdVHaOF6T7omuh76P+UNyesRUitNRFIA+dewi2hFJPrJfbmuHZgJFAuLgDf4ZxU7X6D2UEgYqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(86362001)(186003)(31686004)(36756003)(8936002)(6512007)(66556008)(66946007)(2616005)(6506007)(4326008)(6486002)(8676002)(478600001)(31696002)(83380400001)(53546011)(2906002)(66476007)(26005)(41300700001)(316002)(5660300002)(4744005)(38100700002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2NtRjZVck5wWkh5RUdnSVdZYUQxT01zbDhQaUNxWmhURWVabG5LbDIrMk0r?=
 =?utf-8?B?RWZQSkVHSFkzUHdVMWdNQUxFZmtBWWtpZzhlUDkwK1NPcmlNam1HMGdLQ1Zk?=
 =?utf-8?B?VWZ5OFhzRTBwY1BDTEU1S1N0SS9GVWNOMDJtUEdJSGUxb0hTNnUzcmxYZ0U4?=
 =?utf-8?B?RUhqV0I2bEhHYWx0SGxCc0JFakhCbWFTTFhmYTB5VWtnOHBsSmdDeEhuMkdG?=
 =?utf-8?B?elZKT0pkVGpBTzVMQ0c1QTZzS20zVis5eDhmTWtkMnE1Y1dkRzNQMVdEczlz?=
 =?utf-8?B?cWowcjE4RUF3YkRUbUkwZ2h1b1dCK05idXZLZm9tSE9nVkF4emhNRUtBbTdN?=
 =?utf-8?B?aitsd2dJQUtCRjc1Yk9TUFlTbUNheEhDYVg3MDgwc1QyZTNaaVJUQjRLN09N?=
 =?utf-8?B?RTdPUStUcXZWM3krbEMvU01GVjNzM3F1ZkZ3cWZ6L29QS0NoSCtHUWR5YVdF?=
 =?utf-8?B?di94U0pVaFAxVE1iQ1RxN3kyK2YwUytPVlh4Q0xTQUZ5eUkyeTcxNko5TVpy?=
 =?utf-8?B?Zmdlcy9Bc3l2bmZlR200N3p4ZFRQL1o2dCt6YWIwTjZBSWRGSHFLVEZkQzhC?=
 =?utf-8?B?eFo3OHVKV2hwWGVKcXVhTUlxOFBQWEJFS1Z1YTdyR2k2SkovS0pXTmZ3WTRH?=
 =?utf-8?B?T0Q0K21PNlpoa0FnWWo3L2pTY2pocUsrb0ZGaXBBZUM3U2NhNE9UQi84eDBF?=
 =?utf-8?B?UVlnb3dMemJMVXBaUXFXQk5DS3I3dDd1WnZ4aTVXNW5YbWRhb2RXVlM5eFFq?=
 =?utf-8?B?anNzK1IxQUx3eE13ak5yaElnMFlta2xSQUtoUk9vWmM3WDZDaUl6NzV3QWJ2?=
 =?utf-8?B?V1A1d1RKajA5UEN0U0EzejRvTitQOG1IMy9lNDhoSWRVZ092WGJZeExNT05r?=
 =?utf-8?B?d1haWkREVE1yL3ZmOWNzNnJka2xlUU4rOCtlYVdSWGVHcGI5T2RHb1FOd3Vh?=
 =?utf-8?B?bUh2TUJGb2RQcW9YaDFmSnVweGFXZGRwaE1ob3dYWnljQlBacW9YMTlNK0NB?=
 =?utf-8?B?TEV1YnZqcjRVWUlXTmlDYTMwTDI3eXJpQ0VlZXFoNVlueG9GYm9sTDA0eG9L?=
 =?utf-8?B?TjdNaElMaDB6cmU3S1FLZEVhWWJvMHI5UFFOMC9EZ3kwMFZCS09wQ3NwVlR4?=
 =?utf-8?B?aDc5SHZxb1IzMU9kVnBQQ01VaFBOYjNFSHNjN1YyMFh6KzNGd1RlQkR0OEE0?=
 =?utf-8?B?ZUxKQVMweXZiTE0ySUI3bTdEKzZRdkNJUW1yYkR5VFJWREdHQzdTbHlZQm9n?=
 =?utf-8?B?TDFXSHpYRXVqdHpOOGticWJWaXN4dldQSng0SXMxM2gwY0pkRldwUnJQN1dv?=
 =?utf-8?B?ZFc3STBQQzdGeHh2VXNBR0kvZXNicWVyTnM0amNtS0trMFRCb3Q2cXV1Z1Qy?=
 =?utf-8?B?RXM5NlhPSU9NUThROE9QQWRhNEFZRHlQS1F3WWp6czZDR2xhMzY4TWtXTTM3?=
 =?utf-8?B?YWtHaEJ1b1VGVWtLYXBPRm1GMy80c3o5a2YvVXI5dGFtNVVuWGw1cGsxdTlL?=
 =?utf-8?B?UE1DdDFzQ1ZwUE9wK1pIaVQxSGtIZXByVXhjQ3M5ZzhNUHdrZlF4aHVUMG1U?=
 =?utf-8?B?cFZjZzZ2bDBJYTdEcTRSWHJ5SFRGdVRkaDlVc2JVcHNLdVNTTGo3VjdON3Z6?=
 =?utf-8?B?OWxWTlF5NzJrT3FxUUk2YWdmU0ZRNStybVo3STZEY2FBQmo1YXJkUU93c1Bm?=
 =?utf-8?B?WUdHMGVqN3VLYWRXckdadXBnVFk4a2thSmhFMktpa0FGdGo1LzluTXRIWitJ?=
 =?utf-8?B?cnJYRGZob1hRME0xZDlIZnpJVHR1enhmc0FlTW1hK2lJcFlpQWNMckJaYUkw?=
 =?utf-8?B?M1RXbGgyd2VwR2VXYTNWd0RDVE5nWlZVa1RsTjcwWXJuQjN0ek9BcUo2MXJ0?=
 =?utf-8?B?VVF5bGJHRU9Xd29CNTJ3cFRpazlmNCtSaGduVWNFYmd5STFOV2kvR2lOQWdp?=
 =?utf-8?B?b1pwNU4xQTdKdTF1aUMwZlAxTmtrTFROcm50cXB3UjZ6NUlUanY1U1FpNlZq?=
 =?utf-8?B?NEhiSXRhdHRwQ3d4bVorOHNrNmQ2Sm1iaWMvWHM2MGQzcFJFdjdGc1l1NzNs?=
 =?utf-8?B?YzhJQ2VQbHJiaXY3cXExZys5N1FsRzhNZVVack15Q2ttd043alQ1OFRBb3lW?=
 =?utf-8?B?Z1FlVzI3UVo1M3FjNFc3VEZoZUZ0N3lCaE9ua0dKcTdWYkpDTktMcStSeVov?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e30137fe-8ecb-40d5-7aa7-08dad320b405
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 22:17:44.0268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FFSnYWCQmpPp8E7l9ndNzX4Kldq/U/pRS/5PUy4Xm8XWOKIEu4ng6uDiqugQDRbDnm66bfcZsOIkXKOnUxRYSD8YFFcWjKlijdWEUpevVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6512
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/2022 2:09 PM, maxdev@posteo.de wrote:
> During a brief code review we noticed that the length field expected 
> inside the payload of the message is accessed before it is ensured that 
> the payload is large enough to actually hold this field.
> 
> The people mentioned in the commit message helped in the overall code 
> review.
> 
> Kind regards,
> Max

Hi,

Typically patches would be sent directly as plain text in the email 
content, and not as an attachment.

As this is a fix, you would also typically determine what commit this 
fixes, and add a "Fixes:" trailer to indicate this. You should also have 
the subject include either "net" or "net-next" along with PATCH inside 
the [].

As for the patch contents itself, Linux still follows C89 rules for 
declarations, and you should leave "int len" at the top of the scope, 
but assign it after the validation check as you do.

Thanks,
Jake
