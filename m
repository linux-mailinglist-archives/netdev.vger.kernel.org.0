Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84A36DE82F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDKXmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjDKXmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:42:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811C7527A;
        Tue, 11 Apr 2023 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256525; x=1712792525;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qApeUuC2JI+xim1MsVRmr5eC+lzcbHZFQWfhLOJpKcY=;
  b=AcOObVt2kI+CehxK1BhPv2u0xijJKg3ZleZVsbHrKXsUJR9PRNiphiqB
   8lk3dPOtUdcEXnWtWIGDA3WnJcVt6cyRBHHdpAw1r1jOJS2wlPjtnSP3t
   4SqsqEmDbmM3HnZsdYDjILR3lRwSUL90AmzloHU8NsQ8sKfSw8ZhlJT3E
   qB/zTUtU77shuQm8Z50U6p3C/XZyzZPRdpHEsjNkrK8TEepO4SLsl0fjl
   V0CB0rZ2RcpE3ZL9IUSxl8UrgbtcXzg+ZKi/m02s+pAZ613hJVz6nbW2i
   U2qjE+NhxGrwCVvuVQwksSDktJD6AGeHwLXBdngRfQ+oNKP+KvH7zwQ7S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="406586490"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="406586490"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812770765"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="812770765"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 11 Apr 2023 16:42:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:42:03 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:42:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:42:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:42:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzzGog+QGzl/S4CmFQjZYSyTmewhPf/g16tB4YnvzwVeYr1HKD5lRj24UZb0lleOoV39Ccjkpp2Ic0adO3rtipMHu1kb/SLrJnxYUM7cxCAuKntKrLhC6nK2uGOamBZgJXo1KxPd16OyTPlbZZUNAcSjlBt5zSeQ2zMAf2kLgszq1vs1DFYlpLvA3sQT6WpTaObT6ksWe/KT1LpcNhDy86sc9yl2jPT3+01L0OIEtuLvksNtJ+lQV1ReJJtHTMxKTmb7PmMvEmQfjTR0Lhm3tVz7usw7gWGHG/Vtww5y3PuSzIukdUmfZDuDOLOaLVIml7+/Ugk+T0Z2LsatvlV9Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7gPiGqPxDae2CUicVga80q1Y+F8gogOJuswgyVC61Y=;
 b=KuEQD4vYP9pNOriKbS95Xh1s0fYjRfZZFn55WRoSbSEXoMY8vrvn4ZGDAS1ZXWV1Ws79LT33AYS+OumKbMWqduA/co75iof99ivYSgGJ60LqKJl8CGOE9tOQE45eo6ib9uVNvpSftuSnfTIAfzvHjHXX7PwKwh9ng9v+GdlIVf8IUL9IqxdXZ9Kr6zpWUKTRoyJJAY1g7jwE5mhNcsO8z+NiD6bjlOrGVgTkUb1C/ZauDoDbvIWL/06k5G8c63susw8wuHazB1zmhzmT6WoBIX2eb4OM6FRIndGQ60Ir3hC7wHIIxKrkiiYzFuuWWjQOygX5BgbtuWhKwMZPq2gXIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SN7PR11MB7044.namprd11.prod.outlook.com (2603:10b6:806:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 23:41:55 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:41:55 +0000
Message-ID: <f96efb81-ac39-e64a-a8fc-f2f638e1f3c7@intel.com>
Date:   Tue, 11 Apr 2023 16:41:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 07/12] net: stmmac: Remove some unnecessary
 void pointers
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <vkoul@kernel.org>, <bhupesh.sharma@linaro.org>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <mturquette@baylibre.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <veekhee@apple.com>,
        <tee.min.tan@linux.intel.com>, <mohammad.athari.ismail@intel.com>,
        <jonathanh@nvidia.com>, <ruppala@nvidia.com>, <bmasney@redhat.com>,
        <andrey.konovalov@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <ncai@quicinc.com>,
        <jsuraj@qti.qualcomm.com>, <hisunil@quicinc.com>,
        <echanude@redhat.com>, Simon Horman <simon.horman@corigine.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
 <20230411200409.455355-8-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-8-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::22) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SN7PR11MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec3b715-5b56-40ef-aaf1-08db3ae65567
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5ypsfi2rQ8WzmbqZ6S2wC9adhnKkNUMUsTF2fSM0Yux7mk69/WgjgNrPQyPX10+0udd7cFWlAfehRgH+JfCYnBzPPHlpGrN/KJi4lkuh3IZIwp364FLM0Y0ufiU7wwipmEMgu3KmToX/DDjlxG3jfJZ8zl+nos91zEeQwwEy5pmt0zmJclwgnfmJ6vzM5Km5huMuRh/ZvXhfsv4VTM8CxTTmNk9PRths16kQN7TbusSR2PoYmBawpDoVfn2Z3zPDJndyJWf4BlLEMjXnonQgAEwlMzPJ8CDlcaFpNQB8Lgc3P1W1M5z+lPcrxDv6zEr4ZBhYfNlrJhByMwdDE8CK3nEYMjEsYdMCh3ekeUFgJD5x94BsHRyGXmFHOwBlAK1igCdMLy9Dsf4JKMKyeBQk7MmDdG8SgM07gpDHMkCEgXnk67YJmKcePFp2FOYC9+l77y9bltVO5opH64RVBifh9Hk5eo6hD7FAAWqdnic91jryQ4nk4ntYc81duOV7/+DcRPha7RWsVW9mWjqXZiH0UfP0Qtcfk/gx6kZ3vfrrZQW9rlhWBaNwbqh006jH+Gt/fF7NcLkfU15p72DhpChOL8XDk2V+vt+Mdh3C0dSL+1srNTQYC0XMmJ3Yg5siWqu2T2T7Cz7DLvWEu/89Wk+oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199021)(4326008)(86362001)(2906002)(7416002)(7406005)(5660300002)(31696002)(31686004)(66556008)(2616005)(4744005)(66476007)(66946007)(186003)(44832011)(82960400001)(53546011)(26005)(6506007)(6512007)(6666004)(6486002)(36756003)(38100700002)(316002)(8936002)(8676002)(41300700001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckFuM0R3c1BkclBpUno4S3h2MGtYK1R1STRLYWRUVVlrS1JlK0NtZ2Z6V3NC?=
 =?utf-8?B?SkZnU3FJOE5DWFIvUXBXblJSQUZRVWRnekFiWmZDY3dMeTdEZDZGSEVXbUhk?=
 =?utf-8?B?WmRXYlVRczhRRjQ0Y0h6VnNwbjRNZ2tLTExyb3FBcVBvRFBNSlR1eld1VG5j?=
 =?utf-8?B?eWRuOGZ6RlFrT08rUlVHQXdhYTVDQTYrMzd4VWdkMGU1SGtXVDZ6Z1BSSU1v?=
 =?utf-8?B?VkNrRmpxaXFKL1gzdXVkNmx0OHdXNVR1T05QMG1sbjl6UE9hMSsrK2R1aG9p?=
 =?utf-8?B?bTJGTm9tM0UyUEU1WVVaclJHd1JJYk1EcTNFb2xPSWk1WHp1SDZMcmdWaHBD?=
 =?utf-8?B?ZlZCS1J2Ylg5anI0VHRqV2NTNWxhbmVaSjcvYTJwQ0ZvMTJmdSs2QThleXht?=
 =?utf-8?B?b1g3NVVuRXl2OGlzYkpFOGZYSlpTTzFIM2Voemk4Z0ZrSGNLSCs0SXJBcTZ6?=
 =?utf-8?B?ZEs4bEtScGFEdDdTeUlCMExxQ1oyV3hCL09iajFibGVFRzVSUUVLQmlBWUpW?=
 =?utf-8?B?SG5HR0w5bUpDUUFKdzNmUXRob25XM0ZScFBINGEzVGdJVjZBeWxialo0ckJT?=
 =?utf-8?B?TmxCb2UxK3U0T0czQlVtRGg3V3ViWlhvRzVIcWZraS96MUt3Wk1wdXNnaXNT?=
 =?utf-8?B?OFU2WThFL1ZlWnRnK2F5d1YvYTdvWVRiNTd0TjJoWlJodStWTTZ1bkhZZEV6?=
 =?utf-8?B?aURZb2oxN2xMVDE1eGVSZVlQa2I2NnpZTnhzTUNkcmR5UG1UenBnc3hReE9t?=
 =?utf-8?B?WXBTZytYeXBKWTBqYWxWdlg1aGtmWlJQeTgxZTNpZ285S1YxM3pNUVRLYldw?=
 =?utf-8?B?QW9OeWtERDJDUW8wVWhPbWQvazdjQUQxTm14VlBFZXJRU1Q3SExheW94RzZa?=
 =?utf-8?B?ZVU3RjZ5UmNFVHdyVGk1dmdPZXhLQUM4dVhSM0tuMkpRR2pWMk5LaUd5d0Iz?=
 =?utf-8?B?L2FSOEZtcm1FaktJTDJibFJHMXpUd3RSdUczQnhnOHhkeERld1VRUU1wWFcx?=
 =?utf-8?B?cnIrN2FpM2UvUjI2VzVQR3VuYVlEUDJwOGlLUjRlc2hUSzMzRmd1d21yZ0x4?=
 =?utf-8?B?ODd6VmdpSG9UQ1RIZG9XVU4xUE45M1BhcHNSYzB2cm5JQ2N5K3RDWmlFTDAz?=
 =?utf-8?B?bzU0bzlpK1lQNEVtN1U0YVpEdjVvZFJ5VWIwMHY4WmhCeFZuU0JhaDNaSXRE?=
 =?utf-8?B?YlY5SCtXbFFvUUd5R1cxaHNvN3hrRUVWK0liUmdLOW42c2JSNUsrRlJWUXBx?=
 =?utf-8?B?UHc5aXRKQUFYUWtzejVZd3J6TDRpU1RsaDBubXlhMk1BeldFRXA2ajJubGRW?=
 =?utf-8?B?OVVyQ2gzTXo4cFVQSTRKTXBMb2t3OUpLQ2xjUGNBU0t0aENJSGNmM2FpZGdT?=
 =?utf-8?B?UUs5ekV4a3lwMnBVb0tiK1N0WktWNmJYTUNLVFVLOEZuRldid0REV3JVVlV3?=
 =?utf-8?B?bEpzemY5dEpXZnJSN2pKWm5nMVhVUFJ1cC8yU1U1TlBuM1ZEdS8yaGZyVE1B?=
 =?utf-8?B?ZFZ6eXVKSVlJYll0NVZoYjl1WG5PUFd1TTlnWXRPYTNNUjRqbmJuRkQ4ajcr?=
 =?utf-8?B?d2U5T1hiMFdxS2p1SnkzM2dWdVI2UnF0SVU4NkJ6U0N6SU15ak9XU05tcWNE?=
 =?utf-8?B?K3JBSXBMMXRsb3laR2VUUzExUDBvS2tha3RTNWtFeUZWSEY4b3VLQXVzbzUw?=
 =?utf-8?B?YTNmQzltU0ZFNm41U0JVNU5zNWRZQ3VuVkhXeFNCeW0vVnIyZmN1UWl2c3g0?=
 =?utf-8?B?WEpQdXN2bU1FRkhwSHc0c2p4d1dOaWFBRUtkRTEwK2tDNlRYSDJMSE4vVmR1?=
 =?utf-8?B?cXNKYTNpb1ZKMmVYZE5FU2RwSnI5V3phaXh1NzFneFhMekdtR0FFNnBmZHow?=
 =?utf-8?B?dGwrK1AxcXp0V01XOUc3NDhWVjcvT002ZjB0bGY3ZFdaUmlXSXoxeEQ1Vk9m?=
 =?utf-8?B?VWs1UkR3VUY5c2JUVjAwaVZoODE2VkZZeU9rQUNYU2lVY24vSHZDb2pqQmlG?=
 =?utf-8?B?RHZRbHdFa0x4SnN6OWdieW1aNGRrNmhPUHNoeU81VFRIRytUNkphaUhSeVJW?=
 =?utf-8?B?aHJtb2NHWmNTckdBMWZVcXJkYU9GZ0pKbGpObzJjeitLSmU4aG4rSDM5a3N4?=
 =?utf-8?B?dC9KQVhQd1RXN2V4TnBmVk8vcW1HMGcrMzJSN09rZ3JFOE03SVNxWVltSlVm?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec3b715-5b56-40ef-aaf1-08db3ae65567
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:41:55.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xEzWQc9Arno4i7g7C57eRGpZBFkmouyMkHVPdK56etmCuKQZ+Hx4mHucGVKWtS9Yp8P+E+oL6PKRx9yBV5iC05fWpz3qInNfd9VqStP4P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> There's a few spots in the hardware interface where a void pointer is
> used, but what's passed in and later cast out is always the same type.
> 
> Just use the proper type directly.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Much better!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


