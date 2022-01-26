Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34F449D2CE
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiAZTxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiAZTxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:53:00 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7086C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:52:59 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id h14so1885805ybe.12
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9zSWJp0Fy6FqA+Zet4oV3oEAVgKuTmdSI3N4yUr1Zo=;
        b=APwe/5/rRgn+tM1qKfUjUVZYgoqq3GyQLy7HI9UNJdwwRQHr3HbVlhTALUmynm+vdA
         vTILEh6wtCZjRJhE4Ix0KXHy2+jLBTYoSWECArlsMDe1wOc9ezBj6lU4z4+M5EGfWJB0
         CWqrn1CGbS5peKEkyJashhf5SV0doGyic4z6UmNIxApl+GmIcc4mnmSpCF/beQGh5eK9
         EpIvBauBa16SICZfbb+mNMUHICmfbmhhaLp6ka6DFOkEEtNTO82y2TjYc1tAxNolQpqw
         vCrZ3gQ1CYDRWPHUFPP64oKHcXRawF+ttzRLFtC+z/scoaMGr75yTYFKCUZPDfQ6gKX7
         pxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9zSWJp0Fy6FqA+Zet4oV3oEAVgKuTmdSI3N4yUr1Zo=;
        b=hArxe+e/IGZEbsYm0Lr9o+D8vO9mhBGff0Sd9P/Wi0nCU6ifziPKGs3AX2ViOhZu6g
         12WTqE3G3phsG1CUXcHr+gqjmf7NOLxxmDMnbl/CGyyFriv3Aeo+DUAibRxJyA0XYXcn
         a80p/XL/ytZvc3Z7beyOdZNtvK56NtOZnQwi6c1fG3gZKZ8tmP1PcAqZsaYJLbMRw3ov
         niebRNMlLuEdNYOo67+y4p5pnUqApEY0tTRVtWrYyy9fFmETznvraKpQIiVq7gyQmJ0p
         mAagnWqhoP+53KtH/8eYuV+yz8Q287ElIwqZ+LqchphHN/kP6PuYp1uJh+MIfAkPVM/S
         4YbA==
X-Gm-Message-State: AOAM530Jb2i8gWWEB0f+kGApoP/dFjRUA+xWm4YJBQcMpPEpelwb1I+G
        UG47WcBGNLFcQM4HWA5oL3u5MwwYLxV1RcxKcA8=
X-Google-Smtp-Source: ABdhPJyCTtIHpPC0p+6wg0MoLD8YQhJ26tTbKnbl6dwReZCJJ1Ut6gHG58TD+etzmTPafli0XMv1JOSrbbd063HMp4Y=
X-Received: by 2002:a25:53ca:: with SMTP id h193mr678699ybb.285.1643226779056;
 Wed, 26 Jan 2022 11:52:59 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com> <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 26 Jan 2022 11:52:48 -0800
Message-ID: <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
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

On Wed, Jan 26, 2022 at 6:32 AM <xiangxia.m.yue@gmail.com> wrote:
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

NAK.

Keeping resending the same non-sense can't help anything at all.

You really should just use eBPF, with eBPF code you don't even need
to send anything to upstream, you can do whatever you want without
arguing with anyone. It is a win-win. I have no idea why you don't even
get this after wasting so much time.

Thanks.
