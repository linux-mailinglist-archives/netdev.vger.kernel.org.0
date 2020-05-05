Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD341C625A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgEEUvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgEEUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:51:08 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80418C061A0F;
        Tue,  5 May 2020 13:51:08 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id m5so3608696ilj.10;
        Tue, 05 May 2020 13:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=03Ds9j63XQEQ3+m0+VRXQrj1d0Kc5B7oDJcmSK0dgEI=;
        b=tNP93k/S4/6cZiTmobEHmBFDySyvMkFLkKuRkfuYEcQQbxSf3sBFx7vH3LAw+q7gXJ
         OUkQ4rut12PDFOyWW7TA5P0n+P1o9vuIdQiY4hKS3jbhqkIubh1WGWlqgtS9bhkLgtuA
         XdCTW9JWqPuSe7/ThQkKfqX5NvRK/DUXEEBsefgSdOrVCNat+DKLpf3zp30o1AA1rEZY
         ugwsHonnIgap4N/Fu85r1u9L9LxP23fMkH/1dm6aS24mELQe3OWoBJ+GBhIL+n73hQq4
         ZbFjZQTpwm85ew7Yz0i15kn/mEfU6zq0d26jJ1bcTdy2NO7Azt/quLyPzrWF9mqXgU+/
         0AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=03Ds9j63XQEQ3+m0+VRXQrj1d0Kc5B7oDJcmSK0dgEI=;
        b=mOOH0i9s8152IhHD3OCwRZU/ugOg+Y22JXT6O6qHARXbdNDCcnoSM1d8F8sqLBfK3I
         rhRYQ7eYPKEg00rqi4xauGmP3xrTqum/M3t85l/fWCREXoa1buI55ssaM3KtF6jpKoHk
         qYn9qP156dO3YSl4J57iXYh1weggZZG7bt7HXdb1uqRy0UutdrcaNPGnxqhn5LJA/H5H
         tHDGvubdvywuP9TpdnYHKMbd/4sKw8nPU+AJ2gPl+tzvPtu5V8GkbQ/E0pLNO4UfbRpC
         HkSVB9C+SOfbQz5e08chSyUrjYAPMEA7N4JIhZmrI1V0WrNB0BHG9xeLBbOOwZqDkd24
         FiMg==
X-Gm-Message-State: AGi0PubnIHZeXcm9AEbFi926oiFwsSRp/aVHRS3L85hQOO7s9ad06ygA
        HNYrjaTsVhrHkkrzz3FF7fc=
X-Google-Smtp-Source: APiQypLqVy0tx97IOBZXEq4PeBpqBW3MQckDNoaTDUc2hoP0uNplyt77m1RMEfKK8uKuFitEmYzsnA==
X-Received: by 2002:a05:6e02:111:: with SMTP id t17mr5314560ilm.59.1588711867911;
        Tue, 05 May 2020 13:51:07 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h15sm2054228ior.20.2020.05.05.13.50.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:51:07 -0700 (PDT)
Subject: [bpf-next PATCH 04/10] bpf: selftests,
 print error in test_sockmap error cases
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:50:53 -0700
Message-ID: <158871185376.7537.4984997092745221064.stgit@john-Precision-5820-Tower>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its helpful to know the error value if an error occurs.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index a0884f8..a81ed5d 100644
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

