Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02C573C67
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiGMSO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbiGMSO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:14:56 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8142186DB;
        Wed, 13 Jul 2022 11:14:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so4994898pjr.4;
        Wed, 13 Jul 2022 11:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UtHJ3Qg/19HcUm4MJm1fPiRsTok3DEs2h2LHQfacgzU=;
        b=ntCKgZRAm+eSzp/faQAyDd8Dl+7yFpy6fF8pMd3h08/YpaXT5B0B1GyX7a1R0CPpgO
         +Cs0OwzUQ4iMwGx6nyDPFcBD+VIIcDJoFSbur2vZ0B2PH5oGRcu+6fx7WqOSQviHItiW
         XDrXGD36GpCamSxqDgNeNZGnhsOvoSJBgFo6EHv+hA7MWNZBeOSur9eAKtE6uY9G/prW
         Y/01c9cURM256XlV93x10AFeriiURULVgfMTG6k9aT2NU9vy2/5tM21yuUvKB8SJA05S
         n6L8UE8mO/0namLte4roiMqoClJG6mJ0hR/8aDh+GZsUFZAb3kP8YdW4qC9y6pvciFFg
         h0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtHJ3Qg/19HcUm4MJm1fPiRsTok3DEs2h2LHQfacgzU=;
        b=Cb2zaPlBnunMnSMqpeJwbRMNcObM+wzO7IejfDl6h9P6aZR9ZfjHlUG/pZbMYL3g0u
         Nuew68EZtfIyO9ZXiqdrH6B9tWa+MqatMDmcKcYw16WWIm0Vc3jV7xAjjyAEBpnyczVF
         RZMfy7VMjW9v9PwAKC5IjppCCKR3yyaSp71de71fqKxwvlzwnppr2XnbTenj59fF05RT
         moZuHQwyagnGmV6FlpyA9tBaITBWHxuQubyVDwb3S4ynunpT+yeBsYDpanCpR0WRyeym
         CeF+jZKMVsQ958xOmDh9FwSc6EipqSgzzDNeTaFgBU/fLrtkf7LQVYkN4BCpRbo3pl8z
         7EBg==
X-Gm-Message-State: AJIora/GvnliazedbL0o3pRWyhLsEdLogoXg7lSoq7RDEZTgbqBPR+er
        c5z860DI2a5+IchpI1UkZaM=
X-Google-Smtp-Source: AGRyM1vU7NzF7lHvZ02XnNN53qGMTI64cfjlKr5EM3jBfvohilp/9pIBrt5KJamOYL5JmmeDP1Bg8Q==
X-Received: by 2002:a17:90b:3e89:b0:1f0:4233:b20e with SMTP id rj9-20020a17090b3e8900b001f04233b20emr5191803pjb.0.1657736095153;
        Wed, 13 Jul 2022 11:14:55 -0700 (PDT)
Received: from fedora.. ([103.159.189.141])
        by smtp.gmail.com with ESMTPSA id p6-20020a625b06000000b0052abc2438f1sm8874960pfb.55.2022.07.13.11.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 11:14:54 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        khalid.masum.92@gmail.com, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Subject: [RFC PATCH 1/1] net: kcm: Use sk_psock size for kcm_psock_cache
Date:   Thu, 14 Jul 2022 00:13:24 +0600
Message-Id: <20220713181324.14228-2-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713181324.14228-1-khalid.masum.92@gmail.com>
References: <20220713181324.14228-1-khalid.masum.92@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`struct sock` has a member `sk_user_data`, which got its memory allocated
in `kcm_attach` by `kcm_psock_cache` with the size of `kcm_psock`. Which
is not enough when the member is used as `sk_psock` causing out of bound
read.

Use `sk_psock` size to allocate memory instead for `sk_user_data`.

Reported-by: syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1fa91bcd05206ff8cbb5
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>

---
 net/kcm/kcmsock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 71899e5a5a11..688bee56f90c 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -23,6 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/syscalls.h>
 #include <linux/sched/signal.h>
+#include <linux/skmsg.h>
 
 #include <net/kcm.h>
 #include <net/netns/generic.h>
@@ -2041,7 +2042,7 @@ static int __init kcm_init(void)
 		goto fail;
 
 	kcm_psockp = kmem_cache_create("kcm_psock_cache",
-				       sizeof(struct kcm_psock), 0,
+				       sizeof(struct sk_psock), 0,
 					SLAB_HWCACHE_ALIGN, NULL);
 	if (!kcm_psockp)
 		goto fail;
-- 
2.36.1

