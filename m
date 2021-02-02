Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF830B811
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhBBGxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhBBGxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:53:30 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE96C061788
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:14 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id e18so22675004lja.12
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEnUir7NULfyhfcHWwSmbaRoX9scIfA0jMqc4I/U48c=;
        b=rlmUa3yOSX8RmxkxFfl0r2D59SbMBWwGHCwLaaWnxCMvEdLNmivBdgZ1iAT2n9nMMb
         GTpz49/mW6TOwBeAHz6Y5R/baVSMfHFRaT3LLQ3R3mP8k2dMbWk+7I5ck4aHXriavBtC
         Nu51MMhNWibavFQWeb7MmVshgsYEpYm5MDCxP99ZIxxTS3DcJ/7UivOAp1Ys1CLhjnRJ
         KvXD3ClEuwzZUlhQwSLRw/3HL3gEBeOmmpARr0VroOa05B5ApJTIkt2IT9hRabVnsvCx
         KDDJdklLIdlLL5B2nqzSmiYNymEpweveVLgq/xEO6Bv+qD8pwP1ZDxBE/MO/AVnanhxE
         iK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEnUir7NULfyhfcHWwSmbaRoX9scIfA0jMqc4I/U48c=;
        b=R5ugd0ciyuuvvI4O1j+09QM6oXaBo6JhzeguDZb4H1IdLkP+0Uo2IGv8jWImlknaym
         W8KVjvjCThTKT+T2Ia1kyA/7rGOT2mOj882n5lzPM8rMqkWnsKh2iQ3cG677Zw8Zuv4Q
         BrJt2gAJecwxtxqIsPGnZkZcrs2Xr7cMb2I5rF+d34wHPSwLW5e/7qcNI/82BzaMojLa
         jKUUl6k1OPGUUiPEvjd49MfpqhO8hTkIldIRU4mzIWXXR+LDOLiyXtDNUfpttRXaPMrZ
         OYgZ0d52s76swA3lNE5nY7O8ei91a+PjfaKNglBlimMY9XCIvuBRCWejCNWyapvrI0KI
         QnXA==
X-Gm-Message-State: AOAM531q+QiO3Oc4ClNqVcLTZi6TEdTJkP6+UxbjYmkt0b2t4JZYK541
        mJ8WIDzKxUzgMUpPI77m9QNhVw==
X-Google-Smtp-Source: ABdhPJwBfwCluWWhHX+7vTAnF0IZexsto8DOK5h9oTzGD6jbBozuwhynI3kR38XnVlrmqFsFuQvOFA==
X-Received: by 2002:a2e:90c4:: with SMTP id o4mr12578204ljg.268.1612248733158;
        Mon, 01 Feb 2021 22:52:13 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:12 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 6/7] gtp: set device type
Date:   Tue,  2 Feb 2021 07:51:58 +0100
Message-Id: <20210202065159.227049-7-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the devtype to 'gtp' when setting up the link.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 04d9de385549..a1bb02818977 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -610,6 +610,10 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 };
 
+static const struct device_type gtp_type = {
+	.name = "gtp",
+};
+
 static void gtp_link_setup(struct net_device *dev)
 {
 	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
@@ -618,6 +622,7 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
+	SET_NETDEV_DEVTYPE(dev, &gtp_type);
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
-- 
2.27.0

