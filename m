Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406602AF463
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKKPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:05:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbgKKPFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 10:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605107148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=0SHYGIVqU+ifW0mWHHZIrQ0cDQWnVc1aa0xWSTwfZqo=;
        b=By2bMLjHVHs2tUD7ZK6C7F4XTM8g4uCV4T4G1uPuYk6IXRkSShelD5laPZY3VHzs+hZnsO
        LwLj+WUpUSR9EWf/+d9Mc+niW33XR24LU0aMeXSwk2b/yiLvrGPKxPiAbux+KwbRO+VS52
        Zu9YDrJNFqCXWC92RL7kWrD6aS23UvU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-53u9ICsJOoGZ_8TMujvA0A-1; Wed, 11 Nov 2020 10:05:39 -0500
X-MC-Unique: 53u9ICsJOoGZ_8TMujvA0A-1
Received: by mail-wr1-f70.google.com with SMTP id w17so684902wrp.11
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 07:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0SHYGIVqU+ifW0mWHHZIrQ0cDQWnVc1aa0xWSTwfZqo=;
        b=kwOBCKz6NmCUrhDDYj602nlego8xajROzqT+KDNq0f47NycV1j4IJ71P0IE/LahQFn
         X5DnMZOEHp2oHkYcloA9qGCnGlpioQamKVu9Vtt3uB2vMf7Q5MIzUDpVZ+7MfQ/cHb0W
         mdUNRSxll9VegywLRNqvZO3qAKS4VlOaShkst8WsuXdpypuf9QCabQ8CkMB3wRw2TmEc
         tfowSsuyC3D4jwtEx3YOAVWN9aK9qqCyEQkNLmiZ4KnMJEahMyxh/Ap4tM59tC3OYGMR
         Xg5jVrBmItsVscgQ888TVDKvcUJGbXX7U4w+/aAm7N2ULs+2HpeZ8MSJmzWQrZ/eqqHc
         sTPQ==
X-Gm-Message-State: AOAM531C2dFt3gPBeOS1kak57pm3qvXxqa7YEZP79mZOmq4GZQ9B9mC6
        +m9Rv3rLqcENYknfK1o3IlYFy5Ba8ZuKMQStgCN/m7WuWw/+hcnoI9GeiQQW7n65H7TPJVb+yv/
        NQLyZnpcMKFfC75/g
X-Received: by 2002:a5d:4d86:: with SMTP id b6mr30071887wru.369.1605107138369;
        Wed, 11 Nov 2020 07:05:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysq1qKknl/DJoTqwrl4D18aR/iXtlgN+GmLcojpMoEuli60TwpEaT1WsGYjc4UCl9srocJkw==
X-Received: by 2002:a5d:4d86:: with SMTP id b6mr30071866wru.369.1605107138152;
        Wed, 11 Nov 2020 07:05:38 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p13sm2739175wrt.73.2020.11.11.07.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 07:05:37 -0800 (PST)
Date:   Wed, 11 Nov 2020 16:05:35 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] selftests: set conf.all.rp_filter=0 in bareudp.sh
Message-ID: <f2d459346471f163b239aa9d63ce3e2ba9c62895.1605107012.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When working on the rp_filter problem, I didn't realise that disabling
it on the network devices didn't cover all cases: rp_filter could also
be enabled globally in the namespace, in which case it would drop
packets, even if the net device has rp_filter=0.

Fixes: 1ccd58331f6f ("selftests: disable rp_filter when testing bareudp")
Fixes: bbbc7aa45eef ("selftests: add test script for bareudp tunnels")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/bareudp.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/bareudp.sh b/tools/testing/selftests/net/bareudp.sh
index c2b9e990e544..f366cadbc5e8 100755
--- a/tools/testing/selftests/net/bareudp.sh
+++ b/tools/testing/selftests/net/bareudp.sh
@@ -238,6 +238,8 @@ setup_overlay_ipv4()
 	# The intermediate namespaces don't have routes for the reverse path,
 	# as it will be handled by tc. So we need to ensure that rp_filter is
 	# not going to block the traffic.
+	ip netns exec "${NS1}" sysctl -qw net.ipv4.conf.all.rp_filter=0
+	ip netns exec "${NS2}" sysctl -qw net.ipv4.conf.all.rp_filter=0
 	ip netns exec "${NS1}" sysctl -qw net.ipv4.conf.default.rp_filter=0
 	ip netns exec "${NS2}" sysctl -qw net.ipv4.conf.default.rp_filter=0
 }
-- 
2.21.3

