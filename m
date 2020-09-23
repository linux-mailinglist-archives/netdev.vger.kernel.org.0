Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A13275016
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgIWEvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIWEvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:51:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870A3C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 21:51:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so2584124pjg.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 21:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Hek/EUUuiJ21rb1D7L0ndWNlIkQ0XxyJYkGIM2RfZU=;
        b=acKoghD9ML3XpmNTdVijoYiUK+hgipz337+vxW345N8Wjgy7R/DHFoakxLqbzYYqoB
         GvzHx62kLvU5Pm2c4Zn3Fz/gD1J22dLrrpNtZWVCrGHu2EpQhKbBQwPkIWK/BkEcv5/q
         5UFPzGXmfdMRmuoEZMDnQLW/TOMqRMJUWaS7SlqOwAFyWTXMZ8tOvTZyJD0CQ8AtACn2
         /6xtwilYmyuhlyK2lr+qRyRvr78HhdaUkp0XSyAw9J6EUk/Y8xMVgCqHTYPC5iMJc5DA
         4D13O59K/o9TvQR5W3IIzKrsgqC7JhDxccQ7axSGgmd9UdLnLuJLv+9L/PmKtHJron4L
         yfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Hek/EUUuiJ21rb1D7L0ndWNlIkQ0XxyJYkGIM2RfZU=;
        b=VrJ9hDvGX1PTJadPAcvTENww2NiIy1K1uXQNWZGUAWwpyswSJznvrQnAF/jOUc7tTP
         x2PMipzqI1+suwT/9tBtyF7aAZynQtX7iCrxkdCkIH7lebTn4CLHprtCfrGV4+/TZTAS
         Xh9KXMUYFk+yV7ZLvyUG5knsAY9YjVoDWS3CQqSrHxXAbT5xIoC6lxPwgSL0TKimXo/n
         FQKH8/VV66y3pQLdDk6tpayvwvXqC8PZ7D7+kukxPiJBs0JgG/3Apyn4kmITBqzNlIJZ
         JLJC7m2lCd6ZmNLKsulFW0dZZKsproPBLcPY5u5P0rBHPmT0pXHF07at7l6EOtGyaNTx
         I3kw==
X-Gm-Message-State: AOAM530xaVx7lEGEQC8pusQZPPjKCgU+j871sw3VgtHFM1hfua4U+xQY
        R03bk/pS/eWQ8sZjTy/nzR8=
X-Google-Smtp-Source: ABdhPJxwDIjfYxs3CpI0qMl1pwmCvY2YQd06iO2yQFz1yLDCzfWpWSpviMnMWuNRlzGjTrJgIjoo6g==
X-Received: by 2002:a17:902:6a88:b029:d2:254:c89c with SMTP id n8-20020a1709026a88b02900d20254c89cmr7725637plk.19.1600836710956;
        Tue, 22 Sep 2020 21:51:50 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id y24sm16349080pfn.161.2020.09.22.21.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 21:51:50 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH v2] net/ipv4: always honour route mtu during forwarding
Date:   Tue, 22 Sep 2020 21:51:43 -0700
Message-Id: <20200923045143.3755128-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
In-Reply-To: <CANP3RGcTy5MyAyChUh7pTma60aLcBmOV4kKjh_OnGtBZag-gbg@mail.gmail.com>
References: <CANP3RGcTy5MyAyChUh7pTma60aLcBmOV4kKjh_OnGtBZag-gbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Documentation/networking/ip-sysctl.txt:46 says:
  ip_forward_use_pmtu - BOOLEAN
    By default we don't trust protocol path MTUs while forwarding
    because they could be easily forged and can lead to unwanted
    fragmentation by the router.
    You only need to enable this if you have user-space software
    which tries to discover path mtus by itself and depends on the
    kernel honoring this information. This is normally not the case.
    Default: 0 (disabled)
    Possible values:
    0 - disabled
    1 - enabled

Which makes it pretty clear that setting it to 1 is a potential
security/safety/DoS issue, and yet it is entirely reasonable to want
forwarded traffic to honour explicitly administrator configured
route mtus (instead of defaulting to device mtu).

Indeed, I can't think of a single reason why you wouldn't want to.
Since you configured a route mtu you probably know better...

It is pretty common to have a higher device mtu to allow receiving
large (jumbo) frames, while having some routes via that interface
(potentially including the default route to the internet) specify
a lower mtu.

Note that ipv6 forwarding uses device mtu unless the route is locked
(in which case it will use the route mtu).

This approach is not usable for IPv4 where an 'mtu lock' on a route
also has the side effect of disabling TCP path mtu discovery via
disabling the IPv4 DF (don't frag) bit on all outgoing frames.

I'm not aware of a way to lock a route from an IPv6 RA, so that also
potentially seems wrong.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <maze@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
Cc: Tyler Wear <twear@quicinc.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/ip.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index b09c48d862cc..c2188bebbc54 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -436,12 +436,17 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	struct net *net = dev_net(dst->dev);
+	unsigned int mtu;
 
 	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding)
 		return dst_mtu(dst);
 
+	/* 'forwarding = true' case should always honour route mtu */
+	mtu = dst_metric_raw(dst, RTAX_MTU);
+	if (mtu) return mtu;
+
 	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
 }
 
-- 
2.28.0.681.g6f77f65b4e-goog

