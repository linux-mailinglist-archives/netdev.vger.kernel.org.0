Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE84697F10
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBOPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjBOPDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:03:11 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306F639B93;
        Wed, 15 Feb 2023 07:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676473388; x=1708009388;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+uzN6Fz/4Yr68KR7T50IKDQyyU7tqw/vrMYoWm4kxYw=;
  b=mCHn+q8zVeFl1xmh9BUWOWE03BQ5k0o5inavYWGGXpZI8BY1F1/vvTAo
   kCN0tquR+M3ICsds7701fzcDBwapsnPZmwI762OGJ0fvFxAGmDRPUt3Ws
   4Cn7LAEyXWxaVqQy6Tw0key1PMLbBpcg1yciuvaMNU8N6Yg8A9OVyeNIz
   QmXHKt0NOqF29xpSQJNA+xDxtPpuEIx+OGeemE4c48EsCf6KyzJK6LH5F
   NLpM0t48xS6D3b/f4opKQ1WjdVwzvMfvYIxU0A2CgefbyZtcqYqY6D5bY
   YcPjmbicmxkrMjJ2XcxgpoLOhtqx4DFcO9csXBY+ZI1A7taLNlUsfGzWo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358870795"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="358870795"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:02:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733316139"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="733316139"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2023 07:02:56 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:02:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 07:02:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 07:02:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADacVc2K3f4QMvPW7uiuIKzCWUh4OqZCBiAyx7zWN1b4rKe8dX7Lsjphk+3kpJwuzplH+D2a1HfVFlFGqpTk5BqEB3ADAFhriGu6xRel++7rAW94aaF3dRmAcQhi8JbNjbrWayspLpKkIFWgCR1Dcor/L5Kmldg2ksE6UG/o47wMDcTnco2/V3vnirNgQNtc551C4e+I054PqhMk1CvYkaIW8Sol7rJx0pCKvn2OGue9fIEpToJTW3/4p68/FKTqlvQNuQNi+zj1eaEEJWBMM8bpDcn/TA/ZzRPFdKyImwwiNgZiQSuQMKYa0f/6mX5ThoBPt31tu8B6d92AH//Dkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsVTFosFo8/p0VhzVwBEk54mQZcy0cLIa4YmtS6/VB8=;
 b=O9R6+eTOesA/rJ2dDDvB8pRXEb9Lv6100/lvdoR+R0680NQd+WM3fJ4b/MlDQNWU9YQ8fNWzXT7dLtiknaWZVpQtIuqxsdYN2KmCgOKl0bXatNgx3JkL3A6ApsF6s6aX9e34rLRm0GXawE4BUktlzeFk/fFI/TU9NYqopSZBhUEdsFgAJmgH3FHthqGtZxBqwwlOnkSHGOgwSLLCxaBFuNrsVeIG1WtfM4gAr0AfkNdWTKV7WF7q7r4VjPdMnBkdwrLzsMlf+fbpxHR4zqlEL0gmHM4URYhynmY/b3SzOmLsXAWQbc85s9TOJVmvudRMKBgzeu62IbnDHavXFMdP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB5944.namprd11.prod.outlook.com (2603:10b6:510:124::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 15:02:49 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 15:02:48 +0000
Message-ID: <b48b96ca-2387-ee01-f45f-2bf0ffc82a7c@intel.com>
Date:   Wed, 15 Feb 2023 16:01:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH v2 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
 <8fffeae7-06a7-158e-e494-c17f4fdc689f@iogearbox.net>
 <6823f918-7b6c-7349-abb7-7bfb5c7600c2@intel.com>
 <e62296a6-7016-c98a-8419-69428f65d9cc@intel.com> <87bklwt0tl.fsf@toke.dk>
Content-Language: en-US
In-Reply-To: <87bklwt0tl.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0210.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f86304-c408-43e3-7b17-08db0f65b3c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eJu7MpcyO0wfzthGs7dNam5dKFkTetaGwWdu9emiiDV9hPFHiCvyrD6ZDGWxs6FVpHq0TyfhUdxFck3UZzdBDSbP+z5UAKpjbFgfNQnQNrGIvLMYO6lLgTSd2zmjFACNqviGWaijywek2PZtfF9DhyNfkRWCXbIkJxA9TMZxGeTwOaD+tMfIr8kYp0OMlMur0uyLhQ/Og9kI7MkfFtesvVTBsEbP8BxACmRHSdHmCBfkcYeweqjtoyK9DxRaRTj6oGH8u4hd5wGGyZyssLh7zCk10eJmwVXmCl8oVbmeprrCKpbVTb6Ee7H+TCtu12tkMea70z7rxmR+1oc1Ckkqgiweuc6aKekNFnOpBuuQnVFgBAzRy2tAdsIdg6n5mtW5fzMQFzFoa75YBPgKWAFgPNbC2okJ3M8zx0NZdk1grGFb/I9J4zwYOSxQRBYqOL5b3C382SglNkxgXfu4nkMxhEFDzQBqeRBofTASuGEu+7KH+c2MxxOKgwPVMwB1Ke5fqmq9fW4Q6W+jYNAcnGDdNkBunrCLXBxUNOo2ywApMNDA6lvWg6pUn+wsmOCUbxDrg9LAoxU+LME0DJnQmhwqPbTUZHjkAjFQ856lJfEik10luZG+YJXbbYlX6CpwdPhespgVET7JLSIsmLiqOvjpDnKKV/j9p9xl4ZTxqQUi2eNgYl3vILumewLWc2YbX21xqoYBJoCNU1VMPEB9plQj375yFnyRbxeKvWmw28DNoj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199018)(82960400001)(38100700002)(31696002)(36756003)(86362001)(316002)(478600001)(66946007)(6486002)(66476007)(41300700001)(66574015)(8676002)(4326008)(6916009)(966005)(66556008)(31686004)(6512007)(54906003)(186003)(2906002)(2616005)(6666004)(26005)(6506007)(8936002)(83380400001)(7416002)(53546011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1ZObTBDRlU0aW9GYkRxOHB4VzNSMmZZOUZxYjNFdWM2N1p3c2pyNEo3Njl2?=
 =?utf-8?B?ZllHbGRFUWk1cVlJS1hNVlorK1o5QkRKTDZkZ0tMMko2RUhGYmszZWlkUjk5?=
 =?utf-8?B?Wnp3c2Q2UGc0OHJuR25ZclNnaFh4cDZNRGtabWZDVjB4a1ZDTU1Wc0ova09G?=
 =?utf-8?B?UEZHYXlZamRrQXJqbTA5WjZEUGJaL3JEeUNWNTFSbTc0ZkJBc3pGTUo0cjQx?=
 =?utf-8?B?NmV6eXM5VDBLeWpWVkg2S2paUWZLMGJmTlF0UDRrakREbUl3THBndURTazRp?=
 =?utf-8?B?VFhVaVoxa3FsK3ZiQzJMMG1MNGJUZ29idFc2U0NXeDdwOW85N0xFckxVbXZo?=
 =?utf-8?B?MzBPSlhYenpjQ0YyNC9HUnVBTlVkSWNKR0cxeXFuejlxRTdhdGVmelRBMHA2?=
 =?utf-8?B?VmttQnBZdVdaRS84bUZGNUJCWEdBemNDTXFCMkZYMDBITTJzUTBKemR5dnNL?=
 =?utf-8?B?UXQ2OGR5azhMSkVLeW4rOC9xOWJaTXBJVHQ5TnlOZ1ZDTUErRThZNmFQNng3?=
 =?utf-8?B?dE0zVFpLemY5VWV2Zk5wSUw3cm4yMko1U0NuRGx3SzRzMUc2YVFMeDRPd2dP?=
 =?utf-8?B?QmdxdnBYMzlBS1hHZzI0QlpMeHZLbTRZcHg1cWNXaUd5ZnJHOXczb2tlbEh4?=
 =?utf-8?B?L0VUbk9sUWNtdnRabFB3L3FISEYwYmo3aGlyWWJDS0lmR094eXNyNFBqUEkr?=
 =?utf-8?B?K0pqNUkzMm1WMWtiaXlPWksxS3lsMlg2WWljckhSV3pNV2JSYVprQ2EwT05w?=
 =?utf-8?B?eDkydFFvellmNkJ3R1ZQbm00SXJlMEhWS0dKTG9GcEhDUDlRRHZ0MytyMzQ1?=
 =?utf-8?B?dU03elNzam1EYTl5NnQzYTdvRS9jMjZkcmhpR0JTQlRZVmdyZVBpNkxaMnFT?=
 =?utf-8?B?Y09CY3diYUhkMEZOWHM4MTU3eFZGZWU3S1JvUjEvWkgyYlhJZUlMdVh6WWw3?=
 =?utf-8?B?Y0JqUi9sU1ltU3EvTVFCbktZWkx1UkwwbjRONCtoa1h4YVgreSsyZlNMVHdp?=
 =?utf-8?B?emZqb092RWM0aHo4NWoxc0J2NEt6THdBa21WMDVUM00vVjNwVHdudnJrYmd5?=
 =?utf-8?B?Vjd1Ry91clgzK3FQSWRkc0IwdTNQbHdTazl5UEpmOEtrR1dyc2h5ZVhsbkU2?=
 =?utf-8?B?dHZmblBaVDAxZ0tkZ20rS0Q4c2NmN2R5UVJ3NEhrSEp1Zml1ZTFNZFVSWEk2?=
 =?utf-8?B?eFZxeHBkMExWbXZTdkhqdFZBdHl6cFFyYUlUOTNjWS80QW9nUWFGMExCUFds?=
 =?utf-8?B?QzdSblMxazB0SWpLZ1BRbHVISWVBTXAwMFpOZ0lnVDVNUkpadDExMFlvcVNu?=
 =?utf-8?B?cmdCb0k1ajNBOTQ4aHZFL1lXNGFERUFEQkUvcU80bHYwTUJHcE9IM1NtMXFr?=
 =?utf-8?B?RHJ3a24xdWlCZCtZT1FTb2VobVVqYkJxdkdoUHF0bmFnbXRvMkl6WEpNT1lY?=
 =?utf-8?B?eENMaTluV1FqVDZva3pQTjh1Y1lqOUNXOERtZEJBdkxZUHZzTjZkZU9waDZk?=
 =?utf-8?B?cnVXS0g2aGZoaHZaZnZIWlZNT1kvR1ZlK01YQnN1YnNUZFpXWndBVGZreWYy?=
 =?utf-8?B?SE1oZmNqOTJyUDZBb2R0T3JDaEhHaUpWS2FYNGpxU1pReXFOQ3RZVzRieDFm?=
 =?utf-8?B?a0pPa3VCTnNJd0YvcG1YemhkaFROd0pEWUpNbVA3c1VSdmtzSkg2c2FpQlI0?=
 =?utf-8?B?ZlNXb2Fwbk5VZ1pBUG15SzZQMXhITStmUncxWXh2MzlQelpXYjlVTFNackFL?=
 =?utf-8?B?NE9iK1c1K0RSYWxOK0txNkZ3eXo1ZG9kL29OSEZIajQvUUVsT1dpaHBPUllm?=
 =?utf-8?B?dWNiTjh1WWk1aE02VnpPSWE5dmVtYVVVUFdNRkNqYXZQay9xRFV5SFhuRzE5?=
 =?utf-8?B?ZnBBbld3SnV1dCsvTHdFeHlNSlJvWkJweVZQaFk0aE10aWtmYlZpd1kvV0hk?=
 =?utf-8?B?a0FZNkphZFV5SnRMWHV6c0tiVXZEbXkxUG9hZ2pleFZuUFJjUDFGU2ZsMVJQ?=
 =?utf-8?B?cEZHZlNRK2VrUzVzKzlEQlJXMmhSdDQ2c2xOU3BocktiZm5TVHRQOExnQUpt?=
 =?utf-8?B?SkR6L3pNSERoL3BZVzJEMStrVkMxL2ZaY3phVENpNGlzS3lpaVNmS053R0lz?=
 =?utf-8?B?bVJEK0FkM0lYM1ZpUUhLWVBDaUM1anV6VVBBQndqNG1TREZmd1NlclpsZmt1?=
 =?utf-8?Q?fJSqzgv4shwsC+x6S3radPg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f86304-c408-43e3-7b17-08db0f65b3c9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:02:48.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nykYBJC3hEaK4kcOhvA4UpfaqRJV8PnvCXxkpSSBrai2JttN7DBeCeYpJR+D/zSz3n9biB7tTC5ml3zqgdamr67FCPpe0LfSdCnTQTjL5p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Tue, 14 Feb 2023 22:05:26 +0100

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Date: Tue, 14 Feb 2023 16:39:25 +0100
>>
>>> From: Daniel Borkmann <daniel@iogearbox.net>
>>> Date: Tue, 14 Feb 2023 16:24:10 +0100
>>>
>>>> On 2/13/23 3:27 PM, Alexander Lobakin wrote:
>>
>> [...]
>>
>>>>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in
>>>>> BPF_PROG_RUN")
>>>>> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>
>>>> Could you double check BPF CI? Looks like a number of XDP related tests
>>>> are failing on your patch which I'm not seeing on other patches where runs
>>>> are green, for example test_progs on several archs report the below:
>>>>
>>>> https://github.com/kernel-patches/bpf/actions/runs/4164593416/jobs/7207290499
>>>>
>>>>   [...]
>>>>   test_xdp_do_redirect:PASS:prog_run 0 nsec
>>>>   test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>>>>   test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>>>>   test_xdp_do_redirect:PASS:pkt_count_tc 0 nsec
>>>>   test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>>>>   test_max_pkt_size:FAIL:prog_run_too_big unexpected prog_run_too_big:
>>>> actual -28 != expected -22
>>>>   close_netns:PASS:setns 0 nsec
>>>>   #275     xdp_do_redirect:FAIL
>>>>   Summary: 273/1581 PASSED, 21 SKIPPED, 2 FAILED
>>> Ah I see. xdp_do_redirect.c test defines:
>>>
>>> /* The maximum permissible size is: PAGE_SIZE -
>>>  * sizeof(struct xdp_page_head) - sizeof(struct skb_shared_info) -
>>>  * XDP_PACKET_HEADROOM = 3368 bytes
>>>  */
>>> #define MAX_PKT_SIZE 3368
>>>
>>> This needs to be updated as it now became bigger. The test checks that
>>> this size passes and size + 1 fails, but now it doesn't.
>>> Will send v3 in a couple minutes.
>>
>> Problem :s
>>
>> This 3368/3408 assumes %L1_CACHE_BYTES is 64 and we're running on a
>> 64-bit arch. For 32 bits the value will be bigger, also for cachelines
>> bigger than 64 it will be smaller (skb_shared_info has to be aligned).
>> Given that selftests are generic / arch-independent, how to approach
>> this? I added a static_assert() to test_run.c to make sure this value
>> is in sync to not run into the same problem in future, but then realized
>> it will fail on a number of architectures.
>>
>> My first thought was to hardcode the worst-case value (64 bit, cacheline
>> is 128) in test_run.c for every architecture, but there might be more
>> elegant ways.
> 
> The 32/64 bit split should be straight-forward to handle for the head;
> an xdp_buff is 6*sizeof(void)+8 bytes long, and xdp_page_head is just
> two of those after this patch. The skb_shared_info size is a bit harder;
> do we have the alignment / size macros available to userspace somewhere?
> 
> Hmm, the selftests generate a vmlinux.h file which would have the
> structure definitions; maybe something could be generated from that? Not
> straight-forward to include it in a userspace application, though.
> 
> Otherwise, does anyone run the selftests on architectures that don't
> have a 64-byte cache-line size? Or even on 32-bit arches? We don't
> handle larger page sizes either...

I believe nobody does that :D Everyone just use x86_64 and ARM64 with 4k
pages.

I think for this particular patch we can just change 3368 to 3408
without trying to assert it in the kernel code. And later I'll
brainstorm this :D

> 
> -Toke
> 
Thanks,
Olek
