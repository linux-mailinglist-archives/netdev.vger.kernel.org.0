Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08E813B2C7
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgANTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:13:59 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44886 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgANTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:13:59 -0500
Received: by mail-qt1-f196.google.com with SMTP id t3so13446288qtr.11;
        Tue, 14 Jan 2020 11:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MFqB+06rBeER++BRySglojh7CJB3/vJLed3nR17srZY=;
        b=Cr1uy4rA/yc63G/NYnYI6sGqCHjIbj2TiaQVLsKC492L5usjwa9oleTsoZYu7gfzAz
         fViS+p1sEET0HTnq0582qDyZfsPjAw9Ra2caO/4j6osRwltuRqO4/3vDtygeKSJc5Isd
         5OXxYJlilf3YnCifUUYtc59aGVj8cejFf5udT1ze8tUSnxdZg+oZDuh75TG2ov1we41u
         5wuNe7KELTyQuRDb+nQ6wVTXB5CRurnsWsmU2IV5cbDT/ZGTWhRWaQV9TnDXkS8+Fq8t
         nBf+mW01SclboYCRG+sxLVUG8YtFgwpfHnPt2yo7FFNV0j1WgVRego3SjXeap6hREQk6
         WBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MFqB+06rBeER++BRySglojh7CJB3/vJLed3nR17srZY=;
        b=RZl0rP21WpIFESdYGs2F//HMoxhqAaE0qgc4q7BGZqRF6yXRnAbGWhWtCTKfd3cZ1j
         t+/YzU0UXva+qpWsF7uWtisRxLKMg7DkCHwKNr2wyewSKceFrua7MHi+x78fMFb386SD
         bi/JaGWYHLCjX4cVJQod+f+B0Nmy9z4A5Ftz/R4BwnGaFFetvVyLpptEpHDGbyfcNSYQ
         iCuZiWrEwDHjHJQlNEFdHipeLBV+7s+aU1qp8Q1QG0l8sHeXxWRd/ARu2FhcBNO7Exf9
         M4DqcgnGqS0On0hABrgt0HjkTpUdrE1q6BnV1+UYs7ravOjdnuEr102enN0xw4Qu1QEq
         g1iA==
X-Gm-Message-State: APjAAAUHqwlR1+E4oRJAtd+kJcJc9UrflkD8AKj/Hs+i4JAqiB6TEKN/
        kyCXwP1HDUzcpZtDZXE33+md3LXwBiMYJtpkrKtG3HRs
X-Google-Smtp-Source: APXvYqzlubP7Me7CKiqxoDf6GVTcdnAviypa3ckAtyf8BEQW1oEW0BFawdKK8kqKdvmjfa1uBN2JxgI5I5GwUsEjXcc=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr72065qtu.141.1579029238026;
 Tue, 14 Jan 2020 11:13:58 -0800 (PST)
MIME-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com> <20200114164614.47029-9-brianvv@google.com>
 <CAEf4BzYEGv-q7p0rK-d94Ng0fyQLuTEvsy1ZSzTdk0xZcyibQA@mail.gmail.com> <CAMzD94ScYuQfvx2FLY7RAzgZ8xO-E31L79dGEJH-tNDKJzrmOg@mail.gmail.com>
In-Reply-To: <CAMzD94ScYuQfvx2FLY7RAzgZ8xO-E31L79dGEJH-tNDKJzrmOg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 11:13:47 -0800
Message-ID: <CAEf4BzZHFaCGNg21VuWywB0Qsa_AkqDPnM4k_pcU_ssmFjd0Yg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 7/9] libbpf: add libbpf support to batch ops
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 10:54 AM Brian Vazquez <brianvv@google.com> wrote:
>
> On Tue, Jan 14, 2020 at 10:36 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jan 14, 2020 at 8:46 AM Brian Vazquez <brianvv@google.com> wrote:
> > >
> > > From: Yonghong Song <yhs@fb.com>
> > >
> > > Added four libbpf API functions to support map batch operations:
> > >   . int bpf_map_delete_batch( ... )
> > >   . int bpf_map_lookup_batch( ... )
> > >   . int bpf_map_lookup_and_delete_batch( ... )
> > >   . int bpf_map_update_batch( ... )
> > >
> > > Signed-off-by: Yonghong Song <yhs@fb.com>
> > > ---
> > >  tools/lib/bpf/bpf.c      | 60 ++++++++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/bpf.h      | 22 +++++++++++++++
> > >  tools/lib/bpf/libbpf.map |  4 +++
> > >  3 files changed, 86 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > index 500afe478e94a..12ce8d275f7dc 100644
> > > --- a/tools/lib/bpf/bpf.c
> > > +++ b/tools/lib/bpf/bpf.c
> > > @@ -452,6 +452,66 @@ int bpf_map_freeze(int fd)
> > >         return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
> > >  }
> > >
> > > +static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
> > > +                               void *out_batch, void *keys, void *values,
> > > +                               __u32 *count,
> > > +                               const struct bpf_map_batch_opts *opts)
> > > +{
> > > +       union bpf_attr attr = {};
> > > +       int ret;
> > > +
> > > +       if (!OPTS_VALID(opts, bpf_map_batch_opts))
> > > +               return -EINVAL;
> > > +
> > > +       memset(&attr, 0, sizeof(attr));
> > > +       attr.batch.map_fd = fd;
> > > +       attr.batch.in_batch = ptr_to_u64(in_batch);
> > > +       attr.batch.out_batch = ptr_to_u64(out_batch);
> > > +       attr.batch.keys = ptr_to_u64(keys);
> > > +       attr.batch.values = ptr_to_u64(values);
> > > +       if (count)
> > > +               attr.batch.count = *count;
> > > +       attr.batch.elem_flags  = OPTS_GET(opts, elem_flags, 0);
> > > +       attr.batch.flags = OPTS_GET(opts, flags, 0);
> > > +
> > > +       ret = sys_bpf(cmd, &attr, sizeof(attr));
> > > +       if (count)
> > > +               *count = attr.batch.count;
> >
> > what if syscall failed, do you still want to assign *count then?
>
> Hi Andrii, thanks for taking a look.
>
> attr.batch.count should report the number of entries correctly
> processed before finding and error, an example could be when you
> provided a buffer for 3 entries and the map only has 1, ret is going
> to be -ENOENT meaning that you traversed the map and you still want to
> assign *count.

ah, ok, tricky semantics :) if syscall failed before kernel got to
updating count, I'm guessing it is guaranteed to preserve old value?

>
> That being said, the condition 'if (count)' is wrong and I think it
> should be removed.

So count is mandatory, right? In that case both `if (count)` checks are wrong.

>
> >
> > > +
> > > +       return ret;
> > > +}
> > > +
> >
> > [...]
