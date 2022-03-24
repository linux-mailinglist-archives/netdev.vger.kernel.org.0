Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DD94E6ABC
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 23:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355389AbiCXWdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 18:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244280AbiCXWdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 18:33:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374ADBA321;
        Thu, 24 Mar 2022 15:31:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mp11-20020a17090b190b00b001c79aa8fac4so3134288pjb.0;
        Thu, 24 Mar 2022 15:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yod7U3OVUg4uNqY5svIcJ1tadGMaHGULBreSABaYdbE=;
        b=QuqTJS3PzDePlzBY/DjMMkBkQzrT+DWwXza1rW78vN4LS3Okv9LaUrOby+7+OQwKJb
         l7InH4pGc63+Vlq1lP5rgllByfc4rk60gHLx4qYryHZsK3XlcTechjciXUoOGW0MMDQI
         FhAtxEFRoCf3qDGGO+Owe7hwesJgEV8vRM+WBl3YKDndSGEjFz1Z8VWDTg2HJfxgaIO0
         2/7d8gzhyaeHaK9yeqB4O0iP4maWESsP8GENRZJfBRmkseYbbhnMAW0DMI0jT/VHTTaB
         pvq4ZuQWHADryAj0hGNi2uCOjWSPvDbt+63ribqYQU6IbVBHaqhuMMngHudDqTuMmApV
         a5EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yod7U3OVUg4uNqY5svIcJ1tadGMaHGULBreSABaYdbE=;
        b=7ggb6F/dSPry/js4Bo0ICBKKswKTO6aRRiooHGLs5O6AasmCz6Uo42YEiGTEMGRAfy
         neXXlesi+yWyyhzBkZ250a24SYmmEb4sCML1R8XjEFHSC3D5SeQ6mtVparnRWf2vHvAG
         JWy07Hh31A/G8h6dQAtVKKWtST0wm38IxgCWMSZ30wNb2Jz/B3ELtXMf/O7qQoZZPWcd
         XoHflKGVytdLHj6finhZ0j8P49E88sCQNmwgnbcF9/ceJX3OL/Ym0q9QTLP+22WmTVxD
         5NP2xmGc0K7HSxwvjaRgLRedsw0i9jtLhdi0qlWBohvJoDTzS0dZcUe+3dxFuuBW+czU
         qvrg==
X-Gm-Message-State: AOAM533raxEXyHnJH6/Pxpf8WowWJkDVwhL2Wl5dYDxSMVElkn6CN0tw
        qn+xREoZo6aNelvmszKrVcb8S8nHZd0=
X-Google-Smtp-Source: ABdhPJzQzlT5/1wdqKvYsdjhM4g271o6xMRvl7blS67Dq+GZCg0qJtg2gkck67td4mIs0gl7ZYPiNA==
X-Received: by 2002:a17:90b:4f8e:b0:1c7:3652:21bc with SMTP id qe14-20020a17090b4f8e00b001c7365221bcmr21085353pjb.38.1648161110040;
        Thu, 24 Mar 2022 15:31:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ip1-20020a17090b314100b001c7b10fe359sm3889234pjb.5.2022.03.24.15.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 15:31:49 -0700 (PDT)
Message-ID: <1e50ca36-fc68-6ba8-b041-09336060a409@gmail.com>
Date:   Thu, 24 Mar 2022 15:31:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] net: phy: broadcom: Fix brcm_fet_config_init()
Content-Language: en-US
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     opendmb@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220324215451.1151297-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220324215451.1151297-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/22 14:54, Florian Fainelli wrote:
> A Broadcom AC201 PHY (same entry as 5241) would be flagged by the
> Broadcom UniMAC MDIO controller as not completing the turn around
> properly since the PHY expects 65 MDC clock cycles to complete a write
> cycle, and the MDIO controller was only sending 64 MDC clock cycles as
> determined by looking at a scope shot.
> 
> This would make the subsequent read fail with the UniMAC MDIO controller
> command field having MDIO_READ_FAIL set and we would abort the
> brcm_fet_config_init() function and thus not probe the PHY at all.
> 
> After issuing a software reset, wait for at least 1ms which is well
> above the 1us reset delay advertised by the datasheet and issue a dummy
> read to let the PHY turn around the line properly. This read
> specifically ignores -EIO which would be returned by MDIO controllers
> checking for the line being turned around.
> 
> If we have a genuine read failure, the next read of the interrupt
> status register would pick it up anyway.
> 
> Fixes: d7a2ed9248a3 ("broadcom: Add AC131 phy support")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

I will make this a v2 which explicitly includes delay.h to have a 
definition for usleep_range9) so this commit would apply cleanly to 
earlier kernels as well. Please do not apply just yet. Thanks!
-- 
Florian
