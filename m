Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40C85A8C22
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 06:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiIAEDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 00:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAEDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 00:03:20 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D093F15C358;
        Wed, 31 Aug 2022 21:03:19 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v4so15230389pgi.10;
        Wed, 31 Aug 2022 21:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=F9QtJAGWPoUgH7EvqJ23+lTBvakIaZr8r8lhECGqmaE=;
        b=d64/i3z1FUn8zNdfN8J8FhbvakCDJCdMPkNHvz0Bt1yYZv1GM8BkfI4dgZ3d7Pllik
         35KUqmi061lX1aX65uVNCgs4vVXWH0eM4Ib4NecIz3pFyL1dI00eW2nc/mGSnt/xpF7J
         9YIJepXyJ9TGSzDlzkh9oWxsb8Q9epItsfX1vXOLddLfbo+bEWJunkYOs8ma0N8nvySK
         NvmBpiA/9ZDr1qEXosJdw+fxb+TZCd0IQnQZJ8MKPQZC+KdOvK377587RyLzwvV+rMnk
         TJP/W6cao+iw26Xn8QrppTV7r5UmpwE0s17shi08OhsLFUpJ7DPTww3jfncA49IDEVm3
         q+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=F9QtJAGWPoUgH7EvqJ23+lTBvakIaZr8r8lhECGqmaE=;
        b=2X0RlmTacqRCVoOyPWGj8diadfad4xCj69p+7F5iwr4JE9HikRjb/CEJ/f5zoGrbrU
         YRIa/61w4MTbqdbTT1ZBYDZY093xmjQpP/aj4iW95aNo93okghRX0A9lxrKrhZksHOeg
         hDoFBuPkX2rw/MG2YIACjU2oKX3+3bIJPD3UkHBSPVRC1PctdFqP/RDvDhLOAmqAq6V0
         WxSvnHuSvqirjpg5Rmt0hBy1z4hRHc1m7q7qjSS/5euEb3Hp4EtbEMPK1GYA+0aR7U/7
         fdnm8tWqG4hANs2Pg8JZnx069UFhdu/Mb4G3ZzxWd4PAe4tkZCmHnQuNcje+qVcfiUOt
         MjxQ==
X-Gm-Message-State: ACgBeo3UOCiSLHvZxAX+8YdD/9adzjKb1wkga1oFO76dk7J+GC4Ogo0Q
        GtTxuoxCWeQnh3/mLcaDqg/QsV7ZA9GaWw==
X-Google-Smtp-Source: AA6agR58KSuDpzMdMOpcxDCt3iSfeiaVaetz4buEsvO5bR9uEvOxLcA9OpDX0lWd7olfI0grktg1Lw==
X-Received: by 2002:a05:6a00:228a:b0:538:47a7:706 with SMTP id f10-20020a056a00228a00b0053847a70706mr16938794pfe.62.1662004999307;
        Wed, 31 Aug 2022 21:03:19 -0700 (PDT)
Received: from fedora.. ([103.159.189.150])
        by smtp.gmail.com with ESMTPSA id f9-20020aa79689000000b00528a097aeffsm12110215pfk.118.2022.08.31.21.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 21:03:18 -0700 (PDT)
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
Subject: [PATCH v3] xfrm: Update ipcomp_scratches with NULL if not allocated
Date:   Thu,  1 Sep 2022 10:03:07 +0600
Message-Id: <20220901040307.4674-1-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <00000000000092839d0581fd74ad@google.com>
References: <00000000000092839d0581fd74ad@google.com>
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
Assigning obsolete addresses from ipcomp_scratches

        if (!scratches)
                return;

        for_each_possible_cpu(i)
               vfree(*per_cpu_ptr(scratches, i));
Trying to free non existent page, causing warning: trying to vfree
existent vm area.
        ...
}


Fix this breakage by: 
(1) Update ipcomp_scratches with NULL if the above mentioned 
allocation fails.
(2) Update ipcomp_scrtches with NULL when scratches is freed

Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
---
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
@@ -215,7 +216,7 @@ static void * __percpu *ipcomp_alloc_scratches(void)
 
 	scratches = alloc_percpu(void *);
 	if (!scratches)
-		return NULL;
+		return ipcomp_scratches = NULL;
 
 	ipcomp_scratches = scratches;
 
