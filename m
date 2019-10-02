Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB23C8F10
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfJBQ4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:56:04 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40006 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfJBQ4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:56:04 -0400
Received: by mail-qk1-f194.google.com with SMTP id y144so15685948qkb.7;
        Wed, 02 Oct 2019 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OIrEl09ToJjHqpU/fbMoIlF4w9O4I9epnXRXCxHSJXM=;
        b=tXmz5bKBSc00vUbQztfRLEAKvUWd6F97z7tbFn99q/Rrx+R8lFDYZQVVJkbK1oD9yy
         exBxNZmz/0tH4YbDDCk2JiRsbwSJNnQn18LI2Cl9GQXEjDDoBjel5ce4eEBAizoDxQUz
         INJyCmKa7SqZrJP3iN6Hh7INojFifdkUDzDkxYxi/LlexqiFkPOrWQigCugKwYaPvYI4
         xh1kuuC7oDIaPKtfw30w3YWIJmF3/RuvWUj8kNHKdLFE8GA4YAmv3c/JBJV1WnHLT3zx
         wnlYV6JnaYsAzXGwGXj4r2cY5hZKhzR0f/NeRqpfRVMdFXc2lWh4YLVf8OM5CrzQ57HX
         zIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OIrEl09ToJjHqpU/fbMoIlF4w9O4I9epnXRXCxHSJXM=;
        b=KRPCv+EIqNt+fRl91rQlFlsTl7nODJL9fB4AKDX16BF781AJ5uiJ9bH/DZYckh1+xE
         bKO4uBu9CRirICsLhiBJpypH58gFQhLKJbxqCNbkVdbSf1WQqvhDogJs6oYOrviMAUVI
         LM+PgSkHMiEkTrZr9rFD92iZ+sSyApQGscAIAxOi6hJTmi0DpxTem+O7xCrz+d/1w9Of
         YswCbE2inneRBwWDjALTPzZvz8bTuaBU6m60KajDKWeFxfx5FoCexI175BhuLBTreL3X
         e+DwMHlL7/InndZWFu8JODWFUy5Gc8BqvRli53CUXzQL5y3MpZ9H8jjCztqJBXg7EeLP
         Detw==
X-Gm-Message-State: APjAAAUzKzop2Nsx2/SRQX74EqIf1tFqHPH6XqL6OiGLyhhmyx5ZQSMV
        2ou4lC1SbI6Q3u0g0EXWsW+C+37Zcy2CMUl30tM=
X-Google-Smtp-Source: APXvYqxd1ktORxdnJwwg4BImPkehqyUedweYvhk7uiareg9EEVg4RjqZeDkV+a30ifztSTdpkINIVGqi9aldRksn7LU=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr4773459qkk.39.1570035363234;
 Wed, 02 Oct 2019 09:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190930164239.3697916-1-andriin@fb.com> <871rvwx3fg.fsf@toke.dk>
 <CAEf4BzYvx7wpy79mTgKMuZop3_qYCCOzk4XWoDKiq7Fbj+gAow@mail.gmail.com>
 <87lfu4t9up.fsf@toke.dk> <CAEf4BzZJFBdjCSAzJ3-rOrCkkaTJmPSDhx_0xKJt4+Vg2TEFwg@mail.gmail.com>
 <87imp7tz46.fsf@toke.dk>
In-Reply-To: <87imp7tz46.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Oct 2019 09:55:51 -0700
Message-ID: <CAEf4BzZ6--Vy5=FHDC0EiFnwF79hBz=PXKd21nSdASpfG2y7pQ@mail.gmail.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/
 sized opts
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 11:56 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> >> Sure, LGTM! Should we still keep the bit where it expands _opts in the
> >> struct name as part of the macro, or does that become too obtuse?
> >
> > For me it's a question of code navigation. When I'll have a code
> >
> > LIBBPF_OPTS(bpf_object_open, <whatever>);
> >
> > I'll want to jump to the definition of "bpf_object_open" (e.g., w/
> > cscope)... and will find nothing, because it's actually
> > bpf_object_open_opts. So I prefer user to spell it out exactly and in
> > full, this is more maintainable in the long run, IMO.
>
> That's a good point; we shouldn't break cscope!
>
> BTW, speaking of cscope, how about having a 'make cscope' target for
> libbpf to generate the definition file? :)

I'm all for it, probably both `make cscope` and `make tags`, like
Linux's make has? Feel free to add them, I can also replicate it to
Github's Makefile after that.

>
> -Toke
>
