Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE783D871D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 06:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbfJPEFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 00:05:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38964 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfJPEFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 00:05:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so34083936qtb.6;
        Tue, 15 Oct 2019 21:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RCCD+pK2LNKXeGLEbaKSTm59HIBIHsYlW6ixxxiklIo=;
        b=hbotq9+As/ijYHkMsVDTf6KDVypmqPC4hVwCwwvuWz4jkQV4Hq6UsuqPnN6M4KsH0J
         +/2wQBdO5np18pWtrHw7JwWwPy9OreDZzowFpTNRvNvIfdtHvUMxymvTSdxDMh7488sN
         19CucwBB6+FLjWroRmxrhqCYDmNRxvvDeE2fXrGKh5uCWl7c58cuYZqNOtPUzIY9YqZn
         y6PQYGszxpc6hu764zr3fPFFpVa65Z8X6Yu8mz4dJxkyC3NuWkH05zT2SBSN342OVD5R
         /A0q+wNqTPUDBHxNrHMSE5qRhbwbNnKceMwXhrub1ROs1KQVK7+xr2hWAdsJQ6fTf5Gp
         tkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCCD+pK2LNKXeGLEbaKSTm59HIBIHsYlW6ixxxiklIo=;
        b=YqiLPfjF8yIyWzip3NyQmtTpVLe4lSzyF8yAfJfjnfqTfXBfPDc1AjfHv3gilv/YB4
         pqxOP4LA4YPbfw0oB057s+MGHMa7HG2BLrj5xp448hokisvAyHG5leh4eXyMjleMclza
         PaYbB860a3PmFluA+mEyw2mCAREuRDqXehs2ZY5jhWczKoVJwKpaVofZ6lNCWMaY2A7w
         OQhsTmcoQgX6OwS9D18quoSTw+VuYgF7opFNV6dX8FYRzxSAlTmvG089ie4KfKeeTiGf
         KEMR7IMKk7RrlJsFFKM2LAehO4Qk4baYigZQ0xfbRD7zhxrJGufDrQXuSXtJOECt7seh
         zIEA==
X-Gm-Message-State: APjAAAXSzo3vqWXMUpJy2VK3nM3QHNc5aEz2eg6vKxRyIYVXdL6p6SnG
        ZjOBzZIWbRB3wFn14b0UA223lZBHm7F70hqB0ik=
X-Google-Smtp-Source: APXvYqzH4hj2oi9U9aJlau7y2M5M3SVeCMJnGxcQFXiYU0cal1SeWzaXXa+r4z/pwU3txHPp7W3133w3zTjc4YFdjBg=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr41448104qtj.171.1571198729776;
 Tue, 15 Oct 2019 21:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191007045726.21467-1-eric@sage.org> <20191007110020.6bf8dbc2@carbon>
In-Reply-To: <20191007110020.6bf8dbc2@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 21:05:18 -0700
Message-ID: <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Eric Sage <eric@sage.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, brouer@redhat.org,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 2:00 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>
> On Mon,  7 Oct 2019 04:57:26 +0000 Eric Sage <eric@sage.org> wrote:
>
> > raw_tracepoints are an eBPF alternative to standard tracepoints which
> > attach to a tracepoint without the perf layer being executed, making
> > them faster.
> >
> > Since xdp_monitor is supposed to have as little impact on the system as
> > possible it is switched to using them by append raw_ to the SEC names.
> >
> > There was also a small issues with 'samples/bpf/bpf_load' - it was
> > loading the raw_tracepoints with the tracing subsystem name still
> > attached, which the bpf syscall rejects with a No such file or directory
> > error. This is now fixed.
> >
> > Signed-off-by: Eric Sage <eric@sage.org>
> > ---
> >  samples/bpf/bpf_load.c         |  5 +++--
> >  samples/bpf/xdp_monitor_kern.c | 26 +++++++++++++-------------
> >  2 files changed, 16 insertions(+), 15 deletions(-)
>
> If there is an issue in the loader 'samples/bpf/bpf_load.c' then we
> should of-cause fix it, but you should be aware that we are in general
> trying to deprecate this loader, and we want to convert users over to
> libbpf.
>
> This patch seems like a good first step forward.  Longer term, I would
> like to see this converted into using libbpf.  The library are missing
> attach helpers for regular tracepoints, but for raw_tracepoints it does
> contain bpf_raw_tracepoint_open().

libbpf has both bpf_program__attach_tracepoint() and
bpf_program__attach_raw_tracepoint(), please use them, not lower-level
bpf_raw_tracepoint_open(). See selftests/bpf/prog_tests/attach_probe.c
for examples.

>
> You can see an example of how xdp_monitor have been converted into
> using libbpf and raw_tracepoints here (by Jiri Olsa):
>
>  https://github.com/xdp-project/xdp-tutorial/blob/master/tracing02-xdp-monitor/trace_prog_kern.c
>
>

[...]
