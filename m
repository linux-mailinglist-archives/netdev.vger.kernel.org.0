Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDAB3947A7
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhE1UCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhE1UCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C553C061574;
        Fri, 28 May 2021 13:00:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l70so3360094pga.1;
        Fri, 28 May 2021 13:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nGlypxOO+I1T40Cpmd9aYpx3V+NTRClR+bxP+K/W9Io=;
        b=Eg2JefObN9WovxGVIUL2oEnOCrdUWhB8oasqZ1MVqjoK1KEuFfZbez/gPUTF80rgoj
         oeAu8iFg4lxLTnzZqQh+/j+zJBcXx5jUsSHE4J6luZMNVU6Gx3Oufx8cg91TVNnEfqO/
         rEV93A/t3T73hCi3pWQxa07fpTchYjNpsATsX9IISMjRLN02xUwBlJM4aN/NVPKo4jv2
         BHF72ExTDnay1ZEJz21McucApDaRCstVZjzM/LRklAJHzsZeFwp2uHoTLCeIPocpa+fm
         mM7xRIHMCTAJPgqL+bwj12xV/t64batQxExq4fo/BdS2ncg1aFZIULSI9raWJ2hLgJnS
         U4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nGlypxOO+I1T40Cpmd9aYpx3V+NTRClR+bxP+K/W9Io=;
        b=jNY6EyKQfu+kfR9/mz58LGiPSv76XhdGbfj6vfgTSqDD7K7HZjTwY+iyZxascc30fd
         zmqqEwo3X/G0R3LaDlW4FS5Q0KsR+6hSdcgNT03uQ5GmbKBSdIuoKN2AmufTU7y55n3x
         F56+BcMMdwptmkHC9CTRuSIwUgB1953l6j8G7W9F0y3R2vPIRRb6ZA4XmCY1k4MGU2W1
         ArqJ1q5RpUxtm/tYGNf99wZXW3IVVRLcjWIlseoR/grA6MJ7ynKm6co5zRj/EuqlXNeF
         3yEnTJoE3kFvzKA/4/6CLW2F4bRVi2fKu8tGSm3uZrApQm7bTnDYHCx8CPl7pPmOR+bm
         laPw==
X-Gm-Message-State: AOAM530GlNF2BbVBgjs3R6CYYOTpG6sEvouQx4m3Cr26MYNPGzlNHFAy
        FW7/XGMza/3PpAVxT6FAUKi3smO6MTU=
X-Google-Smtp-Source: ABdhPJzj2vCCkJaWr8yTKkQtKrEKmFs/5e4X59Oc3R8EB5YqEqSYltBbZR5AWK7vi7LVOC1mgE/Z4g==
X-Received: by 2002:a65:4042:: with SMTP id h2mr10559997pgp.380.1622232058730;
        Fri, 28 May 2021 13:00:58 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id a9sm5119518pfr.9.2021.05.28.13.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:00:58 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 5/7] tools: bpf.h: sync with kernel sources
Date:   Sat, 29 May 2021 01:29:44 +0530
Message-Id: <20210528195946.2375109-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to expose bpf_link based libbpf API to users.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2c1ba70abbf1..a3488463d145 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -994,6 +994,7 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_TC,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1007,6 +1008,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_ITER = 4,
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
+	BPF_LINK_TYPE_TC = 7,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1447,6 +1449,12 @@ union bpf_attr {
 				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 				__u32		iter_info_len;	/* iter_info length */
 			};
+			struct { /* used by BPF_TC */
+				__u32 parent;
+				__u32 handle;
+				__u32 gen_flags;
+				__u16 priority;
+			} tc;
 		};
 	} link_create;
 
@@ -5519,6 +5527,13 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct {
+			__u32 ifindex;
+			__u32 parent;
+			__u32 handle;
+			__u32 gen_flags;
+			__u16 priority;
+		} tc;
 	};
 } __attribute__((aligned(8)));
 
-- 
2.31.1

