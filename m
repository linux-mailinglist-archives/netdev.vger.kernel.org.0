Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACDF64576F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiLGKTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiLGKTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:19:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F6711A0A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670408299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9XN+oYBwg/FzBMOO+a8ZKj9oWdJbSN9hLcGMA4//8H8=;
        b=hjPrMJXashGlnDC+QACBmCJkCG5gFyq0x2g33+SowGhaGbBTL9uoTyO9fQI9G9GruTotg0
        efg8uwTSSjdUaftQOF38ZfjHI3iAD6xq0Ic5gWJ5PMIoPlzixwxYq6jXNaSrjfJJm8+0F1
        NiDFFnO3BrcSGkQwcMlhloPvAps9i1A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-8J9aoAinNRW2RkU2UcBfBg-1; Wed, 07 Dec 2022 05:18:18 -0500
X-MC-Unique: 8J9aoAinNRW2RkU2UcBfBg-1
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso9768225wms.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:18:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9XN+oYBwg/FzBMOO+a8ZKj9oWdJbSN9hLcGMA4//8H8=;
        b=Veuzrhxzzd/RJskGlUATVQb7EcyuopWhwyrHulUnzj+cGyGaH/LnDPqgoON2375Oyw
         ctCHfkADXQ815E+KLFIQH+jyQ9PcEDOHTCSd0L8/OakZ35mDgFkzQBWxOnso6iWi/gpb
         2ihGmaj6FhfW7gthNF80djpWDhbHTsql0vgRZDOlyuh+QhWCg5f2O8I7n8UP8K/Ir6nl
         qoBrPwfd7m2KRgrJV6Ww15+e4YThYN00WPgXhDTW5P2SxPBxguCGWviQsUqYQu1KDL33
         p+jS9xjjx+PjnNLZclm50ze7+OoVcrZ5LQ8jHdAMVnYtnujx1ETeZor0ccd2Vcsqn/Cb
         GZaw==
X-Gm-Message-State: ANoB5pmuaIOvKrkAYQzZkE4rHkQzpe11WlVlyHzf1133h7TSlEJox5yr
        j0/KBmIgKpiomj7s4fuCr2+vSrJNWatT7XyxHszvsvcIuM6EwJ2MmVEacEYrmH8NHlVNeIxxgg4
        +7SpdRNdQcUbBjCdA
X-Received: by 2002:a7b:c011:0:b0:3cf:633e:bf6a with SMTP id c17-20020a7bc011000000b003cf633ebf6amr53494652wmb.63.1670408297577;
        Wed, 07 Dec 2022 02:18:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6uytFf4a3LcfdsXtFVT3dWZv2Xsu0MR3+X+lq5orXO9nyT7Wph3RgtwIYprNzcrs9muELhzQ==
X-Received: by 2002:a7b:c011:0:b0:3cf:633e:bf6a with SMTP id c17-20020a7bc011000000b003cf633ebf6amr53494633wmb.63.1670408297327;
        Wed, 07 Dec 2022 02:18:17 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id t25-20020a1c7719000000b003cfd58409desm1201000wmi.13.2022.12.07.02.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:18:16 -0800 (PST)
Message-ID: <989e6b10fb188b015b040f6df2b19c4ecfb8bb91.camel@redhat.com>
Subject: Re: [PATCH net-next 6/6] tsnep: Add XDP RX support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Date:   Wed, 07 Dec 2022 11:18:15 +0100
In-Reply-To: <20221203215416.13465-7-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
         <20221203215416.13465-7-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
> If BPF program is set up, then run BPF program for every received frame
> and execute the selected action.
> 
> Test results with A53 1.2GHz:
> 
> XDP_DROP (samples/bpf/xdp1)
> proto 17:     865683 pkt/s
> 
> XDP_TX (samples/bpf/xdp2)
> proto 17:     253594 pkt/s
> 
> XDP_REDIRECT (samples/bpf/xdpsock)
>  sock0@eth2:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 862,258        4,514,166
> tx                 0              0
> 
> XDP_REDIRECT (samples/bpf/xdp_redirect)
> eth2->eth1         608,895 rx/s   0 err,drop/s   608,895 xmit/s
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 100 +++++++++++++++++++++
>  1 file changed, 100 insertions(+)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index 725b2a1e7be4..4e3c6bd3dc9f 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -27,6 +27,7 @@
>  #include <linux/phy.h>
>  #include <linux/iopoll.h>
>  #include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
>  
>  #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
>  #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
> @@ -44,6 +45,11 @@
>  #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
>  				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
>  
> +#define TSNEP_XDP_PASS		0
> +#define TSNEP_XDP_CONSUMED	BIT(0)
> +#define TSNEP_XDP_TX		BIT(1)
> +#define TSNEP_XDP_REDIRECT	BIT(2)
> +
>  enum {
>  	__TSNEP_DOWN,
>  };
> @@ -819,6 +825,11 @@ static inline unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
>  	return TSNEP_SKB_PAD;
>  }
>  
> +static inline unsigned int tsnep_rx_offset_xdp(void)

Please, no 'inline' in c files, the complier will do a better job
without.

> +{
> +	return XDP_PACKET_HEADROOM;
> +}
> +
>  static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>  {
>  	struct device *dmadev = rx->adapter->dmadev;
> @@ -1024,6 +1035,65 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>  	return i;
>  }
>  
> +static int tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
> +			      struct xdp_buff *xdp)
> +{
> +	unsigned int length;
> +	unsigned int sync;
> +	u32 act;
> +
> +	length = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +
> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> +	sync = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
> +	sync = max(sync, length);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return TSNEP_XDP_PASS;
> +	case XDP_TX:
> +		if (tsnep_xdp_xmit_back(rx->adapter, xdp) < 0)
> +			goto out_failure;
> +		return TSNEP_XDP_TX;
> +	case XDP_REDIRECT:
> +		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
> +			goto out_failure;
> +		return TSNEP_XDP_REDIRECT;
> +	default:
> +		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +out_failure:
> +		trace_xdp_exception(rx->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
> +				   sync, true);
> +		return TSNEP_XDP_CONSUMED;
> +	}
> +}
> +
> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
> +{
> +	int cpu = smp_processor_id();
> +	int queue;
> +	struct netdev_queue *nq;
> +
> +	if (status & TSNEP_XDP_TX) {
> +		queue = cpu % adapter->num_tx_queues;
> +		nq = netdev_get_tx_queue(adapter->netdev, queue);
> +
> +		__netif_tx_lock(nq, cpu);
> +		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
> +		__netif_tx_unlock(nq);
> +	}
> +
> +	if (status & TSNEP_XDP_REDIRECT)
> +		xdp_do_flush();
> +}
> +
>  static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
>  				       int length)
>  {
> @@ -1062,12 +1132,17 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  	int desc_available;
>  	int done = 0;
>  	enum dma_data_direction dma_dir;
> +	struct bpf_prog *prog;
>  	struct tsnep_rx_entry *entry;
> +	struct xdp_buff xdp;
> +	int xdp_status = 0;
>  	struct sk_buff *skb;
>  	int length;
> +	int retval;
>  
>  	desc_available = tsnep_rx_desc_available(rx);
>  	dma_dir = page_pool_get_dma_dir(rx->page_pool);
> +	prog = READ_ONCE(rx->adapter->xdp_prog);
>  
>  	while (likely(done < budget) && (rx->read != rx->write)) {
>  		entry = &rx->entry[rx->read];
> @@ -1111,6 +1186,28 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>  		desc_available++;
>  
> +		if (prog) {
> +			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
> +			xdp_prepare_buff(&xdp, page_address(entry->page),
> +					 tsnep_rx_offset_xdp() + TSNEP_RX_INLINE_METADATA_SIZE,
> +					 length - TSNEP_RX_INLINE_METADATA_SIZE,
> +					 false);
> +			retval = tsnep_xdp_run_prog(rx, prog, &xdp);
> +		} else {
> +			retval = TSNEP_XDP_PASS;
> +		}
> +		if (retval) {
> +			if (retval & (TSNEP_XDP_TX | TSNEP_XDP_REDIRECT))
> +				xdp_status |= retval;

Here you could avoid a couple of conditionals passing xdp_status as an
additional tsnep_xdp_run_prog() argument, let the latter update it
under the existing switch, returning a single consumed/pass up bool and
testing such value just after tsnep_xdp_run_prog().

Mostly a matter of personal tasted I guess.


Cheers,

Paolo

