Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AECF4F3D0
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 07:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfFVFNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 01:13:20 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:41492 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfFVFNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 01:13:20 -0400
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x5M5DDqi017299;
        Sat, 22 Jun 2019 14:13:14 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x5M5DDqi017299
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561180394;
        bh=KdIj9gfPTr+KrZ1sDxUOA4m0IeC48LHZH0YQxYceD7E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vNXZk1hsI4XAgvzZbNpj3eEkuhbxR+xJUJgEQAfDLHUrThJBuGHZnQCO5vbNRFhY9
         O6JJNTD2AoilsIhPpmAPLB1s4tU2y4wbYNdFvz73Ofj6mHBYw5ZRKRChdKtWhGqZDi
         iBqeIGPFn9ldiGUmjSY9CUglghoeCgD3qPumjrBDSZNEKfDG9ZU7ueOhebEc+fo969
         TgZY6+nM4I2xd4ajLhqTRGukFPJdLyN8D1rO1s1h9MYefCsRGBHweTxXGMXf846gEd
         yNByTY3dWBt06CrMLnC6+MAxZ8qT1YpkX/lPVr2HSHKo/3ucD9voLty7ne2cwWjDPH
         Jx7qcb82+RPrQ==
X-Nifty-SrcIP: [209.85.221.169]
Received: by mail-vk1-f169.google.com with SMTP id f68so1742819vkf.5;
        Fri, 21 Jun 2019 22:13:14 -0700 (PDT)
X-Gm-Message-State: APjAAAVeQWdYkqKNvJIsA4mA8ghhGCCWKN4H1uKX2jwXlCdWA6dxG5el
        iu10ScYvznuXsFnP40/mV2q2vPEyZ9pYdqqsk3Y=
X-Google-Smtp-Source: APXvYqzPInWk1IBu1alc9KP2LKnKvdXwjA7lll6wtO8cUk3YyTmS0WJGwLrcgnJ/Z+EOnHvGr4hhymNP3eUnWblqKus=
X-Received: by 2002:a1f:aad2:: with SMTP id t201mr11091589vke.74.1561180393149;
 Fri, 21 Jun 2019 22:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190604101409.2078-1-yamada.masahiro@socionext.com>
 <20190604101409.2078-16-yamada.masahiro@socionext.com> <CAK8P3a08f25WYP5r57JHPcZWieS2+07=_qTphLosS4M2w8F0Zw@mail.gmail.com>
In-Reply-To: <CAK8P3a08f25WYP5r57JHPcZWieS2+07=_qTphLosS4M2w8F0Zw@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 22 Jun 2019 14:12:37 +0900
X-Gmail-Original-Message-ID: <CAK7LNATt8BSrMfrOVjZ_SbA0awsh4CvRhu6TF3gYYynirpviWw@mail.gmail.com>
Message-ID: <CAK7LNATt8BSrMfrOVjZ_SbA0awsh4CvRhu6TF3gYYynirpviWw@mail.gmail.com>
Subject: Re: [PATCH 15/15] kbuild: compile test UAPI headers to ensure they
 are self-contained
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Michal Marek <michal.lkml@markovi.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Palmer Dabbelt <palmer@sifive.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 4:05 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Jun 4, 2019 at 12:16 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
>
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1363,7 +1363,7 @@ CLEAN_DIRS  +=3D $(MODVERDIR) include/ksym
> >  CLEAN_FILES +=3D modules.builtin.modinfo
> >
> >  # Directories & files removed with 'make mrproper'
> > -MRPROPER_DIRS  +=3D include/config usr/include include/generated      =
    \
> > +MRPROPER_DIRS  +=3D include/config include/generated          \
> >                   arch/$(SRCARCH)/include/generated .tmp_objdiff
> >  MRPROPER_FILES +=3D .config .config.old .version \
> >                   Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS G=
SYMS \
>
> This change seems to have caused a minor regression:
>
> $ make clean ; make clean
> find: =E2=80=98*=E2=80=99: No such file or directory

Hmm, I cannot reproduce this.

I checked the latest linux-next.


masahiro@grover:~/ref/linux-next$ git describe
next-20190621
masahiro@grover:~/ref/linux-next$ make clean; make clean
masahiro@grover:~/ref/linux-next$





> Any idea?
>
>       Arnd



--=20
Best Regards
Masahiro Yamada
