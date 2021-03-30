Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D488734EA52
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhC3OXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhC3OWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:22:49 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F59C061574;
        Tue, 30 Mar 2021 07:22:49 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id x17so16623243iog.2;
        Tue, 30 Mar 2021 07:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GNHMCs6x+dR2Cqz7tLELzE1plonqANp2Czvp+h/1Vf8=;
        b=ty8xpi5ikc4QUeUv6hKR+/9N2zPEnBot4pcKeNOEaZaJ44qTR3VEiVODng1iQmgRis
         jjDDk0eoIYssFwk+wJ7B2s3kfT/R71pLJvJ4B8H9CkvjWNxm9rkTWoptZwy4XcpzblxL
         eF3VXHAgsG1Jde5rlCkEaJOnfCBN2//1pESFyMe/88dC7rdge6niEiSGBQ2MRoPFRshu
         7/YP80DZn1AIJbsg9H8y7vKl4xf5MJVRneUpqFIwiqe610OfoNX/OTInXF4Id9YfqD52
         0/HQBm1VpzoF88NyXDbEuttpi/eEWGTH/tLwoyodHYgEZagn3+p7yM4R3wh4l2srhDEz
         wtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GNHMCs6x+dR2Cqz7tLELzE1plonqANp2Czvp+h/1Vf8=;
        b=aDL1b5g7zT+TX/69iK8bs8G9UjC/zt/26/eDiVKWgzCc73NwGg5CkIXwmEJMfKAIFc
         Wx0DRhaUZfYu2Pr5e3ksq+mz2ZGio73ldot3GOZHyS3qo2QGa0EUMXUW0HGaRzutzFOc
         mpvbzZ0iVxebY8KERYwmwU6ZpO7cGUPbcEypPG3t1Q57CBAvKqvtTV5XcwXog3RfB8Yy
         4AET2WMnfJTHDO6jG4mbHJMI7wG8gi8UA+ZkSLtIbXelpnI1w3ftkfYOHqiDs48AmggJ
         eQks6PVVClzLIXlXgVzbVnefF0JrWSwEbP26otwZtlvnzXKT1CD7bR5o+EYbkBLTOlr/
         epzA==
X-Gm-Message-State: AOAM532PZkfxhr4Dn3yKtiU1K9zu/cchBBIIYAO/++1IVtSvUdeAIkkE
        MOkqZBdDC5BKXf/D1oPkm7nkbdVBjaiEoZZk6j8lNujdZVWfmg==
X-Google-Smtp-Source: ABdhPJx2lAQsZaWZav6RqWh2dIxFsrQ79CV0iN3oKmXwGO+ztVj2DfiDBZEwagnQYov43RlS7Ml7o3bDQLfX0pI1IoM=
X-Received: by 2002:a02:c908:: with SMTP id t8mr10461264jao.78.1617114168349;
 Tue, 30 Mar 2021 07:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210328161055.257504-1-pctammela@mojatatu.com>
 <20210328161055.257504-2-pctammela@mojatatu.com> <A175BAAD-39B2-4ECE-9BA0-D070E84484FF@fb.com>
In-Reply-To: <A175BAAD-39B2-4ECE-9BA0-D070E84484FF@fb.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Tue, 30 Mar 2021 11:22:37 -0300
Message-ID: <CAKY_9u0J8gurpOhR9YZceH3N2jJFm=v5VLw3atjo==gTp_-RQg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and 'bpf_ringbuf_submit()'
To:     Song Liu <songliubraving@fb.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em seg., 29 de mar. de 2021 =C3=A0s 13:10, Song Liu <songliubraving@fb.com>=
 escreveu:
>
>
>
> > On Mar 28, 2021, at 9:10 AM, Pedro Tammela <pctammela@gmail.com> wrote:
> >
> > The current code only checks flags in 'bpf_ringbuf_output()'.
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> > include/uapi/linux/bpf.h       |  8 ++++----
> > kernel/bpf/ringbuf.c           | 13 +++++++++++--
> > tools/include/uapi/linux/bpf.h |  8 ++++----
> > 3 files changed, 19 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 100cb2e4c104..232b5e5dd045 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4073,7 +4073,7 @@ union bpf_attr {
> >  *            Valid pointer with *size* bytes of memory available; NULL=
,
> >  *            otherwise.
> >  *
> > - * void bpf_ringbuf_submit(void *data, u64 flags)
> > + * int bpf_ringbuf_submit(void *data, u64 flags)
>
> This should be "long" instead of "int".
>
> >  *    Description
> >  *            Submit reserved ring buffer sample, pointed to by *data*.
> >  *            If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notif=
ication
> > @@ -4083,9 +4083,9 @@ union bpf_attr {
> >  *            If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notif=
ication
> >  *            of new data availability is sent unconditionally.
> >  *    Return
> > - *           Nothing. Always succeeds.
> > + *           0 on success, or a negative error in case of failure.
> >  *
> > - * void bpf_ringbuf_discard(void *data, u64 flags)
> > + * int bpf_ringbuf_discard(void *data, u64 flags)
>
> Ditto. And same for tools/include/uapi/linux/bpf.h
>
> >  *    Description
> >  *            Discard reserved ring buffer sample, pointed to by *data*=
.
> >  *            If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notif=
ication
> > @@ -4095,7 +4095,7 @@ union bpf_attr {
> >  *            If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notif=
ication
> >  *            of new data availability is sent unconditionally.
> >  *    Return
> > - *           Nothing. Always succeeds.
> > + *           0 on success, or a negative error in case of failure.
> >  *
> >  * u64 bpf_ringbuf_query(void *ringbuf, u64 flags)
> >  *    Description
> > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > index f25b719ac786..f76dafe2427e 100644
> > --- a/kernel/bpf/ringbuf.c
> > +++ b/kernel/bpf/ringbuf.c
> > @@ -397,26 +397,35 @@ static void bpf_ringbuf_commit(void *sample, u64 =
flags, bool discard)
> >
> > BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
> > {
> > +     if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
> > +             return -EINVAL;
>
> We can move this check to bpf_ringbuf_commit().

I don't believe we can because in 'bpf_ringbuf_output()' the flag
checking in 'bpf_ringbuf_commit()' is already
too late.

>
> Thanks,
> Song
>
> [...]

Pedro
