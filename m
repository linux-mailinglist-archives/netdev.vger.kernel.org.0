Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1360AA0
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfGEQrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:47:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41398 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfGEQrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:47:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so4543002pff.8;
        Fri, 05 Jul 2019 09:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UtlLnC5TRAlG4W/Cn5rW/mrY7NUfn+eVWfGDgCrn+NA=;
        b=EebMt4kHNNU4St1gh9pQPrRyjq+dQefGVdIKshWZVxKDgEdSSjoCU10RiNuZpqvx+u
         W5LUAZupTXPHjQQtNl/tGo9zufcf6hq6WIQFhOWKA9iGvWTkqEuqKBgVGscD26m4CPI6
         BBvTl8J9E4IMV5B7iZoQ/21tKk07FcWKlsrVMyFdDiS+3vHQ8pzgcyjpcMhrqWI8t0SK
         kRcyw9KNk5pGBOz48qJur1kjak+sg4mcRS3rrQlfsbBRh/A1YbqL4URCQwVbEVEkP1Kt
         8irPJH+JSx1BTQfWCgejQH4+0ERmYyhu49xTF64FjGuhz25CHlcDvLRrVNvf2XbnMCxj
         5skA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UtlLnC5TRAlG4W/Cn5rW/mrY7NUfn+eVWfGDgCrn+NA=;
        b=XSxcMZfLSQCuSo3B1W1NOgT8NBGtwlKbbUubiNodIMsosGguFvP0+Q7oqYYD+Ih30n
         QIHDqV0CjkiRBofE3XKRlAvQeDMpxXJqVaONtfIwLRqnuw2qwtCTB5sPE2lOU1H/0Eok
         vvNvnqsfxXop4/jd0gvH5Cgd0uvSzHcdnQHq0lH3NPj1dqsySKTfzPFgO+Tkz4oqbU06
         4WMvJRSslRer7xANGhbMFRZ7Vlsh+26eE5YOeQz0bx6Ib4pUwVGeikjzQSVWToxykqz5
         WDX89GazTZuRV2lIDNXF2rfzkoVpRR2sTwgr/f4SDxo0u6cX5zD/sitgt11X92L1ckjE
         Pa+g==
X-Gm-Message-State: APjAAAVK3xlN7j7DVr88MHBqc8BFAH2w3l9vMu9W1BxrInKEL/wAOrDR
        iiLzwBxfw8P1jm0tF/TeW2c=
X-Google-Smtp-Source: APXvYqzzuUnoz+i03eSU2aVxxDunTmUAZtNVengEaVs6Y7I7Wb6EZzQ8Z1/26tcM9ViWUO5VsxFVCA==
X-Received: by 2002:a63:6c7:: with SMTP id 190mr6428633pgg.7.1562345259913;
        Fri, 05 Jul 2019 09:47:39 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id v3sm9053586pfm.188.2019.07.05.09.47.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jul 2019 09:47:39 -0700 (PDT)
Date:   Fri, 5 Jul 2019 09:47:36 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 8/8] net: mscc: PTP Hardware Clock (PHC) support
Message-ID: <20190705164736.x6dy2oc6jo5db65v@localhost>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-9-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701100327.6425-9-antoine.tenart@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:03:27PM +0200, Antoine Tenart wrote:

> +void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts)
> +{
> +	/* Read current PTP time to get seconds */
> +	u32 val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);

This register is protected by ocelot->ptp_clock_lock from other code
paths, but not in this one!

> +	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
> +	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
> +	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
> +	ts->tv_sec = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
	...
> +}


> +static int ocelot_init_timestamp(struct ocelot *ocelot)
> +{
> +	ocelot->ptp_info = ocelot_ptp_clock_info;
> +
> +	ocelot->ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
> +	if (IS_ERR(ocelot->ptp_clock))
> +		return PTR_ERR(ocelot->ptp_clock);

You need to handle the NULL case:

ptp_clock_register() - register a PTP hardware clock driver

@info:   Structure describing the new clock.
@parent: Pointer to the parent device of the new clock.

Returns a valid pointer on success or PTR_ERR on failure.  If PHC
support is missing at the configuration level, this function
returns NULL, and drivers are expected to gracefully handle that
case separately.

> +
> +	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
> +	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
> +	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH);
> +
> +	ocelot_write(ocelot, PTP_CFG_MISC_PTP_EN, PTP_CFG_MISC);
> +
> +	return 0;
> +}

Thanks,
Richard
