Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADAFB38E5
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfIPK4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:56:08 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44787 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbfIPKyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:54:43 -0400
Received: by mail-lf1-f67.google.com with SMTP id q11so12130558lfc.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6kzj0QUIRS1sDUroHtM76x4Sw0PaH661mS2z6H9lrYY=;
        b=LYey3wmgdmHy2NTiQkVRdiP/+xWiXr7/VhQu0JvCqcUIAToMMaoYBOM6JFuBqaxkZ1
         JfYQeW6MTnVu/A2LKmVE2hLug+wszlySKPK3lLmm5cC6B8YCZTCUrLGdZnxzx1ACnH70
         UB4kW6+0PoqV7L3+af21M7FxoqOZMXAUDxZSKtf5Wwlpf/fPZeNLIS3PaJbluIKMIsao
         zeKD032jBuH34HlHMsQ2ZAaBWHjzEdEuE2cwW2q876Uoe+JjqzWdVvHCsWaR/4ByQm/a
         uhSDh/DlVgXPaV80sBavReU3gg/Ek+7zUMmJllxUFjANBPZRlVHU2OI0ORj/g+vLAgMn
         Ac7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6kzj0QUIRS1sDUroHtM76x4Sw0PaH661mS2z6H9lrYY=;
        b=jsZYvj698GOUAfyOIPCw2iWo07w6UF7X1WsS+R4ISPK3NBXgvp0+HFxCbzF79rIyQ5
         FEW+OrRb4bTivrGsarw1jFMQOhVPPU5xWenNSBsD3aZbMlSFoX/m7dz6USMlKtJELQUV
         kNrQwZwsCwtmPDKC4/U4GHtTObNHKJXT1WNTopgNuoUAgSOQVZ2HurUcw9TQ+zuirtUO
         /6xZrcvIefH6gWv2XAtQyulElqM/JqX2ssrAxPT3SeW+Y86eGacDJZGxz6AftfQXRe96
         1/+4wnKcSyE5v0kk4ZC5puLEtzNiOT2TGnvaPHK02UUlCIEri53pbMy8DOqsDDsLZOng
         /I9A==
X-Gm-Message-State: APjAAAWtBxy2uIaHN686Hbu5QKpZdNnn1jc1JNiqLfCBtxuxQ7OIFpza
        CxDjo9yVeWGLu9dTQ9zX3MVe1Q==
X-Google-Smtp-Source: APXvYqyJD8dqwWln86DwqzCKKtbka3vRqFxZgcxtBQ23F33WqEha0eXVuyLZUBHVuwzHF7MjlDRyUQ==
X-Received: by 2002:ac2:4ad9:: with SMTP id m25mr11489559lfp.89.1568631281688;
        Mon, 16 Sep 2019 03:54:41 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:41 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 01/14] samples: bpf: makefile: fix HDR_PROBE "echo"
Date:   Mon, 16 Sep 2019 13:54:20 +0300
Message-Id: <20190916105433.11404-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

echo should be replaced with echo -e to handle '\n' correctly, but
instead, replace it with printf as some systems can't handle echo -e.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1d9be26b4edd..f50ca852c2a8 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -201,7 +201,7 @@ endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
 ifneq ($(src),)
-HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
+HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
 	$(HOSTCC) $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
 	echo okay)
 
-- 
2.17.1

