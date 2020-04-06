Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D126919EF5E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 04:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgDFCt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 22:49:29 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43637 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgDFCt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 22:49:29 -0400
Received: by mail-qk1-f196.google.com with SMTP id 13so2547920qko.10;
        Sun, 05 Apr 2020 19:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wN6CWhojM21QuHH3oeTXSFPuTD/EyPbkWM1SkY6Dz/4=;
        b=qJ8oIbLiRmCH8zFrGi6aliIQsf9D3MbSTl152BS7FWsO5jwDWZLWsJb4VW/XK8FiUp
         oBN7dqmnLMJgPkStvouyqv6/lVGYcY+JAWtizAruYxdC2jgV/VszuYWm/6fdHmJ4r5HQ
         NVm6oofetKH39K49FrGXYuNOg2ZdLozgHW3BV6RtMAeXUcFj2HEZ1JZIGF+vZLYXBlGJ
         R+PBbJeo+K6v+B1L5FJVPXOVr+/CLz+52ROd7O20NEBlWh4Y0eMrBKdG6eN3RywOcngJ
         1CP8+kExtM1GODrJHOtjJ/Tu7s/7ffqsn6uTDRpRyQcB+z8Nww1pRejvblEh0wl2RXQW
         HvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wN6CWhojM21QuHH3oeTXSFPuTD/EyPbkWM1SkY6Dz/4=;
        b=sxjEewOWRpGC6WcVwzxwTDTmMw+SR0Q6SdvQcbmL9Iu6XZmhL8AkBxIkFq4I96G+BA
         Hbs8j4wmd6m7m+4Sc+o2gmQXUCNN7gj+QVr/SMYpRt/yyOKxYcMHYcjLa8KrGks8ZGiU
         PGGovJO0gpjhxCqbbzjpigCqAnimph2eP7VEr6LSRBSC1+lIt+t8JAZzUigCRTsMYWS6
         f55r6CvrkP63AdxNee4xl6jhNamBLePaHMl5O7e5bcrTxJODLbQ+rlS1PjdZS8tjVQSA
         7jdxJ8/MDtt1tc8+zFt3NTYRi5ANFV2n5KxLZ32NQC9VIz7Xx8oFJLtGTW07lVg94cI1
         xIFA==
X-Gm-Message-State: AGi0PuYdWILKhjiuBImyEfVkeLUKXPyKr0UEtd1sXAcc4x2AfQXp+QCp
        WKK+fO3Q2CCyn/l3rsuwmsYcSpwgjvlkC91BHDc=
X-Google-Smtp-Source: APiQypIvrd0qLVhYcL+WtDY/R1LSnMjJ5++E30iacHW9CiZBvdw+3wgfMuocvZonIJWiSmiaGntJ+Eu5SbU8FlsWkWM=
X-Received: by 2002:a37:e318:: with SMTP id y24mr19648863qki.39.1586141368479;
 Sun, 05 Apr 2020 19:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200401110907.2669564-1-jolsa@kernel.org> <20200401110907.2669564-3-jolsa@kernel.org>
 <2c93a2c75e55291473370d9805f8dd0484acd5a3.camel@chromium.org> <20200403090158.GE2784502@krava>
In-Reply-To: <20200403090158.GE2784502@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 5 Apr 2020 19:49:17 -0700
Message-ID: <CAEf4BzZziVPm_WDvu8XmZWcvzY-M3_V3niYv3=AZ_=k+WzAr=A@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Florent Revest <revest@chromium.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 2:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Apr 02, 2020 at 04:02:55PM +0200, Florent Revest wrote:
> > On Wed, 2020-04-01 at 13:09 +0200, Jiri Olsa wrote:
> > > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> > > + * Description
> > > + *         Return full path for given 'struct path' object, which
> > > + *         needs to be the kernel BTF 'path' object. The path is
> > > + *         returned in buffer provided 'buf' of size 'sz'.
> > > + *
> > > + * Return
> > > + *         length of returned string on success, or a negative
> > > + *         error in case of failure
> > > + *
> >
> > You might want to add that d_path is ambiguous since it can add
> > " (deleted)" at the end of your path and you don't know whether this is
> > actually part of the file path or not. :)
>
> right
>
> >
> > > +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> > > +{
> > > +   char *p = d_path(path, buf, sz - 1);
> >
> > I am curious why you'd use sz - 1 here? In my experience, d_path's
> > output is 0 limited so you shouldn't need to keep an extra byte for
> > that (if that was the intention here).
> >
> > > +   int len;
> > > +
> > > +   if (IS_ERR(p)) {
> > > +           len = PTR_ERR(p);
> > > +   } else {
> > > +           len = strlen(p);
> > > +           if (len && p != buf) {
> > > +                   memmove(buf, p, len);
> >
> > Have you considered returning the offset within buf instead and let the
> > BPF program do pointer arithmetics to find the beginning of the string?
>
> we could do that.. I was following some other user of d_path,
> which I can't find at the moment ;-) I'll check

This would make it hard to support variable-length data encoding and
sending it over perf_buffer, because it would prevent back-to-back
"stitching" of multiple strings compactly in output buffer. So I think
current approach is preferable.

>
> >
> > > +                   buf[len] = 0;
> >
> > If my previous comment about sz - 1 is true, then this wouldn't be
> > necessary, you could just use memmove with len + 1.
>
> hum, you might be right, I'll check on this
>
> thanks,
> jirka
>
> >
> > > +           }
> > > +   }
> > > +
> > > +   return len;
> > > +}
> >
>
