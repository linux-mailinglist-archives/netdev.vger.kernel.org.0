Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4E2689B0C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbjBCOGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbjBCOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:05:17 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F59DA87B4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:02:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so4444181pjp.0
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 06:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RErS5ohp2TI3iFbaUMVuMMHBVNqa35ywvXn39HuDnR0=;
        b=UuFi7oPu0FClAdDhHTGncJnqzmmAK8pxgYqxQoiasUg8bQsEkQKxsgZ2/1Smh8Yff+
         gD9sMDh5s8+mzkyfTpVe7zY9qjLnaRNOkxKtzdE4NANUZ5ujkgvyyrSIu02W5OOGh4wZ
         eZXXkJNfFBP+w0gsvxhOYrzOaCBH8UbIks6Pn3uY3yX5WASp7HNd5dktx95l/1ZFah5c
         AD6GqM7JysVj/TpsVYc+9uF8KBw+O79Gt46dJ7T6Q/KUa6c+eavxya+kIkrICiDbu+H8
         y13pN4TYyDbLh9fsWI/qsXSuSfSgR87d4wGPDJoqfeExTtCqi10WQRyCb+w90Xppi4TF
         eiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RErS5ohp2TI3iFbaUMVuMMHBVNqa35ywvXn39HuDnR0=;
        b=s/wpPWpmlPzHsMGm8ZYfDD2OLfmhS530b6M718bNl7lRENH+wuHr4aLnKWAW/cZ6Rb
         98FOcaioXcpxuzJaQ/1RBhMNXBSODjOiuserqdIg37rJMFEoHoOhNfAc/skV5w3pMvA5
         WJJEIOXgrsBbOmyGxo9j3LtgYDHhoOiSGC/tu61ozDHS/kdONu6hsBpMxr/yTDy8SIzH
         BZTFQKq1uHuALbZ4/4csIke7axptxrImJkrwXFDIWFoj7Zw8Mx6oreILMpktFdBEG0ew
         MYHFhcigbVa0CISg3Db4DByy7rElrtkdMr8t7RAgDXeITvqxXis+QB3qXQ6qhdPbue7I
         vYmw==
X-Gm-Message-State: AO0yUKVAd2PbRQ64vDzNPjQ1/Moeufgn1DWlUrNWzDl5VE7Lxc4DPQa9
        Scka66NG0xKihGzLN7K2bt1lyJdZP5ws13sA
X-Google-Smtp-Source: AK7set8c3N1bPgyMJh+4GI70jJfTqbD+9yEfG1m9MKFI3FV5cj1bHfnhqfY+TgJbn5WF/i/iWcHSwg==
X-Received: by 2002:a17:903:32c6:b0:196:1cc3:74fc with SMTP id i6-20020a17090332c600b001961cc374fcmr12269901plr.4.1675432963664;
        Fri, 03 Feb 2023 06:02:43 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ij29-20020a170902ab5d00b0018c7a5e052asm1644336plb.225.2023.02.03.06.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 06:02:43 -0800 (PST)
Message-ID: <62bcfc44-aef4-2536-a2da-acc8a68286de@kernel.dk>
Date:   Fri, 3 Feb 2023 07:02:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
To:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Pengfei Xu <pengfei.xu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

signal_pending() really means that an exit to userspace is required to
clear the condition, as it could be either an actual signal, or it could
be TWA_SIGNAL based task_work that needs processing. The 9p client
does a recalc_sigpending() to take care of the former, but that still
leaves TWA_SIGNAL task_work. The result is that if we do have TWA_SIGNAL
task_work pending, then we'll sit in a tight loop spinning as
signal_pending() remains true even after recalc_sigpending().

Move the signal_pending() logic into a helper that deals with both.

Link: https://lore.kernel.org/lkml/Y9TgUupO5C39V%2FDW@xpf.sh.intel.com/
Reported-and-tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/net/9p/client.c b/net/9p/client.c
index 622ec6a586ee..7d9b9c150d47 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -18,6 +18,7 @@
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
 #include <linux/uio.h>
+#include <linux/task_work.h>
 #include <net/9p/9p.h>
 #include <linux/parser.h>
 #include <linux/seq_file.h>
@@ -652,6 +653,28 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	return ERR_PTR(err);
 }
 
+static bool p9_sigpending(void)
+{
+	if (!signal_pending(current))
+		return false;
+
+	/*
+	 * signal_pending() could mean either a real signal pending, or
+	 * TWA_SIGNAL based task_work that needs processing. Don't return
+	 * true for just the latter, run and clear it before a wait.
+	 */
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		clear_notify_signal();
+	if (task_work_pending(current))
+		task_work_run();
+	if (signal_pending(current)) {
+		clear_thread_flag(TIF_SIGPENDING);
+		return true;
+	}
+
+	return false;
+}
+
 /**
  * p9_client_rpc - issue a request and wait for a response
  * @c: client session
@@ -687,12 +710,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	req->tc.zc = false;
 	req->rc.zc = false;
 
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	} else {
-		sigpending = 0;
-	}
+	sigpending = p9_sigpending();
 
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
@@ -789,12 +807,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	req->tc.zc = true;
 	req->rc.zc = true;
 
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	} else {
-		sigpending = 0;
-	}
+	sigpending = p9_sigpending();
 
 	err = c->trans_mod->zc_request(c, req, uidata, uodata,
 				       inlen, olen, in_hdrlen);

-- 
Jens Axboe

