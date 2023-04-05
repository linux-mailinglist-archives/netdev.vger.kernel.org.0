Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52AB6D71B4
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbjDEAvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbjDEAvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:51:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C2610C6
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680655871; x=1712191871;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Go1sdRd1Udjp9nOvQKvjrcQ9+W3cB+b715wIGdpNepQ=;
  b=catQHm027eAPgoB9aRsMnuS0Gvzwqmzqt4MiMAYRE+DZ4hjAP2NFI/r1
   SeoqBJ7XRvSkSTPJG6Szf4lD6bZ+oIDM9ZgXvgE6ZMud1j9c9fXEov4Jo
   /hocyh0ZdzlaLBJO3XPYxrM/oeQwbhVtG9rDwPfguFZZGiqz+EHMGDexX
   /LK4jdVfeCbap2cDzZXuvaAFX+OmpJWRpeuNAGBqbo3pj17SVK5fcMjXF
   W9qqt0dpnCamUf4rhkuBWpBMyb8O3BXdG/RRzZtLOBNzT4yDm920IS/Vk
   rS3PuGmRb7Ce+ovGwH5bqYu5RQTyQjVKNEzcDHWPsaeOK4/DUV8dLrYGi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="341066662"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="341066662"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 17:51:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="932632710"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="932632710"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 04 Apr 2023 17:51:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 17:51:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 17:51:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 17:51:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 17:51:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB3st+EQSq9VJhkk/KLamXymEauMs+XyNWmAk7juvGy7NNtjx1CQdxhYewjvN3MxXPx53xoAo+1Ux6fIr8pp/MiObHAqyYAY1RCaP0X7g4bIUhhv0dNVB9/r8q8270U47+aTVJrpxck4DC1+UXd8I0iF5nCevK57gEhkJ//XPCy6kmh7UMLg6oFImN5Esji9IW/lgYE6XF9MLNIzuVeAUqANGGtMtPQNYGdwqi53WwajJ3V30+ChilM479hAoIIBIbKo/a10guq5aYw3YYoyNoVAKOUY5xGU+gBM8QhXAim9vnPlIqzMDSpxlBc6Lzi76NmaZ43GvM/A2NMp2hjZ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFJfX2F4h99JU/nEDxKbPOnUyzlwLbY1HBd4DOEjscc=;
 b=ZpwMy/6kZLjG1GhoOWaVPWgEimBOBUujRKRLGLnK4j+qcH2zNDhaUCYYidB+gftkuF2s2CgzpXARTyyrEdty6dhbS3GGMHpGysSaTK4hyzrri5ItSLBuslGFj+yVjYEpn3/DcKOcNDE7zSx+jWvbu0hg4tzl11C0j2bACSSo6GPQrUrUvuBWEkwZjKpgs0fuBY4TbNCfNLtJuPIXE3UQ4xmXMXAGzASAHiWzOSZ1in588McXkSjnJuqQgffOcOZw6zygF3x14ZEC4xsVJKdhVTXEW2kVRsMQ/fUuwapETABtsVLIAmixMfc3M2KD7DyZYdZ2TH947DRizKgjfT1fZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Wed, 5 Apr
 2023 00:51:07 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 00:51:07 +0000
Message-ID: <d342bca9-e586-7733-c73b-33531c49baf8@intel.com>
Date:   Tue, 4 Apr 2023 17:51:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [Intel-wired-lan] [PATCH net-next 12/15] idpf: add RX splitq napi
 poll support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <shiraz.saleem@intel.com>, <willemb@google.com>,
        <decot@google.com>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-13-pavan.kumar.linga@intel.com>
 <ZCW3gFQStgYJRTBn@boxer>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <ZCW3gFQStgYJRTBn@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|MN0PR11MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dc363f7-7db0-4bb1-c347-08db356fd700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ghAvnLqPdUSIT0RuGrFQk+Tel0/7HILpBL4g7td53Lo5pP6q6sL83XZ5cHFQoIO7kT1/Sb9IXee1+UAwIXQxNQg/JfERm+9STYAkOg22adew4hESC7aJ+QKAtNEPup1RqHIuKGpWD7mER43FfKcF0g2PYkCGZUtCLp1fee42HIYTTLZ9B7eQfpicvSVHF/kC0Zd7jaP5cWaSM35aSoxEwMh297OY38wblZ6IbYlONCkvA17ZoX2mGS9dlj8+kL7Qxj9IIm0U4wFMnMra6N5eGablnKi0zg5BU2Z6RV1Q3bj+wZ803/WxCpK7tieT7q77dUPJglJp86j6g3iTQlxZZSfHU5E6Oilk2wCDijeUVMHt8goHbvgJjYMF7hPQGcUDUbHDphZ37tmlRR9+PZznoU4TeR5stO37pHKamApjqJsNx7jBqqLccw3C4/MZ2Tj3jmAZym9q4NHU8Hm7QUkqvAD2bQTzGmtVePetCmH9XCSwB2Z5nKChlXY29W8re5bFEjyAot9bS8//3nAQ38S03wvv9/Rm+6/mvePEgW/v9X7P55NAScPWVHHMxJx6bHUTH5Qd3eilbrijlffv+xU3loDBxwk6Z9/3ZQjeQG5b99ms6T6B5hCfI6a+Bz4Y3RhT0P6F2grkbNrODyhPfj82a5BoifViqxv1G+mAOinxo711tvAfjq/0RhOTsaOIpp7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199021)(31696002)(2906002)(36756003)(31686004)(86362001)(83380400001)(186003)(2616005)(53546011)(6486002)(6666004)(107886003)(26005)(6512007)(5660300002)(66476007)(66556008)(82960400001)(478600001)(6506007)(66946007)(54906003)(38100700002)(41300700001)(110136005)(8676002)(316002)(8936002)(30864003)(6636002)(4326008)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU9UUG1KUmNiV0J6Z2JVN1pHYzhVNlp2MUNHWldPMGd4bTcxc3FVdEQzYzFq?=
 =?utf-8?B?Vno5eEgvbW44NTUwbzNDek1KWmZDdmJmeG8zd09VWHlkZW5hVTBPWEdDUi90?=
 =?utf-8?B?YTFIcUw5SmtucE5qTEdIbEZabHlJVFJBbGFYL0NINE9tYUhzVWxDK1pQRTNa?=
 =?utf-8?B?K1g3VzMzSVpoZ0dWYXZTa09KWnpwNjFiRVBzUmxVSzhYQWFLMEZJaEU5VWxS?=
 =?utf-8?B?cCsrSlFUZGhCUFN3VVhLNHVPci9ERm4yUE5SMVlneDBYeU1DSlRQNWFudFRu?=
 =?utf-8?B?ZC9hTU55SUJqa2MyWjlwMUJDQTJXblFyRTJ4TlhodnJ0NnRGVDNXNHp0Qnhp?=
 =?utf-8?B?SUhhUEFzVU90cEgvNE5vdTdPaEVtU0x2blZFSzI0R3B3aE9uZmNGb1JNcCth?=
 =?utf-8?B?a2pNQ3Z6Sjh3SkRrWEViVVlGTlNVa1A3d2grSVhaLzBvenFrZUVDdlZyZ2sx?=
 =?utf-8?B?aW5kMm1JMFJqTHIvQXRwSXd3aTVJVDgwakp4aWdXSyt3MmhqZ1FUSnNWN256?=
 =?utf-8?B?SVo0bmRGenVKamMvTlN3Y1lhdm1WSUNROWFud21kbDRWOTR4d3BkYWlyOXJQ?=
 =?utf-8?B?TjN6SFgyMFBKQVYxTVoxMTRESFpQaTZpK3BpUjJiRFVkVTJLUXVtL1A0ZU1j?=
 =?utf-8?B?anIxRDVYdTVKQ2ludjczdkorTy9nVkNWK1lqQ0FJV0NhU2ZXZGdqZ0xTWXk5?=
 =?utf-8?B?L0hPVW9JUkFRYkJxME12bTZmV0RXVVZ1dlVaZG5UdEFGVVFZR3R6SmtLNEkr?=
 =?utf-8?B?UXc5Yk5zRVJ0S3A1dWZPRGpUUjdQanJySURKM2JLRFJ0QTZtN3NhdWFzOFIx?=
 =?utf-8?B?V0ZRVVF5RzgyQmRCbFpDT21qNFE4MEZQcnZGeU5xKzRCY3VqcmlsRlZ6L3VY?=
 =?utf-8?B?QnNOUk5NOGdrOHdjWGRITzZ1bDh5aVpwNVdCVEFiZUc2cnYxUS9UVjl1YnpU?=
 =?utf-8?B?TmRBLytmcm9PVm5NSXd6VVBTOFN4NWF0NFNVR2xYRzcwRmw2T3ZPVWh2eTFR?=
 =?utf-8?B?eUY3a0k3KzI1eVVrVFZyVkpjOU5tM2YrbHY3c29vQXphaFhGQlF3ZSt4cm5Y?=
 =?utf-8?B?OHdma2RWV1Rmb2Q4eGE4dkV2TThlVU1wVmZwMUp1amNoVkdWM0FVWU91ZzFi?=
 =?utf-8?B?MzF0bGp0NlpkTVd4UmszbXNKSTJ4YWp0SkdLSVE3dFlqN0hsaFVrUm9Fd2pv?=
 =?utf-8?B?WWFxVXV3elZSbjZYenRTaDlYSnlUdzBPZEhNcXhmdkZ1V0RrQ3JrV2VnTXM0?=
 =?utf-8?B?M1F0Z28veDRCcTg2c0lpNjQ5bmI4bnY5am5FaGQ0dU4wckRNZXIwb3pBMUFw?=
 =?utf-8?B?akE3KzFNSnp4TDlBeHZ3VnQyVW8xUVczUnE0WEI3clJrU2JuMnE2MUxJQ2Ru?=
 =?utf-8?B?YmZ6UnBWQ1lLRUtrSW5Wc3NIQy9VOVZrWTJ3eEc2UnZmWXBWSzEyQVZGU3Nn?=
 =?utf-8?B?Q3l0bHpJS0R4M0dEd29kcDk4MUFCTTJaMi9ZVXFYZ3RJSDB4SFF3MVVseUdJ?=
 =?utf-8?B?Y3YwVHJNN2hkV256bVhwQ0ZvbFdXWUlhSllVZlI5d2ozbTJaZ09MeWtiRzZY?=
 =?utf-8?B?eXFyZENZMHNOdkFXbGo1STJZZ1RzcVFMNVcwcDg2bFRjaFI1OVRyVWp0Z0t6?=
 =?utf-8?B?NnpoYnpGaDg5Y2FjMFpnL2lPZ2JENmtKZVpOU2Zjdk1ObkZuUG0zVGJiTm1j?=
 =?utf-8?B?Y1AxZUZCQ3pETjBhYlBvMGFGNEtzbWViVWNiSnBnNVkxT3dRblU3WnMzaHIx?=
 =?utf-8?B?SUU0S0w3b1FhT2lQcjJOS1IyZDFoS2cwMStqcFZYaWVCdDdHUTFZNmJta2Mv?=
 =?utf-8?B?WThxZXI2d1VEdjBoYWF3UUpFL25FQzBUbzhIQnRCVVdlZklqbnVyUDN2STB5?=
 =?utf-8?B?dnRiNEZsUkJqNEZEcWVaVjZhUEdxanE5N3dUUVQ4dDhIMWxRN2Nja1dVazJE?=
 =?utf-8?B?RE1VTlpiWXQwcFdEeHBaZzRLSkVTQTFid1M0VkdKalc3VUV0WUUvbDV2RVU2?=
 =?utf-8?B?ejNycFA2MUdpOTgrUkIyY3NvbHBVTlRNOGVxRk81blMvUFdvWC9tcG5Fb1Rt?=
 =?utf-8?B?dzFIQXk3SndxTEVucmRUaFVRTXRpUFBWa1RaeFk2WERXOVdiS1ltVld2SWNN?=
 =?utf-8?B?S3F4dS9uVU1qUWhIMDc5SjNmRkFPSUV5K2d4V1QyMTdvSDZWbEc5YWJrQUQ1?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc363f7-7db0-4bb1-c347-08db356fd700
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 00:51:07.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caXT+/cM7hfEdxBvM/03/9tvGfZlNK+zcAwrWV8V3IKr2q/Fg3YF2S4dAlTT1rgb7XIfEfs2NWWFtmzH5/8i57AQg9Zver28ttp+orX6dC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/2023 9:23 AM, Maciej Fijalkowski wrote:
> On Wed, Mar 29, 2023 at 07:04:01AM -0700, Pavan Kumar Linga wrote:
>> From: Alan Brady <alan.brady@intel.com>
>>
>> Add support to handle interrupts for the RX completion queue and
>> RX buffer queue. When the interrupt fires on RX completion queue,
>> process the RX descriptors that are received. Allocate and prepare
>> the SKB with the RX packet info, for both data and header buffer.
>>
>> IDPF uses software maintained refill queues to manage buffers between
>> RX queue producer and the buffer queue consumer. They are required in
>> order to maintain a lockless buffer management system and are strictly
>> software only constructs. Instead of updating the RX buffer queue tail
>> with available buffers right after the clean routine, it posts the
>> buffer ids to the refill queues, only to post them to the HW later.
>>
>> If the generic receive offload (GRO) is enabled in the capabilities
>> and turned on by default or via ethtool, then HW performs the
>> packet coalescing if certain criteria are met by the incoming
>> packets and updates the RX descriptor. Similar to GRO, if generic
>> checksum is enabled, HW computes the checksum and updates the
>> respective fields in the descriptor. Add support to update the
>> SKB fields with the GRO and the generic checksum received.
>>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
>> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> ---
>>   drivers/net/ethernet/intel/idpf/idpf.h        |    2 +
>>   drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 1000 ++++++++++++++++-
>>   drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   56 +-
>>   .../net/ethernet/intel/idpf/idpf_virtchnl.c   |    4 +-
>>   4 files changed, 1053 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
>> index 9c0404c0d796..5d6a791f10de 100644
>> --- a/drivers/net/ethernet/intel/idpf/idpf.h
>> +++ b/drivers/net/ethernet/intel/idpf/idpf.h
>> @@ -14,6 +14,7 @@ struct idpf_vport_max_q;
>>   #include <linux/etherdevice.h>
>>   #include <linux/pci.h>
>>   #include <linux/bitfield.h>
>> +#include <net/gro.h>
>>   #include <linux/dim.h>
>>   
>>   #include "virtchnl2.h"
>> @@ -262,6 +263,7 @@ struct idpf_vport {
>>   	u8 default_mac_addr[ETH_ALEN];
>>   	/* ITR profiles for the DIM algorithm */
>>   #define IDPF_DIM_PROFILE_SLOTS  5
>> +	u16 rx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
>>   	u16 tx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
>>   
>>   	bool link_up;
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
>> index 4518ea7b9a31..8a96e5f4ba30 100644
>> --- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
>> @@ -339,6 +339,11 @@ static void idpf_rx_buf_rel(struct idpf_queue *rxq,
>>   	idpf_rx_page_rel(rxq, &rx_buf->page_info[0]);
>>   	if (PAGE_SIZE < 8192 && rx_buf->buf_size > IDPF_RX_BUF_2048)
>>   		idpf_rx_page_rel(rxq, &rx_buf->page_info[1]);
>> +
>> +	if (rx_buf->skb) {
>> +		dev_kfree_skb(rx_buf->skb);
>> +		rx_buf->skb = NULL;
>> +	}
> 
> can you elaborate why you're introducing skb ptr to rx_buf if you have
> this ptr already on idpf_queue?
The pointer gets some use in single queue mode, but we can probably look 
into cleaning up its use in split queue.

> 
>>   }
>>   
>>   /**
>> @@ -641,6 +646,28 @@ static bool idpf_rx_buf_hw_alloc_all(struct idpf_queue *rxbufq, u16 alloc_count)
>>   	return !!alloc_count;
>>   }
>>   
>> +/**
>> + * idpf_rx_post_buf_refill - Post buffer id to refill queue
>> + * @refillq: refill queue to post to
>> + * @buf_id: buffer id to post
>> + */
>> +static void idpf_rx_post_buf_refill(struct idpf_sw_queue *refillq, u16 buf_id)
>> +{
>> +	u16 nta = refillq->next_to_alloc;
>> +
>> +	/* store the buffer ID and the SW maintained GEN bit to the refillq */
>> +	refillq->ring[nta] =
>> +		((buf_id << IDPF_RX_BI_BUFID_S) & IDPF_RX_BI_BUFID_M) |
>> +		(!!(test_bit(__IDPF_Q_GEN_CHK, refillq->flags)) <<
>> +		 IDPF_RX_BI_GEN_S);
> 
> do you explain anywhere in this patchset GEN bit usage?
We can add some additional comments to make it clearer.

> 
>> +
>> +	if (unlikely(++nta == refillq->desc_count)) {
>> +		nta = 0;
>> +		change_bit(__IDPF_Q_GEN_CHK, refillq->flags);
>> +	}
>> +	refillq->next_to_alloc = nta;
>> +}
>> +
> 
> [...]
> 
>> +/**
>> + * idpf_rx_buf_adjust_pg - Prepare rx buffer for reuse
>> + * @rx_buf: Rx buffer to adjust
>> + * @size: Size of adjustment
>> + *
>> + * Update the offset within page so that rx buf will be ready to be reused.
>> + * For systems with PAGE_SIZE < 8192 this function will flip the page offset
>> + * so the second half of page assigned to rx buffer will be used, otherwise
>> + * the offset is moved by the @size bytes
>> + */
>> +static void idpf_rx_buf_adjust_pg(struct idpf_rx_buf *rx_buf, unsigned int size)
>> +{
>> +	struct idpf_page_info *pinfo;
>> +
>> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
>> +
>> +	if (PAGE_SIZE < 8192)
>> +		if (rx_buf->buf_size > IDPF_RX_BUF_2048)
> 
> when buf_size can be non-2k?
The split queue model uses separate Rx completion and Rx buffer queues, 
the latter of which can support both 2k and 4k buffers.

> 
>> +			/* flip to second page */
>> +			rx_buf->page_indx = !rx_buf->page_indx;
>> +		else
>> +			/* flip page offset to other buffer */
>> +			pinfo->page_offset ^= size;
>> +	else
>> +		pinfo->page_offset += size;
>> +}
>> +
>> +/**
>> + * idpf_rx_can_reuse_page - Determine if page can be reused for another rx
>> + * @rx_buf: buffer containing the page
>> + *
>> + * If page is reusable, we have a green light for calling idpf_reuse_rx_page,
>> + * which will assign the current buffer to the buffer that next_to_alloc is
>> + * pointing to; otherwise, the dma mapping needs to be destroyed and
>> + * page freed
>> + */
>> +static bool idpf_rx_can_reuse_page(struct idpf_rx_buf *rx_buf)
>> +{
>> +	unsigned int last_offset = PAGE_SIZE - rx_buf->buf_size;
>> +	struct idpf_page_info *pinfo;
>> +	unsigned int pagecnt_bias;
>> +	struct page *page;
>> +
>> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
>> +	pagecnt_bias = pinfo->pagecnt_bias;
>> +	page = pinfo->page;
>> +
>> +	if (unlikely(!dev_page_is_reusable(page)))
>> +		return false;
>> +
>> +	if (PAGE_SIZE < 8192) {
>> +		/* For 2K buffers, we can reuse the page if we are the
>> +		 * owner. For 4K buffers, we can reuse the page if there are
>> +		 * no other others.
>> +		 */
>> +		int reuse_bias = rx_buf->buf_size > IDPF_RX_BUF_2048 ? 0 : 1;
> 
> couldn't this be just:
> 
> 		bool reuse_bias = !(rx_buf->buf_size > IDPF_RX_BUF_2048);
> 
> this is a hot path so avoiding branches is worthy.
In this instance we rely on the result being 0 or 1, which is why we do 
not use boolean explicitly, where true may be a non-zero value.

> 
>> +
>> +		if (unlikely((page_count(page) - pagecnt_bias) > reuse_bias))
>> +			return false;
>> +	} else if (pinfo->page_offset > last_offset) {
>> +		return false;
>> +	}
>> +
>> +	/* If we have drained the page fragment pool we need to update
>> +	 * the pagecnt_bias and page count so that we fully restock the
>> +	 * number of references the driver holds.
>> +	 */
>> +	if (unlikely(pagecnt_bias == 1)) {
>> +		page_ref_add(page, USHRT_MAX - 1);
>> +		pinfo->pagecnt_bias = USHRT_MAX;
>> +	}
>> +
>> +	return true;
>> +}
>> +
> 
> [...]
> 
>> +/**
>> + * idpf_rx_construct_skb - Allocate skb and populate it
>> + * @rxq: Rx descriptor queue
>> + * @rx_buf: Rx buffer to pull data from
>> + * @size: the length of the packet
>> + *
>> + * This function allocates an skb. It then populates it with the page
>> + * data from the current receive descriptor, taking care to set up the
>> + * skb correctly.
>> + */
>> +static struct sk_buff *idpf_rx_construct_skb(struct idpf_queue *rxq,
>> +					     struct idpf_rx_buf *rx_buf,
>> +					     unsigned int size)
>> +{
>> +	struct idpf_page_info *pinfo;
>> +	unsigned int headlen, truesize;
> 
> RCT please
Will correct in next revision.

> 
>> +	struct sk_buff *skb;
>> +	void *va;
>> +
>> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
>> +	va = page_address(pinfo->page) + pinfo->page_offset;
>> +
>> +	/* prefetch first cache line of first page */
>> +	net_prefetch(va);
>> +	/* allocate a skb to store the frags */
>> +	skb = __napi_alloc_skb(&rxq->q_vector->napi, IDPF_RX_HDR_SIZE,
>> +			       GFP_ATOMIC | __GFP_NOWARN);
> 
> any reason why no build_skb() support right from the start?
We want to move toward supporting build_skb, but there are number of 
complications to that in the way we handle buffers (e.g. different 
buffer sizes/header split) that we want to optimize before implementing 
build_skb.

> 
>> +	if (unlikely(!skb))
>> +		return NULL;
>> +
>> +	skb_record_rx_queue(skb, rxq->idx);
>> +
>> +	/* Determine available headroom for copy */
>> +	headlen = size;
>> +	if (headlen > IDPF_RX_HDR_SIZE)
>> +		headlen = eth_get_headlen(skb->dev, va, IDPF_RX_HDR_SIZE);
>> +
>> +	/* align pull length to size of long to optimize memcpy performance */
>> +	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
>> +
>> +	/* if we exhaust the linear part then add what is left as a frag */
>> +	size -= headlen;
>> +	if (!size) {
>> +		/* buffer is unused, reset bias back to rx_buf; data was copied
>> +		 * onto skb's linear part so there's no need for adjusting
>> +		 * page offset and we can reuse this buffer as-is
>> +		 */
>> +		pinfo->pagecnt_bias++;
>> +
>> +		return skb;
>> +	}
>> +
>> +	truesize = idpf_rx_frame_truesize(rx_buf, size);
>> +	skb_add_rx_frag(skb, 0, pinfo->page,
>> +			pinfo->page_offset + headlen, size,
>> +			truesize);
>> +	/* buffer is used by skb, update page_offset */
>> +	idpf_rx_buf_adjust_pg(rx_buf, truesize);
>> +
>> +	return skb;
>> +}
>> +
>> +/**
>> + * idpf_rx_hdr_construct_skb - Allocate skb and populate it from header buffer
>> + * @rxq: Rx descriptor queue
>> + * @hdr_buf: Rx buffer to pull data from
>> + * @size: the length of the packet
>> + *
>> + * This function allocates an skb. It then populates it with the page data from
>> + * the current receive descriptor, taking care to set up the skb correctly.
>> + * This specifcally uses a header buffer to start building the skb.
>> + */
>> +static struct sk_buff *idpf_rx_hdr_construct_skb(struct idpf_queue *rxq,
>> +						 struct idpf_dma_mem *hdr_buf,
>> +						 unsigned int size)
>> +{
>> +	struct sk_buff *skb;
>> +
>> +	/* allocate a skb to store the frags */
>> +	skb = __napi_alloc_skb(&rxq->q_vector->napi, size,
>> +			       GFP_ATOMIC | __GFP_NOWARN);
> 
> ditto re: build_skb() comment
See the reply to your related comment.

> 
>> +	if (unlikely(!skb))
>> +		return NULL;
>> +
>> +	skb_record_rx_queue(skb, rxq->idx);
>> +
>> +	memcpy(__skb_put(skb, size), hdr_buf->va, ALIGN(size, sizeof(long)));
>> +
>> +	return skb;
>> +}
>> +
>> +/**
>> + * idpf_rx_splitq_test_staterr - tests bits in Rx descriptor
>> + * status and error fields
>> + * @stat_err_field: field from descriptor to test bits in
>> + * @stat_err_bits: value to mask
>> + *
>> + */
>> +static bool idpf_rx_splitq_test_staterr(const u8 stat_err_field,
>> +					const u8 stat_err_bits)
>> +{
>> +	return !!(stat_err_field & stat_err_bits);
>> +}
>> +
>> +/**
>> + * idpf_rx_splitq_is_eop - process handling of EOP buffers
>> + * @rx_desc: Rx descriptor for current buffer
>> + *
>> + * If the buffer is an EOP buffer, this function exits returning true,
>> + * otherwise return false indicating that this is in fact a non-EOP buffer.
>> + */
>> +static bool idpf_rx_splitq_is_eop(struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc)
>> +{
>> +	/* if we are the last buffer then there is nothing else to do */
>> +	return likely(idpf_rx_splitq_test_staterr(rx_desc->status_err0_qw1,
>> +						  IDPF_RXD_EOF_SPLITQ));
>> +}
>> +
>> +/**
>> + * idpf_rx_splitq_recycle_buf - Attempt to recycle or realloc buffer
>> + * @rxbufq: receive queue
>> + * @rx_buf: Rx buffer to pull data from
>> + *
>> + * This function will clean up the contents of the rx_buf. It will either
>> + * recycle the buffer or unmap it and free the associated resources. The buffer
>> + * will then be placed on a refillq where it will later be reclaimed by the
>> + * corresponding bufq.
>> + *
>> + * This works based on page flipping. If we assume e.g., a 4k page, it will be
>> + * divided into two 2k buffers. We post the first half to hardware and, after
>> + * using it, flip to second half of the page with idpf_adjust_pg_offset and
>> + * post that to hardware. The third time through we'll flip back to first half
>> + * of page and check if stack is still using it, if not we can reuse the buffer
>> + * as is, otherwise we'll drain it and get a new page.
>> + */
>> +static void idpf_rx_splitq_recycle_buf(struct idpf_queue *rxbufq,
>> +				       struct idpf_rx_buf *rx_buf)
>> +{
>> +	struct idpf_page_info *pinfo = &rx_buf->page_info[rx_buf->page_indx];
>> +
>> +	if (idpf_rx_can_reuse_page(rx_buf))
>> +		return;
>> +
>> +	/* we are not reusing the buffer so unmap it */
>> +	dma_unmap_page_attrs(rxbufq->dev, pinfo->dma, PAGE_SIZE,
>> +			     DMA_FROM_DEVICE, IDPF_RX_DMA_ATTR);
>> +	__page_frag_cache_drain(pinfo->page, pinfo->pagecnt_bias);
>> +
>> +	/* clear contents of buffer_info */
>> +	pinfo->page = NULL;
>> +	rx_buf->skb = NULL;
> 
> this skb NULLing is pointless to me. from the callsite of this function
> you operate strictly on a skb from idpf_queue.
We'll look into cleaning this up.

> 
>> +
>> +	/* It's possible the alloc can fail here but there's not much
>> +	 * we can do, bufq will have to try and realloc to fill the
>> +	 * hole.
>> +	 */
>> +	idpf_alloc_page(rxbufq, pinfo);
>> +}
>> +
>> +/**
>> + * idpf_rx_splitq_clean - Clean completed descriptors from Rx queue
>> + * @rxq: Rx descriptor queue to retrieve receive buffer queue
>> + * @budget: Total limit on number of packets to process
>> + *
>> + * This function provides a "bounce buffer" approach to Rx interrupt
>> + * processing. The advantage to this is that on systems that have
>> + * expensive overhead for IOMMU access this provides a means of avoiding
>> + * it by maintaining the mapping of the page to the system.
>> + *
>> + * Returns amount of work completed
>> + */
>> +static int idpf_rx_splitq_clean(struct idpf_queue *rxq, int budget)
>> +{
>> +	int total_rx_bytes = 0, total_rx_pkts = 0;
>> +	struct idpf_queue *rx_bufq = NULL;
>> +	struct sk_buff *skb = rxq->skb;
>> +	u16 ntc = rxq->next_to_clean;
>> +
>> +	/* Process Rx packets bounded by budget */
>> +	while (likely(total_rx_pkts < budget)) {
>> +		struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc;
>> +		struct idpf_sw_queue *refillq = NULL;
>> +		struct idpf_dma_mem *hdr_buf = NULL;
>> +		struct idpf_rxq_set *rxq_set = NULL;
>> +		struct idpf_rx_buf *rx_buf = NULL;
>> +		union virtchnl2_rx_desc *desc;
>> +		unsigned int pkt_len = 0;
>> +		unsigned int hdr_len = 0;
>> +		u16 gen_id, buf_id = 0;
>> +		 /* Header buffer overflow only valid for header split */
>> +		bool hbo = false;
>> +		int bufq_id;
>> +		u8 rxdid;
>> +
>> +		/* get the Rx desc from Rx queue based on 'next_to_clean' */
>> +		desc = IDPF_RX_DESC(rxq, ntc);
>> +		rx_desc = (struct virtchnl2_rx_flex_desc_adv_nic_3 *)desc;
>> +
>> +		/* This memory barrier is needed to keep us from reading
>> +		 * any other fields out of the rx_desc
>> +		 */
>> +		dma_rmb();
>> +
>> +		/* if the descriptor isn't done, no work yet to do */
>> +		gen_id = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
>> +		gen_id = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_GEN_M, gen_id);
>> +
>> +		if (test_bit(__IDPF_Q_GEN_CHK, rxq->flags) != gen_id)
>> +			break;
>> +
>> +		rxdid = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_RXDID_M,
>> +				  rx_desc->rxdid_ucast);
>> +		if (rxdid != VIRTCHNL2_RXDID_2_FLEX_SPLITQ) {
>> +			IDPF_RX_BUMP_NTC(rxq, ntc);
>> +			u64_stats_update_begin(&rxq->stats_sync);
>> +			u64_stats_inc(&rxq->q_stats.rx.bad_descs);
>> +			u64_stats_update_end(&rxq->stats_sync);
>> +			continue;
>> +		}
>> +
>> +		pkt_len = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
>> +		pkt_len = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_LEN_PBUF_M,
>> +				    pkt_len);
>> +
>> +		hbo = FIELD_GET(BIT(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_HBO_S),
>> +				rx_desc->status_err0_qw1);
>> +
>> +		if (unlikely(hbo)) {
>> +			/* If a header buffer overflow, occurs, i.e. header is
>> +			 * too large to fit in the header split buffer, HW will
>> +			 * put the entire packet, including headers, in the
>> +			 * data/payload buffer.
>> +			 */
>> +			u64_stats_update_begin(&rxq->stats_sync);
>> +			u64_stats_inc(&rxq->q_stats.rx.hsplit_buf_ovf);
>> +			u64_stats_update_end(&rxq->stats_sync);
>> +			goto bypass_hsplit;
>> +		}
>> +
>> +		hdr_len = le16_to_cpu(rx_desc->hdrlen_flags);
>> +		hdr_len = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_LEN_HDR_M,
>> +				    hdr_len);
>> +
>> +bypass_hsplit:
>> +		bufq_id = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
>> +		bufq_id = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_BUFQ_ID_M,
>> +				    bufq_id);
>> +
>> +		rxq_set = container_of(rxq, struct idpf_rxq_set, rxq);
>> +		if (!bufq_id)
>> +			refillq = rxq_set->refillq0;
>> +		else
>> +			refillq = rxq_set->refillq1;
>> +
>> +		/* retrieve buffer from the rxq */
>> +		rx_bufq = &rxq->rxq_grp->splitq.bufq_sets[bufq_id].bufq;
>> +
>> +		buf_id = le16_to_cpu(rx_desc->buf_id);
>> +
>> +		if (pkt_len) {
>> +			rx_buf = &rx_bufq->rx_buf.buf[buf_id];
>> +			idpf_rx_get_buf_page(rx_bufq->dev, rx_buf, pkt_len);
>> +		}
>> +
>> +		if (hdr_len) {
>> +			hdr_buf = rx_bufq->rx_buf.hdr_buf[buf_id];
>> +
>> +			dma_sync_single_for_cpu(rxq->dev, hdr_buf->pa, hdr_buf->size,
>> +						DMA_FROM_DEVICE);
>> +
>> +			skb = idpf_rx_hdr_construct_skb(rxq, hdr_buf, hdr_len);
>> +			u64_stats_update_begin(&rxq->stats_sync);
>> +			u64_stats_inc(&rxq->q_stats.rx.hsplit_pkts);
>> +			u64_stats_update_end(&rxq->stats_sync);
>> +		}
>> +
>> +		if (pkt_len) {
>> +			if (skb)
>> +				idpf_rx_add_frag(rx_buf, skb, pkt_len);
>> +			else
>> +				skb = idpf_rx_construct_skb(rxq, rx_buf,
>> +							    pkt_len);
>> +		}
>> +
>> +		/* exit if we failed to retrieve a buffer */
>> +		if (!skb) {
>> +			/* If we fetched a buffer, but didn't use it
>> +			 * undo pagecnt_bias decrement
>> +			 */
>> +			if (rx_buf)
>> +				rx_buf->page_info[rx_buf->page_indx].pagecnt_bias++;
>> +			break;
>> +		}
>> +
>> +		if (rx_buf)
>> +			idpf_rx_splitq_recycle_buf(rx_bufq, rx_buf);
>> +		idpf_rx_post_buf_refill(refillq, buf_id);
>> +
>> +		IDPF_RX_BUMP_NTC(rxq, ntc);
>> +		/* skip if it is non EOP desc */
>> +		if (!idpf_rx_splitq_is_eop(rx_desc))
>> +			continue;
>> +
>> +		/* pad skb if needed (to make valid ethernet frame) */
>> +		if (eth_skb_pad(skb)) {
>> +			skb = NULL;
>> +			continue;
>> +		}
>> +
>> +		/* probably a little skewed due to removing CRC */
>> +		total_rx_bytes += skb->len;
>> +
>> +		/* protocol */
>> +		if (unlikely(idpf_rx_process_skb_fields(rxq, skb, rx_desc))) {
>> +			dev_kfree_skb_any(skb);
>> +			skb = NULL;
>> +			continue;
>> +		}
>> +
>> +		/* send completed skb up the stack */
>> +		napi_gro_receive(&rxq->q_vector->napi, skb);
>> +		skb = NULL;
>> +
>> +		/* update budget accounting */
>> +		total_rx_pkts++;
>> +	}
>> +
>> +	rxq->next_to_clean = ntc;
>> +
>> +	rxq->skb = skb;
>> +	u64_stats_update_begin(&rxq->stats_sync);
>> +	u64_stats_add(&rxq->q_stats.rx.packets, total_rx_pkts);
>> +	u64_stats_add(&rxq->q_stats.rx.bytes, total_rx_bytes);
>> +	u64_stats_update_end(&rxq->stats_sync);
>> +
>> +	/* guarantee a trip back through this routine if there was a failure */
>> +	return total_rx_pkts;
>> +}
> 
> keeping above func for a context
> 
> [...]
> 
>>   /**
>>    * idpf_vport_intr_clean_queues - MSIX mode Interrupt Handler
>>    * @irq: interrupt number
>> @@ -3205,7 +4102,7 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
>>   	u32 i;
>>   
>>   	if (!IDPF_ITR_IS_DYNAMIC(q_vector->tx_intr_mode))
>> -		return;
>> +		goto check_rx_itr;
>>   
>>   	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_txq; i++) {
>>   		struct idpf_queue *txq = q_vector->tx[i];
>> @@ -3221,6 +4118,25 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
>>   	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->tx_dim,
>>   			       packets, bytes);
>>   	net_dim(&q_vector->tx_dim, dim_sample);
>> +
>> +check_rx_itr:
>> +	if (!IDPF_ITR_IS_DYNAMIC(q_vector->rx_intr_mode))
>> +		return;
>> +
>> +	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_rxq; i++) {
>> +		struct idpf_queue *rxq = q_vector->rx[i];
>> +		unsigned int start;
>> +
>> +		do {
>> +			start = u64_stats_fetch_begin(&rxq->stats_sync);
>> +			packets += u64_stats_read(&rxq->q_stats.rx.packets);
>> +			bytes += u64_stats_read(&rxq->q_stats.rx.bytes);
>> +		} while (u64_stats_fetch_retry(&rxq->stats_sync, start));
>> +	}
>> +
>> +	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->rx_dim,
>> +			       packets, bytes);
>> +	net_dim(&q_vector->rx_dim, dim_sample);
>>   }
>>   
>>   /**
>> @@ -3338,7 +4254,15 @@ static void idpf_vport_intr_ena_irq_all(struct idpf_vport *vport)
>>   						  true);
>>   		}
>>   
>> -		if (qv->num_txq)
>> +		if (qv->num_rxq) {
>> +			dynamic = IDPF_ITR_IS_DYNAMIC(qv->rx_intr_mode);
>> +			itr = vport->rx_itr_profile[qv->rx_dim.profile_ix];
>> +			idpf_vport_intr_write_itr(qv, dynamic ?
>> +						  itr : qv->rx_itr_value,
>> +						  false);
>> +		}
>> +
>> +		if (qv->num_txq || qv->num_rxq)
>>   			idpf_vport_intr_update_itr_ena_irq(qv);
>>   	}
>>   }
>> @@ -3381,6 +4305,32 @@ static void idpf_tx_dim_work(struct work_struct *work)
>>   	dim->state = DIM_START_MEASURE;
>>   }
>>   
>> +/**
>> + * idpf_rx_dim_work - Call back from the stack
>> + * @work: work queue structure
>> + */
>> +static void idpf_rx_dim_work(struct work_struct *work)
>> +{
>> +	struct idpf_q_vector *q_vector;
>> +	struct idpf_vport *vport;
>> +	struct dim *dim;
>> +	u16 itr;
>> +
>> +	dim = container_of(work, struct dim, work);
>> +	q_vector = container_of(dim, struct idpf_q_vector, rx_dim);
>> +	vport = q_vector->vport;
>> +
>> +	if (dim->profile_ix >= ARRAY_SIZE(vport->rx_itr_profile))
>> +		dim->profile_ix = ARRAY_SIZE(vport->rx_itr_profile) - 1;
>> +
>> +	/* look up the values in our local table */
>> +	itr = vport->rx_itr_profile[dim->profile_ix];
>> +
>> +	idpf_vport_intr_write_itr(q_vector, itr, false);
>> +
>> +	dim->state = DIM_START_MEASURE;
>> +}
>> +
>>   /**
>>    * idpf_init_dim - Set up dynamic interrupt moderation
>>    * @qv: q_vector structure
>> @@ -3390,6 +4340,10 @@ static void idpf_init_dim(struct idpf_q_vector *qv)
>>   	INIT_WORK(&qv->tx_dim.work, idpf_tx_dim_work);
>>   	qv->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
>>   	qv->tx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
>> +
>> +	INIT_WORK(&qv->rx_dim.work, idpf_rx_dim_work);
>> +	qv->rx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
>> +	qv->rx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
>>   }
>>   
>>   /**
>> @@ -3437,6 +4391,44 @@ static bool idpf_tx_splitq_clean_all(struct idpf_q_vector *q_vec,
>>   	return clean_complete;
>>   }
>>   
>> +/**
>> + * idpf_rx_splitq_clean_all- Clean completetion queues
>> + * @q_vec: queue vector
>> + * @budget: Used to determine if we are in netpoll
>> + * @cleaned: returns number of packets cleaned
>> + *
>> + * Returns false if clean is not complete else returns true
>> + */
>> +static bool idpf_rx_splitq_clean_all(struct idpf_q_vector *q_vec, int budget,
>> +				     int *cleaned)
>> +{
>> +	int num_rxq = q_vec->num_rxq;
>> +	bool clean_complete = true;
>> +	int pkts_cleaned = 0;
>> +	int i, budget_per_q;
>> +
>> +	/* We attempt to distribute budget to each Rx queue fairly, but don't
>> +	 * allow the budget to go below 1 because that would exit polling early.
>> +	 */
>> +	budget_per_q = num_rxq ? max(budget / num_rxq, 1) : 0;
>> +	for (i = 0; i < num_rxq; i++) {
>> +		struct idpf_queue *rxq = q_vec->rx[i];
>> +		int pkts_cleaned_per_q;
>> +
>> +		pkts_cleaned_per_q = idpf_rx_splitq_clean(rxq, budget_per_q);
>> +		/* if we clean as many as budgeted, we must not be done */
>> +		if (pkts_cleaned_per_q >= budget_per_q)
>> +			clean_complete = false;
>> +		pkts_cleaned += pkts_cleaned_per_q;
>> +	}
>> +	*cleaned = pkts_cleaned;
>> +
>> +	for (i = 0; i < q_vec->num_bufq; i++)
>> +		idpf_rx_clean_refillq_all(q_vec->bufq[i]);
>> +
>> +	return clean_complete;
>> +}
>> +
>>   /**
>>    * idpf_vport_splitq_napi_poll - NAPI handler
>>    * @napi: struct from which you get q_vector
>> @@ -3456,7 +4448,8 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
>>   		return 0;
>>   	}
>>   
>> -	clean_complete = idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
>> +	clean_complete = idpf_rx_splitq_clean_all(q_vector, budget, &work_done);
>> +	clean_complete &= idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
>>   
>>   	/* If work not completed, return budget and polling will return */
>>   	if (!clean_complete)
>> @@ -3810,7 +4803,6 @@ int idpf_init_rss(struct idpf_vport *vport)
>>   /**
>>    * idpf_deinit_rss - Release RSS resources
>>    * @vport: virtual port
>> - *
>>    */
>>   void idpf_deinit_rss(struct idpf_vport *vport)
>>   {
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
>> index 27bac854e7dc..f89dff970727 100644
>> --- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
>> @@ -61,10 +61,21 @@
>>   
>>   #define IDPF_RX_BUFQ_WORKING_SET(rxq)		((rxq)->desc_count - 1)
>>   
>> +#define IDPF_RX_BUMP_NTC(rxq, ntc)				\
>> +do {								\
>> +	if (unlikely(++(ntc) == (rxq)->desc_count)) {		\
> 
> desc_count won't change within single NAPI instance so i would rather
> store this to aux variable on stack and use this in this macro.
We will consider this as part of a more broad macro update if we can get 
some measurable improvement in performance.

> 
>> +		ntc = 0;					\
>> +		change_bit(__IDPF_Q_GEN_CHK, (rxq)->flags);	\
>> +	}							\
>> +} while (0)
>> +
>> +#define IDPF_RX_HDR_SIZE			256
>>   #define IDPF_RX_BUF_2048			2048
>>   #define IDPF_RX_BUF_4096			4096
>>   #define IDPF_RX_BUF_STRIDE			32
>> +#define IDPF_RX_BUF_POST_STRIDE			16
>>   #define IDPF_LOW_WATERMARK			64
>> +/* Size of header buffer specifically for header split */
>>   #define IDPF_HDR_BUF_SIZE			256
>>   #define IDPF_PACKET_HDR_PAD	\
>>   	(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN * 2)
>> @@ -74,10 +85,18 @@
>>    */
>>   #define IDPF_TX_SPLITQ_RE_MIN_GAP	64
>>
> 
> [...]

Thanks for reviewing,
Emil
