Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D93437CA7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhJVSl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:41:28 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37048
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231511AbhJVSl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 14:41:27 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 27CDC40010
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 18:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634927949;
        bh=n86mKXHUmQMd2j1fhrUQnfMYmml77VBOLV1EynYUhhY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=HKl3xTblTMo7M3fumamz7tUNzOOlXt01PK4GjR6az8shU57h1r2JeZcS05IAQdMXy
         J8q/z6nKCVixcu5jcw/SkUzadlGu0K8P1fFjN1YTzNXv7dswpSeAZYInRNxZpJAb7x
         4ZI1tAzs1WNFd9Ac1nqM8wfxE7Bife1TMJCAyBpV6lURhlTpEeVQqsc0m1w0GTUk1F
         1pgTg/22lrRnr0RfPBSMXFn35tsDMn9qYw6MWIWQtz7lqujExVruPkufLfhC6VI0gE
         rvIyo8dbM3pa2fWvmXwg21Cm+do60aXjSd1g/9EPl6T9d3Rfj3TGmLOrQSblZH63a/
         buOVkIXSCvhhQ==
Received: by mail-pl1-f197.google.com with SMTP id m10-20020a1709026bca00b0013f8e975b31so2083850plt.5
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=n86mKXHUmQMd2j1fhrUQnfMYmml77VBOLV1EynYUhhY=;
        b=WKdgV9QcI5RSraYR+KDAlbMQ3BznkgslbpMN+yFcyrwqGL3k6aHiH0rA90WSzqPVYg
         rjvJfLrc0K+WhSYOmJbBhn6O0TCIePlzlTmm7Op6mHaqEMXqdJvr+cdC3BwhPI7HYS2t
         gnJ/CUyQNJET6XiCYTH0dfRTQZHZ9RTmP6wQvBXWG+RAqpcmzZAI6p6phbF2GSlDCBiV
         7QA8yfvw74i5++zOBCnJCWmF1IM5agIKq4J6u7N9ELoEAC8YGiFpYDVLSWE5ApOK6f8i
         OoUsHCeeUE2YiS66G/QaYv9pfw0tzx5/jS8Ndn8jNvzG0oviNF8md4N+mfogBtzj52n/
         F6iQ==
X-Gm-Message-State: AOAM531BiK9lxaw88xg9kfl/qzKBGna2B45FX1xJ1QYPfMenQWvnC6Bs
        A6rWXi3NEAqURjycO48xNo9fJqeMe9xOS93S0p+xKXonmQ5s/bvXM6M+hEmJmAUOyORJFwUluCN
        yXKr4uqbipLf5s9c5IGyYC0UX4J81FzF9/w==
X-Received: by 2002:a17:90b:3a81:: with SMTP id om1mr16654186pjb.184.1634927947594;
        Fri, 22 Oct 2021 11:39:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyr0k2tHvFjYosAvYccPc7j2GWcS5YtlC6EJ6ASX8+JynI78K6CcwXsy3RFuazSDXjjzkOUIw==
X-Received: by 2002:a17:90b:3a81:: with SMTP id om1mr16654167pjb.184.1634927947318;
        Fri, 22 Oct 2021 11:39:07 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id g16sm5608111pfv.192.2021.10.22.11.39.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Oct 2021 11:39:06 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2F2495FBC4; Fri, 22 Oct 2021 11:39:06 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 26A9EA0409;
        Fri, 22 Oct 2021 11:39:06 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     davem@davemloft.net, netdev@vger.kernel.org, vfalico@gmail.com,
        andy@greyhouse.net
Subject: Re: [PATCH net-next 4/8] net: bonding: constify and use dev_addr_set()
In-reply-to: <20211022175543.2518732-5-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org> <20211022175543.2518732-5-kuba@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Fri, 22 Oct 2021 10:55:39 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7527.1634927946.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 22 Oct 2021 11:39:06 -0700
Message-ID: <7528.1634927946@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
>of VLANs...") introduced a rbtree for faster Ethernet address look
>up. To maintain netdev->dev_addr in this tree we need to make all
>the writes to it got through appropriate helpers.

	Should the above be "go through"?

	-J

>Make sure local references to netdev->dev_addr are constant.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
>CC: j.vosburgh@gmail.com
>CC: vfalico@gmail.com
>CC: andy@greyhouse.net
>---
> drivers/net/bonding/bond_alb.c  | 28 +++++++++++++---------------
> drivers/net/bonding/bond_main.c |  2 +-
> 2 files changed, 14 insertions(+), 16 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 7d3752cbf761..2ec8e015c7b3 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -50,7 +50,7 @@ struct arp_pkt {
> #pragma pack()
> =

> /* Forward declaration */
>-static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[]=
,
>+static void alb_send_learning_packets(struct slave *slave, const u8 mac_=
addr[],
> 				      bool strict_match);
> static void rlb_purge_src_ip(struct bonding *bond, struct arp_pkt *arp);
> static void rlb_src_unlink(struct bonding *bond, u32 index);
>@@ -353,7 +353,8 @@ static struct slave *rlb_next_rx_slave(struct bonding=
 *bond)
>  *
>  * Caller must hold RTNL
>  */
>-static void rlb_teach_disabled_mac_on_primary(struct bonding *bond, u8 a=
ddr[])
>+static void rlb_teach_disabled_mac_on_primary(struct bonding *bond,
>+					      const u8 addr[])
> {
> 	struct slave *curr_active =3D rtnl_dereference(bond->curr_active_slave)=
;
> =

>@@ -904,7 +905,7 @@ static void rlb_clear_vlan(struct bonding *bond, unsi=
gned short vlan_id)
> =

> /*********************** tlb/rlb shared functions *********************/
> =

>-static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
>+static void alb_send_lp_vid(struct slave *slave, const u8 mac_addr[],
> 			    __be16 vlan_proto, u16 vid)
> {
> 	struct learning_pkt pkt;
>@@ -940,7 +941,7 @@ static void alb_send_lp_vid(struct slave *slave, u8 m=
ac_addr[],
> struct alb_walk_data {
> 	struct bonding *bond;
> 	struct slave *slave;
>-	u8 *mac_addr;
>+	const u8 *mac_addr;
> 	bool strict_match;
> };
> =

>@@ -949,9 +950,9 @@ static int alb_upper_dev_walk(struct net_device *uppe=
r,
> {
> 	struct alb_walk_data *data =3D (struct alb_walk_data *)priv->data;
> 	bool strict_match =3D data->strict_match;
>+	const u8 *mac_addr =3D data->mac_addr;
> 	struct bonding *bond =3D data->bond;
> 	struct slave *slave =3D data->slave;
>-	u8 *mac_addr =3D data->mac_addr;
> 	struct bond_vlan_tag *tags;
> =

> 	if (is_vlan_dev(upper) &&
>@@ -982,7 +983,7 @@ static int alb_upper_dev_walk(struct net_device *uppe=
r,
> 	return 0;
> }
> =

>-static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[]=
,
>+static void alb_send_learning_packets(struct slave *slave, const u8 mac_=
addr[],
> 				      bool strict_match)
> {
> 	struct bonding *bond =3D bond_get_bond_by_slave(slave);
>@@ -1006,14 +1007,14 @@ static void alb_send_learning_packets(struct slav=
e *slave, u8 mac_addr[],
> 	rcu_read_unlock();
> }
> =

>-static int alb_set_slave_mac_addr(struct slave *slave, u8 addr[],
>+static int alb_set_slave_mac_addr(struct slave *slave, const u8 addr[],
> 				  unsigned int len)
> {
> 	struct net_device *dev =3D slave->dev;
> 	struct sockaddr_storage ss;
> =

> 	if (BOND_MODE(slave->bond) =3D=3D BOND_MODE_TLB) {
>-		memcpy(dev->dev_addr, addr, len);
>+		__dev_addr_set(dev, addr, len);
> 		return 0;
> 	}
> =

>@@ -1242,8 +1243,7 @@ static int alb_set_mac_address(struct bonding *bond=
, void *addr)
> 		res =3D dev_set_mac_address(slave->dev, addr, NULL);
> =

> 		/* restore net_device's hw address */
>-		bond_hw_addr_copy(slave->dev->dev_addr, tmp_addr,
>-				  slave->dev->addr_len);
>+		dev_addr_set(slave->dev, tmp_addr);
> =

> 		if (res)
> 			goto unwind;
>@@ -1263,8 +1263,7 @@ static int alb_set_mac_address(struct bonding *bond=
, void *addr)
> 				  rollback_slave->dev->addr_len);
> 		dev_set_mac_address(rollback_slave->dev,
> 				    (struct sockaddr *)&ss, NULL);
>-		bond_hw_addr_copy(rollback_slave->dev->dev_addr, tmp_addr,
>-				  rollback_slave->dev->addr_len);
>+		dev_addr_set(rollback_slave->dev, tmp_addr);
> 	}
> =

> 	return res;
>@@ -1727,8 +1726,7 @@ void bond_alb_handle_active_change(struct bonding *=
bond, struct slave *new_slave
> 		dev_set_mac_address(new_slave->dev, (struct sockaddr *)&ss,
> 				    NULL);
> =

>-		bond_hw_addr_copy(new_slave->dev->dev_addr, tmp_addr,
>-				  new_slave->dev->addr_len);
>+		dev_addr_set(new_slave->dev, tmp_addr);
> 	}
> =

> 	/* curr_active_slave must be set before calling alb_swap_mac_addr */
>@@ -1761,7 +1759,7 @@ int bond_alb_set_mac_address(struct net_device *bon=
d_dev, void *addr)
> 	if (res)
> 		return res;
> =

>-	bond_hw_addr_copy(bond_dev->dev_addr, ss->__data, bond_dev->addr_len);
>+	dev_addr_set(bond_dev, ss->__data);
> =

> 	/* If there is no curr_active_slave there is nothing else to do.
> 	 * Otherwise we'll need to pass the new address to it and handle
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 0c52612cb8e9..ff8da720a33a 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -923,7 +923,7 @@ static int bond_set_dev_addr(struct net_device *bond_=
dev,
> 	if (err)
> 		return err;
> =

>-	memcpy(bond_dev->dev_addr, slave_dev->dev_addr, slave_dev->addr_len);
>+	__dev_addr_set(bond_dev, slave_dev->dev_addr, slave_dev->addr_len);
> 	bond_dev->addr_assign_type =3D NET_ADDR_STOLEN;
> 	call_netdevice_notifiers(NETDEV_CHANGEADDR, bond_dev);
> 	return 0;
>-- =

>2.31.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
