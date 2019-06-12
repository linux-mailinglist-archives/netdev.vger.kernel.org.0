Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E5C42607
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408385AbfFLMhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:37:02 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35446 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405938AbfFLMg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:36:58 -0400
Received: by mail-lf1-f68.google.com with SMTP id a25so11974747lfg.2
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W5ZcUb3ZYYyqexpun8Qj0H696dbroHsPGYQhJd7Effk=;
        b=VwfILO09T4Z5Vgxg5LLncNH+Qmr7pUmjfT+5Jzb3WzyN6G7A2tBfEgXyftXagfT8Du
         s6akg89YgtZnGgiA+o++zwTAO8XQmO0IDJGtMmUvUGY3nn76Ej3S5XXdZ/81lWVUPtlS
         s+ToGxwqYWUZFi/Il+qYx2HotqrkUDbrxWg8OgHZ1q6Cv6W9S04F8AK4BjAakKzgCdeE
         2Hab1EhG3q99Md/eLX9voBH8EpSdv4tefeLKacQaIyA/2ry0SG9gi9mZL/zs1vXk/BfZ
         w0TIRRKQZVbfLUkD5SMr/h+O1GZWPU/lMQtC4rt3K7JTj8f9apLM7tSL58gdgQ1LHG8U
         Bmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W5ZcUb3ZYYyqexpun8Qj0H696dbroHsPGYQhJd7Effk=;
        b=qtkBuS/+nBX8KuCxWqNpsfMlaG47wAJNr1PsNjmp5Zemy6fZoP9IkAU1qrehXhuwNH
         19hQJSGGyCgHK5XtY45D0NFJ6xru6X3pZe/BNRAPEVsx13ZNJsoNi9mEfL69/GfJSb40
         5PoMvtOrLsyyRo/0Dnh6D/MInQserAteIzE4JPhGBHymKSMJ6FqtbgrY3E3RR35YJvVg
         Bx7LKYZ259bg6uEtL+kJN0KYdhzDz2+YgVoqUT/xt++EyNIAMku+hiulO8oBJg5NKKml
         Pbvht+OiX5iGAtmYM4I2l3h21HojPhIX4L1/qnuLDpKWoqKiwtwR+92oGXnXHlkcP8Wb
         IkHg==
X-Gm-Message-State: APjAAAUoZg8dJG/src+een2aWigmsBd170xi4JD25H40TnVGXAf2GXX1
        GPWeavovqea58j/yxZQffbm4NN3dLRIF1RUzhqH85g==
X-Google-Smtp-Source: APXvYqwItuntklbPWZ740m/jW/60/m/o5TFEDtlKeNXqgWJx53OWmMyLvLS322F9vXpV1FpMsEDBzyjEugWzC7+3ics=
X-Received: by 2002:ac2:598d:: with SMTP id w13mr39607037lfn.165.1560343016604;
 Wed, 12 Jun 2019 05:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190612081147.1372-1-anders.roxell@linaro.org>
In-Reply-To: <20190612081147.1372-1-anders.roxell@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 12 Jun 2019 14:36:44 +0200
Message-ID: <CACRpkdbhRAdybqKdMgyM9Jy=eSJaRHjTpuOZO=KBgeaCbcP88Q@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: net: dsa: fix warning same module names
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 10:11 AM Anders Roxell <anders.roxell@linaro.org> wrote:

> When building with CONFIG_NET_DSA_REALTEK_SMI and CONFIG_REALTEK_PHY
> enabled as loadable modules, we see the following warning:
>
> warning: same module names found:
>   drivers/net/phy/realtek.ko
>   drivers/net/dsa/realtek.ko
>
> Rework so the driver name is rtl8366 instead of realtek.
>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Sorry for giving bad advice here on IRC... my wrong.

> -obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek.o
> -realtek-objs                   := realtek-smi.o rtl8366.o rtl8366rb.o
> +obj-$(CONFIG_NET_DSA_REALTEK_SMI) += rtl8366.o
> +rtl8366-objs                   := realtek-smi.o rtl8366-common.o rtl8366rb.o

What is common for this family is not the name rtl8366
(there is for example rtl8369 in this family, we just haven't
added it yet) but the common technical item is SMI.

So I would suggest something like:

obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
realtek-smi-objs := realtek-smi-core.o rtl8366.o rtl8366rb.o

I.e. rename the realtel-smi.c to realtek-smi-core.c instead
and go with that.

With that change:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
