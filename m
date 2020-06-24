Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DA1206952
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388231AbgFXBFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387932AbgFXBE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 21:04:59 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C3CC061573;
        Tue, 23 Jun 2020 18:04:59 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z2so420338qts.5;
        Tue, 23 Jun 2020 18:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=3OBgMDcvg30CRdCm9XIACqMvUJtLpuU1344J7O//WYI=;
        b=NHN9+2+B9gQpMaHIT4JfyKUJw1CUMHHF42dfqh4p3Pfha4IQH6PigO6675MF70gsbh
         bF3uw5/0fpWXYzEV21wwpwmf/1dUd1wtuH/YxhLnoXJ7H8gUNeYkUfLCh2/a36HrCQ22
         +b5kABWFKcipyL8Dm+kZTIHtFFcumXg/7GRKyt+q59McrXDM7OK7jEiYUBaSxjfSO4cw
         OfJFReAf1PbsAclpJaCYKbVCnNoHmEAK1kk61BfFCSFmcjns+5ZhpxFEYtW9GIjUnZC6
         /o19reTcqh+qZI3EEq4xJYPmvqQJGilcLH9gEFifHZhI86BmOtQoa127z+LmRtxsZgml
         6zLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=3OBgMDcvg30CRdCm9XIACqMvUJtLpuU1344J7O//WYI=;
        b=ItDPf0WV9v2lfqkh/ywjyyamo/nNyNApGkT79NmHqBfLLYfzLb3c6qaxqmAGdkY0Nk
         kWFXi15YUvwzuMsDJiYrSEDkbIWSfEg5qzVKxxIANrbkQrfNmNFhF0TzzfGsRjjEg6dF
         IvkFKjXz6mkOHhvEyi3n4iCLCfRMNqW2qkAbLM9KAshBBcOLs/FOsFFv0dpVfGkGKmnL
         o4wOjZnTa0j2GUoJj60e/FwqBRs0RVG+Qy16UXS22rEYRRejYiKNedwczFvzMAQwCTlW
         E+RsXTy0ssa/jBlAy49Zz0dUU4LzJW9EgWKJzqBsQkUZDMOl/2zNH7F3ORgH632koyrN
         1vAA==
X-Gm-Message-State: AOAM532aPR0RrMxatn8/Kj/pweWKAOY7bK1ht3eWZpl39QV6KbGa6yt9
        tG9aU0vke9d4PdLeMJl71X4=
X-Google-Smtp-Source: ABdhPJzpzOMIa0DJbqE+BzfGx83i+CzC+VDiaMfdL9OiFjLLB2Z2aSu9Xu/zOS/ZgGpS+CiYw74zyw==
X-Received: by 2002:ac8:2f0b:: with SMTP id j11mr21806690qta.17.1592960699009;
        Tue, 23 Jun 2020 18:04:59 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:596e:7d49:a74:946e])
        by smtp.googlemail.com with ESMTPSA id w4sm2269137qtc.5.2020.06.23.18.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 18:04:58 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "Jan \"Yenya\" Kasprzak" <kas@fi.muni.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/wan] cosa_init: check bounds before access
Date:   Tue, 23 Jun 2020 21:04:49 -0400
Message-Id: <20200624010450.4490-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check i < io bounds before accessing io[i].

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 drivers/net/wan/cosa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 5d6532ad6b78..8797adfa0ab0 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -363,7 +363,7 @@ static int __init cosa_init(void)
 	}
 	for (i=0; i<MAX_CARDS; i++)
 		cosa_cards[i].num = -1;
-	for (i=0; io[i] != 0 && i < MAX_CARDS; i++)
+	for (i=0; i < MAX_CARDS && io[i] != 0; i++)
 		cosa_probe(io[i], irq[i], dma[i]);
 	if (!nr_cards) {
 		pr_warn("no devices found\n");
-- 
2.17.1

