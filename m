Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645A24E2AC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHUV1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHUV1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:27:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5348C061573;
        Fri, 21 Aug 2020 14:27:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 128so1586923pgd.5;
        Fri, 21 Aug 2020 14:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QWnVqkXsQ2VHac6sNBlwzOFyH2VOJDY/ZCWON4QvS5I=;
        b=O5ysZ7BX+yeoWYpqn0zquTNx0iwRRKm2Bzx3i0KWfMjzIB59kkB+pfCQadtv+THzVF
         LjYONAb2xWOCOooyA/gOSaHcBtzivEBljT9wbum2c3BIahbl+nDRM4pZ1/MVlz7HS077
         M3cGX7Z8/QRJ5bRx86su5ApaXmUtndHcN3vWWao5asovSjC0tGD+HB7jNgwgsc6kusuT
         6iqbs9NPOuGfI1bNWxIfHB14J2N1BLeFzSRL5qOwzsDWsvMwEJWM3oEKjyq3ghqUeUWD
         HJRy7cN/FLGd4JvsDQvbkSgbMHJPs9pNxeC8jpha8jvKpoEteXjMOamRYaG91cpi0dSR
         Jfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QWnVqkXsQ2VHac6sNBlwzOFyH2VOJDY/ZCWON4QvS5I=;
        b=jYolLoQrfdhQva0pBGReMAxxIhJqxSyfl/yUsKONdCOKC1LyGiUtOx6vV6fFfpiTLY
         6tZg3hK6Hd3g4PwtLExUbdpav0wRpGekOsDVfP2fe3CLDPbzYt32Y2+szRfmsdmSm9hb
         oTgUkjRSPjKDMnlpJDuUHnpwjNimV/6AZVw60Vi7rcWbTcuNy6dr1+uxgpsBgwkJqD/r
         HiVQ6ZyyTIWS0gD+2FjguREappYaoRvbMLqEi25oKGlQY8AiW/1YbHe3ELTZhapzfVgh
         P7NeDh5+1P5CSZzPaOrJzVaMAeH+XEbXPq+UON1Zhn4bWcBdn7bi/bitwfaZv/fkCQJg
         V5fg==
X-Gm-Message-State: AOAM530Xni5GndUNzDp9Icv+AWOZs54Pp9s6fY2QG1M8wQ020CIJUxJd
        BawDP6u9bXCd6w8G9OTs/64MuTpXRXE=
X-Google-Smtp-Source: ABdhPJyNJHaQhxQmL0Xty5/tLXUcqT2A3go11AbPNwihM9m6T3s/IKR5KxH7Ajta0gztQMLP8U3Cjw==
X-Received: by 2002:a62:164a:: with SMTP id 71mr4035129pfw.266.1598045261183;
        Fri, 21 Aug 2020 14:27:41 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:4c03:c51f:2cf5:9726])
        by smtp.gmail.com with ESMTPSA id l12sm2780525pjq.31.2020.08.21.14.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 14:27:40 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net v2] drivers/net/wan/lapbether: Added needed_tailroom
Date:   Fri, 21 Aug 2020 14:26:59 -0700
Message-Id: <20200821212659.14551-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The underlying Ethernet device may request necessary tailroom to be
allocated by setting needed_tailroom. This driver should also set
needed_tailroom to request the tailroom needed by the underlying
Ethernet device to be allocated.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
Change from v1:
None
I'm re-sending this patch unchanged because the previous reviewer has
stopped responding for 11 days and he didn't indicate what change I
should do to this patch.

It's hard to find reviewers for this code. I tried to send emails, but
people don't respond. If you can review it, I'd really appreciate it.
I'm not in a hurry so please take your time. Thanks!
---
 drivers/net/wan/lapbether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 1ea15f2123ed..cc297ea9c6ec 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -340,6 +340,7 @@ static int lapbeth_new_device(struct net_device *dev)
 	 */
 	ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
 					   + dev->needed_headroom;
+	ndev->needed_tailroom = dev->needed_tailroom;
 
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
-- 
2.25.1

