Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B81A177C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfH2K5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:57:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35134 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfH2K5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 06:57:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id g7so2973001wrx.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 03:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HKngvou9PTiEySa5fxRXC+r6OGUa9j6poOx1wOazin8=;
        b=VUdh0b9J1kPYrn231R1DeFnsGsrc8wIoW/ULI1erpzMlfMjSjBwrWiCQ3r28eiRhh+
         HyZEBxhl9uWV5TxNSlgjeoUCWXv+xR+hV285D6M5iKC/vRyzb88NXxYepymDRWS5LX1X
         bVAnwtGNXPCmvhnv3qlr3xF0WJ4D9qqt21NJKQMIxLZ4DMqyhgJ2l9TzmTBmShHEkZKF
         WBOkGpVSdn3oloet7sBG23+xeIE/670bVKa3JKxvEkeAY1tI2swqbInckRXWntStXrNh
         8fPNvukXoU6zhdxaBA21vTCn2UWDeUFCMKHLS5r3wFk/d/T3Svt1eM77mUp2lzTVpJRm
         hP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HKngvou9PTiEySa5fxRXC+r6OGUa9j6poOx1wOazin8=;
        b=LILvmvTyVx7OzgKj2PIL3rGiushPvgW/Kq1gsle30PJ3qbe7S+jZYnLmqcvVX8WeO+
         VZV4Ik/de6lKLg5fCYMDawb23K1Cy3vpienarwKX/YuA/lyPlGyJ5Xat7FasTLyxOzih
         GxokKkfeUTzA6oXpz6GMWZKkfYU5Yww1zAMgfpXNJuTQ3u5AE2ZvOfUsiQRn94s8TFDk
         o5JZB7w5CrR45BqEns7c0ZNi+xahzNp32eeomsOsig8dXYeSoo9XiS/Mf5bqcTkjSbJ9
         AL/Eews108dEggbJRgURa92+Ty1Zlx7Xqrlug4J6lLQnIgloRq3EKb+t/I96a5tyCBKV
         B9AQ==
X-Gm-Message-State: APjAAAVAF4n3KLDqWvuwiN3nbp21LF+c7YzZ7vYpGDRgMFQ9e+fjeh4z
        4sjZGVGlLzhvnCSpaxA3Yip23zOh0X4=
X-Google-Smtp-Source: APXvYqyEo1n1o7xcGcvE+PiGOi6It4KCuv4fEy3D/JhdLjGRArCkCd0FldCMjXdDxDz6Ar3TgmVzNw==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr11274370wrt.34.1567076221444;
        Thu, 29 Aug 2019 03:57:01 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id j18sm2091938wrr.20.2019.08.29.03.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 03:57:00 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next 1/3] tools: bpftool: ignore make built-in rules for getting kernel version
Date:   Thu, 29 Aug 2019 11:56:43 +0100
Message-Id: <20190829105645.12285-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829105645.12285-1-quentin.monnet@netronome.com>
References: <20190829105645.12285-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool calls the toplevel Makefile to get the kernel version for the
sources it is built from. But when the utility is built from the top of
the kernel repository, it may dump the following error message for
certain architectures (including x86):

    $ make tools/bpf
    [...]
    make[3]: *** [checkbin] Error 1
    [...]

This does not prevent bpftool compilation, but may feel disconcerting.
The "checkbin" arch-dependent target is not supposed to be called for
target "kernelversion", which is a simple "echo" of the version number.

It turns out this is caused by the make invocation in tools/bpf/bpftool,
which attempts to find implicit rules to apply. Extract from debug
output:

    Reading makefiles...
    Reading makefile 'Makefile'...
    Reading makefile 'scripts/Kbuild.include' (search path) (no ~ expansion)...
    Reading makefile 'scripts/subarch.include' (search path) (no ~ expansion)...
    Reading makefile 'arch/x86/Makefile' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.kcov' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.gcc-plugins' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.kasan' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.extrawarn' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.ubsan' (search path) (no ~ expansion)...
    Updating makefiles....
     Considering target file 'scripts/Makefile.ubsan'.
      Looking for an implicit rule for 'scripts/Makefile.ubsan'.
      Trying pattern rule with stem 'Makefile.ubsan'.
    [...]
      Trying pattern rule with stem 'Makefile.ubsan'.
      Trying implicit prerequisite 'scripts/Makefile.ubsan.o'.
      Looking for a rule with intermediate file 'scripts/Makefile.ubsan.o'.
       Avoiding implicit rule recursion.
       Trying pattern rule with stem 'Makefile.ubsan'.
       Trying rule prerequisite 'prepare'.
       Trying rule prerequisite 'FORCE'.
      Found an implicit rule for 'scripts/Makefile.ubsan'.
        Considering target file 'prepare'.
         File 'prepare' does not exist.
          Considering target file 'prepare0'.
           File 'prepare0' does not exist.
            Considering target file 'archprepare'.
             File 'archprepare' does not exist.
              Considering target file 'archheaders'.
               File 'archheaders' does not exist.
               Finished prerequisites of target file 'archheaders'.
              Must remake target 'archheaders'.
    Putting child 0x55976f4f6980 (archheaders) PID 31743 on the chain.

To avoid that, pass the -r and -R flags to eliminate the use of make
built-in rules (and while at it, built-in variables) when running
command "make kernelversion" from bpftool's Makefile.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index f284c207765a..cd0fc05464e7 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -24,7 +24,7 @@ endif
 
 LIBBPF = $(BPF_PATH)libbpf.a
 
-BPFTOOL_VERSION := $(shell make --no-print-directory -sC ../../.. kernelversion)
+BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 
 $(LIBBPF): FORCE
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) $(OUTPUT)libbpf.a
-- 
2.17.1

