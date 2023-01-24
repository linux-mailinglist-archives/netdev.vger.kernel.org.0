Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AD0679645
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjAXLLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjAXLK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:10:57 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0748644BFE
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674558645; x=1706094645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4fHxUYBvauRv/VoB+NmZIAJukrrktJuF63pnNPyAJyU=;
  b=BB5cBdPHSkDeGoFn7pNuEZQGzglRdsD5l+VZnPWQLsvLBJeybl7A4c4M
   US4vO3FGjlhkHvjABPKZGzMM9vq+p9SSIjtCye9VqaxQhKazegWHzZVLK
   Z2Slm5vckFYeT+N4b8Xad1Q8zUxwc6YelBb2ou2LrK7yEPrLwoUiYA7fG
   IEwit/bFk2m18hWGxBKuXi+HUZXgjQKeurY1ObZCdubcdv8MEOP/BlcCl
   MxbGIZEf+XsztJCq6HlH54b7WqM2NXA5kkazXeJxQ3iwUoGWCgHFqQygk
   GOQiWpLbDk6WS3Gl9dWa+t3fmYTw2joPMEESuRR3qU5Aja12WChNKurxl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="323965995"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="323965995"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 03:10:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="990836879"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="990836879"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2023 03:10:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:10:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:10:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 03:10:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 03:10:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7kKyjJsFQeYzy/CP86MiiiBH1ZPpYQnNTZqvFV1GOaPgoy9Tjepf/GjVTjrmUwp56NPclUHMie7KtigfabGZ3mjJYja9TF5RD+kcRemAQGJasMs0rSUBT0YJIIAZO1i71b4f0bBqD1ARHNfPg2fWs0bjIFkeF1vePo4PPhQxhMLZnuhJ6/ut7dHQhyjgJ1c86mi4ROpR1iq+d4wbikAtqNw7QSN57zA/tas1CdMOYuGXUbmBIkVywjEJlrc/oX/S93TzXAC7OtEBE9gJQCtOgnFUys00ekBWp7vBOMDPbTenaWDlzGi7M3GMW6oBND0OKB8fio8XwnxFocCq3/Lnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRZPoJI6Qrk+hKJm1ljHvej/pnfen4mle+p/8hRR8dk=;
 b=ZhIqZkQ4I7RDRZJRJk4CO0prwTyax5x8LCt2D9q0Y6Hl5qgXoj+zz37+PVEhLucUvRd7mvQBgmuhFxbSrcCmYeZKcgOAnRD99trGK1BG/ZApqB7GMRoo1HLssqTx3vzsu61KZuDhJRnXikERQZSnm+gHel2drYgc3W2ysnV1l/DOjB+vFYBv8wI+U93MzfKDE5nFF6JTkUl5DGIaMXUh7UM1g14SyBsORwY1FQ5jL8l97NZbC+9VsMb7BpmDW2LqM+F3ElEr74No/aJGsjbq17wn6M0f8K9tN0ePPM/QLfCyOWEYP+L2CG8TYLM0vjz45VMYPvY/121gkoH7tlerow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7387.namprd11.prod.outlook.com (2603:10b6:208:421::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:10:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:10:39 +0000
Message-ID: <f4ed2416-3cbe-83e9-be1c-9d993224b44e@intel.com>
Date:   Tue, 24 Jan 2023 12:10:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH net-next v14] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <bang@vmware.com>,
        "Yifeng Sun" <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20230124044515.17377-1-u9012063@gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230124044515.17377-1-u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0027.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7387:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf4bb54-2715-40c7-4095-08dafdfba00d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RBF2MZwcSJrJUG65vbA6eWk4rL8IewOkR2u/e37NUyyRE9eSA6SjSiaAufbn7hKleGlupYke/b1lehVjefRk89ml4eTDJt1CyCgr026tAOeXAJfemqqu/VMeQgm231qdbYIz4XCuH//CnYW80V5Ys5oIR65QZBW4NTlmVcpM1pgOt8/iQimyvmzfdcRJUd1W098FI6DHtODQUw/vi/vJxxMfkNbSJZhgfp8s+eLDTgC4CzrdJR5wLKgmjHKyfmSnFjLaQq1gW0W3+1Y3hPwEaNiqxV+SmvMDddHWE0jXoX7hnqz4Fqc4GrGCLH+cFGTJQcRKwi+Cn2kNObxiNFA64CcBAkfFLl+ugPfp+ChxDdq4up0OHE2qo1yabqtvB88ny8v19XcDQZifuB2RtrdphlXI0p3Xpcs1SPfmACJoqLAhVgaMst5X/lqiT5A+wyrsy89enzTZCYVLLpSdX+q4dsSBsNdaro55HeuY36MfFjnR3NNDEoiaZHiKdVCnmJ+BswTuz5N6aN5qowEQc5KFcr7jVsD2B+vINaHgWa4O1w0zjCMZJet1bEWqxtsJ3XjBR0Bh6jbDAzFdVZTdpQn52eaBU8sZAI11f4WIaFG7+G/LBPFQAf2ttaS2z2nHFUMzCCixUzCkRO2+aGnydlvhGkm/U8RdU5p2MR8gsNbWlehiiryeJF+kQYZzfKi3NM8/LJ3FG5ztK4uQ8upyAf03jce7KWSvjKP4TPlvF4dahg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(83380400001)(38100700002)(31696002)(2906002)(5660300002)(82960400001)(8936002)(41300700001)(4326008)(6512007)(186003)(26005)(6506007)(6916009)(6666004)(66556008)(316002)(2616005)(66476007)(19627235002)(54906003)(66946007)(478600001)(6486002)(8676002)(86362001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enk1Y2E1ZEROSks0Nlh3L1I0c1htYVZSMHQxb1daOWkxU2ZrN28zc1FHUUpC?=
 =?utf-8?B?SGZYM1hIdVY5Y3p3QW1QQ01BMEhNdE1WU202bVpTSHlWT2ZTK1RTZGFNZHBx?=
 =?utf-8?B?M1NTYnhwV2RXQ2J0TXIxb3ZBS2s0RUJ5ZDJzRk9WREFUMlY5dFFvSTJ6ZDJT?=
 =?utf-8?B?U2hkaDRsT1FVczRiclhVVGdITS9RbFRsSU80M3RVZlY4VnZPWmVxYkZ1d1Zy?=
 =?utf-8?B?OVdjNzZNUFhNb01HUDhucnhvNFVpZmh0OHQ0MHdXcFZBSHZWdkVhS2hJdlgx?=
 =?utf-8?B?ZXFvZWd6c1BxdklzdUhSaHBHVnAxNEx5V2tZNG5HN05rcmcvdWhTcGZHbkJn?=
 =?utf-8?B?OVhtVkZPTnlvT0E4WWlyazZSRW1vOS9ML1AxRVVWc1FOS1h3MGlJNlZwd1Jt?=
 =?utf-8?B?ZmJ0YUZCcElUNUJBV3dBR1RhL1lXK1lGNlo1UFduWWoxd0JpUmRSM1ZJaEFm?=
 =?utf-8?B?ckFLajFZWjNTUGp4MVNvWG4vQllGcmc4WExOcVgrZWkvOVFYWFR5RUNjQWpo?=
 =?utf-8?B?eHpQeWhERG5VdU5QRnV2TzJSTDRxaDVjbitycHhDMFQzUXJBQytNeUJNdTNl?=
 =?utf-8?B?M2dHWXVUQmlHc2ZOQytFUElPTWppUWVtNEtLYktieCs0SkZrbFlVUUFMRGIr?=
 =?utf-8?B?UG5KaHBNa0dyM2pIbHlwS3BEa3VQZkpHdzIyV0xIczByWEVabXU4SmROSVhI?=
 =?utf-8?B?YmMwckdqL0pjcnV4UGRObFVKU2RnRW1IZGtEc1dVczR1eW9FbEhrY0ZuVU4z?=
 =?utf-8?B?YU5mZ0ZRUTRsMWZXMmdic0R1YnMxc1BaRjIrKzYxb09oMXdFeGo5VlJuWVFW?=
 =?utf-8?B?NEJCZTBmY3QwSDl6M2U2dkMyQ0pwd3RWS3V2U0Jpei9HRkNTZkpWYVhHVnFL?=
 =?utf-8?B?Ulo3Vlg0NmQyR3FkWWtSVEFvQml0Sjd4c2JKS1NyTzdoOHRQTFAxRTVJWG1P?=
 =?utf-8?B?TjJydjFwVFkveVZhZmh0eUVpMmlNcDlJajZVL2pnYlh5NUdTaTc2VDNJZzJp?=
 =?utf-8?B?Z0dMRms2VW56Rnp0R0ZMOThBcVpCbGEvYlY3VzJ5ZHJxTWxSNDZQRlRGSnFQ?=
 =?utf-8?B?eC8rTit4L0JNVGVQUHkzT1FSczA2UVlBRGR0V2RVcm5rRjZoeFdVMklWbDV0?=
 =?utf-8?B?SFBvSjJSMXVaNGcvMWg3MC94MHRna3JiSnFKaVYrb3l1S0RGbnhaK1BCRktL?=
 =?utf-8?B?c2hzQmFSK1hqOEFObVNNaFNMam56TEoyWDArekU1VkZHTDZCMWFMbm1LRDhM?=
 =?utf-8?B?d0I4dXNrTHc3WkxoU29aUk1lNGU4L1drZndiWDNuSERFZlFFTnRLbEhmUW1R?=
 =?utf-8?B?cFpFeEErVmx6UjVLbE9VbTI4RklTdTUzS3I1OWQxSjRNMmdDK1dtUXp3SGIx?=
 =?utf-8?B?SWhESFlwTVg0TlB3a1dueERldllHNUpJeGVMVTdHM1VOMzVid2hLL3hDbzR6?=
 =?utf-8?B?eE5HbWIxbGkyMEo2VmEvWUkzbE9wYVFHbElXdEI2VUp0UjlLZzhhZ2FKVkRZ?=
 =?utf-8?B?Um81azBzcElESjdpOGwxdVY5ZGRxTEtnUkgwUU1yb0M5YU4rRko3N0pWdlZl?=
 =?utf-8?B?c2ZjQnBuWHRpalUxRnNINWc1T1lzbGRzTFl5MkM4eWpmeHVxQnk0QjV0MXEz?=
 =?utf-8?B?ekNpSmV1N2tUb1ZrYlpmSXl0Z1YwdUxvbVc4YXhlaDg5dTNjckVaWE41eGla?=
 =?utf-8?B?Y24vcThEa0hQMElBZ0NJb0JSbGJLNE9jZFlDM2NlUE4xc05WdHZ3U1hnbU5x?=
 =?utf-8?B?RjkxaGZzZkt5S3V1UDc5bUJ1MHJRdHRPTENEMTRsMWxYWXFtUjFjbG4yRU5v?=
 =?utf-8?B?ZkVYRGVNbmREUFloL2RkeUtsaUlmdXBwaFh6ZWNoSFpDUTl0aE90dzU4Qk5m?=
 =?utf-8?B?NEFrUk90NjhvdXhWZkg3MUU0a0hKWktBelB3dUVaemJKdVEvWGp3bjdYSERK?=
 =?utf-8?B?aksxYkxxNGx2Rzh0eEQ3TUlkK09ITDlRdUFrS1hLY1NhdloxUStUekMzZ1Bv?=
 =?utf-8?B?NnRkLy81cVFVSWt6SjE3U1ZZTWZISmorY3hEVy9jMm1EU0VFVTM2TEcvZDc3?=
 =?utf-8?B?eDcyZkNUK0dRQllCQ3lCQXNHc2tGQjdVOEN5RndHMWZKNVh1UTBjT2MrVGtD?=
 =?utf-8?B?MFg4S2tLMzNLR24rdmdQYml4enk0Y0ZNc21sc2VSQWVJenRkRi9GekprWGVX?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf4bb54-2715-40c7-4095-08dafdfba00d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 11:10:39.2687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LjyQmgPZEgNRGwEfkkHcvlfvZJsJcDWQ4lIYO0mJ+pw8UeZTH/Zc14MD7MESqt/JuD4Aev4KJ/a+SllCer1/S9D2iraKYZoJyXSYFJgzHVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7387
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

From: William Tu <u9012063@gmail.com>
Date: Mon, 23 Jan 2023 20:45:15 -0800

> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> 
> Background:

[...]

> @@ -414,26 +427,34 @@ static void
>  vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
>  		   struct vmxnet3_adapter *adapter)
>  {
> +	struct xdp_frame_bulk bq;
> +	u32 map_type;
>  	int i;
>  
> +	xdp_frame_bulk_init(&bq);
> +
>  	while (tq->tx_ring.next2comp != tq->tx_ring.next2fill) {
>  		struct vmxnet3_tx_buf_info *tbi;
>  
>  		tbi = tq->buf_info + tq->tx_ring.next2comp;
> +		map_type = tbi->map_type;
>  
>  		vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
>  		if (tbi->skb) {
> -			dev_kfree_skb_any(tbi->skb);
> +			if (map_type & VMXNET3_MAP_XDP)
> +				xdp_return_frame_bulk(tbi->xdpf, &bq);
> +			else
> +				dev_kfree_skb_any(tbi->skb);
>  			tbi->skb = NULL;
>  		}
>  		vmxnet3_cmd_ring_adv_next2comp(&tq->tx_ring);
>  	}
>  
> -	/* sanity check, verify all buffers are indeed unmapped and freed */
> -	for (i = 0; i < tq->tx_ring.size; i++) {
> -		BUG_ON(tq->buf_info[i].skb != NULL ||
> -		       tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
> -	}
> +	xdp_flush_frame_bulk(&bq);

Breh, I forgot you need to lock RCU read for bulk-flushing...

xdp_frame_bulk_init();
rcu_read_lock();

...

xdp_flush_frame_bulk();
rcu_read_unlock();

In both places where you use it.

> +
> +	/* sanity check, verify all buffers are indeed unmapped */
> +	for (i = 0; i < tq->tx_ring.size; i++)
> +		BUG_ON(tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
>  
>  	tq->tx_ring.gen = VMXNET3_INIT_GEN;
>  	tq->tx_ring.next2fill = tq->tx_ring.next2comp = 0;

[...]

> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	unsigned int max_mtu;
> +	bool need_update;
> +	bool running;
> +	int err;
> +
> +	max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VMXNET3_XDP_HEADROOM) -
> +				    netdev->hard_header_len;

Wrong alignment. You aligned it to the opening brace, but the last
variable itself is not inside the braces.
Either align it to 'SKB' or include into the expression inside the
braces, both is fine.

> +	if (new_bpf_prog && netdev->mtu > max_mtu) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +		return -EOPNOTSUPP;
> +	}

[...]

> +	default:
> +		bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev, prog, act);
> +		rq->stats.xdp_aborted++;
> +		break;
> +	case XDP_DROP:
> +		rq->stats.xdp_drops++;
> +		break;
> +	}
> +
> +	page_pool_recycle_direct(rq->page_pool,
> +				 virt_to_head_page(xdp->data_hard_start));

Nit: you can reuse the @page variable to make this one more elegant, too :)

	page = virt_to ...
	page_pool_recycle_direct(pool, page);

> +
> +	return act;
> +}
> +
> +static struct sk_buff *
> +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
> +		  const struct xdp_buff *xdp)

[...]

> +	page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
> +	if (unlikely(!page)) {
> +		rq->stats.rx_buf_alloc_failure++;
> +		return XDP_DROP;
> +	}
> +
> +	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,

Isn't page_pool->p.offset more correct here instead of just
%XDP_PACKET_HEADROOM? You included %NET_IP_ALIGN there.

> +			 len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	/* Must copy the data because it's at dataring. */
> +	memcpy(xdp.data, data, len);

Aren't you missing dma_sync_single_for_cpu() before this memcpy()?

> +
> +	rcu_read_lock();

[...]

> +int
> +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +		    struct vmxnet3_rx_queue *rq,
> +		    struct Vmxnet3_RxCompDesc *rcd,
> +		    struct vmxnet3_rx_buf_info *rbi,
> +		    struct Vmxnet3_RxDesc *rxd,
> +		    struct sk_buff **skb_xdp_pass)
> +{
> +	struct bpf_prog *xdp_prog;
> +	dma_addr_t new_dma_addr;
> +	struct xdp_buff xdp;
> +	struct page *page;
> +	void *new_data;
> +	int act;
> +
> +	page = rbi->page;
> +	dma_sync_single_for_cpu(&adapter->pdev->dev,
> +				page_pool_get_dma_addr(page) +
> +				XDP_PACKET_HEADROOM, rcd->len,

Same.

> +				page_pool_get_dma_dir(rq->page_pool));
> +
> +	xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,

Same.

> +			 rcd->len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	rcu_read_lock();
> +	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		act = XDP_PASS;
> +		goto refill;

Is it correct to go to 'refill' here? You miss vmxnet3_build_skb() this
way. And when you call vmxne3_process_xdp_small() later during the NAPI
poll, you also don't build an skb and go to 'sop_done' directly instead.
So I feel you must add a new label below and go to it instead, just like
you do in process_xdp():

> +	}
> +	act = vmxnet3_run_xdp(rq, &xdp);
> +	rcu_read_unlock();
> +
> +	if (act == XDP_PASS) {

here:

> +		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> +		if (!skb_xdp_pass)
> +			act = XDP_DROP;
> +	}
> +
> +refill:
> +	new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
> +				       GFP_ATOMIC);
> +	if (!new_data) {
> +		rq->stats.rx_buf_alloc_failure++;
> +		return XDP_DROP;
> +	}
> +	rbi->page = virt_to_head_page(new_data);
> +	rbi->dma_addr = new_dma_addr;
> +	rxd->addr = cpu_to_le64(rbi->dma_addr);
> +	rxd->len = rbi->len;
> +
> +	return act;
> +}
+ a couple notes in the reply to your previous revision. I feel like one
more spin and I won't have any more comments, will be good to me :)

Thanks,
Olek
