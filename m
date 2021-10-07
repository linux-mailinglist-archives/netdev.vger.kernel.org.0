Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60679425559
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242067AbhJGO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhJGO0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 10:26:16 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49454C061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 07:24:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a25so8114280edx.8
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 07:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6vmYD6+ICi1neadqa+gL/UPoAFar0m9iXwg+MUKPe4=;
        b=Phjs2REo2zV9+Isw3WdoK0cSTIqwNWMR8nBvmVMu0YtFcChySx2wGQz4nnBuRiphTJ
         BQHgSu9TXJWSRvBTzYg+fzATpPAAcuCsHbT2jbnMV7y4lb1PgjwiOPP55XCwtvGvKowM
         tFhrvislNX0u2AQO5v7zNuS5cPKcyM5cgq7jj/quVwOobBnNYAxqKD6zj2YzcNbSSgp2
         QrwM75WQkVVEY6yO4/j2xG6mfN8SRoaq+vcyFweptAUpgM8wW8Zne7un0IC7Yko7pcWv
         06RfA/ZLK2Z1sNb//Wqb0HGmgHECRke0f7gXKEFhD75bfzGA6QqYlTHyekEV44nl8jbf
         MXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6vmYD6+ICi1neadqa+gL/UPoAFar0m9iXwg+MUKPe4=;
        b=bg0Zrmi5xcw82AaCK9XmHEh5WXJMRZGEqI30pET7UCP9G6kK/8vecKYxLblXHH0wtK
         3mNpjx51ck7cW5R0US9lS/80GqsHOZubWhes5Zx0eAEy+++Xx3ePUJoSXegG6qMbj+qV
         xFyKYGD5vF5PnhrDeCeta4spLKXSDOcBLeY+EcZeb1eIswWHlGr2WRt6gr0VA2sM6df6
         ARjfiRTmIRly6psNvZrhgUDILE7x2ciwzWuFDY08SzNguWSO01ARMoXVo3gt6zVIVVml
         AVuB5xAe4usXRUqq5+TkpMehRn1ixocr32ZWXhqFqCOJiqzeDatncANlpZhp5xCoUmyS
         qtaw==
X-Gm-Message-State: AOAM5322Int/DXYsGcX3ZMe0daQ/8g0dJpDZaXvzmQbAmxbVLsyuuIgz
        ocuLv5d6HSftYqnUkGAMH1dXYw==
X-Google-Smtp-Source: ABdhPJylKK8xTutG9pv1TVWtqFx5gnnwI2eu2jsgGkaHu/K5+ooHIropO6OIH+FIxYqLMEHJP0/xcA==
X-Received: by 2002:a50:cf02:: with SMTP id c2mr6744434edk.325.1633616653200;
        Thu, 07 Oct 2021 07:24:13 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bx11sm10526987ejb.107.2021.10.07.07.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 07:24:12 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next] mips, bpf: Fix Makefile that referenced a removed file
Date:   Thu,  7 Oct 2021 16:23:39 +0200
Message-Id: <20211007142339.633899-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes a stale Makefile reference to the cBPF JIT that was
removed.

Fixes: 06b339fe5450 ("mips, bpf: Remove old BPF JIT implementations")
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/mips/net/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/net/Makefile b/arch/mips/net/Makefile
index 602bf242b13f..95e826781dbc 100644
--- a/arch/mips/net/Makefile
+++ b/arch/mips/net/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # MIPS networking code
 
-obj-$(CONFIG_MIPS_CBPF_JIT) += bpf_jit.o bpf_jit_asm.o
 obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp.o
 
 ifeq ($(CONFIG_32BIT),y)
-- 
2.30.2

