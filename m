Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D3465C534
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbjACRk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbjACRkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:40:14 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC531263B;
        Tue,  3 Jan 2023 09:40:07 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c17so44823622edj.13;
        Tue, 03 Jan 2023 09:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7/u/+NO1/u6xtGW0HGp1uN31lHD185Kfc1YVT6fktU=;
        b=ltpHUQ+4guxNvt6/0CnhPaDbWdW1ukGhY+rOeWF60K03bzWNS5uY2PdgF3lhKalEQK
         NaI1Vgfsr8ntVqlLQ9iSMOwdratCYBxWOX5uJMTdQ/ACy+gJNZmXtcyaJz42050PXXko
         3/jjaBkND7vX5cZXq+klkfqt0yPPS9e0A/6gAx+w8WH60zJReTsEfLEQqx1WGIBSWnKP
         kPx/UgBWi3fKMfANbEZjKyKjVWmqeRFuxZV5ZgIBMAtmmnBWtiub7Z68rk4i+lunIEAF
         JAEAqjeG7P7LaLAdcvVMncoiKa5FvUxDAwHqrNQyECmLTpg0HL5nOrF2OhYg4VAl0MRq
         D6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7/u/+NO1/u6xtGW0HGp1uN31lHD185Kfc1YVT6fktU=;
        b=qnTU/n3n6C5Zmn480Dx3BErETIYdk0sGQA09hbKgg/Mj7oz5AOpJupt63yEeWCLkIE
         K3mDoNnFMByog5H2uq4cs0SqoiJ3iTZfi47MgQyRnaDxNK71SIpIiEE/Chm6tFjU59Gv
         Sr5r/MgMKnJMcx249wyYwe+uVagDi4YbCGEb3ZaHZMraO7NHT5Y1zfhWrbN5Jn8bCeRn
         CCc7jjOX5hawStZwekuBPGoGxmvENPYHFnRyLgn6XplPzlK+TX9T1N2d7n+SJ8dcZhsQ
         293QBHfxR7Na3Hz9Y0gsEWKQbwHbej75C44BEsI6pH7ZHVWjOg+jt+SA6TL463YO6ryX
         FxUg==
X-Gm-Message-State: AFqh2kpABhwpS8cHau/ZXKEQsc13PXu2guIQX42M2TE6AKiSjE3qOvkl
        FRhXsM8K+H/fssGQEMAhgGU=
X-Google-Smtp-Source: AMrXdXts9S3Rn+7Va7dRsPXFdpIGlugAHTLT5uwwdJqPT1e2FDsmYRsg2uYWiw1XvfZL89s95KQd9g==
X-Received: by 2002:aa7:c704:0:b0:47e:22ac:625c with SMTP id i4-20020aa7c704000000b0047e22ac625cmr34898903edq.41.1672767606027;
        Tue, 03 Jan 2023 09:40:06 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id r17-20020aa7d591000000b004847513929csm11074269edq.72.2023.01.03.09.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:40:05 -0800 (PST)
Date:   Tue, 3 Jan 2023 19:40:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de, jacob.e.keller@intel.com
Subject: Re: [Patch net-next v6 09/13] net: dsa: microchip: ptp: move
 pdelay_rsp correction field to tail tag
Message-ID: <20230103174003.ip7suairhetlru6z@skbuf>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-10-arun.ramadoss@microchip.com>
 <20230102050459.31023-10-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102050459.31023-10-arun.ramadoss@microchip.com>
 <20230102050459.31023-10-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 10:34:55AM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> For PDelay_Resp messages we will likely have a negative value in the
> correction field. The switch hardware cannot correctly update such
> values (produces an off by one error in the UDP checksum), so it must be
> moved to the time stamp field in the tail tag. Format of the correction
> field is 48 bit ns + 16 bit fractional ns.  After updating the
> correction field, clone is no longer required hence it is freed.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
> v2 -> v3
> - used update_correction variable in skb->cb instead of ptp_msg_type
> 
> v1 -> v2
> - added fallthrough keyword in switch case to suppress checkpatch
> warning

I don't think checkpatch asks for fallthrough keyword if there is no
code in between the cases. That would be silly, because it's obvious
that the code falls through. It's most likely that the fallthrough is
needed, but not _here_.

> 
> RFC v3 -> Patch v1
> - Patch is separated from transmission logic patch
> ---
>  drivers/net/dsa/microchip/ksz_ptp.c |  5 ++++
>  include/linux/dsa/ksz_common.h      |  2 ++
>  net/dsa/tag_ksz.c                   | 41 ++++++++++++++++++++++++++++-
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index 8f5e099b1b99..5d5b8d4ed17b 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -267,6 +267,8 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
>  
>  	switch (ptp_msg_type) {
>  	case PTP_MSGTYPE_PDELAY_REQ:
> +		 fallthrough;

On the other hand, I would expect checkpatch to warn about the
superfluous space. There should be just 2 leading tabs here, not 2 tabs
and 1 space.

> +	case PTP_MSGTYPE_PDELAY_RESP:
>  		break;
>  
>  	default:
> @@ -279,6 +281,9 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
>  
>  	/* caching the value to be used in tag_ksz.c */
>  	KSZ_SKB_CB(skb)->clone = clone;
> +	KSZ_SKB_CB(clone)->ptp_type = type;
> +	if (ptp_msg_type == PTP_MSGTYPE_PDELAY_RESP)
> +		KSZ_SKB_CB(clone)->update_correction = true;
>  }
>  
>  static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
> diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
> index b91beab5e138..576a99ca698d 100644
> --- a/include/linux/dsa/ksz_common.h
> +++ b/include/linux/dsa/ksz_common.h
> @@ -36,6 +36,8 @@ struct ksz_tagger_data {
>  
>  struct ksz_skb_cb {
>  	struct sk_buff *clone;
> +	unsigned int ptp_type;
> +	bool update_correction;
>  	u32 tstamp;
>  };
>  
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index e14ee26bf6a0..7dd2133b0820 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -7,6 +7,7 @@
>  #include <linux/dsa/ksz_common.h>
>  #include <linux/etherdevice.h>
>  #include <linux/list.h>
> +#include <linux/ptp_classify.h>
>  #include <net/dsa.h>
>  
>  #include "tag.h"
> @@ -194,14 +195,52 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag)
>   */
>  static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
>  {
> +	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
>  	struct ksz_tagger_private *priv;
> +	struct ptp_header *ptp_hdr;
> +	bool update_correction;
> +	unsigned int ptp_type;
> +	u32 tstamp_raw = 0;
> +	s64 correction;
>  
>  	priv = ksz_tagger_private(dp->ds);
>  
>  	if (!test_bit(KSZ_HWTS_EN, &priv->state))
>  		return;
>  
> -	put_unaligned_be32(0, skb_put(skb, KSZ_PTP_TAG_LEN));
> +	if (!clone)
> +		goto output_tag;
> +
> +	update_correction = KSZ_SKB_CB(clone)->update_correction;
> +	if (!update_correction)

I don't think the on-stack variable "update_correction" really serves a
purpose here, since it's used only once; it would be simpler if you just
used "if (KSZ_SKB_CB()->update...)".

> +		goto output_tag;
> +
> +	ptp_type = KSZ_SKB_CB(clone)->ptp_type;
> +
> +	ptp_hdr = ptp_parse_header(skb, ptp_type);
> +	if (!ptp_hdr)
> +		goto output_tag;
> +
> +	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
> +
> +	if (correction < 0) {
> +		struct timespec64 ts;
> +
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

Why do you clone the skb in the first place, then?
Just extend KSZ_SKB_CB() with some other flag to denote that this skb
needs processing here, and replace the "if (!clone)" test with that.

> +
> +output_tag:
> +	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ_PTP_TAG_LEN));
>  }
>  
>  /* Defer transmit if waiting for egress time stamp is required.  */
> -- 
> 2.36.1
> 

