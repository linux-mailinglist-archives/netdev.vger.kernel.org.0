Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77D5AD8C8
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 20:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiIESFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 14:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIESFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 14:05:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1466423178
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 11:05:47 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fs14so4206545pjb.5
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 11:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date;
        bh=hU6BSIh37JagBrR/b/ihJ2hwF433MNIGrx3QKB93uoA=;
        b=jeNeCCCThdpWv95z8pPFaHA7R9PA4DVs14/xDVxbviujS74b6XngOLKpeT3hZuEL1z
         RkJyH7rQefH3e9MVfbE1Dcjq6ohDjsYXuTQrOtQl1tSZ2EdDnZNVlGyH001HceWqwtXc
         cowVP5MQBZcod1T7qWFNwrIrGbEJBhnbQXKtpMTm1fT/bvHXp06jQTdjyOEo2lHgY84r
         TdPT/6iJVTm+d0gHa42Sy1rG2MTARlqTx+TFBgz43rnKxG8nUKBizMT0H6Gw0Mzj/Iyr
         FneB9Ps7c6sEzZsTfgoyjLDrifFocPFb6RkoHsBnZsFq9x9vt/15JY3Q1IbC/gGQrRVN
         lmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hU6BSIh37JagBrR/b/ihJ2hwF433MNIGrx3QKB93uoA=;
        b=hlL8fNsDasYHN1Tua51vyHlatd1uR6vjb3R+F8sZLnR+asFjwt0ooXTNa/k8aYVnCQ
         /otpxzLfW8E5ORm4MJw0m+3Lmn6OlhIXYr3QJsxfPkiG9SCrrBHhPJpYmRdEwCrr4KVK
         CFk4ih5vylTj3vDWUam3ZFG+MfOlEZuigUc7VsFFve3qhLZvO+hEPYd4140sYHbGdwCH
         shlYt1KGYjwlao5b4wxb+mj9nWYVl3ThQrkPbkNzTDkzWGmNnWqGbEnlg4ykH+TA/4/G
         hk4O/NJhyMrB53Z36EEfCv01EMhksnNqs5slwb/5sEKyUYM18MP4ILQ48XDhOKNWx/2n
         PkAw==
X-Gm-Message-State: ACgBeo0IcIKT6oWaltYmRhXW8l1pMbkLb+ynWSgVdmaoDb8UKhFSmqx5
        Yu/goh6ZA7sCVY+0M/te+sM=
X-Google-Smtp-Source: AA6agR4BN0PwbBohrbySjGAw2wRB+AOLTIU9KZRVNRkbt1Zzz48ESd6VMFjUrnotoO40LM7mTnbm0w==
X-Received: by 2002:a17:903:24f:b0:172:7d68:cf1 with SMTP id j15-20020a170903024f00b001727d680cf1mr49477560plh.55.1662401146597;
        Mon, 05 Sep 2022 11:05:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902cece00b0015e8d4eb219sm8016892plg.99.2022.09.05.11.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 11:05:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Sep 2022 11:05:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, qiangqing.zhang@nxp.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 resubmit] fec: Restart PPS after link state change
Message-ID: <20220905180542.GA3685102@roeck-us.net>
References: <20220822081051.7873-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220822081051.7873-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:10:52AM +0200, Csókás Bence wrote:
> On link state change, the controller gets reset,
> causing PPS to drop out and the PHC to lose its
> time and calibration. So we restart it if needed,
> restoring calibration and time registers.
> 
> Changes since v2:
> * Add `fec_ptp_save_state()`/`fec_ptp_restore_state()`
> * Use `ktime_get_real_ns()`
> * Use `BIT()` macro
> Changes since v1:
> * More ECR #define's
> * Stop PPS in `fec_ptp_stop()`
> 
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>

Besides the problem already reported (widespread BUG: sleeping function
called from invalid context at kernel/locking/mutex.c:580, called from
fec_ptp_gettime), this patch results in a crash when trying to boot the
m68k:mcf5208evb emulation in qemu. Reverting this patch fixes the problem.

Guenter

---
*** ILLEGAL INSTRUCTION ***   FORMAT=4
Current process id is 1
BAD KERNEL TRAP: 00000000
PC: [<00000000>] 0x0
SR: 2714  SP: (ptrval)  a2: 40829634
d0: 00002710    d1: 00002010    d2: 40829442    d3: 00002010
d4: 00000000    d5: 402e818a    a0: 00000000    a1: 40824000
Process swapper (pid: 1, task=(ptrval))
Frame format=4 eff addr=400681c2 pc=00000000
Stack from 40831cec:
        40829442 00002010 40831e0c 402e818a 40ba2000 00000008 408295a4 40829000
        401b0c42 40829634 40829420 00000000 40829420 40829000 00000000 00000001
        00000000 401b130e 408295a4 40829702 40347ee0 401ad026 40829420 40347eea
        00000000 40831e0c 402e818a 40ba2000 00000008 40347ee0 40829000 fffffff8
        4082945a 4082945a 40831e14 00000002 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
Call Trace: [<401b0c42>] fec_ptp_gettime+0x3a/0x8c
 [<401b130e>] fec_ptp_save_state+0x12/0x3e
 [<401ad026>] fec_restart+0x5a/0x770
 [<401ae256>] fec_probe+0x74a/0xd06
 [<402c10a0>] strcpy+0x0/0x18
 [<402d3824>] mutex_unlock+0x0/0x40
 [<402d37e4>] mutex_lock+0x0/0x40
 [<401840ba>] uart_get_icount+0x9c/0x198
 [<40193876>] platform_probe+0x22/0x60
 [<40191c52>] really_probe+0xb0/0x2e4
 [<40191f40>] driver_probe_device+0x24/0x112
 [<40192290>] __driver_attach+0x7a/0x200
 [<402b6458>] klist_next+0x0/0x154
 [<40192216>] __driver_attach+0x0/0x200
 [<4036cac2>] do_one_initcall+0x0/0x22c
 [<4019025c>] bus_for_each_dev+0x6a/0xae
 [<40192866>] driver_attach+0x16/0x1c
 [<40192216>] __driver_attach+0x0/0x200
 [<40190b5a>] bus_add_driver+0x154/0x222
 [<40192f9a>] driver_register+0x6c/0xf0
 [<40377d4a>] fec_driver_init+0x0/0x12
 [<40377d58>] fec_driver_init+0xe/0x12
 [<4036cb1e>] do_one_initcall+0x5c/0x22c
 [<402c10a0>] strcpy+0x0/0x18
 [<4036cac2>] do_one_initcall+0x0/0x22c
 [<402c10a0>] strcpy+0x0/0x18
 [<4036cac2>] do_one_initcall+0x0/0x22c
 [<4003d686>] parse_args+0x0/0x390
 [<4036ce8a>] kernel_init_freeable+0x144/0x1a4
 [<4003d686>] parse_args+0x0/0x390
 [<4036ce98>] kernel_init_freeable+0x152/0x1a4
 [<40377d4a>] fec_driver_init+0x0/0x12
 [<400977d6>] kfree+0x0/0x206
 [<402d2288>] schedule+0x0/0x120
 [<4003d686>] parse_args+0x0/0x390
 [<402cb5d0>] _printk+0x0/0x18
 [<402d0bb0>] kernel_init+0x0/0xf0
 [<402d0bca>] kernel_init+0x1a/0xf0
 [<400208d4>] ret_from_kernel_thread+0xc/0x14
Code: 0000 0000 0000 0000 0000 0000 0000 0000 <0000> 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
