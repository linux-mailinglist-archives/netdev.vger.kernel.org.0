Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CD66BE15
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjAPMpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjAPMpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:45:30 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784ED1E2A0;
        Mon, 16 Jan 2023 04:45:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so33785574pjk.3;
        Mon, 16 Jan 2023 04:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Amg7azjpO2HYUelx+XSQFic7Qcf2sNI2/2pbuVSHnJc=;
        b=aywTxT7b1diDAEOl8+52znh/Y9AZJQ5zoRKXZ1finX/KEngwVXZfqMvTZWgidja5Mi
         fvsmvuPYCnJVqeiMJuv7/VEz9g4dUw6xot/hRsRvy9RsBu+sxDe8ezc1crSDywGxxV9h
         /8F9fTTYCUeKPoLRomCqVvVXL3qB6ywZbwafBA2ms5aIi5wxWHeVInk0kTsW9OT/Q2GU
         W3wZI2JLy2xEX7BC6GeIsg3hWlgo6wBfG7jZ6cZYBqoqTmvMhZSP2Gg/x6ld8lQAXGjU
         EWvl5B3z9ILsJz0mOJjaWzDPDwRriIg26Nxk/g/JfImZPX3EgnzyQmdsubRuTxxUiEWp
         SY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Amg7azjpO2HYUelx+XSQFic7Qcf2sNI2/2pbuVSHnJc=;
        b=oOVs7tBadHvZqubJc1/62F/0+yo2I010fvJEj4JGhtVYkYBJhtAEzwxP3PiikQb3wd
         vmZcb9LudvL8rC900xTeWxHV/ym/nhRefE7nYwR0PN5DF2YV9ncBbmrROQGyWtuifaaO
         e9+aFANbXYR2yEDVbHPIE9XUHvqnldWTpwdtzeXklXB+2gct13F9F5AAvmL/ap9l+pSc
         1EuS5S4LBtvLIln+NOs4m6IXQcq/p5ENtlwmXR1F8B8A55gj+/tHMoo6QThHbRUjttDW
         k/vVoer7+thBni3hSjBpwETReztjRRE4Dh+1qrAnm8dg9YB4j08SI7jHD/ITnGWuJX5q
         hZLg==
X-Gm-Message-State: AFqh2kp9OE6874aqnhmO/bCb+wsqS4J0MoKaXvvMNV1XW1UN+Rl7fUYC
        G2BPW1hD3G5/GVG+jWq8vw==
X-Google-Smtp-Source: AMrXdXttsibQRULHQoJwkP4lEjJ2qLB9fc+WbcqW3nFBuhHsMXUscWnbgbvFdCOg4LnbSwzdNi4k3w==
X-Received: by 2002:a17:902:ccc4:b0:186:e434:6265 with SMTP id z4-20020a170902ccc400b00186e4346265mr107305039ple.2.1673873128837;
        Mon, 16 Jan 2023 04:45:28 -0800 (PST)
Received: from smtpclient.apple (n119236129232.netvigator.com. [119.236.129.232])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902d48100b00189c9f7fac1sm19300831plg.62.2023.01.16.04.45.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Jan 2023 04:45:28 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: KASAN: use-after-free Read in ___bpf_prog_run
From:   Hao Sun <sunhao.th@gmail.com>
In-Reply-To: <0f1d2e35-b027-43c9-067f-5e5e177071ed@meta.com>
Date:   Mon, 16 Jan 2023 20:45:14 +0800
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F4EB9C63-8ED6-4640-9BD4-4709F01589FD@gmail.com>
References: <CACkBjsbS0jeOUFzxWH-bBay9=cTQ_S2JbMnAa7V2sHpp_19PPw@mail.gmail.com>
 <52379286-960e-3fcd-84a2-3cab4d3b7c4e@meta.com>
 <5B270DBF-E305-4C86-B246-F5C8A5D942CA@gmail.com>
 <501fb848-5211-7706-aee2-4eac6310f1ae@meta.com>
 <933A445C-725E-4BC2-8860-2D0A92C34C58@gmail.com>
 <0f1d2e35-b027-43c9-067f-5e5e177071ed@meta.com>
To:     Yonghong Song <yhs@meta.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 12 Jan 2023, at 2:59 PM, Yonghong Song <yhs@meta.com> wrote:
>=20
>=20
>=20
> On 1/9/23 5:21 AM, Hao Sun wrote:
>> Yonghong Song <yhs@meta.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=8818=E6=97=A5=
=E5=91=A8=E6=97=A5 00:57=E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>=20
>>>=20
>>> On 12/16/22 10:54 PM, Hao Sun wrote:
>>>>=20
>>>>=20
>>>>> On 17 Dec 2022, at 1:07 PM, Yonghong Song <yhs@meta.com> wrote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>> On 12/14/22 11:49 PM, Hao Sun wrote:
>>>>>> Hi,
>>>>>> The following KASAN report can be triggered by loading and test
>>>>>> running this simple BPF prog with a random data/ctx:
>>>>>> 0: r0 =3D bpf_get_current_task_btf      ;
>>>>>> R0_w=3Dtrusted_ptr_task_struct(off=3D0,imm=3D0)
>>>>>> 1: r0 =3D *(u32 *)(r0 +8192)       ;
>>>>>> R0_w=3Dscalar(umax=3D4294967295,var_off=3D(0x0; 0xffffffff))
>>>>>> 2: exit
>>>>>> I've simplified the C reproducer but didn't find the root cause.
>>>>>> JIT was disabled, and the interpreter triggered UAF when =
executing
>>>>>> the load insn. A slab-out-of-bound read can also be triggered:
>>>>>> https://pastebin.com/raw/g9zXr8jU
>>>>>> This can be reproduced on:
>>>>>> HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to =
test
>>>>>> padding handling of btf_dump
>>>>>> git tree: bpf-next
>>>>>> console log: https://pastebin.com/raw/1EUi9tJe
>>>>>> kernel config: https://pastebin.com/raw/rgY3AJDZ
>>>>>> C reproducer: https://pastebin.com/raw/cfVGuCBm
>>>>>=20
>>>>> I I tried with your above kernel config and C reproducer and =
cannot reproduce the kasan issue you reported.
>>>>>=20
>>>>> [root@arch-fb-vm1 bpf-next]# ./a.out
>>>>> func#0 @0
>>>>> 0: R1=3Dctx(off=3D0,imm=3D0) R10=3Dfp0
>>>>> 0: (85) call bpf_get_current_task_btf#158     ; =
R0_w=3Dtrusted_ptr_task_struct(off=3D0,imm=3D0)
>>>>> 1: (61) r0 =3D *(u32 *)(r0 +8192)       ; =
R0_w=3Dscalar(umax=3D4294967295,var_off=3D(0x0; 0xffffffff))
>>>>> 2: (95) exit
>>>>> processed 3 insns (limit 1000000) max_states_per_insn 0 =
total_states 0 peak_states 0 mark_read 0
>>>>>=20
>>>>> prog fd: 3
>>>>> [root@arch-fb-vm1 bpf-next]#
>>>>>=20
>>>>> Your config indeed has kasan on.
>>>>=20
>>>> Hi,
>>>>=20
>>>> I can still reproduce this on a latest bpf-next build: =
0e43662e61f25
>>>> (=E2=80=9Ctools/resolve_btfids: Use pkg-config to locate =
libelf=E2=80=9D).
>>>> The simplified C reproducer sometime need to be run twice to =
trigger
>>>> the UAF. Also note that interpreter is required. Here is the =
original
>>>> C reproducer that loads and runs the BPF prog continuously for your
>>>> convenience:
>>>> https://pastebin.com/raw/WSJuNnVU
>>>>=20
>>>=20
>>> I still cannot reproduce with more than 10 runs. The config has jit =
off
>>> so it already uses interpreter. It has kasan on as well.
>>> # CONFIG_BPF_JIT is not set
>>>=20
>>> Since you can reproduce it, I guess it would be great if you can
>>> continue to debug this.
>>>=20
>> The load insn =E2=80=98r0 =3D *(u32*) (current + 8192)=E2=80=99 is =
OOB, because sizeof(task_struct)
>> is 7240 as shown in KASAN report. The issue is that struct =
task_struct is special,
>> its runtime size is actually smaller than it static type size. In =
X86:
>> task_struct->thread_struct->fpu->fpstate->union fpregs_state is
>> /*
>> * ...
>> * The size of the structure is determined by the largest
>> * member - which is the xsave area. The padding is there
>> * to ensure that statically-allocated task_structs (just
>> * the init_task today) have enough space.
>> */
>> union fpregs_state {
>> struct fregs_state fsave;
>> struct fxregs_state fxsave;
>> struct swregs_state soft;
>> struct xregs_state xsave;
>> u8 __padding[PAGE_SIZE];
>> };
>> In btf_struct_access(), the resolved size for task_struct is 10496, =
much bigger
>> than its runtime size, so the prog in reproducer passed the verifier =
and leads
>> to the oob. This can happen to all similar types, whose runtime size =
is smaller
>> than its static size.
>> Not sure how many similar cases are there, maybe special check to =
task_struct
>> is enough. Any hint on how this should be addressed?
>=20
> This should a corner case, I am not aware of other allocations like =
this.
>=20
> For a normal program, if the access chain looks
> like
> task_struct->thread_struct->fpu->fpstate->fpregs_state->{fsave,fxsave, =
soft, xsave},
> we should not hit this issue. So I think we don't need to address this
> issue in kernel. The test itself should filter this out.

Maybe I didn=E2=80=99t make my point clear. The issue here is that the =
runtime size
of task_struct is `arch_task_struct_size`, which equals to the =
following,
see fpu__init_task_struct_size():

sizeof(task_struct) - sizeof(fpregs_state) + fpu_kernel_cfg.default_size

However, the verifier validates task_struct access based on the ty info =
in
btf_vmlinux, which equals to sizeof(task_struct), much bigger than =
`arch_
task_struct_size` due to the `__padding[PAGE_SIZE]` in fpregs_state, =
this
leads to OOB access.

We should not allow progs that access the task_struct beyond `arch_task_
struct_size` to be loaded. So maybe we should add a fixup in `btf_parse_
vmlinux()` to assign the correct size to each type of this chain:
task_struct->thread_struct->fpu->fpstate->fpregs_state;
Or maybe we should fix this during generating BTF of vmlinux?


