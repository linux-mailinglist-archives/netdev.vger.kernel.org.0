Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F09AE875
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393854AbfIJKim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:38:42 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42842 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393840AbfIJKil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:38:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id y23so15872975lje.9
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NGKQzll/A9IaEu36OmTkFVayy8Bwv+m3n0iuRSm1M6Y=;
        b=ABzAt76oNXU0+8r79M+Uq/vNmBPlKtTMxdiCXMEvHZE5RCKq3QqV2iBKiCEqCQMDfD
         5MRDIcIUmhICZ3oxwsncRXUExmaAd9uO3zO0pf2FzyrZMXEgHWGUsMrthX1YCuT8uNr8
         Fy0s+pdJsRFxY31Gq1uTHRY9vyjkZ4Lx/gplROpBnTB/nyNhoWEI9RhKa13TJTdcaqC9
         qsDUhmIGRXpmc/qhpPCYEP73F4LEXLy/8Q1Cw3S1pNBR2BYa3qjcBMPKNVQUbuY7MZyb
         DEINpV16u8PrEGM44UFFxvEoPR+mFi0diwU1Esg8Xd3hntXMUtO/QSHNxqgy9MXXYTPm
         aZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NGKQzll/A9IaEu36OmTkFVayy8Bwv+m3n0iuRSm1M6Y=;
        b=ohqMBoBMiXMHqgKg71ZXz6s8WWDWQyl3oAw7hMb3iWQj4j6W2LhSE9Z8VObZBPU2Io
         bk3szMgm+oJMSXnAiTdFtG/9SGvVlXCoPtIamqudffzAwCofrmnaG0ai8TqdDHdPH7W3
         DG3ijzFa3nmOAxM0rpN3QUSgtyhnDbbKYN2ZD38kImGlInInTVGM0zAQx6CjyzLrthNe
         G/sVNkcgiyoN2AjriUHjppx1DLJLyguCtjoOvXWSCvFkvGdrPDhB9gb36g/RszwOfqrE
         ID7/gKNYZnxy9qS8KymvofiW/1C9RJKM4adONZXRhdBa0ofDplFGxeCxJM17md+r5L3u
         MZgg==
X-Gm-Message-State: APjAAAXd+1EvSxsFUZaxa1vJWO7IUGuIAv+TD0OHQPK7f5baRrV7cbzD
        y8Rlmpb3QCTnKCQyp9yumkxYlg==
X-Google-Smtp-Source: APXvYqz0/JLIcR6H+rHFrDDr038ZGekYrfvl6BKTgPvWXfLvjHyS9lrOyEn6zwfVLEO1KhHL+BKEHQ==
X-Received: by 2002:a2e:5456:: with SMTP id y22mr19750906ljd.60.1568111918957;
        Tue, 10 Sep 2019 03:38:38 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id g5sm4005563lfh.2.2019.09.10.03.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 03:38:38 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 01/11] samples: bpf: makefile: fix HDR_PROBE "echo"
Date:   Tue, 10 Sep 2019 13:38:20 +0300
Message-Id: <20190910103830.20794-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

echo should be replaced on echo -e to handle \n correctly, but instead,
replace it on printf as some systems can't handle echo -e.

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

