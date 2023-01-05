Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE565F32B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbjAERwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbjAERwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:52:17 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F195106
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672941136; x=1704477136;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DgDZDNuKfhhlK4KZcWBnHc+kr6KfbExG3lGw8i0DG0E=;
  b=HgRre4Fry2mZJiBtkH5FqAgAShVKb5v6cOA0NbjaQLUjqexMLDjP7fwQ
   KrChAYXYZqOG1JdhENGGyEjgt45dXjPI6vRwiyOWiT7Pqmmj47rp+d85b
   TI5c29mW1h3r1Hn6X+Yigoq+Q8j6TFePXnF6Vbh009jvLOSb/BAQoA5WH
   ZRmYlDOreW88Z8tBqb5B+uaZCY2Wqv8sF8H15kdIUmJvr45uRlZQUK4Hf
   gPQvJHeHshGkzlScafStLI3ebmN3oPX0c0/05dYkWY9fGwgkFzFr73psO
   KutRDSz8vMcami7ZNz8QJYyiG6vsoaJJRtYK9e/GqaWJNl/diiBcbbaXq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322339963"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="322339963"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 09:52:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="657601638"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="657601638"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jan 2023 09:52:09 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 09:52:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 09:52:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 09:52:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIkUp1FWId4L83zaEUA9z5gjcG9im1q5DXtAON29+qwWjoBO9C4ykEWKP8M+i3rVo9y+UlgcUpHB2z8Yta/XU9+AOo9Qa9Yu1l3hlMX5FhvekTue2nBR0clFaf2KGyj+guQXN/RFYkN8yNsuHW+8A6AHLN6H8WHw0DpTN3zQjKA9MUrOKafutgl+fPGrDx5SYg5cWYNVbwhMTTIBdmIWO7rwg4Vun7qPe5c57vl7oy3/b/nbjGsQexZF9jv/a79ANcNmW2JhLizwAdF/UiT8HgmxgJPwqvArqSDES+AYXBtChDfTujL/tcxTj8i8xUf/JwdzJbtetTl01BMSHSXVTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIf+c328HejHR6eDMMK1be1O/DEfCMx9L1y9lDTUFIQ=;
 b=Pp93sbLQDk4k2eQseykaIRxlZStKbGpJZ5Wb1PgPUQ9JBm2bQU8+ZacNf3AMFa6hYZ8NXYYcFvu4umTw1Ke/LIDFsN13VZrZyRYQoL0K5lEV/yQ8RldpB3fIsBIOMHpdgjz+q3679sexLshnEgCg1YJYPZ+/v8nfR1VxuRtmwH+lpfiF0rIsaAAk+R6KQ6sQCuGhx9/CnqlMEKVkcyTHH6Bd/a9pg1YyY7u7d5E3brvXVcBw0l0V5qZpJi5mRQFOm2eMNqSlscDaVS/iRwhekleRi6Zhh7HdpuWWQv4RJRmFtVhRbOyidrFCSAu73NwErThZ8Kdr2/D+PL5Gnt1mlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB8069.namprd11.prod.outlook.com (2603:10b6:8:12c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 17:52:05 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 17:52:05 +0000
Message-ID: <b148f80c-fa9a-a663-a723-b8f58de29a24@intel.com>
Date:   Thu, 5 Jan 2023 18:52:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 9/9] tsnep: Add XDP RX support
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-10-gerhard@engleder-embedded.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230104194132.24637-10-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0265.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fd0b78b-dab9-4bf3-a529-08daef458ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tAuWHGf49SFrf6kzCu4Y5B9isfZ5an7VkOKnc6+Z3gigPB07MQoD7/Qve07FaSwqeAYoxwIvXlPvi0U9t0QGAr36R+8UveTb6l9TnWjdH5Xmcfu8iUroyFf8ujq4ClFcpFysu/H/fOrGP0FX6vCmYJ628PsniMcZsDzLXuEmH/7sX+s1/s+SLOdzY8jQ0kff6XMSQHqLui3Bj6dWurEsGKx+D/d76VJB8Og7E9sMpjLjvqvtPOHnF/txE7pF9aAuxM9hZ03dn1lSjgF2S3Dwder4hYqzlm2UqfCe7Rq5W2d27j7LIdiJ3vWxxQwsafkHohIfWECJ8rPnM7KjY3Fl/T2BA6uP6L33V7YkAmt1vLojdR0jWE/92G4crQW618CWPi7PKB96BoYd5Dg4D6cDWOkAsPqFDBSsiN8YMRlOw2F19w7g1PNnLVbZjodXkq3yyzbss1yDfuQXg9b9ovbhwuL8818S1dSOdzVvNHO9UCvGnVciTgBLd+fCo20HIFY3usAaCeatAN0fbOrZAVcfzlSyR4Rwa1HGfYb71nBFCyh9EpisTLdPtCilzeRQy4oh8ZvMQGAQnspd+/n3o8UMsiuaVPal6ukb4cgsQCq3XawxgnQrqvwTY+hRqqaTDUBSjudceI7kAFjP0xKl5K2+4X/wEqTg/H+XberFZXQ7fLLjWGXwgcSPUauf3wxx9iUdq94h+xLmCHCOin1Gp/FgKsO5QVSLy5W8FhKsN5EqClE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(2616005)(82960400001)(83380400001)(186003)(6512007)(26005)(38100700002)(86362001)(31696002)(36756003)(2906002)(6916009)(66556008)(5660300002)(66476007)(8936002)(4326008)(8676002)(66946007)(31686004)(316002)(41300700001)(6666004)(6486002)(478600001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajgzZUZNTEFsY2tVNmR5aFY5RW04OUVBc0ZHN2l3ZjB5MlVxeG0xeHVUTjFv?=
 =?utf-8?B?SnFlSkVCaFIyb3hGVWFsYVBUSTRiY3pEV1hwRkhmMjRlMFNhWEE1YTZ4cjRI?=
 =?utf-8?B?RnBXS2p2R09kVGt2bkw4UlVBaFRKNU92SkVtNXRrTitRWlNQdnJwWWxXVG5E?=
 =?utf-8?B?SFpsbGRqeUg0T2xQL0N0bUNYb3RLNVpCeVBOb2hYTnRiLzhEVDhGK2UxMGNW?=
 =?utf-8?B?TlRDeFhxWGVSNStJNzF1YkJmUkg4UXZ0bmdtNVRMQXo0ckdWTkVqZ1JWM2U2?=
 =?utf-8?B?QWJOaVFEQ1JaRm1FczkwdWVuVzErWUw5QklpWkNudm55cUFhdWxHUGdkZ1dM?=
 =?utf-8?B?MWFmcmE4N2N5bXJNQnlIYlVDcnFhWHJhUXNFa0VHU2xCcjIxM2RETERzUkQz?=
 =?utf-8?B?RjNtSE5tcnNYVGdwVGtSNHQwWmhxYWFLK2JKTTBWUlBrd2crR0ordmt4dlhD?=
 =?utf-8?B?b20zWWtOcGl4SFVOY2tBNENKTTE0TWxOZXFqenIyMlBKS0xwaUlmeFpnaEhZ?=
 =?utf-8?B?aUlicEI2Vkl2S1ZlaDVJTkpIV21uMzd4VlYwbGVJOFY4MDhJcWpRT0FFOCt0?=
 =?utf-8?B?K0RnNW1QQUJ4NFkzZEI3bjE1QVRqNUJYV1R6Q2NIbFZtWVhDclpaZXFSWkow?=
 =?utf-8?B?Tlg1SUN2VEI4WUJSYTcyYUVQRmIyNVhZVGluNXBDRjJnME9SNmRiZ3hyUWYv?=
 =?utf-8?B?aU1qSGZaeTl6SVdXRFZoOGJJSFdvaWR4M2NNRlQzdlByNWZhM2JtbGgrdCtM?=
 =?utf-8?B?OUxjMk8yc1ZsRjRZUGF3RmM1QmlUank1TkZ3RWRqZGE2TGlEOW84UWUyWWNF?=
 =?utf-8?B?WlZNRmpjdUZTK2RCeDEwdGxoNXlaWmc5bE9sVHBPMHpiZmh5R3lOU1NQUVdv?=
 =?utf-8?B?MHo5eG9vL3M1L1VBNjVicFhnRnZMRGdZSjVhTkp0ZU1oSTlscSswMGVQYmJr?=
 =?utf-8?B?SjI1d3VMSDJHTWx4cm15QkorR1ZMN1BadDRXTS95akZIYzlmT3h1NTVaVDVI?=
 =?utf-8?B?T3BDMWsrUytDYWFaL1RDN0RzejBNRnYwdDVRa0xScWJDM0dOUllSZVJ6Mmp3?=
 =?utf-8?B?OWgxajNjdm5tZ0xjUVRqemV2dFBzQzJ1RWc0TjBXL0wyUGVXMjFESzlVZkM1?=
 =?utf-8?B?MXZTN3l3YmgwVjZ1SHNLb3FlQkVkenhxNE5xa3BwbW9sVkNFVTNLaElCb1Vj?=
 =?utf-8?B?SXZTTFBtMXV5MTM1MWhreEcyQjU4OE5JTHZ4WitVMWtXb0taOHluaWJaSHhP?=
 =?utf-8?B?Z2FrMnh2dzRJOHpYVUUyWFdwd0FNZGZlMWJOMCtaVXdlMjFxR3FVQVhuK2sz?=
 =?utf-8?B?R2lJUEwrVFJVQ2JDR0ROeHJNOFR5aEgxNVVvbHlvQWs2U2dFTkN5K21YcDgv?=
 =?utf-8?B?TkxxYld0Q0N3QUlaK0dNT0J3YlBtWFNzZStEenVnSE1lZDNydmo1MWZ0UUUx?=
 =?utf-8?B?Z3ErKzJRUFFneWo2V2hWS3ZsUmFDME5rdFhjNXBZczhoWnV5a1BVYTBISHIv?=
 =?utf-8?B?Z3hUOVR6VW5jemU3SE91dHh5Ujl5eDRmcWQ0eWwycDh4TEV2aWFaSmh3WFdW?=
 =?utf-8?B?d3lmcjdFQm5BVVZnb2pvb3M0Tmx6V1IrQkpGaitUOHNlZnhnL3NEMFJOdllo?=
 =?utf-8?B?M1VUZUxXOStoS0dFRzZRdzZ5bURNMVBBb1h5cndVc08yTE5zckJJVG0vbjJz?=
 =?utf-8?B?MFMvbThSbWVicDk0a1A0MjhOd3d6Ulh0cDYzQ1g4RksxT1N6Yys2bmY1dVpW?=
 =?utf-8?B?Q2hFbXFjaVVEYWI0amNxcitkbVBDMytuTm1yQUl4OUl4M2F0MVhHZWFtTklI?=
 =?utf-8?B?K05pWEJGRk11aXdxdlJNTDhiMXNwNmZXTkZkYUtpckgvaG40aUpoaUpaQ2hC?=
 =?utf-8?B?cDA1SkZHN3Z0NU05Q21YWDEyU2dSUUxZSk5tK01ORXc1Y3E0N0ZaRlVuWmxl?=
 =?utf-8?B?elJBRUNLUW5jb0t6NzliZytnWTc2NVRPeFB1dGVpVkZJTzNqUm9EVEZVMXRY?=
 =?utf-8?B?ZnptMG82SGQyWm9hV3c1Y05LT2xzbFZibmtZcERMUjdPYzZJem1PMGZBamY0?=
 =?utf-8?B?aldpREQ3d0U1UHNiSkxiajdRaVY5UTJEZGZGMnZYejZRdkkySXJaUmR1SUF0?=
 =?utf-8?B?cGRWWnJCdFVwTUU2TFJSL0d4OFduNlI5TTdoWVU3V3FjSDN1V0tCWWJsQjVU?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd0b78b-dab9-4bf3-a529-08daef458ed0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 17:52:05.6197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsmRnJYUFc1PenuFJ8fNWwVye69fYA9tmAINalCu388BySTqo/4KcbdvsORcHliTUEywO17tRfNykj4Jz9GhloCI/s2bGaRDR68NjZcIlrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8069
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>
Date: Wed Jan 04 2023 20:41:32 GMT+0100

> If BPF program is set up, then run BPF program for every received frame
> and execute the selected action.
> 
> Test results with A53 1.2GHz:
> 
> XDP_DROP (samples/bpf/xdp1)
> proto 17:     883878 pkt/s
> 
> XDP_TX (samples/bpf/xdp2)
> proto 17:     255693 pkt/s
> 
> XDP_REDIRECT (samples/bpf/xdpsock)
>  sock0@eth2:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 855,582        5,404,523
> tx                 0              0
> 
> XDP_REDIRECT (samples/bpf/xdp_redirect)
> eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 129 ++++++++++++++++++++-
>  1 file changed, 127 insertions(+), 2 deletions(-)

[...]

> @@ -624,6 +628,34 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
>  	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>  }
>  
> +static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
> +				struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
> +	int cpu = smp_processor_id();
> +	struct netdev_queue *nq;
> +	int queue;

Squash with @cpu above (or make @cpu u32)?

> +	bool xmit;
> +
> +	if (unlikely(!xdpf))
> +		return -EFAULT;
> +
> +	queue = cpu % adapter->num_tx_queues;
> +	nq = netdev_get_tx_queue(adapter->netdev, queue);
> +
> +	__netif_tx_lock(nq, cpu);

[...]

> @@ -788,6 +820,11 @@ static unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
>  	return TSNEP_SKB_PAD;
>  }
>  
> +static unsigned int tsnep_rx_offset_xdp(void)
> +{
> +	return XDP_PACKET_HEADROOM;
> +}

The reason for creating a function to always return a constant?

> +
>  static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>  {
>  	struct device *dmadev = rx->adapter->dmadev;

[...]

> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
> +{
> +	int cpu = smp_processor_id();
> +	struct netdev_queue *nq;
> +	int queue;

(same re squashing)

> +
> +	if (status & TSNEP_XDP_TX) {
> +		queue = cpu % adapter->num_tx_queues;
> +		nq = netdev_get_tx_queue(adapter->netdev, queue);
> +
> +		__netif_tx_lock(nq, cpu);
> +		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
> +		__netif_tx_unlock(nq);
> +	}

This can be optimized. Given that one NAPI cycle is always being run on
one CPU, you can get both @queue and @nq once at the beginning of a
polling cycle and then pass it to perform %XDP_TX and this flush.
Alternatively, if you don't want to do that not knowing in advance if
you'll need it at all during the cycle, you can obtain them at the first
tsnep_xdp_xmit_back() invocation.

> +
> +	if (status & TSNEP_XDP_REDIRECT)
> +		xdp_do_flush();
> +}
> +
>  static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
>  				       int length)
>  {

[...]

> @@ -1087,6 +1189,26 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>  		desc_available++;
>  
> +		if (prog) {
> +			bool consume;
> +
> +			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);

xdp_init_buff() is designed to be called once per NAPI cycle, at the
beginning. You don't need to reinit it given that the values you pass
are always the same.

> +			xdp_prepare_buff(&xdp, page_address(entry->page),
> +					 tsnep_rx_offset_xdp() + TSNEP_RX_INLINE_METADATA_SIZE,
> +					 length, false);
> +
> +			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
> +						     &xdp_status);

[...]

Thanks,
Olek
