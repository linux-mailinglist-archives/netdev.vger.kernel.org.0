Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90846471C9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiLHO2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLHO15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:27:57 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD73254463;
        Thu,  8 Dec 2022 06:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670509674; x=1702045674;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=62RlkuGJ0OZTKy6gsuAtMc1JGuc9sFHHdSFEPN1ueWs=;
  b=Vc8m9R6bC0XMiSqfMvrBCA1L6vW2van8gHiF86mCti16aadNUuz5MdPs
   1/I3IPxokVK+jPc+ShYyCsRBmqrvWVvuo1byHTkmEWZVyrkaberLK5js9
   EM3Jg9zMV6EZXaVaT/5nJP81kL0m70yPR06F3zxCfo36Wp+hjP80Z0dNX
   0qBBSLVeKeKOqE/QfRhT7vAsfKDWxyM9vkQoxhGRLxfdjly+WEJxzSgAl
   1ViK8t2/Vie8vLEw8wCs6SNAEpcDHAJtqFPqat1QGXy7W9qiyhbtb+5+J
   IHN8oRsX64Zyv8UCpdNwJzAWzbfvj0866DAkGDzzFebbwoBYmJIU89euD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="381478301"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="381478301"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 06:10:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679541813"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679541813"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 08 Dec 2022 06:10:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 06:10:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 06:10:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 06:10:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwjAibl6HfrMn/EA3/lCIxot6bL9bJNsgFYoqRgN9ef7mLBJqHBCA42lKqvb7GYlfF5M4uQWzxVtIl6CGcxxFHj/7zdN1mVC/YT6n554TrZNaqeucAQ2CWwG54PrAtRhlt9vkX8WG5W4yIkaEZ0wg2dFgi45vHAms2N8r6hNfgRewPhJt2dtdHvWttYIv4cwiLwAAytfX0YW3lRSbnNoLBbI3S74weE7bVpco/nhtSIUgVU/sMQR+Up+sMzwmmMXw3U4Xtx/dlyOij9nel46jyIxuTyw3no6LiEC2YKvP75lNd6RSyV+br9bqx9DzG+l/tWz1wxC2RqtUXbfBSSc4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kWV1zr3nX9rvotatOuAIIIFC5BzQHVYEA2VgutuMPY=;
 b=ABo2wQcmA/lhZgPTpLVNDef71shnEGHXdQP4cNiSCenK3cyVd+ARy1FDsOkMsz4TPsn6/jy23HcbdW3jdLyT0ULFxakzzilidSZvJwy3hbDpODPw8DjiXAxzZN0a6ZrHXBlOJThMWdloZRnK5/QbO/FPI/sDBVwJFw00mTBb9nqO/sCdBWVz0YoRRTFWjnIY6gxfPxVGF07+ioVVxytH9r/vQENo2uCdQcrMd8NHkmTWD6Tr0dg6PsiGJs/jO5sB/P2n9QRM8zxLZsPlnRXYTIIgNOTWbmQrOsUMEro57oKO1A6edOygzmrE8CERiq+sGzvNigMvYBJK3+s0MtAjCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB4929.namprd11.prod.outlook.com (2603:10b6:303:6d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.16; Thu, 8 Dec 2022 14:10:31 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 14:10:31 +0000
Date:   Thu, 8 Dec 2022 15:10:13 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next v2 2/6] tsnep: Add XDP TX support
Message-ID: <Y5HwRZmCv2WYpBtg@boxer>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-3-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221208054045.3600-3-gerhard@engleder-embedded.com>
X-ClientProxiedBy: DB6PR0201CA0003.eurprd02.prod.outlook.com
 (2603:10a6:4:3f::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: f726009d-9e19-4b7a-408a-08dad925f700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwv9a5fJdyx0TKZJCNePX2joQ+bGs2elCxoh8k0LvqxBaXsJOAkLBujZSVYuwskIeC07ufdzHEQgS/Hj+ed3Wkod1qvxkfKAmxB/mzSsLd8bHOEsnWF05lLK/5ghaer9e40oyqwD65aWnyL7AiqcVSXDYBWVXfuubn9RFb2CEVlqmKZA9s5erDLAtdFEStRdW9J89Ok0dxuThqfJmUSA3ekNcup6i70OJfLIw/py8XV9qYpmRGmXT/3sI72u7NIkBKnWFir3ZquCOM4YqfF0HXUpQeCZO3j7ncMz+AWmlidIOuqdqYo2uCDmYT3GmkKBlaRJXVPLZmNUvgUn/z7Qo3YBhzfGJ5MFXD6KcyiJCRDzQV8PWLPZW2O5r/YOspSVqj5LTa8oRmp310gPHojd2Cn94dD6297mm+WYjwbTP9ib0oQBhHtnKGQpsrBseXzWPRjGKymb6of7uZjGUMIBcT+z6biHZWYUBHfpNunCD7ZXnTGEX1MmcAs31H/i+ZaPBWyJMGFcUghoAvm64h0WHnE1v/8wz+pzCT9CV42yBKjs2K86GBN432aRKbgK9n2x5/asXVbJAaJsPtv7KiDQo3CpJRfboxheNbGFMSbV+C0a2zOIRkAwW3v1cUF9aQpl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199015)(6666004)(38100700002)(2906002)(82960400001)(44832011)(26005)(8936002)(83380400001)(316002)(6916009)(6512007)(9686003)(6506007)(478600001)(7416002)(5660300002)(33716001)(186003)(86362001)(66476007)(41300700001)(4326008)(66556008)(8676002)(6486002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?opmFNe8AQITa6zrLJ9d7V48EGmZySgpO7JJW1NJI6H/a9E68ZSZDsGJtt1dS?=
 =?us-ascii?Q?BGa6iEHp2+tDJc++sNZF0iOM1F+SuUOdMVKMi6sguZhMZLFz0TAZbiWNXIai?=
 =?us-ascii?Q?G/THSygLf/qn6n/qmeO/U+z2MtlDF0WXb2QhDgw5LcuL07tinSjafTVsW9Tf?=
 =?us-ascii?Q?wFt+08nfDpLXP/vLC/C31YR5lB7mKiHY0zehC4bp0+nX4vm6/2CQUh0z9PAK?=
 =?us-ascii?Q?uRmLl+SFBj6z8/ckwH/LJRJzqTYJpLoFPzsluHjpKOf+LZJ/PMYQix/UfmSm?=
 =?us-ascii?Q?4W0fDomZNQuDt5K3zMAa1nKy9bMHblOM1vM960dJH2D4P/Vx7OTy0183s9xZ?=
 =?us-ascii?Q?Cu/PqCHWXSF9aif/2iJgN7aIP6iTNNKYDi3Bm1FpqqG/D9/iY75HyZ0sWpPp?=
 =?us-ascii?Q?z2uW/VZb/KkrV+qTOtwBhH5qA5MO9GQtefsyCe+RGBPHvce8TbDEGjve1Q9s?=
 =?us-ascii?Q?+Wr4GrXMP+HN0sliwKEYA5DMyIS4+ln+W9tgpTOFTkJkQUQapHJCj9FuYRh5?=
 =?us-ascii?Q?4x2ak6SnL3hJHGYaIe45MPP1Tj0/GKJsunbMLE0epbZU0WRZkl5bUV3/SlgJ?=
 =?us-ascii?Q?+aLTc622hBCzQL8vT+Fr/dmfY2oqRvVZOUJc6qNAtBQC20gpJY32yjSBlA41?=
 =?us-ascii?Q?EjK6r384VKGBtkImvZVq3XBEw+/pErjW94/KilxMBc9vTnXiLUFnUKqoIUEF?=
 =?us-ascii?Q?jnZDGlBOEH0mehbGFwkiAOf8ns6oy392TRwg1+qRE9ARbpue9dAAVnET938D?=
 =?us-ascii?Q?N3WQ1g/vVwzbroWVo6va9Fyj23xzm3JHNz4O6tpP5ZSTQO88dkcRBODHgBlM?=
 =?us-ascii?Q?kGZMr6CqAT4kZ5KB0CsAIDXvdI+qdWNRBLuc60gYqxpQ43NBc3INmDp3/FEe?=
 =?us-ascii?Q?ek8FmbI9ve3OU2WADMScZXYzyjhwqT9MAH/fYwAdh/W+qkPV2OVUZAGH1AEx?=
 =?us-ascii?Q?oSEkIEy9TsTSqf7jNOKNu6oP5nG2gNg2yA/Z1M56xZDNsBohUBrB2UwQPAvJ?=
 =?us-ascii?Q?OrVGbWOC01oHGLRYOAS8hLtjv8nw91w6VcMVNuzKMG0R5BgRlY61YE7D0dwH?=
 =?us-ascii?Q?IAYLumen7xTnap+RyfnS15Mbn01naB1mOgN1BFvGlj1fMXyhfeeEgc7W95Vi?=
 =?us-ascii?Q?KgJP/wQzDc76xUsoGNzEdQw6rtNI2rz6lXVjI+tfcQtAw34rCqd7afk1ktN+?=
 =?us-ascii?Q?d+ErXh/yap3rma54ugGDeSI9N1F+H2UqnmhzlQgHjDYdYrD0Z7IGj8TAvbdo?=
 =?us-ascii?Q?yJaXKf/YeudfUcGBOwujNlmFSKbM8qQYYUNk7qWGOcqtLJvL3+PhrXUYc87b?=
 =?us-ascii?Q?IrZ7rRJ6PK2CJV0k61G5t46TqAtC4dG4Q6FZWdkvMSwHyTW2duWHiq3BvXoV?=
 =?us-ascii?Q?uGd9bhSMg3xGllfy3IzP7O790IXVBbQbJ2HUPPuX5U1BYzI2cWDVA3wGwSHf?=
 =?us-ascii?Q?udpPzu398LnwaKgWhjAs6XbVDDZATz5hShepsr7aaywztYogrhrSwDOL38QG?=
 =?us-ascii?Q?5uPQKOP/OmlbtDQfCv3jnKTxzPe1Ex+Inu/44wb0L0z3V4awhu7Y22EBFI3w?=
 =?us-ascii?Q?TS8SRO9KI6s9kUgeMbL3KXeMBfTh9TLYrgGCPKwEfbrRnBkmXaiA6fN/cXbF?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f726009d-9e19-4b7a-408a-08dad925f700
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 14:10:31.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mdFdO6i9jpP0N2a7QTwJ9gMOnS1cNGqz/z0j9XMlnCnFxgFBBgnnfxpDXuhuS4Wu4QOXltyxroh7DpoPcuIq6g6lHlWCZeLegnnxvcugGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4929
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 06:40:41AM +0100, Gerhard Engleder wrote:
> Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
> frames is included.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  12 +-
>  drivers/net/ethernet/engleder/tsnep_main.c | 204 ++++++++++++++++++++-
>  2 files changed, 207 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index f72c0c4da1a9..29b04127f529 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -57,6 +57,12 @@ struct tsnep_rxnfc_rule {
>  	int location;
>  };
>  
> +enum tsnep_tx_type {
> +	TSNEP_TX_TYPE_SKB,
> +	TSNEP_TX_TYPE_XDP_TX,
> +	TSNEP_TX_TYPE_XDP_NDO,
> +};
> +
>  struct tsnep_tx_entry {
>  	struct tsnep_tx_desc *desc;
>  	struct tsnep_tx_desc_wb *desc_wb;
> @@ -65,7 +71,11 @@ struct tsnep_tx_entry {
>  
>  	u32 properties;
>  
> -	struct sk_buff *skb;
> +	enum tsnep_tx_type type;
> +	union {
> +		struct sk_buff *skb;
> +		struct xdp_frame *xdpf;
> +	};
>  	size_t len;
>  	DEFINE_DMA_UNMAP_ADDR(dma);
>  };
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index a28fde9fb060..b97cfd5fa1fa 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -310,10 +310,11 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
>  	struct tsnep_tx_entry *entry = &tx->entry[index];
>  
>  	entry->properties = 0;
> -	if (entry->skb) {
> +	if (entry->skb || entry->xdpf) {

i think this change is redundant, you could keep a single check as skb and
xdpf ptrs share the same memory, but i guess this makes it more obvious

>  		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
>  		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
> -		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
> +		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
>  			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
>  
>  		/* toggle user flag to prevent false acknowledge
> @@ -400,6 +401,8 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>  
>  		entry->desc->tx = __cpu_to_le64(dma);
>  
> +		entry->type = TSNEP_TX_TYPE_SKB;
> +
>  		map_len += len;
>  	}
>  
> @@ -417,12 +420,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
>  		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
>  
>  		if (entry->len) {
> -			if (i == 0)
> +			if (i == 0 && entry->type == TSNEP_TX_TYPE_SKB)
>  				dma_unmap_single(dmadev,
>  						 dma_unmap_addr(entry, dma),
>  						 dma_unmap_len(entry, len),
>  						 DMA_TO_DEVICE);
> -			else
> +			else if (entry->type == TSNEP_TX_TYPE_SKB ||
> +				 entry->type == TSNEP_TX_TYPE_XDP_NDO)
>  				dma_unmap_page(dmadev,
>  					       dma_unmap_addr(entry, dma),
>  					       dma_unmap_len(entry, len),
> @@ -505,6 +509,122 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  	return NETDEV_TX_OK;
>  }
>  
> +static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
> +			    struct skb_shared_info *shinfo, int count,
> +			    bool dma_map)
> +{
> +	struct device *dmadev = tx->adapter->dmadev;
> +	skb_frag_t *frag;
> +	unsigned int len;
> +	struct tsnep_tx_entry *entry;
> +	void *data;
> +	struct page *page;
> +	dma_addr_t dma;
> +	int map_len = 0;
> +	int i;
> +
> +	frag = NULL;
> +	len = xdpf->len;
> +	for (i = 0; i < count; i++) {
> +		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
> +		if (dma_map) {
> +			data = unlikely(frag) ? skb_frag_address(frag) :
> +						xdpf->data;
> +			dma = dma_map_single(dmadev, data, len, DMA_TO_DEVICE);
> +			if (dma_mapping_error(dmadev, dma))
> +				return -ENOMEM;
> +
> +			entry->type = TSNEP_TX_TYPE_XDP_NDO;
> +		} else {
> +			page = unlikely(frag) ? skb_frag_page(frag) :
> +						virt_to_page(xdpf->data);
> +			dma = page_pool_get_dma_addr(page);
> +			if (unlikely(frag))
> +				dma += skb_frag_off(frag);
> +			else
> +				dma += sizeof(*xdpf) + xdpf->headroom;
> +			dma_sync_single_for_device(dmadev, dma, len,
> +						   DMA_BIDIRECTIONAL);
> +
> +			entry->type = TSNEP_TX_TYPE_XDP_TX;
> +		}
> +
> +		entry->len = len;
> +		dma_unmap_addr_set(entry, dma, dma);
> +
> +		entry->desc->tx = __cpu_to_le64(dma);
> +
> +		map_len += len;
> +
> +		if ((i + 1) < count) {
> +			frag = &shinfo->frags[i];
> +			len = skb_frag_size(frag);
> +		}
> +	}
> +
> +	return map_len;
> +}
> +
> +/* This function requires __netif_tx_lock is held by the caller. */
> +static int tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
> +				     struct tsnep_tx *tx, bool dma_map)
> +{
> +	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
> +	unsigned long flags;
> +	int count = 1;
> +	struct tsnep_tx_entry *entry;
> +	int length;
> +	int i;
> +	int retval;
> +
> +	if (unlikely(xdp_frame_has_frags(xdpf)))
> +		count += shinfo->nr_frags;
> +
> +	spin_lock_irqsave(&tx->lock, flags);
> +
> +	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {

Wouldn't count + 1 be sufficient to check against the descs available?
if there are frags then you have already accounted them under count
variable so i feel like MAX_SKB_FRAGS is redundant.

> +		/* prevent full TX ring due to XDP */
> +		spin_unlock_irqrestore(&tx->lock, flags);
> +
> +		return -EBUSY;
> +	}
> +
> +	entry = &tx->entry[tx->write];
> +	entry->xdpf = xdpf;
> +
> +	retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, dma_map);
> +	if (retval < 0) {
> +		tsnep_tx_unmap(tx, tx->write, count);
> +		entry->xdpf = NULL;
> +
> +		tx->dropped++;
> +
> +		spin_unlock_irqrestore(&tx->lock, flags);
> +
> +		netdev_err(tx->adapter->netdev, "XDP TX DMA map failed\n");
> +
> +		return retval;
> +	}
> +	length = retval;
> +
> +	for (i = 0; i < count; i++)
> +		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
> +				  i == (count - 1));
> +	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> +
> +	/* descriptor properties shall be valid before hardware is notified */
> +	dma_wmb();
> +
> +	spin_unlock_irqrestore(&tx->lock, flags);
> +
> +	return 0;
> +}
> +

(...)
