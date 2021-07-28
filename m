Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52833D8C5A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhG1K72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhG1K7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 06:59:24 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9928C061757;
        Wed, 28 Jul 2021 03:59:21 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o185so3172588oih.13;
        Wed, 28 Jul 2021 03:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EBN6n460UBT8iz0V/+V0RJfO2gnHS3Gi9OOil4PHTno=;
        b=i9XFgH6TG3jWr00bRIcLxZWNcxzzzTgaG1WnJlNu+8DVYAWtSA6bkltSbcvwbU3kLK
         vevh386iP9H8eN4MoEjrTYhrgF9FkI+xl2eOcflkkNlcaWK0OBkS93RlGNv0D4lUbbW5
         gtq7aYbUybbuXeyuww/IhfLo9zx8CMVuKU2UbyfvODa7KEbVbt1rWSZYUBCPcVfHMbRZ
         MRSXSk3AmmSinBXeQai0WnVOkieaEO7b40afVFNktA0PdX+9zc/J2Di7U3WJJOq526dS
         29dj+EEagBdTU8qS4r4I9T2c3tfOdI5qQ6W96uFsXjrd0ePd4UJSb0YzzkneFT8L2MIB
         BaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EBN6n460UBT8iz0V/+V0RJfO2gnHS3Gi9OOil4PHTno=;
        b=QvHPZUEr5kezpZK+OKbvg0enYGT48QtKLWGWG0lhge0t2/pBCGhgTVVvV8zs0o7TZR
         EoyHywbJ+WEf3cJNfAijvlWOsIQubgWMQ1F9b+gdNDHXZJMGa7GbeoHPN1LwjhG9liTd
         HpiME6HpbCbyg9VJ5izsAKD+LVzSTmEM07Z21hSNyFTYeAzSobAEdMsCY2TelU6R3fk1
         Vx1Lb+5XyloQ1TS3P3C6jmkWdJlNJDLlh0TnqA8xOt987dCR4DNePag3Oin4gy+VqtP6
         ZamsJM2tDbO7k/985QJbTNdY108UTMnxmFItYAX/aeXu+0DMjUsF4JHBe7uGWDiWoI4V
         cWGg==
X-Gm-Message-State: AOAM533lS6MQC3/i88VUtQLK4GcaDT1PcCmFjywgQeX8rAJRI3B+Vx9G
        P8IwbMsC2VgzBeI8uSj6FOOraRQVQvbfdljwOV8=
X-Google-Smtp-Source: ABdhPJy6kitM6hVhjg8otVodIIawPEAqSygak98gW3nUlTIWPwHclST+eBl1nmM1xwe+SE4ll58keuVMcnRU+nn3m4Y=
X-Received: by 2002:a54:4094:: with SMTP id i20mr17956262oii.159.1627469961038;
 Wed, 28 Jul 2021 03:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <DB8P193MB0581FEB4CB90263430546C4C88E99@DB8P193MB0581.EURP193.PROD.OUTLOOK.COM>
 <CAEf4BzaSthevAa_0Jjc4meKtW898NPgzd6yywzLLfztVa_c55Q@mail.gmail.com>
In-Reply-To: <CAEf4BzaSthevAa_0Jjc4meKtW898NPgzd6yywzLLfztVa_c55Q@mail.gmail.com>
From:   =?UTF-8?B?Um9iaW4gR8O2Z2dl?= <r.goegge@googlemail.com>
Date:   Wed, 28 Jul 2021 12:59:09 +0200
Message-ID: <CAM798qBDjKk2Na4qfe+OKNWX6z4Boo+eTzrsTisBzUXYKXQCwQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 11:17 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jul 27, 2021 at 7:41 AM Robin G=C3=B6gge <r.goegge@outlook.com> w=
rote:
> >
> > This patch fixes the probe for BPF_PROG_TYPE_CGROUP_SOCKOPT,
> > so the probe reports accurate results when used by e.g.
> > bpftool.
> >
> > Fixes: 4cdbfb59c44a ("libbpf: support sockopt hooks")
> >
> > Signed-off-by: Robin G=C3=B6gge <r.goegge@outlook.com>
> > Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> > ---
>
> Looks good, I'll apply to bpf tree once this patch makes it into patchwor=
ks.

I think I'll have to resend the patch from my gmail account, rookie mistake
on my part for using my outlook account in the first place I guess.
>
> Meanwhile, looking at probe_load() seems like a bunch of other program
> types are not handled properly as well. Would you mind checking that
> as well and following up with more fixes for this? See also [0] for
> this whole probing APIs situation.
>
>   [0] https://github.com/libbpf/libbpf/issues/312

Yes, some other program type probes are broken at the moment. But
as far as I can tell fixing them won't be as easy for me as this one. I'm
currently working on implementing a feature probe API in cilium/ebpf,
once I have working probes for the types there I can try and translate
them to follow up with fixes here.
>
> >  tools/lib/bpf/libbpf_probes.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probe=
s.c
> > index ecaae2927ab8..cd8c703dde71 100644
> > --- a/tools/lib/bpf/libbpf_probes.c
> > +++ b/tools/lib/bpf/libbpf_probes.c
> > @@ -75,6 +75,9 @@ probe_load(enum bpf_prog_type prog_type, const struct=
 bpf_insn *insns,
> >         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> >                 xattr.expected_attach_type =3D BPF_CGROUP_INET4_CONNECT=
;
> >                 break;
> > +       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> > +               xattr.expected_attach_type =3D BPF_CGROUP_GETSOCKOPT;
> > +               break;
> >         case BPF_PROG_TYPE_SK_LOOKUP:
> >                 xattr.expected_attach_type =3D BPF_SK_LOOKUP;
> >                 break;
> > @@ -104,7 +107,6 @@ probe_load(enum bpf_prog_type prog_type, const stru=
ct bpf_insn *insns,
> >         case BPF_PROG_TYPE_SK_REUSEPORT:
> >         case BPF_PROG_TYPE_FLOW_DISSECTOR:
> >         case BPF_PROG_TYPE_CGROUP_SYSCTL:
> > -       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> >         case BPF_PROG_TYPE_TRACING:
> >         case BPF_PROG_TYPE_STRUCT_OPS:
> >         case BPF_PROG_TYPE_EXT:
> > --
> > 2.25.1
> >

--=20
Robin Goegge
Tel. +491732422154
