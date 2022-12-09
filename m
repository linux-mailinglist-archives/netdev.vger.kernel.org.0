Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180ED6484AE
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiLIPIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiLIPGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:06:54 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36445AE1A;
        Fri,  9 Dec 2022 07:06:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id l11so3457721edb.4;
        Fri, 09 Dec 2022 07:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0FxyA7dRkxBEiA6ABsejXOaJjVnfAPVgsqCFDw63Vww=;
        b=namGDfXr4MGPMZxP3nrt9pzbvsKGF0ESYiU7Do/5RXM2jt+E+2Rq/+hYXmR3WJfctu
         paBGsHOfW1pS2JW/Fvs+HB4ykFOJ5IWINx9CYlcbKEYD2xGy3e19FBT6XIvPJP/lqDw/
         dp8SCQzzT4xXxZ1/O1MJZa0kzszCNjBi1zWcyUhnYS0iGPdrTIWCuXrhkKmvHO/1RE3Z
         zOxPBZZOpRGlJfG7qEPIOweOfs/wkDthNFv6gC5zUxZg3Euf2tm1+l0udGaGphGmuoeL
         KMahhZtgQakXwW2Heam27xdjTZ/Uxpoy5U8aPVs99uSflPfANlDYSvECAMH5XRQTnWT+
         vgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FxyA7dRkxBEiA6ABsejXOaJjVnfAPVgsqCFDw63Vww=;
        b=oIQQEG1fnJMDlLm3H8tAWo0r4k0VimFy07rVb7JKmzYWfsbsZyPET38Wfkqfm1rPs5
         S3pIFsvAkurdDvxNZpjaJrYLKgkX80zMQ+gVKAWeVDj9GKaNKGForBSnpCEgV4IllCRH
         3ayrDUkLZTSF6YoCWTFlnPDMl4tEtTd7Dnc3UgmsCGj5ew47TUcDnUsAOPc3vzt7odYR
         IRZg1SZw94lOcw+YFC+Ik3ZbRqzziCGrdyOXGGNnFI71K5Rp360TfFbH3scNgXPTs1BV
         HsY4VSconUN2C/84XGwBm3Qgg3D/hJ1r/91z5rj4KwAKcsOq57vGOHF/H2giUCnygUh6
         NXMg==
X-Gm-Message-State: ANoB5pl1p0hef8FXVz17WCyRP6WeuapABpTUHn8xgb7de8LltDrmcx1u
        PA5KzrgK/oZyI31+C+LFfAw=
X-Google-Smtp-Source: AA0mqf5PRBO/SVeCnQCwec3v9rkM7eGcNMfYFagDRFkAM0l70GiIOIg3rfAq+KWjVDvsVd8GkDWoOA==
X-Received: by 2002:a05:6402:5508:b0:462:2e05:30ce with SMTP id fi8-20020a056402550800b004622e0530cemr5016565edb.42.1670598397120;
        Fri, 09 Dec 2022 07:06:37 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id z2-20020aa7d402000000b0046182b3ad46sm737298edq.20.2022.12.09.07.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:06:36 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:06:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 07/13] net: dsa: microchip: ptp: add packet
 reception timestamping
Message-ID: <20221209150634.gb3mdxphq3dt3kfi@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:31PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> Rx Timestamping is done through 4 additional bytes in tail tag.
> Whenever the ptp packet is received, the 4 byte hardware time stamped
> value is added before 1 byte tail tag. Also, bit 7 in tail tag indicates
> it as PTP frame. This 4 byte value is extracted from the tail tag and
> reconstructed to absolute time and assigned to skb hwtstamp.
> If the packet received in PDelay_Resp, then partial ingress timestamp
> is subtracted from the correction field. Since user space tools expects
> to be done in hardware.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +bool ksz_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
> +		       unsigned int type)
> +{
> +	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
> +	struct ksz_device *dev = ds->priv;
> +	struct ptp_header *ptp_hdr;
> +	u8 ptp_msg_type;
> +	ktime_t tstamp;
> +	s64 correction;
> +
> +	tstamp = KSZ_SKB_CB(skb)->tstamp;
> +	memset(hwtstamps, 0, sizeof(*hwtstamps));
> +	hwtstamps->hwtstamp = ksz_tstamp_reconstruct(dev, tstamp);
> +
> +	ptp_hdr = ptp_parse_header(skb, type);
> +	if (!ptp_hdr)
> +		goto out;
> +
> +	ptp_msg_type = ptp_get_msgtype(ptp_hdr, type);
> +	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
> +		goto out;
> +
> +	/* Only subtract the partial time stamp from the correction field.  When
> +	 * the hardware adds the egress time stamp to the correction field of
> +	 * the PDelay_Resp message on tx, also only the partial time stamp will
> +	 * be added.
> +	 */
> +	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
> +	correction -= ktime_to_ns(tstamp) << 16;
> +
> +	ptp_header_update_correction(skb, type, ptp_hdr, correction);
> +
> +out:
> +	return 0;

Nitpick: port_rxtstamp() returns "bool" as in "should reception of this
packet be deferred until the full RX timestamp is available?". The
answer of 0 is coincidentally correct, but should have been "false".

> +}
> +
>  static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
>  {
>  	u32 nanoseconds;
