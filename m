Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6685C6DE82A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDKXmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjDKXl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:41:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7AB40DB;
        Tue, 11 Apr 2023 16:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256517; x=1712792517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qxWpsHczDhSPrkGPdv4V9dRntKXjqG0NkSGY+c0hvXc=;
  b=DWyHjuZMXuOXUpUm0X79Pe4nxMGTaz/1M3N2DKgSzQuUZMpCSwjjwlqP
   uU+5C1BOZEvD3lgUqepWMo0meaLl1GWZKxTSsk0GTtesTgyJLxQffy2Cl
   p52eWLihmJHhQNawPKPJT9FzdmgqKLZ/8icKC3YMOpkEMOKhcCmnL3ot4
   lT4K5QQbdJ81ssPfDOThXD5TxHavZVfBpsNCxCykd6TM0n1jAbgcOXB+k
   RQ0kxXT3t0EgjA3by+mXxK740vM4meL936/HgOfSOHMIlDmA63skI+JTp
   WxiF6/e9byfq5IHFTa/IvSbu4wUR/y9rbspY9oIx1iJemqjuzDEsuv+Bv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="341248350"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="341248350"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="688751334"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="688751334"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 11 Apr 2023 16:41:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:41:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:41:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:41:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxdIpUKJTL3WTqVUNWRwtdHcofuvbw+oDrvMLpUNV+KZ0J+tvrBcrDPyWkGYLdthr9bl7STQgJPJYs2yJiqW0bdUaFTTZafk24YCN4hzwIGCO20twk58yD46OHOeCOKhpByzdalYfVQ99nQAOUY3OrhCxSN2BCHjy23sivbE0oSG7/A2UQSc6PWpKhG+y9C+scDILvqbVfSnQvHzBABnVjQNe6l2XqY2zk1NqyzvQZye2hiDCsAPtdI7JU7VEtVSPKigjb0UQU2OR5jTebyqot1HZn5PtRCu8urjmM3VurpWXibDBG7swNhXqw1kGYtnctpaYLLB8+h5UxixnQsa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jwfc3ub4IRt6p7GSBNQVp3E+XqMwaCuhPzYs3+ItLSI=;
 b=PwitO+VwzITgLWVKJm0js5vf0oauXjm7B1epgVe5d4FI+MCwM6nwmEaI/p+BofHhl4PTocizbDYPK/hNmsWG13RuvnMKAjutv3DzrldEPmZpvDLMYc8vTZk31p2HQefdPAs9wRapgv0o6KijpfUXN/Zg4HR00Qe8jePx2X9HI6aWQnVtDsQV8EOBm2SZhGvrt3jLSkEc1SM3mq+rEDZ6xOYYdm0ilIqom8kRB5t77zSl94J+FtKg193R26devtGbROdnLF8ZOZzrFtnfBGQHIm6H5w+9XKzkBV1aYWfnGMvq5JxIi5lSk3FLB19ajAz7d16uzAPQ9ksjKIPJTQ8O7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SN7PR11MB7044.namprd11.prod.outlook.com (2603:10b6:806:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 23:41:47 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:41:47 +0000
Message-ID: <40ae59b0-563c-b53c-1708-425ad2b2480e@intel.com>
Date:   Tue, 11 Apr 2023 16:41:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 09/12] net: stmmac: dwmac4: Allow platforms to
 specify some DMA/MTL offsets
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <vkoul@kernel.org>, <bhupesh.sharma@linaro.org>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <mturquette@baylibre.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <veekhee@apple.com>,
        <tee.min.tan@linux.intel.com>, <mohammad.athari.ismail@intel.com>,
        <jonathanh@nvidia.com>, <ruppala@nvidia.com>, <bmasney@redhat.com>,
        <andrey.konovalov@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <ncai@quicinc.com>,
        <jsuraj@qti.qualcomm.com>, <hisunil@quicinc.com>,
        <echanude@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
 <20230411200409.455355-10-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-10-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SN7PR11MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: ebd35904-3b48-4d5d-fc67-08db3ae65098
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJwnN2VutJFz//MUzmv8AiRGkZesFU/KXAUBDu0BumG7NR9rMLj9A/KYrgM1RgCQL8GcgsVDf4Dhf1y1R5X+JupTudas/9I03m/9GyKgZ/F8mY6Kc0qBGKpDvM0aEpqCCmelj3k+FbREdIcT1/9f4cjEIylKpG27651Kcc7fDNfjc6CgdPtsLnX7t/Nb7OAy+sROSh6i5JOnuKNtoOSFOKp2nyVm1rabXk61I2k61Re9TVOD15SBUtIGOOVF2NLV7pBn48BFMGWxmw93sk6s3tRPXDo3UZhyf1GCaxU59jxS6YalQI6jaqv/F6aq6bNF9g5RCq8jOkhG+mw+VAq1DVcKDebVi7PvXPvRfyCZvogxrneS07jGGEOfFwQ5wHTggJzhA4u6eC3GmYskgTuWQpbuJ5VMlzu9ZJKGjA8QlJQ1jiobjFn8DVopFC9Y4MkPkUptQjXMtUZvpugeX867i2l2cAK4JvDxCJ6Abe5tr1JEcYbO6NcNLQOg5wbZGOgvRI3xe0Ik7EukQSQDWslzq5/MrbTus2+V1eQCVL7t4NoFJpLrjdDFH1wg9LOIohsottSvF5HgsJJ7x9rlje3pDR3qkqs4BWJEgnjbb9FKgvRjqS5oxkdO7/KzGe7McFW/vK4itl7g7YXKxb0TXLRnlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199021)(4326008)(86362001)(2906002)(7416002)(7406005)(5660300002)(31696002)(31686004)(66556008)(2616005)(4744005)(66476007)(66946007)(186003)(44832011)(82960400001)(53546011)(26005)(6506007)(6512007)(6666004)(6486002)(36756003)(38100700002)(316002)(8936002)(8676002)(41300700001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmNpOTNDejhDOXpqUEVhbkhFN2V3MHBod1ZDcUh6Szdja3RqVTNxNktpMWUx?=
 =?utf-8?B?NXgvWUJDNk5yWm1PclVDSkkvMnBpZHdYTWZmTUdncUtmeUdsNmh6SWhocGFw?=
 =?utf-8?B?UlJ2Z2lpNWUxQXRsNjhhbktwNXkzKzZqYmlhSWowek4wSmFQSmgrK3pnY2FP?=
 =?utf-8?B?V0t4MVF3S3RKZTl0WXZ4SDQ1akJwT2JJWlNuc0dkTXBueDF3T0VQMGFWS3Zi?=
 =?utf-8?B?ZlZOMlNMcmwyU21DZC8vNU5oNjEvdXY1NVVUMEgvTmJ4eXJJdTFqQnFlSVVI?=
 =?utf-8?B?bjI1cyt1TFVwUnY3bms4V2VhWVhISG1jTGI0bHFUWkpsVHhDY1ExVW5HbC9r?=
 =?utf-8?B?emFWWWJKUWRUSzRRVHpRY0M2REhmQWRIdUp4aFQ3bW1FZnNEZTVtU0hUdXVH?=
 =?utf-8?B?M0NwS04yMzFHYXpYYmZicHo0MWpqU2Znc2pjUDJXc0x5a1MxK1NqaWhIZWMx?=
 =?utf-8?B?bjJpaHpQVVljaHQ5RGNOeU16Vy8wUDZkd1BOOEN1alowN0xpYzhBUEc5RjBs?=
 =?utf-8?B?RHEvdGxDZ1pwYXlTT0YyY01uT1lNcTBucExyR1JjN2pVeDdwYktGbDBCK1dC?=
 =?utf-8?B?Q3o0Z1BJczk4anlSdGxCVU9yN0hBMHhuTTBaR09DTXovamY0UmJZcFlRVUNh?=
 =?utf-8?B?eUp2enJ2TDhuTWFyNnd2Vmg5VDRKUTNxZjdiMmcwTHhVQ1JJTi9TMytPM3dN?=
 =?utf-8?B?YnJBZ0NsWlIvbVVlYWFKNXUrNGxNd1VIdHEzV0R1Z20yaThjYjlGU2Q2SDJa?=
 =?utf-8?B?MGFmRVAwbStKQTFiK0owcE1Tbm91ZGRwTC94dmtkWEZGcElIRVZRUDhkQmdR?=
 =?utf-8?B?OXBON2RJL0pzWWFUcGxLTURlYkFwYXFmRGxZOWtyWUdxUUF6ZmptcmpJKzc1?=
 =?utf-8?B?ODlTbWh6WHdUZ2RFUlBvUHpadHhPZ0dQcHhxT3hlV3RXUkFjY0diYVFsbUhX?=
 =?utf-8?B?Sk42U3N1L1lxdVdxd3VTVUk0cVFJMkdsREVqSGFSZ2pMS0xVVzVEMmczeFNJ?=
 =?utf-8?B?djZ6b1hKSTlzREd6NWdXdkpnUFhaQ2Z0My9ja3J0RDREN3JwdytvcGRQOUp5?=
 =?utf-8?B?djNhcmtpQWlyMEM0ZnU5aW90ZzNWNlprbHNrSUM5Z0tSWDk3OU5ISXVrVW1T?=
 =?utf-8?B?cVo2WDIxMXRoOUhJdlJDYk1SRnpFZFdUNkpFdlZ5UHA4QTJaNml4MHo2RUVp?=
 =?utf-8?B?U210OFdJeW1YOG5pejJETFp1cUI3c1Y2K3hwSmFwWlNBbGZZOTBEa2NVTFgv?=
 =?utf-8?B?NThiYTFKbVh4eGN2ZWU2Z1VNU1NjZHF0Q1BYWW45b2xRNE8zSnU4QmZGeEVW?=
 =?utf-8?B?Z3RBbGFUaXZEc2VmQmhON29ZellpQ2xaZlJvM2FqekVwc0I2bE1xUHhQSG5r?=
 =?utf-8?B?QW1XQ1BJRnByeXowTzhLNklBeTdZTWdpTCswRVExKzlmNjdVZVplV0J6SFRp?=
 =?utf-8?B?SlFablBXaDZWMk5yYmJQVU90SEtnZlU4MGVFdGlKbUJCMnd1ZExjNVY0WUhE?=
 =?utf-8?B?djRxbHhWQ0dLWHpPUXFlMS9heVhudTVBd1BqWFpZaWx1UmhMTVFJK2pJcWRZ?=
 =?utf-8?B?UkhjSzVyQktkZTNGZmdjVlU0TlB0Y25lUldVT2Nlbnd2QzI5K0NuMEJTY2Rl?=
 =?utf-8?B?OXBZa1I4OWVnQmJMbWNOK3YvOXBWdHdBa2FhbkVRSU5iQ3piUjNUYnhCaWdY?=
 =?utf-8?B?clpVVHM4OFVwTE1QbDNUMU03ZXIvN0RvWG9wVVNONjRvTWwxemhVSVNMWmVo?=
 =?utf-8?B?RmVKSm1abld6bUYwUEhaaWh5aXBnaHN1ckFmU2p5ZkRGaFZMaWJKTjhEU29a?=
 =?utf-8?B?RUxMYnhIUncrcUxzTnhPODNqaHJsQmxyaE9uVDgxTHVIUjloMkZLNlFQbENC?=
 =?utf-8?B?RlM0RTlqMzZ1dk9NQXMycE5USzFRQ2ZSTlkvR21xeDhsUmsyL29hdmQ0OGtV?=
 =?utf-8?B?NytNU0pzOXovZWtPTDg5Q2NNUVAyVWlma0RGTUVNK29EbDJpV1ZybDU1TUNh?=
 =?utf-8?B?ZmNLRFFRQlJHNWFwWjhaNzlLazIzUitqTFR1MmhHVFF4LzFpZVZYaGM1U2pM?=
 =?utf-8?B?ZmoxTW1aN2tZelc2OWNWckc4cVRTaG1SV1lGK3dBYUJxRE1ESStTaUd3enF4?=
 =?utf-8?B?clhOYW91a1pDUHAyaUViNnRuMWo5VDA2TENmTmExRGJhTmhmYndkU1UxL1BV?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd35904-3b48-4d5d-fc67-08db3ae65098
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:41:47.7245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sE5aOSBejnnTAC7WSEvy6OjKCh/7oIQxp57D8p7pTWJb0MgBcCNSoq8+zkUW84WugmbgM5SsRclYPBRP/lmuVngLYdNxsYAH775FccVwlm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> Some platforms have dwmac4 implementations that have a different
> address space layout than the default, resulting in the need to define
> their own DMA/MTL offsets.
> 
> Extend the functions to allow a platform driver to indicate what its
> addresses are, overriding the defaults.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


