Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14133E3E44
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 05:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhHID2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 23:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhHID2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 23:28:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F95C061757;
        Sun,  8 Aug 2021 20:28:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so28032031pjb.2;
        Sun, 08 Aug 2021 20:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l+cxRO1Gc4pNzjnbnXj/dz1Ypz3ztoOKH1tuHXAAFPA=;
        b=dMDKcCTXOQUUnwBpX6jWEo4XdtHuAFjrY3QbiOYjWEih0TEyGFOUZmyMgDkEKP3VCh
         TL6LbtX/P561/GeI09SwbM6ASMxRM0+e5HOmHQUW69fdNKHm7N5kTyjoncse9I0i3/Vg
         numvEbfERNgevBc5i3W82u2uKe8d5a5R03CHy0rWVJTvU6pWckbXxLbwd/+UcujLAH1j
         kqAzuGJWmwEoWFMsU9e/yCffWy65Wh0ZRmlRJJ+1RXA3G0gL1FWAb8Vi+ctFdNwqhJJw
         iuRfyOXlU7JSmvaYDW1auo542Ku3GKCpLVFQY83jp1G0vVejLoDGAT80Na20ja2rGk7g
         UOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=l+cxRO1Gc4pNzjnbnXj/dz1Ypz3ztoOKH1tuHXAAFPA=;
        b=UxjiIe1APhUbgRqWBq7bkA6XpgrPwaAZj/vnLDZvz5k7WyMxBwtr/ewG+osCL9AkUM
         yPXRQA6bT2ir1PcZ5DKw6lwdYFcMSmUEKWEc7Y/BayDxoOXn1cFuCf84joO+9+hvouiD
         3oVF7y1I7HadXxA0zyoggNE2jAY1hCAnGLRGp3QLFd5iCiopEWCkjur0RgbhwEGxYiV0
         wyUGOwe0gT86TkP7jS1tCq3Elohizqmg9osR7hk+wlzb5fW9hQPOYl0XSXuYV32ymvET
         kIhLP4Q4p5PAAjQZZG8G90Zni4ERseI1DDZZhYKf+14ijKS7FXIq1jSjRUeZsbSogw8l
         lUPg==
X-Gm-Message-State: AOAM5327AXkd6IeOC+ZYEhJlR0tsb8p0pcPkU2DJM58+RxZ8cOgDNyDZ
        UOgGegX+c1lTZKh8AWGXs+k=
X-Google-Smtp-Source: ABdhPJzk+1tL/wgq/qc8SHCp97UXVBnISsMEN+Hqc+0boje+yOIv2HOFgmy/pIJto2v3w++RNimBXw==
X-Received: by 2002:a17:90a:4404:: with SMTP id s4mr13380103pjg.153.1628479692586;
        Sun, 08 Aug 2021 20:28:12 -0700 (PDT)
Received: from localhost (61-220-137-34.HINET-IP.hinet.net. [61.220.137.34])
        by smtp.gmail.com with ESMTPSA id 22sm18218071pgn.88.2021.08.08.20.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 20:28:11 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH] net: called rtnl_unlock() before runpm resumes devices
Date:   Mon,  9 Aug 2021 11:28:09 +0800
Message-Id: <20210809032809.1224002-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
__dev_open() it calls pm_runtime_resume() to resume devices, and in
some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
again. That leads to a recursive lock.

It should leave the devices' resume function to decide if they need to
call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().

[  967.723577] INFO: task ip:6024 blocked for more than 120 seconds.
[  967.723588]       Not tainted 5.12.0-rc3+ #1
[  967.723592] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.723594] task:ip              state:D stack:    0 pid: 6024 ppid:  5957 flags:0x00004000
[  967.723603] Call Trace:
[  967.723610]  __schedule+0x2de/0x890
[  967.723623]  schedule+0x4f/0xc0
[  967.723629]  schedule_preempt_disabled+0xe/0x10
[  967.723636]  __mutex_lock.isra.0+0x190/0x510
[  967.723644]  __mutex_lock_slowpath+0x13/0x20
[  967.723651]  mutex_lock+0x32/0x40
[  967.723657]  rtnl_lock+0x15/0x20
[  967.723665]  igb_resume+0xee/0x1d0 [igb]
[  967.723687]  ? pci_pm_default_resume+0x30/0x30
[  967.723696]  igb_runtime_resume+0xe/0x10 [igb]
[  967.723713]  pci_pm_runtime_resume+0x74/0x90
[  967.723718]  __rpm_callback+0x53/0x1c0
[  967.723725]  rpm_callback+0x57/0x80
[  967.723730]  ? pci_pm_default_resume+0x30/0x30
[  967.723735]  rpm_resume+0x547/0x760
[  967.723740]  __pm_runtime_resume+0x52/0x80
[  967.723745]  __dev_open+0x56/0x160
[  967.723753]  ? _raw_spin_unlock_bh+0x1e/0x20
[  967.723758]  __dev_change_flags+0x188/0x1e0
[  967.723766]  dev_change_flags+0x26/0x60
[  967.723773]  do_setlink+0x723/0x10b0
[  967.723782]  ? __nla_validate_parse+0x5b/0xb80
[  967.723792]  __rtnl_newlink+0x594/0xa00
[  967.723800]  ? nla_put_ifalias+0x38/0xa0
[  967.723807]  ? __nla_reserve+0x41/0x50
[  967.723813]  ? __nla_reserve+0x41/0x50
[  967.723818]  ? __kmalloc_node_track_caller+0x49b/0x4d0
[  967.723824]  ? pskb_expand_head+0x75/0x310
[  967.723830]  ? nla_reserve+0x28/0x30
[  967.723835]  ? skb_free_head+0x25/0x30
[  967.723843]  ? security_sock_rcv_skb+0x2f/0x50
[  967.723850]  ? netlink_deliver_tap+0x3d/0x210
[  967.723859]  ? sk_filter_trim_cap+0xc1/0x230
[  967.723863]  ? skb_queue_tail+0x43/0x50
[  967.723870]  ? sock_def_readable+0x4b/0x80
[  967.723876]  ? __netlink_sendskb+0x42/0x50
[  967.723888]  ? security_capable+0x3d/0x60
[  967.723894]  ? __cond_resched+0x19/0x30
[  967.723900]  ? kmem_cache_alloc_trace+0x390/0x440
[  967.723906]  rtnl_newlink+0x49/0x70
[  967.723913]  rtnetlink_rcv_msg+0x13c/0x370
[  967.723920]  ? _copy_to_iter+0xa0/0x460
[  967.723927]  ? rtnl_calcit.isra.0+0x130/0x130
[  967.723934]  netlink_rcv_skb+0x55/0x100
[  967.723939]  rtnetlink_rcv+0x15/0x20
[  967.723944]  netlink_unicast+0x1a8/0x250
[  967.723949]  netlink_sendmsg+0x233/0x460
[  967.723954]  sock_sendmsg+0x65/0x70
[  967.723958]  ____sys_sendmsg+0x218/0x290
[  967.723961]  ? copy_msghdr_from_user+0x5c/0x90
[  967.723966]  ? lru_cache_add_inactive_or_unevictable+0x27/0xb0
[  967.723974]  ___sys_sendmsg+0x81/0xc0
[  967.723980]  ? __mod_memcg_lruvec_state+0x22/0xe0
[  967.723987]  ? kmem_cache_free+0x244/0x420
[  967.723991]  ? dentry_free+0x37/0x70
[  967.723996]  ? mntput_no_expire+0x4c/0x260
[  967.724001]  ? __cond_resched+0x19/0x30
[  967.724007]  ? security_file_free+0x54/0x60
[  967.724013]  ? call_rcu+0xa4/0x250
[  967.724021]  __sys_sendmsg+0x62/0xb0
[  967.724026]  ? exit_to_user_mode_prepare+0x3d/0x1a0
[  967.724032]  __x64_sys_sendmsg+0x1f/0x30
[  967.724037]  do_syscall_64+0x38/0x90
[  967.724044]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 net/core/dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8f1a47ad6781..dd43a29419fd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1585,8 +1585,11 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 
 	if (!netif_device_present(dev)) {
 		/* may be detached because parent is runtime-suspended */
-		if (dev->dev.parent)
+		if (dev->dev.parent) {
+			rtnl_unlock();
 			pm_runtime_resume(dev->dev.parent);
+			rtnl_lock();
+		}
 		if (!netif_device_present(dev))
 			return -ENODEV;
 	}
-- 
2.25.1

