Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75C03F8AF2
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbhHZPYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:24:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:5278 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhHZPYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 11:24:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="214638360"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="214638360"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 08:23:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="643895714"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2021 08:23:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 08:23:51 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 08:23:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 26 Aug 2021 08:23:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 26 Aug 2021 08:23:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX0Gs5Qm2dPAy/8qAgjmmuanMXr9Hs5rccXts85uaT5UImdVp5H8iTu2oBTk+4xuu3vhi/oMkZja07hILBNU7xNpT8E0Fhc6HCqReAzUF522JHukoQpDWHipNPxnbSsV5ap5UQ5PHE67qlaoKo4MDX0Fol/9Q82Raizd6o0PhCYt+g1Fwi69XvF/qGYz45flkBA/yCcVPbIkBSXcirsY57JkVdfMnVxqGp0HUXuD6Bddv8UkQqBZaKy14bBX1zCdNpTtPpD9qo2uWZdf27GmY0Q/VjXN+irUft9f+uAKJyG/HAM3eWo5ACJkhzbpC5t10o4clJ7e0oyxaVPwZQa8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5D6t6s3ISKzZ9mpgjS1BVGqQyfQUijb6dhAQYtluJE=;
 b=KmqSnWZTpCYfgMCfJcmlWQ3JNEue02oJvfkmSTslwTFFyEyEmAFu+/1MpN4t0Geh71aIk+sW22c5JUA63d7NjcfP7ly0sobY20plyIAv2E2gc52DClFNf+4ZVYDJUz1mWT4UeHDA5b6sE6EOtujGXnPUgiah05jMJ13kQgChi7/CQ4oMaYVtdCLXCVNRSGZKkFe0FHOB4bAkSZVBdTYZDScPqNHnT972r0aoqG59XX+fv6EHQweHB2YISFCcixovxWuzMd2aaULu2EuaQh/RgcKmPhXUxyaRdQyohB/vci4F3+Yro/N6v/LC2Ky6LAmjbvlO8cWu/iCS+EGlC4pnYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5D6t6s3ISKzZ9mpgjS1BVGqQyfQUijb6dhAQYtluJE=;
 b=lF+4eUw34zLVPmq/RvxcXPiARu6jnhtFg40BCFu/tiVdx3zCZpWuSbdgAZ7tDRC56MJsy57PLw3hkK3h9LoZ6Kyce0SFR+PE2KmC7jI2bsTRm1zjjDLe9H8G/+LBFcRSkRqokNy6c49Bcb/SdxgebUELVFU8+w/yYymaLH4IVds=
Authentication-Results: kuaishou.com; dkim=none (message not signed)
 header.d=none;kuaishou.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB1437.namprd11.prod.outlook.com (2603:10b6:301:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Thu, 26 Aug
 2021 15:23:49 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::45e:286f:64a1:1710]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::45e:286f:64a1:1710%9]) with mapi id 15.20.4415.027; Thu, 26 Aug 2021
 15:23:49 +0000
To:     <kerneljasonxing@gmail.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
Message-ID: <d15a1f43-3fea-b798-7848-61faf3ca1e8c@intel.com>
Date:   Thu, 26 Aug 2021 08:23:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210826141623.8151-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR2201CA0043.namprd22.prod.outlook.com
 (2603:10b6:301:16::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MWHPR2201CA0043.namprd22.prod.outlook.com (2603:10b6:301:16::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 15:23:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a444cc-37f4-465c-fcaf-08d968a58105
X-MS-TrafficTypeDiagnostic: MWHPR11MB1437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB14377C7B1518784BC63921C997C79@MWHPR11MB1437.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LPMuh/zaMxMQtkb8Oodv6BbaM3bwZD9b1fk2WCJzQQlv8k4yRojVRfx5MyTBd35U3RhEN6tceGkKKUlE8w5jrgeckpkoTx4Wx++3Lc02B7ItsNuOiRNcNiHGpQ0q1aJZyfry7dq9XQ5Nug3NGb/+z38c7rMHOOFCKw8gjA7S+zibs3Q7Ys6K8zwGnIvbsaJuJ0pkJ2pB5xisWjQk47LfMjw/jlt8eBhbBWYjA1/YSz6JjyZbOK2uQjDMC43NrEUgfcU6tUS2JgK7W38YzgstwC1foy6fa+tzv9SI1NSBKqtgq1IzhnyQWJO/qjYEe3EgMVgh3h9tTu4RPsjSbq9m22lg6qx/ueFetxDw46Yn0+XyjMolAk9lmlij0tlowOfZ8t3oNDAMwnJMRFf2BErdecbL1opv3qFCqUdbsKx/JGoh+wvDX8HRhbyV1VA6MlEjQkF2J+N5tHflKRy/B5Gb+hy+1EsUnpNbSShQRBX2yP02Wmy7o5B95jspVNjd/gmgHNpPwrLFcUABqE659HZqhY5mFAm8VJrRHsCkEGHc+sTWmBk4mAwkXifvbqeDq485wGByilUdWqGHpiOyQJKWtF2tAXuJaOHDMFEug9sIbgwVH6Iyfrhr0sjvokEedhc+hUEyuMEyUEfJDXbAcs2eYKz8X2lsvgW87vGuWuegwJgis/XG9lD097XUvB6sZIz+40odwFxVbdzSOQCJGRhIkb//4Xdc7hGMLprU7MmuYT6vDbecZrgJkOE/oV/YINQOM024FA4L+om5jXICXsWHhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(921005)(53546011)(7416002)(38100700002)(186003)(31686004)(36756003)(508600001)(26005)(956004)(83380400001)(6486002)(2616005)(316002)(66476007)(4326008)(2906002)(54906003)(31696002)(8676002)(5660300002)(66946007)(66556008)(6666004)(16576012)(44832011)(8936002)(40753002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmJidlJDNkRDdHJPam1vUi9RcjB0ZnNtOHNuZmFHNWhTTFMweS90Nk1MKzl4?=
 =?utf-8?B?dkYzeDhKVXZLY1cwdFNxRFUxTlZheUtPdHdRNnBPTVg5TkQ3alBtVHpZKzlv?=
 =?utf-8?B?Ynp0TWdNTjNBcmd6cVR3NjB1WUc4dUxXR2JLSjVhK3RxTGhhQ2ExV2lKSDlF?=
 =?utf-8?B?VXpaYmNZQ0JXbkQ0KzNqLzg5a2xJbVV5eUE3N1NuYStGeHNYNzM2d0g1Sjhs?=
 =?utf-8?B?S3ltOUEwQVgrblU0U3V3MTlydWEvU09kd3ZPOU13L2NuRWJOcHhPUHdubGIx?=
 =?utf-8?B?eDh5QXBQaisxK054aXFmZjFWcTM2RnZFdisrSEtKMmx2RkFYYnVZdzNBRUsw?=
 =?utf-8?B?enViZmUvN0Z5QlYybFlqVTB5WHpFemRSRndFL21WK2RxQWVkdjBwa05FRUVJ?=
 =?utf-8?B?MFVUQ1NHS28wMUpJWjZzKzdYOVZtVWNLYUVEM1p3ZEI2cWNKVlVOdzE5MjBn?=
 =?utf-8?B?QWR5WTBLZGdoUnYrOVpZajJoa1RQcTJWcFV6ZUd6QzM3RUY3UmIxcDVnbHdt?=
 =?utf-8?B?QWlxSmtHV0FERll0NW12SDhaTVlLMk0rKzk4eTlJT3BoZXpzTnVmcmx4RTJH?=
 =?utf-8?B?L1lJek1YS0lmdUlBWldKaTlBNis4QXJoY3FTVXZ1Z2creHY3ODBxSDFtZ21t?=
 =?utf-8?B?ZjRDaXRTMHdib2puVHNzbitYTW4yQWJ4YlB6eUtUMFhjN0Evek8vSUNPekJl?=
 =?utf-8?B?aVVrYkk5SG9kZ1JlTjJLVWtFYjJ3SVlBYmN2c29udGJUNkpVaDBrRmVKbnJl?=
 =?utf-8?B?aWJMVjRJU2tOeUlzLzhFYUtOSkRqbVVid0pUNFpSdnorSWRzaEtwTDk1ZnJs?=
 =?utf-8?B?bmtuTitEZHdQemRXQUc0UW5sVUVHeWNjVEdFTER1cmRyYkZ6SVB5L0VHQVVx?=
 =?utf-8?B?UDRmTGVuWTFYNTZMbkdMZjlxK3Z5OUROd3REcUo2MithZ3R6a2ViSHBiTUQ1?=
 =?utf-8?B?NDhZQ2FYNWxRazA3WmpoUmF5Z01PSkVodzVUYVNwRm91cjVlOGNHL1lUc3J1?=
 =?utf-8?B?dEh3aUNYN3lkOC9nM1hpa2JSK2g2UHovL3pHNXBLeHhjRXB0UExQc1hTQ2JE?=
 =?utf-8?B?S09TYkVOR3BybVRSOFd0OGZCd0RoV3E4WWlLYnA3VjNUNWVQS213UXVYWGRi?=
 =?utf-8?B?NE9jcDFWNEEwSGUrdnNOeTlmUUNCaDFsbmZRMG5WZml5NnJhUnhXN2FxZFdF?=
 =?utf-8?B?RVJrOHArc0RaODJCZGxDRjJoR2xTRUIzNzNoaDZvdm1zRkRrak9XdlR4TkhT?=
 =?utf-8?B?dE1BOUhMQjEvWnp4VFZyYkIxeUZ2cStrYXk1WTArU2d1MXY3dmIybU9xcnpJ?=
 =?utf-8?B?ZmdwcVhJMXExNCtYQzhjUUZmNGJMZkpDYkRBMXlvR3lDeTZTWjZ3ZlAxTGd0?=
 =?utf-8?B?UG9saTFaMkhvaHF6WUJXL2JMVk5EZmRwV2tMUDJ0YXg2dkZsczZYVUtHbnpU?=
 =?utf-8?B?ZG11TTR5aDlnWmx3Rmx1VitHd1c0YTJIWk9wemQ1OTVwOWc0QVpMMytERlZv?=
 =?utf-8?B?VkdMd3BLTUFhWE03T0NuTngxZXJTb3cyODV6Ulh6NzJzUVUwdzRLYTl6QTM5?=
 =?utf-8?B?NGNEYUF3R2ZqL1F3SHRZeXJVbDJyd2krTFdlVHhUWkJ6bmRrTXhYOWR6ckQ0?=
 =?utf-8?B?Y0JQc25FeGUxb1B1MDFpVzU5KzR4bXdORmhhalV5V3I3bmdGTU9FeVhNcUI1?=
 =?utf-8?B?ZXVyN1Rxb242VGVSUTc1QWpSbnhEd0xmTzd1ZkxscHU4dW95VjlOd2VyUkpD?=
 =?utf-8?Q?g55ppxtNUmJQ3+2xmTwld9/IRdOR1vSWWdHSl3n?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a444cc-37f4-465c-fcaf-08d968a58105
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 15:23:49.4326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fgj0ZtCzaYqNoeXn2Q2Bmo+8Otab7kj+hfPQNTWMpdf2DT2FE5NHNmB5HvqyGBCsrN8v0EwesYz33BoDQLqUaOrBQc2Ig+WOPXqNnXGtqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1437
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/2021 7:16 AM, kerneljasonxing@gmail.com wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> server is equipped with more than 64 cpus online. So it turns out that
> the loading of xdpdrv causes the "NOMEM" failure.
> 
> Actually, we can adjust the algorithm and then make it work through
> mapping the current cpu to some xdp ring with the protect of @tx_lock.

Thank you very much for working on this!

you should put your sign off block here, and then end with a triple-dash
"---"

then have your vN: updates below that, so they will be dropped from
final git apply. It's ok to have more than one triple-dash.

> 
> v4:
> - Update the wrong commit messages. (Jason)
> 
> v3:
> - Change nr_cpu_ids to num_online_cpus() (Maciej)
> - Rename MAX_XDP_QUEUES to IXGBE_MAX_XDP_QS (Maciej)
> - Rename ixgbe_determine_xdp_cpu() to ixgbe_determine_xdp_q_idx() (Maciej)
> - Wrap ixgbe_xdp_ring_update_tail() with lock into one function (Maciej)
> 
> v2:
> - Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
> - Add a fallback path. (Maciej)
> - Adjust other parts related to xdp ring.
> 
> Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h           | 15 ++++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  9 ++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 64 ++++++++++++++++------
>  .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |  1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  9 +--
>  5 files changed, 73 insertions(+), 25 deletions(-)

...

> @@ -8539,21 +8539,32 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
>  int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
>  			struct xdp_frame *xdpf)
>  {
> -	struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
>  	struct ixgbe_tx_buffer *tx_buffer;
>  	union ixgbe_adv_tx_desc *tx_desc;
> +	struct ixgbe_ring *ring;
>  	u32 len, cmd_type;
>  	dma_addr_t dma;
> +	int index, ret;
>  	u16 i;
>  
>  	len = xdpf->len;
>  
> -	if (unlikely(!ixgbe_desc_unused(ring)))
> -		return IXGBE_XDP_CONSUMED;
> +	index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> +	ring = adapter->xdp_ring[index];
> +
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_lock(&ring->tx_lock);
> +
> +	if (unlikely(!ixgbe_desc_unused(ring))) {
> +		ret = IXGBE_XDP_CONSUMED;
> +		goto out;
> +	}

This static key stuff is tricky code, but I guess if it works, then it's
better than nothing.

As Maciej also commented, I'd like to see some before/after numbers for
some of the xdp sample programs to make sure this doesn't cause a huge
regression on the xdp transmit path. A small regression would be ok,
since this *is* adding overhead.

Jesse

