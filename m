Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAD3166DC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhBJMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:36:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232009AbhBJMeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:34:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612960370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JzdFsPraeCWajGIcw01BPCKeAxZ8iBlE0yhBilS2XoI=;
        b=hGamYpqNlW3rHEo1eamxRO4KaMvEvGt/3hkd96worza1OjF+nCss1dOv9lCOnz6bKcdYem
        rkZfgrSONJZrBYxNQG49bSVAPVSEvnQQCckf5QQ0NfseKgiLuENayB025VfMCa3qhlt2WX
        bSQcrML8hN8MzFu/bq0TAAs3xJQRgts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-2B_1-xrrNrS33ccH2a91rQ-1; Wed, 10 Feb 2021 07:32:46 -0500
X-MC-Unique: 2B_1-xrrNrS33ccH2a91rQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E029801962;
        Wed, 10 Feb 2021 12:32:44 +0000 (UTC)
Received: from krava (unknown [10.40.195.206])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8F991189B8;
        Wed, 10 Feb 2021 12:32:40 +0000 (UTC)
Date:   Wed, 10 Feb 2021 13:32:39 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Nathan Chancellor' <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <YCPSZ0ke/WWmrcTP@krava>
References: <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <YCKwxNDkS9rdr43W@krava>
 <YCLdJPPC+6QjUsR4@krava>
 <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
 <20210210000257.GA1683281@ubuntu-m3-large-x86>
 <67555404a0d449508def1d5be4d1f569@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67555404a0d449508def1d5be4d1f569@AcuMS.aculab.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:34:25AM +0000, David Laight wrote:
> > > > vfs_truncate disasm:
> > > >
> > > >         ffff80001031f430 <vfs_truncate>:
> > > >         ffff80001031f430: 5f 24 03 d5   hint    #34
> > > >         ffff80001031f434: 1f 20 03 d5   nop
> > > >         ffff80001031f438: 1f 20 03 d5   nop
> > > >         ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > >
> > > > thats why we don't match it in pahole.. I checked few other functions
> > > > and some have the same problem and some match the function boundary
> > > >
> > > > those that match don't have that first hint instrucion, like:
> > > >
> > > >         ffff800010321e40 <do_faccessat>:
> > > >         ffff800010321e40: 1f 20 03 d5   nop
> > > >         ffff800010321e44: 1f 20 03 d5   nop
> > > >         ffff800010321e48: 3f 23 03 d5   hint    #25
> > > >
> > > > any hints about hint instructions? ;-)
> > >
> > > aarch64 makes *some* newer instructions reuse the "hint" ie "nop"
> > > encoding space to make software backwards compatible on older hardware
> > > that doesn't support such instructions.  Is this BTI, perhaps? (The
> > > function is perhaps the destination of an indirect call?)
> > 
> > It seems like it. The issue is not reproducible when
> > CONFIG_ARM64_BTI_KERNEL is not set.
> 
> Is the compiler/linker doing something 'crazy'?

I need to check the gcc build, where pahole in my test sees
zero ftrace addresses, while booted kernel shows ftrace working

> 
> If a function address is taken then the BTI instruction is placed
> before the function body and the symbol moved.
> But non-indirect calls still jump to the original start of the function.
> (In this case the first nop.)

for clang build, it looks like pahole needs fix not to assume that
ftrace address match with function start, I'll send it later today

thanks,
jirka

> 
> This saves the execution time of the BTI instruction for non-indirect
> calls.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

