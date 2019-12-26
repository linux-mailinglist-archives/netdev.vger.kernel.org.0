Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B73212AEF3
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLZVfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:35:25 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56316 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:35:25 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so3838131pjz.5
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I8OAdcktKNNxLldYp1vXyJmIqrTlmpirUH+a3CmCZSE=;
        b=CNpwjnbELqVd++shT+XngHtUkMjCIzkksUVMEWee7KQfuqkGtnHcn85AEJchju7aYE
         2Aqn5+CztQ0AV4sklbHi/ttRaf46jpb+smpX9m/V7IKZUiyXfbZxx+1fkV1SsiwuF2WR
         7U/XqpnXcZO8tj6CUegL0eGxl0LWxT4h3o4iOcVHfsx+EaozQZiTkcuIEPFPhNt8V7gL
         TaWqn1bv/m3Zzt03YCekqbRMr9sKssBu3TheP/6JS2eBfVnor+bJFqP+fA+ccdGP/Squ
         ZIfZA2d0pJckBra+4RGlbTEjgwPpzEnZD+35lxL0MpnxI42EYbopXVeTRO7G0Mw+tah3
         J0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I8OAdcktKNNxLldYp1vXyJmIqrTlmpirUH+a3CmCZSE=;
        b=OMSRqpsINkyC2W8svSO5duH0egUU0yh8JRivG9nGl1yPBFyrLKoEHBjp6KnqE5t6XX
         P4PZxrPYrDRQVETXYv9hKY1ZtJc6YXvWoqsdds8iMbOpgUMvdtO6p+/ZteqW4AtQc0X9
         vskIL9508C5HBgLLMg0HzUa2r1LoPB3BLVpuo11IUnndaKa+Sn32cjPQVzfJ7kN7G5BM
         8W3cDUzQ7YXq56Jf0a1zFCrj5Xkkh5kEDZzO2dbdtofVDfZ1yYWk+kpJLWgvNt8D4red
         /E4Cw26YX/rNfJfzhwC1+9tfpo2nyI6r7xNlZa9PxpbLaxcy9niMuSezP4yA40iyVgDV
         nOdg==
X-Gm-Message-State: APjAAAX4YBMlMR9YC7DOzCeJJWIuSDL3XF5dO9M3xjx3vsef0cbPSK74
        MBabr/zRdMTrvgx4rZl4p6jz3J0cDdw=
X-Google-Smtp-Source: APXvYqyl1JBPb/8G+a/k4dUV+eIUvC9MsztwOO4KvW13PUdw/XHEfh1BIGalQU8FYB1r3d5u1MQ2SA==
X-Received: by 2002:a17:902:7288:: with SMTP id d8mr46701484pll.341.1577396124373;
        Thu, 26 Dec 2019 13:35:24 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id q6sm37996662pfh.127.2019.12.26.13.35.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Dec 2019 13:35:23 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH net-next 2/2] net: Warning about use of deprecated TX checksum offload
Date:   Thu, 26 Dec 2019 13:34:59 -0800
Message-Id: <1577396099-3831-3-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577396099-3831-1-git-send-email-tom@herbertland.com>
References: <1577396099-3831-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a warning in netdev_fix_features that NETIF_F_IP_CSUM and
NETIF_F_IPV6_CSUM are deprecated and that drivers should advertise
NETIF_F_HW_CSUM instead.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 net/core/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0ad39c8..ef09fb7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8835,6 +8835,10 @@ static void netdev_sync_lower_features(struct net_device *upper,
 static netdev_features_t netdev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
+	/* NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are deprecated */
+	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+		netdev_warn(dev, "NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are considered deprecated. Please fix driver to use NETIF_F_HW_CSUM.\n");
+
 	/* Fix illegal checksum combinations */
 	if ((features & NETIF_F_HW_CSUM) &&
 	    (features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))) {
-- 
2.7.4

