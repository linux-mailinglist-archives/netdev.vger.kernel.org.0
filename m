Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194EC109BF3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfKZKKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:10:14 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39365 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbfKZKKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:10:14 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so6442664pga.6;
        Tue, 26 Nov 2019 02:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ecShvr+Zq6STOGx1l0iQ8cCvKv5lb6vZ/WjknM9nD6E=;
        b=d+YYczk4lJH43WHRgPgABeQW5AYRNcl7DJRbNi1c4p2WWFqkvolmM2XsQ44czI+mWp
         aVmIt6CW9B+7OpTNN+ps0zReed0nBfjwq9pklcNZKWKoIW7k1EQMTOHSi4d0/BCnYQee
         jinDCFwA6wNeZ4cBOG9cHPVSHcKoTCX0NlPdmJVevRHmMaf97cZDvXxtiWam3BPVOLr9
         RFEZ0ncycDTNPn5Urku5wMT1KOZ8+LKL42IakRmapDH1VNSLE/H9DD99CM6pQ9LMRigI
         y0T8KiZRlGegkVpLl3zTTtrATMEXAozU32i+jHRlYa3drVFQX+N2oBh6kWr44Z3T2zcB
         SEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ecShvr+Zq6STOGx1l0iQ8cCvKv5lb6vZ/WjknM9nD6E=;
        b=DeWsz7cvyOT96qeoXmPmrT16zTTQuqg0n0i4Gqhb9cUmzRb0p6rZe/MVpcv9Wavevl
         Hpkj7R6mOIFQ0GLBDg95hioXfwzO9YyDufp9P9FiGoSPjUf3O+uVHcf20rEhBBWvN08m
         uja5QKFFx3zjsdFWR9fiZ6Cuw7P+9FuOylA11h5rgdH0u/eWzp2suu0Ayt8VgWludHpi
         D9EVoYA3iVMTK7EbnDRgJw7ClEKtZaHHYsgu7lO+uT2b/caEy2oGDUOaC5QJlngaVGKJ
         bxWYiF02bo5QSN1FHFwv2KYC4ux3wHhzZSSPIPw3N+mTmONkL6+XuDAkF437HHHXdMAL
         GI2w==
X-Gm-Message-State: APjAAAUUc6aRz1JCNBB/kTSPkzKPkiVI7A0iBsOpeZfQP2jdoir64455
        K7px3UCEoupDnsMbP4KzB1E=
X-Google-Smtp-Source: APXvYqxLnUahtpS2ezzELlW12TWhqW19OSB0jtp9PSXtwd5yFTcnaRJ86M926/WsXnNPNpvBgZKE9Q==
X-Received: by 2002:a63:e4a:: with SMTP id 10mr35864959pgo.121.1574763013362;
        Tue, 26 Nov 2019 02:10:13 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h9sm12059065pgk.84.2019.11.26.02.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:10:12 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC 1/3] configure: add libbpf support
Date:   Tue, 26 Nov 2019 19:09:12 +0900
Message-Id: <20191126100914.5150-2-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
References: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation to add libbpf support for Qemu. When it is
enabled Qemu can load eBPF programs and manipulated eBPF maps
libbpf APIs.

When configured with --enable-libbpf, availability of libbpf is
checked. If it exists then CONFIG_LIBBPF is defined and the qemu
binary is linked with libbpf.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 configure | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/configure b/configure
index 6099be1d84..a7e8a8450d 100755
--- a/configure
+++ b/configure
@@ -504,6 +504,7 @@ debug_mutex="no"
 libpmem=""
 default_devices="yes"
 plugins="no"
+libbpf="no"
 
 supported_cpu="no"
 supported_os="no"
@@ -1539,6 +1540,8 @@ for opt do
   ;;
   --disable-plugins) plugins="no"
   ;;
+  --enable-libbpf) libbpf="yes"
+  ;;
   *)
       echo "ERROR: unknown option $opt"
       echo "Try '$0 --help' for more information"
@@ -1825,6 +1828,7 @@ disabled with --disable-FEATURE, default is enabled if available:
   debug-mutex     mutex debugging support
   libpmem         libpmem support
   xkbcommon       xkbcommon support
+  libbpf      eBPF program support
 
 NOTE: The object files are built at the place where configure is launched
 EOF
@@ -6084,6 +6088,19 @@ case "$slirp" in
     ;;
 esac
 
+##########################################
+# Do we have libbpf
+if test "$libbpf" != "no" ; then
+  if $pkg_config libbpf; then
+    libbpf="yes"
+    libbpf_libs=$($pkg_config --libs libbpf)
+  else
+    if test "$libbpf" == "yes" ; then
+      feature_not_found "libbpf" "Install libbpf devel"
+    fi
+    libbpf="no"
+  fi
+fi
 
 ##########################################
 # End of CC checks
@@ -6599,6 +6616,7 @@ echo "libpmem support   $libpmem"
 echo "libudev           $libudev"
 echo "default devices   $default_devices"
 echo "plugin support    $plugins"
+echo "XDP offload support $libbpf"
 
 if test "$supported_cpu" = "no"; then
     echo
@@ -7457,6 +7475,11 @@ if test "$plugins" = "yes" ; then
     fi
 fi
 
+if test "$libbpf" = "yes" ; then
+  echo "CONFIG_LIBBPF=y" >> $config_host_mak
+  echo "LIBBPF_LIBS=$libbpf_libs" >> $config_host_mak
+fi
+
 if test "$tcg_interpreter" = "yes"; then
   QEMU_INCLUDES="-iquote \$(SRC_PATH)/tcg/tci $QEMU_INCLUDES"
 elif test "$ARCH" = "sparc64" ; then
-- 
2.20.1

