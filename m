Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8373B18532D
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCNAKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:10:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46776 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgCNAKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:10:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id t13so9205085qtn.13;
        Fri, 13 Mar 2020 17:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fFSXCfPxZ44Gnna3dml1rVBvXL2ix7ceGBfMvBZcWhM=;
        b=UkdDesbXxDUbg/DWkkM7sHPh9FhVdTbptkUsIMGIMH8oIJNK4CeqEW4mizy05MukkY
         Wts6bS3oPfdRBlMrUsN0XD4L2kySfaN64YKwJ0rmfz0Tts1ja6sF4BaI5RLHjeRHsxY5
         5dzmJ+ieanG7C0Yf/ZkYE+m6/fxyTbNNEIkqUSsTFOMdlL8DrQBXKITZo4BzAA1L/Npo
         Z4oyOe7k7HnUy4qrGzofXI167Rv8R68BKgMqg/bzyvFDJavhol2wui3184MjBgzvVHrh
         wQQqz5n7vN/wa8A29HqU75LAXCtJjWupVgN01of7YFROdlA6sx0B/ZGNOnrJqfFYjIlA
         /cgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fFSXCfPxZ44Gnna3dml1rVBvXL2ix7ceGBfMvBZcWhM=;
        b=iqy5WEYIGwThoWj/8l4++ruAWy5BnBF3Y0CPMsu/HrTCUSDXXuHeqJPj6gtEK2zhTM
         n23DbHxbm04T2Q4DlRPqxDJ/+jd4ahIqRS7Qz2ic5AJ9m6FYyhru/l3jkma8OuWVxTuK
         i3sVBPrfy4deDXNRFunNNRiKwluGRCc07kHEQdepTz+Zbmu6FCVBgR5V/8ITyuSEFj/G
         wdf3jtCTBR4JLoWw5LheEjyEGPNZf12yFvUBHQmzHmAjv7BIbNH9Z908SS0H1y2GgW3C
         T5w8US2UZJBWhmExcofBAd0RGCx5lecjIiUitTo/9N4ijAhJe8O5iFSwKe0hYekvcpqu
         mIGA==
X-Gm-Message-State: ANhLgQ1l7nsWXetQhPjbJCnEcypE5fMHX+B5HitUUpdyebgxPpdNfBJm
        vXE/B1pA06s7O/oME2OeGanVH9owmXnMyf3ZS+Y=
X-Google-Smtp-Source: ADFU+vsgImTQTIJZ5OGL/TViJc/xh0JVJ3pvrUibZAduISBqK1IMILlfRzrNz6b8LLekW4ilQ2KdjtG5wDQH8gCM6Ho=
X-Received: by 2002:ac8:4e14:: with SMTP id c20mr14992805qtw.141.1584144640839;
 Fri, 13 Mar 2020 17:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200313233535.3557677-1-andriin@fb.com> <20200314000510.cmsepdhnywtglrcm@kafai-mbp>
In-Reply-To: <20200314000510.cmsepdhnywtglrcm@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Mar 2020 17:10:29 -0700
Message-ID: <CAEf4BzbKAz699qu0ae=A_8WryUXWywXDJm17d4ogp8x=oHXa_Q@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] selftests/bpf: fix nanosleep
 for real this time
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 5:05 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Mar 13, 2020 at 04:35:35PM -0700, Andrii Nakryiko wrote:
> > Amazingly, some libc implementations don't call __NR_nanosleep syscall from
> > their nanosleep() APIs. Hammer it down with explicit syscall() call and never
> > get back to it again. Also simplify code for timespec initialization.
> >
> > I verified that nanosleep is called w/ printk and in exactly same Linux image
> > that is used in Travis CI. So it should both sleep and call correct syscall.
> >
> > Fixes: 4e1fd25d19e8 ("selftests/bpf: Fix usleep() implementation")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index f85a06512541..6956d722a463 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -35,16 +35,12 @@ struct prog_test_def {
> >   */
> >  int usleep(useconds_t usec)
> >  {
> > -     struct timespec ts;
> > -
> > -     if (usec > 999999) {
> > -             ts.tv_sec = usec / 1000000;
> > -             ts.tv_nsec = usec % 1000000;
> > -     } else {
> > -             ts.tv_sec = 0;
> > -             ts.tv_nsec = usec;
> > -     }
> > -     return nanosleep(&ts, NULL);
> > +     struct timespec ts = {
> > +             .tv_sec = usec / 1000000,
> > +             .tv_nsec = usec % 1000000,
> usec is in micro and tv_nsec is in nano?
>

Yes, this is implementation of usleep() (microsecond sleep), so usec
is microseconds. We call nanosleep internally, though, which accepts
seconds and nanoseconds units. Did I mess up math here?

But either way, sending v2, there is another place we explicitly are
calling nanosleep as well, fixing that one as well.

> > +     };
> > +
> > +     return syscall(__NR_nanosleep, &ts, NULL);
> >  }
> >
