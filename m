Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4048462F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiADQtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbiADQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:49:11 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43663C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:49:11 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso47946021ots.6
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 08:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nk0aYW8xmaANY67wA38Mno5k8+GUEgGnrhUgqMFRavw=;
        b=Wyv117fVh8i2v229qp7m8us3ZIoUlhwUzlS4PB+1EvVUy08JBGM4PWrKdAWmQJywNI
         Cqf+6ZTAl8NJFVJ/KtycTZAwmVjfKrOvfpWjOPlbCEAFq4F5Rll5hn1vvkRAPpvJY6os
         gr1JmPdwiyVJsj7UDJMrLAslFjsX3LBqPvOwoaQnoCauPqC6GY4j9OB+qJKU2Kc/0adv
         o1VKuG962NRJMPPQnUP5sjJvJRd6ScavL971dnMsXBBOT+OTIYTTRADfA/fMvMZYyqxo
         Sn0h0t+CXkd5I09HorJdSsn+upfzfhDM56rn4B5B7Y2+7MBAd1l52iywfv6Qu8e6goCQ
         5gSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nk0aYW8xmaANY67wA38Mno5k8+GUEgGnrhUgqMFRavw=;
        b=5MBUUmP+XSD8vRC5vgCm8s9WAUdEC+o/fCR30RB6wfr2HqnG3p++Hyat9G8Dq4fxzy
         vI5kMct7Su9HNE9lE+vA6JrnHj1HU3XQ6MdgddWe0xT+kIOQP3bX16vpKCWo2036NEa2
         vIMgddvQwxeIrfn2HDv/l7busjO8c4LtqXvpneDfsUdUdHX4aUGe1CEjOPQ80WU6vQQH
         xImyFKlXRsHPyhN7yGUDz3/b+EIi7CHaaKJg037FEqpIAyi5HnwX7fX3tPf6pfi83y1V
         Nor0D5vXdWmASgP1dpnfSCMJJM+8WtLdbumF39bMfAaO+wo1bNqMMwKQ4hvY3OwDyGnW
         1tAQ==
X-Gm-Message-State: AOAM532jqw1F3W2Hd4BQBEc8NTBwsPH0HejWMUO2wuWJ0lRFi4bD9wwI
        voYMW0UzwqZ5coyH6chMxW/L7b4SHCW6NqPCg05YDA==
X-Google-Smtp-Source: ABdhPJxBLS98dFTQUiuMh74pX1sC9/E2IRzT57swFPXBIWj06YlQj9pdICfdZLREbd5nzBybHHepqFZaKSph6UyqkSM=
X-Received: by 2002:a05:6830:20c6:: with SMTP id z6mr3207917otq.237.1641314950603;
 Tue, 04 Jan 2022 08:49:10 -0800 (PST)
MIME-Version: 1.0
References: <E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 4 Jan 2022 17:48:58 +0100
Message-ID: <CACRpkdZCACEHEFq93CHvr4E+xMFa3YHUVcJXt=Uc1THZ8_3psQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: gemini: allow any RGMII interface mode
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 5:38 PM Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> wrote:

> The four RGMII interface modes take care of the required RGMII delay
> configuration at the PHY and should not be limited by the network MAC
> driver. Sadly, gemini was only permitting RGMII mode with no delays,
> which would require the required delay to be inserted via PCB tracking
> or by the MAC.
>
> However, there are designs that require the PHY to add the delay, which
> is impossible without Gemini permitting the other three PHY interface
> modes. Fix the driver to allow these.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Excellent root-cause analysis of this and thanks!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
