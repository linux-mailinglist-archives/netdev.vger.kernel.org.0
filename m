Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1132843595D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhJUDsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhJUDrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:52 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625CEC061749;
        Wed, 20 Oct 2021 20:45:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b14so7771232plg.2;
        Wed, 20 Oct 2021 20:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FO6px52zOvL06YEAEvGgHt7D/uuPPxpA7vLGdvmdYfM=;
        b=WNmzmbXrhFH2nno5IvKecSwjtBp9Sq1uuau/dT4MJbXtKGLvAztn1BspiqME7ie9jT
         ElhAup4UIC5cL6+b1eX/i/G0lqnjyW2GJyKBbXutPomMQgnucVAuegoq+aer3e0kmeIK
         G+IYbOusYEVuk9y4PutAERzxqKLouzRE0BDA3FPNkhdC1Q3PcxupW92oFnz1dWdOnlIS
         4Tcz8zW4c+HN+W9ZApz2p6CICrqQQ3HZ+HBtQP7s4MIytQ3quGSqGkIQGRYgU0LYV3oH
         gCDGkw+O3TQMThouBhgLOFPqjoPP1OYoKuTmp9qCInxJi5/wsDyISnA/gqXY0tP5wtLV
         t76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FO6px52zOvL06YEAEvGgHt7D/uuPPxpA7vLGdvmdYfM=;
        b=b+soD0oR6OHqrpohBeSpRTIqBD82r9nwxQP+Cp2Jkdp2nQlmvAS26nBv+m1DbD+8g6
         0Z0I7RHIsnr4n44A6sx60ODbbMg/i3UtLu7W8NMVlluVCsTq6QDHiJULJSOz1QbHGUo4
         Q7cbU1iDhGKg0gK9umEuBweL9nJAahQ0Z7hJ1bvCHg1oXQVl2T2UQnUH32hSDIE95DmV
         6Oi9v3eZmv+rG/SeAs520GWVSkaMSl/2QxzSC5q7CWZH+1OtrW1+AxAPWPY75vBbBdmH
         ngUm8fdKbkSABSFurh2ZpCey+nzRcbN+BCDYXIySnqzLdcOpGdq71DuLFHZHtPfEIIRq
         zqMw==
X-Gm-Message-State: AOAM53274LGYIjqXJgszPWLfM+KCANXcIH6BwH0u1+7fNJzgxn56wJlL
        YI5z/ikhtzbfjFOGIn19Zik=
X-Google-Smtp-Source: ABdhPJxnEADlrfLm34Bwr231gBIB5s+zQ3Wui9SZ/ZXUE7pRuaq7y0gkzhhBLrZJrNoDqeWyO/tWqA==
X-Received: by 2002:a17:90b:3a81:: with SMTP id om1mr3695306pjb.184.1634787936822;
        Wed, 20 Oct 2021 20:45:36 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:36 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v5 09/15] tools/include: introduce TASK_COMM_LEN_16
Date:   Thu, 21 Oct 2021 03:45:16 +0000
Message-Id: <20211021034516.4400-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TASK_COMM_LEN_16 is introduced to replace all the hard-coded 16 used in
the files under tools/ directory.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/include/linux/sched/task.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/linux/sched/task.h b/tools/include/linux/sched/task.h
index a97890eca110..7657dd3e0e02 100644
--- a/tools/include/linux/sched/task.h
+++ b/tools/include/linux/sched/task.h
@@ -1,4 +1,6 @@
 #ifndef _TOOLS_PERF_LINUX_SCHED_TASK_H
 #define _TOOLS_PERF_LINUX_SCHED_TASK_H
 
+#define TASK_COMM_LEN_16 16
+
 #endif  /* _TOOLS_PERF_LINUX_SCHED_TASK_H */
-- 
2.17.1

