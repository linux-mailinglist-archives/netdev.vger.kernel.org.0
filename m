Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B778F1CB67A
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEHSB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgEHSB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:01:57 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E2EC061A0C;
        Fri,  8 May 2020 11:01:55 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so2676311iob.3;
        Fri, 08 May 2020 11:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r7bDLgNrDXeewGypNasOoqrtWded7aamzXwK9TddFBw=;
        b=LhhiM4/AQvhkEMDKaB3Tt499nsoVsXXHJ3GJd16b4ClbOqMl3jyzNTULx62GVU8RUQ
         A+U3Zd/b5P2Lr5QMm1sJXbBNbn1GN85iicHgaNpO79TW6MJWDxmXttJTKIuIJxO84gqH
         piWglqwh2W7Pq2LdLOG6ZCVWWVAD3kWMGHOzyc5H/itS1rM0L0CXTdIQ6kDTOJcw+AsG
         DO3WH/pcNruC4WfgqLgpKZKRhVnNhlx0XFZVXj1rprFr0Qfa8q2ZIUm8pKuvalf2rOBZ
         wRek5ALwth7K62kICejecwsW/nO6bf7dZ6OrTC/tUyCuFyxbm6+DdDOkAy7pKN9eOtzt
         ysFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r7bDLgNrDXeewGypNasOoqrtWded7aamzXwK9TddFBw=;
        b=WRxlYQeR+3iu3pT52wxw0WPxJzJGWsrygEZlttVN3RBF7WU4WIZD3xYo1jwBr5ETyM
         JlScXxzTh8PrMde12JcvY/iEn1zGZ2/wm8oR3DG0KX5lM+K9HMzS4T/IwVH03iwD/7zy
         ZC9C9t28e8MfGP3R+D/9ving2IuYapyES97iGyukdLtx0Y16uE0jS1RjGNM2uxf/ApLS
         2t+UHvA87lZoUQvVMMVtjHkamzKaMo1+qg7wdeh3CLovDUPpWI/dIvclOoqp2t+mbzjE
         v4v7md2MJY9IuH8pDL5D0JNRa9q3Cd1H7LtZAWv4ncXXMBKS9iuUIOaWbdWnON1D22cL
         /x7Q==
X-Gm-Message-State: AGi0PuaE8LVdF5txP5qTaz2y/RjFRtpC6aul0oc0QinoRZ8cwdtxSnpV
        zW5XVeqZFkN7QRTdJ28escg5mVVh5CjJit6r3VQh9g==
X-Google-Smtp-Source: APiQypJCMF7S9z1hk5aGez68jjhlYaSLhrxsu3yh5ngHD3YtLnhfu/RdB7zSzrqrIhxXAa2iTyZVN4WDuAck/OpuQEU=
X-Received: by 2002:a02:cd03:: with SMTP id g3mr3639823jaq.61.1588960915124;
 Fri, 08 May 2020 11:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200508070548.2358701-1-andriin@fb.com> <20200508070548.2358701-3-andriin@fb.com>
 <5eb5817b12a3b_2a992ad50b5cc5b4b7@john-XPS-13-9370.notmuch>
In-Reply-To: <5eb5817b12a3b_2a992ad50b5cc5b4b7@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:01:44 -0700
Message-ID: <CAEf4BzZ0ydoZa_Y0NvHgEqMM-QffKZW7jR4-Bxo5gr5A-Scqgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 8:57 AM John Fastabend <john.fastabend@gmail.com> wr=
ote:
>
> Andrii Nakryiko wrote:
> > Add fmod_ret BPF program to existing test_overhead selftest. Also re-im=
plement
> > user-space benchmarking part into benchmark runner to compare results. =
 Results
> > with ./bench are consistently somewhat lower than test_overhead's, but =
relative
> > performance of various types of BPF programs stay consisten (e.g., kret=
probe is
> > noticeably slower).
> >
> > To test with ./bench, the following command was used:
> >
> > for i in base kprobe kretprobe rawtp fentry fexit fmodret; \
> > do \
> >     summary=3D$(sudo ./bench -w2 -d5 -a rename-$i | \
> >               tail -n1 | cut -d'(' -f1 | cut -d' ' -f3-) && \
> >     printf "%-10s: %s\n" $i "$summary"; \
> > done
>
> might be nice to have a script ./bench_tracing_overhead.sh when its in it=
s
> own directory ./bench. Otherwise I'll have to look this up every single
> time I'm sure.

Yeah, I didn't want to pollute selftests/bpf directory, but with a
separate subdir it makes more sense. I'll put it there. For ringbuf
I'll have much longer scripts, so having them in file is a necessity.

>
> >
> > This gives the following numbers:
> >
> >   base      :    3.975 =C2=B1 0.065M/s
> >   kprobe    :    3.268 =C2=B1 0.095M/s
> >   kretprobe :    2.496 =C2=B1 0.040M/s
> >   rawtp     :    3.899 =C2=B1 0.078M/s
> >   fentry    :    3.836 =C2=B1 0.049M/s
> >   fexit     :    3.660 =C2=B1 0.082M/s
> >   fmodret   :    3.776 =C2=B1 0.033M/s
> >
> > While running test_overhead gives:
> >
> >   task_rename base        4457K events per sec
> >   task_rename kprobe      3849K events per sec
> >   task_rename kretprobe   2729K events per sec
> >   task_rename raw_tp      4506K events per sec
> >   task_rename fentry      4381K events per sec
> >   task_rename fexit       4349K events per sec
> >   task_rename fmod_ret    4130K events per sec
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> LGTM
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
