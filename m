Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D644B4EC
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbhKIVzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241983AbhKIVzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 16:55:02 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E72FC061764;
        Tue,  9 Nov 2021 13:52:16 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e65so350468pgc.5;
        Tue, 09 Nov 2021 13:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bsrdgL3do9jE/45Ub+BZHx3M+v8XdQYPbDEI8JfUoVs=;
        b=B8seUKGFVfQBw0vDuSlW5GF4x5fqUhYBm1EJTiYPjlDdqQrsbibtzJxHOK9EocqmSt
         cSxiNZn2M2OmTFTTtDIGhvufuU2SzSNZuS6tidCObITEDiU5+n/HUO1kGapOp14yu3uZ
         PDpgCCoGhwGvMJdPpbFH575924BNonb7yCJlD4nnCOg9icbbSkpxlzAUdE1NqO1HHKt8
         Agl+yFQm1Wv44rzvmUcjcdLDPpqEFOzK+ynYjpzg6ho0ttp+nYgPTVKcfNgJja200vgT
         1qrI49eYuwNFT809ZWabe7FWjI7BZiqtJRtZIhRGGAV9vpJi72HwNVMyJfyMXJDBKnip
         s/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bsrdgL3do9jE/45Ub+BZHx3M+v8XdQYPbDEI8JfUoVs=;
        b=AA8Kgr8Bu1Pc76cut4jib7La8m7H/CWktWRGSbOofS0oe7qzsKG6ytPAX/rRpFivfI
         OFfxu7UdxsVddgjsZQ1HPe3g45EUGBogMqs2umwhJyxv13b40DdQaruQJhOVa5lj+OO/
         1MFKS/LTKVzRcorEm5/vqsyt1GJ12Jq69r4QHIX6SsPO2lmZ2AKLGq2+qZaQu62m/Lq1
         a9slDpTjBwA/I/OxBn6mbFH6HrKTbE1nMc+8p5MWo6GnsBqaJtyZjFbgCQfLK3rJ4N+4
         quSNMeM6jJ6LLETtvQZZtobgz0QuBy6PRAaehQ0ZuUH9z+/jwFC9Y/BlFfcHy+YLG7lc
         wnEw==
X-Gm-Message-State: AOAM530CRZVR7Hpv9cJ3DpKh7wxBNfShsZPj8QI2geQ/DNXUjRdiqq/T
        gbn44ZcV/p6GL8sN3oPi+IyRyw7rDJ94Hi8eyrg=
X-Google-Smtp-Source: ABdhPJw24SX2e9CGDihhmkA4QccdgXILFl9imc8UkSBQc7tl5soo1qazxhvBEpf1aeehm8rfLfv6NjLbktYFxVomCQA=
X-Received: by 2002:a05:6a00:1310:b0:494:672b:1e97 with SMTP id
 j16-20020a056a00131000b00494672b1e97mr45482368pfu.77.1636494735702; Tue, 09
 Nov 2021 13:52:15 -0800 (PST)
MIME-Version: 1.0
References: <20211108164620.407305-1-me@ubique.spb.ru> <20211108164620.407305-2-me@ubique.spb.ru>
In-Reply-To: <20211108164620.407305-2-me@ubique.spb.ru>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Nov 2021 13:52:04 -0800
Message-ID: <CAADnVQJf5ZbJ11ytgyWxGoKoXTvDtpjn_EAw23rCppoY8LtiBA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: Forbid bpf_ktime_get_coarse_ns and
 bpf_timer_* in tracing progs
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        John Stultz <john.stultz@linaro.org>, sboyd@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Steven Rostedt <rosted@goodmis.org>,
        syzbot <syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 8:46 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> bpf_ktime_get_coarse_ns() helper uses ktime_get_coarse_ns() time
> accessor that isn't safe for any context.
> This results in locking issues:

Please trim the cc. vger thinks it's a spam.
The patch didn't reach the mailing list or patchwork.

>  const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto = {
>         .func           = bpf_ktime_get_coarse_ns,
>         .gpl_only       = false,
>         .ret_type       = RET_INTEGER,
> +       .allowed        = bpf_ktime_get_coarse_ns_allowed,

I think it's easier to move to networking prog types
instead of going through a callback.

>  static const struct bpf_func_proto bpf_timer_init_proto = {
>         .func           = bpf_timer_init,
>         .gpl_only       = true,
> @@ -1147,6 +1173,7 @@ static const struct bpf_func_proto bpf_timer_init_proto = {
>         .arg1_type      = ARG_PTR_TO_TIMER,
>         .arg2_type      = ARG_CONST_MAP_PTR,
>         .arg3_type      = ARG_ANYTHING,
> +       .allowed        = bpf_timer_allowed,

I think disabling timers in check_map_prog_compatibility
(similar to how bpf_spin_lock is restricted) would be cleaner.
