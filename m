Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE45633F0D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiKVOgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiKVOgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:36:53 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6456AEDF;
        Tue, 22 Nov 2022 06:36:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id v3so14242148pgh.4;
        Tue, 22 Nov 2022 06:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cGYcCov0QWV5/pmhkif2gKEvza2fhvaSDbV2ibX4Xxw=;
        b=Yf/ae+WaB92/B2oW8rm2PNHW6u9yZmCnp2vaAeSvyORkUotOZC7a9rzYn2g15nPKFm
         1IvR0SmzSB5OPJVMfA8lmj5D13+twLYQhrHV7vzXas8ToriqWOZPAiaUOq0fh8HAqnr+
         eGRiNs0pQO2JRvVgpdpfub9Y6HLaVXRZRipn6wdIDXtIkWL9VrhYF8t1HO/CAI2CusMO
         8gRG6y/YGxknGHxakQ4mjbmBSTsFzlXL2QSnIsplcepOWOD/ehMoHAbQysIqgDhnD6CQ
         xtjWXM4j4pAkxNKRGHzS0nFGIwf+zMRXYdkXJhCfYQ3qR21gdwC9bz8b0MuFEe1KgCzm
         pkVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cGYcCov0QWV5/pmhkif2gKEvza2fhvaSDbV2ibX4Xxw=;
        b=n3szhxRUnNMyTaQzJ7gfDSdQTtITF1/9/KZoOTfEftUn0NRFD8Znb1Gw0CvxZfaJTw
         V4iiwwUuWiN6pDWS4twidjKVqVhusqa86H4e1y7GZdRqplnSMp5t+nl9TduSisS7aCb5
         Adtg6tA9s6wAU/KI+d0kgHk7dEtG9aS9ucZMkoiCZyDbBNWox8JnpQ6hSKIv+Mq8bh/u
         1FXlfTjwBcs12d4Pj5FlvqIGVtcpW1wAaw3UrIRH/WxgAqbjo7a5Hy+k8CxztxwwXk+Q
         D5BWbIHbgBa8c0AmavAHHWFDqUV82WwgFyIYVhiWxqllXc+m1G6sX74Ose1WsETzqL5q
         acPw==
X-Gm-Message-State: ANoB5pmjzQIUJa5992gOBbFjnVxG/0JVQb6q5/cb2odxybh9VICI6r88
        AwK9vfZT/84iEq4AH7Q34vM=
X-Google-Smtp-Source: AA0mqf5l9HCqHENR6evGA1AnfNBF1AM3N9DlC0n3BMJQekcNUwT6iTfAm7BtDYfJxu7GuaKzaMTlig==
X-Received: by 2002:a63:d712:0:b0:470:4522:f317 with SMTP id d18-20020a63d712000000b004704522f317mr11984330pgg.129.1669127812542;
        Tue, 22 Nov 2022 06:36:52 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d40c00b00188fadb71ecsm10519251ple.16.2022.11.22.06.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:36:51 -0800 (PST)
Date:   Tue, 22 Nov 2022 06:36:49 -0800
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
Message-ID: <Y3zegX68J7Mfbrbr@hoboy.vegasvil.org>
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

> +static int ksz_ptp_enable_perout(struct ksz_device *dev,
> +				 struct ptp_perout_request const *perout_request,
> +				 int on)
> +{
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +	u64 cycle_width_ns;
> +	u64 pulse_width_ns;
> +	int ret;
> +
> +	if (perout_request->flags & ~KSZ_PEROUT_VALID_FLAGS)
> +		return -EINVAL;
> +
> +	if (ptp_data->tou_mode != KSZ_PTP_TOU_PEROUT &&
> +	    ptp_data->tou_mode != KSZ_PTP_TOU_IDLE)
> +		return -EBUSY;
> +
> +	ret = ksz_ptp_tou_reset(dev, KSZ_PER_OUT_TOU);
> +	if (ret)
> +		return ret;
> +
> +	if (!on) {
> +		ptp_data->tou_mode = KSZ_PTP_TOU_IDLE;
> +		return 0;  /* success */
> +	}
> +
> +	ptp_data->perout_target_time_first.tv_sec  = perout_request->start.sec;
> +	ptp_data->perout_target_time_first.tv_nsec = perout_request->start.nsec;
> +
> +	ptp_data->perout_period.tv_sec = perout_request->period.sec;
> +	ptp_data->perout_period.tv_nsec = perout_request->period.nsec;
> +
> +	cycle_width_ns = timespec64_to_ns(&ptp_data->perout_period);
> +	if ((cycle_width_ns & TRIG_CYCLE_WIDTH_M) != cycle_width_ns)
> +		return -EINVAL;
> +
> +	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE)
> +		pulse_width_ns = perout_request->on.sec * NSEC_PER_SEC +
> +			perout_request->on.nsec;
> +
> +	else
> +		/* Use a duty cycle of 50%. Maximum pulse width supported by the
> +		 * hardware is a little bit more than 125 ms.
> +		 */
> +		pulse_width_ns = min_t(u64,
> +				       (perout_request->period.sec * NSEC_PER_SEC
> +					+ perout_request->period.nsec) / 2
> +				       / 8 * 8,
> +				       125000000LL);

CodyStyle nit: if/else bodies need {} because of two lines in 'else'.

Thanks,
Richard


> +
> +	ret = ksz_ptp_tou_pulse_verify(pulse_width_ns);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz_ptp_configure_perout(dev, cycle_width_ns,
> +				       pulse_width_ns,
> +				       &ptp_data->perout_target_time_first);
> +	if (ret)
> +		return ret;
> +
> +	/* Activate trigger unit */
> +	ret = ksz9477_ptp_tou_start(dev);
> +	if (ret)
> +		return ret;
> +
> +	ptp_data->tou_mode = KSZ_PTP_TOU_PEROUT;
> +
> +	return 0;
> +}
