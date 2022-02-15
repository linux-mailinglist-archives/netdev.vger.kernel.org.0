Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0D4B60BD
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiBOCGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:06:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiBOCF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:05:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E87D31EC75
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644890748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rcVCDBo5DVaghZVQQl2zbGTyQ7E+laKLLxGgEjqHxnk=;
        b=BsxIUDJ0NFwUiJ43PxEXU25y1vTuIzFDlJT36TVEeYsSeAjix370M3S14x+VeiVImZpYVh
        ybAaCpPtG7IAqjI2MIlyPAfEqj5tohTeDvfW1P383T/n32JInI3MLvmIx6m44mo3fpgB5S
        HGUF20Hn81Et1PA9gKO6PtJYyrlm8GU=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-I8I0kJyHMV60amBYl900tg-1; Mon, 14 Feb 2022 21:05:47 -0500
X-MC-Unique: I8I0kJyHMV60amBYl900tg-1
Received: by mail-oo1-f69.google.com with SMTP id s14-20020a4aa54e000000b002ea553d580eso11709440oom.4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rcVCDBo5DVaghZVQQl2zbGTyQ7E+laKLLxGgEjqHxnk=;
        b=UJ3Vk0NNxkcJyL7EVVf7S9MWf96buWmwF9e3Q/cUiy+CbX4UxaBYQVw24r5MZFE5q6
         olELTBBvCNAuX8IPVEiDQRxS/jVeyn5xGi4Fv10aDGxcHCdl1SfQOjQL04GRIkrgKFuE
         NAu4sjTQXCMAH3kGtb0d0hAXF3Q5XRrPzoBbgjyFrf75Ek9jVg0czh8P3pzK6vJVJuCw
         9FCI3CzhJq9sdCKmfoaCT12czdBLqAtI5LwrPkb1jdYnzJ2MjuKUFtaI5Ou7shV1vQJj
         raa+pQsfBZPC8AOXGWaX1mshfxAhqpDm13hfaUmMAzexkWSIRFFHU6Laau1LflzN4atE
         BRDA==
X-Gm-Message-State: AOAM531nh6+K7zGBmEQ/Spx3SN7zn0r5xsJM5AHenpbMSqBsIejhxvD7
        +bclRwwHFwC6xFlE334Usb8CqO3jzkWF0gJZlb/Ry6R1MboKTR989as9S3GLERWyGh8J4W0PBTK
        DbX6xOo4ajoFckdEo
X-Received: by 2002:a05:6830:4113:: with SMTP id w19mr688310ott.120.1644890746730;
        Mon, 14 Feb 2022 18:05:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEs/cQG7EnoAYBz/PX072UhjyPsRpX8PJZ5Lr3Q9WSLBCh3TgTI0hgly/YAlr42AGrYmPADg==
X-Received: by 2002:a05:6830:4113:: with SMTP id w19mr688302ott.120.1644890746552;
        Mon, 14 Feb 2022 18:05:46 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id r41sm14527325oap.2.2022.02.14.18.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 18:05:46 -0800 (PST)
From:   trix@redhat.com
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] mctp: fix use after free
Date:   Mon, 14 Feb 2022 18:05:41 -0800
Message-Id: <20220215020541.2944949-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this problem
route.c:425:4: warning: Use of memory after it is freed
  trace_mctp_key_acquire(key);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
When mctp_key_add() fails, key is freed but then is later
used in trace_mctp_key_acquire().  Add an else statement
to use the key only when mctp_key_add() is successful.

Fixes: 4f9e1ba6de45 ("mctp: Add tracepoints for tag/key handling")
Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: change the Fixes: line

 net/mctp/route.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 17e3482aa770..0c4c56e1bd6e 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -419,13 +419,14 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * this function.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (rc)
+			if (rc) {
 				kfree(key);
+			} else {
+				trace_mctp_key_acquire(key);
 
-			trace_mctp_key_acquire(key);
-
-			/* we don't need to release key->lock on exit */
-			mctp_key_unref(key);
+				/* we don't need to release key->lock on exit */
+				mctp_key_unref(key);
+			}
 			key = NULL;
 
 		} else {
-- 
2.26.3

