Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708AC689ECC
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjBCQEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjBCQEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:04:33 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27F09E9F0
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:04:30 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n13so5651724plf.11
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 08:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zK9eYlTE134Ongv7tYVDXtUJ3WbDMm6sY8qBuuitrdk=;
        b=K/34GIjojnqdexrsSJ1JNVcCtkumCejh0Nl2yqTxL8cLRUG9hESBZZbZZVpJ4K4K3C
         aE2bVR7RSbFS2zcMDAW6Ca50Q6nybGP4vsW6DL6iMP9r6NZvnudRnx1WEdKw8MX+GRR7
         ZibTu7Q97qU0Wb6jdoTzG6TXv30W5npqX7zyL38eombPjeehedG/b84LI0jy59YitdE6
         bzN0LaBj1+UmUVG3nwh9CkxqhxYGVLsvdA7NaH2Qv25I+dfvS/2ney2TA2xpbLCaZjoM
         WwMwiPwf34oQOdOjbSgRPtzFiG9M6PBISan6Ip2/xcQNJwpgBsfwqKkeQnf6P9coHut1
         u32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zK9eYlTE134Ongv7tYVDXtUJ3WbDMm6sY8qBuuitrdk=;
        b=mFkqHQHgmGjbLqebwFwI5UC8ArOHMW91V/NIzIrsNHTgXgOiLlmGYQDfCAj7Jm2QQC
         t8bgQfamdyEorKI0HzGjxX3KP0sCdQE3sHoC5QVSln76CAqWyHQKzf3uoV/ABr5mjWsS
         q7YoZbAynEdk8fU3ZbqdXyRcKiHhR0RLfxOWJXlwA8j5kxlNg4Q0qQ7nxcHIiy5SP86C
         yHCPGq49JrqmjhA3npUDEcqrTDOXo0ag8DU4xoIVT7M8lCHH9RyDZwgDOAZtsshW7hNd
         cevFvK3YmAgJckVtVuA2fIzC6OugT1pGz/4qSyMe8CCyqqIHqY/vCRjlTp4DBiW6v8SG
         w6Cw==
X-Gm-Message-State: AO0yUKXxBt2VcZIE0ymxlCFVOttzZj9aMzZYmabptaGiIiDK/RprG3m0
        +WcHQCIULREho6pFOniNk+Wt9/xEJggtFiIt
X-Google-Smtp-Source: AK7set/ck/VXOrydpoOTlkFRFCz2wQZ6hoZSLs1shEElczv9Q8+j3PFdWJetEqX0nGZZ2i8HkHz1kg==
X-Received: by 2002:a17:902:d481:b0:196:8d96:dc6b with SMTP id c1-20020a170902d48100b001968d96dc6bmr12391998plg.2.1675440269887;
        Fri, 03 Feb 2023 08:04:29 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001948107490csm1792224plk.19.2023.02.03.08.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 08:04:29 -0800 (PST)
Message-ID: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
Date:   Fri, 3 Feb 2023 09:04:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Pengfei Xu <pengfei.xu@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
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

Move the signal_pending() logic into a helper that deals with both, and
return -ERESTARTSYS if the reason for signal_pendding() being true is
that we have task_work to process.

Link: https://lore.kernel.org/lkml/Y9TgUupO5C39V%2FDW@xpf.sh.intel.com/
Reported-and-tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: don't rely on task_work_run(), rather just punt with -ERESTARTYS at
    that point. For one, we don't want to export task_work_run(), it's
    in-kernel only. And secondly, we need to ensure we have a sane state
    before running task_work. The latter did look fine before, but this
    should be saner. Tested this also fixes the report as well for me.

diff --git a/net/9p/client.c b/net/9p/client.c
index 622ec6a586ee..9caa66cbd5b7 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -652,6 +652,25 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	return ERR_PTR(err);
 }
 
+static int p9_sigpending(int *sigpending)
+{
+	*sigpending = 0;
+
+	if (!signal_pending(current))
+		return 0;
+
+	/*
+	 * If we have a TIF_NOTIFY_SIGNAL pending, abort to get it
+	 * processed.
+	 */
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		return -ERESTARTSYS;
+
+	*sigpending = 1;
+	clear_thread_flag(TIF_SIGPENDING);
+	return 0;
+}
+
 /**
  * p9_client_rpc - issue a request and wait for a response
  * @c: client session
@@ -687,12 +706,9 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	req->tc.zc = false;
 	req->rc.zc = false;
 
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	} else {
-		sigpending = 0;
-	}
+	err = p9_sigpending(&sigpending);
+	if (err)
+		goto reterr;
 
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
@@ -789,12 +805,9 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	req->tc.zc = true;
 	req->rc.zc = true;
 
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	} else {
-		sigpending = 0;
-	}
+	err = p9_sigpending(&sigpending);
+	if (err)
+		goto reterr;
 
 	err = c->trans_mod->zc_request(c, req, uidata, uodata,
 				       inlen, olen, in_hdrlen);

-- 
Jens Axboe

