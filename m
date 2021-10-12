Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E66142A02F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhJLIqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbhJLIqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:46:04 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EDEC06174E;
        Tue, 12 Oct 2021 01:44:03 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id w8so9628908qts.4;
        Tue, 12 Oct 2021 01:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VfQ3pN1Wn4j6A/3u2FeV9UXUwDseQ7lyqBpHMKNttwQ=;
        b=LpsFlzNolwpXyMKTm0MbsCNr7jyVUcwhDI/eDqcWEdapUlOTe9TvDou+0ZzsO8ERwN
         YyANMv+gKHNwMYfHNeGSjQhlM0wRFY8lU1TrCgJE+LMD1b1xnPpErPZ8sam2l6HXoRXo
         Xvo3KhLF//01y/FFKbS1cKkj/nUX0xyCZTijQ6UG9vd83mc7u0a8DtozKOzFT26wLUuK
         301g+9BYtfnzMBsnrxTO8iN1iVa/uP3J3kC9ezvUIvwkLEB8EkGepEMqUQuu1+jKjEi2
         sRXACZlrbEYsMoaLhBAdtz0Hed25be9MTfGTZ4rTdupCHlQb29Y79GQS+NXG+Ng/WnRp
         m2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VfQ3pN1Wn4j6A/3u2FeV9UXUwDseQ7lyqBpHMKNttwQ=;
        b=wSWTr6xFHBbQk4kIA/CQ2V0r2Hu4iN1MyNQCAa9tTrJQKPdjCWLfrOpMvm/IhVueXK
         WOb1rkIlDRt6/VNem+qqDi0YtY9dGa99R2wSVOGlnlV7F+sWQlXKTUJj/hOBhPe2dsi5
         AniiKNgLZEfGGz7KOycmYl+fiDUgOLhic7bToiehXJA1g735ow17VKMf7zV4NtDEULEB
         sQsSKMxxtqP5W+Z51wWjGZiQiiWP/bmPH3AVZbjGeoDbp6EjIE8j+XMOzzn+biFbv2o1
         297VGnB7K0e1TENrtIMh0MCSPjqmzQOAb0v2DUfFygVWHNk/ha4r3KZ71p8dvZPNvDOz
         l4tg==
X-Gm-Message-State: AOAM533yk0rMaByviq6hWBSNVqHSF0l+gDUuKFL2bINNZZeuTTPLSwi4
        7wByC+vdHqWlFnIFi2MeJndyXcIYXHfNTA==
X-Google-Smtp-Source: ABdhPJw+AA+6ybWt+MFjv/URB4aGoizbzzcXUS6UalpNJTesRT0CVKh3MhIuKyB5wiHcWcBgbdHOBQ==
X-Received: by 2002:ac8:6683:: with SMTP id d3mr20946779qtp.291.1634028242132;
        Tue, 12 Oct 2021 01:44:02 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e4sm4272414qty.59.2021.10.12.01.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 01:44:01 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Date:   Tue, 12 Oct 2021 04:44:00 -0400
Message-Id: <346934f2ad88d64589fa9a942aed844443cf7110.1634028240.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
The access by ((const struct rt0_hdr *)rh)->reserved will overflow
the buffer. So this access should be moved below the 2nd call to
skb_header_pointer().

Besides, after the 2nd skb_header_pointer(), its return value should
also be checked, othersize, *rp may cause null-pointer-ref.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/netfilter/ip6t_rt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 733c83d38b30..d25192949217 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -83,11 +83,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !(rtinfo->flags & IP6T_RT_LEN) ||
 		  ((rtinfo->hdrlen == hdrlen) ^
 		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	pr_debug("res %02X %02X %02X ",
-		 rtinfo->flags & IP6T_RT_RES,
-		 ((const struct rt0_hdr *)rh)->reserved,
-		 !((rtinfo->flags & IP6T_RT_RES) &&
-		   (((const struct rt0_hdr *)rh)->reserved)));
+	pr_debug("res flag %02X ", rtinfo->flags & IP6T_RT_RES);
 
 	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
@@ -107,7 +103,12 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 						       reserved),
 					sizeof(_reserved),
 					&_reserved);
+		if (!rp) {
+			par->hotdrop = true;
+			return false;
+		}
 
+		pr_debug("res value %02X ", *rp);
 		ret = (*rp == 0);
 	}
 
-- 
2.27.0

