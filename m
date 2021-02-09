Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB0315941
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhBIWSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:18:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234005AbhBIWMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612908634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LlfTMLVBHMWsjcgkhsCMYhUdpfeSRHZZE2Im+2isGyg=;
        b=CH32oapRt/8p0ojS4qx0SxECp5FV/cOSGveI/Q4ZJlpjw6R2Zy+pWZaldKb1tyEx6ItBsy
        A2x8eazVdKl70vmOtveQ4u/YCp5PJl0awaKwXnjqWvN0V9/E4BDFoxxxecirDsQELZSYfl
        DdSBYzwF83EGbQdvM6blZD7wutFKt5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-JpWUcil0NF2JEdCCKSmXeA-1; Tue, 09 Feb 2021 16:41:54 -0500
X-MC-Unique: JpWUcil0NF2JEdCCKSmXeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 630A7192D78A;
        Tue,  9 Feb 2021 21:41:52 +0000 (UTC)
Received: from krava (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2E3105D747;
        Tue,  9 Feb 2021 21:41:44 +0000 (UTC)
Date:   Tue, 9 Feb 2021 22:41:44 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Daniel Kiss <daniel.kiss@arm.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCMBmNujLsMg0Q0q@krava>
References: <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <YCKwxNDkS9rdr43W@krava>
 <YCLdJPPC+6QjUsR4@krava>
 <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
 <YCL1qLzuATlvM8Dh@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCL1qLzuATlvM8Dh@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 09:50:48PM +0100, Jiri Olsa wrote:
> On Tue, Feb 09, 2021 at 12:09:31PM -0800, Nick Desaulniers wrote:
> > On Tue, Feb 9, 2021 at 11:06 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Tue, Feb 09, 2021 at 05:13:42PM +0100, Jiri Olsa wrote:
> > > > On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> > > >
> > > > SNIP
> > > >
> > > > > > > > >                 DW_AT_prototyped        (true)
> > > > > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > > > > >                 DW_AT_external  (true)
> > > > > > > > >
> > > > > > > >
> > > > > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > > > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > > > > strange, given vfs_truncate is just a normal global function.
> > > > > >
> > > > > > right, I can't see it in mcount adresses.. but it begins with instructions
> > > > > > that appears to be nops, which would suggest it's traceable
> > > > > >
> > > > > >   ffff80001031f430 <vfs_truncate>:
> > > > > >   ffff80001031f430: 5f 24 03 d5   hint    #34
> > > > > >   ffff80001031f434: 1f 20 03 d5   nop
> > > > > >   ffff80001031f438: 1f 20 03 d5   nop
> > > > > >   ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > > > >
> > > > > > > >
> > > > > > > > I'd like to understand this issue before we try to fix it, but there
> > > > > > > > is at least one improvement we can make: pahole should check ftrace
> > > > > > > > addresses only for static functions, not the global ones (global ones
> > > > > > > > should be always attachable, unless they are special, e.g., notrace
> > > > > > > > and stuff). We can easily check that by looking at the corresponding
> > > > > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> > > > >
> > > > > I'm still trying to build the kernel.. however ;-)
> > > >
> > > > I finally reproduced.. however arm's not using mcount_loc
> > > > but some other special section.. so it's new mess for me
> > >
> > > so ftrace data actualy has vfs_truncate address but with extra 4 bytes:
> > >
> > >         ffff80001031f434
> > >
> > > real vfs_truncate address:
> > >
> > >         ffff80001031f430 g     F .text  0000000000000168 vfs_truncate
> > >
> > > vfs_truncate disasm:
> > >
> > >         ffff80001031f430 <vfs_truncate>:
> > >         ffff80001031f430: 5f 24 03 d5   hint    #34
> > >         ffff80001031f434: 1f 20 03 d5   nop
> > >         ffff80001031f438: 1f 20 03 d5   nop
> > >         ffff80001031f43c: 3f 23 03 d5   hint    #25
> > >
> > > thats why we don't match it in pahole.. I checked few other functions
> > > and some have the same problem and some match the function boundary
> > >
> > > those that match don't have that first hint instrucion, like:
> > >
> > >         ffff800010321e40 <do_faccessat>:
> > >         ffff800010321e40: 1f 20 03 d5   nop
> > >         ffff800010321e44: 1f 20 03 d5   nop
> > >         ffff800010321e48: 3f 23 03 d5   hint    #25
> > >
> > > any hints about hint instructions? ;-)
> > 
> > aarch64 makes *some* newer instructions reuse the "hint" ie "nop"
> > encoding space to make software backwards compatible on older hardware
> > that doesn't support such instructions.  Is this BTI, perhaps? (The
> > function is perhaps the destination of an indirect call?)
> 
> I see, I think we can't take ftrace addresses as start of the function
> because there could be extra instruction(s) related to the call before
> it like here
> 
> we need to check ftrace address be within the function/symbol,
> not exact start

the build with gcc passed only because mcount data are all zeros
and pahole falls back to 'not-ftrace' mode

	$ llvm-objdump -t build/aarch64-gcc/vmlinux | grep mcount
	ffff800011eb4840 g       .init.data     0000000000000000 __stop_mcount_loc
	ffff800011e47d58 g       .init.data     0000000000000000 __start_mcount_loc

	$ llvm-objdump -s build/aarch64-gcc/vmlinux	
	ffff800011e47d50 00000000 00000000 00000000 00000000  ................
	ffff800011e47d60 00000000 00000000 00000000 00000000  ................
	ffff800011e47d70 00000000 00000000 00000000 00000000  ................
	ffff800011e47d80 00000000 00000000 00000000 00000000  ................
	ffff800011e47d90 00000000 00000000 00000000 00000000  ................
	...

	we should check on why it's zero

	Nathan, any chance you could run kernel built with gcc and check on ftrace?


the build with clang fails because the ftrace data are there,
but pahole takes them as 'start' of the function, which is wrong

	$ llvm-objdump -t build/aarch64/vmlinux | grep mcount
	ffff800011d27d10 g       .init.data     0000000000000000 __start_mcount_loc
	ffff800011d90038 g       .init.data     0000000000000000 __stop_mcount_loc

	$ llvm-objdump -s build/aarch64-gcc/vmlinux	
	ffff800011d27d10 cc330110 0080ffff 1c340110 0080ffff  .3.......4......
	ffff800011d27d20 6c340110 0080ffff 1004c111 0080ffff  l4..............
	ffff800011d27d30 3804c111 0080ffff 6004c111 0080ffff  8.......`.......
	ffff800011d27d40 8804c111 0080ffff 0405c111 0080ffff  ................
	ffff800011d27d50 3805c111 0080ffff 7c05c111 0080ffff  8.......|.......
	...

I think if we fix pahole to take check the ftrace address is
within the processed function, we should be fine.. I'll try to
send something soon

jirka

