Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8FD1F464D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 20:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbgFIS03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 14:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbgFIS0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 14:26:22 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E94C05BD1E;
        Tue,  9 Jun 2020 11:26:22 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 9so26330721ljc.8;
        Tue, 09 Jun 2020 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MS9Y1NckTNUGInM9fo7+yYKL81LHnuUrE4ZS9tUH7g=;
        b=DPikTQ6FcOWi2xrpQfnqWVvm6/TQuJuZJFq1dFpl6Dsv7SXbIyqsRgvVUAJHN8NA5/
         4ZyotKF7uRw/fJVAdAnhcCbJA25jOOBTWjeYI573uPiJI6ttNZl7ut6DC1w1p9TEqMQq
         bOGXtZi/nQZSFyigS4lXIBPyKoLA6OjZeRc28ZHnmWF22CygGrscBrirRXRuuDTjTF/E
         V5KdvyWhvA5i2CNmuPHF+3ftELR0FjhMqHjlAuCUCUEslu19dV5BAqDY7EhMBoQHwzo8
         7mJf9AbGhHY4SKc//y9ymx5vDx0Lc7hke0nkuCD4C2QSOm/vaoXVNFxpa6otHPhncXfj
         LkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MS9Y1NckTNUGInM9fo7+yYKL81LHnuUrE4ZS9tUH7g=;
        b=CmDNspyxBDNGGedu4rcFcoJUE7VxYeG6VWenQwPSnk6AiCThSrR2MUZzQ49/+hLOht
         GPyh05tJhBvmHK3iRl/lADL/Ses+lB9EnTKhb/ooXmzdVegMsjzAfkDQCThihUGG1k5l
         EIvPyGnXqnsrDbY4flTxuMlwkVztEKeknNrxdkwm+7tuUXifFPivgm8VybbD2+Xfn0ny
         tLI5Lui2a9lKwYdbnoYv2x6NqTPCRiCk2vvACA6MxboWaAyUtbquCDLCyMy+g2TDJpxV
         IoPfRbC1u4PC0HLmfpnfdrErTw3oy8qjj08IwWNIHvUYB4wtPSB8bWByWPu6UmJQeJfB
         S+Kg==
X-Gm-Message-State: AOAM530nHCIOsTqkv7h+xy0MBTEWLkXuTqgH/u3HfDi3MfZifq28nfix
        VfMehDf8iqcAtMFia4lMJWTIw1Yq/mptQr46JIM=
X-Google-Smtp-Source: ABdhPJyuNw+27EwMjp90S0ui4JzjSD6X/su1nk+7nNol/uL1gqWAurpftXOz5HydFAsnP6W9lTuL+gJyLO/bzpSu7Qw=
X-Received: by 2002:a05:651c:1193:: with SMTP id w19mr14859026ljo.121.1591727181004;
 Tue, 09 Jun 2020 11:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200608162202.94002-1-lmb@cloudflare.com>
In-Reply-To: <20200608162202.94002-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Jun 2020 11:26:09 -0700
Message-ID: <CAADnVQ+YNPG_AZueO+J8N=1u-fmsfSBCcyh693vYmaERdpGm7w@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: cgroup: allow multi-attach program to replace itself
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <shuah@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Roman Gushchin <guro@fb.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 9:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> When using BPF_PROG_ATTACH to attach a program to a cgroup in
> BPF_F_ALLOW_MULTI mode, it is not possible to replace a program
> with itself. This is because the check for duplicate programs
> doesn't take the replacement program into account.
>
> Replacing a program with itself might seem weird, but it has
> some uses: first, it allows resetting the associated cgroup storage.
> Second, it makes the API consistent with the non-ALLOW_MULTI usage,
> where it is possible to replace a program with itself. Third, it
> aligns BPF_PROG_ATTACH with bpf_link, where replacing itself is
> also supported.
>
> Sice this code has been refactored a few times this change will
> only apply to v5.7 and later. Adjustments could be made to
> commit 1020c1f24a94 ("bpf: Simplify __cgroup_bpf_attach") and
> commit d7bf2c10af05 ("bpf: allocate cgroup storage entries on attaching bpf programs")
> as well as commit 324bda9e6c5a ("bpf: multi program support for cgroup+bpf")
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")

Applied. Thanks
