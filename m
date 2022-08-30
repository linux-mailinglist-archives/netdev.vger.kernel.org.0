Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694C25A6E24
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiH3UJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiH3UJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:09:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5274DEA
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 13:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661890178; x=1693426178;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0mHNgQbyGaPeerjH/k5vLW++/r55pkjpWw0AwP4NlOU=;
  b=UuhYcuYjmaKATY2O17f4JjZjM280uIg//sWDFuNBx0EzWSDoQ+cSOnu3
   /jfKoFYmNsPHJVoy4RFGBWNaFigLZ5yFD37RVXVFK6ftcQqdcZSECHCfy
   R7tdsu/s0OEWIwt14oyc6J5qRUw3JzakFGvV/RuHqy8W/BpuG/5TvrUFv
   NhTFI1tomPPvTTAQAKhWZOSn2hnbGa7iaEuv8WT84+orLlZBaHzQRFORh
   JBAwyefIxF07TB5AFxRykGUeGmHhEu9X9Nx5tOLEIszfLvCeQ/VobzMGr
   YIYLl4VyFANqw/5OBf2icQnHf3/H4oUWESLLAv7rmxH+qnAn7P5g4krZP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="278307188"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="278307188"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 13:09:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="562789471"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 13:09:37 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 13:09:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 13:09:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 13:09:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 13:09:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKgXHXCMEbW0ofE0RBHHwhqK1r5wW+DclYJUr5y0i/8wycQNGRPV6wjuEjlb/CkWMv7l4FiPWQoT9PjQotxcC4ASGMynt9Y+Qeie3+hm7nmNPfxPNdpf6Ui5GWYnUXaGbh82v7GbWSNaCxmRykfv9NF1XYfMAGBl6NtzI7Hy1ZBmo4Oh6lcTKPqmurruHpXAUhxfHt7P36d9LDuUdSA3jDkCO57s5ed2uAYaS5WeGWBsXvFyKcLIQ5UQv+PhAvaCk9dcbRvEkFl8Fn1lcEV9wWoXJnz09bbQ7jIJWAO4M2e1f3xRXRJfFAHkGIw38yCTunx8rVPEMIS8Tb1LZOYubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWU2uNoiA/sM9mSYKuai5mBSKT6Au9pp8e4gcaX+yKY=;
 b=LNYlYVwHJJpJwHT3jeivrgMlO6dzwAXt9d96C/oRRJIGn2lMzB5Tn/xqsHSaVn2WB9nqrNhL6mlh69/x58qr4LcaQKL8yvHeUCIg/1QjuOTQTMj+YKOqjLza1/45q7l6TPmv7w6YJuf1HvpjxbAn5JKd8f8Id9iqPHOnmrGPn5qpNs7g+rKtyXUbfG/UjdmwyHYBhd9R3objrmeVTO1mLCVbeYNH9n4ubIHxeMsZ9U0atw7icNr802UIc2h0eTAsQyZQMHJUkPbxhKijm8ScFpDrgWQyArbe/tEgv69VIfjb5321+1nSDhQkwCwiQ1IuBKq9of/dSDfVerMWOXvMdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by MW4PR11MB6619.namprd11.prod.outlook.com (2603:10b6:303:1eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 30 Aug
 2022 20:09:34 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 20:09:34 +0000
Message-ID: <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
Date:   Tue, 30 Aug 2022 13:09:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
 <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
In-Reply-To: <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0189.namprd05.prod.outlook.com
 (2603:10b6:a03:330::14) To SA2PR11MB5100.namprd11.prod.outlook.com
 (2603:10b6:806:119::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58e574ff-0b59-42c9-efb1-08da8ac38e97
X-MS-TrafficTypeDiagnostic: MW4PR11MB6619:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVW/QThNFefBH/Gai197HcF74D/v0E4NTCMzWzuK1uSSGrdLM49msnY+a+za4fxbL3kSTDdARdk+KbG3OhpflNvN9cRWB3PQAZJs1sulonI8apYUj0wJepj+Cqd6GPcimU8BRBLEVAq3Q0HVje8IMaeGuTKMGFMjd2PDiOvRWhnpd2PXuPT117b1qH5H7nDJB6nQASCYUp8RGxMfB2fyUfYSzWmC1vbsgk60i0CMNEY6j/M67ImkpOYAPtQwQzJ4QZuiqMfoWaFxepKS8wvukNWCglXzzk257sQq2q+q1Nej50IoiS4GLEkcFS5ka7Gj4BuMEa4FRnHzRuvN//M+qeRaIsft8+so3k1pUEsb9GZzz/cuCOr4UFS6cRtA97XDSne91ZKOt3ior5OxTm8NHh0o2fqcAUJ+fFPPJtyknmWiaL+N2+NG8qUWhwajof+Sw5gDvkb/+uybbiz7t5j/RxHuu1BQSAbLLmX9MxAsiYnP+vOEbC0NOwhr3jpHrYfhdoQsu/i2cyagLsT48y8MqWpfFOn4g+uF+cxXO4B+j6njwyDs3B/o+P0UjTPhQpu2AaRXEKvILEU8RVHR7FtTURFO/vO+uhI9QCBMXjuwS8cEAWjdKlOFNvNSXVXJqE68gAdNn/zRjFTVaQdAMgBwdqc77cngE0/qzDHlioI5fVKb/vdq5oEZ+OLfnjqKWtVbjBNKrkRd1TMOJBGyEj+AK9GRpLdMN8z/LdUtOKKmtZrjWeVoKP2GmvTJjwpZBCspHN59IoEfhaYL2gO9Tlby2pg4/WoK32VUG9TbL5IVvYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(396003)(346002)(136003)(39860400002)(41300700001)(6486002)(8676002)(66476007)(4326008)(66946007)(478600001)(66556008)(2906002)(53546011)(83380400001)(5660300002)(6506007)(26005)(6512007)(6666004)(8936002)(31686004)(110136005)(316002)(86362001)(31696002)(54906003)(36756003)(82960400001)(2616005)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEpZZXc5S3YyUWZETHVaemh5QmgvWWVNNi9RaU43Y1p4WW1ITlArc1A2dVNY?=
 =?utf-8?B?RnROdWdMbm5EbHRJd2J6L3JqWlVBd1E1SkRCT1hWb0FseXE4dDJXSzh4c3p0?=
 =?utf-8?B?NFJCSHArVWZCanE0RGdWV2Q2QmhWZ1RENGRBUlBLbDZNS0JPeU4zQmRSWUY5?=
 =?utf-8?B?c2U1azJoZm05NVF3bkxqdUxJakxGSHhPbDhueHFoeStOTzQzUVZ4RVdhcDNs?=
 =?utf-8?B?RzNNcDFDWEZYcnV3ZVRRamE0WWdyTjVYVTl5ZHJETWpnd2h0S1VnOHJJWTda?=
 =?utf-8?B?ZThHZ0dLUC9RR2dhTzNVOCt0WnhWeUxLUjk4QlhZQVVxOFJkNlU4UkZUNVpu?=
 =?utf-8?B?MElETm9kWVpVVFNRYm5QZzlSOEx6WllHNHVxK1JRZFpZeXBEa2RkaVdXZm12?=
 =?utf-8?B?dEtxcnhwQzZ5UmpYZGlVNDdDVjJIVHJ5QlE2WERHWlNuRFVsRTBNcndkandI?=
 =?utf-8?B?cFkrd0pGaDdmSnBFVGt3Tmd3WTl3eG1XV1hkV3JrZktzYlVCREFTYUFqNG9j?=
 =?utf-8?B?RVMwZlVnTTFSa1FXWUlQdm42UFRZYUlKN0Rwcms5UGQ0eDZIL1NvdjM1VHJn?=
 =?utf-8?B?Yk5LeHp5RU9abDZmQzc4OE9qWGlGdENWa01qWVVKNDBxajJ4NUUrbThTQ0xm?=
 =?utf-8?B?VU8ySWg5cHVqYTk2WVk2bUlkYU13d0lmT2U2TlUxa29vTDRwdURjZmNXelha?=
 =?utf-8?B?TmlKNnhXOVNBejhDUE1yZFlZT0htSjBwUXBmclJwT3UwRU1pblc2NDJGbER4?=
 =?utf-8?B?LzVKczkydDEwb0NaMEZleXdFcFRXRTlDZHhTeGZuY0J5dnF1RVpoTmlBQnRu?=
 =?utf-8?B?MlJLSG1SK2k5QWo0RkhvaDlnWVJBSHlBUDdPWnpWTnVMa1UvYURvZFZBU2RT?=
 =?utf-8?B?djZMMkxQUmJlRm5JTlZra2w3WFk1dFVzL1dHQXROU0U2UG0zZ0hNcXBZM2kr?=
 =?utf-8?B?ME8xbnZwNmFDUk56VnBDQThuVjFCSVc5NTBxdm9BRkM4SXFZSGZEc3AwTEtj?=
 =?utf-8?B?Sis5b1lkTFcrbUVVRmh6cHFtSzBrYUVWOWpLWGl3TThXMnJGRkJ1OFZqVzdJ?=
 =?utf-8?B?NDE4RnY2dXZONGVta0EwWklhbVBZVXpmQTVlNDl2UE1BOVUrUjhoWldRN2Ru?=
 =?utf-8?B?NkQwUUpTdmVGb1hNTmpHWkZKWlc4R1QyRGtuYlJ1UVNGS24xM3BKNmVLQ20z?=
 =?utf-8?B?OXBkY3NhVjFXUWhHOUplYmFkaEdzeE5QdkU1WnhKVWhBME9MZldtY0VjL0Fm?=
 =?utf-8?B?V2orbTA5VnNQbXV2N2x4RUVuYTJ1NUJhZFpURmlJTzkzWHhENm5nUThIZi9W?=
 =?utf-8?B?a01zbVBpcnZWMkhlQm9PdDNrc240d0dVczFrdXJkYllvUEpna2UxYUVxZmVJ?=
 =?utf-8?B?ZitsNEY2MFN6N3hBeUdlUVdGUmZ6aUZqMVZCOS9VMnhQVkNXVElIMTQwLzQv?=
 =?utf-8?B?QVBJa0U2MVYrUWNhYkFNT3Z2aWt3akN4WnFqbkZiZVlnYTJJM2dTbXhxaW1R?=
 =?utf-8?B?YXRlMFBObHA0azdoWmdhSXBscmI3dGZWMDR2L1oxODgydDcrekZ5VjhuYk5E?=
 =?utf-8?B?cENSRkhtWllQYjlQYXNGQThDalpuK3lWZElNQW1rWkNPSTA3RmxTT2dWSmgv?=
 =?utf-8?B?c0RCbmVVZHBZMmp6UjJLWVMweWZjMS9RYXZ5dkY4a1U1d3B1V0Y3dVdldlc3?=
 =?utf-8?B?NzNUeFJHUGxTN0JSZ2tmTHVCZHg5ZlhwTHIzbmovS0JIbnppMUlRQm4xSHlj?=
 =?utf-8?B?Q1VMNHNmOWJOVVhzVGJRNlhWQ2U1UzhDS0xtazlEeDBGc1FETGp3ak5idjBD?=
 =?utf-8?B?U1FvR0Q0YTVMTFR2Q0NHNDI2T0xEd0lxNkdmbk5NZHpsSGZqa210MDVLQ0pT?=
 =?utf-8?B?ZVkySWR6WFQybHIrTFRlWXNJY3lNOWpZVkduOWhQN3RFMlB6MGNaQ2U4a1BR?=
 =?utf-8?B?YVFXNFl6WUxMV3huS1NxdEZQYm92bXFuWTdSdVBCR0ZDT1p0K3hmOWRFajRv?=
 =?utf-8?B?a1N2TG1YTGFzaWx6YWh5U29GczhPUGVNWktsZHB6cE5USFUwTkhrUHMydzll?=
 =?utf-8?B?UURSNHQxd0oxK3JhekdSRXpMcWxpSXVuTHY4ampyR1ZxU1F6cFUyV1hLTHJi?=
 =?utf-8?B?M3lRNHl0Tit6dDlLQlU1eDdFaHJLa00valU0dWI2dWFHTGxxODRFQ2ZkQmN2?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e574ff-0b59-42c9-efb1-08da8ac38e97
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 20:09:34.3798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLHUHsI/YTulGJuPBX4M2CYOUrWRL6oJ0CxWcODfPMzeMj4K6naa6zSZ3PYuJq++sDqPArxl6UNzsv7cyGA0q1CXiRpweNb6i6AEpOQBtec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6619
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/2022 11:10 AM, Jacob Keller wrote:
> 
> 
> On 8/29/2022 4:21 AM, Gal Pressman wrote:
>> On 29/08/2022 10:11, Keller, Jacob E wrote:
>>>> Regardless, changing our interface because of one device' firmware
>>>> bug/behavior change doesn't make any sense. This interface affects all
>>>> consumers, and is going to stick with us forever. Firmware will
>>>> eventually get updated and it only affects one driver.
>>> Well, the current ice behavior for every FEC mode *except* No FEC, we try modes which may be supportable even though they're outside the spec. As far as I understand, the reason we attempt these is because it allows linking in more scenarios, presumably because some combination of things is not fully spec compliant? I don't really know for sure.
>>>
>>> For future firmware, this would include No FEC as well. Thus, even with future firmware we'd still be trying some modes outside of the spec. I can try to get some more answers tomorrow about the reasoning and justification for this behavior.
>>>
>>
>> Yea, understood, but respectfully, I don't understand why we should go
>> along with your requirement to support this non-spec behavior.
> 
> My understanding is that this is requested by customers for a few reasons:
> 
> 1) interopability with legacy switches
> 
> 2) interopability with modules which don't follow spec
> 
> 3) low latency applications for which disabling FEC can improve latency
> if the module is able to achieve a low enough error rate.
> 
> We have a fair number of customer requests to support these
> non-compliant modules and modes, including both enabling certain FEC
> modes or disabling FEC.
> 
> We already have this enabled with existing drivers. Of course, part of
> that was caused by confusion due to poor naming scheme and lack of clear
> communication to us about what the real behavior was. (Thanks Kuba for
> pushing on that...) It probably comes across as a bit disingenuous
> because we've implemented and enabled this support without being clear
> about the behavior.
> 
> I haven't 100% confirmed, but I would be surprised if this only affects
> ice. Its likely something that behaves similarly for other Intel products.
> 
> The ability to go outside the spec enables some of our customers and
> solves real problems. The reality is that we don't always have perfect
> hardware, and we want to inter-operate with the existing hardware. Some
> switches were designed and built while the standards were still being
> developed, and they don't 100% follow the spec because of this.
> 
> By extending the interface it becomes clear and obvious that we're going
> outside the spec. If this hadn't been brought up this would have more or
> less hidden behind a binary firmware blob with almost no way to notice
> it, and no way to communicate that is whats happening.
> 
> I'm frustrated by the poor communication here because it was not at all
> obvious to me until the last week that this is what we were doing.
> However, I do see value in supporting the existing hardware available
> even when its not quite spec compliant.
> 
> Thanks,
> Jake

I'm trying to figure out what my next steps are here.

Jakub, from earlier discussion it sounded like you are ok with accepting
patch to include "No FEC" into our auto override behavior, with no uAPI
changes. Is that still ok given the recent dicussion regarding going
beyond the spec?

I'm also happy to rename the flag in ice so that its not misnamed and
clearly indicates its behavior.

Gal seems against extending uAPI to indicate or support "ignore spec".
To be properly correct that would mean changing ice to stop setting the
AUTO_FEC flag. As explained above, I believe this will lead to breakage
in situations where we used to link and function properly.

I have no way to verify whether other vendors actually follow this or
not, as it essentially requires checking with modules that wouldn't link
otherwise and likely requires a lot of trial and error.


