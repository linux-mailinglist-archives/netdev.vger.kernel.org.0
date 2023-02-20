Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39A69D0E9
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjBTPt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBTPt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:49:27 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256FAA5E7;
        Mon, 20 Feb 2023 07:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676908166; x=1708444166;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0na25uvLwZtyeINk8R6LRufyx2zhFfnCocBwySb5XUM=;
  b=hvMoUrxA06a3kh6Q3NFcNJT533re64TI0fLk9f7siE/Y+OdvFspXIpvX
   UscH0VQ/LGCU4jxMTpwqAcecldJb/ENcsnRYncKEMc01AbYwaucLS//H/
   pQMhctATyvm66QnRoth11HPo/8OP+fjVI4jhvkQfZ6Icu21DgsgLi2AAY
   AEqI2Hv9TpHhZwKa/PLRf1M5KGYCTC1HQZiXqJuwaClsQpsvCqdwwWPND
   CwwGJihfMRRz9lJqPSMIx+xU10E120rZmL4O3fz+a9V+9/4wBGbq7DEAh
   ai52gSm3QqRgBHBXUaDN3mfWponbAGTNsvA/az6RRpMfyHl+/6iSItBPU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="312060609"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="312060609"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 07:49:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="916897880"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="916897880"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 20 Feb 2023 07:49:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 07:49:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 07:49:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 20 Feb 2023 07:49:24 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 20 Feb 2023 07:49:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/BMDDBDd/8LaZNSJZMyxRSBtQihWpJQMVzubEhMOaoP+3h2aIp0fGLQksUZjqxNb7jN80y2L4UA98VFQgUFkXgiaQZL4+CSwThCN4gvGjxmaWI3SHKDrYAKf2dPhiLYWQGFSRPvMuWuA+JiA7Fm/9wk7mSXRPxlGynk+/Ok1Y+aGrzCYm1GseutRopxr7f/8PvS00XXB03ahuy0RvuNeU2R94Z3zUv40jW127uhtqP+mo3lo9BifFLD57wzcAnDIaCDqfxsmB8J+LoZK9I4By4Dx/cxDRk2RHqzxKUi4XaQi/IXUE09OmZkHgEPLz5RJo+gIQyPvHn/cbQQvhae7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFuEFbYY7Cj8J/lB+LxaJ0PMdYxZKsIjRZSJzbQ0En4=;
 b=aLXMCVp27TV1JBmZ9zLC+JmmvITJDg3dT3pOymCTvgsUOENzJ9Tm5A8U8MqzA0Sy7XzQRpgc4O7vxIh/O4TiaOeIXDDgCDiQeRCdD8+j+4bq3qHlw8UxXJSoadZvpjT3GqdKU1QaUdTpNXEpHSbcCUQmCmm4LyR4fj4DfvkDDTVrRLMkT0wRfS5UwrBAm6aMJScn6D0NDXLg7ac7hC5rSQlDr75TRJYEoOimLMvy2QXxJrNmNpidqpzf84MWuBuKMs1nXHJwYAH7FVgFq89xwjjBNZi16/pOk9bYE4goDrIHoeoo7CYwm3W0pGB7pZTMJIJpxjNCMwS2Nk/jqPj0nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB4942.namprd11.prod.outlook.com (2603:10b6:a03:2ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 15:49:22 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 15:49:22 +0000
Message-ID: <dd4dc3b2-115d-5973-6882-9b9916182a88@intel.com>
Date:   Mon, 20 Feb 2023 16:48:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next v4] bpf, test_run: fix &xdp_frame misplacement
 for LIVE_FRAMES
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20230215185440.4126672-1-aleksander.lobakin@intel.com>
 <cd2fa388-573c-99d7-d199-f588d8d38bd5@linux.dev>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <cd2fa388-573c-99d7-d199-f588d8d38bd5@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0231.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::27) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: eaf4f2b9-cc87-4967-bfe4-08db135a0900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jObeldr2FTtvPw/icC1T3cOkcKO1dAD3F/hnEfvzD3CO7FuPQmofVoS6TR5CXhMBmjy1dI/D1E944oA24LGq2uKiUI61vLTy/vlkEMVl0Ko1XdWh4GXob6z9EYJUN6b2nN2HvMS9I4/cqqvXDyMCLNXiMMOmdeLJHqoDb6WzLwGw6RplkAvRW+EYJaZ7A+uecI7t49DxZMo3Xq1YW227hfN1zoIztjW1hzWUFRbPGzJfqRDApZmNhzMxIXaIErpwfgQsvEQcxBL57YRZHu7CzzVgz9OnhmaifymzGyjZ+XjQsqHmk1ozRCOTJucQXv0vW+sTh9VPNFtqdeqkJFjyWv1YKsaanSinG51uipA0Q6R9cCpIMUDV73VK/u60wZOfMiPsCdKehMmCbLXPnPjBvXHzq32WAf0yqjrteui43Z2uQJV7NxdJogOpYc5cPAO3GbdMf5d9JPbOYMAzeFReKtIsk5Ch+XB7K1Demo2WgrxSvVjxHsirV2EPSKxDQHlpNoiP/izp1JOI5OyVxv5RhNbc0fiB24AaBed1jIDYVkz/Ra5zCm9viAy3sh3WZkNgb2gqbGm6ufLKuOwXEePZYmAlh/+CWUXej20sQqtSFRbYCX3LrRtjnclofxMutQ473o84hdcjg1v//0Omxno6uxvmGUZDO2W65pkYWRSXeg3GAY0MemFb5Mxk0QA+QIi4MUbrV9W2iA+kE+VhYfjqaP7g6OYOajwsTMpEYOUvFGY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199018)(8936002)(2616005)(7416002)(5660300002)(31696002)(4326008)(6916009)(8676002)(86362001)(66476007)(66556008)(66946007)(36756003)(83380400001)(54906003)(316002)(478600001)(966005)(6486002)(41300700001)(186003)(26005)(6512007)(2906002)(38100700002)(31686004)(82960400001)(53546011)(6506007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTR0RkE0Y3JlblQvRjFGOUVUOWljaHpDeXhQM2VpWHY0SXIwVWxoNlpOK2dx?=
 =?utf-8?B?SG9qbmViZ2Q2U3E1UEZVOVNnbUJvV2FyRHgwWVhOckJwcGNPVk8xQzBUdjVp?=
 =?utf-8?B?YmQyYnNsR3REeHNkQnlNbDZkZ3ZtR2NFMUh6Y21KNkJDVDdjN0Z4MmV4a2Zm?=
 =?utf-8?B?T0JTcG1uY1RCSXFUdHNPY0xHY0pwZiswakpPTUp6YktlZ0x1bWpBYVN0Mjlt?=
 =?utf-8?B?NHNKbXBjTllPcFYxWUVkZng4aldWRm5oeGtZUno0TWUzcnYyMGpnNnpLUHRw?=
 =?utf-8?B?VVc1OUJWVjhtOEJXZEYzd25qZ1U1NEhhL0JjbXA1OFRkREJPWGFZTGVMampQ?=
 =?utf-8?B?emduc2Q2U01ybVBDT0k2Wm5pQnBJTHVBL284cUpoTjA1cjdnRW5LUGZEaTdz?=
 =?utf-8?B?UDFpTmMvN1RSNXZoaUt4dzBjY3J4TGlGVjEwVEdDOEdHcHJERklaYnZWSndo?=
 =?utf-8?B?QWpKUHROSkdZL2t1TERQVWtFS2FMQjZ4a1hiVXpNNEhsclVsNzJqUGU2OERy?=
 =?utf-8?B?Q21aVFlzMVR1ZG9TTC9TRnlEbkhreDBHUHhFWmJZUnM5UDZoamFETWp5eE51?=
 =?utf-8?B?aUdqb1RiUm5FUklzV3dTRVBCbUtuRnNudjBYZlRubTF3eEhjQXUxYVFPcitv?=
 =?utf-8?B?b1hyQlpFWElrTEVwT3Bwa2w4ODhEOXBNNWJFK3pnNDk3bW1NTW4xK0JPSmdX?=
 =?utf-8?B?MlN1V0hOZ3d4WFo4Y0hySkhJVTVkYWhNd3BqdlREeXVyM0pCMk54dXEyLzZ5?=
 =?utf-8?B?Ui9vMU5PcHQ0d2g3QzVBdW1iejJKVk1iRUZGNmQvckJjMFVWY3REeExVUWUx?=
 =?utf-8?B?YnlFM2pHVWZZc2NIRk0vKzl5ajZnSVE4UlRBRFI3OGpDWjR4MWlRVHRGNk90?=
 =?utf-8?B?cG9nMStuNzE4aHdML2pIbVpOSDVDams5L2ZId1dUOVN3WWFtcWpXZEhNZ2FK?=
 =?utf-8?B?Y2dTbFpmazlXZVFiUFBIUFFDYUlobUwyblArbWZBODh5QnR1WVVzUWgrZEdL?=
 =?utf-8?B?bXhVWUtBRDNuenNEUmdPNTMzQmZpUUtpVlh3a3IrWWtqS2ViMWF5RHcrTVFj?=
 =?utf-8?B?VHFBNm5JTytGUGJaTFRIR3E4OTBOOTkxTHh0eUhjK2V5a05QNG5zRGUxaGFv?=
 =?utf-8?B?enhzWnFyOHNVbWdURTdoWnBXcVo2UVZheUFRQ0o5RTdwd2YvU1FyZUR5RFpF?=
 =?utf-8?B?SWttN3h3RVhSMFNzR0dubThMVGRGb1N6T0RrMHVSU2dyN241dHU3VjBIVktT?=
 =?utf-8?B?VmNMaldldUxuVXdIdXB4Nm96YXYvNDUvMUVzYkt3QkorbnVTQjl0Wk80M29j?=
 =?utf-8?B?UlNzRlhvdUJXQnptT2lGbDZLNGJ5ZU04SW02aEloVG80eWtqVkpVanlybEZ5?=
 =?utf-8?B?VktoYm05Yi9rYk02RUljS1I2bHY1eFJzdzJwU1BMVGI5UEp3TEt2U2ltbVNL?=
 =?utf-8?B?LzQ0eVZQMGxjS3hNVTFKdTRZUUcwZmFQTmFGV0ViaHQrR0NrY2xVbU5RV2x0?=
 =?utf-8?B?ckk3YjdQQlE4T1FRQVg5UnFtdEFpUnVpMVFUZURId1VMT1plYVhJUHpiNUkw?=
 =?utf-8?B?UG5kcG1Ta0t1VzRaTW5aTGt3NE9vMlpjZU5BZ2Fxd2tURnJxekxna21IU0VC?=
 =?utf-8?B?SnpNblZZckJyOEhvZHZnTExOb3dXYTI4SVdQZ1pWMzBpTnVnR1J6MFRpVmkz?=
 =?utf-8?B?RU9YTE5XY2JBclZkL3hYRkJyME91dDZsOVFqRXowbFhLTFVqdjB5KytHbE01?=
 =?utf-8?B?bStFT291WXFVUHJOR05mQjVXc0NFem01VFV4MUg5L0tNcjdKQTYzYktqdFhx?=
 =?utf-8?B?bXBxWUg5OTBkaFlQRSt1N3dqOEZGeVgxRlhPVS9qelRoRzJ1VHNsZWJsdVZq?=
 =?utf-8?B?Y285SXdMbVZjSEJTWEI4MzRKSkpTS01yT3pTWnhSL0srMzh6TnVHRXp6Umdr?=
 =?utf-8?B?ZEpTR1JpRytkYnRmcWh2STJkOGVjbkxuczhYbVd5MEhtZm5HTlg4a2kyRlk0?=
 =?utf-8?B?Q01jNkxqcGUrcE9EQkU2V2hFNGZlTGNvK2pOb2ExMjFUWnRINkdYcGFXdEZ4?=
 =?utf-8?B?d2VUUUFzTllYUFFtM2xJTE9wQUx1N0ZUZTl2TG1YQlZsY0pJK2t5UFl5WDJS?=
 =?utf-8?B?ajFVZmZubjlCZHNTZUpwTDgybURiaURFWDFHU2l4WC9DSzNoRDVRM2xrTnRs?=
 =?utf-8?Q?Zuwk33VpDty9LJC+Kd+kIII=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf4f2b9-cc87-4967-bfe4-08db135a0900
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 15:49:22.4585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Pnt4jwrNZ0O1PRLBzkw3Zi3Tsuirl7/03cs4AXmYm/QkC7pdk2yBiyTGhFUZHyKditGqLo3P42c4dkUNOclmJMK54/VpPqqrnqs28n3C1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4942
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Kafai Lau <martin.lau@linux.dev>
Date: Fri, 17 Feb 2023 12:32:36 -0800

> On 2/15/23 10:54 AM, Alexander Lobakin wrote:
>> +#if BITS_PER_LONG == 64 && PAGE_SIZE == SZ_4K
>> +/*
>> tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c:%MAX_PKT_SIZE
>> + * must be updated accordingly when any of these changes, otherwise BPF
>> + * selftests will fail.
>> + */
>> +#ifdef __s390x__
>> +#define TEST_MAX_PKT_SIZE 3216
>> +#else
>> +#define TEST_MAX_PKT_SIZE 3408
> 
> I have to revert this patch for now. It is not right to assume cache
> line size:

Userspace part tries to guess it :D Anyway, let's keep as it was for now.
Sent v5 without the static assertion, I hope it can still hit current
cycle? Or too late already?

> https://lore.kernel.org/bpf/50c35055-afa9-d01e-9a05-ea5351280e4f@intel.com/
> 
> Please resubmit and consider if this static_assert is really needed in
> the kernel test_run.c.
> 
>> +#endif
>> +static_assert(SKB_WITH_OVERHEAD(TEST_XDP_FRAME_SIZE -
>> XDP_PACKET_HEADROOM) ==
>> +          TEST_MAX_PKT_SIZE);
>> +#endif
> 

Thanks,
Olek
