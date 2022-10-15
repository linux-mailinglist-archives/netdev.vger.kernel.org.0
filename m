Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629225FFB48
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJOQuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 12:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJOQuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 12:50:21 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D5F42D68;
        Sat, 15 Oct 2022 09:50:20 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v40-20020a056830092800b00661e37421c2so1380588ott.3;
        Sat, 15 Oct 2022 09:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gaBorpeM8V7m8SAG2YMcD20/4oV3CI8spBrOFUZBCj0=;
        b=itMm9PtcYGZC/S/zNPXxgkiEUfYzw4v/S7eWRU2eYc/c24FX9lES+jOwcoO/nBfTCS
         iBJKTB1za6OkIxvLk0uPiiLvVZFrhB+bbsXwzVOxknrjUsYk8CfLnxjI1M0YuGQ+fdLh
         aJv8tVIvdxFBtjCmohOHpr8pQtKLhefet8sXo9Z6Bli5RvcBLZt+U96pXoxrlE0sogCG
         lNavBRSRRLTV4xlINdXmyNyiJxm/cbTgdSEQezmVbBIMdaZNRV1T0rZdd+KwLI42vNeE
         76GH0rNa3p2IIZTBhnKxQeaUyVEWZjmyE0PgEQKOGJsKfNIqY+Sq/9CO3KD3t+O0Me7Q
         JQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaBorpeM8V7m8SAG2YMcD20/4oV3CI8spBrOFUZBCj0=;
        b=GYtGFXSFKRPAAvbmhrpXkACk6NBdQS7g/sfWUQSaPbItzUkSo447Nm1F1Pxh9IrVht
         oLAfcIXaVcMk38emKTO2tBTjgXOtj8Zl8fn8k6gD3giykNH6f1Oph4sNKKVhX3wjF+ZC
         CYsVFE75DVw4JbLJJJuVrCuUZtxKub211H2dO9/Xh4aIBhs262XLIYE74azcWq+h+p/H
         Sx4Pk6JoX6Boz72OkZOSESrCFCDl9YAZMOSpfv2eMx3z25LLJUDkfROvbyvh69GzjSyU
         L8JTqGzjziVWo6sYIgViysXr8uLDihIeTRIZC7VgCzqXCgEUgfK425At5vbPpk7Dqh2X
         ZVbQ==
X-Gm-Message-State: ACrzQf1H8qgje+StAWqVd6QhCc9YAGJO4q72tyUizajQJTOr4SapQWMQ
        F1YghK8HbZSijL9geiJaqCY=
X-Google-Smtp-Source: AMsMyM41gyen8vcEwtex8EZqZBAb3f7m2MEGHd5U94tNVHrAGDZpxAMyO6GQmsId+IaBnxmuHOuz4Q==
X-Received: by 2002:a9d:d83:0:b0:661:e250:f35f with SMTP id 3-20020a9d0d83000000b00661e250f35fmr1535982ots.102.1665852619400;
        Sat, 15 Oct 2022 09:50:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k25-20020a056830151900b00661ac94f187sm2716112otp.42.2022.10.15.09.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 09:50:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 Oct 2022 09:50:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     guoren@kernel.org
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH] Revert "cpumask: fix checking valid cpu range"
Message-ID: <20221015165017.GA1034513@roeck-us.net>
References: <20221015130548.3634468-1-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221015130548.3634468-1-guoren@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 09:05:48AM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> This reverts commit 78e5a3399421ad79fc024e6d78e2deb7809d26af.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> 
> Let's back this out and retry with a larger clean up in -next.
> 

Unfortunately the revert triggers (or exposes ?) another backtrace.

WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x194/0x976
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-12199-g277163563de8 #1
Hardware name: riscv-virtio,qemu (DT)
epc : __netif_set_xps_queue+0x194/0x976
ra : __netif_set_xps_queue+0x3b0/0x976
epc : c089a664 ra : c089a880 sp : c2515c60
gp : c1d8e760 tp : c2578040 t0 : c364f980
t1 : 00000000 t2 : 00001fff s0 : c2515cd0
s1 : c2515ce4 a0 : c364f940 a1 : 00000000
a2 : c364f940 a3 : 00000000 a4 : c364f950
a5 : c364f890 a6 : 00000003 a7 : 00000000
s2 : 00000001 s3 : c1d382c0 s4 : 00000000
s5 : 00000000 s6 : 00000000 s7 : c364f880
s8 : 00000000 s9 : 00000001 s10: 00000001
s11: 00000000 t3 : 00000018 t4 : 7fd38a0e
t5 : 00000007 t6 : c3639470
status: 00000120 badaddr: 00000000 cause: 00000003
[<c074548a>] virtnet_set_affinity+0x13a/0x1a2
[<c07478de>] virtnet_probe+0x884/0xfdc
[<c063ce9a>] virtio_dev_probe+0x1d6/0x354
[<c0683d6e>] really_probe+0x82/0x214
[<c0683f58>] __driver_probe_device+0x58/0xa2
[<c0683fd2>] driver_probe_device+0x30/0xaa
[<c0684596>] __driver_attach+0x56/0x11c
[<c0681f26>] bus_for_each_dev+0x52/0x90
[<c06837c0>] driver_attach+0x1a/0x22
[<c068331a>] bus_add_driver+0x148/0x1b6
[<c0684d70>] driver_register+0x52/0xea
[<c063c924>] register_virtio_driver+0x1a/0x28
[<c0c2428e>] virtio_net_driver_init+0x7a/0xa6
[<c0002824>] do_one_initcall+0x5e/0x2e2
[<c0c01130>] kernel_init_freeable+0x298/0x306
[<c0aa0ac2>] kernel_init+0x1e/0x10e
[<c0003ad8>] ret_from_exception+0x0/0x10
irq event stamp: 106012
hardirqs last  enabled at (106011): [<c0aa9284>] _raw_spin_unlock_irqrestore+0x54/0x62
hardirqs last disabled at (106012): [<c0007534>] __trace_hardirqs_off+0xc/0x14
softirqs last  enabled at (105764): [<c0886392>] napi_get_frags_check+0x0/0x50
softirqs last disabled at (105758): [<c0886392>] napi_get_frags_check+0x0/0x50

This is the result of commit 854701ba4c39 ("net: fix cpu_max_bits_warn()
usage in netif_attrmask_next{,_and}").

Guenter
