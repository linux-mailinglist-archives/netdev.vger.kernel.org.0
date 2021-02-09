Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8C314D46
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhBIKiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbhBIKdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:33:49 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C118C061793
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:33:08 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hs11so30501242ejc.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pU+OX90lxBxSULEfhANKbIE/Stad0bhVCCPB37fq3V8=;
        b=uOeVlII1joPJGrGM7ioEQvI4TFcu7uvVOunOZY6MZHQkWkF6Au3YhdUcxNrnRD4X1S
         NznynEhjLxkgnzisVcEc2EXlLsXRPdYFyR4i7H8cpACTdVYxLxpXmuvk60weC2BzmhII
         7G4ogf70dvX5DMbEBEJ5F6gVXdHRZPXSdzs5HMNetNZ/yOf/sejlIG5MXJ04qXrK38wU
         tsuz3uXVYiFfKbqTUFE1+ThCqVHSChnRsdsOSalPB4nWbjRdD2LgDJCJMfR6LyRB23bn
         08fLL8GRIdIcCRZ/Bl73I8/gdPif+0/1t63Uuw4fetlReRxTRX3NFFBVvdXqYyaM5jYG
         HTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU+OX90lxBxSULEfhANKbIE/Stad0bhVCCPB37fq3V8=;
        b=UkCJVn89uQPJ+xBDgX3DONgyfnBgFutn7I12pTz7wQ5RsQ1zM184af1JtquAAB28d5
         7oR+s33NKnRdDy957zm3hu5d5KaUSNP/cM9NC3SzfGlnSUjblPj/FGzMRpgDdpr3mWXr
         mQka0nWVuKrBpsC8/1aPhglCwxJYGlymj7Z9w+W6SgrXyfE0ARSHL5xq0XNK2MU+iIfd
         siUbQSsZvsqShiPIaGQBY7GdAUKOb7pGp655Qc9UGjIf48j4kFheAAAvdYTybjOGnucj
         T2sSjviTVKyWPxBs5dSIG8QIR0qIIPjANiU8tbYpaWLxM2QVLRESkwNhXmKJZzhyPPZB
         YYlA==
X-Gm-Message-State: AOAM531uClJ/f8Z0ywkWXFtQQSIHZ7zCjalpWq5D38wWHIv38HknUK20
        jZeRnRY358d2k7YUy6IFZK1r6f+iLE+JOPoCyziOPQ==
X-Google-Smtp-Source: ABdhPJxj32UCAuGucKAdAzpyJRyGa1U1L+vcZZ882Xy+JRW4pT7i729xjX+0bj445/Xj0tYhm0jBIQ==
X-Received: by 2002:a17:906:3484:: with SMTP id g4mr21255904ejb.38.1612866786517;
        Tue, 09 Feb 2021 02:33:06 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q20sm8486896ejs.17.2021.02.09.02.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 02:33:06 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@nvidia.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 3/3] bonding: 3ad: Use a more verbose warning for unknown speeds
Date:   Tue,  9 Feb 2021 12:32:09 +0200
Message-Id: <20210209103209.482770-4-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209103209.482770-1-razor@blackwall.org>
References: <20210209103209.482770-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The bond driver needs to be patched to support new ethtool speeds.
Currently it emits a single warning [1] when it encounters an unknown
speed. As evident by the two previous patches, this is not explicit
enough. Instead, use WARN_ONCE() to get a more verbose warning [2].

[1]
bond10: (slave swp1): unknown ethtool speed (200000) for port 1 (set it to 0)

[2]
bond20: (slave swp2): unknown ethtool speed (400000) for port 1 (set it to 0)
WARNING: CPU: 5 PID: 96 at drivers/net/bonding/bond_3ad.c:317 __get_link_speed.isra.0+0x110/0x120
Modules linked in:
CPU: 5 PID: 96 Comm: kworker/u16:5 Not tainted 5.11.0-rc6-custom-02818-g69a767ec7302 #3243
Hardware name: Mellanox Technologies Ltd. MSN4700/VMOD0010, BIOS 5.11 01/06/2019
Workqueue: bond20 bond_mii_monitor
RIP: 0010:__get_link_speed.isra.0+0x110/0x120
Code: 5b ff ff ff 52 4c 8b 4e 08 44 0f b7 c7 48 c7 c7 18 46 4a b8 48 8b 16 c6 05 d9 76 41 01 01 49 8b 31 89 44 24 04 e8 a2 8a 3f 00 <0f> 0b 8b 44 24 04 59 c3 0
f 1f 84 00 00 00 00 00 48 85 ff 74 3b 53
RSP: 0018:ffffb683c03afde0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff96bd3f2a9a38 RCX: 0000000000000000
RDX: ffff96c06fd67560 RSI: ffff96c06fd57850 RDI: ffff96c06fd57850
RBP: 0000000000000000 R08: ffffffffb8b49888 R09: 0000000000009ffb
R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 0000000000000000
R13: ffff96bd3f2a9a38 R14: ffff96bd49c56400 R15: ffff96bd49c564f0
FS:  0000000000000000(0000) GS:ffff96c06fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f327ad804b0 CR3: 0000000142ad5006 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ad_update_actor_keys+0x36/0xc0
 bond_3ad_handle_link_change+0x5d/0xf0
 bond_mii_monitor.cold+0x1c2/0x1e8
 process_one_work+0x1c9/0x360
 worker_thread+0x48/0x3c0
 kthread+0x113/0x130
 ret_from_fork+0x1f/0x30

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/bonding/bond_3ad.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 2e670f68626d..460dc1bfc7a9 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -326,11 +326,10 @@ static u16 __get_link_speed(struct port *port)
 
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
-			if (slave->speed != SPEED_UNKNOWN)
-				pr_warn_once("%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
-					     slave->bond->dev->name,
-					     slave->dev->name, slave->speed,
-					     port->actor_port_number);
+			WARN_ONCE(slave->speed != SPEED_UNKNOWN,
+				  "%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
+				  slave->bond->dev->name, slave->dev->name,
+				  slave->speed, port->actor_port_number);
 			speed = 0;
 			break;
 		}
-- 
2.29.2

