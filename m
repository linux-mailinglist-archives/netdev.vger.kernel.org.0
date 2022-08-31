Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F225D5A8032
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiHaOaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiHaOaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:30:05 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF792A47A;
        Wed, 31 Aug 2022 07:29:59 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id b2so10907688qkh.12;
        Wed, 31 Aug 2022 07:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=MnDD7K45URldganONgu4aspExP7uN+YZ9AWpkwZwj/I=;
        b=pZ4xxdD16ga83C5iRMKA6VvNnSR/dQF2+wYm7Et+bL2Fm4FF0B2D0Nyi+QhaSIqYz4
         cp+IvxHenwBvJ3NhO7k2j70O4b8iXorB6pFXF5Z/LzqTWbpyvOT4v2t2ptutKdx6KnPr
         IzD5B4DruSxvLG3/9vXaY9qW5YxvKuvxyJWW43OXWwqln6E0dwUTcovM48N0M65Lzne5
         CgHdzO/tQpW9JYe5Icvr47mfVEe+J0OLFa4HN/kOieRphqaanRzj2spMEyqehu+0u01a
         OGcZPwCxT64WpSb8ki2NycIKJkMUgbqPsdKEfVvMk4hxm67YIlx8Pt+DEV68jiGZzzwO
         zxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=MnDD7K45URldganONgu4aspExP7uN+YZ9AWpkwZwj/I=;
        b=eF9YNv0sKuloAZBNtJuEGZmsbEJCoPO/YbO416eGEjSzKVwjqc4ykZgLOb3Hl7k1LA
         yq6gxs8bwKzyizfO1b/rEXK6/5IugtIvtTkpsZbk/68a7VS+OmcE5cs14PzyoYZvRP4N
         /2RiQDzfAfdFgQyMT24bcxMshMNHdhqkJbzuoxNCwb8k23MpPRitn0n/rrXhrkOdYpj/
         nRUOPLf/c6fqpazHvxGnGOqu3fIsOUcz2OYJGzBR8gpM2fveSzEqYNW09s/Mo4unmCZs
         A1iw5PnoTZbVKHIVqD17TVffsf29pn9pIvRC3xNQPa4RMyvTHWr3OMEgNLRpI5ZBGqpp
         nuOg==
X-Gm-Message-State: ACgBeo3R78hKcve/gMHe/JqxbEt9qfqTlaOqJa65KGB1izitxaUFAY3y
        BNBaJaH4GTcp2vQeoqhYL/+SGyjxXFMdmA==
X-Google-Smtp-Source: AA6agR73ZH3tQvTkzFnfj3lP/LBtdrLHTW2EleHm7Mg9cbXsYhIMUxzuXbzhzPe5fWtXGfX/XF1mNg==
X-Received: by 2002:a05:620a:288b:b0:6b6:4f9b:85c6 with SMTP id j11-20020a05620a288b00b006b64f9b85c6mr15815569qkp.614.1661956198499;
        Wed, 31 Aug 2022 07:29:58 -0700 (PDT)
Received: from fedora.. ([103.230.107.19])
        by smtp.gmail.com with ESMTPSA id bm19-20020a05620a199300b006bac157ec19sm9947266qkb.123.2022.08.31.07.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 07:29:57 -0700 (PDT)
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
Subject: [PATCH v2] xfrm: ipcomp: Update ipcomp_scratches with NULL if alloc fails
Date:   Wed, 31 Aug 2022 20:29:38 +0600
Message-Id: <20220831142938.5882-1-khalid.masum.92@gmail.com>
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
Receiving obsolete addresses from ipcomp_scratches
        
	if (!scratches)
                return;

        for_each_possible_cpu(i)
               vfree(*per_cpu_ptr(scratches, i));
Trying to free non existent page, causing warning.

        ...
}

Fix this breakage by updating ipcomp_scratches with NULL if
the above mentioned allocation fails.

Reported-and-tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>

---
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..17815cde8a7f 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -215,7 +215,7 @@ static void * __percpu *ipcomp_alloc_scratches(void)
 
 	scratches = alloc_percpu(void *);
 	if (!scratches)
-		return NULL;
+		return ipcomp_scratches = NULL;
 
 	ipcomp_scratches = scratches;
 
