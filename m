Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB0826E730
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIQVOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgIQVOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 17:14:52 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B3C061351;
        Thu, 17 Sep 2020 14:14:51 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x69so3764224lff.3;
        Thu, 17 Sep 2020 14:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3h/n7ORzeoLPoMQCIVHFT+TEfTwQU8jH7kBTXjNHH3M=;
        b=FcL9uQTwv2RTB9lHYBT1tWqe8K2qrJJme5EGfUJJqXyT3aUdRBCXJ4Q1u6pghRicjO
         4p1MeK3pvIYXZEB4GOHQBfEjiOOSUFcuEPNL4ErWMDSxUNceUC5JZOGN+R3mcpEQjO3T
         NpSeldLORAd49fOOkGPvga9nPLiXHA3qlhzZkREg/cNrlqewjEeFwkEbmLhNLIa4+P3f
         lN7I5ei/KWeGQMWj4NjLIaFRBu58lybrtFHT4d9pxUbXqiXk7Ay8ZJxqdpoCAfCHk5k7
         6AIvT9Drktd1ciXyU3wPiY/oe39vow08wWnqqQmblVZi1MtzdixV/XVMM11kPYZnUysJ
         vOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3h/n7ORzeoLPoMQCIVHFT+TEfTwQU8jH7kBTXjNHH3M=;
        b=aYnVoG64OiUDOz2phITynbE1Gx4PsjY3a0d5kEkyHHIu7Z4IopmBA/Qmfl2Zc7EPxS
         VyllB80MaC4JY6ws9VYz88lNFPTSV52OJ7YxLx0DKMJ9Gm6cJ5vi6sWWMlk+U3ychFE0
         4ZJRxXHzxQYZz8loJJGrhXGY9pWDSwg/G4GTWiHg+xzbtIyN3YEF9MEuHIXCUDkxjLoq
         0pCe8CW0TfYY4loSqGBB9Cj5qAyRhx3bOVCygZibfefdR0QvkuKvB46CP6ymebAhJy99
         Ei6dnDrHMSy+lr7oYSQYWBPgkHCzGLxDm2silBIBicObxJwxa8KD9D4Vzz3BhjqIKhSM
         WzRQ==
X-Gm-Message-State: AOAM533iVoWagiracEwpdmeYTVX9C37cL8idrdXo1pSx6TX7ufWP2SLF
        0gQsar5aHlZJxRr5hRpRjPL03gGC22obKY/SoVY=
X-Google-Smtp-Source: ABdhPJxFrGY3UhKsrnnXJdQlpaybZpAGaRdUutZ8eQPROX8V7TjbcKok7QpjWfBV6AaNC38dULAGycs9QxJPGTFeNmQ=
X-Received: by 2002:a19:9141:: with SMTP id y1mr9073088lfj.554.1600377290046;
 Thu, 17 Sep 2020 14:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200916112416.2321204-1-jolsa@kernel.org> <20200917014531.lmpkorybofrggte4@ast-mbp.dhcp.thefacebook.com>
 <20200917082516.GD2411168@krava>
In-Reply-To: <20200917082516.GD2411168@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Sep 2020 14:14:38 -0700
Message-ID: <CAADnVQ+o-0hoiJ5SBDXOuJ2MKJkTmsOxh60z61+_ZZ+8_=DhrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix stat probe in d_path test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 1:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> > Ideally resolve_btfids would parse dwarf info and check
> > whether any of the funcs in allowlist were inlined.
> > That would be more reliable, but not pretty to drag libdw
> > dependency into resolve_btfids.
>
> hm, we could add some check to perf|bpftrace that would
> show you all the places where function is called from and
> if it was inlined or is a regular call.. so user is aware
> what probe calls to expect

The check like this belongs in some library,
but making libbpf depend on dwarf is not great.
I think we're at the point where we need to break libbpf
into many libraries. This one could be called libbpftrace.
It would potentially include symbolizer and other dwarf
related operations.
Such inlining check would be good to do not only for d_path
allowlist, but for any kprobe/fentry function.
