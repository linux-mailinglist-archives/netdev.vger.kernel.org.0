Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07996C4091
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfJAS7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:59:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45579 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfJAS7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:59:37 -0400
Received: by mail-qk1-f195.google.com with SMTP id z67so12299969qkb.12;
        Tue, 01 Oct 2019 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDgVpSVS3j/X4E2sKRS6osVsp2VH7adg4ugDtzd2YHE=;
        b=l8b5YVFLLUkyHg5nqSUdC8sGop80xHc8CcriPRBPMhyGkbNwV+3ZfYSEhm9lns3ChN
         M1tQoQBCjo+N5iBOsCBzDaSEpefzoa6qK+CqPOqUDeHElnmaU4rWs7z7cJlEHC0/6Uff
         h9XpKuLQpatsFhFVfc+B69pKHkjSsa/xLqSQN6L31pcfgkr8TL3KDI0dR4BIDU7ufgPn
         PZEW5vZTGOT2QM/kPkDqwg8dJP1B57zRQ+t7Dvez911JdsrBXfVtsqDkrjBBpShq/wxb
         W2dYF5/oQpgRk5/K90rnVjcPI38vTjuCEnLoU7KbklnxDovkOHaZIlC2+VRKwEEou7m9
         Ax6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDgVpSVS3j/X4E2sKRS6osVsp2VH7adg4ugDtzd2YHE=;
        b=LMVuOkfziuOQnStzG4hH425VkZQLomreiZPa2yvlkTmeJDC+iejkY7FeQy7jfMCQrj
         J98bvWiyG+dUvmN/bbsxD0XFB2LUaJg0qNM38Oi7BorP7bSQ72pdlMWLg1lYGiSI/WmV
         ESJbR23kk++ujNus1BJKgDN0F5vNRpUfxNr+m3+j08C6oGXk3kLOzoaszsxOLJY0bZlj
         jmmnz8mq+7qwAdl21DAeRRpY/o6E26wu5GV890XSD3UPl3OrKp8V9tXu4stuywDC6fci
         0JJLFj5dYCVVeH4lKvF7F104p4ABvl4RlymodarfCY8FFJGehuUAPa8ggpCvAN5xuuXY
         tANg==
X-Gm-Message-State: APjAAAWwP7X3MOaXcRArYVFdEjWC4MhZMSrY24WFXdVdiZQRqwI9Dl4+
        g2wdK1Pn1s34YrGfsTfTz/rf7erwOF5ns1wspVQ=
X-Google-Smtp-Source: APXvYqyTCgkXwj/txTZ3PePkm/FPjE0ClqYNsHykHfAuC4SGSK4PSHwKHUJ+fAXoJ7C9dJOP5SuRGwikHvOc2XOddiw=
X-Received: by 2002:a37:98f:: with SMTP id 137mr8062799qkj.449.1569956375878;
 Tue, 01 Oct 2019 11:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190930164239.3697916-1-andriin@fb.com> <20191001184813.23d004d2@carbon>
In-Reply-To: <20191001184813.23d004d2@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 11:59:24 -0700
Message-ID: <CAEf4Bza5+pCJUB048HXRx9w059t-RzXuv+mC_MH5akSsr78y4Q@mail.gmail.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/
 sized opts
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 9:48 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> On Mon, 30 Sep 2019 09:42:39 -0700
> Andrii Nakryiko <andriin@fb.com> wrote:
>
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index 2e83a34f8c79..1cf2cf8d80f3 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -47,6 +47,12 @@ do {                               \
> >  #define pr_info(fmt, ...)    __pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
> >  #define pr_debug(fmt, ...)   __pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
> >
> > +#define OPTS_VALID(opts) (!(opts) || (opts)->sz >= sizeof((opts)->sz))
>
> Do be aware that C sizeof() will include the padding the compiler does.
> Thus, when extending a struct (e.g. in a newer version) the size
> (sizeof) might not actually increase (if compiler padding room exist).

Yes, that's a very good point, thanks for bringing this up!

I was debating whether OPTS_VALID should validate (similar to kernel)
that all the bytes between user's struct size and our
latest-and-greatest struct definition size are set to zero. But this
padding issue just proves it has to be done always.

And it also shows that using struct initialization to zero (or using
macro with struct field initializers) is almost a must to avoid issue
like this. On libbpf side I think we can just provide helpful message
to user, otherwise it might be hair-pulling to figure out what's
wrong.

>
> > +#define OPTS_HAS(opts, field) \
> > +     ((opts) && opts->sz >= offsetofend(typeof(*(opts)), field))
> > +#define OPTS_GET(opts, field, fallback_value) \
> > +     (OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
>
> I do think, that these two "accessor" defines address the padding issue
> I described above.
>
> p.s. I appreciate that you are working on this, and generally like the idea.

Thanks!

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
