Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14E1EC5D1
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 01:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgFBXhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 19:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbgFBXhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 19:37:00 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AFBC08C5C0;
        Tue,  2 Jun 2020 16:37:00 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u10so371190ljj.9;
        Tue, 02 Jun 2020 16:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GdWNUgi5y0Fz4OroTP++PrgaHpt4V1QS6Jm3TD7Guhw=;
        b=flswYF3O5wxY51s5J6uaJ0EKQbmA0V43mqv+TMz3LDvmQ8CqkGdH2mVfStb3EJj8iC
         P3OdRr8XmL1hn/eB4hosjEVE+bB1p7nBDJ5nV4Em2Cv/KnAPQ4hCe522QjgteN5DVM2k
         kq0K2T4UOo4Zw4riBEoAoCwwCANgdloqPeVrqxOvcB4XSovXwcWLQ5LacvF5G5L42xK3
         ZITGR1vr8aoG5A7eyK150VjKlZpExWqArRF04a8sGQ57D301PCKTWDdbxkHvls67nZ/8
         7/sbxpZPdwAw1OGId/jE9s55d4FfJovu/JOmdRU1AXqdfGlR40N7RNbMKz9dzA2r7SsB
         aR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GdWNUgi5y0Fz4OroTP++PrgaHpt4V1QS6Jm3TD7Guhw=;
        b=BL390f4EsyplpCqJCUwLvMBpWhosl1widbf1OaX8hdH+isvXBoizVCkfeox7suK+Ez
         fA/egfPRn5wuXkMx+c8olY0HRPuUO83nt7hcB5nHlk49ENHb7Z1LeMyryB4GsgRT4ymF
         ftv6QlGDEuhpDEJ1sqRxzX1jpTnBJFkD8TAVGbGAJwM2ho5ti56cpc3EAv6uPUihSsbL
         Vf2TatzWSSsP81nw9XDv1fv2k8FURp0q26QAgbJbM0QXHxfYu36LcHqg53y1L8iCR6lR
         aEXvC1n6e1zjtozCQAl1rGXK4ukkvAoWTMNKG3RaZeQmKx6jWoLlKgxO0WSongyZfuRI
         VyZA==
X-Gm-Message-State: AOAM532Xp4VdkLVyz+1N7AtJumBqg9oBVQjT+dCZ/TBLhEQbkgdQyodj
        aNXfh5jHLDsWd9jUSxvNEDIYW49bCB4LIE+PKPM=
X-Google-Smtp-Source: ABdhPJwWZAbuTC/pnOc5/VzkEakgL1GLhE2Ep1oCj70IRumzCeqf4Cv1NXxKiPB/rXYFrZdtFdLk0DA5k46qvFpnMNQ=
X-Received: by 2002:a2e:81d1:: with SMTP id s17mr702198ljg.91.1591141018774;
 Tue, 02 Jun 2020 16:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk> <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
 <CAGw6cBuCwmbULDq2v76SWqVYL2o8i+pBg7JnDi=F+6Wcq3SDTA@mail.gmail.com>
 <20200602191703.xbhgy75l7cb537xe@ast-mbp.dhcp.thefacebook.com>
 <CAGw6cBstsD40MMoHg2dGUe7YvR5KdHD8BqQ5xeXoYKLCUFAudg@mail.gmail.com>
 <20200602230720.hf2ysnlssg67cpmw@ast-mbp.dhcp.thefacebook.com> <CAGw6cBuF8Dj-22bH=ryL+17N48pwMD5hN49sH4AHYYyMm2xgtg@mail.gmail.com>
In-Reply-To: <CAGw6cBuF8Dj-22bH=ryL+17N48pwMD5hN49sH4AHYYyMm2xgtg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Jun 2020 16:36:46 -0700
Message-ID: <CAADnVQLzQcUyi3Trtr0iT7gEhpSQYAH8WD5q+X8EmRwMYMzhbQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     Michael Forney <mforney@mforney.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 4:21 PM Michael Forney <mforney@mforney.org> wrote:
>
> On 2020-06-02, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > the enum definition of BPF_F_CTXLEN_MASK is certainly within standard.
> > I don't think kernel should adjust its headers because some compiler
> > is failing to understand C standard.
>
> This is not true. See C11 6.7.2.2p2: "The expression that defines the
> value of an enumeration constant shall be an integer constant
> expression that has a value representable as an int."
>
> You can also see this with gcc if you turn on -Wpedantic and include
> it in a way such that warnings are not silenced:
>
> $ gcc -Wpedantic -x c -c -o /dev/null /usr/include/linux/bpf.h

ISO C forbids zero-size arrays, unnamed struct/union, gcc extensions,
empty unions, etc
So ?

warning: ISO C forbids zero-size array =E2=80=98args=E2=80=99 [-Wpedantic]
 4095 |  __u64 args[0];
 warning: ISO C90 doesn=E2=80=99t support unnamed structs/unions [-Wpedanti=
c]
 3795 |  __bpf_md_ptr(void *, data_end);

#define BPF_F_CTXLEN_MASK BPF_F_CTXLEN_MASK
will only work as workaround for _your_ compiler.
We are not gonna add hacks like this for every compiler.
