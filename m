Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7086E287829
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbgJHPwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730221AbgJHPwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:46 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767BBC0613D2;
        Thu,  8 Oct 2020 08:52:46 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y20so2945311pll.12;
        Thu, 08 Oct 2020 08:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DykZRLkCtQ9htd/aPPi1KevQSJPPLl8ioPLoUg7iCDU=;
        b=I6ruV0aT0SbKbNmivtTsSc3QbkRbeqPsS51ghGqK9eiPkZMg3QjJStW025Prflt4yc
         5t3GBn7dq+YTFhaBRtQMjqxbzHjSTSFlsIV5Icxo2F2moEOEds0sEMRIwoeVoT7j0VOp
         S/mRYijrhRhVH8qiMP47upCFqrWgA/le2gaYZUdQlrkYmQY3f4+sydP3hGcrx60iSt3Q
         GkZonckP4MqYqULzu1AtDCbhCN9hxdiYHkwiSEV03s3UMKXKaf7Ix4S98Mdz+l3pEv/C
         e72eUPxZ4eHZsvgN2KohV6/CkZKOOgqGzl1Yyzhc2ao+yap0bWyEnOUx+BpuDHINElXh
         wfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DykZRLkCtQ9htd/aPPi1KevQSJPPLl8ioPLoUg7iCDU=;
        b=sNAQ3rRNRzx6thadpdZDEZypkq3RXkpAdnVHGJqojUf2/ClMTytu7t/4cZb3X6T/m4
         HX7nriOfStsj97jU+qOCEkmpqAnuekH1z30/Put65dRGfJr0V3IezPGY46A6exaS1KXC
         x4cb+o8QHMLar1fj7GqCVls/RKKUFCrEmlDTCqFtwyFUg0uYdzjHhOdr7XYO66LgLZAy
         6UNF6mELYkS/VFUhn0AWxtWt8AXaOsZHwMLsALtHuouA1TC6l4sfAuQSA5RrEYv4Emgo
         LAbWM1VuLDyvtxT5lwxi6KUZV7VLHM8Fja/kdUGxutnL+iFq0p3yEIy1zE+NWUgbIR8K
         i/Mw==
X-Gm-Message-State: AOAM533XunxXcbyuYeiuxKbgl0seQmZHzt9iqPX2cktxll97gHBBhEnX
        DzUyHF/gveOx0/d8Roxd3iY=
X-Google-Smtp-Source: ABdhPJxY7ImE16iT/WCwS+04dw4rq1gkRdo2bGfhtCm8ChQuCPLEtIvdcka7sVONMT+GjoDeE3bT5w==
X-Received: by 2002:a17:902:7c0d:b029:d3:de09:a3 with SMTP id x13-20020a1709027c0db02900d3de0900a3mr8007289pll.52.1602172366048;
        Thu, 08 Oct 2020 08:52:46 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 008/117] mac80211: set STA_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:20 +0000
Message-Id: <20201008155209.18025-8-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs_sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 829dcad69c2c..d3366989c6f9 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -34,6 +34,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
 	.read = sta_##name##_read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define STA_OPS_RW(name)						\
-- 
2.17.1

