Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9322660661
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjAFScZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjAFScY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:32:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BB49170
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673029942; x=1704565942;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E/xIzhgb1JvThrlLHadyKBM3UxVO/V9srKb4ikim04g=;
  b=BqZ9hAGj4TAWs0WH0BYCdO7cnu8darIlcLtIF3tZ+6Cf/PSrUuDU9Car
   m0lNNjcGpnXMb2jVk9OkPi8IelmRksPtzNIkKhsc1LdNPn37wNpW7HVZ8
   ynPL4he7+WNsPNSQAY87wPtLZbb/yEppUnHG/gFAOAQoXl97nfQQZe0qF
   mKPi5DWcScju8yDk7pKt+3cK0iDYR2x4vfsjlPCCiKkdeZMX+jY4vfGj0
   Ir+yWWl3xeSis4zuB4ak070FTBgiJnXzwSCnZbvYIa2NcGdvGQWjPTlg6
   ta0IvOPDMYzqdR0DKIrJz9pHCJt6VZwVgltr92bAoyb4AGExiokMmtPXF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="324547079"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="324547079"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:32:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="649385737"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="649385737"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 06 Jan 2023 10:32:20 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 10:32:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 10:32:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 10:32:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll1RWDVRSg/ZmdgYdj4e7RiaVWUug+TtSqpnVXOERNY4dT0zBkHR5gGdKClEhzUSZjt+iwSfopsav3t+sHGTqJEpswxAyHbHDbJ6bVRRoeRIjbQ5QEUPSAGj+6iz/qdtYg8S64s/BogPyWScJDC0ODfZFQmrVJjgrM5imTgtq+/N6EPBm6QTav8M6hWTbBk5cWf1C4I7e4Z/62mCUmFDZoOBoey9YImCUndX9PVhx4NoIYg64epdVFZ0HnnOiR92vE6CNf8Qcvj8X+2BoqkcvFSF18XbOH8FEkNBk4omip6Mm+buYfEYGoy+Y6ZNhXYIfnxJj7WJs3hYabqSlT4cIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqkSpW/3Ie2I3kB8jWrFUiJ8QgacQrL8wUJ+1SXkNS0=;
 b=W5+tM7zSwc9jrfkv9wk4gQuvU40m31+3S785YsYP8VUsFDX837TQkduXidjngTJAq4PJDXRhXme4/9JjKPUqrGoKv1h4MVhHiJvqjX69Rr5DDGaBrHAPymSKqfc5WsVgM4UvTCmoVlLUpn/HsCndiU2WSJzoCt5iXlugzEpnrrdoRApLpWUR47uIAjb+0IkYgrCccBnUh5HA+bf1PXAvqaaGodn3gSckVZR++7C3wraDQn+LQnvoDAFFKclfRWMQT3gq5C/pT76bPd6XXIRcyoEzlfdcemv64aCU5oPH1GcfR7zOhaNnHiNZNvFDQ0K/J5HKntXBoQxYb+J8U0l4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM4PR11MB6429.namprd11.prod.outlook.com (2603:10b6:8:b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:31:27 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%6]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 18:31:27 +0000
Message-ID: <8b1bd24c-f14c-0244-d2fb-69d4f02b46d5@intel.com>
Date:   Fri, 6 Jan 2023 10:31:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     <m.chetan.kumar@linux.intel.com>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <ryazanov.s.a@gmail.com>,
        <loic.poulain@linaro.org>, <ilpo.jarvinen@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <edumazet@google.com>, <pabeni@redhat.com>, <linuxwwan@intel.com>,
        <linuxwwan_5g@intel.com>, <chandrashekar.devegowda@intel.com>,
        <matthias.bgg@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <cad74cd61423dbf01375a96432b3d1dbfcce0f1a.1673016069.git.m.chetan.kumar@linux.intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <cad74cd61423dbf01375a96432b3d1dbfcce0f1a.1673016069.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:74::42) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DM4PR11MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d33b25f-979e-473f-0ee6-08daf01438cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lT8xY5Mjf45prCw+3ejxYN1ZI7O6CJs6I/NWmCujOCk7j9IFdHSiuGJAWl3WtgaFt50YkjtaIkHBuAVTTab7s5eUPnATwp2TWkGtfF5N1NlkwXUlSunHCKK3QPbZsOx5t6NPcMc/q2K+M1xXNZ8IB6Rf4ifeKTzbwrnbc+/Tv7/uWQTh1r6db01QMP8pyl1RNVf3rcCtZ+rwh7538lTpLPk7bdVtGSe2bFz5VL3/WAObddLIFvaMWTyrNJ/uBPuYTcz4ZSZyxH8sykNfxgDYGb369fvHk2BFklrLcIXKxcWkumyJFsb8Rq898ImJtSdz6UT0QRLhxHEuMnQ3sHLdA8KFiCzLBH7fyRpLgUKgbu6wPxchx4bK4VTyajQQqC75JoJbvveNnA08oHSytDsRanCQcjVLu7tLuok1y8urWJPYlv78uWzpx85gycT1jW+qZuUjNpB7WjuB6Y95zhF+D2y37BJAlP5FiEnyFkEcaxUOiruSQ2N6IYpU3foWGsKl+MrE+sQf9t/pNdfoH/jru+fUSIouaxHdL3DX4G3KxFkmMGx6ikw2dMczmW2KFKeLwWEa2cwP9e+pptReBny3ENdK+d4+IiGh7hOaNeHF63CAQ8wq9bn+V4R26p+rohCCPwRmdWXYV3EmBM/tqHqP2iUK7mt+3ORs2+Rqum38BWDzVsUiPMiG9UpHFFPdd/J/65Fd1JWqZePkH9a92ug1v9klrljGEkZnmY05cx/Cb+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(41300700001)(8936002)(316002)(66946007)(5660300002)(8676002)(7416002)(31686004)(2906002)(4326008)(53546011)(6506007)(6666004)(66476007)(6486002)(66556008)(478600001)(86362001)(31696002)(186003)(6512007)(26005)(44832011)(83380400001)(2616005)(38100700002)(36756003)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG5Eb2tWdG5GZWRMQk9yNUt0VkFiSytQMHA4UGMwaXQ1Ulk3NW53OTQ2bVhy?=
 =?utf-8?B?c1B0SVhHRmErNEtIN2toUldyeWxlTnp0L2s5K2l2UW5TNG84bDB6TCtLMFM4?=
 =?utf-8?B?TkRocFM1WVZBMGV3dFNlNFFXdHVZYXFJaENCcGltR3k4Z1pHVHJ5OEt4V0pu?=
 =?utf-8?B?aUd5Q2hoNGIxcTI1YTlxZWEvK213cUhxdGRqTjVDWDhpZTVOcFJVbXNqTWkv?=
 =?utf-8?B?c1hrbW5OcTF1bUx2WTNMejB2eWlCa0wrOUo2MytVQno5aTJNckE4SjdzaFgx?=
 =?utf-8?B?MUpPTVJLQVk1UHU1djgzbGdLaFFHOHhRSUc4Qlo1c25lY0d2djdZWHl0S2lZ?=
 =?utf-8?B?YWZZVnZsU1gwYWNDaitVdFlBcytsQ3ZkLzRDSHNHUk40a0o0S0J1eXh0cDE1?=
 =?utf-8?B?cHRjNmFyZTNGcG1hUktuaDJtTXMxUk12VHZmSFd6NjdQOC9iU2x5QWQ1Tjhn?=
 =?utf-8?B?UDl3V3N1VjdpbmpSMVlhZDRzNmVGYVh1dnBYdW9rVW56bkQ5b0REOG5VeVlX?=
 =?utf-8?B?Q1lNNGIwekEzZCtTc3VyM3I5RmNLWW1MVWZkWkJUKzdFNkRhUmtLR1VZdW1n?=
 =?utf-8?B?NUhVa01aczk0bGx0SzdpL01NdGNCK0pROGs5VS9hNExNeXI1QW4wWjVzME1o?=
 =?utf-8?B?eVF1SG9JWk5uczM0NXM4MmI2Y2YwTXJpd0pBazl5TVFwc3J4TXh1aW9tRkdo?=
 =?utf-8?B?b0VpT2VNRWJmUjlFbzNCL2hadmRTWG1RQVN5SDlEK2xlbENTaEF1aEFUa3Iw?=
 =?utf-8?B?akZldnRxVFdxSzk2OFlVUWQxTTNXcmk3ODV1V3YraUx3L2RuMytMOFVtVlRU?=
 =?utf-8?B?c0tWWWdMamJTa0U0a1o4N2YzZkcrWlRzWDIwMGtrdEZSUk9IR3V1a0loRTk2?=
 =?utf-8?B?THR2NFVRYXE2MjFFNTlXQlBtdlF6UXBlZWI5ZzZmVHZPZ3hja2g4YmVlYmN6?=
 =?utf-8?B?UTZwZFBYdkN6cHNhRXE3cTl3dExPMDdpWktJS1FIQk5MbEQvTVVRWVowT0FL?=
 =?utf-8?B?SE1GMG9qSlNLVXlQbHllQjk0T2tRWEY3VndQT1pHNFZBWjcxN0c1YlZBWEp2?=
 =?utf-8?B?SXgxV0RPTXh6d2YxVjZlZ0tRVkVKRy9MbFRXNDZFUC9YU2lGVzV1bURyWGhG?=
 =?utf-8?B?WFh0K3M0Lzg2WVl3M25ueit3Vk0rYlpOYkpqNEh0UTRKUERCbHVEWkdqQnNY?=
 =?utf-8?B?MnFwa1UzdnNDeFp0YXc1aUExdEJHQWFZdUcyOFo5Sm83ZWl6TlErV2p4SVdr?=
 =?utf-8?B?b0ltT2dQYWZGVWtFTUNQa1FuT1ZaOERFRThCYTJMd01XR1N3V2xlK0dhWnFz?=
 =?utf-8?B?djZFVWVPdEduSFZuenFZWU1BOXRtTWs5MzAyWUE2WTB5REFiMG9SYk8waFp0?=
 =?utf-8?B?K01iQUxGY0U1dXc3dVV6Tkt4NFFrc2Y5bi9qemNtNFdXdW9CL0FxbVJLVVNK?=
 =?utf-8?B?RjdDM293Sy9pQ2tPazVMNWZiZnRoT25MZnBFMHFZMDBNdWcyUTVCS2lCSEoz?=
 =?utf-8?B?M3Z5M0Y1SGZ1TGc2dFBlSUI2TmpsN1pEa2FGcjNWSkZlSzU2Zm9meVNBbkpJ?=
 =?utf-8?B?U2FyYXZLOUlDQ01LSXNIeWxmUWNTMVVZUHhLaXVUTU5zZVF6UU8yalhlY21T?=
 =?utf-8?B?S2h2WGJYeTQ3S3pBUFdFNG05NWMrTnl3emgwUUJJVzZWVWZKc29GTTNFeTZX?=
 =?utf-8?B?dWorQjFvZEZZR0x2OE9wZ2RpWHlVQVdVLzhMNjcyeGs0KzE3RjcwN0hEYkR6?=
 =?utf-8?B?Z3haQkp2eXY1c3FoeHZ0YXRnUWRCNDhXV2tkQ01PRlBhZCs2TVRuY1c4Yk9z?=
 =?utf-8?B?L2ZpbnV5eDhyVmtZelhGUjk0OXdmdzd0MWp5dG1OcjhORGloVXFsdzBESmdo?=
 =?utf-8?B?R2VZaCtyY1drVldIL3V2M1ZXb1NiTTJFVGFjeFlaN3FXMlpQNXlqTWtMVzFL?=
 =?utf-8?B?TkNDa2NkeFR6NjFPT2pEWG1KS1pldmQ3TGo2YXhjRDdadXhkc05pckhBRzZz?=
 =?utf-8?B?cUFFVXdsZHc0bGRQTEFTMS9jY2pLaWpEN1hKTWJxTXBPVzhNYUV2OGROS0RZ?=
 =?utf-8?B?REFDYlZYMksrZ0YwVHl1Z01acU40dHYrYWVaakVQVDFMLzk1QlRMbDRjZFNw?=
 =?utf-8?B?enVFRUdVWWhaUHJLdDcrK3dlYlhqVEFVeGJHb0hHT1A1ZVZkV2hGME1JMEt2?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d33b25f-979e-473f-0ee6-08daf01438cf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:31:27.2420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItRzpiRrzpqpzp87KRyIqJM++Yz9sQ4UrGIfryzESQJx1I3CPHzcP4SsxwC8ZTddMB9F/aTcnE8LpjIkSu13TOwMv0ztZ7I9uBYJ6JsjVt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6429
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 8:26 AM, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> To support cases such as FW update or Core dump, the t7xx
> device is capable of signaling the host that a special port
> needs to be created before the handshake phase.
> 
> This patch adds the infrastructure required to create the
> early ports which also requires a different configuration of
> CLDMA queues.

nit: use imperative voice in your commit messages: no "this patch".
instead:
"Add the infrastructure..."

> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> --
> v3:
>   * No Change.
> v2:
>   * Move recv_skb handler to cldma_queue.
>   * Drop cldma_queue_type.
>   * Restore prototype of t7xx_port_send_raw_skb().
>   * Remove PORT_CFG_ID_INVALID check in t7xx_port_proxy_set_cfg().
>   * Add space before */.
>   * Drop unnecessary logs.
>   * Use WARN_ON on early port.
>   * Use new MISC_DEV_STATUS_INVALID instead of MISC_DEV_STATUS.
>   * Use macros instead of const identifiers.
>   * Change ports member type from pointer to array type.
>   * Prefix LK_EVENT_XX with MISC prefix.
>   * Use t7xx prefix for device_stage enums.
>   * Correct log messages.
>   * Don’t override pkt_size for non-download port under dedicated Queue.
>   * Drop cldma_txq_rxq_ids.
>   * Use macro for txq/rxq index.
>   * Use warn_on for rxq_idx comparison.
>   * Drop t7xx_port_proxy_get_port_by_name().
>   * Replace fsm poll with read_poll_timeout().
>   * Use "\n" consistently across log message.
>   * Remove local var _dev prefixes in fsm_routine_start().
>   * Use max_t.

...


> diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
> index c41d7d094c08..44352cd02460 100644
> --- a/drivers/net/wwan/t7xx/t7xx_reg.h
> +++ b/drivers/net/wwan/t7xx/t7xx_reg.h
> @@ -102,10 +102,28 @@ enum t7xx_pm_resume_state {
>   };
>   
>   #define T7XX_PCIE_MISC_DEV_STATUS		0x0d1c
> -#define MISC_STAGE_MASK				GENMASK(2, 0)
> -#define MISC_RESET_TYPE_PLDR			BIT(26)
>   #define MISC_RESET_TYPE_FLDR			BIT(27)
> -#define LINUX_STAGE				4
> +#define MISC_RESET_TYPE_PLDR			BIT(26)
> +#define MISC_DEV_STATUS_MASK			GENMASK(15, 0)
> +#define MISC_DEV_STATUS_INVALID			GENMASK(15, 0)

I don't see any uses of this, even though it's mentioned in the commit 
message. The only reason I looked was because it was weird to have 
DEV_STATUS_MASK and STATUS_INVALID be the same values, is that correct?


> +#define MISC_LK_EVENT_MASK			GENMASK(11, 8)
> +
> +enum lk_event_id {
> +	LK_EVENT_NORMAL = 0,
> +	LK_EVENT_CREATE_PD_PORT = 1,
> +	LK_EVENT_CREATE_POST_DL_PORT = 2,
> +	LK_EVENT_RESET = 7,
> +};
> +
> +#define MISC_STAGE_MASK				GENMASK(2, 0)
> +
> +enum t7xx_device_stage {
> +	T7XX_DEV_STAGE_INIT = 0,
> +	T7XX_DEV_STAGE_BROM_PRE = 1,
> +	T7XX_DEV_STAGE_BROM_POST = 2,
> +	T7XX_DEV_STAGE_LK = 3,
> +	T7XX_DEV_STAGE_LINUX = 4,
> +};
>   
>   #define T7XX_PCIE_RESOURCE_STATUS		0x0d28
>   #define T7XX_PCIE_RESOURCE_STS_MSK		GENMASK(4, 0)
> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> index 80edb8e75a6a..76fb5d57d4d7 100644
> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> @@ -206,6 +206,34 @@ static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
>   		fsm_finish_command(ctl, cmd, 0);
>   }
>   
> +static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int status)
> +{
> +	struct t7xx_modem *md = ctl->md;
> +	struct cldma_ctrl *md_ctrl;
> +	enum lk_event_id lk_event;
> +	struct device *dev;
> +
> +	dev = &md->t7xx_dev->pdev->dev;
> +	lk_event = FIELD_GET(MISC_LK_EVENT_MASK, status);
> +	switch (lk_event) {
> +	case LK_EVENT_NORMAL:
> +	case LK_EVENT_RESET:
> +		break;
> +
> +	case LK_EVENT_CREATE_PD_PORT:
> +		md_ctrl = md->md_ctrl[CLDMA_ID_AP];
> +		t7xx_cldma_hif_hw_init(md_ctrl);
> +		t7xx_cldma_stop(md_ctrl);
> +		t7xx_cldma_switch_cfg(md_ctrl, CLDMA_DEDICATED_Q_CFG);
> +		t7xx_cldma_start(md_ctrl);
> +		break;
> +
> +	default:
> +		dev_err(dev, "Invalid LK event %d\n", lk_event);
> +		break;
> +	}
> +}
> +
>   static int fsm_stopped_handler(struct t7xx_fsm_ctl *ctl)
>   {
>   	ctl->curr_state = FSM_STATE_STOPPED;
> @@ -317,8 +345,9 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
>   static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
>   {
>   	struct t7xx_modem *md = ctl->md;
> -	u32 dev_status;
> -	int ret;
> +	struct device *dev;
> +	u32 status, stage;
> +	int ret = 0;
>   
>   	if (!md)
>   		return;
> @@ -329,23 +358,55 @@ static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command
>   		return;
>   	}
>   
> +	dev = &md->t7xx_dev->pdev->dev;
>   	ctl->curr_state = FSM_STATE_PRE_START;
>   	t7xx_md_event_notify(md, FSM_PRE_START);
>   
> -	ret = read_poll_timeout(ioread32, dev_status,
> -				(dev_status & MISC_STAGE_MASK) == LINUX_STAGE, 20000, 2000000,
> -				false, IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
> +	ret = read_poll_timeout(ioread32, status,
> +				((status & MISC_STAGE_MASK) == T7XX_DEV_STAGE_LINUX) ||
> +				((status & MISC_STAGE_MASK) == T7XX_DEV_STAGE_LK), 100000,
> +				20000000, false, IREG_BASE(md->t7xx_dev) +
> +				T7XX_PCIE_MISC_DEV_STATUS);
> +
>   	if (ret) {
> -		struct device *dev = &md->t7xx_dev->pdev->dev;
> +		ret = -ETIMEDOUT;
> +		dev_err(dev, "read poll %d\n", ret);
> +		goto finish_command;
> +	}
>   
> -		fsm_finish_command(ctl, cmd, -ETIMEDOUT);
> -		dev_err(dev, "Invalid device status 0x%lx\n", dev_status & MISC_STAGE_MASK);
> -		return;
> +	if (status != ctl->prev_status) {
> +		stage = FIELD_GET(MISC_STAGE_MASK, status);

if stage is only used down here you can declare it locally. cppcheck has 
a check that will find these for you.

> +		switch (stage) {
> +		case T7XX_DEV_STAGE_INIT:
> +		case T7XX_DEV_STAGE_BROM_PRE:
> +		case T7XX_DEV_STAGE_BROM_POST:
> +			dev_info(dev, "BROM_STAGE Entered\n");
> +			ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
> +			break;
> +
> +		case T7XX_DEV_STAGE_LK:
> +			dev_info(dev, "LK_STAGE Entered\n");
> +			t7xx_lk_stage_event_handling(ctl, status);
> +			break;
> +
> +		case T7XX_DEV_STAGE_LINUX:
> +			dev_info(dev, "LINUX_STAGE Entered\n");
> +			t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
> +			t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
> +			t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM |
> +					     D2H_INT_ASYNC_MD_HK | D2H_INT_ASYNC_AP_HK);
> +			t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_NORMAL);
> +			ret = fsm_routine_starting(ctl);
> +			break;
> +
> +		default:
> +			break;
> +		}
> +		ctl->prev_status = status;
>   	}
>   
> -	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
> -	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
> -	fsm_finish_command(ctl, cmd, fsm_routine_starting(ctl));
> +finish_command:
> +	fsm_finish_command(ctl, cmd, ret);
>   }
>   
>   static int fsm_main_thread(void *data)
> @@ -516,6 +577,7 @@ void t7xx_fsm_reset(struct t7xx_modem *md)
>   	fsm_flush_event_cmd_qs(ctl);
>   	ctl->curr_state = FSM_STATE_STOPPED;
>   	ctl->exp_flg = false;
> +	ctl->prev_status = 0;
>   }
>   
>   int t7xx_fsm_init(struct t7xx_modem *md)
> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
> index b6e76f3903c8..5e8012567ba1 100644
> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
> @@ -96,6 +96,7 @@ struct t7xx_fsm_ctl {
>   	bool			exp_flg;
>   	spinlock_t		notifier_lock;		/* Protects notifier list */
>   	struct list_head	notifier_list;
> +	u32                     prev_status;
>   };
>   
>   struct t7xx_fsm_event {

