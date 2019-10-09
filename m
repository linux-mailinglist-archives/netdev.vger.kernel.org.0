Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741F1D19C3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbfJIUlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:41:47 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42215 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731977AbfJIUlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so3848357lje.9
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j9oehlPvbpQ/3mUr7ILsjkWG9P4RuU3Cq2akh+BGeG4=;
        b=u9WblPuD1rsm0jyX6rOP8LRDXId4vkuFAucoTNQKldbU28hMIlJ4Ye49sY+S9r4GVw
         FZlnYg+q4HiKAE96sVNakxmBf34Y9mWy3RWPbEpycFz6xT78/mZDLFsz7FEXaIXy1EXt
         XrgaMdZhH+hP/js5F/dJ3Em5ta0eRVre0FAswR5FWcDfAnxpFAk1mWdRFBtU+/IJF0Ty
         TBQ4ItMejqowBuKLezbZXsMP0uNYRa5YzBKTB7STXrYiiISY8jmZs0OxMlAXJTxMw2Uo
         ah+j28+8X6x/K5OMYVKofwMOJqb+8KuBfI6BQFyAyyrKkwdciKWqLYwXUnPM8odBEyds
         lLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j9oehlPvbpQ/3mUr7ILsjkWG9P4RuU3Cq2akh+BGeG4=;
        b=KJLPSaxySGvJMxz3BzDNKCGWLgOx1I5tTsHqR28KFB3tIQrRyuNy7M/5toqxQdgz/x
         ZPJ9yPwJD0vvGyO/jiInVPpkt1dpSMMkerT/h3E8Fi/GY3M0tKtmdD/46drcKAmc4O+4
         BjkB/faVpVOjGeZsFSsQS8vzS9mcRiVVk2OfXjQOVRC88GYxFi3iIDIhHehfQ0ggwchE
         AUjHzlv7a8A5cGz8308BSruu7E5CtT0JSF2mnP892P5vHfAfP58+lsSUwrwZEr/YakTa
         XdiFs+k03MD9oML5jqRakzgLT5rQmm8lRjkGATVzl6jObvwAbryJ3Rz4fDl5B0btCb+2
         b2iA==
X-Gm-Message-State: APjAAAXCzd58dQrASgPDBExHEP0bzm59LUr7pjoT1Ifs9CTUujNub+nu
        SYSwUlZ7Tgh5BbcHb2UzsdyoIiPsc98=
X-Google-Smtp-Source: APXvYqymIdgfyxgRoHuT7kBxL0jS3aNb/nX8NZ5SezJ6vkjCDt5qlasTpcF9WFmXN/+gsv58UvFtuw==
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr3696925lji.142.1570653705253;
        Wed, 09 Oct 2019 13:41:45 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:44 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 04/15] samples/bpf: use own EXTRA_CFLAGS for clang commands
Date:   Wed,  9 Oct 2019 23:41:23 +0300
Message-Id: <20191009204134.26960-5-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It can overlap with CFLAGS used for libraries built with gcc if
not now then in next patches. Correct it here for simplicity.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 9c8c9872004d..cf882e43648a 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -218,10 +218,10 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
 			  /bin/rm -f ./llvm_btf_verify.o)
 
 ifneq ($(BTF_LLVM_PROBE),)
-	EXTRA_CFLAGS += -g
+	BPF_EXTRA_CFLAGS += -g
 else
 ifneq ($(and $(BTF_LLC_PROBE),$(BTF_PAHOLE_PROBE),$(BTF_OBJCOPY_PROBE)),)
-	EXTRA_CFLAGS += -g
+	BPF_EXTRA_CFLAGS += -g
 	LLC_FLAGS += -mattr=dwarfris
 	DWARF2BTF = y
 endif
@@ -280,8 +280,9 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 # useless for BPF samples.
 $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
-	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
-		-I$(srctree)/tools/testing/selftests/bpf/ -I$(srctree)/tools/lib/bpf/ \
+	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
+		-I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
+		-I$(srctree)/tools/lib/bpf/ \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
-- 
2.17.1

