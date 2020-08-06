Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC82A23D56F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHFC2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgHFC2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 22:28:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321D3C061574;
        Wed,  5 Aug 2020 19:28:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u20so2147542pfn.0;
        Wed, 05 Aug 2020 19:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=BJzx13SAAD8E0rIJfj6pRh0FzKS0NoLgCdQQcttiUsQ=;
        b=QbHtTavwBm6EOBB0ka3itQYmyguF1rko1UQ9BY5T+7R/8UFmfF++gwLsjfJtr9WS0E
         wZJ+66z1CU8nGBpiQqH65mFo3g9t2H21qWyyERjiVDKmhwM4sK28T1Nr85R6h3ETxoKz
         TELWZXY6faffzQyuw6SwvLBc3hQZG9M2txsYKlg7dEt33M6xvl/pJb87hM6syowD0Vji
         O0xLsyolCYllqiociky9nrF+9rrrWQ/4R2WSCUzVS+ERDFNBxxKIBbBSzuHqDeg5UOLp
         YhSJ1RFH0uZBhvW+g/yeKbr8MkJAQndea2z+c4Wx4iaB5H3QYQiGLXgeyZIGuOGIwOz6
         tllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BJzx13SAAD8E0rIJfj6pRh0FzKS0NoLgCdQQcttiUsQ=;
        b=cUeQNsrP6QxYNOBxfgzqLs6fnH6pTTo2QADxsiU/3JH9oBk5ol6CZGzItWJz5USWWq
         vPAJVp9MUW2JdnRXK1U9JoY6toLulZ5u6Rxwi2tiwHD2o6TLrZ3cTiQWvnzHNcz4BJTg
         JqlQClsG69Nj3vts3ZANWU/e8nQi8kh4bjvGijfv6EYvnEv9uHGxqYu1FpqfmbCu83TV
         iyhjKM4n619WRaVx/0vR4sJ0MO6IvDTF6l2TLLte0d8GuF2hN5OAZfwm+j279V74HWOS
         WfyjVyy9Xgko6k7jHUd8d0nzT47NHpEmIYNDkt6w2aUb6NtciqdbnQA7LWFJIJcb6Jsa
         wqHQ==
X-Gm-Message-State: AOAM533lqGvA1DendOhqld5rgWMi68pDRa6KAolZPtQP5+X8pT5DxTG2
        DAvIplZ7XJWi4Q0L2+LkYVj5128X
X-Google-Smtp-Source: ABdhPJy+oHC+2kRMLWgauFJIm4yUmEdu2ksQqI906QPw/bPz+gxG5Un9Kp1u2KpZ6sTKAU3pyjmryQ==
X-Received: by 2002:aa7:95b8:: with SMTP id a24mr5893703pfk.219.1596680892349;
        Wed, 05 Aug 2020 19:28:12 -0700 (PDT)
Received: from oppo (69-172-89-151.static.imsbiz.com. [69.172.89.151])
        by smtp.gmail.com with ESMTPSA id a184sm5674137pfa.83.2020.08.05.19.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 19:28:11 -0700 (PDT)
Date:   Thu, 6 Aug 2020 10:28:08 +0800
From:   Qingyu Li <ieatmuttonchuan@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: enforce CAP_NET_RAW for raw sockets When creating a raw
 AF_NFC socket, CAP_NET_RAW needs to be checked first.
Message-ID: <20200806022808.GA17066@oppo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Qingyu Li <ieatmuttonchuan@gmail.com>
---
 net/nfc/rawsock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index ba5ffd3badd3..c1302b689a98 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -332,8 +332,11 @@ static int rawsock_create(struct net *net, struct socket *sock,
 	if ((sock->type != SOCK_SEQPACKET) && (sock->type != SOCK_RAW))
 		return -ESOCKTNOSUPPORT;

-	if (sock->type == SOCK_RAW)
+	if (sock->type == SOCK_RAW){
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
+	}
 	else
 		sock->ops = &rawsock_ops;



