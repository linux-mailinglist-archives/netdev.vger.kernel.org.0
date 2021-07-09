Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3877E3C1ECB
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 07:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhGIFUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 01:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhGIFUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 01:20:08 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD7CC061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 22:17:25 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 14so8238789qkh.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 22:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Stq9NaXhoMxngm3X3gbu1sOKCEkZjhRMTkH6hXoUsuI=;
        b=dsxwD48jxrqhC02ar6vrgD9NTe/46WthrUBNi8hGB2v2xgcvtCgMOY4DtTWg2OHuOT
         IMbq0tt70VfpdX8Bqibu5hrqX2MlLUCJrZId2SWLwdaqKTBT3NhI42GJvngByDGOeT99
         D0BkdkdLMw/VaC5l7Tp4IUK4SIkdakavXEYsnKEJRMYPTbRuMOCapmit6uWn+y91slS0
         lqpW+xzXPuWtEsPAsDjXRvinwEvax1hphCPST7f//RAeEeRacQDL2r2XVXFeE0KLhDPM
         fG0j/zFxRXe8U+bvwf3M9rOUx9rtSzrBxTsrggM7+vzQVNGsaCzfxCzwvx/hBL/vvlwm
         3V3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Stq9NaXhoMxngm3X3gbu1sOKCEkZjhRMTkH6hXoUsuI=;
        b=P6IZBlJUTpzBHfaQD4GS1UP5b0w7CIYhG18ObobT1C9LS6Qj/J6f4O2q10c8Pd85H+
         JA/mwnW2T6in6GAeS4xE+dMeSfqB0G7lkw1JzyDN16jDGhusVAB7Z7F54S00Vymf8nRT
         9uaVSXgwkXE6R+uc41V5b80wPepqD/uV23TOcv9cMdtizwElqWqIiogOkPp4OGuI4Elp
         nuEQ16lCyUmG6PtuhJcYzS4+4gdvj06UPnBZyvh+O7ko367R6/vSFmk5piA8RaTVkgZ4
         FixCYqK0L6adE9tOPLVD5cndsajaT4XjgcCVhKw2BZ6ktkeCfn2jDWdKfKptJsAMdkdo
         o39Q==
X-Gm-Message-State: AOAM532Jhv1qSD+Ru6Eu6bnzX3JYWp8t2c7tOaxxsaz/3PJVrFE2UEum
        Ce4RU8KBFCDAeS3RasUe8Eq5w4uA9Nc=
X-Google-Smtp-Source: ABdhPJzh2D9n0dOT1Anm0xxufZEbK30pTfqPcbU7z8Zdkr4LBLRXFAhCfFIjnlnBu7NiP9sohiBnXQ==
X-Received: by 2002:a37:2f44:: with SMTP id v65mr34687050qkh.315.1625807844038;
        Thu, 08 Jul 2021 22:17:24 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id y9sm2028246qkb.3.2021.07.08.22.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 22:17:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next] net: use %px to print skb address in trace_netif_receive_skb
Date:   Thu,  8 Jul 2021 22:17:08 -0700
Message-Id: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

The print format of skb adress in tracepoint class net_dev_template
is changed to %px from %p, because we want to use skb address
as a quick way to identify a packet.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 2399073c3afc..78c448c6ab4c 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
 		__assign_str(name, skb->dev->name);
 	),
 
-	TP_printk("dev=%s skbaddr=%p len=%u",
+	TP_printk("dev=%s skbaddr=%px len=%u",
 		__get_str(name), __entry->skbaddr, __entry->len)
 )
 
-- 
2.27.0

