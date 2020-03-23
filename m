Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F60318FFC4
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCWUsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:48:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42867 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgCWUsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584996533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=huVFHH9z29+35S5huD7Q2FJNAOR5an7AL8Bv1lal6/Y=;
        b=Ijgod2XuC3Lhq8R6IbYBoYbmjxw1xoUTxkJ20v7i2Vx7jyb8iodf7O8mRpM9niKFlO3l9T
        fFgxo1orEQrawAAesycEDy8j30qWtZv15n36leR0NZyunZRadMX3QFgVO11d95TmI+cQ8A
        qu8p8y3TMfhnBe6B7C8UKZSyzwVkwDs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-FjO0yjsqNhOHZphlupY7Bg-1; Mon, 23 Mar 2020 16:48:51 -0400
X-MC-Unique: FjO0yjsqNhOHZphlupY7Bg-1
Received: by mail-wm1-f69.google.com with SMTP id r19so396952wmg.8
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 13:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=huVFHH9z29+35S5huD7Q2FJNAOR5an7AL8Bv1lal6/Y=;
        b=ayOYLA5e6foH2OgFwbi0ObPgd0e90LNbNfyeATRBRlxaAwAAKgzK9xdyK+iDqKmZ93
         3oCQyPps3strVqiGVyWtQy8wl6J01fzMeRza60GSLTtuQeHeVxcxXCBK+9o3R7zUV857
         0g+Y2lG0mDtOKYtCYP/HVklqrdpo+dQlHFttTGfQuihEsCtWuIxF42Nld8o4yWZxEKix
         Dri7bl//7GhGZo5hzcnH++1s9TF3j/W6jh3Nt0uBNfLurGrfX3ZriwT1X6u5q7Zgh5sD
         TYoKEql4Y/94cEapEEeMvoMm9gdINERL9nPM7MQN1yx25324pF02tCBEXfOm11q3hUvj
         +k2Q==
X-Gm-Message-State: ANhLgQ2k7NfQsa2Fh9W6F3HUkxHXZM2KssNHemEfuBUwck1v4Fpqlwik
        JGd7rmp4Zx8rfeMcpmlZhSX9rnrv2Ibah0ipFtpJ6jl3nVML3mumWiFgp0uh7j8h6QgSlaaCayx
        P6886Zx3goItNsfYS
X-Received: by 2002:adf:de90:: with SMTP id w16mr20186483wrl.292.1584996529981;
        Mon, 23 Mar 2020 13:48:49 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vveACIRwVBVNIr6+FO4+y5htjIzI/9L7lRDFCKlRh8LKAKur/FQT7NiIqtjS73YvZjAUdMqjA==
X-Received: by 2002:adf:de90:: with SMTP id w16mr20186467wrl.292.1584996529830;
        Mon, 23 Mar 2020 13:48:49 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id q4sm1662703wmj.1.2020.03.23.13.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 13:48:49 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:48:47 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 1/4] net: sched: refine extack messages in
 tcf_change_indev
Message-ID: <50000fbb42292e4200431ee4dec26c4ae78279ac.1584995986.git.gnault@redhat.com>
References: <cover.1584995986.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1584995986.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an error message when device wasn't found.
While there, also set the bad attribute's offset in extack.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/pkt_cls.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 1db8b27d4515..41902e10d503 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -502,12 +502,16 @@ tcf_change_indev(struct net *net, struct nlattr *indev_tlv,
 	struct net_device *dev;
 
 	if (nla_strlcpy(indev, indev_tlv, IFNAMSIZ) >= IFNAMSIZ) {
-		NL_SET_ERR_MSG(extack, "Interface name too long");
+		NL_SET_ERR_MSG_ATTR(extack, indev_tlv,
+				    "Interface name too long");
 		return -EINVAL;
 	}
 	dev = __dev_get_by_name(net, indev);
-	if (!dev)
+	if (!dev) {
+		NL_SET_ERR_MSG_ATTR(extack, indev_tlv,
+				    "Network device not found");
 		return -ENODEV;
+	}
 	return dev->ifindex;
 }
 
-- 
2.21.1

