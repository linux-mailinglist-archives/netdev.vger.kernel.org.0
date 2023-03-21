Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288BC6C3810
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCURTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCURTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:19:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CAA1ABE2;
        Tue, 21 Mar 2023 10:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679419171; x=1710955171;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+pbxC+Nch8Qq6o8L0fZvehtK5oCNg/DH2mV9XiR6s6A=;
  b=VkUdv+ZvrDGrhZH3U4SVMjppSVtooxV2GBmny0Xto7M+qcm1VpPPiQhg
   phc1A2kJBDzo75+/n2pBqfyvL2GEvCp1MPSNaTHlGYiSlaIgZMuU5ieko
   wMhHkO8COXAEnyR1SBIuUbe17zJ+forX8esUg0IHLxPmL1+ACiRClOKbp
   R/cHnhlXtxZS8kV+Qdf5OhswIrJyEybkyO3I/mev7YT9GZLIvXwU5dSl+
   0uPdFaVg8s7G75rp47O1isoXLzYyYIVy2DnBQyV/WXbLdCHlc6D4Z5YHk
   wSJJt69ERTEj86KnxDZ5Fgo0Q7vNQKAcELlJe2fS9YHsDgLget6cOQ/b0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="425293574"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="425293574"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 10:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="714078455"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="714078455"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 21 Mar 2023 10:19:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 10:19:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 10:19:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 10:18:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx5pWrXmWfEZG2UcIVs+Xmq8nKObH4VRKQ+uoTwjriPQv4r6JaUjwZPCsRRVXlI14pCNnw4TbOgqW6rlO2hIsZT2bVZ3MZnoMGiVmOfM78WOzCoc68Q5UAygtY8G9MbnZqUU5uD4PkdHA9xLXdb8aVRwZfOCKtv/gwsOKpVaQZRpUtRA1nmQocuw+07vgSHqI+pDK5bnSh+l/BHdw9lXJxvAwnpCMrJJ+gzdonfHspalp6LijZ4f6XYfROPeSvwTmxdunxNBCd3Dc0B/2RI4eH5pMUHMTWHXkQY5C1KyEmPrB7FqXKig6DxXYyol025RrTtoGI/zoYSBZJZ0ETYgxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgFEFMIOfan3CF/8RtwDgO9r5bOMFIF66VBeoUEN1ho=;
 b=VPVTSbHJw1P3xVXEveqqOJ2tPX53K+J3FIOBPiCH+AGBsWVJ/NYc+HiMgg2dn/7MnK+TZgqpzxUfi6nnDutlx1NsoI4CXfuqFwpRlt9FuzLbF3sLag8tj+0HkbldSVcsZ9oDIRxYxb22mhXbT5o4lgciZ5W7lBn5AJ1ajAwesgm3PQO3/sWvDkRmz1+KDj0uje61uBrlaFtSmPKE0Zv4GTHMGT1D2ia0Ybp2ogjwbplcHeqsjp2PVYsSlF4x68yihlnAoqFOhBZAnMltablzt0mDAxnpafB+BC4iJag9f4v/YPMY71MIKW0ziQc2iLTKYQFjaqPwHfVXxzUbD7y75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW4PR11MB6665.namprd11.prod.outlook.com (2603:10b6:303:1ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 17:18:57 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 17:18:57 +0000
Message-ID: <b06df26a-2db7-ad8f-23ff-85a8f812a16f@intel.com>
Date:   Tue, 21 Mar 2023 10:18:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <corbet@lwn.net>, <jesse.brandeburg@intel.com>,
        <pisa@cmp.felk.cvut.cz>, <mkl@pengutronix.de>,
        <linux-doc@vger.kernel.org>, <f.fainelli@gmail.com>,
        <stephen@networkplumber.org>
References: <20230321050334.1036870-1-kuba@kernel.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230321050334.1036870-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|MW4PR11MB6665:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b9856d3-2194-4970-8af0-08db2a305ac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOQVYLVD9MIA8FArOXSfbgGIFQ+/PebiO3fq/0LHhvMAueSn2wQaRC5AkS88ffTNmDAv6C4tfW8dEQe6CAkSKJjePDSh7olDa4seKKpWp/9qcOMOjGrhSMAxEYgbJRWGyxhmxfZk0UGNTfSob/GYgBLtFClCoEWtN7fiMLpzFY+B9ImvRYyZxFOWxhZ9J+yFb/pJowa0NKH3KrPJW1k/bqkSysm2F0WitZV0yP9o0F+pzFzjI0e9Uwo7h2BKl6Y+SiAVFwikxKHFJl5TxruVZdGz+RJ96cjMj9jkNMbQja3rReYBOJUYSPkeAUeGdwj0dcPUcaH99n75cfXfvKRX+MAoQvRkK2Saf4yQbMjN3erG9Umq1U2jmtIZW5MvaC6/cGOdZ/4E8IrS8VL1kswbHOd+fx7+9AhwFWpXHCLabMxQfSgHNtM7D2HGiqth7hO+MOXjytRzkRln1kqVKffeWQb14tVIZ+5X6AXU4CXdegN+EBLlWfIjR+zKl8+1kBgXaDTdek0ezkopqj+xFfYrS60dxIWMnjH2q6AKnjqGDsgZWmAzghlBDNfr6Md4HB81QB/Rb+/xgG1UATeK/jTQwJfLhbhBbRu3wnhM1yccgNsrluhF2U66xzmdP+zNpuLlRZI5oRlg87QHIVdbelyc/lQ7FNFuA8S5ljg0x02fthpGcUBpxQpuzU6JOlgo/QMIrO7+ba7SpYEckx0d6zoH2N74rXNlxj6T9A4glWQjMM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199018)(41300700001)(8936002)(4326008)(66946007)(66556008)(8676002)(66476007)(38100700002)(86362001)(2906002)(31696002)(36756003)(5660300002)(7416002)(82960400001)(31686004)(6486002)(966005)(186003)(6506007)(6512007)(26005)(53546011)(6666004)(316002)(478600001)(54906003)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUtWZDRpS01iU3dCd2dIaFh5bGJJdWl4amdkMHdIUVNGWmZBTW1kWldjM2xE?=
 =?utf-8?B?YzJic1haWEo3bVNNcnE5SE9ZQTVZZlU0bXZ4UzFPNksrUk5EOHc3VVJFT3lX?=
 =?utf-8?B?U0RCVGp1S0tsSTBJY1FyK2ZwWkhyejZCWnljSXUySmJ5cGc3ZkRTU3JsYzVX?=
 =?utf-8?B?R2dtOStBenRQQnlmOE1iSmJKUE8ydHlRaXY0OWRvRHpob1VpZEZQWXZkS0xM?=
 =?utf-8?B?SDFqenlQSUZXQUNRVXh3a2lJWFJhcW9HVXBJVS9yTDBDamhZRExneWpUekp0?=
 =?utf-8?B?UlNudUVSKzY3MjlaODRUK0ViUlozUmFtRUEwVkwyU1p5bGJiejdXUmdpTitO?=
 =?utf-8?B?L3doUkZ1ZHJ0NTM2NWYraFBIcXo1REQ3ZkM4dC9kUWFiS0s5WE9weXVJaUJx?=
 =?utf-8?B?bTRmNWVoSGU4d3JxK3R0WXcrMG1XSmoxRGNoMDNXemdhNDI5V3JleSt2dHhq?=
 =?utf-8?B?TmI3NnBsNEk3alBDSUlsVDFhV0JaZlRDM3lhc200cDJrYnNLTEhMMmdKQkUr?=
 =?utf-8?B?RG5keTI1T3JnUWYxNTE3UVhyMDRwTWE5NzBRdlF2WWZPNVRRb0R2ZHhuWHQ1?=
 =?utf-8?B?NUswK3FXRGltYWZmbjJWLzlyOXVnNG4vV0pXbDFpMWMwZXg5Ly8xRHlTQlNN?=
 =?utf-8?B?aEJyVnE2UDVSaUh1SS9VNVBNM2tZRzBSQzM4a0FaY1JrZ2pWNXlmbU9taXpu?=
 =?utf-8?B?eXJBMkdzN0RRa1NodTdrV3JuOTZhYXVZT2cvYUZWRUNEbnY4c1NDZnpWUitN?=
 =?utf-8?B?dHlFeHFPVGpKRENuZUsvQzVsbFRtTlBmeVZpMVJDN0wrOWY0VVEwSStaTzJU?=
 =?utf-8?B?dDc5aHlWaWxRRlB0eE1LMWh4RFFHYk1xQWNSQTVrWlY2MkdxdmFRZldJSW5E?=
 =?utf-8?B?QzdxanBBSHh6NEFSc3lRdUNSakJXRGpMdzdMdllQOVNJZDA2SlB1QVdyYkZr?=
 =?utf-8?B?Vlpic215WCt4NHkzbll5RktoQnN0YzRpNVdrQmY1dUc3Z2Q4elR1LzJHZ0Uw?=
 =?utf-8?B?NW5TS3cySlhzanZJTmNOcjlHQ3RmcG9aUGdjbHFwWVVMTTQzemEyME0zUTBj?=
 =?utf-8?B?c0xtQUIydEFTdmZkc3hmam42Mk5wZmxSMzdrbTNjVVcwTkZkZnlqUjNwZmhs?=
 =?utf-8?B?cXcxaUhPbjdibnhsZDZHd3NaWHlqSm8zdlI3U0txTnMxU1RwSG5yRWF2TlBs?=
 =?utf-8?B?T2FIc0wzdzlvM0hiaEIveEs2R1NSSFEzVTNld0JGcU51MHAycGRMRTZiVWR4?=
 =?utf-8?B?QkVhRXVpQTMrOFhPcHRCUXdIMnJKem9EQjhhZ0NreHVPcmx2b3B4ai9OVmI3?=
 =?utf-8?B?b0FORG5EUmhObkQ0dGVjdXdJWUp0cnlMQ2VHT3RXNFJuZ2hUZ04reXYxVTZW?=
 =?utf-8?B?STB6ZDR0czRGQ01PUXdTVGlCcGlFWlFyQUYzc0hVLzVFdTVkaXRDbkNTRnIw?=
 =?utf-8?B?aFByV2tmSjhQeStxSStqVm1QYlkvWTU2SUVmOUVWRWQrWng0WGE3T3ZiNXAz?=
 =?utf-8?B?ZExydnVRK1ByRFhMaExzcE9zdlJVa3FFQzU4TlQzbGtISUtDMHBBY21lZDVK?=
 =?utf-8?B?cXBLRWRDRjJ2dTM4S05NSUR4S0ROd0p2aTF6aHhycW9nbFVDTXdvd1BIWGs3?=
 =?utf-8?B?akZ0ZER4bkV1WWs3YjhuNWJ3LzZOejdSNlNFT2xsMy9oY1IzWUYwcjBGWFBU?=
 =?utf-8?B?em4yOSswZmFxK0pweDU5eGMwcGkzZU5XekRWMGUzRU03dWxYcDR6aHNZaVVM?=
 =?utf-8?B?RGtaNnB6blNucGRlR3JOeDNOQlgyQTR5bTFBclZWbC85VjlFakZkZlp4TlJW?=
 =?utf-8?B?RWJNVFl6RzZ1ajZxZitRa1haTkF2SWxsVmw3TGZ0YzZ1dXNIVWJJUGVHRVNj?=
 =?utf-8?B?RStsNHZkSEdIV2RBcDlEVWVzZmxPeTVtc3dTN2IxU1doQlZNKy9SRFB5YXFj?=
 =?utf-8?B?MEhLZmlDY2ZLV2w3Uzd0dzVuYStSR3JGQTZ4K2x0eUVxZGRjK241NjRGTmcv?=
 =?utf-8?B?R2hrQ2M4Njk0ODR6Q25KbFlqNStGdTd0RnNsVnFISGc3ZGNCYXh5U09pT1VD?=
 =?utf-8?B?dG1mWSs3VjRKT1dUT2NzeHNEcVhlSjJQcFYxTjdqOUdkcXBackc1c1h4a24v?=
 =?utf-8?B?OGZuM0ZORklIV2VYVDJGR1F1TTRlU3hpSmMxZG0rUHVCWE1YQ3NrWnlGVnd6?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9856d3-2194-4970-8af0-08db2a305ac3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 17:18:57.4962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KqEhm71ySRbXGa88BNDEI0O8e668jn1EIFBTTDnD9SttCmOCNYkkSL2dSaEuvpTLGv4rIST/NFaL7ARtoBCrBoxQMg5h365FT7qse41z4Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6665
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/2023 10:03 PM, Jakub Kicinski wrote:
> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v2: remove the links in CAN and in ICE as well
>      improve the start of the threaded NAPI section
>      name footnote
>      internal links from the intro to sections
>      various clarifications from Florian and Stephen
> 
> CC: corbet@lwn.net
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: pisa@cmp.felk.cvut.cz
> CC: mkl@pengutronix.de
> CC: linux-doc@vger.kernel.org
> CC: f.fainelli@gmail.com
> CC: stephen@networkplumber.org
> ---
>   .../can/ctu/ctucanfd-driver.rst               |   3 +-
>   .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>   .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>   .../device_drivers/ethernet/intel/ice.rst     |   4 +-
>   .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-

With ixgb removed, this should already be gone? Aside from the ixgb 
portion...

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com> # For the Intel 
portion

>   Documentation/networking/index.rst            |   1 +
>   Documentation/networking/napi.rst             | 251 ++++++++++++++++++
>   include/linux/netdevice.h                     |  13 +-
>   8 files changed, 267 insertions(+), 16 deletions(-)
>   create mode 100644 Documentation/networking/napi.rst

