Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01A05985D5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245168AbiHRObk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241464AbiHRObj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:31:39 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E981B99F1;
        Thu, 18 Aug 2022 07:31:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y141so1695985pfb.7;
        Thu, 18 Aug 2022 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7uI5yxQ2IficxCafBouZLQeDm3f9EVu1uBy3AFKC6gc=;
        b=efDyAXQ6g+bmM4mO4s9FEnX/G1io8w/Sb/p1agZBS8OYl+4qzSpqCOAmCv3KAH464o
         yqXHdmbv31M0qS0KPcZ+AfpgUlngTmPnP1urpMeb2TYvCM7sALpSLDshkSIVSeLrLRoF
         9QRaSQEbHv1F0yKOy1EsV9/6nosGOpeu+xYijhMJZB5j2CwYWyjafJJPw/2wgoPOAmX9
         LusMGoVPGPBLhQCbR4KB1vFQXYKGb7ro+K46rcWNOd67jWtcnaicVx8TbJZBi/u+VF8e
         xfkjVg6/1RxyOP6+vO8uXbp3X4dJAawiUTncBQeH7ADAUdm0lWBNB61oEHpzTJH5pQ32
         5q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7uI5yxQ2IficxCafBouZLQeDm3f9EVu1uBy3AFKC6gc=;
        b=kf0DH8mr8driZ647ZEBqIHDtOA0TuXjnsOC0fpynqTvApab6Hp7Fn9egczwMD21asJ
         labmcsdA6jL8IAtxe2S2dR5eBrPD9kOZ4Oy5xoHX2ylRPgTobvQoNtYllvzkYN9/sAzm
         sSnhxWHaasTJcUNBiRV+bBq1rJJyQ4DJP/wVMu8Poi+PgkPRN88tVqcA3sdYncuxlojg
         sjZqHbAik7J+iz8btM4rOgpN1Kg+ZgVxVXbyCULmFb6jgRHsEGGYZPqdxNQeeI/6C7K8
         3AJnp5BhEU5fPL4rWGhWecq2Zoerfq/2BKvTntFE49NAZJUXyyNO/Og2CYZHeyBcYlAo
         JTzw==
X-Gm-Message-State: ACgBeo3l/wbepAn9hz8H/oShVANS+jBSX/nrI7+eUWJ4scNZrgoswEP9
        1hIeB2hr+fW2pswpyfV2fnI=
X-Google-Smtp-Source: AA6agR4cpUjkd3sgji2FqH6ByueAGCTReVusgTDZMfiRqYfoSDWjRgIK3pIyCMwyH5XK6YNRGb4yrg==
X-Received: by 2002:a63:d652:0:b0:41c:45e9:abee with SMTP id d18-20020a63d652000000b0041c45e9abeemr2763443pgj.110.1660833098487;
        Thu, 18 Aug 2022 07:31:38 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:31:37 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 01/12] cgroup: Update the comment on cgroup_get_from_fd
Date:   Thu, 18 Aug 2022 14:31:07 +0000
Message-Id: <20220818143118.17733-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
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

