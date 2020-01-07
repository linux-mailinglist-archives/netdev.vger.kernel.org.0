Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4513237E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 11:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgAGKYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 05:24:24 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35012 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgAGKYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 05:24:23 -0500
Received: by mail-qk1-f195.google.com with SMTP id z76so42523259qka.2;
        Tue, 07 Jan 2020 02:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x/FJ6ST8pkDrcHZpucYQ0+Lv1MfR+E42jWdOkBgx1mI=;
        b=W97EYdAzT4wGqtQz+nEZlGtjbw82WKRpKzkSTWeomNngXkJlZ0LrcHRfyaGeiAZIHW
         rvQqZTlXYdzvxPdu9Q5+NrnulPy3kmaBbC2uFh/j3Cuxd4oRLMi7YY9C//4Xu749Q/ct
         x/Xe/qmgLkLWCE7G1Ub2gZwh4dA+h322tFNABvjbiALnpDJDu57PlQOQpLAOAyoWMLwC
         zsBxwvVmOUyr8JG8J6EbtEPZohnwSzLANzd9BzI57ROgoUv1E4mb+A3z01ciSUyYAYcM
         jSlBqOX4KE0Z9aHSGTMSW0EqfgAWxH5rdd8+7HUdJ9nSQ7naiX8Bw7GkPQjqHdu6f5co
         rriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x/FJ6ST8pkDrcHZpucYQ0+Lv1MfR+E42jWdOkBgx1mI=;
        b=YK5SZGILvzLnpIhT/EetrR6gUEkBFm7P7YrEct0a8ijkDXl8HwZ8saheqcMeFbshUe
         wSxQ0E8bUnBxyKcdMNojSlq54OfOWDGVx/tFQee92IJK4cjbFoNheqT/IsSsQh2L68Zk
         gn5ncT8CHTD50zA5oox82yeynBNm4iQhVh6puC0C0LbCmLOqr1irnDyYiIvL3i95PsYE
         CXDo4y9UtZVhja+USfkYxIAL0MnKtvhGO6Xhfx0RPTsIeV0f8dQ0ZkyAzVI++IZMt3qs
         uVuVBAK1Y4q9a7efww26Kjz1uNNOEWvXbXDOfseM6RP8s25OVrxWef7hShY4ocNp/4l5
         wCIQ==
X-Gm-Message-State: APjAAAWQVzdo09Po7M2hnf5U9hIMrrybe8xBzohndZEDsGH6Ee9133Ms
        23l6/DymHFx8RIk0Xl2xC/LurAGt3F5Md1GaTI0=
X-Google-Smtp-Source: APXvYqzDx+S0/3olC7XANuGvHUw4RJp7j1GA9/yRyv+B3EeVXv6gW65lJFGfrkkk5uU/pbXjmLKIBfxaiWk1FtUzW/E=
X-Received: by 2002:a05:620a:14a4:: with SMTP id x4mr86439378qkj.493.1578392662584;
 Tue, 07 Jan 2020 02:24:22 -0800 (PST)
MIME-Version: 1.0
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-7-bjorn.topel@gmail.com>
 <7ceab77a-92e7-6415-3045-3e16876d4ef8@iogearbox.net> <CAJ+HfNgmcjLniyG0oj7OE60=NASfskVzP_bgX_JXp+SLczmyOQ@mail.gmail.com>
 <alpine.DEB.2.21.9999.2001031730370.283180@viisi.sifive.com>
In-Reply-To: <alpine.DEB.2.21.9999.2001031730370.283180@viisi.sifive.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 7 Jan 2020 11:24:11 +0100
Message-ID: <CAJ+HfNgrekRMM_XS1eK_Cn77BNEgs2gxEsTEvxDpKH9M4R7TJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT
 image alloc/free
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul,

Back from the holidays. Sorry about the delay!

On Sat, 4 Jan 2020 at 02:32, Paul Walmsley <paul.walmsley@sifive.com> wrote=
:
>
[...]
>
> Looks like Palmer's already reviewed it.  One additional request: could
> you update the VM layout debugging messages in arch/riscv/mm/init.c to
> include this new area?
>

Sure, I'll send that as a follow-up! Related; Other archs, e.g. arm64,
has moved away from dumping the VM layout (commit 071929dbdd86
("arm64: Stop printing the virtual memory layout")), and instead rely
on _PTDUMP. Going forward that probably applies to riscv as well!


Cheers,
Bj=C3=B6rn
