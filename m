Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890BCF6A22
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKJQbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:31:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbfKJQbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573403484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NYL+EMILRZtMS9HsJMtfOH0Pn977hfVVaofdbnoRpeY=;
        b=KEprjiaKM5D7rsHtxaknr5x5chTR/dSXG/T8TknBZZJs6wxdRxUSCtDfasHJUT4w4h06iD
        F78GYNWCZ9z+u2CvQwndzFZlVpcO4oskzbLIztc3ECV40PkU545Pvwb8+OUSfsOG8V6GFH
        nyvkSOjSvIS88bIfcX+uxJFaDuS9xjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-qC36rPmGM62JiDsMD6VHlw-1; Sun, 10 Nov 2019 11:31:21 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB15FDB20;
        Sun, 10 Nov 2019 16:31:19 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 221015DA75;
        Sun, 10 Nov 2019 16:31:17 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2DBAD30FC134F;
        Sun, 10 Nov 2019 17:31:16 +0100 (CET)
Subject: [net-next PATCH] samples/bpf: adjust Makefile and README.rst
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 10 Nov 2019 17:31:16 +0100
Message-ID: <157340347607.14617.683175264051058224.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: qC36rPmGM62JiDsMD6VHlw-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Side effect of some kbuild changes resulted in breaking the
documented way to build samples/bpf/.

This patch change the samples/bpf/Makefile to work again, when
invoking make from the subdir samples/bpf/. Also update the
documentation in README.rst, to reflect the new way to build.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/Makefile   |    4 ++--
 samples/bpf/README.rst |   12 +++++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index d88c01275239..8e32a4d29a38 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -203,7 +203,7 @@ TPROGLDLIBS_test_overhead=09+=3D -lrt
 TPROGLDLIBS_xdpsock=09=09+=3D -pthread
=20
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine o=
n cmdline:
-#  make samples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm/bui=
ld/bin/clang
+#  make M=3Dsamples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm=
/build/bin/clang
 LLC ?=3D llc
 CLANG ?=3D clang
 LLVM_OBJCOPY ?=3D llvm-objcopy
@@ -246,7 +246,7 @@ endif
=20
 # Trick to allow make to be run from this directory
 all:
-=09$(MAKE) -C ../../ $(CURDIR)/ BPF_SAMPLES_PATH=3D$(CURDIR)
+=09$(MAKE) -C ../../ M=3D$(CURDIR) BPF_SAMPLES_PATH=3D$(CURDIR)
=20
 clean:
 =09$(MAKE) -C ../../ M=3D$(CURDIR) clean
diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index cc1f00a1ee06..dd34b2d26f1c 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -46,12 +46,10 @@ Compiling
 For building the BPF samples, issue the below command from the kernel
 top level directory::
=20
- make samples/bpf/
-
-Do notice the "/" slash after the directory name.
+ make M=3Dsamples/bpf
=20
 It is also possible to call make from this directory.  This will just
-hide the the invocation of make as above with the appended "/".
+hide the invocation of make as above.
=20
 Manually compiling LLVM with 'bpf' support
 ------------------------------------------
@@ -77,7 +75,7 @@ Quick sniplet for manually compiling LLVM and clang
 It is also possible to point make to the newly compiled 'llc' or
 'clang' command via redefining LLC or CLANG on the make command line::
=20
- make samples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm/build=
/bin/clang
+ make M=3Dsamples/bpf LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm/bu=
ild/bin/clang
=20
 Cross compiling samples
 -----------------------
@@ -98,10 +96,10 @@ Pointing LLC and CLANG is not necessarily if it's insta=
lled on HOST and have
 in its targets appropriate arm64 arch (usually it has several arches).
 Build samples::
=20
- make samples/bpf/
+ make M=3Dsamples/bpf
=20
 Or build samples with SYSROOT if some header or library is absent in toolc=
hain,
 say libelf, providing address to file system containing headers and libs,
 can be RFS of target board::
=20
- make samples/bpf/ SYSROOT=3D~/some_sysroot
+ make M=3Dsamples/bpf SYSROOT=3D~/some_sysroot

