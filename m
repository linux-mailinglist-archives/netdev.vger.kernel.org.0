Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C53868C90E
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBFV6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBFV6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:58:31 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517A32E0D9
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:58:30 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y2so4990050iot.4
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 13:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fEJkg3vFsPDsEc2uUA+I0qUb7SDToyzc2fbeGRQ3Xkw=;
        b=wREIB52x7Gj4i8qeOALr/ssoKrPwfhniYRcBc6Uh6V1MmEK1evW2v1m4ZVXiQs15JJ
         T8yeV0lrc3+XZoSsfo5ocGpJ+VjPpUJWm3lqBfrzVkJ7SlJ40je6noq6B0vAVfcSfyvN
         1PTDy75YjKhQBymCUkeBPEIGTfyjyK0lf7Pbkso/Mm6DvMEsgTHmTycgHrQxiUa/l7Vi
         x66OVhSg1W1xmAs1OyBgAhgyIsv7G64By7yCD55yeUvhVSgSGm/9ndHN4OFT4iQBWlVC
         6kE65UBTjBOPqKBeGOrP/H1zDkKM9Hb1oJD4B+9s0++hAKgKV4fc55SvOM1d5zoNqGsp
         8fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fEJkg3vFsPDsEc2uUA+I0qUb7SDToyzc2fbeGRQ3Xkw=;
        b=joF0b8YO2hyHJOfij724oQZzrDNI85EMF/nk39irCB0jwzsipDF3D67n6vstj1LP+r
         tnQkBKj0E/VlFxdFt0QOKUOOe3sFaXeRyqpHqAT8GEJOYYXUo2iKtvfMXTgHexA7u+wj
         oZG1cqeZwBLiE8Vmt5frWXbbf9cbbWWoy/fa+wuSiOo7b9P+zD5rnToJc6qpckRX4HxE
         FXyvQuUXExY243okHggbRkRvF33cwzy0o7D17ZmLpDUXpZGCq8om3zr6SIw2l4Sf896c
         CYMDJVonp/MIW5sXd+jo36wf36zQkufBz9hmQfHQrRT0c5RB+8IZods76vVYp/mHclc0
         tjqA==
X-Gm-Message-State: AO0yUKXpuFXTpyUIkOF8PIfpOdgcn9WxGjastTrkQObUDxSM9720NOMF
        Cl45YMfaBb5NQ7vajLElezn3rw==
X-Google-Smtp-Source: AK7set/KwkWdqhwJl4TGWqMcSEKusrowg3HqumL7HuG+l7md0d8zHZvN/ZZM2krcBcTT8iE/80as6Q==
X-Received: by 2002:a6b:ed05:0:b0:716:8f6a:f480 with SMTP id n5-20020a6bed05000000b007168f6af480mr467293iog.0.1675720709379;
        Mon, 06 Feb 2023 13:58:29 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x11-20020a0566022c4b00b00724768be183sm3313927iov.13.2023.02.06.13.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 13:58:28 -0800 (PST)
Message-ID: <24add543-e230-7eca-e96b-7253f620b570@kernel.dk>
Date:   Mon, 6 Feb 2023 14:58:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        v9fs-developer@lists.sourceforge.net
References: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
 <Y99+yzngN/8tJKUq@codewreck.org>
 <ad133b58-9bc1-4da9-73a2-957512e3e162@kernel.dk>
 <Y+F0KrAmOuoJcVt/@codewreck.org>
 <00a0809e-7b47-c43c-3a13-a84cd692f514@kernel.dk>
In-Reply-To: <00a0809e-7b47-c43c-3a13-a84cd692f514@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Sorry I didn't develop that idea; the signal path resets the pending
>> signal when we're done, I assumed we could also reset the TWA_SIGNAL
>> flag when we're done flushing. That might take a while though, so it's
>> far from optimal.
> 
> Sure, if you set it again when done, then it will probably work just
> fine. But you need to treat TIF_NOTIFY_SIGNAL and TIF_SIGPENDING
> separately. An attempt at that at the end of this email, totally
> untested, and I'm not certain it's a good idea at all (see below). Is
> there a reason why we can't exit and get the task_work processed
> instead? That'd be greatly preferable.
Forgot to include it, but as mentioned, don't think it's a sane idea...


diff --git a/net/9p/client.c b/net/9p/client.c
index 622ec6a586ee..e4ff2773e00b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -652,6 +652,33 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	return ERR_PTR(err);
 }
 
+static void p9_clear_sigpending(int *sigpending, int *notifypending)
+{
+	if (signal_pending(current)) {
+		*sigpending = test_thread_flag(TIF_SIGPENDING);
+		if (*sigpending)
+			clear_thread_flag(TIF_SIGPENDING);
+		*notifypending = test_thread_flag(TIF_NOTIFY_SIGNAL);
+		if (*notifypending)
+			clear_thread_flag(TIF_NOTIFY_SIGNAL);
+	} else {
+		*sigpending = *notifypending = 0;
+	}
+}
+
+static void p9_reset_sigpending(int sigpending, int notifypending)
+{
+	unsigned long flags;
+
+	if (sigpending) {
+		spin_lock_irqsave(&current->sighand->siglock, flags);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	}
+	if (notifypending)
+		set_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL);
+}
+
 /**
  * p9_client_rpc - issue a request and wait for a response
  * @c: client session
@@ -665,8 +692,7 @@ static struct p9_req_t *
 p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 {
 	va_list ap;
-	int sigpending, err;
-	unsigned long flags;
+	int sigpending, notifypending, err;
 	struct p9_req_t *req;
 	/* Passing zero for tsize/rsize to p9_client_prepare_req() tells it to
 	 * auto determine an appropriate (small) request/response size
@@ -687,12 +713,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	req->tc.zc = false;
 	req->rc.zc = false;
 
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	} else {
-		sigpending = 0;
-	}
+	p9_clear_sigpending(&sigpending, &notifypending);
 
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
@@ -714,8 +735,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 
 	if (err == -ERESTARTSYS && c->status == Connected &&
 	    type == P9_TFLUSH) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
+		p9_clear_sigpending(&sigpending, &notifypending);
 		goto again;
 	}
 
@@ -725,8 +745,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	}
 	if (err == -ERESTARTSYS && c->status == Connected) {
 		p9_debug(P9_DEBUG_MUX, "flushing\n");
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
+		p9_clear_sigpending(&sigpending, &notifypending);
 
 		if (c->trans_mod->cancel(c, req))
 			p9_client_flush(c, req);
@@ -736,11 +755,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 			err = 0;
 	}
 recalc_sigpending:
-	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
+	p9_reset_sigpending(sigpending, notifypending);
 	if (err < 0)
 		goto reterr;
 
@@ -773,8 +788,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 					 const char *fmt, ...)
 {
 	va_list ap;
-	int sigpending, err;
-	unsigned long flags;
+	int sigpending, notifypending, err;
 	struct p9_req_t *req;
 
 	va_start(ap, fmt);
@@ -789,12 +803,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	req->tc.zc = true;
 	req->rc.zc = true;
 
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	} else {
-		sigpending = 0;
-	}
+	p9_clear_sigpending(&sigpending, &notifypending);
 
 	err = c->trans_mod->zc_request(c, req, uidata, uodata,
 				       inlen, olen, in_hdrlen);
@@ -810,8 +819,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	}
 	if (err == -ERESTARTSYS && c->status == Connected) {
 		p9_debug(P9_DEBUG_MUX, "flushing\n");
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
+		p9_clear_sigpending(&sigpending, &notifypending);
 
 		if (c->trans_mod->cancel(c, req))
 			p9_client_flush(c, req);
@@ -821,11 +829,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 			err = 0;
 	}
 recalc_sigpending:
-	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
+	p9_reset_sigpending(sigpending, notifypending);
 	if (err < 0)
 		goto reterr;
 

-- 
Jens Axboe


