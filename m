Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27EF699902
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBPPf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjBPPf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:35:57 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8414CCB6;
        Thu, 16 Feb 2023 07:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676561756; x=1708097756;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2maYTvlu36kNoW1uqZyQzWgceGmGNkCYxJoCmgkLIe4=;
  b=cpHd7gfB5rVshtOGdYozB792PrCvcKy5j1YU8Ub036PjU+xZGDCO9ctV
   DrL6NP6E+x3MYWDrATdjw/DSRcLkol5EGOrcn+5WS6zrvZotxu5iBS719
   U9KM4QFMFcMnsOHPk+4g2uyzsGLCRCFTnyvGkL7qorh6f/2dq3so0pR92
   IfqTD9sQe1gFx8QbrQcugbVktbhG8pY4ReIRcpMvuCRH5Xgps0fnmTdMr
   RSEf8GFu/GlE00jhyR29ojL4NTz1EQfLhnS3BG3NKqOd3eHz/tFh/7fZF
   XTCtqMKXiUTSus9vcDspVR4PVRk+AmUlkI29NqGNeGdCGKn/csNFihn7I
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="359175976"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359175976"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:35:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="844181008"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="844181008"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2023 07:35:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:35:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:35:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:35:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1wu2EU1twYA6rNdEN55yi1n2siRb/VxaLZGi7CeUgHy83p5jQnciGTdKMUIvc8mG5FdChxgl/W5SEuJ4PGx4BaXLEfArwpkZ0ss6KiuWlNxAgEpf172zQGM8hwwRqfmQJMSlZ4WUbVU4p6EFmtq+ToJmpuhNs/OltpeMzZkc7WiAP3QzcJ6Ia7oCnlvrcogsOpviffrfSbJRpxc9LPtaqWtE45fKY/5wdf9RHSfrOcLhl0tXTZ6csifyDuVhbkT0ZISjcZBdbuIrMJbkeimbLyXbrfLvgqBsf3k9v7KLVeH+i2+honpAfohaiisvgBpgi1ejxLwBcuThoW7RNPf0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdirv7fuMz9aaBBzAnlIWbKS2f8eT/3ryyt40BVFZOM=;
 b=Izr1Shtytr1h/jnoDfH3yFhe3AQtkHnMijFqgMm2Rf7fX8ljvnNLoB56IKmbn4Yao77qqGu4XKKxadAJc+2uPolkoHaazSDi8h0MtgIHjbWgR7NvsVLJ7HANYZ1eQgC/WMyc7Y11A/oO0/e2ttBHU8Kk9eNLMOST/02eTYneYApdM4Byx1RZdoe+mBwqMZCe7/iMBMuVJdf3e3OUjlhGAQ7s3TilmD8PcnElSXGO6hqSnkesxL74S4j7xuSUjOrlqWyuwa7Tz2gSs2V/kxmwXJcHmnCgiIXVEv2AVjk+7E+SiSDhw5NiK+mkmRC0El8pJNVe7liZME7YopxHq+Ojqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB8213.namprd11.prod.outlook.com (2603:10b6:610:18b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 15:35:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 15:35:47 +0000
Message-ID: <33f62bbd-51ed-475a-45f4-79226a235d6c@intel.com>
Date:   Thu, 16 Feb 2023 16:34:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [xdp-hints] Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable
 and fix RX hash usage by netstack
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>, <brouer@redhat.com>,
        <bpf@vger.kernel.org>, <xdp-hints@xdp-project.net>,
        <martin.lau@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <ast@kernel.org>,
        "Stanislav Fomichev" <sdf@google.com>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
 <88e5c6b2-8acc-6585-100d-7b62320e5555@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <88e5c6b2-8acc-6585-100d-7b62320e5555@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c87801-a802-4b1e-d814-08db103379bf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cjc6mlK7ATPIiWB69VFBLDihSsoJ2kLDjP847VMtSeI1lCl0UWLxX6yQaH6w5UYBQVG/Jgr+qg8Qkr4j+olpEICPR1hc9aHZlweLpnQCPFSlkuUguefLn0SmOYLQQD7ezGoXWU9eFANy0DGU2jvcVGwzk9nTqgYV5AzMvcuKV/fcziokXcrIceHv2+b89XFTCFd7nixuDzeTsRf1QB4J7JDH7WIRQyjIVUexQ6GSJDUbCF91xy6mGFemWTvXq+ubG+QyLfG+qODMMIj+sfiF8uzZhRudWO2gZisDFQY9Ears8q2jV+AD36r7EXjhnjpxirVcus5UIAOdKA64tEF5NKpigG/9/CG8yoPzwz33zeqTb2YYZnIlzYhPJgSbndxjaaOblqCuylTYe6LVRLkuSifS0yJMzFlXhxJPNlhRjKOPjiVBOJa4ir5x8mB/IZFP+Sx+U0olQQC3DoBy55C0RAEEFrQBO6dlqmfilz5vwwswtxQsFfrr3q98ukLT6CzNM3fIptTFrCF9Y301VoT+DlsQnqeDGtgFurVD2t5ejsJc7pQT8QvGaL7DmxL8+e1/akKJXEwxDEP8D8ClL4MAEBWfVYENCy9QbxD/sxTpfrHYTEVthYgbMIrd/viSYnmYBtN2eQTl4BiE4JNMfRDV3SP9bsXfJRejmi78qGWUjbD0S05dv5hFZa/sCNKzTe2je1yt1oW7Rj/+YXlfpGajStZ5y/beDOim54jxhT2Wti0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(31686004)(82960400001)(31696002)(86362001)(38100700002)(83380400001)(6512007)(26005)(6666004)(6506007)(186003)(2616005)(478600001)(66476007)(316002)(8676002)(966005)(6916009)(66556008)(54906003)(66946007)(4326008)(6486002)(41300700001)(5660300002)(8936002)(7416002)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUtFRVF5TStadXZtaFZGeDdTcXg3VVlyVE1wRVNSMGlGTldmQngxQkN5MUI4?=
 =?utf-8?B?YlMwMTkrTFJtbFNxNUUzcHhKTytXMDlzeEtjK2xFTkludnFxdk1pRHlHSUZr?=
 =?utf-8?B?S3pVVkR0NlZjWDFZY2czUzdNRmpZTS94dFQxMUZQQVJzYjhKMXJrMkQ3aGR2?=
 =?utf-8?B?OWtiVForZnlHODhnempSSXk1TGFNS0tXUFNhZ3VpV2EweVc4SG41SGU1RjVj?=
 =?utf-8?B?VHpSZkUxc1RNYW5aYTJCNzVmNzhHWXdQKyt4ZXdQUXlZcXU1eXAyNHhtalF2?=
 =?utf-8?B?N041bVJHSEcxL0piZlJUTHNIYndvZk9oQklXSFVaYlNGbGhMTVVhSGZCU0pj?=
 =?utf-8?B?TmJuam5aQXZTcFl3dHo5dk9pOHdrWGN3S3hibFVESUQzR3N3c2VGU3JsTjVH?=
 =?utf-8?B?N2VBSUJ3MUNuQzZxekY4SlJvQ2puN3hvR1AxcDZlSkRmeERpVFNiZkpoZVpk?=
 =?utf-8?B?dDY5emloUzhSUytFYXNmSmtHdTF3M3lhcFVLU25tQk5KV1prU0loMXc3K01j?=
 =?utf-8?B?WTVDYjhBdG5QQWZqVXJPQmdSQkN4N1N3RFZ4MTYvMysxbFk0MWpvV0E4WGNF?=
 =?utf-8?B?b0UwOElGSEVjMkNiYkpvYXFQdHlaYUUzSmZRakJ2SUpPMWxGKzFpbkwvOFZm?=
 =?utf-8?B?MEVkZzFSYSs1VGRMQWZTelRiRlpqZ0FxQisweXpqZWFwajFIYU8wQmxlcitS?=
 =?utf-8?B?NHJZbUFOaGs2UGIyU2doUUpaMVpHZ0NpdjYvdjdxRkZXOEw0ZFRXV1NKTzNB?=
 =?utf-8?B?OUZwS2hYRC9vQVdObVIrOVcvbGd4eEtlWEVMSHhvdUhDM1FPcGxEaGttLzdP?=
 =?utf-8?B?d2ZJUkQ5NTBsc1liNkZ1YXgzMFozQk5nYndZbVprTXV0djErcGJxNjdLMHJQ?=
 =?utf-8?B?VkJHVCtaa2gvekI4ZFcyd2JBS0xEWE95MXlpK29lUzh6c21iTnZ6OXFacGFw?=
 =?utf-8?B?WTlDZ295dTJ2K2NYbFRWamFxM1FSeC9yblVUSnhQMjJWWVoyc3hVVnhic0dv?=
 =?utf-8?B?QmcwVTNQWEJSbVhZU2NidXNLOUNEUmpYS0E1UTl5aytOdzVwdVBud25Cb2gy?=
 =?utf-8?B?RmJlSGpnNjBOQ3NJQmpNZnJoVnBpQUhEMnk3Y1V0TmVlSlcvclNtdmZlTFU4?=
 =?utf-8?B?aXc0RUpoZFBJRjZjMDBzb1lrWnRGQ0hJQ20zY2o5cklFc3RLQlFNYUQ2eDdU?=
 =?utf-8?B?ZVV5MU95NFJBS3pUWWt2WFFyMzZHYmVRNjJkTzVNdjI3cnlZSE51L01LSGVE?=
 =?utf-8?B?dzNUVm5EMFRITmJpc1ZpZDR5ZndvVkJJNmc1YS93Umkvd3lMMi9NeFNWWDhY?=
 =?utf-8?B?bmRKWEljai9pWEFYNHdyd2lXV1V2TmJ3ejMrcWdPVFJEWUx1eUZ4ZWZBbUcr?=
 =?utf-8?B?R0VIMS9Yb3RETlJORWNLMWpNVUp1dms2cHVHL1UwMXhhUXEwWGZpdVVuZFhm?=
 =?utf-8?B?bjNaK045RnVqQXpacWNrUjJ5Ti9wa25CQklUL2lZU1RIbUNYeUM0V09VWHMw?=
 =?utf-8?B?N0xNWXBHdTRhSGduSlp1ZnhsTnBzaG1DNDhzeDJUa0h4ZldzV3JqNURvQWtk?=
 =?utf-8?B?VWZrMURMTE42RS9yMmlDcUVoRzRWcHBKbXF5NkZqV0c2em9qc0J0Q3AwRWZT?=
 =?utf-8?B?eW5FTTlZYW9OQXl3ZWh3MHc5bmFMbENsTnNCNkFhQkhZOUYvL1QvM3I2MGV0?=
 =?utf-8?B?NENBNVYzYUM2a295c1BQVmxRUXY5V1Q1eGMzR0ZiT3dIMDFyMDlJcnB4ZDhM?=
 =?utf-8?B?cjlldnR1V2JhOG16Z0VzRjd3U2RIOVgxTW15aVdqbEloV3hlQ0RkeDJuVDFL?=
 =?utf-8?B?dFordUJmNGcreU9IODNacE5keGgrSk5VWGJPZC9JTDNYcWIxVUtoU25iSldk?=
 =?utf-8?B?M21tak4zczBKemRMWk5uOUluUE5xcXc4S2dsL0lpNzRFMnczVWNscHoyMGFC?=
 =?utf-8?B?R29LbVk4TG5EQURtamViR2JmNUZ5UUE5SXN3eU5RMUUxbzRZNmM0eEhiWC83?=
 =?utf-8?B?SUlnSFR2bTQwTmFRck1UM1NhWnY0VmFGbFV5d3pORTVSbjdRV0ovSlBGZ2U0?=
 =?utf-8?B?K282ZEVXVkVDOGJ6aXdKY0pKWEZOWmh5dlFwcUNTenQ1dGV5U1hoMEh0d25U?=
 =?utf-8?B?bXdOYkZoZGpjVkljRFc3N2loZk5BVGVxZjdWNzRlUnV4RHBuZm9GT2hmN3lL?=
 =?utf-8?Q?zRjkn0+MG3yOh585t5rI1cw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c87801-a802-4b1e-d814-08db103379bf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:35:47.6924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRswOs6+zPHPAkQGk6R3jpS8Kh5tDBVRjd0JsxIv1+tVnNIUy0qno3Kpt1QGRHSeElKJD8/uva8uqp0q9DUb7qidi/QTUpHFQW89uz60F7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8213
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

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 16 Feb 2023 14:29:43 +0100

> 
> On 14/02/2023 16.00, Paul Menzel wrote:
>>
>> Thank you very much for your patch.
> 
> Thanks for your review :-)

[...]

>>>   static inline void igc_rx_hash(struct igc_ring *ring,
>>>                      union igc_adv_rx_desc *rx_desc,
>>>                      struct sk_buff *skb)
>>>   {
>>> -    if (ring->netdev->features & NETIF_F_RXHASH)
>>> -        skb_set_hash(skb,
>>> -                 le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>>> -                 PKT_HASH_TYPE_L3);
>>> +    if (ring->netdev->features & NETIF_F_RXHASH) {
>>> +        u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
>>> +        u8  rss_type = igc_rss_type(rx_desc);
>>
>> Amongst others, also here.
> 
> Do notice I expect compiler to optimize this, such that is doesn't place
> this variable on the stack.

That's complicated I'd say. I mean, never trust the compilers.
Yesterday I had a problem when the compiler (Clang 16) wasn't inlining
oneliners (called only once) into one big function and was making
19-byte tiny functions from each of them, resulting in 10+ functions
consisting of one call only => 2x jumps between functions :clownface:
Especially when you use non-native words (u8/u16, also u64 for 32-bit
arches) like this.

> 
>>> +        enum pkt_hash_types hash_type;
>>> +
>>> +        hash_type = igc_rss_type_table[rss_type].hash_type;
>>> +        skb_set_hash(skb, rss_hash, hash_type);
>>> +    }
>>>   }
>>>   static void igc_rx_vlan(struct igc_ring *rx_ring,
>>> @@ -6501,6 +6527,7 @@ static int igc_probe(struct pci_dev *pdev,
>>>       netdev->features |= NETIF_F_TSO;
>>>       netdev->features |= NETIF_F_TSO6;
>>>       netdev->features |= NETIF_F_TSO_ECN;
>>> +    netdev->features |= NETIF_F_RXHASH;
>>>       netdev->features |= NETIF_F_RXCSUM;
>>>       netdev->features |= NETIF_F_HW_CSUM;
>>>       netdev->features |= NETIF_F_SCTP_CRC;
>>
>>
>> Kind regards,
>>
>> Paul
>>
>>
>> [1]: https://notabs.org/coding/smallIntsBigPenalty.htm
>>
> 
Thanks,
Olek 
