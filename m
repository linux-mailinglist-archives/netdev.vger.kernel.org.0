Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C904E1200BD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLPJOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:18 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45006 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfLPJOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:16 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so3308277pgl.11;
        Mon, 16 Dec 2019 01:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JJx1gb7dyIux/wvtlAjUM4Ul67VDqBxG4kjHz1T/apg=;
        b=AEIfRIfuKJKYD+qvWQaSBXL7IDzElcWqewDLhnppNot8arXsdKKANjssizbJgnCmKV
         SDIbaGEkWHjZoNKopu6kC3hbpLdvJngOZY92hPXZGZTMuJhbwyr7DOFHpkYU/Bly6t0J
         MgJeIFQ1I4RJl9criTK7V/4yXUSG7Hu01jTMp0JstURGvI+v2tpJYQ902utvaQEEZReq
         umZ+iVILzopn2A5DzvLjf11+vEJvzZPxY3t1i6Ev1oLJzj44HXNhysK65vc3HI1SZSS/
         FZ6dh97VkM4iHm7mY34w1mQ0eOZzNFY+RbahdFWiY5ogJJeLCpxuc16JwcM8CNzn3EAM
         uG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JJx1gb7dyIux/wvtlAjUM4Ul67VDqBxG4kjHz1T/apg=;
        b=oRb/T7Guhf9C+pNax6Ykpp4PRsHq/p1VSUQNshj9CuC+qoXR2/z+hQnYnPbDOFgjx4
         v0HDlBDEnl/gkc5IVGjVwegwZOgwgTdugBRj7vTkoh/LZtUd/R3TymaYIGB+40UI4XgE
         ZJrldqxVQCKDZvIC3enVmC+YuSZN16SGvAq6rl/oS7IvvPU9EOTX2lgmlTKrR9RcMGK5
         JjIRENyyUDbk6AYkZLiNg2a8aBCEIh0DI6ONp4jf8/kqs2uatMlmXRaLxADzaQEWhABo
         yP1pXD+gfy1OCdVALyzroP75Zv46jZtmpNhc7JLBUSqqmCTZMgHumpZDnXdAyk9d9bza
         FezA==
X-Gm-Message-State: APjAAAVbi3vzeCPrX4j1TaEnABU3l01aMjeIctpdM2ab9m1nGY46npQJ
        48tFWaW6tJkHGVTnie82xesNRVzS86I=
X-Google-Smtp-Source: APXvYqxFeC9Wz/Ld4lIscKeMf0jMlKJu/7MJXqqy6/vQF89UWfwcx6tFmnqaY4nKmOGM+XOBrCNyHw==
X-Received: by 2002:a62:7b54:: with SMTP id w81mr14816500pfc.127.1576487655949;
        Mon, 16 Dec 2019 01:14:15 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:15 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 9/9] riscv, perf: add arch specific perf_arch_bpf_user_pt_regs
Date:   Mon, 16 Dec 2019 10:13:43 +0100
Message-Id: <20191216091343.23260-10-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216091343.23260-1-bjorn.topel@gmail.com>
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RISC-V was missing a proper perf_arch_bpf_user_pt_regs macro for
CONFIG_PERF_EVENT builds.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/include/asm/perf_event.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
index aefbfaa6a781..0234048b12bc 100644
--- a/arch/riscv/include/asm/perf_event.h
+++ b/arch/riscv/include/asm/perf_event.h
@@ -82,4 +82,8 @@ struct riscv_pmu {
 	int		irq;
 };
 
+#ifdef CONFIG_PERF_EVENTS
+#define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
+#endif
+
 #endif /* _ASM_RISCV_PERF_EVENT_H */
-- 
2.20.1

