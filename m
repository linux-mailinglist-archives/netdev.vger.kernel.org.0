Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9B44369E4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhJUSDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhJUSDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 14:03:03 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218F5C061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 11:00:47 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w19so700258edd.2
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 11:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIYrRTmX5V84BHHeufjDiyr6+alzshVTg749wgpX3eo=;
        b=EiFLijYDlfmhmyoo92EoztIv8sM8Jp+fKgSCojNMOoqJVkBDvO08suLxUycWhmWoPA
         Ff94psFkpw0SYCpsXIl9mpE700PCTNxnjm/ElxTxAgbEr1uuTPPMNnE9Uxffe2BNYW5F
         bhe0+V0PTySy3ZS4Sajp16lbnkqrYOocozpU9Xv2NQ2TxKQW07s7VapCINvNRVxzOzF3
         I6M8F6lO5CXSf9g8l+P5bKTnNpJ9qQXaqpPd7Hq9M+mbyC4cTQ1SN6t0+UtXBxc0DKeX
         AA4k3eFHXV3uNTD7JRvEs1i4qFS7tgTmBg5N/qpbLcOUezHFmvVK3ewKgLaLP/rgrFPI
         NeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIYrRTmX5V84BHHeufjDiyr6+alzshVTg749wgpX3eo=;
        b=WUCNPKlqdOuaDL1SBBcE5nOr3exrUk7canJFdoZT//Nqj+vcMl6FtnZ1FJGHvbQCH1
         fy+7Eqjqsg1cRqSHaIwnYUBEmC4bqmELVmVU4aaStcQn9LLUOBp1WCWi3rsbCMyPLxKX
         mU14nekI1+WbcbVuEZ6Nmbo7BAMEP7UfCj79mQi6jHCcJIe/RhIFjI7EUTnydOOZzIHE
         HfleOOcgOGFQjdW9evRiNTrk3AnQG30b2Z0jtwQKDcZ4CiZv+KgUMYhX1TQCLDdffPXn
         rCseRdph7l8Y825OP+qsiTnlsmhqHrRJEToK73TSbS2y5m9dmsD1JGdz8U5XjgBiQHTr
         CVZg==
X-Gm-Message-State: AOAM533ruQKC7AEOhluFHfF2D0JgaL4TZBzv6FqAFktxH+PDO2ZqunZB
        oCGok74XBRqnBMRjrfR1iZUotEnza5myTdDTMwbZ6A==
X-Google-Smtp-Source: ABdhPJzlqQaS/1MlF4OEnw3mUA5NGqkHXCkQD3KUM6Cs9XIFrFlfTJy9R87RSguimFt9hUj6Qu7SWk+UXl7aifxmkpw=
X-Received: by 2002:a17:907:2bc2:: with SMTP id gv2mr8820744ejc.433.1634839245373;
 Thu, 21 Oct 2021 11:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211015164809.22009-1-asmaa@nvidia.com>
In-Reply-To: <20211015164809.22009-1-asmaa@nvidia.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Thu, 21 Oct 2021 20:00:34 +0200
Message-ID: <CAMRc=McSPG61nnq9sibBunwso1dsO6Juo2M8MtQuEEGZbWqDNw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] gpio: mlxbf2: Introduce proper interrupt handling
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, davthompson@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 6:48 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:
>
> This is a follow up on a discussion regarding
> proper handling of GPIO interrupts within the
> gpio-mlxbf2.c driver.
>
> Link to discussion:
> https://lore.kernel.org/netdev/20210816115953.72533-7-andriy.shevchenko@linux.intel.com/T/
>
> Patch 1 adds support to a GPIO IRQ handler in gpio-mlxbf2.c.
> Patch 2 is a follow up removal of custom GPIO IRQ handling
> from the mlxbf_gige driver and replacing it with a simple
> IRQ request. The ACPI table for the mlxbf_gige driver is
> responsible for instantiating the PHY GPIO interrupt via
> GpioInt.
>
> Andy Shevchenko, could you please review this patch series.
> David Miller, could you please ack the changes in the
> mlxbf_gige driver.
>
> v5 vs. v4 patch:
> - Remove a fix which check if bgpio_init has failed.
>   This fix should in a separate patch targeting the stable
>   branch.
>

Hi Asmaa! Did you send this fix? I can't find it in my inbox or on patchwork.

Bart
