Return-Path: <netdev+bounces-8992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36DE47267BB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E769A28143B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F85638CBE;
	Wed,  7 Jun 2023 17:47:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDAC1772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:47:21 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD7310CA;
	Wed,  7 Jun 2023 10:47:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6621a7efe18so173990b3a.1;
        Wed, 07 Jun 2023 10:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686160039; x=1688752039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Of8fDCbAzKBU0E3fdobtakbNXasluc37nuXH5F34jmk=;
        b=NKvomtQLfXx26DVNv0Tlz0YGU3B4EDx4lo9lyheksqm0WK8JAZG12YHocpKNGJDqU8
         JMMGXjb9U4q6lqEDN0zA/N3hmTliS22jz7RAsrNZTE7qGPsVyqCIjSxmhHwy8FgGK7pE
         KKpWqW+QVintGhddzYANBXQHhv+CYQZq/5yPDa/fR0eHaaSGyuYWNIvkjoZg4B/vXL4h
         cW0aYFOQphjgvBmOPkZR11UTOhWKnytQfoXM9c0paVAdZ9MkMK9XQxCb5pCtwsTrR28a
         rOnXGzGjY1Kb3Zlx8gj8Dk/FWl+opDaL68AKJ57QiuEB9h4QQmJd37H4KNH14cVYgObk
         25Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686160039; x=1688752039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Of8fDCbAzKBU0E3fdobtakbNXasluc37nuXH5F34jmk=;
        b=BxEaLLzL9EfJj08u0ATX+c+Wbs8Ay23z3bFAHJx8jhzgWe7fkcw1TsbiJjAet/c5gC
         sjqnhWYu/yffVjXYhQL7RaxaNPH9dL1ocQG5horIKrhvjrRqhZKPntj35ycUltxJTbLG
         M1r7s/l/odd8GXF8CTxru0PYRw2m38ki5eyU6cPYQlieTyMO9qoF/sJsXPI7my+Qcpqy
         n0cKKb1jI4BM2RzVMqhXcST5AumRIvhQkTfhLW25eRDAR3Qhgz41UgIq0rN1Aej1tzXH
         aYf4dgp2+ndvszH8pevM5IDlFQYtTMxMvJ9z8bEPNAUaugML/RaBJp4C0LbLLsH40uV3
         Q/Lg==
X-Gm-Message-State: AC+VfDwT212JbHgP5bD+9cbdDGyI/aVY/POuVu57oEVvax+KPeQqPQ4L
	VUiHF/oLvHDDIxjwAU6nJ64=
X-Google-Smtp-Source: ACHHUZ7mh0cTvL7KvDRqsg+seMhXvGeWEE219xToJY6WKwhkwcyHDYxaVIgGdGmy4xfELN/mpooRYw==
X-Received: by 2002:a05:6a20:72a7:b0:10b:e7d2:9066 with SMTP id o39-20020a056a2072a700b0010be7d29066mr3109250pzk.2.1686160039013;
        Wed, 07 Jun 2023 10:47:19 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b38-20020a631b66000000b0051eff0a70d7sm9148638pgm.94.2023.06.07.10.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:47:18 -0700 (PDT)
Date: Wed, 7 Jun 2023 10:47:16 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: micrel: Change to receive timestamp in the
 frame for lan8841
Message-ID: <ZIDCpPbCFCxKBV2k@hoboy.vegasvil.org>
References: <20230607070948.1746768-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607070948.1746768-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:09:48AM +0200, Horatiu Vultur wrote:

> Doing these changes to start to get the received timestamp in the
> reserved field of the header, will give a great CPU usage performance.
> Running ptp4l with logSyncInterval of -9 will give a ~50% CPU
> improvment.

Really?

> -static struct lan8814_ptp_rx_ts *lan8841_ptp_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
> -{
> -	struct phy_device *phydev = ptp_priv->phydev;
> -	struct lan8814_ptp_rx_ts *rx_ts;
> -	u32 sec, nsec;
> -	u16 seq;
> -
> -	nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_HI);
> -	if (!(nsec & LAN8841_PTP_RX_INGRESS_NSEC_HI_VALID))
> -		return NULL;
> -
> -	nsec = ((nsec & 0x3fff) << 16);
> -	nsec = nsec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_LO);
> -
> -	sec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_HI);
> -	sec = sec << 16;
> -	sec = sec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_LO);
> -
> -	seq = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_MSG_HEADER2);

Before: 5x phy_read_mmd() per frame ...

> -	rx_ts = kzalloc(sizeof(*rx_ts), GFP_KERNEL);
> -	if (!rx_ts)
> -		return NULL;
> -
> -	rx_ts->seconds = sec;
> -	rx_ts->nsec = nsec;
> -	rx_ts->seq_id = seq;
> -
> -	return rx_ts;
> -}

> +static void lan8841_ptp_getseconds(struct ptp_clock_info *ptp,
> +				   struct timespec64 *ts)
> +{
> +	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> +							ptp_clock_info);
> +	struct phy_device *phydev = ptp_priv->phydev;
> +	time64_t s;
> +
> +	mutex_lock(&ptp_priv->ptp_lock);
> +	/* Issue the command to read the LTC */
> +	phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
> +		      LAN8841_PTP_CMD_CTL_PTP_LTC_READ);
> +
> +	/* Read the LTC */
> +	s = phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_HI);
> +	s <<= 16;
> +	s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_MID);
> +	s <<= 16;
> +	s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_LO);

After: 4x phy_read_mmd() per frame.  How does that save 50% cpu?

> +	mutex_unlock(&ptp_priv->ptp_lock);
> +
> +	set_normalized_timespec64(ts, s, 0);
> +}


> +static long lan8841_ptp_do_aux_work(struct ptp_clock_info *ptp)
> +{
> +	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> +							ptp_clock_info);
> +	struct skb_shared_hwtstamps *shhwtstamps;
> +	struct timespec64 ts;
> +	struct sk_buff *skb;
> +	u32 ts_header;
> +
> +	while ((skb = skb_dequeue(&ptp_priv->rx_queue)) != NULL) {
> +		lan8841_ptp_getseconds(ptp, &ts);

No need to call this once per frame.  It would be sufficent to call it
once every 2 seconds and cache the result.

> +		ts_header = __be32_to_cpu(LAN8841_SKB_CB(skb)->header->reserved2);
> +
> +		shhwtstamps = skb_hwtstamps(skb);
> +		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> +
> +		/* Check for any wrap arounds for the second part */
> +		if ((ts.tv_sec & GENMASK(1, 0)) < ts_header >> 30)
> +			ts.tv_sec -= GENMASK(1, 0) + 1;
> +
> +		shhwtstamps->hwtstamp =
> +			ktime_set((ts.tv_sec & ~(GENMASK(1, 0))) | ts_header >> 30,
> +				  ts_header & GENMASK(29, 0));
> +		LAN8841_SKB_CB(skb)->header->reserved2 = 0;
> +
> +		netif_rx(skb);
> +	}
> +
> +	return -1;
> +}

Thanks,
Richard

