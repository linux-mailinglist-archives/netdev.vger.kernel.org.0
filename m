Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0725E543DF6
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiFHU4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiFHU4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:56:03 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6601203A23
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 13:56:01 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f65so9824125pgc.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 13:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y0RmZAfZMIZ3zlMy1U7qBhVX1OcJ3Ow6drCnObgVndE=;
        b=PnRXenNad9Fxfj+NJYzSr1172LNucsyysTu0xRPlBu1dDjAKNSJmxoB8RiqJbsjBgD
         plEIY/0JiyekS8R5p1VMr2D+dh/vKnmSmSN4DL07UfL1IYQbM/HtPu1S4JPMgOOy7VNA
         iMeLByHSVr7nBVF3qrQ/fB2M8Th9gijS/c7DMlTRZZCYD6EAv0LDNpKwVvnPsxA/6nOr
         A/sHXUL2TkUtP8/Qik2MRbSJKbj91rGNl7asAAS/y+6rWvul5PtrwWX3EFah9tZO/KTS
         9oRh0i5Dppn2XhKEBxrBwQzChrboPP/NxUfBzikeqspDQmaW1wM6+cwADp9PencPmnBu
         eHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y0RmZAfZMIZ3zlMy1U7qBhVX1OcJ3Ow6drCnObgVndE=;
        b=luBCGlCmbMmG00u004fSm6TaGsPlRGWOi2NIrlx/N0WUXED4FEBgYxn40czOGmjrKL
         btbCcQXry2CII+WU/jcGBpxmNlhYYfboSYdIsBdR0XtQaCoGi9VC6tUh9bQJ37uI/MUq
         MMAKeNgWcanq7NFtS78Qhmc4eJ9IGAWRr4QFwBDxGfpz7riYqYFOjE0nYpkXqZoNVu2b
         OaeyQxhofTFvZaniKdTDcoyt23Hl3K8u4O951GCk0HPtvpe09MainuvUVwN3uKQRdp8h
         vbXNUEY5Rc/dVDUc1XRQN1JVG+scB2gTJD2MmSuBk9VssEPGJabzU4ZFm0zj+3KMM3zC
         7llQ==
X-Gm-Message-State: AOAM532p63ASmQr2aQbXjXdM5/HEqzCFoGnpg+rm7KJG51cHs/ISuhih
        xPx+E+s1WVSHDdRfVu2Rbn0=
X-Google-Smtp-Source: ABdhPJwdb05lw2Vgu1iezYKMat79krWzvASmGaung2pWUpCFAIlVCM7Avnlo8LFmF1OVSNGi3QHvkQ==
X-Received: by 2002:a63:210e:0:b0:3fd:9c07:7670 with SMTP id h14-20020a63210e000000b003fd9c077670mr17209236pgh.222.1654721761308;
        Wed, 08 Jun 2022 13:56:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q68-20020a632a47000000b003fcc510d789sm14369192pgq.29.2022.06.08.13.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 13:56:00 -0700 (PDT)
Date:   Wed, 8 Jun 2022 13:55:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220608205558.GB16693@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-3-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608204451.3124320-3-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 01:44:50PM -0700, Jonathan Lemon wrote:
> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> tested on that hardware.

...

> +static const struct ptp_clock_info bcm_ptp_clock_info = {
> +	.owner		= THIS_MODULE,
> +	.name		= KBUILD_MODNAME,
> +	.max_adj	= 100000000,

Does this really work?  See below.

> +	.gettimex64	= bcm_ptp_gettimex,
> +	.settime64	= bcm_ptp_settime,
> +	.adjtime	= bcm_ptp_adjtime,
> +	.adjfine	= bcm_ptp_adjfine,
> +	.do_aux_work	= bcm_ptp_do_aux_work,
> +};

On another phy from the same (?) family (541xx), I found that the
synch becomes unstable when slewing more than:

	port->caps.max_adj	= 62500,

Thanks,
Richard

