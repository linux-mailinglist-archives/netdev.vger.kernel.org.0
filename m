Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B71229CDA
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgGVQOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGVQOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:14:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D79C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:14:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z3so1519135pfn.12
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SMCwoHMyepT1PSSn6MxfQ4RUWpwLcdAu833ifsBS4lI=;
        b=KSMWxS4jlcRpVrWgICCOpKZayg177Xx3wA+1jQLk77VbTbHNcI/Ru8I6A3oQKLnd/3
         pwWXOLWv3clDKGHmh8FFJZ/JBckrw6NBhMagLp43bYBG5DsKY8lguaEgkzEaTcWbOt/R
         tFEgfdyB3bXnz+5BPZQ1YWz9shBRI4ktjB1YVQ0/m+vS5vSrmiNlt9psrO9mSybbELSM
         rrRgXxI6Q1S5OGxxkPFHJcgoV7hE7owgTYEaOzr7Qy9z8VPKklgpjUiwOLVPmisoVufM
         hYuB6zIciycwxo2YZPDX8UwRXpDryMG4ZrwuKIVDj9nIje/Zu/P7ok4nEn7KgRUnEOf6
         Kjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SMCwoHMyepT1PSSn6MxfQ4RUWpwLcdAu833ifsBS4lI=;
        b=GrorZf/T3oCbJ3GZcKle4khWE5ixuO03ikASO7+Qry7PLArVaqP71923h+euwdu1dh
         RYDi7leC8HyUtpSIG3J3Zi13QRtNTFE9nashWfhD7lkOHXO7sknLM5noVIFhPXDBl3yR
         WdRxIxu8nNWjG1WL43WFo65Q7uGE5s1du6GATNd1HGLK+oPMTxoWTICl4GCruZJhwCr+
         gRqCWa9LV7qCBvCqEQ8sgiZ7oqDNFpQNqrEL/g3tDTsle494qcR6KTajTgyWH8yysGDY
         tmRCiQOFV3VcHenOcdPbwOx9rSvWkdfLi4vayzZe7s/0ssx/MMdKIGpr6RZeCYNjCfun
         eUpQ==
X-Gm-Message-State: AOAM531hr2QF0Yp5XetbeT7w+mZ3DnLvwGoaDntdkloeXwK/d+70q9ao
        f2ALp6OG4760Rb/vN/44ptP9whHk
X-Google-Smtp-Source: ABdhPJwAVRGUDSGwC14kxsO+rONbGjEDX1l3z5/fLZ0WCp0ebAZKbBz+0otSWJ7KE+vMuZDOwhkXyQ==
X-Received: by 2002:a63:f806:: with SMTP id n6mr515293pgh.346.1595434492568;
        Wed, 22 Jul 2020 09:14:52 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([42.109.146.221])
        by smtp.gmail.com with ESMTPSA id g6sm44657pfr.129.2020.07.22.09.14.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 09:14:52 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next] net: Enabled MPLS support for devices of type ARPHRD_NONE.
Date:   Wed, 22 Jul 2020 21:43:21 +0530
Message-Id: <1595434401-6345-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

This change enables forwarding of MPLS packets from bareudp tunnel
device which is of type ARPHRD_NONE.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 net/mpls/af_mpls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index fd30ea61336e..37b6731a4576 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1594,7 +1594,8 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		    dev->type == ARPHRD_IP6GRE ||
 		    dev->type == ARPHRD_SIT ||
 		    dev->type == ARPHRD_TUNNEL ||
-		    dev->type == ARPHRD_TUNNEL6) {
+		    dev->type == ARPHRD_TUNNEL6 ||
+		    dev->type == ARPHRD_NONE) {
 			mdev = mpls_add_dev(dev);
 			if (IS_ERR(mdev))
 				return notifier_from_errno(PTR_ERR(mdev));
-- 
2.18.4

