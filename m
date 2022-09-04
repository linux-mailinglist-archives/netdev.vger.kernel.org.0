Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808B45AC611
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 21:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiIDTXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 15:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIDTXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 15:23:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D4E2E69E;
        Sun,  4 Sep 2022 12:23:35 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x23so6639445pll.7;
        Sun, 04 Sep 2022 12:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=t1xTYA4sjuGCh4pw3N6/8X8I4YHHyXAx3KGLnNc3nds=;
        b=JuQdFQznN6fig6R2GT4wFv4boLIPrh52pkOjt7Lk8nwSgI65990K1hikW1+UWssukE
         hkoBhQ15kid+XL/9WfgKqmYdxnNhivT42x0Favs9JqSVfbZk7KM6V/nvm87u8L5ENJxK
         sUnBMp3KajXtvWlKqVkJ2nmon4lFv5WpkK7pP63O25Cz9I3Lhra7fp0atBGfasq85YMU
         0piwSM/rdcd/050P3aavp1ybATVo4tInhsgWKqxmQjpQ02QhR1ya7lZCMid3kzVbxR0H
         j6RZa8ATgc8gnLynqW/GwbdGRJVzFBafXFM12/beAvTFdWSb/jM8PqtVC1QNo4dxT1YA
         tMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=t1xTYA4sjuGCh4pw3N6/8X8I4YHHyXAx3KGLnNc3nds=;
        b=3FlyJrHXT00o9acOFVG30aCNY5J27dt4LditI0dnOo2OKrUkd6BJ+6Gem+mZY1sRjF
         NiF+LOmfP0GpY+OPkqvkUM8tgPh8s7sn/M/c7TnTojtMT9gSAm2nfbCQI3byEOCSsU25
         lm1fR5CZHKEdJInMy4XAQUK7jS8dlxw0g7ecawN3eXkWhx/5VD7V0y/TRa3z2s41zGah
         n7wjvPStNRSuTHegD/cIVMMqCJkgEX9Ulnqte1Ug2T5rQSyLpJszlxKsgbvxk+cAcgSQ
         ZawrIMLGmsDtJHRHeIP4SPMW326aj59aDUgn23Tr2VKbcrhoF/3Zxav0oXCBQ1vzH+6q
         HMNA==
X-Gm-Message-State: ACgBeo0mpVbEYDTAfErADPeg+U+wybmOSQ8wtXheD1+I+tfa1st0h6XF
        G1KZDsKGXcflYcNXLmV1R28=
X-Google-Smtp-Source: AA6agR7Fr+8qy74vv2j29N2M5Bf8aHfMmlBDM7k04lJv67nFAGaICCLvwviLtM1Rxh97EiGfwGZi1g==
X-Received: by 2002:a17:902:b217:b0:172:bd6c:814d with SMTP id t23-20020a170902b21700b00172bd6c814dmr45833683plr.55.1662319414609;
        Sun, 04 Sep 2022 12:23:34 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:291b])
        by smtp.gmail.com with ESMTPSA id i192-20020a6287c9000000b00538116bab6fsm5980580pfe.213.2022.09.04.12.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 12:23:33 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Sun, 4 Sep 2022 09:23:32 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Gabriel Ryan <gabe@cs.columbia.edu>,
        Abhishek Shah <abhishek.shah@columbia.edu>,
        linux-kernel@vger.kernel.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: [PATCH cgroup/for-6.1] cgroup: Remove data-race around
 cgrp_dfl_visible
Message-ID: <YxT7NASKiuZDx6PT@slm.duckdns.org>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
 <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
 <YwuySgH4j6h2CGvk@slm.duckdns.org>
 <20220829072741.tsxfgjp75lywzlgn@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829072741.tsxfgjp75lywzlgn@wittgenstein>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From dc79ec1b232ad2c165d381d3dd2626df4ef9b5a4 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sun, 4 Sep 2022 09:16:19 -1000

There's a seemingly harmless data-race around cgrp_dfl_visible detected by
kernel concurrency sanitizer. Let's remove it by throwing WRITE/READ_ONCE at
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Cc: Gabriel Ryan <gabe@cs.columbia.edu>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/netdev/20220819072256.fn7ctciefy4fc4cu@wittgenstein/
---
Applied to cgroup/for-6.1.

Thanks.

 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0005de2e2ed9..e0b72eb5d283 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2173,7 +2173,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6098,7 +6098,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.37.3

