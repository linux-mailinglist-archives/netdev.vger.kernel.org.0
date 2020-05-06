Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3EE1C6577
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 03:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgEFBZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 21:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728717AbgEFBZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 21:25:52 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C5AC061A0F;
        Tue,  5 May 2020 18:25:51 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d25so2966990lfi.11;
        Tue, 05 May 2020 18:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R8S5HdybhlovzUPCTk9Jk+qbEBW/OQLluce9QD/haJY=;
        b=f+0mA+UluyywJdzAbSZ+S07Dn3UuRprlr7OqNJJTdb4q3dgRRB/HFmHQPiF9qJLGTN
         SenVPax3AN6/xo7smc8N+L8W/BW5KWLovp3fQRANzSeXp0waG8X8QXsx7DNKU2w0Yu9h
         mQK/pR4+SAzvhA8I04ubAek4tM5wFmdkKRGLhtguis2C0AEbYP8ZqcM5oNiYWE1ndDRN
         AHg9Dp0ZAN6lgEXpzBrvxDGZ7y3Jg+T2VoJSzZHLU1rBJJ/lbOz2UFpQBnvaJiaHTdKy
         GIB+Rj189fj1G3z0PQ5BP+DbdBYkoFmySlugeUxppPOtkiMcuwz+x6wLvU8cSj4suPXP
         27Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R8S5HdybhlovzUPCTk9Jk+qbEBW/OQLluce9QD/haJY=;
        b=I5iAebtBW+OEddh/UHAhn6OrEZ8sRUDr6MN/elhVsWs67RwrGMat7Rm5CBskdi8P45
         F0cUr2MqCcL66w1462i113CXAtMWbbvotbsDGMGXbg31EFixX2+m1x9cNWN3LxUhLoIv
         MQfnFJqfsF7MBUyVe1OIb37bu7ldqhI8eAptk/H7oJZYvXKpMTqm9ReUTkQoY/74EmNJ
         mAv4InYZYQ1EQaLchTlhx453Y2F3sLAVqnYeAGB1OF3gu8NKYzftYbHaii3FMSjwytyU
         yiBZm6FHqmp2FgGiZXm9IozZz4T2MVeS3+oezE1XmrL1BX1CGZRZZaqHl1xT3Y4xNlba
         /pTw==
X-Gm-Message-State: AGi0PuY74EjXxyZ1DqFzHEyslfynsZIbAAj07LmGFOcEjaEpZdJIFtBJ
        7O6Gsrz6obah0pezp9MJ2NyYS+E0DTp2+c8vYaI=
X-Google-Smtp-Source: APiQypLOpg4/tYn03s637jE2G1bJDVdGixwGQ8OvYymZpqxqACDkAG7Vi5EcqCFFDP9TytC6duf4OnhDbE/8g8qbHxA=
X-Received: by 2002:ac2:5607:: with SMTP id v7mr3436836lfd.134.1588728350093;
 Tue, 05 May 2020 18:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com> <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
 <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com> <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
 <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com> <20200428040424.wvozrsy6uviz33ha@ast-mbp.dhcp.thefacebook.com>
 <78EFC9DD-48A2-49BB-8C76-1E6FDE808067@redhat.com> <20200428121947.GC2245@kernel.org>
 <20200501114420.5a33d7483f43aaeff95d31dc@kernel.org>
In-Reply-To: <20200501114420.5a33d7483f43aaeff95d31dc@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 May 2020 18:25:38 -0700
Message-ID: <CAADnVQKyfJPujoef6+sV7hJf9kVBjZKur_yjW8GJtTYS-c_Knw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 7:44 PM Masami Hiramatsu <mhiramat@kernel.org> wrot=
e:
>
> On Tue, 28 Apr 2020 09:19:47 -0300
> Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
>
> > Em Tue, Apr 28, 2020 at 12:47:53PM +0200, Eelco Chaudron escreveu:
> > > On 28 Apr 2020, at 6:04, Alexei Starovoitov wrote:
> > > > On Fri, Apr 24, 2020 at 02:29:56PM +0200, Eelco Chaudron wrote:
> >
> > > > > > But in reality I think few kprobes in the prog will be enough t=
o
> > > > > > debug the program and XDP prog may still process millions of
> > > > > > packets because your kprobe could be in error path and the user
> > > > > > may want to capture only specific things when it triggers.
> >
> > > > > > kprobe bpf prog will execute in such case and it can capture
> > > > > > necessary state from xdp prog, from packet or from maps that xd=
p
> > > > > > prog is using.
> >
> > > > > > Some sort of bpf-gdb would be needed in user space.  Obviously
> > > > > > people shouldn't be writing such kprob-bpf progs that debug
> > > > > > other bpf progs by hand. bpf-gdb should be able to generate the=
m
> > > > > > automatically.
> >
> > > > > See my opening comment. What you're describing here is more when
> > > > > the right developer has access to the specific system. But this
> > > > > might not even be possible in some environments.
> >
> > > > All I'm saying that kprobe is a way to trace kernel.
> > > > The same facility should be used to trace bpf progs.
> >
> > > perf doesn=E2=80=99t support tracing bpf programs, do you know of any=
 tools that
> > > can, or you have any examples that would do this?
> >
> > I'm discussing with Yonghong and Masami what would be needed for 'perf
> > probe' to be able to add kprobes to BPF jitted areas in addition to
> > vmlinux and modules.
>
> At a grance, at first we need a debuginfo which maps the source code and
> BPF binaries. We also need to get a map from the kernel indicating
> which instructions the bpf code was jited to.
> Are there any such information?

it's already there. Try 'bpftool prog dump jited id N'
It will show something like this:
; data =3D ({typeof(errors.leaf) *leaf =3D
bpf_map_lookup_elem_(bpf_pseudo_fd(1, -11), &type_key); if (!leaf) {
bpf_map_update_elem_(bpf_pseudo_fd(1, -11), &type_key, &zero,
BPF_NOEXIST); leaf =3D bpf_map_lookup_elem_(bpf_pseudo_fd(1, -11), &t;
 81d:    movabs $0xffff8881a0679000,%rdi
; return bpf_map_lookup_elem((void *)map, key);
 827:    mov    %rbx,%rsi
 82a:    callq  0xffffffffe0f7f448
 82f:    test   %rax,%rax
 832:    je     0x0000000000000838
 834:    add    $0x40,%rax
; if (!data)
 838:    test   %rax,%rax
 83b:    je     0x0000000000000846
 83d:    mov    $0x1,%edi
; lock_xadd(data, 1);
 842:    lock add %edi,0x0(%rax)

> Also, I would like to know the target BPF (XDP) is running in kprobes
> context or not. BPF tracer sometimes use the kprobes to hook the event
> and run in the kprobe (INT3) context. That will be need more work to
> probe it.
> For the BPF code which just runs in tracepoint context, it will be easy
> to probe it. (we may need to break a limitation of notrace, which we
> already has a kconfig)

yeah. this mechanism won't be able to debug bpf progs that are
attached to kprobes via int3. But that is rare case.
Most kprobe+bpf are for function entry and adding int3 to jited bpf code
will work just like for normal kernel functions.
