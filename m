Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5785C1B2134
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgDUIPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgDUIPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:15:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6403C061A0F;
        Tue, 21 Apr 2020 01:15:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e6so1046477pjt.4;
        Tue, 21 Apr 2020 01:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6lBTpejJL7g1ofNkPjXSqwyv4TOSkRFfpJYGD1KEjIs=;
        b=alOJNEp0kLkmeHRC/DHGPggPqUUDiKfkLQZvv1qgTslXuLGwgK4R+qPsoaDaBEs1KO
         0cECrIzGQAZDNGUaL59F7MqKyipr7lrjJGnsasvn+WANMLkmDlM/2B67/C2vNHpj+oIV
         /Z+mEo7uEAGHvaFmLtzJNmOp/VBKKRM+2WQesmzp6QW46WJ0lmN+Xo4p9WzaHXI5nY7M
         DFU0YaNJybeJnaTIa1uY5erSKpRdALbXq9slcPfX3CoMYKUuz6coIi1iPtbMFyBiZq1P
         FhHEPkPg5K4WkNBhq2ecEpYDhQwmkwE6V6WwkZfv5mhkDv75OHmgqko3A61Y5i7HffHc
         yq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6lBTpejJL7g1ofNkPjXSqwyv4TOSkRFfpJYGD1KEjIs=;
        b=RkxPwAQ41CAsyBUrnZgd7exLyV7PJssysLkPuQjzfF5nkDRNs4p1MWxcisLTZiOYcP
         I+sBm6H2BZ/LLYonQu9umwha29SVDN29VEWiMRn6DouHbkJ37vfKjkTXLrWKRDBPPyTe
         dxBzNFXNFp2iIIeQrHSQ/1xBMeO8OBMOX4R1j8R8G0leJTtLXRuy/hdxnFAUoDvyVuuW
         OsZeKyq57gaLPjUOqUDIXklaNPq1TxFfrNB19Bat6z3oMdHw6K86TMDZdz+ePJmGrp3n
         8hveDZNqKo90dqvpPz7Rl4lqL/ZCp331Dq4tbeTBZFAIZZk1xFyI3s3gOJOgM7xFR+O0
         iirw==
X-Gm-Message-State: AGi0PuZyWcIHIbQ1hPYvvFXsKQc7Ox7nIhTVgVoijLi8NmFzEZ1+7Lqi
        r6haP9Xh3L2IpDxGvx4QcFU=
X-Google-Smtp-Source: APiQypKVcSgIMnT7cohNy58TF/TOlAbPt+9WQH6aOS1ZJvMXH4cIMcTGeCAKwr4qwrlbKXORdp0cHg==
X-Received: by 2002:a17:90a:210b:: with SMTP id a11mr4419361pje.31.1587456931376;
        Tue, 21 Apr 2020 01:15:31 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id c3sm1696665pfa.160.2020.04.21.01.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:15:30 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] libxt_addrtype.c - include strings.h for the definition of ffs()
Date:   Tue, 21 Apr 2020 01:15:26 -0700
Message-Id: <20200421081526.108133-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This resolves compiler warning:

extensions/libext_srcs/gen/gensrcs/external/iptables/extensions/libxt_addrtype.c:263:14: error: implicit declaration of function 'ffs' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
  int first = ffs(val);
              ^

Test: builds with less warnings
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libxt_addrtype.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libxt_addrtype.c b/extensions/libxt_addrtype.c
index 27485405..5cafa219 100644
--- a/extensions/libxt_addrtype.c
+++ b/extensions/libxt_addrtype.c
@@ -5,6 +5,7 @@
  * This program is released under the terms of GNU GPL */
 #include <stdio.h>
 #include <string.h>
+#include <strings.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_addrtype.h>
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

