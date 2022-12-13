Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E7264B2F4
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiLMKGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbiLMKGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:06:00 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7561B78B
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:05:56 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id c184so14112210vsc.3
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XMzzFTvuqaMziGtwkJpPvbzIY0Mb8qOTWg1NfkHEVhE=;
        b=JIrF0JrjEbC22Xe6s6IPvHqn0qMEb89jhAc1+irAGXJYCtQqITTSxVN8qDSZsBoAeA
         Aaqr31a2yqCR0CihwMb8QpsIsVzFpGH9JjnQeEwM9vmHQ5iktcAwRTLotk6sR/SUPCop
         lU42FjqrvgCiNST4BOzA05muKUsiQZey/riVqY1EyplKc6C9WA5IQpeBY3WdhQCTrXEK
         fgp/TcuKmt8/8a+Nm59w6TjpWHQjx7UXgbLp0kRcuV20NpDhjJU1lL+DdUniWlWJb7wF
         VfoA3PlKY+HefsP+6mjk6Khg7uHcn9jkBOR9oKGiqR4JuqJ23T7ukicXjB9FvwDfgAJa
         +khQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XMzzFTvuqaMziGtwkJpPvbzIY0Mb8qOTWg1NfkHEVhE=;
        b=nbuBbSVR+IsQuq6NH7rLuxE/hYgU1lx8OmpJnrLGkp6dyZ3xFEJ2od75MnCA6OkBpP
         y558O70T1/iqnvxNLnnvZJVybV7DOChIZ7KwEwQNQ59QrcZy/snUqCw0n0O8xZ7eerhC
         HTgd6yikE/aRfA1BRkE0oVUROCGuFAvpqHBMS4jpEYtePq3NDnXmGuXxnjR2GqF3ihud
         77hYubbEGfpZr0YpAdbl2BZYT4GvTOVzi98p8cr/RczBjE9p7qtPLe4ltap6WGHL3bAz
         5r+MBnNNx7TGyiMeXpNpm4QYHL0DQFEYKa9DhtQIMp2Otz7RxWrPTWqFCzLy1T+fZU1a
         rNAw==
X-Gm-Message-State: ANoB5pn/C5ESIl8roDo1dLKSN+zLjIKG3s0fTUjhTguWQCPzX8tMiwZV
        7RpZVB4w0qSgNdIKsdJaWGSsVBohoKjBye8dLUWxVQ==
X-Google-Smtp-Source: AA0mqf7vpSlMQ7Ef8ekL/1O2JwgvLvwzON3XuqsxRGCJcCtaYNlJG/cxmKIIJCa9o9rRzJFCC+FwwmxHhtbLGjWE/NQ=
X-Received: by 2002:a05:6102:3590:b0:3aa:eee:5bc9 with SMTP id
 h16-20020a056102359000b003aa0eee5bc9mr44049108vsu.24.1670925955828; Tue, 13
 Dec 2022 02:05:55 -0800 (PST)
MIME-Version: 1.0
References: <20221212130924.863767275@linuxfoundation.org> <CA+G9fYv7tm9zQwVWnPMQMjFXtNDoRpdGkxZ4ehMjY9qAFF0QLQ@mail.gmail.com>
 <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
In-Reply-To: <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 15:35:44 +0530
Message-ID: <CA+G9fYtNvr-82FG23mkKj2LAMtS87hGEEpjZsGNUhr8oPU6O2A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Jakub Kicinski <kuba@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Dec 2022 at 14:50, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Dec 13, 2022, at 08:48, Naresh Kamboju wrote:
> > On Mon, 12 Dec 2022 at 18:43, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >
> > Regression detected on arm64 Raspberry Pi 4 Model B the NFS mount failed.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Following changes have been noticed in the Kconfig file between good and bad.
> > The config files attached to this email.
> >
> > -CONFIG_BCMGENET=y
> > -CONFIG_BROADCOM_PHY=y
> > +# CONFIG_BROADCOM_PHY is not set
> > -CONFIG_BCM7XXX_PHY=y
> > +# CONFIG_BCM7XXX_PHY is not set
> > -CONFIG_BCM_NET_PHYLIB=y
>
> > Full test log details,
> >  - https://lkft.validation.linaro.org/scheduler/job/5946533#L392
> >  -
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/tests/
> >  -
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/test/check-kernel-panic/history/
>
> Where does the kernel configuration come from? Is this
> a plain defconfig that used to work, or do you have
> a board specific config file?
>
> This is most likely caused by the added dependency on
> CONFIG_PTP_1588_CLOCK that would lead to the BCMGENET
> driver not being built-in if PTP support is in a module.

Here is the build command which is the same for working and not working
kernels.

# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft-crypto.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/distro-overrides.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/systemd.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/virtio.config
 --kconfig-add CONFIG_ARM64_MODULE_PLTS=y
 --kconfig-add CONFIG_SYN_COOKIES=y
 --kconfig-add CONFIG_SCHEDSTATS=y CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-

- Naresh

>
>      Arnd
