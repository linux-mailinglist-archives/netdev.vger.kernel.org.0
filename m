Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3BD235500
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 05:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgHBDsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 23:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgHBDsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 23:48:23 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F68EC06174A;
        Sat,  1 Aug 2020 20:48:23 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c15so1490662lfi.3;
        Sat, 01 Aug 2020 20:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wG1gwMiM0UcJAlC5639hiivISpRQRCMhT/1gmgA81Ts=;
        b=GEZstshkvLit5VOUOUZFMmZb5GDyMv8fNDhf6/+U4r1tesaNyKf74IzXbanmp5Ran3
         3qFa0aC5CgTE/XRB0vIEk7/mSVVaejBXPxpg99I7HbU8jlvvDIZ+Ng3ww6RWusEiAqBD
         iS2ie5uz1/Di5/DO+6Q+pgyLCP5P+6s6SOOzE38l3p86DAPu0euW/uCjs2Nwdj8XV8BO
         kJojycWR2yenYUokriI+enMMTdBUqY6p0ALpttokDVWdFPX9kwUY4dbmILu6Ud77qFYK
         ik1ilhGX9d8qkyY+3EpkbGkPJuNAxj7qoDRBvB2qXa/ok5Ar+iPLzAyW8FpBWwftfO/e
         GrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wG1gwMiM0UcJAlC5639hiivISpRQRCMhT/1gmgA81Ts=;
        b=ISJbPelz1hpyW6Z960gRAxgNEN6xse+B3GqMZjjcXJjug8xpQM4Ex1TIuarjUL1Fg2
         uJU55/Wj+cXEdA/mV6lTJJ1bfK/ZYH5zzQDqwSpIVBVxadOWUwuIylKfFMLv27TW9gSd
         /iZqOp18EBkgZYuagDxdCEGdt0sodB2JFjGG94eAlH2L/BPw68wYu84a2q3SNRQWd8TI
         tU+qpkHRQSQwBGWbhgf18MjBcIk6ssAQUB1L42Z2vKLl4lOFv6003IYBw4IvFhm7KFhf
         KcuNlPRIMKCqih79aDuFbuODn7fep0+2kEcm+axr0yjopu68MhUBZLQ6FjRst4GM1M7J
         5BRg==
X-Gm-Message-State: AOAM531uKmE5ULHDQnjKIMGszmldt4zMbkl075QlTGr2u07jRVgK20id
        8LOZDUtFMfA2GVLTTF/j1a9D12r3HQYm8xAwEUM=
X-Google-Smtp-Source: ABdhPJzH1J7BRRdO/Tm7hs85uwoYN2vR0VkAKUf65U+Jz37vsCtdxEI6fNXXg0nyry4cxBShh73puATE8QSZxGy8Jtk=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr5387414lfs.8.1596340101742;
 Sat, 01 Aug 2020 20:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200731182830.286260-1-andriin@fb.com>
In-Reply-To: <20200731182830.286260-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 1 Aug 2020 20:48:10 -0700
Message-ID: <CAADnVQJcfygvdGVpknpQxADs_L7oK8Ghuci0JXULekJdWx5Nsw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/5] BPF link force-detach support
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 11:29 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set adds new BPF link operation, LINK_DETACH, allowing processes
> with BPF link FD to force-detach it from respective BPF hook, similarly how
> BPF link is auto-detached when such BPF hook (e.g., cgroup, net_device, netns,
> etc) is removed. This facility allows admin to forcefully undo BPF link
> attachment, while process that created BPF link in the first place is left
> intact.
>
> Once force-detached, BPF link stays valid in the kernel as long as there is at
> least one FD open against it. It goes into defunct state, just like
> auto-detached BPF link.
>
> bpftool also got `link detach` command to allow triggering this in
> non-programmatic fashion.
>
> v1->v2:
> - improve error reporting in `bpftool link detach` (Song).

Applied. Thanks
