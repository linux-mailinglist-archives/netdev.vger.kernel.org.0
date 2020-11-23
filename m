Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007FB2C09DC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388552AbgKWNN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388522AbgKWNNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606137203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IsLM1UDMLXmRkRLkuy+KFrXPGu3beCudF+xPd0mVg1s=;
        b=NVm+mnVnxCOmYsLpsIyplsZ9+RneojwTnOAT9gCeMQ6yp8HiOXJaysToS2Rv8bnUlCv4Vw
        yH1cy1RNBXhIXroE+bzwsYyC9DtpGFlMlTPk2+6DuBZsQkyJK/jqCvVNknmSFB/8Ra75gX
        jCISRu1m8brnFBwcYGdv7RYPB/HIxwo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-XZfFAaWyPFecnP-GKaiOMA-1; Mon, 23 Nov 2020 08:13:20 -0500
X-MC-Unique: XZfFAaWyPFecnP-GKaiOMA-1
Received: by mail-pg1-f199.google.com with SMTP id z130so12427426pgz.19
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:13:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IsLM1UDMLXmRkRLkuy+KFrXPGu3beCudF+xPd0mVg1s=;
        b=hCjtfm3HjY90IxZce+j/n+MoM5/D44JBnka9ZuLwKHdgs/lvtPyGcWoQpmdZTBw22O
         n61xgnZNbk8oFXO1BpootXYjBT6hZbgYNWIyZGv9KZK86d4BqfdSnINT37J3kRdbgYI9
         EdIzUhRwsiksbAPYDGsfbJmOuXKx3jj1Y/LNuQUeRkys0Yw+49Ap3QMhQIF7RLu7plOB
         VoUe1lCPuY1GRbZNdKQyQQLpLkWOZiDQ2KuqWE91pz3YiLNAYXyUDBWqQbWHuwyfPoMh
         XzoAR/erINUcLmMYgdcds/m8IjlMmQ/piakVtiFQhxnTcgPss0U4EAje1YOyglwVv09G
         NCLw==
X-Gm-Message-State: AOAM533Qor8g7sAc/8R6QQRlUGbZYrCkdUF0LFsm6zHsc7ZALa/A3g7w
        n3dR6UMUph95u9L10T95AuWqWALnVTRPJGyBBnneHE217iNiJTsJh2RMMAQ0sEWZnQGRve+F1AH
        jeUicxA6JvrL1WJs=
X-Received: by 2002:a63:ff03:: with SMTP id k3mr27087343pgi.304.1606137199648;
        Mon, 23 Nov 2020 05:13:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGUkrVhRlwnNPySOSVHrOOtkW9IHSay4gtS8Hbby0hAFRIWJnYTKS/RMZG4JY3FlemOcZa1w==
X-Received: by 2002:a63:ff03:: with SMTP id k3mr27087319pgi.304.1606137199304;
        Mon, 23 Nov 2020 05:13:19 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 84sm12075505pfu.53.2020.11.23.05.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:13:18 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv6 iproute2-next 1/5] iproute2: add check_libbpf() and get_libbpf_version()
Date:   Mon, 23 Nov 2020 21:11:57 +0800
Message-Id: <20201123131201.4108483-2-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201123131201.4108483-1-haliu@redhat.com>
References: <20201116065305.1010651-1-haliu@redhat.com>
 <20201123131201.4108483-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch aim to add basic checking functions for later iproute2
libbpf support.

First we add check_libbpf() in configure to see if we have bpf library
support. By default the system libbpf will be used, but static linking
against a custom libbpf version can be achieved by passing libbpf DESTDIR
to variable LIBBPF_DIR for configure.

Another variable LIBBPF_FORCE is used to control whether to build iproute2
with libbpf. If set to on, then force to build with libbpf and exit if
not available. If set to off, then force to not build with libbpf.

When dynamically linking against libbpf, we can't be sure that the
version we discovered at compile time is actually the one we are
using at runtime. This can lead to hard-to-debug errors. So we add
a new file lib/bpf_glue.c and a helper function get_libbpf_version()
to get correct libbpf version at runtime.

Signed-off-by: Hangbin Liu <haliu@redhat.com>
---

v6:
1) Add a new helper get_libbpf_version() to get runtime libbpf version
  based on Toke's xdp-tools patch. The libbpf version will be printed
  when exec ip -V or tc -V.

v5:
1) Fix LIBBPF_DIR type and description, use libbpf DESTDIR as LIBBPF_DIR
   dest.

v4:
1) Remove duplicate LIBBPF_CFLAGS
2) Remove un-needed -L since using static libbpf.a
3) Fix == not supported in dash
4) Extend LIBBPF_FORCE to support on/off, when set to on, stop building when
   there is no libbpf support. If set to off, discard libbpf check.
5) Print libbpf version after checking

v3:
Check function bpf_program__section_name() separately and only use it
on higher libbpf version.

v2:
No update
---
 configure          | 113 +++++++++++++++++++++++++++++++++++++++++++++
 include/bpf_util.h |   3 ++
 ip/ip.c            |  10 +++-
 lib/Makefile       |   2 +-
 lib/bpf_glue.c     |  63 +++++++++++++++++++++++++
 tc/tc.c            |  10 +++-
 6 files changed, 196 insertions(+), 5 deletions(-)
 create mode 100644 lib/bpf_glue.c

diff --git a/configure b/configure
index 307912aa..2c363d3b 100755
--- a/configure
+++ b/configure
@@ -2,6 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 # This is not an autoconf generated configure
 #
+# Influential LIBBPF environment variables:
+#   LIBBPF_FORCE={on,off}   on: require link against libbpf;
+#                           off: disable libbpf probing
+#   LIBBPF_DIR              Path to libbpf DESTDIR to use
+
 INCLUDE=${1:-"$PWD/include"}
 
 # Output file which is input to Makefile
@@ -240,6 +245,111 @@ check_elf()
     fi
 }
 
+have_libbpf_basic()
+{
+    cat >$TMPDIR/libbpf_test.c <<EOF
+#include <bpf/libbpf.h>
+int main(int argc, char **argv) {
+    bpf_program__set_autoload(NULL, false);
+    bpf_map__ifindex(NULL);
+    bpf_map__set_pin_path(NULL, NULL);
+    bpf_object__open_file(NULL, NULL);
+    return 0;
+}
+EOF
+
+    $CC -o $TMPDIR/libbpf_test $TMPDIR/libbpf_test.c $LIBBPF_CFLAGS $LIBBPF_LDLIBS >/dev/null 2>&1
+    local ret=$?
+
+    rm -f $TMPDIR/libbpf_test.c $TMPDIR/libbpf_test
+    return $ret
+}
+
+have_libbpf_sec_name()
+{
+    cat >$TMPDIR/libbpf_sec_test.c <<EOF
+#include <bpf/libbpf.h>
+int main(int argc, char **argv) {
+    void *ptr;
+    bpf_program__section_name(NULL);
+    return 0;
+}
+EOF
+
+    $CC -o $TMPDIR/libbpf_sec_test $TMPDIR/libbpf_sec_test.c $LIBBPF_CFLAGS $LIBBPF_LDLIBS >/dev/null 2>&1
+    local ret=$?
+
+    rm -f $TMPDIR/libbpf_sec_test.c $TMPDIR/libbpf_sec_test
+    return $ret
+}
+
+check_force_libbpf_on()
+{
+    # if set LIBBPF_FORCE=on but no libbpf support, just exist the config
+    # process to make sure we don't build without libbpf.
+    if [ "$LIBBPF_FORCE" = on ]; then
+        echo "	LIBBPF_FORCE=on set, but couldn't find a usable libbpf"
+        exit 1
+    fi
+}
+
+check_libbpf()
+{
+    # if set LIBBPF_FORCE=off, disable libbpf entirely
+    if [ "$LIBBPF_FORCE" = off ]; then
+        echo "no"
+        return
+    fi
+
+    if ! ${PKG_CONFIG} libbpf --exists && [ -z "$LIBBPF_DIR" ] ; then
+        echo "no"
+        check_force_libbpf_on
+        return
+    fi
+
+    if [ $(uname -m) = x86_64 ]; then
+        local LIBBPF_LIBDIR="${LIBBPF_DIR}/usr/lib64"
+    else
+        local LIBBPF_LIBDIR="${LIBBPF_DIR}/usr/lib"
+    fi
+
+    if [ -n "$LIBBPF_DIR" ]; then
+        LIBBPF_CFLAGS="-I${LIBBPF_DIR}/usr/include"
+        LIBBPF_LDLIBS="${LIBBPF_LIBDIR}/libbpf.a -lz -lelf"
+        LIBBPF_VERSION=$(PKG_CONFIG_LIBDIR=${LIBBPF_LIBDIR}/pkgconfig ${PKG_CONFIG} libbpf --modversion)
+    else
+        LIBBPF_CFLAGS=$(${PKG_CONFIG} libbpf --cflags)
+        LIBBPF_LDLIBS=$(${PKG_CONFIG} libbpf --libs)
+        LIBBPF_VERSION=$(${PKG_CONFIG} libbpf --modversion)
+    fi
+
+    if ! have_libbpf_basic; then
+        echo "no"
+        echo "	libbpf version $LIBBPF_VERSION is too low, please update it to at least 0.1.0"
+        check_force_libbpf_on
+        return
+    else
+        echo "HAVE_LIBBPF:=y" >> $CONFIG
+        echo 'CFLAGS += -DHAVE_LIBBPF ' $LIBBPF_CFLAGS >> $CONFIG
+        echo "CFLAGS += -DLIBBPF_VERSION=\\\"$LIBBPF_VERSION\\\"" >> $CONFIG
+        echo 'LDLIBS += ' $LIBBPF_LDLIBS >> $CONFIG
+
+        if [ -z "$LIBBPF_DIR" ]; then
+            echo "CFLAGS += -DLIBBPF_DYNAMIC" >> $CONFIG
+        fi
+    fi
+
+    # bpf_program__title() is deprecated since libbpf 0.2.0, use
+    # bpf_program__section_name() instead if we support
+    if have_libbpf_sec_name; then
+        echo "HAVE_LIBBPF_SECTION_NAME:=y" >> $CONFIG
+        echo 'CFLAGS += -DHAVE_LIBBPF_SECTION_NAME ' >> $CONFIG
+    fi
+
+    echo "yes"
+    echo "	libbpf version $LIBBPF_VERSION"
+}
+
 check_selinux()
 # SELinux is a compile time option in the ss utility
 {
@@ -385,6 +495,9 @@ check_setns
 echo -n "SELinux support: "
 check_selinux
 
+echo -n "libbpf support: "
+check_libbpf
+
 echo -n "ELF support: "
 check_elf
 
diff --git a/include/bpf_util.h b/include/bpf_util.h
index 63db07ca..dee5bb02 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -300,4 +300,7 @@ static inline int bpf_recv_map_fds(const char *path, int *fds,
 	return -1;
 }
 #endif /* HAVE_ELF */
+
+const char *get_libbpf_version(void);
+
 #endif /* __BPF_UTIL__ */
diff --git a/ip/ip.c b/ip/ip.c
index 5e31957f..466dbb52 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -24,6 +24,7 @@
 #include "namespace.h"
 #include "color.h"
 #include "rt_names.h"
+#include "bpf_util.h"
 
 int preferred_family = AF_UNSPEC;
 int human_readable;
@@ -147,8 +148,9 @@ static int batch(const char *name)
 
 int main(int argc, char **argv)
 {
-	char *basename;
+	const char *libbpf_version;
 	char *batch_file = NULL;
+	char *basename;
 	int color = 0;
 
 	/* to run vrf exec without root, capabilities might be set, drop them
@@ -229,7 +231,11 @@ int main(int argc, char **argv)
 			++timestamp;
 			++timestamp_short;
 		} else if (matches(opt, "-Version") == 0) {
-			printf("ip utility, iproute2-%s\n", version);
+			printf("ip utility, iproute2-%s", version);
+			libbpf_version = get_libbpf_version();
+			if (libbpf_version)
+				printf(", libbpf %s", libbpf_version);
+			printf("\n");
 			exit(0);
 		} else if (matches(opt, "-force") == 0) {
 			++force;
diff --git a/lib/Makefile b/lib/Makefile
index 13f4ee15..a02775a5 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
-	names.o color.o bpf.o exec.o fs.o cg_map.o
+	names.o color.o bpf.o bpf_glue.o exec.o fs.o cg_map.o
 
 NLOBJ=libgenl.o libnetlink.o mnl_utils.o
 
diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
new file mode 100644
index 00000000..67c41c22
--- /dev/null
+++ b/lib/bpf_glue.c
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * bpf_glue.c:	BPF code to call both legacy and libbpf code
+ * Authors:	Hangbin Liu <haliu@redhat.com>
+ *
+ */
+#include "bpf_util.h"
+
+#ifdef HAVE_LIBBPF
+static const char *_libbpf_compile_version = LIBBPF_VERSION;
+static char _libbpf_version[10] = {};
+
+const char *get_libbpf_version(void)
+{
+	/* Start by copying compile-time version into buffer so we have a
+	 * fallback value in case we are dynamically linked, or can't find a
+	 * version in /proc/self/maps below.
+	 */
+	strncpy(_libbpf_version, _libbpf_compile_version,
+		sizeof(_libbpf_version)-1);
+#ifdef LIBBPF_DYNAMIC
+	char buf[PATH_MAX], *s;
+	bool found = false;
+	FILE *fp;
+
+	/* When dynamically linking against libbpf, we can't be sure that the
+	 * version we discovered at compile time is actually the one we are
+	 * using at runtime. This can lead to hard-to-debug errors, so we try to
+	 * discover the correct version at runtime.
+	 *
+	 * The simple solution to this would be if libbpf itself exported a
+	 * version in its API. But since it doesn't, we work around this by
+	 * parsing the mappings of the binary at runtime, looking for the full
+	 * filename of libbpf.so and using that.
+	 */
+	fp = fopen("/proc/self/maps", "r");
+	if (fp == NULL)
+		goto out;
+
+	while ((s = fgets(buf, sizeof(buf), fp)) != NULL) {
+		if ((s = strstr(buf, "libbpf.so.")) != NULL) {
+			strncpy(_libbpf_version, s+10, sizeof(_libbpf_version)-1);
+			strtok(_libbpf_version, "\n");
+			found = true;
+			break;
+		}
+	}
+
+	fclose(fp);
+out:
+	if (!found)
+		fprintf(stderr, "Couldn't find runtime libbpf version - falling back to compile-time value!\n");
+#endif /* LIBBPF_DYNAMIC */
+
+	_libbpf_version[sizeof(_libbpf_version)-1] = '\0';
+	return _libbpf_version;
+}
+#else
+const char *get_libbpf_version(void)
+{
+	return NULL;
+}
+#endif /* HAVE_LIBBPF */
diff --git a/tc/tc.c b/tc/tc.c
index af9b21da..7557b977 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -30,6 +30,7 @@
 #include "tc_common.h"
 #include "namespace.h"
 #include "rt_names.h"
+#include "bpf_util.h"
 
 int show_stats;
 int show_details;
@@ -259,8 +260,9 @@ static int batch(const char *name)
 
 int main(int argc, char **argv)
 {
-	int ret;
+	const char *libbpf_version;
 	char *batch_file = NULL;
+	int ret;
 
 	while (argc > 1) {
 		if (argv[1][0] != '-')
@@ -277,7 +279,11 @@ int main(int argc, char **argv)
 		} else if (matches(argv[1], "-graph") == 0) {
 			show_graph = 1;
 		} else if (matches(argv[1], "-Version") == 0) {
-			printf("tc utility, iproute2-%s\n", version);
+			printf("tc utility, iproute2-%s", version);
+			libbpf_version = get_libbpf_version();
+			if (libbpf_version)
+				printf(", libbpf %s", libbpf_version);
+			printf("\n");
 			return 0;
 		} else if (matches(argv[1], "-iec") == 0) {
 			++use_iec;
-- 
2.25.4

