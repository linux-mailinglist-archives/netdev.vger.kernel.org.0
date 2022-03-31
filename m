Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F734ED502
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 09:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiCaHu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 03:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiCaHuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 03:50:54 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAAEB7E9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 00:49:07 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2e6650cde1bso244239047b3.12
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 00:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VMe7G7k2F3sJkaSPUU9OrwOFeasEXkAartozpYsWHIc=;
        b=DxzC7NLOdCvcI2Y6Jkn7NtrjSTk/HjFQ5Xoc+vrI1kB+adkprJc036rzhEcY7WIsb4
         hi6VZZ41bmjouckANvMCufUEo9vlehxdqn+3bgc2SyyUQWyntDDxBggQ22Tn22tsTq0u
         RswaETTPPBGNkDOFF6cAE+nsIDQg8cQKSQge3IFXm5blV8hxJw2Eg2YFNto1XLqC5s9c
         bEzWJam1SuIWN+0KSl9Qgcmn+hHK/Fp5JrNZMY6LYrR2oKsP/e168fjnqAGYixSMP340
         jlv98Y8dweJgi8sEeL1SJX1b2LL8VEuDYSx10oZ0Uir7rrQeBm0+JVkcNScDUx8Oxd8w
         HKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VMe7G7k2F3sJkaSPUU9OrwOFeasEXkAartozpYsWHIc=;
        b=r5XwT7G+uFpYgGQTwzpg89fzeYQp7MB10Lt2DTBi5P9kl5xwu4JdU/vQmtkRVnG9MO
         F/gAzgoiikA+6aUT83i6ncPK5+9RqSzeQyY58PQmZA4GgPM6Lffs4FgwhgBH+WRfkjly
         pk4UFjTMijajZpoMoJQmA2BCgoRgl/NJ0YfgjYiA3eUBdh3lwqthb4fdK5nxh29pow0w
         hI4zPWtXBtpam36l8z+vnjtleHn5dX9Jxi0IU8AIky01wj79BmdBmgrIOXavA364P9Vl
         ZljfYyI+nlc+n6gb59vUGE+6rXTncW2B7SXlP5TcPyvBkTDLcxY4kA+iEdFfDFmblB8D
         OsLg==
X-Gm-Message-State: AOAM530s60lIrXXi+VyL3Qf3MZs/ngGgQI+2tvzk9HG2UmuPHGLbGsjg
        ihXxPuJflheunrUjBeA+gPJpf7TK6iMxkJOSMf0ynxbcBipVYY2Z
X-Google-Smtp-Source: ABdhPJwm1aZ7lVTNgZks7FI5cru3hzVpoo623xthni2Gg4cDDSwbU6DVUUuvFoJCZFISyNoBIH7VYUNZV2+9SgkMfcU=
X-Received: by 2002:a81:591:0:b0:2e5:cdb0:9363 with SMTP id
 139-20020a810591000000b002e5cdb09363mr3788408ywf.265.1648712947039; Thu, 31
 Mar 2022 00:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
 <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
 <20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08c5c6f3-e340-eaee-b725-9ec1a4988b84@linuxfoundation.org>
 <CA+G9fYsjP2+20YLbKTFU-4_v+VLq6MfaagjERL9PWETs+sX8Zg@mail.gmail.com> <20220329102649.507bbf2a@kernel.org>
In-Reply-To: <20220329102649.507bbf2a@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 31 Mar 2022 13:18:56 +0530
Message-ID: <CA+G9fYsX=NfUoSXHGEqo_pPqrZ7dxt8+iiQMiAm4dEemNtwq1g@mail.gmail.com>
Subject: Re: kselftest: net: tls: hangs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Netdev" <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
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

> Can you check where the process is stuck and it's state?
> /proc/$pid/stack and run that thru scripts/decode_stacktrace
>

Steps to reproduce:
          - cd /opt/kselftests/default-in-kernel/net
          - ./tls &
          - tests_pid=$!
          - echo $tests_pid
          - sleep 90
          - cat /proc/$tests_pid/stack | tee tests_pid_stack.log
          - cat tests_pid_stack.log

[<0>] do_wait+0x191/0x3a0
[<0>] kernel_wait4+0xaf/0x160
[<0>] __do_sys_wait4+0x85/0x90
[<0>] __x64_sys_wait4+0x1c/0x20
[<0>] do_syscall_64+0x5c/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Detail test log can be found here in this link [1]

I do not see any output from
./scripts/decode_stacktrace.sh  stack-dump.txt


- Naresh

[1] https://lkft.validation.linaro.org/scheduler/job/4812800#L2256
