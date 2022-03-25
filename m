Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4969A4E7B9B
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbiCYWPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiCYWPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:15:12 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E56427176
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:13:36 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 12so9640142oix.12
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PAdDbobA7ctOVd3F7wClb6JTLruDj5TFIdtnV7HXuO8=;
        b=h55V9kQ5U2X286qcrn/XW1bPCCbK5drMiqQedFn46a7iit4ROK+BInCdGuGHQ+vTqd
         kiNIJGJTdlPf8jdH16R1D7M1ja0XnwWCXX50bLOqZlNy1DqbroREFd2qYtsxRqoGbzKA
         9oMLzUfr97I+5K83Q7v4WFdfHGcrpN8OS28mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAdDbobA7ctOVd3F7wClb6JTLruDj5TFIdtnV7HXuO8=;
        b=jar6RYD+vK6NXX4AmpTXidH1sCsU6j4idC2DY/zO6FUrKUs9bAdhJ5kj/o7MX8nuaJ
         yovAriT5TYoi6Pyn8N2yffcefDlweIBsuPtNi8kijmxZ51o3czcRldBLJFbX+IR3rZTG
         2S+gnw6xxDAyOWUC2iPLCLfqH32WN3I/8qR+2fDvpJeTdumVb1u35R8cWHRPqBe5gg+7
         +TTUJ2TdmxylYZ7zMH65tdGLmvMZiuT8IXzAIY2mJEZVx3FFVbUcGo/NDBOwq8R2j0wB
         fXWTENZfC9n9N5pmxt+ZC9WciW1XY4o3M6S3+jHSVbFwpW8O8VNJzy37Q6lYF2Ip5eJt
         Be+A==
X-Gm-Message-State: AOAM530Lvf0z0tZQDA53+eIjENuUplGZMB3qPocExOPHgobLiDOqwhDi
        H2E6OIWK45QnOBqWXGJKm3pR5E8vC+cjrw==
X-Google-Smtp-Source: ABdhPJzrh3as6EzSlyV4zCifga3mc8DRKXJ3IcSVHDKxmnRkMthzAmI+Lf4flooxoeGxfZh8tqjnfg==
X-Received: by 2002:a05:6808:11c4:b0:2d9:c395:f15e with SMTP id p4-20020a05680811c400b002d9c395f15emr11146862oiv.47.1648246415160;
        Fri, 25 Mar 2022 15:13:35 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id r8-20020a05683001c800b005cdadc2a837sm3203525ota.70.2022.03.25.15.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 15:13:34 -0700 (PDT)
Subject: Re: kselftest: net: tls: hangs
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 16:13:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/22 1:40 AM, Naresh Kamboju wrote:
> While running kselftest net tls test case on Linux next and mainline kernels
> the test case fails at following sub test cases and hangs every time.
> Please investigate this hang issue.
> 
> kconfigs are generated from kselftest-merge config.
> 
> metadata:
>    git_ref: master
>    git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>    git_sha: b61581ae229d8eb9f21f8753be3f4011f7692384
>    git_describe: next-20220323
>    kernel_version: 5.17.0
>    kernel-config: https://builds.tuxbuild.com/26mKij4yB5Q6WUpOyHHEoHLstVJ/config
> 
> Test log link,
> --------------
> # selftests: net: tls
> # TAP version 13
> # 1..502
> # # Starting 502 tests from 14 test cases.
> # #  RUN           global.non_established ...
> # #            OK  global.non_established
> # ok 1 global.non_established
> # #  RUN           global.keysizes ...
> # #            OK  global.keysizes
> <trim>
> 
> # #  RUN           tls.12_aes_gcm.splice_cmsg_to_pipe ...
> # # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
> p[1], NULL, send_len, 0) (10) == -1 (-1)
> # # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
> # # splice_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.12_aes_gcm.splice_cmsg_to_pipe
> # not ok 21 tls.12_aes_gcm.splice_cmsg_to_pipe
> # #  RUN           tls.12_aes_gcm.splice_dec_cmsg_to_pipe ...
> # # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
> send_len, 0) (10) == -1 (-1)
> # # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
> # # splice_dec_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.12_aes_gcm.splice_dec_cmsg_to_pipe
> # not ok 22 tls.12_aes_gcm.splice_dec_cmsg_to_pipe
> # #  RUN           tls.12_aes_gcm.recv_and_splice ...
> # #            OK  tls.12_aes_gcm.recv_and_splice
> 
> <trim>
> 
> # #  RUN           tls.13_aes_gcm.splice_cmsg_to_pipe ...
> # # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
> p[1], NULL, send_len, 0) (10) == -1 (-1)
> # # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
> # # splice_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.13_aes_gcm.splice_cmsg_to_pipe
> # not ok 70 tls.13_aes_gcm.splice_cmsg_to_pipe
> # #  RUN           tls.13_aes_gcm.splice_dec_cmsg_to_pipe ...
> # # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
> send_len, 0) (10) == -1 (-1)
> # # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
> # # splice_dec_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.13_aes_gcm.splice_dec_cmsg_to_pipe
> # not ok 71 tls.13_aes_gcm.splice_dec_cmsg_to_pipe
> 
> 
> <trim>
> 
> # #  RUN           tls.12_chacha.splice_cmsg_to_pipe ...
> # # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
> p[1], NULL, send_len, 0) (10) == -1 (-1)
> # # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
> # # splice_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.12_chacha.splice_cmsg_to_pipe
> # not ok 119 tls.12_chacha.splice_cmsg_to_pipe
> # #  RUN           tls.12_chacha.splice_dec_cmsg_to_pipe ...
> # # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
> send_len, 0) (10) == -1 (-1)
> # # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
> # # splice_dec_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.12_chacha.splice_dec_cmsg_to_pipe
> # not ok 120 tls.12_chacha.splice_dec_cmsg_to_pipe
> 
> <trim>
> 
> # #  RUN           tls.13_chacha.splice_cmsg_to_pipe ...
> # # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
> p[1], NULL, send_len, 0) (10) == -1 (-1)
> # # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
> # # splice_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.13_chacha.splice_cmsg_to_pipe
> # not ok 168 tls.13_chacha.splice_cmsg_to_pipe
> # #  RUN           tls.13_chacha.splice_dec_cmsg_to_pipe ...
> # # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
> send_len, 0) (10) == -1 (-1)
> # # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
> # # splice_dec_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.13_chacha.splice_dec_cmsg_to_pipe
> # not ok 169 tls.13_chacha.splice_dec_cmsg_to_pipe
> 
> <trim>
> 
> # #  RUN           tls.13_sm4_gcm.splice_cmsg_to_pipe ...
> # # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
> p[1], NULL, send_len, 0) (10) == -1 (-1)
> # # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
> # # splice_cmsg_to_pipe: Test terminated by timeout
> # #          FAIL  tls.13_sm4_gcm.splice_cmsg_to_pipe
> # not ok 217 tls.13_sm4_gcm.splice_cmsg_to_pipe
> # #  RUN           tls.13_sm4_gcm.splice_dec_cmsg_to_pipe ...
> # # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
> send_len, 0) (10) == -1 (-1)
> # # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
> [  661.901558] kworker/dying (49) used greatest stack depth: 10576 bytes left

This seems to be the problem perhaps.

Jakub, any thoughts. The last change to tls.c was a while back.

> 
> Test case HANG here.
> 
> Full test log links [1] including boot log and test run log.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 
> https://lkft.validation.linaro.org/scheduler/job/4770773#L2700
> 

thanks,
-- Shuah
thanks,
-- Shuah
