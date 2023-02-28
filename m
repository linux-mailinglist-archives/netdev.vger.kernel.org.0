Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1089B6A5D21
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjB1QaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB1QaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:30:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3A493D3
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677601806; x=1709137806;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uY7zEnxCI5+PZhca9wVghvbqqevAwSLFQ8rgEcQZp48=;
  b=MoJQOrUQjNPZtkJA4kJ67oKRADTyRyi1Ee4Ws4hLC2N0D+Cj3KBIU5PR
   GQgCCj0EGlYGE9o3CZK20LJg3OQG/c8XyFc+VlbXtn8OQSakMoyUXeYAm
   wMwjmk4tSM+PGmqIcJmwIvvnSfyV1AYqADKqhssapsVX+MZzlwSBf3cJr
   zNH9smdX2f1RQSYIHakwvF2/cvhsBsWfgJDD8DRhaDniHwzljnkdvpWo5
   Pp4ncQ9SH/fyCsI0LO7ZZDvA4Ao/KNQH3uLQbL8FtHUGTYpSUHCXVcnaA
   cCEuOsuPFvs5Gmx6A3RnTG+vkY8H0GpdKuX1Z5WttPXLa9NQHZrfD1Xs5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="335670904"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="335670904"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="667516564"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="667516564"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2023 08:29:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 08:29:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 08:29:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 08:29:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnsCiSSImjX/CUNOv27BxhcD1FFI7QairqllEWuyZ28L7cXA0ILz5XKbAq2ExpUmj1db4tKt7GWN0B96MSxdETT2w+/awJc/8XOkjKmQEqJOr6SyLWsqvG2TR+rLvUj5p5zFUd4340nPPwnhCBcxZSXjvIbmAi0TcizPPVNA95Vt0Sgl8Gb7VWfn4U+VTkbFpdF5swpnnX9IAMuojLWcJodRW7MOjkN3IksXr/enK8jVqC5Nwqdp/tsVkFnoGtJaskF2q+6hlcjR9nm6IRTj0vmzSkog+K/bnXsSLKG+H4Gfg/PV3fmvgiBY47YvVyQMkT44kBPYBo4xzRvlcaSsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KioS9+wDS08fB/y1oKn3L0aZqTUuqEKIA2j43a5+5Qg=;
 b=B6wDH6AF7jre2XFWmAyw24AocQ5GZp86HulEL4EZEwKaaoZRO9Q5KpfP5ZOLILBHhblX6HfkrAe2j71dPmFsUH8ol/9wnlMNry/9LjQO/uLTzkhkoGtZ9JkNbRAncXod+GF9IVIyviAfB8vNuUxMbUJzNXDK9qaielh5AfuQWEPF34uRriKarvMxud2hXgyXbRMLcx258DAMCet3dfxlnnM1GEs13EXSUSctf1YT9Lv0Mh34RXwPwyrBvjRPI97WZ/S3635A4b06vfT3JMfWFrv5ll8o715WrEcI12X7kYl39EAPcqR/O1H2pzf+c4SfSspWsk/URo3qnFB2bxlTyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB6611.namprd11.prod.outlook.com (2603:10b6:510:1ce::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Tue, 28 Feb
 2023 16:29:45 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 16:29:45 +0000
Message-ID: <0650079e-2cc1-626b-ac04-2230b41fd842@intel.com>
Date:   Tue, 28 Feb 2023 17:28:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
CC:     <edumazet@google.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <shakeelb@google.com>,
        <soheil@google.com>
References: <20230224184606.7101-1-fw@strlen.de>
 <20230227152741.4a53634b@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230227152741.4a53634b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0058.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::22) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB6611:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d2c2f7f-316d-463c-c2d6-08db19a90008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WwfBi245RpDBTp2wigiYJ04gfbtxAxbOnv68pPyTm9Y69GrDpFJXbpfah1gudYdIBnAvlCwNamc9l+wZQV4jluxOVQ6RgP6fX/R0XgqgL0lkoVhJaonXzdFtMq7puCyZeL/vslIaiyRs8tBOacQHK/pSPH5fXtPpxBAZksB7mkEoLj9lux/9iPlmn+3/ehNr73uaUTUgtUqL1uVSs6qRqJ6U/1iUi/3PDdrGVSG1pp/8N25zPvoO7Vgi19EJ2dFiWCAqNB0YCuOhbB09uLxrjYjavQ1lIzqXp30GM3kYnQN4j2I5wLhvHLTmvqbpG25awycWfgRhB5Y8v/kaqcV97Ogb58qB8ei4dIIg4MGJS2Ey51p9LBExsyU13WLwnB3X/KphSa7VVP1K96sp6uWCvsakVV7USvatnMMyfm5/WgH6i3qYTFJN6KwUZ/CGndhVEC1yiwFOfaUCr8NoFeFqFzvuUwTTFdFHlaCM8ZgJrWz2kLPptNOjbPvAcon//y1CYW6jVmur+anfcqnTrw5SY66P9Lv6kpZkWXppqXJtwLSvkT0QWTvIcoiq4Z58yMhoh3tw9vtjE0Ze0y0BbEvWfYyw6lDAOCFMYJzCeVV9vLuAygfhF0YQ771qblEcOZX4VmQAFWJfHMzzaG9pFM08PR082f+0JUzX7Y3eB0wr5BkQhljoTecxw4pCbIaXe4GlWVqkEgmlEG7pdwBDwWKnAjQAe7ryFe6Ki0l/IlXRUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199018)(82960400001)(6666004)(2906002)(6506007)(6512007)(38100700002)(31686004)(6486002)(83380400001)(5660300002)(41300700001)(26005)(186003)(478600001)(8936002)(110136005)(8676002)(2616005)(36756003)(66946007)(66476007)(316002)(66556008)(31696002)(4326008)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE90NHJyOXhCb0hRdFcvdnBaRGViTC9td1d2elNmTU5VMWY4K0VNNVpycHpG?=
 =?utf-8?B?aW5KSnIvdzUyOXp1WGtLV0hSbmtkZUV4WnlQV1VDUVB0eWFOMUtHY3JkVndZ?=
 =?utf-8?B?Q3pvaVRYOVVrbDluMndVczZYWS92cG5paURpTVhTdC80ZWhYMkQ3SmVCeTUw?=
 =?utf-8?B?cDJpZ3JLdm95VnpOMks1L0QrNlNaS3ZYcUVGSGh4V2EzRVFaOTllRktjMkNs?=
 =?utf-8?B?WVNKZHVSZnZRZ0lFZ0hRZUtQSTZKTHJ1aTVDR1ZrMzg3WFVydnEwSE84QWRF?=
 =?utf-8?B?bmZBV0tHejUrSWw1WWlVSTFrRE1OZVMrUE5ialI1dmt3Q0FxamczUlFKQURu?=
 =?utf-8?B?VDhpblh6eEtITnpLMjVTRnRTNUx6QTVsV0RtRUFKN2Uvbysva1Y3N1A5Qytv?=
 =?utf-8?B?RVpRVlA1VXVCckM4SHpiZGc3NVlaREp1K1NESG9jeEpqRmdla2VrWlI1N3FN?=
 =?utf-8?B?Z2pwckFxNUVxTk1GSTBDZmM0Mmcxb0pneWNIeWErMFZRczBhd0RCb253czZw?=
 =?utf-8?B?aEw2RDd0dUExTHBMYUZzTC9yNUVIV0VNWmJXOGx0bUV0RVZHWEdGKzdtMkph?=
 =?utf-8?B?ZWgvMlZ2VVJHN2xEcVBVNkl1WXBDKzRmY1NzZnhoZWRxNGs2YW5vdkxYaGNY?=
 =?utf-8?B?aHF3aEYzU0loNXZ1N3pXa3FxTVdIZ3hsMHc3Uk11cmNpaVZySitnb2Flc2ds?=
 =?utf-8?B?SXVONFRoM0hoeWhOaXg5aDR2eGtJcWtzeThBL2NLd0JOdS80UjM2djI3VkNH?=
 =?utf-8?B?UGxoYmMyQmZPMjMyRHl6VnRBdDBIOXpEbExjdjBiRkhHOHNLVkJIbjFWVldv?=
 =?utf-8?B?VWczcDZudG5yS2NHTkYzSlU0QndSMGwzUmMwSXdnR3UwckRmcTF0K081NG9N?=
 =?utf-8?B?WHpiU3h3VTV0RGNZZVJOWGg0VURFL1kyekpRYytabzQ4Z2I0bUtGQXdodFJp?=
 =?utf-8?B?cGQ0S29ZMDR4UjFHTGtBaDdid2RJcEQ2ZlVKMUtqaFRVaHh5cnpvZ2N6eU9K?=
 =?utf-8?B?dzBJZFpHWGRpQ1lmWEdJUEZCZnpSMUljMjFpT1Nva3JFak40SzNNeGQ0bnlh?=
 =?utf-8?B?WkY4bFNrSGFDcjRsNTlUK0t4NnJITjhVUzNYRkJ2RWgrTktLQVA3clVyQTJB?=
 =?utf-8?B?ZDVmU3I1b3VxNDBQN0QvOWluL0RpRDVTdXQycjhSQ0QrQjJpNGthS0sra0Iv?=
 =?utf-8?B?Y2hiVzl2YlVnYU9IeWVpNVhNdVBSNklsMHI1LytrUjJwNUMwNXg4S1FjeFo1?=
 =?utf-8?B?cXVMY20yUFB1OHZ5YUhiQ2k3WFI3SXpGRUFqRXlvdzA3RFA2KzBtYTN2VjVt?=
 =?utf-8?B?bTlZK2RjeHowZFA1R09wbHptTyt4UXd3N1ZRU0VEbmZZWE5oQTZhZUVSL0Ju?=
 =?utf-8?B?UnkxN084SnBJOXcxNVEzeDhSNVo0YkFXR2g5ZnBIbUtiSllYUEgzTnRCY0RR?=
 =?utf-8?B?aXV2V2hYNWd6RStJU29pWXVlK25CVlFabFk2TWJHWDU0REZ0cE5yYWhkRVBy?=
 =?utf-8?B?NkpYR1R5SmIrRDNKUHFVZFZqM1VjZHhDQllmaGJzYnI0TVZRdFp6K0VUVTNW?=
 =?utf-8?B?NUxrY0dPRTVDdzJweXVlUitSYngxZ1VSUGl5OW5JSjdMcytsSDBBazRiS2F2?=
 =?utf-8?B?NWdOek91N0p2eWVSK3JYZ3FpcnR6L29ZOEFXeE5ockt5d0d3bkhSSTRLUWVa?=
 =?utf-8?B?WUJjdlJoa3BTaGdWQ1hKUStEemU1SFNzWi9DdzlsN2pDSllSbVByVWlsRlpa?=
 =?utf-8?B?NEowVEN5c0RPZmpRcStaU3d3S2U4ekFuUnV0UzNvR1crNEd5L0d3N3RWMTNh?=
 =?utf-8?B?T2JEVHVxR2kxWDA3RVJrUjJGS28zeWRrQWY4YnlnMEhBcnZpMC9KK1E1cGp0?=
 =?utf-8?B?U1BVOEt0MkorZnZySmsvamtBMUlWOFNEOGllMk1yREhrTzRDMVplV096Umx6?=
 =?utf-8?B?dlR2VWIxc3ZtN0RpeFlOUWlPUTNaRHFhWm5hcDdnN0g1cmdOZWlvU1poeWhw?=
 =?utf-8?B?aG52cWVOSTM3OWpBNmF6djR2UlRPK2hwb09RYUJ1RnRBbnVSU2ttUU0xMytC?=
 =?utf-8?B?blBKYzRUb1FFZytIdFFodG84SnVWZ2N4clZxVkg2UW4zalE4RmxGY0Z2STBN?=
 =?utf-8?B?YzhPeEU5SWVobDI4Q2haUFJPNGk0SEhpWEN3dCtObTJvN3c4NFBueDg2MElO?=
 =?utf-8?Q?1BM2MCQsnQMyJUeGWpTROn4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2c2f7f-316d-463c-c2d6-08db19a90008
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 16:29:44.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXzwN3vw97wlETPL6HRFHyQvhAmJKkZHjreDUOS/g542Cuc8SJDMdcJdWFo+kd3OqeMR+ZYmOH2cwxpAoNx1YSSGE3B+Fzn8GVdBH1YJucE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6611
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

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 27 Feb 2023 15:27:41 -0800

> On Fri, 24 Feb 2023 19:46:06 +0100 Florian Westphal wrote:
>> There is a noticeable tcp performance regression (loopback or cross-netns),
>> seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.
>>
>> With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
>> memory pressure happen much more often. For TCP indirect calls are
>> used.
>>
>> We can't remove the if-set-return short-circuit check in
>> tcp_enter_memory_pressure because there are callers other than
>> sk_enter_memory_pressure.  Doing a check in the sk wrapper too
>> reduces the indirect calls enough to recover some performance.
>>
>> Before,
>> 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver
>>
>> After:
>> 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver
>>
>> "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
>>
>> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
>> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Looks acceptable, Eric?
> 
I'm no Eric, but I'd only change this:

+	if (!memory_pressure || READ_ONCE(*memory_pressure) == 0)

to

+	if (!memory_pressure || !READ_ONCE(*memory_pressure))

:p

The perf boost looks gross, love that *_*

Thanks,
Olek
