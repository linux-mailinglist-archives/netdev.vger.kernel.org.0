Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A6A6BEA59
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjCQNmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjCQNmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:42:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B2D22A14;
        Fri, 17 Mar 2023 06:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679060507; x=1710596507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rsxTSYN8Z3kV49J0f2KZNu9BMQhwu8dqJZHC7dBHsAk=;
  b=FKXyPl28G0wZFh3X7iH4nfZCeXzNNUJB7IKd3SyNTRG68KAbk3ZWs+oV
   sPfpt/2cmMwvrOkH6OTEzlXRDZf3x0GcO25PHMm/xaUa7wiLzR2pc3XcS
   hD9jGnQfBsqvKp3vpypjnS4PxfffrjIpUdmVEftU3s2vvUdhG2YJQtk+g
   2XWTyH9edIXxm7+FBHY5P8uZHvB6a60bg2Agjw4m3lXqA8t2jaPtTFsOV
   L1nbhS5yNjxocblX+rXkHgVGhnPtfA0lyuqZKeQtth/5ALuaDmn4V76yG
   waSpbbwPb3l+QL2wK5geMqyl1aGLZjl79Rw2cvYJoIQulD3lI/C0mgXw8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="317916523"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="317916523"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 06:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="926142655"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="926142655"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2023 06:41:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 06:41:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 06:41:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 06:41:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 06:41:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKvjyPCa2vXVMBWbxZiYclFvsdJYjKPk1/GRLjUdrw2SPgjmdRoIryN1SdLibJ8c++LGTualCaSmdtGSAqS7Wb0uhOFed+4n2UiUkvyRsAtDq8WqR6/sGP7Nc07cIWaaxdbY8bKldeQgR62C6UOAtpiHvv9uQCmPCgexqbJh/WjOT5Aq7OEptcx6aYT4lcBrekXpKYR3vV1dxe6ebwuRdR7G/KalnvXj/k7LwUOEKPKddR6HNK2k48gOYGWfDLyCu/GipVzRAqYw3lSMxJZLZD4AHTYrbrZ1Q8o3G1CYgOEpcue1/nJLY0RwGoVMmrCGb236mUnjA1ElKq/cJADEZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1ZB1Acqxha4fKbwjGdoV1ZG/UPdr10CDgQRNQTYSNE=;
 b=TrSb/b5263KzFi62FNAyhQO7HvLtPEn52qUAqDIsTc6lSAOD5fhAdbrcgArRVDo+tm0YteLTq8RsuLEvDXbSo4M4pvdgFIzEM60Y9y8FqIIYwbnztIg/WsGMskDZVFtrUaBEDwlt3IkM0YpE17PQjC5tLzq20lkQlswVi6dFD0D7Un+NpmakOPo5KIt1D00H1leEAghqmPx4Y92stI3qU9GnM8DH0DbT06irVQm4ScbsoIPXFFbaiHkPc72UiSkvNmrymsb2eTKpHAMRyGdtiRuL/Q6we3Q1T5Boaus23oN6skgS+xIC0EN+69I7t5Sqgjti2H+xW6pvn7jT2v8FUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 13:41:35 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 13:41:35 +0000
Message-ID: <0a3933ee-17aa-c6fa-a493-89b96e1c01db@intel.com>
Date:   Fri, 17 Mar 2023 14:40:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: fix "metadata marker" getting
 overwritten by the netstack
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
 <20230316175051.922550-3-aleksander.lobakin@intel.com>
 <8f6bf3e51b5b56ac4cc93dc51456eec221eca559.camel@linux.ibm.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <8f6bf3e51b5b56ac4cc93dc51456eec221eca559.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0177.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::21) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c7a5ff7-2c0a-4f9b-b982-08db26ed5344
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpwqPPZ29XIgtf0D99++jXyEwAMPnclHxBbtG/Jp5M1ZHxN7oT2K0V7BSbvAhzNP5KZU/XJYF5hU1ikrREOedzlCHZl7gTKuahmgVhMsZRiyO0FFPakDEPqS1q48UBwFeMKYJ6cS/klN72P3BuEgDogL+n02igZvCkSyYCa401d0q0f5OAJWf8RDdiFK9Al5WPdoNIHPKagn8EhsVRcJB5cMOqiy/OTf5n7TXdGhlhK1cCHPCHRxoE+XUtUvInfkqd3H8QwCOcI7bhYCll5QWZhVhl67veLabCixR08VVDmRD9CDgqTPcHoLN7PwPq1sI7Oy4UTguKo2xFSRQl+W1MSo/fh995dzBk7Dn3/fOQjdHIni6Pstgg18UH28dhjWbthK6aY8nNgy5RK/aFi/IsIHm4+/52s5ZSdd3BhPmxfHvX4CNq93IJZ/0kwI2dNPRLnvnqrnVLXuhljWrKo4heqCVimEQgMcm0hcHOvEvXKbshvyZPhiE+TLm9HpYayee+yjAgcMByaDXJrr/mIYA+gkMHugOP/GMShCKlkUYhHZxR/wJjn3PMkhN0SMaI452VGDK1tvA9LKFc5SqaD7qmXJeGtiN+BNjXQkp8y0af0ntHIM+Y1HIBCaBxLARiWavmo5Ex32/li9szP+us3FHxe5OWvqTliTHlm2PMD8EZas8dNqrA7RjkxwbyRneW2U6OxQIfhSVF4CKMlyRKvIm3Su5Uk/3TsONpugPYL6bAs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199018)(82960400001)(186003)(6512007)(6506007)(26005)(41300700001)(31686004)(38100700002)(66476007)(6666004)(8676002)(66946007)(8936002)(7416002)(4744005)(4326008)(5660300002)(66556008)(83380400001)(6916009)(2616005)(6486002)(316002)(54906003)(31696002)(36756003)(86362001)(2906002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzlRSnIzK3FYUWJIL1c4MnIwNkpGRkF4Q0J4N2ppc1YrK3JSdFB4VS9sWFdk?=
 =?utf-8?B?L1BISHpWUitEOURuV0NDc3JwWngrcGJNQ2tkUFhDaTZJenIwOUxERXJWNUQw?=
 =?utf-8?B?M1ZhTi8vR3BRalhTSGVBaHo5RXdHMlFGU3cxblJqQkZ4dGtuREJROFpWczNM?=
 =?utf-8?B?UG9LalRSSGlpSlVqdFp0MHlLZmdTMTlYaWp0RDcyQWFmT2swYUUvd1dRNEk5?=
 =?utf-8?B?enVBQVU2SzZFbzdxVVR5cHBtVE5ISVQrS3YzS2lPZmZOOFZ4OTFwVFBIMFhX?=
 =?utf-8?B?SThiUTlRUWJuODVPK3VUYzVaMXpMcXVDQ0ZDUytEcldGUnhyNmxQZ2poZ3p5?=
 =?utf-8?B?WVdQUnM3N2dPQndxZnVMZmZRRzBwZVcrQ0NFRHFRZmNkNXVWSGhraXhQVGVu?=
 =?utf-8?B?QnAvRVdrM3VFcmE3MkRiSi81SDhHTGlOY1JPdlZUL1JLZGduVUcvSjhtVlpT?=
 =?utf-8?B?ZHZyQkhua3pTelZOWDNSVFlLY1I3UFZYaGRDTG03ZGo4ZW85bVBYelFDWjJa?=
 =?utf-8?B?eit2VDhUd3dWbjBHT3o4blJjYXhWemNTa2M1b216NzR0SGF6Vkg0b3BYNEE3?=
 =?utf-8?B?Z0MzaHFZVHRJc2tkWWtrMEZweWNUZlYrN05mOGVsT2wvZm9HSEg3WU1HVmpY?=
 =?utf-8?B?TGxBL1lMUG5KcXBsNWtubjdFelorYUg3TFdUMzZ4U0FBdWloZFhVbnNHUTRL?=
 =?utf-8?B?SEZudmUwZmJQZ1diRlQ4WTdXK3BHOXdUOTl1UGdaR0NLYmc5UWhiSUtENHhC?=
 =?utf-8?B?c0ZQdVpKU3VlS0UzdzdSTnlqVmI0ZDVXeTgrL3FiQThEM0c5QzJJZFlFQzVn?=
 =?utf-8?B?S1AzcmdSdmZmaUdLUFJwd0RNQ0FQUmdSaFNacW80SVpKTjdDY3QxUnZDYjZv?=
 =?utf-8?B?eW15VnlUYUFuWVhGZmNTT3dtRmwvdCt0cGdTWnl3V2YwNUt4NWlsbFJsTEdn?=
 =?utf-8?B?M1BNNnZneFFoeW9CQUlabGEzaGkyci8wd0pjQjRaNjVEL3NxK1VETXJZbFcr?=
 =?utf-8?B?YlZQWWl1NjB2MGJ1QmY0T3FnSFVYYldHeUpwcnRkRXQwbDlmaC9KcFpFeDR1?=
 =?utf-8?B?WFFmbnFGTDN0eWhsamtOV29rZ282SWU0YmRveGpFTEtlMG40d1V5azREekVk?=
 =?utf-8?B?blhpWVB0MlFjTEN6N3R6eGU1cWtmMmd3eitNTElsQ2tIRkRqNk5tV21YQk9w?=
 =?utf-8?B?RHJFVWtWUGVDei9XMlRsS3ZXSGJkSklCaG50a2pFeUE3ZEZjMjlRb0c1VXk5?=
 =?utf-8?B?TmNZLzF6R3ZHM1M1L0hadElNQkZESVVyOVRrYXBtcG9TWHE5OG54dUN4UUYr?=
 =?utf-8?B?NVJUc0tVdlk5eFlMYUZLWUJrQjR4cW5mMnRLUnJvSy95TUxhVWpYY1BOUFcw?=
 =?utf-8?B?OWd3dGlZQTRHSzVSNmhDWEVlWnNHSjR2Sk1lTkNYZHdLb0lsYlJKaDVOZDY0?=
 =?utf-8?B?L2ZaNmtMK0JoU0pLdXFQWjJkUU5ST3pIRG1nVWp0ekNKZnB5dW9kbVF3OEpH?=
 =?utf-8?B?T2NRZWpzU3ZkVFVvZldPNkxwRGt3T0JnVGlHTkRISTd6T0pWN2RMNTFwazNT?=
 =?utf-8?B?aUx0d0UyK0hDZFhnZ3JxbTlFYnFMUEVKMTZ5OFYzVTNWVDV5cWE0NjJYeW5D?=
 =?utf-8?B?bG15L1diczZ3NGtFTnB4c0dHLzBtVG8wTE1IQXpGUjAwQlB5eWZtK2ZXNGdV?=
 =?utf-8?B?VkJNUXVOV1gycm56VDZ2MHBnNmptVFBacThPRktsaXkxQjdhSE01ZUwyV2la?=
 =?utf-8?B?RlFkNm9vSm1ha1U2ODUrOC9GZE9rOHRqNHNuVHFmV2ZZeDVDY0Rqc3dPbU05?=
 =?utf-8?B?N2hmaHpyNE5Ndmtrb3JIQ3N3MkNXN0NzbGRKYXJHaTZHNDhXeVBVTXJNODV1?=
 =?utf-8?B?VXVrT0UwaFI0aGV5eXplQTJKNTBwTlY1NnR0QldyUDZxMVBla3ZDOTZBYkhh?=
 =?utf-8?B?ZjFGRVZjMGdkT0UwRFBKNy9OcG9pKy9EaEl4QWF3SHBNb2Rwd09HbGhhb1Er?=
 =?utf-8?B?ZjNjLyswZGt2bHpwWC9GeXpoMWxCQ21FWFlaUStCK3lBd1IvekJ1cWhDWGFr?=
 =?utf-8?B?SVNMdGlvN0g1Z1NOMVZNdEdGSFl6dFJwVk5rc2Z0S3h2MmtUek8yS05XVGFD?=
 =?utf-8?B?RVdJdFZ6YTVkSEZ3RjliQjc0SFQzeXp0Z2R3Qm9hSUhJT0Fla3BWWVY3cmdo?=
 =?utf-8?Q?0QJo1ZuwWu+Rylhwwb+VxaY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c7a5ff7-2c0a-4f9b-b982-08db26ed5344
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 13:41:35.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J236y5LdKKsS5py+4KQfs0aFJxYiO1vs/8C72msRZAu2yMvTUF4yol3yBue3YoA0p1sPL9uxdS56FO+6JWVw4lXNpGQda3/O6LhQnQ/7QW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5978
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>
Date: Thu, 16 Mar 2023 22:22:26 +0100

> On Thu, 2023-03-16 at 18:50 +0100, Alexander Lobakin wrote:
>> Alexei noticed xdp_do_redirect test on BPF CI started failing on
>> BE systems after skb PP recycling was enabled:

[...]

>> @@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
>>  
>>         *payload = MARK_IN;
>>  
>> -       if (bpf_xdp_adjust_meta(xdp, 4))
>> +       if (bpf_xdp_adjust_meta(xdp, sizeof(__u64)))
>>                 return XDP_ABORTED;
>>  
>>         if (retcode > XDP_PASS)
> 
> Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>

Much thanks again for the debugging and testing! It definitely wouldn't
have been quick without you :D

Olek
