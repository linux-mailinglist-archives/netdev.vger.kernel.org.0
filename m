Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78A494BDB
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfHSRjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:39:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38541 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfHSRi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:38:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id e11so1614313pga.5
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 10:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XlmO/eodwC71D1bsvJiGJ+8sk3xEUmzJXMjarfbHpdM=;
        b=gg7ZbGjUDcVLbly6VkVmQCEm7LnkM7/6eeJr1yDs/VllkZKChPUwEdIIM+ASJep+0d
         eTbcdwDBDnKHjZCSyp5RDqf1TtfMsMh+vt9oAp3e0EwlmkpTYhuHPUHzlHx12lsYMA6B
         XIIRQq56YHYVfoGZPvdmk762cOlZT9gcyK/DGI1NIT/6fL0go62V36EENoYqRw73qpkm
         5C2PnhPOmeBcDCPJX69CgCkLcL5fJS0lVZHv0xerYPYlKw0mZqWbnQRyDII2jbC4t9B8
         ip/abnvN/q+dm8L/8HG5bh9s0yT4UbiWPwqT529QMgGUVn4BaLTKI/S3pAiCSPFXQe6F
         vLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XlmO/eodwC71D1bsvJiGJ+8sk3xEUmzJXMjarfbHpdM=;
        b=WOsnWaTQOMwvW/mfxRPveVKLXflREOck8p+vlp+GO0KAQY99HSyZ1kwzmbFHz9MAbz
         Tr/zk2/3a6fp4HO+fR1Vq7AhXipD1ARb9koy7YNRQ1VcywahrNm1FiuIb5X+9ehhVbtT
         m3Pl58At4a9+gnGS+Vn9/bj2VRVCZNa4O3Q1F55UfiapnkhQz11nhBtG/dEv54/r/5ke
         rgGWXAhlVtTczYYHBGWZQpyubzP+iMAO6ucpNJub00WusmhC9n80uX9rKLGJEIdqEG3C
         stJQpTqcuoU7khWLaLGloPiewjNU5qSw01w/kZZJhA/YfdvgLwP9UaoSJ7JRdeU7pupr
         UxnA==
X-Gm-Message-State: APjAAAWzWABCkuY3T9BfZ14Z19knotQ19JimmhDlLPCTCmu6TvNICzdl
        LFL3XXYnnVrd5KBZ8xKdelu0Tw==
X-Google-Smtp-Source: APXvYqxPdCTE7oJv0KRum5I0reGZkgvYoxAuvehn29xWjMgxP5kckXF7eMEtwBbvDmFwEEKLk08xug==
X-Received: by 2002:aa7:9713:: with SMTP id a19mr25281790pfg.64.1566236338926;
        Mon, 19 Aug 2019 10:38:58 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:f907:f7f1:6354:309? ([2601:646:c200:1ef2:f907:f7f1:6354:309])
        by smtp.gmail.com with ESMTPSA id br18sm14684454pjb.20.2019.08.19.10.38.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 10:38:57 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <20190819172718.jwnvvotssxwhc7m6@ast-mbp.dhcp.thefacebook.com>
Date:   Mon, 19 Aug 2019 10:38:56 -0700
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jordan Glover <Golden_Miller83@protonmail.ch>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA2D2573-D90D-4904-A8B5-08C9C5FC7A56@amacapital.net>
References: <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com> <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com> <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com> <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch> <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de> <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch> <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com> <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de> <20190817150245.xxzxqjpvgqsxmloe@ast-mbp> <alpine.DEB.2.21.1908191103130.1923@nanos.tec.linutronix.de> <20190819172718.jwnvvotssxwhc7m6@ast-mbp.dhcp.thefacebook.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 19, 2019, at 10:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
>> On Mon, Aug 19, 2019 at 11:15:11AM +0200, Thomas Gleixner wrote:
>> Alexei,
>>=20
>>> On Sat, 17 Aug 2019, Alexei Starovoitov wrote:
>>>> On Fri, Aug 16, 2019 at 10:28:29PM +0200, Thomas Gleixner wrote:
>>>> On Fri, 16 Aug 2019, Alexei Starovoitov wrote:
>>>> While real usecases are helpful to understand a design decision, the de=
sign
>>>> needs to be usecase independent.
>>>>=20
>>>> The kernel provides mechanisms, not policies. My impression of this who=
le
>>>> discussion is that it is policy driven. That's the wrong approach.
>>>=20
>>> not sure what you mean by 'policy driven'.
>>> Proposed CAP_BPF is a policy?
>>=20
>> I was referring to the discussion as a whole.
>>=20
>>> Can kernel.unprivileged_bpf_disabled=3D1 be used now?
>>> Yes, but it will weaken overall system security because things that
>>> use unpriv to load bpf and CAP_NET_ADMIN to attach bpf would need
>>> to move to stronger CAP_SYS_ADMIN.
>>>=20
>>> With CAP_BPF both load and attach would happen under CAP_BPF
>>> instead of CAP_SYS_ADMIN.
>>=20
>> I'm not arguing against that.
>>=20
>>>> So let's look at the mechanisms which we have at hand:
>>>>=20
>>>> 1) Capabilities
>>>>=20
>>>> 2) SUID and dropping priviledges
>>>>=20
>>>> 3) Seccomp and LSM
>>>>=20
>>>> Now the real interesting questions are:
>>>>=20
>>>> A) What kind of restrictions does BPF allow? Is it a binary on/off or i=
s
>>>>    there a more finegrained control of BPF functionality?
>>>>=20
>>>>    TBH, I can't tell.
>>>>=20
>>>> B) Depending on the answer to #A what is the control possibility for
>>>>    #1/#2/#3 ?
>>>=20
>>> Can any of the mechanisms 1/2/3 address the concern in mds.rst?
>>=20
>> Well, that depends. As with any other security policy which is implemente=
d
>> via these mechanisms, the policy can be strict enough to prevent it by no=
t
>> allowing certain operations. The more fine-grained the control is, it
>> allows the administrator who implements the policy to remove the
>> 'dangerous' parts from an untrusted user.
>>=20
>> So really question #A is important for this. Is BPF just providing a bina=
ry
>> ON/OFF knob or does it allow to disable/enable certain aspects of BPF
>> functionality in a more fine grained way? If the latter, then it might be=

>> possible to control functionality which might be abused for exploits of
>> some sorts (including MDS) in a way which allows other parts of BBF to be=

>> exposed to less priviledged contexts.
>=20
> I see. So the kernel.unprivileged_bpf_disabled knob is binary and I think i=
t's
> the right mechanism to expose to users.
> Having N knobs for every map/prog type won't decrease attack surface.
> In the other email Andy's quoting seccomp man page...
> Today seccomp cannot really look into bpf_attr syscall args, but even
> if it could it won't secure the system.
> Examples:
> 1.
> spectre v2 is using bpf in-kernel interpreter in speculative way.
> The mere presence of interpreter as part of kernel .text makes the exploit=

> easier to do. That was the reason to do CONFIG_BPF_JIT_ALWAYS_ON.
> For this case even kernel.unprivileged_bpf_disabled=3D1 was hopeless.
>=20
> 2.
> var4 doing store hazard. It doesn't matter which program type is used.
> load/store instructions are the same across program types.
>=20
> 3.
> prog_array was used as part of var1. I guess it was simply more
> convenient for Jann to do it this way :) All other map types
> have the same out-of-bounds speculation issue.
>=20
> In general side channels are cpu bugs that are exploited via sequences
> of cpu instructions. In that sense bpf infra provides these instructions.
> So all program types and all maps have the same level of 'side channel ris=
k'.
>=20
>>> I believe Andy wants to expand the attack surface when
>>> kernel.unprivileged_bpf_disabled=3D0
>>> Before that happens I'd like the community to work on addressing the tex=
t above.
>>=20
>> Well, that text above can be removed when the BPF wizards are entirely su=
re
>> that BPF cannot be abused to exploit stuff.=20
>=20
> Myself and Daniel looked at it in detail. I think we understood
> MDS mechanism well enough. Right now we're fairly confident that
> combination of existing mechanisms we did for var4 and
> verifier speculative analysis protect us from MDS.
> The thing is that every new cpu bug is looked at through the bpf lenses.
> Can it be exploited through bpf? Complexity of side channels
> is growing. Can the most recent swapgs be exploited ?
> What if we kprobe+bpf somewhere ?
> I don't think there is an issue, but we will never be 'entirely sure'.
> Even if myself and Daniel are sure the concern will stay.
> Unprivileged bpf as a whole is the concern due to side channels.
> The number of them are not yet disclosed. Who is going to analyze them?
> imo the only answer to that is kernel.unprivileged_bpf_disabled=3D1
> which together with CONFIG_BPF_JIT_ALWAYS_ON is secure enough.
> The other option is to sprinkle every bpf load/store with lfence
> which will make execution so slow that it will be unusable.
> Which is effectively the same as unprivileged_bpf_disabled=3D1.
>=20
> There are other things we can do. Like kasan-style shadow memory
> for bpf execution. Auto re-JITing the code after it's running.
> We can do lfences everywhere for some time then re-JIT
> when kasan-ed shadow memory shows only clean memory accesses.
> The beauty of BPF that it is analyze-able and JIT-able instruction set.
> The verifier speculative analysis is an example that the kernel
> can analyze the speculative execution path that cpu will
> take before the code starts executing.
> Unprivileged bpf can made absolutely secure. It can be
> made more secure than the rest of the kernel.
> But today we should just go with unprivileged_bpf_disabled=3D1

I=E2=80=99m still okay with this.

> and CAP_BPF.
>=20

I think this needs more design work.  I=E2=80=99m halfway through writing up=
 an actual proposal. I=E2=80=99ll send it soon.=
