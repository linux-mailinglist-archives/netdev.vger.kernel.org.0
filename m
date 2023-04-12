Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A86E003F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDLU52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDLU51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:57:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFB0C4;
        Wed, 12 Apr 2023 13:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681333046; x=1712869046;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iZ0eHgAjgVERBsnWBXvK+UJ8i+NORBOv/awMq9b6uU4=;
  b=bLLi+v849sNZy3y3LxYiheiZPWMv0Simhwv/PxGOzeX9mvGQxeE0M1SQ
   OjLihvFlBrdLCL2Ey9TP++EAFuH9xcdX/wKRhddXC+8D18JaoPYz/BS8C
   U67AtsHmHrtVOOHLqqOIiz5NwpwXl55omC+Eps66qbeUUjBKyYdeGazjV
   apXRYDixaylf06KRWgCGWuMUb+JPHx5mplHD/l8dgmY7m1kl5vrefyC6s
   QZ6szSw70lML7ZBB6FRcihjG4F9Cvf66gCW6nD4/EaYc/GTyfQIZHZ04g
   BNQWPU3L3O1jxA2jZe0W6IYZzHxmRjR/7N3H8k1wA9WL8sx/0xGAQ4z8K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430308166"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430308166"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 13:57:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863461188"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863461188"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 13:57:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 13:57:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 13:57:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 13:57:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 13:57:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9+++IAu/3kq2L/yIOyF7I54y75/f2g1GX0Z2Gyo9QlMlZFNAjEV1x6KCRoqqdisftrF//M6mthSCJV+tIGxIk5riqwN9oP5Yc5N0looXwLEXrYXXXXmykgLlwAMuUGMkjM6nJ02xvtjuBxngKcDF7cbyca+mWLqJCyUC1Y9oqNSDnefmKKjT+GZurVCKoe71KyJ3H18/IGETv2xGqkVJ/qkGvAvDZbeP4wvjitZDJPC8Hyj53C9tBaMBT9rydtW2QU82OAavixKEFwx5UYes1/CYAZrI4EWf90V++XHFeFbv2JBpmsvH7GA/gZFYdK9X24iPovzMM9fgeTnBKDKkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXMcrYjV2/39mNRRfCtojqWYNqKN+prTKXMyi0AZgL8=;
 b=TMo99LZmr7ifWTc6CVmkQdQY6IE3divcRq2yd+srIdhxnVZQt02ebEEt1W/KibNy7nRi+WK0PHQigSQXDLoQR70P/f4v0LhL4Y4SyvlT5MahLJl7uFIVQro+rUjbw4jgz/BbqhqjgTEcl5pClBamTvZQAL7PfKNcM3AN/RadQ3QH0HcBykbaxwh5dSk6UsnJJlXZ03MzKUn/c5mQzqEDgdHY7fSljzrOzLNbMtywKzvEhpsZiIbiKPcu9MaMEJG+pNPuJ8lxG2e8m2tvK/5xx9ZYZhaUjKL6W5R47/gBaGv8oLerNxsD/MXG6EObwUlIT4GIjGyXWnV/QbWA0bSOpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6999.namprd11.prod.outlook.com (2603:10b6:510:221::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 20:57:22 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 20:57:22 +0000
Message-ID: <f0694d43-3274-93ef-0798-6129556277b4@intel.com>
Date:   Wed, 12 Apr 2023 13:57:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v3 4/4] net: stmmac: add Rx HWTS metadata to XDP
 ZC receive pkt
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Alexander Duyck" <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <xdp-hints@xdp-project.net>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-5-yoong.siang.song@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412094235.589089-5-yoong.siang.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0063.namprd17.prod.outlook.com
 (2603:10b6:a03:167::40) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB6999:EE_
X-MS-Office365-Filtering-Correlation-Id: 05e7d1d6-a367-4d0c-26dd-08db3b988302
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K65ergTZiZcaaQB81Ff9hHF9x51FvzeVQRO3d9p51cIQnUzgO5+lDjNqFFfr8Kn0SRtIoTNacnYHufOUmw+jXxmZBiQhbD/sa2lBVKDYiNzhPzITDbnzdMxi2h2/xUihGYEqpVh5KTqoooxpMnGnBFxvBQ/yxkUz1a/agtA4S4cylNR7svqnV1WzSjm5V+gShi4uBWFDsl84j4UulqDAMeqdc49NHpm2XlzwHc65DRmSy1P5BUWR/nQ9t5oxgdjPRoIQuc31S9RFvP9CoM99OfvYPZbXdkjBfZoRz18auHcMVETow0WtkAZCRgXkK516l8OhJI2ZERjgAE6NkCI2212tZCRyf4rGcZFn2+ps8G6+35TvOMXIDxBzmVtfN+vwCOw1M3qHC2Jk/KcNXE9SCFdCw2rGq7w/2K5DFA5O6y6vJDtjcEcuk3jc3ZZc57UYS8uEclJIDbPumaICDAQrUgu3/n0xAuTdsNqQdAi55z5e1ZGf72hhFF7iuEvq0TIXvZrqs15u0QmYcc2SSINQCwDrTYyDCkFUKBO5/7gkFZvRF7so0e/82wJ0LPXbzzFAjIShDKIFxXxWn4NvtbdGqWhtHzTdpaJNaBw75eIXutt7EjrpfjTvP+QjLD5UzyiUviGwjN9HVxALzO40D0CqFBfQLkbXt5/vo7U7wHLu+Ek=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199021)(2906002)(4744005)(31686004)(7416002)(8676002)(8936002)(5660300002)(478600001)(41300700001)(316002)(66946007)(82960400001)(36756003)(66476007)(66556008)(110136005)(6636002)(4326008)(186003)(31696002)(6486002)(38100700002)(86362001)(26005)(53546011)(6506007)(6512007)(921005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkJzRFBsM3llbU1ZWTZQam1lMGJaV1lENmIvcDdlQTRQUHYwK2ZXNThvbnhq?=
 =?utf-8?B?YXJOdWl5blI0b3pOalhhaElzTHNJcmFrM08zbklXUlVPS240R1BFRXZaL1Nr?=
 =?utf-8?B?Rm5qdlhZR2JwbDNNUm1HSDdCNk15aVlqenh0dFJQYkdNQmVodmdLNlJJclUz?=
 =?utf-8?B?MkFTbFNWSnRleTdoNXRUb2dQcE9mbFN1ZVVzSWNpUUV6TWlCK0tlYXFnQ2Ew?=
 =?utf-8?B?dUUvS2lDdnpaN0VVNzlwckt4MklEbitlOVcxdEhzV2tsM3RTNDdwSXRNVWNR?=
 =?utf-8?B?Y2d4bjlKOHkrVGlzbFNuWTFUSDZITGRhZ1J2QVppd2NsR0pDTUFSajVucytS?=
 =?utf-8?B?LytZYzkvbTVZU1RwWkRydVVHRU1xM1dMYzR5elkwOFIxNHNXYlI1UWxNZWJW?=
 =?utf-8?B?NHR6QzQrT1crcjY0bzlKaitrcUZFcXBCY0tZbytnNlBOMVVacEpycjBhSHJI?=
 =?utf-8?B?di83eExaVkFLZVQxNW9PTittcDhPclFlVDNWUlNFUllxQTZacXJ0bEdmNTNt?=
 =?utf-8?B?Y2ZpaUZ1NnRvWlo3cVlCa2hzSWVYUVV6YVRhQ3Z5NjVPR0FiR2NqV0JXUHFu?=
 =?utf-8?B?ZmlIcS9KWVVtWWJXVGZOWXo1bVlLVUNzemFxMnBjd1dSTW1CYnc2YVVBM2hq?=
 =?utf-8?B?OUhZeW9JN3ZRalZTL1IxNFZxRXRHWlBkUDYrZjJJOURKOUFRbWhvcDR0YzBO?=
 =?utf-8?B?aE95NGdCeHN2SHl4TFVicWdPVHpiWVRISm0zTnQ5c3owMlZKU0FvWkNCSVE1?=
 =?utf-8?B?bzhZNFA1SWhkMFpXZWlaeXlIWmMxSExzRFovWVE4aDhxb0NlV04zUmt1dTZn?=
 =?utf-8?B?VDFac0diQWhvUStxQXdxa3IrMEdNR1BCeUdyZldXYmgxRmhPdk02MXJWL0Vo?=
 =?utf-8?B?VC9EcGdKY2dxYjRpM3hsME5yKzh2dFd0bVhwM0p1MXZTRWhzR2lOZTh4cTVq?=
 =?utf-8?B?b1NOSFFNRStKb1VPSUdGRzhaSUNLb0tHZlpPZklvOTJ0eHpUcHd4NWhQQ2wv?=
 =?utf-8?B?TjIvV0JzSlJZN1lWWHNVc0lOcTJiUksralVpS2JIZ25DdjNBOTlGOTNKM3NE?=
 =?utf-8?B?eGdtb05ManF5Q2VQeG9YcllqMjBMeFd2bTdsb0Z4NXhiakVTeGEwTTBRUUs4?=
 =?utf-8?B?VGdlOFFJc2VFNFA0Ym44eVdJRXk5dmZ5Z0VEQVpuSnZJdEM5NWxFbzhMMDVu?=
 =?utf-8?B?M2Q0blZGUGpITERla0VLNVJ3Z1FMOVkzaGxNUWtVa3RTeVVoMy93OXZ5dDlx?=
 =?utf-8?B?RjdvRVFvUzUvVDREekxxZ0RoZFJXQkU3bUV0ZzNDUUwwR2h0aVpkNWtYUER0?=
 =?utf-8?B?a1F0RWF4Q0JyMDU3VE1udk9vWjQrekpTVzRIWTNsRGtzQnB2Qm5ldlNJUmhR?=
 =?utf-8?B?Uk9QenZESUJORnNuckdjbURFOTROWWlWcTFEMnpmOTZ4U2tkdTdaSkFKUFlh?=
 =?utf-8?B?VU05U1ZvTkh3Yk1mV0RBMS9SMWhVUCthZG1xcEJDZkpxWm9GMEIrSzI3Zy90?=
 =?utf-8?B?b1ZObG55Z2kxc0Y2NDlVTVRoYzZ0eVNTMXJqT3B0UWZlbmxzcjhZcndodzVQ?=
 =?utf-8?B?RDlZTExQTEhiWTZIeXBHTEFlRHNjVUs2YmlIYUYwUTdXdjBnems4blRsZUgr?=
 =?utf-8?B?YVBST3NTSXlhazhhdXowMG9XZUpzSHd1R3czUVRTelIzbjFWV3g5eGxQSXFa?=
 =?utf-8?B?Zmx6WnJCUTVlTk5JVUE5eTV6Z0V4QS96VGlGMS9SREIxQ0JLRjRMRkpSemo5?=
 =?utf-8?B?aWpiUlpnT3ZPTFpBM1g0cDY0TkpWY1V6QnBZV25kbGxwb3JHeU55MGNVaGdn?=
 =?utf-8?B?U3NFdlpvM3JHMnh1QUJGSXJsTUVWZHNDZW5nN002bURERDJReFlrbG1mdVhQ?=
 =?utf-8?B?SCtIRWo4WXh3VS83S3VLa0VJTTFnV3pWb0tIRnN0YjJyUTlVY2pUQ0NGdlNk?=
 =?utf-8?B?UjZFL2tMMWFyOG1lVlluMVBzMFRwZHo0S2x5VXlUa3pJczZXZC9tVFRjVzg1?=
 =?utf-8?B?K3paRnh4bEJMZ21ubERKNitia0w3cGU2VmxyMzJqOWp6U0tZTWpxUXRCY3J1?=
 =?utf-8?B?YitYYklKci9XeGN6a0hERTk0NGgzU1kvb0hDYzJEMEwwd1lTSnZiRTQ4VUVX?=
 =?utf-8?B?blJsVTRYUUNRVEhHNXN2QnlNVXYyR0ViZE9aaHo0d0xVcUQ5UmlDTGdVUWtM?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e7d1d6-a367-4d0c-26dd-08db3b988302
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 20:57:22.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRbIS+v6t7iym9Kb24YzSgyRbhALCJfpQQS8YZStgxwZJHaS1NolRiQGDedbkMU7iYZuInXM5aosaRoQ1l+BA21kwiMGGJ/cAwiIe6Uz8JQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6999
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 2:42 AM, Song Yoong Siang wrote:
> Add receive hardware timestamp metadata support via kfunc to XDP Zero Copy
> receive packets.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---

I'm not familiar enough with XDP to understand how the struct layering
and casting works, so I'm not confident in adding my Reviewed-by, but
this seems ok to me.
