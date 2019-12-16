Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA9B1202BF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 11:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLPKif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 05:38:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42021 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727229AbfLPKif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 05:38:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576492713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gf1efliaRWnpvAVh5vnGXcL2YmyXEHBK2in0V8Lblq4=;
        b=R6ttrI9P91VSTxTR2W423+eTR6qdQipV+cYrBO0WFcdyQhHOT64NkKfuQxQvMR4JHlD6rF
        lOmBaZNj6UXU3KqVtaDpty3cv8+jPaMYzZDJhcGUzyjC2mx7I1pO3l2ZlT72fZCwjUqn34
        tZtQF4kUrXvr5WfuaoGepwl1J8BjKmI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198--_EpuaBcOGCWwZ1kC0ZPVQ-1; Mon, 16 Dec 2019 05:38:32 -0500
X-MC-Unique: -_EpuaBcOGCWwZ1kC0ZPVQ-1
Received: by mail-lf1-f71.google.com with SMTP id c16so168633lfm.10
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 02:38:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gf1efliaRWnpvAVh5vnGXcL2YmyXEHBK2in0V8Lblq4=;
        b=eMUBsnPqyxh20xVOCCDiGRPMi2RtrBMsL67Mhjct9J5KMacFjN3TDp0teiA/jnzVAm
         yqNZuOELkvWyXlk04EaC2OZ2+lJwa1R2HacKJdWa8YcM9X2wQy2qvIwgwaCUf/zpDcII
         g/XrILd0ASA47BS2F3kB+jVS/yT2Fs91peLzqVaMP0yQm2H1Xu79FPAzj0jlAAS8vHdO
         RAeM2hJtuDtlq3HNnEEVXl8+4qVt6J/acNhWNKvA16Z2iKjaAtxHAWrLuTB7PGkKVhWp
         jUWnSotNrHR2ESn/G5ngcEl0aoKGQ0G8TUVFJkJXyxtUypeAexMrCE8C0sUanXvL3TNx
         uzag==
X-Gm-Message-State: APjAAAVJ3Noru/Bbq0sRwifzbM6lo8vymPypgk30givSnHpS/bCuyXaA
        Wi1OBnG7Yz8GPNG4eEGtSeFTXrejUkJ9TogKZ8Ab6qyAiKg1/GCZ11IQNPVSYns1a5LaXhM+HAJ
        fZF5ODBJq1KFLbOlJ
X-Received: by 2002:a19:86d7:: with SMTP id i206mr15713306lfd.119.1576492710572;
        Mon, 16 Dec 2019 02:38:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAC7blaaEIQuV426pWfsiM9hQDs8+KIaFApneIvLvnQjwG0S82ZHs7D2IVOlgI6seAYwiZEA==
X-Received: by 2002:a19:86d7:: with SMTP id i206mr15713293lfd.119.1576492710403;
        Mon, 16 Dec 2019 02:38:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y29sm10246562ljd.88.2019.12.16.02.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 02:38:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A55371819EB; Mon, 16 Dec 2019 11:38:28 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples/bpf: Set -fno-stack-protector when building BPF programs
Date:   Mon, 16 Dec 2019 11:38:19 +0100
Message-Id: <20191216103819.359535-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems Clang can in some cases turn on stack protection by default, which
doesn't work with BPF. This was reported once before[0], but it seems the
flag to explicitly turn off the stack protector wasn't added to the
Makefile, so do that now.

The symptom of this is compile errors like the following:

error: <unknown>:0:0: in function bpf_prog1 i32 (%struct.__sk_buff*): A call to built-in function '__stack_chk_fail' is not supported.

[0] https://www.spinics.net/lists/netdev/msg556400.html

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index b00651608765..f51804ef12c3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -234,6 +234,7 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
 			  readelf -S ./llvm_btf_verify.o | grep BTF; \
 			  /bin/rm -f ./llvm_btf_verify.o)
 
+BPF_EXTRA_CFLAGS += -fno-stack-protector
 ifneq ($(BTF_LLVM_PROBE),)
 	BPF_EXTRA_CFLAGS += -g
 else
-- 
2.24.0

