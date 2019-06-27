Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2365C5791D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 03:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfF0Btq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 21:49:46 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:27093 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfF0Btq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 21:49:46 -0400
Received: from grover.flets-west.jp (softbank126125154139.bbtec.net [126.125.154.139]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id x5R1kN0v032702;
        Thu, 27 Jun 2019 10:46:23 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com x5R1kN0v032702
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561599984;
        bh=t/tKte8+f+WnIerV46Kqk5V4Cu5goyQEz8X3TPyTH+k=;
        h=From:To:Cc:Subject:Date:From;
        b=x56ew+Nf/mRL+Y9auCSqcIA7wXTn2ja3HVYzHe0zb/E43gJ8Lggs/PguNK3OCZjgp
         uEyvbCO2H1dT/DpTwUE6DbmQRbC6vOSL5OITz+s0Bb0odvn6gylTlEcXpF8asnjeml
         88aMR4WR5z+A0KqVY3or1TMOqNYfDZk2Ex4sSzWca/5b84o36B0eGUd3VL7kWJzm2Z
         ht4QKpX3nwgoUQtDo9jLHs9EQ7Dgcaxi1GdZoFz3rV7s0Tp5VvQMZ+OUmUdUW+ge61
         tE78teOBqyznZ79jc3oTqjv6+zpNpU51id+uwMW/3dc8GBkGo5Jz2XIAR4PoONDPEu
         JgLgECL33cJbg==
X-Nifty-SrcIP: [126.125.154.139]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Sam Ravnborg <sam@ravnborg.org>,
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
Subject: [PATCH v2 0/4] Compile-test UAPI and kernel headers
Date:   Thu, 27 Jun 2019 10:46:13 +0900
Message-Id: <20190627014617.600-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1/4: reworked v2.

2/4: fix a flaw I noticed when I was working on this series

3/4: maybe useful for 4/4 and in some other places

4/4: v2. compile as many headers as possible.


Changes in v2:
 - Add CONFIG_CPU_{BIG,LITTLE}_ENDIAN guard to avoid build error
 - Use 'header-test-' instead of 'no-header-test'
 - Avoid weird 'find' warning when cleaning
  - New patch
  - New patch
  - Add everything to test coverage, and exclude broken ones
  - Rename 'Makefile' to 'Kbuild'
  - Add CONFIG_KERNEL_HEADER_TEST option

Masahiro Yamada (4):
  kbuild: compile-test UAPI headers to ensure they are self-contained
  kbuild: do not create wrappers for header-test-y
  kbuild: support header-test-pattern-y
  kbuild: compile-test kernel headers to ensure they are self-contained

 .gitignore                         |    1 -
 Documentation/dontdiff             |    1 -
 Documentation/kbuild/makefiles.txt |   13 +-
 Makefile                           |    4 +-
 include/Kbuild                     | 1134 ++++++++++++++++++++++++++++
 init/Kconfig                       |   22 +
 scripts/Makefile.build             |   10 +-
 scripts/Makefile.lib               |   12 +-
 scripts/cc-system-headers.sh       |    8 +
 usr/.gitignore                     |    1 -
 usr/Makefile                       |    2 +
 usr/include/.gitignore             |    3 +
 usr/include/Makefile               |  133 ++++
 13 files changed, 1331 insertions(+), 13 deletions(-)
 create mode 100644 include/Kbuild
 create mode 100755 scripts/cc-system-headers.sh
 create mode 100644 usr/include/.gitignore
 create mode 100644 usr/include/Makefile

-- 
2.17.1

