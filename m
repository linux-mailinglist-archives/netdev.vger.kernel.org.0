Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E295A3F12
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiH1SWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 14:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiH1SWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 14:22:09 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E5D2A430;
        Sun, 28 Aug 2022 11:22:05 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y127so6234539pfy.5;
        Sun, 28 Aug 2022 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=fDxt/23RMfjSPySyD961NLt4VpOweqOjLnL5SIVCHSw=;
        b=bYRe2XZSiSci2LOHFk4x2DL4UfLXQoCGgCBD1X+W6bzYL4E1x6f+eLhYmIXp7q53rW
         Uo4HLItQM5SCdwRKOFo/PKO99zk0ev1GsMB4n8AfLYQjMlsPBBchv0gViHGlRajCZW+K
         cA9OvTZId4uB8YFICMpI/1EkiEyyzvHs0SZdjd0LBmU+XWTWtTyb/6/HhwPbnmqlIRss
         kEbrFVTf+Jr0SVAsukYkqK/AOqGbxpalP10Wr6ELwkCpjLKMc4yVLcoMTZQnZfCCmuvf
         oP/IvdKyf+e3fgFbFTmyrw1IHO3wI6pgK1/WjAkAppW869soncCXuBC+5JdGn0xcr0Ni
         udyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=fDxt/23RMfjSPySyD961NLt4VpOweqOjLnL5SIVCHSw=;
        b=C9BOuWz1wHzIsQ6CNyycxbFXoJn/HPEWnj+xhzGQ/X9J+naXDt85twsReXUp1GQGAK
         T2vqExh/+d1kUkJjm+LhMFfXCuTL8WQljZxH2LjF2iTpBIrzfij08ZDNp23qI2YMmWDl
         JAWOu7iuBWcETDQdtCDCGLmKteanr5tIOhiDVNOrZaqTAH/6jmBxueWle5eM5e7fQv+Y
         whUfnvLdmRRTQoJNorE7dsQp0qBiIYyzj595jIsSaG2Dxa2Ck5LLwLLzqXSuAR2eAaGy
         X1VlCwTekxR81S84AVZlJDQ9rSgSZoZlPdC3c12AkQm5K/rGCqkNQzQdYL8tvJlZtvB4
         5QuA==
X-Gm-Message-State: ACgBeo0LtD+Vte6JvP+aKTHh7sBoXD9EENcbSsu7pwOj9hFIfq0lrLDP
        krs27t8X+/FJGH+kKSui/K8=
X-Google-Smtp-Source: AA6agR7tU14ikL/UQg9apn73eAvtTX2DR/yMT2CYo2OogdbUN5FCCIPInYPJGDzhUW+NCZRXkw3MpA==
X-Received: by 2002:a63:c5:0:b0:40d:d290:24ef with SMTP id 188-20020a6300c5000000b0040dd29024efmr11059768pga.141.1661710924333;
        Sun, 28 Aug 2022 11:22:04 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b0016eef474042sm5650821plx.262.2022.08.28.11.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 11:22:03 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Sun, 28 Aug 2022 08:22:02 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Gabriel Ryan <gabe@cs.columbia.edu>
Cc:     Christian Brauner <brauner@kernel.org>,
        Abhishek Shah <abhishek.shah@columbia.edu>,
        linux-kernel@vger.kernel.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: data-race in cgroup_get_tree / proc_cgroup_show
Message-ID: <YwuySgH4j6h2CGvk@slm.duckdns.org>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
 <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
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

On Mon, Aug 22, 2022 at 01:04:58PM -0400, Gabriel Ryan wrote:
> Hi Christian,
> 
> We ran a quick test and confirm your suggestion would eliminate the
> data race alert we observed. If the data race is benign (and it
> appears to be), using WRITE_ONCE(cgrp_dfl_visible, true) instead of
> cmpxchg in cgroup_get_tree() would probably also be ok.

I don't see how the data race can lead to anything but would the following
work?

Thanks.

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1e..a90fdba881bdb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2172,7 +2172,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6056,7 +6056,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);


-- 
tejun
