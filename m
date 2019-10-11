Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 899EBD35E2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfJKA2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:28:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33578 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfJKA2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id a22so8065865ljd.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LjUmR6syFZQTjTX+EMH7Sbgc4CwkKZT5NTkS4TQtAUc=;
        b=mnI2QbGCo1NRiFTjyOBIqf6KabxlSsnPI4hdGenxjeIyJTkSXKVt+0hJS0M5neXKLA
         QBHDyXER/DRHnVa4ubnHrlLClZtvLAtNYFdgQF3rb4NcU4bmKJ0Lz2Ufxthc/b0bJ1+Z
         kW4AWWBQ2OqryumuH+jEK+ydtLRpiEzBtnHnm7tZaq6+hU/ItTonq/Y3xqyD177deZTS
         bDH08drSrEruU6qymWOgxylscRznlSk57CIdPAwhHWK3wTFu0VdkWrvR+s6lEse6B5Go
         1vh0iAFOmgwbO1zArtb6aL2WFaJ1aR6YdgCcd9ExuDq4DEQiXiJOktqlD/av3XyosuSO
         f42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LjUmR6syFZQTjTX+EMH7Sbgc4CwkKZT5NTkS4TQtAUc=;
        b=b5i4GoSgEBX9aGUauLjwLQpkbpI1kYaw5yBwBOVUH3Hjdr4UvudvaGqgZpSrZT4AN0
         5uZSZ+vBEEMFprxd7cDOEml4tzY2vCk4Aq4eA0p43NbnMd9Ivvxtw0QP2TjT87lWpAGw
         OCi48TfRNbhQTCYPETD8C+QEHvjzV3ABdOIyxPNiBhNqs41JirwYJAWKEa0C/RSCLOsP
         H1PHUZCtoQ+6WxBug4o2lvQAMioeq5Ut9qm/zWZ/mOS3i0T+1fBD5SX5TUxvkuj2SL4w
         qmc5R4nZo80dg+VZPZoTJALvqrdRacuPMQ8H/QdZF0eEZw44C0Zt8SPdy8jidxLzVmha
         D6dA==
X-Gm-Message-State: APjAAAXPqseCUqS2XlXEkzBw3myiyHb9jm7oHqSNiN1hu1+zqAk62spI
        I4F1L8MJ4q6ioCmmGFzQ7BjCqg==
X-Google-Smtp-Source: APXvYqw3xBuKAwJLBbXvSMeq+H2mubLdl9QJO6loIzPi+swWT6qeo8+IJ6UrP2bxsA8AXu9fvQT6DA==
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr7896959ljj.160.1570753718464;
        Thu, 10 Oct 2019 17:28:38 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:37 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 13/15] samples/bpf: provide C/LDFLAGS to libbpf
Date:   Fri, 11 Oct 2019 03:28:06 +0300
Message-Id: <20191011002808.28206-14-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to build lib using C/LD flags of target arch, provide them
to libbpf make.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a6c33496e8ca..6b161326ac67 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -248,7 +248,8 @@ clean:
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like
-	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(BPF_SAMPLES_PATH)/../../ O=
+	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
+		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
-- 
2.17.1

