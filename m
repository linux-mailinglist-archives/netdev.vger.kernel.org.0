Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51F32A29B5
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgKBLp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgKBLpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:24 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB603C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:23 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id s9so14197891wro.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L/1dSfgUmYvSGxjXScyhjjkeJuw81QdOwZR7q6CVPfI=;
        b=Qfj7amzDD6qRJfpPj7Kfaq0RN6Zfebg5cL2Y5QirGcThPfy/GdFzJEUlIhkxCxX2ej
         8pN7J4WvJOwj2EX1YIXsel0XOyS7xvbsXCqRUU8ayU75Tezo1KQrxJOTXpJy/hQO79E1
         oqSrIE3cAwDY1I1OIP13gFP8y6Uj8eXiTOATnEPNU3NGd2BPhxv4lSaZ0jNaFYRWR7ay
         8PWlbSnokPxIRKb65tQC6IilvYeK8TDXUsNyKweT3tHgHpR+av+NhFWPQ39ThGcxTOmT
         aTCWSVNnZjc+4XSbqT/GXi7K2XrQ2Mmg/Jlur8r52OQojB1NMrzx1Oab4Lvt92n9ri+a
         FjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L/1dSfgUmYvSGxjXScyhjjkeJuw81QdOwZR7q6CVPfI=;
        b=a1CWD/r2js4Zikg8xLnDddTNdBj0gSeMYIhIPfW8gQdF87nL4Nxg6xPNSVrUAy3BoF
         0IE0CdzYOu3hnqxneawGUJb906rOB8uEEZAzUjjL0Ekz2FYJP3K8W8jWNbdXRrqX4RMW
         2JHQOvhlMgU1Va8u5xaoVjzmvxb8nE2R1ZaXSbkrQTlxzB0efA1fNwSn8j+DMX7vGVeC
         PsENtrXjSLFhqT/r3EDGxggNyo5vp1QlYpCoRnuTcsx2dfCScbQC9DEHCKMSQWDuGVur
         Qe/TujCW2PqA9i7AIcM5SABafe+QTZ5RE7qXX6FgJZiVdc7nOF82jFMMUC4HtN/uGEx8
         hgcw==
X-Gm-Message-State: AOAM5332u7nz7ebBtA2cLQCDCRuuALc2qvjAKTo3rzLI1caCqLNLK617
        WrgcQFWVho4LCt4xZSbnX3Cz0Q==
X-Google-Smtp-Source: ABdhPJymAryJsxD86HRxteYOWKeQkGtIsslWIMb5neTnqMW+04ZCVn6ueDBGgX/iA9uK4VJVtgok4g==
X-Received: by 2002:adf:f74e:: with SMTP id z14mr19575382wrp.312.1604317522365;
        Mon, 02 Nov 2020 03:45:22 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:21 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 01/30] net: fddi: skfp: ecm: Protect 'if' when AIX_EVENT is not defined
Date:   Mon,  2 Nov 2020 11:44:43 +0000
Message-Id: <20201102114512.1062724-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When AIX_EVENT is not defined, the 'if' body will be empty, which
makes GCC complain.  Place bracketing around the invocation to protect
it.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/ecm.c: In function ‘ecm_fsm’:
 drivers/net/fddi/skfp/ecm.c:153:29: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/ecm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/ecm.c b/drivers/net/fddi/skfp/ecm.c
index 15c503f43727b..97f3efd5eb13c 100644
--- a/drivers/net/fddi/skfp/ecm.c
+++ b/drivers/net/fddi/skfp/ecm.c
@@ -147,10 +147,11 @@ static void ecm_fsm(struct s_smc *smc, int cmd)
 	/* For AIX event notification: */
 	/* Is a disconnect  command remotely issued ? */
 	if (cmd == EC_DISCONNECT &&
-		smc->mib.fddiSMTRemoteDisconnectFlag == TRUE)
+	    smc->mib.fddiSMTRemoteDisconnectFlag == TRUE) {
 		AIX_EVENT (smc, (u_long) CIO_HARD_FAIL, (u_long)
 			FDDI_REMOTE_DISCONNECT, smt_get_event_word(smc),
 			smt_get_error_word(smc) );
+	}
 
 	/*jd 05-Aug-1999 Bug #10419 "Port Disconnect fails at Dup MAc Cond."*/
 	if (cmd == EC_CONNECT) {
-- 
2.25.1

