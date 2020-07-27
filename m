Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9176A22F502
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgG0QZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbgG0QZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:25:36 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713E9C0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s16so12648020qtn.7
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m74gINJk0o2yzV3Cw9JKpr2KF9pTOOCvx6qXl5Iu/vg=;
        b=dtR9T8mdGLI8E9i+4pFa9xh5+Om67FJCDxJx+9umnUhXDzD3A9Yhrn7iZwOae0sKx4
         GNXkmCs9eA9FpQEsicd52sMEFwQNn96OlDW4u7u2TYELLCl9LYyU0/XOchka1pE1/kza
         JBTCuxVSG1RGs5eCD+olldQt/17GFoOHyF8mRFedSGD0N3xfUATEcIPxAjy/VgD7hWiq
         Jdo24KxLxDuebkauHPT4wOxgv84IfzOWwhr8OYBamP0FUzS6pQ1OJl9TR6lVFueoqBpx
         1qrq+BcLbcDH9EwZwlkJJOSekr5OBjbU1ZYizr5/e3hzv00+yfQE0uoOHHvkvlrv6vl7
         PCYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m74gINJk0o2yzV3Cw9JKpr2KF9pTOOCvx6qXl5Iu/vg=;
        b=Pbjy3QebCIu03GQPx0piKRj00k7sjABp1wQDVYar+MqDn8AbZQDqgWSKSj9UpJCpHL
         4TSoe9DFHYFB7OMh7iN61x7iCqmUR/S3OxebAAcBbbQmHd2sCgwCiV8xcLU7ra8W2Paj
         VPMN1rtgu0/+XHo9eRhuw/ZarXVGqEM3N4UI4UTGo4XKYJjGLth5PkHNrufTTCh2c3qp
         rkASHXYLW+r6p8eLvZ92/jEOJLrUw/3iEg6rlb5U661whewz0uiz0uMQMbv1z85RXMtM
         UMvNtKbv2wUsqeQtvFObdfyQkSCpNiqQH8JD44inWqXwI1ULmkw5JayPZzOYn6GjGji6
         207w==
X-Gm-Message-State: AOAM532zgGCps3gCXhH0zV+YBLOLBZU1D6oyIVGPMDmdTWnkjCPC32M+
        lI8tD43KD2SrjoppgLEa48w8LxXY
X-Google-Smtp-Source: ABdhPJxNZYVopQtzevVbTge52UyVu1BrBQ8Ar5E6JezSlCEPsoQWzqG9OAU99tG06wYGCUsBWt+8gw==
X-Received: by 2002:ac8:3fcf:: with SMTP id v15mr23008974qtk.274.1595867135578;
        Mon, 27 Jul 2020 09:25:35 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id o37sm16764529qte.9.2020.07.27.09.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:25:35 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 3/4] selftests/net: so_txtime: fix clang issues for target arch PowerPC
Date:   Mon, 27 Jul 2020 12:25:30 -0400
Message-Id: <20200727162531.4089654-4-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
References: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

On powerpcle, int64_t maps to long long. Clang 9 threw:
warning: absolute value function 'labs' given an argument of type \
'long long' but has parameter of type 'long' which may cause \
truncation of value [-Wabsolute-value]
        if (labs(tstop - texpect) > cfg_variance_us)

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: af5136f95045 ("selftests/net: SO_TXTIME with ETF and FQ")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/so_txtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index ceaad78e9667..3155fbbf644b 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -121,7 +121,7 @@ static bool do_recv_one(int fdr, struct timed_send *ts)
 	if (rbuf[0] != ts->data)
 		error(1, 0, "payload mismatch. expected %c", ts->data);
 
-	if (labs(tstop - texpect) > cfg_variance_us)
+	if (llabs(tstop - texpect) > cfg_variance_us)
 		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
 
 	return false;
-- 
2.28.0.rc0.142.g3c755180ce-goog

