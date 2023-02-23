Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1F6A0CEC
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjBWP3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbjBWP3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:29:36 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A023403A
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677166151; x=1708702151;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yHe52OoZf0bK8bkMzm79jOfKKHGGwrNodwlVvniM10E=;
  b=Fk3xSI3NHrFGhol0C5U+51d6one6l5HhsNyA4Zl27A3UAUWEcSD6HOJK
   5Ryoxyl73XBP7yc/9nnpjzmqTQGurhFiS0odpE8pq8jwk2yttD9U69u2e
   SkZAnRocPXLXbhEao35Ir0fyGkEk4yc/0emXv3xC8dd+uYYNwY6a6Fql9
   Ejm8BBIuFu8DfY1D0mMXm7e1M0vPCrg8VppFbBcj1CrQXSjrh2Z7sG5QT
   3Zs/LBQF++3tz7UEtWM+2v67uTE9pgfSx5SSMYUiyUt8hUF+kF/tKiRUL
   dFkW5GAtSlPlTkrsk1OtCUpXPTbLNHrTT3zith0hqO/2RqQroa+cfa/k/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="419465827"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="419465827"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 07:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="736406921"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="736406921"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 23 Feb 2023 07:28:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 07:28:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 07:28:51 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 07:28:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGfk3qrw3bl2PxLSaY37AGCval1ZDzfTl9gsGlnXhc9bqR2J3ArF2N4epwBmVJrlPKf1JepsRA0mhEATWux/hR7AvIpyEOPcOCHpcMoyhOo9BQib7EBQXNOM47mHpG/Fniw7wS8Wat3mh3QBjpnSpaKxdAtD82zkMq9JvP96T7Yx4a/3wyZkcdEtkJmNzTl3FtirULof4xBw4XZ/z0SGzIPF2GEbwK5apnfIuKQI2OipWrRLMeQZ1wUBCWGFxBV9ThkBFtFBl3b+1/QZNQ8ejlh7I9zSUHyaVWW4IQszyo1LrYLPTMknb0mI1AY3VgeSdQzlj8VVPHJydjT14Qj9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdYGzdis6+V/EYxqCIz5jE5lSZuwkSO7GE3zrwBrhWc=;
 b=VtnQLKD1TSudyvARbunYU+62ovloqcSmBT/SfxRQLDyZFLLDicqrFBLXROwP93H6VtiFxXLVrflGY1evqjEPceoUkBA9+iBd/5Lp6xAiY33kCEBXXKZB+kExH//aFyBahLZGOtDEh2tPZQNkQaAS0xv1NC0gxihg3QYGlbRak8ekOCdLQUeoaj4c1BqITZDjupwbzcYWpHABLeXl5DVYrGIwi/xcubn9YMXkZJkYMSXr7U3DFcqL7lKefA+j49a4ZjBi+QkbgcygSK7txcdg9+kVQtaGJ0hP6ljysYqdPsByLvcJzaQoZoVXZHS4iKEn97pa2IkCryDcWHAjvna/eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5317.namprd11.prod.outlook.com (2603:10b6:208:309::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 15:28:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 15:28:50 +0000
Message-ID: <d97892e9-6fcb-248c-db27-5e34ee5dff11@intel.com>
Date:   Thu, 23 Feb 2023 16:27:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 1/2] net: flower: add support for matching cfm
 fields
Content-Language: en-US
To:     Zahari Doychev <zahari.doychev@linux.com>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <hmehrtens@maxlinear.com>,
        "Zahari Doychev" <zdoychev@maxlinear.com>
References: <20230215192554.3126010-1-zahari.doychev@linux.com>
 <20230215192554.3126010-2-zahari.doychev@linux.com>
 <e4863729-4ddc-f6cc-85f2-333bd996fc6a@intel.com>
 <20230217161920.gs3b2fbc5k73fput@tycho>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217161920.gs3b2fbc5k73fput@tycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0363.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: d3307414-4ab0-41dc-46c1-08db15b2a97f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e9EjO5LPq5Zeu6plbI1wfeOtWLOFbvbKfoWMzrnDqqETtayEIc7Up9R3kcOZs/cYzAqam8RvY9M+Va7VkdWhpVu9MQIDIkWwB+Pgf4TLx2U9ck/oEOUVFpp2yddfYnnFxoD9SJaNQa9wwmgOXbDZyiz0SeTd4YUwirLvclXAc3sLWQ/NsaFdcIiKGuWGHsYt5hA7NQCXRYwSW0hjRVyJPLxA2P9APldYEbRxhiil/1OpNPf/SHu41ODeeyASm/nlAsC54Ts22XEoWF4fzMjziWyBSlJOVLo1dV+XhmD1OumEkDIwzM/cCH/GdMe1S1tTDtKPOYOLDcYM39/BIyR8LUiXC+H6oGnWx5uY/dCBDEwfsccSslxGBJmo2dGknZXov8wNldhKVB+TvsdobxDwIQq1nMHpxVg8NcZVgR1hz8FvOFwR3QSS/wTGwl3irVLHZT9uUTwBb0WmOA+DZnToiGbDByAwIbNTlpviqDFo4y0BSX8G+vNp+Bw9jmYyuxbBKd/hcETvp7jdTwDZONwoB1e4X3R070d4DPaA/pyCWbsHCZAreawLNC/dWARBuLEdl0Y7KKH50ArgVZ6szD5sPoEuuF+a3ezEy872V9BQmizXkAnYZDtzErzVAIu7gwtRAJOeR0yQZK2yRALZUUyczrT+7ZvzFr8qaqZNFbhznW2244rO+DVPdYRTD61F3dtrnUG2NQXAyAmwAiQq7e8c18EudrHVrhXMmmyJI1ead+g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199018)(478600001)(6506007)(6512007)(26005)(186003)(66946007)(41300700001)(66556008)(66476007)(316002)(6486002)(6916009)(4326008)(8676002)(83380400001)(8936002)(5660300002)(2906002)(82960400001)(38100700002)(7416002)(86362001)(31696002)(31686004)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFFBbk5MazFFb0oxN0FPMkdPVVJSZTNKWkNBSzJGYlQwSzdwNTIvOTBYa1Ur?=
 =?utf-8?B?MHZtczV4NE9QWVNaVzltYXQvMlgrM1VKdVNBK2NQUlRoMjA0eXBSQXZKVGxq?=
 =?utf-8?B?MDNxek9SY2RvNlgyMUJhN3U5UDFMaEtQQlZEOXl6MHNSVjVHSCswRXZOeUJC?=
 =?utf-8?B?ZjhxWHR3b1JBc2RweUh2SFgxVFBDZWl2SDBkZW1mK3hLVTlJVTliVFF2enNV?=
 =?utf-8?B?eGZrV2NIY0kvY2tIcFozK1cxOExnR0hvaHNETzJWVWo0QXl4N3JqMTR4Yzdp?=
 =?utf-8?B?ZWdVZU41UlgyVndPWTB1UXZ5Q2VGMm5kWi91MUwzdU5uSUNIT0xwS0IxNWRG?=
 =?utf-8?B?MkNzdUdRQVhXZlVaTS9HMWFQTWZWcnVSOHdUVWEyc0Z3SnN5Q211ai8yWEU0?=
 =?utf-8?B?Q3FvTXBCNlpSajdZUEVkZlUwMytKays0cG4xYS9KSzJqNDZpVXdRaFFDQ2Z1?=
 =?utf-8?B?RHp1L0F6Tld1aWRkdlhPOEdiQ1pFeG0wOHl6cHJLdEp4WFkvU3U5YkRkVGNB?=
 =?utf-8?B?bUNHRWNHV3Y2OTNSWmVCSVllUllrbVRreVlVK1IwNXZDVE9RVWhNY1NxR0No?=
 =?utf-8?B?S2ZIenkxOTAwMWJNbFE1c0xJeGlxVzFESWlqSjRjdzk1WnFiQWJ1clBiVjgx?=
 =?utf-8?B?eXVpeldacGZYUjhQejlrb3ovTjBQTnVyZkhzby9ZSXZNckw0dy9SUVB0TkVN?=
 =?utf-8?B?TFd0RW5TQ0RGYVN5dWV2UmNEWTF1YkxJZFlrcUUyaDZPclBCcURRVjhTanNF?=
 =?utf-8?B?a0lhNDdMdEFTVUZnYm5nYkgxQWRMT2xOdldzMzNGR3Z4TUhRa2xWRlRQQS81?=
 =?utf-8?B?SW5vcmU5TTg0dTlrSUR5b1hXTUthZGhNdHM0TG9YWGFhKzlOUzhlc05YWWNn?=
 =?utf-8?B?V3VjRTY2SnVYTzR4Wk9selU1Z3FKR3hKcGdtZGtaaWhCS2owY0ErTlNCSEtj?=
 =?utf-8?B?b0ZMcitiSHltbXZuUHBUbjhmME1MYVBSd0dnaGZSS0U1TWJvZTI1R1VOcklQ?=
 =?utf-8?B?RHlUVEkvTlBQZFh4b3FiSWMrOHpua0JxY1lzVmVaeXBlVFZRUVFJNk9IZks4?=
 =?utf-8?B?K2xNWHNqMG12c25NWHhnQUpwa3ZGUTd3YTVJTGNrL1FDOGRRRU1YRmg0Tkdn?=
 =?utf-8?B?NDFadlBpVURSMzREK0xKOWlwTzJRMEdFY1htZ1VvN1UyWkZndTBWUzQ2L3Rh?=
 =?utf-8?B?QnNuRFJlbk9zUkZXdmVzRDF3SkFEOFo0emJZMUpWUU0zd0lMS0lyNERwblN3?=
 =?utf-8?B?VWg0T0N1NmhTVWpZWnpsOVVBZjJCWStLc2UzSEkzR3QvZGZwWThmK0JXOVhZ?=
 =?utf-8?B?TG9HTjhBUDVVSWJEaGR1VUpjZTRzMFFEK0d5WXkzWTdPT21HdjdaRnhtK2c5?=
 =?utf-8?B?U0dxVlZONndNWGw4WHBYUFZ3Zk5VUVNBcDkzY3JXRGs2V00vS1JjNmJYb2xX?=
 =?utf-8?B?cXI4WG9IOVJZNkJpOCtrN2tWQ3VyeS9MMklHeGtEUGdmcEFlVzFCelFkcTRq?=
 =?utf-8?B?RzY4OFN2SXhRVExYTnV3cmt1d0ZDZGRPMFk1d3ZnTmVFVVMxTldFbU9JdW9O?=
 =?utf-8?B?Q1krMnBsWGpCT2NxNFVxcGpVUy9QY29hb1o3bSs5Y2ZZOFBzYmlhU0x0QmR4?=
 =?utf-8?B?UEtVTDdIdlNuVGV4KzBxNkpmOGN6VzUvSDFNUURva091aWdXNUN5MFU2MVYv?=
 =?utf-8?B?WVlCM21yVmt6Q2tXYlVZSEcxRnpwaGt0S1AxY1JUMkxBcW8yMlVHSkdxblJY?=
 =?utf-8?B?cERJcXpUK2hsQ2R3cTNsZHlDOGpXTmJPVHJrWDhTM09zN0Jicm5vamVYdFVr?=
 =?utf-8?B?WlIzNVVodkEycU84VlE3T3p1WEtZRjd0ZGdGMmxFNXk0MElEUnVjUzUyMXJL?=
 =?utf-8?B?djdpWXRRSE5KRVcrUG04ZlNaeERVdEp2VEMrRFo3SGtkWHRtYkdFV2RXdWdM?=
 =?utf-8?B?WkR6ZXNoc2JBalRyenNYYTJ2Y2F6MmZpSGJsc0dPdUttWVNyc1B0MlJidTR0?=
 =?utf-8?B?N3R1cjdseDZCMTVSYU1KUGFqL0ZDaXlPQUNyN3BpaG44U0pOR2lYSzRpWUFa?=
 =?utf-8?B?c01UekZTV3lkeENoTkEyendMQVVFWTcwZ3FLaFd5UWVMd0tLeE5HMmdyR3ZT?=
 =?utf-8?B?Unl6Qkxndi9hMExYVGF1Q3RiSjd0U0FTYkNHRTdpZDQvWGhpYUxhUnBYZm9j?=
 =?utf-8?Q?hGvKWc1cVJBAqhgX+lY3W50=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3307414-4ab0-41dc-46c1-08db15b2a97f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 15:28:49.7922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyxDaHRPXQWOjbV1Wx6jWmp86t/isd4EoOfx/MfuAV/r0uWe03DFWu0e5qMmm53py8rsaxSahBfKNb2i485euhsDUY6WtC7raay5N7Rtbuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5317
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

From: Zahari Doychev <zahari.doychev@linux.com>
Date: Fri, 17 Feb 2023 17:19:20 +0100

> 
> [...]
> 
>>> +/**
>>> + * struct flow_dissector_key_cfm
>>> + *
>>> + */
>>
>> ???
>>
>> Without a proper kernel-doc, this makes no sense. So either remove this
>> comment or make a kernel-doc from it, describing the structure and each
>> its member (I'd go for kernel-doc :P).
>>
> 
> I will fix this.
> 
>>> +struct flow_dissector_key_cfm {
>>> +	u8	mdl:3,
>>> +		ver:5;
>>> +	u8	opcode;
>>> +};
>>> +
>>>  enum flow_dissector_key_id {
>>>  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
>>>  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
>>> @@ -329,6 +339,7 @@ enum flow_dissector_key_id {
>>>  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
>>>  	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
>>>  	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
>>> +	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
>>>  
>>>  	FLOW_DISSECTOR_KEY_MAX,
>>>  };
>>> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
>>> index 648a82f32666..d55f70ccfe3c 100644
>>> --- a/include/uapi/linux/pkt_cls.h
>>> +++ b/include/uapi/linux/pkt_cls.h
>>> @@ -594,6 +594,8 @@ enum {
>>>  
>>>  	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
>>>  
>>> +	TCA_FLOWER_KEY_CFM,
>>
>> Each existing definitions within this enum have a comment mentioning the
>> corresponding type (__be32, __u8 and so on), why doesn't this one?
>>
> 
> I was following the other nest option attributes which don't have
> a comment but sure I can add one or probably change the name to
> include the opts prefix.

Ah it's nested. You can put a comment with the single word "nested" there.

> 
>>> +
>>>  	__TCA_FLOWER_MAX,
>>>  };
>>>  
>>> @@ -702,6 +704,16 @@ enum {
>>>  	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
>>>  };
>>>  
>>> +enum {
>>> +	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
>>> +	TCA_FLOWER_KEY_CFM_MD_LEVEL,
>>> +	TCA_FLOWER_KEY_CFM_OPCODE,
>>> +	__TCA_FLOWER_KEY_CFM_OPT_MAX,
>>> +};
>>> +
>>> +#define TCA_FLOWER_KEY_CFM_OPT_MAX \
>>> +		(__TCA_FLOWER_KEY_CFM_OPT_MAX - 1)
>>
>> This fits into one line...
>> Can't we put it into the enum itself?
>>
> 
> I can fix this but putting it into the enum makes it different from the 
> other defintions. So I am not quire sure on that.

Nothing present in the kernel automatically means it's good or approved
or you should go only that route. Write the code the way you feel it
looks the best and will see what others think.

> 
>>> +
>>>  #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */

[...]

>>> +	key_cfm = skb_flow_dissector_target(flow_dissector,
>>> +					    FLOW_DISSECTOR_KEY_CFM,
>>> +					    target_container);
>>> +
>>> +	key_cfm->mdl = hdr->mdlevel_version >> CFM_MD_LEVEL_SHIFT;
>>> +	key_cfm->ver = hdr->mdlevel_version & CFM_MD_VERSION_MASK;
>>
>> I'd highly recommend using FIELD_GET() here.
>>
>> Or wait, why can't you just use one structure for both FD and the actual
>> header? You only need two fields going next to each other, so you could
>> save some cycles by just directly assigning them (I mean, just define
>> the fields you need, not the whole header since you use only first two
>> fields).
>>
> 
> I am not sure if get this completely. I understand we can reduce the
> struct size be removing the not needed fields but we still need to
> use the FIELD_GET here. Please correct me if my understanding is wrong.

If both packet header and kernel-side container will have the same
layout, you could assign the fields directly.

	key_cfm->mdlevel_version = hdr->mdlevel_version;
	key_cfm->opcode = hdr->opcode;

> 
>>> +	key_cfm->opcode = hdr->opcode;
>>> +
>>> +	return  FLOW_DISSECT_RET_OUT_GOOD;
>>> +}
[...]

Thanks,
Olek
