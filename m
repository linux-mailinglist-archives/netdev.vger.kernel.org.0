Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DE01D1EC0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390528AbgEMTOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387469AbgEMTOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:14:21 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAD1C061A0C;
        Wed, 13 May 2020 12:14:21 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so305611ioq.5;
        Wed, 13 May 2020 12:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=43Hlxsx5pxHjZmNmr0yvURFfUClaHM8PF0aTQc8wlNM=;
        b=k3vI+2azbPnj3DbZGU9yjYpuIupiUxkA7R6175hurZuv2bW4WIg1t9N2DZThveoab+
         CJmQ3f6UKEf2aH/EHtX5cZamFBKTEVjzwZOMInbracXKP/4pSgD6AVCe6gfilI1CMe7z
         zO+xlkSdwtbq+ef5frg9840XTQdpjCsDhBHgAC5J5UUo842ovNVcTbW6uDoMyPQAz53D
         6XnWmBmOqkwfYHuOxdgWQPRQml6xfs+TxLGtFsTbuNIToGchpHL06Bn+EzoV6Myhlc/s
         RhC7YcMmRIpqA3U2md8Au40HUSGYliB5FbWzvP7ZxiCAkkUe0+Mwd7ZsfFTIP2SxgcH+
         SIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=43Hlxsx5pxHjZmNmr0yvURFfUClaHM8PF0aTQc8wlNM=;
        b=q3RONWIk8J0r187n8b0AQies4KLGBE02xGE+PJm6BEIovd9Chat1EbshwJPJm2YZIh
         txi3B6lHpdz+MDUrRguFotr17JwOUAcNhaCRjupnXNo5QWmKnRPo78tPhWDMtRl04p5q
         qwnUpKMi5Ot2W+uZRJL8L/wM8hoxXiPeg+OOxByB7gunVN9FnuLbulRfSlOjqAKXeTIo
         i4qcfDVFYQ6qTkEFXyW+zyyuptyv+XJwe0XlxEyBwEzS6XeePp8xqW/kCrBaXPZZSCye
         kFEL7nKxvOxk0uNSWYYTVzMI/sH6UFG7jB9L9dGbhcesct+JZTzwM/mLBAKPRJRrFGFc
         yfCw==
X-Gm-Message-State: AGi0PuZ7UnjEuw+mAhWmXJ4NZTltqsjnZ18yVYJjUBvajmrqIUlc7+Tb
        SWdOa8k6J9IQ6wLjIgTdxl0=
X-Google-Smtp-Source: APiQypKGJDfmzZyB1XXwi9nyiPO8avdG+uRevH+BBvr01LgPaH4VJfSK8+cu3OVInbB2vRfh0f3LuA==
X-Received: by 2002:a02:a608:: with SMTP id c8mr982869jam.95.1589397259544;
        Wed, 13 May 2020 12:14:19 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a6sm211255ioe.10.2020.05.13.12.14.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:14:18 -0700 (PDT)
Subject: [bpf-next PATCH v2 06/12] bpf: selftests,
 print error in test_sockmap error cases
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:14:05 -0700
Message-ID: <158939724566.15176.12079885932643225626.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
References: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its helpful to know the error value if an error occurs.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 5ef71fe..7f45a8f 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -341,14 +341,18 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
 
 	clock_gettime(CLOCK_MONOTONIC, &s->start);
 	for (i = 0; i < cnt; i++) {
-		int sent = sendfile(fd, fp, NULL, iov_length);
+		int sent;
+
+		errno = 0;
+		sent = sendfile(fd, fp, NULL, iov_length);
 
 		if (!drop && sent < 0) {
-			perror("send loop error");
+			perror("sendpage loop error");
 			fclose(file);
 			return sent;
 		} else if (drop && sent >= 0) {
-			printf("sendpage loop error expected: %i\n", sent);
+			printf("sendpage loop error expected: %i errno %i\n",
+			       sent, errno);
 			fclose(file);
 			return -EIO;
 		}
@@ -460,13 +464,18 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 	if (tx) {
 		clock_gettime(CLOCK_MONOTONIC, &s->start);
 		for (i = 0; i < cnt; i++) {
-			int sent = sendmsg(fd, &msg, flags);
+			int sent;
+
+			errno = 0;
+			sent = sendmsg(fd, &msg, flags);
 
 			if (!drop && sent < 0) {
-				perror("send loop error");
+				perror("sendmsg loop error");
 				goto out_errno;
 			} else if (drop && sent >= 0) {
-				printf("send loop error expected: %i\n", sent);
+				fprintf(stderr,
+					"sendmsg loop error expected: %i errno %i\n",
+					sent, errno);
 				errno = -EIO;
 				goto out_errno;
 			}
@@ -690,14 +699,14 @@ static int sendmsg_test(struct sockmap_options *opt)
 	if (WIFEXITED(rx_status)) {
 		err = WEXITSTATUS(rx_status);
 		if (err) {
-			fprintf(stderr, "rx thread exited with err %d. ", err);
+			fprintf(stderr, "rx thread exited with err %d.\n", err);
 			goto out;
 		}
 	}
 	if (WIFEXITED(tx_status)) {
 		err = WEXITSTATUS(tx_status);
 		if (err)
-			fprintf(stderr, "tx thread exited with err %d. ", err);
+			fprintf(stderr, "tx thread exited with err %d.\n", err);
 	}
 out:
 	return err;

