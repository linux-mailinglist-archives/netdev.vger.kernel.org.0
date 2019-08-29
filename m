Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8993CA1783
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfH2K5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:57:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36872 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbfH2K5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 06:57:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so2955567wrt.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 03:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qo+jIlzTdRjj5XqbIhGgOupgZtD97wKDakusyLmwdK0=;
        b=BBvuGNw5ClkOpjUSYE/0x2LneTUCMC0fLn/Dz48gLNnMTa7OKEIk4BSx29+yThPQX/
         wIDBJ6W1ev1YXhGV9vMnnR1v539s3lDCapCAWuwXs8AM25c5hnF6C5AHYjuXlFrw0q4x
         5C7w9c8tJXtj//ua6JogNjVz7QTnhpywiuXcsB/3aZ1nytygekH6FNlWsmrLuq+0Frtx
         DE08G6zFzxubbuzdBkNxB1CyS3DDW/qoRDLuTMxMQQTmzUvM0Z8EX6cJiXNm1vkpf4iB
         22t4t5eW1HOF3pZcRvi1AYN5Kx53NV5rJYBd7wlGc0t1TfOvgifGoKP8KLdQJMTfd6Va
         lTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qo+jIlzTdRjj5XqbIhGgOupgZtD97wKDakusyLmwdK0=;
        b=nsVXSNitBMoEbPkBlzaJFFXCs08wj+8FCA2R8nt/1+QBQP1DFw4g64ZnAYRhoFx6Dj
         22NUvA0eghwO0cKYlQkOYrnbtFF57wPXLZXdcmtPIk/F9mOMfkv/EDcXRa74rcyQwRWa
         nn6C9G5n6X4O8iVO1xOMc2ceOo70TaMhOZeuH6PgnBsF2Oe4eTXO+8oWfir5evuTNJCK
         N5p5Om9e91CpGM+YIYDa3sNvvNIy7vFwMuXX4IhUWz/OS99h+XTskmdOPB+euZq3vtwy
         N9TTQvURDbBPUcoEZiLqPsy4Bzjs+8RUL1q8ftSZd3hb6upuJFb6b+qqkdexWaqWqN8j
         eq3g==
X-Gm-Message-State: APjAAAUC2jXuAAuOL5GKihh9kmKqGQG4rJoL+7PZYJ0i9RbuhbA+t+c3
        DSxPbGYIfFvyqSR35Mvg/rPj39HXrBE=
X-Google-Smtp-Source: APXvYqzC42eL+icqpZ9RvKAbHLc2ziGgDSxjZd1mGXZt1UPmohmCRi9OvHzk01jPMNZosga5kefTog==
X-Received: by 2002:a5d:658d:: with SMTP id q13mr3251729wru.78.1567076223889;
        Thu, 29 Aug 2019 03:57:03 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id j18sm2091938wrr.20.2019.08.29.03.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 03:57:02 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next 3/3] tools: bpftool: do not link twice against libbpf.a in Makefile
Date:   Thu, 29 Aug 2019 11:56:45 +0100
Message-Id: <20190829105645.12285-4-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829105645.12285-1-quentin.monnet@netronome.com>
References: <20190829105645.12285-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpftool's Makefile, $(LIBS) includes $(LIBBPF), therefore the library
is used twice in the linking command. No need to have $(LIBBPF) (from
$^) on that command, let's do with "$(OBJS) $(LIBS)" (but move $(LIBBPF)
_before_ the -l flags in $(LIBS)).

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/bpf/bpftool/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 3fc82ff9b52c..22b5a8f2c53d 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -55,7 +55,7 @@ ifneq ($(EXTRA_LDFLAGS),)
 LDFLAGS += $(EXTRA_LDFLAGS)
 endif
 
-LIBS = -lelf -lz $(LIBBPF)
+LIBS = $(LIBBPF) -lelf -lz
 
 INSTALL ?= install
 RM ?= rm -f
@@ -117,7 +117,7 @@ $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 $(OUTPUT)feature.o: | zdep
 
 $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
 
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
-- 
2.17.1

