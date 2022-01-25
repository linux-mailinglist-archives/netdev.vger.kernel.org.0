Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D3249AF4A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456004AbiAYJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455315AbiAYJEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:04:07 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489D0C061345
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:23 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z20so4900766ljo.6
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k43NlouVQB8hM1beYosBs1yb2iePFVYZFONuMP14vSM=;
        b=zp0RDdvCCfDNZfHZsadkx2auxVmRnOOpvABVv9a1MtModBQsy/um51GjHOd7t53C2N
         tA/G2rMzpf9wWg761k/ef2SUVbbzAlVs+mozPmJjymGAUK5aAiwRQfO9lqwGVxuK5otI
         Pl1RMPJRJoo69MW/tkfnBcf3JEn0aqVRkjuYH7BCr0Pg+c0rglS3vio4S6gl7bQ3UGaX
         1nscK/FwgBv2TA0EsI+2kfdGD0JEbkH1eUyfkEWgAx/EtxIiGFnJMBxIBmnpy6KBN84l
         tTtoY8j5IXK9nVZT2/cuCoUN70rFwtLCwgB0kS14UaLp/KVsdxFJ+fsZKbwvjAtdn1Ll
         DoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k43NlouVQB8hM1beYosBs1yb2iePFVYZFONuMP14vSM=;
        b=rNcMiVc4wqbBKgBgRk578Q2dkcF+ioCslTEbYc7dq3z+KBUq89a3bh1wIXGeLgG/mf
         dX7zTND5+bkEWAf8QE1Yb/a9zVCb2/9qsRHsduXhbVTyLf2yHcf53b9IMe4IEudMuXa2
         PlqtyIBoLBaTnTD2KPJsalAVPLzNKU3NK6R6eF1CSxAtcnYrwZkil3GLrJo5wzofOQpL
         A1EDuNeAheumY5GNY3Q0hmK5aipSzClkyvo6UieTV++t7laC8ygeQnZy3S2MPA49h+mx
         UdE7ZeLu4LzZ8r3/6p9/8MdKsI0Ps3D89u9ZmFwggP/U3MdHXR0/DNRnIjCrMdWn0agW
         Bxqg==
X-Gm-Message-State: AOAM5321i4qkCygCjemFgw5y8HK1P/eABZgRHhKkNFJETTu1TT1F9oIN
        hh2MDWl/MwV9rHXcjWK2EdKRkA==
X-Google-Smtp-Source: ABdhPJyYp87wYisP2/l1MxOBncqSB6zBTz6Bvqiipiw7V7kXabqJmsZ2TUeV3tPNrW20SUDhl6kxAg==
X-Received: by 2002:a2e:b914:: with SMTP id b20mr13735990ljb.6.1643100441653;
        Tue, 25 Jan 2022 00:47:21 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id q5sm1418944lfe.279.2022.01.25.00.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:47:21 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
Subject: [RFC PATCH 1/5] uapi/linux/if_tun.h: Added new ioctl for tun/tap.
Date:   Tue, 25 Jan 2022 10:46:58 +0200
Message-Id: <20220125084702.3636253-2-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125084702.3636253-1-andrew@daynix.com>
References: <20220125084702.3636253-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added TUNGETSUPPORTEDOFFLOADS that should allow
to get bits of supported offloads.
Added 2 additional offlloads for USO(IPv4 & IPv6).
Separate offloads are required for Windows VM guests,
g.e. Windows may set USO rx only for IPv4.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/uapi/linux/if_tun.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 454ae31b93c7..07680fae6e18 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -61,6 +61,7 @@
 #define TUNSETFILTEREBPF _IOR('T', 225, int)
 #define TUNSETCARRIER _IOW('T', 226, int)
 #define TUNGETDEVNETNS _IO('T', 227)
+#define TUNGETSUPPORTEDOFFLOADS _IOR('T', 228, unsigned int)
 
 /* TUNSETIFF ifr flags */
 #define IFF_TUN		0x0001
@@ -88,6 +89,8 @@
 #define TUN_F_TSO6	0x04	/* I can handle TSO for IPv6 packets */
 #define TUN_F_TSO_ECN	0x08	/* I can handle TSO with ECN bits. */
 #define TUN_F_UFO	0x10	/* I can handle UFO packets */
+#define TUN_F_USO4	0x20	/* I can handle USO for IPv4 packets */
+#define TUN_F_USO6	0x40	/* I can handle USO for IPv6 packets */
 
 /* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
 #define TUN_PKT_STRIP	0x0001
-- 
2.34.1

