Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8511436DE7
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfFFH4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:56:53 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37812 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfFFH4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:56:53 -0400
Received: by mail-yw1-f67.google.com with SMTP id 186so517001ywo.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 00:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9i+39qzlLlaj4ZIJyuysO0V74pT4jxs4rHh5xzjVecc=;
        b=pJ/XAoNin++ppwq0Yryx58yYTvqaZaQj8So8vITNx5j6Ty5ySAWqIr36sESXSFmaR8
         9HomApkEVr1IiR6M4JnOxf4jg7D3RXcLWx0RgOKLxj0C/TA1UXqAq7i1S7bWi6bVY+Uq
         9/nZJtNx9DaywajZ/iowMTY7S0YAJ7AfcOAFxET8HWmzQxO2UT7I8H2scnQojIHiELvA
         Xk3CwGnga560N3HRVcVF/JkEIA5SY/HjaWWvmIvVSQRZprabi//HTGKoOvsdFIiwtFCa
         P8qiEP0zgewtJW0XMD891BgK1PL82mlWRyb8cy0BcXqubHqc1dSM2oAR31pY3r2y6THY
         AL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9i+39qzlLlaj4ZIJyuysO0V74pT4jxs4rHh5xzjVecc=;
        b=a1WBPS/dtURHcThqOyWh6Q8I5qSk6mNgctmUCFhJHrJRUdMKgnYSutoNFh7+Mi1215
         JL258M0EB8VHQlTmKkWO0YHu6ZcXd2E4J/m1KaZxmJA2gtAc/RqQR0jGu/NJWC40ELpu
         kxJVc7v/Z30fD0LlyT9ydOqpjuot4rELmRYeb8vtZdWA7xVEWqUbWMEwzEevmV0hrIcV
         SJC+0EULfDl1WxCK9+cWlxZVZWhmLfOFLDlVf0kvET03autIK5JgHnNf/qfunsMdod7+
         eeqGuu47kY7gptJEl+vrbcovaKRJur1SIS9/pz+4twblHthUmp2/Eod8hi/Jg5JS3FHj
         MSwQ==
X-Gm-Message-State: APjAAAVJA/jrDi0/+GVTii5QcgRqfrN962/LCI3bSF3PmDBWyz/WKrHK
        JPHDJ8v5EnplCQZnmo9k1l0ckJ7JMbbSDg==
X-Google-Smtp-Source: APXvYqzBoIij+GY609wSEIttcFA3t55zCx1DUNATNXk8Jbe9N2y6y9kv5BsG96+2mq9PAiF/I6Wf1g==
X-Received: by 2002:a81:2981:: with SMTP id p123mr10051401ywp.430.1559807812812;
        Thu, 06 Jun 2019 00:56:52 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id 14sm316343yws.16.2019.06.06.00.56.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 00:56:52 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 2/4] perf augmented_raw_syscalls: Remove duplicate macros
Date:   Thu,  6 Jun 2019 15:56:15 +0800
Message-Id: <20190606075617.14327-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606075617.14327-1-leo.yan@linaro.org>
References: <20190606075617.14327-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro SYS_EXECVE has been defined twice, remove the duplicate one.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/examples/bpf/augmented_raw_syscalls.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/examples/bpf/augmented_raw_syscalls.c b/tools/perf/examples/bpf/augmented_raw_syscalls.c
index 68a3d61752ce..5c4a4e715ae6 100644
--- a/tools/perf/examples/bpf/augmented_raw_syscalls.c
+++ b/tools/perf/examples/bpf/augmented_raw_syscalls.c
@@ -90,7 +90,6 @@ struct augmented_filename {
 /* syscalls where the second arg is a string */
 
 #define SYS_PWRITE64            18
-#define SYS_EXECVE              59
 #define SYS_RENAME              82
 #define SYS_QUOTACTL           179
 #define SYS_FSETXATTR          190
-- 
2.17.1

