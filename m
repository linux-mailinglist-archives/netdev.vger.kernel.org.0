Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46003286C5D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 03:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgJHBWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 21:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgJHBWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 21:22:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4343FC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 18:22:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so2616424pfd.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 18:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+wvNeX6adtwcGsxQnaVNp3gmoXBkclIepmj1UUWaJU=;
        b=PAzAZD4iX2HRszKcX2IHM36Dmd9e/cRfp+FYrcCXAinsVcx8iDhfcGcmQhxpemz25N
         EVcXRuDYUfKqOURxkBTLCbmOjh3NFY73W4bPpHrssXwdX5LZBLx12T7vO2Oc6TkuStQ6
         P3ySrtLtTpNusGodX2znNbvLQceEJKFvE+AXqazX+soljY+Ovoxu/0uWO3W2vmJImjiV
         gerFYsqNPwiZmBxxvlqEVXshLesIMjgi0x1KA3N5x3BPdu+lFYEfOY0xuwlDlb4MJ9XO
         pi1rplUEKLJerg4lipn8eu2Eiuz0Q/kjVL8UnnWo+rSjPE5yiVOonLYWAfTLhK/s6HZE
         1+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+wvNeX6adtwcGsxQnaVNp3gmoXBkclIepmj1UUWaJU=;
        b=DgGZMwRaIUzaONvNOJpioMbnxRlCbMAZARBWgAjMB5rXEgmEO/ZeiWbGuE0J25SSH7
         3XG+oBc6lb4HlRF/ctoc09Ty8gJ0S8eh2d2mhL5k277j+m2bIvqRubcL2tacbVXTAzZQ
         g2tHxLgUk1MSvr/Enj3oiIyASi/X4wmmPwHZYBdglaaBe4aS4j3NsEedxlDg5jPn1gnL
         /52ZTyuHHb78rIhLPuCwxxHgMuddvhbJTmQ7Get7D0ZKlgCMiSJBMC386uzE178+scwU
         vsCCrIheHripnDWLnJixF3/wIy6d3gnpvXx/VRazpkI4r8f5lXEzAntaqAYh9q7IFpu9
         RlHw==
X-Gm-Message-State: AOAM533c3RvVwCMPBl4PeB27U+Jgmx3dnQwQEkPX14VUYm3nTqgXw8Sv
        Mh3+JzbSb+XAgN+mNYUZ3JyWQvVrvBlvQg==
X-Google-Smtp-Source: ABdhPJzbsFeTVIj6Zm49dFE43KUZx9npD4Zj9cv7qpaWYOE84dsQovQXUu5Qq+s1a+QALQTg46A7RA==
X-Received: by 2002:aa7:9501:0:b029:155:3b11:d5c4 with SMTP id b1-20020aa795010000b02901553b11d5c4mr1851015pfp.76.1602120131390;
        Wed, 07 Oct 2020 18:22:11 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id u7sm4627667pfn.37.2020.10.07.18.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 18:22:10 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [Patch net] ip_gre: set dev->hard_header_len properly
Date:   Wed,  7 Oct 2020 18:21:54 -0700
Message-Id: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
conditionally. When it is set, it assumes the outer IP header is
already created before ipgre_xmit().

This is not true when we send packets through a raw packet socket,
where L2 headers are supposed to be constructed by user. Packet
socket calls dev_validate_header() to validate the header. But
GRE tunnel does not set dev->hard_header_len, so that check can
be simply bypassed, therefore uninit memory could be passed down
to ipgre_xmit().

Fix this by setting dev->hard_header_len whenever sets header_ops,
as dev->hard_header_len is supposed to be the length of the header
created by dev->header_ops->create() anyway.

Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
Cc: William Tu <u9012063@gmail.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/ip_gre.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 4e31f23e4117..43b62095559e 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -987,10 +987,12 @@ static int ipgre_tunnel_init(struct net_device *dev)
 				return -EINVAL;
 			dev->flags = IFF_BROADCAST;
 			dev->header_ops = &ipgre_header_ops;
+			dev->hard_header_len = tunnel->hlen + sizeof(*iph);
 		}
 #endif
 	} else if (!tunnel->collect_md) {
 		dev->header_ops = &ipgre_header_ops;
+		dev->hard_header_len = tunnel->hlen + sizeof(*iph);
 	}
 
 	return ip_tunnel_init(dev);
-- 
2.28.0

