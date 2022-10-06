Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248AB5F6A1A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiJFO52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiJFO50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:57:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB92AC384
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665068246; x=1696604246;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pvIBxQbXScr1f3rOfvLzP+TJuhqi5NAwmmMVWw4QcKU=;
  b=gVezQqsv41YNC91fHhsgR7mrQ7Q0KUDzCg0je3jr1fpRqlcHflpWocoy
   8QzuLz/9pknZxJu7joI4j8VPuES/bPcmq/1HY8sendR3UKlbv1Z4a89q7
   3cQSP9UAtEBwRk069IJvvZKRWHMh08dMWfj9Xyxhix4gjfPdfoM5qGewF
   dRRsIldpHGemGZXUbgS9elB4mjM5zgm3EYb8ERGjO31czZeOL4DpK0N0K
   SLki+IGIswzRUTTgKWxBPe7pJufjRSnCuknwFB9ueiJf0pLDY6MXbBnyS
   x9TCs7XsRdLWBDa7faiHE5l4DLv74xjAeXEF/8OcSGUxGI/5RzSJJwGab
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="304458930"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="304458930"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 07:57:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="729175730"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="729175730"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 06 Oct 2022 07:57:25 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 07:57:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 6 Oct 2022 07:57:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 6 Oct 2022 07:57:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmeLvRTBdxLl4MvTwH+a52PL4hDktFbk5wjUm+QhFpVKB+YV8G7asSpE584Oelq2Lh3w4RTSuhOsbi3OsltCGuIsJZGVo9/igJDFkzkJ4BFKgRXLE6nJiFvA9sPaIvibg1ThXgCGOzvigh1SmeX2QxFEtb5QOsZpp/nDszYIZnR/aCZhR2LK7U6hLCqM+4b9JU7gXEwjLuF+v97Qwmu9UJG/uu/QmHWk6yX1NoSjqSK2rIqSPsTrg96GZ5ZtD3Rcns88XmpM7c00LFsjXAaheSW/1hu1CaTRwlPuBZQKsKodgNkVkY8E5ulOWzVnyM9c7B115PEeaGpGlfxhpVyM7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CekYUQnO0/EYhS00dLjE3Sqg5hxEN3rVPZZVFKSbA3E=;
 b=J9puwq3zMUmZNdmxZrhD+92FYkpgjRAgA9GLnc2H0VZxFpfURgq/uLvN5vLntKfU5KNZScZCZhJ7JLxzhQomRU+7SQ7H1WTIpKlIMVvjSVbsqWIzLS4TNaj4EVHhyFMQ8TsoMkO3+MU3cF3QREUe2LrEwnVIrktijks9eGpfNqivcuJLLddANqg1FhDeYJMAtFOxHdl/l3m9Zhp1nIqkPFHqGLaLNDkxERIzd3Xodv29SLNslGIMqCwsU244ougrpR9woh+wEHw/YjN98UEcp4D0LXYibMqTpCtTKbTMMQXm2QXmMA70C4e69IwYIH6WgsqlHgzsLBVd1hF+1LGuLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DS0PR11MB6349.namprd11.prod.outlook.com (2603:10b6:8:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Thu, 6 Oct
 2022 14:57:23 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::65f0:bb9b:623e:49e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::65f0:bb9b:623e:49e%6]) with mapi id 15.20.5676.030; Thu, 6 Oct 2022
 14:57:23 +0000
Message-ID: <481f7799-0f1c-efa3-bf2c-e22961e5f376@intel.com>
Date:   Thu, 6 Oct 2022 09:57:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Joe Damato <jdamato@fastly.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>, <jesse.brandeburg@intel.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com> <20221006010024.GA31170@fastly.com>
 <Yz7SHod/GPxKWmvw@boxer>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <Yz7SHod/GPxKWmvw@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR20CA0035.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::48) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DS0PR11MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: f3654dc3-0f74-4744-ddf9-08daa7ab135a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/ic4kDqyKYA1h3NrHzd4jsehBgFUQDkaB0hrr47cOkaP7QmQwuSyRgZjasBhUWWHr2cE+liG5QWNkQ0XTWpd2za+P64OSwDm+WP/F+AOU8SCTzDvLm+1rtrANsPVmpOw6XaCn+WNNuI7C3b//X+uM9lsvfeO2K/z11tQDKSL1ZAKvGihs67kXMHujtCX9QsDAQwNAUNw5hKHknSR2+Fa4Wt8pmmDR+K/0MSVgrs/ltnUhMSpubl3h3xI15L1Vzn4CTkgEYzM7oJ4sjRYpgDjOFAokFQW7o6hfFFrJ9iZkuj9N+6rPpAQBf5BaXjDSlMQPUk1FQ+2QTYTW+bLtSl4RpCAr82p8vJMfJrH0zUdI0ZLKASa4QL/f7jawAEdqIQin7IYKCBsM5FBtbaNCD7+cKPb1Y8lL9bXCLeaE8oA22NPXqmDMaN+V8wG8KJLNtDUg7pP6FYg7UhUh9Y6eRHiQMe+4wiT+ZKpbtBVHlsBD+51MZNghXsnDHthn8oiwg7OonsKnAsiPowxTfHcjxrOd8Jvra4YGs1G34iCJe0xePcNtNgePBa3Yv161eBqBE5EQNke346ivLj6D+IP6PzmjUDTMc/Z6IUBU0VJP3ewZAyGatF4C7tKT/54S+Ic6q4MQZFJe34DICa4gbcAV0fjzNNVodnLXK3NkiZcdJMrQwfTIjRGXmKAW5HrWeEvDo/gzpXxAU5OKUUfeQgWadu2DtrLbpAX1vi39+9GII4zLXqiV+joIF2pVrOERZd3pOIYn+coJFmWn0ahELUctCaYzMCJVcomO8GemNfNi8cbZU7ooRKvkIrXzySK9d81FB3I6xucGsmddLY7cENwbq1Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199015)(31686004)(36756003)(83380400001)(38100700002)(82960400001)(86362001)(31696002)(186003)(8936002)(2616005)(53546011)(6506007)(6512007)(26005)(478600001)(107886003)(6486002)(2906002)(6666004)(5660300002)(316002)(41300700001)(110136005)(66946007)(4326008)(66476007)(66556008)(8676002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGtKSjN3bkxORkl3QzdmWEZHMEFKbkRtOUtnYk5seVBMdnoraWFJcDNoSTBz?=
 =?utf-8?B?ZTRyclArU2JOMHROcVdDVEtNY09TQWEzQ2d3YUpWek92bXkxa0ljNGJERVdh?=
 =?utf-8?B?a0ZZd1h1Z1RuclJkdi9HcWtVbHZoS2pWWkcyUE1ySlFiOWFzMkdsUEVnVmdF?=
 =?utf-8?B?YXJ1KzkrTnNyR29HMTZBMWQ2RitFZVRsakRlVmlBRm1tRHEzOGdxelpoc0Vh?=
 =?utf-8?B?OXNnM08wVkQzZ2R6ZUQxRS9mRS9YTzRmSThUd0hMWTJMYktlN2xaSWg1UXZ1?=
 =?utf-8?B?R25vK2tYQStteFRVUGZIb0xhZ2NDSnFxaXBZektsVlRydmlpUUV5WC9WVXBE?=
 =?utf-8?B?NGtETzluV1V5dDBab3lFMHdHS2NyRGNWYkY3M0hUK0NoN05ZRzBReU9IaDYy?=
 =?utf-8?B?SWwvYXprUXM1R3ZwVjJmcER0QlYwTnNza3p3Ymw2SUtuWlU5bTZFNWM1VG9P?=
 =?utf-8?B?M2wyaW5FbDdhUUpaUTdyUzBsbWQ1VlRWMW9OWXNtMmVTQmRPZm02MDBDNWJ0?=
 =?utf-8?B?U055SkhBV1lsek95cnYxUEo2L3ZaUFZPZDdKamxVdk9yZ1lWck1mK1ZmN3lu?=
 =?utf-8?B?VXJrM2VDMFRuRXZzRFJzK3FIeHg0Tklpd2tnZS9US25EQnVwdXd5ckZxQ2I5?=
 =?utf-8?B?b2RaamVGblJYd1VrbHFjLzY1TzkzdkZoZUVRTUZ4NDBxMzNzZGtCNmQ2WFo3?=
 =?utf-8?B?MGRjQW5mZ2tHcWhyV1NsK3JtWXY2YmFZTVdPN2pjWEhEMXJLSkZFTWZBZHc0?=
 =?utf-8?B?bzlCd3h4cG5iTlVqbStCbVQ1bUh2cjR0aVJxZGFJTHJ6UDVEYmlqSjdmbmt3?=
 =?utf-8?B?VWp4QWdCdnNoa20yeEdoYURNRktQV29scnQrVkNxRHl0bGYwYVJQZG1tTGpV?=
 =?utf-8?B?a29DOTR4YlV4THZjTmdHTFhrdzQzM2ViQkdhMTBhaUdiN1drUitiVFNTTEdu?=
 =?utf-8?B?YzBMQ2hqNU9ycFdTK25JMm15MU9kNzZiZkJOakRWSEVaYy9UNlR1MnEzRUV3?=
 =?utf-8?B?SFRVb3p3VGdZM1oyNEFKZmQrL0lCN3hCRjg5dXhaTjZ6enVJSnArTnNmeS9o?=
 =?utf-8?B?OUNKd0I1bWNyWDdGNzhKTlRXTmEvOEVQeHI1NHRQU1Q0V0hkWWttY3M0d1U3?=
 =?utf-8?B?a3M3TnpJOEdDc21rSU9MdENZUUVuTmtCQnhEQkxISHNsM1gvbnJIbm1UbmhH?=
 =?utf-8?B?cU93N0lweGxEa2ZZMGZDMnpRWWdkWHI2Vy92aDhiaHA0SHoyWWpNUXliallH?=
 =?utf-8?B?TTRNN0tPdUtpSnA4Nml2Zmx0dmcxVStNUVhvZ1Nxd0x6eEg5RC81bldFTjN6?=
 =?utf-8?B?RFp4SmRuTlJQWG9zL1diZUJHbDlGUnA1dHpJSTMvU3NWeXBRY0hub2NoeUR3?=
 =?utf-8?B?MG9VUTZVSXlJY3ZVa2NsU1F2UDVOSS9CS2NXQnRZVW9nb3BreXBJbUlZbmZ5?=
 =?utf-8?B?Y1pLdDdoa1pCRFdPeFdDZUNGUXp3SEJBNEVHZUJ4QWliMDBXOGg3TWNUWGVz?=
 =?utf-8?B?a1lna0NRVXR3Qml1MmdncEdZc0hBTitadC91aFpaaFBMcFBHV2hhdlUyMkZI?=
 =?utf-8?B?WGIwZTlodWtQaDJpcFptZnhvRThVTjA4MEJ5c2lHbVg3R01nTUFza0xhbWta?=
 =?utf-8?B?R3BQQVF0VDc4ZmlsSDRCLzNuMFJFVWVxSXMwclFFSEtkTWxyOUhvZTh2QWNZ?=
 =?utf-8?B?SmJkaXhITWhnY09NT1V2S3RTVXhKVW9XajhpdWlQUWN3U0FQeHVUZWU0bmkr?=
 =?utf-8?B?dUpMT0NzQnNLMHVxdXVhWndzQVRYR3FSNmlzUkZudHovY2UrOXFuNmEyR2VN?=
 =?utf-8?B?dXErSXBqQVcxcTNxNHN1blBWd3FRbkFDdmd4ZDdlSWlCdk1vUmtmdllhWFBp?=
 =?utf-8?B?bmZ6a1JSV0s1UXYwcWRZZ2pseEJVMGpxRlBra1lkdGtPbkY5MlIyaWUvaEZK?=
 =?utf-8?B?R0FlOEt6d1BBYlhGSXRTYzkrcUxicjJYM0ZJbzREQzV1dXVUdjBvMnBVclRu?=
 =?utf-8?B?MGRQVlpPZTlYSTlmMVpXU0tpRjRqM2FFRGxic0hGbERIMU1IU0l2RVFsWlkr?=
 =?utf-8?B?dkVmRzdJcE5ldldLdTQxL0RyMmdCaVFpQ2F3VmhWa1M0c0pTRjE5ekx3Q1Ir?=
 =?utf-8?B?YlFOU1NXK0QyRmZMWjBqd2FCRkN6UWdnTUw0UkFoRCtYS1RLeHp3Q0JNdlpm?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3654dc3-0f74-4744-ddf9-08daa7ab135a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 14:57:23.3420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2HXXup75xB2X7uGcpKGulQ6lgRdSn2ZAbwF561+TDTeBURUbSE8D0JpMNay6fr0xlb6B/ThHLYp8f+ZKPdM1LhDT0n0vlZL2CW3luC7+CU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/2022 8:03 AM, Maciej Fijalkowski wrote:
> On Wed, Oct 05, 2022 at 06:00:24PM -0700, Joe Damato wrote:
>> On Wed, Oct 05, 2022 at 05:31:04PM -0700, Joe Damato wrote:
>>> On Wed, Oct 05, 2022 at 07:16:56PM -0500, Samudrala, Sridhar wrote:
>>>> On 10/5/2022 4:21 PM, Joe Damato wrote:
>>>>> Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
>>>>> the number TXs cleaned.
>>>>>
>>>>> Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.
>>>>>
>>>>> Care has been taken to avoid changing the control flow of any functions
>>>>> involved.
>>>>>
>>>>> Signed-off-by: Joe Damato <jdamato@fastly.com>
>>>>> ---
>>>>>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
>>>>>   drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
>>>>>   drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
>>>>>   3 files changed, 24 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>>>>> index b97c95f..a2cc98e 100644
>>>>> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>>>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>>>>> @@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
>>>>>    * @vsi: the VSI we care about
>>>>>    * @tx_ring: Tx ring to clean
>>>>>    * @napi_budget: Used to determine if we are in netpoll
>>>>> + * @tx_cleaned: Out parameter set to the number of TXes cleaned
>>>>>    *
>>>>>    * Returns true if there's any budget left (e.g. the clean is finished)
>>>>>    **/
>>>>>   static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>>>> -			      struct i40e_ring *tx_ring, int napi_budget)
>>>>> +			      struct i40e_ring *tx_ring, int napi_budget,
>>>>> +			      unsigned int *tx_cleaned)
>>>>>   {
>>>>>   	int i = tx_ring->next_to_clean;
>>>>>   	struct i40e_tx_buffer *tx_buf;
>>>>> @@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>>>>   	i40e_arm_wb(tx_ring, vsi, budget);
>>>>>   	if (ring_is_xdp(tx_ring))
>>>>> -		return !!budget;
>>>>> +		goto out;
>>>>>   	/* notify netdev of completed buffers */
>>>>>   	netdev_tx_completed_queue(txring_txq(tx_ring),
>>>>> @@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>>>>   		}
>>>>>   	}
>>>>> +out:
>>>>> +	*tx_cleaned = total_packets;
>>>>>   	return !!budget;
>>>>>   }
>>>>> @@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>>>>>   			       container_of(napi, struct i40e_q_vector, napi);
>>>>>   	struct i40e_vsi *vsi = q_vector->vsi;
>>>>>   	struct i40e_ring *ring;
>>>>> +	bool tx_clean_complete = true;
>>>>>   	bool clean_complete = true;
>>>>>   	bool arm_wb = false;
>>>>>   	int budget_per_ring;
>>>>>   	int work_done = 0;
>>>>> +	unsigned int tx_cleaned = 0;
>>>>>   	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
>>>>>   		napi_complete(napi);
>>>>> @@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>>>>>   	 */
>>>>>   	i40e_for_each_ring(ring, q_vector->tx) {
>>>>>   		bool wd = ring->xsk_pool ?
>>>>> -			  i40e_clean_xdp_tx_irq(vsi, ring) :
>>>>> -			  i40e_clean_tx_irq(vsi, ring, budget);
>>>>> +			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
>>>>> +			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
>>>>>   		if (!wd) {
>>>>> -			clean_complete = false;
>>>>> +			clean_complete = tx_clean_complete = false;
>>>>>   			continue;
>>>>>   		}
>>>>>   		arm_wb |= ring->arm_wb;
>>>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>>>> index 790aaeff..f98ce7e4 100644
>>>>> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>>>> @@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
>>>>>    * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
>>>>>    * @xdp_ring: XDP Tx ring
>>>>>    * @budget: NAPI budget
>>>>> + * @tx_cleaned: Out parameter of the TX packets processed
>>>>>    *
>>>>>    * Returns true if the work is finished.
>>>>>    **/
>>>>> -static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
>>>>> +static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
>>>>> +			 unsigned int *tx_cleaned)
>>>>>   {
>>>>>   	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
>>>>>   	u32 nb_pkts, nb_processed = 0;
>>>>>   	unsigned int total_bytes = 0;
>>>>>   	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
>>>>> -	if (!nb_pkts)
>>>>> +	if (!nb_pkts) {
>>>>> +		*tx_cleaned = 0;
>>>>>   		return true;
>>>>> +	}
>>>>>   	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
>>>>>   		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
>>>>> @@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
>>>>>   	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
>>>>> +	*tx_cleaned = nb_pkts;
>>>> With XDP, I don't think we should count these as tx_cleaned packets. These are transmitted
>>>> packets. The tx_cleaned would be the xsk_frames counter in i40e_clean_xdp_tx_irq
>>>> May be we need 2 counters for xdp.
>>> I think there's two issues you are describing, which are separate in my
>>> mind.
>>>
>>>    1.) The name "tx_cleaned", and
>>>    2.) Whether nb_pkts is the right thing to write as the out param.
>>>
>>> For #1: I'm OK to change the name if that's the blocker here; please
>>> suggest a suitable alternative that you'll accept.
>>>
>>> For #2: nb_pkts is, IMO, the right value to bubble up to the tracepoint because
>>> nb_pkts affects clean_complete in i40e_napi_poll which in turn determines
>>> whether or not polling mode is entered.
>>>
>>> The purpose of the tracepoint is to determine when/why/how you are entering
>>> polling mode, so if nb_pkts plays a role in that calculation, it's the
>>> right number to output.
>> I suppose the alternative is to only fire the tracepoint when *not* in XDP.
>> Then the changes to the XDP stuff can be dropped and a separate set of
>> tracepoints for XDP can be created in the future.
> Let's be clear that it's the AF_XDP quirk that we have in here that actual
> xmit happens within NAPI polling routine.
>
> Sridhar is right with having xsk_frames as tx_cleaned but you're also
> right that nb_pkts affects napi polling. But then if you look at Rx side
> there is an analogous case with buffer allocation affecting napi polling.

To be correct,  I would suggest 2 out parameters to i40e_clean_xdp_tx_irq()
tx_cleaned and xdp_transmitted.  tx_cleaned should be filled in
with xsk_frames. Add xdp_transmitted as an out parameter to i40e_xmit_zc()
and fill it with nb_pkts.

I am not completely clear on the reasoning behind setting clean_complete
based on number of packets transmitted in case of XDP.


>
>> That might reduce the complexity a bit, and will probably still be pretty
>> useful for people tuning their non-XDP workloads.

This option is fine too.


