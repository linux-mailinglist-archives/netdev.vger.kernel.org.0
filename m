Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43BE29EF5D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgJ2PMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728122AbgJ2PMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603984337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8yXg8GBRC3KQm8TIwzNWSAA5c5aI10yuXVMvwbMl8jQ=;
        b=D2D7Hs267/T35ZCny5IN4J/5DNaOebL1uAyd7HzDgLQX7V7qXTz9DNTMFbd/kyq+woDZRL
        /Raq2ASH1EdRdpxsXBOPHN9XjyuuHpZPpWuk7yyVqLanWyBraCOEbuyUZ15IKyfK99X7id
        HY57l5qpyZBTLdeuvsq6GkHIbAzqfYM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-jkNSuBxZMx-a6uavGNkSWQ-1; Thu, 29 Oct 2020 11:12:14 -0400
X-MC-Unique: jkNSuBxZMx-a6uavGNkSWQ-1
Received: by mail-pg1-f200.google.com with SMTP id u4so2312922pgg.14
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 08:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8yXg8GBRC3KQm8TIwzNWSAA5c5aI10yuXVMvwbMl8jQ=;
        b=m0vhPmDjwN8STxpbwvmJ9nOyeg2UL7G7qXakXEy780r8Gyt80xSiE3hCuwV3dYXqIe
         bLrwigCu+m4csbPKgr380vw0ZSSYWiJnhvqM+bE68gfGkLX+lmt3tbWTFpsAOY+QlHvZ
         E8USJiYXbFyu58GDW/tcBC9if/Bk816hF2wcIrzH+fl508u8qktabgFWdjodMUAKvBp1
         1aA9ZKmJwBn8wY6ZnKyCMz8oizPxOVXnWoQMnUxcd47yrs/45OeouwrMLelW31Ct4fOt
         IOp92if2FrAtCSqUrekMuPLb4XZC9VBtGtUyW1rW00MBa8EJs/ir20aN7PRdgYaaPxDE
         oOaQ==
X-Gm-Message-State: AOAM530UxXKxQybcox3DDZxv9S2J+06I0haqaErWkkmbMenPplGPpqGw
        glzEJ5O719pO5Ixu/S+/ue318q27w51fIFVSAl7YpkVvy7L/ERpzKzw2n3j6EDMjArU9gv82bEc
        tGEIDnmHE/bZG2bg=
X-Received: by 2002:a17:902:82c8:b029:d5:af76:e447 with SMTP id u8-20020a17090282c8b02900d5af76e447mr4522654plz.42.1603984333260;
        Thu, 29 Oct 2020 08:12:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwraKY2zYjg/36Q/sRro4/67gXgpcUIi2epbNWb6q9PHHSU54xissIzzblfsvoCuCO8XJVZCw==
X-Received: by 2002:a17:902:82c8:b029:d5:af76:e447 with SMTP id u8-20020a17090282c8b02900d5af76e447mr4522624plz.42.1603984333014;
        Thu, 29 Oct 2020 08:12:13 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3sm3305435pfv.92.2020.10.29.08.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:12:12 -0700 (PDT)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv3 iproute2-next 1/5] configure: add check_libbpf() for later libbpf support
Date:   Thu, 29 Oct 2020 23:11:42 +0800
Message-Id: <20201029151146.3810859-2-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201029151146.3810859-1-haliu@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a check to see if we support libbpf. By default the
system libbpf will be used, but static linking against a custom libbpf
version can be achieved by passing LIBBPF_DIR to configure. FORCE_LIBBPF
can be set to force configure to abort if no suitable libbpf is found,
which is useful for automatic packaging that wants to enforce the
dependency.

Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
v3:
Check function bpf_program__section_name() separately and only use it
on higher libbpf version.

v2:
No update
---
 configure | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/configure b/configure
index 307912aa..58a7176e 100755
--- a/configure
+++ b/configure
@@ -240,6 +240,97 @@ check_elf()
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
+check_force_libbpf()
+{
+    # if set FORCE_LIBBPF but no libbpf support, just exist the config
+    # process to make sure we don't build without libbpf.
+    if [ -n "$FORCE_LIBBPF" ]; then
+        echo "FORCE_LIBBPF set, but couldn't find a usable libbpf"
+        exit 1
+    fi
+}
+
+check_libbpf()
+{
+    if ! ${PKG_CONFIG} libbpf --exists && [ -z "$LIBBPF_DIR" ] ; then
+        echo "no"
+        check_force_libbpf
+        return
+    fi
+
+    if [ $(uname -m) == x86_64 ]; then
+        local LIBSUBDIR=lib64
+    else
+        local LIBSUBDIR=lib
+    fi
+
+    if [ -n "$LIBBPF_DIR" ]; then
+        LIBBPF_CFLAGS="-I${LIBBPF_DIR}/include -L${LIBBPF_DIR}/${LIBSUBDIR}"
+        LIBBPF_LDLIBS="${LIBBPF_DIR}/${LIBSUBDIR}/libbpf.a -lz -lelf"
+    else
+        LIBBPF_CFLAGS=$(${PKG_CONFIG} libbpf --cflags)
+        LIBBPF_LDLIBS=$(${PKG_CONFIG} libbpf --libs)
+    fi
+
+    if ! have_libbpf_basic; then
+        echo "no"
+        echo "	libbpf version is too low, please update it to at least 0.1.0"
+        check_force_libbpf
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
+        echo 'CFLAGS += -DHAVE_LIBBPF_SECTION_NAME ' $LIBBPF_CFLAGS >> $CONFIG
+    fi
+
+    echo "yes"
+}
+
 check_selinux()
 # SELinux is a compile time option in the ss utility
 {
@@ -385,6 +476,9 @@ check_setns
 echo -n "SELinux support: "
 check_selinux
 
+echo -n "libbpf support: "
+check_libbpf
+
 echo -n "ELF support: "
 check_elf
 
-- 
2.25.4

