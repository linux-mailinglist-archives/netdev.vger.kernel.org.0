Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9AC2AA6B8
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgKGQre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbgKGQrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 11:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604767651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DHS62vo2PjQMnlGUR+ju7tKFuCSwS6A0lH+pddFHEC8=;
        b=DZKQit2AyLIV3xf7xdQx5tz0TbsPhYJaq8BTsFrVH9qNhGGT7FJt79VjvFztDVeHHMjltD
        PZ6Ov6mEWO1n0WSsYN95qSRWSR3LA3eHJWpv5noVPPK/FRnIny1hegoXLJUJgXnapqLryX
        tntZAs/tq6VAkC65PmkdQYclsYLX37E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-EApvY_b2NammEBW8-I15Wg-1; Sat, 07 Nov 2020 11:47:21 -0500
X-MC-Unique: EApvY_b2NammEBW8-I15Wg-1
Received: by mail-wr1-f70.google.com with SMTP id h11so1894010wrq.20
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 08:47:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DHS62vo2PjQMnlGUR+ju7tKFuCSwS6A0lH+pddFHEC8=;
        b=ImDxycV8YBI8rKSwNw6snmFknQ168059vyiLTy84rBbAm/+1eO9oG0auMJZaPRkKxC
         0N+hlfdR9ioI32J8qz1xRSCSlrkeGUsh5n35O3/QbQIRSI2giiTULR1c3p+5SLeK8EU2
         EA1pOeTH4xEeuXhxl3Z813Tb/dadyMgYe6QCdxW8KyaWuKgR0ZIEWAc5PgrZUPOOXGMx
         aoFquUENtabRo8vZeqEZbXdjIguXgbgEANUvL8vmytDkNq6q/G0NPmxeA/OU5mFjL6Cx
         uib8jCI91O9ZQ56VNnAbGRo16IgUaPq/fMmU0jpnnfZgmnB3+7CTprUOo/4MmA3Ydzf8
         qeQg==
X-Gm-Message-State: AOAM530IWeW/UnVDX6T90QzTO+0bXxugyUDg94KPVSwcqqXSLAapKc+m
        mzKrzzPNg8xXZXZ8UljNfJKu7NitaELw8O02AALPP9i9D+IjlMKYK+ip8+40bszAooPFS3KqjrR
        /OE1dQ+mNjCQZ1VNy
X-Received: by 2002:a05:6000:107:: with SMTP id o7mr8594064wrx.354.1604767640140;
        Sat, 07 Nov 2020 08:47:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRUsGR4ASmN8QkLO+2M2Eb67ysjHiiJIVe2VQwpzJiF27PMDcy8lRX2HFld+Qy7ZuzWaYwkQ==
X-Received: by 2002:a05:6000:107:: with SMTP id o7mr8594050wrx.354.1604767639981;
        Sat, 07 Nov 2020 08:47:19 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id s188sm6960746wmf.45.2020.11.07.08.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 08:47:19 -0800 (PST)
Date:   Sat, 7 Nov 2020 17:47:17 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] selftests: disable rp_filter when testing bareudp
Message-ID: <28140b7d20161e4f766b558018fe2718f9bc1117.1604767577.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some systems have rp_filter=1 as default configuration. This breaks
bareudp.sh as the intermediate namespaces handle part of the routing
with regular IPv4 routes but the reverse path is done with tc
(flower/tunnel_key/mirred).

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/bareudp.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/bareudp.sh b/tools/testing/selftests/net/bareudp.sh
index c6fe22de7d0e..c2b9e990e544 100755
--- a/tools/testing/selftests/net/bareudp.sh
+++ b/tools/testing/selftests/net/bareudp.sh
@@ -234,6 +234,12 @@ setup_overlay_ipv4()
 	ip netns exec "${NS2}" sysctl -qw net.ipv4.ip_forward=1
 	ip -netns "${NS1}" route add 192.0.2.100/32 via 192.0.2.10
 	ip -netns "${NS2}" route add 192.0.2.103/32 via 192.0.2.33
+
+	# The intermediate namespaces don't have routes for the reverse path,
+	# as it will be handled by tc. So we need to ensure that rp_filter is
+	# not going to block the traffic.
+	ip netns exec "${NS1}" sysctl -qw net.ipv4.conf.default.rp_filter=0
+	ip netns exec "${NS2}" sysctl -qw net.ipv4.conf.default.rp_filter=0
 }
 
 setup_overlay_ipv6()
-- 
2.21.3

