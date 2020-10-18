Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7BF291662
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 10:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgJRIC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 04:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgJRICy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 04:02:54 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9083BC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 01:02:54 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id l16so7269333ilj.9
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 01:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGV1mi6BRZYJ4sedatrAUzZXew/QykKVCr+dciyYk1M=;
        b=qB7Z04O17cqGPcinasEHPTSke1Xa+XJgPP1yxHKr6TLq+0PIkLbg3wIJIzxyw8AoY5
         bYM+RT3x36M03gzU0TrUaK9TbAeDYWsBOBEhxSoXPvW2MAJPD0jpm+H8EQMAr4NLp3BG
         nEB9m+xqdiNQOl4EFjs57h4gSj+VjDH1aTHXM3WRdg0Vsby3dXN3QTqYLAPjW97YZJjQ
         0d1sNf8a88yKsKnCeRcM4McnQ0fI1FamMpVp7ccO22hPa7dT20Ts1OJs2Qt8Z02Yu/oI
         xZuWXenaOEAteEnRIPwcp+vBxHXJIrhxALJSgJX2AzIt3mNfw4Gbfs39pDVtWSYHBZjb
         NwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGV1mi6BRZYJ4sedatrAUzZXew/QykKVCr+dciyYk1M=;
        b=LMxqNsWtas1Zx50lCBCBbTJzt71F5Zl2NMcoz7QwIjX/yKmxBK6cpqlscS14fs7i2o
         hjD97+JJdKi0GdBC/FZtoxBSNXtsOpsxZeTCFW60yP7JgeAoDH6eVqdzQhXfRx4zf9/4
         rmirr8d93DgFU40wVkh8aezSij6pj5mLS/0tBqG5h4kmQEAVOzRlq4F7Nj+cQHbSgMvb
         zBBAEckfcg/diBxtn9oMbJl2mXFwYsUbuwTZN6OlIy/GeKs7nUCMVe0L61Wvh/c9O+16
         i9b4mM2emZZ56QeC7ZHkIayUaz4nRjbrqRRLLEIktEBmyvPIR1fCkFoSl8VsLL5s2n7W
         2afw==
X-Gm-Message-State: AOAM533bwAZUSRpcyHHMesLSAWnq2ktnHJZr/CyeQqR2E88rrMqbE95q
        ckivwTuhUKBzFJ8yzAJKnYjQ6RyE9iJgp8E0fYuTNA==
X-Google-Smtp-Source: ABdhPJxeOfKRvZ53Zpo1xQpI/L17AwFJlSjvGsVCUXrYhW0juy7XOjv5fM4LXlFxfsGbHGhzEb7mYvYZhMuZzaYiXjo=
X-Received: by 2002:a92:c213:: with SMTP id j19mr7824067ilo.205.1603008173595;
 Sun, 18 Oct 2020 01:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com> <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 18 Oct 2020 10:02:41 +0200
Message-ID: <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
Subject: Re: Remove __napi_schedule_irqoff?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 1:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 17 Oct 2020 15:45:57 +0200 Heiner Kallweit wrote:
> > When __napi_schedule_irqoff was added with bc9ad166e38a
> > ("net: introduce napi_schedule_irqoff()") the commit message stated:
> > "Many NIC drivers can use it from their hard IRQ handler instead of
> > generic variant."
>
> Eric, do you think it still matters? Does it matter on x86?
>
> > It turned out that this most of the time isn't safe in certain
> > configurations:
> > - if CONFIG_PREEMPT_RT is set
> > - if command line parameter threadirqs is set
> >
> > Having said that drivers are being switched back to __napi_schedule(),
> > see e.g. patch in [0] and related discussion. I thought about a
> > __napi_schedule version checking dynamically whether interrupts are
> > disabled. But checking e.g. variable force_irqthreads also comes at
> > a cost, so that we may not see a benefit compared to calling
> > local_irq_save/local_irq_restore.
> >
> > If more or less all users have to switch back, then the question is
> > whether we should remove __napi_schedule_irqoff.
> > Instead of touching all users we could make  __napi_schedule_irqoff
> > an alias for __napi_schedule for now.
> >
> > [0] https://lkml.org/lkml/2020/10/8/706
>
> We're effectively calling raise_softirq_irqoff() from IRQ handlers,
> with force_irqthreads == true that's no longer legal.
>
> Thomas - is the expectation that IRQ handlers never assume they have
> IRQs disabled going forward? We don't have any performance numbers
> but if I'm reading Agner's tables right POPF is 18 cycles on Broadwell.
> Is PUSHF/POPF too cheap to bother?
>
> Otherwise a non-solution could be to make IRQ_FORCED_THREADING
> configurable.

I have to say I do not understand why we want to defer to a thread the
hard IRQ that we use in NAPI model.

Whole point of NAPI was to keep hard irq handler very short.

We should focus on transferring the NAPI work (potentially disrupting
) to a thread context, instead of the very minor hard irq trigger.
