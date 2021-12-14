Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0A473949
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhLNAGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbhLNAGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 19:06:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA8FC061574;
        Mon, 13 Dec 2021 16:06:08 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y8so12353672plg.1;
        Mon, 13 Dec 2021 16:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=55lxsoQgLoszPpn3Zz52kf+fUEXdI0dE7Z9T+JL+v2Q=;
        b=ShuRFbPaf29WkgxKHhZ2ldu0usxLwoJGCJXPzuU9mriwR6lQS5SqYcw2uinSt4QtuA
         ZWhVp6eotZG7iXs8mQ+KeBmYqyUPnHV1+tx3KIvCuoKyRKwjgZaiu067Ptvdked5Qdka
         NB684P56IxTbG+OSSXPjiG5Pcd9vX7UV3htoIDhnTMUCL91F24yWrInwvqUaV7R25asA
         dUT3Z9E/A8QxeCTWaCw8NvUzrfDt4gqpIeZyQQc/zsm1m/pLiomnE5nkfqikhomb4wp4
         LERGkWSaSLpcGA+yaqSxgkLYCGIAcG8KPUoqN9GYPu1vZpTg5ZjkhTkOlAbq/SdULYxm
         NWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=55lxsoQgLoszPpn3Zz52kf+fUEXdI0dE7Z9T+JL+v2Q=;
        b=Flzc1hU+Tzy+7UDGBy+wpMkfADsgna6ubjVbHVwxQxmD51HNmNNAEQbsFyAhiiVddR
         IvvVDdax8KCRite+nIuGnar24GXWTAfsQl+cEgrXdjMHJhYSC0bVqQsffXyy23HPq7dQ
         rPvNwD9bDsQVtHjP3QdpfY/V8wxudVqTO5yGSwttkuWeYbY12UezSHXwIgPMIK7zXpJj
         RlwEtqrtNB6rIHjOyMP1n6DH1Qv3cPhB+tCdqOZ31oR5HDPsyRQV7dRmq9+DgyZEoIjW
         uhuGJMuGVuH+kve16BO3aZaM7IKox5OICqzxlUjXsJ7sEudLrrGUSIFtl5owALadBXO/
         7acg==
X-Gm-Message-State: AOAM533b14ShDNg2pkCnJzJQc95PJj1YPpB/aB0yFhvLqanm0B2Nd9Bc
        JeyOTkkgYajGqXoJLYZIQ/eJwDKMucU2FNxrpZ4=
X-Google-Smtp-Source: ABdhPJzov7vlNt97LtnENj5CaDnYjIAeqGVvVRjpk8eyfpaDvk+mOcZyL4U2nFnUv/ZaPYGPFAa1xHKV84knjbOipmE=
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr1660011pjy.138.1639440367827;
 Mon, 13 Dec 2021 16:06:07 -0800 (PST)
MIME-Version: 1.0
References: <20211211184143.142003-1-toke@redhat.com> <20211211184143.142003-9-toke@redhat.com>
 <CAADnVQKiPgDtEUwg7WQ2YVByBUTRYuCZn-Y17td+XHazFXchaA@mail.gmail.com> <87r1ageafo.fsf@toke.dk>
In-Reply-To: <87r1ageafo.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Dec 2021 16:05:56 -0800
Message-ID: <CAADnVQL6yL6hVGWL0cni-t+Lvpe91ST8moF69u5CwOLBKZT-GQ@mail.gmail.com>
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

On Mon, Dec 13, 2021 at 8:28 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> This adds an XDP-based traffic generator sample which uses the DO_REDI=
RECT
> >> flag of bpf_prog_run(). It works by building the initial packet in
> >> userspace and passing it to the kernel where an XDP program redirects =
the
> >> packet to the target interface. The traffic generator supports two mod=
es of
> >> operation: one that just sends copies of the same packet as fast as it=
 can
> >> without touching the packet data at all, and one that rewrites the
> >> destination port number of each packet, making the generated traffic s=
pan a
> >> range of port numbers.
> >>
> >> The dynamic mode is included to demonstrate how the bpf_prog_run() fac=
ility
> >> enables building a completely programmable packet generator using XDP.
> >> Using the dynamic mode has about a 10% overhead compared to the static
> >> mode, because the latter completely avoids touching the page data.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  samples/bpf/.gitignore            |   1 +
> >>  samples/bpf/Makefile              |   4 +
> >>  samples/bpf/xdp_redirect.bpf.c    |  34 +++
> >>  samples/bpf/xdp_trafficgen_user.c | 421 +++++++++++++++++++++++++++++=
+
> >>  4 files changed, 460 insertions(+)
> >>  create mode 100644 samples/bpf/xdp_trafficgen_user.c
> >
> > I think it deserves to be in tools/bpf/
> > samples/bpf/ bit rots too often now.
> > imo everything in there either needs to be converted to selftests/bpf
> > or deleted.
>
> I think there's value in having a separate set of utilities that are
> more user-facing than the selftests. But I do agree that it's annoying
> they bit rot. So how about we fix that instead? Andrii suggested just
> integrating the build of samples/bpf into selftests[0], so I'll look
> into that after the holidays. But in the meantime I don't think there's
> any harm in adding this utility here?

I think samples/bpf building would help to stabilize bitroting,
but the question of the right home for this trafficgen tool remains.
I think it's best to keep it outside of the kernel tree.
It's not any more special than all other libbpf and bcc tools.
I think xdp-tools repo or bcc could be a home for it.
