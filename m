Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655D44459F0
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhKDStB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhKDStA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 14:49:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2BDC061205
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 11:46:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p18so8686303plf.13
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 11:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZRCurcnAWlfcIEIhKEcHpG6APnIk0vWAzCbgW8z74I=;
        b=uH/jS2pXU8+Dx5lWubYytMer/C5V/1X14Bd5IfnS5fUDR3XBRv+7fBQQJwg6g6g0aj
         1XPh2SaIBvoa01RrWOHZO7EFonhxf5w9D4Uy3AhYUknrH2vHYs4mQRaJE2mUzqH9G3Bi
         pJnAq2AgTdQ8y63e4JJx/7Ekid/PUdc8kXH3OYZFnfCV+zSt38giw3DFP+IVDPH5wEfv
         P+1Qx5EOjZ6cM5H7LZ5UIvtpTIIYJk7GDutSSODCvVGddWu8pcQTStxTnaZPTydo2Bh3
         6JJc+CTRfyBTipZd5ooXG5ODVkF6KeDKkFIJ0DNAfox8usWEIcNUvY++smWCTM5nCAVH
         wNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZRCurcnAWlfcIEIhKEcHpG6APnIk0vWAzCbgW8z74I=;
        b=4UyXqEwPjIFUY/nAt7y5wCjelDen9WS3geumc10haPmpffox+lSXHdtMd/YyraZVAc
         dLD1TwVDdQCb3OJSa2wkW7/qtbqXriOREofOfjOVszQ/yqC9M1vZ7G835jOdjSKWQ/Zp
         qdJ6TYwnCG0lwFYwLemHIfRQTMkGo982d4v2Wo8DVmvJ9Rpkq8iVBB8ha2RExNQIL5tF
         GlgwOpfGlODGHn9bZIdNogueUcqAdrZ1ZUSIH3c5Q/PBayjEBDrmw2YADP7Ur8jqep9Z
         MjTpwdAH/nqJ9WaqcCM8ILFswaJ1+eHyLiW9utv9S4mwPi9/TDAIgJL5c2s6dfGzAnQr
         vjRA==
X-Gm-Message-State: AOAM530ut4ZCWsy7EtOLknqLWjg68OZozaRsuKznaDZfB7q+pvUQotwk
        aTpgWrtIvLUeIjBcBHp6hMZezT4SR/g7jK1a8kf5rA==
X-Google-Smtp-Source: ABdhPJwCR7/sViRZj+ZMPCbfgHTih5igO1NmnmR9fxCChoxweHr2wNdJG9+mCW6rOYw0WM0ZsAp4pjFd8JWfIk87quQ=
X-Received: by 2002:a17:902:e890:b0:142:f3:7bf7 with SMTP id
 w16-20020a170902e89000b0014200f37bf7mr21229752plg.87.1636051581383; Thu, 04
 Nov 2021 11:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211104010548.1107405-1-benl@squareup.com> <20211104010548.1107405-2-benl@squareup.com>
In-Reply-To: <20211104010548.1107405-2-benl@squareup.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 4 Nov 2021 19:57:02 +0100
Message-ID: <CAMZdPi8SnET8x0CBOyzSNcXroy=ctb_k-qE=bqpx_8027vVTTA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] wcn36xx: populate band before determining rate on RX
To:     Benjamin Li <benl@squareup.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Nov 2021 at 02:05, Benjamin Li <benl@squareup.com> wrote:
>
> status.band is used in determination of status.rate -- for 5GHz on legacy
> rates there is a linear shift between the BD descriptor's rate field and
> the wcn36xx driver's rate table (wcn_5ghz_rates).
>
> We have a special clause to populate status.band for hardware scan offload
> frames. However, this block occurs after status.rate is already populated.
> Correctly handle this dependency by moving the band block before the rate
> block.
>
> This patch addresses kernel warnings & missing scan results for 5GHz APs
> that send their beacons/probe responses at the higher four legacy rates
> (24-54 Mbps), when using hardware scan offload:
>
>   ------------[ cut here ]------------
>   WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:4532 ieee80211_rx_napi+0x744/0x8d8
>   Modules linked in: wcn36xx [...]
>   CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         4.19.107-g73909fa #1
>   Hardware name: Square, Inc. T2 (all variants) (DT)
>   Call trace:
>   dump_backtrace+0x0/0x148
>   show_stack+0x14/0x1c
>   dump_stack+0xb8/0xf0
>   __warn+0x2ac/0x2d8
>   warn_slowpath_null+0x44/0x54
>   ieee80211_rx_napi+0x744/0x8d8
>   ieee80211_tasklet_handler+0xa4/0xe0
>   tasklet_action_common+0xe0/0x118
>   tasklet_action+0x20/0x28
>   __do_softirq+0x108/0x1ec
>   irq_exit+0xd4/0xd8
>   __handle_domain_irq+0x84/0xbc
>   gic_handle_irq+0x4c/0xb8
>   el1_irq+0xe8/0x190
>   lpm_cpuidle_enter+0x220/0x260
>   cpuidle_enter_state+0x114/0x1c0
>   cpuidle_enter+0x34/0x48
>   do_idle+0x150/0x268
>   cpu_startup_entry+0x20/0x24
>   rest_init+0xd4/0xe0
>   start_kernel+0x398/0x430
>   ---[ end trace ae28cb759352b403 ]---
>
> Fixes: 8a27ca394782 ("wcn36xx: Correct band/freq reporting on RX")
> Signed-off-by: Benjamin Li <benl@squareup.com>

Tested-by: Loic Poulain <loic.poulain@linaro.org>
