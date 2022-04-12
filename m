Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639CC4FE894
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 21:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355289AbiDLT1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 15:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356386AbiDLT1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 15:27:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B68825C5E
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:25:25 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s2so18355863pfh.6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYhX4cxvNPixKiX8/O3wLDCe+0alwiuzYnrIU9ZEA4g=;
        b=WcXC5z9iBD0s8lqEIkWuMQZUWfBIEmGdOcTDJqsddJGTc3xoDzEDte6mLkWCIDPq6H
         YHQuTi2jz+pLaZ8K0n3h+80UsslQCJcbZCL49vv/iIQRc4MzeoUTN57u4Pk6Dtk8H9Wc
         KDCu2a04jyUl6dKyGyJfhQgPSJPUaOxmhiyGeDPKKJPcJHNUlNymuti54JQo6/NDczvO
         vbVuQ9W77Cy/v2QPjgtsQEF4MpP2tX3f+bHSl/ir7fHiWkRxbpG2V2V744Rx+xNFpwjR
         XZUkPMYcqusEKPz9Uy9mX9juzRrR5tQ+Q4qiBB8T1Gj6Sx2YQ1W9au99vcD3HFtSTAwh
         8rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYhX4cxvNPixKiX8/O3wLDCe+0alwiuzYnrIU9ZEA4g=;
        b=rAqyr32HIqQ+fBQSGFrSzAzbbT3oJlaSnNSeawIJSPFlK6nqpf3DBHi/VniEUui8gI
         4tfpSNT9QR9muvU7Fkwyw4v/CBTeDzqAC/aFtSOwnjMZLkeQunBt70fByncRUcgfRrCj
         XF4xO6dXVmb3nHLwZEBaWyN3uA6ev1w3ZB8s5XpT1i/Z+W0x7sQJ6zo3737lKqh4G74p
         RPF4qr+tEiCj2VfUK/b2XhqeOmTRMDhMciQRUxEL9U4XLhX1oMawxdal//dRHGeBCiLw
         XFtEamKRWybw4mNcEZSr3bqSMdoP/YpBgLAvjl2Eu5Cu/KAcpbIOS/S3JsKeDK5tU8Yr
         8edg==
X-Gm-Message-State: AOAM533rooYyHTrhjbE86P5kLoRzvUADWGqQoKVwZfdLJRSdeSZtQ164
        iNJiylSYOgxtsI3+3uPM9RTcqQ==
X-Google-Smtp-Source: ABdhPJzeMv6SyUCfIBcUkGwkpHGFXVQVcRPNb1is3QYfwJwv0AwJdiiTP5oX9DldB+gEsO0E0yWlUQ==
X-Received: by 2002:a05:6a00:15ca:b0:505:bf6f:2b48 with SMTP id o10-20020a056a0015ca00b00505bf6f2b48mr12169006pfu.64.1649791524446;
        Tue, 12 Apr 2022 12:25:24 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm38925670pfc.78.2022.04.12.12.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 12:25:24 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     cgroups@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Subject: [PATCH] cgroup: don't queue css_release_work if one already pending
Date:   Tue, 12 Apr 2022 12:24:59 -0700
Message-Id: <20220412192459.227740-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a corrupted list bug scenario that can be triggered from
cgroup css_create(). The reproduces writes to cgroup.subtree_control
file, which invokes cgroup_apply_control_enable(), css_create(), and
css_populate_dir(), which then randomly fails with a fault injected -ENOMEM.
In such scenario the css_create() error path rcu enqueues css_free_rwork_fn
work for an css->refcnt initialized with css_release() destructor,
and there is a chance that the css_release() function will be invoked
for a cgroup_subsys_state, for which a destroy_work has already been
queued via css_create() error path. This causes a list_add corruption
as can be seen in the syzkaller report [1].
This can be avoided by adding a check to css_release() that checks
if it has already been enqueued.

[1] https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd

Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: <cgroups@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Reported-by: syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Fixes: 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu and work item")
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 kernel/cgroup/cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..9ae2de29f8c9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5210,8 +5210,11 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	INIT_WORK(&css->destroy_work, css_release_work_fn);
-	queue_work(cgroup_destroy_wq, &css->destroy_work);
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+			      work_data_bits(&css->destroy_work))) {
+		INIT_WORK(&css->destroy_work, css_release_work_fn);
+		queue_work(cgroup_destroy_wq, &css->destroy_work);
+	}
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
-- 
2.35.1
