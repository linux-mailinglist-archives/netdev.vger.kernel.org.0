Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B556E8C9F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbjDTIXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjDTIW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:22:58 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B147A4EC7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:47 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a66911f5faso7687615ad.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681978966; x=1684570966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+G6vgR3v0UbcyeLgoVJtbhyjb8Bnzg2BuB5vx6ENGSs=;
        b=gmHpqIYsFEawOoh6e/kYnNpsHMaFPJZafvyLbrYNV62K0tMz3a9gzV5FoV5+AOuj1f
         Hg6VHB3+T8L68chbn4wLx+AJvlnF50YnFWMGP1a7AT0q702poyfVJ4OFrRvMF09j3tmM
         fQT/lUMF7OqM91hE7tSUYVMBHX7eSHb47Ysq1G5yIRwf9knD29gquOIG8C7GJZVFcE3T
         4ps3aMIqOF3TpV1PnHn9V8qmvISjL3+YeeuYgVzeF+5SgSQHdvMp3pyYKjFe7Qch+BQM
         XlMuAIn7nJvLyzBLaLKy7nWZCSIz5OfeHrjDCmXTyIvpzTAV1sfZi5WOI7sngF7UOA+t
         LMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978966; x=1684570966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+G6vgR3v0UbcyeLgoVJtbhyjb8Bnzg2BuB5vx6ENGSs=;
        b=aBiHYsIkFtGPRgs0SfWCksX9/0mk4+foQNpkXQKSdS+7pqakxRB26H40EgUc0toq70
         pl4WD0M/fiNukcPi1q6KpV97kr/wglwnFjgFOv6ui1lWrOLagOugIBT0ShTKzbX/OTon
         Wg+aWFsAYkzI6w3A/73QN6mIffWTOS8bNGawfQCOBFQSVH5v+ZUwZc9j7h2o0onHyQE5
         XLSynfwosoJz41iYPrMioZr4sYMd/hn/LnEX/lhAY6vNLX5Lk+/T7RbDstYTxNKy7AZh
         dT/dvQfunH4UfyOSc8sh8xAo/b7u2kRVhsd19Y50RZkU5qsGX96/oOMzYAmczyUkTYan
         B8hA==
X-Gm-Message-State: AAQBX9f4OdUknZkh2YOX4DwlWSBw38R5Oq6PwBRPUCUVp6LtsnrDwbk6
        hZ5EpNAtOgQDZWDgw1Gs1w7cs/FKebfAO24C0pc=
X-Google-Smtp-Source: AKy350aHayqN9Wuj51ay8xt6iuq7zZHPHcJ0dfd8AF/Ki6tENZWMXB50fy9k3t4/LQBcnillHSMoGg==
X-Received: by 2002:a17:902:ea08:b0:1a2:85f0:e748 with SMTP id s8-20020a170902ea0800b001a285f0e748mr864961plg.20.1681978966430;
        Thu, 20 Apr 2023 01:22:46 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902d34b00b001a1ed2fce9asm662175plk.235.2023.04.20.01.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:22:45 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/4] Documentation: bonding: fix the doc of peer_notif_delay
Date:   Thu, 20 Apr 2023 16:22:28 +0800
Message-Id: <20230420082230.2968883-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420082230.2968883-1-liuhangbin@gmail.com>
References: <20230420082230.2968883-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding only supports setting peer_notif_delay with miimon set.

Fixes: 0307d589c4d6 ("bonding: add documentation for peer_notif_delay")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index adc4bf4f3c50..6daeb18911fb 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -776,10 +776,9 @@ peer_notif_delay
 	Specify the delay, in milliseconds, between each peer
 	notification (gratuitous ARP and unsolicited IPv6 Neighbor
 	Advertisement) when they are issued after a failover event.
-	This delay should be a multiple of the link monitor interval
-	(arp_interval or miimon, whichever is active). The default
-	value is 0 which means to match the value of the link monitor
-	interval.
+	This delay should be a multiple of the MII link monitor interval
+	(miimon). The default value is 0 which means to match the value
+        of the MII link monitor interval.
 
 prio
 	Slave priority. A higher number means higher priority.
-- 
2.38.1

