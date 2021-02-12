Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A9431A67E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhBLVFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbhBLVFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:05:50 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335DAC061574;
        Fri, 12 Feb 2021 13:05:10 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id b16so611311lji.13;
        Fri, 12 Feb 2021 13:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbjxvXETQ6j1I+XE78CycXkHwpX2+wbGS1inRasjIr8=;
        b=Al/iMWmOf7Gd9oFlnEXwvenLfFIsVMK4Ry7fXXndiMOM82g1G9FlGVgp5SVX0+mvGs
         WYJXgl7thHsaalmZRlJ/ar1b1A54ekTvFlQpsGO78qxDH1iY+sD72PF34Ddsm9d7bPV4
         l5pJKgBOXZ8uibbPiqdUkuLBRtYbZhtLsZ2db7YE64odxEeO+4NIPXTdAPaO28v6Xo18
         7grwkYotKThMyPsVmbv1sRMpNBTj6g+AOpsfMSYyq9+fNzoAcQ3JJlOl/kjWlxH4RtRE
         JG/Jn9SnfYC0T3PCQv9e1M88rDovWpB52fI7nBS7cNykXPAqFbJdBEzkzZ0TUgmsjxpL
         zH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbjxvXETQ6j1I+XE78CycXkHwpX2+wbGS1inRasjIr8=;
        b=O0+XZaT9NwvvBtxhHnzeiOpclUzTkWFG94jEJ0HsX/DY0QGTYThL/ii/HgSYuvn9on
         yqN1sTjHesCROzcruku0H2uqnVa0ZPj1Ty/t/QzYlDxjnha9gDJ8d+1fivzspgG9vd5O
         5I2u++b4+FDAxElfJKjG2pvWDWLns0sMimBPqoT3pioSx5qw0gF6SRxsSarJ0dvvRWay
         DUZJJGGOXCjeUP9H4quiXASV3wwcKyi3kR59pZPmZJ3L0EBi+ro71dyiHqx6hkttMK7A
         v+nL0ADO41m4VBo33afWd2Kd2x7g4MlxlkWGIwrv8rNzZFaHLTwWxdhYunqJBOjMjhN/
         9cpw==
X-Gm-Message-State: AOAM530GIWrhgLmjNKpZKm1Q98uw5BqNiRRNNHgOr6rEVF8tZSrUQCkS
        9XfXfYv37eofTTtL43tz9mZIX0mMaxHpSJvmM54=
X-Google-Smtp-Source: ABdhPJxt7EFnIwL+LdVfknDOokIu3H1OBKy7uZzacZS8PnSHmFx6tCyCijFpf5OcXDQzHrvbB5Nz18inr1afODxxbsg=
X-Received: by 2002:a2e:9655:: with SMTP id z21mr1557918ljh.486.1613163908673;
 Fri, 12 Feb 2021 13:05:08 -0800 (PST)
MIME-Version: 1.0
References: <20210212183107.50963-1-songliubraving@fb.com>
In-Reply-To: <20210212183107.50963-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 12 Feb 2021 13:04:56 -0800
Message-ID: <CAADnVQKz8fzvVfqozE2QePjXk4bG8gyTow8Nm+CRYcWM7pf6DA@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 0/3] introduce bpf_iter for task_vma
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 10:31 AM Song Liu <songliubraving@fb.com> wrote:
>
> This set introduces bpf_iter for task_vma, which can be used to generate
> information similar to /proc/pid/maps. Patch 4/4 adds an example that
> mimics /proc/pid/maps.
>
> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
> vma's of a process. However, these information are not flexible enough to
> cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
> pages (x86_64), there is no easy way to tell which address ranges are
> backed by 2MB pages. task_vma solves the problem by enabling the user to
> generate customize information based on the vma (and vma->vm_mm,
> vma->vm_file, etc.).
>
> Changes v6 => v7:
>   1. Let BPF iter program use bpf_d_path without specifying sleepable.
>      (Alexei)

Applied. Thanks!
