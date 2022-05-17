Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF0652AD5B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353206AbiEQVLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353201AbiEQVLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:11:23 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB227CCE
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:11:21 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 34B2E3F5F4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 21:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1652821879;
        bh=ABLCy/8yhWR8/YRA8GGw8Leu35Alfnt7kjgvDbpodu8=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=lD8Lkb+oxUwtMlh3aQJ/pgieBbs9E/FGgDS+QGXDUEnscFAutf9QSldCcmoK1oWd1
         /eFaU48y0IuPPNMvnJHSrGpAo6OuMcs7Z40REX2PA73l/WST6wcULmtaRY5b4GhRFg
         aa5WdW2venYhSkVjyLwd73XYCi6ZFka9l7lph1M8HQ98n4r8S1d9gVdqFMUYdcjlUv
         GRq7O5vGUqbsJcVZt5ueYKt0gcmq4q647UpfrD4utI4qy5Dejb0Wh4a8Sd3I5UaKz5
         pCFk9hbsGYkqcYqhZ+kZfNi6A8ey8ocAb4FvvgTGZviukpeb/KdmwDciy6sd3Fabyc
         /M/GPCYs0dAkg==
Received: by mail-pg1-f197.google.com with SMTP id y17-20020a637d11000000b003ab06870074so146502pgc.15
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=ABLCy/8yhWR8/YRA8GGw8Leu35Alfnt7kjgvDbpodu8=;
        b=YYmqhEqGT5hRWoxHNujsLopGwexz9fHbpcD/CnuxrasUYGI8hQOFlgk0aTxWeuC2mT
         edw/5+iVQMEo4PxMk9OWP3ULcbqLUGTA996WLrZLDjUytgDcvIaYl0ZG/upDug6rpYXA
         x/yCSXhwdsU4FhRZHZJ5Ug6pbChAnxL6yJ9i9ABp8rCNFkwTFujW2BQB4o8ADYLVdHEb
         PQwjLYBHoltn7ABVOZAOVMtHAz5ZoowM7Ie9McgKs8PkWVKv7EfFRGGO6YCJkx9lr/PZ
         bQ0sjZz9yPExgFvk6NdfkCkzzDRaMDIV8k/G3f8tWxqUqwFH665h2Uy3jRLQV0g/hi//
         dmCA==
X-Gm-Message-State: AOAM533eX2tLs+81rIGPFEN4brGDRAIgPv2SGVo2BtRx7sVOb+DCK4ZJ
        T2KtUxYuZgZJ9dNLvijdNSEFaj3KlVXxcpVPHVeEjTBBssrCnQkzCmxhvJmo6M2QSjm8jonu2OJ
        lkKJpkQAL9e2Bnn4xcdndM8Q3n6xiiTC3PA==
X-Received: by 2002:a17:90a:cc15:b0:1df:5929:15b9 with SMTP id b21-20020a17090acc1500b001df592915b9mr12007887pju.178.1652821875804;
        Tue, 17 May 2022 14:11:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwirMLrDtjCxcsFM4LFMAkbF3zdaum6IIM0EBN4T5baoNo5mAWh+VNid7F9kZ1+M6UtSlZumg==
X-Received: by 2002:a17:90a:cc15:b0:1df:5929:15b9 with SMTP id b21-20020a17090acc1500b001df592915b9mr12007856pju.178.1652821875336;
        Tue, 17 May 2022 14:11:15 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id f16-20020a170902ab9000b0016191b843e2sm52271plr.235.2022.05.17.14.11.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 May 2022 14:11:14 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6DF5D5FDEE; Tue, 17 May 2022 14:11:14 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 67D51A0B21;
        Tue, 17 May 2022 14:11:14 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] bonding: netlink error message support for options
In-reply-to: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
References: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 17 May 2022 16:31:19 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2124.1652821874.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 17 May 2022 14:11:14 -0700
Message-ID: <2125.1652821874@famine>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Add support for reporting errors via extack in both bond_newlink
>and bond_changelink.
>
>Instead of having to look in the kernel log for why an option was not
>correct just report the error to the user via the extack variable.
>
>What is currently reported today:
>  ip link add bond0 type bond
>  ip link set bond0 up
>  ip link set bond0 type bond mode 4
> RTNETLINK answers: Device or resource busy
>
>After this change:
>  ip link add bond0 type bond
>  ip link set bond0 up
>  ip link set bond0 type bond mode 4
> Error: option mode: unable to set because the bond device is up.
>
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>---
>
>Notes:
>    This is an RFC because the current NL_SET_ERR_MSG() macros do not sup=
port
>    printf like semantics so I rolled my own buffer setting in __bond_opt=
_set().
>    The issue is I could not quite figure out the life-cycle of the buffe=
r, if
>    rtnl lock is held until after the text buffer is copied into the pack=
et
>    then we are ok, otherwise, some other type of buffer management schem=
e will
>    be needed as this could result in corrupted error messages when modif=
ying
>    multiple bonds.

	If I'm reading the code correctly, rtnl isn't held that long.
Once the ->doit() returns, rtnl is dropped, but the copy happens later:

rtnetlink_rcv()
	netlink_rcv_skb(skb, &rtnetlink_rcv_msg)
		rtnetlink_rcv_msg()	[ as cb(skb, nlh, &extack) ]
			rtnl_lock()
			link->doit()	[ rtnl_setlink, rtnl_newlink, et al ]
			rtnl_unlock()
		netlink_ack()

inside netlink_ack():

        if (nlk_has_extack && extack) {
                if (extack->_msg) {
                        WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG,
                                               extack->_msg));
                }

	Even if the strings have to be constant (via NL_SET_ERR_MSG),
adding extack messages is likely still an improvement.

	-J

> drivers/net/bonding/bond_netlink.c | 87 ++++++++++++++++++------------
> drivers/net/bonding/bond_options.c | 62 +++++++++++++--------
> include/net/bond_options.h         |  2 +-
> 3 files changed, 96 insertions(+), 55 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index f427fa1737c7..418a4f3d00a3 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -151,7 +151,7 @@ static int bond_slave_changelink(struct net_device *b=
ond_dev,
> 		snprintf(queue_id_str, sizeof(queue_id_str), "%s:%u\n",
> 			 slave_dev->name, queue_id);
> 		bond_opt_initstr(&newval, queue_id_str);
>-		err =3D __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -175,7 +175,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int mode =3D nla_get_u8(data[IFLA_BOND_MODE]);
> =

> 		bond_opt_initval(&newval, mode);
>-		err =3D __bond_opt_set(bond, BOND_OPT_MODE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MODE, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -192,7 +192,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			active_slave =3D slave_dev->name;
> 		}
> 		bond_opt_initstr(&newval, active_slave);
>-		err =3D __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -200,7 +201,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		miimon =3D nla_get_u32(data[IFLA_BOND_MIIMON]);
> =

> 		bond_opt_initval(&newval, miimon);
>-		err =3D __bond_opt_set(bond, BOND_OPT_MIIMON, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MIIMON, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -208,7 +209,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int updelay =3D nla_get_u32(data[IFLA_BOND_UPDELAY]);
> =

> 		bond_opt_initval(&newval, updelay);
>-		err =3D __bond_opt_set(bond, BOND_OPT_UPDELAY, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_UPDELAY, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -216,7 +217,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int downdelay =3D nla_get_u32(data[IFLA_BOND_DOWNDELAY]);
> =

> 		bond_opt_initval(&newval, downdelay);
>-		err =3D __bond_opt_set(bond, BOND_OPT_DOWNDELAY, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_DOWNDELAY, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -224,7 +225,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int delay =3D nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
> =

> 		bond_opt_initval(&newval, delay);
>-		err =3D __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -232,7 +234,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int use_carrier =3D nla_get_u8(data[IFLA_BOND_USE_CARRIER]);
> =

> 		bond_opt_initval(&newval, use_carrier);
>-		err =3D __bond_opt_set(bond, BOND_OPT_USE_CARRIER, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_USE_CARRIER, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -240,12 +243,14 @@ static int bond_changelink(struct net_device *bond_=
dev, struct nlattr *tb[],
> 		int arp_interval =3D nla_get_u32(data[IFLA_BOND_ARP_INTERVAL]);
> =

> 		if (arp_interval && miimon) {
>-			netdev_err(bond->dev, "ARP monitoring cannot be used with MII monitor=
ing\n");
>+			NL_SET_ERR_MSG(extack,
>+				       "ARP monitoring cannot be used with MII monitoring");
> 			return -EINVAL;
> 		}
> =

> 		bond_opt_initval(&newval, arp_interval);
>-		err =3D __bond_opt_set(bond, BOND_OPT_ARP_INTERVAL, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_ARP_INTERVAL, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -264,7 +269,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> =

> 			bond_opt_initval(&newval, (__force u64)target);
> 			err =3D __bond_opt_set(bond, BOND_OPT_ARP_TARGETS,
>-					     &newval);
>+					     &newval, extack);
> 			if (err)
> 				break;
> 			i++;
>@@ -297,7 +302,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> =

> 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
> 			err =3D __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
>-					     &newval);
>+					     &newval, extack);
> 			if (err)
> 				break;
> 			i++;
>@@ -312,12 +317,14 @@ static int bond_changelink(struct net_device *bond_=
dev, struct nlattr *tb[],
> 		int arp_validate =3D nla_get_u32(data[IFLA_BOND_ARP_VALIDATE]);
> =

> 		if (arp_validate && miimon) {
>-			netdev_err(bond->dev, "ARP validating cannot be used with MII monitor=
ing\n");
>+			NL_SET_ERR_MSG(extack,
>+				       "ARP validating cannot be used with MII monitoring");
> 			return -EINVAL;
> 		}
> =

> 		bond_opt_initval(&newval, arp_validate);
>-		err =3D __bond_opt_set(bond, BOND_OPT_ARP_VALIDATE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_ARP_VALIDATE, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -326,7 +333,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u32(data[IFLA_BOND_ARP_ALL_TARGETS]);
> =

> 		bond_opt_initval(&newval, arp_all_targets);
>-		err =3D __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_ARP_ALL_TARGETS, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -340,7 +348,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			primary =3D dev->name;
> =

> 		bond_opt_initstr(&newval, primary);
>-		err =3D __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_PRIMARY, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -349,7 +357,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_PRIMARY_RESELECT]);
> =

> 		bond_opt_initval(&newval, primary_reselect);
>-		err =3D __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_PRIMARY_RESELECT, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -358,7 +367,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_FAIL_OVER_MAC]);
> =

> 		bond_opt_initval(&newval, fail_over_mac);
>-		err =3D __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_FAIL_OVER_MAC, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -367,7 +377,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_XMIT_HASH_POLICY]);
> =

> 		bond_opt_initval(&newval, xmit_hash_policy);
>-		err =3D __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_XMIT_HASH, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -376,7 +386,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u32(data[IFLA_BOND_RESEND_IGMP]);
> =

> 		bond_opt_initval(&newval, resend_igmp);
>-		err =3D __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_RESEND_IGMP, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -385,7 +396,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_NUM_PEER_NOTIF]);
> =

> 		bond_opt_initval(&newval, num_peer_notif);
>-		err =3D __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_NUM_PEER_NOTIF, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -394,7 +406,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_ALL_SLAVES_ACTIVE]);
> =

> 		bond_opt_initval(&newval, all_slaves_active);
>-		err =3D __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -403,7 +416,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u32(data[IFLA_BOND_MIN_LINKS]);
> =

> 		bond_opt_initval(&newval, min_links);
>-		err =3D __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MINLINKS, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -412,7 +425,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u32(data[IFLA_BOND_LP_INTERVAL]);
> =

> 		bond_opt_initval(&newval, lp_interval);
>-		err =3D __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_LP_INTERVAL, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -421,7 +435,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u32(data[IFLA_BOND_PACKETS_PER_SLAVE]);
> =

> 		bond_opt_initval(&newval, packets_per_slave);
>-		err =3D __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -430,7 +445,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int lacp_active =3D nla_get_u8(data[IFLA_BOND_AD_LACP_ACTIVE]);
> =

> 		bond_opt_initval(&newval, lacp_active);
>-		err =3D __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_LACP_ACTIVE, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -440,7 +456,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_AD_LACP_RATE]);
> =

> 		bond_opt_initval(&newval, lacp_rate);
>-		err =3D __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_LACP_RATE, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -449,7 +465,7 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u8(data[IFLA_BOND_AD_SELECT]);
> =

> 		bond_opt_initval(&newval, ad_select);
>-		err =3D __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_AD_SELECT, &newval, extack);
> 		if (err)
> 			return err;
> 	}
>@@ -458,7 +474,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u16(data[IFLA_BOND_AD_ACTOR_SYS_PRIO]);
> =

> 		bond_opt_initval(&newval, actor_sys_prio);
>-		err =3D __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYS_PRIO, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -467,7 +484,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 			nla_get_u16(data[IFLA_BOND_AD_USER_PORT_KEY]);
> =

> 		bond_opt_initval(&newval, port_key);
>-		err =3D __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_AD_USER_PORT_KEY, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -477,7 +495,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> =

> 		bond_opt_initval(&newval,
> 				 nla_get_u64(data[IFLA_BOND_AD_ACTOR_SYSTEM]));
>-		err =3D __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_AD_ACTOR_SYSTEM, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -485,7 +504,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int dynamic_lb =3D nla_get_u8(data[IFLA_BOND_TLB_DYNAMIC_LB]);
> =

> 		bond_opt_initval(&newval, dynamic_lb);
>-		err =3D __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_TLB_DYNAMIC_LB, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>@@ -494,7 +514,8 @@ static int bond_changelink(struct net_device *bond_de=
v, struct nlattr *tb[],
> 		int missed_max =3D nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
> =

> 		bond_opt_initval(&newval, missed_max);
>-		err =3D __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval,
>+				     extack);
> 		if (err)
> 			return err;
> 	}
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index 64f7db2627ce..4a95503384a3 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -636,7 +636,8 @@ static int bond_opt_check_deps(struct bonding *bond,
> }
> =

> static void bond_opt_dep_print(struct bonding *bond,
>-			       const struct bond_option *opt)
>+			       const struct bond_option *opt,
>+			       char *buf, size_t bufsize)
> {
> 	const struct bond_opt_value *modeval;
> 	struct bond_params *params;
>@@ -644,16 +645,18 @@ static void bond_opt_dep_print(struct bonding *bond=
,
> 	params =3D &bond->params;
> 	modeval =3D bond_opt_get_val(BOND_OPT_MODE, params->mode);
> 	if (test_bit(params->mode, &opt->unsuppmodes))
>-		netdev_err(bond->dev, "option %s: mode dependency failed, not supporte=
d in mode %s(%llu)\n",
>-			   opt->name, modeval->string, modeval->value);
>+		scnprintf(buf, bufsize, "option %s: mode dependency failed, not suppor=
ted in mode %s(%llu)\n",
>+			  opt->name, modeval->string, modeval->value);
> }
> =

> static void bond_opt_error_interpret(struct bonding *bond,
> 				     const struct bond_option *opt,
>-				     int error, const struct bond_opt_value *val)
>+				     int error, const struct bond_opt_value *val,
>+				     char *buf, size_t bufsize)
> {
> 	const struct bond_opt_value *minval, *maxval;
> 	char *p;
>+	int i =3D 0;
> =

> 	switch (error) {
> 	case -EINVAL:
>@@ -663,38 +666,45 @@ static void bond_opt_error_interpret(struct bonding=
 *bond,
> 				p =3D strchr(val->string, '\n');
> 				if (p)
> 					*p =3D '\0';
>-				netdev_err(bond->dev, "option %s: invalid value (%s)\n",
>-					   opt->name, val->string);
>+				i =3D scnprintf(buf, bufsize,
>+					      "option %s: invalid value (%s)",
>+					      opt->name, val->string);
> 			} else {
>-				netdev_err(bond->dev, "option %s: invalid value (%llu)\n",
>-					   opt->name, val->value);
>+				i =3D scnprintf(buf, bufsize,
>+					      "option %s: invalid value (%llu)",
>+					      opt->name, val->value);
> 			}
> 		}
> 		minval =3D bond_opt_get_flags(opt, BOND_VALFLAG_MIN);
> 		maxval =3D bond_opt_get_flags(opt, BOND_VALFLAG_MAX);
> 		if (!maxval)
> 			break;
>-		netdev_err(bond->dev, "option %s: allowed values %llu - %llu\n",
>-			   opt->name, minval ? minval->value : 0, maxval->value);
>+		if (i) {
>+			// index buf to overwirte '\n' from above
>+			buf =3D &buf[i];
>+			bufsize -=3D i;
>+		}
>+		scnprintf(buf, bufsize, " allowed values %llu - %llu",
>+			  minval ? minval->value : 0, maxval->value);
> 		break;
> 	case -EACCES:
>-		bond_opt_dep_print(bond, opt);
>+		bond_opt_dep_print(bond, opt, buf, bufsize);
> 		break;
> 	case -ENOTEMPTY:
>-		netdev_err(bond->dev, "option %s: unable to set because the bond devic=
e has slaves\n",
>-			   opt->name);
>+		scnprintf(buf, bufsize, "option %s: unable to set because the bond dev=
ice has slaves",
>+			  opt->name);
> 		break;
> 	case -EBUSY:
>-		netdev_err(bond->dev, "option %s: unable to set because the bond devic=
e is up\n",
>-			   opt->name);
>+		scnprintf(buf, bufsize, "option %s: unable to set because the bond dev=
ice is up",
>+			  opt->name);
> 		break;
> 	case -ENODEV:
> 		if (val && val->string) {
> 			p =3D strchr(val->string, '\n');
> 			if (p)
> 				*p =3D '\0';
>-			netdev_err(bond->dev, "option %s: interface %s does not exist!\n",
>-				   opt->name, val->string);
>+			scnprintf(buf, bufsize, "option %s: interface %s does not exist!",
>+				  opt->name, val->string);
> 		}
> 		break;
> 	default:
>@@ -713,7 +723,8 @@ static void bond_opt_error_interpret(struct bonding *=
bond,
>  * must be obtained before calling this function.
>  */
> int __bond_opt_set(struct bonding *bond,
>-		   unsigned int option, struct bond_opt_value *val)
>+		   unsigned int option, struct bond_opt_value *val,
>+		   struct netlink_ext_ack *extack)
> {
> 	const struct bond_opt_value *retval =3D NULL;
> 	const struct bond_option *opt;
>@@ -734,8 +745,17 @@ int __bond_opt_set(struct bonding *bond,
> 	}
> 	ret =3D opt->set(bond, retval);
> out:
>-	if (ret)
>-		bond_opt_error_interpret(bond, opt, ret, val);
>+	if (ret) {
>+		static char buf[120];
>+		buf[0] =3D '\0';
>+		bond_opt_error_interpret(bond, opt, ret, val, buf, sizeof(buf));
>+		if (buf[0] !=3D '\0') {
>+			if (extack)
>+				extack->_msg =3D buf;
>+			else
>+				netdev_err(bond->dev, "Error: %s\n", buf);
>+		}
>+	}
> =

> 	return ret;
> }
>@@ -757,7 +777,7 @@ int __bond_opt_set_notify(struct bonding *bond,
> =

> 	ASSERT_RTNL();
> =

>-	ret =3D __bond_opt_set(bond, option, val);
>+	ret =3D __bond_opt_set(bond, option, val, NULL);
> =

> 	if (!ret && (bond->dev->reg_state =3D=3D NETREG_REGISTERED))
> 		call_netdevice_notifiers(NETDEV_CHANGEINFODATA, bond->dev);
>diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>index 61b49063791c..ae38557adc25 100644
>--- a/include/net/bond_options.h
>+++ b/include/net/bond_options.h
>@@ -107,7 +107,7 @@ struct bond_option {
> };
> =

> int __bond_opt_set(struct bonding *bond, unsigned int option,
>-		   struct bond_opt_value *val);
>+		   struct bond_opt_value *val, struct netlink_ext_ack *extack);
> int __bond_opt_set_notify(struct bonding *bond, unsigned int option,
> 			  struct bond_opt_value *val);
> int bond_opt_tryset_rtnl(struct bonding *bond, unsigned int option, char=
 *buf);
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
