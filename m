Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD35AA5D9
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiIBCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbiIBCaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D103275DF;
        Thu,  1 Sep 2022 19:30:13 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h188so737829pgc.12;
        Thu, 01 Sep 2022 19:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=7uI5yxQ2IficxCafBouZLQeDm3f9EVu1uBy3AFKC6gc=;
        b=OFJXxBSBYOssoMkoywl9EoB3k6QrkEaHd8YL02U+QnpsTC0UA4fodDgpSL5b5LWBLX
         nLgkHuPVwidqPfsnsj8JHUDLGBuIyEEBczjpRgWekusWdvlQ7O5GLfNXILnfWwkwAPMJ
         hcJ2ifQutv33yG3kxTre9B7m3UTbVLhx74iQdT6qSkb9YwbhX7EK8Gsn17MRAfi/hNG1
         6Svh8N4fpVQKpD4jLnAFBmhHGs6Pbi/lGpjyvsVXTIgrjPlqDpEWOT1O2plNLLZMq3/C
         Pyiw6ih9zAawcl99mJzJSBR019T2VD/ls6nn2v1UxhwxYmwSSUpvlAAX2eLUKf3JXR6f
         eZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7uI5yxQ2IficxCafBouZLQeDm3f9EVu1uBy3AFKC6gc=;
        b=5F/Pi4ST4B0syjt1JlQNybb1xFlAY+MgzHzJ3lle7sUBjV5OYFwMxujeHWTr2lsQfc
         sn53RpVgU2tJxE6xyA1HEgW2/9soRaDjOso6VHlWlpbpUlldqn7aj/UjoHPoGMJHTnvn
         APg5p/QvzPU3Hk/oXsEhHotUDeqZL11tNi4fqug/TrAfnps9zctFfCJd1mijC4ihnXgi
         tWNzvZyytulqXM961pSqhGGN6U2JsBbNpKed11W6zDEzjwD6o4P7jw2Zozoydcm5yoP/
         FOEzig0r2V3z0m6tK+ZdtMD/C/XtGyQwji5snxVAqDulErnADjyTCBxH5lqY5qrpRc3m
         UcUA==
X-Gm-Message-State: ACgBeo0zqsOsRtR2o5VbyjQ8sviu8bYQQfyYVL/0/2XvpqpzT+l5XAQU
        usx5uIx2WJbycSUDkl/qfM8=
X-Google-Smtp-Source: AA6agR7KvJ3/nC3lYOZJPIL8xkpq5Mcjsx/aQlho5wzkyPrwzNAvnub08SZ4yh6Sj9fhmkLywjW2qg==
X-Received: by 2002:a05:6a02:10e:b0:42a:b42b:5692 with SMTP id bg14-20020a056a02010e00b0042ab42b5692mr28380447pgb.67.1662085812826;
        Thu, 01 Sep 2022 19:30:12 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:12 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v3 01/13] cgroup: Update the comment on cgroup_get_from_fd
Date:   Fri,  2 Sep 2022 02:29:51 +0000
Message-Id: <20220902023003.47124-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
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

After commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
we can open a cgroup1 dir as well. So let's update the comment.

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5f4502a..b7d2e55 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6625,7 +6625,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
 
 /**
  * cgroup_get_from_fd - get a cgroup pointer from a fd
- * @fd: fd obtained by open(cgroup2_dir)
+ * @fd: fd obtained by open(cgroup_dir)
  *
  * Find the cgroup from a fd which should be obtained
  * by opening a cgroup directory.  Returns a pointer to the
-- 
1.8.3.1

