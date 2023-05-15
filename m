Return-Path: <netdev+bounces-2493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BD070235E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA64B28102F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05921FD0;
	Mon, 15 May 2023 05:37:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AAD10E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:37:58 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108EE1AD
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:37:57 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-517c840f181so6464868a12.3
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684129076; x=1686721076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3mY1NKnSfc3tTg6uMYIHbHpiMKYjEwslmiKy6He9nZI=;
        b=MuliBsloQjZHA/UQ3C1TpdckKLFZEudv5ev2j6oR8dxl90H48ZEtq26q3kt39dlUt8
         oaT7bvilFEtskSvbsSEAbYojHHd+YwJl8PKQs8Ix/msrDqRZaomqQAVAVb6vWyhM6hGZ
         sCG+oAqahEfasJUUUCaGmm+SmgMoxO0VsWCjebMHNYysT2q7zQOEtAToN1+mRIzcnywM
         Y6ChR2ME4KL6opq2FzQoo9uQKtS1VJfgz+hAnpDWlk+OBz9cHvmnporA6XdSKS15nFlt
         vhpWpefCGsk66rFzLz5+E+SbXZSS6LV7tAZXxHDiYuOkjoRIxwUQ/vH7sZczFGUbVQpx
         jy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684129076; x=1686721076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3mY1NKnSfc3tTg6uMYIHbHpiMKYjEwslmiKy6He9nZI=;
        b=gdyD6JJgZNGIm2Ln1i2yrfG6M6KDe1PjvnxruDV/X844cZtfwUIG9yEGtQC4TFAEq8
         aqMHHcWewNz5U1EotqL4utNL+qpahX7T+xbvA6l/mMyZGoildtlakrvq/alHYiglksnB
         K0D/9VPzVpS3vcZ7Id8RUM2+jOQ8aGR6bk+8hS9yeO5ENLU1BIeg7WUBGeocArXKzR9J
         BSxQIuERYBdnj4weINzTf1KnpLlpapvxz5dPnzpWXiDGVdtiqLV17wMwFTpCaYvU4twW
         1WFeg1r2NOgtP1HO8W7C+DXA+zQhP07exLiD63SB1I3od/xIGoqj5vQI9f9MXdFsKk+U
         8dng==
X-Gm-Message-State: AC+VfDw3jYVBNuyioVMgpVBcossHON5cZGNK6dl8F/CyVPIXr5jozC5w
	W1xq3kjIowLxcml/+9UPJS0=
X-Google-Smtp-Source: ACHHUZ4PVdfoUiw3oIAJsUYd1fOojui7wxxOXGw8ichIcBuHQxHnyX2YH1ggBpl7BQa4folaHkkBEw==
X-Received: by 2002:a05:6a21:6d9f:b0:100:b8fc:8c6c with SMTP id wl31-20020a056a216d9f00b00100b8fc8c6cmr31349454pzb.19.1684129076270;
        Sun, 14 May 2023 22:37:56 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id a19-20020a62bd13000000b0063f0c9eadc7sm6737391pff.200.2023.05.14.22.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 22:37:55 -0700 (PDT)
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
	wangyufen@huawei.com,
	ap420073@gmail.com,
	syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Subject: [PATCH net] net: fix stack overflow when LRO is disabled for virtual interfaces
Date: Mon, 15 May 2023 05:37:40 +0000
Message-Id: <20230515053740.3065735-1-ap420073@gmail.com>
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

In order to fix it, the priv_notifier_ctx net_device member is introduced.
This variable can be used by each interface in its own way in the
notification context. The bonding and team interface is going to use it
to avoid duplicated NETDEV_FEAT_CHANGE event handling.

Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bonding/bond_main.c | 6 +++++-
 drivers/net/team/team.c         | 6 +++++-
 include/linux/netdevice.h       | 1 +
 net/core/dev.c                  | 2 ++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3fed888629f7..dc6d5172475c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3947,7 +3947,11 @@ static int bond_slave_netdev_event(unsigned long event,
 		unblock_netpoll_tx();
 		break;
 	case NETDEV_FEAT_CHANGE:
-		bond_compute_features(bond);
+		if (!bond_dev->priv_notifier_ctx) {
+			bond_dev->priv_notifier_ctx = NETDEV_FEAT_CHANGE;
+			bond_compute_features(bond);
+			bond_dev->priv_notifier_ctx = 0;
+		}
 		break;
 	case NETDEV_RESEND_IGMP:
 		/* Propagate to master device */
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index d10606f257c4..c7af29d3cda0 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -3022,7 +3022,11 @@ static int team_device_event(struct notifier_block *unused,
 		team_del_slave(port->team->dev, dev);
 		break;
 	case NETDEV_FEAT_CHANGE:
-		team_compute_features(port->team);
+		if (!port->team->dev->priv_notifier_ctx) {
+			port->team->dev->priv_notifier_ctx = NETDEV_FEAT_CHANGE;
+			team_compute_features(port->team);
+			port->team->dev->priv_notifier_ctx = 0;
+		}
 		break;
 	case NETDEV_PRECHANGEMTU:
 		/* Forbid to change mtu of underlaying device */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..ebd49a54f0d5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2393,6 +2393,7 @@ struct net_device {
 	unsigned		threaded:1;
 
 	struct list_head	net_notifier_list;
+	u32			priv_notifier_ctx;
 
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec management functions */
diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e041935..cc6b5f626054 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10677,6 +10677,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->priv_flags = IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM;
 	setup(dev);
 
+	dev->priv_notifier_ctx = 0;
+
 	if (!dev->tx_queue_len) {
 		dev->priv_flags |= IFF_NO_QUEUE;
 		dev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;
-- 
2.34.1


