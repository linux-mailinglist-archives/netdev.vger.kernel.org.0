Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA304BF392
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiBVI17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiBVI1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:27:45 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF442A419C;
        Tue, 22 Feb 2022 00:27:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id bq11so13710137edb.2;
        Tue, 22 Feb 2022 00:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YeBwl+cDNDxkcii4iqqmSQh8iOckl1iaIpteuIFwTpM=;
        b=cqCcBFsrzeJKHRx4gHlf7ld7nCQ2LRR7Hk9EwhMt4BExbFeDUyhfESgj3mb/pNAks1
         f6v5gibh6yg8f2rpo3rnCmV4aOu9aQtdWSWFnkeIwvF7ZzW2jH9wD828iRo++5Qq9hiP
         iFMSSWli1mUKheJ+ByRAVr+DTrlxrN8d1GpL8csErTYywrIdJD+wgKdJhbz14YcTjNN9
         QLYHpOJj4+aD1gQXQR4BBuFY7ODOlwSbpWIlkPcFtX1RGy1o2J52AsHyRf+K/sMYD/Ts
         Qkp6/Su6sQs5AZVED84I1YoDKGniaI4xqKFxUJqRAyMuXaws9yZcAuBmOBlZ4fLUwczV
         njhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YeBwl+cDNDxkcii4iqqmSQh8iOckl1iaIpteuIFwTpM=;
        b=jkiLqk4URiNcID+mVrM9Ld7MfA5+WGAXfDXHq23CPXH0inIG4TqnASrJpqn0voSJ2j
         z+NxKjzxEZiDMEhG1SLjHUb1yqJqU+VGX9t5koqEq6N3UXD/M76qJw7uFtwctdVJSow/
         F5wgt1cv//aVN4bqffjJ3rVh/UTXvjGfLVl8JVXAjqXHYn5qQ4lrt7b5wSw/ovjB3T93
         ySK9CrK9tjgJGJ1PntcjG277Nn0BepEyBfrjEBnobzYvp1kWRRogsqtjl7xbsjHeTij0
         HovlHpuHKQrHKDR8nqOKcBF98cj7TVGnjM9hIDISBexMPFRMGRxdN0mZzQSQN5m3QMHc
         FJxw==
X-Gm-Message-State: AOAM533WNDEv71tK6zq5f6gxm+XZyozsX9nvExWeDBfWvIQTNZZv4g+q
        aT4aEQUOBYdTOgotgS9KkfLgob9rVXXHkOROL44=
X-Google-Smtp-Source: ABdhPJzaz9o/CRhBuFWxIAMNaUpZe/CUzLwFI2z7NFjp37R9qL4VEb/wnJoPDe0i1GXAZrVXlCIg3+4GTr9kvxWyShw=
X-Received: by 2002:a05:6402:51ca:b0:410:a0d1:c6e9 with SMTP id
 r10-20020a05640251ca00b00410a0d1c6e9mr25307011edd.200.1645518439393; Tue, 22
 Feb 2022 00:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20220221162652.103834-1-clement.leger@bootlin.com> <YhQHqDJvahgriDZK@lunn.ch>
In-Reply-To: <YhQHqDJvahgriDZK@lunn.ch>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 22 Feb 2022 09:26:43 +0100
Message-ID: <CAHp75VeHiTo6B=Ppz9Yc6OiC7nb5DViDt_bGifj6Jr=g89zf8Q@mail.gmail.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 5:57 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > This series has been tested on a x86 kernel build without CONFIG_OF.
> > Another kernel was also built with COMPILE_TEST and CONFIG_OF support
> > to build as most drivers as possible. It was also tested on a sparx5
> > arm64 with CONFIG_OF. However, it was not tested with an ACPI
> > description evolved enough to validate all the changes.
>
> By that, do you mean a DSD description?
>
> In the DT world, we avoid snow flakes. Once you define a binding, it
> is expected every following board will use it. So what i believe you
> are doing here is defining how i2c muxes are described in APCI.

Linux kernel has already established description of I2C muxes in ACPI:
https://www.kernel.org/doc/html/latest/firmware-guide/acpi/i2c-muxes.html

I'm not sure we want another one.

> How
> SFP devices are described in ACPI. Until the ACPI standards committee
> says otherwise, this is it. So you need to clearly document
> this. Please add to Documentation/firmware-guide/acpi/dsd.

-- 
With Best Regards,
Andy Shevchenko
