Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB6A1FC0FF
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 23:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgFPV1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 17:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPV1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 17:27:49 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81149C061573;
        Tue, 16 Jun 2020 14:27:48 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id di13so26344qvb.12;
        Tue, 16 Jun 2020 14:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eMLqTOGQHq+yNx61UDkCrEYYfwQYZaCvRhrV7StRB2A=;
        b=BJKFlqz0LHOu5f6IUdG6RT51FWyDFLhx2WOE5Jlvu8tj+5qCAi2gJdCdl7nV3oi7JB
         gh+tQVBxMMf7sRzI1Gb/BDXjpb6cRKKe0q1WAr9+lpMb3IFf7MhgVHOlzUpQZPMC6A0T
         3qAlWo7pz74iztkyNtU1qv4au7+bPF39x4Ft+3DZ867XWh7Pv7l4m5vekrAHyAwkk7mN
         z4RQF/HEphC89qfTvzlUIJSdOBlRHXp6TcChMMY2FkrcY+ndf8xJHPTwcB+zRB0cTKU7
         wYckIvfnxvj4/Axn3+QYG0e77fgdABq91vIdWXkTK8NYLw7GHdRq/Gf5h1ps59dzHtCY
         zWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eMLqTOGQHq+yNx61UDkCrEYYfwQYZaCvRhrV7StRB2A=;
        b=fYuecyTWbwDaRmxxPWGSCBIh4iBMBmu8jibYsJMgW2/50aoAw2FbaXObkARr+U7GYs
         B7MLwMbu6pm6MmYGaZWkzDk/mbMF2tQ3zquO5cI95jvs1FDL4DeYHLcDB0DWlKVvXqeW
         +q5F0avaJUf5rRBp+64h4UHP9Wz846ed0tvuB2U+ipOyk1xoWC6BOBcG4bObohZ2Ayfg
         kx0IufmTCjVDkykyu5e/33Zf8TUcsb9hA9chMxpaY5nmCKbM9NsAFaN7vF5uP14aFLg+
         tBSWGgwthif2lvhPwqpta3NqcdvPwBrMT5FIbrzADMKjZQTj5cYf/X+ntP3fCLbX3VEO
         NT/A==
X-Gm-Message-State: AOAM531NM9HUGGsMZojWbZge6OGzmIrthmMlvx47oP5JTG2JibeueR6s
        V0TrOMR9Kpwle9dtOBSiDCFoDfEu3lsKusLpcmY=
X-Google-Smtp-Source: ABdhPJzCQVrrOypIBy+J1szAVhGgJNPinueyPip+DM8/Uksfz3TkqwcghhoWn+SqS4Y2lbvIHacWMRqRdBBPj3eWubM=
X-Received: by 2002:ad4:4baa:: with SMTP id i10mr4568800qvw.163.1592342867619;
 Tue, 16 Jun 2020 14:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200616050432.1902042-1-andriin@fb.com> <20200616050432.1902042-2-andriin@fb.com>
 <5fed920d-aeb6-c8de-18c0-7c046bbfb242@iogearbox.net>
In-Reply-To: <5fed920d-aeb6-c8de-18c0-7c046bbfb242@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jun 2020 14:27:36 -0700
Message-ID: <CAEf4BzZQXKBFNqAtadcK6UArfgMDQ--5P0XA1m2f_d8KG6YRtg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 1:21 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 6/16/20 7:04 AM, Andrii Nakryiko wrote:
> > Add selftest that validates variable-length data reading and concatenta=
tion
> > with one big shared data array. This is a common pattern in production =
use for
> > monitoring and tracing applications, that potentially can read a lot of=
 data,
> > but usually reads much less. Such pattern allows to determine precisely=
 what
> > amount of data needs to be sent over perfbuf/ringbuf and maximize effic=
iency.
> >
> > This is the first BPF selftest that at all looks at and tests
> > bpf_probe_read_str()-like helper's return value, closing a major gap in=
 BPF
> > testing. It surfaced the problem with bpf_probe_read_kernel_str() retur=
ning
> > 0 on success, instead of amount of bytes successfully read.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Fix looks good, but I'm seeing an issue in the selftest on my side. With =
latest
> Clang/LLVM I'm getting:
>
> # ./test_progs -t varlen
> #86 varlen:OK
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> All good, however, the test_progs-no_alu32 fails for me with:

Yeah, same here. It's due to Clang emitting unnecessary bit shifts
because bpf_probe_read_kernel_str() is defined as returning 32-bit
int. I have a patch ready locally, just waiting for bpf-next to open,
which switches those helpers to return long, which auto-matically
fixes this test.

If it's not a problem, I'd just wait for that patch to go into
bpf-next. If not, I can sprinkle bits of assembly magic around to
force the kernel to do those bitshifts earlier. But I figured having
test_progs-no_alu32 failing one selftest temporarily wasn't too bad.

>
> # ./test_progs-no_alu32 -t varlen
> Switching to flavor 'no_alu32' subdirectory...
> libbpf: load bpf program failed: Invalid argument
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> arg#0 type is not a struct
> Unrecognized arg#0 type PTR
> ; int pid =3D bpf_get_current_pid_tgid() >> 32;
> 0: (85) call bpf_get_current_pid_tgid#14
> ; int pid =3D bpf_get_current_pid_tgid() >> 32;
> 1: (77) r0 >>=3D 32
> ; if (test_pid !=3D pid || !capture)
> 2: (18) r1 =3D 0xffffb14a4010c200
> 4: (61) r1 =3D *(u32 *)(r1 +0)
>   R0_w=3Dinv(id=3D0,umax_value=3D4294967295,var_off=3D(0x0; 0xffffffff)) =
R1_w=3Dmap_value(id=3D0,off=3D512,ks=3D4,vs=3D1056,imm=3D0) R10=3Dfp0
> ; if (test_pid !=3D pid || !capture)
> 5: (5d) if r1 !=3D r0 goto pc+43
>   R0_w=3Dinv(id=3D0,umax_value=3D4294967295,var_off=3D(0x0; 0xffffffff)) =
R1_w=3Dinv(id=3D0,umax_value=3D4294967295,var_off=3D(0x0; 0xffffffff)) R10=
=3Dfp0
> 6: (18) r1 =3D 0xffffb14a4010c204
> 8: (71) r1 =3D *(u8 *)(r1 +0)
>   R0_w=3Dinv(id=3D0,umax_value=3D4294967295,var_off=3D(0x0; 0xffffffff)) =
R1_w=3Dmap_value(id=3D0,off=3D516,ks=3D4,vs=3D1056,imm=3D0) R10=3Dfp0
> 9: (15) if r1 =3D=3D 0x0 goto pc+39
>   R0=3Dinv(id=3D0,umax_value=3D4294967295,var_off=3D(0x0; 0xffffffff)) R1=
=3Dinv(id=3D0,umax_value=3D255,var_off=3D(0x0; 0xff)) R10=3Dfp0
> ; len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> 10: (18) r6 =3D 0xffffb14a4010c220
> 12: (18) r1 =3D 0xffffb14a4010c220
> 14: (b7) r2 =3D 256
> 15: (18) r3 =3D 0xffffb14a4010c000
> 17: (85) call bpf_probe_read_kernel_str#115
>   R0=3Dinv(id=3D0,umax_value=3D4294967295,var_off=3D(0x0; 0xffffffff)) R1=
_w=3Dmap_value(id=3D0,off=3D544,ks=3D4,vs=3D1056,imm=3D0) R2_w=3Dinv256 R3_=
w=3Dmap_value(id=3D0,off=3D0,ks=3D4,vs=3D1056,imm=3D0) R6_w=3Dmap_value(id=
=3D0,off=3D544,ks=3D4,vs=3D1056,imm=3D0) R10=3Dfp0
> last_idx 17 first_idx 9
> regs=3D4 stack=3D0 before 15: (18) r3 =3D 0xffffb14a4010c000
> regs=3D4 stack=3D0 before 14: (b7) r2 =3D 256
> 18: (67) r0 <<=3D 32
> 19: (bf) r1 =3D r0
> 20: (77) r1 >>=3D 32
> ; if (len <=3D MAX_LEN) {
> 21: (25) if r1 > 0x100 goto pc+7
>   R0=3Dinv(id=3D0,smax_value=3D1099511627776,umax_value=3D184467440694145=
84320,var_off=3D(0x0; 0xffffffff00000000),s32_min_value=3D0,s32_max_value=
=3D0,u32_max_value=3D0) R1=3Dinv(id=3D0,umax_value=3D256,var_off=3D(0x0; 0x=
1ff)) R6=3Dmap_value(id=3D0,off=3D544,ks=3D4,vs=3D1056,imm=3D0) R10=3Dfp0
> ;
> 22: (c7) r0 s>>=3D 32
> ; payload1_len1 =3D len;
> 23: (18) r1 =3D 0xffffb14a4010c208
> 25: (7b) *(u64 *)(r1 +0) =3D r0
>   R0_w=3Dinv(id=3D0,smin_value=3D-2147483648,smax_value=3D256) R1_w=3Dmap=
_value(id=3D0,off=3D520,ks=3D4,vs=3D1056,imm=3D0) R6=3Dmap_value(id=3D0,off=
=3D544,ks=3D4,vs=3D1056,imm=3D0) R10=3Dfp0
> ; payload +=3D len;
> 26: (18) r6 =3D 0xffffb14a4010c220
> 28: (0f) r6 +=3D r0
> last_idx 28 first_idx 21
> regs=3D1 stack=3D0 before 26: (18) r6 =3D 0xffffb14a4010c220
> regs=3D1 stack=3D0 before 25: (7b) *(u64 *)(r1 +0) =3D r0
> regs=3D1 stack=3D0 before 23: (18) r1 =3D 0xffffb14a4010c208
> regs=3D1 stack=3D0 before 22: (c7) r0 s>>=3D 32
> regs=3D1 stack=3D0 before 21: (25) if r1 > 0x100 goto pc+7
>   R0_rw=3DinvP(id=3D0,smax_value=3D1099511627776,umax_value=3D18446744069=
414584320,var_off=3D(0x0; 0xffffffff00000000),s32_min_value=3D0,s32_max_val=
ue=3D0,u32_max_value=3D0) R1_rw=3Dinv(id=3D0,umax_value=3D4294967295,var_of=
f=3D(0x0; 0xffffffff)) R6_w=3Dmap_value(id=3D0,off=3D544,ks=3D4,vs=3D1056,i=
mm=3D0) R10=3Dfp0
> parent didn't have regs=3D1 stack=3D0 marks
> last_idx 20 first_idx 9
> regs=3D1 stack=3D0 before 20: (77) r1 >>=3D 32
> regs=3D1 stack=3D0 before 19: (bf) r1 =3D r0
> regs=3D1 stack=3D0 before 18: (67) r0 <<=3D 32
> regs=3D1 stack=3D0 before 17: (85) call bpf_probe_read_kernel_str#115
> value -2147483648 makes map_value pointer be out of bounds
> processed 22 insns (limit 1000000) max_states_per_insn 0 total_states 2 p=
eak_states 2 mark_read 1
>
> libbpf: -- END LOG --
> libbpf: failed to load program 'raw_tp/sys_enter'
> libbpf: failed to load object 'test_varlen'
> libbpf: failed to load BPF skeleton 'test_varlen': -4007
> test_varlen:FAIL:skel_open failed to open skeleton
> #86 varlen:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
