Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAAA440554
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJ2WNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:13:54 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:53456
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhJ2WNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:13:54 -0400
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A38B73F198
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635545481;
        bh=rJEl92OkXZ6vzaeh/08Zu3EiMrKJUk52e/INR2VXE/k=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=j6BeAyR4bvRbhK5ganbslaEDf7sPa1nAyg79lToJT9tVrLekrpEip0T5xCmlK6xVh
         pTaNEfK/YNCtF92t1ibxZ7lYboa/2GbuliVasv1RP8AVKvJqSLCWJFz35vvNEkZn0G
         XYHmv9aIk2NBRq6cDg2ExKFf3PQ+GxIIGNMMAHIVAT2OGaemO5engDK15sa/Munfyi
         KpcZzGQMZ3RvwdZLHFzVkaDvX5K9VOeJoBgz/r3oFjotWeWvfpeJoWP0EMq4SuPLsh
         Sj1U4918HbkvgRpjYcHuCeeVew6FWCzU81DMzo3NJ/CNv/Q1p0TSVl75BaxP5PKyVf
         f1sySXN05Nnfg==
Received: by mail-pj1-f70.google.com with SMTP id s10-20020a17090a13ca00b001a211aa215fso5986418pjf.0
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 15:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=rJEl92OkXZ6vzaeh/08Zu3EiMrKJUk52e/INR2VXE/k=;
        b=4uPq6dFNzRyHbrPGUSNp0VS9kmbqcVurQ1F66qtTmAO27MQA63Czv2XethKn2svbIZ
         wfByL+9XUvcu7OYIqjTEFcDC4B+4RavRIl7AIiziKuMWt5hsn/JV5rqPBo232DTmcfPf
         l3T/PIILm3BfL79R0rjbFjoAucsWSwhQxl8dK4Y4BcOMCBF24N3MqPX4tFk0G3r/fheq
         o0QsXQec5FXYrTtjE3YqLbRSgzacq4BBuNh3GVha5kaWwfShX0ZlKxytqJltJJmVAa12
         S4VFu3xz9LD7t7wTwEEWxOB/4Iwr339l7ifv5UFjCf4bX6UdlZ2h6r+mAUSFb2fCzHM0
         jAGQ==
X-Gm-Message-State: AOAM530P5omkYW3IJFxy2qA2F1SZrACczbR7zTOMqnpaMumD3MtDU++q
        kGXDSPI9oDAiPtuuB/x78nfUXKV0GLOAXOohnQrgqfDXJujm+exjhvY8BfOMTTseJD2cANQ/r7u
        0E0EkXTfqpNMMUwm49JJOPP7yX4/4P6CZkw==
X-Received: by 2002:a17:90a:b381:: with SMTP id e1mr22182154pjr.55.1635545480314;
        Fri, 29 Oct 2021 15:11:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAsY25h4CaQJ9GfGThpECBxAMgtafnfLbq200oicDHgnIOHYcQFl9Nf8RcfP5aiqNUlmdHFg==
X-Received: by 2002:a17:90a:b381:: with SMTP id e1mr22182121pjr.55.1635545479976;
        Fri, 29 Oct 2021 15:11:19 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id mu11sm14273844pjb.20.2021.10.29.15.11.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 15:11:19 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 07D865FDFB; Fri, 29 Oct 2021 15:11:18 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id F3B6DA0409;
        Fri, 29 Oct 2021 15:11:18 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [Draft PATCH net-next] Bonding: add missed_max option
In-reply-to: <20211029065529.27367-1-liuhangbin@gmail.com>
References: <20211029065529.27367-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 29 Oct 2021 14:55:29 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7319.1635545478.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 29 Oct 2021 15:11:18 -0700
Message-ID: <7320.1635545478@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Hi,
>
>Currently, we use hard code number to verify if we are in the
>arp_interval timeslice. But some user may want to narrow/extend
>the verify timeslice. With the similar team option 'missed_max'
>the uers could change that number based on their own environment.
>
>Would you like to help review and see if this is a proper place
>for `missed_max` and if I missed anything?
>
>Thanks
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> Documentation/networking/bonding.rst | 10 ++++++++++
> drivers/net/bonding/bond_main.c      | 17 +++++++++--------
> drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++++
> drivers/net/bonding/bond_options.c   | 21 +++++++++++++++++++++
> drivers/net/bonding/bond_procfs.c    |  2 ++
> drivers/net/bonding/bond_sysfs.c     | 13 +++++++++++++
> include/net/bond_options.h           |  1 +
> include/net/bonding.h                |  1 +
> include/uapi/linux/if_link.h         |  1 +
> tools/include/uapi/linux/if_link.h   |  1 +
> 10 files changed, 74 insertions(+), 8 deletions(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 31cfd7d674a6..41bb5869ff5f 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -421,6 +421,16 @@ arp_all_targets
> 		consider the slave up only when all of the arp_ip_targets
> 		are reachable
> =

>+missed_max
>+
>+        Maximum number of arp_interval for missed ARP replies.
>+        If this number is exceeded, link is reported as down.
>+
>+        Note a small value means a strict time. e.g. missed_max is 1 mea=
ns
>+        the correct arp reply must be recived during the interval.
>+
>+        default 3

	I'd suggest "arp" in the option name to make the scope more
obvious.

>+
> downdelay
> =

> 	Specifies the time, in milliseconds, to wait before disabling
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index ff8da720a33a..3baae78a7736 100644
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
>+		 * - more than missed_max*delta since last receive AND
> 		 * - the bond has an IP address
> 		 *
> 		 * Note: a non-null current_arp_slave indicates
>@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bo=
nd)
> 		 */
> 		if (!bond_is_active_slave(slave) &&
> 		    !rcu_access_pointer(bond->current_arp_slave) &&
>-		    !bond_time_in_interval(bond, last_rx, 3)) {
>+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max)) {
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

	The above two changes make the backup and active logic both
switch to using the missed_max value (i.e., both set to the same value),
when previously these two cases used differing values (2 for active, 3
for backup).

	Historically, these intervals were staggered deliberately; an
old comment removed by b2220cad583c9b states:

			if ((slave !=3D bond->curr_active_slave) &&
			    (!bond->current_arp_slave) &&
			    (time_after_eq(jiffies, slave_last_rx(bond, slave) + 3*delta_in_tic=
ks))) {
				/* a backup slave has gone down; three times
				 * the delta allows the current slave to be
				 * taken out before the backup slave.

	I think it would be prudent to insure that having the active and
backup timeouts set in lockstep does not result in an undesirable change
of behavior.

>@@ -5822,6 +5822,7 @@ static int bond_check_params(struct bond_params *pa=
rams)
> 	params->arp_interval =3D arp_interval;
> 	params->arp_validate =3D arp_validate_value;
> 	params->arp_all_targets =3D arp_all_targets_value;
>+	params->missed_max =3D 3;
> 	params->updelay =3D updelay;
> 	params->downdelay =3D downdelay;
> 	params->peer_notif_delay =3D 0;
>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index 5d54e11d18fa..30ccea63228e 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -110,6 +110,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_=
MAX + 1] =3D {
> 					    .len  =3D ETH_ALEN },
> 	[IFLA_BOND_TLB_DYNAMIC_LB]	=3D { .type =3D NLA_U8 },
> 	[IFLA_BOND_PEER_NOTIF_DELAY]    =3D { .type =3D NLA_U32 },
>+	[IFLA_BOND_MISSED_MAX]		=3D { .type =3D NLA_U32 },
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
>+		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_MISSED_MAX */
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
>index a8fde3bc458f..57772a9da543 100644
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
>@@ -270,6 +272,15 @@ static const struct bond_option bond_opts[BOND_OPT_L=
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
>+		.values =3D bond_intmax_tbl,

	This allows missed_max to be set to 0; is that intended to be a
valid setting?

	-J

>+		.set =3D bond_option_missed_max_set
>+	},
> 	[BOND_OPT_ARP_TARGETS] =3D {
> 		.id =3D BOND_OPT_ARP_TARGETS,
> 		.name =3D "arp_ip_target",
>@@ -1186,6 +1197,16 @@ static int bond_option_arp_all_targets_set(struct =
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
