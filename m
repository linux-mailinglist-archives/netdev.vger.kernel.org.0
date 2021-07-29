Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A583DA401
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhG2NYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbhG2NYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:24:45 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F8C0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:24:41 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q15so10227755ybu.2
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I3gtSFNqWlMDmi9F4nxYDosBV6KTlor90/18ofAi344=;
        b=C7koYkLFCNRI5d3aOLmjP4UgotIcym7KhpDnQrZq+VbEO0/RuCP9WbJ9nmGJA0Y7Zy
         gaRETBwCP25fPOjkKsDbgvuIoLI15o+ifA0BNxQYCN+1/Talwpjn7DvAgnmdeIlgHWMa
         V1Ubx8NEvQfb5ygqm3DvFVTYS67gVpLND8VKDYdvpCidVVjhtCsuyim3f9O43DT/E9p3
         cEmO5s+SISsMBXMZcUYpUVIqyj4lN3BvbEs+GXIsYzMnciptSQH6o0EbNQXaI5o+xaWx
         HirTVc1V41nKF/c7sjIYKdgagCdF+yikaGf4P28Y1MHyLuV3wNEyL4EO19wJGfE2mpXT
         t0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I3gtSFNqWlMDmi9F4nxYDosBV6KTlor90/18ofAi344=;
        b=bPuyI2McOKFrFIL+OVmy6jdWUoCtKOgyXkoRc5IZajtRGie5C23meuH5MgokrxPbnJ
         NLP0wLqnY0XxX0kALUGhRfBP/4JTvw+9kW+oB8vvZ1r3NF7HG6WJu35C9GKBMVwzF/mJ
         qx47boEdYaZty91H7gTw+H/Y2iOql/UI6Tr0g5zbq/LtfxwmUCVACOdMvAfRzJZ/K28f
         nwnxvYN5WUL8+CSH3BGGs/Wlm/JHIAQdp/VH4vwLn1fInEU1NUcGd1Ake70ykxImCQDW
         iB45BbdWctnREuRE93tfZcRNr1XtmRmVVdr5AoATugEiuU7kf2pEznD+dVVGgiWNUfgC
         69Pw==
X-Gm-Message-State: AOAM533o4mn6XD1IpnlDP27FB3n8BguDjSe2mXVXoqFqJqa12FU3SOlD
        +NBa5QsDlwAiTBnQUvDwGk68flRCNiasPOnH7lvrxw==
X-Google-Smtp-Source: ABdhPJzGyV91GtfYtuhcB/tTlKHgTZafB6xVSMrvN/YBDR52baHS3XwWbpKhz2+KqAmfd0TTop2jmaE/7wvwYcPxxLE=
X-Received: by 2002:a25:7b83:: with SMTP id w125mr6681536ybc.238.1627565080581;
 Thu, 29 Jul 2021 06:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-11-johan.almbladh@anyfinetworks.com> <6c362bc2-e4cf-321b-89fb-4e20276c0d73@fb.com>
In-Reply-To: <6c362bc2-e4cf-321b-89fb-4e20276c0d73@fb.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 29 Jul 2021 15:24:29 +0200
Message-ID: <CAM1=_QRN+aioWWNfeS5Tddo2u6UG86bVj66BJoYyzaUDSkDZ1w@mail.gmail.com>
Subject: Re: [PATCH 10/14] bpf/tests: Add branch conversion JIT test
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 2:55 AM Yonghong Song <yhs@fb.com> wrote:
> > +static int bpf_fill_long_jmp(struct bpf_test *self)
> > +{
> > +     unsigned int len = BPF_MAXINSNS;
>
> BPF_MAXINSNS is 4096 as defined in uapi/linux/bpf_common.h.
> Will it be able to trigger a PC relative branch + long
> conditional jump?

It does, on the MIPS32 JIT. The ALU64 MUL instruction with a large
immediate was chosen since it expands to a lot of MIPS32 instructions:
2 to load the immediate, 1 to zero/sign extend it, and then 9 for the
64x64 multiply.

Other JITs will be different of course. On the other hand, other
architectures have other limitations that this test may not trigger
anyway. I added the test because I was implementing a non-trivial
iterative branch conversion logic in the MIPS32 JIT. One can argue
that when such complex JIT mechanisms are added, the test suite should
also be updated to cover that, especially if the mechanism handles
something that almost never occur in practice.

Since I was able to trigger the branch conversion with BPF_MAXINSNS
instructions, and no other test was using more, I left it at that.
However, should I or someone else work on the MIPS64 JIT, I think
updating the test suite so that similar special cases there are
triggered would be a valuable contribution.
