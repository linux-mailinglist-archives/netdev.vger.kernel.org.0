Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B314B64BDAD
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiLMT4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiLMTz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:55:59 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50E42655C
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 11:55:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQmf31MLfLMvtuFBMCXxlTIO4yqmUhL59dWkzMEEHd41s93GKIrFMmUk/X78WiYsIaLsZGbVy61ikQlbNt3NdcAavfC9rmDBb2jUucDwCwvxA3iT9cr24K7SDlBAGchsn5FXlC23BIdfDtl8TPGLMdh0lFKgwm0sz8Iv5m/6ViQIgsyGqBO/IC9GwkW941eAM77BsXhjrYclkf1pu7wRFzDxWH3Y3TBvowMuDCkDou8PF6clPWjJlCxy64zPWn4SEe1DQd6k5ShHr/YuzVx7vwf8dGflYyLjHSV0QmogROcecKAkJ6YoN/ZDLg6y6EiGZAcyBJhYsyC4YyEeQxEbRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Li7WIUlODQ3EmUekvvLh5DOD6qMpmIYrZFpfE+nCeS0=;
 b=QYJXRhg7njJWkeAAJ7eSuQoe+ZPLnfeotbp9ftE1JUzhrGV14MXXaJEY4LDIqsBBfUF8u8sJMpbT+Kq8eMt752k+RSgv7KtyELD1lPJ1m1fPORxikwhAwPnF5UJvXZ1hxQwBMnwl3HFWC/wYs3T4zew/ql96Y9MhwNihqZQMLcjqjfmYDCiwQrUEv8UbS9vBnqIKN1KMwOybrgxi8rVsiUIVDZUsp8esTkdW7BuF0ONfKQUOn2GtaFKVSFJnVZVwfksIEJmkrk+CQgWTQn80JCoJNj38XBOhUgNfqikmVYs/CEQDRrU9vwN5RK8iuK2yrV9eo6BAMgXBA211VmuMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Li7WIUlODQ3EmUekvvLh5DOD6qMpmIYrZFpfE+nCeS0=;
 b=Y7k1rb5C2G9WLEa/rUJ8hZhjkM+t8gCdXYcNaGu1I4s03x9Gjn2Mc172nO8wM0LUWaR7uPUBnf0dWyZ2yGPpDq7I0pW6w1lhMCvav4gSFbE92exOplctdJdHYBAkmrhHkjwLBUEKrKlg0mxoHDIUoSNPeOIbLNgXAl4tMkkglAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7568.eurprd04.prod.outlook.com (2603:10a6:102:f1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Tue, 13 Dec
 2022 19:55:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 19:55:55 +0000
Date:   Tue, 13 Dec 2022 21:55:51 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [RFT] net: ethernet: enetc: do not always access skb_shared_info
 in the XDP path
Message-ID: <20221213195551.iev4u5niyzvyflyc@skbuf>
References: <8acb59077ff51eb58ca164e432be63194a92b0bf.1670924659.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8acb59077ff51eb58ca164e432be63194a92b0bf.1670924659.git.lorenzo@kernel.org>
X-ClientProxiedBy: BE1P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c05e232-8318-4afc-c4b5-08dadd440bc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83urNl+5Laz3jo7P5DR6xtXPPqU8lhMNtaIG7k/8tZ5Q/hr2CCiWDvc88amESTrctiJQu5m+O8DnLXhLUh05rSk3uo2R4T6R9ipcpem5yl5vc1r5GI/0YTzOit3O++qWQeatlku63rBAjp10ZSnXfiAZaZMbJi0TVDSfukFbWgcr1FoUnaw3LAMqK+KY+orC5XMD/ZgVMcyIaK2aSczKZgSZHzgqlatGjSSbuAzlaxC0gwstbfbcHqymaXi7cq90M0OMNV8aQwgPDqOlNFDrJ/wbnzmCKj9mEhtv6HjiL70RA4kxn6FdwtaQ2tNvr0spR4sJJUubT9Xxg6XdodOr2Iy8x6WFNyF0PXq3/FdKonucZBFc8HXTEgxy+1M9J6RulMCUdWsM7DlqrBRfUHf6bj9M48sMd0y++w7SaQT12amvKqwcCEa46mfbBpOHO4TbzxS9uOz0vw0BVynjhYdRLuPGPH8VLmps8v0CYO33DGo4XdEVT9VerRsP3e1xkdsUERZ+ez/Qk8PxVL7eLCNxrEGMZ6drJYz9TMNNutAtC+1yDF0LdjxG0K1cdbbsn8mduNG3sPfuekXJQ5Hjo9PGIlEpqiq1T00EnNF0f8Rw1L8VirqShCB+dEHsJFCR20A5RLGVq6la5QALXvIaVVx/v1hvyWY2Gy+H3faj2fQlxEQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(6666004)(86362001)(316002)(6916009)(478600001)(966005)(33716001)(44832011)(6486002)(2906002)(66476007)(4326008)(5660300002)(66946007)(66556008)(8676002)(41300700001)(8936002)(6506007)(6512007)(9686003)(38100700002)(186003)(26005)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IAMH2ART6JeObk+tfTya84NtB8q3Q4vH8pr4dobjqgm5XvJjmiQauPCI3+Yt?=
 =?us-ascii?Q?dZeI574z5jHZoFHsAlpqeRdayN/1ZyfcwU7HdAsP2znmAmXyJisG1fIsfv0q?=
 =?us-ascii?Q?uYPbLh32RumDuV7jGttPNNMQxLUZ+/YHCk6u7waZxWgB7avHphe7F0RI6SUp?=
 =?us-ascii?Q?XVA6Yq8IzwfEoP3m68Vo8JhdSSRtpuGWSA3ZvWu2sWC2iEHBCEyLM/qfcHRw?=
 =?us-ascii?Q?/1X7xTIAExYm4Zd3iJ+468mwl6k91tun7o9LPB1OrtYoXyKBx1dFVq50pGzM?=
 =?us-ascii?Q?M5QqQHV9si+6LDsRgv3X6oxbB+jENUwD8AQkp+OsVWQgJBT4YAeSaUlK8blI?=
 =?us-ascii?Q?diBWp+FF7BuEhtmE+FTZePqDG67Uet5SUU6ILp4RfqUDIncvOq0w7KyQzJg2?=
 =?us-ascii?Q?QBPp/QGWBfjlb7X7uxGJQgbtn+GOdd6wwMuMzsNKVVGVzQ5JRNyJp3qQ4Ooy?=
 =?us-ascii?Q?sHg9RUBWG+4GrHccct/4K7QnShD1MQcVv/hJLaihqXgzli0SNw8eWE+mgEpU?=
 =?us-ascii?Q?fDvl0dyidf0IgCcnQYf4rR0mO/d1+ZLrBanrTGrQXbLuTSzOTjSB9Oc9riKz?=
 =?us-ascii?Q?7kSXvpuiUOuqJhVi/p2mw5bRGmHvrE21C8pCC7Azg0AHRN4rtB5XCAIyq/Mb?=
 =?us-ascii?Q?eoAikgvz+an4k3dYgAuoASdWFdtUUUDgT0Cggwr6CZTRQ9uzdE8lWNJM1V2r?=
 =?us-ascii?Q?pIA27FHOWqifhuWtI52HaP8ChWKkarxGq0ZS1kQan2rXFA0j+7T2FDkoxT0F?=
 =?us-ascii?Q?A/3+CLpA9kyAsYjOoHRE5F4oHPYJPnGe+m0DiX5RfIuoOrrZDl4tper1BDY3?=
 =?us-ascii?Q?j8LzhIXQzw68SvUajtJKyKaNaES/cb80Ve1OFpHJGhxe2+J02CFsWuOl1t2M?=
 =?us-ascii?Q?2QHPt/Yn+QSUG402nhYu4hXAIUWIk/igpm6hljS7TuDfEZYbK9Dj3gYf4/Se?=
 =?us-ascii?Q?uBPlI4G6C6KdjJCILLQmX3bsK2YnCBFbcf8dKqXImLoBEKhBHZC8dJOrFCj5?=
 =?us-ascii?Q?RG4zkBWg89lQVl8hW6sjWyWlzipXvN2SXAiObBRY0Benn1tgt/YvKWy2o9xu?=
 =?us-ascii?Q?7DI+EMr5/gPjASqHLpQvLsROpjuqMhpDuLuy/i6wB3da8qDyiq/hCL3rL2ME?=
 =?us-ascii?Q?r8+zieUjdn55ErHbMyq1zPJDOcz1eklYbveIFcLQvxhliUYIYAtjxFaUSnp7?=
 =?us-ascii?Q?+6yO1RIrWhVX7EP1uSM8/K7/IeiQVBFU3NpukD9GtbVcWNgc8MYbBL5ZdrCU?=
 =?us-ascii?Q?PF7qCSn1FkNzxsM+WyzRjUhzgC6pw6J9KNsgJEtP7q293/1Q4IrqwHGpx+GM?=
 =?us-ascii?Q?nGUVrKAzO5hoTujwDX8X+dm+qeZl3uw6ydj2KZyJWaREu6W8lpqEAFC6J0u1?=
 =?us-ascii?Q?uWLR68qi+MQ8s4PKlXjcuTF0miqAmXqLgTwk4ISrVJDI6G6XH6t3D9BCvC22?=
 =?us-ascii?Q?NBRtiBj1stO4z72kJ6mVTshW74kjwH8lechlwvJ/g+I3YXLVi7z0aq20TV3/?=
 =?us-ascii?Q?/mi///1sNvH02myDupD2JK6mABjl+KPXhC0Bt8n+Dxalsb0XVT0NjWxzmpqC?=
 =?us-ascii?Q?1xDzUimi3aq9uMNM1di2Q+YrTcw/qL7g6lLsJbx4RfHOvHClZFm378rlty1O?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c05e232-8318-4afc-c4b5-08dadd440bc4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 19:55:55.3805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oNhQsDYtFNeab/P1nNHmsO5QOgfEEGgwwaoersannNxg8TOSDpUMlkvSXZr3v/dqJdBDq3XLoQJ7XMhYEcjfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7568
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Tue, Dec 13, 2022 at 10:46:43AM +0100, Lorenzo Bianconi wrote:
> Move XDP skb_shared_info structure initialization in from
> enetc_map_rx_buff_to_xdp() to enetc_add_rx_buff_to_xdp() and do not always
> access skb_shared_info in the xdp_buff/xdp_frame since it is located in a
> different cacheline with respect to hard_start and data xdp pointers.
> Rely on XDP_FLAGS_HAS_FRAGS flag to check if it really necessary to access
> non-linear part of the xdp_buff/xdp_frame.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> This patch is based on the following series not applied yet to next-next:
> https://patchwork.kernel.org/project/netdevbpf/cover/cover.1670680119.git.lorenzo@kernel.org/
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index cd8f5f0c6b54..2ed6b163f3c8 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1305,6 +1305,10 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct enetc_bdr *tx_ring,
>  	xdp_tx_swbd->xdp_frame = NULL;
>  
>  	n++;
> +
> +	if (!xdp_frame_has_frags(xdp_frame))
> +		goto out;
> +

Tested this with single-buffer devmap XDP_REDIRECT, can't test with
multi-buffer I think.

>  	xdp_tx_swbd = &xdp_tx_arr[n];
>  
>  	shinfo = xdp_get_shared_info_from_frame(xdp_frame);
> @@ -1334,7 +1338,7 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct enetc_bdr *tx_ring,
>  		n++;
>  		xdp_tx_swbd = &xdp_tx_arr[n];
>  	}
> -
> +out:
>  	xdp_tx_arr[n - 1].is_eof = true;
>  	xdp_tx_arr[n - 1].xdp_frame = xdp_frame;
>  
> @@ -1390,16 +1394,12 @@ static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
>  {
>  	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
>  	void *hard_start = page_address(rx_swbd->page) + rx_swbd->page_offset;
> -	struct skb_shared_info *shinfo;
>  
>  	/* To be used for XDP_TX */
>  	rx_swbd->len = size;
>  
>  	xdp_prepare_buff(xdp_buff, hard_start - rx_ring->buffer_offset,
>  			 rx_ring->buffer_offset, size, false);
> -
> -	shinfo = xdp_get_shared_info_from_buff(xdp_buff);
> -	shinfo->nr_frags = 0;
>  }
>  
>  static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
> @@ -1407,7 +1407,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
>  {
>  	struct skb_shared_info *shinfo = xdp_get_shared_info_from_buff(xdp_buff);
>  	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
> -	skb_frag_t *frag = &shinfo->frags[shinfo->nr_frags];
> +	skb_frag_t *frag;
>  
>  	/* To be used for XDP_TX */
>  	rx_swbd->len = size;
> @@ -1415,6 +1415,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
>  	if (!xdp_buff_has_frags(xdp_buff)) {
>  		xdp_buff_set_frags_flag(xdp_buff);
>  		shinfo->xdp_frags_size = size;
> +		shinfo->nr_frags = 0;

Tested this and enetc_map_rx_buff_to_xdp() with single-buffer and
multi-buffer XDP_TX.

>  	} else {
>  		shinfo->xdp_frags_size += size;
>  	}
> @@ -1422,6 +1423,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
>  	if (page_is_pfmemalloc(rx_swbd->page))
>  		xdp_buff_set_frag_pfmemalloc(xdp_buff);
>  
> +	frag = &shinfo->frags[shinfo->nr_frags];
>  	skb_frag_off_set(frag, rx_swbd->page_offset);
>  	skb_frag_size_set(frag, size);
>  	__skb_frag_set_page(frag, rx_swbd->page);
> -- 
> 2.38.1
>

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks.
