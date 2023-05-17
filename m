Return-Path: <netdev+bounces-3371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB70706B19
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E217C2816EA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640382C742;
	Wed, 17 May 2023 14:30:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5853431EEB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:30:48 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C783
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:30:46 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ae4d1d35e6so7573435ad.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684333846; x=1686925846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nno4Kho/bh8zoKGUI9i17Qh0whDq5bpJPQ1dlj8iq+8=;
        b=fDsRwiY8oKUU6NA6SezRgRXsApzq5nkY1z7QK0iaiHd/zzXKu4FOQ3BIaN06xeumzQ
         PePawMJ04gLo2AL1j/jRtKSS0Oh3Aj/4+n6kpbQjVLNnGiI+qPkEQ7AFiHIjyYLVsnqG
         7JFP1v94NsL09J8gw8Y6dULsGwhVVURBrWkpryBpfgUVnSVZHg4Jak1SJY1v1e6bqSzc
         7SqkuYeTZzuYSeb1mJfDHHkXfqTF93Vh9NLop0fwKiBXcHC90oBJXpOroG6QuRxDmyTT
         Q8DR/LLsmKAm6sNIjsmR635OMmOuZ0v+J6wGA8jPUoh0ejgXXt0DQB1kmhxtAGbTtT+M
         ZrnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684333846; x=1686925846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nno4Kho/bh8zoKGUI9i17Qh0whDq5bpJPQ1dlj8iq+8=;
        b=KJ6afrE0MQ9wvB+hKEjJ/wF2yeiMtYAd49FTSXUaxr7hkfFA/6dDoYe919Tznba8Qb
         T2G+0stkeEXmOchqhMx4LhKzdeDWTyl2U9WJU6CR/LlEvL8C+BI8AGh8Ami907vLaLUU
         QLvaCzcbxJBwv9iRdcKkHhOXwu3vfemz1LtK3cOFqYd6ZjRl4fRwEg5Vv6dYDnT879xz
         fcXrwh2FgCrDKZC5xoWSPo5iiTHOlIkhAT93SN06rciEMkmNRLixerXFAl6RRTL2oWA6
         DDt5LsXv/2LITyY6Vd/wOvgCIBGdppXVkyH313asm8KkB7JDZ9uyjkDRT+WNxTp77UOT
         ZZEw==
X-Gm-Message-State: AC+VfDzBL+5IdoEcEvF+xtxMzJwoFY2Rkt25zCoF7pHZWHUZFuBZtxr+
	DQhz6dfbQHwAxoRWsP4zeQ0=
X-Google-Smtp-Source: ACHHUZ7seZEZYoJKz5Rdat4VC85bFe2Sz1RmoN0UYzi4mDNkTKHkNzQnS6RuWziNA7ht/CdQ2ubZwg==
X-Received: by 2002:a17:903:238d:b0:1a6:83fa:b370 with SMTP id v13-20020a170903238d00b001a683fab370mr39057358plh.2.1684333845977;
        Wed, 17 May 2023 07:30:45 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001adf6b21c77sm9526817plg.107.2023.05.17.07.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 07:30:44 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	jiri@resnulli.us,
	j.vosburgh@gmail.com,
	andy@greyhouse.net,
	netdev@vger.kernel.org
Cc: jarod@redhat.com,
	razor@blackwall.org,
	simon.horman@corigine.com,
	wangyufen@huawei.com,
	ap420073@gmail.com,
	syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Subject: [PATCH net v2] net: fix stack overflow when LRO is disabled for virtual interfaces
Date: Wed, 17 May 2023 14:30:10 +0000
Message-Id: <20230517143010.3596250-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the virtual interface's feature is updated, it synchronizes the
updated feature for its own lower interface.
This propagation logic should be worked as the iteration, not recursively.
But it works recursively due to the netdev notification unexpectedly.
This problem occurs when it disables LRO only for the team and bonding
interface type.

       team0
         |
  +------+------+-----+-----+
  |      |      |     |     |
team1  team2  team3  ...  team200

If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
event to its own lower interfaces(team1 ~ team200).
It is worked by netdev_sync_lower_features().
So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
work iteratively.
But generated NETDEV_FEAT_CHANGE event is also sent to the upper
interface too.
upper interface(team0) generates the NETDEV_FEAT_CHANGE event for its own
lower interfaces again.
lower and upper interfaces receive this event and generate this
event again and again.
So, the stack overflow occurs.

But it is not the infinite loop issue.
Because the netdev_sync_lower_features() updates features before
generating the NETDEV_FEAT_CHANGE event.
Already synchronized lower interfaces skip notification logic.
So, it is just the problem that iteration logic is changed to the
recursive unexpectedly due to the notification mechanism.

Reproducer:

ip link add team0 type team
ethtool -K team0 lro on
for i in {1..200}
do
        ip link add team$i master team0 type team
        ethtool -K team$i lro on
done

ethtool -K team0 lro off

In order to fix it, the notifier_ctx member of bonding/team is introduced.

Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Add new member to struct bonding/team instead of the net_device.

 drivers/net/bonding/bond_main.c | 8 +++++++-
 drivers/net/team/team.c         | 7 ++++++-
 include/linux/if_team.h         | 1 +
 include/net/bonding.h           | 1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3fed888629f7..edbaa1444f8e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3947,7 +3947,11 @@ static int bond_slave_netdev_event(unsigned long event,
 		unblock_netpoll_tx();
 		break;
 	case NETDEV_FEAT_CHANGE:
-		bond_compute_features(bond);
+		if (!bond->notifier_ctx) {
+			bond->notifier_ctx = true;
+			bond_compute_features(bond);
+			bond->notifier_ctx = false;
+		}
 		break;
 	case NETDEV_RESEND_IGMP:
 		/* Propagate to master device */
@@ -6342,6 +6346,8 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
+	bond->notifier_ctx = false;
+
 	spin_lock_init(&bond->stats_lock);
 	netdev_lockdep_set_classes(bond_dev);
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index d10606f257c4..555b0b1e9a78 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1629,6 +1629,7 @@ static int team_init(struct net_device *dev)
 
 	team->dev = dev;
 	team_set_no_mode(team);
+	team->notifier_ctx = false;
 
 	team->pcpu_stats = netdev_alloc_pcpu_stats(struct team_pcpu_stats);
 	if (!team->pcpu_stats)
@@ -3022,7 +3023,11 @@ static int team_device_event(struct notifier_block *unused,
 		team_del_slave(port->team->dev, dev);
 		break;
 	case NETDEV_FEAT_CHANGE:
-		team_compute_features(port->team);
+		if (!port->team->notifier_ctx) {
+			port->team->notifier_ctx = true;
+			team_compute_features(port->team);
+			port->team->notifier_ctx = false;
+		}
 		break;
 	case NETDEV_PRECHANGEMTU:
 		/* Forbid to change mtu of underlaying device */
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index fc985e5c739d..8de6b6e67829 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -208,6 +208,7 @@ struct team {
 	bool queue_override_enabled;
 	struct list_head *qom_lists; /* array of queue override mapping lists */
 	bool port_mtu_change_allowed;
+	bool notifier_ctx;
 	struct {
 		unsigned int count;
 		unsigned int interval; /* in ms */
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 0efef2a952b7..59955ac33157 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -221,6 +221,7 @@ struct bonding {
 	struct   bond_up_slave __rcu *usable_slaves;
 	struct   bond_up_slave __rcu *all_slaves;
 	bool     force_primary;
+	bool     notifier_ctx;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
 			      struct slave *);
-- 
2.34.1


