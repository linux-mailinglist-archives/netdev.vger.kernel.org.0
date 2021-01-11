Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD102F126B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAKMj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbhAKMjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:39:55 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0EDC06179F;
        Mon, 11 Jan 2021 04:39:15 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m6so5314989pfk.1;
        Mon, 11 Jan 2021 04:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=LN8iCFkEESN0ochju51DttjgCNR10tVmwy/p3ps8lpk=;
        b=od/VJAVV3AUfx5X4yiqa9SB96KL+e0rqJ7X6sB1bVKWf3NXM+vMkSvFYqwY4IDMGqO
         395tg/N7zv2ztEGmemp1GAWsCl7zXeGaJtUJ+O2Tcj++4BwxxbWf9HLO+75vSPIdt6Zo
         ogJ895vH3VasHiNGL25irLQ4OZ09BIiWGpk2hrEk2OwkWTxavEYcsTW9PGxqIdJIn7+Z
         hH6FV8JzM5qCbG6qGvnH/lgdODnTtkUdfQ1JxV+6LVKpdmOi92i9z0T26swC0pD2/Ypa
         TlxO9yMmP90dxJtBsQUGYaEKXvApb5O4Pl23FI4kntP4pNKz+7C0He/uswOu17gCgobb
         1Gnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=LN8iCFkEESN0ochju51DttjgCNR10tVmwy/p3ps8lpk=;
        b=jhrxEMau4IFafw+qkVTZcC3d7OfA3LkcaHcIWKHIv1tX9ldkrcVZ716p28SxH91ynU
         kcTFycVZLwl5uZabg6ghR6tr6VvGXbKrsE0Lkkv1W8+ttg+VhmUmywETL2Ia+cTTXKSe
         rHsVxxtfgGtdYSietJl1AZhHAaDgKTDrMTNImOPtsM1gK7/RQesNDbCRUGD9lpK4OBcS
         1W0gjAEvVAZcZ4U7Nr4+8jzaTGLVp+lDP469t1QqC9K6q5CIFrMqjNV3rJ02qURQ3hnJ
         p6LVJipn7uyDNkucwMBJzhQfaadx7/Kj3NNKELGNGYiQsJPy+7XA1wsk/qYOkcGEGnZr
         OYmA==
X-Gm-Message-State: AOAM532g8f4zn51NA1Sp0ALkZwtwYaArOV8kIPKDeNEdDo05X9OyW9Iv
        Why5QCbfJx5CW0F4wXXmyi5rgA/JVIKQQw==
X-Google-Smtp-Source: ABdhPJwqkqwf7nh1xqWs8FtOMDcBQEuUQuiVRlg9e+Z7waoBBPLQWsoU5d3MXD6Wq8dMxHu3kZnaMw==
X-Received: by 2002:a05:6a00:212a:b029:1a8:6d7b:d62e with SMTP id n10-20020a056a00212ab02901a86d7bd62emr19170407pfj.23.1610368754732;
        Mon, 11 Jan 2021 04:39:14 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f67sm19483908pfg.159.2021.01.11.04.39.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 04:39:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 2/2] Revert "bareudp: Fixed bareudp receive handling"
Date:   Mon, 11 Jan 2021 20:38:49 +0800
Message-Id: <7119d2c8d500ce50e610df3f5a55d5fe7005d8a1.1610368263.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8636d49cb2d5deb966ba1112b6d0907f2f595526.1610368263.git.lucien.xin@gmail.com>
References: <cover.1610368263.git.lucien.xin@gmail.com>
 <8636d49cb2d5deb966ba1112b6d0907f2f595526.1610368263.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610368263.git.lucien.xin@gmail.com>
References: <cover.1610368263.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As udp_encap_enable() is already called in udp_tunnel_encap_enable()
since the last patch, and we don't need it any more. So remove it by
reverting commit 81f954a44567567c7d74a97b1db78fb43afc253d.
---
 drivers/net/bareudp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 85de5f9..aed5049 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
-	/* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
-	 * socket type is v6 an explicit call to udp_encap_enable is needed.
-	 */
-	if (sock->sk->sk_family == AF_INET6)
-		udp_encap_enable();
-
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
-- 
2.1.0

