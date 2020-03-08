Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEAF17D0CB
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 02:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgCHBTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 20:19:39 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45746 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgCHBTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 20:19:38 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so3105847pfg.12
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 17:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dBoiH9t2knqWW1tRshylPv1WgUbDBqY7rGHDWOEn8Yk=;
        b=P+OSalS1HaRDGjmh0QOHySTOn+vCYxunNybqAWckdjhr6WEalkTJBWvQ/NJFIXksC7
         U1lK09hEYKvvOngLyue2BCSLBPjiJufFUtE0kxa2Ld36MPGp6EGIHNdcvBX7iGrek10E
         jJDa8MGtA/1wfwpqr/nlce8BjPInt7fBiWYNR3DSIkFiRqkdxUxLU2wMZujm6J/mQgn0
         RAdNy7aBB9r04BRwuMfB8F1fdsvxQ8e+C6m9Mf1Kim1je1xIoaz5l5UrAgffWhWu3mv7
         WY1MEaKrXyegWFhrQInjZmqAek0Narz6XzQIAazrUe3NQlL5DRu482IR5l31MGToA3jg
         +Fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dBoiH9t2knqWW1tRshylPv1WgUbDBqY7rGHDWOEn8Yk=;
        b=uhjjS+i34W9q1HV0ty2atqXhBeImzk6JMqBcdJuYGsg/I4vfeywwY37PH0LTH8d5X0
         OJcB3KjB6Jt7KEvsyfQFNZODB/8Or1J5c1IO1Oc+pIFunBIGe1GimMoAMfKS3O0xe0Tz
         fnX1HAFmkBgDjn0KMkmUSop8J/Xg0cBQyLd8rVa9yUiiTfKG//0Lc9kSgOiPMyVYk1AJ
         R5HMftxS9aU0/7CHNuQwRt3wPaZmHm/+A6OyeYyl0eNbblF0IHx5BWhThfevNrZ0DF8y
         r2LBIVSBEmH5yPW9H+YRMZghbaWPmDAAoTSwDKnS6hw5TyQUy+7EiOEQ8nUtnCu6fYiY
         uRrw==
X-Gm-Message-State: ANhLgQ26ncTAyS2fxHf+97ZY3hUYosoa0S0RJgh+zy17bxoUk9ybwcEU
        h7fC3IoTTrvrKp3xbeNgWYM=
X-Google-Smtp-Source: ADFU+vv1v23Y0J8A/gDdn+qT49yXjwdDmSZuEquckFxWeV2dZ5y0vIDnDU1WoCd/Bcp3BWoZYp7qYw==
X-Received: by 2002:a63:5546:: with SMTP id f6mr10186633pgm.260.1583630377399;
        Sat, 07 Mar 2020 17:19:37 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id i197sm38164743pfe.137.2020.03.07.17.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 17:19:36 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        martinvarghesenokia@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 3/3] bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()
Date:   Sun,  8 Mar 2020 01:19:30 +0000
Message-Id: <20200308011930.6923-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current code, udp_encap_enable() is called in
bareudp_socket_create().
But, setup_udp_tunnel_sock() internally calls udp_encap_enable().
So, udp_encap_enable() is unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bareudp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index c9d0d68467f7..71a2f480f70e 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -250,9 +250,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
-	if (sock->sk->sk_family == AF_INET6)
-		udp_encap_enable();
-
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
-- 
2.17.1

