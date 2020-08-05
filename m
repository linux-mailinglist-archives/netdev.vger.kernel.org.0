Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257EC23D430
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 01:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgHEXef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 19:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHEXee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 19:34:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B4C061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 16:34:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z188so16049798pfc.6
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 16:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9OiiVXTxVhc48oAXKp00ksq24Qk2HVTqscPmiRwM/Hw=;
        b=pLUYdhpAAlfEx5qGEovAgdbjbNkN1nB+/FmwR2K97x/xij3xgLOzbNIXYFChVXAeOV
         lUiK7g/13hw8THcTVMc3DdGRksoM0DTvc5Xzcv5LP0mUv7ZHZEYcHIiTNGkXxXX+AWGX
         +bW/A5+lA3NNeRmSLCON0ajP4DO8rECvItLkZ5URAD8TcVdNgfLoKc3Q+tg5ugw3Dyun
         2Hbi2fGxMHyXJQ0Vfqv6lFpiWNGXQhWu3en72+tf/dHF+rqS6vHPWyNhophMEcy5UjIx
         Sl99JOp/u9dyoh+khDVMo0Z2zgbO340+alfsjPw/WIhlW2FNzHYPlO3GmOJx8qflhb+5
         ziUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9OiiVXTxVhc48oAXKp00ksq24Qk2HVTqscPmiRwM/Hw=;
        b=uTJFuvpHj0cNM/i5Bt1o2BQYDqluyAtKByMsZKnIEBoeMyftO97SYX9T4Vulq3YUXY
         8M8pmmR4EpwTZuYqRAPgk3qXsGAS1rYcuGfARwh9qt5Ktd+sv5QFb7zDTaCmowRXjKNW
         +nbkpJm45gDGzNyeusiYotxSqyYYlAZ5yJbVCLB+hXJtMqlDYcKCa4d6LB7HbDAwH9gm
         R0IeCr45stuHCLu/dlyyA18TjtcGtrj8tLNBLAfqBVhFGwLluBkp3VPtVVVy5ah7/fxW
         mnAszvdU4UADfVRUjA+qBScSAB8AlSgj32A3ahbI3x64CbGr8hCS6fkkd/6bmXHarheD
         PL2g==
X-Gm-Message-State: AOAM530dOvmmr6gJwZ2lOUETDX2Qh/Ht2rpYlhip0hm31zS8H0Cbq0iI
        QnzJVK1QNHt3U62ptUOvoRsa1sGIRlnZgA==
X-Google-Smtp-Source: ABdhPJzVNVlebTbTeFch524xKwprPUvNiTMhQpRBuaSe8d8PLarleX/W76WsXoSLxi/GgxxaHhvRCA==
X-Received: by 2002:a62:1c0f:: with SMTP id c15mr5411876pfc.235.1596670473468;
        Wed, 05 Aug 2020 16:34:33 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id gm9sm4145975pjb.12.2020.08.05.16.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 16:34:33 -0700 (PDT)
Date:   Wed, 5 Aug 2020 16:34:25 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
Message-ID: <20200805163425.6c13ef11@hermes.lan>
In-Reply-To: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 16:25:23 +0200
Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:

> Hi,
> 
> We're seeing occasional lockups on an embedded board (running an -rt
> kernel), which I believe I've tracked down to the
> 
>             if (!rtnl_trylock())
>                     return restart_syscall();
> 
> in net/bridge/br_sysfs_br.c. The problem is that some SCHED_FIFO task
> writes a "1" to the /sys/class/net/foo/bridge/flush file, while some
> lower-priority SCHED_FIFO task happens to hold rtnl_lock(). When that
> happens, the higher-priority task is stuck in an eternal ERESTARTNOINTR
> loop, and the lower-priority task never gets runtime and thus cannot
> release the lock.
> 
> I've written a script that rather quickly reproduces this both on our
> target and my desktop machine (pinning everything on one CPU to emulate
> the uni-processor board), see below. Also, with this hacky patch

There is a reason for the trylock, it works around a priority inversion.

The real problem is expecting a SCHED_FIFO task to be safe with this
kind of network operation.

