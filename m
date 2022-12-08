Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD89164756F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLHSTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHSTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:19:02 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D5E4AF12
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 10:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670523540; x=1702059540;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JfyswzrmMXZMVUaWdR5vSokCBSBLQcNTdJnNU/NYYsM=;
  b=EcXLpz/G7/S3xoHo12is9EPdP0FUHYdg/FAxYCVxHP3ywrmJJFKnd8Hy
   Lg26S5OdI9Hrd+wTKFNJEVQRJJBAf69nq4xVWzdjV4RNWkPHPyq7cEA0P
   b+uCDcTpPIUMUa+XMCZRoaH/OWftoAbqBWx9FoOfvtj5ve3fdjjWEgxWw
   KZiaNVNnLW6gTJ9GNOF1jl/fyu5ssljx/Z2JjVHdfmgJ2TgYVRWP4Q4cB
   p4XkF7xnKHR2EM9K1Zxkq8wP+NI4hc4865g0N3pAUdW0J97yNRw9cUnMa
   qxZITGbTojFyJHHGOOBgIf6I295m8/IatdE0kCVIMgxVLA+VYloBGr6JY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317269103"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="317269103"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 10:17:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="975975967"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="975975967"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 08 Dec 2022 10:17:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 10:17:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 10:17:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 10:17:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpUBcIzwhkWSNIEZrlEItyJ+41Sv+fLEjLH220nyxr0RVMtgzmE41OGCgblthB92dk8v+fMUJ9ACOWOtA5rMM3ld9ipWzIjt5v+MacEYgfyv8gf5bpfwACuLRQYd/E8X81lgL3IgTixuFrC2fEROsckhbY7GcuJEZOz5CUkUXS6QjQJ18C4cN8XXHyXjbojCgVNnPpynNKuRTdkxCsQeM0pXK3sLMKiBixMiW5HWqdAnS3Le3jDEeBLL62JofsbWFL49wR70gQjMpcbVldzYUqBPpEgloAe0VtaAmG8WlJty53jLmlMHyAXY+YZyltBLDFto8+z/L8a1d8yVQXLfZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oDEWsgscfOTplxUyzYN09hFc24vVdtVQm3CyL9EVp4=;
 b=BoPwNqnGfuhO284jXEznrgwxwe/hO3zC7PMk2f82vt9bjvn8G6R/letjlP2NC/Q5uIW5j9rwi5RxhwpqKKvQvF6dnK1EKzMlM1dB94PD4ggQ4Z79gaR9v6BDCdfnotOUKLrExn0fSn//wVNyXSrLroGBQOUYY5rSr6vQkj9gdIetfJQCgV71xp6h0W0jtqCYSaK/rY/uIshmSaNE/73MkZxij74KRiIpONMOTPNUdeD9fl4oUSlLkpP9cDXK9XJJPbPkeY9qbOwuGx8CsJIi2AvvHfMEbDRIASxlmGl9kLMdTmsMNEMuzyNHJYGjd8oaUPFoWNLdnigkoYH+eeyaLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ2PR11MB7598.namprd11.prod.outlook.com (2603:10b6:a03:4c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 18:17:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 18:17:04 +0000
Message-ID: <864de21a-000b-5713-95e0-f71f536c567d@intel.com>
Date:   Thu, 8 Dec 2022 10:17:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v2 10/15] ice: disable Tx timestamps while link
 is down
To:     Saeed Mahameed <saeed@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <leon@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-11-anthony.l.nguyen@intel.com>
 <Y5El5C8EFQhU+Ukd@x130>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5El5C8EFQhU+Ukd@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0379.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::24) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ2PR11MB7598:EE_
X-MS-Office365-Filtering-Correlation-Id: 162baddc-30f5-4d94-f0da-08dad94868aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMHeDy9DRbXDBSvsupSWAjcwD8TzfC/m3miVfzj571JrqUyrX6oHLb34TBpEzuZeBH4Lb7S/zogdPT7v2TSNCJq/RAvJkczX//WOgR4LklL6UqjkjXV9UutXMZcxbJD4zy0+lojyWONemizUhEBRDc3zELwOZAEd5ZW2wc0ZtKODQK5ABbw9ewirGNFXaU1G3RckZLKCiPCJ2PwcaTlrLv/2QDJqq74u4qSmW18xsVrggLJQ/hlI3g+cLe2ha/CeCxIiD6afT2YlVBQXHbIEkDryW1KjaLJMcZRZxKgwd0kyseS1w62MjHGRKM2EDPl3uDK8Z9bg67SdXG+7PE3CPlEB5tKk6RzIeU6bOG6HkzYa0McW/yfgaYpePp/rPPD+I6mnmCSqUitzOhukNldBx76jkrYufe/jOU97z91JPlsBChHeKEjlTlDkygkcpSOeGZEKbGh83cx69JgrRJQS+y1gbavN0cmNUBhsJBFY8AB4TyPbDXRSysbKlGpCjB6GZfVY7DSUTIsxKeG5pJ73bUp+woy0OxjGm0o5BNp4q8uVx4N4kcRFVPYQTDtlifyW/WNL0apMRnYAgesHtXt/Aqp3JKl9XnL9/72n1dmRIwvz9Af4BpCeehpkwRAZMJwXaGM+6Bfwp5H3dqw/aoWo2ZEx4Tu7VpR7QelS1FTcAzc2nJsh1eO2uF0cqrejsA2MvYUbZCqBIWQTLUskCxg3MrhNQqljsyg68Gf5OA5ASlo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199015)(2906002)(66946007)(4744005)(38100700002)(8936002)(31686004)(4326008)(316002)(8676002)(66556008)(66476007)(36756003)(41300700001)(2616005)(82960400001)(186003)(5660300002)(6636002)(6666004)(110136005)(53546011)(6506007)(26005)(107886003)(86362001)(6512007)(83380400001)(31696002)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGZkY3pXbk14ZXN5alMrTUZVK1g4S2pwK01IRG5MQWJTQlNTVHNCM0NsTzFI?=
 =?utf-8?B?U1Rpcms0TjBXcElQSlhPd2lURTI0cFFueXhXU0tkZHpYQU1vcnQ3ZG55ZXZW?=
 =?utf-8?B?M2t4bHFJTURVNE9mbUFYNTl4NTY3Z2NyN0g5dzl6dmtqeG1XTGxHM1F5S2RD?=
 =?utf-8?B?MDlWcDZUanlnVllaTS9vMXNyT3ZOQkNQK2hWVW9FTU9jRUM3ZUhvQ3plWTlG?=
 =?utf-8?B?R0h2eFM2QzJvMzRiZVhQV2dHeVhJMUF0RVJoMi9nMHd0NVVqYkJQN1RxQ0Zm?=
 =?utf-8?B?dy85SUFGbFdhdEM4WXEzeWdUS042WDUyMWxuU1JRdWdBOEpqOStobTF1QWVC?=
 =?utf-8?B?T2gyQ2JLT2Fqc1dQOFIxa2MwdjBBSDN6MWNtL2J3TUZOamtjbWVRQzdQYU8w?=
 =?utf-8?B?OUFhNFN0dW1HOHVUTTN3bEZBVE5iTjVIVU1yOUJZZEtXRmN2K1E3c0Jrd1dv?=
 =?utf-8?B?TExCV0VOeEZjaVpVVytUcnhlL24yVVVpKytmL0dkU2U2UVdJeXBJU2lVcEhz?=
 =?utf-8?B?MVdseVhVT2VYYll0S1ZWMVpjZzZmampMYTJ3cFlDdndDaGdCNkVnRkdhZ3E4?=
 =?utf-8?B?U0N1SDkybWNxVXBmaXJuemI1dkl1Z1ZKcHhQMUhZaDFJYXU2ekZ5NEN4NzI0?=
 =?utf-8?B?c2hCUTFRck9HWHpCSG5QRVlDSnE0aCtVRndDYmZORjd4Q3B5K2tPVitDaTRz?=
 =?utf-8?B?ZmtxcUpSWGFWMFZxbHhPWHdIcUkvVWxOV2Zzd0xnQ01KSDVaaldmNjFtQnpO?=
 =?utf-8?B?TytES3hhN1VOK0ZhaTA1OURSNmFaZy9IeExFdnNqbkZZc1QwN0lMWW1YV0R5?=
 =?utf-8?B?YVJVUzJuOW5iMjZYS29BL3ZIN21NZmd1MUV4VSsySUJQcVNpb3BJd0pqMll6?=
 =?utf-8?B?YXY4UjlZK1FadnNMZlVCckJwazdtWVRQYkFXR04wd0FnbE1yakZ0c2xjM0x3?=
 =?utf-8?B?b2luYWJuSlNUamkzUi9ndTZSTUorTXZheDBFK2FuU2lxVG8xa3JWOWNweEJ1?=
 =?utf-8?B?SmhyeVpHZEppanErc1RVR09OZ1JQd2xYbTJZOEZMeTVoMlNxeGNPOWVHcUEx?=
 =?utf-8?B?MHhSOFBENGdPRytJT1JOd3kwQjNWbUIwa3VMTldieHJVRENERWlsV1ZnRlFU?=
 =?utf-8?B?WmNudUFKZkJ2YVhFRHdMc1lPM1B2Mmh2VWp5ZkRCRDU5WFFsR2pOSGhyOUVT?=
 =?utf-8?B?enZXV2tFbEhWWE1aRHhuV2xscXNzd21LSGxMcERZb3NYbkVUQkhaZTEwaDRl?=
 =?utf-8?B?amswSmJ1cmdqeFpoSkV2QS81aVREdHJOdWFBQnVpSkpzTmlDdlN5TzF5anA1?=
 =?utf-8?B?WENqS0JpekovbmJuWG5MOWpmeWllVjVPTFkwNkZMbzNMYXdQbi9lQTVXQXRT?=
 =?utf-8?B?Nld0K3lJYVRkVTZ4cUdFZU1nRmRVTWk2d3N6NEFrenJ4dW9IYWdkZEkveHhj?=
 =?utf-8?B?YWRURUFPZTlZaS9KYWV5UDA2UHcvZThPd1dQMzlJK1B5dUhTdUN1WG93ZkdT?=
 =?utf-8?B?cDhzYmk3TEkxb2s4NVZzWFJCWUJIajE2Z2dBb2tyb0YyemNLTHd1dUVKY3dK?=
 =?utf-8?B?UDd1SUJZN1pXQXN0aUx6ejVaYy9oMzBXNDlvR0VLaGN1WTZVWXRJOXVBdnNv?=
 =?utf-8?B?TXc2THJwRk5DZHJqd2pIbllmR2R0Tm9DdGdlbi9HRWFlTU9xdGFGYkI1dmk1?=
 =?utf-8?B?TXJNTnYvTlQ2TW1qZW1UZmJRbktCaWJLMy9lZ0grOWVObGdMWGVyTnJOMm1D?=
 =?utf-8?B?THV3OGVNSkw0RWpOTHRyM2FESnpXclNaZ1NoLzhxNmtCRjQrU01BSVJuR0NY?=
 =?utf-8?B?WUo5d0JrUUFwcnBSbkw0aGg4WEVnQ2NhbnZORnIxd3ErNkhJY2FLOE1oamZG?=
 =?utf-8?B?Tm1odkhWeG83Wkt6L2RrNTg3bVgwaERTaTJNdWVEei92dkRJcXlEQWl0d0F5?=
 =?utf-8?B?dTR3N3pCRXNPcFRqVkJYMHczdnFNZ2tiSWJWOU4xbHBsVmU5LzVIbHRVbjRE?=
 =?utf-8?B?bitCYUNNMXk1cmx6N3hFa0JrVUt4NmJhYW41cXFqQ1pWM1J6cXRZRjQyQjQ3?=
 =?utf-8?B?eEZTb1Q1RkJ3L0NpZklQaFRmcjFMU0NWL2xwOGIvejI2anAvWjUrMnEyUWhQ?=
 =?utf-8?B?QTd6YjlBaFJmbHYwY256R2Erc1Qwc05aSlc5UUVGOXdJc3lBYksyNEZ6bVhi?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 162baddc-30f5-4d94-f0da-08dad94868aa
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 18:17:04.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoJn8krEMeBxgAlpH9hUkF0nuD4v2AnSxJ+mWDLkFIcZwjO9bQj/obVMHT74fqsS3YeJ2171xkbXJlekLhZ+9x1NFCseAMA9DdbEL/qNjzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7598
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
> why not just use the same sync mechanisms we have for tx queues, 
> carrier_down etc ..?

I can't find a record of a specific issue this fixed, and I checked and 
can confirm that the netdev stack already checks netif_carrier_ok. Lets 
just drop this from the series.

We'll have a new one with the bitmap_or change posted this afternoon and 
this change dropped.

Thanks,
Jake
