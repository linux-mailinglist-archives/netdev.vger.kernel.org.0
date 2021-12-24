Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C7A47F0C0
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhLXT25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLXT25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:28:57 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC815C061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 11:28:56 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d10so28210320ybn.0
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 11:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WhJnMHcEgS/JsiXIwx0xpw5OXOcZlOqXNjiWSM58NRU=;
        b=ACSonXQcx2YuqoO4WulfoVCz4SXM8yLosiOjS/HTjyp9O4wwTjFGXhQpiWOKuIdX/y
         sS7A5/X5QqtQUW/BH/fFhKxbFG1IHSzkm0seHzGLossUMQP9L+4q9G0g1PO8RH2masrY
         bb0m6js3DcDhmQgghZpAmjSOmpM4rUzJp8Bw4Kg4u4kjDxSgTvvyyettMrZzCoezWtL3
         XotA4wuScGZszhvUW9VfDI242hs8n4j4iG++EhvhuTiAPeOu0IZ+a6LcwRUT5HsbOUTQ
         9WNgHf96s8rLLJe34aRXXWtnSWr8xvdRwweGwZq3yZaVyeAYB+v4aoRSz8LD2a420lgU
         TARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WhJnMHcEgS/JsiXIwx0xpw5OXOcZlOqXNjiWSM58NRU=;
        b=4zlwjI93UTnrho/awYUi8wIE/4Q0llm8pPgKUVMVw+ytB77KbdHRCXRSuJj5sjvTsN
         iXEEuK+E2NxUGbQk62QbleD8Yz3NkFMq30l7Vtp6JHDcFXxQolYGQ18dAh3IeVFPQC3f
         OXlez+NdKPmFcRSfL4yV9XVT9zZA4D0BOG1j9WOp/0LNwGztcWsKJtX/3IZuxREYzfiV
         4rETGGP1mzjfpmg7MNyEF6uUn1+1Hxcv3RjjXmabUfcbQ+M1/ctQ/7fiVokNyeHkdvde
         TBK+r6giHmXoIH3Xn01/UEGAacuUN2SsZUcp1cSjanvat50C70dOj2vHSrlsx+igQXe5
         Tp2A==
X-Gm-Message-State: AOAM533Vp9Vtzkmty3esqOCgtvoUSWdGhXQI+4JHhhbSjLM8kow4QhJs
        H1Npn++H8SUtEZ5pc0w3O8ktO3ibe3eNUoL60Kw=
X-Google-Smtp-Source: ABdhPJwWI9fycWSV91B+dtzXYAUSbXweD3oMNr8vJKhx5SK3KCOjIWykLuH4wBG5rIWAF1t+6hv9vLVmHH1eDkYtgQA=
X-Received: by 2002:a25:e686:: with SMTP id d128mr3039318ybh.740.1640374136080;
 Fri, 24 Dec 2021 11:28:56 -0800 (PST)
MIME-Version: 1.0
References: <20211224164926.80733-1-xiangxia.m.yue@gmail.com> <20211224164926.80733-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211224164926.80733-3-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 24 Dec 2021 11:28:45 -0800
Message-ID: <CAM_iQpUhNmmxyPXjyRBKzjVkreu0WXvoyOTdxT0pdjUBsFkx6A@mail.gmail.com>
Subject: Re: [net-next v7 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 8:49 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch allows user to select queue_mapping, range
> from A to B. And user can use skbhash, cgroup classid
> and cpuid to select Tx queues. Then we can load balance
> packets from A to B queue. The range is an unsigned 16bit
> value in decimal format.
>
> $ tc filter ... action skbedit queue_mapping skbhash A B
>
> "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> is enhanced with flags:
> * SKBEDIT_F_TXQ_SKBHASH
> * SKBEDIT_F_TXQ_CLASSID
> * SKBEDIT_F_TXQ_CPUID

NACK.

These values can either obtained from user-space, or is nonsense
at all.

Sorry, we don't accept enforcing such bad policies in kernel. Please
drop this patch.

Thanks.
