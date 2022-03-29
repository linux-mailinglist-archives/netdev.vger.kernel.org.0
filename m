Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22D4EAF97
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbiC2OvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 10:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbiC2OvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 10:51:09 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300844A17
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 07:49:25 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f23so1504966ybj.7
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 07:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2oha13URciMJUMHsLdhAfLwBD02pEz7fymz7j2GuO7o=;
        b=wBWob6xx+smvegWHYDHGVSH5Rfy37d3hz6zthZZcPFemFXoA+nsASFgP6NQiFKIbE3
         vWIaox+AyVGgFCHkBQkOiDBOn4JA/4PQ9Srx+8oeWQboWEFG+Oz0XPK/RretvIxeSW2v
         axIdcy+Z1oXPU8Yf1w1g4a9iSZjUFYlSOEOLV9B4L0YWFMIKobHYcFIt0CnHukEXPskB
         3cta2MzhxPDYRyaqirp0WllWgLzPr2jsd3uUNvKaeOCN0mvIi8Eu5G/gKdZ9Dx4Izhj5
         mXptXWPiFDrvKAG0r5K7m/8Nh827vevOIIuMJj3QhQ46ytdI51ANoB/QArDmvQD4qk6+
         mvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2oha13URciMJUMHsLdhAfLwBD02pEz7fymz7j2GuO7o=;
        b=d7amnjJf3Cc4Se0k9DZgXnmwLbEQOKj03qDRmK0WOU9iuv/pZekdE4yUOkKSXDJOrk
         5v/D7yMT2YjSuFvtL/plC0wAw6O/tk4igN2jenxzYeUHtYCK327B8JjSU7xcHJm931Fx
         TxI7tMUXFCoOBtaJPDY3H7e4mUz/btXhfFkAp7dQX8D523yPbBlwSXkgcRADl0yaAytf
         ekNyX8G4wU0SmGKThs/2ENp/wkzCETo/8uLTnm9VT+RxRoV4zlHhDZhVbIu/3e83lI6o
         j7f+IJuuTY/zfTbUEPa1EqIZTPLF+n4lgFMV6E+8Wt7TgtK9o2hwspjseLAUAtAUT+BW
         6NPw==
X-Gm-Message-State: AOAM530rilz6JlHVsD/4yQOksUroSKQoSvuStN8vgLU1Cs3zBfrMWuWP
        u37cYNsscivOqGjNlEk1+zzfhaq3+P+r4TMjC1ZEip+wco0lwnHa
X-Google-Smtp-Source: ABdhPJzNMO0WNloIJZHTbvtLBwdcrxAvJey28Sdrtc06nKCudh6Qlw+sP4mWnWff33jmxA1NY5T8kuC5m/fNpf0cxVg=
X-Received: by 2002:a25:9909:0:b0:624:57e:d919 with SMTP id
 z9-20020a259909000000b00624057ed919mr29015853ybn.494.1648565364194; Tue, 29
 Mar 2022 07:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
 <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
 <20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <08c5c6f3-e340-eaee-b725-9ec1a4988b84@linuxfoundation.org>
In-Reply-To: <08c5c6f3-e340-eaee-b725-9ec1a4988b84@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Mar 2022 20:19:10 +0530
Message-ID: <CA+G9fYsjP2+20YLbKTFU-4_v+VLq6MfaagjERL9PWETs+sX8Zg@mail.gmail.com>
Subject: Re: kselftest: net: tls: hangs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>
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

> >> This seems to be the problem perhaps.
> >>
> >> Jakub, any thoughts. The last change to tls.c was a while back.
> >
> > Yes, sorry, kicked off a build and got distracted.
> >
> > I can repro the failures, TLS=n in the config I must have not tested
> > that in the new cases.

Thanks for investigation and reproducing the test failures.

> >
> > But I can't repro the hung, and we have a timer at the hardness level
> > IIUC so IDK how this could "hang"?

Did you get a chance to build and test with the config file that I
have provided ?
I am using kselftest-merge configs for my daily CI system [1] on gitlab.

If you think the Kconfig is a test

> > Naresh, is there any stack trace in the logs? Can you repro on Linus's
> > tree?

There is no stack trace print, it was only hung.

> I couldn't reproduce this either - I have TLS=m

If you want to reproduce the same build or re-use the bzImage /
vmlinux / System.map
you may check the provided link [1].

Step to reproduce [1]:

# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.

tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config
--kconfig-add CONFIG_IGB=y --kconfig-add
CONFIG_UNWINDER_FRAME_POINTER=y cpupower headers kernel kselftest
kselftest-merge modules


[1] https://builds.tuxbuild.com/26mKij4yB5Q6WUpOyHHEoHLstVJ/

- Naresh
