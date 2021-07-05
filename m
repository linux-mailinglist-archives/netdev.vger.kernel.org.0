Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1433BBB58
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhGEKlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhGEKlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 06:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625481550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nGQUOo7dih5SsR/eYJTAqFGEk1u85z/Uj7xxDty7zgs=;
        b=dOSqwtsdHPlXNGPCSTe8Gfj0AabwDIc/n7wbMIpGvAZ1bpQASVlg5t5GdLNHJJvZxw4bba
        UsSFmHm2Cz1hesSeGE9dXBAFxBG0HLrtoJwlWppGl6NLDWMUBcE1T6WAyETm1NHIKWdooQ
        7OzgT4DQRzGme2wG/TseuneT2h0yFpY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-3UnKnGotNe-ksnpvQRr24g-1; Mon, 05 Jul 2021 06:39:06 -0400
X-MC-Unique: 3UnKnGotNe-ksnpvQRr24g-1
Received: by mail-ej1-f72.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso5052706ejt.20
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 03:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nGQUOo7dih5SsR/eYJTAqFGEk1u85z/Uj7xxDty7zgs=;
        b=VK3L7XhyWW3CQpK5EwEIe4A4bJexkbRL6/mC+EigSXeIU3sPvxrExjCgw4Eb7yz+wX
         oMr1BgYlHtVwDG0uULg7gM/+dPMh/caccI1+cPrYeDxm5BrwyqZ0RluDlvYxNJ2gDf+w
         2Mu0gMQLZ6F62cdEamlny3rlh9CRj8eq628u+IPVhFS50YORwzo2pUFhnq84sp9Yv6EV
         xxjPDv2CLEzaM9mLE22YTWjXdr0oQ7S7zHiGGdKwGAZ/4PZErK81XK+D5M3Ol2SNaaSE
         FM4t4HMlSLIiBAUULBHFke2s28L4t8gMBNOC2u+eIdr4IV509ldwug/Q3RxA8fvu/6CE
         B93Q==
X-Gm-Message-State: AOAM530slJGEehxPb2lNGLASwlF1TIMUEeXDzjwILnlF/B+O05n7TtYD
        bd+7Xa5etNXNRXEBYILFMlqoBNi4cFFuXUxhpZX4lIVDLuntEJSTKRJJZLtBvYdYFajgyoFSWmY
        faRaE9HRdJ0HY55+J
X-Received: by 2002:a50:ff0a:: with SMTP id a10mr15534602edu.273.1625481545588;
        Mon, 05 Jul 2021 03:39:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7AdVa/ufIWFAME312qFMf9TF3XV/MioLYjFkYwJs7x9qatrRfikQLgmYhM9YTs1FWMmfkxg==
X-Received: by 2002:a50:ff0a:: with SMTP id a10mr15534579edu.273.1625481545241;
        Mon, 05 Jul 2021 03:39:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x16sm1622024ejj.74.2021.07.05.03.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 03:39:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1650918072E; Mon,  5 Jul 2021 12:39:04 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next] samples/bpf: add -fno-asynchronous-unwind-tables to BPF Clang invocation
Date:   Mon,  5 Jul 2021 12:38:41 +0200
Message-Id: <20210705103841.180260-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The samples/bpf Makefile currently compiles BPF files in a way that will
produce an .eh_frame section, which will in turn confuse libbpf and produce
errors when loading BPF programs, like:

libbpf: elf: skipping unrecognized data section(32) .eh_frame
libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .eh_frame

Fix this by instruction Clang not to produce this section, as it's useless
for BPF anyway.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 520434ea966f..036998d11ded 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -331,6 +331,7 @@ $(obj)/%.o: $(src)/%.c
 		-Wno-gnu-variable-sized-type-not-at-end \
 		-Wno-address-of-packed-member -Wno-tautological-compare \
 		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
+		-fno-asynchronous-unwind-tables \
 		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
 		-O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
 		$(OPT) -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
-- 
2.32.0

