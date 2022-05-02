Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F83351737A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382073AbiEBQEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386150AbiEBQEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:04:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A7FBCBA;
        Mon,  2 May 2022 09:00:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a1so17137924edt.3;
        Mon, 02 May 2022 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3AME3IcPE8G01jSuTBFGfb2u7+rTRdyuYIo50HVTEg=;
        b=BgtDFtCxqx/FN6/+BjsXXaKHaLn+ihBUfE5b+bIVc+wk821dSW3bFKNEVB7Q6ypQ5v
         D242HfeafW05VEfKAo9l+Ijc5DyyfjEsZOarGM/2zSvIJB9EruKM/plp38cwhHcgJ0WO
         k9SZWJE4wn6AuFK92SkXbDNi9OHtz4DKDcqmNzU8tSM94UgbJiGsn3nBFCvw/Sdu/DBS
         Snr1GOkFl5FtN8t04fe/O5sF6tUC/9+e2/2QX/LXzWuoP0rHnDAysSAydmaNv1wVFTOu
         WFwhuJUvHxBSlT0VgQRxRjE41n/xVjw1/LuuvYsnXON3Kh7iGQmvA2RtV6UbVM003aYX
         7EAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3AME3IcPE8G01jSuTBFGfb2u7+rTRdyuYIo50HVTEg=;
        b=4ult8OEWfth1odpgUsNNDZynmlQSqtqtQhykxI59gre/g03/qFd+3whHFC4v4qWypP
         nmKZwaDQ/WnDmHuInKWuRQaAM46t2RvIfoKeF53TJocYhLP6jJGV2UTlDx4WwvbR0bvL
         6UrP+5Y3mp8IXDqyKKF2l9Ca3Uk154A6D/+8FOqKEkOYhY+jZQlN06cgUZd9kdkhr6Nf
         GilsU/Sn9VufZP9wgoOQvzarkyRAJcPY2tCS8bGnlaFWsOad4wAm0HYwtjw3/UuTwBmV
         QqD6YcCcA+RJw35N10ZiSMlH5q5u1FVaBQluDv/CSZ4P9H7kc9dJ8+8In6LfKo58WLrt
         RDHg==
X-Gm-Message-State: AOAM530TMGUNqLcUePAPGA03Nc6dWpSVeZ2CWzjUKUEn10NxMX8Fa5V8
        CTkZZyaKDbAKrooyr/mh0CrN7CSeopmV1w==
X-Google-Smtp-Source: ABdhPJznJdmRHvGijkQSObAClombdDNVzKY2UjTJqgKqhfMTLfZKvR9cH4mQxnXdWmlxHCAxcsSCLA==
X-Received: by 2002:a05:6402:10d5:b0:408:f881:f0f3 with SMTP id p21-20020a05640210d500b00408f881f0f3mr13971727edu.112.1651507253898;
        Mon, 02 May 2022 09:00:53 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-001-135-067.77.1.pool.telefonica.de. [77.1.135.67])
        by smtp.gmail.com with ESMTPSA id h18-20020a1709070b1200b006f3ef214dd3sm3689996ejl.57.2022.05.02.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 09:00:53 -0700 (PDT)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Serge Hallyn <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v2 7/8] kernel/bpf: use new capable_or functionality
Date:   Mon,  2 May 2022 18:00:28 +0200
Message-Id: <20220502160030.131168-6-cgzones@googlemail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502160030.131168-1-cgzones@googlemail.com>
References: <20220217145003.78982-2-cgzones@googlemail.com>
 <20220502160030.131168-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Use the new added capable_or function in appropriate cases, where a task
is required to have any of two capabilities.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cdaa1152436a..95a2cf3e78c9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2249,7 +2249,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	    !bpf_capable())
 		return -EPERM;
 
-	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN) && !capable(CAP_SYS_ADMIN))
+	if (is_net_admin_prog_type(type) && !capable_or(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
-- 
2.36.0

