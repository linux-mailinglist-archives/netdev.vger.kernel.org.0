Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550828DE93
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfHNUSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:18:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35253 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfHNUSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:18:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so168456qke.2;
        Wed, 14 Aug 2019 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zn5OY7qtTY8/SyRXwm9IflvgFXbwJ9NOa9Xd8Lg4Njc=;
        b=BuP63IQ8M8WPhQVn2WX5hNOOKyrOYdhWp83fFvNhiQ/Y+xa6p6WnFoT9weFWlq9gtm
         Rj1IsqMjsiApbMM9dwfsuOsrNhNYsM7DYRwuenNQ3oYH/Qf22Qp41qwlsHsNhwgyZBEM
         CTlyik0fO/J1hsV55coCdIMBgD6JJvL0tiyuydSO8NilCO4oSJ8ZL1geL6TJMJ7hQ8yU
         iK8XBkeCX22VYiY0K0FPO5+We61Vzf7+vzatxZe8vluVEt/YhevenEcVkaMP92fvSleo
         LwmLjEswipdlgkkoYfeu2sAOGnFQdZH6Cpjuio63wk1a+Jn3uXTtmwOjecl8pMajQR9U
         FL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zn5OY7qtTY8/SyRXwm9IflvgFXbwJ9NOa9Xd8Lg4Njc=;
        b=O4PhcbzRNUxcsPy4iUr6RW04YsdBwA1zxsr+cZ5POCFAsFr83efazu3d4c1NOIZj88
         k1TnBl9E/rkPBDM+EYUXU8LzK+lGbsyKnDu5a0/eJSXqwI44cGP2usLs5iqN0J6Dvjnz
         BYE2UV0Rb9krciXwHCIqK5sXPahsOPzUqeuXgP8VCvR47O+IgPBUoCpUF4pT6Gknjx3a
         gnEg2ygtS28l++aJ2xjzOxQ35YfW6RiBSB9w1ch+ogPPlMkXJXSvsHIVXrWY6R89G/BS
         YkLrezYVPIlQE0Mkcyr3hpoTcGStG+OlWu80LnNUk8nP1EdrT59rX63HRK7uvHgFfKiE
         4PDw==
X-Gm-Message-State: APjAAAUKiefuJSvtOogDR9LKbQkgRRff1ne/khYiuCAgZa7Ox1BRBKzg
        vswdzBvkzo2ihI+GyBImmHkGbsLeVHDxLnfzDQWBDmDVVH0OEw==
X-Google-Smtp-Source: APXvYqy2jlTraKUIsacId1r7iyieBlfez2kGtVZANNEnjs51VS6v9JdwAS0YJJJ+omNOMaTC77awFz9eeSDAYH7oHWQ=
X-Received: by 2002:a37:660d:: with SMTP id a13mr1140074qkc.36.1565813918274;
 Wed, 14 Aug 2019 13:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp> <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
 <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com> <CAADnVQJE2DCU0J2_d4Z-1cmXZsb_q2FODcbC1S24C0f=_b2ffg@mail.gmail.com>
 <bec14521-dec1-5e1b-2f29-5c0492500272@netronome.com>
In-Reply-To: <bec14521-dec1-5e1b-2f29-5c0492500272@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 13:18:27 -0700
Message-ID: <CAEf4BzYqsT4OmWQ9WK9dmnKT9cMcjbhgHZmboUBgkEvtbaeUeA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map entries
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:12 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-08-14 09:58 UTC-0700 ~ Alexei Starovoitov
> <alexei.starovoitov@gmail.com>
> > On Wed, Aug 14, 2019 at 9:45 AM Edward Cree <ecree@solarflare.com> wrote:
> >>
> >> On 14/08/2019 10:42, Quentin Monnet wrote:
> >>> 2019-08-13 18:51 UTC-0700 ~ Alexei Starovoitov
> >>> <alexei.starovoitov@gmail.com>
> >>>> The same can be achieved by 'bpftool map dump|grep key|wc -l', no?
> >>> To some extent (with subtleties for some other map types); and we use a
> >>> similar command line as a workaround for now. But because of the rate of
> >>> inserts/deletes in the map, the process often reports a number higher
> >>> than the max number of entries (we observed up to ~750k when max_entries
> >>> is 500k), even is the map is only half-full on average during the count.
> >>> On the worst case (though not frequent), an entry is deleted just before
> >>> we get the next key from it, and iteration starts all over again. This
> >>> is not reliable to determine how much space is left in the map.
> >>>
> >>> I cannot see a solution that would provide a more accurate count from
> >>> user space, when the map is under pressure?
> >> This might be a really dumb suggestion, but: you're wanting to collect a
> >>  summary statistic over an in-kernel data structure in a single syscall,
> >>  because making a series of syscalls to examine every entry is slow and
> >>  racy.  Isn't that exactly a job for an in-kernel virtual machine, and
> >>  could you not supply an eBPF program which the kernel runs on each entry
> >>  in the map, thus supporting people who want to calculate something else
> >>  (mean, min and max, whatever) instead of count?
> >
> > Pretty much my suggestion as well :)

I also support the suggestion to count it from BPF side. It's flexible
and powerful approach and doesn't require adding more and more nuanced
sub-APIs to kernel to support subset of bulk operations on map
(subset, because we'll expose count, but what about, e.g., p50, etc,
there will always be something more that someone will want and it just
doesn't scale).

> >
> > It seems the better fix for your nat threshold is to keep count of
> > elements in the map in a separate global variable that
> > bpf program manually increments and decrements.
> > bpftool will dump it just as regular map of single element.
> > (I believe it doesn't recognize global variables properly yet)
> > and BTF will be there to pick exactly that 'count' variable.
> >
>
> It would be with an offloaded map, but yes, I suppose we could keep
> track of the numbers in a separate map. We'll have a look into this.

See if you can use a global variable, that way you completely
eliminate any overhead from BPF side of things, except for atomic
increment.

>
> Thanks to both of you for the suggestions.
> Quentin
