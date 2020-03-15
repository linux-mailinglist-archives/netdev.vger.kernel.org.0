Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F75C185983
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCODAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:00:04 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46192 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCODAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:00:04 -0400
Received: by mail-qk1-f196.google.com with SMTP id f28so20074662qkk.13;
        Sat, 14 Mar 2020 20:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hy6Hpt/byxt7YG6bMmh5Wt+6YXRWMDbd956TqtsgPoM=;
        b=N1SIIptkyVu0bnPRr1X+9vB10u5VxtKKSPeaKf82MARMaGgJhRNtm/YOUuVoaj6mWy
         TKHsS3Fyt6O7e+A9qhmU9dLG7khsqVbPNX40G8FmCpUn9166xHGyCzbaJkYuo3Z5o/Zn
         mQs8pMTYjJYrQsHF4arniVZ76I1MPtC8PibwOuepTon9Sid6hMcvybCvkJU1a5iR1cme
         ncZl8DV12gGcSysif0cc5gPJUjLqHzneXnXk2ZN5pS2AxAKtdvjDrLNkhVjLh5eR92Im
         YMnKMer+q/9K8Pighm+rMqeUtSNuF7Js3rCoMcUguTnQztvzldhBKg2aH33sEvpb6uKU
         xOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hy6Hpt/byxt7YG6bMmh5Wt+6YXRWMDbd956TqtsgPoM=;
        b=dQ1iLY7XTFemCP78tZ+KyD8z7HDoTs+qX2B0ebu6fxG8YuectY+7nIeyh5Sq/ASeCz
         eYwDQcXuOG+lYYAJZN5QUtwrvmloZ5l1tv8BM6fOEVXuVrIrekLcwCfCwJa/QbxIvBjj
         1PiVByVgCFtd/CMbgfShT8R2AzQy/ABjUY2p9hPnlDU7ddyGCJFbgLIatcmhCO3k0OAt
         JAkxQDXtWu8Ykx2GQNtez0Fndb08n8A4W8vTgVJgOuD/5+huHQhefRc2989bOAkYgVbB
         glas6uBK73H524F8RiSvm9+rucXKwXVrooVfjOHpMrcDpp8C4bt2jr5GX+k0f3d9J8tU
         VUig==
X-Gm-Message-State: ANhLgQ1CV0xPNhuNyEJq2X2ffL5vWza3UkhsqdOGiCtmAu9SNLKyEbdD
        5OYOBAWDLxLxFG8vpZTqzsTFv3uCz+53lOQoCw==
X-Google-Smtp-Source: ADFU+vuNEzUMw87pGiKUDhatJT5ZIPWK4VhX8lP5NrXYEalTcpu76nrzuSJdzsMsZkasN8A22YE8r+NgFGN+Wy0BqBY=
X-Received: by 2002:a25:1485:: with SMTP id 127mr26357959ybu.464.1584241202467;
 Sat, 14 Mar 2020 20:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200314034456.26847-1-danieltimlee@gmail.com>
 <20200314034456.26847-3-danieltimlee@gmail.com> <CAEf4BzZHk38KZRx5VstpPXYnFjM8OMOr1cUiSsnr_zY6v2AdJw@mail.gmail.com>
In-Reply-To: <CAEf4BzZHk38KZRx5VstpPXYnFjM8OMOr1cUiSsnr_zY6v2AdJw@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sun, 15 Mar 2020 11:59:48 +0900
Message-ID: <CAEKGpzi82ugDtCULWvFr4h19wTZMFQt6-QTUPNT_xkQWFSkbnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 5:07 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Mar 13, 2020 at 8:45 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> > than the previous method using ioctl.
> >
> > bpf_program__attach_perf_event manages the enable of perf_event and
> > attach of BPF programs to it, so there's no neeed to do this
> > directly with ioctl.
> >
> > In addition, bpf_link provides consistency in the use of API because it
> > allows disable (detach, destroy) for multiple events to be treated as
> > one bpf_link__destroy. Also, bpf_link__destroy manages the close() of
> > perf_event fd.
> >
> > This commit refactors samples that attach the bpf program to perf_event
> > by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> > removed and migrated to use libbbpf API.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >  - check memory allocation is successful
> >  - clean up allocated memory on error
> >
> > Changes in v3:
> >  - Improve pointer error check (IS_ERR())
> >  - change to calloc for easier destroy of bpf_link
> >  - remove perf_event fd list since bpf_link handles fd
> >  - use newer bpf_object__{open/load} API instead of bpf_prog_load
> >  - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
> >  - find program with name explicitly instead of bpf_program__next
> >  - unconditional bpf_link__destroy() on cleanup
> >
> > Changes in v4:
> >  - bpf_link *, bpf_object * set NULL on init & err for easier destroy
> >  - close bpf object with bpf_object__close()
> >
> >  samples/bpf/Makefile           |   4 +-
> >  samples/bpf/sampleip_user.c    |  98 +++++++++++++++++++----------
> >  samples/bpf/trace_event_user.c | 112 ++++++++++++++++++++++-----------
> >  3 files changed, 143 insertions(+), 71 deletions(-)
> >
>
> Few more int_exit() problems, sorry I didn't catch it first few times,
> I'm not very familiar with all these bpf samples.
>

No, you've catch the exact problem.
In previous patch, it was int_exit(error) but I've revert back on this version.
I'll explain more later.


> [...]
>
> >  all_cpu_err:
> > -       for (i--; i >= 0; i--) {
> > -               ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> > -               close(pmu_fd[i]);
> > -       }
> > -       free(pmu_fd);
> > +       for (i--; i >= 0; i--)
> > +               bpf_link__destroy(links[i]);
> > +err:
> > +       free(links);
> >         if (error)
> >                 int_exit(0);
>
> if (error) you should exit with error, no?
>
> >  }
> >
> >  static void test_perf_event_task(struct perf_event_attr *attr)
> >  {
>
> [...]
>
> >  err:
> > -       ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> > -       close(pmu_fd);
> > +       bpf_link__destroy(link);
> >         if (error)
> >                 int_exit(0);
>
> same comment about exiting with error
>
> >  }
> > @@ -282,7 +297,9 @@ static void test_bpf_perf_event(void)
>
> [...]
>
> > @@ -305,6 +343,10 @@ int main(int argc, char **argv)
> >                 return 0;
> >         }
> >         test_bpf_perf_event();
> > +       error = 0;
> > +
> > +cleanup:
> > +       bpf_object__close(obj);
> >         int_exit(0);
>
> here and in previous sample int_exit for whatever purpose sends KILL
> signal and exits with 0, that seems weird. Any idea why it was done
> that way?
>

I'm not sure why the code was written like that previously. However, IMHO,
int_exit() is used as signal handler (not only this, other samples too)
and this function is mainly used like this.

signal(SIGINT, int_exit);

When the signal occurs, the function will receive signal number as first
parameter. So the reason why I've reverted int_exit(error) to int_exit(0) is,

Considering that this function is used as a signal handler,
one function will be used for two purposes.

static void int_exit(int sig)
{
        kill(0, SIGKILL);
        exit(0);
}

Passing error argument will make this function to indicate error on exit or
to indicate signal on exit. Also it is weird to pass extra argument which is
not signal to signal handler.

Actually when this int_exit() called, it will end before exit(0) and parent and
child process will be killed with SIGKILL and the return code will be 137,
which is 128 + 9 (SIGKILL).

# ./trace_event
# echo $?
137

One option is to remove the int_exit() that was used to terminate during the
process, not as a signal handler and change the logic to propagate the error
to main. However, this can be somewhat awkward in semantics because a
in trace_event_user.c function such as print_stacks() uses int_exit().
(Error propagated from printing stacks? not look good to me)

I not sure what is the best practice in this situation, so I just
reverted it to original.
Any ideas or suggestion is welcome.

> > -       return 0;
> > +       return error;
>
> so with that int_ext() implementation you will never get to this error
>
> >  }
> > --
> > 2.25.1
> >

Thank you for your time and effort for the review :)

Best,
Daniel
