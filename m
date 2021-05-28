Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0D73942B0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhE1MjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbhE1Mhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:37:48 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413DC06134B
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:35:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z19-20020a7bc7d30000b029017521c1fb75so4500760wmk.0
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CAJJ5ylE6DY1LEIvtkhT4WtykTW0tludDFTq303oux4=;
        b=TIozvvJQPkXu4CDZis28mzSB0BsmPt8pL9vaufk0dUutEqrhpHh149Eh4msMIbh6oH
         70TBMs4xNBKU38kNg2iV2Wmsmg1lj2fJsFTYHrxszRwMmyMP0AcSbNZGfTittXVJlzkj
         b8IuzRTY7b4gXF/VyEaZED9Wuz6cpeEcZzaq4bZXtkRfIkejsOMI5gmzeqwC726hnl5y
         5WnHaFvUcXxzzS1MgP5jagPqz8OCh9Pg8OzOrUgmPbXJwUhk+nJ6U+FSKyV44M+R26Uo
         WILaB4/pbIbYSV653afrXUSsEF3vBFE3MV2Mj+96/eS3stEFFgPX3gQMEkJ+l+GS2xiB
         Jj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CAJJ5ylE6DY1LEIvtkhT4WtykTW0tludDFTq303oux4=;
        b=gjCvksYOfyDHx3GHs8lXTbQIJBMm7OCBA0WU/9JOrAowJrTuBjgY2Sy+IjyOrn0l7G
         tcDjCtzKpO4mVGpWihFjxS34ImpJaTr5vC5oX8VixVhk1wZJYwyAl5jGq/0H/APUGkrG
         4lDp9tZF83p90XuMZmI2RjzkLnNblELjDJONFbS5pv6QenFnoTytcU/jSy2LcfJhEDhU
         Sga2hleAOcpSDuYhOgYif9Y8zjF38SSt9S/NILN9f2UGqnpoXowY0ZPHFBViGcq+88GJ
         43/CERlAq4yudG9Het8d1mM67huIW4lX/8u72uFCS8VSjMaU9O9XbllnYojT5c0/XHcw
         5/Nw==
X-Gm-Message-State: AOAM531E9nhh3nmqIp8KCGuM9Y1a5BcXhyeFN9LgfrQ74q7Mw0imAvau
        I0Fgz82Ur0oxR5ba6OFx+XDMw/oyQHlZh4Xt
X-Google-Smtp-Source: ABdhPJw8cMgGTksLR+xZtQGlN63wWp8cPEbNaz8t7M7JwJDM/gJGGXB4FJYoh9RwoxL98+c0ZGkVLw==
X-Received: by 2002:a05:600c:2cd2:: with SMTP id l18mr8275963wmc.142.1622205357884;
        Fri, 28 May 2021 05:35:57 -0700 (PDT)
Received: from wsfd-netdev-buildsys.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l8sm3980580wrf.0.2021.05.28.05.35.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 May 2021 05:35:57 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>
Subject: [Draft iproute2-next PATCH] configure: add options ability
Date:   Fri, 28 May 2021 08:35:43 -0400
Message-Id: <20210528123543.3836-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <haliu@redhat.com>

Hi David,

As we talked in my previous libbpf support patchset. You'd like to make
configure with option settings. Here is a draft patch. Not sure if this
is what you want.

There are also a lot variables that I not sure if we should add options
for them. e.g. PKG_CONFIG, CC, IPTC, IPT_LIB_DIR, etc. Do you have any
suggestions?

---
As there are more and more global environment variables in configures.
it would be more clear with options for users. Add related options for
variables. Keep using the same name so the old way (set global env) is
still working.

Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
 configure | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/configure b/configure
index 179eae08..aae324c9 100755
--- a/configure
+++ b/configure
@@ -1,13 +1,8 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # This is not an autoconf generated configure
-#
-# Influential LIBBPF environment variables:
-#   LIBBPF_FORCE={on,off}   on: require link against libbpf;
-#                           off: disable libbpf probing
-#   LIBBPF_DIR              Path to libbpf DESTDIR to use
 
-INCLUDE=${1:-"$PWD/include"}
+INCLUDE="$PWD/include"
 
 # Output file which is input to Makefile
 CONFIG=config.mk
@@ -486,6 +481,44 @@ endif
 EOF
 }
 
+usage()
+{
+        cat <<EOF
+Usage: $0 [OPTIONS]
+  --libbpf_force                enable/disable libbpf by force.
+                                on: require link against libbpf, quite config if no libbpf support
+                                off: disable libbpf probing
+  --libbpf_dir                  Path to libbpf DESTDIR to use
+  --include_dir                 Path to iproute2 include dir
+  -h | --help                   Show this usage info
+EOF
+        exit $1
+}
+
+while true; do
+	case "$1" in
+		--libbpf_force)
+			if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
+				usage 1
+			fi
+			LIBBPF_FORCE=$2
+			shift 2 ;;
+                --libbpf_dir)
+			LIBBPF_DIR="$2"
+                        shift 2 ;;
+                --include_dir)
+			# How to deal with the old INCLUDE usage?
+			INCLUDE=$2
+                        shift 2 ;;
+                -h | --help)
+                        usage 0 ;;
+                "")
+                        break ;;
+                *)
+                        usage 1 ;;
+        esac
+done
+
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
 
-- 
2.26.3

