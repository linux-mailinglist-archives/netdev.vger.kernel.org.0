Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7508323106
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhBWSvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhBWSvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:51:12 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8B6C0617A7;
        Tue, 23 Feb 2021 10:49:58 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id r19so9374045otk.2;
        Tue, 23 Feb 2021 10:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZuxsaAAdjPyMNiwNHSVTcTYJyJqi7kExwKRM2p9ugF4=;
        b=rgg8RZkTEWc7Y10zKBUzkvBdEWuqQw8XhA+cxbqtaKmu5e2/A9LmR1a2cO8hZ5mzjc
         vRSVDpJ3dn2/MWGFTIaFROlZF6NlK6UatC0cRSbZWwPRLSlQqJmSbf0B1BsOtw6BHCwG
         +xKlX7roO8qr97z3Nhky3dniMoSWGuC2ZMqg1gQ/DMTLhYMuZAPtUG4ik4kg5TJpkO2b
         pBqA0ZrszlUz3q0bm6p5A0yiIP/5yInpWQKEuViqpSte7r05tMbEL1WvkDKqtcAAfGUp
         VP7p9s79zLoTRZU4tTJeGh1vAHd8BzD3WDlcb7X3O2v2lokMF9GAKzOFtftC5uIxSUNA
         499w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZuxsaAAdjPyMNiwNHSVTcTYJyJqi7kExwKRM2p9ugF4=;
        b=Giu3wt5YmbxY0L03NIRfSK2aBsTUMZ/c61lQiCEdrMDwM/dofRSnsbSKVdDAV4vwM2
         f26k7CSaAtMSlWzBDtAV6yncRvH9XiIF4F1duKUcMIYkmD2YH98vZvcoPR/T/+uTsk+d
         5Y5GwYfUArw2XPfxwG+Yeyhk6cNd3VBaRul4f2M8uFbaR2PwpZJ77sgb0S1B0rb3nrBK
         +MnGhZRJPRWNbJsnllVGqzudeNPHDVVzZFr+oONC5+g1OhdWUJUKybSrep1zrmsh+QkE
         BPhjC1UjLXMBSIG1eTSzlXIEgyWBMWx81J6Bp0VIlG79pp3hsInSVEZ0ty0fqhODvnWB
         f/Dg==
X-Gm-Message-State: AOAM530xDDrp83r9uc2mWbRcL8uV+2kO4P5vyjPJSy8UMg8N1agTPah5
        FkWHiZBAfaF0nhnqvgVsLosRKZAp4WaynQ==
X-Google-Smtp-Source: ABdhPJwfCCcMmcMR2FMh9uF9FOBrZ4QjbXUt6tOHO0BXY2QL4ortwjLbneUXbJ87m6sVIdenLE9mcg==
X-Received: by 2002:a05:6830:1557:: with SMTP id l23mr21838268otp.181.1614106197743;
        Tue, 23 Feb 2021 10:49:57 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:56 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 9/9] skmsg: remove unused sk_psock_stop() declaration
Date:   Tue, 23 Feb 2021 10:49:34 -0800
Message-Id: <20210223184934.6054-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is not defined or used anywhere.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 676d48e08159..6c09d94be2e9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -400,7 +400,6 @@ static inline struct sk_psock *sk_psock_get(struct sock *sk)
 	return psock;
 }
 
-void sk_psock_stop(struct sock *sk, struct sk_psock *psock);
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock);
 
 static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
-- 
2.25.1

