Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD8F5A5BC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfF1UN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:13:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45054 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfF1UN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:13:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id p144so5942081qke.11;
        Fri, 28 Jun 2019 13:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IRIzBehGC+RSVo0fap4Q6ERqxH3/Nedpjri/5bBHyhw=;
        b=mD6m/f4G0MEQ7BMevHwO20wKgkSI6DHaSd+pocUd2XMQydI7qBQMbVmhAzZnqoKHFq
         qKSzbnNWK90Q0VPB1uhzNqc39bU6oaawi3R29ljE0Jxrd8+XwMBpE6LjAcvAooJChnT/
         0/5L4KEbPtFh+C62WUSA5TslZYSTb90cnsbe3ZvUqSYekk/FyculZzV9AwSNJwQtB2K7
         OzB3gDRjeh27B6u7S0hkrnCqHi0bqSMHmWxkBEv2wJHtQiORm2v4fMibtYUO8BjbtATP
         y+qNiinCEzFC9QOxwdqg1UqAQWS1E0VUZ/YhE6tZ5jRqZhVymfIt8Kw0yje54hH73xbA
         ipqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IRIzBehGC+RSVo0fap4Q6ERqxH3/Nedpjri/5bBHyhw=;
        b=Yn9EAN3iBdtLAZoErt5WftsZdVq0jrFnqozmP2cwUjKQ9B7vPow9CNX1JdPDSIJqlW
         4rbJb8UkfTCEEKF3a2F2qR8BrPbgWin7YgJuollMeYPrRwWTMWYpU4YciLs/vYnfoWdp
         lD3+Y/VqJdWw57t6o3daLY+XD2TaX57IGtXI91rSV/ACPRcDOXy7EbQo6zWtdHrJDXGX
         ESnZ0fyvDMY5vub/l25SlYbQGZTnJ9GWsfHT0nmUk1S+8dxF2GDp6GY/BUGbCTJ11cJC
         PFdjaWLkkyhuevO7KG+NUMZkDXMytquenMRP2JD4NbdpIDUCBhNMDYEKRkb1v3qdZI8C
         Vmxw==
X-Gm-Message-State: APjAAAUxJR68vJqJN+mNP3B6vQ4386AzOwf3Z+Wr9AuL/iebuD/veWg9
        kOdHSWdBjUSlqG1o33T0VhFxZ8VBrDIe/f1CiM0=
X-Google-Smtp-Source: APXvYqzyUyqLaCsT+r7EI13BiFpHrD0/kS+zlYkmGSWysFPVgerO+MQ3qT0Nto00mj8F+ddqr+TeHcF+2IBPOIL9ZEM=
X-Received: by 2002:a37:5cc3:: with SMTP id q186mr10231977qkb.74.1561752806360;
 Fri, 28 Jun 2019 13:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-10-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-10-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 13:13:15 -0700
Message-ID: <CAPhsuW5CsBdxp=3mv-JGOapQBfR6qgUz0SeWbkO7BEwBicDHsg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 9/9] selftests/bpf: convert existing
 tracepoint tests to new APIs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Convert some existing tests that attach to tracepoints to use
> bpf_program__attach_tracepoint API instead.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../bpf/prog_tests/stacktrace_build_id.c      | 50 ++++---------------
>  .../selftests/bpf/prog_tests/stacktrace_map.c | 43 ++++------------
>  .../bpf/prog_tests/stacktrace_map_raw_tp.c    | 15 ++++--
>  3 files changed, 31 insertions(+), 77 deletions(-)

More deletions. Nice!
