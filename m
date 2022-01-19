Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B402A493F5C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 18:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356530AbiASRut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 12:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344353AbiASRur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 12:50:47 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F310CC061574;
        Wed, 19 Jan 2022 09:50:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j23so11382882edp.5;
        Wed, 19 Jan 2022 09:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gYqrzHKY6NZ+smDMyNLEdjverS9Vu94GwZDjRJxBkqA=;
        b=fiV7KO5DntXelX0OfsQwMZ+mrbf1r4MX4LvHgm8nKHMgHVomhgK2EstxRyA3k2PNMo
         ND6qE2dpDjcyySIVQbG5BVociAX9RQp1Iw2qF9YaZ8bK+TpyP2WhWG4CjdC+phk37eWk
         lLU4ZS/QTAU83uE54abGHGwTiTF78dMbRBXLbAHzdf2cGD3TMKnot0FBpYSy0VuXQdFJ
         fpfwBXTYPRk+DhGZXarUHtCFXfDTBis8RDS0htGQ9pw2KI/2kW2KZyGVJx3p385LD/Zk
         w/lT4WXLAEeeZNFZK9yR9E6LxldsRj44MO9GAv5RdQcKLN/G97hSFd1FYwOzRjwrwQ1s
         U71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gYqrzHKY6NZ+smDMyNLEdjverS9Vu94GwZDjRJxBkqA=;
        b=yA5cMUcT/jqBKQVsjtM0NxjNGCfFKcI5812LRLRf2ehpeGpNQO1Ddn9ekLj4QMsFr5
         XooxUAd/naHzr5w5H6S6tsyMQtqq6MdIOvsiMqc7vzJz380gXySjHg8mk7eXLiqdrKOC
         9DgzfjIQIIlwd2pAwd9n9tYhK8hJOPY4p4FUXY8A/JsdHVQSLlTDEbJKbcwzbRmexfDY
         T3PatmlK2NNxJNL0zePXM4s4cORqZVY2UEHZIb/dvTf+Pf0FST4d3sz/CvtvqBMXWc7Q
         s/IxpKnrAEMufLwWUpoRr81sjDGdZyLNXnfB6PEIyQ8b/Nrv63725INjof2z16f97jSD
         fKWg==
X-Gm-Message-State: AOAM533fheJ3VJiSMU5ThDVYOucUUbFX5O442wMc/VlEoOvN1G0Pgl97
        Lu3oTt87rOILNC744AAkjLshgyt4wFbr9GYJqgo=
X-Google-Smtp-Source: ABdhPJxpCISVyWKWKmWvQqQZxVaOGKUDCOomH8fpNTQfnCEI6mNChEe1bV6hhw1xHpAzOHlmz0/2fU+h5aQ8rZLpMeU=
X-Received: by 2002:a05:6402:4c5:: with SMTP id n5mr31968102edw.122.1642614645556;
 Wed, 19 Jan 2022 09:50:45 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-2-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-2-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 19 Jan 2022 19:49:03 +0200
Message-ID: <CAHp75VfVuX-BG1MJcEoQrOW6jn=PSMZH0jTcwGj9PwWxocG_Gw@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] brcmfmac: pcie: Release firmwares in the
 brcmf_pcie_setup error path
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>
> This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
> the CLM blob is released in the device remove path.

...

>         if (ret) {

>                 brcmf_err(bus, "Failed to get RAM info\n");
> +               release_firmware(fw);
> +               brcmf_fw_nvram_free(nvram);

Can we first undo the things and only after print a message?

>                 goto fail;
>         }


-- 
With Best Regards,
Andy Shevchenko
