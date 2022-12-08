Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B626564665D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLHBP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLHBPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:15:53 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C75880D8
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670462152; x=1701998152;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m2GQFi2jxNpyvH9SfoQBjL1nwXA7Kl2EYsFG2kH+i8I=;
  b=CkzS3XFVsTVZhpVXM1nSM8jNkF3VZY5smXTbjojZdIyt3S6BUjM10xIM
   imCm0Qwjg/lce3RpM7DyIlGrJE/CdlqT7UFNB1uE3m5HM/4TKJ1nb9f84
   lU7mnsZckGVddPSqlVm+QTjaUmw9xdQqdzPvjxk2+XAd7yM47wOx5Kzfu
   FGzcAAiX4MbHXEHcpPj08j8YlzqtG8s1Wq6kJuBMlX/5mjwk6c9d4X/zK
   8Ek10OFUdOFzImDHJVaZlFiwt+VKDa/YRyRmBQCS3bomc+24/19xVamcD
   t+gdOI/wRawRxa/CCsIPHQ1fAAqXhzDG0X+t1GIciadHM43lwGPmBX+5c
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304673805"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304673805"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:15:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="892021330"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="892021330"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 07 Dec 2022 17:15:51 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 17:15:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 17:15:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 17:15:50 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 17:15:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd8DGjQKDHhnRa1PbzjPJntYpSgb/pkpB8bS3yZQ+vRzHnEY4KQnF0J/2JaqHlLGg6dz8doqM0JJ0cOW5QGzGVSVz8qzGJDM8FBbS3S9wFDwObRu9ATKcpQFzRQFr25CH7ZJxYBPDR2mLauucveGF5yrCZQnG7g3U1EUV27X/i2qpy/C00Uz4NvecYJPbUeO+AggztrKpG8MjEpdWF5LzgwEjA9w82Xb9Bj9xTxuH0SoBcaiZ4zKyXIMPAAi8vRUiiqBgqJN4+X40YlXXEr8xxPBLocP/BlsPbusbSJDXUtmGaiMQ3UobVf32pvapwAIMfZ3BZQxvoQhDY1k1zYZaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nU1vlCXRgbpXIJUIR+dZomYZjoXTxq7xxN79idKEedA=;
 b=DqITwalqb1pWQv3p5Cx9Q0UclXJoxws5jDSQDOqtqiZxd6ZziJUxzF0TwCmn2UMoSr5KZsOdks4vo7a7e0M4Sbhem3xdDbQ84n3vJNFr4A2r5WDun/hWrvl+COvBLLlqtgL6oBO6jigUGfbrSAjcEEtCCS+f3ole+aH60l9Cs1c1a9TvaGva5ONTdIGiB61HrTIsKPGLu8zKnA+ET6/xQCqJad03s8J9TbyZbeofmZ5vQCiYZGihsoxXIBrqme7QfculFHL6PoVHYyJgcKZaMfSle4ZiIEJDfAbNTrCLYEBX73fFLcwvOjT3LHoHF0Ce4v5MBpNKHlR9+IFWBBDDZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 01:15:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%4]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 01:15:43 +0000
Message-ID: <c76fdcf2-29e8-c8a1-2c31-b33bbb88d625@intel.com>
Date:   Wed, 7 Dec 2022 17:15:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v2 10/15] ice: disable Tx timestamps while link
 is down
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <leon@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-11-anthony.l.nguyen@intel.com>
 <Y5El5C8EFQhU+Ukd@x130>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5El5C8EFQhU+Ukd@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:a03:331::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM6PR11MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c71fac-c273-4e2d-1cea-08dad8b9ba46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMf6D5KpG6t+btSXZqEFj4LMRutlt19uTFe+frT++T20zT8BrA7Pkuys6kcBTFaOIIGtn/RUU14LmRPdz1NWaJL/YDZS3JIEw2Z9XmE8cWdiqWQVKwV5gIFxTOFMex00KUltqNZlgbepCtMhuDpqYiY1LjFNupTFZXTeW63ZQjik95Sped7ofg0ESI/vODy1opoh6bVzvzE+lGoIbVrsP4n2GkaE1apdkZlBE0yZ1O0992OI5T3/dMCsHUQrxEph2cSQDO1fGdhmM4GSQCkfhXnOCZ7AljvQDRKyRZcqnnBPuCsKyOKcv/387xCfnX/cAEWYDRXDumLUPHtGKqv0MtfXYFUqGTChjEm6hZZRnWitocATOmi6vAjTacWW9vpN1Fk+b3MkxykrDCylQto5u5CFR9UDCHyZrv/UtF0qwUARYyMw/D3OJWAAu75auwlv7DfKvA5AYBCl4gGvgVdNMUM5Py4SnIFzvSX+bYHmSNSIDzJUN+mBJoRblniWhlKxPLEEB2R22LPx+kkvhIxVoZKD+3RdNG3RbXUTSIXBe/3oUEFzKrLbWyQqXQQy6zdIp+Hmg39dfzihMZCUJ3qlPmDL8SMg91FAXjn9gBnK8grQSHx0l9xqoU//qT7gAeSA2GmzaQKvDxjM1a4JQ1JB8ggmbpg39zaOGilD8/VhCtihmywhvcnTUw5HjosR8uOv5FPbh543Q5PdS48JFHp3Q3rsOR841vXTmSycOTuF8FQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(26005)(8936002)(5660300002)(4744005)(6506007)(53546011)(186003)(2616005)(83380400001)(2906002)(86362001)(6512007)(6486002)(31686004)(6636002)(110136005)(38100700002)(8676002)(36756003)(82960400001)(66556008)(66946007)(41300700001)(4326008)(66476007)(107886003)(31696002)(478600001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1JVVUZXbEJxam50cXhORXd2NldyQUpVbnFIaHcvaE9lVGp1ZzY0VGpDRXV0?=
 =?utf-8?B?cGozS3ZGTlJzaGNyMjhyOUJHLzNxS0lQV09QdXV1T2lQTS9HQUJCdEltWTlW?=
 =?utf-8?B?S2JZN3R2V0k5T3BhNWthVHdOdGZaUkpzSythbkdaeEZWV0lJZDJMaHRTSmFI?=
 =?utf-8?B?L0dnTnl0dFJBTHhROWd6YTZxWHJBUlUwai93MVBCZ1l2aGJTeDZ6bVRPai9r?=
 =?utf-8?B?aUNkZStVc1VMZGpFdWtWZUNiMEFTWWN4Zi85UmZIOUFTbmNvSjA0YzFFL0ky?=
 =?utf-8?B?amlJUVlwNG1TNXBNMTVlZk5oUVlnaVpkUjJYbXl0bW1Wa3JkS3M5cHZpUWw0?=
 =?utf-8?B?dXJ1REIwYzlCYlNQemtyaVpWREZDeG9XQlozN1Y3UUNOZ0srbVA5Um5HK3FJ?=
 =?utf-8?B?SE9QWmVZZkNsbzdkcVNPdTd4NmZiaUxtZkdXaEd4ZVVyOEpXUm9CNzBNR1ox?=
 =?utf-8?B?Z3RQSm5hZkxyQXpMV3hkSUJBQmR4VERTa0lrb2tOSGhPQmQzdGRwM0JjeGVV?=
 =?utf-8?B?cW9ldnE2R21tbGFVQUQwR0NtK1hCZndWekJieFRiL3I2MEx2RGc3RmlpcHI3?=
 =?utf-8?B?QWZTeVpzMmIvWWRlR2V3UDZnc2lPb1N6SVR2ai92RkJGUm1TSU8vQjUzaThR?=
 =?utf-8?B?dVRsVk9jUDVrTmV0UVUxaHpNRkQ2ZU1CR3V2VHUyTTJlSUVMMjNoVFVZUzFh?=
 =?utf-8?B?V1RTZnRKaUZ0cVYwVWp5Z004eE5YQW8xUVFjSS9hT0ZBckpReFhYVG0xajIx?=
 =?utf-8?B?Z2lFZmdUdjg4RGZyR01NbWQ4MWZqN0Qrd0x0L2QvcC9sR25mMThwYUlVTmQw?=
 =?utf-8?B?NXd2dWNmVWphR000NzZ0bThSUE1iUURqS0hwOW9DbE13bkRHK2c4VUk0NWl0?=
 =?utf-8?B?eXJFUml4dmg4SThLbk8rVkRvK0lrTzhob3JJNjQ5VTJnelI3TWdibVNHMzFt?=
 =?utf-8?B?clAwZEZtZHg1N2kyWW55aUJ6QVloUnFxbEFJamRucjBXWjFySFF5eU1XTEw3?=
 =?utf-8?B?M3NlZDVCNHFRcnF5ajdTTEF2UE5jYVR3ZWtSQ1QwMGM5UXRLOHRXWEFEcjY3?=
 =?utf-8?B?cmc4YWRhZjNhbTlCTC8wRTh3VFRGdXhaa0hWVm5tdDd1b0V2T0t6MWVTYnJi?=
 =?utf-8?B?WDRjY2ExNlArZUJxWEFEaXVqbFM2c0Q5RTZOajdxaXBRSE43MWVua2Y1bmda?=
 =?utf-8?B?L3lmR3d5a3VNaDdqTmF0ZnJXRkxtRE9RelI3dW9lZUNDSUk4NGZlR1A1Wk5j?=
 =?utf-8?B?akh6WGNOeDZJNUpWK2lQblNJeGV5VEdVN2RTUUVZcFBTaGV6Z2R1MFNpcFZ0?=
 =?utf-8?B?TS9uL1BuMVpubXVhQmYxUk9RMEEyNHVYQ3F5emk1MW9uY2NLeXVSRklRUUZs?=
 =?utf-8?B?K3BPZjB1cWdxaFZxdUtNVkhBVEthRytiNHl4c3lxTEhQN2hNT3NOdGRncGNG?=
 =?utf-8?B?MlhqS0FDRlRKZmdqdW9sRE41eFQzU04zY05XWlZUaGNRTXVpUVdPMFVSZHdy?=
 =?utf-8?B?UEpGc09HdnUxRXhXN2tpMGdTNExPNW85eHR6V3dWYTZVVFY3QWtVaWpraklI?=
 =?utf-8?B?dnVhNVZTZGZzd1JvcmxHR3h2Z0JZNTVPdFE1bTJsVWZQMkc5NEgwMmxyZ1Bm?=
 =?utf-8?B?U1RUZ3RyVG1TWitLY040VExWSkFzTXhhcFAwb2I5Zmw3NWJWcDdEdEpRUjZD?=
 =?utf-8?B?dnYwRE5ZajM3M2ZURy9mMERCZEdoUnpzSi9yWmkvZFNZVFowVWZBcXlJejVU?=
 =?utf-8?B?bVV3QnloVTB4NXdDeS9kSXZzb2dxcFRPSmxWWnJlMkpTeEJ3QmdOWnZpTHRH?=
 =?utf-8?B?OTNtVUJvNE16aGphbCtGNDRBM3dlOU83WGNZL3Z5cnRkQ3FzK2FIaVM5VVNY?=
 =?utf-8?B?QTRPMFpkSS9nMjhsUDZIT0xBak5WZ1dWV2ZlZGRSUFhKbU8va09jaEJwQllN?=
 =?utf-8?B?dGlRamh5Q2d3aW84bnFHb0FHWC9KaUl6VytNOVNYL3BBMG42aUZ4ZVhpMkhy?=
 =?utf-8?B?Z082cnpONHZSUWJ5VDA0c1RyYnI5NjBPQk94NFA2M05HdkNrV3lMSUtTQlZH?=
 =?utf-8?B?U1plZ1ZWMnVZcjJ4cHFMWk1Sbko2ZWt5MktHYm9uM1VQNTI1clJvY3A5dDRt?=
 =?utf-8?B?K3h2Q2RBL3l1S1dxalBrSkVoV2MySVZ5bFYrMEJlZ2tYYXg1TSticHFmWEli?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c71fac-c273-4e2d-1cea-08dad8b9ba46
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 01:15:43.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqSoLa35aOpH2C369TjUm1nOOgvJVyxudLOot3eWh3Io67ScO6DzK5iNnMByFbO5yqDJq+wBG0WvXUGPL9QzJiXbF9HKaBW44snXR9/jRqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 3:46 PM, Saeed Mahameed wrote:
> On 07 Dec 13:09, Tony Nguyen wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> Introduce a new link_down field for the Tx tracker which indicates 
>> whether
>> the link is down for a given port.
>>
>> Use this bit to prevent any Tx timestamp requests from starting while 
>> link
> Can tx timestamp requests be generated in a context other than the xmit ndo
> ? how ?
> 

As far as I know, there is no other way. Only the xmit ndo routine.

> why not just use the same sync mechanisms we have for tx queues, 
> carrier_down etc ..?
> Anyway I'm just curious..

Hmm. That's a good point... I'm not sure what caused the case where we 
began a transmit request while the link was down...

I'll have to check into that.
