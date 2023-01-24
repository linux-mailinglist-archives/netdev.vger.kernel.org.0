Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18FD67A087
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjAXRwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjAXRwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:52:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB80049541;
        Tue, 24 Jan 2023 09:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674582728; x=1706118728;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ij7ONRpXo0i3enJFPPUMyDDXekRpmuCTr+eC1iIPvHY=;
  b=TvePt5tEaHlqsWQhT5MnUD/YnDlCvrnJKq5NfXkCZBTGum3fwmlRftxi
   c1RGFCjonkd5GbfRgbasJ6eDuZCY+i7kQkBAPGCV7RGx/970AM352iy0H
   SLsnbao+B9yPlBq/NI4/PLcqcgrmLBUyQ8bMKk+dS3fXtVl4Wlr9DjiQD
   FjldA9P47Q78RgWNEbOsgoMWL1JhSLLgdJ7LgjdWNVvS1lRBJjkMVmKb/
   fC01y3G09e3tT6otiy+e78jx3KcjiFWI/WhwpW36+UWXSkHRI7bvJCI3W
   UcWe82d4OdY98WGltr/vccW0T1KUa3qG0JkYqFsXPz3sUIBeVwXZSxgru
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="412591255"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="412591255"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 09:49:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="730763802"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="730763802"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2023 09:49:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 09:49:58 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 09:49:58 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 09:49:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RS7A/JjOYwvioMT/dEBujjy4KAxdLp1f8iNkfGxmXXIXFu1k65xj08sPLgU7v0Hk3Tm5FKx2wG6gAierZCgOGK9VC4+9z4NnfKLZRo2qSaCKgTlbnFaGGlgfFIj5oCCGf9H7gxblND5nYD9F+Pp2RZRjS92P/eArdFEFDGEmP2BRvKY4ELAJeZI9BFOslo+Hrri5vZVVI8ONHUdG2qFyoErbwnWYaI7ohu0x6kw9ImeZcfxvVdrsjNyiCLIklJ0S721W3WV9wHWDIPOTKd4BnUckNxo/Hfvkkmn1FJzrdNONv/oq4Pac6YAS0nh+IIXohxRq10KD9SEME2YXoow58w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uv0E6Q19IcN7HZAGaya1XVlB4t1UWS/PHA0fo+PSJNk=;
 b=hjT2+PpR3UZsKLWG0pC28q963vE6D7YABpvian6fo0WsgO1uDxFgzkXA7oXGTTCTrj1EIGue4H0y7cJDqdPhxeb1UiVIUZVGbV9LsBYhm/G3ZAnNV8DDVYfiDBm+kiK73r1NKJ5WZdIw5f1J9g5YTYurC5H7l23yYF3WjONXIjwZU+wb7lt6hyWwgv4eDxl1NmAZHiKa83pbbjuSSa7QJ63UEIQC/oqzk9ChRVOXeKThRv/wLOeXpIJPpuweNvcyNXlfNQFubTJ2p07o/0rWB93zb1WeAMhm5cmmO4xLSKMUfJ0PBwMyLkickTkGtu3j1A61KKBxe1raWiw5XdJqJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB5821.namprd11.prod.outlook.com (2603:10b6:303:184::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Tue, 24 Jan
 2023 17:49:55 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 17:49:55 +0000
Message-ID: <a16382e3-b66f-0a57-2482-72afd00cdabe@intel.com>
Date:   Tue, 24 Jan 2023 18:49:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v4 5/8] net: fou: regenerate the uAPI from the
 spec
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh@kernel.org>,
        <johannes@sipsolutions.net>, <stephen@networkplumber.org>,
        <ecree.xilinx@gmail.com>, <sdf@google.com>, <f.fainelli@gmail.com>,
        <fw@strlen.de>, <linux-doc@vger.kernel.org>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>
References: <20230120175041.342573-1-kuba@kernel.org>
 <20230120175041.342573-6-kuba@kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230120175041.342573-6-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB5821:EE_
X-MS-Office365-Filtering-Correlation-Id: 21c9d734-8fda-4b6c-4d39-08dafe3366fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lQUSUGq5dAjtjoZbpNJIxUJwR0pODEce4TH7iGnNtbJMZVmjySZuy9Mom/5Oppn7C+PhZ8rVJpsbbMMugOfe0zuTN2OKctmq6Hc29UU/DgYZ5Av4L2TQ195ij6qgWBjGGMNrlVCijTY9F9T0XJvuv2CaIkX86JQmTJNC/ipMroCWjQiui4AKm01WKZ8x5/u/SJr6lF6+OnBgoKCw9yh31gy8awsaKExxayu3A/o2RXkgScBeHDoZFKcYkG88MSF3v+mD76cRXbsFZfkbzuSr/O3/weSd8eWhF5qPp4B7c+/tz2hgfZM+F27FJjfPQ6Yq0gYXmek1Kcuv++VRelAuNBw7Sz0+h5KqQWPn3WnzpT9sPqmGpqOKCOOQo2vodof67cMY39dZIBFwX4yfpXRrngF8ach8NWXJAlH6aWGrK2NHGKr4DJMiQdIaTP3L4968Lz1p8B8riDBWzd7Z2IhbZ6eWgRjTuUgzCFfpiMoKUkOMHB3Cemw5YUdcCcmPc8BAtkmn8PiP4X9xfJA5CXQbts2L0YKOAb6n0Y/atDmieatwXUNPKhajYN5fHVIpLCZAFgtNXB+jSAHfY1trLzTVoDbqiSypWkMEfH3urZPUNscsLIgN54NZeP2Fy4fDkc35eovaeYKRlXABtpKOwGOFTo9IjoyZlenaARCbOq36c7613Eu0uN1bciHm+RmDFcAb1uAYCXJXcm8kw2SokbIz3BdY4aVz28Z5ozX+Ikt0Im8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(5660300002)(31686004)(8936002)(4326008)(4744005)(7416002)(66476007)(8676002)(66556008)(66946007)(6916009)(38100700002)(31696002)(478600001)(6512007)(26005)(186003)(6666004)(2906002)(6486002)(316002)(36756003)(2616005)(6506007)(83380400001)(82960400001)(41300700001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0Z5Rko5S3d6ekc2TUIwSkVLQ3FnZVBPcjhmS0dUTERqd29NQTRJRVBjZTRT?=
 =?utf-8?B?VGpZRkpLQllrWGRkc01yMGhESVRuR1FQQ01VTW4zd0dyOHUzc1FZUWNPc2o5?=
 =?utf-8?B?RGJpa05YRTNZMXEyTDVqeCtWbzVBUTFMbWFTUkwvdW04eVd1NS9Ma2RSY2lU?=
 =?utf-8?B?a0lWVmVqTGVRU205WWZDOEZMcDQwZHdSU2RLT2ZuRWk2bXdwazhwVFRKb0t3?=
 =?utf-8?B?MHhZcVkwRFV0REF5blQrOGhXZXZuV1JOQk1QL1gySnk3Z1hBM1V5bTh2VmZJ?=
 =?utf-8?B?NmJmTXBUK1ZpbURzRHN1c0pXbERPR3kyekc3UlJ6aVhydldqMVpNek0reDVY?=
 =?utf-8?B?UE5oQk1WZHUxSkV3MTVZeDc5djlMbTRHbUVBMzNTMUI5WVR2YnZpeXU3b3NR?=
 =?utf-8?B?VTZsN1BJL2ozWU16OXEyRlBoSllCZmNxSE4zdktsSHlHcGlEUFJmRnFqOHdt?=
 =?utf-8?B?RUhGT0VFa0FtRzFWYklKWkpoaitQSi9QTzFrV0o4QlVOaGgyWjRUZ0lPTXdJ?=
 =?utf-8?B?K2Nyay9BeitBbVlUcjN3WGRhclRpNnJaVEJ5TG5sU3U4dk5wTnBUdUhMcU14?=
 =?utf-8?B?N1FsNFg2MTBUUHBsdURaMTdrT3FidEZpZUxobEM4NCtSL0xkbVVWU1U4VUFx?=
 =?utf-8?B?eEhENlRnbWZLeUQyYWZFMTREYWZjbWs4VXhYTlVIdkhrdWwxbGNDdXNHRGcr?=
 =?utf-8?B?TDhibWdPT0t4SU9xZjMyZmhsdkdOMHo1Y3pjT3dnQWJwYzlzRE9ic0s4RFM5?=
 =?utf-8?B?NFo2RXRmbWNOcVhkbTJkYndXVjQ5RHhPaUd6cHcwNnZGWnNtVWk3dy9sV0Nh?=
 =?utf-8?B?UmdMeXllSmdjUUU4elB4aGtFRzJMbWN1L1FJUzF5M2RiN1VCdldYbkxWSXRu?=
 =?utf-8?B?SnozazFNNEtoN1Q0aDYrdFM2TkpscEt6blU0MlJJWEIyaVNaRC9zUGFYMEw1?=
 =?utf-8?B?cGRMSEZUWnFPYm9tVDFYcnI4YkFxWUtkeWhGQ0MzUGhLeXpJWmRHaDBtV3NJ?=
 =?utf-8?B?c3VQUldOLzdVZlR3YlhkM3BTSUtZTGRIczF0STZOUXZTMDZoR2JLcTRzQktD?=
 =?utf-8?B?WDFKbzNYUDJUTXZhSUcvb1B6TnV2TjdUY1E2SXF2aXBEL0lacFNteld2QU9v?=
 =?utf-8?B?S05udUM2WVAvYmQxa2xmRi9xNUJVLzZoa05SNUU5Sk51OEpDMnhmQlQrY0hF?=
 =?utf-8?B?VTFobDRPZ1N6ZndtUkxia2lsdHJiNThDMzRERnhzdFlPOHpMekE2My9RcHdK?=
 =?utf-8?B?cGJ5L2pxUFF2amExS0dmczQ0blpYSE1nSzJGMy93Z2xhVVZLcm00RUZHSVNz?=
 =?utf-8?B?a09teWIwRCtjM0ljelNzdHN2YzFDWHh4emhTYmZKQmhlREpEWGxTcXZ5RXJw?=
 =?utf-8?B?YkFBSXJ2cTFXVC9qa0ovZEJIcnh3MEo1akRwVE1ROFNQNFN0SlpQNndHMDQ0?=
 =?utf-8?B?SHBpRWZDTmZkUmgwaEl0SU5HY0NQb1RVVWd6VUxJZDhaSVlNTDF6UTZFN2VE?=
 =?utf-8?B?cmFVR3IxU2FieWhQQ2dLdFZBYy9zOTRjVnRTaHZ1YkdHMTB5R2Q1MDFKNjZO?=
 =?utf-8?B?N0s2eG5iWkhzVUIyYVoyZVVQU0V6L0duRHVlaDdnR29Pdjd2VitQN0ppRmNn?=
 =?utf-8?B?QWp6T2JQYU1ic25VQ3BTWFBOck8xdzNGNTZ0KzREZUtJSjdKdjVlbXpwMFo1?=
 =?utf-8?B?d05GeVZzZXUyRk4rRHhmRWJmNm9CMm81ZnRNbk9MbTVjVi9RWEhOdGYvQU9N?=
 =?utf-8?B?V3RtWGRxdEV4NWN4TTlhZ1E0QVVaQ0FrdmJwTmZRS3hCYkhwdTNOUlo3alhp?=
 =?utf-8?B?dHFEaysweEpwRmdvb1k2ejZYMm5jQ2t1QVd6OFNaUlZNczFNa0gwaE15V1dq?=
 =?utf-8?B?Y1A5SVBhRnFpL0NMYS9CVGo1ejFKRXJYZVJvSVN3eWZqdjN0ZVJLTDYrSVdY?=
 =?utf-8?B?MVcxWVZPZ3ZWVFNxQndmZ2Vnd3JFN2g5QURyK0NPNjNpbzRQLzh0UXhQbExY?=
 =?utf-8?B?Z1BVNGovb2xLYzNSdStLN3lObjc5SE1qcjM1eXhLRFRZcUxKMlBvK2JrOWhy?=
 =?utf-8?B?Rk51Q2tOaEJtY3VWTWZ6NVV6d3ExeG1KckJ6eGpvcEltNVRGdzRpS1NhRUVx?=
 =?utf-8?B?N3c5eHRZUDNKMko3cFlLekw3R0g2QUpwajVSNk4xcWFLWkxkRFdpNEx2K2FP?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c9d734-8fda-4b6c-4d39-08dafe3366fc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 17:49:55.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Z1ruRwIBbjVt6PACSq5WFupfYWsUVYU1nFd8kICz9LJqi7ewm3H8HPh7ef0vvNaHm/uT+G09DmJK5xLPK62l9bslb6QMkQn5yPchcfboi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 20 Jan 2023 09:50:38 -0800

> Regenerate the FOU uAPI header from the YAML spec.
> 
> The flags now come before attributes which use them,
> and the comments for type disappear (coders should look
> at the spec instead).

Sorry I missed the whole history of this topic. Wanted to ask: if we can
generate these headers and even C files, why ship the generated with the
source code and not generate them during building? Or it's slow and/or
requires some software etc.?

> 
> Acked-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/uapi/linux/fou.h | 54 +++++++++++++++++++---------------------
>  1 file changed, 26 insertions(+), 28 deletions(-)

[...]

> -#define FOU_CMD_MAX	(__FOU_CMD_MAX - 1)
> +#define FOU_CMD_MAX (__FOU_CMD_MAX - 1)
>  
>  #endif /* _UAPI_LINUX_FOU_H */

Thanks,
Olek
