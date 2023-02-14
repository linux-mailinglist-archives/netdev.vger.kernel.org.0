Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58F169648E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjBNNWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjBNNWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:22:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8745265B3;
        Tue, 14 Feb 2023 05:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676380956; x=1707916956;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=//Tkd9cd0hxXdRVpMuO6SVsODqanSHErUkh6B7jEOio=;
  b=fJavqvmwdSrf8AH8r+nbL8ICoTYHuPEBZ6jWacRwlrA8C8/hAm6uo/ON
   Oi8NK2MgU05MeyhtogWfbdWPegO8+mo0EFsN/h2XX5iREC9eL8Kxp97Pr
   d699mgUc4JuU68tIzGbxqo8wNhRmL3s7fyOSDRdCi+VS0XKpxvS7wtz3Z
   mE+mX+9zlzzMmesKXIWBeTjLLIjBgPA6t/cFfI+S8P+wtA1b76Bmw6SbH
   nCgdyS89fC29wUBPTpQKvr6K1lkEQIYz9X17apOTjq5/fpR4SXJCFpq3y
   aAnav6cbHZ/1pjmjuPI0E0UXLOULeqgQVpe0yy9W/QHUAl1adYiDYzX8X
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="329783000"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="329783000"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 05:22:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="843167198"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="843167198"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 14 Feb 2023 05:22:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 05:22:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 05:22:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 05:22:20 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 05:22:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDXGeqBOJI4u7hc5tCuRjidqzahcZ2CtLBZt50KEduzh9YCXt4YeodJisqwwD3hDvLBuJsNn0FQ0nqdCSntXMqgfaTVzTFdOFqsUFppdEoBkVU3Sd3aM89SaDtfwPzOcDCnex6kpEiol0LiJuBNLM0fs16+DRUmweYVJHWDpw70mPvxL9e87cbcBrWcosC7Doqge2Gc8N+2pij3clUoIP9RTgbj80w+OjLRzUMUHTxUFmKVUned8l96UWJK9jrKSPPEqdtfB0S8jSOFPKgy14qqi1f7aDnCSIZn4AP0SE321Ig+vlSuydrMen5ogoOaMWoc9AGxz6k/GALEOaeHQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHwCQVo/h2EN3+nH1M/o8TeJSQBoRo8MaRz4HrdKvcQ=;
 b=Svhqn63SkdMfYkbgk2Tq28eUxZkFvsqrSgpNjhWXHI8PGNUTWYqOc/vt5tIu7nThPjy03dOP9l+3Bu4oiVbNDHbGlRGT5TCtOMd18Xgzww0mZXoV5tJF606m01KnckF3bWOQ1QsTnjKA97Y8t934RwsW8L5BEuDtp5eXdUhYMvdHWdUcXjgPx5UxxHzTRPcLAuzxpC6a1iOv7t4HhnUKnqg9gANsTGsEHpobal7wTBYkK7NUH+4NsdE22N4Jdp6oqkRvnIQG5q3LlbDxFlONeOITDgwmuaSgDE1SzKwmAjuXCDtWZMKj2S58eAM/m/ifIDIyRVvHQAHvxkwwDraP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5949.namprd11.prod.outlook.com (2603:10b6:510:144::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 13:22:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 13:22:12 +0000
Message-ID: <af69e040-3884-aa73-1241-99207aa577b4@intel.com>
Date:   Tue, 14 Feb 2023 14:21:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next V1] igc: enable and fix RX hash usage by netstack
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>, <martin.lau@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <xdp-hints@xdp-project.net>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <167604167956.1726972.7266620647404438534.stgit@firesoul>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df424cd-a7ff-44c6-6b7a-08db0e8e7b15
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDxc7Ex+p+sNiBMwnfxK3k7LzvHcXXhsZynt432LDTZpFVcWFvk+XXOAFZyf3IYUrg6X8f+EUCWNNNiEyoJsia/Dc/CgBZ8DCknkFQNiLUbLE5Nn4MEa40F7D3/YmR7QmUfLhM6wUMikoHoZDn11OihqT7NTIuOsNzsqVQYNanb6tMbj8gHHZLmu1zKD4DQDy/4jToyTnb1efwst+iCwus0YCGULaZdU5Hj8P70NuddZxVvEijT54mnZSt0NrY5JRin52eEVcwiJeCtrPuIyQmwhNONg7t/wPLnGpWjwfyhNF2VuNN9x4Iy9IXUdtxt1uBxy7Ni3qm1aAreG9Lf4pfJ7d5vpEbB6ILKSllBgGzIGuPcFDhmy3V5xUEO52266EhUv/4k9MpQ+wNNyN7TOesmLe74lb3tXmbcOyl28e4OQwg1H4ROURNlqTKNJtwxgTEDPmz2vfRLD9gDF2aZmAw+h03Yy51IDCdyZmBDFU9hYWh+MxFER4jzIzMZsFiLtQw7L4F2zFUNDAHC429tSAs4QbJsTgX+jKzhbC/4PmnzKtMgv1zJEmH7Sqngf5f7E1WcoWk8D2zsrK1xmFmeTd142Tb1hVZlfEcyhAmVukZQ5SRk4vjuhQzG11VrlTL4woXoExrrUcu9B3O28RAL7oW7xGzD/D4QW0euSPgmWJDeo+ts5N5Wdzb+KQAMEyo81lNVgJ84ubowVpxLLIoO75rG2NxIOpGUh1qA3rUr8C+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199018)(31686004)(8936002)(6506007)(4326008)(41300700001)(6916009)(5660300002)(36756003)(38100700002)(31696002)(8676002)(66946007)(66476007)(66556008)(82960400001)(86362001)(6486002)(478600001)(2616005)(2906002)(316002)(6666004)(26005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnlMMS9Ub2t6a25KczFKSUF3KzZFeW4rSHlGTDF0NUpMZkdtMjU0N3pZU2Vo?=
 =?utf-8?B?cDdOYTREZUlNZGtUcmVRM213bWhUaE5TYi96d0JqTVd2VE5jZVd6Qk02Sldl?=
 =?utf-8?B?cTNJakhHaVByUFU4cmVNWXlZSXdMZGxWSTZDTFZXT1hrV2lmYkxwMkFIV0Vz?=
 =?utf-8?B?Uk1OQks5Tngzd1Jlbmp0Tm9hNDNpY21SZTY3UGNHc0pVNmxic2hNNUxTbTB3?=
 =?utf-8?B?UnVCSmMzWmc5UVJ2VWVMVGVzS3UvR1JFSlpJNXJoS09NbFpxNXhtQjZQME1h?=
 =?utf-8?B?T0tyVThDdGN3WVh0eG9aRDZGKzBiSDVHcFdpVzUrS0VsT1VvREp3SnlWV0Vq?=
 =?utf-8?B?VmhRNlRQN1EvMEc4UGNBZnZxT2htTklaYzRKVHBySDJpWklFR2tIWnJYL0pk?=
 =?utf-8?B?R002ZFFGNVVyZUtBYkwxS2xaWkltd3NiVU0wTmZabGxXc24wbVZoQTlJdlhJ?=
 =?utf-8?B?WUc1UTlHV3VWb0N4VXhkcFdCajJVWDV3aW02K2Y0NlBZN2xZNGI4a0Mvc0Rt?=
 =?utf-8?B?RDF4VG1IMmNGSmNvQ1pick9iN0g4SFFMSnl5Y0NJdEhsWWltTVZkRGFJcUgz?=
 =?utf-8?B?OHdEckpKV1dYb3FHK2N4blNEVE40NFBrU2lwaXlxQjlGNlpmNy9YNDdyTUFL?=
 =?utf-8?B?eWJwYWVPS1lNenByNnR4eW1DV1dxNElLTlBUQ3ZHb25kc3htZWMzQWdETm1l?=
 =?utf-8?B?OGIvWU5mMEUwU1hTVnlpRm5kVVJFZndDSXB5WHZOOHhNbERKeEVhTUdNZDdk?=
 =?utf-8?B?MzhLUUJaR3p1TDlsZEZDZmhEcTFvdklZNjFJVmhMK1VDSDY0NEdmRlVuRlY0?=
 =?utf-8?B?eTVJZGJoR04yamw4Sk4va3ZZcGJEbjMvcjdTWlJmNlA1cWQyYkJieFRKbFNz?=
 =?utf-8?B?MmdTUUxlbDIrY1gwUGl5MVZacU16LzUwKzdMMCswSTRpazg1eWdNSFpmYjZk?=
 =?utf-8?B?YnA2elIwR2NiUWZNYUZGVGFFSXdHZlVyTEVwd0xOZ1BpczQ3amFtYnd4UmRv?=
 =?utf-8?B?c1JKZEYrZlh6NFBrSXlzZHF4eTBqeXlpS3JhR041WlVJQWFtZUQwODdXd2t4?=
 =?utf-8?B?b21PdDM3QlBLOExQNzV6bTRsUlJnVUVGTjhsQTZhbVBibjNHK3BqcWVlYTBh?=
 =?utf-8?B?ckVHbHB3OTZ5eEo0Mmh1WWVISldhMGt0STU4ZDh6OStLTTZ4bHZHY2YzZmtU?=
 =?utf-8?B?ZnJadWo1bi9Vb25BcUZRVE5hZDJaTktaT2VYb1NZYW1oaElLZGhNb2MrVlE2?=
 =?utf-8?B?Zk1aZmkzNVRXaFNFTm40bWZ4cEtUcm5UUU1QOVdRNWthclQ3MW1XZzBZY1lk?=
 =?utf-8?B?Q0ZDSlhOWUZlM2lUa3N4c3JqRml4b3owcHpNUzhHRVNiZHhLRXI3RTVIYWth?=
 =?utf-8?B?RGZuMUViYUdLUEFacURrVHo0L2d0OTk1b01LSXlYTFBLKzlVYWp1SWhnSWwz?=
 =?utf-8?B?YU1FRG1mZUxwbU4wTmJsYjA2Q1BkZko3ZGJLYmRXQjArMkw4NklLRU5Cb1h5?=
 =?utf-8?B?L1lhUkFOSGsxeUNhazFWZFJxeGNTdTNQbVY5Mi95SFJGMnJQWlpCNnlCUjA4?=
 =?utf-8?B?WEtkL0RGRHFvV3pmT012UkRkcXAzQjVCNWZjZnJrKzZYYStmME9SMnBOUzh1?=
 =?utf-8?B?bHpFblhLMm1vZjBZZnJ4aUVJak00Q3pxak1Vb1VVMEY1dU50bmcyWmZBbEZR?=
 =?utf-8?B?dnlGQ0djVHJ4NDhXelhMaDJpZnhaSEZNVUtlR1lMazBqdGUwZHBrNGFSWTQx?=
 =?utf-8?B?WUxLM3UyaGphMnlLclBQalRETEVHZjQrYWNNMmdCY3pPYTh2OTRzYk9WempI?=
 =?utf-8?B?NWo3SG5WQXlraDNscm1HcUJKcmRCNUw1RFpOc2JwYmpZMnN3S3ZSZkdZeGhD?=
 =?utf-8?B?VXNjc1J4TUs0SXBhUmZwWXVqV3FacnBjTjhzMVg5NjJiMXVRYkJNTjBaNUNn?=
 =?utf-8?B?dkw4dUNUMXZSSzA3UjVHbHkrYlA5SXdmTi9XNk9NYldGejRqdDNFTGN3WHhz?=
 =?utf-8?B?NlR2QWtnS2JGQW5DWTV6VHplU0QxQ0dZcGg3QnpFTDVnb3lZN1cybEhQZVlS?=
 =?utf-8?B?RWtGUHJOamt3S0ZRMmJ2eW9LTUFYSnVXcUk2OXhBQkl0UUpaVVJ3RTFnNktU?=
 =?utf-8?B?UEh6alhIS0loM0hENVYxOHo3VjI1MzFSK2lKMEs0bTdDS0tRaHJtYVNGNFda?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df424cd-a7ff-44c6-6b7a-08db0e8e7b15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:22:11.9015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6VvCtkEYA2sx6pPOB0cyl56MvKq8H2Zol54wCY3lwgIW1Rf5Xxer/7xvlLRBPhKB/KalTuhHMEQ5bsj1iYOGEmUeJaCE2gGr5tezPXzZzT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5949
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 10 Feb 2023 16:07:59 +0100

> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
> hardware wasn't configured to provide RSS hash, thus it made sense to not
> enable net_device NETIF_F_RXHASH feature bit.

[...]

> @@ -311,6 +311,58 @@ extern char igc_driver_name[];
>  #define IGC_MRQC_RSS_FIELD_IPV4_UDP	0x00400000
>  #define IGC_MRQC_RSS_FIELD_IPV6_UDP	0x00800000
>  
> +/* RX-desc Write-Back format RSS Type's */
> +enum igc_rss_type_num {
> +	IGC_RSS_TYPE_NO_HASH		= 0,
> +	IGC_RSS_TYPE_HASH_TCP_IPV4	= 1,
> +	IGC_RSS_TYPE_HASH_IPV4		= 2,
> +	IGC_RSS_TYPE_HASH_TCP_IPV6	= 3,
> +	IGC_RSS_TYPE_HASH_IPV6_EX	= 4,
> +	IGC_RSS_TYPE_HASH_IPV6		= 5,
> +	IGC_RSS_TYPE_HASH_TCP_IPV6_EX	= 6,
> +	IGC_RSS_TYPE_HASH_UDP_IPV4	= 7,
> +	IGC_RSS_TYPE_HASH_UDP_IPV6	= 8,
> +	IGC_RSS_TYPE_HASH_UDP_IPV6_EX	= 9,
> +	IGC_RSS_TYPE_MAX		= 10,
> +};
> +#define IGC_RSS_TYPE_MAX_TABLE		16
> +#define IGC_RSS_TYPE_MASK		0xF

GENMASK()?

> +
> +/* igc_rss_type - Rx descriptor RSS type field */
> +static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)

Why use types shorter than u32 on the stack?
Why this union is not const here, since there are no modifications?

> +{
> +	/* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
> +	return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info & IGC_RSS_TYPE_MASK;

The most important I wanted to mention: doesn't this function make the
CPU read the uncached field again, while you could just read it once
onto the stack and then extract all such data from there?

> +}
> +
> +/* Packet header type identified by hardware (when BIT(11) is zero).
> + * Even when UDP ports are not part of RSS hash HW still parse and mark UDP bits
> + */
> +enum igc_pkt_type_bits {
> +	IGC_PKT_TYPE_HDR_IPV4	=	BIT(0),
> +	IGC_PKT_TYPE_HDR_IPV4_WITH_OPT=	BIT(1), /* IPv4 Hdr includes IP options */
> +	IGC_PKT_TYPE_HDR_IPV6	=	BIT(2),
> +	IGC_PKT_TYPE_HDR_IPV6_WITH_EXT=	BIT(3), /* IPv6 Hdr includes extensions */
> +	IGC_PKT_TYPE_HDR_L4_TCP	=	BIT(4),
> +	IGC_PKT_TYPE_HDR_L4_UDP	=	BIT(5),
> +	IGC_PKT_TYPE_HDR_L4_SCTP=	BIT(6),
> +	IGC_PKT_TYPE_HDR_NFS	=	BIT(7),
> +	/* Above only valid when BIT(11) is zero */
> +	IGC_PKT_TYPE_L2		=	BIT(11),
> +	IGC_PKT_TYPE_VLAN	=	BIT(12),
> +	IGC_PKT_TYPE_MASK	=	0x1FFF, /* 13-bits */

Also GENMASK().

> +};
> +
> +/* igc_pkt_type - Rx descriptor Packet type field */
> +static inline u16 igc_pkt_type(union igc_adv_rx_desc *rx_desc)

Also short types and consts.

> +{
> +	u32 data = le32_to_cpu(rx_desc->wb.lower.lo_dword.data);
> +	/* Packet type is 13-bits - as bits (16:4) in lower.lo_dword*/
> +	u16 pkt_type = (data >> 4) & IGC_PKT_TYPE_MASK;

Perfect candidate for FIELD_GET(). No, even for le32_get_bits().

Also my note above about excessive expensive reads.

> +
> +	return pkt_type;
> +}
> +
>  /* Interrupt defines */
>  #define IGC_START_ITR			648 /* ~6000 ints/sec */
>  #define IGC_4K_ITR			980
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 8b572cd2c350..42a072509d2a 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -1677,14 +1677,40 @@ static void igc_rx_checksum(struct igc_ring *ring,
>  		   le32_to_cpu(rx_desc->wb.upper.status_error));
>  }
>  
> +/* Mapping HW RSS Type to enum pkt_hash_types */
> +struct igc_rss_type {
> +	u8 hash_type; /* can contain enum pkt_hash_types */

Why make a struct for one field? + short type note

> +} igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
> +	[IGC_RSS_TYPE_NO_HASH].hash_type	  = PKT_HASH_TYPE_L2,
> +	[IGC_RSS_TYPE_HASH_TCP_IPV4].hash_type	  = PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_IPV4].hash_type	  = PKT_HASH_TYPE_L3,
> +	[IGC_RSS_TYPE_HASH_TCP_IPV6].hash_type	  = PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_IPV6_EX].hash_type	  = PKT_HASH_TYPE_L3,
> +	[IGC_RSS_TYPE_HASH_IPV6].hash_type	  = PKT_HASH_TYPE_L3,
> +	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_UDP_IPV4].hash_type	  = PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_UDP_IPV6].hash_type	  = PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
> +	[10].hash_type = PKT_HASH_TYPE_L2, /* RSS Type above 9 "Reserved" by HW */
> +	[11].hash_type = PKT_HASH_TYPE_L2,
> +	[12].hash_type = PKT_HASH_TYPE_L2,
> +	[13].hash_type = PKT_HASH_TYPE_L2,
> +	[14].hash_type = PKT_HASH_TYPE_L2,
> +	[15].hash_type = PKT_HASH_TYPE_L2,

Why define those empty if you could do a bound check in the code
instead? E.g. `if (unlikely(bigger_than_9)) return PKT_HASH_TYPE_L2`.

> +};
> +
>  static inline void igc_rx_hash(struct igc_ring *ring,
>  			       union igc_adv_rx_desc *rx_desc,
>  			       struct sk_buff *skb)
>  {
> -	if (ring->netdev->features & NETIF_F_RXHASH)
> -		skb_set_hash(skb,
> -			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
> -			     PKT_HASH_TYPE_L3);
> +	if (ring->netdev->features & NETIF_F_RXHASH) {

	if (!(feature & HASH))
		return;

and -1 indent level?

> +		u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
> +		u8  rss_type = igc_rss_type(rx_desc);
> +		enum pkt_hash_types hash_type;
> +
> +		hash_type = igc_rss_type_table[rss_type].hash_type;
> +		skb_set_hash(skb, rss_hash, hash_type);
> +	}
>  }

[...]

Thanks,
Olek
