Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365D06CA073
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjC0Jtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjC0Jte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:49:34 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F8A4EF1;
        Mon, 27 Mar 2023 02:49:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMP6ozau6nMib3TsfRFJQxdDEiJNVbxHDMQotWGnFKwCuPcr+VaQLXRNzx180nS2Q1AATtE/W4e7yM31NaNDiUkp2IsbHezZqOjw0588QIJhzw+B9FJsRuRmBfEQO79EV2aPyGQ5esJlKNaar5K/xSCDj/ho1jeAAvia7PpsZwwoH5x5Uj2UFf7iz1swv+igUoEVD1eR0LfCqWpB1AIf2lOS0VfgZuwGc/sWaA8SJ4HKsESCAGVVg4DeKCmXveMJU3fbClhWTo4nYVL6yRrQCFziUq3NSDKlas6i/5r0u/b5rTizcj+IxWKyil8y/miPHbN1cSXoBn4bvh7aTxyOIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aizyv9aVMzXqujfWpUm+5JI+oNwOuS5buKRo7/7L1Gw=;
 b=SsVM+ssx1iQ8wbS+fu/42qMtLqskSBQreF9XFufOpZ/iC9aYugoF++e+/a67YPzid6pGtPuA6BWc0EgqtXuCWAiQhTtj9V+bPRCSTJZP8/YDc3pzDwpp6mkev9Yup2iSf03KoCKb7BPoncCsEDMYpRuyZlmG0zh0SPF048XEYmbNnfjut5TK2lll+XXlHKLxQNGzQwMBSXSf9wi0moxKUfzWQu8AbZ2D9hLYfnyIXJT2/W+J0zRaI7WGtMKcSM8LgpKyrtZc/DbymYWfIpwZGAKhXJlc9IVFkuwWZSkW3mWoZOtf/t9K4pv0DYkRsDj0dUnb8CrEWzpQ4rj5KxBXSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aizyv9aVMzXqujfWpUm+5JI+oNwOuS5buKRo7/7L1Gw=;
 b=hvR6lToDvDtsEc2eOFSkhTwOiwC2Y5mb3IfngYInlXa8+wPMCYlHA49t77QNbZaOMf5Iuj70IEgNANRw45rLscTRp0Xf+fZ+nnIbHh0Hbja8vl3ft55XhKtfj/DBrroyHs1k6ib5YLdT+7f3uj6X2pwJNgjpwbTR66P6+iF54JL3gzVeVQ4dLDfZ4nxsh67n5ypchZpZEhlJNpk1dLrBn1sFEo1mPAIuoCOkWPRQLGyZbKeeGOYXMkRsfwjSiqZrjZ7c9dqsF1KSGTosmhRxG+flMkfbMD0DzveCcRGs7mT0mlpbBNofdZgY8lQcJI/tRcAlP4o7zMSOURFL/HsX7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DB8PR04MB7098.eurprd04.prod.outlook.com (2603:10a6:10:fd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 09:49:26 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::154e:166d:ec25:531b]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::154e:166d:ec25:531b%6]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 09:49:26 +0000
Message-ID: <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
Date:   Mon, 27 Mar 2023 11:49:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20230327083646.18690-2-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::11) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|DB8PR04MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 104f9459-01ea-46ae-23ae-08db2ea88d27
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QoVH7mp2+SxEouRbejB1uvC3UgWnNWzloIqcl3hzLuICt9lK1wNOej3W0Dm6bZe1B2JW22IovDy27p4n8G3OvxPdxDPUQq3gDBYV13oOYa6vk5bbq2pg2YW2I/Ugo5meWU7n03A2SzKCAIimSA3xEQm2Hjoo0jMz1+MkXTF5vtq+osaCLfNi6iy/+DMo/lQWw8g9Q4I/MyO8y/ikFxWtluJ1WH6GDTUoxOws4wh3bp3evRuL5ZUPrnjNewdhsFX9NPgS36vM2BJXhiDoNg1Oth7X0UVsGE9qFLStYYwdGMTiCs0Ky3n/IR79hHnTd0wKuCoi9ItwQ8ufed8lEaWNeybnOFsvswPPMkKm+c92USIn8pB5gYLRMZLZi3jPfwnuzajuS+0RU5k35eHB+gQbvnfGrjwTaC/dYa7lo5k2vYW5+YTEigStfzsMnWV00NzfzUnso2wHT/lroo1v5UKfTqlmO/Yep9gWFH/0kfW8mfe7HHt+EMHIg2LXoCOSXxAwvhtBg/LO+p60ZtTfbV3wcgW7roMmDTGA5oxAkPy2gjP7izUKFQ28W6HZ3uzpHbVCE3d8ifRrnW5UShZDu/UeM+Ejjqe9u2i7iqCXZyi68xZ5buJMZFK9TccXNW7StgLSMhXgY7vulhx+IKtFl8zJRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(2616005)(83380400001)(66476007)(2906002)(4326008)(8676002)(66946007)(66556008)(6636002)(54906003)(6486002)(478600001)(53546011)(6512007)(186003)(6506007)(26005)(316002)(37006003)(7416002)(31696002)(86362001)(36756003)(41300700001)(38100700002)(8936002)(5660300002)(6862004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHduUWsxVlB3RERBUlc4QnA2alMveE1rYkdpK2k0U0Ezc1J6SzlMMG1lSDBN?=
 =?utf-8?B?bHl1Y0VuU0czZnpicFV5VU4xSGluRGREdlZBeUlDd3A5Mytlc1lUZHFwU0Qy?=
 =?utf-8?B?enM0bTdnK25Jd1dYSXZoMklycGN5S3FtbHQvNHRTRHlFUjdsUVkzenBFWkpG?=
 =?utf-8?B?K0RSbTE0RGdSeXF3bnVMSGYvVzFqSUxzLzdpT3JOSmlscml0UHdUWWpUajIw?=
 =?utf-8?B?LytKUDJjaVZ4STZqZE1Kb2ZKeEpxTWtoOHB5Wjlkd2djRzhvdjlsS1FPVjk4?=
 =?utf-8?B?RkRaSmJXS1FpRGhTMFJlMmtHRjhSZFJRbTJ6NXRWYi9BQWwrWVgzS3V5VTNW?=
 =?utf-8?B?SDNmQWZab2h2NnpqTnhNeHdadDBhQU5iTEQ0WWpWUnBiTGVxWURMaTJQc0ZE?=
 =?utf-8?B?OEdNdUZXWDRWeEcwUWpiOXRxcWVMSndMeUU0UGxmdGRZRzRaT210VERXRGVS?=
 =?utf-8?B?SWlNSmtvaGhJaHkrMnJYZHhxWHVXT0Y1NnpERWpDRzJlYUpwQ3d3a3AwT284?=
 =?utf-8?B?MjBSZi8zcVFubnMwM09EMERyMitrdmNmVnhXeUhKUkRXWDNzUDQwanlWMFBp?=
 =?utf-8?B?bllCamRFbnFIQit3T2VxRmQvVk50UytaMERsait2WDlFSjA1S0txS3dXeWgv?=
 =?utf-8?B?ZGovaVpqWDdNOE1ST1dQWUR1RlVZOVprbmVFcGduR2RmSVJ1THFObm9NeS9h?=
 =?utf-8?B?Rmx1Tng0ajlXQUtKWXZUNDZhOGhXd0hzMlIxNWxRY1dJUktSVFRVdnZ5Y1NR?=
 =?utf-8?B?S3pmRlZwd0x5a1hEblc3dkpyYXlFL1RPMWMrbm9EaXkvVjRKZkNva05WNmh0?=
 =?utf-8?B?cGhTa0ZRNit0VmR4Kzlhdm1lcFM4NTVVbElVSXRjWXdjQ1RsaklRcElCRW5H?=
 =?utf-8?B?SDFjK3FHbHpEQjZZazdMc1RrSU1ncnpobGFYRUxhaXJ0cVRvNmh2ZkZvcWs1?=
 =?utf-8?B?QnpDTTIxWjZSNlNXRDFSRlRKN1RwWnhGOFRQbWNLTm1wSy9NcnZGWkR3MlUx?=
 =?utf-8?B?L3ZiQXdqaEV0RE1RSlNlME5DY2pEbGg0dVBqU2dUaXVxbHZSN28rVWZYM1hx?=
 =?utf-8?B?WmMxU2JiUWFwUjdwUFYyUmc1MEZEazVFYmREQTUvWC9Ebmc0R1dLck5UTTBo?=
 =?utf-8?B?TEFBM3ZLMWxQMUlBMHR5U01lRzFTVHRNTXFyMEtYM3AvTndhZlRnTUtDeHJp?=
 =?utf-8?B?NWlUTWhzbk1oS25OQTg5Z01jSlNzQUxkVytPa1cxOTdKbG51dVY4SFJ6YWY3?=
 =?utf-8?B?YjE4ZkRPKzkvY3ZMQS9GUGY1bkZabG1VWjBGdTVkWnJ6YTUra0FieXI5RC9K?=
 =?utf-8?B?VFhRaGRGRTJwd1pvQWpPR1N3bkFhS1FtYVZkNXBxQzYvbC9lUEhyNjJVMUVD?=
 =?utf-8?B?eW9FVUMvY29qNUsrZGY1L0QyZU1HZWNWUFAreFd5OUJYczB6ZVVUMERvQ0Fx?=
 =?utf-8?B?aTZCd0NObCtEQnFlY3JNQW5ROXBJa2g4OUlBN2s1anAwM00xR0xwNkhRSVhX?=
 =?utf-8?B?TkFvR3YrSDJVNTJCaVJ2UG1oSDJIRVlLeDRGT1lQTzg5UGFIYXZ2NS91c1hG?=
 =?utf-8?B?SnpDZlNRZzJxWklzbFJLVHFiT0RJeEw0YTJxYmZIazNFTUtVU3RINGppZExB?=
 =?utf-8?B?WStvaWZ0cTA5VjBkcysrMU5kOGpwdEtkWXVyVktnTUIwU3psT3FOb2JpOTJ3?=
 =?utf-8?B?d2JxM1BYTlhYUHJkOExnSW5rdU9TYm5EY2x1RXdPS2VMKzM4Vk8rVnozdHVl?=
 =?utf-8?B?a0xVNXBkY0Zia3M1VDNOUjFiT3o2T045TkhaUEdWZFRxdjdVOUNnN0J4UFB5?=
 =?utf-8?B?aDcyZFdLeDUxd0pNYi9XRXRiUG1Bdy9iSll5OVFEL1B0VnU2QThUcDF0bjBi?=
 =?utf-8?B?Y1BUVGU1SWN3bG84S3psK21WZ3c2TUhDL1RTUEZtT1NoKzlGSE5saGhOMENj?=
 =?utf-8?B?L09TK2l2VHhzUmV1QWhCbGtRMWVDWitISk5qaUtEUExmNDBQZDZFNUJ0M3N3?=
 =?utf-8?B?QTNicHRieFZiWXNycTZDeG5GdFJTV2haT3MralFHNFJ1eGd3RnhIT3YxZjUz?=
 =?utf-8?B?U2NQeXVHS1hKcDMzalN0UFZkeVVpMnVlbmc0SERZREFJeTBHdzM1QlNwS3VJ?=
 =?utf-8?Q?WT8N4QDk3E4GkbEUCNzusd/yG?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 104f9459-01ea-46ae-23ae-08db2ea88d27
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 09:49:26.2409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQqION1iwwkyVX/Y5hceaXh6qe0tnKbjJ4UTeoqLpbibSis4LcM1PPmlbrkNGFMoQvrpQi1coSFNczmu9tNFIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7098
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2023 10:36, Juergen Gross wrote:
> Fix xenvif_get_requests() not to do grant copy operations across local
> page boundaries. This requires to double the maximum number of copy
> operations per queue, as each copy could now be split into 2.
> 
> Make sure that struct xenvif_tx_cb doesn't grow too large.
> 
> Cc: stable@vger.kernel.org
> Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  drivers/net/xen-netback/common.h  |  2 +-
>  drivers/net/xen-netback/netback.c | 25 +++++++++++++++++++++++--
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 3dbfc8a6924e..1fcbd83f7ff2 100644
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -166,7 +166,7 @@ struct xenvif_queue { /* Per-queue data for xenvif */
>  	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
>  	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
>  
> -	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
> +	struct gnttab_copy tx_copy_ops[2 * MAX_PENDING_REQS];
>  	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
>  	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
>  	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 1b42676ca141..111c179f161b 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -334,6 +334,7 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
>  struct xenvif_tx_cb {
>  	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
>  	u8 copy_count;
> +	u32 split_mask;
>  };
>  
>  #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
> @@ -361,6 +362,8 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
>  	struct sk_buff *skb =
>  		alloc_skb(size + NET_SKB_PAD + NET_IP_ALIGN,
>  			  GFP_ATOMIC | __GFP_NOWARN);
> +
> +	BUILD_BUG_ON(sizeof(*XENVIF_TX_CB(skb)) > sizeof(skb->cb));
>  	if (unlikely(skb == NULL))
>  		return NULL;
>  
> @@ -396,11 +399,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>  	nr_slots = shinfo->nr_frags + 1;
>  
>  	copy_count(skb) = 0;
> +	XENVIF_TX_CB(skb)->split_mask = 0;
>  
>  	/* Create copy ops for exactly data_len bytes into the skb head. */
>  	__skb_put(skb, data_len);
>  	while (data_len > 0) {
>  		int amount = data_len > txp->size ? txp->size : data_len;
> +		bool split = false;
>  
>  		cop->source.u.ref = txp->gref;
>  		cop->source.domid = queue->vif->domid;
> @@ -413,6 +418,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>  		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
>  				               - data_len);
>  
> +		/* Don't cross local page boundary! */
> +		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
> +			amount = XEN_PAGE_SIZE - cop->dest.offset;
> +			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);

Maybe worthwhile to add a BUILD_BUG_ON() somewhere to make sure this
shift won't grow too large a shift count. The number of slots accepted
could conceivably be grown past XEN_NETBK_LEGACY_SLOTS_MAX (i.e.
XEN_NETIF_NR_SLOTS_MIN) at some point.

> +			split = true;
> +		}
> +
>  		cop->len = amount;
>  		cop->flags = GNTCOPY_source_gref;
>  
> @@ -420,7 +432,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>  		pending_idx = queue->pending_ring[index];
>  		callback_param(queue, pending_idx).ctx = NULL;
>  		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
> -		copy_count(skb)++;
> +		if (!split)
> +			copy_count(skb)++;
>  
>  		cop++;
>  		data_len -= amount;
> @@ -441,7 +454,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>  			nr_slots--;
>  		} else {
>  			/* The copy op partially covered the tx_request.
> -			 * The remainder will be mapped.
> +			 * The remainder will be mapped or copied in the next
> +			 * iteration.
>  			 */
>  			txp->offset += amount;
>  			txp->size -= amount;
> @@ -539,6 +553,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
>  		pending_idx = copy_pending_idx(skb, i);
>  
>  		newerr = (*gopp_copy)->status;
> +
> +		/* Split copies need to be handled together. */
> +		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
> +			(*gopp_copy)++;
> +			if (!newerr)
> +				newerr = (*gopp_copy)->status;
> +		}

It isn't guaranteed that a slot may be split only once, is it? Assuming a
near-64k packet with all tiny non-primary slots, that'll cause those tiny
slots to all be mapped, but due to

		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
			data_len = txreq.size;

will, afaict, cause a lot of copying for the primary slot. Therefore I
think you need a loop here, not just an if(). Plus tx_copy_ops[]'es
dimension also looks to need further growing to accommodate this. Or
maybe not - at least the extreme example given would still be fine; more
generally packets being limited to below 64k means 2*16 slots would
suffice at one end of the scale, while 2*MAX_PENDING_REQS would at the
other end (all tiny, including the primary slot). What I haven't fully
convinced myself of is whether there might be cases in the middle which
are yet worse.

As I've been struggling with the code fragment quoted above already in
the patch originally introducing it, I'd like to see that relaxed. Can't
we avoid excessive copying by suitably growing tx_map_ops[] and then
deleting that bumping of data_len? Then there also wouldn't be the risk
multiple splits per copy anymore.

Alternatively to all of the above: Am I overlooking a check somewhere
which would also constrain the primary slot (or more precisely its
residual) to within a single page (along the lines of the check for
non-primary slots in xenvif_count_requests())?

Jan
