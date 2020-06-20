Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC022024A7
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgFTPAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgFTPAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:00:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93223C06174E;
        Sat, 20 Jun 2020 08:00:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b16so5925141pfi.13;
        Sat, 20 Jun 2020 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DDyb+a3mzh7po6nWmFZIl2Ms9xrkB7LHenQj89oU6Mw=;
        b=XZE2NUiD1Ye5NjZRYffV013e2osADlzoRtxaVTgkbMME/gmTaUL3Z+29wasLpN+0Ot
         tqi1Gj+UU3+vdMlPgl3tLTkQCqoHs65TFxGjFhzLVKG9E1tZOdQv7uw+KhmHYUb3jQer
         KhXXkjPnZ9v+0IpLIGVkkiD5mERQD0RIWvAnMFcychz0Rc0JYxr1srpwwuBef5SUyKJk
         LpL1YJYbvYFjtDxWrkIapp3U0sq1m8ADFxo35hCTqt6/xyOENh4Ge/qQUw1xuBD3rwxj
         0hVp9zjkF28/05qjrPggmkk6GJSc158jltORU695KMcTsQYsYvpFnHRz3FZC0pdNlOZh
         OcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DDyb+a3mzh7po6nWmFZIl2Ms9xrkB7LHenQj89oU6Mw=;
        b=HXR6YNDXlN4On+MlMUfVSSmW7wWtAi6yqAfQIhuBmySBqTLWCY/usPNBUM7rkAQjdb
         OPA3rtjlfguXf3wKuZoCLEpWU4/Qw+gw1iklSTxJghbU31Kf/lPEvnDD1Uy7L8RyPRnx
         DIFRme3HoeGawrQBmeVD1iTSLawHdLj3sqbzJ1k1zOJM+A9HGZGUsyAgh0xasBFzllyy
         xu+MiHplVZMh36CEQ7S3YqqvEAA0u8BjZeIvHAQxricQK5+UG7J+iZY3Qb9e8AUIUeox
         GDGgjr+ZKMAV9K6l26iGXvIv8az6/ATJn4PyMX6369K3uM63fYDMxCT0gfXJ6ThfUOdu
         CzmQ==
X-Gm-Message-State: AOAM533RfJb/1hz/Z6Oavmxrm3VDPyswZNU/ujQweV0UoNmQrbBvtXLO
        /YZ0mfDDDCjTvUaBUoDgei4=
X-Google-Smtp-Source: ABdhPJyY6yijmOSY3tbo3eLGhiIZXCTei0YCd9ybr8hNcfFYowMYK88IBEDJP80uQJORnec+jIPH0A==
X-Received: by 2002:a62:7ccb:: with SMTP id x194mr13275278pfc.318.1592665248712;
        Sat, 20 Jun 2020 08:00:48 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k19sm9423331pfg.153.2020.06.20.08.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:00:48 -0700 (PDT)
Date:   Sat, 20 Jun 2020 08:00:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC
 support
Message-ID: <20200620150045.GA2054@localhost>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619122300.2510533-7-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 02:22:58PM +0200, Antoine Tenart wrote:

> +static void vsc85xx_dequeue_skb(struct vsc85xx_ptp *ptp)
> +{
> +	struct skb_shared_hwtstamps shhwtstamps;
> +	struct vsc85xx_ts_fifo fifo;
> +	struct sk_buff *skb;
> +	u8 skb_sig[16], *p;
> +	int i, len;
> +	u32 reg;
> +
> +	memset(&fifo, 0, sizeof(fifo));
> +	p = (u8 *)&fifo;
> +
> +	reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> +				  MSCC_PHY_PTP_EGR_TS_FIFO(0));
> +	if (reg & PTP_EGR_TS_FIFO_EMPTY)
> +		return;
> +
> +	*p++ = reg & 0xff;
> +	*p++ = (reg >> 8) & 0xff;
> +
> +	/* Read the current FIFO item. Reading FIFO6 pops the next one. */
> +	for (i = 1; i < 7; i++) {
> +		reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> +					  MSCC_PHY_PTP_EGR_TS_FIFO(i));
> +		*p++ = reg & 0xff;
> +		*p++ = (reg >> 8) & 0xff;
> +		*p++ = (reg >> 16) & 0xff;
> +		*p++ = (reg >> 24) & 0xff;
> +	}
> +
> +	len = skb_queue_len(&ptp->tx_queue);
> +	if (len < 1)
> +		return;
> +
> +	while (len--) {
> +		skb = __skb_dequeue(&ptp->tx_queue);
> +		if (!skb)
> +			return;
> +
> +		/* Can't get the signature of the packet, won't ever
> +		 * be able to have one so let's dequeue the packet.
> +		 */
> +		if (get_sig(skb, skb_sig) < 0)
> +			continue;

This leaks the skb.

> +		/* Check if we found the signature we were looking for. */
> +		if (!memcmp(skb_sig, fifo.sig, sizeof(fifo.sig))) {
> +			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +			shhwtstamps.hwtstamp = ktime_set(fifo.secs, fifo.ns);
> +			skb_complete_tx_timestamp(skb, &shhwtstamps);
> +
> +			return;
> +		}
> +
> +		/* Valid signature but does not match the one of the
> +		 * packet in the FIFO right now, reschedule it for later
> +		 * packets.
> +		 */
> +		__skb_queue_tail(&ptp->tx_queue, skb);
> +	}
> +}

Thanks,
Richard
