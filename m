Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C564FCE4F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347147AbiDLE6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347092AbiDLE6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:58:08 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F219E11C07
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:55:51 -0700 (PDT)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7D27F3F845
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649739349;
        bh=pow7WGCl5/+qsXQpSH+3LFTNAwgaC5eqLAL0Vx4SfPA=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=P4clLl8absVl/e1mN3oCyO5b7jcg6B+Tu1X+4YUv3azaKEt6TZugi6b6prj3zgkDI
         bz8qLPwiEeyQ4XXPqm2koBisr1Vliu3+iecwkVzfUAVmCf51E0N1fEEiVSZ9DSUE1v
         r5qtBTBKA4qpX8oPr6EeuwXBjfz6X768s74B6JkOeYCuJx+i6J5759OZMnU5TU6qfd
         QkWvyr+FlGVL8CAlzoim3nhNAwVB0oWtxiv2MBPZ35Ck068KtqgWCERLDFVlaphBCg
         Xf4H8XW65uiuU18uFYA6bNVqycDYpAinWU2rvvNzfIIexZE6pD4HoSf2obmEgADX3Z
         moh6EZNFa3s5g==
Received: by mail-pg1-f198.google.com with SMTP id u32-20020a634560000000b0039940fd2020so9943242pgk.20
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=pow7WGCl5/+qsXQpSH+3LFTNAwgaC5eqLAL0Vx4SfPA=;
        b=1BhUbc9trxBmlrM5f+JBoR0r6brwUBTb/C8JWaVBzv5lwrHLAyj1Ff+ebfkCf/EUR4
         8PAvrqBcSglKcZdo7UEwBRnT1mj9VL0wKPqOWJ9IVF9W4TIi9MrdfX2trEpkJMIZ0QPj
         CCvvBvgwzrOMDnshTBcVIJo2R1iqzl85YLzDvTJz2yhAUnyn/rAm0KhY1ikPt+/g0ZgL
         5Lgg51H//fMceGIUDmDO5C7jPckv+45OBnj4WhY7DadJEhCSUJC0CaZDQMTRApy7HRBi
         5lay7d7sSBJ2THMo2mxL3Pm9iVzr+22OnA9i48Y9aivr9lIGjYIQKLNUb7i6fRW37mGL
         f7OA==
X-Gm-Message-State: AOAM533pJIhYYuYaXSRZ+u26gOsw3RCGo6ZxlyWMiFhfK3JIZxZua9fS
        3I3PpOsqyk1tpPOCBzJceTTrKWoxUgVMnMzJhME86HWck4ObNhWJ7dpRtaD3KA7SWoh3cRhTWOk
        bHGf4aAp/5JlGoRrl34ACHFoDZBk0YhBdNQ==
X-Received: by 2002:a63:2006:0:b0:39d:8460:48a4 with SMTP id g6-20020a632006000000b0039d846048a4mr3272766pgg.623.1649739347823;
        Mon, 11 Apr 2022 21:55:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFOdDCW3YRf6PojFhHKJ4BiX1KaUM1fTlvlCz0qK4sw40csATRUO3oemtsHIMwyGaT8MQgwg==
X-Received: by 2002:a63:2006:0:b0:39d:8460:48a4 with SMTP id g6-20020a632006000000b0039d846048a4mr3272735pgg.623.1649739347533;
        Mon, 11 Apr 2022 21:55:47 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id s22-20020a056a00179600b004fb28a97abdsm40804798pfg.12.2022.04.11.21.55.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Apr 2022 21:55:46 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id E5E576093D; Mon, 11 Apr 2022 21:55:45 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DEE73A0B21;
        Mon, 11 Apr 2022 21:55:45 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
In-reply-to: <20220412041322.2409558-1-liuhangbin@gmail.com>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Tue, 12 Apr 2022 12:13:22 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11972.1649739345.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 11 Apr 2022 21:55:45 -0700
Message-ID: <11973.1649739345@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Add per port priority support for bonding. A higher number means higher
>priority. The primary slave still has the highest priority. This option
>also follows the primary_reselect rules.

	The above description (and the Subject) should mention that this
apparently refers to priority in interface selection during failover
events.

>This option could only be configured via netlink.
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> Documentation/networking/bonding.rst |  9 +++++++++
> drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++++
> drivers/net/bonding/bond_netlink.c   | 12 ++++++++++++
> include/net/bonding.h                |  1 +
> include/uapi/linux/if_link.h         |  1 +
> tools/include/uapi/linux/if_link.h   |  1 +
> 6 files changed, 51 insertions(+)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 525e6842dd33..103e292a04a1 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -780,6 +780,15 @@ peer_notif_delay
> 	value is 0 which means to match the value of the link monitor
> 	interval.
> =

>+prio
>+	Slave priority. A higher number means higher priority.
>+	The primary slave has the highest priority. This option also
>+	follows the primary_reselect rules.
>+
>+	This option could only be configured via netlink, and is only valid
>+	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
>+	The default value is 0.
>+
> primary
> =

> 	A string (eth0, eth2, etc) specifying which slave is the
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 15eddca7b4b6..4211b79ac619 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1026,12 +1026,38 @@ static void bond_do_fail_over_mac(struct bonding =
*bond,
> =

> }
> =

>+/**
>+ * bond_choose_primary_or_current - select the primary or high priority =
slave
>+ * @bond: our bonding struct
>+ *
>+ * - Check if there is a primary link. If the primary link was set and i=
s up,
>+ *   go on and do link reselection.
>+ *
>+ * - If primary link is not set or down, find the highest priority link.
>+ *   If the highest priority link is not current slave, set it as primar=
y
>+ *   link and do link reselection.
>+ */
> static struct slave *bond_choose_primary_or_current(struct bonding *bond=
)
> {
> 	struct slave *prim =3D rtnl_dereference(bond->primary_slave);
> 	struct slave *curr =3D rtnl_dereference(bond->curr_active_slave);
>+	struct slave *slave, *hprio =3D NULL;
>+	struct list_head *iter;
> =

> 	if (!prim || prim->link !=3D BOND_LINK_UP) {
>+		bond_for_each_slave(bond, slave, iter) {
>+			if (slave->link =3D=3D BOND_LINK_UP) {
>+				hprio =3D hprio ? hprio : slave;
>+				if (slave->prio > hprio->prio)
>+					hprio =3D slave;
>+			}
>+		}
>+
>+		if (hprio && hprio !=3D curr) {
>+			prim =3D hprio;
>+			goto link_reselect;
>+		}
>+
> 		if (!curr || curr->link !=3D BOND_LINK_UP)
> 			return NULL;
> 		return curr;
>@@ -1042,6 +1068,7 @@ static struct slave *bond_choose_primary_or_current=
(struct bonding *bond)
> 		return prim;
> 	}
> =

>+link_reselect:
> 	if (!curr || curr->link !=3D BOND_LINK_UP)
> 		return prim;
> =

>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index f427fa1737c7..63066559e7d6 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_devi=
ce *bond_dev,
> 		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID */
> 		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STA=
TE */
> 		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_=
STATE */
>+		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
> 		0;
> }
> =

>@@ -53,6 +54,9 @@ static int bond_fill_slave_info(struct sk_buff *skb,
> 	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, slave->queue_id))
> 		goto nla_put_failure;
> =

>+	if (nla_put_s32(skb, IFLA_BOND_SLAVE_PRIO, slave->prio))
>+		goto nla_put_failure;
>+
> 	if (BOND_MODE(slave->bond) =3D=3D BOND_MODE_8023AD) {
> 		const struct aggregator *agg;
> 		const struct port *ad_port;
>@@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_=
MAX + 1] =3D {
> =

> static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1=
] =3D {
> 	[IFLA_BOND_SLAVE_QUEUE_ID]	=3D { .type =3D NLA_U16 },
>+	[IFLA_BOND_SLAVE_PRIO]		=3D { .type =3D NLA_S32 },

	Why used signed instead of unsigned?

	Regardless, the valid range for the prio value should be
documented.

	-J

> };
> =

> static int bond_validate(struct nlattr *tb[], struct nlattr *data[],
>@@ -136,6 +141,7 @@ static int bond_slave_changelink(struct net_device *b=
ond_dev,
> 				 struct nlattr *tb[], struct nlattr *data[],
> 				 struct netlink_ext_ack *extack)
> {
>+	struct slave *slave =3D bond_slave_get_rtnl(slave_dev);
> 	struct bonding *bond =3D netdev_priv(bond_dev);
> 	struct bond_opt_value newval;
> 	int err;
>@@ -156,6 +162,12 @@ static int bond_slave_changelink(struct net_device *=
bond_dev,
> 			return err;
> 	}
> =

>+	/* No need to bother __bond_opt_set as we only support netlink config *=
/
>+	if (data[IFLA_BOND_SLAVE_PRIO]) {
>+		slave->prio =3D nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
>+		bond_select_active_slave(bond);
>+	}
>+
> 	return 0;
> }
> =

>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index b14f4c0b4e9e..4ff093fb2289 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -176,6 +176,7 @@ struct slave {
> 	u32    speed;
> 	u16    queue_id;
> 	u8     perm_hwaddr[MAX_ADDR_LEN];
>+	int    prio;
> 	struct ad_slave_info *ad_info;
> 	struct tlb_slave_info tlb_info;
> #ifdef CONFIG_NET_POLL_CONTROLLER
>diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>index cc284c048e69..204e342b107a 100644
>--- a/include/uapi/linux/if_link.h
>+++ b/include/uapi/linux/if_link.h
>@@ -956,6 +956,7 @@ enum {
> 	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
> 	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
> 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
>+	IFLA_BOND_SLAVE_PRIO,
> 	__IFLA_BOND_SLAVE_MAX,
> };
> =

>diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linu=
x/if_link.h
>index e1ba2d51b717..ee5de9f3700b 100644
>--- a/tools/include/uapi/linux/if_link.h
>+++ b/tools/include/uapi/linux/if_link.h
>@@ -888,6 +888,7 @@ enum {
> 	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
> 	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
> 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
>+	IFLA_BOND_SLAVE_PRIO,
> 	__IFLA_BOND_SLAVE_MAX,
> };
> =

>-- =

>2.35.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
