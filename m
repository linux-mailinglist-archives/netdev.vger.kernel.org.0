Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3CC2506
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbfI3QW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:22:59 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33205 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfI3QW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:22:59 -0400
Received: by mail-qt1-f195.google.com with SMTP id r5so17823115qtd.0;
        Mon, 30 Sep 2019 09:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=El93Fu1oJqniCITnf6MocyiC5MoE5Rxv000GoLGhIcE=;
        b=fgX+6Z+CtxQiPY/CGH1zslA6mqXLXl+VBoSAIj10rNs004C3SGQupsPaUZ/1ztgL/m
         uN/eh6ywaFxMJT2ljpEnWmnWhXPORuRNauKi/L/PLr16dx273YdT5/vpcSmIltLgVCYU
         vJ+B5MwiYRg1FOrpezId2n4u6cwhFsPWUmja38vlDM/J6Fzuw1ksovuBRRsye9fRoDK5
         GKcyMGbXRa6SF8chVUrlku3JcF1+XHD5u0cebZ0BaxACdN1/1xs6sbj1DBga9N+jK+YU
         lfqBx6G8amueyD/Ov0RLWoFLuchcRP0vQzYQY7MSMIhx8VlMYC2A0DgJhu1mzynMZtRV
         Gd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=El93Fu1oJqniCITnf6MocyiC5MoE5Rxv000GoLGhIcE=;
        b=ROox7J63xEYjL2/KzcjWE/+6iPkTZWJ7aJaf3gSJXF+0DPhxnc33w+K/PBtgwsH/LS
         Q1HE6upLB9N0hS3mfhDxzBf55nG3WPhefDze/mhFs8umvuXL75lrIpfh7hmfH4f6D2Nl
         /xyVZAnO29kXhRoI5fHMth7RaZRZvrRa9GYNTFlfBJ+xvK0XCgOiXfY+QqJxK9aHBxCW
         +vUYnxKv39LyxBGi3oMYvdPgacQy0xPX63CoNdSErL8EDI5rR40x2iVa29G5DWs5q/Vf
         C6TemjDdPMMJcytw80T6gBXC7WMuUwdxOiYy14P3lHLwGa8sb8HUXNW3yG1iHfsqh2xA
         ltXg==
X-Gm-Message-State: APjAAAXiNVivQ26zm96qsj+xeSdhjY4kl0p9OhWvkpXbYFM1YAKZowFn
        GOlln7V/ODOkk5ppu0JWL6ZHtcJjIu/9A2qkhNI=
X-Google-Smtp-Source: APXvYqy/QgcC7txP+bTPRoIV9DEwamtrpPUNd9KRn5bDLfaORHvTe03LXfM03Zs5b4m8246V87TsOhFFOGVtbyt0shE=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr25094277qtq.141.1569860577784;
 Mon, 30 Sep 2019 09:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190928063033.1674094-1-andriin@fb.com> <05329A22-363F-4C12-9B6D-F9A2941C749E@fb.com>
In-Reply-To: <05329A22-363F-4C12-9B6D-F9A2941C749E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Sep 2019 09:22:46 -0700
Message-ID: <CAEf4BzZ4aDv07Qs48_=58x=gDdVyTN8c+S4_NjJj8z4NOCJqvg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically possible
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 11:07 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Sep 27, 2019, at 11:30 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch switches libbpf_num_possible_cpus() from using possible CPU
> > set to present CPU set. This fixes issues with incorrect auto-sizing of
> > PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.
> >
> > On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> > be a set of any representable (i.e., potentially possible) CPU, which is
> > normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> > tested on, while there were just two CPU cores actually present).
> > /sys/devices/system/cpu/present, on the other hand, will only contain
> > CPUs that are physically present in the system (even if not online yet),
> > which is what we really want, especially when creating per-CPU maps or
> > perf events.
> >
> > On systems with HOTPLUG disabled, present and possible are identical, so
> > there is no change of behavior there.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/libbpf.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index e0276520171b..45351c074e45 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
> >
> > int libbpf_num_possible_cpus(void)
> > {
> > -     static const char *fcpu = "/sys/devices/system/cpu/possible";
> > +     static const char *fcpu = "/sys/devices/system/cpu/present";
>
> This is _very_ confusing. "possible cpus", "present cpus", and "online
> cpus" are existing terminologies. I don't think we should force people
> to remember something like "By possible cpus, libbpf actually means
> present cpus".
>
> This change works if we call it "libbbpf_num_cpus()". However,
> libbpf_num_possible_cpus(), should mean possible CPUs.

Ok, then if we really need to (I'll play again with my VM to recall
all the details of original problem with this that I had before), I'll
just add libbpf_num_present_cpus().

>
> Thanks,
> Song
>
