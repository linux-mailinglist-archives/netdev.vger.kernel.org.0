Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283BF6E7A9F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjDSNY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjDSNYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:24:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E31718F;
        Wed, 19 Apr 2023 06:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681910665; x=1713446665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9KEtfQ4iIZUlv/YMOpRsQktsrJ3RqeofH7g8pTctUcI=;
  b=YXh40gGp8D2IYzvZCXRaI0o40zZ8nJFcUggIx8TJUAsXuy689XY58mx0
   ZLasfy649aI+MdLWw176TVdzX87epmSBW6191cYCxKS+hlrMDQykKjmrl
   2WF5Rw4ptd8TqLEhoOdHB5UgAxeHxlDwwPFHDJ90T9ypb/XHc8+hoNv+t
   BNw/440q/kYaX0Sv+7U5o07CF9MkDWky39qQ5QC3oMdnEbhiuSj5Li4VW
   lZ7sI1RmLo4LT4j2aMNpGdvXZOhZN9hV+0iiCR3cyjFhRz0hQImKe3puY
   /Q8buHncyi7f7zDDzVmBRUcNbnnLyUzvme2PE91UKul+uodL1vJp7IDGF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="325060293"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="325060293"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 06:23:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="780853545"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="780853545"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Apr 2023 06:23:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 06:23:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 06:23:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 06:23:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3NZGxI9SK51/mwSiELfmnazA5A8Pt4KU7+dvr542QqJYXKwEYb+Jb35QPI5ZdqlGS0pwLd+dgHU+7TtBEsGHt8s8D2xftliZ3160Nfh2iYsZuj4S4WHKIIP1oBFW40gG0FDy/gkDKNP3KotINIJ074gZ5bjfOCS0Vcyx1oKIIYiMDTVl6BfvjTl/ODDOh9EbFRgVD3ro2Tyg21H35AR/tIClYRziAdV+iL8ZXkZ1Ysm8gEKiWm1I7gosaVVuQe5D6ejBnO6OPSLjd6Ff8X/cSTXKvVyVGktwB5N1fg89QBLRhzlZ3rTX+5KXMfrZdmsMipM1ejLwBNtMAvL6Nc9Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4jQTWPOZ1TEOUeqMbB1BNxz4zrXRB7WUwpwzy1Q+xE=;
 b=aF4g1Rs6QQoOWCdBMoPm+BXqTlfxxQxrWyk0x02CF+3RdJopDjlol9jBFUIVqWx71z6t+cNQ4pSvzlq+A2rfjJ0xfVyy/7/qYXsIv4HHtNHmXOYeAKBFIAlfX0cQD09xLUa7eCCmSo6aRUssgSQJ1Z9DVk1EoOEe+IrWDgqh0mGY7IZStgCZgwFz4WhaeOEcqQGoaxtdgk3lqaZjTmh/Q5CBl4OOhQt2lAjZDLKrj6bb6lRwXVP+hZv5xHipMVIws9Qa/F8JzK7UmWW2B5NihbH13DE1ord6UU7fk7e78AwNY/PgNrfUzl+VPbaiFP3NwkcbSt8r1H+s2Oev8UPZEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5411.namprd11.prod.outlook.com (2603:10b6:610:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 13:23:46 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 13:23:46 +0000
Message-ID: <88d5a2f6-af43-c3f9-615d-701ef01d923d@intel.com>
Date:   Wed, 19 Apr 2023 15:22:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR09CA0023.eurprd09.prod.outlook.com
 (2603:10a6:10:a0::36) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5411:EE_
X-MS-Office365-Filtering-Correlation-Id: 94e159f6-16ae-43ce-8820-08db40d94dd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJ1qFcGac2eC7QiGNy9ccYfkDGPaR9WGDtoS4D6i1FRUuU1QGzy5gnrTJ0AgFVWzU6KPUUHLYcdakG+DdeTaqXijp2eeYWbEOsSa/fYMFqIPoZGMLSOyw0gsH5/aD0Niicd3NgSTAm90QjN+xxIr2Nt6mcTRceXYcBRjoamYiXtNZMbENXZNTqhrBol2DLzmLndlKZo3TFwuN/dgXmxcP4L3IQKl2ur+yxxTLBoeoLGzTVs3kM6pWP4g4h/Ia+042KmksH2vOIaK2DxkjH3U75J413waCojAgcwjLUGIEXTSvb58A24YnmxJ3dhSpJSSOxC3jZ6UNKC5Prl6NSEMmZMQF5tFND7y4DjwbxsL55lUfQT/2nHGJx1Hi/2kHcg53MsWmJF8MeIl+6izlSlvXWZHlptPxGwap9B5Yr/Sp9g4nCfbeECYuk4LouU3ig8FM+FGIZvSwQII6KZfIPO8qpp4ZGvUAXh9Ircc3zJTN59WQm355hXLjpPEUFkNwGn5yS6V4HnKCFmps4UlG85TVbKBQPBYMIuRhzyehiIKutPmCJjuQO6+ngXycmYTyxd/anXJ31lgXQQKtsX6KYLSQHz0P3DUvpb71kOI3NVzDsMdSXZ7uojrCh5J7NRUW2ZAhPnrz3HDZdNkSR5CL3jDzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(54906003)(36756003)(31696002)(86362001)(478600001)(82960400001)(41300700001)(8936002)(8676002)(38100700002)(7416002)(5660300002)(2906002)(66476007)(66556008)(66946007)(4326008)(6916009)(316002)(6506007)(6512007)(83380400001)(26005)(966005)(186003)(6666004)(6486002)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1U0NjJ3UmVBL3BXYVlyVy9oWE5sL25hTUFxTGk3OU1nd2E5VlJRU3ZHbGdz?=
 =?utf-8?B?N2s5aXpUNEVlbGdqcm13UitmaEs0a3VHSzlXeHhxQzQ2aFJkRkQ4eTNyT3BL?=
 =?utf-8?B?NThCdERzYWVabENIL2hVRjZWNkcwbDQzY2d3akw5T3FNdHFGWFBObkVRM2gz?=
 =?utf-8?B?MEhJTXZndWRJYXk2eHEvNlZiOFkwMmZ3NGc4ZE9zYTVyVjhnSXpyeXhtRHpu?=
 =?utf-8?B?cEpuOHk2b09DK2R2N0pOWFdwSDNLYzlFQW5LeVQwUjhSei9VTW1za0h2MFZ5?=
 =?utf-8?B?SjNRbFJQZnJ0d1R4RXFveTZISTNDZW5hQWdSR1JyNnlHOTdPcE9yTUxvbzhG?=
 =?utf-8?B?cXpuSXBOMmMzNU5pcHpEb0l2Rk1nZ1dTa1RiRUNIblI1M2lCNHU2dkpDWGxs?=
 =?utf-8?B?ODNMZnJqL2M2NVVkZXBhUStvYUs1Vlc0bWVRS3hBazJ5OURuM2NsS0tmUzJI?=
 =?utf-8?B?WG1uMGZkZjdZZlMvT0EyZFhDRXdOYXBKV3FxakdSdms5azJoRWNLeDNBeFIw?=
 =?utf-8?B?OE5xU0tOeWRZTHpIMTd6UWhBdUViV3VJOUZGbzZIeDB6aEF2WkFYMEtRc3B5?=
 =?utf-8?B?OC80TlJtbncweHB4S3Q0NU9TRWQzWWhrTDlkME9CSG81cXd0bzhlS2dyZ1Iy?=
 =?utf-8?B?TW1Xd0Rla1lJMjc2ZmtlbENKSC9CU0R5d0Ria0NRQTd4dU1VUTZ1RnYwRXpU?=
 =?utf-8?B?cmluL1ZzbVB3WGl6V0dkYmhBblRicEdIWXp4NWdseUNhMHJYMkQxd0QzWG9s?=
 =?utf-8?B?UklZS3ZYMkgrWU94dll5WkpKK1p1bU44L1FBRE4yL2hwamxuM28wRjJERGUx?=
 =?utf-8?B?NTE4Mk5zTUcvM29lelJSeHZTT2wvQldpQ3FWVi9tSHl4Yk80NnlOUElsY2dH?=
 =?utf-8?B?Ry9EQitBbEVYUitjTHBJRkVjTUFyZCtEdnVOMjlVN3F1NkhIeGV4aytWYU9n?=
 =?utf-8?B?N0U0cXFxNUN5dUtrZ3kvZlFBOE90WE12T1I3YTdOeVZMN1ZTUE1IakltNUt5?=
 =?utf-8?B?bDZpWU9aMnNFNmVNSnZjRUE0b2xDRGM4bXYya1QrWkJnd2xGK0FjbndUWko4?=
 =?utf-8?B?a25aeUpzZ1p5ZjlMOEpjSCtHWFc3SnpseGpxbTAxTkR3aUJFQy9OS25MSGxa?=
 =?utf-8?B?ZWd5YzhXbzA4U09UMDJBZXloUERYK1pVVmUyaXphL3AraGV6ZHFoeGgzc3Nx?=
 =?utf-8?B?K3RxeEczdGJ0TzhsZksvbyt0TC9mWkNqc1ZEQlgzTU04NkFVbG1Bci9RUVpW?=
 =?utf-8?B?NDZwZHJFbVhYTENpTlgrQllYbnEyRm5kaVU0eUQ3US80WkNEVlZHb2EvRkpi?=
 =?utf-8?B?eGhhZmkyS0RGbVdXQ3Z0YjVJMzBEeWJjOGhWZjUzays4RmE2bS9hQllya3hC?=
 =?utf-8?B?Y2dEZmt1WHh2V0xXUGhWeXZ3S1RvSW5xanNKVTRIM3hOVGQzSzZFUU11ckNZ?=
 =?utf-8?B?c3RCMVRaV1Nyb3EycGhNcko0eUVCMnFIT0V5WFp2NkNuQzBLbEgrTStJVmVY?=
 =?utf-8?B?UHVOcElYRUJlb01TNzJuU200cVo1QkJEMHhFdVRqcnFudk9SV3VTRmpOMWtQ?=
 =?utf-8?B?VVR2RVZxS3NSRFdlSVR1elMvNlJzTEpsZVJ5WUtSNXJUbXdub1lpN0p6Ymdq?=
 =?utf-8?B?Yko2amVPUUNyWWt1TzNxR0I0MFRvMUllb3JrczdTdDJweW5rOXNDSDhROUtr?=
 =?utf-8?B?VFFvblFtcWdFZmtyVmlkby83VWdsVmVhMnZ0ZjZPS1Vqckh6REJGc01NRzF2?=
 =?utf-8?B?SGZoQXVtanBRQ3cyK1JiRTdqRUVTVEppeUdSVU1EcXNNcktGOFVmU2w2cW9j?=
 =?utf-8?B?MHdGU01BL0RQL2R1SDhqK0Evb0dvVFk3TEZZbVNDZGhabCtBVFo0QUw5K0tw?=
 =?utf-8?B?UEVqMUE3TGd6aGh3eTdXQlI0Sm5LczI0V2pvRjZTZWRoSDR5Rk91VjU0OXYx?=
 =?utf-8?B?SG5xa1NDTmovWXY0NTRJNkE2dTZkeUgvNStKRHEyYVRKNHJUWkxrcnpxeVRE?=
 =?utf-8?B?MTBmWXJyLzRFRVdlajNzckwwZ05oak9DY1ZidFdIN3RNR0FmN05QRHVQeVhZ?=
 =?utf-8?B?a1VvZUxZbXVmZTlSVW1CcjlEUnB2alM4UHJpRm10ZG1iNHBEWktPQVM4QzlL?=
 =?utf-8?B?L3V3WEdsR3d4a2xpMHI5SE5FdHE1c3FuY0hINmVGK3dYU1hvOWFTUi94Tmoy?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e159f6-16ae-43ce-8820-08db40d94dd3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 13:23:46.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoN53pdpeFrnZyWINZ+w97LbK21hMEYqwgP9gH8N1o3pLL9g3xkILoBG9xz84coeJEu4tJfRqfCUdGCFFXF0aqgBY+09xxpEuGODeb3LR6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5411
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Mon, 17 Apr 2023 11:27:50 +0800

> The purpose of this patch is to allow driver pass the own dma_ops to
> xsk.
> 
> This is to cope with the scene of virtio-net. If virtio does not have
> VIRTIO_F_ACCESS_PLATFORM, then virtio cannot use DMA API. In this case,
> XSK cannot use DMA API directly to achieve DMA address. Based on this
> scene, we must let XSK support driver to use the driver's dma_ops.
> 
> On the other hand, the implementation of XSK as a highlevel code
> should put the underlying operation of DMA to the driver layer.
> The driver layer determines the implementation of the final DMA. XSK
> should not make such assumptions. Everything will be simplified if DMA
> is done at the driver level.
> 
> More is here:
>     https://lore.kernel.org/virtualization/1681265026.6082013-1-xuanzhuo@linux.alibaba.com/
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[...]

>  struct xsk_buff_pool {
>  	/* Members only used in the control path first. */
>  	struct device *dev;
> @@ -85,6 +102,7 @@ struct xsk_buff_pool {
>  	 * sockets share a single cq when the same netdev and queue id is shared.
>  	 */
>  	spinlock_t cq_lock;
> +	struct xsk_dma_ops dma_ops;

Why full struct, not a const pointer? You'll have indirect calls either
way, copying the full struct won't reclaim you much performance.

>  	struct xdp_buff_xsk *free_heads[];
>  };
>  

[...]

> @@ -424,18 +426,29 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>  		return 0;
>  	}
>  
> +	if (!dma_ops) {
> +		pool->dma_ops.map_page = dma_map_page_attrs;
> +		pool->dma_ops.mapping_error = dma_mapping_error;
> +		pool->dma_ops.need_sync = dma_need_sync;
> +		pool->dma_ops.sync_single_range_for_device = dma_sync_single_range_for_device;
> +		pool->dma_ops.sync_single_range_for_cpu = dma_sync_single_range_for_cpu;
> +		dma_ops = &pool->dma_ops;
> +	} else {
> +		pool->dma_ops = *dma_ops;
> +	}

If DMA syncs are not needed on your x86_64 DMA-coherent system, it
doesn't mean we all don't need it. Instead of filling pointers with
"default" callbacks, you could instead avoid indirect calls at all when
no custom DMA ops are specified. Pls see how for example Christoph did
that for direct DMA. It would cost only one if-else for case without
custom DMA ops here instead of an indirect call each time.

(I *could* suggest using INDIRECT_CALL_WRAPPER(), but I won't, since
 it's more expensive than direct checking and I feel like it's more
 appropriate to check directly here)

> +
>  	dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
>  	if (!dma_map)
>  		return -ENOMEM;
[...]

Thanks,
Olek
