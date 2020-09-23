Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C6B2761DB
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIWUSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgIWUSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:18:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D4EC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 13:18:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p16so384783pgi.9
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 13:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=boOIxhUxOHbOCqVTnoxAdSoDT3OVN0nOXlllUNKf4Lk=;
        b=pO5v1itDUPv8ky0LzVzzyajNFBb1ypuvxZ9UUPxjvENEsnkgGwb6JjmrseFmh0mMWJ
         nxAxqBswRWUruJY8lbw7WBjwiu36i8jw95C4E/o2U8yMD7Uo6Iy4HRfeMkQWcHEpkF+/
         iXzr+N8tS/QnQXPeD1TQcYlpAElS3LVcfk0tZRCmi/ucHaTJ1MYqiyGUj5llAHUQmng1
         0ja6WuyUAIRjzksB+wD30bQfeD1GP3NcxaXhNzurRmq6310gpBMx0851axLYx0Yy3vVe
         Gn47gtDIM4x/P7hha2FbbXMcxZTbu3M0ujNEzMNF5V3HCQZlwmoBAkhs99vjdwNvwCKN
         HpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=boOIxhUxOHbOCqVTnoxAdSoDT3OVN0nOXlllUNKf4Lk=;
        b=YAajc71Um/sk9dRcJEX1haMHeey63hHZgDFHwe0MsHMvB8LvcSPuRUtq7SH6NODjg/
         qB5I82pVNajDW7kpKSmZpuvCyixLYKcFjQ2P1OWBT1FXjgytrCe6a2QkYRH7bHUJfJLE
         sfyXOvsDTzxV25mxkx7hFPb18VX8gEhR9Byy60OXQTdZZ2qubCXDvarvZ1HlZvu+J4cI
         XHoumn/hSNeDWM6QCQecMsJF0nMQUWkt3pqDRgAq9FpQtc/xSP9BQXQoXNF9o2zXFCTc
         5SbKGSqVncjGrADRK9dSn5+4dbOPhAE5PWyDRhpnvh/ji+IcL/S2qz0dzYCXTjbB9OMm
         /Wjw==
X-Gm-Message-State: AOAM530Uoxw5wTghSv6ONTG5U2rnaXBL2KYZzjZuUW3YyFGFVmki2an4
        mvTCGDFti2iH1f2LtPwhH8M=
X-Google-Smtp-Source: ABdhPJy0Bq1y5NQbOvctNGDA8kb+sufrxVEtNfxErQjAHvvpiDfQXzSY0QONg7CsB4OcJqflAMN7pA==
X-Received: by 2002:a63:ff07:: with SMTP id k7mr1193434pgi.39.1600892304324;
        Wed, 23 Sep 2020 13:18:24 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id e10sm311196pjj.32.2020.09.23.13.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:18:23 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH v3] net/ipv4: always honour route mtu during forwarding
Date:   Wed, 23 Sep 2020 13:18:15 -0700
Message-Id: <20200923201815.388347-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
In-Reply-To: <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
References: <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
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
Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
Cc: Tyler Wear <twear@quicinc.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/ip.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index b09c48d862cc..2a52787db64a 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -436,12 +436,18 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
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
+	if (mtu)
+		return mtu;
+
 	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
 }
 
-- 
2.28.0.681.g6f77f65b4e-goog

