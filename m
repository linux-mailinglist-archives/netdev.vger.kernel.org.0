Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2405876D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF0QmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:42:15 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:26335 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfF0QmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:42:13 -0400
Received: from grover.flets-west.jp (softbank126125154139.bbtec.net [126.125.154.139]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x5RGdDPu001384;
        Fri, 28 Jun 2019 01:39:13 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x5RGdDPu001384
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561653555;
        bh=gmui0wDo25dBFORH/YJIka6km4EHEw6EORwEfx2o9yQ=;
        h=From:To:Cc:Subject:Date:From;
        b=LHdsJdpohHEYXa83KNz44gcdbSGWwuH8/i52iXtlPRu1GaI0q1AIx+uhiZPjHD+z5
         DuAejfYBz1ERCd2/UEO+AX31hXfRB+q54megCy3CibiEP6HvQxVWjnWOs45HCaF/1v
         svegg5xjoWH1Nyji+k19J2kFhp8cBCa3WLF4tFizjrni8vK+F5L1uhpXRV3iLegiR5
         10g+kzx64nxuVStvUP5W0JRs+1HhG7fKuerU2btKzoJvU2KSNdGHewmxZAQ7sXFeN6
         9Ka0JHlHITKQRFO42QeQ+Z1F0cFcDwb6auRWANJTCWTkPeJI9xac1Jcl7bd/3v1Z3B
         JmLIbr58SXI/Q==
X-Nifty-SrcIP: [126.125.154.139]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Tony Luck <tony.luck@intel.com>, linux-doc@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        linux-riscv@lists.infradead.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Colin Cross <ccross@android.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v3 0/4] Compile-test UAPI and kernel headers
Date:   Fri, 28 Jun 2019 01:38:58 +0900
Message-Id: <20190627163903.28398-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1/4: Compile-test exported headers (reworked in v2)

2/4: fix a flaw I noticed when I was working on this series.
     Avoid generating intermediate wrappers.

3/4: maybe useful for 4/4 and in some other places.
     Add header-test-pattern-y syntax.

4/4: Compile-test kernel-space headers in include/.
     v2: compile as many headers as possible.
     v3: exclude more headers causing build errors


Masahiro Yamada (4):
  kbuild: compile-test UAPI headers to ensure they are self-contained
  kbuild: do not create wrappers for header-test-y
  kbuild: support header-test-pattern-y
  kbuild: compile-test kernel headers to ensure they are self-contained

 .gitignore                         |    1 -
 Documentation/dontdiff             |    1 -
 Documentation/kbuild/makefiles.txt |   13 +-
 Makefile                           |    4 +-
 include/Kbuild                     | 1250 ++++++++++++++++++++++++++++
 init/Kconfig                       |   22 +
 scripts/Makefile.build             |   10 +-
 scripts/Makefile.lib               |   13 +-
 scripts/cc-system-headers.sh       |    8 +
 usr/.gitignore                     |    1 -
 usr/Makefile                       |    2 +
 usr/include/.gitignore             |    3 +
 usr/include/Makefile               |  134 +++
 13 files changed, 1449 insertions(+), 13 deletions(-)
 create mode 100644 include/Kbuild
 create mode 100755 scripts/cc-system-headers.sh
 create mode 100644 usr/include/.gitignore
 create mode 100644 usr/include/Makefile

-- 
2.17.1

