Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0900750D2A6
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiDXPMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiDXPMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:12:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21BE66F9E;
        Sun, 24 Apr 2022 08:09:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j8so21587553pll.11;
        Sun, 24 Apr 2022 08:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zx+YaIWJey4qzWLJKHpX/8eOZNZqHoxAIr2LpwgG1oI=;
        b=HhLSNzrntAkIJsbkeLJX1axnBynXa/65EKVtiiPG3OTpRFtGTY6JuKYM0zZ3vvfCBU
         RDlSqOhkO//MsibbAJeiWs3yE7x87TYQ0etBqLO9gD+yuk/bm6Pr4ygJidzPk96veBZf
         O7daXyq6RFvuIjPSsoqcXYrTqEJ2EPX+VvgCYl82uK2X+ZEiNBkGHxx5GWPfQyEpQA/3
         fug9YV3FWKx2+I8p4sOGf4wtGu8bqTgUjFuxiKI/ptKAl347VEcig9SdJ+lS8EjGX9ap
         R9ru4MrPUGLJIGMa1aZDahFU+dIHSf6x3k00yUd/ZfQUk/MUkyjO7ul59tt5itjSglHR
         P1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zx+YaIWJey4qzWLJKHpX/8eOZNZqHoxAIr2LpwgG1oI=;
        b=Z+42264eGnyXaFoJO+1bijug32qAqWydAJfKKvsqrg+2ibfUy/Jlr+va0qlJLrzLYl
         eArsR6BsWuBk0dIMaaYNiTBsV0rVD6IPWVlQreFq1k6Am3BhZF8qG/+70KP33vk/Z6Kw
         hmIsC7Ar0hdZqrE4Tf+m0iQ/sB4R88x7qKTji0xvoOr4ejhGxDIYOvqrn+Ml2Lh2ncAc
         O8/BvIPJUpBFwVz3NkH6L8+L0rOnLxpueNtyws/eZW5LJ3e9b8W3j2xOC+dGXry7nQMs
         tTZmOEgTKt3ZK+JGnVObOdyk61erneeE9ZzEgTc0VPtb3bM2uIxFE2OFjiY7fUmrGf8a
         QZqg==
X-Gm-Message-State: AOAM533wNzQazEBheZQU9MD3JKf/UH8yhRd8dk5GqrZ2insD0IEPTwXE
        STANntHpSju92dmcipFeeL23vucDepM=
X-Google-Smtp-Source: ABdhPJzFGGBCFpxapSXUNHoP4G5tCoGTm2UyFllGwbA9dCszVILsFulse0PeoGl54W7MuZ5CAuRDCA==
X-Received: by 2002:a17:902:a585:b0:14d:58ef:65 with SMTP id az5-20020a170902a58500b0014d58ef0065mr13834388plb.139.1650812952455;
        Sun, 24 Apr 2022 08:09:12 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm9382792pfh.143.2022.04.24.08.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 08:09:11 -0700 (PDT)
Date:   Sun, 24 Apr 2022 08:09:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 5/5] net: lan966x: Add support for PTP_PF_EXTTS
Message-ID: <20220424150909.GA29569@hoboy.vegasvil.org>
References: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
 <20220424145824.2931449-6-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424145824.2931449-6-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 04:58:24PM +0200, Horatiu Vultur wrote:

> @@ -321,6 +321,63 @@ irqreturn_t lan966x_ptp_irq_handler(int irq, void *args)
>  	return IRQ_HANDLED;
>  }
>  
> +irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args)
> +{
> +	struct lan966x *lan966x = args;
> +	struct lan966x_phc *phc;
> +	unsigned long flags;
> +	u64 time = 0;
> +	time64_t s;
> +	int pin, i;
> +	s64 ns;
> +
> +	if (!(lan_rd(lan966x, PTP_PIN_INTR)))
> +		return IRQ_NONE;
> +
> +	/* Go through all domains and see which pin generated the interrupt */
> +	for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
> +		struct ptp_clock_event ptp_event = {0};
> +
> +		phc = &lan966x->phc[i];
> +		pin = ptp_find_pin(phc->clock, PTP_PF_EXTTS, 0);

Not safe to call ptp_find_pin() from ISR.  See comment in include/linux/ptp_clock_kernel.h

Thanks,
Richard
