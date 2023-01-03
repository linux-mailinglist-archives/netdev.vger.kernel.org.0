Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091D665C521
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbjACRck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbjACRcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:32:13 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8EB13CC4;
        Tue,  3 Jan 2023 09:32:07 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fc4so75587447ejc.12;
        Tue, 03 Jan 2023 09:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YG4i5oMddOcq4wbxchFxVq+VqEIB5EVefjqGfmz6A2Q=;
        b=UBzDhMG3uSSfDynOQEle64ardS3Ufw5fLVqZ/2Fww6pHKyFiDNTcMILa0/H0SxvA3u
         gR1ASWgjI7umu8i/MMff0sGtn8iCuZZeLk7Rh+1jYGZ5fzfhZmzcoXeTVucdA38VY5VS
         Om3OsiGSJre1n1yahFi2mmgptKYx7HX9BEIaw+F5oFyH+Y7TKBiRsYzEE+ggtat8yeDv
         zm+t+Tr8Ar/uxrUa7UNUEOuvVo57xqbk/z2kPimPY+s6Jn0GQ7VZOIJdcSqRbkZmTzG3
         8UJuysv67POsTbaae/sA+yLl9QzGhpbUXHqPqnUR6KMvA7w9wBJf/t7eLBo3cUpIWQhJ
         rIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG4i5oMddOcq4wbxchFxVq+VqEIB5EVefjqGfmz6A2Q=;
        b=xfo9dicfeb9B5wEFyuSwRw2qtelpqNmlrRS/5QQwoaN0QrrKTSwPJO6fluIQdjnq75
         oEmyCTjs3M/55+zWkrqAXNx5nf0CN41e+/lu9zgE/ei/TMaFIa/T/ocEMRl/o5mFaUIC
         ZQRijloNKoKlFGwJDkU2IVWkiIS3m6JPaen3yYIgkXdeHHfHbJTS6M1AWhYfsa1sCmQG
         ROk1fEcqy/RZjgMU1xY3Jw6SxKt4HBWoDz84SbQzdH8dLnoqGVi5kTJLuoQ2rr3Mnbas
         QtXjJ+9jH92GKfP1Rj0ojqhJzZPq3798OwNa9a03Euoh79BIjg17Ty1rlfvxWNYAN/Dt
         wBqw==
X-Gm-Message-State: AFqh2krCD21XpQVRfEf3HWtsGN4iN7qQFod0MDR/XnS7ga8NrPsj6Osc
        mhHZrx8wFEsWGpH21nbU7tI=
X-Google-Smtp-Source: AMrXdXugCVwYalVAnTPxV7bgcnPudfKLt/iLdKOfwDfLsBDbKHviJFrHAxFAYOw2I74NT2G1lao0XQ==
X-Received: by 2002:a17:906:d052:b0:7c1:5098:907a with SMTP id bo18-20020a170906d05200b007c15098907amr40260883ejb.35.1672767125685;
        Tue, 03 Jan 2023 09:32:05 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id gf3-20020a170906e20300b007bff9fb211fsm14299234ejb.57.2023.01.03.09.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:32:05 -0800 (PST)
Date:   Tue, 3 Jan 2023 19:32:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de, jacob.e.keller@intel.com
Subject: Re: [Patch net-next v6 08/13] net: dsa: microchip: ptp: add packet
 transmission timestamping
Message-ID: <20230103173203.6qufqwkdlnrck2vb@skbuf>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-9-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102050459.31023-9-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 10:34:54AM +0530, Arun Ramadoss wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index e72fce54188e..8f5e099b1b99 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -18,6 +18,8 @@
>  
>  #define ptp_caps_to_data(d) container_of((d), struct ksz_ptp_data, caps)
>  #define ptp_data_to_ksz_dev(d) container_of((d), struct ksz_device, ptp_data)
> +#define work_to_xmit_work(w) \
> +		container_of((w), struct ksz_deferred_xmit_work, work)
>  
>  /* Sub-nanoseconds-adj,max * sub-nanoseconds / 40ns * 1ns
>   * = (2^30-1) * (2 ^ 32) / 40 ns * 1 ns = 6249999
> @@ -111,9 +113,15 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
>  
>  	switch (config->tx_type) {
>  	case HWTSTAMP_TX_OFF:
> +		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 0;
> +		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 0;
> +		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
>  		prt->hwts_tx_en = false;
>  		break;
>  	case HWTSTAMP_TX_ONESTEP_P2P:
> +		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 0;
> +		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
> +		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;

Please use true/false for boolean types. I believe I've said this before.

>  		prt->hwts_tx_en = true;
>  		break;
>  	default:
> @@ -232,6 +240,88 @@ bool ksz_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
>  	return false;
>  }
>  
> +void ksz_port_txtstamp(struct dsa_switch *ds, int port,
> +		       struct sk_buff *skb)

Function prototype fits on one line.

> +{
> +	struct ksz_device *dev	= ds->priv;

Again, I believe the tab here is misused, as there is nothing to align
the equal sign to.

> +	struct ptp_header *hdr;
> +	struct sk_buff *clone;
> +	struct ksz_port *prt;
> +	unsigned int type;
> +	u8 ptp_msg_type;
> +
> +	prt = &dev->ports[port];
> +
> +	if (!prt->hwts_tx_en)
> +		return;
> +
> +	type = ptp_classify_raw(skb);
> +	if (type == PTP_CLASS_NONE)
> +		return;
> +
> +	hdr = ptp_parse_header(skb, type);
> +	if (!hdr)
> +		return;
> +
> +	ptp_msg_type = ptp_get_msgtype(hdr, type);
> +
> +	switch (ptp_msg_type) {
> +	case PTP_MSGTYPE_PDELAY_REQ:
> +		break;
> +
> +	default:
> +		return;
> +	}
> +
> +	clone = skb_clone_sk(skb);
> +	if (!clone)
> +		return;
> +
> +	/* caching the value to be used in tag_ksz.c */
> +	KSZ_SKB_CB(skb)->clone = clone;
> +}
> +
> +static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
> +				 struct ksz_port *prt, struct sk_buff *skb)
> +{
> +	struct skb_shared_hwtstamps hwtstamps = {};
> +	int ret;
> +
> +	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;

It would be good if you set SKBTX_IN_PROGRESS _before_ passing the skb
ownership to the DSA master (dsa_enqueue_skb). It makes a certain class
of bugs much easier to identify, because they will reproduce much more
consistently. Otherwise, as the way things are written, the DSA master
driver will sometimes see this skb as having SKBTX_IN_PROGRESS and
sometimes not in progress (because the assignment races with the
ndo_start_xmit of that other driver).

I know perfectly well that the DSA master driver should not look at the
SKBTX_IN_PROGRESS flag of a skb which it's not support to timestamp itself.
But sometimes drivers aren't all that perfect.

> +
> +	/* timeout must include tstamp latency, IRQ latency and time for
> +	 * reading the time stamp.

FWIW, also the time necessary for the DSA master to transmit the skb,
of course.

> +	 */
> +	ret = wait_for_completion_timeout(&prt->tstamp_msg_comp,
> +					  msecs_to_jiffies(100));
> +	if (!ret)
> +		return;
> +
> +	hwtstamps.hwtstamp = prt->tstamp_msg;
> +	skb_complete_tx_timestamp(skb, &hwtstamps);
> +}
> +
> +void ksz_port_deferred_xmit(struct kthread_work *work)
> +{
> +	struct ksz_deferred_xmit_work *xmit_work = work_to_xmit_work(work);
> +	struct sk_buff *clone, *skb = xmit_work->skb;
> +	struct dsa_switch *ds = xmit_work->dp->ds;
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *prt;
> +
> +	prt = &dev->ports[xmit_work->dp->index];
> +
> +	clone = KSZ_SKB_CB(skb)->clone;
> +
> +	reinit_completion(&prt->tstamp_msg_comp);
> +
> +	dsa_enqueue_skb(skb, skb->dev);
> +
> +	ksz_ptp_txtstamp_skb(dev, prt, clone);
> +
> +	kfree(xmit_work);
> +}
> +
>  static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
>  {
>  	u32 nanoseconds;
> @@ -480,7 +570,29 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
>  
>  static irqreturn_t ksz_ptp_msg_thread_fn(int irq, void *dev_id)
>  {
> -	return IRQ_NONE;
> +	struct ksz_ptp_irq *ptpmsg_irq = dev_id;
> +	struct ksz_device *dev;
> +	struct ksz_port *port;
> +	u32 tstamp_raw;
> +	ktime_t tstamp;
> +	int ret;
> +
> +	port = ptpmsg_irq->port;
> +	dev = port->ksz_dev;
> +
> +	if (ptpmsg_irq->ts_en) {
> +		ret = ksz_read32(dev, ptpmsg_irq->ts_reg, &tstamp_raw);
> +		if (ret)
> +			return IRQ_NONE;
> +
> +		tstamp = ksz_decode_tstamp(tstamp_raw);
> +
> +		port->tstamp_msg = ksz_tstamp_reconstruct(dev, tstamp);
> +
> +		complete(&port->tstamp_msg_comp);
> +	}
> +
> +	return IRQ_HANDLED;
>  }
