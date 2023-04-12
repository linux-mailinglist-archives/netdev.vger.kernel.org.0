Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0226E00B9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjDLVV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDLVVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:21:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA0783CB;
        Wed, 12 Apr 2023 14:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334464; x=1712870464;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qzmGvCBPfL96M1nMAseheicXfwJIEB12NQf7EaaahcM=;
  b=S7PTADcoNX4DT1FNz7sz+qMxJ475eH1acT5pgO/O2gvTNwN5OSz7Hixw
   CwpBMNidO4w/+BHUrXvafQBF7+gPcGWev+0nYYxhTYbDjb0dBwjS1B0OK
   dcjZIeLKAVX1nJf+LIp1SKMXtb2MHbbZhWIwjCQmyDhbsMdhgWVBLYl9k
   /VaK6OD9DUKoH7DCAddY4u1+sNuUkH32/ySD+Pm6M0cb5I6r6D89FOc5o
   rqlNCOVDHcTjpHrREXOVD6/TmTpAsBQX9KTLmitvZr1bhDPkXL1gW1l+M
   OR7FAghzP1ydXOa8xybXG5QFLDhRoJBqyhUJZTzxeLMMokCTA5xolHCLk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="328139485"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="328139485"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:19:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="689059028"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="689059028"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 12 Apr 2023 14:19:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:19:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:19:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:19:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:19:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMa6M5a5JWQvbMf5PooGeKOkjFyxBk6wVo5qCWsG6qa3uKDtS8QdNZgn0KRyAmviSIFyOShIcoVTLQZ/xJXVYaUlDRAQfJqfwmPUVBK2OIrLCNwVGUfShVvCYnwzgyZQv9MIqjFdu1PdJ/XhId5g4mcTajHxdjO0g+JgbeOAH/qh97igFVHfZX4IqFoptK+wtX2ucSA7hQzIG7ZX3qJOtPNqHEkSHYCWj/f3bo9wrL0Oan6mVBCv+xikMEvEu8O/WvcDKJ77UBMK8N8hdyT4rvdf8i34sSythl5SCgpoR5acb51f3hNNBYujJZ4zkA+ojKRrKTvVonxUw7Ws9CsU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HXFu0HvR+7GHP/DX47Tl3E7Pdp2g31jfsvJB5Jccq0=;
 b=lI4xtWkLlXHkZXM1R1NYnW28zH3ImiuMnvT5i5cuFmCFiDIajyPybxBrcbnmO5Y4d4hRcIO++3ygki5pQtp5oLiOKiRNxN2KEZRnM3n9MLHXDpY0repN93arRjZ/Zo/Q8ILVDycKwV7mdxKHIUk/4RPrKJ1SArVQj4T6lFyg9QG6vupYiAy9LuPSrfUiZHjIufMHiqpGqFYjlFiOpGYSX/AJKVfDMXDq1RlpOvNxsbTtRUaAsPa25/dz78YFfLD6yOOGe7/QtCM3+wOBU/D3yoDaVFdBhif7TV21E54mcHXv0235N1QvXRmtwpKXxAdqgzI9qzcOcWtH9LBGvhB1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by PH8PR11MB6901.namprd11.prod.outlook.com (2603:10b6:510:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 21:19:18 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:19:18 +0000
Message-ID: <2c9d0ba9-299a-4bac-5ccd-62c73c9b428d@intel.com>
Date:   Wed, 12 Apr 2023 16:19:14 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net] selftests: add the missing CONFIG_IP_SCTP in net
 config
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        <linux-sctp@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
References: <61dddebc4d2dd98fe7fb145e24d4b2430e42b572.1681312386.git.lucien.xin@gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <61dddebc4d2dd98fe7fb145e24d4b2430e42b572.1681312386.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::20) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|PH8PR11MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 488dc369-f7cd-471b-6dc5-08db3b9b9343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KSaqZsEXlRgATiBS94HH6ARAUmU4EwuvtkUJrKruD27ID0fJgjlbgCTjaP8s/NMHH3/TvYJs0m+X5k/x0bMZfK6YJQXPYqstyl3bosW+0sAwsGx6PiKrByl/55rzdGRHjxjJdcBVHI1FrxCT6nzNOKRQhLRBymy8tTCxjN4Afe2tMGinubO29KdeQoROfRYRU6LFUdzpQR2kkvKa3TTCeIQziptQAIBO7zLbrd3WkvnvlkW0ymJDl9SZqhvL1fkFXknoNrNVGVR95h0IqOes5xtzfHnxgyyCtBsuzm8Pwxi28nGwWGV92HWuWU0yEZpHS8DE0a+fu6BXTbJYmAuKAvBOTfigvf7OewNBJuovSPv4NDutULPsiiegeM5FROycSHUr34h+cmcDrbxgIi0cjsUxTLiDYy4Xc0UNdSFEwVJzQMW0C2o+ct86VQlFg1ul6pnTvdM1uc9QZPEpb0B9tT2tvRvwRKz3A7BGZWKHQrkkzRDAixhuo9HgU9QvrL9xhx7Zx5cuNpX7pY+U4CZZ69EXKvEEl9jRirhdWLeBrwUJSDhjxEbC5OvxaXDPPh/cLIdBtAc21D9fdVA5sC4xvCzTplbZZ5bxMGUc1zqL5hIeFwHveF4i34HYpxIqfgWWSR6Kl9eQwRmV981WufFPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199021)(31686004)(36756003)(41300700001)(66476007)(54906003)(66946007)(478600001)(8676002)(6486002)(4326008)(66556008)(316002)(110136005)(31696002)(86362001)(2616005)(6506007)(6512007)(6666004)(26005)(53546011)(4744005)(2906002)(5660300002)(82960400001)(8936002)(38100700002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnZVSGNoVWdCcHpLY3NsbW16WUVKdmp1aVR4aDVvdW5LRGhHVWUvVUpjN25J?=
 =?utf-8?B?azFVMXZIbHg0dmlzNC9EWGNuc2tVd3FFZ1dHTGRyNmFBSUc0MDAvMDNvZDZw?=
 =?utf-8?B?dm9ZbXkzbDlYTFIvS0UrdGtPenJmVG41L0F5YThWU3h2ODU4WTRjZXlDbi9w?=
 =?utf-8?B?VDY1Rk5SSW15ZnF6TE80TmFtdFFoQ2xzWlJpV051K1VybUgremI4RDVlWFNi?=
 =?utf-8?B?SDkyU1pGWlRuV1Y3WDJrdy81Q0JFbk0rV3Bnb1R3MHRxRjJ4VjZ5cHpRcnhp?=
 =?utf-8?B?SC9lSXdaSzhRMkNXeld5MlA4QzN3cnNHdWkyajVoQmw2U05rQkduaVZ6VjQ5?=
 =?utf-8?B?b05IZS9aSm12SmIwazlvaE5KRGUzYUgwZnYvbGZodmo4ekxza3RzRi9xcTNH?=
 =?utf-8?B?Qy9IMkNUMlREY0hDZGc2MmVxY2tNZ3g4TWpRSkhsNFdaWmdQZTl3UHAyUnZI?=
 =?utf-8?B?YXV0RmtrSmg2VjZWcnMxL2lYdnREWk5WNW93TjBuY01ZMzZiL2R6ZE43YlRm?=
 =?utf-8?B?cEdCSTM2MzV4a0dqaCtUaC94S041MjhGandySmh6TWlPVmJ6QVlJK1YvMHFo?=
 =?utf-8?B?TlhNSlVNR0xVZG9GNTY0aWpUNDNFWmpyc0tjdjNDaGszT2xiVGtuUUxPSk12?=
 =?utf-8?B?b0FZSThSckNBblhaemYxNmQ0RVFBbTQ5bFY5RDNUdDFtMUdVWGVJT3dsNTg3?=
 =?utf-8?B?a3pxVDltbzJOK1V4RFh6OTRoaUw5b1dMcE9FUzNMMzdrL3grZGFGR2NMOEFm?=
 =?utf-8?B?OUR6QVJLNWpyMWozb3ppZUEzNk40TkRLN0V4VmdYeHpEbndWZ05hdmF5akUx?=
 =?utf-8?B?MXQwQU83Y1NaamlaU0I2bERWa0F3aHlmSHhFQURHYTg0RFc3VzRNRngwM3FX?=
 =?utf-8?B?YndQNlZPb0IvYkhEeWk3MnlhcEV5Lzh5eldlTThsYzV6VURaMWVMc2pldEts?=
 =?utf-8?B?ZjUxckttR0tCcmxxd3FCNWYyNlVuNmRuYUh4MkRoNkhrTENqblIvQnlkVTYy?=
 =?utf-8?B?empERVhmM2txOW9aTkJ5d2ttWjczcHVzM1gzcVBXbm83Z2h6Wkk2SWw1a1N3?=
 =?utf-8?B?aisxSnJpbEtad240RDgvek5KRWk0Q1NZV0Zwak16SHM3eW41Q3lnMjVJSDVr?=
 =?utf-8?B?NTFMcVRMNDl2b2JFbkVNTFAvSnc3ajI3Q0Fld0FodmdlZ2J6eXhHMTllRlVx?=
 =?utf-8?B?VldJRFFqVGxOUG0zdTBqUnQzM0kySDhwTlBjSy9yYlRWMFJ6WUc4SmRmbnFq?=
 =?utf-8?B?ZUlOelJoUWNBOU9La2I0d3FxalpmTEFZK3ZGN1Fib05vaXlrUWs1RGR0VUYw?=
 =?utf-8?B?NUxRbHlQc1djRHB1SnZoczUwM2wxM1pQK3VyeVR1cG5hVVVtSWJJcVFWaFVP?=
 =?utf-8?B?OGVaZVo4Q00rZW90YUlYaUlPNHNQT0xzaEphTWZQc3hMaTZKZElBVHRxeEpC?=
 =?utf-8?B?bXV3WitLR0w0aExScStQZHpYTU40RGFmUzIrRFNsbFMvVEFjU1RuR3NPVitj?=
 =?utf-8?B?Z2dnYTZ6a1NKaFF6S2FpM1BSZmNtODZXcGp1VDZZVDNHWnEzcUQ3WmJyK28w?=
 =?utf-8?B?UVRvcGxPU0tUT004UTZJVTdrZ0dBK3ZuVXIzbS9WZ3kyUk5MWXowcTJFMW1u?=
 =?utf-8?B?STlNTDVmOTR2cDR1ZkJ1aTlNazl0aGc3SFd1Wi95bytZY3BrNi9VVzhpODk5?=
 =?utf-8?B?Vk8yTXY2MTFkODh2QTRDUzFJTUcrVmNFNStlclNub1VWdkRVbUJsWnlVTjJL?=
 =?utf-8?B?cnE5am9Eb2tOU0c5N1pkUkZVSTVUZ29nUDc4bm9ranlmOC8vWEZ4RFJBcVZN?=
 =?utf-8?B?RXd1TXRZWTFNdlBLSTNEeUtyTDFuTnhwQlp3NEtTMGt1Si9aeXFjdHZzWTZl?=
 =?utf-8?B?cjI0RUJJYy9OZTdjWTBXUWlYdTE5ckVGTjI5N1VZNVloV0FnOTZoajcvTnZU?=
 =?utf-8?B?bjJKbFpNeHR5ZHpQZm9VM21HM1RsNlhTT3dxR1hOR25XampkN1BBRFJrY25K?=
 =?utf-8?B?S1ZUdGkwRlFRUG56RUtXUlhpYk9TMUhibXlmR1h6Ni9peDBhRVZrK3E2VHRH?=
 =?utf-8?B?ajc4eDBIQnFEakdOU3FtZThyclRQblR0ZVpxeTZMMmUwZ1BiQmpCS0VIS0pI?=
 =?utf-8?B?VUJOaU56c3RhbEdzOHNtbk1NdXJDejNHYlp3eVRFNGtPVUFlZjVVUXVFMGM2?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 488dc369-f7cd-471b-6dc5-08db3b9b9343
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:19:18.2223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Auid+pTYPVqyjdxoeR0EiGRpKIwDfcWJCvoHv9vzA+9e6+EmJnXoX0jLxTHWp4ttn1z/5afgW1gwCQZvODr4xrBb67EuwUZgYYUNGKGEtsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6901
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 10:13 AM, Xin Long wrote:
> The selftest sctp_vrf needs CONFIG_IP_SCTP set in config
> when building the kernel, so add it.
> 
> Fixes: a61bd7b9fef3 ("selftests: add a selftest for sctp vrf")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

