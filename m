Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53AF52B081
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 04:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiERCnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 22:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiERCnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 22:43:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4636C2CC98;
        Tue, 17 May 2022 19:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C33A5616BD;
        Wed, 18 May 2022 02:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC934C385B8;
        Wed, 18 May 2022 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652841776;
        bh=8lal2RSw8WZDliO+MS5PxwsArM0OcZxQoc6XS524+XQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PMQn4g6draPn5/ucYkLGG4AIMeasxadp/5xL/DF+6xJntfe7A0GbuGSfJZ03wHRXD
         g15C715cWQipJ+dRax4EpfPtF/OVcskbX9aRYFlMjbJeQqfT5PcwVsyePxNEzTv3H+
         uvZ3b8rHJmk+C1PbtD0+y68wCLMHrxCQ9vc9paAv71RmMUPVmRxe3S/9otxnYF/lqF
         CX638d7HUFT9WJ8jOPsYSgzbWr/du0vP/63aT0qxvHkKJre/nO4hKKnFhe+Noq+RaM
         BgGbIsNE3/VVUKDYcdQWNJdE2ERShfcsypNkcSooPSMri2xKWNfYaLSJY2jVzMo4v5
         NdSP1Kd+2udzQ==
Date:   Tue, 17 May 2022 19:42:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>,
        <harinikatakamlinux@gmail.com>, <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH 1/3] net: macb: Fix PTP one step sync support
Message-ID: <20220517194254.015e87f3@kernel.org>
In-Reply-To: <20220517073259.23476-2-harini.katakam@xilinx.com>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
        <20220517073259.23476-2-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 13:02:57 +0530 Harini Katakam wrote:
> PTP one step sync packets cannot have CSUM padding and insertion in
> SW since time stamp is inserted on the fly by HW.
> In addition, ptp4l version 3.0 and above report an error when skb
> timestamps are reported for packets that not processed for TX TS
> after transmission.
> Add a helper to identify PTP one step sync and fix the above two
> errors.
> Also reset ptp OSS bit when one step is not selected.
> 
> Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
> Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")

Please make sure to CC authors of the patches under fixes.
./scripts/get_maintainer should point them out.

> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

If this is a fix it needs to be posted as [PATCH net] separately first
so we can get it into stable as well. The trees get merged together
every Thursday, if you're quick you may still make it this week.
Then after trees get merged you should send send the remaining patches.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

> Notes:
> -> Added the macb pad and fcs fixes tag because strictly speaking the PTP support  
> patch precedes the fcs patch in timeline.
> -> FYI, the error observed with setting HW TX timestamp for one step sync packets:  
> ptp4l[405.292]: port 1: unexpected socket error
> 
>  drivers/net/ethernet/cadence/macb_main.c | 54 ++++++++++++++++++++----
>  drivers/net/ethernet/cadence/macb_ptp.c  |  4 +-
>  2 files changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index e993616308f8..e23a03e8badf 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -37,6 +37,7 @@
>  #include <linux/phy/phy.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/reset.h>
> +#include <linux/ptp_classify.h>

Please keep the includes in alphabetical order.

>  #include "macb.h"
>  
>  /* This structure is only used for MACB on SiFive FU540 devices */
> @@ -98,6 +99,9 @@ struct sifive_fu540_macb_mgmt {
>  
>  #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
>  
> +/* IEEE1588 PTP flag field values  */
> +#define PTP_FLAG_TWOSTEP	0x2

Shouldn't this go into the PTP header?

>  /* DMA buffer descriptor might be different size
>   * depends on hardware configuration:
>   *
> @@ -1122,6 +1126,36 @@ static void macb_tx_error_task(struct work_struct *work)
>  	napi_enable(&queue->napi_tx);
>  }
>  
> +static inline bool ptp_oss(struct sk_buff *skb)

Please spell out then name more oss == open source software.

No inline here, please, let the compiler decide if the function is
small enough. One step timestamp may be a rare use case so inlining
this twice is not necessarily the right choice.

> +{
> +	struct ptp_header *hdr;
> +	unsigned int ptp_class;
> +	u8 msgtype;
> +
> +	/* No need to parse packet if PTP TS is not involved */
> +	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> +		goto not_oss;
> +
> +	/* Identify and return whether PTP one step sync is being processed */
> +	ptp_class = ptp_classify_raw(skb);
> +	if (ptp_class == PTP_CLASS_NONE)
> +		goto not_oss;
> +
> +	hdr = ptp_parse_header(skb, ptp_class);
> +	if (!hdr)
> +		goto not_oss;
> +
> +	if (hdr->flag_field[0] & PTP_FLAG_TWOSTEP)
> +		goto not_oss;
> +
> +	msgtype = ptp_get_msgtype(hdr, ptp_class);
> +	if (msgtype == PTP_MSGTYPE_SYNC)
> +		return true;
> +
> +not_oss:
> +	return false;
> +}
> +
>  static int macb_tx_complete(struct macb_queue *queue, int budget)
>  {
>  	struct macb *bp = queue->bp;
> @@ -1158,13 +1192,14 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
>  
>  			/* First, update TX stats if needed */
>  			if (skb) {
> -				if (unlikely(skb_shinfo(skb)->tx_flags &
> -					     SKBTX_HW_TSTAMP) &&
> -				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
> -					/* skb now belongs to timestamp buffer
> -					 * and will be removed later
> -					 */
> -					tx_skb->skb = NULL;
> +				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&

ptp_oss already checks if HW_TSTAMP is set.

> +				    !ptp_oss(skb)) {
> +					if (gem_ptp_do_txstamp(queue, skb, desc) == 0) {

Why convert the gem_ptp_do_txstamp check from a && in the condition to
a separate if?

> +						/* skb now belongs to timestamp buffer
> +						 * and will be removed later
> +						 */
> +						tx_skb->skb = NULL;
> +					}
>  				}
>  				netdev_vdbg(bp->dev, "skb %u (data %p) TX complete\n",
>  					    macb_tx_ring_wrap(bp, tail),
> @@ -2063,7 +2098,7 @@ static unsigned int macb_tx_map(struct macb *bp,
>  			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
>  			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
>  			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
> -			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
> +			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl && !ptp_oss(skb))
>  				ctrl |= MACB_BIT(TX_NOCRC);
>  		} else
>  			/* Only set MSS/MFS on payload descriptors
> @@ -2159,9 +2194,10 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
>  	struct sk_buff *nskb;
>  	u32 fcs;
>  
> +	/* Not available for GSO and PTP one step sync */

If the functions are named right this comment should not be needed.

>  	if (!(ndev->features & NETIF_F_HW_CSUM) ||
>  	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
> -	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
> +	    skb_shinfo(*skb)->gso_size || ptp_oss(*skb))
>  		return 0;
>  
>  	if (padlen <= 0) {
> diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
> index fb6b27f46b15..9559c16078f9 100644
> --- a/drivers/net/ethernet/cadence/macb_ptp.c
> +++ b/drivers/net/ethernet/cadence/macb_ptp.c
> @@ -470,8 +470,10 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	case HWTSTAMP_TX_ONESTEP_SYNC:
>  		if (gem_ptp_set_one_step_sync(bp, 1) != 0)
>  			return -ERANGE;
> -		fallthrough;
> +		tx_bd_control = TSTAMP_ALL_FRAMES;
> +		break;
>  	case HWTSTAMP_TX_ON:
> +		gem_ptp_set_one_step_sync(bp, 0);
>  		tx_bd_control = TSTAMP_ALL_FRAMES;
>  		break;
>  	default:

