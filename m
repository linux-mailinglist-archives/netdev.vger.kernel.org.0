Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B4519B4CA
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732354AbgDARkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:40:06 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42857 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732196AbgDARkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:40:06 -0400
Received: by mail-qv1-f67.google.com with SMTP id ca9so140942qvb.9;
        Wed, 01 Apr 2020 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fX422TdFozt80QVZChxuC9EZU3f392RlNKEmnBWdj2Q=;
        b=evA/xkHmMTT1gdc2DMiGqvAp5PmGJdk3+ajrrEYoe0lM0s2K4+LjcPtnxkakvxWKLg
         85/Z67bIVXJDSph1jVYaCQQp1lGJXM6EjVZa0nh+A+tHo1G54GcTvwK0aD2jlSKji9jM
         9/EUQUZD/2zHxX1TOCvJSaSQeoSffDev2ffIGsQ31aObkzWHbsrM3iI5mOnYEvgihprx
         Q162j1mw1mPbfYsgl5Z8CCfzOcEBEGwutQ5fkrGo5/G+T/ffkQo0gTq2sZd0wOHJoNmW
         tdsLr0ZDNk7108B3CKsmoVff22Z2dGVSwJ3lR8Q+hFOd3AVq9etm8EQtLj5IgGuQ+6Tk
         i/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fX422TdFozt80QVZChxuC9EZU3f392RlNKEmnBWdj2Q=;
        b=CwHXXYoooILjugsme0QQ/vRYmCVdg5M++ibGQ5YYXpk/O/ukHQ8gLuL17Z1EP1UkgQ
         v3l+c24ElTG9HIyfIxCUrCbR6fgCVkrKzcQo+zkql4SJ412NUFsVteuEGdINoEHSArZX
         y1afUyvFWnHeJHN9A1Fpxct++5KIg0D70XyGYK/s9V1lrtA23KVwA4MHXBft0VwEEpLO
         d2rATNl7vzqWi+08ozURkg4w0aZxxRdXIcZEgqdVGWaNIPngtwU+GtVImka1/77+Rf2V
         hWBxTF2bq4uHmpdU/R73mUFlJxtAC0plnhXvtRvYBzqpNT5JsX2CW8TcVyN5iuGC5+of
         kg5A==
X-Gm-Message-State: ANhLgQ3fXSDLj45YI8Vl1zKd3QPDNl0IVr+dwmd0Ux0P/0DRqYLReEYs
        ZAM2i+wLxIkRttiK/H6pmDVFzugUEtaRUZ3lQgs=
X-Google-Smtp-Source: ADFU+vtuM30vCozCzySnSiOkT0yB9mHAUljvdphtZTXt9gEG66IVNpXLZbaI+n+Ng9gXXFojDtAlmfiIRhiiqTbDI2Q=
X-Received: by 2002:a0c:8525:: with SMTP id n34mr22646713qva.224.1585762804641;
 Wed, 01 Apr 2020 10:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com> <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com> <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com> <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com> <CAEf4Bza1ueH=SUccfDNScRyURFoQfa1b2z-x1pOfVXuSpGUpmQ@mail.gmail.com>
 <e9e81427-c0d7-4a1e-ba9b-c51fd3c683ac@solarflare.com>
In-Reply-To: <e9e81427-c0d7-4a1e-ba9b-c51fd3c683ac@solarflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Apr 2020 10:39:53 -0700
Message-ID: <CAEf4BzYj8F05Z_e7SnkG_WvM_S191mNbtzP=cqzF85BUjdLfVg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Edward Cree <ecree@solarflare.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 1, 2020 at 7:26 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 01/04/2020 01:22, Andrii Nakryiko wrote:
> > Can you please point out where I was objecting to observability API
> > (which is LINK_QUERY thing we've discussed and I didn't oppose, and
> > I'm going to add next)?
> I didn't say you objected to it.
> I just said that you argued that it was OK for it to not land in the
>  same release as the rest of the API, because drgn could paper over
>  that gap.  Which seems to me to signify a dangerous way of thinking,
>  and I wanted to raise the alarm about that.

Let's have a bit more context first. BTW, please don't trim chain of
replies (at least not so aggressively) next time.

>>> That is my point. You are restricting what root can do and people will
>>> not want to resort to killing random processes trying to find the one
>>> holding a reference. This is an essential missing piece and should go i=
n
>>> at the same time as this set.
>> No need to kill random processes, you can kill only those that hold
>> bpf_link FD. You can find them using drgn tool with script like [0].
> For the record, I find the argument "we don't need a query feature,
> because you can just use a kernel debugger" *utterly* *horrifying*.

I was addressing the concern of having to randomly kill processes.
Which is a "human override" thing, not really an observability one.
And my response is exactly that it's better to be able to see all
owners of bpf_link, rather than have a "nuke" option. It so happens
that drgn is a very useful tool for this and I was able to prototype
such script quickly enough to share it with others. drgn is not the
only option, you can do that by iterating procfs and using fdinfo. It
can certainly be improved for bpf_link-specific case by providing more
information (like cgroup path, etc). But in general, it's a question
of "which processes use given file", which unfortunately, I don't
think Linux has a better observability APIs for. I'm not happy about
that, but it's not really bpf_link-specific issue either.

> (If you _don't_ see what's wrong with that argument... well, that'd
>  be even _more_ alarming.  Debuggers =E2=80=94 and fuser, for that matter=
 =E2=80=94
>  are for when things go wrong _in ways the designers of the system
>  failed to anticipate_.  They should not be part of a 'normal' work-
>  flow for dealing with problems that we already _know_ are possible;
>  it's kinda-sorta like how exceptions shouldn't be used for non-
>  exceptional situations.)

I don't think it's as quite black and white as you are stating. For
instance, I *think* lsof, netstat, bcc tools, etc disagree with you.
Also need to kill application because it's attached to XDP or cgroup
doesn't seem like a "normal" workflow either. But I really would
rather leave it at that, if you don't mind.

>
> -ed
