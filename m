Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF5D3012A3
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAWD2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbhAWD21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 22:28:27 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E9DC06174A;
        Fri, 22 Jan 2021 19:27:47 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 30so5139912pgr.6;
        Fri, 22 Jan 2021 19:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y63ezxhE9y61i4ONjRBHzW6xiIvx1qUMUf4Z/Rhvgp0=;
        b=JBiEK2Sr+NPccQrh4kmyjqK1PO9wHEgrQeEE1SIDCJkGCSZ0yraYOoJsGQvf5NVxe7
         fwhUE4d6jUG3uUncgwndLpglX9gftVNiw9JC9M6L0e+sCbAinWsYPyXzeUR2IVFuZQXS
         VZpd+pJvaFJGVKrFt1narbL5mIm8dTgAovCEQFFahaVQygOGmCMqnnpO3d1GZRf+rUjh
         fazrMXNvZJpK51CIkwvg7iUhkoR3vc1Ykod3mbklZCIiwkyrUnpF6AGXpk1z3iOEEPzP
         WF3/vYGsqaYM02CU5SpXtLltlsZgTuiCxl6Zsg1pS56X1xWMUmoG35ycGBu/TolaHQ5H
         9XKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y63ezxhE9y61i4ONjRBHzW6xiIvx1qUMUf4Z/Rhvgp0=;
        b=HXB1emMJz41O5KkikdE5m+W9hDtnqM+Yu1lC/I5b0v/r421MDPpk4j8yMg/EMdkEtP
         gbzluP2ZBjp4r+wQPnlDflnPR2BCvRri84LiBVzEI5YVDLJZ0+geawx/EsdGlnhpEp0F
         OUWkx5r6O2Z5mbTBBJwQ5Eke6DlKOvrHYC0gL84+K83zIKNWnH56g29uJZwdbfx6sn92
         qcnHrJNF+RA+KveAqopJkdY1jpWfXe3EHdmdgFHwGAV8rRKwYpSFZv+am5urEhes6ed9
         xCWq/rDUbT2sqoPw8RqaAjq5Q1VoCE0TBnuzsZUWvqZmYq6o8euaPDjadUVtoCDw40hw
         k//Q==
X-Gm-Message-State: AOAM533QvY7uOJgXcU6ubjSTTjxOVTYcix1sI8FM/BALjrxqzPN6MZlp
        PJO9lTKvJVBjBouylvFWONnQ7kMBeu8Uhgqedf8=
X-Google-Smtp-Source: ABdhPJxvXtRwLuJMLaToEnLo+EFA8YdlaLpxjwRJMr3vlzSIF/5tghE/vDuJ4l0UgbBtQ89IuFYIjiyp1P1GOPZ9cgw=
X-Received: by 2002:a63:2265:: with SMTP id t37mr387298pgm.336.1611372466644;
 Fri, 22 Jan 2021 19:27:46 -0800 (PST)
MIME-Version: 1.0
References: <c099ad52-0c2c-b886-bae2-c64bd8626452@ozlabs.ru>
 <CACT4Y+Z+kwPM=WUzJ-e359PWeLLqmF0w4Yxp1spzZ=+J0ekrag@mail.gmail.com>
 <6af41136-4344-73da-f821-e831674be473@i-love.sakura.ne.jp>
 <70d427e8-7281-0aae-c524-813d73eca2d7@ozlabs.ru> <CACT4Y+bqidtwh1HUFFoyyKyVy0jnwrzhVBgqmU+T9sN1yPMO=g@mail.gmail.com>
 <eb71cc37-afbd-5446-6305-8c7abcc6e91f@i-love.sakura.ne.jp>
 <6eaafbd8-1c10-75df-75ae-9afa0861f69b@i-love.sakura.ne.jp>
 <e4767b84-05a4-07c0-811b-b3a08cad2f43@ozlabs.ru> <b9e41542-5c93-9d37-d99d-acde6fb01fa1@i-love.sakura.ne.jp>
In-Reply-To: <b9e41542-5c93-9d37-d99d-acde6fb01fa1@i-love.sakura.ne.jp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 22 Jan 2021 19:27:35 -0800
Message-ID: <CAM_iQpU3P03+2QL2iDbVQSyqwHb6DXi96eXNEm3kDgFWjqAKHg@mail.gmail.com>
Subject: Re: BPF: unbounded bpf_map_free_deferred problem
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 4:42 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Hello, BPF developers.
>
> Alexey Kardashevskiy is reporting that system_wq gets stuck due to flooding of
> unbounded bpf_map_free_deferred work. Use of WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND
> workqueue did not solve this problem. Is it possible that a refcount leak somewhere
> preventing bpf_map_free_deferred from completing? Please see
> https://lkml.kernel.org/r/CACT4Y+Z+kwPM=WUzJ-e359PWeLLqmF0w4Yxp1spzZ=+J0ekrag@mail.gmail.com .
>

Which map does the reproducer create? And where exactly do
those work block on?

Different map->ops->map_free() waits for different reasons,
for example, htab_map_free() waits for flying htab_elem_free_rcu().
I can't immediately see how they could wait for each other, if this
is what you meant above.

Thanks.
