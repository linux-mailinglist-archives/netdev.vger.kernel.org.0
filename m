Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9E66F3145
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjEAM5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjEAM5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:57:05 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BC210C0
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 05:57:02 -0700 (PDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7BDC23F443
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682945814;
        bh=HRk8cy1VoDoapgVcYtaF8k5Z9TalIOy7hJWJIqQsiHQ=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=JdBk6PvUSeeii5dA1yJvZXvUQAh0oBz3AYOth2X3wzNG51xTFJv3yTrAWxxDf91lV
         dbF3fJuO4mqDFTTvirISX4AhwkhDelG7+6cDWsy+D8ibKu8UWPv8SNMrYs7TzfSfvm
         BJrEYAZPf1HU236MZ7IAUdP2eV+eVUhJ9dqER2ozeYTXEaL/U4XzhTvse2q1h8d6Ie
         /yB0FQg8rtWO8a2FtaftMxyIRH+WHap6s4ucQNT9S1my4A5AaZ9kr702ySurNcpHxy
         zfVVUd8JfT4mQQL3yVhWgqNKY5WCDG4mKl29BwKMLdneliq1/FT/z0w11nFzzDcTJ0
         r6uF4goOw00LQ==
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2ff4bc7a770so1468585f8f.3
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 05:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945814; x=1685537814;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HRk8cy1VoDoapgVcYtaF8k5Z9TalIOy7hJWJIqQsiHQ=;
        b=VaC5BV2WfbsIX3/uC8SO4Yjfcy8Eyc2auVfc31P7/FsszCkTalDiOboIFHJ+1wqDrg
         nYncFW4M1XJ7ADGB85khfBXu3C9227VuY++gB9bCnVRGRf2JVtDSAFROmqoTBVfyzyyO
         5bEeV9J/5cHGsTIDrdFyR3glzpxmQrUamo3lXCe1DOTd3s71wE1xlDPky09ir4pu9Srr
         wx9BhKIXz7LIx+VVc4OyJQ0zbU/C/fQ9Mxzh+8t000ZZKk6N0afhFiF0wj39kODsMyMG
         akyreJGeCxTlDVmovxpsrmLC9g+21ULKGZkT4BSXkyGMphz3kncse7gcWGm8SsqEE3kC
         Wu4A==
X-Gm-Message-State: AC+VfDzzXcokZwBeXUdJ3V6osFwpPBIiZ0TA2rhEj3rsxHnYaJu+m0e4
        kXG6bnXj0Wvh0za0yMxsb0x5aRYf6fivloswLc6734LXVgH26JiuAO6A5PivnDv/7NcSU9TLAhX
        ZxaAQfetHZCFVzvRloT2xePKJx0QRI3jw1w==
X-Received: by 2002:adf:e488:0:b0:306:2d32:8ec with SMTP id i8-20020adfe488000000b003062d3208ecmr2011742wrm.6.1682945814155;
        Mon, 01 May 2023 05:56:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7PXOT7gjLUORaMlLYna+ebVHD5B9aXkgH9TjEzR51UYjgUu2OcnpETslXjXgfiI/J2o0tV+Q==
X-Received: by 2002:adf:e488:0:b0:306:2d32:8ec with SMTP id i8-20020adfe488000000b003062d3208ecmr2011718wrm.6.1682945813862;
        Mon, 01 May 2023 05:56:53 -0700 (PDT)
Received: from vermin.localdomain ([62.168.35.101])
        by smtp.gmail.com with ESMTPSA id j8-20020adff008000000b002f6176cc6desm28221836wro.110.2023.05.01.05.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 05:56:53 -0700 (PDT)
Received: by vermin.localdomain (Postfix, from userid 1000)
        id A565A1C03A0; Mon,  1 May 2023 14:56:52 +0200 (CEST)
Received: from vermin (localhost [127.0.0.1])
        by vermin.localdomain (Postfix) with ESMTP id A35101C039E;
        Mon,  1 May 2023 14:56:52 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, alardam@gmail.com,
        memxor@gmail.com, sdf@google.com, brouer@redhat.com,
        toke@redhat.com
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
In-reply-to: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
Comments: In-reply-to Lorenzo Bianconi <lorenzo@kernel.org>
   message dated "Sun, 30 Apr 2023 12:02:44 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.7+dev; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <95778.1682945812.1@vermin>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 01 May 2023 14:56:52 +0200
Message-ID: <95779.1682945812@vermin>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:

>Introduce xdp_features support for bonding driver according to the slave
>devices attached to the master one. xdp_features is required whenever we
>want to xdp_redirect traffic into a bond device and then into selected
>slaves attached to it.
>
>Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
>Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

	The patch looks ok to me, but the description sounds more like
feature enablement rather than a bug fix as the "Fixes:" tag and net
tree suggest.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>---
>Change since v1:
>- remove bpf self-test patch from the series
>---
> drivers/net/bonding/bond_main.c    | 48 ++++++++++++++++++++++++++++++
> drivers/net/bonding/bond_options.c |  2 ++
> include/net/bonding.h              |  1 +
> 3 files changed, 51 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 710548dbd0c1..c98121b426a4 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1789,6 +1789,45 @@ static void bond_ether_setup(struct net_device *bo=
nd_dev)
> 	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
> }
> =

>+void bond_xdp_set_features(struct net_device *bond_dev)
>+{
>+	struct bonding *bond =3D netdev_priv(bond_dev);
>+	xdp_features_t val =3D NETDEV_XDP_ACT_MASK;
>+	struct list_head *iter;
>+	struct slave *slave;
>+
>+	ASSERT_RTNL();
>+
>+	if (!bond_xdp_check(bond)) {
>+		xdp_clear_features_flag(bond_dev);
>+		return;
>+	}
>+
>+	bond_for_each_slave(bond, slave, iter) {
>+		struct net_device *dev =3D slave->dev;
>+
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
>+			xdp_clear_features_flag(bond_dev);
>+			return;
>+		}
>+
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
>+			val &=3D ~NETDEV_XDP_ACT_REDIRECT;
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
>+			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT;
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
>+			val &=3D ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
>+			val &=3D ~NETDEV_XDP_ACT_HW_OFFLOAD;
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
>+			val &=3D ~NETDEV_XDP_ACT_RX_SG;
>+		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
>+			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT_SG;
>+	}
>+
>+	xdp_set_features_flag(bond_dev, val);
>+}
>+
> /* enslave device <slave> to bond device <master> */
> int bond_enslave(struct net_device *bond_dev, struct net_device *slave_d=
ev,
> 		 struct netlink_ext_ack *extack)
>@@ -2236,6 +2275,8 @@ int bond_enslave(struct net_device *bond_dev, struc=
t net_device *slave_dev,
> 			bpf_prog_inc(bond->xdp_prog);
> 	}
> =

>+	bond_xdp_set_features(bond_dev);
>+
> 	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link=
\n",
> 		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
> 		   new_slave->link !=3D BOND_LINK_DOWN ? "an up" : "a down");
>@@ -2483,6 +2524,7 @@ static int __bond_release_one(struct net_device *bo=
nd_dev,
> 	if (!netif_is_bond_master(slave_dev))
> 		slave_dev->priv_flags &=3D ~IFF_BONDING;
> =

>+	bond_xdp_set_features(bond_dev);
> 	kobject_put(&slave->kobj);
> =

> 	return 0;
>@@ -3930,6 +3972,9 @@ static int bond_slave_netdev_event(unsigned long ev=
ent,
> 		/* Propagate to master device */
> 		call_netdevice_notifiers(event, slave->bond->dev);
> 		break;
>+	case NETDEV_XDP_FEAT_CHANGE:
>+		bond_xdp_set_features(bond_dev);
>+		break;
> 	default:
> 		break;
> 	}
>@@ -5874,6 +5919,9 @@ void bond_setup(struct net_device *bond_dev)
> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP)
> 		bond_dev->features |=3D BOND_XFRM_FEATURES;
> #endif /* CONFIG_XFRM_OFFLOAD */
>+
>+	if (bond_xdp_check(bond))
>+		bond_dev->xdp_features =3D NETDEV_XDP_ACT_MASK;
> }
> =

> /* Destroy a bonding device.
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index f71d5517f829..0498fc6731f8 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -877,6 +877,8 @@ static int bond_option_mode_set(struct bonding *bond,
> 			netdev_update_features(bond->dev);
> 	}
> =

>+	bond_xdp_set_features(bond->dev);
>+
> 	return 0;
> }
> =

>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index c3843239517d..a60a24923b55 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -659,6 +659,7 @@ void bond_destroy_sysfs(struct bond_net *net);
> void bond_prepare_sysfs_group(struct bonding *bond);
> int bond_sysfs_slave_add(struct slave *slave);
> void bond_sysfs_slave_del(struct slave *slave);
>+void bond_xdp_set_features(struct net_device *bond_dev);
> int bond_enslave(struct net_device *bond_dev, struct net_device *slave_d=
ev,
> 		 struct netlink_ext_ack *extack);
> int bond_release(struct net_device *bond_dev, struct net_device *slave_d=
ev);
>-- =

>2.40.0

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
