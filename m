Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B78D3600
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfJKA31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:29:27 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42477 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbfJKA2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id c195so5709977lfg.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=03GhUEVVPKzA4TMKrHg2hN3Csg5CX1o2irsu+gSocso=;
        b=lgPdUOsdWvm3NrU+k0qDkNxtB02GwhSc5KwzTrCweHYaxGN3NwSL194iDLlMKbHnkv
         HQsLrmFRtK/MtY3s/t6lnF+dn79c9z+krOQUQchJEDuQ1x5wj40QtHKQGOOzwMr6pRkZ
         m5Vkk9C5vFXa/NWObQzlISQO4YdbJs44MBjE2Xjous5QWHXDZlr5DcIOTBFHkyeEGG61
         WF5Q7LTNZe3DrJVHzyS/VSxTW8rou+w2JR/RdhCDReKxj3Ac/8BRWjvZzNJle1gTsy0r
         gvhuogyNpORJ/IMHS8eJ+Y6UViz1GyjAt2gUp2tjQrsb1BfdiOFJaLYy7NLhBHyRChj0
         y2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=03GhUEVVPKzA4TMKrHg2hN3Csg5CX1o2irsu+gSocso=;
        b=k+w7Di3MUz7RrmWwyDxEzSf2EUiIJckE1+nFefEDeQP5i5OB/rAJYoBZrrcIah4cyo
         RZYMulr4sc5npBQCXgskyZWR3FMvT8qQXFT4kxzBeVXInC138hQyL7d0X7HOIV4tk53O
         V5SEepFygqRneNTQ4UFeZ0hKYYIjoCBK6TnZy5c5Kgi+JyDhLSPYmItBrfcJ9AWNciGf
         4T+iHbB5T7hyv6BGXGOKgKiINA3bUdyObjp0cO8gQj+03XUIZfl0qo0tZcJeXXFlx1nK
         Z48vjJxN8sg4bhePzSFMfE4rHFdzpqcgD0A6rBZYG886Ntvur8moPpyF4e41tim10lEr
         egQQ==
X-Gm-Message-State: APjAAAXTWWZ+nOMUgPdlWBwM/FjcKM6h2w6GhV4LsRyGicXJFEbLWz7D
        qGS1VQQxwovngn8jRMniwT7SyQ==
X-Google-Smtp-Source: APXvYqy0DvtjgGiKI7+n5Ix8WqhnukzK5KufDqlv4+eYNhjK3Y4l+UKA9J1K50qMit1NFTou4C7DEA==
X-Received: by 2002:ac2:43d9:: with SMTP id u25mr7678515lfl.142.1570753713044;
        Thu, 10 Oct 2019 17:28:33 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:32 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 09/15] samples/bpf: use own flags but not HOSTCFLAGS
Date:   Fri, 11 Oct 2019 03:28:02 +0300
Message-Id: <20191011002808.28206-10-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While compiling natively, the host's cflags and ldflags are equal to
ones used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it
should have own, used for target arch. While verification, for arm,
arm64 and x86_64 the following flags were used always:

-Wall -O2
-fomit-frame-pointer
-Wmissing-prototypes
-Wstrict-prototypes

So, add them as they were verified and used before adding
Makefile.target and lets omit "-fomit-frame-pointer" as were proposed
while review, as no sense in such optimization for samples.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 91bfb421c278..57a15ff938a6 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -176,8 +176,10 @@ BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
 TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
 endif
 
-TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
-TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
+TPROGS_CFLAGS += -Wall -O2
+TPROGS_CFLAGS += -Wmissing-prototypes
+TPROGS_CFLAGS += -Wstrict-prototypes
+
 TPROGS_CFLAGS += -I$(objtree)/usr/include
 TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
 TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
-- 
2.17.1

