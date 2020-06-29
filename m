Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A33320D45C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbgF2THt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730671AbgF2THn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:07:43 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40530C031C6A;
        Mon, 29 Jun 2020 10:48:36 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id t74so9629718lff.2;
        Mon, 29 Jun 2020 10:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ybGXMKNhDBo5PBd7dMGTNB+NKn/M8wbDbj+FSv497kA=;
        b=FTbcEof5mQ5AtbU2qMu8nqf/RaXgjo+qUZz2FYAp7+7T5toEGdniO0LzE8R1Z8u8qf
         xQ5Md/ebsR8A/RKHeRU1M4N8QpxvpPyuJ5PiFjbp0HwLcyRAcCqJh6w5+73zNJXPaRNg
         qJGsSvumlSa/DU+20IYMSWg0KcfR+ZDxFLtzGADNGcY2lW8AcYdeNxga3M8N3Op4C87r
         NbW1si6I1BQukRPlMdqro2tpbrxQTvR2LRrv3EDKk4gZ+Rv+VvFUxQkkQa6Y5ruBbhUJ
         daFntdO4bwspNqRGwLgkLgubsBMokEXJFxOq5yxIs88z43RINNxGuRlmNyNUewT7dG6M
         o6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ybGXMKNhDBo5PBd7dMGTNB+NKn/M8wbDbj+FSv497kA=;
        b=sngSP58VdNsW0b5z5rJ4J5kQflyxpqy4V5i6nMc+MfDCt/MM+fRlW4tzTq4QCE92J2
         MWsyQlDglyQlkCvLeJIplBdp8yFe5YPyRBvqgEaopK+SfYikNKPn4uXtp8z5sXd5bwNU
         lgDzHuPfOupuvvfUX7R3RoO+6isuoqhajhsI1gc7vBGVVA0FwHnIRsmHJ4IpQVcD5rnv
         EOEDj5PpRGs4ZFtAeLcGBF/9zHt23tQ/xbHQQCyRINdae1a740Kux4c8FrrBK5eWUDPL
         VsKIIv0LuwRVDzttCmMNUnyjiUaMIBEOq9ec7xeqMemDv9IaDUeuLJyZwvi5GRdoCi9x
         HYgg==
X-Gm-Message-State: AOAM5332rhyNJDa7LhBbj9u0+0+5hRrZIKbauBCLlRjxf1q8jlNZhAYP
        D3zAZs6jagJNCIh5av3zfFU6R7YYcewApgeY0EW3Tg==
X-Google-Smtp-Source: ABdhPJzZDr0HwEoLFL7dYzolxGZR+HKuaAQBS5yCdNgwW0eFKrNa/0UgV6HRDrUsRbVYgAhakBOutFkj1UCxakKoAWM=
X-Received: by 2002:a05:6512:49d:: with SMTP id v29mr9912417lfq.134.1593452914654;
 Mon, 29 Jun 2020 10:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200629093336.20963-1-tklauser@distanz.ch> <20200629093336.20963-2-tklauser@distanz.ch>
In-Reply-To: <20200629093336.20963-2-tklauser@distanz.ch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 29 Jun 2020 10:48:23 -0700
Message-ID: <CAADnVQLNAJoV1-0jADDMA=pv7f_P6nNdDVnYnVsLFQxJNgWbuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, x86: Factor common x86 JIT code
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wang YanQing <udknight@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 2:33 AM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> Factor out code common for 32-bit and 64-bit x86 BPF JITs to bpf_jit.h
>
> Also follow other architectures and rename bpf_jit_comp.c to
> bpf_jit_comp64.c to be more explicit.
>
> Also adjust the file matching pattern in MAINTAINERS such that the
> common x86 files are included for both the 32-bit and 64-bit BPF JIT
> sections.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  MAINTAINERS                                   |   3 +-
>  arch/x86/net/Makefile                         |   2 +-
>  arch/x86/net/bpf_jit.h                        |  93 ++++++++++++
>  arch/x86/net/bpf_jit_comp32.c                 | 135 ++++--------------
>  .../net/{bpf_jit_comp.c => bpf_jit_comp64.c}  |  84 +----------
>  5 files changed, 123 insertions(+), 194 deletions(-)
>  create mode 100644 arch/x86/net/bpf_jit.h
>  rename arch/x86/net/{bpf_jit_comp.c => bpf_jit_comp64.c} (96%)

I don't see any value in such refactoring.
Looks like code churn to me.
