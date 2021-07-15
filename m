Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100A13C989E
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 08:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhGOGDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 02:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhGOGDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 02:03:10 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B83C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 23:00:17 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id c13so1130703qtc.10
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 23:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rg9L3Dk0joAl/Y4W8CAVXRIHURFOXJ22e73C4jmmn+Q=;
        b=n29ocmTnG9sT1PL7cTAmTnnVLB0BU2D6etXbW5eHxqbzSdBkIpx0NgRkyfsD6LGaQl
         oNhB99grJYd9TSatmQPgHW1ft/UKduk+sUgcYnWe8H8GRGbQmqTJ1skvMmH/XUl9jv/l
         8XXa0k6+DXflyZlCAQDYCo7yd5g01tvk+lOlD84dU1NzWT3UlaEZJMfpN40OUcFs0A5C
         v/N5FDI4uKG4sp1HIhSFnfNoz0phKKf4qAYrLkddoruAw7hirw9ctjTFIwnb8jkpTqnS
         GRL3gXDQTpv46IG1NEjnkuyRfdlLB/zs0ldQDmJgzFtVUldk53SA46LB5aFfuCnFWcSR
         URjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rg9L3Dk0joAl/Y4W8CAVXRIHURFOXJ22e73C4jmmn+Q=;
        b=CbdQ8LEvGyGnlRG1M2EZagyCU0QTL0cPQ/+ujJaLH4MKNgK3Cq8IEPDDOStsKrv3OU
         JFzrX5bOeRCmqLJ74ffd3IKrFSc/f6gx3Enlf4c5wSOHn9Dab6qZ/lSuPRWpFMzFSSZe
         V0kmLcOtXNfTU4Yt3++CmVJAHzRuueJqKlCUEFYFkMLSevSQ0C82/JA3Ml1maMNY+zRO
         qDIWM6P1HI/xp5WauoW/qPknVoILrbVlzG85f0xxV7ly716ZbCLGTutN8g4+kZcNVVmu
         ULX+VDswjTW28lrdX6GC6LVnZHKVhDAQ4VCqdcTgRy2gnA9pxgbK7JnrL2gAGn0tn10x
         FZ1g==
X-Gm-Message-State: AOAM530LaE4PPxjdyzCXaljS6HTP+or6nOhKUGp29eEKslDnTVOhSZBe
        noqtQLIfjHih5Z+DW7jy1Wg1lBrEdYk=
X-Google-Smtp-Source: ABdhPJxSnq+/XN+F54igLcrzQVpIuS5ROJ5I8g/X6OkDS4J5ES+yYRS9xDFHZexbzaTNrbeylb8OGQ==
X-Received: by 2002:ac8:5cd5:: with SMTP id s21mr2376760qta.192.1626328816317;
        Wed, 14 Jul 2021 23:00:16 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id e15sm1659717qty.13.2021.07.14.23.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 23:00:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next resend v2] net: use %px to print skb address in trace_netif_receive_skb
Date:   Wed, 14 Jul 2021 22:59:23 -0700
Message-Id: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
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

Note, trace ring buffer is only accessible to privileged users,
it is safe to use a real kernel address here.

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

