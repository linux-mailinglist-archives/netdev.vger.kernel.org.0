Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727A04E6B96
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 01:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352445AbiCYAvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 20:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiCYAvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 20:51:45 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CCC7090A
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:50:11 -0700 (PDT)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2988C3F19C
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648169404;
        bh=vW2uiFi4Owf4Y0WZunIGfR72ibo0Z88XaHvRsbPLOPs=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=p3ZRR34wFdvno75CEzKgQ/SL60Jv1Gtao/V8lgKbcz5cSxeCVS0jlEw4+Vjdsb30c
         s+7dMYsQu2cgjRDnX/hzYP5BdOWvYK3yrFiwiIVvHCECdMBr4I/iMYZ7SgL11NvYUf
         K6Or1LHyaFZWsBIfkxUeLHqxowVJlP0ATVJauOrDxPwrc6jrIA8LgzTxqY/jBCf3H0
         c63Z0OC9AeV7LvtfbD6ljgJEPLH0DEuHKAfK5r7e5zCr6te5N6SSVKcrokDPOAKfAg
         IcZo9+g8dCTC9MwBuwercRq4a2sYqI5TlmIEds01grjcbETbx5kfYGH8bXDSeeG+ou
         GwxbxFshEujGA==
Received: by mail-pg1-f200.google.com with SMTP id r11-20020a63440b000000b0038068f34b0cso3074258pga.0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=vW2uiFi4Owf4Y0WZunIGfR72ibo0Z88XaHvRsbPLOPs=;
        b=Z8zDjgX2A8ez0dVVbO43ppF26PO8cwaNWTC/kPbXdbUGSQoLtWs7bKCzjBHRJxbct/
         uVTtVuaKczE6nY1WA7qtxCUNMsvzAlE3bhLC+0NDcIQsL9+zzcDhGidUYtmUdZEzqgXn
         5t1YM52ukiV8tvFXf1VAYQflHE4l38iq7ztcdNIaSJmQ++Php/JZKdnJcNNSpyk9rYIb
         h+gmlaksg9cjZx7lSHdtD1kj91rik5S87/Wflb3rdoV53kQFOIG/ZBteZIIRKpD2gm2a
         z5WBPbptkCIsJUPmRMLliCGgYVRj+EU8WHv7nH0i1WaoJflDZ+keVeLn4oXQSmerayiX
         0Mzg==
X-Gm-Message-State: AOAM533SyCneFac8M2pQHTKDmn4xK3G4PHhBhTyA4Pww+SANvLqQpqY2
        bLqXYaUGIh+70RYa5wU7HsLL6gxV8QY2P1tceAoGm85x/CJc1o9sDBGCyHVuJ3Ef6E94RSA3Ek/
        g7NWDzZ2261l6mrW/wopbIg0I3+YjJbD4ng==
X-Received: by 2002:a63:5b63:0:b0:378:5645:90f6 with SMTP id l35-20020a635b63000000b00378564590f6mr5900881pgm.505.1648169402459;
        Thu, 24 Mar 2022 17:50:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRwdWWmUSzACldZ1e2BspTq/MatGVgjxrUDK0i3uo+IzxWxg7k/EjXdugLGuPu93mnvtwtrg==
X-Received: by 2002:a63:5b63:0:b0:378:5645:90f6 with SMTP id l35-20020a635b63000000b00378564590f6mr5900850pgm.505.1648169402069;
        Thu, 24 Mar 2022 17:50:02 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm3562172pgj.85.2022.03.24.17.50.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 17:50:01 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 38B706093D; Thu, 24 Mar 2022 17:50:01 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 32FEAA0B18;
        Thu, 24 Mar 2022 17:50:01 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, Long Xin <lxin@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bond: add mac filter option for balance-xor
In-reply-to: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
References: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Thu, 24 Mar 2022 11:54:41 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12685.1648169401.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 24 Mar 2022 17:50:01 -0700
Message-ID: <12686.1648169401@famine>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Considering this as an RFC given that net-next is closed...
	=

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Attempt to replicate the OvS SLB Bonding[1] feature by preventing
>duplicate frame delivery on a bond whos members are connected to
>physically different switches.
>
>Combining this feature with vlan+srcmac hash policy allows a user to
>create an access network without the need to use expensive switches that
>support features like Cisco's VCP.

	Could you describe this use case / implementation in a bit more
detail?  I.e., how exactly that configuration works.  I don't think this
patch is replicating everything in the OVS SLB documentation.

>[1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>
>Co-developed-by: Long Xin <lxin@redhat.com>
>Signed-off-by: Long Xin <lxin@redhat.com>
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>---
> Documentation/networking/bonding.rst  |  19 +++
> drivers/net/bonding/Makefile          |   2 +-
> drivers/net/bonding/bond_mac_filter.c | 222 ++++++++++++++++++++++++++
> drivers/net/bonding/bond_mac_filter.h |  40 +++++
> drivers/net/bonding/bond_main.c       |  26 +++
> drivers/net/bonding/bond_netlink.c    |  13 ++
> drivers/net/bonding/bond_options.c    |  58 ++++++-
> drivers/net/bonding/bonding_priv.h    |   1 +
> include/net/bond_options.h            |   1 +
> include/net/bonding.h                 |   3 +
> include/uapi/linux/if_link.h          |   1 +
> 11 files changed, 384 insertions(+), 2 deletions(-)
> create mode 100644 drivers/net/bonding/bond_mac_filter.c
> create mode 100644 drivers/net/bonding/bond_mac_filter.h
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 525e6842dd33..a5a1669d3efe 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -550,6 +550,25 @@ lacp_rate
> =

> 	The default is slow.
> =

>+mac_filter
>+
>+	Tells the bonding device to drop frames received who's source MAC
>+	address	matches entries in a filter table. The filter table is
>+	populated when the bond transmits frames. This is similar in
>+	concept to the MAC learning table implemented in the bridge code.
>+
>+	This filtering is only enabled for the balance-xor bonding mode.
>+
>+	off or 0
>+		Turns the feature off
>+
>+	number
>+		A number greater than zero turns the feature on and sets
>+		the maximum number of MAC addresses to store in the hash
>+		table.
>+
>+	The default is off.
>+
> max_bonds
> =

> 	Specifies the number of bonding devices to create for this
>diff --git a/drivers/net/bonding/Makefile b/drivers/net/bonding/Makefile
>index 30e8ae3da2da..5dbc360a8522 100644
>--- a/drivers/net/bonding/Makefile
>+++ b/drivers/net/bonding/Makefile
>@@ -5,7 +5,7 @@
> =

> obj-$(CONFIG_BONDING) +=3D bonding.o
> =

>-bonding-objs :=3D bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sy=
sfs_slave.o bond_debugfs.o bond_netlink.o bond_options.o
>+bonding-objs :=3D bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sy=
sfs_slave.o bond_debugfs.o bond_netlink.o bond_options.o bond_mac_filter.o
> =

> proc-$(CONFIG_PROC_FS) +=3D bond_procfs.o
> bonding-objs +=3D $(proc-y)
>diff --git a/drivers/net/bonding/bond_mac_filter.c b/drivers/net/bonding/=
bond_mac_filter.c
>new file mode 100644
>index 000000000000..a16a1a000f05
>--- /dev/null
>+++ b/drivers/net/bonding/bond_mac_filter.c
>@@ -0,0 +1,222 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/*
>+ * Filter received frames based on MAC addresses "behind" the bond.
>+ */
>+
>+#include "bonding_priv.h"
>+
>+/* -------------- Cache Management -------------- */

	I don't think this header adds anything, given that there's not
really a lot in the section.

>+static struct kmem_cache *bond_mac_cache __read_mostly;
>+
>+int __init bond_mac_cache_init(void)
>+{
>+	bond_mac_cache =3D kmem_cache_create("bond_mac_cache",
>+					   sizeof(struct bond_mac_cache_entry),
>+					   0, SLAB_HWCACHE_ALIGN, NULL);
>+	if (!bond_mac_cache)
>+		return -ENOMEM;
>+	return 0;
>+}
>+
>+void bond_mac_cache_destroy(void)
>+{
>+	kmem_cache_destroy(bond_mac_cache);
>+}

	There are a lot of the above sort of wrapper functions that are
only ever called once.  Some of these, e.g., mac_delete, below, I agree
with, as the call site is nested fairly deep and the function is
non-trivial; or, mac_delete_rcu, which is used as a callback.

	The above two, though, I don't see a justification for, along
with hold_time and maybe a couple others, below.  In my opinion,
over-abstracting these trivial things with one call site makes the code
harder to follow.

>+
>+/* -------------- Hash Table Management -------------- */
>+
>+static const struct rhashtable_params bond_rht_params =3D {
>+	.head_offset         =3D offsetof(struct bond_mac_cache_entry, rhnode),
>+	.key_offset          =3D offsetof(struct bond_mac_cache_entry, key),
>+	.key_len             =3D sizeof(struct mac_addr),
>+	.automatic_shrinking =3D true,
>+};
>+
>+static inline unsigned long hold_time(const struct bonding *bond)
>+{
>+	return msecs_to_jiffies(5000);
>+}

	This shouldn't be a magic number, and if it's an important
timeout, should it be configurable?

>+
>+static bool has_expired(const struct bonding *bond,
>+			struct bond_mac_cache_entry *mac)
>+{
>+	return time_before_eq(mac->used + hold_time(bond), jiffies);
>+}
>+
>+static void mac_delete_rcu(struct callback_head *head)
>+{
>+	kmem_cache_free(bond_mac_cache,
>+			container_of(head, struct bond_mac_cache_entry, rcu));
>+}
>+
>+static int mac_delete(struct bonding *bond,
>+		      struct bond_mac_cache_entry *entry)
>+{
>+	int ret;
>+
>+	ret =3D rhashtable_remove_fast(bond->mac_filter_tbl,
>+				     &entry->rhnode,
>+				     bond->mac_filter_tbl->p);
>+	set_bit(BOND_MAC_DEAD, &entry->flags);
>+	call_rcu(&entry->rcu, mac_delete_rcu);
>+	return ret;
>+}
>+
>+void bond_mac_hash_release_entries(struct work_struct *work)
>+{
>+	struct bonding *bond =3D container_of(work, struct bonding,
>+				mac_work.work);
>+	struct rhashtable_iter iter;
>+	struct bond_mac_cache_entry *entry;
>+	unsigned long flags;
>+
>+	rhashtable_walk_enter(bond->mac_filter_tbl, &iter);
>+	rhashtable_walk_start(&iter);
>+	while ((entry =3D rhashtable_walk_next(&iter)) !=3D NULL) {
>+		if (IS_ERR(entry))
>+			continue;
>+
>+		spin_lock_irqsave(&entry->lock, flags);
>+		if (has_expired(bond, entry))
>+			mac_delete(bond, entry);
>+		spin_unlock_irqrestore(&entry->lock, flags);
>+	}
>+	rhashtable_walk_stop(&iter);
>+	rhashtable_walk_exit(&iter);
>+	queue_delayed_work(bond->wq, &bond->mac_work,
>+			   msecs_to_jiffies(5 * 60 * 1000));
>+}
>+
>+int bond_mac_hash_init(struct bonding *bond)
>+{
>+	int rc;

	As a point of style, (almost) everywhere else in bonding uses
"ret" for a return value.  The exceptions are largely my doing, but,
still, it'd be nice to be mostly consistent in nomenclature.

>+
>+	netdev_dbg(bond->dev, "mac_filter: alloc memory for hash table\n");
>+	bond->mac_filter_tbl =3D kzalloc(sizeof(*bond->mac_filter_tbl),
>+				       GFP_KERNEL);
>+	if (!bond->mac_filter_tbl)
>+		return -ENOMEM;
>+
>+	rc =3D rhashtable_init(bond->mac_filter_tbl, &bond_rht_params);
>+	if (rc)
>+		kfree(bond->mac_filter_tbl);
>+
>+	return rc;
>+}
>+
>+static void bond_mac_free_entry(void *entry, void *ctx)
>+{
>+	kmem_cache_free((struct kmem_cache *)ctx, entry);
>+}
>+
>+void bond_mac_hash_destroy(struct bonding *bond)
>+{
>+	if (bond->mac_filter_tbl) {
>+		rhashtable_free_and_destroy(bond->mac_filter_tbl,
>+					    bond_mac_free_entry,
>+					    bond_mac_cache);
>+		kfree(bond->mac_filter_tbl);
>+		bond->mac_filter_tbl =3D NULL;
>+	}
>+}
>+
>+static int mac_create(struct bonding *bond, const u8 *addr)
>+{
>+	struct bond_mac_cache_entry *entry;
>+	int ret;
>+
>+	entry =3D kmem_cache_alloc(bond_mac_cache, GFP_ATOMIC);
>+	if (!entry)
>+		return -ENOMEM;
>+	spin_lock_init(&entry->lock);
>+	memcpy(&entry->key, addr, sizeof(entry->key));
>+	entry->used =3D jiffies;
>+	ret =3D rhashtable_lookup_insert_fast(bond->mac_filter_tbl,
>+					    &entry->rhnode,
>+					    bond->mac_filter_tbl->p);
>+	if (ret) {
>+		kmem_cache_free(bond_mac_cache, entry);
>+		entry =3D NULL;
>+		if (ret =3D=3D -EEXIST)
>+			return 0;
>+		pr_err_once("Failed to insert mac entry %d\n", ret);
>+	}
>+	return ret;
>+}
>+
>+static struct bond_mac_cache_entry *mac_find(struct bonding *bond,
>+					     const u8 *addr)
>+{
>+	struct mac_addr key;
>+
>+	memcpy(&key, addr, sizeof(key));
>+	return rhashtable_lookup(bond->mac_filter_tbl, &key,
>+				 bond->mac_filter_tbl->p);
>+}
>+
>+inline void mac_update(struct bond_mac_cache_entry *entry)
>+{
>+	entry->used =3D jiffies;
>+}
>+
>+int bond_mac_insert(struct bonding *bond, const u8 *addr)
>+{
>+	struct bond_mac_cache_entry *entry;
>+	int rc =3D 0;
>+
>+	if (!is_valid_ether_addr(addr))
>+		return -EINVAL;
>+
>+	rcu_read_lock();
>+	entry =3D mac_find(bond, addr);
>+	if (entry) {
>+		unsigned long flags;
>+
>+		spin_lock_irqsave(&entry->lock, flags);
>+		if (!test_bit(BOND_MAC_DEAD, &entry->flags)) {
>+			mac_update(entry);
>+			spin_unlock_irqrestore(&entry->lock, flags);
>+			goto out;
>+		}
>+		spin_unlock_irqrestore(&entry->lock, flags);

	This seems really expensive, as it will add a spin_lock_irqsave
round trip for almost every packet transmitted when mac_filter is
enabled (as this will be called by bond_xmit_3ad_xor_slave_get).

>+	}
>+
>+	rc =3D mac_create(bond, addr);
>+
>+out:
>+	rcu_read_unlock();
>+	return rc;
>+}
>+
>+int bond_xor_recv(const struct sk_buff *skb, struct bonding *bond,
>+		  struct slave *slave)
>+{
>+	const struct ethhdr *mac_hdr;
>+	struct bond_mac_cache_entry *entry;
>+	int rc =3D RX_HANDLER_PASS;
>+
>+	mac_hdr =3D (struct ethhdr *)skb_mac_header(skb);
>+	rcu_read_lock();
>+	if (is_multicast_ether_addr(mac_hdr->h_dest) &&
>+	    slave !=3D rcu_dereference(bond->curr_active_slave)) {
>+		rc =3D RX_HANDLER_CONSUMED;
>+		goto out;
>+	}
>+
>+	entry =3D mac_find(bond, mac_hdr->h_source);
>+	if (entry) {
>+		unsigned long flags;
>+		bool expired;
>+
>+		spin_lock_irqsave(&entry->lock, flags);
>+		expired =3D has_expired(bond, entry);
>+		spin_unlock_irqrestore(&entry->lock, flags);
>+		if (!expired)
>+			rc =3D RX_HANDLER_CONSUMED;
>+	}

	As above, really expensive, except for incoming packets here
(since this is called as the recv_probe).

>+
>+out:
>+	rcu_read_unlock();
>+	return rc;
>+}
>diff --git a/drivers/net/bonding/bond_mac_filter.h b/drivers/net/bonding/=
bond_mac_filter.h
>new file mode 100644
>index 000000000000..0cfcc5653e7e
>--- /dev/null
>+++ b/drivers/net/bonding/bond_mac_filter.h
>@@ -0,0 +1,40 @@
>+/* SPDX-License-Identifier: GPL-2.0-only
>+ *
>+ * Filter received frames based on MAC addresses "behind" the bond.
>+ */
>+
>+#ifndef _BOND_MAC_FILTER_H
>+#define _BOND_MAC_FILTER_H
>+#include <net/bonding.h>
>+#include <linux/spinlock.h>
>+#include <linux/rhashtable.h>
>+
>+enum {
>+	BOND_MAC_DEAD,
>+	BOND_MAC_LOCKED,
>+	BOND_MAC_STATIC,
>+};
>+
>+struct bond_mac_cache_entry {
>+	struct rhash_head	rhnode;
>+	struct mac_addr		key;
>+
>+	spinlock_t		lock; /* protects used member */
>+	unsigned long		flags;
>+	unsigned long		used;
>+	struct rcu_head		rcu;
>+};
>+
>+int __init bond_mac_cache_init(void);
>+void bond_mac_cache_destroy(void);
>+
>+void bond_mac_hash_release_entries(struct work_struct *work);
>+int bond_mac_hash_init(struct bonding *bond);
>+void bond_mac_hash_destroy(struct bonding *bond);
>+
>+int bond_mac_insert(struct bonding *bond, const u8 *addr);
>+int bond_xor_recv(const struct sk_buff *skb,
>+		  struct bonding *bond,
>+		  struct slave *slave);
>+
>+#endif
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 15eddca7b4b6..f5a8a50e9116 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1549,6 +1549,10 @@ static rx_handler_result_t bond_handle_frame(struc=
t sk_buff **pskb)
> 		return RX_HANDLER_EXACT;
> 	}
> =

>+	/* this function should not rely on the recv_probe to set ret
>+	 * correctly
>+	 */
>+	ret =3D RX_HANDLER_ANOTHER;

	This change is overriding the return from a recv_probe added by
this patch (bond_xor_recv can return RX_HANDLER_PASS).  Why?

	Also, I don't agree with the comment; the recv_probe return
value by design affects the return value from bond_handle_frame.

> 	skb->dev =3D bond->dev;
> =

> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_ALB &&
>@@ -4117,6 +4121,7 @@ void bond_work_init_all(struct bonding *bond)
> 	INIT_DELAYED_WORK(&bond->arp_work, bond_arp_monitor);
> 	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
> 	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
>+	INIT_DELAYED_WORK(&bond->mac_work, bond_mac_hash_release_entries);
> }
> =

> static void bond_work_cancel_all(struct bonding *bond)
>@@ -4127,6 +4132,7 @@ static void bond_work_cancel_all(struct bonding *bo=
nd)
> 	cancel_delayed_work_sync(&bond->ad_work);
> 	cancel_delayed_work_sync(&bond->mcast_work);
> 	cancel_delayed_work_sync(&bond->slave_arr_work);
>+	cancel_delayed_work_sync(&bond->mac_work);
> }
> =

> static int bond_open(struct net_device *bond_dev)
>@@ -4174,6 +4180,11 @@ static int bond_open(struct net_device *bond_dev)
> 		bond_3ad_initiate_agg_selection(bond, 1);
> 	}
> =

>+	if (bond->params.mac_filter) {
>+		bond->recv_probe =3D bond_xor_recv;
>+		queue_delayed_work(bond->wq, &bond->mac_work, 0);
>+	}
>+
> 	if (bond_mode_can_use_xmit_hash(bond))
> 		bond_update_slave_arr(bond, NULL);
> =

>@@ -5043,6 +5054,13 @@ static struct slave *bond_xmit_3ad_xor_slave_get(s=
truct bonding *bond,
> 	if (unlikely(!count))
> 		return NULL;
> =

>+	if (bond->params.mac_filter) {
>+		const struct ethhdr *mac_hdr;
>+
>+		mac_hdr =3D (struct ethhdr *)skb_mac_header(skb);
>+		if (bond_mac_insert(bond, mac_hdr->h_source))
>+			return NULL;
>+	}
> 	slave =3D slaves->arr[hash % count];
> 	return slave;
> }
>@@ -5660,6 +5678,8 @@ static void bond_destructor(struct net_device *bond=
_dev)
> =

> 	if (bond->rr_tx_counter)
> 		free_percpu(bond->rr_tx_counter);
>+
>+	bond_mac_hash_destroy(bond);
> }
> =

> void bond_setup(struct net_device *bond_dev)
>@@ -6115,6 +6135,7 @@ static int bond_check_params(struct bond_params *pa=
rams)
> 	params->downdelay =3D downdelay;
> 	params->peer_notif_delay =3D 0;
> 	params->use_carrier =3D use_carrier;
>+	params->mac_filter =3D 0;
> 	params->lacp_active =3D 1;
> 	params->lacp_fast =3D lacp_fast;
> 	params->primary[0] =3D 0;
>@@ -6317,6 +6338,10 @@ static int __init bonding_init(void)
> 			goto err;
> 	}
> =

>+	res =3D bond_mac_cache_init();
>+	if (res)
>+		goto err;
>+
> 	skb_flow_dissector_init(&flow_keys_bonding,
> 				flow_keys_bonding_keys,
> 				ARRAY_SIZE(flow_keys_bonding_keys));
>@@ -6346,6 +6371,7 @@ static void __exit bonding_exit(void)
> 	/* Make sure we don't have an imbalance on our netpoll blocking */
> 	WARN_ON(atomic_read(&netpoll_block_tx));
> #endif
>+	bond_mac_cache_destroy();
> }
> =

> module_init(bonding_init);
>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index f427fa1737c7..249d79b6e21a 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -113,6 +113,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_=
MAX + 1] =3D {
> 	[IFLA_BOND_PEER_NOTIF_DELAY]    =3D { .type =3D NLA_U32 },
> 	[IFLA_BOND_MISSED_MAX]		=3D { .type =3D NLA_U8 },
> 	[IFLA_BOND_NS_IP6_TARGET]	=3D { .type =3D NLA_NESTED },
>+	[IFLA_BOND_MAC_FILTER]		=3D { .type =3D NLA_U8 },
> };
> =

> static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1=
] =3D {
>@@ -498,6 +499,14 @@ static int bond_changelink(struct net_device *bond_d=
ev, struct nlattr *tb[],
> 		if (err)
> 			return err;
> 	}
>+	if (data[IFLA_BOND_MAC_FILTER]) {
>+		u8 mac_filter =3D nla_get_u8(data[IFLA_BOND_MAC_FILTER]);
>+
>+		bond_opt_initval(&newval, mac_filter);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MAC_FILTER, &newval);
>+		if (err)
>+			return err;
>+	}
> =

> 	return 0;
> }
>@@ -565,6 +574,7 @@ static size_t bond_get_size(const struct net_device *=
bond_dev)
> 						/* IFLA_BOND_NS_IP6_TARGET */
> 		nla_total_size(sizeof(struct nlattr)) +
> 		nla_total_size(sizeof(struct in6_addr)) * BOND_MAX_NS_TARGETS +
>+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MAC_FILTER */
> 		0;
> }
> =

>@@ -723,6 +733,9 @@ static int bond_fill_info(struct sk_buff *skb,
> 	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
> 		       bond->params.missed_max))
> 		goto nla_put_failure;
>+	if (nla_put_u8(skb, IFLA_BOND_MAC_FILTER,
>+		       bond->params.mac_filter))
>+		goto nla_put_failure;
> =

> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
> 		struct ad_info info;
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index 64f7db2627ce..0f6036ff7b86 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -15,6 +15,7 @@
> #include <linux/sched/signal.h>
> =

> #include <net/bonding.h>
>+#include "bonding_priv.h"
> =

> static int bond_option_active_slave_set(struct bonding *bond,
> 					const struct bond_opt_value *newval);
>@@ -84,6 +85,8 @@ static int bond_option_ad_user_port_key_set(struct bond=
ing *bond,
> 					    const struct bond_opt_value *newval);
> static int bond_option_missed_max_set(struct bonding *bond,
> 				      const struct bond_opt_value *newval);
>+static int bond_option_mac_filter_set(struct bonding *bond,
>+				      const struct bond_opt_value *newval);
> =

> =

> static const struct bond_opt_value bond_mode_tbl[] =3D {
>@@ -226,6 +229,12 @@ static const struct bond_opt_value bond_missed_max_t=
bl[] =3D {
> 	{ NULL,		-1,	0},
> };
> =

>+static const struct bond_opt_value bond_mac_filter_tbl[] =3D {
>+	{ "off",	0,	BOND_VALFLAG_MIN | BOND_VALFLAG_DEFAULT},
>+	{ "maxval",	18,	BOND_VALFLAG_MAX},

	What's the magic number 18?

>+	{ NULL,		-1,	0}
>+};
>+
> static const struct bond_option bond_opts[BOND_OPT_LAST] =3D {
> 	[BOND_OPT_MODE] =3D {
> 		.id =3D BOND_OPT_MODE,
>@@ -482,7 +491,16 @@ static const struct bond_option bond_opts[BOND_OPT_L=
AST] =3D {
> 		.desc =3D "Delay between each peer notification on failover event, in =
milliseconds",
> 		.values =3D bond_intmax_tbl,
> 		.set =3D bond_option_peer_notif_delay_set
>-	}
>+	},
>+	[BOND_OPT_MAC_FILTER] =3D {
>+		.id =3D BOND_OPT_MAC_FILTER,
>+		.name =3D "mac_filter",
>+		.unsuppmodes =3D BOND_MODE_ALL_EX(BIT(BOND_MODE_XOR)),
>+		.desc =3D "filter received frames based on MAC addresses that have tra=
nsmitted from the bond, number of MAC addresses to track",
>+		.flags =3D BOND_OPTFLAG_NOSLAVES | BOND_OPTFLAG_IFDOWN,
>+		.values =3D bond_mac_filter_tbl,
>+		.set =3D bond_option_mac_filter_set
>+	},
> };
> =

> /* Searches for an option by name */
>@@ -1035,6 +1053,44 @@ static int bond_option_use_carrier_set(struct bond=
ing *bond,
> 	return 0;
> }
> =

>+static int bond_option_mac_filter_set(struct bonding *bond,
>+				      const struct bond_opt_value *newval)
>+{
>+	int rc =3D 0;
>+	u8 prev =3D bond->params.mac_filter;
>+
>+	if (newval->value && bond->params.arp_interval) {
>+		netdev_err(bond->dev, "ARP monitoring cannot be used with MAC Filterin=
g.\n");
>+		rc =3D -EPERM;
>+		goto err;
>+	}

	What happens if a user (a) switches to ARP monitor with
arp_validate in balance-xor mode after mac_filter is enabled, or, (b)
changes the mode to something other than balance-xor with mac_filter
enabled (both by changing the configuration in real time)?

	-J

>+
>+	netdev_dbg(bond->dev, "Setting mac_filter to %llu\n",
>+		   newval->value);
>+	bond->params.mac_filter =3D newval->value;
>+
>+	if (prev =3D=3D 0 && bond->params.mac_filter > 0) {
>+		rc =3D bond_mac_hash_init(bond);
>+		if (rc)
>+			goto err;
>+	} else if (prev > 0 && bond->params.mac_filter =3D=3D 0)
>+		bond_mac_hash_destroy(bond);
>+
>+	if (bond->mac_filter_tbl) {
>+		bond->mac_filter_tbl->p.max_size =3D
>+			1 << bond->params.mac_filter;
>+		netdev_dbg(bond->dev, "mac_filter hash table size: %d\n",
>+			   bond->mac_filter_tbl->p.max_size);
>+	}
>+
>+out:
>+	return rc;
>+
>+err:
>+	bond->params.mac_filter =3D 0;
>+	goto out;
>+}
>+
> /* There are two tricky bits here.  First, if ARP monitoring is activate=
d, then
>  * we must disable MII monitoring.  Second, if the ARP timer isn't runni=
ng,
>  * we must start it.
>diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bon=
ding_priv.h
>index 48cdf3a49a7d..0299f8bcb5fd 100644
>--- a/drivers/net/bonding/bonding_priv.h
>+++ b/drivers/net/bonding/bonding_priv.h
>@@ -15,6 +15,7 @@
> #ifndef _BONDING_PRIV_H
> #define _BONDING_PRIV_H
> #include <generated/utsrelease.h>
>+#include "bond_mac_filter.h"
> =

> #define DRV_NAME	"bonding"
> #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
>diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>index 61b49063791c..42e3e676b9c2 100644
>--- a/include/net/bond_options.h
>+++ b/include/net/bond_options.h
>@@ -67,6 +67,7 @@ enum {
> 	BOND_OPT_LACP_ACTIVE,
> 	BOND_OPT_MISSED_MAX,
> 	BOND_OPT_NS_TARGETS,
>+	BOND_OPT_MAC_FILTER,
> 	BOND_OPT_LAST
> };
> =

>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index b14f4c0b4e9e..5bc3e7b5a2af 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -125,6 +125,7 @@ struct bond_params {
> 	int miimon;
> 	u8 num_peer_notif;
> 	u8 missed_max;
>+	u8 mac_filter;
> 	int arp_interval;
> 	int arp_validate;
> 	int arp_all_targets;
>@@ -248,6 +249,7 @@ struct bonding {
> 	struct   delayed_work alb_work;
> 	struct   delayed_work ad_work;
> 	struct   delayed_work mcast_work;
>+	struct   delayed_work mac_work;
> 	struct   delayed_work slave_arr_work;
> #ifdef CONFIG_DEBUG_FS
> 	/* debugging support via debugfs */
>@@ -260,6 +262,7 @@ struct bonding {
> 	spinlock_t ipsec_lock;
> #endif /* CONFIG_XFRM_OFFLOAD */
> 	struct bpf_prog *xdp_prog;
>+	struct rhashtable *mac_filter_tbl;
> };
> =

> #define bond_slave_get_rcu(dev) \
>diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>index cc284c048e69..9291df89581f 100644
>--- a/include/uapi/linux/if_link.h
>+++ b/include/uapi/linux/if_link.h
>@@ -929,6 +929,7 @@ enum {
> 	IFLA_BOND_AD_LACP_ACTIVE,
> 	IFLA_BOND_MISSED_MAX,
> 	IFLA_BOND_NS_IP6_TARGET,
>+	IFLA_BOND_MAC_FILTER,
> 	__IFLA_BOND_MAX,
> };
> =

>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
