Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E83FD8D2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 13:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbhIALei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 07:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243809AbhIALeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 07:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630496020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qfiHKoT5MN3E0ZiaC3Ojbhr2s8ndIKXzF4a+608y18Y=;
        b=WhOFPoeelhPfEhfq1tDGjC+IkRAw/FJLiBET/e5QYrbTgE6beaGU6rVxrBFaxg+6PfKY46
        mCA1ANaOHPjAW+qUerqrFE75L5FsSaCf54tSqtyBVWXEzDJ5v9RI086S9WyL8C+Jrrh0y0
        wtEptMLz13/qwzsjsDgycuLmMkF5beE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-jaS8SFMoM-6Z29LvFtgM6g-1; Wed, 01 Sep 2021 07:33:39 -0400
X-MC-Unique: jaS8SFMoM-6Z29LvFtgM6g-1
Received: by mail-wm1-f71.google.com with SMTP id j145-20020a1c2397000000b002ea321114f7so876320wmj.7
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 04:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qfiHKoT5MN3E0ZiaC3Ojbhr2s8ndIKXzF4a+608y18Y=;
        b=S0McLmJ4JFQrYXwiPDyupCvr11sZWqAgGTJNfizbXDq+U0HFffaGmXiQr53KJ88JMJ
         gbVnW1k1a77yOXspatc7fzvLiNSF3QbD4DSkG4P7Z3j9NvlLb1mig+82VILrSPdH5HR8
         eHbdlea3cKwWYMJgSSbuH2afiAxCVbOUrHj87j3VfylHsNAj3CXCNIreCze9lmivSSfu
         kRTW4y2Bmpdnw67h+NGdRaCpBgeoLx3JfroOQJSC1xjkm2cS5XWwLeXltPBRbkBXAMsW
         jqnEdvPNoGjEoC/QdpYdlMNH+tdCU4sWkUOOBWQzw33HLOwefHG1PxqS6zIozqtcE7aQ
         UfMA==
X-Gm-Message-State: AOAM532Fc0kSBo3JbF+LI4orYAD5LLPHsEDQDkK8f97YbE/GyPIQtR/H
        arN7MPFa7br1kskOVLQmAJmOHQdL9sPFfnFRQzR7bu9EjhpALIdFfphZn7nFlDJtaJVkniOLu0Y
        d2dVGNtJVgtj/g/ze
X-Received: by 2002:a1c:a793:: with SMTP id q141mr9140707wme.157.1630496018355;
        Wed, 01 Sep 2021 04:33:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzllkDttpmad/9xB6vvxRknNjVlOeQdBWPPTb+XT8cgjYVQinKRakHvxZHkpXDGSFNm9zwh6Q==
X-Received: by 2002:a1c:a793:: with SMTP id q141mr9140689wme.157.1630496018186;
        Wed, 01 Sep 2021 04:33:38 -0700 (PDT)
Received: from krava ([94.113.247.3])
        by smtp.gmail.com with ESMTPSA id c1sm4990023wml.33.2021.09.01.04.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 04:33:37 -0700 (PDT)
Date:   Wed, 1 Sep 2021 13:33:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 20/27] libbpf: Add btf__find_by_glob_kind
 function
Message-ID: <YS9lD5r7HSAuh+MR@krava>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210826193922.66204-21-jolsa@kernel.org>
 <CAEf4BzaxuWMDW5shE_LuAkHfy0rkbdd05t9QAtL4j9XPZ1_rYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaxuWMDW5shE_LuAkHfy0rkbdd05t9QAtL4j9XPZ1_rYQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 05:10:52PM -0700, Andrii Nakryiko wrote:
> On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding btf__find_by_glob_kind function that returns array of
> > BTF ids that match given kind and allow/deny patterns.
> >
> > int btf__find_by_glob_kind(const struct btf *btf, __u32 kind,
> >                            const char *allow_pattern,
> >                            const char *deny_pattern,
> >                            __u32 **__ids);
> >
> > The __ids array is allocated and needs to be manually freed.
> >
> > At the moment the supported pattern is '*' at the beginning or
> > the end of the pattern.
> >
> > Kindly borrowed from retsnoop.
> >
> > Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/btf.c | 80 +++++++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/btf.h |  3 ++
> >  2 files changed, 83 insertions(+)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 77dc24d58302..5baaca6c3134 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -711,6 +711,86 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
> >         return libbpf_err(-ENOENT);
> >  }
> >
> > +/* 'borrowed' from retsnoop */
> > +static bool glob_matches(const char *glob, const char *s)
> > +{
> > +       int n = strlen(glob);
> > +
> > +       if (n == 1 && glob[0] == '*')
> > +               return true;
> > +
> > +       if (glob[0] == '*' && glob[n - 1] == '*') {
> > +               const char *subs;
> > +               /* substring match */
> > +
> > +               /* this is hacky, but we don't want to allocate for no good reason */
> > +               ((char *)glob)[n - 1] = '\0';
> > +               subs = strstr(s, glob + 1);
> > +               ((char *)glob)[n - 1] = '*';
> > +
> > +               return subs != NULL;
> > +       } else if (glob[0] == '*') {
> > +               size_t nn = strlen(s);
> > +               /* suffix match */
> > +
> > +               /* too short for a given suffix */
> > +               if (nn < n - 1)
> > +                       return false;
> > +
> > +               return strcmp(s + nn - (n - 1), glob + 1) == 0;
> > +       } else if (glob[n - 1] == '*') {
> > +               /* prefix match */
> > +               return strncmp(s, glob, n - 1) == 0;
> > +       } else {
> > +               /* exact match */
> > +               return strcmp(glob, s) == 0;
> > +       }
> > +}
> > +
> > +int btf__find_by_glob_kind(const struct btf *btf, __u32 kind,
> > +                          const char *allow_pattern, const char *deny_pattern,
> > +                          __u32 **__ids)
> > +{
> > +       __u32 i, nr_types = btf__get_nr_types(btf);
> > +       int cnt = 0, alloc = 0;
> > +       __u32 *ids = NULL;
> > +
> > +       for (i = 1; i <= nr_types; i++) {
> > +               const struct btf_type *t = btf__type_by_id(btf, i);
> > +               bool match = false;
> > +               const char *name;
> > +               __u32 *p;
> > +
> > +               if (btf_kind(t) != kind)
> > +                       continue;
> > +               name = btf__name_by_offset(btf, t->name_off);
> > +               if (!name)
> > +                       continue;
> > +
> > +               if (allow_pattern && glob_matches(allow_pattern, name))
> > +                       match = true;
> > +               if (deny_pattern && !glob_matches(deny_pattern, name))
> > +                       match = true;
> 
> this is wrong, if it matches both deny and allow patterns, you'll
> still pass it through. Drop the match flag, just check deny first and
> `continue` if matches.

true, ok

> 
> > +               if (!match)
> > +                       continue;
> > +
> > +               if (cnt == alloc) {
> > +                       alloc = max(100, alloc * 3 / 2);
> 
> nit: maybe start with something like 16?

ok

> 
> > +                       p = realloc(ids, alloc * sizeof(__u32));
> 
> we have libbpf_reallocarray, please use it

ok

> 
> > +                       if (!p) {
> > +                               free(ids);
> > +                               return -ENOMEM;
> > +                       }
> > +                       ids = p;
> > +               }
> > +               ids[cnt] = i;
> > +               cnt++;
> > +       }
> > +
> > +       *__ids = ids;
> > +       return cnt ?: -ENOENT;
> 
> cnt == 0 means -ENOENT, basically, no? It's up to the application to
> decide if that's an error, let's just return the number of matches,
> i.e., zero.

ok

thanks,
jirka

