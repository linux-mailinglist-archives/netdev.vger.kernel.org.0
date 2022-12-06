Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635A7644384
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiLFMyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiLFMxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:53:52 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DCFF6D;
        Tue,  6 Dec 2022 04:53:49 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z92so20177591ede.1;
        Tue, 06 Dec 2022 04:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HcQpLIgk7FDe8TDre+fsogLWbAMYx7kboeWg7OjsK2E=;
        b=TQh3CMmY28sMVz0h70oZ+26STyNmlXcIVBmb5mNb7YxavyaSssn+VGOxRY5u4e6+X5
         MGCTdoJea2Z8zX4fC6T/YA1WIGsPpxG4z23RpoYUDhcdWgfJ0ZwnPBuXOC/cByRgzTXP
         0FtGB+hmD5p/vRKbXTQRdbX8SL2ybxgxBfYfJxIgUxtZ4k3LeR0/u4NEcegx6Q87GAbD
         CneDjcbqYNlAv8D/KWXoeoyw3pxysmasqu+wkOhdRaail7lTN2FdhqBA3BUzXLJ+BlDR
         N27SJp7unEcvpr2guOZzjMU2O1MK9/KG7cZg1+gNin6LN7RUCQYgRuBKGYjmaSmxbDTT
         VFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcQpLIgk7FDe8TDre+fsogLWbAMYx7kboeWg7OjsK2E=;
        b=yvi9Z2Rp/tUuZ76eHyi0Fil5fcDNnNsVRd/ZOKk/gsWqTYQzS0DIxg5lwLsSRZMsQm
         Hp7EaMtYjVZEyIDVgl0k+syP8q/Z5UogE0ciFXs6v4wOaFBnh3zZiFAC3BNlMzAQ15V+
         sK8gAky/9Q9PyV4O+ZcrijeUww73vbVDnYe86wUMRgDkV6PkQoQ1LMV5gB7RvENP8y84
         VaY7twXWpU9DyRB12N0NQezuEtvR978aPCpGerg5IquhNaNR0rFCP3w3NLoRJrPj8dK4
         TaXeePSMQV1NYSzSeNNJkw0Bxyr2p5Uvw/nZKeNTBiKwlsson/N6BkDxx06uaHAj0tHR
         w1Sw==
X-Gm-Message-State: ANoB5pmCrVU3lPVbAIrWqiR4m6VHXw8tbMUt7jye1sSDxv/vLYWAAZMH
        92zYISOrbCeQh/5LtuDjdwo=
X-Google-Smtp-Source: AA0mqf7vsZ6Mt8VWaagYQp8hD3OgQSyGl+BrXBxApQHL+A8P6g1R8wBUU0bk1FcDxQwhVAsUUtKDTQ==
X-Received: by 2002:aa7:d601:0:b0:46c:7da6:7320 with SMTP id c1-20020aa7d601000000b0046c7da67320mr11222860edr.227.1670331227752;
        Tue, 06 Dec 2022 04:53:47 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id b17-20020a1709063cb100b007b4bc423b41sm7233152ejh.190.2022.12.06.04.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:53:47 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:53:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v2 07/13] net: dsa: microchip: ptp: add packet
 reception timestamping
Message-ID: <20221206125344.rwheovbxdoad2duv@skbuf>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
 <20221206091428.28285-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206091428.28285-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 02:44:22PM +0530, Arun Ramadoss wrote:
> +static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
> +			      struct net_device *dev, unsigned int port)
> +{
> +	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
> +	struct dsa_switch *ds = dev->dsa_ptr->ds;
> +	u8 *tstamp_raw = tag - KSZ_PTP_TAG_LEN;
> +	struct ksz_tagger_data *tagger_data;
> +	struct ptp_header *ptp_hdr;
> +	unsigned int ptp_type;
> +	u8 ptp_msg_type;
> +	ktime_t tstamp;
> +	s64 correction;
> +
> +	tagger_data = ksz_tagger_data(ds);
> +	if (!tagger_data->meta_tstamp_handler)
> +		return;

The meta_tstamp_handler doesn't seem to be needed.

Just save the partial timestamp in KSZ_SKB_CB(), and reconstruct that
timestamp with the full PTP time in the ds->ops->port_rxtstamp() method.

Biggest advantage is that ptp_classify_raw() won't be called twice in
the RX path for the same packet, as will currently happen with your code.

> +
> +	/* convert time stamp and write to skb */
> +	tstamp = ksz_decode_tstamp(get_unaligned_be32(tstamp_raw));
> +	memset(hwtstamps, 0, sizeof(*hwtstamps));
> +	hwtstamps->hwtstamp = tagger_data->meta_tstamp_handler(ds, tstamp);
> +
> +	if (skb_headroom(skb) < ETH_HLEN)
> +		return;
> +
> +	__skb_push(skb, ETH_HLEN);
> +	ptp_type = ptp_classify_raw(skb);
> +	__skb_pull(skb, ETH_HLEN);
> +
> +	if (ptp_type == PTP_CLASS_NONE)
> +		return;
> +
> +	ptp_hdr = ptp_parse_header(skb, ptp_type);
> +	if (!ptp_hdr)
> +		return;
> +
> +	ptp_msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
> +	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
> +		return;
> +
> +	/* Only subtract the partial time stamp from the correction field.  When
> +	 * the hardware adds the egress time stamp to the correction field of
> +	 * the PDelay_Resp message on tx, also only the partial time stamp will
> +	 * be added.
> +	 */
> +	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
> +	correction -= ktime_to_ns(tstamp) << 16;
> +
> +	ptp_header_update_correction(skb, ptp_type, ptp_hdr, correction);
> +}
> +
>  /* Time stamp tag *needs* to be inserted if PTP is enabled in hardware.
>   * Regardless of Whether it is a PTP frame or not.
>   */
> @@ -215,8 +268,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
>  	unsigned int len = KSZ_EGRESS_TAG_LEN;
>  
>  	/* Extra 4-bytes PTP timestamp */
> -	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
> -		len += KSZ9477_PTP_TAG_LEN;
> +	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
> +		ksz_rcv_timestamp(skb, tag, dev, port);
> +		len += KSZ_PTP_TAG_LEN;
> +	}
>  
>  	return ksz_common_rcv(skb, dev, port, len);
>  }
