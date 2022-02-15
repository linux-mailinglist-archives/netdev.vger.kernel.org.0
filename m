Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25C04B6F32
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiBOOgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:36:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiBOOgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:36:16 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B210240A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:36:05 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id e3so32555557wra.0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MUUf+pXkN05JwdwuQzd9Pvh+Bteaj3c62ygRM6bt9Qk=;
        b=mudgwYtlwGFKHg2+iOKPcYtEENCpxIIfMw819BpddxPUCVCqMHj2+IeOBJM0X4iUpB
         GxtARny1Df2jwq3YqCemRhpibF1+gTiMw17Vuz0eueDZwShUR7fDR/zggpssLn9xYNBq
         qmwZJpwpMUokt7zNMHN46J+C38KBJPlHJMDFItwUmRn5U5LqxKHWe2Npafb0ihV4xtkj
         L+3NqEKaGGzN7pgAtibj2nHTis9XKdKJf6zUacBd0Zu+nAIceQOhrYA9xH0g3wno+CJ9
         iJvrc6sjhbNWiNFpFCIA2K3W2z8zBDgBSMIyKlwYzwwPQWg0KkqaO/xNG5dYbZsPVPPK
         A1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MUUf+pXkN05JwdwuQzd9Pvh+Bteaj3c62ygRM6bt9Qk=;
        b=VSUwAVpUDgoeoFAACiZ6NbYsU6Lh2ixC4QX2OA61vOEDje0eos22W8wtS2oNF2OGuR
         v+/ODhw0W0sk73q6mMcgYWEBL/jjSRq+gpZ9slrA9aiOASuiKiREYP3Ta4+86Y4MFJ8T
         1nGNQacQ+OQMQBy8AN7n+hS76yLUaGXcB+l9BBiv3xVpIGyQ8xCw5sVndOoLWpmWcPhM
         wq/RkIu8clf3Tu0nBOSCya2kjcVCztjNB8QlVJX6O6JV182JLwADh/R/cSleBTfioW1f
         R4p0nNKq2b1wpoTjyqx9LNEUuq9g/Qypy7GE5OFIUJFGfwMWHNAw0bzpFZ0wwdWm/wdK
         /h0Q==
X-Gm-Message-State: AOAM531kaSjgm5CXZqEfdPAYxaW715cZBj44ku1T6Oc4StZF51h8cKOb
        172+jW4vJAgRSQYl38i1jHkAAg==
X-Google-Smtp-Source: ABdhPJxdzZWSPAfu5kiJHsgXoaKlEMHyoO7bf7BXdQ3G1AR5Pr3gbsP/kmzkmb0nxmt6dWCFQ9iT3w==
X-Received: by 2002:a5d:5381:: with SMTP id d1mr3487021wrv.559.1644935763754;
        Tue, 15 Feb 2022 06:36:03 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n7sm15182386wmd.30.2022.02.15.06.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 06:36:03 -0800 (PST)
Date:   Tue, 15 Feb 2022 14:36:01 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH v4 0/7] Provide and use generic_handle_irq_safe() where
 appropriate.
Message-ID: <Ygu6UewoPbYC9yPa@google.com>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220211181500.1856198-1-bigeasy@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022, Sebastian Andrzej Siewior wrote:

> handler/ interrupt controller entry). It is low level code and the
> function expects that interrupts are disabled at entry point.
> 
> This isn't the case for invocations from tasklets, workqueues or the
> primary interrupt handler on PREEMPT_RT. Once this gets noticed a
> "local_irq_disable|safe()" is added. To avoid further confusion this
> series adds generic_handle_irq_safe() which can be used from any context
> and adds a few user.
> 
> v2…v4:
>   - Correct kernel doc for generic_handle_irq_safe() as per Wolfram Sang.
>   - Use "misc" instead of "mfd" for the hi6421-spmi-pmic driver.
> 
> v2…v1:
>  https://lore.kernel.org/all/20220131123404.175438-1-bigeasy@linutronix.de/
>  - Redo kernel-doc for generic_handle_irq_safe() in #1.
>  - Use generic_handle_irq_safe() instead of generic_handle_irq() in the
>    patch description where I accidently used the wrong one.
> v1:
>  https://lore.kernel.org/all/20220127113303.3012207-1-bigeasy@linutronix.de/

Please use the official cover-letter format (--cover-letter).

It would have been nice to at least find a diff stat here.

...

Do we really need to coordinate this series cross-subsystem?

Can we first apply the API, then have each of the subsystems adapted
separately?  Does the change-over all need to happen concurrently?

If the latter is the case, is this set bisectable?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
