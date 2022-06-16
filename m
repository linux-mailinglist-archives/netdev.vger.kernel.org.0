Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F2E54EA29
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiFPTcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiFPTcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:32:47 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA321AD8D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:32:46 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7934D4100C
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655407965;
        bh=MfBd/Ga0o25q1MT4i+2Pu9qCNQqFVHIBJnEzyzd+yxE=;
        h=From:To:Cc:Subject:MIME-Version:Content-Type:Date:Message-ID;
        b=N6JpcjbeLm/VtVzdhCRPq4kcW7VLempPTmtOdresuiFs/JktfzkCL8xYHXkwImWBG
         qNAfEPTVw1OeJaolBjKjXYtZ11JfLIQo9ng+Udrb/fAlXrC+9vrh97rH+lui0dd/x4
         v24OYNMnLyHrRr1h0ATmsRyNvlcyBNYqNRQqQwZI+0rlBnzdJguPUElWdk/k/7Kbhn
         MzV0zB9/Hj22eMxVZJqCnyBmhbw6CoMyh+LCF3S0+3jOSoDQlWNijihMCxDQDveOyr
         SJVgY3Jsk7mHNxPVchP7LP931enOKyPTx6Pf7a+746YWUd4zPZ3c+wFHmhfHZtqC2Z
         +OdpmCOcr0bJw==
Received: by mail-pg1-f197.google.com with SMTP id e18-20020a656492000000b003fa4033f9a7so1121568pgv.17
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:mime-version:content-id
         :content-transfer-encoding:date:message-id;
        bh=MfBd/Ga0o25q1MT4i+2Pu9qCNQqFVHIBJnEzyzd+yxE=;
        b=jKwk4sW8Mb7e2w1CUXjtwwEnK6SxIwB8TTfjLjPYSLwYIlvRU1o2OxHfguZ0m/N4up
         vawxdaDNfVF/0kjXUQnV/LLhlZqVQ2Oad+weFDo85FxuzBWzIKOem9xCOVpBc+i88YdD
         Rjc4dCoUhyr9InWQTfNzXn6T7Yt6k0ME9Us5t4Wca6+PNQmqLqCq+mf/jCL7C8mg3bn+
         sx8xrLgvtkPdHYlOV4QZBQFmS0ZmR/3Ft7Di/tO5GB2T9vDlUkpWYYkyIAZwxe9Z7Z8J
         6MzOxY/h8EtFxFRijO7cNdH1PW1fr0ifTUWg7tlVOMJPu5F5kYzN+DfAthGNuDdtwqj5
         eXSA==
X-Gm-Message-State: AJIora9vsxVsUmEFN4sFxXx93N74/PfP6g0eZkM503XNNdrEkigas52Z
        BEkmxw6FZY6FesMKSy3J3oOo3vp6KvIb5YjzYhUj8LffyxlFv0aW6xockpUyQtw4PivlSPTSd0Y
        RUN69qZFnu1FA/MuoGbXSGmt6vk7KRelA4w==
X-Received: by 2002:a62:7cd2:0:b0:51b:9ba6:a028 with SMTP id x201-20020a627cd2000000b0051b9ba6a028mr6371242pfc.24.1655407961529;
        Thu, 16 Jun 2022 12:32:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u5CTZM5NqbZO88e9dZCt3a1JD9A/rLHFiLv816rVBzmiEXRqDoYA4uafs+LmwI0+64adCJ3A==
X-Received: by 2002:a62:7cd2:0:b0:51b:9ba6:a028 with SMTP id x201-20020a627cd2000000b0051b9ba6a028mr6371222pfc.24.1655407961209;
        Thu, 16 Jun 2022 12:32:41 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id i186-20020a62c1c3000000b00524c5c236a6sm1867697pfg.33.2022.06.16.12.32.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jun 2022 12:32:40 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 81AF46093D; Thu, 16 Jun 2022 12:32:40 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7A879A0B36;
        Thu, 16 Jun 2022 12:32:40 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        dingtianhong <dingtianhong@huawei.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net] bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9399.1655407960.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 16 Jun 2022 12:32:40 -0700
Message-ID: <9400.1655407960@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	 The bonding ARP monitor fails to decrement send_peer_notif, the
number of peer notifications (gratuitous ARP or ND) to be sent. This
results in a continuous series of notifications.

	Correct this by decrementing the counter for each notification.

Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Fixes: b0929915e035 ("bonding: Fix RTNL: assertion failed at net/core/rtne=
tlink.c for ab arp monitor")
Link: https://lore.kernel.org/netdev/b2fd4147-8f50-bebd-963a-1a3e8d1d9715@=
redhat.com/

---
 drivers/net/bonding/bond_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_ma=
in.c
index f85372adf042..6ba4c83fe5fc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3684,9 +3684,11 @@ static void bond_activebackup_arp_mon(struct bondin=
g *bond)
 		if (!rtnl_trylock())
 			return;
 =

-		if (should_notify_peers)
+		if (should_notify_peers) {
+			bond->send_peer_notif--;
 			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
 						 bond->dev);
+		}
 		if (should_notify_rtnl) {
 			bond_slave_state_notify(bond);
 			bond_slave_link_notify(bond);
-- =

2.29.GIT

