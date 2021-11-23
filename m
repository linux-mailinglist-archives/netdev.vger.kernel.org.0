Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C7445AD70
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhKWUkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhKWUkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:40:19 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4075CC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:37:11 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g28so159875pgg.3
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJBH1JAXhSB1d1xZwo45FF71m59d3MSt1r3XvxpX7LY=;
        b=Wsip1urqYjLZUcFBkZ6+kKRwMdpqWvuj/7GVzKddNY4kJyMtP0pyOO0uTlikkQAD3J
         MazuvOGDzS2Z3b4OPugx9XU//HFD9aj7eVWp3r0JBaxefWp5jmHnK43nEJMtWLg7lerB
         W80VIYyiVy8WD9kVrVociyJZgu399F7avd2yjfQRkDyh9Dx2sbQcJaorD5GkHiop/QHD
         DaPljZRZfxmIVPhTeopkNc4qXuK/z05Z5s0YBa1WyRrc3SbJ4OQbXxnegUsIozBYOpoQ
         mGwr00FdNC1mG/Q1HZ/KVTVHjEcPEhtDPc2WxLoGu3SukLVfYMmKCWXNnnKffV1uEZ9t
         PJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJBH1JAXhSB1d1xZwo45FF71m59d3MSt1r3XvxpX7LY=;
        b=6KKV4/XHa/8F4zjVWDr6WEfWD0u2BFh5kv7XmBId9gztg1wuP/B0/HkGoyT8et9kox
         FalyZ7D4vqxDoB5Wk3MHtm8lvqrG9QZSWBffOedJ/MbtkJ7z4L9/4wgcTuyESdCVTD8b
         WyS4uEtjlaG854gX+fI/AovqDqTiKvzQwxyRLaueyfaS8kZ+3xYHLEsgUF0Di5S1UXku
         JKn5YQ/pRdddZrRTF+nUGKAlCivI0sTT2oICTuomiNONJ574rlm+SY5rnuArUvOUgpyc
         D/gCZRWaUxVYMyj6om/V6m+PCwUZrABr7Yiv/L7eYJ6+muXMvlBWNqd5TKWLX8wOwFcj
         YrPg==
X-Gm-Message-State: AOAM532QDEC9D0xPmZINbaz9ZOlGbFn1qEs8RiTL9mWEVqkThCRjgsuq
        uXWB+NU3eAiAL/RrzJzkcwL+dkPt1lhIdw==
X-Google-Smtp-Source: ABdhPJwk9pFeDl9SPQGNY98Vg+Z+pofRIrsrDSr9IXu53j5xarGdeRE9lwt6sezxp1yshyJx7xQ6EA==
X-Received: by 2002:a63:be01:: with SMTP id l1mr6058937pgf.445.1637699830640;
        Tue, 23 Nov 2021 12:37:10 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:cd70:5ac2:9066:1bb8])
        by smtp.gmail.com with ESMTPSA id b15sm15148620pfl.118.2021.11.23.12.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:37:09 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Subject: [PATCH] net: allow CAP_NET_RAW to setsockopt SO_PRIORITY
Date:   Tue, 23 Nov 2021 12:37:02 -0800
Message-Id: <20211123203702.193221-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

CAP_NET_ADMIN is and should continue to be about configuring the
system as a whole, not about configuring per-socket or per-packet
parameters.
Sending and receiving raw packets is what CAP_NET_RAW is all about.

It can already send packets with any VLAN tag, and any IPv4 TOS
mark, and any IPv6 TCLASS mark, simply by virtue of building
such a raw packet.  Not to mention using any protocol and source/
/destination ip address/port tuple.

These are the fields that networking gear uses to prioritize packets.

Hence, a CAP_NET_RAW process is already capable of affecting traffic
prioritization after it hits the wire.  This change makes it capable
of affecting traffic prioritization even in the host at the nic and
before that in the queueing disciplines (provided skb->priority is
actually being used for prioritization, and not the TOS/TCLASS field)

Hence it makes sense to allow a CAP_NET_RAW process to set the
priority of sockets and thus packets it sends.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 31a2b79c9b38..1e49a127adef 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1135,6 +1135,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_PRIORITY:
 		if ((val >= 0 && val <= 6) ||
+		    ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) ||
 		    ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 			sk->sk_priority = val;
 		else
-- 
2.34.0.rc2.393.gf8c9666880-goog

