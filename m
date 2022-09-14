Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A75B8BAB
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiINPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiINPVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:21:35 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E668F2F02D
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:21:32 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id z18so11413116qts.7
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=8sVnRYf4lRZtHclJFM/PYgijezwVHsVwJUa/M1F9Nfw=;
        b=aU+pRvep+sXGVRr01+jPV7M1KGeUuIOdGm/7Imgv2e35rdbyXzmARUq1pX7NbUK31d
         P7JnZtuwOHE1Y3V+NSrCkrjcfy/IVgYVBkLzYROVFEJ2rN4QRKzlug+IhDRBgsnblfD/
         z6gvdEo890XqggiMeBDVIPT5KAcHLF/iLDo5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=8sVnRYf4lRZtHclJFM/PYgijezwVHsVwJUa/M1F9Nfw=;
        b=hxJWELQe7TqvLHsUZbc1jeQocSOmRB4wOh2ZHXRh9M5Xk1GVHNxFkbAd+EmpatOvCR
         BYbi3189RhaE5TXUwkJnWbP5ONttACCz7NqM/Srkeg+cq0VE4BqylUCny1MpenrQhn4g
         zHJOOVAJpy/teuTit6gAlJXlTxND6QaAFvmsaOw6g4V5h8nioJbKFlc442KdIv5LbM+b
         eGt77slofV1weLyeKGxZBkhH/xPyLaolP+D/nzFQKs6fI6dWw3TGWL3ZistY0plKYq0Q
         BKQMxFVwJ1h/GVASs1qQVqk/hOmlyZ2BM/yPpsWO2jWfBuXo3bbFEwnr3alDguJ5DBbw
         vXhg==
X-Gm-Message-State: ACgBeo2l9q+5M64c0UIJ4uykxqGUMAQYBAxrgcDf1bXwCFBfooZ1Bc9j
        +SBH1ZT/JVDE9zS6Jv59+Frd8eeyNWnACQ==
X-Google-Smtp-Source: AA6agR7ZNSK0Wj6yfxk79XJBZFAA1MTWPQ476wlMRinCM4BZ0UnCvklfLiJOYGy/JdFBeTehewHncw==
X-Received: by 2002:a05:622a:2cc:b0:35c:ba98:a026 with SMTP id a12-20020a05622a02cc00b0035cba98a026mr2708655qtx.160.1663168891742;
        Wed, 14 Sep 2022 08:21:31 -0700 (PDT)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com. [209.85.160.177])
        by smtp.gmail.com with ESMTPSA id h2-20020ac87762000000b0034454d0c8f3sm1594370qtu.93.2022.09.14.08.21.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 08:21:31 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id j10so8597240qtv.4
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:21:31 -0700 (PDT)
X-Received: by 2002:a02:9509:0:b0:349:b6cb:9745 with SMTP id
 y9-20020a029509000000b00349b6cb9745mr18869971jah.281.1663168880396; Wed, 14
 Sep 2022 08:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220912221317.2775651-1-rrangel@chromium.org>
 <20220912160931.v2.5.I4ff95ba7e884a486d7814ee888bf864be2ebdef4@changeid> <YyFs5q67RYR2aAy7@black.fi.intel.com>
In-Reply-To: <YyFs5q67RYR2aAy7@black.fi.intel.com>
From:   Raul Rangel <rrangel@chromium.org>
Date:   Wed, 14 Sep 2022 09:21:08 -0600
X-Gmail-Original-Message-ID: <CAHQZ30CU2-YtOfGYXJq3c=-1ttyw=hKZvViOfWGAKkxXO1C5Gw@mail.gmail.com>
Message-ID: <CAHQZ30CU2-YtOfGYXJq3c=-1ttyw=hKZvViOfWGAKkxXO1C5Gw@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] gpiolib: acpi: Add wake_capable parameter to acpi_dev_gpio_irq_get_by
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Linux ACPI <linux-acpi@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "jingle.wu" <jingle.wu@emc.com.tw>,
        "Limonciello, Mario" <mario.limonciello@amd.com>,
        Tim Van Patten <timvp@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S. Miller" <davem@davemloft.net>,
        David Thompson <davthompson@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Lu Wei <luwei32@huawei.com>, Paolo Abeni <pabeni@redhat.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 11:55 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> Hi,
>
> On Mon, Sep 12, 2022 at 04:13:09PM -0600, Raul E Rangel wrote:
> > +int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name,
> > +                          int index, int *wake_capable)
>
> Here too bool.

I've incorporated both of your suggestions. I instead added
`acpi_dev_gpio_irq_wake_get_by` as the basic function and left
`acpi_dev_gpio_irq_get_by` the same. THis way I don't have to update
any of the callers.
