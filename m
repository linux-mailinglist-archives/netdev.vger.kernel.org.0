Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEBC671112
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjARCWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARCWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:22:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0726E3E087;
        Tue, 17 Jan 2023 18:22:01 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hw16so68031523ejc.10;
        Tue, 17 Jan 2023 18:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+advyT/5BIKUb5fwkTNOHjhet8rF/l8YyqhXFamTOh0=;
        b=QMqw+wVZPsINTwHd4/KmdeLRt/y/BrPXNBYj3nwyqaDOCGfqE+DRjJiQ8lFAaqLyzK
         ILklkcmRYMHUeE/JvRvd2S2HkSWkrTYoKBTkfRVQ6m7TB1nrnTgbf94Yrc/2FHH72aRc
         u2NGIS9uHMGcmDEQQ29kFy0eXNl6hldOqJ+1jbSimQKgAuM4x4DgCAZYDtK0R3QF02t3
         qDGBVYAgcJN4QoI3EanlLKBx5pANQeemRgjXI9xfPa1OSdGyS6WYvtO9EAa6vrHqQLYe
         fRLA/txn23+DwuGpPY9IMML9FBcrPIgZS/cbeClmuoHDf1bj15KSEbV1385wsrvgqY5E
         jTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+advyT/5BIKUb5fwkTNOHjhet8rF/l8YyqhXFamTOh0=;
        b=3TYZf9+nJFaqv53hAgWNqqqxVF+WS9SbD22Rj8r6hihXpY1LvaQ/DOFwRUCra4ygIz
         W3VLc/eu8meo5AIvlWuKPGklKNp9SFdvFZXhjx7Jjxrul6OCUkRuzUSokP2ZG6AvVeFj
         AraXG/Gb8DOJ6LEWmUrfAAEpZ+1foPR9086kJGwHW4LY/XSfSDLu0Q2PYjFtUFHAQeid
         Pd5EXuuaiytUtFm4kBA0/eSTxmjzML/MvhLqxwtr+JIBhPK3WiqXvCcP4g+t6jUPP7aT
         bmPHD9NP3hsqKnveod/ddQ+hS8NoFoZZ2ZlwM1ypWsC8Hsy9BT+ErMWTOrRBbGs+7bCy
         mcZA==
X-Gm-Message-State: AFqh2kpUGe3WQe4HaIDeKTZBibgdCmq+QLoKALKzX4Zq05YgJa1chTdY
        Q1D8GNiKXEoU+aZFJQ+GMOg3be/7jTzfjmf1ozE=
X-Google-Smtp-Source: AMrXdXsC3bnTE90KIYSWGJIwtCpPkYXNIcXQACD7qNM6JzO9ctSq9n1iBbUdWEJabAk8cwv58yOAJ37lgr92swbQP/o=
X-Received: by 2002:a17:906:240a:b0:870:1522:2df3 with SMTP id
 z10-20020a170906240a00b0087015222df3mr399518eja.327.1674008519368; Tue, 17
 Jan 2023 18:21:59 -0800 (PST)
MIME-Version: 1.0
References: <20230105030614.26842-1-tong@infragraf.org> <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net> <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org> <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
 <4380D454-3ED0-43F4-9A79-102BB0E3577A@infragraf.org> <d91bbb9e-484b-d43d-e62d-0474ff21cf91@iogearbox.net>
 <7159E8F8-AE66-4563-8A29-D10D66EFAF3D@infragraf.org>
In-Reply-To: <7159E8F8-AE66-4563-8A29-D10D66EFAF3D@infragraf.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Jan 2023 18:21:46 -0800
Message-ID: <CAADnVQLf_UhRP76i9+OaLGrmuoM942QebMXT3OA3mgrP_UV0KA@mail.gmail.com>
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
To:     Tonghao Zhang <tong@infragraf.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.or" 
        <linux-arm-kernel@lists.infradead.or>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 6:13 PM Tonghao Zhang <tong@infragraf.org> wrote:
>
>
>
> > On Jan 17, 2023, at 11:59 PM, Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
> >
> > On 1/17/23 3:22 PM, Tonghao Zhang wrote:
> >>> On Jan 17, 2023, at 3:30 PM, Christophe Leroy <christophe.leroy@csgro=
up.eu> wrote:
> >>>
> >>>
> >>>
> >>> Le 17/01/2023 =C3=A0 06:30, Tonghao Zhang a =C3=A9crit :
> >>>>
> >>>>
> >>>>> On Jan 9, 2023, at 4:15 PM, Christophe Leroy <christophe.leroy@csgr=
oup.eu> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> Le 06/01/2023 =C3=A0 16:37, Daniel Borkmann a =C3=A9crit :
> >>>>>> On 1/5/23 6:53 PM, Christophe Leroy wrote:
> >>>>>>> Le 05/01/2023 =C3=A0 04:06, tong@infragraf.org a =C3=A9crit :
> >>>>>>>> From: Tonghao Zhang <tong@infragraf.org>
> >>>>>>>>
> >>>>>>>> The x86_64 can't dump the valid insn in this way. A test BPF pro=
g
> >>>>>>>> which include subprog:
> >>>>>>>>
> >>>>>>>> $ llvm-objdump -d subprog.o
> >>>>>>>> Disassembly of section .text:
> >>>>>>>> 0000000000000000 <subprog>:
> >>>>>>>>          0:       18 01 00 00 73 75 62 70 00 00 00 00 72 6f 67 0=
0 r1
> >>>>>>>> =3D 29114459903653235 ll
> >>>>>>>>          2:       7b 1a f8 ff 00 00 00 00 *(u64 *)(r10 - 8) =3D =
r1
> >>>>>>>>          3:       bf a1 00 00 00 00 00 00 r1 =3D r10
> >>>>>>>>          4:       07 01 00 00 f8 ff ff ff r1 +=3D -8
> >>>>>>>>          5:       b7 02 00 00 08 00 00 00 r2 =3D 8
> >>>>>>>>          6:       85 00 00 00 06 00 00 00 call 6
> >>>>>>>>          7:       95 00 00 00 00 00 00 00 exit
> >>>>>>>> Disassembly of section raw_tp/sys_enter:
> >>>>>>>> 0000000000000000 <entry>:
> >>>>>>>>          0:       85 10 00 00 ff ff ff ff call -1
> >>>>>>>>          1:       b7 00 00 00 00 00 00 00 r0 =3D 0
> >>>>>>>>          2:       95 00 00 00 00 00 00 00 exit
> >>>>>>>>
> >>>>>>>> kernel print message:
> >>>>>>>> [  580.775387] flen=3D8 proglen=3D51 pass=3D3 image=3Dffffffffa0=
00c20c
> >>>>>>>> from=3Dkprobe-load pid=3D1643
> >>>>>>>> [  580.777236] JIT code: 00000000: cc cc cc cc cc cc cc cc cc cc=
 cc
> >>>>>>>> cc cc cc cc cc
> >>>>>>>> [  580.779037] JIT code: 00000010: cc cc cc cc cc cc cc cc cc cc=
 cc
> >>>>>>>> cc cc cc cc cc
> >>>>>>>> [  580.780767] JIT code: 00000020: cc cc cc cc cc cc cc cc cc cc=
 cc
> >>>>>>>> cc cc cc cc cc
> >>>>>>>> [  580.782568] JIT code: 00000030: cc cc cc
> >>>>>>>>
> >>>>>>>> $ bpf_jit_disasm
> >>>>>>>> 51 bytes emitted from JIT compiler (pass:3, flen:8)
> >>>>>>>> ffffffffa000c20c + <x>:
> >>>>>>>>      0:   int3
> >>>>>>>>      1:   int3
> >>>>>>>>      2:   int3
> >>>>>>>>      3:   int3
> >>>>>>>>      4:   int3
> >>>>>>>>      5:   int3
> >>>>>>>>      ...
> >>>>>>>>
> >>>>>>>> Until bpf_jit_binary_pack_finalize is invoked, we copy rw_header=
 to
> >>>>>>>> header
> >>>>>>>> and then image/insn is valid. BTW, we can use the "bpftool prog =
dump"
> >>>>>>>> JITed instructions.
> >>>>>>>
> >>>>>>> NACK.
> >>>>>>>
> >>>>>>> Because the feature is buggy on x86_64, you remove it for all
> >>>>>>> architectures ?
> >>>>>>>
> >>>>>>> On powerpc bpf_jit_enable =3D=3D 2 works and is very usefull.
> >>>>>>>
> >>>>>>> Last time I tried to use bpftool on powerpc/32 it didn't work. I =
don't
> >>>>>>> remember the details, I think it was an issue with endianess. May=
be it
> >>>>>>> is fixed now, but it needs to be verified.
> >>>>>>>
> >>>>>>> So please, before removing a working and usefull feature, make su=
re
> >>>>>>> there is an alternative available to it for all architectures in =
all
> >>>>>>> configurations.
> >>>>>>>
> >>>>>>> Also, I don't think bpftool is usable to dump kernel BPF selftest=
s.
> >>>>>>> That's vital when a selftest fails if you want to have a chance t=
o
> >>>>>>> understand why it fails.
> >>>>>>
> >>>>>> If this is actively used by JIT developers and considered useful, =
I'd be
> >>>>>> ok to leave it for the time being. Overall goal is to reach featur=
e parity
> >>>>>> among (at least major arch) JITs and not just have most functional=
ity only
> >>>>>> available on x86-64 JIT. Could you however check what is not worki=
ng with
> >>>>>> bpftool on powerpc/32? Perhaps it's not too much effort to just fi=
x it,
> >>>>>> but details would be useful otherwise 'it didn't work' is too fuzz=
y.
> >>>>>
> >>>>> Sure I will try to test bpftool again in the coming days.
> >>>>>
> >>>>> Previous discussion about that subject is here:
> >>>>> https://patchwork.kernel.org/project/linux-riscv/patch/202104150932=
50.3391257-1-Jianlin.Lv@arm.com/#24176847=3D
> >>>> Hi Christophe
> >>>> Any progress? We discuss to deprecate the bpf_jit_enable =3D=3D 2 in=
 2021, but bpftool can not run on powerpc.
> >>>> Now can we fix this issue?
> >>>
> >>> Hi Tong,
> >>>
> >>> I have started to look at it but I don't have any fruitfull feedback =
yet.
> >>>
> >>> In the meantime, were you able to confirm that bpftool can also be us=
ed
> >>> to dump jitted tests from test_bpf.ko module on x86_64 ? In that can =
you
> >>> tell me how to proceed ?
> >> Now I do not test, but we can dump the insn after bpf_prog_select_runt=
ime in test_bpf.ko. bpf_map_get_info_by_fd can copy the insn to userspace, =
but we can
> >> dump them in test_bpf.ko in the same way.
> >
> > Issue is that these progs are not consumable from userspace (and theref=
ore not bpftool).
> > it's just simple bpf_prog_alloc + copy of test insns + bpf_prog_select_=
runtime() to test
> > JITs (see generate_filter()). Some of them could be converted over to t=
est_verifier, but
> > not all might actually pass verifier, iirc. Don't think it's a good ide=
a to allow exposing
> > them via fd tbh.
> Hi
> I mean that, can we invoke the bpf_jit_dump in test_bpf.ko directly ?. bp=
f_prog_get_info_by_fd copy the insn to userspace, but we only dump insn in =
test_bpf.ko
>
>                 if (bpf_dump_raw_ok(file->f_cred)) {// code copied from b=
pf_prog_get_info_by_fd, not tested
>
>                         /* for multi-function programs, copy the JITed
>                          * instructions for all the functions
>                          */
>                         if (prog->aux->func_cnt) {
>                                 for (i =3D 0; i < prog->aux->func_cnt; i+=
+) {
>                                         len =3D prog->aux->func[i]->jited=
_len;
>                                         img =3D (u8 *) prog->aux->func[i]=
->bpf_func;
>                                         bpf_jit_dump(1, len, 1, img);
>                                 }
>                         } else {
>                                 bpf_jit_dump(1, ulen, 1, prog->bpf_func);
>                         }
>                 }

Let's not reinvent the wheel.
bpftool prog dump jited
is our supported command.
ppc issue with bpftool is related to endianness of embedded skeleton.
which means that none of the bpftool prog commands work on ppc.
It's a bigger issue to address with cross compilation of bpftool.

bpftool supports gnu and llvm disassembler. It retrieves and
prints BTF, line info and source code along with asm.
The user experience is at different level comparing to bpf_jit_dump.
