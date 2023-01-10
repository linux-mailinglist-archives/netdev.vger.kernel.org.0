Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E360663C84
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjAJJQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjAJJQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:16:14 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 236D150F4B;
        Tue, 10 Jan 2023 01:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
        Content-Type; bh=Em2JFVD2u/iA9XuWQueDH1iR1dHDBEeEW9F0fobBqK8=;
        b=o036YDsCb1nERLIPl3fNaHZoESyd6FhjyfxtmFYZcr1K/bMOfgT/t/nxk89u5f
        VeaFd6Vuxi8HLS9jC4FDbEKgCQx9DYxy97MVZKscY7RPTt+lHwJtHJ96mDHSvBbi
        INnkDtkkXT8zPI8LpbS09cFCp2+Rk8XWM8X8JSHhMf958=
Received: from localhost.localdomain (unknown [114.107.205.23])
        by zwqz-smtp-mta-g2-0 (Coremail) with SMTP id _____wDXwC1kLL1j4dlPAA--.32863S4;
        Tue, 10 Jan 2023 17:14:47 +0800 (CST)
From:   =?UTF-8?q?=E6=9D=8E=E5=93=B2?= <sensor1010@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        kuniyu@amazon.com, petrm@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?=E6=9D=8E=E5=93=B2?= <sensor1010@163.com>
Subject: [PATCH v1] net/dev.c : Remove redundant state settings after waking up
Date:   Tue, 10 Jan 2023 01:14:09 -0800
Message-Id: <20230110091409.2962-1-sensor1010@163.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDXwC1kLL1j4dlPAA--.32863S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4R9_-mUUUUU
X-Originating-IP: [114.107.205.23]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/xtbBogzyq1aEHGxrVAAAsq
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the task status has been set to TASK_RUNNING in shcedule(),
no need to set again here

Signed-off-by: 李哲 <sensor1010@163.com>
---
 net/core/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..4bd2d4b954c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6580,7 +6580,6 @@ static int napi_thread_wait(struct napi_struct *napi)
 		schedule();
 		/* woken being true indicates this thread owns this napi. */
 		woken = true;
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
 
-- 
2.17.1

