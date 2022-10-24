Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2181C60B5C6
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJXSjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiJXSjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:39:01 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CD519046F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:21:12 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BD0DA412DC
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1666628712;
        bh=Ixu77uPqydiuHG6fPGpxDklyUTJBN1ymlRpdiLOxoy4=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=TYq8Ft/rl5vJFO55sJuGYWEFsSDImWZXHZ8o99RfiSfIPmnc9b8T578nGAi4X0gZx
         KxfT2iNW9k8rPG1pZYkm2RJ2I8jKftnnE1YfJujNGXdPUYw+PxvWnd26VwdFdgNDvB
         ATI6+NjxdxTzR8/VFLDEk3q13+jfGtZLndXs8MRaVbJS5driOxWhlTYZ59rnYawcnj
         0tZdy1z31+/77kw6FHMA4iEGv45XgEtBsPjMKWnWenbn0sxMEDCtHDBjy1GPRX6Z3P
         2b3WXGLTUDB+YRZ/n+q5ss4ejfx+ieEtIG870u7GIXAtHgNvJLWF1WQRGdMnZWhY48
         iqE1nrkGx/uPQ==
Received: by mail-pj1-f70.google.com with SMTP id e3-20020a17090a7c4300b0021329152ecaso552199pjl.5
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:mime-version:comments
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ixu77uPqydiuHG6fPGpxDklyUTJBN1ymlRpdiLOxoy4=;
        b=3S9WX/wARGUslrmkUsSIKeu+pJxaVT0dmVqdGMB5DEK2HyeSPzUn9Trov2eGkhhP9d
         41UAbpU1OmYvgEpgD+o4pbltX7KMJdiPDVeEfLSJEXBqf83jEwYYL3SC5TcaOL5S3Nbi
         +LCMjZ5QM+1y769BdIZ7xj6kHTiR/4+LDMFP0DlW1fCAY85pOQ2Ql6vmSIImev2sE9jD
         v5+gQW8NQVxVmyZR9d0pgPGgK1/tFwEIiYxV9Qf6sZh4jwuhV9TKiCz59pjaby8mCjet
         rH9Jz10VZGLsAhKF1E0xTkdTsLkjMmMKnpc9sQVhzLSMmyJ4uT+whDy7MMc9NQlSxpMi
         NWZA==
X-Gm-Message-State: ACrzQf3f6If9jz6/cedyl+mV2g2M5c4hxn/v2S3Nc2zhMbo9rc3nKDnl
        D5DRy6CFthEk/h/XAjqean9UugRtKwJcLuvp+1OXmcCja9w0tWGac3IjA1qQcaPDoUoHM2dRJXf
        RbncqnWXRvfId4+8FTTpxYu6K8ulFlnRmmQ==
X-Received: by 2002:a17:902:8a88:b0:17f:8642:7c9a with SMTP id p8-20020a1709028a8800b0017f86427c9amr35266062plo.13.1666628711431;
        Mon, 24 Oct 2022 09:25:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6UhqBLQBcXTciVK82+Hw2AgWJIhdAmL0U73IMMIQQNfpE/hHan6un1+M0e7JUSpxgxZB0ZXA==
X-Received: by 2002:a17:902:8a88:b0:17f:8642:7c9a with SMTP id p8-20020a1709028a8800b0017f86427c9amr35266042plo.13.1666628711092;
        Mon, 24 Oct 2022 09:25:11 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm11771pfa.184.2022.10.24.09.25.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Oct 2022 09:25:10 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0494260DBF; Mon, 24 Oct 2022 09:25:09 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id F1B29A06A7;
        Mon, 24 Oct 2022 09:25:09 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Steven Hsieh <steven.hsieh@broadcom.com>
cc:     Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: 3ad: bonding of links with different data rate
In-reply-to: <20221022220158.74933-1-steven.hsieh@broadcom.com>
References: <20221022220158.74933-1-steven.hsieh@broadcom.com>
Comments: In-reply-to Steven Hsieh <steven.hsieh@broadcom.com>
   message dated "Sat, 22 Oct 2022 15:01:58 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 24 Oct 2022 09:25:09 -0700
Message-ID: <15633.1666628709@famine>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven Hsieh <steven.hsieh@broadcom.com> wrote:

>Current Linux Bonding driver supports IEEE802.3ad-2000.
>Operation across multiple data rates=E2=80=94
>All links in a Link Aggregation Group operate at the same data rate.
>
>In IEEE802.1AX-2014
>Aggregation of links of different data rates is not prohibited
>nor required by this standard.

	The -2014 and -2020 versions change a lot of things at once; I'm
not sure we can just cherry pick out one thing (or maybe we can, I'm
reading through the changes).  Notably, the -2020 version states, in
reference to changes added at -2014,

"[...] it explicitly allowed the aggregation of point-to-point links of
any speed using any physical media or logical connection capable of
supporting the Internal Sublayer Service specified in IEEE Std
802.1AC."

	whereas the -2008 standard specifies "CSMA/CD MACs" instead of
the ISS from 802.1AC.  I'm not yet sure if this makes any relevant
difference.

>This patch provides configuration option to allow aggregation of links
>with different speed.

	Have you tested all of the edge cases?  E.g., what is the
behavior with and without the option enabled when an interface in an
aggregator changes its speed?

	If you have tests, consider including test scripts in
tools/testing/selftests/drivers/net/bonding/

>Enhancement is disabled by default and can be enabled thru
> echo 1 > /sys/class/net/bond*/bonding/async_linkspeed

	New option settings like this require (a) support in iproute2
(to set/get the option like any other bonding option), and (b) updates
to the documentation (Documentation/networking/bonding.rst).

	I'm not completely sold on the name, either, "async" doesn't
really describe "differing data rates" in my mind.  Perhaps an option
named "ad_link_speed" with allowed values of "same" or "any"?

	-J

>Signed-off-by: Steven Hsieh <steven.hsieh@broadcom.com>
>
>---
>
> drivers/net/bonding/bond_3ad.c     | 12 +++++++++++-
> drivers/net/bonding/bond_options.c | 26 ++++++++++++++++++++++++++
> drivers/net/bonding/bond_sysfs.c   | 15 +++++++++++++++
> include/net/bond_options.h         |  1 +
> include/net/bonding.h              |  1 +
> 5 files changed, 54 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad=
.c
>index e58a1e0cadd2..f5689dae88c3 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -385,6 +385,13 @@ static void __ad_actor_update_port(struct port *port)
> 	port->actor_system_priority =3D BOND_AD_INFO(bond).system.sys_priority;
> }
>=20
>+static inline u32 __get_agg_async_linkspeed(struct port *port)
>+{
>+	const struct bonding *bond =3D bond_get_bond_by_slave(port->slave);
>+
>+	return (bond) ? bond->params.async_linkspeed : 0;
>+}
>+
> /* Conversions */
>=20
> /**
>@@ -2476,7 +2483,10 @@ static void ad_update_actor_keys(struct port *port,=
 bool reset)
> 		speed =3D __get_link_speed(port);
> 		ospeed =3D (old_oper_key & AD_SPEED_KEY_MASKS) >> 1;
> 		duplex =3D __get_duplex(port);
>-		port->actor_admin_port_key |=3D (speed << 1) | duplex;
>+		if (__get_agg_async_linkspeed(port))
>+			port->actor_admin_port_key |=3D duplex;
>+		else
>+			port->actor_admin_port_key |=3D (speed << 1) | duplex;
> 	}
> 	port->actor_oper_port_key =3D port->actor_admin_port_key;
>=20
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond=
_options.c
>index 3498db1c1b3c..cd871075b85c 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -84,6 +84,8 @@ static int bond_option_ad_user_port_key_set(struct bondi=
ng *bond,
> 					    const struct bond_opt_value *newval);
> static int bond_option_missed_max_set(struct bonding *bond,
> 				      const struct bond_opt_value *newval);
>+static int bond_option_async_linkspeed_set(struct bonding *bond,
>+					   const struct bond_opt_value *newval);
>=20
>=20
> static const struct bond_opt_value bond_mode_tbl[] =3D {
>@@ -226,6 +228,12 @@ static const struct bond_opt_value bond_missed_max_tb=
l[] =3D {
> 	{ NULL,		-1,	0},
> };
>=20
>+static const struct bond_opt_value bond_async_linkspeed_tbl[] =3D {
>+	{ "off", 0,  BOND_VALFLAG_DEFAULT},
>+	{ "on",  1,  0},
>+	{ NULL,  -1, 0},
>+};
>+
> static const struct bond_option bond_opts[BOND_OPT_LAST] =3D {
> 	[BOND_OPT_MODE] =3D {
> 		.id =3D BOND_OPT_MODE,
>@@ -360,6 +368,14 @@ static const struct bond_option bond_opts[BOND_OPT_LA=
ST] =3D {
> 		.values =3D bond_num_peer_notif_tbl,
> 		.set =3D bond_option_num_peer_notif_set
> 	},
>+	[BOND_OPT_ASYNC_LINKSPEED] =3D {
>+		.id =3D BOND_OPT_ASYNC_LINKSPEED,
>+		.name =3D "async_linkspeed",
>+		.desc =3D "Enable aggregation of links of different data rates",
>+		.unsuppmodes =3D BOND_MODE_ALL_EX(BIT(BOND_MODE_8023AD)),
>+		.values =3D bond_async_linkspeed_tbl,
>+		.set =3D bond_option_async_linkspeed_set
>+	},
> 	[BOND_OPT_MIIMON] =3D {
> 		.id =3D BOND_OPT_MIIMON,
> 		.name =3D "miimon",
>@@ -1702,3 +1718,13 @@ static int bond_option_ad_user_port_key_set(struct =
bonding *bond,
> 	bond->params.ad_user_port_key =3D newval->value;
> 	return 0;
> }
>+
>+static int bond_option_async_linkspeed_set(struct bonding *bond,
>+					   const struct bond_opt_value *newval)
>+{
>+	netdev_info(bond->dev, "Setting async_linkspeed to %s (%llu)\n",
>+		    newval->string, newval->value);
>+	bond->params.async_linkspeed =3D newval->value;
>+
>+	return 0;
>+}
>diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_s=
ysfs.c
>index 8996bd0a194a..6a0b4e1098af 100644
>--- a/drivers/net/bonding/bond_sysfs.c
>+++ b/drivers/net/bonding/bond_sysfs.c
>@@ -753,6 +753,20 @@ static ssize_t bonding_show_ad_user_port_key(struct d=
evice *d,
> static DEVICE_ATTR(ad_user_port_key, 0644,
> 		   bonding_show_ad_user_port_key, bonding_sysfs_store_option);
>=20
>+static ssize_t bonding_show_async_linkspeed(struct device *d,
>+					    struct device_attribute *attr,
>+					    char *buf)
>+{
>+	struct bonding *bond =3D to_bond(d);
>+	const struct bond_opt_value *val;
>+
>+	val =3D bond_opt_get_val(BOND_OPT_ASYNC_LINKSPEED, bond->params.async_li=
nkspeed);
>+
>+	return sprintf(buf, "%s %d\n", val->string, bond->params.async_linkspeed=
);
>+}
>+static DEVICE_ATTR(async_linkspeed, (00400 | 00040 | 00004) | 00200, /*S_=
IRUGO | S_IWUSR,*/
>+		   bonding_show_async_linkspeed, bonding_sysfs_store_option);
>+
> static struct attribute *per_bond_attrs[] =3D {
> 	&dev_attr_slaves.attr,
> 	&dev_attr_mode.attr,
>@@ -792,6 +806,7 @@ static struct attribute *per_bond_attrs[] =3D {
> 	&dev_attr_ad_actor_system.attr,
> 	&dev_attr_ad_user_port_key.attr,
> 	&dev_attr_arp_missed_max.attr,
>+	&dev_attr_async_linkspeed.attr,
> 	NULL,
> };
>=20
>diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>index 69292ecc0325..5b33f8b3e1c7 100644
>--- a/include/net/bond_options.h
>+++ b/include/net/bond_options.h
>@@ -76,6 +76,7 @@ enum {
> 	BOND_OPT_MISSED_MAX,
> 	BOND_OPT_NS_TARGETS,
> 	BOND_OPT_PRIO,
>+	BOND_OPT_ASYNC_LINKSPEED,
> 	BOND_OPT_LAST
> };
>=20
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index e999f851738b..5d83daab0669 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -146,6 +146,7 @@ struct bond_params {
> 	int lp_interval;
> 	int packets_per_slave;
> 	int tlb_dynamic_lb;
>+	int async_linkspeed;
> 	struct reciprocal_value reciprocal_packets_per_slave;
> 	u16 ad_actor_sys_prio;
> 	u16 ad_user_port_key;
>--=20
>2.34.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
