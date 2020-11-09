Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D622AB197
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgKIHJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:09:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgKIHJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604905748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lr5FGifEj0XFUjCByrjQaeD9olbg/PmpTJM7l/NH3SE=;
        b=fqk4yRlkcD11SBxSbsc2u5R5pUigoUBD7lCw8pcC/m71mPTzPGXAoJ9dtrTIxzOTrgbYsy
        9m7uppAH3exr319q+ITqrGOCzY5rwUQy7sDSvIt8gGzkfHhrh6gLd+igBrLnpwmnKHOxd5
        V/ApcnPc7PXw10gSacl4wzOJUg37Cls=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-5q3aEB7kM2-XkLJA4Vvm0g-1; Mon, 09 Nov 2020 02:09:07 -0500
X-MC-Unique: 5q3aEB7kM2-XkLJA4Vvm0g-1
Received: by mail-pf1-f198.google.com with SMTP id a24so5860286pfo.3
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 23:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lr5FGifEj0XFUjCByrjQaeD9olbg/PmpTJM7l/NH3SE=;
        b=n//mQ4nd36UiLHKwFIBarWICbZD5ipUHForKCZAQQBtqsar/ckpWF0X75Jj/p5xoOh
         wsKr+QCRQhLlzogJRbg1kJc0Srh8fs7ohFEzOs6c1lwQdUhH7KA03r+XCS9AWiHu5p/k
         3s58dkm9181HcLNOdTG/0iM8cr0iK21nNFvvMBAGibG+TQbY6Xyh7NPjk/Fa73t4M+K+
         999CadvUKrVeVjV9s3u/3dCLZIVfrZTTp9u3zEeFAe8f/sRgPm2wQw6iDWt3haJry2v6
         vecdTHLhTdg6QkOg4O0cVBTHku/qD8vFEA9cDoWEYTIIGXcHARr0fWNxUuLQgeGhaJmp
         I3CA==
X-Gm-Message-State: AOAM533lFjLpmtawE7DXL4uBsLsJcaNo4PtRH6hbM+7mjDh4fwlAUZ8s
        HjYEgc18zEw+7hcp1YgObyLxYi04pWAnYVUa9uZWOsWGKpfUc0TDKDDEPQNgnk8znFhd6fHfDfR
        +C3hhsxbukUufwTE=
X-Received: by 2002:a17:90a:5508:: with SMTP id b8mr6175040pji.85.1604905746225;
        Sun, 08 Nov 2020 23:09:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysEBuccEoiH9atrfymWGXNP4Pu0uVGIsOO1JTSoqNY//f96IqxJ9ndfe8U3s8b7CteM0UJ/Q==
X-Received: by 2002:a17:90a:5508:: with SMTP id b8mr6175025pji.85.1604905746024;
        Sun, 08 Nov 2020 23:09:06 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f17sm2492483pfk.70.2020.11.08.23.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 23:09:05 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv4 iproute2-next 1/5] configure: add check_libbpf() for later libbpf support
Date:   Mon,  9 Nov 2020 15:07:58 +0800
Message-Id: <20201109070802.3638167-2-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201109070802.3638167-1-haliu@redhat.com>
References: <20201029151146.3810859-1-haliu@redhat.com>
 <20201109070802.3638167-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a check to see if we have libbpf support. By default the
system libbpf will be used, but static linking against a custom libbpf
version can be achieved by passing LIBBPF_DIR to configure.

Add another variable LIBBPF_FORCE to control whether to build iproute2
with libbpf. If set to on, then force to build with libbpf and exit if
not available. If set to off, then force to not build with libbpf.

Signed-off-by: Hangbin Liu <haliu@redhat.com>

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
 configure | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/configure b/configure
index 307912aa..3081a2ac 100755
--- a/configure
+++ b/configure
@@ -2,6 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 # This is not an autoconf generated configure
 #
+# Influential LIBBPF environment variables:
+#   LIBBPF_FORCE={on,off}   on: require link against libbpf;
+#                           off: disable libbpf probing
+#   LIBBPF_LIBDIR           Path to libbpf to use
+
 INCLUDE=${1:-"$PWD/include"}
 
 # Output file which is input to Makefile
@@ -240,6 +245,106 @@ check_elf()
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
+        local LIBBPF_LIBDIR="${LIBBPF_DIR}/lib64"
+    else
+        local LIBBPF_LIBDIR="${LIBBPF_DIR}/lib"
+    fi
+
+    if [ -n "$LIBBPF_DIR" ]; then
+        LIBBPF_CFLAGS="-I${LIBBPF_DIR}/include"
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
+        echo "HAVE_LIBBPF:=y" >>$CONFIG
+        echo 'CFLAGS += -DHAVE_LIBBPF ' $LIBBPF_CFLAGS >> $CONFIG
+        echo 'LDLIBS += ' $LIBBPF_LDLIBS >>$CONFIG
+    fi
+
+    # bpf_program__title() is deprecated since libbpf 0.2.0, use
+    # bpf_program__section_name() instead if we support
+    if have_libbpf_sec_name; then
+        echo "HAVE_LIBBPF_SECTION_NAME:=y" >>$CONFIG
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
@@ -385,6 +490,9 @@ check_setns
 echo -n "SELinux support: "
 check_selinux
 
+echo -n "libbpf support: "
+check_libbpf
+
 echo -n "ELF support: "
 check_elf
 
-- 
2.25.4

