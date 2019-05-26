Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97B22AC4A
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfEZVPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:15:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36849 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfEZVPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:15:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id d21so6220718plr.3
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 14:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gymxrhMZW1MlcvQ3Sojp16R+DodTpO8ebx9/FKrBeb8=;
        b=skU17xqfNqX3/U9F9IErr1T3irC5LacYzLo717gvgkoP39VW97DbHMAmjdHwwrzHIN
         8U70x3m+m9GMTBWpbqWOBm6lHrqEjeCWJM6yfFOB4Zc6gtj+pFIU5jXOmO6HfRPo085h
         5xdgMde+ie8/sPydHA9hhk7swBPxAQBHL0b37UrKSGjrUbTTL8BHLTRBMmE3ZnDTuFtH
         pgrdKEgyRcZG0ZpDjGt+pwdKPrxs2YuNp0hPZ6Nl8xmjldJZyKTOpLx6+909lYTZyoZh
         YmljdUpCB39yHFNTHz1YxNs8l0M8MFIgJYpKACGDoeg+1+CpNbxuQrpSi4xbs9Tk91In
         d9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gymxrhMZW1MlcvQ3Sojp16R+DodTpO8ebx9/FKrBeb8=;
        b=M1lfXIWEvbAwjZibaX1zS1cVWv3s4pmgMgVt7xeGMtfUSk3sTWMQgmhLqDnGELO3WW
         18+6PClznsdh+Gxla23OIq33L6pysMH1FvFM8vJ5tN81/KEOH/D1KE6X/aLYydvt9tP1
         /hyRvmRALRR0JJIuUNfOzEtn9uAFMjC1nHgm+C3/sTJXFCC5AbqQ7wHdzSJfubyHuvGf
         W/Z+4NaNKnoVArU58IxK/AU7yRfojJkDKgN7hfpQg7aP6BcVkTpwgcRigdhTKxb1mk/0
         fR/4LrcRGLnliNQBXxFfZCMKGxhcn0H0ljlhLQKJlg1bFVv9Faw7iQOAlXDhLUyNZ4V9
         QAqg==
X-Gm-Message-State: APjAAAX8NpXoR5v2KTxLN1GnpdxzG5hscSTdmVTsTw0dQyctgOBN5KGy
        XIhzdDlXjf1uT6Q6y7Y5UvPQtplj1YW8Vg==
X-Google-Smtp-Source: APXvYqzOm/R99BWWljrdhWDyOFJHAFdsnpFy8u4umJGP6TuMsDViSRAi2iIEsaEk1t2q3HPyNNeL3g==
X-Received: by 2002:a17:902:690b:: with SMTP id j11mr48901092plk.149.1558905333756;
        Sun, 26 May 2019 14:15:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id f40sm13325325pjg.9.2019.05.26.14.15.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 May 2019 14:15:33 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 3/4] ipv6: Reference RFC8504 for limits in padding and EH
Date:   Sun, 26 May 2019 14:15:05 -0700
Message-Id: <1558905306-2968-4-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558905306-2968-1-git-send-email-tom@quantonium.net>
References: <1558905306-2968-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC8504 specifies requirements for applying limits to Hop-by-Hop
and Destination Options extension headers and options (including
padding). Reference this RFC appropriately.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h | 9 +++++----
 net/ipv6/exthdrs.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index daf8086..fd01823 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -54,10 +54,11 @@
 
 /* Limits on Hop-by-Hop and Destination options.
  *
- * Per RFC8200 there is no limit on the maximum number or lengths of options in
- * Hop-by-Hop or Destination options other then the packet must fit in an MTU.
- * We allow configurable limits in order to mitigate potential denial of
- * service attacks.
+ * Section 5.3 of RFC8504 describes limits that may be applied by an
+ * implementation to protect a node from excessive extension header options
+ * (for instance, to protect a node from denial of service attacks where
+ * the attacker sends packets filled with tiny options that will be skipped
+ * by a receiver).
  *
  * There are three limits that may be set:
  *   - Limit the number of options in a Hop-by-Hop or Destination options
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index fdb4a32..f0e0f7a 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -153,7 +153,8 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			/* RFC 8200 states that the purpose of PadN is
 			 * to align the containing header to multiples
 			 * of 8. 7 is therefore the highest valid value.
-			 * See also RFC 4942, Section 2.1.9.5.
+			 * See also RFC 4942, Section 2.1.9.5, and
+			 * RFC 8504, Section 5.3.
 			 */
 			padlen += optlen;
 			if (padlen > 7)
-- 
2.7.4

