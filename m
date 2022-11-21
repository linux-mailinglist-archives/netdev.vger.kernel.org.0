Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE9632EDF
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiKUVdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiKUVdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:33:10 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF9F10B5F;
        Mon, 21 Nov 2022 13:33:08 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id gv23so31526839ejb.3;
        Mon, 21 Nov 2022 13:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MrnT+eSbey2CG+aPSBBnxrMG7unNpVOnktkqfmkzqVU=;
        b=n6ChiPX/0X6KmY7+2o4+fswG5u7ei9vyDif1QYvCokDRZtasfbHHoM1gqpfPC1kNns
         aw1mNKF3DlH/d+46jwy7UVuURA/jwPqAv6+siGb+IAFnL1jMOiV0dlbnH94tpdyYcUhq
         IAqz6alY2BEUzJbBeIhxt9br1EZ5o3Ol30/8dBh1H96brOgmV7noZ4Nnc8izd1zMzOQq
         NOBKdUmTKsO/KrzrjeuP+OOtCbE3GaEyGmS64OrQyiC0NRcX28WONs89jJkk8kApqJC0
         YYJG3xma3lsIFG2+tyQbXB6xwl/L1Dy1lS5nuIXcmPenWMA71Fd5+10ORiM1+eBY9IRC
         G6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrnT+eSbey2CG+aPSBBnxrMG7unNpVOnktkqfmkzqVU=;
        b=6zlQ2kVvWzhWVeazc8vecX/OjN+k90Erz2Sa+ocPSNTSFL0rxpF/onN38nCBG9Pg9Z
         4s73P3dpaiU7e+OCUVSZ1d7THRyiRn7XuNUY7ITHlc1TNvFAp5wj/TwvmAHE2OvezKG1
         sJoqxno+TlY1b6KhwDz7EhyEnnf2HRd3jAiT48vUelg3XTlwoSbao9mY+DjVs/vtyVOa
         zbRS7i93ZSGy2L0SyAdY2Xl/laqoKMkPjQAgJvkefeY3v5ZHOIGVYs5vju6cr83Rkbz9
         ofawEy7OVidNPoQM/OliXRihBVoYqEVqjo0cyw1l0IuMHV3zfTseOQW7pRVjfbwWqlc0
         r+VA==
X-Gm-Message-State: ANoB5pmJoqBs2v0CncftXkN0DFDEGXwdoElLi7UjU1PSnN+wt12EYRd6
        h8X3V6bxh+laM6+0EPRu1Y8=
X-Google-Smtp-Source: AA0mqf6vCReIQ8RGXycSP2jzKhKbxAj0ZLfxQq5d8yLVtjj3HJWldO6lB73MNpWQrMUvgv3McGlJJQ==
X-Received: by 2002:a17:906:b0cd:b0:78d:8c6b:397b with SMTP id bk13-20020a170906b0cd00b0078d8c6b397bmr4210221ejb.364.1669066387317;
        Mon, 21 Nov 2022 13:33:07 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id cn16-20020a0564020cb000b0045c010d0584sm5644221edb.47.2022.11.21.13.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 13:33:06 -0800 (PST)
Date:   Mon, 21 Nov 2022 23:33:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [RFC Patch net-next v2 2/8] net: dsa: microchip: adding the
 posix clock support
Message-ID: <20221121213304.vytvbfvikuwcw3oi@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-3-arun.ramadoss@microchip.com>
 <20221121154150.9573-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-3-arun.ramadoss@microchip.com>
 <20221121154150.9573-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:11:44PM +0530, Arun Ramadoss wrote:
> +int ksz_ptp_clock_register(struct dsa_switch *ds)
> +{
> +	/* Register the PTP Clock */
> +	ptp_data->clock = ptp_clock_register(&ptp_data->caps, dev->dev);
> +	if (IS_ERR_OR_NULL(ptp_data->clock))
> +		return PTR_ERR(ptp_data->clock);
> +}
> +
> +void ksz_ptp_clock_unregister(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +
> +	if (IS_ERR_OR_NULL(ptp_data->clock))
> +		return;
> +
> +	ptp_clock_unregister(ptp_data->clock);
> +}

API usage seems to be incorrect here (probably copied from sja1105 which
is written by me and also incorrect, yay).

The intention with IS_ERR_OR_NULL() is for the caller to return 0
(success) when ptp_clock_register() returns NULL (when PTP support
is compiled out), and this will not make the driver fail to probe.

There isn't a reason to use IS_ERR_OR_NULL() in the normal unregister
code path, because the code won't get there in the IS_ERR() case.
So a simple "if (ptp_data->clock) ptp_clock_unregister(ptp_data->clock)"
would do.
