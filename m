Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73F86E96F7
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjDTOXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjDTOXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:23:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A48420C;
        Thu, 20 Apr 2023 07:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682000606; x=1713536606;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CV4L5rrlhrl553umOiLb1GVW6pnq3AUzvlMT2GorTiY=;
  b=cwlgL4E84kFSqWvxWW7U6+0nvs3xqPE0p+rHWWKwR1+he+YmabgcT4+o
   lFfmAEskDuuyYnfKp5Z0LWCKm1QxztjBNO7rNT6t0KzJKFGTNMrpyhojW
   D+PpOnNbxErM8X2f8gXxAoawMHkrph4Y6Madti1pDjx9nQZJ7j/u9KzEc
   vLzO/Q48gJ6YB0VksUnfuQf7Cpo8eYYhT4lYXIXhsAo28UdFKSuozp6E1
   aQAgEX2HxpyfkPLj+CTOq7b69ceiTqnLqNMTL9oJHWS5P0LaW9LvKWL7k
   jDYzxJcVGDHQRWa0rcvgxI51I2Yt+kjHbmZ1cX+LcuC+g9mhXTAy0Zl7A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="344497588"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="344497588"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:23:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="685354301"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="685354301"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2023 07:23:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:23:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:23:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 07:23:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 07:23:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8P165cJ8f565Wvrm9Swrsfik9nPikffNrIc/mBe7xVD9dnFunBpidQFhdukyJipVh36oQL9DL9gyhz00CUutulD3uecLYywcTlw5H/4iBxnWs0taBTOu98qBjF/+3gWq1bnGv1HUGDfWxtf8OOgKwgK49fHW2tgV1oe5DXGtYrZzubwZGB1V37Bss0oI5N/Tc9Zm1/yGuU6wijviZPN0BLX4tS5bekOZ0zWrKIEM5oK/S/0vOhjS7hrU0oemYAWUfX/YQzuI8ObxZUX9+29MLI4RidqFeZ25iYNbqzHcbuh0083ipKY3C8hVLjD4MmZ0O6errm+zYkWHPlfHq0QRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCrhhTPr2KcIs73oMK0i1+V4eKlpN3BKJaeeEHvuDSQ=;
 b=Y/B3o2R/bz6PePqU2LwlhBOuvMayhGyKAT9ps/3FZlL0mL153K1mtBSekgDtQQYRSizxAgw+sSfokibtrrE6rEGFEaBw8x55aS4ArmhY9JxbqyMy49HWG/l6k5nMkNFUBey4H9J21UIJW3naLCSfhcl4g/KgFAcGtATnrk47ScxifEyt3kR0YA89144Zq7S9lm4e0/aKSjs555wRuseN2fW26pVo99lEGDmj2OKXb8qqK7zJAsRd5PKbu0zlBMyvP1uAjhlPXo8PSkDU4Ct1QV1+9TCPPsGd+7ATT4g4Et6U4glh0QNFUxirfK1DU/ZFWiTLhJgoCbogle2AaSbSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB7872.namprd11.prod.outlook.com (2603:10b6:208:3fe::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Thu, 20 Apr 2023 14:23:17 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 14:23:17 +0000
Date:   Thu, 20 Apr 2023 16:23:10 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 1/6] tsnep: Replace modulo operation with mask
Message-ID: <ZEFKzuPKGRv0bO35@boxer>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-2-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230418190459.19326-2-gerhard@engleder-embedded.com>
X-ClientProxiedBy: FR3P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: 0878ee81-9713-45c0-d808-08db41aac8bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ynNrQr79t+3mX/j67cF2KjI8Zh4dDOsQTaoAXmDN0LxY2JlgDGetfB2ZwjKDReuCIjHJGhkcdvKXKkdA08PwMyc2fWQmhGB1qUxK7aNxTlrBXLV9C+dbgwAm0HbJzVRgkb0WUbkn+goXsgFM4oDqcWzyDJa6z7bZ3H76jKYVnFhZWmPhjsealzB/smabkbuQZtijtbP4Gz10jOxjnr76HU/xP55akvVxqpgz4sytnynQ687xSrkloLg1iZEVDLuJYyzLQks+NP59UGMv7Gr4gg0+swbn4RoCFxvmPyrIp/IMZcKWmo3lpuorQOT93Op5wpAPAk7e0IqZ160DctoWHl07azETDQYcM7iQAByk2lcXfQNwzhBjshTstSEnnsi70fIgmBHZ/buvENYFUWMa+mYksZmkyUvk1ODeUaVs2/7ItawVAeppthEzrHaT4KCsTBG+/EgfD7tljanF2Au7A73eLZZF3dt+XsvzLrs6Nu+OSXJXnDLuLqV3w6dhMBHVy839hh1as4vTXxn4dVrJX7mrrAWwVjpUWX76gnWNDx5wiQpO86gvhvtgXr2ov7Eu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(186003)(6506007)(6512007)(9686003)(26005)(6486002)(6666004)(5660300002)(316002)(4326008)(41300700001)(66556008)(6916009)(66476007)(66946007)(8936002)(8676002)(44832011)(478600001)(82960400001)(38100700002)(2906002)(86362001)(33716001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4nl07cDTLPVhctQhtyouifrCcfLdGgNcWoj6qr08lxqTK4apBe4iIu0clStC?=
 =?us-ascii?Q?6HsaOi0/h9Pq3hLu2A8lRaiBy5o9Ol2+c91kDdvpIPTof3yMQ7VQRi4hNkuV?=
 =?us-ascii?Q?Olms4O4BIXj6fJQHrv5/Vu3ZwNaY1wRt9jqc+9D0dggPuxiZpWi7117yGqxE?=
 =?us-ascii?Q?eKAUT+T4ra44bVlZyxN5x5qmaRK0v7K5wBqwzL/xLlOjBOf4GeC0wj5P4WNF?=
 =?us-ascii?Q?Uxt2mLOpzP9hjz12g5Oe8dcUHlHHCFYJu37dIQ9GIKqlmo4VrwpaKRLSewUL?=
 =?us-ascii?Q?4C2dKXxpKod38R8d0ZQZLaR3X+zg9tV2KK7jKJCAXDEpcRPPHkBXaa/o5YAT?=
 =?us-ascii?Q?2kuMGgEfw/zmMuSQcdw5gCz0Uma3rFA0GYt58/JwAJYW04SlsFvDc3VXghN+?=
 =?us-ascii?Q?f2f6fD1CNyCimyh1tj8eizQY/C4qproGfnpEQlvTtg2UsKKyNRxI96gn2Njk?=
 =?us-ascii?Q?3+Hf28TkNy4cX1MOpejDWI4rX9XUJAxsWWvV+zTie2vqvc8wIowFwtcxCvtp?=
 =?us-ascii?Q?NWVqrD1nB+dI0o/+N8g0rlVnJi8mPnIf9RVk55JlVrNegh+mR+rknciLHnpU?=
 =?us-ascii?Q?67hD3b5TKwjh0ido6eBFN8/2+EAxYxbfTFtPS3cm1BtvoD9AuUxCRoGclAEI?=
 =?us-ascii?Q?5RhuZtScWiD08kx/EZgemQDdixA8KWWuB3d3Pq55g6xMPq3darhWFpaHpqvj?=
 =?us-ascii?Q?ThM+9+iZ6ZnmuZRmqbe+m/8vzrdrYzDkyOdp/hB4ogrQZjqy0gUCD7xjj57q?=
 =?us-ascii?Q?IQiQXen0DIOUdxWF4NrfVohydiUkAg+dRQmJANbKoCxBGvew3dN4NpnnnrUQ?=
 =?us-ascii?Q?JS2pVYNMzIjSzBHYz/4qWU2Rvjz/zI0Z9dAFrD+aBmdGBraAlDJGUgqdRTmu?=
 =?us-ascii?Q?3ZgEAh8t2K6sYchMAo+/WbCPV2KuQkG13NzNxMk8yeQ6PQpBrLid86cDUHIW?=
 =?us-ascii?Q?bvS2gHUxWCJzBWNy2hhO/q0r9yBT+ELd5Llu5V35pC/vB5CLVp0hRQUoOGT+?=
 =?us-ascii?Q?v/Vl6w9dTKkX2Efl5rLqRMGS3A2SwQDreVhizTAo/L0kpOyRmyMfGLzJN7j9?=
 =?us-ascii?Q?ZRPDANZssTXDtGmoNwDxAOry082AS6vk0B6W3ObUJWBcqX6AY5XKdvoyXES0?=
 =?us-ascii?Q?jxe0cwQWmM6TTemjML3VTj0Ns7xcHkZCekiXawxebCTk0tyUImWevZOpnHHo?=
 =?us-ascii?Q?Hf836IYi+dAIL9V6re3BtY6Nf4TIYVSHVzxzzyEsyBHPi0nr83KsZtLQSOu6?=
 =?us-ascii?Q?kGtQQ4S+3MaRXyoM+koBVzLYjOd5SpzQTv8DedOrWIQghKz5straXhez8f2+?=
 =?us-ascii?Q?NKa9gPoEsr9B28RT4CWVPl7Z4NK+/ct9pF+1wYiNYl1m/UPLk/eTXY6cPToJ?=
 =?us-ascii?Q?CT9BSIyavB//qbZVX9ZUhuSSfnteYjI0PwTs0TgqYuekWWnyv0ceAOJx7N5B?=
 =?us-ascii?Q?4TJNhU7PXLBphTlP3ygoBMTiF1K0j7Ckv8QEDA1K0NaPE4+9hI6x/ov5hM71?=
 =?us-ascii?Q?ULd6i2/G2teQ1s5Tir679k+Jkm83YZqLoBTDAlRaSlfv7vRvBFLgiUANnPPB?=
 =?us-ascii?Q?oP00PjBg1L54A6uMnrGAIKbLV2G6suERWOnNbYcWZingw6fER+VdamydOVns?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0878ee81-9713-45c0-d808-08db41aac8bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:23:17.2830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXplMJ2BSOcN5iw023834eIWp47vWf99THyEFy3BJqIgWlcWuP7fmzDSdITEbfJNKmt3cdejrH0DUaLP4dBNhUNfvFuQmZ4TrQqT0XeeqHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:04:54PM +0200, Gerhard Engleder wrote:
> TX/RX ring size is static and power of 2 to enable compiler to optimize
> modulo operation to mask operation. Make this optimization already in
> the code and don't rely on the compiler.

I think this came out of my review, so:
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Does this give you a minor perf boost?

> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  1 +
>  drivers/net/ethernet/engleder/tsnep_main.c | 28 +++++++++++-----------
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index 058c2bcf31a7..1de26aec78d3 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -18,6 +18,7 @@
>  #define TSNEP "tsnep"
>  
>  #define TSNEP_RING_SIZE 256
> +#define TSNEP_RING_MASK (TSNEP_RING_SIZE - 1)
>  #define TSNEP_RING_RX_REFILL 16
>  #define TSNEP_RING_RX_REUSE (TSNEP_RING_SIZE - TSNEP_RING_SIZE / 4)
>  #define TSNEP_RING_ENTRIES_PER_PAGE (PAGE_SIZE / TSNEP_DESC_SIZE)
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index ed1b6102cfeb..3d15e673894a 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -292,7 +292,7 @@ static int tsnep_tx_ring_init(struct tsnep_tx *tx)
>  	}
>  	for (i = 0; i < TSNEP_RING_SIZE; i++) {
>  		entry = &tx->entry[i];
> -		next_entry = &tx->entry[(i + 1) % TSNEP_RING_SIZE];
> +		next_entry = &tx->entry[(i + 1) & TSNEP_RING_MASK];
>  		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
>  	}
>  
> @@ -381,7 +381,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>  	int i;
>  
>  	for (i = 0; i < count; i++) {
> -		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
> +		entry = &tx->entry[(tx->write + i) & TSNEP_RING_MASK];
>  
>  		if (!i) {
>  			len = skb_headlen(skb);
> @@ -419,7 +419,7 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
>  	int i;
>  
>  	for (i = 0; i < count; i++) {
> -		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
> +		entry = &tx->entry[(index + i) & TSNEP_RING_MASK];
>  
>  		if (entry->len) {
>  			if (entry->type & TSNEP_TX_TYPE_SKB)
> @@ -481,9 +481,9 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>  
>  	for (i = 0; i < count; i++)
> -		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
> +		tsnep_tx_activate(tx, (tx->write + i) & TSNEP_RING_MASK, length,
>  				  i == count - 1);
> -	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> +	tx->write = (tx->write + count) & TSNEP_RING_MASK;
>  
>  	skb_tx_timestamp(skb);
>  
> @@ -516,7 +516,7 @@ static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
>  	frag = NULL;
>  	len = xdpf->len;
>  	for (i = 0; i < count; i++) {
> -		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
> +		entry = &tx->entry[(tx->write + i) & TSNEP_RING_MASK];
>  		if (type & TSNEP_TX_TYPE_XDP_NDO) {
>  			data = unlikely(frag) ? skb_frag_address(frag) :
>  						xdpf->data;
> @@ -589,9 +589,9 @@ static bool tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
>  	length = retval;
>  
>  	for (i = 0; i < count; i++)
> -		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
> +		tsnep_tx_activate(tx, (tx->write + i) & TSNEP_RING_MASK, length,
>  				  i == count - 1);
> -	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> +	tx->write = (tx->write + count) & TSNEP_RING_MASK;
>  
>  	/* descriptor properties shall be valid before hardware is notified */
>  	dma_wmb();
> @@ -691,7 +691,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  		/* xdpf is union with skb */
>  		entry->skb = NULL;
>  
> -		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
> +		tx->read = (tx->read + count) & TSNEP_RING_MASK;
>  
>  		tx->packets++;
>  		tx->bytes += length + ETH_FCS_LEN;
> @@ -839,7 +839,7 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
>  
>  	for (i = 0; i < TSNEP_RING_SIZE; i++) {
>  		entry = &rx->entry[i];
> -		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
> +		next_entry = &rx->entry[(i + 1) & TSNEP_RING_MASK];
>  		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
>  	}
>  
> @@ -925,7 +925,7 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>  	int retval;
>  
>  	for (i = 0; i < count && !alloc_failed; i++) {
> -		index = (rx->write + i) % TSNEP_RING_SIZE;
> +		index = (rx->write + i) & TSNEP_RING_MASK;
>  
>  		retval = tsnep_rx_alloc_buffer(rx, index);
>  		if (unlikely(retval)) {
> @@ -945,7 +945,7 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>  	}
>  
>  	if (enable) {
> -		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
> +		rx->write = (rx->write + i) & TSNEP_RING_MASK;
>  
>  		/* descriptor properties shall be valid before hardware is
>  		 * notified
> @@ -1090,7 +1090,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  				 * empty RX ring, thus buffer cannot be used for
>  				 * RX processing
>  				 */
> -				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> +				rx->read = (rx->read + 1) & TSNEP_RING_MASK;
>  				desc_available++;
>  
>  				rx->dropped++;
> @@ -1117,7 +1117,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  		 */
>  		length -= TSNEP_RX_INLINE_METADATA_SIZE;
>  
> -		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> +		rx->read = (rx->read + 1) & TSNEP_RING_MASK;
>  		desc_available++;
>  
>  		if (prog) {
> -- 
> 2.30.2
> 
