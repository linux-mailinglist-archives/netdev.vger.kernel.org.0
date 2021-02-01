Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BE430AD18
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhBAQwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhBAQwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:52:01 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B082AC061786;
        Mon,  1 Feb 2021 08:51:19 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id a12so23740104lfb.1;
        Mon, 01 Feb 2021 08:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wF7mWC2M9iBBc+ACGYALfCAPMzd/Re2kA54W5usB+9c=;
        b=cOQzkJjTPteBDAyEwI88kZ6IB+wiDX+1y1GIGJanexyB8HynFGGumgPPIB53qiYArs
         +e7ZbAKr52jZx90yInF//sIz6yDHJwouIdUUpr7f+3RpMaze56OrOgLqkai2EYjbnhH4
         +TjotrLukfQlGShqfr5pes94GebIp75G5LolNlKBcwL38rvVt6GF8CQLI1q9GB1HPcmR
         z6CAHvTshHpQ4KeHiHwtBkg9OEvkkecyzIew0dLXYR5N/LDEFQ7bsggyocEzRyVr7DKk
         qvBdOSvfJVBUqSYoCtiKeZRvkxoEahCvcvZBJrQYAMMjBUSPic/kfUiYpdD6bVKsvhMk
         3tsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wF7mWC2M9iBBc+ACGYALfCAPMzd/Re2kA54W5usB+9c=;
        b=Y1pQjEKYg8M5tDAuMWB4GcZzrE/9wTMdeoSK3zTO8Ie8CPtT/aXFYg5Ry0jIzTH4BL
         hfTDPIRhNJlcCth2pmSezZwXG/ExkjqcJlSICKlGBVgCUhZ9mrYOVOTXebKj7gMVMFne
         QoEA71I8Ja3KtmGmKL3kiaQt7JOUsYa2ylLVQ4IazLu8hS6Qvd96nSDb2Zi/gs704+jN
         dSXZXcpAiijuuoPx0lpyrJp/IHJFbI2i28m+AjSpQKL7rdJ47/BdXHBm3AVykzc06X6y
         +Z/YG6IIErZ+mY/kxUgsEkGqLcC0Z4JTq2IroRkCH3g++Lw9RMdpm5QP6+fZ2Y2KaK+C
         2ZMw==
X-Gm-Message-State: AOAM532zBjWeFqWbNmQ8LrshOAig7XrSIqpPc59SeL9DZItPDQNgD3/z
        y3xyZF2rgys3ycL90szgqgTGD1ad9PrR9VHuhgY=
X-Google-Smtp-Source: ABdhPJwU19Ykz6zVy5HPScLPfN7sZ41eNDew+I/XiJKnUJb0R2TV/4YtlOqZLFcdbXx3hMrOMozaP/L2VFq0o4gRw5Y=
X-Received: by 2002:a19:ec03:: with SMTP id b3mr9452260lfa.608.1612198278259;
 Mon, 01 Feb 2021 08:51:18 -0800 (PST)
MIME-Version: 1.0
References: <20201007152355.2446741-1-Kenny.Ho@amd.com> <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com> <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
In-Reply-To: <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Mon, 1 Feb 2021 11:51:07 -0500
Message-ID: <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Dave Airlie <airlied@gmail.com>, Kenny Ho <Kenny.Ho@amd.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Brian Welty <brian.welty@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Resent in plain text.]

On Mon, Feb 1, 2021 at 9:49 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> - there's been a pile of cgroups proposal to manage gpus at the drm
>   subsystem level, some by Kenny, and frankly this at least looks a bit
>   like a quick hack to sidestep the consensus process for that.
No Daniel, this is quick *draft* to get a conversation going.  Bpf was
actually a path suggested by Tejun back in 2018 so I think you are
mischaracterizing this quite a bit.

"2018-11-20 Kenny Ho:
To put the questions in more concrete terms, let say a user wants to
 expose certain part of a gpu to a particular cgroup similar to the
 way selective cpu cores are exposed to a cgroup via cpuset, how
 should we go about enabling such functionality?

2018-11-20 Tejun Heo:
Do what the intel driver or bpf is doing?  It's not difficult to hook
into cgroup for identification purposes."

Kenny
