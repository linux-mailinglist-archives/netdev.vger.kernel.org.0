Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C3143E5D2
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJ1QNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:13:39 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:36354 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1QNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:13:37 -0400
Received: by mail-lf1-f41.google.com with SMTP id j2so14690577lfg.3;
        Thu, 28 Oct 2021 09:11:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DH8yGhC3Nvprfn3hCny0Vjdm/oIXFS546cCDILMHRkQ=;
        b=s3f6tlOOhRkJHdZOP2zz3Yc7j0AxUFThrrIohu6RpDUFAvOOtx+G52mjODRVE8inhx
         GcMA5SMJyAVCs6x0XnE/Jzs21KAq5RbXg8nCVi9yf2ngecIm2WSg/xNSI9XYDZ1JYxXI
         Nuym60QOKmeS7cmwteE6/7vBuojVLh23UDf7iKNV8XrDzTwljzPR59N91KC4Ce/aB9Yv
         lQkw+K+JR2H1TfYD2QraNL7Mx+E5rQDEVM0K/JvG4tG+BfwNFrFHj7BKkww/dpJnFQUi
         32JUw1LPnt+NlgTyremnAw1GFKh/ohVbt3BKyzlcmuJaSTblin7Dr28F9Ki451+qoFZw
         nM/Q==
X-Gm-Message-State: AOAM531wZ9uKIBiklVo7tT2e0OKKhzrMJSBYr3Vc0EzjAP1sx9eZ2kQA
        yCEKwMPTSHvgOZ7VysYsI1s=
X-Google-Smtp-Source: ABdhPJzGcFsQsLLh2iM+XXTTQAAvk5Ijtz1Ynp38QBMLPr3KG5zxCbxkrQLRhXQ1kOc3f2/PH3tnWQ==
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr5589603lfu.490.1635437469642;
        Thu, 28 Oct 2021 09:11:09 -0700 (PDT)
Received: from kladdkakan.. ([193.138.218.162])
        by smtp.gmail.com with ESMTPSA id o17sm49680lfo.176.2021.10.28.09.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:11:08 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v2 3/4] riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
Date:   Thu, 28 Oct 2021 18:10:56 +0200
Message-Id: <20211028161057.520552-4-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028161057.520552-1-bjorn@kernel.org>
References: <20211028161057.520552-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros for 64-bit RISC-V PT_REGS to bpf_tracing.h.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index d6bfbe009296..db05a5937105 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -24,6 +24,9 @@
 #elif defined(__TARGET_ARCH_sparc)
 	#define bpf_target_sparc
 	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_riscv)
+	#define bpf_target_riscv
+	#define bpf_target_defined
 #else
 
 /* Fall back to what the compiler says */
@@ -48,6 +51,9 @@
 #elif defined(__sparc__)
 	#define bpf_target_sparc
 	#define bpf_target_defined
+#elif defined(__riscv) && __riscv_xlen == 64
+	#define bpf_target_riscv
+	#define bpf_target_defined
 #endif /* no compiler target */
 
 #endif
@@ -288,6 +294,32 @@ struct pt_regs;
 #define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), pc)
 #endif
 
+#elif defined(bpf_target_riscv)
+
+struct pt_regs;
+#define PT_REGS_RV const volatile struct user_regs_struct
+#define PT_REGS_PARM1(x) (((PT_REGS_RV *)(x))->a0)
+#define PT_REGS_PARM2(x) (((PT_REGS_RV *)(x))->a1)
+#define PT_REGS_PARM3(x) (((PT_REGS_RV *)(x))->a2)
+#define PT_REGS_PARM4(x) (((PT_REGS_RV *)(x))->a3)
+#define PT_REGS_PARM5(x) (((PT_REGS_RV *)(x))->a4)
+#define PT_REGS_RET(x) (((PT_REGS_RV *)(x))->ra)
+#define PT_REGS_FP(x) (((PT_REGS_RV *)(x))->s5)
+#define PT_REGS_RC(x) (((PT_REGS_RV *)(x))->a5)
+#define PT_REGS_SP(x) (((PT_REGS_RV *)(x))->sp)
+#define PT_REGS_IP(x) (((PT_REGS_RV *)(x))->epc)
+
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a0)
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a1)
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a2)
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a3)
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a4)
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), ra)
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), fp)
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a5)
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), sp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), epc)
+
 #endif
 
 #if defined(bpf_target_powerpc)
-- 
2.32.0

