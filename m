Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E02B492C2D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiARRUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiARRUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:20:18 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0663C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 09:20:17 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id a12-20020a0568301dcc00b005919e149b4cso25141416otj.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 09:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q58G43Dd6LyCCT5zsV5YGlgMttIjdvQX+Rs5GRII7ec=;
        b=1qYFd+Sq/4+fBx82KH33Kei7sR1IXIJNUUCGrq2Jrn9aP1e0lCaVPhedJZzlZNcihN
         doKVyYbveHxKhXzzUeQXGNv8Qmm6nE9LbGAB0X2t9ToX3V2kKBl0YdXGEIvOr1vevG8z
         zBTrU96a+TXH+M0hOwbGRH5hz5DhtGMQwLSVOd8GdOefWNEklhfeBIDSWNgzv4jo6QaC
         SMBa7AMh4MS2WBWTZQ76acLyCEqZibR/yJpE/mz0Ma4brEpVKKkrPEt3vAt3/g6UYAiW
         11me60Gmo5481OPhWq1K9WgiaeHGz2DNVjRY1GIph0nUQ0rQ9sgIPL0cfANp5/uZKj1m
         UBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q58G43Dd6LyCCT5zsV5YGlgMttIjdvQX+Rs5GRII7ec=;
        b=iDE+ExFdRN8lIs2U0aL+2FSqQh0r3OUQglrSQMoHy2b84DT09yRMNyMMUPeZSZF7xE
         Sj9dzbxq/zq5dmdzVKZocwCrbZcURhv8QEOTh+Z4tmT1xttAZj2KF6Fj0ybJ1yoGck9f
         FujfEw28AKLWRztJ5YwgUWSIzpE/kLyrpr9GsF1lbIuKF5vVb5pv8cCokMelbd9NrUfb
         Dj49sYFsB7zrt4/ETvCydZJL4BrBTplQiDqBy64fHCZhBcH8rpvQVOkxfgveV+/2bxGo
         uMHb1VsNIwOD70bStIaArVFkqZ+NJGpkPydL16hEpj7TVU8ZbrcxPhFaKe8HxY+6nBxK
         /Sgg==
X-Gm-Message-State: AOAM533qez02qWk8TzDynbtRsdMU4ktiOvbAkIYfK2SN/2GIN+2mvdOH
        jrER+zVQ0Tv2vLqLRHDYjUpm0C+UtNtetJAaZdM=
X-Google-Smtp-Source: ABdhPJwz1or9s05ZkWIXq5QJ+DVbUYTKpcmhXwThJgiR6Cu0dmYILKbxyh5GSJl0utYDpp9tM6rukA==
X-Received: by 2002:a05:6830:1f56:: with SMTP id u22mr13667781oth.138.1642526417122;
        Tue, 18 Jan 2022 09:20:17 -0800 (PST)
Received: from localhost.localdomain ([191.34.69.98])
        by smtp.gmail.com with ESMTPSA id t15sm7051833otc.17.2022.01.18.09.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 09:20:16 -0800 (PST)
From:   Victor Nogueira <victor@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, kernel@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next] net: sched: Clarify error message when qdisc kind is unknown
Date:   Tue, 18 Jan 2022 14:19:09 -0300
Message-Id: <20220118171909.4375-1-victor@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding a tc rule with a qdisc kind that is not supported or not
compiled into the kernel, the kernel emits the following error: "Error:
Specified qdisc not found.". Found via tdc testing when ETS qdisc was not
compiled in and it was not obvious right away what the message meant
without looking at the kernel code.

Change the error message to be more explicit and say the qdisc kind is
unknown.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index c9c6f49f9c28..eedb2df7cc6e 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1204,7 +1204,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
-- 
2.34.1

