Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1D5A7376
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 03:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiHaBmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 21:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHaBmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 21:42:38 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB53A3465;
        Tue, 30 Aug 2022 18:42:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 202so12244349pgc.8;
        Tue, 30 Aug 2022 18:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ubln5fbaH7ce6iCfzyyQW0XzblPfUEWaEnsNJEtuwZ0=;
        b=WQWrb6A2v+HplHa3p58KzNRe6SGR/3aIWFOSYkCJN0vW/pKmSkdNGK/JiCYm4EEbhH
         nVMI9oI06oNBKeVT4kRHfNoZ/j7eG7vmAX+6Izx/XPGRsV6Aluyw2K60H0tVaBm+DUxJ
         EhsnX3Ind220EeodRa+bvDXMM+ZZIqPurQhcUwudUmAra8VYIctv6qCypHE1VKNHCP3G
         4YcoOUwsJwE2OtZnuYwoWsStzSGz42wG02pXpODJot6I8B4/0sMcN6H31TM5F/j9c/Uw
         rzpSf6rFCe92nJ83yoNL7Y5j6WGJxGq7DqRZZ1v1vBO2r6NE4ZC+pO9r9bznIVIUuMHA
         znUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ubln5fbaH7ce6iCfzyyQW0XzblPfUEWaEnsNJEtuwZ0=;
        b=0gEL0kiUNte28fUWluPDF80TunjYG5iwvwJD/DVvhG4Pv+xW6+ioFEFPdGAbX+yGxe
         gJo6ZvO0Wh10GpAwUBSxiZlKcnvcXzEARsIPmxsWM9IzLc7cadi8PPus1QieUnRRnS4y
         DEdNZR5qV4mnbUn9XO8DolI9DRRHdIHR1+is4VkeGmInvqE8DhszJk0cutTei5TNBTsM
         rqnhAjRNXJl8Up+ABnGzJOZbg7JqP9vmfZ7V4kGB+KwYOs4PMjmDuIyCRXqlVyp9iIz7
         bXUavGSsh33CIuCj99Ao6IvQxqSxl2BaZVMVgiYDwTCzG3tqHAYlvUGgHcncxm2x/qUp
         QV0w==
X-Gm-Message-State: ACgBeo1RAx5w90ASbLsNrSiArq+SQOE1mTGIV+BkRdzIdjOz2Xs0vMKi
        jlGpEghnGbYvGZU7RkPrxOnfWV+2KYG4XA==
X-Google-Smtp-Source: AA6agR6kV/OhmOXg5dp+Bv+738W/VZODrtrBXBzu3xirOAwgxXAPMAvHOgtUE00PgnclQ8hA1OuYZg==
X-Received: by 2002:a05:6a00:4147:b0:52e:2d56:17c8 with SMTP id bv7-20020a056a00414700b0052e2d5617c8mr23961845pfb.51.1661910156971;
        Tue, 30 Aug 2022 18:42:36 -0700 (PDT)
Received: from fedora.. ([103.159.189.150])
        by smtp.gmail.com with ESMTPSA id k15-20020a62840f000000b0052ddccd7b64sm10080460pfd.205.2022.08.30.18.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 18:42:36 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Khalid Masum <khalid.masum.92@gmail.com>
Subject: [PATCH] xfrm: Don't increase scratch users if allocation fails
Date:   Wed, 31 Aug 2022 07:41:26 +0600
Message-Id: <20220831014126.6708-1-khalid.masum.92@gmail.com>
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

ipcomp_alloc_scratches() routine increases ipcomp_scratch_users count
even if it fails to allocate memory. Therefore, ipcomp_free_scratches()
routine, when triggered, tries to vfree() non existent percpu 
ipcomp_scratches.

To fix this breakage, do not increase scratch users count if
ipcomp_alloc_scratches() fails to allocate scratches.

Reported-and-tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>

---
 net/xfrm/xfrm_ipcomp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..af9097983139 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -210,13 +210,15 @@ static void * __percpu *ipcomp_alloc_scratches(void)
 	void * __percpu *scratches;
 	int i;
 
-	if (ipcomp_scratch_users++)
+	if (ipcomp_scratch_users) {
+		ipcomp_scratch_users++;
 		return ipcomp_scratches;
-
+	}
 	scratches = alloc_percpu(void *);
 	if (!scratches)
 		return NULL;
 
+	ipcomp_scratch_users++;
 	ipcomp_scratches = scratches;
 
 	for_each_possible_cpu(i) {
-- 
2.37.1

