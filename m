Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB72418D990
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgCTUjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:39:14 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35961 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgCTUjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:39:14 -0400
Received: by mail-qt1-f196.google.com with SMTP id m33so6220332qtb.3;
        Fri, 20 Mar 2020 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aU/f7OsSuaYYN0ak53X2K4ccWpx/Sz3zQomd0t0Ur1Y=;
        b=Vr/hkjmzhM0CtjsDKNhTaUpSec9nYh51Ch/B1IHBC1qo1bKL583I00LKIk+y6O+kO3
         eHV+326SQZPS1wFOllcbbswoppQmtUykJrNswIo4RQs2qvD/pNuvQdPQwrz4K5H0TKGt
         4QdsXSPWZCHQ/kizs3jZUTAeR3I/JAHJMZ0i5DUlc3uhWWwu+7L1Phy2vhswXZ4CR0Gw
         2E51w1exrU89/LB5U/6GX3wdljwxwttdJldY5W/6bHH9lBP7Gi2KCBVW4hoK+H4yRwIa
         gND6YNZfqo4BVdeREzgCcEawAxpSfmBeFGncthcemcxi66fWdiWAn0hN08dGV9PY3Hw7
         asqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aU/f7OsSuaYYN0ak53X2K4ccWpx/Sz3zQomd0t0Ur1Y=;
        b=CyIuR6VHGMZZtPx+FtUYBP4PMWiinbB2xURQp5jl1mdLfcB+AoibZD+s6HJQocUkK+
         3N9tnlwVb6ECwZfw7EyqVisk6bMOgjK6+oGsOSScFmQjlxLEUwtnx+R0+QXICcRUHUl6
         t3pnCym1mFmliiFRuxsjqdb61hgW/roPSmvjnSgaEq0MNXCyGHb56NLSQV2KKXqhS5V6
         Ronw8rBwBpl1vsCwmjSQ6OiSY9aF7wVVioZDqiuROdPONWAUWEqNyN4v3G07hKptkdl9
         NXN0oww6A6zqy643bAMNs0oVRyCapSR0reiVro8Yi9agj56Vij/fFSlNskO09NZCE9J9
         mdpg==
X-Gm-Message-State: ANhLgQ0FipzID8AMVbsbnSxm7U0jtJihdPweuQpqI9+qrfjjiC4ZqrBI
        ZFxf3ZOcg+z2bloZRDyH426e/9f+CFKRD7/C9wS6Mo3d
X-Google-Smtp-Source: ADFU+vsgglMRdUuFeveU+nHS7dbO0bzdETud3rvXCi/+c5Vb2+7fAuIm3xpe/yKK6Zpd51eluKKHJKyMeIcA4i87t5o=
X-Received: by 2002:ac8:7448:: with SMTP id h8mr10221262qtr.117.1584736751359;
 Fri, 20 Mar 2020 13:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk>
In-Reply-To: <875zez76ph.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Mar 2020 13:39:00 -0700
Message-ID: <CAEf4BzYGZz7hdd-_x+uyE0OF8h_3vJxNjF-Qkd5QhOWpaB8bbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 1:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> While it is currently possible for userspace to specify that an existi=
ng
> >> XDP program should not be replaced when attaching to an interface, the=
re is
> >> no mechanism to safely replace a specific XDP program with another.
> >>
> >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which c=
an be
> >> set along with IFLA_XDP_FD. If set, the kernel will check that the pro=
gram
> >> currently loaded on the interface matches the expected one, and fail t=
he
> >> operation if it does not. This corresponds to a 'cmpxchg' memory opera=
tion.
> >>
> >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
> >> request checking of the EXPECTED_FD attribute. This is needed for user=
space
> >> to discover whether the kernel supports the new attribute.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > I didn't know we wanted to go ahead with this...
>
> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
> happening with that, though. So since this is a straight-forward
> extension of the existing API, that doesn't carry a high implementation
> cost, I figured I'd just go ahead with this. Doesn't mean we can't have
> something similar in bpf_link as well, of course.
>
> > If we do please run this thru checkpatch, set .strict_start_type,
>
> Will do.
>
> > and make the expected fd unsigned. A negative expected fd makes no
> > sense.
>
> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
> flag. I guess you could argue that since we have that flag, setting a
> negative expected_fd is not strictly needed. However, I thought it was
> weird to have a "this is what I expect" API that did not support
> expressing "I expect no program to be attached".

For BPF syscall it seems the typical approach when optional FD is
needed is to have extra flag (e.g., BPF_F_REPLACE for cgroups) and if
it's not specified - enforce zero for that optional fd. That handles
backwards compatibility cases well as well.

>
> -Toke
>
