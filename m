Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52630185ADD
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgCOHIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:08:40 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36630 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgCOHIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:08:39 -0400
Received: by mail-qt1-f195.google.com with SMTP id m33so11435839qtb.3;
        Sun, 15 Mar 2020 00:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3nMYlWWwUq84qTzU+6pFvuRsqqoRM8vkv3X4IPT+9GY=;
        b=S6d1ZbjXkCkQCwLa+/6TFsNFJiEbkl6DftVhmxkZXjHY2SBrS9MPLy7OnDp5J+zsLW
         BBDAc5nD7/tvlh++3W79znio4kJGCzcqZxJCTbA4jabRcqGTemWvqyWn4LloN8coiots
         ZhREeJ2eobfwJK9vGmSBxorIoVf3jtDL23GSF8ZnlrWbefcxjg5iapF0okxvzFz+DmX5
         u3ybtqtYqF9bHxcBvrmsPKZTbjNUglf1K9PCrxd0zPtMr+LXrdctcpRf0gx/Gdlpy9o/
         32+yrLJ3nsHJYdkFxFVkR1pRYaXyNvV7LaYWVsgwO+M7Y60W4NKC+OFBC1FWF6UunCyt
         TqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3nMYlWWwUq84qTzU+6pFvuRsqqoRM8vkv3X4IPT+9GY=;
        b=bXqUmQhuLHoZqhv4PPOWrZyCf9a8jVBEmj+WXsFkfOppTSiFwonTnVZI9oxwgji+nB
         xR7auJQd+QRY5NrP4+XetkcHaRNFx5c0DAa/mCXH8Irb9zpQbNnJH+dSDQnOCtJkrdH8
         +D9tgtNb16vQEndw3IOmBle5X91c8hDQiID+9/HbACVtbzgEbu2T6ON90Qt+UH7bAUuG
         Eyj6s42wGQMXASZqvW++EvLm1JbyMdjGCC6rRP4s4e8/Xr8TqPFF/4XvnwwpMPVqi2k6
         h1oDpFHC12O55Be5aD6MJeRV3VZqDzoDF+Ze/jKWVQbQz5vAIgmXEaB7kjyuVgRmHvUu
         YcCA==
X-Gm-Message-State: ANhLgQ24qWUXpJL/7sEXskfAShq4sbGaTz1YXewFcoAzuNnYXOG3W2d0
        da34stibqDnbAtJUtCumbbzJuaBmgO/U3aUMHsoM6FHc
X-Google-Smtp-Source: ADFU+vscuUP36SLI2i8MPrCExMOmVbMqX8+YmdNat5U1K/2jn1IDN2d6dzB1kwvn3xToE4kUkTXUKziom0JqJAhcZlQ=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr12396583qtk.171.1584256118020;
 Sun, 15 Mar 2020 00:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200314034456.26847-1-danieltimlee@gmail.com>
 <20200314034456.26847-3-danieltimlee@gmail.com> <CAEf4BzZHk38KZRx5VstpPXYnFjM8OMOr1cUiSsnr_zY6v2AdJw@mail.gmail.com>
 <CAEKGpzi82ugDtCULWvFr4h19wTZMFQt6-QTUPNT_xkQWFSkbnQ@mail.gmail.com>
In-Reply-To: <CAEKGpzi82ugDtCULWvFr4h19wTZMFQt6-QTUPNT_xkQWFSkbnQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 15 Mar 2020 00:08:26 -0700
Message-ID: <CAEf4BzayAHxZ-B-ndRHf29G45nFSVtLpTLfqkSB_5SSyx39puw@mail.gmail.com>
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

On Sat, Mar 14, 2020 at 8:00 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Sun, Mar 15, 2020 at 5:07 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Mar 13, 2020 at 8:45 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> > > than the previous method using ioctl.
> > >
> > > bpf_program__attach_perf_event manages the enable of perf_event and
> > > attach of BPF programs to it, so there's no neeed to do this
> > > directly with ioctl.
> > >
> > > In addition, bpf_link provides consistency in the use of API because it
> > > allows disable (detach, destroy) for multiple events to be treated as
> > > one bpf_link__destroy. Also, bpf_link__destroy manages the close() of
> > > perf_event fd.
> > >
> > > This commit refactors samples that attach the bpf program to perf_event
> > > by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> > > removed and migrated to use libbbpf API.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> > > Changes in v2:
> > >  - check memory allocation is successful
> > >  - clean up allocated memory on error
> > >
> > > Changes in v3:
> > >  - Improve pointer error check (IS_ERR())
> > >  - change to calloc for easier destroy of bpf_link
> > >  - remove perf_event fd list since bpf_link handles fd
> > >  - use newer bpf_object__{open/load} API instead of bpf_prog_load
> > >  - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
> > >  - find program with name explicitly instead of bpf_program__next
> > >  - unconditional bpf_link__destroy() on cleanup
> > >
> > > Changes in v4:
> > >  - bpf_link *, bpf_object * set NULL on init & err for easier destroy
> > >  - close bpf object with bpf_object__close()
> > >
> > >  samples/bpf/Makefile           |   4 +-
> > >  samples/bpf/sampleip_user.c    |  98 +++++++++++++++++++----------
> > >  samples/bpf/trace_event_user.c | 112 ++++++++++++++++++++++-----------
> > >  3 files changed, 143 insertions(+), 71 deletions(-)
> > >
> >
> > Few more int_exit() problems, sorry I didn't catch it first few times,
> > I'm not very familiar with all these bpf samples.
> >
>
> No, you've catch the exact problem.
> In previous patch, it was int_exit(error) but I've revert back on this version.
> I'll explain more later.
>
>
> > [...]
> >
> > >  all_cpu_err:
> > > -       for (i--; i >= 0; i--) {
> > > -               ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> > > -               close(pmu_fd[i]);
> > > -       }
> > > -       free(pmu_fd);
> > > +       for (i--; i >= 0; i--)
> > > +               bpf_link__destroy(links[i]);
> > > +err:
> > > +       free(links);
> > >         if (error)
> > >                 int_exit(0);
> >
> > if (error) you should exit with error, no?
> >
> > >  }
> > >
> > >  static void test_perf_event_task(struct perf_event_attr *attr)
> > >  {
> >
> > [...]
> >
> > >  err:
> > > -       ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> > > -       close(pmu_fd);
> > > +       bpf_link__destroy(link);
> > >         if (error)
> > >                 int_exit(0);
> >
> > same comment about exiting with error
> >
> > >  }
> > > @@ -282,7 +297,9 @@ static void test_bpf_perf_event(void)
> >
> > [...]
> >
> > > @@ -305,6 +343,10 @@ int main(int argc, char **argv)
> > >                 return 0;
> > >         }
> > >         test_bpf_perf_event();
> > > +       error = 0;
> > > +
> > > +cleanup:
> > > +       bpf_object__close(obj);
> > >         int_exit(0);
> >
> > here and in previous sample int_exit for whatever purpose sends KILL
> > signal and exits with 0, that seems weird. Any idea why it was done
> > that way?
> >
>
> I'm not sure why the code was written like that previously. However, IMHO,
> int_exit() is used as signal handler (not only this, other samples too)
> and this function is mainly used like this.
>
> signal(SIGINT, int_exit);
>
> When the signal occurs, the function will receive signal number as first
> parameter. So the reason why I've reverted int_exit(error) to int_exit(0) is,
>
> Considering that this function is used as a signal handler,
> one function will be used for two purposes.
>
> static void int_exit(int sig)
> {
>         kill(0, SIGKILL);
>         exit(0);
> }
>
> Passing error argument will make this function to indicate error on exit or
> to indicate signal on exit. Also it is weird to pass extra argument which is
> not signal to signal handler.
>
> Actually when this int_exit() called, it will end before exit(0) and parent and
> child process will be killed with SIGKILL and the return code will be 137,
> which is 128 + 9 (SIGKILL).
>
> # ./trace_event
> # echo $?
> 137
>
> One option is to remove the int_exit() that was used to terminate during the
> process, not as a signal handler and change the logic to propagate the error
> to main. However, this can be somewhat awkward in semantics because a
> in trace_event_user.c function such as print_stacks() uses int_exit().
> (Error propagated from printing stacks? not look good to me)
>
> I not sure what is the best practice in this situation, so I just
> reverted it to original.
> Any ideas or suggestion is welcome.
>

I'd do it as simple as possible. Just exit with error (or return
error, whatever makes more sense). I don't get why signal handler code
has to be called here. SIGKILL also doesn't make any sense. Let's keep
it simple.

> > > -       return 0;
> > > +       return error;
> >
> > so with that int_ext() implementation you will never get to this error
> >
> > >  }
> > > --
> > > 2.25.1
> > >
>
> Thank you for your time and effort for the review :)
>
> Best,
> Daniel
