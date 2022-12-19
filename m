Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA96D6510D3
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiLSRAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiLSRAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:00:16 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3755B12D37
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671469216; x=1703005216;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7gZ6CWlDrkmOzlYQL6tV+lKmVBbeCcLUD9VEpTNDYYs=;
  b=DPiISmTsuS3uQIXYVBVUnW4ilCeKBHgwZwb88PULa9rPElZ7l2Z+VfC5
   m3tBYZgYU0PoaQaIjpszcYDmWfKLdP57LwU1mNFvGG5tQ1yfvnOcDbhkr
   XBx8EZuXwpMF8G7FwDx8GfFvegyWeBsvVNvEW0zgc3TVlBgULFJBjOWSV
   ox3w4SljoC5qBAWEzMaYpqTqQgaWYfKvE+fEuRLin7qwr/OUM9D0uDJpd
   Ob2Uh6hlu3DgFl3TOEuJQd0thrpRFHv11c5NzY2VwlYVFHhS1qW1IbQOe
   5A6uwsDPbqzllWENffljo4wB1LpgoOGUWIGgH+UWe6HDe3ZrQnCgIP84U
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="321293446"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="321293446"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 09:00:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="650589047"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="650589047"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 19 Dec 2022 09:00:14 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 09:00:12 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 09:00:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 09:00:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 09:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyUuGXlJjMxCNvtqvq48uOQgRQ9Pg8/+9uVuCcZ2DrLviI+WFFKX+Gu35NKkf2ETjbch8z2DCfNTqclIMHmJspIAUbqLsRXYT3qtqEQiG35pCFBBEGEe73L5edCkdZwXtdLwj+k+U5SIfXRxC068Aghqd+c7avxAkSggTKjgRIgPCsXr5oSpiefqLgUP+KOcip3eMD0kdWFamTufHZtRwd+lrQXYi6c7yy06U/tlTr6FNEZBZcUd7JVNuNNJzrQywjfWECv8yCdgUtJqs0LacWSYzD8OohwelQeJ0X+lWK1rdwFOAnf1XnF0zTaCOvjkVpJpVjmZPRv86fWxyNjo0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gZ6CWlDrkmOzlYQL6tV+lKmVBbeCcLUD9VEpTNDYYs=;
 b=WmYjZWj4J1QBWxTQAVk9KUt59TqXrASMpdL/uVoS0yO/udMX3LyhoO60QT+5k5PfB6ZkwzbegqJxiVoGS4u+J6YJp8T/8yuKc6mFA7ox8n5UkwvfRjbyK74w1bTxwdidGPw2jKKnzT5gG78WZUkok9SxCivybW5v+5WIa3VkHnjXl0rkyxQKfFRUgPv5Ohvp2JLcQt0JwiVUznDf7qFMLiiNt4Z3kTCrcGCAwnBGH3lzaiDFzFPHNGHK63oBsyos4MYM539o1Nd7d2QuAOWEsnQpp925PX8Bc6SIZB6T0j0fJ0dnCuttCfIVyPcNgiVtj3DNBht/dm2RjQeDnq2uSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SJ0PR11MB5599.namprd11.prod.outlook.com (2603:10b6:a03:3af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 17:00:10 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::1d81:371:eb0a:cbcc]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::1d81:371:eb0a:cbcc%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 17:00:10 +0000
Message-ID: <f72d0049-757f-af8d-5378-49cccb7f4e3e@intel.com>
Date:   Mon, 19 Dec 2022 18:00:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: iproute2 merge conflicts
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ffeb2330-9c1b-2ec6-e5a0-bfdd614b3fb1@gmail.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <ffeb2330-9c1b-2ec6-e5a0-bfdd614b3fb1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0172.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::15) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SJ0PR11MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: 156ac9d8-26b6-484f-265e-08dae1e27d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sppztSvGKFugi2fAv4iPagfP3teTyOCJaaLsZoU4jDahryqhnQIWPFF0WMYU8z40gCmzAvmu0uAS8ZlOWQYlFioLuO1h5mf5Bsai0tnQQaM87TcfMWI8BjkihUzEOgrOVTyJoH3Qg/HmMsI0UyhDPTwHO/mGeTq01o8PyQKcKQjKaOv9xN6NTL8vQLJQ/HbnyVVJe+oYNmMIKkLm9sfR5paD5CSOQbgg/CHzOKWTM1N5+l5MXEmbWyCbay3v6bhJW4/Kg25haRmbci2FTPlcUsXkVIK8PqVQeUuarolorSkedggZSmFElCO3lgy8g+cABsF3leeTqEiojrHdyiivTh3elhgvSPydh99QUq37hl+8Hv4MCYOuxSireqjGLQaLAomNrAQdrnK9a+WRESDLdjuRxJk8Lyj6HbhI01shMI++Y/HHY420KdtoH77dHoJKx+OQwodqYK3X4Va+FtQ2pE3WaGm+4+yRxZxK7whNSiGRSZdCBVeuHWHyRHUEmIO2s1yhUe7gIr5WdMZLeAZMDgZiNmIWi1cf4fFTn5SVK/N4U+kzEt2i7B4DIOdjKSdbXB3A3uTJB2Bs6yEItzWmBpPuGnYe8yLuWhevScxf8W9ShU84NBp3j4AQn4Ve1eEmGBB2EmvjOwf7PEu+bmnE3TQyS3qlZKe/1sZncAKFLNif+9IuDwolXAfOTnHahpDXbqx5ucUjUElf85ozEqSwuAO89XgCwILNena2YbfXFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199015)(86362001)(83380400001)(82960400001)(31696002)(5660300002)(4744005)(2906002)(38100700002)(41300700001)(8936002)(6506007)(6666004)(6486002)(478600001)(6512007)(2616005)(53546011)(26005)(66946007)(66476007)(7116003)(186003)(54906003)(6916009)(8676002)(4326008)(316002)(66556008)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG5BS01aQkNCZlp4MEFtMUVXaEUwTTdmNFZzSENBUDNuUUw0K1Mvc2g1djJG?=
 =?utf-8?B?eTRsWnJFdlpwdHJWcnNPREswSDlJVFBVY21ON3hKYURobTI2N1o4Ky84aFBR?=
 =?utf-8?B?dnlsQ0xwWFhCTHFWUDYrVVVpcHRxMCsyelJBODBNQ0dhb2VvbGtGbzlVbGE5?=
 =?utf-8?B?eUdXY1ZKay80WGlNeUVpMkNPTGJJUDZPdmg1elh0eE81UjZtQnF5eDh0ZjQ3?=
 =?utf-8?B?cXpiUG9kcWdLb05odUVZY2FtVlFoWnM1WnZ2eUF0T3hlVzB6S0ZuL0VpdzVH?=
 =?utf-8?B?OFVWUHgvOUlZcWdIc2JYYmdma2lYUmVjL2JlS080V0hIYlJNbHVITHRETDIw?=
 =?utf-8?B?bjNYVUJpQUlxL013THpQTEl1b0QybmlsQjY2MDdYMzc4ZHVQQ0RVOFN4SEdw?=
 =?utf-8?B?d0VEOTNIN1h4K2xqTFBldHhvOVdtbFRmaUZpc2VOSnpSYXVoaW9XMm9YdVRY?=
 =?utf-8?B?Vk0wa25IVElVbHBtMFRIQS9TOTRtZkYybDFoaTNDbzBMZm1jN1hucFhCeGhX?=
 =?utf-8?B?N1R4aVlMbXFMaHJlcVcxblRWQXFpYWxUVkhHVkVsRXlLOGhjVHkrU3BBYkxk?=
 =?utf-8?B?OVNFanpaS0tDZi9JbGJjSGt3S0JVRXlDWEQwajNzQ1R3NXBvZllRaU5NUmFD?=
 =?utf-8?B?RU5ma1hNaDVnTmZoTnJ3eEZZSU51U3VzT2ltaUIwSC85NGVLZmw5M1loSDVx?=
 =?utf-8?B?WUpNOTJkNVhYT3BjcE82MFNDdHVXNkw0UGRMSXVFckhXQ3VwUjJsRG1zaC9E?=
 =?utf-8?B?UFVxYWVxM00yTEYzd3doQXR2YmpEUUZLS2d3VURyZ1VnMSt4VTJzaHp3clpT?=
 =?utf-8?B?R3VXdDVkempWL2RQU0E0OUdmcjJPbDFBb3FQNFF0NTkzeFZSYUh6aXBub1NU?=
 =?utf-8?B?VFdxeER6dGxTUDJsaS9KSjZ3TEk5L3h1V2xNSXhiSUZNaDlGMldxK1F0cXh5?=
 =?utf-8?B?NG5yYlNVcWUwa1lheUhTYlduMm96ZXU3UXBpSXNFMm00OGFIN0h3S0ZMYUYy?=
 =?utf-8?B?NU0rRFRnM2RuVDZLV0NwcU5hS2FRNTk0VGNqRnhPVVhKdlJrSit1UG5kNVdS?=
 =?utf-8?B?Z2EwVzJCSUsvYUJtR1RJS2JBN0o1QTJxcW1xbEZzNksxOU9iazNXVGQ3SGh4?=
 =?utf-8?B?ZkNSaTBGQk9BRXFMaGw1MWo3K1BTZndTcm43SHozWjF6VW0vU0liRkZuY0JC?=
 =?utf-8?B?dUZFZ214S01MUWpUeUE0dDBiSnA1Y2tIcWRtUDlsaWNoTGQ5MmRsT2FIN3ZF?=
 =?utf-8?B?bzdFVTVlV0NBd2lWd3RNcHdubDlmRkhyN1NoUGFsRFhOMmpndmhtSjlIRGdp?=
 =?utf-8?B?UWVVai9HNFB3a0hhNnh6M0JVazlhK0RwcnZwdjVKaGJ3L2R4UXBPTnFTb253?=
 =?utf-8?B?RS90VDF3N3ZQVHB0dHVHM2VaaE1mSDc1UEU4NU0zejZiSkxXNXN1L3U0dFBy?=
 =?utf-8?B?czZrOUVvRmw4V3hyM1Vva3FmRmtZQVVTa1NkV0lKZkR0bllFYkpoUXJjY1dU?=
 =?utf-8?B?bFpjL1R3NnloUkJOcitIMHMzUFpQSDRDeGc2aEgzK3ptYkxTanZXYlJGdmo5?=
 =?utf-8?B?VXVESmFRamhNREwyeGZKVVpSUmprR09oSVVhZCtZYlIyUjF6b3hReEtlUVhR?=
 =?utf-8?B?WnRwdE44Rjk5a0l0VU93SkpSSlcrMnBDWm1NSytqUkhmeU9aNzlHV0tteXpG?=
 =?utf-8?B?M1RXQ2FFdFJ5dm9iWnNITW44L0FqWk9vK2J2YjJnUEFMcFhST0pPRFhrdkNy?=
 =?utf-8?B?Z2tDY1JyQk1MUDhadHlVQS9oZDM2LzRHa2ZCcy9DTHB6VFUzMVJnajNWOVhj?=
 =?utf-8?B?R3hiZmowbUc2dDAzaXUvOHJCRWM5dnh5V3hMNVF0UnhGWHZBbnFvWmFBUE80?=
 =?utf-8?B?QTZrR2Y3bFB2SE9WZXN1M2VLaWtGTXhybnlGeS9CdUtKVHpidTJ4b2c4a25v?=
 =?utf-8?B?S1hnUUJPYTZZQU5aNms0Y2FUV01wNmwrVUl5YWd1QUZqd1hPd3VvUjY4bXNV?=
 =?utf-8?B?cFR4MEwxUGtNYmxBYk5qRFpTd1JUMDlPM3QzSldsMTRnWlIxSHE3cEFHZmZM?=
 =?utf-8?B?TStKWTVHM1ErcHRHU055VkJ5bW92SjAzZjhnSmdOTGU1dGJ4dFdIdEZ4cmVL?=
 =?utf-8?B?TUpnb2svRkVCM0xLaVFPQm9HR1B1QWxHNVZXN0M5bThLQWNJU2V0RW1ZRWJQ?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 156ac9d8-26b6-484f-265e-08dae1e27d0b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 17:00:10.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/7v/Jip8aAxRiUwBM+Maxc8Q/GLvsHuckXDxv96ANYErdr1dllks4r0F5nByCa+56NE4B08XJoTe8U9t60ecUtL1Ms6Jnx8myxSnUBn38k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5599
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



On 12/16/2022 5:14 PM, David Ahern wrote:
> Hi Michal:
>
> I merged main into next and hit a conflict with your recent patch set.
> Can you take a look at devlink/devlink.c, cmd_port_fn_rate_add and
> verify the conflict is correctly resolved?
>
> Thanks,
> David

Hi,
I've checked the file and everything looks good. The problem was that for
net-next tree I added two additional flags in a function call. And also submitted
a bugfix to net that added one more flag in the same function call.
BR,
Michał



