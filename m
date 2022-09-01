Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2D95A8F73
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiIAHNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbiIAHM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:12:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9023AE0FFD;
        Thu,  1 Sep 2022 00:12:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c66so6416285pfc.10;
        Thu, 01 Sep 2022 00:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZnVHYIoePyzft+SR64LAbQjIYKuIRSY5pvCaoRn0uR4=;
        b=hf0pPpYjDcjPGucGsP6ylkEDuZmBFG9lkrq81PSSVgzqZ+yKJ+duU5RLlxpp0p6zo2
         Uvo/FIPtgVodEDAvfADDz/Bm72MOBn57TfDwKm0gqqXNIAb0IdvCWYPODaBNAvhQvg09
         8YPZoZeu8/zE/EscbKW9ptybnGBZ1nrBZtoOfhP97mGUgtCjvTv53bTNcFNBWRQGdJDL
         Oc4Z4ej3C6cIa5eLoHeM9ze32PFg+gVAn5gHyTKLMc9vettP8fpaYfr1dQQ1tmg/hDrc
         JxcrvYAVBB+i8N265izt/7+Aaalrmr8wBRJ8IUrsS+1gEcjXqipg8gXPi8Dp5TfQd6GF
         Qovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZnVHYIoePyzft+SR64LAbQjIYKuIRSY5pvCaoRn0uR4=;
        b=y6M3Ouiu+UQF9WOkcj0kMULg0WpkVq8VRJbfXd+fUnlFcfStGj3+4gX5awVzlQU8fr
         AWzVLSxBTfmo+VLYpP1so4LNukqmO3ZXj0S7Ad092toIi4Tg/QTzLdJQOeqaKEZrbpTA
         3SPQnaBeI2YOFCyeWpxPrF2makmH/YsM8xNxO5YQiStfjVDoFTG2tXr8JCNebEokZzBh
         dP5ubcEwtZHiSZOLBN8sAqTffVfd9TCQdCV9TI7Hr/5r/8CxpoWG4WYyN0bEkFwnaN0x
         tOlxfSOshVq737ntIRar1Gri+HtCYDTIIL5uw1xn77S5At7CvyXxRbBm/GJAVZrlh5sW
         Refw==
X-Gm-Message-State: ACgBeo3iki4ALwJP27WEEBne8ARhJ330k7cavbT9Z3rBiRiCs4/ki7pz
        4pk1sqYUML5JRfo8HjL1pAw=
X-Google-Smtp-Source: AA6agR4WZoetDvivmlqq9ieW+hP6W9zwvwCVfBpNaU2sUWgZikyExz43/hy+jnpoe89kmajDObQgwg==
X-Received: by 2002:a63:89c6:0:b0:42b:8246:265 with SMTP id v189-20020a6389c6000000b0042b82460265mr23356525pgd.256.1662016344064;
        Thu, 01 Sep 2022 00:12:24 -0700 (PDT)
Received: from fedora.. ([103.230.104.22])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a990100b001fdcfe9a731sm2513918pjp.50.2022.09.01.00.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 00:12:23 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com,
        Khalid Masum <khalid.masum.92@gmail.com>
Subject: [PATCH v4] xfrm: Update ipcomp_scratches with NULL when freed
Date:   Thu,  1 Sep 2022 13:12:10 +0600
Message-Id: <20220901071210.8402-1-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <00000000000092839d0581fd74ad@google.com>
References: <00000000000092839d0581fd74ad@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if ipcomp_alloc_scratches() fails to allocate memory
ipcomp_scratches holds obsolete address. So when we try to free the
percpu scratches using ipcomp_free_scratches() it tries to vfree non
existent vm area. Described below:

static void * __percpu *ipcomp_alloc_scratches(void)
{
        ...
        scratches = alloc_percpu(void *);
        if (!scratches)
                return NULL;
ipcomp_scratches does not know about this allocation failure.
Therefore holding the old obsolete address.
        ...
}

So when we free,

static void ipcomp_free_scratches(void)
{
        ...
        scratches = ipcomp_scratches;
Assigning obsolete address from ipcomp_scratches

        if (!scratches)
                return;

        for_each_possible_cpu(i)
               vfree(*per_cpu_ptr(scratches, i));
Trying to free non existent page, causing warning: trying to vfree
existent vm area.
        ...
}

Fix this breakage by updating ipcomp_scrtches with NULL when scratches
is freed

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
---
Changes since v3:
- Update ipcomp_scratches to NULL when freed only
- Link: https://lore.kernel.org/lkml/20220901040307.4674-1-khalid.masum.92@gmail.com/

Changes since v2:
- Set ipcomp_scratches to NULL when scratches is freed.
- Update commit message.
- v2 Link: https://lore.kernel.org/lkml/20220831142938.5882-1-khalid.masum.92@gmail.com/

Changes since v1:
- Instead of altering usercount, update ipcomp_scratches to NULL
- Update commit message.
- v1 Link: https://lore.kernel.org/lkml/20220831014126.6708-1-khalid.masum.92@gmail.com/

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..3774d07c5819 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -203,6 +203,7 @@ static void ipcomp_free_scratches(void)
 		vfree(*per_cpu_ptr(scratches, i));
 
 	free_percpu(scratches);
+	ipcomp_scratches = NULL;
 }
 
 static void * __percpu *ipcomp_alloc_scratches(void)
