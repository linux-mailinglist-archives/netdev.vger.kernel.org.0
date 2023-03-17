Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D34D6BEBCC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjCQOyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCQOyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:54:10 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C611559C1;
        Fri, 17 Mar 2023 07:54:05 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PdRkB58cyz9xqwW;
        Fri, 17 Mar 2023 22:45:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnOWDafhRkaQemAQ--.41316S3;
        Fri, 17 Mar 2023 15:53:41 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
        brauner@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ebiederm@xmission.com,
        mcgrof@kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 1/5] usermode_driver: Introduce umd_send_recv() from bpfilter
Date:   Fri, 17 Mar 2023 15:52:36 +0100
Message-Id: <20230317145240.363908-2-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwBnOWDafhRkaQemAQ--.41316S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XF4ftFW7Xw4fGw48Kw1fXrb_yoW7WFy3pF
        WFkw13Cr4rtFy7ZFs3tan3AFyYg395G3W5KwnxWr9avan8Jr4qg3y5KFyYv34rGry5Cw1Y
        qrs0kFyUW3WDXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
        Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
        6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14
        v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
        rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXw
        CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
        67AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
        1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU
        Iw0eDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4asxgACsK
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Move bpfilter_send_req() to usermode_driver.c and rename it to
umd_send_recv(). Make the latter independent from the message format by
passing to it the pointers to the request and reply message buffers and the
respective lengths, and by merely doing read/write operations.

From umd_send_recv(), remove the call to __stop_umh() and returning
reply.status, which is message format-specific. Let the callers of
umd_send_recv(), such as bpfilter_process_sockopt(), call shutdown_umh()
and evaluate the reply. Consequently, remove __stop_umh(), since in
bpfilter_process_sockopt() the CONFIG_INET condition is always true.

In addition to the original bpfilter_send_req() implementation, support
partial reads and writes, so that callers are not limited by the length of
the message to send or receive. Currently, the pipe supports receiving
64 KB at once.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/usermode_driver.h |  2 ++
 kernel/usermode_driver.c        | 47 ++++++++++++++++++++++++++++++-
 net/bpfilter/bpfilter_kern.c    | 50 +++++++++------------------------
 3 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/include/linux/usermode_driver.h b/include/linux/usermode_driver.h
index ad970416260..37b8d08cc3d 100644
--- a/include/linux/usermode_driver.h
+++ b/include/linux/usermode_driver.h
@@ -15,5 +15,7 @@ int umd_load_blob(struct umd_info *info, const void *data, size_t len);
 int umd_unload_blob(struct umd_info *info);
 int fork_usermode_driver(struct umd_info *info);
 void umd_cleanup_helper(struct umd_info *info);
+int umd_send_recv(struct umd_info *info, void *in, size_t in_len, void *out,
+		  size_t out_len);
 
 #endif /* __LINUX_USERMODE_DRIVER_H__ */
diff --git a/kernel/usermode_driver.c b/kernel/usermode_driver.c
index 8303f4c7ca7..cdbfaad99d7 100644
--- a/kernel/usermode_driver.c
+++ b/kernel/usermode_driver.c
@@ -188,4 +188,49 @@ int fork_usermode_driver(struct umd_info *info)
 }
 EXPORT_SYMBOL_GPL(fork_usermode_driver);
 
-
+/**
+ * umd_send_recv - send/receive a message through the pipe
+ * @info: user mode driver info
+ * @in: request message
+ * @in_len: size of @in
+ * @out: reply message
+ * @out_len: size of @out
+ *
+ * Send a message to the user space process through the created pipe and read
+ * the reply. Partial reads and writes are supported.
+ *
+ * Return: Zero on success, -EFAULT otherwise.
+ */
+int umd_send_recv(struct umd_info *info, void *in, size_t in_len, void *out,
+		  size_t out_len)
+{
+	loff_t pos, offset;
+	ssize_t n;
+
+	if (!info->tgid)
+		return -EFAULT;
+	pos = 0;
+	offset = 0;
+	while (in_len) {
+		n = kernel_write(info->pipe_to_umh, in + offset, in_len, &pos);
+		if (n <= 0) {
+			pr_err("write fail %zd\n", n);
+			return -EFAULT;
+		}
+		in_len -= n;
+		offset += n;
+	}
+	pos = 0;
+	offset = 0;
+	while (out_len) {
+		n = kernel_read(info->pipe_from_umh, out + offset, out_len, &pos);
+		if (n <= 0) {
+			pr_err("read fail %zd\n", n);
+			return -EFAULT;
+		}
+		out_len -= n;
+		offset += n;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(umd_send_recv);
diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 422ec6e7ccf..17d4df5f8fe 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -25,40 +25,6 @@ static void shutdown_umh(void)
 	}
 }
 
-static void __stop_umh(void)
-{
-	if (IS_ENABLED(CONFIG_INET))
-		shutdown_umh();
-}
-
-static int bpfilter_send_req(struct mbox_request *req)
-{
-	struct mbox_reply reply;
-	loff_t pos = 0;
-	ssize_t n;
-
-	if (!bpfilter_ops.info.tgid)
-		return -EFAULT;
-	pos = 0;
-	n = kernel_write(bpfilter_ops.info.pipe_to_umh, req, sizeof(*req),
-			   &pos);
-	if (n != sizeof(*req)) {
-		pr_err("write fail %zd\n", n);
-		goto stop;
-	}
-	pos = 0;
-	n = kernel_read(bpfilter_ops.info.pipe_from_umh, &reply, sizeof(reply),
-			&pos);
-	if (n != sizeof(reply)) {
-		pr_err("read fail %zd\n", n);
-		goto stop;
-	}
-	return reply.status;
-stop:
-	__stop_umh();
-	return -EFAULT;
-}
-
 static int bpfilter_process_sockopt(struct sock *sk, int optname,
 				    sockptr_t optval, unsigned int optlen,
 				    bool is_set)
@@ -70,16 +36,27 @@ static int bpfilter_process_sockopt(struct sock *sk, int optname,
 		.addr		= (uintptr_t)optval.user,
 		.len		= optlen,
 	};
+	struct mbox_reply reply;
+	int err;
+
 	if (sockptr_is_kernel(optval)) {
 		pr_err("kernel access not supported\n");
 		return -EFAULT;
 	}
-	return bpfilter_send_req(&req);
+	err = umd_send_recv(&bpfilter_ops.info, &req, sizeof(req), &reply,
+			    sizeof(reply));
+	if (err) {
+		shutdown_umh();
+		return err;
+	}
+
+	return reply.status;
 }
 
 static int start_umh(void)
 {
 	struct mbox_request req = { .pid = current->pid };
+	struct mbox_reply reply;
 	int err;
 
 	/* fork usermode process */
@@ -89,7 +66,8 @@ static int start_umh(void)
 	pr_info("Loaded bpfilter_umh pid %d\n", pid_nr(bpfilter_ops.info.tgid));
 
 	/* health check that usermode process started correctly */
-	if (bpfilter_send_req(&req) != 0) {
+	if (umd_send_recv(&bpfilter_ops.info, &req, sizeof(req), &reply,
+			  sizeof(reply)) != 0 || reply.status != 0) {
 		shutdown_umh();
 		return -EFAULT;
 	}
-- 
2.25.1

