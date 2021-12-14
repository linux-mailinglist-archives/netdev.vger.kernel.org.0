Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB0473B85
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhLND3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhLND3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:29:09 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4409C061574;
        Mon, 13 Dec 2021 19:29:08 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id o14so12610456plg.5;
        Mon, 13 Dec 2021 19:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+ssVFgBKjmVIJAolDkQX5NONW+ijNamJd/NwdyPKjV0=;
        b=GRxFpSh/e9TAEjNBmbCynBmh5VwaVPIneZaPhsZV5UNIkQqWWtXMdT1cdC/tpDpRwr
         4+/OiAVq6C6OIWd/C8PPbM65OC9J3IaMrXO0nDPzY2V2vFnn+dtLMqDC6V8cApXuAga5
         WFk4Po2FaV/+e8mN1xoqELFrIXyttA/aZVx1v13cpjufo9jTZQO+C+t4ROOM71oyYsER
         tFw7lAL585FhSYsmJl0DljEbRibaXfUGpo9EAiTmMAHivxKHCe3G1xvdDD8QaIWgNVpJ
         2Z2ARL5JGTnldsJg7E6zt4CY9AlWtqYxqeaqS/QSUeu9ajNHmQe9VlHxieDifGHcR0N9
         eVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+ssVFgBKjmVIJAolDkQX5NONW+ijNamJd/NwdyPKjV0=;
        b=5RWW3AMQ64Qu/8qzSztAsceA8q2DzkolqjtXPQ1vOcomsEEltRW+C0L1JCpc/HE+IZ
         qoGQvWCz3ZRSsiPM7OGAh9w2rxRgtP9QlTM0+Td6aKkIlNKNQ6ZtQcwQYfV+xCC0PlPr
         qqlq7TWcCNkJQaZU8XN5tI2HTlkMyecV0XnrYaIk5i3sjOWMw+kTrgGmaakGK67p01CL
         H+KOh/FlU2Z8BoktsESw8fuOQHzPCt1Xm18tiXJbPvuE/5zIr9b9y/eWAD8ZOAgBjUUh
         AxluzGArse9WYgrtMPJP8f42NVyFZKjsFZ2hSjQ8ZY/DsSH1FzLfm26AUqMaou+ZhsrL
         lK+w==
X-Gm-Message-State: AOAM533WOt3OH45otLiab9PA+tHUl31L9OqJAdOKCLUgYV94Q4Po/DCS
        BzYZnt6y1K8Y4FT7LdzGiym9pBFsIL9TosajUnUtb1xe
X-Google-Smtp-Source: ABdhPJxdLvdWfQnDKR8oEQPVlSpYAGmCAqXZN1ivSOU8D+cJ4iqJWPRMvwEaas1wN53MIB9VFi6SGJ5jCzxal+55b48=
X-Received: by 2002:a17:902:b588:b0:143:b732:834 with SMTP id
 a8-20020a170902b58800b00143b7320834mr2611006pls.22.1639452548228; Mon, 13 Dec
 2021 19:29:08 -0800 (PST)
MIME-Version: 1.0
References: <20211211184143.142003-1-toke@redhat.com> <20211211184143.142003-9-toke@redhat.com>
 <CAADnVQKiPgDtEUwg7WQ2YVByBUTRYuCZn-Y17td+XHazFXchaA@mail.gmail.com>
 <87r1ageafo.fsf@toke.dk> <CAADnVQL6yL6hVGWL0cni-t+Lvpe91ST8moF69u5CwOLBKZT-GQ@mail.gmail.com>
 <87czm0yqba.fsf@toke.dk>
In-Reply-To: <87czm0yqba.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Dec 2021 19:28:57 -0800
Message-ID: <CAADnVQKM81Jf0b-m=VeuVES7K11uksVrzQtCksoyCq3mZ-=L5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 8/8] samples/bpf: Add xdp_trafficgen sample
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 4:37 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Mon, Dec 13, 2021 at 8:28 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> >> >>
> >> >> This adds an XDP-based traffic generator sample which uses the DO_R=
EDIRECT
> >> >> flag of bpf_prog_run(). It works by building the initial packet in
> >> >> userspace and passing it to the kernel where an XDP program redirec=
ts the
> >> >> packet to the target interface. The traffic generator supports two =
modes of
> >> >> operation: one that just sends copies of the same packet as fast as=
 it can
> >> >> without touching the packet data at all, and one that rewrites the
> >> >> destination port number of each packet, making the generated traffi=
c span a
> >> >> range of port numbers.
> >> >>
> >> >> The dynamic mode is included to demonstrate how the bpf_prog_run() =
facility
> >> >> enables building a completely programmable packet generator using X=
DP.
> >> >> Using the dynamic mode has about a 10% overhead compared to the sta=
tic
> >> >> mode, because the latter completely avoids touching the page data.
> >> >>
> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> ---
> >> >>  samples/bpf/.gitignore            |   1 +
> >> >>  samples/bpf/Makefile              |   4 +
> >> >>  samples/bpf/xdp_redirect.bpf.c    |  34 +++
> >> >>  samples/bpf/xdp_trafficgen_user.c | 421 ++++++++++++++++++++++++++=
++++
> >> >>  4 files changed, 460 insertions(+)
> >> >>  create mode 100644 samples/bpf/xdp_trafficgen_user.c
> >> >
> >> > I think it deserves to be in tools/bpf/
> >> > samples/bpf/ bit rots too often now.
> >> > imo everything in there either needs to be converted to selftests/bp=
f
> >> > or deleted.
> >>
> >> I think there's value in having a separate set of utilities that are
> >> more user-facing than the selftests. But I do agree that it's annoying
> >> they bit rot. So how about we fix that instead? Andrii suggested just
> >> integrating the build of samples/bpf into selftests[0], so I'll look
> >> into that after the holidays. But in the meantime I don't think there'=
s
> >> any harm in adding this utility here?
> >
> > I think samples/bpf building would help to stabilize bitroting,
> > but the question of the right home for this trafficgen tool remains.
> > I think it's best to keep it outside of the kernel tree.
> > It's not any more special than all other libbpf and bcc tools.
> > I think xdp-tools repo or bcc could be a home for it.
>
> Alright, I'll drop it from the next version and put it into xdp-tools.
> I've been contemplating doing the same for some of the other tools
> (xdp_redirect* and xdp_monitor, for instance). Any opinion on that?

Please move them too if you don't mind.
samples/ just doesn't have the right production quality vibe.
Everything in there is a sample code. In other words a toy application.
I hope xdp_trafficgen aims to be a solid maintained tool with
a man page that distros will ship eventually.
So starting with a good home is important.
