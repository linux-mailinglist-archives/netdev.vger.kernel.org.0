Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AACC4E6F11
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 08:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354511AbiCYHmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 03:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354324AbiCYHmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 03:42:09 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805E9CA0CD
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:40:34 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id o5so12644712ybe.2
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wlrec6Y+LyRBdGVxeVK4iHp5+fm9Y0IJxLyRmKge+xA=;
        b=h/+3jokb0P4AYkdzHUOOtZcj8eFwEU103K8GOY4KMELzx3erofGSdigB5qSclXsMF6
         nXS/Oe1MDUaPQny+pMrBkvuCpDuLh6R+Qwgtbvvg8vrjV03rvpF7v44iAC0R5E+uyVel
         cxBIMvN5C4DGedCad/EjsbSHB1OlR5nMW6VfcC30aPTJkm02XIF3TWjOq5AAyCrcTJ68
         aODITlpfzPQKnPYJUihVFoY4joQIqSjd07JaImEv2jqnTjgu/YfJQ3ZFYpI/XW4zYMhx
         YVcHp49t1wWeHckI47QpfbEOYgtzdXxBxalXYZz/lpxkxHJi7BDR/c0bX6ES4XQ3fX2m
         Pq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wlrec6Y+LyRBdGVxeVK4iHp5+fm9Y0IJxLyRmKge+xA=;
        b=oUqie+uCybY6SjPOQjk2meFZ7K+fUH1gz6mLBbg51adnWilutptukR0tmAx35Q9Hxo
         38bpRWYDAl34UubNCUoQs8HwZozBjst+4RKXbrtVjQUxqs7+900f2iKlJ5aSftY2iTBe
         OaZYgRci2pkeHk1S64WUhS3MtUpm8jOVwxdRaNVvuONRLaFVUFL/GmG9bo30Bjy/oMup
         CLv7w1YAYs9l6alazwUqRVA5ihVf3jqG/hhLpkCfF7FgVUhCr0K6H4xPo0mdXpMNAc1+
         sZx7jx+77jJZM+h8AqSYfJtGnjmnI7VtKeyZ3grUo7/Zp6LSGRuTUHBqdukuflX/Ez8f
         YG7A==
X-Gm-Message-State: AOAM532WSkawQaOyHv1f1EpsqCbSN0TOikvk/UyqKPMHa1rNUPHcBOgi
        bpnAkfdt6GqI7JuPjfV4Q2f2ddwXqjeeTNBqPszRQA==
X-Google-Smtp-Source: ABdhPJyfvYJFDjUOYwwacT/jY+etlozfKr130Ts6uO4Uvp9gtSLhWQ2kvSZVLktH7T9+5J/pvTrFUOx0DmzpQF3xQTc=
X-Received: by 2002:a5b:892:0:b0:633:ba98:d566 with SMTP id
 e18-20020a5b0892000000b00633ba98d566mr8430115ybq.128.1648194033598; Fri, 25
 Mar 2022 00:40:33 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 25 Mar 2022 13:10:22 +0530
Message-ID: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
Subject: kselftest: net: tls: hangs
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftest net tls test case on Linux next and mainline kernels
the test case fails at following sub test cases and hangs every time.
Please investigate this hang issue.

kconfigs are generated from kselftest-merge config.

metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git_sha: b61581ae229d8eb9f21f8753be3f4011f7692384
  git_describe: next-20220323
  kernel_version: 5.17.0
  kernel-config: https://builds.tuxbuild.com/26mKij4yB5Q6WUpOyHHEoHLstVJ/config

Test log link,
--------------
# selftests: net: tls
# TAP version 13
# 1..502
# # Starting 502 tests from 14 test cases.
# #  RUN           global.non_established ...
# #            OK  global.non_established
# ok 1 global.non_established
# #  RUN           global.keysizes ...
# #            OK  global.keysizes
<trim>

# #  RUN           tls.12_aes_gcm.splice_cmsg_to_pipe ...
# # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
p[1], NULL, send_len, 0) (10) == -1 (-1)
# # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
# # splice_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.12_aes_gcm.splice_cmsg_to_pipe
# not ok 21 tls.12_aes_gcm.splice_cmsg_to_pipe
# #  RUN           tls.12_aes_gcm.splice_dec_cmsg_to_pipe ...
# # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
send_len, 0) (10) == -1 (-1)
# # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
# # splice_dec_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.12_aes_gcm.splice_dec_cmsg_to_pipe
# not ok 22 tls.12_aes_gcm.splice_dec_cmsg_to_pipe
# #  RUN           tls.12_aes_gcm.recv_and_splice ...
# #            OK  tls.12_aes_gcm.recv_and_splice

<trim>

# #  RUN           tls.13_aes_gcm.splice_cmsg_to_pipe ...
# # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
p[1], NULL, send_len, 0) (10) == -1 (-1)
# # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
# # splice_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.13_aes_gcm.splice_cmsg_to_pipe
# not ok 70 tls.13_aes_gcm.splice_cmsg_to_pipe
# #  RUN           tls.13_aes_gcm.splice_dec_cmsg_to_pipe ...
# # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
send_len, 0) (10) == -1 (-1)
# # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
# # splice_dec_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.13_aes_gcm.splice_dec_cmsg_to_pipe
# not ok 71 tls.13_aes_gcm.splice_dec_cmsg_to_pipe


<trim>

# #  RUN           tls.12_chacha.splice_cmsg_to_pipe ...
# # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
p[1], NULL, send_len, 0) (10) == -1 (-1)
# # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
# # splice_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.12_chacha.splice_cmsg_to_pipe
# not ok 119 tls.12_chacha.splice_cmsg_to_pipe
# #  RUN           tls.12_chacha.splice_dec_cmsg_to_pipe ...
# # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
send_len, 0) (10) == -1 (-1)
# # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
# # splice_dec_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.12_chacha.splice_dec_cmsg_to_pipe
# not ok 120 tls.12_chacha.splice_dec_cmsg_to_pipe

<trim>

# #  RUN           tls.13_chacha.splice_cmsg_to_pipe ...
# # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
p[1], NULL, send_len, 0) (10) == -1 (-1)
# # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
# # splice_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.13_chacha.splice_cmsg_to_pipe
# not ok 168 tls.13_chacha.splice_cmsg_to_pipe
# #  RUN           tls.13_chacha.splice_dec_cmsg_to_pipe ...
# # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
send_len, 0) (10) == -1 (-1)
# # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
# # splice_dec_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.13_chacha.splice_dec_cmsg_to_pipe
# not ok 169 tls.13_chacha.splice_dec_cmsg_to_pipe

<trim>

# #  RUN           tls.13_sm4_gcm.splice_cmsg_to_pipe ...
# # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
p[1], NULL, send_len, 0) (10) == -1 (-1)
# # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
# # splice_cmsg_to_pipe: Test terminated by timeout
# #          FAIL  tls.13_sm4_gcm.splice_cmsg_to_pipe
# not ok 217 tls.13_sm4_gcm.splice_cmsg_to_pipe
# #  RUN           tls.13_sm4_gcm.splice_dec_cmsg_to_pipe ...
# # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
send_len, 0) (10) == -1 (-1)
# # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
[  661.901558] kworker/dying (49) used greatest stack depth: 10576 bytes left

Test case HANG here.

Full test log links [1] including boot log and test run log.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org

https://lkft.validation.linaro.org/scheduler/job/4770773#L2700
