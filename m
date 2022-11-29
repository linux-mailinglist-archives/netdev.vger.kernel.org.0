Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5C63C0E2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiK2NVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiK2NVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:21:33 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2B53137C;
        Tue, 29 Nov 2022 05:21:33 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so33656546ejb.13;
        Tue, 29 Nov 2022 05:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=p47a3wFEwKYP2wcEEZnkh1s7uSbd3Bd5YrEhFKIvdKC1mL2nrnkc/SGZ9bljiiVjbs
         rfGUWsl4v+l8JG9/zt7lQSNuVueDxKq4BSnuqxah+Qvxr2ci3nnjfk9YNqwGD6WKj269
         52Kc6dQnHaZIbUN9uyOx9huUd7/x+20pTCCF1yE6mzyk7lU6Ekqv04HW8U3waCmroV5R
         3UIquFwrLgCANn9+6KcfbkXbO7xntgEUIi6jOMb3j/KRxqDnQYw6l4kfKs4e1axbHohg
         dI2tzbszSZWkslNC+iOYAtn2fjJdSRATUX2hWaeGiJxcxpVhEJBLoKzXrzjGx2UcB2Hu
         kHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=VfX514pJKMln3u23HJe1TTa9o+V4+dl4Gv7al6XGwVA/2ZjK+O507mQx2DLxoUVuy8
         aqd/qgjAzH2cqn5BGSGviv4ut6+hee32HAnA0ln+dmzJTzm3f+0rABG+62OHWC+4A72l
         IqwMFZl0bbfZ6ZduCakbyYo8+Ir6egy7GVPqhvkAjBEqR3mmo4WvtLFM/+AjdcRreTlU
         LuYXR6hsgEKZ1q4i9EWbcAVnhsZPyEQ4HBqDItSigYBEkrrEEHOp6wMmri9FYeDFfIDX
         xYiGTzg2ggm1n43wLRG8QlBP7DRMlQmI08lYj0gGydgFh7putDwg5Yf05FRTGRPGwrnD
         fjuw==
X-Gm-Message-State: ANoB5pmZ5atr7R1d63cSBdLTd4geNt96bh6xz+/boZvun6HEAz0BCHMZ
        5IfA8iQz/SDhTpp+YeyRw2o=
X-Google-Smtp-Source: AA0mqf69iwjmBuRhHbB63gyM+aH9AogDycouxPQ7kMyCdsErcoAcLaF9FBJCB5BgVo9WalJ3UU26Sg==
X-Received: by 2002:a17:906:a050:b0:78d:47c8:e80f with SMTP id bg16-20020a170906a05000b0078d47c8e80fmr48387746ejb.700.1669728091429;
        Tue, 29 Nov 2022 05:21:31 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id v25-20020aa7d9d9000000b00458a03203b1sm6252632eds.31.2022.11.29.05.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 05:21:31 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v2 1/3] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date:   Tue, 29 Nov 2022 15:20:16 +0200
Message-Id: <20221129132018.985887-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129132018.985887-1-eyal.birger@gmail.com>
References: <20221129132018.985887-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows adding additional files to the xfrm_interface module.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/Makefile                                    | 2 ++
 net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (100%)

diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 494aa744bfb9..08a2870fdd36 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the XFRM subsystem.
 #
 
+xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
+
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface_core.c
similarity index 100%
rename from net/xfrm/xfrm_interface.c
rename to net/xfrm/xfrm_interface_core.c
-- 
2.34.1

