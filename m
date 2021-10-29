Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DAD43FFBE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhJ2Pol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhJ2Poj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:44:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58311C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 08:42:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so10872326pji.5
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 08:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kkIaNAWrV0g1tlwIyobLQ2owOjHhSsT7Vz4+dBANidw=;
        b=NbgEkhmDu0A6F9mCzWFqCA5YwVmtDO+9Dx2bjqjwnUV0YUVPIMukasaHXGyNMCdYyH
         SuRAxANAc3rzaNUfiL/6F+ts/fHLX1SCgS8D1/EfafFwa34vf2DrhdnxgR8j468xobH+
         jKkELHDoj5+WixbfOVFzlDjldqc4QDIDewSi/isDjE2v4bAITzbCXjys/RVgX9Krghka
         7WBucxCZ0dvd8ANPno5Kl7sTJ0P5fjUP8j7l3otuYEY4zdbMnBirKCgo0lqw/ZuVvx1e
         f9JHlFN24Kf6/IRKG3l+roHbomMOROTumSamNfosY78HxSZ/xC1OkNPnF9Y3MGnExG+l
         edkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kkIaNAWrV0g1tlwIyobLQ2owOjHhSsT7Vz4+dBANidw=;
        b=hiO/FCmQZq8fCW1Mj+EouAQsDrXrUwzlpI6m77W5Ik/FL55t8l1EMhsKLrVocfLCXA
         g/3flsaBM+PVHsZwgGQLweOmsDRhBxv0a6XnboBsvY2WjRfbxiR0A+LZrcTGsGe5fY8Z
         310ZDpzWqNATnsCKQbTvkZiO4c1Y3RQmxMPbj8aOkb99ZKkTQqnTkDQayMfr9s1fHXPN
         8uir0HAxLRpvxn9yKxVxHYTLySBBnL6hcUI2KvYPfi3KEWM+OC+jGjxS5ggT8TIzm9Ax
         4de0bgE4SHEHok04TbB7aYgEvTf2x+rzcAaP4orOHvHDZOV1IRApzoSkl/iS1ug6KKob
         asHA==
X-Gm-Message-State: AOAM532iS0XY4nE3E3AHRE09E6GjGvOfkHChWh+cPUb7ClmVMWnKCB8R
        YuKwMh6Wr+6E4ovyLvBuAikn3prTTt3PxE/PMsVlkPZIxqw=
X-Google-Smtp-Source: ABdhPJzWBU9HuRjz4XE7V5QOImcxRG8oIZ83YjPeYLT5AcsiscP9FnXtU/YIns8UybNkVDKrswhA2/hM0epEdzKDGp8=
X-Received: by 2002:a17:90a:6b0d:: with SMTP id v13mr12330428pjj.138.1635522130816;
 Fri, 29 Oct 2021 08:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <d732c167-4fbd-b60a-1e1b-8e0147fd9a78@gmail.com> <f91a8348-87ab-86dc-9a10-d934bce0aa87@iogearbox.net>
In-Reply-To: <f91a8348-87ab-86dc-9a10-d934bce0aa87@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 29 Oct 2021 08:41:59 -0700
Message-ID: <CAADnVQLqrokhdY_DQWOhBafaYe-tSpQ60seTxv8r5MQpH6RtHw@mail.gmail.com>
Subject: Re: [RFC] should we allow BPF to transmit empty skbs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 8:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/29/21 5:22 PM, Eric Dumazet wrote:
> > Some layers in tx path do not expect skb being empty (skb->len == 0)
> >
> > syzbot reported a crash [1] in fq_codel.
> >
> > But I expect many drivers would also crash later.
> >
> > Sure the immediate fq_codel crash could be 'fixed', but I would rather
> > add some sanity checks in net/core/filter.c
>
> Makes sense, we shouldn't have to add this to fq_codel fast path, but rather
> a sanity check for bpf_clone_redirect().
>
> I wonder if it's only related to bpf_prog_test_run() infra or if it could also
> have been generated via stack?

probably bpf_prog_test_run_skb only.
I would only add size !=0 check there.
