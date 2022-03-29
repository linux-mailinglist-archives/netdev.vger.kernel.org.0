Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591954EB2E7
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 19:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbiC2RsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 13:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236919AbiC2RsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 13:48:20 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0239F6E4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:46:37 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2e5e176e1b6so191648247b3.13
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrxBmj3GpjfEXbV7dJKqlXJPQi4RQr480aeAGe5MOS8=;
        b=VcYOpdW+8NZLiACShBrxKYjw/NzSb+jdRYP/YfIzGIeaCqcOvIqqFa+HkLN1UG6N/Q
         3xiCZQ4MqO3ngax6VRhP1+9rOrLop4QwPTEuFV2bhZDW5kGa91gQU3ZoNkzSslPDIdyj
         ESjbIWwL+20GWKVbM25H/1hURq5eqR8q1dHcMwoMh1S1h0HRITLMxwhju+mfTPSGtFVM
         xg5FS7tHyvuGBaSBBTlXzfFSlE3biWMS3B+FzJap1BQBChOgX02ZuOwR3kFAUeWgafPU
         At75EqZ8Fz8rsk1T2SRXrPLcVe1Kiu7l0h3Uhs+cw/S6Dgl/e4ELpzOh/MKrkRs6vGvL
         VnXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrxBmj3GpjfEXbV7dJKqlXJPQi4RQr480aeAGe5MOS8=;
        b=4MKn9+BZpiN/SGKLXdkcMYSNtJa3RBtaVY8a90kV2jG3Zu79dKN9q5B9ogRKldaJdx
         u2wr0Lk0ewe4cbjHqTp0GW8pLYAjQu5L0anwijlL7IzDlL7wbozxSbl/OfBjI13JSrB5
         miTzS2he5VNfFi2a8Mse6EK4hGhm3QRqe0zQaRk6LWyOsAd1g39lQqnzB8fN5OKlrELg
         v7oA5MtCNdfotlPs4SxDwAGMPKCx4e9In/8JgmrE1owuTE/+Xm4bB4+qHv25s4uJ6hGZ
         QaqHE0IOGMs1j5531U8qiVOXVgOMPeCMpthrckiuAEQ+aYkEUBYHXawx6uHBf/A9/Uw+
         36DA==
X-Gm-Message-State: AOAM533VeQiITd9Eg2fg9P+TJc5XNzGjw+gBwrehTkY1Hc+F23J8poGe
        agq8PKJ/ntKusBAU4AahlpSI8FZw3O6Xe03hdJFNSQ==
X-Google-Smtp-Source: ABdhPJzmr5nr3EH0V0FaEzffhKcpEMjHM6b5lUrXr25VGW0+uSbpa5ywzIB7LYtr99FeJgpoM4ph8hxqn7i37xz2P4s=
X-Received: by 2002:a81:71c3:0:b0:2e5:8d77:1bfe with SMTP id
 m186-20020a8171c3000000b002e58d771bfemr32745027ywc.36.1648575996500; Tue, 29
 Mar 2022 10:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
 <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
 <20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08c5c6f3-e340-eaee-b725-9ec1a4988b84@linuxfoundation.org>
 <CA+G9fYsjP2+20YLbKTFU-4_v+VLq6MfaagjERL9PWETs+sX8Zg@mail.gmail.com> <20220329102649.507bbf2a@kernel.org>
In-Reply-To: <20220329102649.507bbf2a@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Mar 2022 23:16:25 +0530
Message-ID: <CA+G9fYvC3b9YwXjeAUBKbgWCgip7KioBRxH=GGNPSpyPqDy2dQ@mail.gmail.com>
Subject: Re: kselftest: net: tls: hangs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Netdev" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, 29 Mar 2022 at 22:56, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 29 Mar 2022 20:19:10 +0530 Naresh Kamboju wrote:
> > > > But I can't repro the hung, and we have a timer at the hardness level
> > > > IIUC so IDK how this could "hang"?
> >
> > Did you get a chance to build and test with the config file that I
> > have provided ?
> > I am using kselftest-merge configs for my daily CI system [1] on gitlab.
> >
> > If you think the Kconfig is a test
>
> I have not used the exact config, just a config with TLS=n.
> I also have a different GCC version (11.1).
> Unfortunately I don't have access to docker or podman on the machines
> I'm using.
>
> > > > Naresh, is there any stack trace in the logs? Can you repro on Linus's
> > > > tree?
> >
> > There is no stack trace print, it was only hung.
>
> Can you check where the process is stuck and it's state?
> /proc/$pid/stack and run that thru scripts/decode_stacktrace

I generally use remote devices. which have single serial connection only.
However, I will try your suggestions tomorrow and get back to you.

> > > I couldn't reproduce this either - I have TLS=m
> >
> > If you want to reproduce the same build or re-use the bzImage /
> > vmlinux / System.map
> > you may check the provided link [1].
> >
> > Step to reproduce [1]:
> >
> > # TuxMake supports the concept of runtimes.
> > # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> > # that you install podman or docker on your system.
> > #
> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake
> > #
> > # See https://docs.tuxmake.org/ for complete documentation.
> > # Original tuxmake command with fragments listed below.
> >
> > tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11
> > --kconfig defconfig --kconfig-add
> > https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config
> > --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config
> > --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config
> > --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config
> > --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config
> > --kconfig-add CONFIG_IGB=y --kconfig-add
> > CONFIG_UNWINDER_FRAME_POINTER=y cpupower headers kernel kselftest
> > kselftest-merge modules
> >
> >
> > [1] https://builds.tuxbuild.com/26mKij4yB5Q6WUpOyHHEoHLstVJ/
>
> I only see build logs here, are there logs for the run?

Yes. Those are only build logs.
The test log is here but not very useful.
 https://lkft.validation.linaro.org/scheduler/job/4770773#L2700

- Naresh
