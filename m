Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779A5651573
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiLSWQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLSWQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:16:07 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6512BE9
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671488166; x=1703024166;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TRphWeuJjHpbQLKijKR2mZP9GrpjT4lICvc2q9aWbHs=;
  b=YJ9ioCt62Uqx2zKXbGcHkGm516KgHA671odR4IfCfoIjgPn5BS+YdJ50
   tzYID4CLzLCpuuGSECYUd+OR5e/zZoxYpCo98sZNrYEMIWJxoSc0DWruG
   a4SF5twuPHpQVYSr59O2pW2qDHr5V9nkU5oSA8Reugk+edkQrU/KUq2LZ
   lpg5qlYX/UR5YTmszX1jcci2hZnn954OKYmVFjZ6grxy+s7ZOqf5mq5qR
   48z7v9Gb5n9Fq1myNAeamH5Ipw8r+UVSYF3CaMv8b8pAoD60/vQqhBEoa
   rwok4TBfpkslsYBkRSgHKu5JBg6dX/j8wrQjyFcFpSLv7AZFY05ESqddf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="383805515"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="383805515"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 14:16:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="825001186"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="825001186"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2022 14:16:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 14:16:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 14:16:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 14:16:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jr7kr95aGkzgHZRlPlHBuZLiGBPPR+we1CFkJlx/IAWm3SeXKtRZB5H5Gzw16dkXlUJilc5O190rM0195iOxEppDViDAiVplkXHq0K7gA4CfqtICyoYWQHv4MPhKuln4ghnlLRnBrR+0zE8Kjst5gxxFgV7kZXx08Tivbh8RQ+Y9mVwlmQ9ZlrKeiMwRziBrSt9VOgtrCJNYwJ/O6tSSOXiEG1hszIquD25EYbc0OT1F7A3MTio70hxvwnmAiHFf0h0anuQcnnFQ648QDMttXWsSNUaeWw31WxOfwO0z1JzFW9aEQvnpj3ds53c4jpciZCgp+GS3fvLPD4CxEQzSjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYKuHv/+Sry5v3MBMmmNyVNNXv23rBjiKWWUJUghU0o=;
 b=SeZqHwLiZ5jzs9bGNkIW4HpXLZeIftv7+OkjdO4oYJgaYO29lF2BDHgreuVVxJ4eyRvAqEqPo2/BY1ESpp5W3z67FUnCyZmLAdHsuiX8GJdiZ92bagL8TIslAiuqvLtBOejO/WZeByLYOPSQ1HbARYG8+ZhGM8ojBoN77ajExdkFRv7R6uf2IaWfPXp9IcqXtfXPFIaL+RDArdc0kGVNG2NbEP2Y2ZdAAAr3jT1qF29fZ8cs1ZHwYJIbf0uH27pC3ZtYcx8p/s5DHY6TEtQKVoRBz67yz7dSjRjECxQawblMJuS82bD5r4MIx7NXZIcTvwbLK66iq4j/H5sRINnOpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB6394.namprd11.prod.outlook.com (2603:10b6:208:3ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 22:16:03 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 22:16:03 +0000
Message-ID: <d4a5f340-157e-3830-1efa-420408ee1b33@intel.com>
Date:   Mon, 19 Dec 2022 14:16:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 00/10] devlink: remove the wait-for-references on
 unregister
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
 <3d169051-e095-6a2a-d5d8-409a5ad8af4b@intel.com>
 <20221219141000.32c94617@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221219141000.32c94617@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b5cf15-0a28-4d73-8658-08dae20e9e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Bp4hRlHrdrIYpvApIqgnsQHwl4OXgrnGrk4+xjORWELXBbg19bZyciUy0vIcbgf9VZEUQWL2VxDuEAIPDoAE9IOVlW/z/pT6ebL4gVSjMzu/FnQOZ4OEnAf/b1ev+gmSs5uV40FPviudikLnsruxTRTT6GjwMGuIEJUtkOwLVDWsbSbWUn2Ej8mxDs7U5QBI8cBGfy+D53Jce239Vt1hsnQ8bZYQpu/8rEIH8MFSoPwNXpFA6UVpjUGocN4v5DPXcPKDly/civzLvo0s4kNlZxrG+uMt/bneE0drCEfyMDECz/30HRjojVgDn7QUIVX2Eir73SaHFIqBgPL/xEEUsKCwQFdBRW7b0JvajhFQgN53/llg6DraVjsQA8Zc0F/bYn77jT0VojfEvDB3jYVb2X8nGNkvlPzsNCuXFDoOsoBsAgrYwfG//LVfRDtX+CI8QyCjFSpCS8TdP985Ly22dvPnfYWfKuxyIc1u6fb8qHTt13ASrhARVCh9TaAg0/2yP/ffayiANfGeNLv+rELuBqf0e43Jquze18cZ+YY+iopZoUpAGd79Y5UW9DBvtwOkelhxa/Gg21zKqaIJDyLu73FLNw0rtX4zWPIT/zYumFUNNkj+w5Zfw5aRFNdEQzwJ21PU/arkbgX6KXF5XmGvugMFgiZy8jpOzPVUIx5+awVKw7OiN9z2XMFh2KveSWAXLINDnD06015dSKf8ncTmgEv2sGIvwMmp7QpbSbQqZL0oLMPAfCp2or3oZJ7bZ/KnlNpcLxNue16Fvsm5mu0Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(2906002)(31696002)(38100700002)(316002)(53546011)(66556008)(4326008)(66476007)(66946007)(8676002)(6486002)(6916009)(966005)(2616005)(86362001)(6506007)(36756003)(478600001)(5660300002)(83380400001)(6512007)(26005)(8936002)(31686004)(82960400001)(41300700001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFlZRUg2WjNRRjZMekFQVlhSSklaM29yNHRENDlEY1IxbVliVk4rSFhKZkdx?=
 =?utf-8?B?OWc4SWd6MVlaS2tteE1XYUFORjRJejMyMFh4ZXJSdlFlRVpJbnRuMzJQM3NY?=
 =?utf-8?B?bk9uNlI4MXhUejVZcTBMSFNSczNmMUhDVzlJRGp2c0MwMHh5ZjdKVjl5NUJT?=
 =?utf-8?B?bWJTb2lNUzJWNDZlTytxNXU1QjZhYjVZVDlmMklCL1RLTWdET0EzN0NrQ25u?=
 =?utf-8?B?M1JPb0lTbjJUMHhqQmNxdkdVdW1XMkk0OE1PVTFPeFZlYWtiVjl0dEpQRXBQ?=
 =?utf-8?B?aXRsN3p2a3lUSFppVFJ0Q2RkMitjSDB2RFJyZlB6M0E0bTVLQkEzdmwvZ3FT?=
 =?utf-8?B?WnA1cUNGZHpzM2dod00ySDBmNGJmL1ZhUHZCNFhhZkpqM3dQaU9jTW5XQW1R?=
 =?utf-8?B?WXlqYTlzRGNZV0xJV2JqV3p0Q2V3cnRSbEJzcmFYMHc3UEhZNGZBYldYVzVv?=
 =?utf-8?B?aXhjS2d1eWw0cWNkeXJubitjZ1BBRjZOQ0FCbzYxdUh1Y1E3MThBOHdtK0di?=
 =?utf-8?B?bEF4RmprcUkwVkZUcGxFMUM2MnhsSCtPU1NPNXIzR0JMNkc5QklSazFOb3li?=
 =?utf-8?B?RTBwRDVFbGFseDN2aHFCTGp1T1p5UVcyYXVRNWxCTWZNT0Q4T1RkdmR5TFBz?=
 =?utf-8?B?Rkt0cXFncEx4Zkh2OHNvUnljWFhvVmVLem9rc2dhR0FKaW96cWpDdThDK0N0?=
 =?utf-8?B?bkQyd1VVY2U1Z0w4bFV6M2FEWk1LZmpZS3lvZHNtOXg2Vmx1ek1vT3ZXU3NH?=
 =?utf-8?B?Sk95cVdNOTkxOVpmZmZlRHBONE5zRG9VSjdVb01hNVFycGUweEZJNWxGMDNw?=
 =?utf-8?B?L1ZPeGdZUys5bGEwS2tXL3h4bVV1Qi9vTEhGM093bS8yQmdJaUJ4WElYV1Bo?=
 =?utf-8?B?eEx2ekorSWtUbzdwUmtpOUdnUEdKZ3NCQVpJQjd5WDQ5bXBWZG9XMWtEcWxi?=
 =?utf-8?B?Zmd4czJMcTVCZWQvY3Q0OGthSXBQb2h6bjkxc0tmb01FZllXN2EreGRDRFJp?=
 =?utf-8?B?WTZWVFNPOG9KMlVYZStUbFRKQzhoY1dWdmpUNzNKVUZ2YUFjK1ZrYWFsMjlo?=
 =?utf-8?B?M3pwcjdBQTRobXhSZVMrT2g5S0FPN2lvWGNzaGt0RUZQeFp3dDQrMTQyQUFD?=
 =?utf-8?B?Sko5eU5KN3lyUk9iWjdOQ21xdS9ZYU05UVVrOTFnMGtjRDBWalIvVTNPZmdp?=
 =?utf-8?B?RHNQK2xDMUZ5R3RWRVR1QmJKZU4vMExxYmNPS29VYlhHYnNQTDhWaXd1Q2tr?=
 =?utf-8?B?OWthVk44cDRLTHlZNU9OOTMxRDRxMVBxbVY0VUFwRWdUTnRpTnNiWmFEaHZy?=
 =?utf-8?B?YldVRHZIa0NhMlU5YUk3RHZWeUlJcXNPS1dFQ3F4Rjh0YURFL09lMmVJUXYy?=
 =?utf-8?B?UzRQRDNnd0pxWnppbzdqQjFQZXhQNnZ4bEt4dUllMnZXeFFXc2l6S3Z2Zm4v?=
 =?utf-8?B?TktDZ2M1eXVXeWlLd2laOEJoVlJ6M3lKd3h6VlBsQlVvWlJqRS9COC9jNDRu?=
 =?utf-8?B?TXR1VWlSQUgyT1k5UEFjYUZORkZRM2czV0U1eDI4aytUaTlqUTR4OFJBOXBW?=
 =?utf-8?B?aXZYL3ArR1pLemZWNnVKcUlFZTl4ZGQyeXpER3ZtbStPWG9SZkRpZktTZGYw?=
 =?utf-8?B?dzAyTFNIRWprR1BiQzNzemVhSDlPRVRJUnp6anFQTjFvTHAxR2luTmVyczNF?=
 =?utf-8?B?b2Izd0pxdmF1enZQUEhpRXljakFSYnZsdEVGZXZoa0dUUGx2a2VYT0xJMGt4?=
 =?utf-8?B?aVF0bSs5S1dldmpsYm84S0RXTmNUbE5GS3VYRE9vMklucWZ5WmJNQ09nSHdU?=
 =?utf-8?B?Vm0wK0RHd3JsNmsyeWQ3M0JEN3VtTndTQzNIMUp4VXpCbmZPcUxWK1pQcWpI?=
 =?utf-8?B?Q0ptQ1pwdWZId3V1Y1RJMTJnZVVQOTErZlVjN05jT3ZLNE9NMC85V3VxSGgz?=
 =?utf-8?B?ZDFZcjBLQmptWlVBMHptY0dKZXh3aVA1b2orQWlPb2RydzcrLzdVZTI5dzYv?=
 =?utf-8?B?QUdXb2xJRmNic2RtR1hWUVFxRHZYNUhHWDNSSFFYeGFvanhpR3h1RnpDSTZ1?=
 =?utf-8?B?TXFSZVdjb3VyNlhvbFVhNHRkRW9QaVZqMHNpdHRCKzhqZENsOW81MlM5UmlP?=
 =?utf-8?B?cjZTRjdGN3FPcytnaXFBV0tzckV5V01PK1o0bGZ0Z0s0bGdaM2lIZGRwd2ti?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b5cf15-0a28-4d73-8658-08dae20e9e22
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 22:16:03.7609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 99AwuAhSTDLj0EVypfkO/kz7OQJ9QTUp6X/lfr21F6pvbfyssspgZsDudemEiEL+hxBJxjoA2btxvDV08CrsrtP1wlCzqvok4jP2GvZw/OU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6394
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/2022 2:10 PM, Jakub Kicinski wrote:
> On Mon, 19 Dec 2022 09:38:09 -0800 Jacob Keller wrote:
>> On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
>>> This set is on top of the previous RFC.
>>>
>>> Move the registration and unregistration of the devlink instances
>>> under their instance locks. Don't perform the netdev-style wait
>>> for all references when unregistering the instance.
>>
>> Could you explain the reasoning/benefits here? I'm sure some of this is
>> explained in each commit message as well but it would help to understand
>> the overall series.
> 
> Fair point, I'll add this:
> 
>   Yang Yingliang reported [1] a use-after-free in devlink because netdev
>   paths are able to acquire a reference on the devlink instances before
>   they are registered.
> 
> [1]
> https://lore.kernel.org/all/20221122121048.776643-1-yangyingliang@huawei.com/

Great. I also think its better to allow some of the sub objects to be
setup either before or after registering, as some things might be
dynamic. This series lets us get there safely which is good.
