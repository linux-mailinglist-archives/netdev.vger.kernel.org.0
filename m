Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B70234C138
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhC2BlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhC2Bkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:40:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868FEC061574;
        Sun, 28 Mar 2021 18:40:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l76so8417047pga.6;
        Sun, 28 Mar 2021 18:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A31fTE6FaV7bDCF8xSgupyEIITubhNi2zHJbCkiQMck=;
        b=gMXBRLbxgDGSiivJHaNkwk8IFZyp88K0+CIt3cIBrSI7i5ZjnQJevS+V8/Oep2we9U
         zcmkDgxEh12E6z/cbWHSo4Ip3wF2O0wm8DuPxW0ScAsNrJdKTvki4CQJosuQrmA2nJBc
         KlgwrOWTRpiNG0trd2FFKVvU5ad1ss1SC6QDoTSygpF0jfCw3Fb2eQXopFN3Budm54Bh
         lp98nDGzHH7mBrDHFXIZimkHG0+JDowEi6k7rDh8PNAh3KRh/Miee1IwEMGz2tSGxOUt
         7YD91vhKhlbHq/qaVO+f1ghDGryB8ddQazWGDx5W4Rx7cFFpUtVjpafxvymE4Bri7UTk
         0G3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A31fTE6FaV7bDCF8xSgupyEIITubhNi2zHJbCkiQMck=;
        b=sU2HcL+d+pUr2L0if3liV6FskpyXmQ/KOC+Y+MBBwf49WXNtlC25Md9mlcB4vAWUaP
         YG7sI3aT01w323QaZfpBAD2joYbCXuFXYjLbfhjZW0nd9ucgel/6Lq+dwBA/jtdtba0e
         lzvtWOyVrdkUY6lErnTYpZPY/Dh4rhvcnui0oMPLzhxwdguSscITdOW/kKrgZHRCpkHm
         xPn2R/djENOBi0kx9zHR4txM6/BelBsxe1rf2UrokGap0uYzFIKP5/6OyJj77eAV0JQs
         /zXg/Sf3N/XPAfeSAOOLJZh/jsdRzum+jsG0NMpRNv6Wmgxror2U7oS/2Bs9nrL/2Qaw
         Kq0w==
X-Gm-Message-State: AOAM532xmRBBoM2frxHd7+G/iMc2yBQ5YSmyoOfBnlIv/IFDjWN6vyN0
        2EFJnhRH9H6jcHC1d70ii7M=
X-Google-Smtp-Source: ABdhPJzlTquJbyX58kehPjSrAn+tbLmsKBKtqWJa6h9V/LJ1IFLn9pV+kMpIPv2UGFg6LjaD4qanBA==
X-Received: by 2002:a05:6a00:b86:b029:207:8ac9:85de with SMTP id g6-20020a056a000b86b02902078ac985demr22525728pfj.66.1616982048021;
        Sun, 28 Mar 2021 18:40:48 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:1b8f])
        by smtp.gmail.com with ESMTPSA id k21sm15960927pfi.28.2021.03.28.18.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 18:40:47 -0700 (PDT)
Date:   Sun, 28 Mar 2021 18:40:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
Message-ID: <20210329014044.fkmusoeaqs2hjiek@ast-mbp>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp>
 <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 09:32:58PM -0700, Andrii Nakryiko wrote:
> > I think it's better to start with new library for tc/xdp and have
> > libbpf as a dependency on that new lib.
> > For example we can add it as subdir in tools/lib/bpf/.
> >
> > Similarly I think integerating static linking into libbpf was a mistake.
> > It should be a sub library as well.
> >
> > If we end up with core libbpf and ten sublibs for tc, xdp, af_xdp, linking,
> > whatever else the users would appreciate that we don't shove single libbpf
> > to them with a ton of features that they might never use.
> 
> What's the concern exactly? The size of the library? Having 10
> micro-libraries has its own set of downsides, 

specifically?

> I'm not convinced that's
> a better situation for end users. And would certainly cause more
> hassle for libbpf developers and packagers.

For developers and packagers.. yes.
For users.. quite the opposite.
The skel gen and static linking must be split out before the next libbpf release.
Not a single application linked with libbpf is going to use those pieces.
bpftool is one and only that needs them. Hence forcing libbpf users
to increase their .text with a dead code is a selfish call of libbpf
developers and packagers. The user's priorities must come first.

> And what did you include in "core libbpf"?

I would take this opportunity to split libbpf into maintainable pieces:
- libsysbpf - sys_bpf wrappers (pretty much tools/lib/bpf/bpf.c)
- libbpfutil - hash, strset
- libbtf - BTF read/write
- libbpfelf - ELF parsing, CORE, ksym, kconfig
- libbpfskel - skeleton gen used by bpftool only
- libbpflink - linker used by bpftool only
- libbpfnet - networking attachment via netlink including TC and XDP
- libbpftrace - perfbuf, ringbuf
- libxdp - Toke's xdp chaining
- libxsk - af_xdp logic

In the future the stack trace symbolization code can come
into libbpftrace or be a part of its own lib.
My upcoming loader program and signed prog generation logic
can be part of libbpfskel.
