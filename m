Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407EC4A5C0
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbfFRPqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:46:55 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:25939 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfFRPqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:46:54 -0400
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x5IFkfN4028453;
        Wed, 19 Jun 2019 00:46:41 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x5IFkfN4028453
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1560872802;
        bh=386ZLEU3NwMBqho2YAfsvSOOObyOn03wy4ojBhvxK60=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zEO3TjqbGOEvExBhKiAr+1HikWsmWFNgpCAfYBvqzvBYn3batDYk+Q30THkzzJVAi
         AnDI2sDbURwJ6EawFc9+Ece35Tk04fStXcjIXDdGDhQWoL6w11dMbFama5grXT4j0R
         V+OC4mb0Ws5539Va/vyrBmdYoQu8kXTFVWaH/UAZoxanZi0BUOfjT+zsRWLHNPFTye
         piqVckY4JJ7yzRVgtKrHBVSo3c/c5FJA4qcI1V94YH5vl93xRVCn9rUzej4Ssem18q
         v1tBySID2r88u+8+15EvkwHyxfo2CTpsQFe4gMd0Ab9Pv18fovHBho4ypB94zLM8Vd
         /rVtx9E/pjG/g==
X-Nifty-SrcIP: [209.85.222.44]
Received: by mail-ua1-f44.google.com with SMTP id 8so6428262uaz.11;
        Tue, 18 Jun 2019 08:46:41 -0700 (PDT)
X-Gm-Message-State: APjAAAWR7k/6CtXPXCm6OxqQ6XZ9DQTZdUsAEw2DVDg9quBGyrNXTyF5
        RXj9vCG7r/nNdVyIiCondC+vqOh1EPeGC5viJGU=
X-Google-Smtp-Source: APXvYqxtLvDnMS0CFAbDTiZ+5ZRw6eQK7Tj+rcqL/cHf9e3ufopPnNNl1cknMI4hmuC4210dH4UbfTG8JkzKXgzkjhE=
X-Received: by 2002:a67:7fcc:: with SMTP id a195mr44483545vsd.181.1560872800733;
 Tue, 18 Jun 2019 08:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190604101409.2078-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190604101409.2078-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 19 Jun 2019 00:46:04 +0900
X-Gmail-Original-Message-ID: <CAK7LNASv7WP+X2_oEEmp5tGqOxiv2VCj84CLuHhSsesF6AiD8A@mail.gmail.com>
Message-ID: <CAK7LNASv7WP+X2_oEEmp5tGqOxiv2VCj84CLuHhSsesF6AiD8A@mail.gmail.com>
Subject: Re: [PATCH 00/15] kbuild: refactor headers_install and support
 compile-test of UAPI headers
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        linux-riscv@lists.infradead.org,
        Vincent Chen <deanbo422@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yonghong Song <yhs@fb.com>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Greentime Hu <green.hu@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-parisc@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 7:15 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
>
> Multiple people have suggested to compile-test UAPI headers.
>
> Currently, Kbuild provides simple sanity checks by headers_check
> but they are not enough to catch bugs.
>
> The most recent patch I know is David Howells' work:
> https://patchwork.kernel.org/patch/10590203/
>
> I agree that we need better tests for UAPI headers,
> but I want to integrate it in a clean way.
>
> The idea that has been in my mind is to compile each header
> to make sure the selfcontainedness.
>
> Recently, Jani Nikula proposed a new syntax 'header-test-y'.
> https://patchwork.kernel.org/patch/10947005/
>
> So, I implemented UAPI compile-testing on top of that.
>
> When adding a new feature, cleaning the code first is a
> good practice.
>
> [1] Remove headers_install_all
>
> This target installs UAPI headers of all architectures
> in a single tree.
> It does not make sense to compile test of headers from
> multiple arches at the same time. Hence, removed.
>
> [2] Split header installation into 'make headers' and 'make headers_install'
>
> To compile-test UAPI headers, we need a work-directory somewhere
> to save objects and .*.cmd files.
>
> usr/include/ will be the work-directory.
>
> Since we cannot pollute the final destination of headers_install,
>
> I split the header installation into two stages.
>
> 'make headers' will build up
> the ready-to-install headers in usr/include,
> which will be also used as a work-directory for the compile-test.
>
> 'make headers_install' will copy headers
> from usr/include to $(INSTALL_HDR_PATH)/include.
>
> [3] Support compile-test of UAPI headers
>
> This is implemented in usr/include/Makefile
>
>
> Jani Nikula (1):
>   kbuild: add support for ensuring headers are self-contained
>
> Masahiro Yamada (14):
>   kbuild: remove headers_{install,check}_all
>   kbuild: remove stale dependency between Documentation/ and
>     headers_install
>   kbuild: make gdb_script depend on prepare0 instead of prepare
>   kbuild: fix Kconfig prompt of CONFIG_HEADERS_CHECK
>   kbuild: add CONFIG_HEADERS_INSTALL and loosen the dependency of
>     samples
>   kbuild: remove build_unifdef target in scripts/Makefile
>   kbuild: build all prerequisite of headers_install simultaneously
>   kbuild: add 'headers' target to build up ready-to-install uapi headers
>   kbuild: re-implement Makefile.headersinst without directory descending
>   kbuild: move hdr-inst shorthand to top Makefile
>   kbuild: simplify scripts/headers_install.sh
>   kbuild: deb-pkg: do not run headers_check
>   fixup: kbuild: add support for ensuring headers are self-contained
>   kbuild: compile test UAPI headers to ensure they are self-contained

Series, applied to linux-kbuild.


>  Documentation/kbuild/headers_install.txt |   7 --
>  Documentation/kbuild/makefiles.txt       |  13 ++-
>  Makefile                                 |  56 +++++-----
>  arch/arc/configs/tb10x_defconfig         |   1 +
>  arch/nds32/configs/defconfig             |   1 +
>  arch/parisc/configs/a500_defconfig       |   1 +
>  arch/parisc/configs/b180_defconfig       |   1 +
>  arch/parisc/configs/c3000_defconfig      |   1 +
>  arch/parisc/configs/default_defconfig    |   1 +
>  arch/powerpc/configs/ppc6xx_defconfig    |   1 +
>  arch/s390/configs/debug_defconfig        |   1 +
>  include/uapi/{linux => }/Kbuild          |   6 +-
>  init/Kconfig                             |  20 ++++
>  lib/Kconfig.debug                        |  25 +++--
>  samples/Kconfig                          |  14 ++-
>  samples/Makefile                         |   4 +-
>  scripts/Kbuild.include                   |   6 --
>  scripts/Makefile                         |   5 -
>  scripts/Makefile.build                   |   9 ++
>  scripts/Makefile.headersinst             | 132 ++++++++++-------------
>  scripts/Makefile.lib                     |   3 +
>  scripts/cc-system-headers.sh             |   8 ++
>  scripts/headers.sh                       |  29 -----
>  scripts/headers_install.sh               |  48 ++++-----
>  scripts/package/builddeb                 |   2 +-
>  usr/.gitignore                           |   1 -
>  usr/Makefile                             |   2 +
>  usr/include/.gitignore                   |   3 +
>  usr/include/Makefile                     | 132 +++++++++++++++++++++++
>  29 files changed, 329 insertions(+), 204 deletions(-)
>  rename include/uapi/{linux => }/Kbuild (77%)
>  create mode 100755 scripts/cc-system-headers.sh
>  delete mode 100755 scripts/headers.sh
>  create mode 100644 usr/include/.gitignore
>  create mode 100644 usr/include/Makefile
>
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv



-- 
Best Regards
Masahiro Yamada
