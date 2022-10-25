Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC0060D645
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 23:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiJYVnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 17:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJYVnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 17:43:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9DCA8345
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 14:43:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id jo13so8546173plb.13
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 14:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4BYzSfSEbxwfGjiReZhxW7dY9K6SswSYX/2tTsnVE3A=;
        b=rO8Q2MFnyLDdiMIJ2AMBrd542IU8ziDsNseaWNyy+AykZW30Nfz1t/0dLE/Npds4vM
         6Y/yoln8IzRp61SAGAcjhxImDKQu4G4bfAAdgEneEJqjOK5ziy5e5So50KOxTQgYrd19
         CfVqs0Iw9rnK6OT5J+qlEeZLejfMFRdQBgGk93V2a3FxBXJprkJNk8th8yypsN/BLO/j
         g0BPP2VdRIvhEBRKoalyLJ5FT9DIakIY4rSM+GOJTLOi9amtzWHYs/hN9gwQHnHoDUO7
         fBdHf7hqS5GD5nRy+mlTESzhjk0eG3y1HLBVnvxarED8PEKnXE0fdq41ZLQ6b8EhzWKY
         O2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4BYzSfSEbxwfGjiReZhxW7dY9K6SswSYX/2tTsnVE3A=;
        b=Sg139KlOLb3e2t5w804/OefLHyrMnlUpt6D4RDcxvjaIZKqQsnuI0GMKsAtktoflBj
         xKhbibCM0yj0uTOPBXqCQGIW5LqoHYzW1o2f6HvREC2e9sCUXQEbxWI2MXNOkIP2s7l3
         R/sEfI2/0IjFNJkqIR23vCmYv3tk2ldXeyz8RzVORwmv7BeuAz+xdQvX5VkTX/z0wocr
         zM4Ta853GWUGRxszWLuKwpBunGcuLMRx5wiq0X3O1RKpxIXVY4hWLCTloIBkS4sRy0fO
         z65njM88gssof8yr1trJzWv0LjaeTOX1LXnQ1TS2hm/Qep9KW86vN4npu92obr9jVJ8w
         3YSQ==
X-Gm-Message-State: ACrzQf07UJ97P+q9sVwNGioH/4xQZCE9Ij15SoOS9v06bVhJk6dJw5Vy
        ebQ02iJEs6y6NrWzNBWxMDph/SSHMbaozQ==
X-Google-Smtp-Source: AMsMyM7PxaWYxApceQ3LvPhiSZdOR8uLCHExlZvuZS+Wl4phj1m6v64F3vLY7EOt99PtL0QG0OD/YQ==
X-Received: by 2002:a17:902:b190:b0:186:b9b2:9268 with SMTP id s16-20020a170902b19000b00186b9b29268mr7859719plr.32.1666734178538;
        Tue, 25 Oct 2022 14:42:58 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d14-20020a170903230e00b00183ba0fd54dsm1619658plh.262.2022.10.25.14.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:42:58 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2] ip: revert including new features in all cases
Date:   Tue, 25 Oct 2022 14:42:54 -0700
Message-Id: <20221025214254.103427-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem is ip commands built from latest version still have to
run on older kernels.  Running current "ip monitor" on older
kernels would fail because it could not add the group for stats
since rtnl group for stats was not added until 5.18 kernel.

The proposed solution is to revert the inclusion of new features
that could be rejected by older kernels from the default "all"
setting of ip monitor.

This effectively reverts commit 4e8a9914c4d459be57ddedf1df35b315e7fea8a5.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ipmonitor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 8a72ea42db73..ea91166b5fe9 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -190,7 +190,12 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 #define IPMON_LNSID		BIT(9)
 #define IPMON_LNEXTHOP		BIT(10)
 
-#define IPMON_L_ALL		(~0)
+/* All only includes those bit supported by older kernels */
+#define IPMON_L_ALL	(IPMON_LLINK | IPMON_LADDR |	\
+			 IPMON_LROUTE | IPMON_LMROUTE | \
+			 IPMON_LPREFIX | IPMON_LNEIGH |	\
+			 IPMON_LNETCONF | IPMON_LRULE | \
+			 IPMON_LNSID)
 
 int do_ipmonitor(int argc, char **argv)
 {
-- 
2.35.1

