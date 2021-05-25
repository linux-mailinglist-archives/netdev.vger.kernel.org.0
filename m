Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8238F9E3
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 07:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhEYFXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 01:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhEYFXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 01:23:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4FC061574;
        Mon, 24 May 2021 22:22:13 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x18so18385556pfi.9;
        Mon, 24 May 2021 22:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vsVktyDW5h8IILopVFPzLm4hVr+vzw6YbWqAMHceFQg=;
        b=TfBUb2lpGBoNV/dpugCIcHC7WuPlWxRdPjpyBKlAFG1KmNfQX5iK2twzkxkCjY9uL3
         6ka9me9ctOFKwGRRBJgKwD+1/jdkl8+NmaZQ5I6qeSYdrSJkiOpLvD++5bdeK1h963an
         ZAqX4+ztUZflZDVvsi/M0odUfpI0JJ1yWlk+9gGnlWXMtPT3B03tVKnTLUnoEsHeGWHP
         PfFYxfWmgl4de5O2cKI3GUvPMd4A9QmVfJP0pdzm83U3HySDslIuWopeHRFXVqqAT93e
         8YsfdTChPVCWfwJjKqJSzxnNTlhxmBxJ4akoWPPjmWCBd16EoSnnn1RAKH/Tl/Pr8uMk
         TFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vsVktyDW5h8IILopVFPzLm4hVr+vzw6YbWqAMHceFQg=;
        b=iBne4DYvua8Oc8l2xqz4lGejvsux0LuoYFv5gk3D8kYTY/3MEl7q/FmKau1x8HPbv7
         FNLTzqAeyCSLdbRtiwuXM2KOsugo75Zs5W85BAKlBNBkCJ7BbafQPvMffiy9cls0JRe4
         3LjOF4J6QuHolFwLFCspuKRL6FD10sIdtSHT2v/hTFNnBt9/O2nVuS9uDpNi79rrpCp6
         rnW6iOBIVzT52Zuw8Ev9W5yXDfcMZssmzhw3TO1i4xtGOxiyK4QYPbTCPjDB5QGEzQ5z
         JHw/M6yqFwBvn7mNuc0AZ6rYaT8Cwj3DrWE1YZELG9uwtKI0oeVS11VZEnFHW40dG9N+
         pJwg==
X-Gm-Message-State: AOAM531FAmReoMzbvao9r7sYu3U+bKRHkLLCYIDOijqgpsK5xhQO7HMs
        yAsOD2suIbI83cqnitHM5X/5WdhRe7CB5B+6mhM=
X-Google-Smtp-Source: ABdhPJxTk1REDdxT1XgsO/5DTtqQMepwF0tlGoQiUOVWdcYCIX1y+bcKF0wBZSQHebivBecRRWJJW3tYbSivqfbtxn4=
X-Received: by 2002:a62:ee07:0:b029:2d8:dea3:7892 with SMTP id
 e7-20020a62ee070000b02902d8dea37892mr28419866pfi.78.1621920132546; Mon, 24
 May 2021 22:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CACAyw9-7dPx1vLNQeYP9Zqx=OwNcd2t1VK3XGD_aUZZG-twrOg@mail.gmail.com>
 <CAADnVQLqa6skQKsUK=LO5JDZr8xM_rwZPOgA1F39UQRim1P8vw@mail.gmail.com> <CAEf4Bza2cupmVZZRx4yWOQBQ7fnaw5pwCQJx9j1HWp=0eUiA1A@mail.gmail.com>
In-Reply-To: <CAEf4Bza2cupmVZZRx4yWOQBQ7fnaw5pwCQJx9j1HWp=0eUiA1A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 24 May 2021 22:22:01 -0700
Message-ID: <CAM_iQpXn8KyLtApiJOkjKfrhadeG-j0Z+QOBS6SFJjs1as0ZQg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 12:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> I second the use of BPF_PROG_TEST_RUN (a.k.a. BPF_PROG_RUN now) to
> "mirror" such APIs to user-space. We have so much BPF-side

Except the expiration time is stored in user-space too if you just
use user-space timers to trigger BPF_PROG_TEST_RUN.
Modifying expiration based on its current value in timer callbacks
is very common. For example in conntrack use case, we want the
GC timer to run sooner in the next run if we get certain amount of
expired items in current run.


> functionality and APIs that reflecting all of that with special
> user-space-facing BPF commands is becoming quite impractical. E.g., a
> long time ago there was a proposal to add commands to push data to BPF
> ringbuf from user-space for all kinds of testing scenarios. We never
> did that because no one bothered enough, but now I'd advocate that a
> small custom BPF program that is single-shot through BPF_PROG_RUN is a
> better way to do this. Similarly for timers and whatever other
> functionality. By doing everything from BPF program we also side-step
> potential subtle differences in semantics between BPF-side and
> user-space-side.

I am confused about what you are saying, because we can already
trigger BPF_PROG_RUN with a user-space timer for a single shot,
with the current kernel, without any modification. So this sounds like
you are against adding any timer on the eBPF side, but on the other
hand, you are secoding to Alexei's patch... I am completely lost.

Very clearly, whatever you described as "single shot" is not what we
want from any perspective.

Thanks.
