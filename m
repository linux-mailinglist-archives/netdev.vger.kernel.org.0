Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7039633F15
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiKVOjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiKVOi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:38:59 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7DC2B1AD;
        Tue, 22 Nov 2022 06:38:57 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y4so13845647plb.2;
        Tue, 22 Nov 2022 06:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tVuwP251JI0J9486LpQEsG/geG2FeNl8X2kV1b5W5q0=;
        b=ddV5BJEYTQfeA1K7pTcwqvps5E2lAEF1MY7CMMCf1ejnNpQWCbZlJ++FKQUlmbI+xV
         cRGcPkXO2EH/iwlqua7vAj8zXTR9y6rtKmKUEgGbyPvtvJIVkQp7QZ9z6XVvLnnaY2tP
         3Y79Aqu6/Ai3bkQ8BG0d7Xi5WufwJeWiuyAac1+eD1A1IXQ2rhKh7mR+gBo77/1J99g6
         3PKyucoa/2xCw6YQFKbsYLpBpw9LoaI8W2NpCGxQB2XDkDrgmDCjUmLbTCZ8vUGPpAy2
         NsOr1iKZ+0kHeZi8Pg1kz17bZkLkanZhXRiFx6qrBWOC73hwT715IT8da8oKW90adQj6
         3ZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVuwP251JI0J9486LpQEsG/geG2FeNl8X2kV1b5W5q0=;
        b=D9XJA+EccubnPrpcrTBLolZdp3cHQXM1XENaSSCAzp8tJfJUadKLU6O0YmL4k7l1kK
         +xmIeFUhA7nqlzzNxEIPIhQC11HPheuZSDaL9pg27+oYNnmc6TW8en2yqnCZ6K8APwVr
         bGtStcYqJZLdTM2GMMwiDnC4AikJX6BlmRbLXt4VPHfLeyfoowt6D0xDVIvqwNEuIEc8
         vDDOVbOZUKrZ8C5xM9wSCkOPDl+hHbbfBm4FAi1ewd+JKMMgp5VNHCzEBvTI8AiYQO02
         UWB7P1CmwXxLW1WsybDWHtorWabHfM55Lq/ZlSyZZjhTKs3jRt56iR+xyhbeoBHWcJup
         c6Uw==
X-Gm-Message-State: ANoB5pkQmusPneSU2zoZ7kwhllxy9pH1OKaDrIUBgJzkKjSqPDfEEX2J
        GaheRMItj3B8awJL+QDCmHU=
X-Google-Smtp-Source: AA0mqf44OKSH/IJzzcyXFVYdPLL0givZmbapdvwxCwpoGgBie66zH/Mfystxx8NutxYWYOepnzuWMw==
X-Received: by 2002:a17:90a:c095:b0:212:e766:f3e4 with SMTP id o21-20020a17090ac09500b00212e766f3e4mr25192156pjs.213.1669127936797;
        Tue, 22 Nov 2022 06:38:56 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id az23-20020a17090b029700b00218b32f6a9esm3985479pjb.18.2022.11.22.06.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:38:56 -0800 (PST)
Date:   Tue, 22 Nov 2022 06:38:53 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com
Subject: Re: [RFC Patch net-next v2 8/8] net: dsa: microchip: ptp: add
 periodic output signal
Message-ID: <Y3ze/S7qOCswSnv1@hoboy.vegasvil.org>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-9-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-9-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:11:50PM +0530, Arun Ramadoss wrote:

> +static int ksz_ptp_restart_perout(struct ksz_device *dev)
> +{
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +	s64 now_ns, first_ns, period_ns, next_ns;
> +	struct timespec64 now;
> +	unsigned int count;
> +	int ret;
> +
> +	ret = _ksz_ptp_gettime(dev, &now);
> +	if (ret)
> +		return ret;
> +
> +	now_ns = timespec64_to_ns(&now);
> +	first_ns = timespec64_to_ns(&ptp_data->perout_target_time_first);
> +
> +	/* Calculate next perout event based on start time and period */
> +	period_ns = timespec64_to_ns(&ptp_data->perout_period);
> +
> +	if (first_ns < now_ns) {
> +		count = div_u64(now_ns - first_ns, period_ns);
> +		next_ns = first_ns + count * period_ns;
> +	} else {
> +		next_ns = first_ns;
> +	}
> +
> +	/* Ensure 100 ms guard time prior next event */
> +	while (next_ns < now_ns + 100000000)
> +		next_ns += period_ns;
> +
> +	/* Restart periodic output signal */
> +	{

CodingStyle: avoid anonymous blocks.  Move to helper function instead?

Thanks,
Richard


> +		struct timespec64 next = ns_to_timespec64(next_ns);
> +		struct ptp_perout_request perout_request = {
> +			.start = {
> +				.sec  = next.tv_sec,
> +				.nsec = next.tv_nsec
> +			},
> +			.period = {
> +				.sec  = ptp_data->perout_period.tv_sec,
> +				.nsec = ptp_data->perout_period.tv_nsec
> +			},
> +			.index = 0,
> +			.flags = 0,  /* keep current values */
> +		};
> +		ret = ksz_ptp_enable_perout(dev, &perout_request, 1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
