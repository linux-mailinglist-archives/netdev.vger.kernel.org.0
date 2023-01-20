Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68436748B5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 02:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjATBSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 20:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjATBSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 20:18:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39736A259C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674177492; x=1705713492;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3kafweHo4e5gJWu6b0ROs/tIMFGZrI3LTFJB+VPobdY=;
  b=Gg5+Cyhaotx6i/uL0SMyfkKJZaEQuaqHAUpnaLgASME1+GEScvqUqiA7
   rgHem1nZZHDMyvn1sOMWYIDf/1H6sVrrJhD7rxR6V+MutA5Dy8EmHLyFN
   UoHfgA3o8y2LjlhcZQp7Jl1AbY7sCdTUBSO0g6XVnUp6mamCeWlAKUAQS
   bi20u83jSRSRJHiWn7CEUEJDYey8c0oMgYSFFz0UOzIE1WcXBOFa2NeQx
   +plXu+DrjNHLipKQ3cxop5FCkm703Q+F9EIk0b7FsDNe8I9xv/KWVs+nU
   JFUGCN+4j5RC9Gz2IqDdsZxJLjkHKmFc7qNrMOHBVWQalxFDbLnYB4vnc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="352737142"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="352737142"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 17:18:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="662377679"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="662377679"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jan 2023 17:18:11 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 17:18:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 17:18:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 17:18:10 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 17:18:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaN0BvjKnDPp6O+1sFFHPOiu3dFRpsW2tFzQljJ6XISgIIDLt/WkfJU6PHqxPwOgrCYGWpoyPYYAN4xfQlSkuPaDzSzpiMKvoKE+XwDkNRhwdp2b4FSstKn2h6vUGFpDTOa2fptEWZREqM6xvAi0kd5Sp2l+Ta1g7Tumxw/wPrKdka4+xDjO0bBpOIqllD4ofv+2nV4yG7+gjAfo8/65itgulN6j1dmBDCAQ5b075yrzQM7lhjTVM7bHMfLqe87lfzLNPgH02RqsBxBWgG2zsN+Pei76JW3Dp89iyultXoe+9DrGaEXca8EM8ySkht6CunvgHuFtKT7hkGhwVjXibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuW0XMKM9TcqIvFW/xKQbLfeouAGShykfRjFGHY4t8k=;
 b=NPMyr9m/uFINlk9uYOhLG7dYjl6aD3ioBTbYZeGzXy8vKoZ7zphrMAZCJh7Lr4YnSxvExKXIFfYz+84ZiUpNUIlYvmoeIhRZkJcL3KdspjuXIR3RJAqEBIHPElQvv0qOBx7MQ936NjPtg3zijRNDKc53q45RJ56EkNeihSVC/7CSzCy5gClNUYasZCio1hhxVmPL4ZTntxHsykDLEhaEYr/Kg7hemQqEI2fYBv+HXNN0sf61Qbjdusr16DZ3KhnHk8rCw7OR28NwL/cDy9Enp+1SWSjvAsPfpDJnpyvyHcZ5MP8CMCtg+OgJ7EWPHkm+iDyxc38SBh7RRuJhgB3JdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 01:18:07 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c%7]) with mapi id 15.20.6002.026; Fri, 20 Jan 2023
 01:18:07 +0000
Message-ID: <45a806ca-ff78-255c-3ffd-32bf0bf76353@intel.com>
Date:   Thu, 19 Jan 2023 17:18:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/6] mlxsw: Add support of latency TLV
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
References: <cover.1674123673.git.petrm@nvidia.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::12) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SJ0PR11MB5069:EE_
X-MS-Office365-Filtering-Correlation-Id: 212bd9cc-ef32-42d2-763b-08dafa842fd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUNjmbRHLHetOJhVL6rFEBSSONZYxH6WvNRZ1XmSxXZ6t0aoWWkOKCTBYlYQxp3Xdi1pAHeNLUMOSq8lijMeyhLj+yg4KieFTpXW4mAoIRmFP2q2skMyg3NJfk77EiuYh4pruXkezUUnHx0/o0mcmBiM3/ZHVV4+WMUSnLvONIwo/qLnUB0qyaA3YCL7CsyMQgxcr7CO7rmFkAxXZaH5NRgRj8rx/Q+URMyj2vq6/k/z9OcEoZbdVIikwFfuK1xgLIY0sYFa7cp6dA4TNMCo/11j7DFuPrBLJPXhf0zOVHPjFW9Zmtg8gyHys+yRrcbCz8Ut3t/ejMpncZ4t/H3NsvJ9LYvV40R5lRA9noDKhBoS/S7d7+buvPmJtLfVqs6SetbY95Z0xsepCq22PPQEHStV6FbtoLmFDZ+HghnwfMc1DLogQl00Us1N6likawnDPkcURuS5iHMGFWk7F6JbJXx1czo50tQUnvGlll7Ytdt8aL3VaGflMLjzp/vl8qIjHUYUWPrvt+U/QKwGYHfzSvwODmYWrFYc73F1owO5/XzdZJheusYmvkSq2xYhE+kO5RczWGn24eIkNUvS9fcaq8DZYuiJvCb7drBlRIMtWmWnz/5P7GL3iI6HpUKTIYOEO3yGx6FeJavX+gjxfXdGUNE9k3fDGcrdarXeKXqBXHw6QAsNT5APKwiJStbtjIdFVl4E5U4D334fwnmCydE7kb2xVpQXRKa4j+k471lW1q0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199015)(82960400001)(66476007)(38100700002)(66556008)(478600001)(86362001)(31696002)(5660300002)(8936002)(66946007)(7416002)(2906002)(110136005)(4326008)(41300700001)(8676002)(26005)(2616005)(83380400001)(186003)(6512007)(6666004)(53546011)(316002)(54906003)(6506007)(36756003)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlNQb1lXNVNmcG1xWWd0a016eEg0MThWWVZjY2F3cnVWRGFGdHJpRVptWnYy?=
 =?utf-8?B?YW9BRTUyZ0M4Vk10N1ZxcTNLZTZ3RnJtWHpRU1JmNlZFSmZJQTlScDgwVzdQ?=
 =?utf-8?B?N2hHODUzVmZsNWN1ZEYrZ2tTcjhMM0Q1SlhmMmZXbEFpdVFpNndybUNQMTFJ?=
 =?utf-8?B?aEU2dDlVTUVPVDFVdU93UDFpbitwVUttUkh5TVY3bU9QSjNNVlNxVjZrdUF0?=
 =?utf-8?B?bWEvL1NiT25xTE5keDNFeGhyMmJXUVE0ZWdiTUl0dFpDcHNFaEpnOWsySHA2?=
 =?utf-8?B?cExxQW5GWkc5LzVFVG5GV0ozakdLM0pCTmtSZFMxaUwrMlJ0M2syNjJKVUxz?=
 =?utf-8?B?NlNvVDNWR3MzQWNnQ1NhSTRMT0xISS9yN3htcGFueDI1U0NTL1VDWHA1NXFH?=
 =?utf-8?B?TmROb3hCeWFwRHdwY2g1NlBHRTFXSTJqZWpWMEZlQTRZbVJZMVZMVnB4bmVM?=
 =?utf-8?B?dlREY2FUWGVXUjd3WVAzTlJwWmpvS1VQT1FRMDBvc2l4UVk1NVNkdHUrRmM1?=
 =?utf-8?B?c3Q3a2lid2NCT1pRRzVOSDVXbGVxSk96Y29iNkw1T0JTR05NQVVsR2J5T25Q?=
 =?utf-8?B?emwzQnpNTStJRHc3NHE0TkdZYVpPTnBDL081eFFmMG8xT1FWS0FiV3U3M3BN?=
 =?utf-8?B?MEZCTFFkU1REWWVxWWxwYW9wREtGcTk1QWtMcHhKbWVxd05VZStTZWpxbmtJ?=
 =?utf-8?B?K2pjYVFZcWtpM0o2MldDZ2VOR3o2blZDRDFSZE5PRDV0a3lWdW96NG1ZSEwv?=
 =?utf-8?B?TFdUQk9lMnkyQ2xWMjdrVXNsNkxOWmM3NlZ0V0VFWFc2QkswRDJWdHNkbUpV?=
 =?utf-8?B?SnBsUkdMYnJ0all3T2UvdkJEeGI2QU9SeFBuV2Fud1lwRGdqZzNXdTFvTm9V?=
 =?utf-8?B?QnBKNEgxMDhVNEFWenV6ajJjanJlQmt1SHFqU3pLSUN0RGhWdDgvVkZhazJQ?=
 =?utf-8?B?bk9CTWhmZXJWMUhKcnFaWVRSSFY4b3NiVkE3eVJCWGt1TUtrYU9QbHVsa2da?=
 =?utf-8?B?QlVLVHN5dkxxQW45Q0V4Z3YzSnVRc1BzYzl3TnFTYTY0ekRzdjc1VlVZTVo3?=
 =?utf-8?B?Z1NBdDJkWDZHcG1UQWxnMk4wWjY1bXRiRGNYTTNBbTIrSm9LTlA5aThtdVRw?=
 =?utf-8?B?RS9tai8ya3Zzc2NlVjFCRkEwOVNqYmI0RGtTOWFnaEtJTitXRTJKZzdHMGZL?=
 =?utf-8?B?eWNHYTd2RFBBcXhTR09VdThZZFFwUkFreTlnVk1RQm1tOWFYaG9NUGtwdmVT?=
 =?utf-8?B?TzNuV29meUV5L0VIVkxMRWRqZFFJdHZxNElnUjVPbXczZ1lzaFhLNEhkZ1FU?=
 =?utf-8?B?MkFicGFabHA1NHFmVEhKaENZQzdwU3JUMEs4R1pNaHI0VGx3L3NOb1RGR3N1?=
 =?utf-8?B?bFNpRGUxLzdyYURBckxkNmxrdHdrMTdpSzFSN01wcnVCN254dHdVVFBZcyti?=
 =?utf-8?B?Mi9ycU9rMENTblU2ZEpEaFlqdlJqT04wQ1gzK2FOY3RiWFZHcEpFS0thbkp6?=
 =?utf-8?B?Y1lzWDVRcktRYjFIbVd3MUZPVGh6SmV5ZVZkeDJwaExsRDJhMUd3VksvYVlQ?=
 =?utf-8?B?QUF1TzRJSlByWk9yVmVzcEtwMEFLSG8wdTFhUG9UcnN5ZnNLYk9rYS93T3B3?=
 =?utf-8?B?c1E4emUzS3BRTThRRThzcXpKSk04K1MrZklIYXZBdm5KMG5iMXorZ2tpcitQ?=
 =?utf-8?B?aUppeUMxWFdzQndIRFJrTTY5VVMxMmpMbjNJakJUaVphZys0aU9Td2U5Nnl4?=
 =?utf-8?B?c0prVTFlaW1DNkJkT0NMYnNNbFhVNVFmYXVsdDgrS0szczRvMGhGWldzdHBF?=
 =?utf-8?B?M1ZxV3N4dkMxbWpYNDlPb0xZZVFzMTV4cHpmeHRSc3N3a25YL09FZUN1ZnB4?=
 =?utf-8?B?aUcyZ2p6d1BhSzVBMVkrOGdJRUgzOFkxMFFqUUdLc1kyODQralhBRllnTGlS?=
 =?utf-8?B?VXdIOGJCTGdaSnNINFJlYmhCVlpEMlo2Zmx1Tk1RVGNBNW1wcm85Zmx0aitO?=
 =?utf-8?B?UmVjNGZEbU9RQldYOFRTUnc2VmpKeklrUC9uZFUzbFFDVndGL3VIVlZnRTIw?=
 =?utf-8?B?R1BvWkR1YkFCNVZXZjJOaUEvMGxSQnFEbTZ2aHRSQkw2c2JuNlZwU3R2bEVq?=
 =?utf-8?B?cmR4eFE2c2dWMjlJbnhUUlFQdHdKTnh5RzliUDNlNmpsSWs0WVlsL3Eya2Jj?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 212bd9cc-ef32-42d2-763b-08dafa842fd8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 01:18:07.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GG+0gdfSGZBMenhiEIikuS04vPxa165V//sK41N5DknT8PSSrZYNZZzJTfjQkklZKtWZeSoOmrXKQeXMllPhYIK2rcsynUKrge2mKEPWcVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5069
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2023 2:32 AM, Petr Machata wrote:
> Amit Cohen writes:
> 
> Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> the driver and device's firmware. They are used to pass various
> configurations to the device, but also to get events (e.g., port up)
> from it. After the Ethernet header, these packets are built in a TLV
> format.
> 
> This is the structure of EMADs:
> * Ethernet header
> * Operation TLV
> * String TLV (optional)
> * Latency TLV (optional)
> * Reg TLV
> * End TLV
> 
> The latency of each EMAD is measured by firmware. The driver can get the
> measurement via latency TLV which can be added to each EMAD. This TLV is
> optional, when EMAD is sent with this TLV, the EMAD's response will include
> the TLV and will contain the firmware measurement.
> 
> Add support for Latency TLV and use it by default for all EMADs (see
> more information in commit messages). The latency measurements can be
> processed using BPF program for example, to create a histogram and average
> of the latency per register. In addition, it is possible to measure the
> end-to-end latency, so then the latency of the software overhead can be
> calculated. This information can be useful to improve the driver
> performance.

...

> Patch set overview:
> Patches #1-#3 add support for querying MGIR, to know if string TLV and
> latency TLV are supported
> Patches #4-#5 add some relevant fields to support latency TLV
> Patch #6 adds support of latency TLV
> 
> Amit Cohen (6):
>    mlxsw: reg: Add TLV related fields to MGIR register
>    mlxsw: Enable string TLV usage according to MGIR output
>    mlxsw: core: Do not worry about changing 'enable_string_tlv' while
>      sending EMADs
>    mlxsw: emad: Add support for latency TLV
>    mlxsw: core: Define latency TLV fields
>    mlxsw: Add support of latency TLV

Looks ok to me.

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

>   drivers/net/ethernet/mellanox/mlxsw/core.c    | 108 ++++++++++++++----
>   drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 -
>   drivers/net/ethernet/mellanox/mlxsw/emad.h    |   4 +
>   drivers/net/ethernet/mellanox/mlxsw/reg.h     |  12 ++
>   .../net/ethernet/mellanox/mlxsw/spectrum.c    |   1 -
>   5 files changed, 103 insertions(+), 24 deletions(-)
> 
