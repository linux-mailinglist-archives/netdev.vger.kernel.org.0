Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AFA1856E1
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgCOBaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:30:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41023 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbgCOBa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:30:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id z65so7667457pfz.8;
        Sat, 14 Mar 2020 18:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMScX9D+bo7V5tsR+P54vN/tFEz4jr2Kaeohu46gTh4=;
        b=pLG5L/5uUs+w2CT4Pf7I9WcSpvh45S/zuF3TcIltzBf3PjIOcBcISiXHH+L88xGQKV
         G2fEuWzInsnUMBJZQ2PaQdQ5OSmCzaQ3jNPc/UP0XFUmzqPkL1kYrNn13c/WY9Zh99zV
         uecJYomI90/1Yw1RW+dQB37mJXLWnl/fJGNDscOPBcQGJx6mEU2xTzN98LguzIw44Dxg
         M6tlabOPPgDU1Pov9ly39kUtXiVEXJidFi9rGFNd8LtZojTiNdNDf7DmzZ0I3KUEtpLh
         epqY/jVzLFobBTxvvJTejbIgwh8NH+0zkIDUrlrSmo4+7a1m1KijomkXZ3SFd95XukEw
         8DRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMScX9D+bo7V5tsR+P54vN/tFEz4jr2Kaeohu46gTh4=;
        b=t2LB4aFk6/MvNLlnk31V8z6KaPj96V6bgDS7icQ8Hi2NsvP+OAKTNqCcVHZXeSuTaz
         C4MI7cnAmprN0icmGFmsIbPsoBldRwJznRx19F2jjuHkh73tVmbyOSsKSmWXVuUZDoqj
         Dmc3ptcBhE+hq4dXcunxn2wGSPRBseFE8fxNRhm6FDTQkQWQmjUvhn9yDVqRXZaSLtYH
         o6eMXxNj0dXCoataEuhYrQfLeWHuPFQ3fRONLBzHW8uUeAN/jnkzAQMLc8qwL//g8MS2
         pRH3q+qfEpd8aCZpxb2cGP98bqQmnOmRGM5Ad5gMgaOSebz1AilygzS9AyqlZ+79F2q7
         kwdA==
X-Gm-Message-State: ANhLgQ3yHzq/SXxN0xezHA/2DzTfUBTaNLsiOxAFRVLhIAL5s2lmyxto
        PYUyvLsB8J/e5jCkAAzOpLwEhImIs8SsvkSZrRsRdFT+
X-Google-Smtp-Source: ADFU+vuoQK/VSjk7IDs20ixuHqIMdAAqb3DZ6UMrH4XSUYSPbHrIz1VgSoqlkXQmsAdy/pP5qUnKePjMylLZkdO+J9Y=
X-Received: by 2002:a0c:ecc3:: with SMTP id o3mr18877283qvq.163.1584216450724;
 Sat, 14 Mar 2020 13:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200314034456.26847-1-danieltimlee@gmail.com> <20200314034456.26847-3-danieltimlee@gmail.com>
In-Reply-To: <20200314034456.26847-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 14 Mar 2020 13:07:19 -0700
Message-ID: <CAEf4BzZHk38KZRx5VstpPXYnFjM8OMOr1cUiSsnr_zY6v2AdJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 8:45 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> than the previous method using ioctl.
>
> bpf_program__attach_perf_event manages the enable of perf_event and
> attach of BPF programs to it, so there's no neeed to do this
> directly with ioctl.
>
> In addition, bpf_link provides consistency in the use of API because it
> allows disable (detach, destroy) for multiple events to be treated as
> one bpf_link__destroy. Also, bpf_link__destroy manages the close() of
> perf_event fd.
>
> This commit refactors samples that attach the bpf program to perf_event
> by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> removed and migrated to use libbbpf API.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>  - check memory allocation is successful
>  - clean up allocated memory on error
>
> Changes in v3:
>  - Improve pointer error check (IS_ERR())
>  - change to calloc for easier destroy of bpf_link
>  - remove perf_event fd list since bpf_link handles fd
>  - use newer bpf_object__{open/load} API instead of bpf_prog_load
>  - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
>  - find program with name explicitly instead of bpf_program__next
>  - unconditional bpf_link__destroy() on cleanup
>
> Changes in v4:
>  - bpf_link *, bpf_object * set NULL on init & err for easier destroy
>  - close bpf object with bpf_object__close()
>
>  samples/bpf/Makefile           |   4 +-
>  samples/bpf/sampleip_user.c    |  98 +++++++++++++++++++----------
>  samples/bpf/trace_event_user.c | 112 ++++++++++++++++++++++-----------
>  3 files changed, 143 insertions(+), 71 deletions(-)
>

Few more int_exit() problems, sorry I didn't catch it first few times,
I'm not very familiar with all these bpf samples.

[...]

>  all_cpu_err:
> -       for (i--; i >= 0; i--) {
> -               ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> -               close(pmu_fd[i]);
> -       }
> -       free(pmu_fd);
> +       for (i--; i >= 0; i--)
> +               bpf_link__destroy(links[i]);
> +err:
> +       free(links);
>         if (error)
>                 int_exit(0);

if (error) you should exit with error, no?

>  }
>
>  static void test_perf_event_task(struct perf_event_attr *attr)
>  {

[...]

>  err:
> -       ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> -       close(pmu_fd);
> +       bpf_link__destroy(link);
>         if (error)
>                 int_exit(0);

same comment about exiting with error

>  }
> @@ -282,7 +297,9 @@ static void test_bpf_perf_event(void)

[...]

> @@ -305,6 +343,10 @@ int main(int argc, char **argv)
>                 return 0;
>         }
>         test_bpf_perf_event();
> +       error = 0;
> +
> +cleanup:
> +       bpf_object__close(obj);
>         int_exit(0);

here and in previous sample int_exit for whatever purpose sends KILL
signal and exits with 0, that seems weird. Any idea why it was done
that way?

> -       return 0;
> +       return error;

so with that int_ext() implementation you will never get to this error

>  }
> --
> 2.25.1
>
