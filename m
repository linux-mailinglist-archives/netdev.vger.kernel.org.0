Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D85127A56D
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 04:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgI1CcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 22:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgI1CcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 22:32:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92638C0613CE;
        Sun, 27 Sep 2020 19:32:12 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so6205396pgj.3;
        Sun, 27 Sep 2020 19:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOzo5/c2tdrgQiQGFz7WuFAha6P44jvsz6cVgcm8TcY=;
        b=kW+Zgvk2DhFr4cMdk/FE/ggsX4G5knNefZ2eo0gUQim4RNqKjTZDBOdG4JaJr+t/dR
         mcHASO2BW+hUrMJ1QCpPe8VxlFp9hXh4H2NG0ge9hLJMoAOy5kPcU9m6ObeKFtf0DQtl
         KKJkDUVuJwWJXryHBjNzgvTrpDY+sEcsOI4oRaEHQ0dyihuFuJRrPd9aGEfHK6pZUWuI
         X3svmF1Wb68kET+VLaWuXV/3VP9r5T3NF9fQ/Pl9s+EeSU506OAsJnkUJwUo97zu6nnI
         Elclk5vhN0jVWUwUOGhK8k7Eka5abD1oC4oU2efz1qTYAfE9hcjq6xun05LGEKj69IMa
         DUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOzo5/c2tdrgQiQGFz7WuFAha6P44jvsz6cVgcm8TcY=;
        b=hRCspbSUzI0gFtU1BnotmMOG2en964C4UZ1RcdkT8t74RtcogaUwUHwJZkLK9HWhwA
         Msa8SHbLSPc6T4gQQkPZ7etrrGvOJz/JZe4FCm2o9GTBI1pHNvfbDtVsyPkRdzcMSGm6
         3VUeKrdS0+uNipd+1sHO2QefddADWOrpuBXYTCirTWII9g01hdeQlPLK3UI3fuYBluP8
         RGfG0hzNCt+Fd7vW9QN5WQxNWrgkVvvGU21ccv90wprfBzPoap0lid79uuF0jNtlspLx
         uIJv5rtTuQVkG9QOGTMbn6Lej4pJdp7xrAvvD5LyXdKveFUBTypjfzxzlvP8CEdqX6iN
         GUYg==
X-Gm-Message-State: AOAM530iWKU9y0KMe9Ir1HYyClJ+Q6mZrtqki3AQoa6Jq8tq/J9fwKd6
        6d4H5IBwvYEgxy+c2+fR7oL2s21hHPnNyw==
X-Google-Smtp-Source: ABdhPJwdyItsf3llU8D2ReOXPVuFzN+E1b3zCpuRsyj3ra1guULJ59refqTesZBqpflx3jpd2JK/ew==
X-Received: by 2002:aa7:8051:0:b029:13e:d13d:a0f7 with SMTP id y17-20020aa780510000b029013ed13da0f7mr8100970pfm.19.1601260331595;
        Sun, 27 Sep 2020 19:32:11 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q65sm7771306pga.88.2020.09.27.19.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 19:32:10 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: vlan: Fixed signedness in vlan_group_prealloc_vid()
Date:   Sun, 27 Sep 2020 19:31:50 -0700
Message-Id: <20200928023154.28031-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit d0186842ec5f ("net: vlan: Avoid using BUG() in
vlan_proto_idx()"), vlan_proto_idx() was changed to return a signed
integer, however one of its called: vlan_group_prealloc_vid() was still
using an unsigned integer for its return value, fix that.

Fixes: d0186842ec5f ("net: vlan: Avoid using BUG() in vlan_proto_idx()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/8021q/vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 6c08de1116c1..f292e0267bb9 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -51,8 +51,9 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 				   __be16 vlan_proto, u16 vlan_id)
 {
 	struct net_device **array;
-	unsigned int pidx, vidx;
+	unsigned int vidx;
 	unsigned int size;
+	int pidx;
 
 	ASSERT_RTNL();
 
-- 
2.25.1

