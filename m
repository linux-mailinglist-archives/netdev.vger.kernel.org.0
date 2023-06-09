Return-Path: <netdev+bounces-9573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6ABB729D8F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E684528194F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48794182D2;
	Fri,  9 Jun 2023 14:57:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D237256D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:57:59 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFB83C05;
	Fri,  9 Jun 2023 07:57:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5151934a4e3so2848580a12.1;
        Fri, 09 Jun 2023 07:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686322650; x=1688914650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AQ5NbJ/8HyFfA/fHfyveGzqPx6mqtSR2v+z5Mms+B/8=;
        b=RPX3vATLDyoZQgmI5/Wl2Um3DE0YU8PV9sMGrLgMDzXJbHnwx0J8A+HoQW19jCgWF6
         WAALIrhAXxY83Zvu5gdBlztWuQbUcwFRGmWBZdvzS28CssXk5M6DKb5T0yFn1578aUym
         zVf3D24eqTl4lHy+vefS5MmiTZnqZz9w7hinhz+HNQSePGptyMULqTOLcYCgerrDt+Zp
         mnMlE0jEH3jX2erfWpFRYqL0Gk7uJ2UtpyDQ80uOdrw7944IaupgCvukxBWyvU0Bh8UE
         8+9CC17Mdtx+nLQR7zur2M0KcGEvLRSCGrxZrHIs1AfT4Hu6PuWWKixxM4AYKoOzWjB5
         XD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686322650; x=1688914650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQ5NbJ/8HyFfA/fHfyveGzqPx6mqtSR2v+z5Mms+B/8=;
        b=XSJ38bXCR6etDliWRhTGby0Tc6G754WATd6pHLrdjuSWP39sMitnEOnEIELtxN1Ej5
         6JUrhPsnpL7Wu/CBmF6UD+0PVAz3ZzDxY6kF0z1w9552OP18GizECZaVphA8q+aoUeTb
         lo41LvKxWL6N9TN1Q8lAFJaO6ZvpdPWqayKGjQzDE/FTRWFJ2MAsoIM+awUmGRF6qiUZ
         YX8XjHaTb7CKKx7ZNah7qHKrgxC9L+Z40XaYHIaz9qWevkjl7p/6bKA4tb3I+n3qA5hG
         NafKpFTB54tzYIGB0WLsxyyLKsGcCT952taTnJcds51e52dsfB2f8GlKbZJddxzkOojv
         aVRA==
X-Gm-Message-State: AC+VfDyuSG8gpO3xloDZBvuEUOOdND1Cd21SVg0IEhFAsGDeU3GtE+Cv
	DOFoL7Hjz7i+LT7PMr3XoXsBO1OWR7mXtA==
X-Google-Smtp-Source: ACHHUZ7fqVz8JnmQwDp7D6ADrxADJviSks1ga/x0rOv8oJm6yM4W+s4VgMzX/9EzQ0lsOKCR/OYOdw==
X-Received: by 2002:a05:6402:31e6:b0:50b:c77e:b071 with SMTP id dy6-20020a05640231e600b0050bc77eb071mr1257564edb.18.1686322650296;
        Fri, 09 Jun 2023 07:57:30 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id a12-20020aa7cf0c000000b00514b8d5eb29sm1865730edy.43.2023.06.09.07.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 07:57:29 -0700 (PDT)
Date: Fri, 9 Jun 2023 17:57:27 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: alexis.lothore@bootlin.com
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Message-ID: <20230609145727.qt6qvyoheepstpz7@skbuf>
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 04:18:12PM +0200, alexis.lothore@bootlin.com wrote:
> +int mv88e6393x_tbf_add(struct mv88e6xxx_chip *chip, int port,
> +		       struct tc_tbf_qopt_offload_replace_params *replace_params)
> +{
> +	int rate_kbps = DIV_ROUND_UP(replace_params->rate.rate_bytes_ps * 8, 1000);
> +	int overhead = DIV_ROUND_UP(replace_params->rate.overhead, 4);
> +	int rate_step, decrement_rate, err;
> +	u16 val;
> +
> +	if (rate_kbps < MV88E6393X_PORT_EGRESS_RATE_MIN_KBPS ||
> +	    rate_kbps >= MV88E6393X_PORT_EGRESS_RATE_MAX_KBPS)
> +		return -EOPNOTSUPP;
> +
> +	if (replace_params->rate.overhead > MV88E6393X_PORT_EGRESS_MAX_OVERHEAD)
> +		return -EOPNOTSUPP;

How does tbf react to the driver returning -EOPNOTSUPP? I see tbf_offload_change()
returns void and doesn't check the ndo_setup_tc() return code.

Should we resolve that so that the error code is propagated to the user?

Also, it would be nice to extend struct tc_tbf_qopt_offload with a
netlink extack, for the driver to state exactly the reason for the
offload failure.

Not sure if EOPNOTSUPP is the return code to use here for range checks,
rather than ERANGE.

> +
> +	/* Switch supports only max rate configuration. There is no
> +	 * configurable burst/max size nor latency.
> +	 * Formula defining registers value is:
> +	 * EgressRate = 8 * EgressDec / (16ns * desired Rate)
> +	 * EgressRate is a set of fixed values depending of targeted range
> +	 */
> +	if (rate_kbps < MBPS_TO_KBPS(1)) {
> +		decrement_rate = rate_kbps / 64;
> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS;
> +	} else if (rate_kbps < MBPS_TO_KBPS(100)) {
> +		decrement_rate = rate_kbps / MBPS_TO_KBPS(1);
> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS;
> +	} else if (rate_kbps < GBPS_TO_KBPS(1)) {
> +		decrement_rate = rate_kbps / MBPS_TO_KBPS(10);
> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS;
> +	} else {
> +		decrement_rate = rate_kbps / MBPS_TO_KBPS(100);
> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS;
> +	}
> +
> +	dev_dbg(chip->dev, "p%d: adding egress tbf qdisc with %dkbps rate",
> +		port, rate_kbps);
> +	val = decrement_rate;
> +	val |= (overhead << MV88E6XXX_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT);
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
> +				   val);
> +	if (err)
> +		return err;
> +
> +	val = rate_step;
> +	/* Configure mode to bits per second mode, on layer 1 */
> +	val |= MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L1_BYTES;
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
> +				   val);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +int mv88e6393x_tbf_del(struct mv88e6xxx_chip *chip, int port)
> +{
> +	int err;
> +
> +	dev_dbg(chip->dev, "p%d: removing tbf qdisc", port);
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
> +				   0x0000);
> +	if (err)
> +		return err;
> +	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
> +				    0x0001);

I guess this should return void and proceed on errors, rather than exit early.
Maybe shout out loud that things went wrong.

> +}
> +
> +static int mv88e6393x_tc_setup_qdisc_tbf(struct mv88e6xxx_chip *chip, int port,
> +					 struct tc_tbf_qopt_offload *qopt)
> +{
> +	/* Device only supports per-port egress rate limiting */
> +	if (qopt->parent != TC_H_ROOT)
> +		return -EOPNOTSUPP;
> +
> +	switch (qopt->command) {
> +	case TC_TBF_REPLACE:
> +		return mv88e6393x_tbf_add(chip, port, &qopt->replace_params);
> +	case TC_TBF_DESTROY:
> +		return mv88e6393x_tbf_del(chip, port);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}

