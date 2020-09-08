Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52FC262391
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgIHX1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIHX1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:27:49 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78656C061573;
        Tue,  8 Sep 2020 16:27:48 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r24so1109494ljm.3;
        Tue, 08 Sep 2020 16:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZLv64E9iX6vMYMgu7cql00jwI+aNGqHeU3sAICtz6A=;
        b=OzvOSNnKRpFC83G2xLmy29NuaGc62o+QwwhuJt3Ep3NAd3lGgbsGc6e+0h/62YzQFr
         nBkTSpTme6SXKATJV2LgvBD1XzfJNSzhAbLw0ud1IV+C1Rt7+WKymSqMtEQtE4rucstM
         1RV7RuTaAEfFsHmHqdUoAE9Rq9M1cQVL4Ebl3Qyc2G4W/SvwbWlBrEfCi6OQrx9l6wB7
         fkLhN2CFEYNdzuy3nBN9PZQ0PoYkjecP1vCiAsS5SWrjADGad73W975fSHXyneviUOjR
         LPQBktMD2G9DFkuSCz2aZvEyy/jAGuPqCw2DcZkEcaBRMYPCyDnwDiT4EHrH/Suin7Gu
         foMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZLv64E9iX6vMYMgu7cql00jwI+aNGqHeU3sAICtz6A=;
        b=HfLlUQuuiRGzLzgJHm7QwZ6hqngmUUIoB2dB6CGotQyvBMoFcYT+3YPthJchXLcyTS
         pnzSyLLtCyPWsP2qNSdt84BWgXmjeeaEDVqYYDe2N2JHueEiwfE9Zrpxw4ze3FmP+YKv
         UL23XvhpbNQciAgKjuSRbq3PiQiS5kqk1ZxP4Cx5gkeHc+D/WrUFr/YZP7P7XFoHM9uD
         mwklsiXf9x3pCOVstQhe+/WTVzeK/oUY/PIcRL5YJdEMWVVWH8wu5cudNP7TMOb06zf7
         LrGZJj4ciz+gR7KMNz8ONBD/PWCKds3OhmRX68jZKQn86/fMNNhAlfZvtNHr+eIM84Jd
         UVQg==
X-Gm-Message-State: AOAM533EZkU/AlIBTb7MOTg4/sb1QCMDHYN3bss80INj4YYQH533hh4w
        MyCh9D7dh3W0rWFKlLvfMd8VRHh1PcX7/8kO//E=
X-Google-Smtp-Source: ABdhPJzZbZ7aWtVf/S5ICwzcEkfOfBdUWwNY78rT8KIIWZtqaAoKBo8vmO+MWeqK1xl7wdxaek/YwpNobozhN3hhKuU=
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr453236ljr.2.1599607666714;
 Tue, 08 Sep 2020 16:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200905214831.1565465-1-Tony.Ambardar@gmail.com> <CAEf4BzYmHLvnMrg-b5rgLCU2fg3C1q1SHbonao96fFOPYagC8w@mail.gmail.com>
In-Reply-To: <CAEf4BzYmHLvnMrg-b5rgLCU2fg3C1q1SHbonao96fFOPYagC8w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Sep 2020 16:27:35 -0700
Message-ID: <CAADnVQ+wvZX8-2rW6KwZPTyv10+9LrOFVJMkQNYX2VxcRoS0oQ@mail.gmail.com>
Subject: Re: [PATCH bpf v1] tools/libbpf: avoid counting local symbols in ABI check
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 12:53 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Sep 5, 2020 at 2:49 PM Tony Ambardar <tony.ambardar@gmail.com> wrote:
> >
> > Encountered the following failure building libbpf from kernel 5.8.5 sources
> > with GCC 8.4.0 and binutils 2.34: (long paths shortened)
> >
> >   Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
> >   match with num of versioned symbols in libbpf.so (236). Please make sure
> >   all LIBBPF_API symbols are versioned in libbpf.map.
> >   --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
> >   +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
> >   @@ -1,3 +1,5 @@
> >   +_fini
> >   +_init
> >    bpf_btf_get_fd_by_id
> >    bpf_btf_get_next_id
> >    bpf_create_map
> >   make[4]: *** [Makefile:210: check_abi] Error 1
> >
> > Investigation shows _fini and _init are actually local symbols counted
> > amongst global ones:
> >
> >   $ readelf --dyn-syms --wide libbpf.so|head -10
> >
> >   Symbol table '.dynsym' contains 343 entries:
> >      Num:    Value  Size Type    Bind   Vis      Ndx Name
> >        0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
> >        1: 00004098     0 SECTION LOCAL  DEFAULT   11
> >        2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
> >        3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
> >        4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
> >        5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
> >        6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1
> >
> > A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
> > same with the libbpf.so DSO for consistent comparison.
> >
> > Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
> >
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>

Applied. Thanks
