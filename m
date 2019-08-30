Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51C5A2BBF
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfH3Au6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:50:58 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45481 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfH3Au4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id l1so4768004lji.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mY025N9ZTLshq6bUASscJHYyFWN73WCKPGSueHP30TA=;
        b=Okdsp5ZxNf0c0ZS1PgudZ1/Uzcx1vh+JyUHLIBaB4gA9eHqIu0am2+/xAGRamBrEmK
         qCvznYgVkMcSDDWdiuCGk34vVj8/mP+ro1bCTjA8Ka3xrOrkCNjL5U6xgrBRNELJmuje
         tp5PnYpAOK9+P7pd2AMtrpQ2VFUiwZgdf+VjTUiXBMwwiLm0B+wHxS9J4hkKQKTR1PMo
         g5JzQdW9lrRdG4QItLYA3aqHsMKgs2n4aIc4BsxCiDVNYjJ1gBnQXG5diF7z2I2DKLba
         2UWvt484BgUsrYmmG+TmQ/bM0gM9QCmze3gdMrsQwFGwno6fmli/VeP2qEfoN4+I/6o0
         LHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mY025N9ZTLshq6bUASscJHYyFWN73WCKPGSueHP30TA=;
        b=izKk1Y2g+9FXgdEBDWCzOCTv7PaKeRVRO3NobcFJCviW4mZKP7hJo+MIXOdiy40/7c
         ya/ThARz8k7X7O5weWNTji9zau/xQdhJAHKvTuGUFl5HJpt5fnfsJCkY6yCiw8nMpNRm
         EgcFtWd8jnP913HoeL4W/UW7nUAIPdA0BT9h0IPTiVst7x9ZS2EAj82cqySLdmlZmrdg
         38vJkBIq2RaCZO6QD5TU0WY7BDOoGeEkwKZ+DwWLq+iUr2WymNUT8s7OgxGM0i5+o7T6
         yRhHrp34rx9VYLiEKEAjareTYeMQjDLhtI2Cns97jkNAbbGzrs2vI/agD4we92VrxTxH
         uMag==
X-Gm-Message-State: APjAAAUbn8qPxM/GTxmR2NzLl0E3yXxP+u0WITHDwqD3WqmNptZuxnoG
        y+SPw95XJW8V7lCL/OTG6JHmTQ==
X-Google-Smtp-Source: APXvYqwqImk+P6XTagmx3q1aVV2TwK0n5J/VZAS+IZlC8HW1HTeVnR0gZP11ETCdNHIKYsMWLXe3bA==
X-Received: by 2002:a2e:2bda:: with SMTP id r87mr1097319ljr.3.1567126254430;
        Thu, 29 Aug 2019 17:50:54 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:53 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 10/10] arm: include: asm: unified: mask .syntax unified for clang
Date:   Fri, 30 Aug 2019 03:50:37 +0300
Message-Id: <20190830005037.24004-11-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
References: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The samples/bpf reuses linux headers, with clang -emit-llvm,
so this w/a is only for samples/bpf (samples/bpf/Makefile CLANG-bpf).

It allows to build samples/bpf for arm on target board.
In another way clang -emit-llvm generates errors like:

<inline asm>:1:1: error: unknown directive
.syntax unified

I have verified it on clang 5, 6 ,7, 8, 9, 10
as on native platform as for cross-compiling. This decision is
arguable, but it doesn't have impact on samples/bpf so it's easier
just ignore it for clang, at least for now...

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 arch/arm/include/asm/unified.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index 1e2c3eb04353..3cf8757b9a14 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -11,7 +11,11 @@
 #if defined(__ASSEMBLY__)
 	.syntax unified
 #else
-__asm__(".syntax unified");
+
+#ifndef __clang__
+	__asm__(".syntax unified");
+#endif
+
 #endif
 
 #ifdef CONFIG_CPU_V7M
-- 
2.17.1

