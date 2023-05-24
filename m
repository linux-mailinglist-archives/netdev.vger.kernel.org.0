Return-Path: <netdev+bounces-4850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C084870EC08
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C00228116A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965CAEC2;
	Wed, 24 May 2023 03:46:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CA315B3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:46:03 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE301BF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:45:47 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d3578c25bso389868b3a.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684899947; x=1687491947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eERsr2KIMKuXdu39RaY5MYbtRVFOF/NWR6LanLsqRiE=;
        b=oX1i/2BM+POPpgU0H7rR2FA3xezK1PV62m0gmR8X7cDypxDgrcNm6y1hN2L7xe0Iyt
         1mqpUUfU5wVY2ct7zwN0337V84n335jWKfp/fLGAae/GVQX9d8VHopDXSbyc+VR1Aw1J
         9Ln+3f/S210eHii1JUTImMdQcMguXXxjCOJMG/os9DxbKxZoC3hCKTQnLCF93Q1iaQ2d
         av0h8BHHGKbrBu5ciEaKli2LNHRY7yFVTfPWjAoQjfyG42IfpEaak2hpBJvurKUqdl4x
         ITXpwstImNpqzIKZSk8wc9OYgBtYSk1nlvLmy+qLuTu2DYOqJGPDLsbxqqKtB6I35i6L
         mLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684899947; x=1687491947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eERsr2KIMKuXdu39RaY5MYbtRVFOF/NWR6LanLsqRiE=;
        b=Jr4C8NHOmkEUXLP6yHr9yNIG9Pm98/P/JN1FqkqGpaRW4KL0mmnoaovoqeUEQRc1T+
         zmh0XS0TopnDQfbxSN1Vt9nucF+fBpjCqzQ0Cj04VKWHFINp+qHmuhJ1JNWXpgaxa8y3
         yGohmEJT46isA/aeuiYn/65WHts7imDlwLd0QZm23F5tp+Mbbq2HqltgcHhKHtwMTm1s
         i6SRlL8/88Y2+cPy1fnYouSHUBxOnjPrIBXM8jo/mi+MP2EPjB6cKWjIfXzQvUo6IHYh
         /tcG+n41OVDlYZZ46uLtzJrTVvqYOKcTDKsUuqjN7Pt79BjgarLHBs7oZj7ZKWBqdezR
         wLkA==
X-Gm-Message-State: AC+VfDy/+tAess1Cp4O6MthH4CRrZizQwWxk/or8rmuWCa++D2Rg6CVE
	86QWx/1ZZFIuied8QG2NvVfSGqmq89Glkjjwr+WRYM/Jd3PRwTZu9z5f7MzG
X-Google-Smtp-Source: ACHHUZ4PLipjlYjH8YoIgKf655AyBFU9nvjtB318MzB07fqsGQ8SGcMEHi2RWTo6VU1u85f4vPEQAt10WMMOk/wTCek=
X-Received: by 2002:a05:6a21:788f:b0:10b:58f1:7a6f with SMTP id
 bf15-20020a056a21788f00b0010b58f17a6fmr11464439pzc.41.1684899947297; Tue, 23
 May 2023 20:45:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEUSe78ip=wkHUSz3mBFMcd-LjQAnByuJm1Oids5GSRm-J-dzA@mail.gmail.com>
 <CAKwvOdn3ngS101Y8DiBQgmw4K8kEX+ibGeXYBwTRVLT59q6wsw@mail.gmail.com>
In-Reply-To: <CAKwvOdn3ngS101Y8DiBQgmw4K8kEX+ibGeXYBwTRVLT59q6wsw@mail.gmail.com>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Tue, 23 May 2023 21:45:36 -0600
Message-ID: <CAEUSe7_S_u=4rfJib9p=yaniAWcO6YZCkXtT26_o--+bhW8ODg@mail.gmail.com>
Subject: Re: Stable backport request: skbuff: Proactively round up to kmalloc
 bucket size
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	linux- stable <stable@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, rientjes@google.com, vbabka@suse.cz, 
	Sumit Semwal <sumit.semwal@linaro.org>, clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello!

On Mon, 22 May 2023 at 12:37, Nick Desaulniers <ndesaulniers@google.com> wr=
ote:
>
> On Mon, May 22, 2023 at 11:24=E2=80=AFAM Daniel D=C3=ADaz <daniel.diaz@li=
naro.org> wrote:
> >
> > Hello!
> >
> > Would the stable maintainers please consider backporting the following
> > commit to the 6.1? We are trying to build gki_defconfig (plus a few
>
> Does android's gki_defconfig fail to boot on the `android14-6.1`
> branch of https://android.googlesource.com/kernel/common?
>
> (i.e. downstream branch from linux stable's linux-6.1.y)?
>
> We just ran CI successfully on that branch 10 hours ago.
> https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/5=
042504560/jobs/9045030265
>
> Do you have more information on the observed boot failure? (panic splat?)

Apologies if it sounded like we were trying to boot an Android kernel.
Let me clarify: We're booting v6.1.29 from linux-stable/linux-6.1.y.

This is what we get under Qemu-arm64 for v6.1.29 with Clang 16:
-----8<-----
  Unexpected kernel BRK exception at EL1
  Internal error: BRK handler: 00000000f2000001 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.29 #1
  Hardware name: linux,dummy-virt (DT)
  pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
  pc : pskb_expand_head+0x448/0x480
  lr : pskb_expand_head+0x13c/0x480
  sp : ffff80000802b850
  x29: ffff80000802b860 x28: 00000000000002c0 x27: 0000000000000ec0
  x26: ffff0000c02c8ec0 x25: ffff0000c02c8000 x24: 00000000000128c0
  x23: ffff0000c030e800 x22: ffff0000c030e800 x21: 0000000000000240
  x20: 0000000000000000 x19: ffff0000c085e900 x18: ffff800008021068
  x17: 00000000ad6b63b6 x16: 00000000ad6b63b6 x15: 0001001c00070038
  x14: 0000000c00020008 x13: 00882cc00000ffff x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000001
  x8 : ffff0000c030eac0 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : ffff0000c030eaf0 x4 : ffff0000ff7abd10 x3 : 0000000000001740
  x2 : ffff0000c02c8000 x1 : 0000000000000000 x0 : 0000000000000000
  Call trace:
   pskb_expand_head+0x448/0x480
   netlink_trim+0xa0/0xc8
   netlink_broadcast+0x54/0x764
   genl_ctrl_event+0x21c/0x37c
   genl_register_family+0x628/0x708
   thermal_netlink_init+0x28/0x3c
   thermal_init+0x28/0xec
   do_one_initcall+0xfc/0x358
   do_initcall_level+0xd8/0x1b4
   do_initcalls+0x64/0xa8
   do_basic_setup+0x2c/0x3c
   kernel_init_freeable+0x118/0x198
   kernel_init+0x30/0x1c0
   ret_from_fork+0x10/0x20
  Code: f9406679 38776b28 3707eba8 17ffff67 (d4200020)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: BRK handler: Fatal exception
  SMP: stopping secondary CPUs
----->8-----

Here's a link to that test, with all artifacts:
https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/daniel/tests/2QA2CVTT=
vG6KZETMUyZCNgS8koR

This can be reproduced locally via Tuxrun:
-----8<-----
#pip3 install -U tuxrun
tuxrun --runtime podman \
  --device qemu-arm64 \
  --image docker.io/lavasoftware/lava-dispatcher:2023.01.0020.gc1598238f \
  --boot-args rw \
  --kernel https://storage.tuxsuite.com/public/linaro/daniel/builds/2QA2CHQ=
UpqKe27FyMZrBNILVwXi/Image.gz
\
  --modules https://storage.tuxsuite.com/public/linaro/daniel/builds/2QA2CH=
QUpqKe27FyMZrBNILVwXi/modules.tar.xz
\
  --rootfs https://storage.tuxboot.com/debian/bookworm/arm64/rootfs.ext4.xz
----->8-----

This is vanilla v6.1.29 with no extra patches, just this kernel configurati=
on:
  https://storage.tuxsuite.com/public/linaro/daniel/builds/2QA2CHQUpqKe27Fy=
MZrBNILVwXi/config

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org



> > extras) on Arm64 and test it under Qemu-arm64, but it fails to boot.
> > Bisection has pointed here.
> >
> > We have verified that cherry-picking this patch on top of v6.1.29
> > applies cleanly and allows the kernel to boot.
> >
> > commit 12d6c1d3a2ad0c199ec57c201cdc71e8e157a232
> > Author: Kees Cook <keescook@chromium.org>
> > Date:   Tue Oct 25 15:39:35 2022 -0700
> >
> >     skbuff: Proactively round up to kmalloc bucket size
> >
> >     Instead of discovering the kmalloc bucket size _after_ allocation, =
round
> >     up proactively so the allocation is explicitly made for the full si=
ze,
> >     allowing the compiler to correctly reason about the resulting size =
of
> >     the buffer through the existing __alloc_size() hint.
> >
> >     This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
> >     coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
> >     back the __alloc_size() hints that were temporarily reverted in com=
mit
> >     93dd04ab0b2b ("slab: remove __alloc_size attribute from
> > __kmalloc_track_caller")
> >
> >     Cc: "David S. Miller" <davem@davemloft.net>
> >     Cc: Eric Dumazet <edumazet@google.com>
> >     Cc: Jakub Kicinski <kuba@kernel.org>
> >     Cc: Paolo Abeni <pabeni@redhat.com>
> >     Cc: netdev@vger.kernel.org
> >     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Cc: Nick Desaulniers <ndesaulniers@google.com>
> >     Cc: David Rientjes <rientjes@google.com>
> >     Acked-by: Vlastimil Babka <vbabka@suse.cz>
> >     Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221021=
234713.you.031-kees@kernel.org/
> >     Signed-off-by: Kees Cook <keescook@chromium.org>
> >     Link: https://lore.kernel.org/r/20221025223811.up.360-kees@kernel.o=
rg
> >     Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> >
> >
> > Thanks and greetings!
> >
> > Daniel D=C3=ADaz
> > daniel.diaz@linaro.org
>
>
>
> --
> Thanks,
> ~Nick Desaulniers

