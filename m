Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD6F4CE5D5
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiCEQLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiCEQLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:11:42 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE42882D33;
        Sat,  5 Mar 2022 08:10:51 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 27so9989235pgk.10;
        Sat, 05 Mar 2022 08:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wtx7c+X3yjESu1Dpjr/CsyO3k3jbgKrBuP5zPYT0FSk=;
        b=f6uGNOfIbH+TrImkxSbJDauNwa/CF+cQEvDDrhDCzcK1UtqlwlMeid4oWjjChXUfnE
         LCK+PM3T/qkMAPWLd90YEfegnyrEqXs2e18LWtJ2wyVy4LvP5Dr6P+TZg9lrFwUhb11e
         /S+siIpFU+ga9TpwCi8iSfLX5drHS9UMHB1JT/C5FEhk6X47cvEp8E187thPgH96K5q8
         KQrYB1TGKKGluMvwKmFDDG/99yUgmMbFi6v7kCWllcVB5oknRWlvMOEqwO0s+SXsFDeH
         vCj1H8LENDQ+pzxe6jifoW2r4MIV61yhgM0s7nB/AkWpaJeYk/hcekEitHjBo5XtEKEq
         ifqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wtx7c+X3yjESu1Dpjr/CsyO3k3jbgKrBuP5zPYT0FSk=;
        b=ev+N1/QZFPfjsPeZqMZXuKnk+AyL1Wx9UeF5FATM683YPLeLyrqQiylzEwVNt5EF6I
         dHl8fW6uNNbDausNDiL42UUgSjQTReBjYUMHGwyx6sNuQTCsWesUXJNWcg2SAfSjRFOG
         9L7EfGMEHJi5BWGz5Yl899QX2mWXEHVRzSVQoERQolicmEMzUPAvS83kXReYV+LxDiXg
         rGmfh5Mni88IRx3x3BN4ecNPOMxTnevKh6rBv6G/4hJWi1XSApM179BgtNwok9IAl0Hh
         /ZMgrTn0EYMFvhPHo3CSgdGrZGDdNYOTXv/BCUDZbRgVJz2S6GgkUJlY/OLGNmLtypMj
         9oDw==
X-Gm-Message-State: AOAM530N7KYHxc4gtUJsGeh3MdmRa/LeqTVGgd5nYjMbl3QqAt/bYZ7D
        nW4r09KIRtGVymXaTReXjRQM9KW2ud3oiRjL
X-Google-Smtp-Source: ABdhPJxrEAGDhuCwqZ+Chfx7wXPBFe8HnPTj3i4MDB8GsFpwKTihqD7Lt/y8bKHDxTy7JUBNNO/wQw==
X-Received: by 2002:a63:4c50:0:b0:373:2a90:dc04 with SMTP id m16-20020a634c50000000b003732a90dc04mr3210931pgl.350.1646496651181;
        Sat, 05 Mar 2022 08:10:51 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id 124-20020a620582000000b004dee0e77128sm9460805pff.166.2022.03.05.08.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:10:50 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Remove redundant slash
Date:   Sun,  6 Mar 2022 00:10:13 +0800
Message-Id: <20220305161013.361646-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trailing slash of LIBBPF_SRCS is redundant, remove it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/preload/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 167534e3b0b4..7b62b3e2bf6d 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
+LIBBPF_SRCS = $(srctree)/tools/lib/bpf
 LIBBPF_INCLUDE = $(LIBBPF_SRCS)/..
 
 obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o
-- 
2.35.1

