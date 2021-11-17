Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8794542CF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 09:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhKQIn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 03:43:27 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37360
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232682AbhKQIn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 03:43:27 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8BD5E40826
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637138427;
        bh=9UgRjfcdtXsRqoXzBe40yNxQFYJcHoaAVcm2uwoIBfI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=d4YotfhBKzdjjUYsqmQGwa93qxlp1k2WK+IBqdA8dTVmUW1SuRI2kGorMasf3S3Mb
         wftk8irL7beLxd+SapR+04+HxXq1masL9Gtkfnlec9q/KjSXQ+M5E5lIdiQouDu3/l
         2OmSCvZbzCFPWSaTar1a6DgJr5BqsZ79wRbscZ+4O0qBEy4EFHyeCZcFSETZLOCeCU
         MPFJoEY2C1UswHBCmfKwsoAH9FvXzt94OUYVNu6hYIVbHbF1kr6a6XQz6DiUe70cih
         fYLLC+4P0yFNOVQoycYw8V1SADjxthIrTqpONZPWlvnzEZx1opBGQ38bb3mV+ghLQJ
         hLYd7E/X5Q77g==
Received: by mail-wm1-f69.google.com with SMTP id i131-20020a1c3b89000000b00337f92384e0so2501693wma.5
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 00:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=9UgRjfcdtXsRqoXzBe40yNxQFYJcHoaAVcm2uwoIBfI=;
        b=c5ShAj9k7XsLl1+cHrc1SJzEGXk3VPmdDxtcNnjDk45CcE1Qcek7JItyPV87Dk2C77
         IG3aWhZWgh5eUdWIqnvN6apyotSqu7FnCNFJWRAOTZtb34e019qyHi8hb7KHzUNudz9N
         /ntpfXX6rG7ZtnVsgcJe6bavCcnMQZz+bquDfOPPrL9OxlQAkkOJHR+DOM7OCnnyaiTv
         t3BuCZmF2rluTYN80PJpd9m6vr/YpdRraVQfy8wtMqZn3xMpjp/Plunppt89rHkCHKYV
         f49nv9fQw3Xz154bj75riCK+mqT9iSJ6Y/VODxxN6q/0HAw100YNe4jUvfMf8oWBt1/x
         +LdA==
X-Gm-Message-State: AOAM531dY6pRHnXQ/hskcawfT9+jAmjXpEQwkn8EAMks5hryRkvZfTI/
        bW9BgcJwD2C9ObnK4003Yay60TwEGRxRESH49G6E+ooImibJ2sj9JWYnaFr53No+mHsE9JIBri+
        Sypm+HZZMowqGpDA6X2xmbYlemMQIbFpbKw==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr16288798wme.186.1637138427149;
        Wed, 17 Nov 2021 00:40:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWXqbX9EdIZa/WYCa3qIJFMXVTFI1G5yYmujTlBzE1XCK0gI0swvs3GL6qEgyJdatPKO3pkA==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr16288774wme.186.1637138426928;
        Wed, 17 Nov 2021 00:40:26 -0800 (PST)
Received: from nyx.localdomain (faun.canonical.com. [91.189.93.182])
        by smtp.gmail.com with ESMTPSA id x21sm4532916wmc.14.2021.11.17.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 00:40:26 -0800 (PST)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id E031D24050F; Wed, 17 Nov 2021 08:40:25 +0000 (GMT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id D95BD2809DB;
        Wed, 17 Nov 2021 08:40:25 +0000 (GMT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add missed_max option
In-reply-to: <20211117080337.1038647-1-liuhangbin@gmail.com>
References: <20211117080337.1038647-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 17 Nov 2021 16:03:36 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70665.1637138425.1@nyx>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 17 Nov 2021 08:40:25 +0000
Message-ID: <70666.1637138425@nyx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Currently, we use hard code number to verify if we are in the
>arp_interval timeslice. But some user may want to reduce/extend
>the verify timeslice. With the similar team option 'missed_max'
>the uers could change that number based on their own environment.
>
>The name of arp_misssed_max is not used as we may use this option for
>Bonding IPv6 NS/NA monitor in future.

	Why reserve "arp_missed_max" for IPv6 which doesn't use ARP?  If
the option is for the ARP monitor, then prefixing it with "arp_" would
be consistent with the other arp_* options.

	-J

>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>
>---
>v2: set IFLA_BOND_MISSED_MAX to NLA_U8, and limit the values to 1-255
>---
> Documentation/networking/bonding.rst | 10 ++++++++++
> drivers/net/bonding/bond_main.c      | 17 +++++++++--------
> drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++++
> drivers/net/bonding/bond_options.c   | 28 ++++++++++++++++++++++++++++
> drivers/net/bonding/bond_procfs.c    |  2 ++
> drivers/net/bonding/bond_sysfs.c     | 13 +++++++++++++
> include/net/bond_options.h           |  1 +
> include/net/bonding.h                |  1 +
> include/uapi/linux/if_link.h         |  1 +
> tools/include/uapi/linux/if_link.h   |  1 +
> 10 files changed, 81 insertions(+), 8 deletions(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 31cfd7d674a6..4a28b350bb02 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -421,6 +421,16 @@ arp_all_targets
> 		consider the slave up only when all of the arp_ip_targets
> 		are reachable
> =

>+missed_max
>+
>+        Maximum number of arp_interval monitor cycle for missed ARP repl=
ies.
>+        If this number is exceeded, link is reported as down.
>+
>+        Normally 2 monitor cycles are needed. One cycle for missed ARP r=
equest
>+        and one cycle for waiting ARP reply.
>+
>+        default 2
>+
> downdelay
> =

> 	Specifies the time, in milliseconds, to wait before disabling
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index ff8da720a33a..9a28d3de798e 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3129,8 +3129,8 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
> 			 * when the source ip is 0, so don't take the link down
> 			 * if we don't know our ip yet
> 			 */
>-			if (!bond_time_in_interval(bond, trans_start, 2) ||
>-			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
>+			if (!bond_time_in_interval(bond, trans_start, bond->params.missed_max=
) ||
>+			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_=
max)) {
> =

> 				bond_propose_link_state(slave, BOND_LINK_DOWN);
> 				slave_state_changed =3D 1;
>@@ -3224,7 +3224,7 @@ static int bond_ab_arp_inspect(struct bonding *bond=
)
> =

> 		/* Backup slave is down if:
> 		 * - No current_arp_slave AND
>-		 * - more than 3*delta since last receive AND
>+		 * - more than (missed_max+1)*delta since last receive AND
> 		 * - the bond has an IP address
> 		 *
> 		 * Note: a non-null current_arp_slave indicates
>@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bo=
nd)
> 		 */
> 		if (!bond_is_active_slave(slave) &&
> 		    !rcu_access_pointer(bond->current_arp_slave) &&
>-		    !bond_time_in_interval(bond, last_rx, 3)) {
>+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max+1)) =
{
> 			bond_propose_link_state(slave, BOND_LINK_DOWN);
> 			commit++;
> 		}
> =

> 		/* Active slave is down if:
>-		 * - more than 2*delta since transmitting OR
>-		 * - (more than 2*delta since receive AND
>+		 * - more than missed_max*delta since transmitting OR
>+		 * - (more than missed_max*delta since receive AND
> 		 *    the bond has an IP address)
> 		 */
> 		trans_start =3D dev_trans_start(slave->dev);
> 		if (bond_is_active_slave(slave) &&
>-		    (!bond_time_in_interval(bond, trans_start, 2) ||
>-		     !bond_time_in_interval(bond, last_rx, 2))) {
>+		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max=
) ||
>+		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) =
{
> 			bond_propose_link_state(slave, BOND_LINK_DOWN);
> 			commit++;
> 		}
>@@ -5822,6 +5822,7 @@ static int bond_check_params(struct bond_params *pa=
rams)
> 	params->arp_interval =3D arp_interval;
> 	params->arp_validate =3D arp_validate_value;
> 	params->arp_all_targets =3D arp_all_targets_value;
>+	params->missed_max =3D 2;
> 	params->updelay =3D updelay;
> 	params->downdelay =3D downdelay;
> 	params->peer_notif_delay =3D 0;
>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index 5d54e11d18fa..1007bf6d385d 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -110,6 +110,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_=
MAX + 1] =3D {
> 					    .len  =3D ETH_ALEN },
> 	[IFLA_BOND_TLB_DYNAMIC_LB]	=3D { .type =3D NLA_U8 },
> 	[IFLA_BOND_PEER_NOTIF_DELAY]    =3D { .type =3D NLA_U32 },
>+	[IFLA_BOND_MISSED_MAX]		=3D { .type =3D NLA_U8 },
> };
> =

> static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1=
] =3D {
>@@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_d=
ev, struct nlattr *tb[],
> 			return err;
> 	}
> =

>+	if (data[IFLA_BOND_MISSED_MAX]) {
>+		int missed_max =3D nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
>+
>+		bond_opt_initval(&newval, missed_max);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
>+		if (err)
>+			return err;
>+	}
>+
> 	return 0;
> }
> =

>@@ -515,6 +525,7 @@ static size_t bond_get_size(const struct net_device *=
bond_dev)
> 		nla_total_size(ETH_ALEN) + /* IFLA_BOND_AD_ACTOR_SYSTEM */
> 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
> 		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
>+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MISSED_MAX */
> 		0;
> }
> =

>@@ -650,6 +661,10 @@ static int bond_fill_info(struct sk_buff *skb,
> 		       bond->params.tlb_dynamic_lb))
> 		goto nla_put_failure;
> =

>+	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
>+		       bond->params.missed_max))
>+		goto nla_put_failure;
>+
> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
> 		struct ad_info info;
> =

>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index a8fde3bc458f..10ea93097737 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -78,6 +78,8 @@ static int bond_option_ad_actor_system_set(struct bondi=
ng *bond,
> 					   const struct bond_opt_value *newval);
> static int bond_option_ad_user_port_key_set(struct bonding *bond,
> 					    const struct bond_opt_value *newval);
>+static int bond_option_missed_max_set(struct bonding *bond,
>+				      const struct bond_opt_value *newval);
> =

> =

> static const struct bond_opt_value bond_mode_tbl[] =3D {
>@@ -213,6 +215,13 @@ static const struct bond_opt_value bond_ad_user_port=
_key_tbl[] =3D {
> 	{ NULL,      -1,    0},
> };
> =

>+static const struct bond_opt_value bond_missed_max_tbl[] =3D {
>+	{ "minval",	1,	BOND_VALFLAG_MIN},
>+	{ "maxval",	255,	BOND_VALFLAG_MAX},
>+	{ "default",	2,	BOND_VALFLAG_DEFAULT},
>+	{ NULL,		-1,	0},
>+};
>+
> static const struct bond_option bond_opts[BOND_OPT_LAST] =3D {
> 	[BOND_OPT_MODE] =3D {
> 		.id =3D BOND_OPT_MODE,
>@@ -270,6 +279,15 @@ static const struct bond_option bond_opts[BOND_OPT_L=
AST] =3D {
> 		.values =3D bond_intmax_tbl,
> 		.set =3D bond_option_arp_interval_set
> 	},
>+	[BOND_OPT_MISSED_MAX] =3D {
>+		.id =3D BOND_OPT_MISSED_MAX,
>+		.name =3D "missed_max",
>+		.desc =3D "Maximum number of missed ARP interval",
>+		.unsuppmodes =3D BIT(BOND_MODE_8023AD) | BIT(BOND_MODE_TLB) |
>+			       BIT(BOND_MODE_ALB),
>+		.values =3D bond_missed_max_tbl,
>+		.set =3D bond_option_missed_max_set
>+	},
> 	[BOND_OPT_ARP_TARGETS] =3D {
> 		.id =3D BOND_OPT_ARP_TARGETS,
> 		.name =3D "arp_ip_target",
>@@ -1186,6 +1204,16 @@ static int bond_option_arp_all_targets_set(struct =
bonding *bond,
> 	return 0;
> }
> =

>+static int bond_option_missed_max_set(struct bonding *bond,
>+				      const struct bond_opt_value *newval)
>+{
>+	netdev_dbg(bond->dev, "Setting missed max to %s (%llu)\n",
>+		   newval->string, newval->value);
>+	bond->params.missed_max =3D newval->value;
>+
>+	return 0;
>+}
>+
> static int bond_option_primary_set(struct bonding *bond,
> 				   const struct bond_opt_value *newval)
> {
>diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond=
_procfs.c
>index f3e3bfd72556..2ec11af5f0cc 100644
>--- a/drivers/net/bonding/bond_procfs.c
>+++ b/drivers/net/bonding/bond_procfs.c
>@@ -115,6 +115,8 @@ static void bond_info_show_master(struct seq_file *se=
q)
> =

> 		seq_printf(seq, "ARP Polling Interval (ms): %d\n",
> 				bond->params.arp_interval);
>+		seq_printf(seq, "ARP Missed Max: %u\n",
>+				bond->params.missed_max);
> =

> 		seq_printf(seq, "ARP IP target/s (n.n.n.n form):");
> =

>diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_=
sysfs.c
>index c48b77167fab..04da21f17503 100644
>--- a/drivers/net/bonding/bond_sysfs.c
>+++ b/drivers/net/bonding/bond_sysfs.c
>@@ -303,6 +303,18 @@ static ssize_t bonding_show_arp_targets(struct devic=
e *d,
> static DEVICE_ATTR(arp_ip_target, 0644,
> 		   bonding_show_arp_targets, bonding_sysfs_store_option);
> =

>+/* Show the arp missed max. */
>+static ssize_t bonding_show_missed_max(struct device *d,
>+				       struct device_attribute *attr,
>+				       char *buf)
>+{
>+	struct bonding *bond =3D to_bond(d);
>+
>+	return sprintf(buf, "%u\n", bond->params.missed_max);
>+}
>+static DEVICE_ATTR(missed_max, 0644,
>+		   bonding_show_missed_max, bonding_sysfs_store_option);
>+
> /* Show the up and down delays. */
> static ssize_t bonding_show_downdelay(struct device *d,
> 				      struct device_attribute *attr,
>@@ -779,6 +791,7 @@ static struct attribute *per_bond_attrs[] =3D {
> 	&dev_attr_ad_actor_sys_prio.attr,
> 	&dev_attr_ad_actor_system.attr,
> 	&dev_attr_ad_user_port_key.attr,
>+	&dev_attr_missed_max.attr,
> 	NULL,
> };
> =

>diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>index e64833a674eb..dd75c071f67e 100644
>--- a/include/net/bond_options.h
>+++ b/include/net/bond_options.h
>@@ -65,6 +65,7 @@ enum {
> 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
> 	BOND_OPT_PEER_NOTIF_DELAY,
> 	BOND_OPT_LACP_ACTIVE,
>+	BOND_OPT_MISSED_MAX,
> 	BOND_OPT_LAST
> };
> =

>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index 15e083e18f75..7b0bcddf9f26 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -124,6 +124,7 @@ struct bond_params {
> 	int arp_interval;
> 	int arp_validate;
> 	int arp_all_targets;
>+	unsigned int missed_max;
> 	int use_carrier;
> 	int fail_over_mac;
> 	int updelay;
>diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>index eebd3894fe89..4ac53b30b6dc 100644
>--- a/include/uapi/linux/if_link.h
>+++ b/include/uapi/linux/if_link.h
>@@ -858,6 +858,7 @@ enum {
> 	IFLA_BOND_TLB_DYNAMIC_LB,
> 	IFLA_BOND_PEER_NOTIF_DELAY,
> 	IFLA_BOND_AD_LACP_ACTIVE,
>+	IFLA_BOND_MISSED_MAX,
> 	__IFLA_BOND_MAX,
> };
> =

>diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linu=
x/if_link.h
>index b3610fdd1fee..4772a115231a 100644
>--- a/tools/include/uapi/linux/if_link.h
>+++ b/tools/include/uapi/linux/if_link.h
>@@ -655,6 +655,7 @@ enum {
> 	IFLA_BOND_TLB_DYNAMIC_LB,
> 	IFLA_BOND_PEER_NOTIF_DELAY,
> 	IFLA_BOND_AD_LACP_ACTIVE,
>+	IFLA_BOND_MISSED_MAX,
> 	__IFLA_BOND_MAX,
> };
> =

>-- =

>2.31.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
