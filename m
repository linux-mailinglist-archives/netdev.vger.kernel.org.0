Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD836566C4
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 03:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiL0C0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 21:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiL0CZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 21:25:50 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD5363EA
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s7so12036741plk.5
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fw1zp7wA+/zxFPe9++9b6RsIhQH1xDXghkXPllMc2n4=;
        b=dmWwqELbw9ZEZJgxhlpTM+I5eJSOq6C0nFb5niSwcy+brkJPLb+pRruGiewMtfgDy0
         2oJIziVqszQ+rxkD9M5cwMVDrHvNPdGobcuqb5wAn82QLAgLTY+3D1/E9vrnBCKmbeBE
         9a/C42/KBck+uafJDNlqi5zgPfinCVzdFwi4TG+k0LNp/Gpipdh9qDEx4LlDkwaB0KQQ
         +zhSi6OeBCysEmrmdkIPZTB/VyzpBkG0llnLRrh81f2yZGFAj5C1AalYPVt8VUV1/Jly
         G9+38kJdlTzpEUR9XRGePMeUlp4klYV8MER19PSJK5ijva9L8gzowcBInyZboJpIXxlN
         ay6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fw1zp7wA+/zxFPe9++9b6RsIhQH1xDXghkXPllMc2n4=;
        b=UGMKJXZGDpIo/e6jmqs0gx4mzil+mbXM0p3D7YJIxx5oEDj8WU26f8HATf+B29YcFZ
         vojzgtTS205lvuDHB8sqK3Uz4Di8EdzA+EQci0Kb18aevrdTj5WUJr7Nv5tzvq/q01Yn
         0/7vAZwAlXo2AFGZZgTOkp6rAdI4oGFyCcdYkKw+WaaL8cMFRzVeG4EWKxVQ4glDBvpe
         l6/kauHdhM7BXlzT+h+51W88z2jdlIGkOq4flxFHP9s6rTCO3sCzRfUBOH/cm3XanzqK
         3zfSvLUCQ7b+P6+rMeMWYfqG50EonAaHMMWmNUD8+g3BJwEDHAWR+Z3g2iR5PSh9+c7d
         tQ5Q==
X-Gm-Message-State: AFqh2kqfvWI+OHIAc8WtavCS1/RMyc5iHjlovTrYytbx279bE6yRTxCs
        Nt+wpoQdEBUFUkqqT/TmQNN4YA==
X-Google-Smtp-Source: AMrXdXthXoQLGifDOmu5LuHbRt/+6ge15hO72pdWQm3ohBcfdoG9AvdFFZDLqr/g0rDj9Oi6RbKKmQ==
X-Received: by 2002:a17:902:a582:b0:192:52d7:b574 with SMTP id az2-20020a170902a58200b0019252d7b574mr17963636plb.63.1672107947993;
        Mon, 26 Dec 2022 18:25:47 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b001870dc3b4c0sm2465014plk.74.2022.12.26.18.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 18:25:47 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH 5/9] tools/virtio: convert to use new unified vringh APIs
Date:   Tue, 27 Dec 2022 11:25:27 +0900
Message-Id: <20221227022528.609839-6-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221227022528.609839-1-mie@igel.co.jp>
References: <20221227022528.609839-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vringh_*_user APIs is being removed without vringh_init_user(). so change
to use new APIs.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 tools/virtio/vringh_test.c | 89 +++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 6c9533b8a2ca..068c6d5aa4fd 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -187,7 +187,7 @@ static int parallel_test(u64 features,
 
 		vring_init(&vrh.vring, RINGSIZE, host_map, ALIGN);
 		vringh_init_user(&vrh, features, RINGSIZE, true,
-				 vrh.vring.desc, vrh.vring.avail, vrh.vring.used);
+				 vrh.vring.desc, vrh.vring.avail, vrh.vring.used, getrange);
 		CPU_SET(first_cpu, &cpu_set);
 		if (sched_setaffinity(getpid(), sizeof(cpu_set), &cpu_set))
 			errx(1, "Could not set affinity to cpu %u", first_cpu);
@@ -202,9 +202,9 @@ static int parallel_test(u64 features,
 					err = vringh_get_head(&vrh, &head);
 					if (err != 0)
 						break;
-					err = vringh_need_notify_user(&vrh);
+					err = vringh_need_notify(&vrh);
 					if (err < 0)
-						errx(1, "vringh_need_notify_user: %i",
+						errx(1, "vringh_need_notify: %i",
 						     err);
 					if (err) {
 						write(to_guest[1], "", 1);
@@ -223,46 +223,45 @@ static int parallel_test(u64 features,
 						host_wiov,
 						ARRAY_SIZE(host_wiov));
 
-				err = vringh_getdesc_user(&vrh, &riov, &wiov,
-							  getrange, &head);
+				err = vringh_getdesc(&vrh, &riov, &wiov, &head);
 			}
 			if (err == 0) {
-				err = vringh_need_notify_user(&vrh);
+				err = vringh_need_notify(&vrh);
 				if (err < 0)
-					errx(1, "vringh_need_notify_user: %i",
+					errx(1, "vringh_need_notify: %i",
 					     err);
 				if (err) {
 					write(to_guest[1], "", 1);
 					notifies++;
 				}
 
-				if (!vringh_notify_enable_user(&vrh))
+				if (!vringh_notify_enable(&vrh))
 					continue;
 
 				/* Swallow all notifies at once. */
 				if (read(to_host[0], buf, sizeof(buf)) < 1)
 					break;
 
-				vringh_notify_disable_user(&vrh);
+				vringh_notify_disable(&vrh);
 				receives++;
 				continue;
 			}
 			if (err != 1)
-				errx(1, "vringh_getdesc_user: %i", err);
+				errx(1, "vringh_getdesc: %i", err);
 
 			/* We simply copy bytes. */
 			if (riov.used) {
-				rlen = vringh_iov_pull_user(&riov, rbuf,
+				rlen = vringh_iov_pull(&vrh, &riov, rbuf,
 							    sizeof(rbuf));
 				if (rlen != 4)
-					errx(1, "vringh_iov_pull_user: %i",
+					errx(1, "vringh_iov_pull: %i",
 					     rlen);
 				assert(riov.i == riov.used);
 				written = 0;
 			} else {
-				err = vringh_iov_push_user(&wiov, rbuf, rlen);
+				err = vringh_iov_push(&vrh, &wiov, rbuf, rlen);
 				if (err != rlen)
-					errx(1, "vringh_iov_push_user: %i",
+					errx(1, "vringh_iov_push: %i",
 					     err);
 				assert(wiov.i == wiov.used);
 				written = err;
@@ -270,14 +269,14 @@ static int parallel_test(u64 features,
 		complete:
 			xfers++;
 
-			err = vringh_complete_user(&vrh, head, written);
+			err = vringh_complete(&vrh, head, written);
 			if (err != 0)
-				errx(1, "vringh_complete_user: %i", err);
+				errx(1, "vringh_complete: %i", err);
 		}
 
-		err = vringh_need_notify_user(&vrh);
+		err = vringh_need_notify(&vrh);
 		if (err < 0)
-			errx(1, "vringh_need_notify_user: %i", err);
+			errx(1, "vringh_need_notify: %i", err);
 		if (err) {
 			write(to_guest[1], "", 1);
 			notifies++;
@@ -493,12 +492,12 @@ int main(int argc, char *argv[])
 	/* Set up host side. */
 	vring_init(&vrh.vring, RINGSIZE, __user_addr_min, ALIGN);
 	vringh_init_user(&vrh, vdev.features, RINGSIZE, true,
-			 vrh.vring.desc, vrh.vring.avail, vrh.vring.used);
+			 vrh.vring.desc, vrh.vring.avail, vrh.vring.used, getrange);
 
 	/* No descriptor to get yet... */
-	err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
+	err = vringh_getdesc(&vrh, &riov, &wiov, &head);
 	if (err != 0)
-		errx(1, "vringh_getdesc_user: %i", err);
+		errx(1, "vringh_getdesc: %i", err);
 
 	/* Guest puts in a descriptor. */
 	memcpy(__user_addr_max - 1, "a", 1);
@@ -520,9 +519,9 @@ int main(int argc, char *argv[])
 	vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
 	vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
-	err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
+	err = vringh_getdesc(&vrh, &riov, &wiov, &head);
 	if (err != 1)
-		errx(1, "vringh_getdesc_user: %i", err);
+		errx(1, "vringh_getdesc: %i", err);
 
 	assert(riov.used == 1);
 	assert(riov.iov[0].iov_base == __user_addr_max - 1);
@@ -539,25 +538,25 @@ int main(int argc, char *argv[])
 		assert(wiov.iov[1].iov_len == 1);
 	}
 
-	err = vringh_iov_pull_user(&riov, buf, 5);
+	err = vringh_iov_pull(&vrh, &riov, buf, 5);
 	if (err != 1)
-		errx(1, "vringh_iov_pull_user: %i", err);
+		errx(1, "vringh_iov_pull: %i", err);
 	assert(buf[0] == 'a');
 	assert(riov.i == 1);
-	assert(vringh_iov_pull_user(&riov, buf, 5) == 0);
+	assert(vringh_iov_pull(&vrh, &riov, buf, 5) == 0);
 
 	memcpy(buf, "bcdef", 5);
-	err = vringh_iov_push_user(&wiov, buf, 5);
+	err = vringh_iov_push(&vrh, &wiov, buf, 5);
 	if (err != 2)
-		errx(1, "vringh_iov_push_user: %i", err);
+		errx(1, "vringh_iov_push: %i", err);
 	assert(memcmp(__user_addr_max - 3, "bc", 2) == 0);
 	assert(wiov.i == wiov.used);
-	assert(vringh_iov_push_user(&wiov, buf, 5) == 0);
+	assert(vringh_iov_push(&vrh, &wiov, buf, 5) == 0);
 
 	/* Host is done. */
-	err = vringh_complete_user(&vrh, head, err);
+	err = vringh_complete(&vrh, head, err);
 	if (err != 0)
-		errx(1, "vringh_complete_user: %i", err);
+		errx(1, "vringh_complete: %i", err);
 
 	/* Guest should see used token now. */
 	__kfree_ignore_start = __user_addr_min + vring_size(RINGSIZE, ALIGN);
@@ -589,9 +588,9 @@ int main(int argc, char *argv[])
 	vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
 	vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
-	err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
+	err = vringh_getdesc(&vrh, &riov, &wiov, &head);
 	if (err != 1)
-		errx(1, "vringh_getdesc_user: %i", err);
+		errx(1, "vringh_getdesc: %i", err);
 
 	assert(riov.max_num & VRINGH_IOV_ALLOCATED);
 	assert(riov.iov != host_riov);
@@ -605,9 +604,9 @@ int main(int argc, char *argv[])
 
 	/* Pull data back out (in odd chunks), should be as expected. */
 	for (i = 0; i < RINGSIZE * USER_MEM/4; i += 3) {
-		err = vringh_iov_pull_user(&riov, buf, 3);
+		err = vringh_iov_pull(&vrh, &riov, buf, 3);
 		if (err != 3 && i + err != RINGSIZE * USER_MEM/4)
-			errx(1, "vringh_iov_pull_user large: %i", err);
+			errx(1, "vringh_iov_pulllarge: %i", err);
 		assert(buf[0] == (char)i);
 		assert(err < 2 || buf[1] == (char)(i + 1));
 		assert(err < 3 || buf[2] == (char)(i + 2));
@@ -619,9 +618,9 @@ int main(int argc, char *argv[])
 	/* Complete using multi interface, just because we can. */
 	used[0].id = head;
 	used[0].len = 0;
-	err = vringh_complete_multi_user(&vrh, used, 1);
+	err = vringh_complete_multi(&vrh, used, 1);
 	if (err)
-		errx(1, "vringh_complete_multi_user(1): %i", err);
+		errx(1, "vringh_complete_multi(1): %i", err);
 
 	/* Free up those descriptors. */
 	ret = virtqueue_get_buf(vq, &i);
@@ -642,17 +641,17 @@ int main(int argc, char *argv[])
 	vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
 	for (i = 0; i < RINGSIZE; i++) {
-		err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
+		err = vringh_getdesc(&vrh, &riov, &wiov, &head);
 		if (err != 1)
-			errx(1, "vringh_getdesc_user: %i", err);
+			errx(1, "vringh_getdesc: %i", err);
 		used[i].id = head;
 		used[i].len = 0;
 	}
 	/* Make sure it wraps around ring, to test! */
 	assert(vrh.vring.used->idx % RINGSIZE != 0);
-	err = vringh_complete_multi_user(&vrh, used, RINGSIZE);
+	err = vringh_complete_multi(&vrh, used, RINGSIZE);
 	if (err)
-		errx(1, "vringh_complete_multi_user: %i", err);
+		errx(1, "vringh_complete_multi: %i", err);
 
 	/* Free those buffers. */
 	for (i = 0; i < RINGSIZE; i++) {
@@ -726,19 +725,19 @@ int main(int argc, char *argv[])
 		vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
 		vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
-		err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
+		err = vringh_getdesc(&vrh, &riov, &wiov, &head);
 		if (err != 1)
-			errx(1, "vringh_getdesc_user: %i", err);
+			errx(1, "vringh_getdesc: %i", err);
 
 		if (head != 0)
-			errx(1, "vringh_getdesc_user: head %i not 0", head);
+			errx(1, "vringh_getdesc: head %i not 0", head);
 
 		assert(riov.max_num & VRINGH_IOV_ALLOCATED);
 		if (getrange != getrange_slow)
 			assert(riov.used == 7);
 		else
 			assert(riov.used == 28);
-		err = vringh_iov_pull_user(&riov, buf, 29);
+		err = vringh_iov_pull(&vrh, &riov, buf, 29);
 		assert(err == 28);
 
 		/* Data should be linear. */
-- 
2.25.1

