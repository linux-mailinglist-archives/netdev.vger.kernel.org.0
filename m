Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713FB22A31F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgGVXcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVXcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 19:32:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01860C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 16:32:08 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m16so1726559pls.5
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 16:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFC0xrdSRnPm4Fj5OAjFqii2HUrxhI4pHVzKkcfzqwE=;
        b=CbhTlFJDmP3BPxFipLDQmCJvuB2r6i5o1OM+wb/1XUXY7pOWdbHi69NuI8RBUlBfG9
         CJOsv0ex8DARKDaDG5CTlDqSRhw1/Ydtga0OYMwOxz9m7G+MIh9AS7BnHyMNngkreiUe
         UUk47A9Rs1oAUsbodDzHUIuVBVCkse7AtmyWnD+nZt1fj4afI7Q6GLupOMhcQkA6IJu8
         4+zLRtfEyZjDwEx8k/lYqOOGtvPqtRTafcP7oZZQ3X42Uxac/tdJoP8pA3ZYFES4uLwD
         c84FJpwyR3c+pSa6XumbScAdP8BOcp7qM5VzeCLFuiYmIkI0Iv4p2n5Dr1hXEuZB4A+1
         5AJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFC0xrdSRnPm4Fj5OAjFqii2HUrxhI4pHVzKkcfzqwE=;
        b=cRBJqWuZzFWxy7o4wnf5/ZGsuzMKmBqxs1PwqP9rxXEd3nM1B6AkTS1Zl5WkqPMtQ+
         BiW3lQxrLhxs2Cexr1Mf7NSDDnDgLBUKnCKysiwK/mtXIyS5iXpcR6zmjCEESgSf8L1I
         rsKTQiCucz42XDo7djyeKkwKp//opgYEQCwqpwxznwkhS1YVON1sSLdE3U3xJMksDxE6
         XFi5IvhlMbQqAuOTKVJE8njmHUySlTFEonasbv+XMiXgxTelTYqS7ijOwUUo71ZXBLW0
         mxgAq+MHXGvxd0W1lRKKVB5kLVTnBDZt57oyitNCjPqJTPpNj8LBzAo0Duj00tirEQ6u
         52DQ==
X-Gm-Message-State: AOAM533vaGE4aM5zjWo+27Qk3vKWioeE82SW6jvek6I3OyZwhRdSET0A
        ggFhBlKHiMslzX4VFhV21NN++rfh0PU=
X-Google-Smtp-Source: ABdhPJxbB4UDkYSNvQgnkouArd3KnQxuQ/EfgF4VgIW43pxyiI9PM46RBatYP+CwNT8+tzwO1F9vjA==
X-Received: by 2002:a17:902:7b90:: with SMTP id w16mr1423524pll.253.1595460726381;
        Wed, 22 Jul 2020 16:32:06 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::2e])
        by smtp.gmail.com with ESMTPSA id r4sm723408pji.37.2020.07.22.16.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 16:32:05 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com,
        Beniamino Galvani <bgalvani@redhat.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: [Patch net] bonding: check return value of register_netdevice() in bond_newlink()
Date:   Wed, 22 Jul 2020 16:31:54 -0700
Message-Id: <20200722233154.13105-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Very similar to commit 544f287b8495
("bonding: check error value of register_netdevice() immediately"),
we should immediately check the return value of register_netdevice()
before doing anything else.

Fixes: 005db31d5f5f ("bonding: set carrier off for devices created through netlink")
Reported-and-tested-by: syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com
Cc: Beniamino Galvani <bgalvani@redhat.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/bonding/bond_netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index b43b51646b11..f0f9138e967f 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -456,11 +456,10 @@ static int bond_newlink(struct net *src_net, struct net_device *bond_dev,
 		return err;
 
 	err = register_netdevice(bond_dev);
-
-	netif_carrier_off(bond_dev);
 	if (!err) {
 		struct bonding *bond = netdev_priv(bond_dev);
 
+		netif_carrier_off(bond_dev);
 		bond_work_init_all(bond);
 	}
 
-- 
2.27.0

