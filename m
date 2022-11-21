Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955A8632FFD
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiKUWvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKUWvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:51:16 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DC676169;
        Mon, 21 Nov 2022 14:51:14 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ft34so31766030ejc.12;
        Mon, 21 Nov 2022 14:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LfUGZj1LCxAemKpNc6YCN31EZ8nKAkPT8bKBKtlXg9Q=;
        b=NVADdeQo3QZsyTMk9oPpYOLNxrRcwPkuz+nFNqW7inCIdNIqL12Fup0SHIJC+/0ihu
         21KwHDtgZIizr6KRd/h6h8+lG9fa7ymjOj2kyqsjvKkoej9IFYdalli2R0/ZebnnqSlx
         WTiHcI2RDJBKE8oFXf6uVkUfT6euh1ts49BFeg99IBmhgctU3YgdKlDEqXnFAXv0nyP2
         w6hecYnI62NXUOX4/LB7C5J+xPBe+2XKrj35Edsnzbv2mZUzuc1o3Z4hHg+DL4Bk9dyJ
         f6KPW94gFJ7hesfoOu0N+hDDQcpmjRjKtxmGDMrFO6ClOe+ME/ixS/Ccsm2kawbGX0Yf
         wGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfUGZj1LCxAemKpNc6YCN31EZ8nKAkPT8bKBKtlXg9Q=;
        b=s/hqW3e7jakETejedpC91G800lc+sRYeEJGftSlAUprXxiS4JJ9GNaCT2zQzlDMpFA
         iraNJswV797Um+fBFiUgTeYQHbGhs4qfaglbbI6m7efXUt/1XfYA1ebvuAfcaoXpcad7
         g+1mRnKfMUDw+ZSfpaCKFyY+CupTHfJ6X5/yWCOLcOyYJYLI7vEE3p/he3tkWWwK9ZSP
         BmzohqtDsEWmCYFSVyaYjUr/owmu6GWpJIuqtQuux9CDsnKY0/2C28vNqYKtwEg0ym/e
         yjEWWu0hPlzzYyc0nJ2JVHNo1FWbyY+CDofbNzE5G1+4wIEj5AuPx4EDaNxdmjPwGoL0
         wmTA==
X-Gm-Message-State: ANoB5pmch6Czg5WY80AZTcAUBzbx0BktqNz0YHUO4pDZr2Y+15p2+LBi
        huYivmmIVHG4vsDuQRSnbGE=
X-Google-Smtp-Source: AA0mqf79/Ke1CW43MqT3oV1ujLcAWxalv4dNSorq8mkwB5GJwzbT0B7uwue9GHc3r30glZG69OJ2Fw==
X-Received: by 2002:a17:906:a2d1:b0:781:bc28:f455 with SMTP id by17-20020a170906a2d100b00781bc28f455mr17021624ejb.170.1669071072818;
        Mon, 21 Nov 2022 14:51:12 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id cq17-20020a056402221100b0045ce419ecffsm5757437edb.58.2022.11.21.14.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 14:51:12 -0800 (PST)
Date:   Tue, 22 Nov 2022 00:51:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [RFC Patch net-next v2 7/8] net: dsa: microchip: add the
 transmission tstamp logic
Message-ID: <20221121225109.5j5g5yubqgzukloh@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Mon, Nov 21, 2022 at 09:11:49PM +0530, Arun Ramadoss wrote:
> This patch adds the routines for transmission of ptp packets. When the
> ptp packets(sync, pdelay_req, pdelay_rsp) to be transmitted, the skb is
> copied to global skb through port_txtstamp ioctl.
> After the packet is transmitted, ISR is triggered. The time at which
> packet transmitted is recorded to separate register available for each
> message. This value is reconstructed to absolute time and posted to the
> user application through skb complete.

"skb complete" is not a thing. "socket error queue" is.

> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
> +static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
> +				 struct ksz_port *prt, struct sk_buff *skb)
> +{
> +	struct skb_shared_hwtstamps hwtstamps = {};
> +	int ret;
> +
> +	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +
> +	/* timeout must include tstamp latency, IRQ latency and time for
> +	 * reading the time stamp.
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
> +#define work_to_xmit_work(w) \
> +		container_of((w), struct ksz_deferred_xmit_work, work)
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
> +	/* Transfer skb to the host port. */
> +	dsa_enqueue_skb(skb, skb->dev);
> +
> +	ksz_ptp_txtstamp_skb(dev, prt, clone);
> +
> +	kfree(xmit_work);
> +}
> +
>  static const struct ptp_clock_info ksz_ptp_caps = {
>  	.owner		= THIS_MODULE,
>  	.name		= "Microchip Clock",
> @@ -514,7 +568,29 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
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
> +		port->tstamp_msg = ksz_tstamp_reconstruct(dev->ds, tstamp);
> +
> +		complete(&port->tstamp_msg_comp);
> +	}
> +
> +	return IRQ_HANDLED;
>  }

I dug out some notes I had taken while reviewing a previous patch set
from Christian. There was a race condition which caused rare TX timestamping
timeouts, and the issue seems very much still present here. See below my
notes, luckily they resulted in a patch which solved the problem at the time.

From 97ad5ac1541349584fc63f1d28ce12a6675dcff0 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 20 Oct 2021 00:39:37 +0300
Subject: [PATCH] net: dsa: ksz9477_ptp: fix race condition between IRQ thread
 and deferred xmit kthread

Two-step PTP TX timestamping for the ksz9477 driver works as follows:

1. ksz9477_port_deferred_xmit() initializes a completion structure and
   queues the PTP skb to the DSA master

2. DSA master sends the packet to the switch, which forwards it to the
   egress port and the TX timestamp is taken.

3. Switch raises its PTP IRQ and the ksz9477_ptp_port_interrupt()
   handler is run.

4. The PTP timestamp is read, and the completion structure is signaled.

5. PTP interrupts are rearmed for the next timestampable skb.

6. The deferred xmit kthread is woken up by the completion. It collects
   the TX timestamp from the irq kthread, it annotates the skb clone
   with that timestamp, delivers it to the socket error queue, and
   exits.

7. The deferred xmit kthread gets rescheduled with the next
   timestampable PTP packet and the steps from 1 are executed again,
   identically.

There is an issue in the fact that steps 5 and 6 might not actually run
in this exact order. Step 6, the deferred xmit kthread getting woken up
by the completion, might happen as soon as the completion is signaled at
step 4. In that case, the deferred xmit kthread might run to completion
and we might reach step 7, while step 5 (write-1-to-clear to the IRQ
status register, to rearm the interrupt, has _not_ yet run).

If the deferred xmit kthread makes enough progress with the _next_ PTP
skb, such that it actually manages to enqueue it to the DSA master, and
that makes it all the way to the hardware, which takes another TX
timestamp, we have a problem if the IRQ kthread has not cleared the PTP
TX timestamp status yet.

If it clears the PTP status register now, it has effectively eaten a TX
timestamp.

The implication is that the completion for this second PTP skb will time
out, but otherwise, the system will keep chugging on, it will not be
forever stuck. The IRQ kthread does not get rearmed because it has no
reason to (the PTP IRQ is cleared), and the deferred xmit kthread will
free the skb for the completion that timed out, and carry on with its
life. The next skb can go through the cycle 1-6 just fine.

The problem which makes the above scenario possible is that we clear the
interrupt status after we signal the completion. Do it before, and the
interrupt handler is free to do whatever it wishes until it returns.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz9477_ptp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index c646689cb71e..bc3f0283859a 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.c
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -1106,6 +1106,11 @@ irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port)
 	if (ret)
 		return IRQ_NONE;
 
+	/* Clear interrupt(s) (W1C) */
+	ret = ksz_write16(dev, addr, data);
+	if (ret)
+		return IRQ_NONE;
+
 	if (data & PTP_PORT_XDELAY_REQ_INT) {
 		/* Timestamp for Pdelay_Req / Delay_Req */
 		struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
@@ -1128,11 +1133,6 @@ irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port)
 		complete(&prt->tstamp_completion);
 	}
 
-	/* Clear interrupt(s) (W1C) */
-	ret = ksz_write16(dev, addr, data);
-	if (ret)
-		return IRQ_NONE;
-
 	return IRQ_HANDLED;
 }
 

About the only difference seems to be that ACK-ing the interrupt is done
at the end of ksz_ptp_irq_thread_fn(), while complete(&port->tstamp_msg_comp)
is called from ksz_ptp_msg_thread_fn() - which is called by handle_nested_irq()
IIUC.

>  
> +/* Time stamp tag is only inserted if PTP is enabled in hardware. */
> +static void ksz_xmit_timestamp(struct dsa_switch *ds, struct sk_buff *skb,
> +			       unsigned int port)
> +{
> +	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
> +	struct ksz_tagger_data *tagger_data;
> +	struct ptp_header *ptp_hdr;
> +	unsigned int ptp_type;
> +	u32 tstamp_raw = 0;
> +	u8 ptp_msg_type;
> +	s64 correction;
> +
> +	if (!clone)
> +		goto out_put_tag;
> +
> +	/* Use cached PTP type from ksz_ptp_port_txtstamp().  */
> +	ptp_type = KSZ_SKB_CB(clone)->ptp_type;
> +	if (ptp_type == PTP_CLASS_NONE)
> +		goto out_put_tag;
> +
> +	ptp_hdr = ptp_parse_header(skb, ptp_type);
> +	if (!ptp_hdr)
> +		goto out_put_tag;
> +
> +	tagger_data = ksz_tagger_data(ds);
> +	if (!tagger_data->is_ptp_twostep)
> +		goto out_put_tag;
> +
> +	if (tagger_data->is_ptp_twostep(ds, port))
> +		goto out_put_tag;
> +
> +	ptp_msg_type = KSZ_SKB_CB(clone)->ptp_msg_type;
> +	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_RESP)
> +		goto out_put_tag;
> +
> +	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
> +
> +	/* For PDelay_Resp messages we will likely have a negative value in the
> +	 * correction field (see ksz9477_rcv()). The switch hardware cannot
> +	 * correctly update such values (produces an off by one error in the UDP
> +	 * checksum), so it must be moved to the time stamp field in the tail
> +	 * tag.
> +	 */
> +	if (correction < 0) {
> +		struct timespec64 ts;
> +
> +		/* Move ingress time stamp from PTP header's correction field to
> +		 * tail tag. Format of the correction filed is 48 bit ns + 16
> +		 * bit fractional ns.
> +		 */
> +		ts = ns_to_timespec64(-correction >> 16);
> +		tstamp_raw = ((ts.tv_sec & 3) << 30) | ts.tv_nsec;
> +
> +		/* Set correction field to 0 and update UDP checksum.  */
> +		ptp_header_update_correction(skb, ptp_type, ptp_hdr, 0);
> +	}
> +
> +	/* For PDelay_Resp messages, the clone is not required in
> +	 * skb_complete_tx_timestamp() and should be freed here.
> +	 */
> +	kfree_skb(clone);
> +	KSZ_SKB_CB(skb)->clone = NULL;
> +
> +out_put_tag:
> +	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
> +}
