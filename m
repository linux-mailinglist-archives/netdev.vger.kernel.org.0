Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646C7E547
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfD2OtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:49:14 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:43392 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728318AbfD2OtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:49:14 -0400
Received: from grover.flets-west.jp (softbank126125154137.bbtec.net [126.125.154.137]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x3TElneS020381;
        Mon, 29 Apr 2019 23:47:50 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x3TElneS020381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1556549270;
        bh=0mmb8KbbWCtfjhHsrd+vj0pp6+i0mYzDtsbj3K9ug1I=;
        h=From:To:Cc:Subject:Date:From;
        b=E/9dWespF/U4QZkTXajWW8HEjCLAKKtzzLhBEGSrAj4VfD82pdB+QgLaWlgB+DsaT
         6UI0FG8X+mhTF7iJ86IY7bk/U3OQrxcU79h6tlvXMIkW+rNrOfRKryd3DVsWy1zDwK
         GEoeQScbG6zQ4LquGHs3UKD3O3f/13bm8Od5l+ilrhK1fR+9bjc8BSU6acIm2x3XLC
         HdLCTYw7cNLim5D7ScD3XYmceYHSbcgDvkXZ5QWKCbEs8RsV66wgIIkk/SAIjtrJzP
         pGVLbPgdaEyka1onhlmaEIaNBLWsgWmMU3aBWNiOlyoyhj6j6f3nXE4QE494aHzA1n
         QXm9/2qJy4Asg==
X-Nifty-SrcIP: [126.125.154.137]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sirio Balmelli <sirio@b-ad.ch>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        linux-kernel@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH] bpftool: exclude bash-completion/bpftool from .gitignore pattern
Date:   Mon, 29 Apr 2019 23:47:39 +0900
Message-Id: <1556549259-16298-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
intended to ignore the following build artifact:

  tools/bpf/bpftool/bpftool

However, the .gitignore entry is effective not only for the current
directory, but also for any sub-directories.

So, the following file is also considered to be ignored:

  tools/bpf/bpftool/bash-completion/bpftool

It is obviously version-controlled, so should be excluded from the
.gitignore pattern.

You can fix it by prefixing the pattern with '/', which means it is
only effective in the current directory.

I prefixed the other patterns consistently. IMHO, '/' prefixing is
safer when you intend to ignore specific files.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 tools/bpf/bpftool/.gitignore | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
index 67167e4..19efcc8 100644
--- a/tools/bpf/bpftool/.gitignore
+++ b/tools/bpf/bpftool/.gitignore
@@ -1,5 +1,5 @@
 *.d
-bpftool
-bpftool*.8
-bpf-helpers.*
-FEATURE-DUMP.bpftool
+/bpftool
+/bpftool*.8
+/bpf-helpers.*
+/FEATURE-DUMP.bpftool
-- 
2.7.4

