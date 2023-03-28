Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5B76CB576
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjC1Eik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjC1Eij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:38:39 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E087D1FE5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:38:10 -0700 (PDT)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AFAFA3F210
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 04:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1679978287;
        bh=686fpAWYbCb9nKozPm3P7x4wMIwJg4LGwO1Jttut4kg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=jmDaQ/de73hdbYPYmeX5v5HpbGwxmuw+7VYWouwMP0NaOF9MNNfasvHo7tvxBNWsJ
         /3FnSAfBV6QntqN+SamEGwtNPu4b+yyX/haKKnL7xXZsl78MEZ3bOCjB1n7DCkH99y
         vDkfkWUARZWdo195GwfUOyi8KAnODkrulW4zkCWcvoPhiwfZCTi0mqZpcXzWlYA25N
         xCHybUkiHe9vsKgaF7zFpORidQJF5jEg9qIgtRgYQLZva4bIYcAOJq9FwYXRFd6z6q
         mH8mwq3eBXUQvZrMO6jsCXn7WHiS8J4OHTTACtmYOW1I2T+LbkS0hHP+2TvuvkIbaZ
         CSkHzPEAKfAcw==
Received: by mail-pf1-f198.google.com with SMTP id x3-20020a62fb03000000b00622df3f5d0cso5264547pfm.10
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679978286;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=686fpAWYbCb9nKozPm3P7x4wMIwJg4LGwO1Jttut4kg=;
        b=2eah7AUZWez3mlaptq+rLVo6zRn7dHSkNssRAwk8oA/gLoqvCXe9HYBekEOvV6go69
         J4KftpiqSC9jR+vefmJtphW059zKOZmMHiPgBRWvPibia3PoODddm2AguZ68UGRI2w0c
         zUcmwdaqhx4LJ0xwwzikl8ewfpvAkF/AxQjCR7kYiY0h6KlfucX7VtGZYpg3odw/zPxZ
         4ajYbZ5FMHmT7HiVgAPl6LON4a8Bg6DCenSgkd/LczikEjY66XH6lBMv4IUozxr0zvaa
         4nwaeMLFeAG0vs+9qJNYyfpjr7OvQpY0PEMqf/O5/9/HnpbCA6G42i1HuYrwIn8J54p6
         toLQ==
X-Gm-Message-State: AAQBX9eg1fdLoqUF1MFDfEBjNNYegXd6nfi/QL5MDDPnFJNJbIg0Ch52
        Y/+83kvUydmHnw0OifmC8gg27F2n/yKHH7OVFtpXW+Fo90r4dnipeJEjjEArGKN2lOfKwg6roXt
        H9mgsTh+7TM3l5gcch/EU8Ynx+GJHQCPEpg==
X-Received: by 2002:a17:902:cf45:b0:19f:1f0a:97f1 with SMTP id e5-20020a170902cf4500b0019f1f0a97f1mr11851396plg.30.1679978286185;
        Mon, 27 Mar 2023 21:38:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZUXJ6hQZuQufvn6eGNuiWnhfqaZdjOeBO7O6cx/GbMYOTRk/HihXU8WgrlZgR8l/WBxkQ88w==
X-Received: by 2002:a17:902:cf45:b0:19f:1f0a:97f1 with SMTP id e5-20020a170902cf4500b0019f1f0a97f1mr11851382plg.30.1679978285791;
        Mon, 27 Mar 2023 21:38:05 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a19d4592e1sm19820566plr.282.2023.03.27.21.38.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Mar 2023 21:38:05 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id C038461E6A; Mon, 27 Mar 2023 21:38:04 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B8ED49FB79;
        Mon, 27 Mar 2023 21:38:04 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     sujing <sujing@kylinos.cn>
cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bonding: avoid use-after-free with tx_hashtbl/rx_hashtbl
In-reply-to: <20230328034037.2076930-1-sujing@kylinos.cn>
References: <20230328034037.2076930-1-sujing@kylinos.cn>
Comments: In-reply-to sujing <sujing@kylinos.cn>
   message dated "Tue, 28 Mar 2023 11:40:37 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23771.1679978284.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 27 Mar 2023 21:38:04 -0700
Message-ID: <23772.1679978284@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sujing <sujing@kylinos.cn> wrote:

>In bonding mode 6 (Balance-alb),
>there are some potential race conditions between the 'bond_close' process
>and the tx/rx processes that use tx_hashtbl/rx_hashtbl,
>which may lead to use-after-free.
>
>For instance, when the bond6 device is in the 'bond_close' process
>while some backlogged packets from upper level are transmitted
>to 'bond_start_xmit', there is a spinlock contention between
>'tlb_deinitialize' and 'tlb_choose_channel'.
>
>If 'tlb_deinitialize' preempts the lock before 'tlb_choose_channel',
>a NULL pointer kernel panic will be triggered.
>
>Here's the timeline:
>
>bond_close  ------------------  bond_start_xmit
>bond_alb_deinitialize  -------  __bond_start_xmit
>tlb_deinitialize  ------------  bond_alb_xmit
>spin_lock_bh  ----------------  bond_xmit_alb_slave_get
>tx_hashtbl =3D NULL  -----------  tlb_choose_channel
>spin_unlock_bh  --------------  //wait for spin_lock_bh
>------------------------------  spin_lock_bh
>------------------------------  __tlb_choose_channel
>causing kernel panic =3D=3D=3D=3D=3D=3D=3D=3D>  tx_hashtbl[hash_index].tx=
_slave
>------------------------------  spin_unlock_bh

	I'm still thinking on the race here, but have some questions
below about the implementation in the meantime.

>Signed-off-by: sujing <sujing@kylinos.cn>
>---
> drivers/net/bonding/bond_alb.c  | 32 +++++++++------------------
> drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++++++++------
> include/net/bond_alb.h          |  5 ++++-
> 3 files changed, 46 insertions(+), 30 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index b9dbad3a8af8..f6ff5ea835c4 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -71,7 +71,7 @@ static inline u8 _simple_hash(const u8 *hash_start, int=
 hash_size)
> =

> /*********************** tlb specific functions ************************=
***/
> =

>-static inline void tlb_init_table_entry(struct tlb_client_info *entry, i=
nt save_load)
>+void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
> {
> 	if (save_load) {
> 		entry->load_history =3D 1 + entry->tx_bytes /
>@@ -269,8 +269,8 @@ static void rlb_update_entry_from_arp(struct bonding =
*bond, struct arp_pkt *arp)
> 	spin_unlock_bh(&bond->mode_lock);
> }
> =

>-static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
>-			struct slave *slave)
>+int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
>+		 struct slave *slave)
> {
> 	struct arp_pkt *arp, _arp;
> =

>@@ -756,7 +756,7 @@ static void rlb_init_table_entry_src(struct rlb_clien=
t_info *entry)
> 	entry->src_next =3D RLB_NULL_INDEX;
> }
> =

>-static void rlb_init_table_entry(struct rlb_client_info *entry)
>+void rlb_init_table_entry(struct rlb_client_info *entry)
> {
> 	memset(entry, 0, sizeof(struct rlb_client_info));
> 	rlb_init_table_entry_dst(entry);
>@@ -874,9 +874,6 @@ static int rlb_initialize(struct bonding *bond)
> =

> 	spin_unlock_bh(&bond->mode_lock);
> =

>-	/* register to receive ARPs */
>-	bond->recv_probe =3D rlb_arp_recv;
>-
> 	return 0;
> }
> =

>@@ -888,7 +885,6 @@ static void rlb_deinitialize(struct bonding *bond)
> =

> 	kfree(bond_info->rx_hashtbl);
> 	bond_info->rx_hashtbl =3D NULL;
>-	bond_info->rx_hashtbl_used_head =3D RLB_NULL_INDEX;

	Why remove this line?

> 	spin_unlock_bh(&bond->mode_lock);
> }
>@@ -1303,7 +1299,7 @@ static bool alb_determine_nd(struct sk_buff *skb, s=
truct bonding *bond)
> =

> /************************ exported alb functions ***********************=
*/
> =

>-int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>+int bond_alb_initialize(struct bonding *bond)
> {
> 	int res;
> =

>@@ -1311,15 +1307,10 @@ int bond_alb_initialize(struct bonding *bond, int=
 rlb_enabled)
> 	if (res)
> 		return res;
> =

>-	if (rlb_enabled) {
>-		res =3D rlb_initialize(bond);
>-		if (res) {
>-			tlb_deinitialize(bond);
>-			return res;
>-		}
>-		bond->alb_info.rlb_enabled =3D 1;
>-	} else {
>-		bond->alb_info.rlb_enabled =3D 0;
>+	res =3D rlb_initialize(bond);
>+	if (res) {
>+		tlb_deinitialize(bond);
>+		return res;
> 	}
> =

> 	return 0;
>@@ -1327,12 +1318,9 @@ int bond_alb_initialize(struct bonding *bond, int =
rlb_enabled)
> =

> void bond_alb_deinitialize(struct bonding *bond)
> {
>-	struct alb_bond_info *bond_info =3D &(BOND_ALB_INFO(bond));
>-
> 	tlb_deinitialize(bond);
> =

>-	if (bond_info->rlb_enabled)
>-		rlb_deinitialize(bond);
>+	rlb_deinitialize(bond);

	Why is rlb_deinitialize() now unconditionally called here and in
bond_alb_initialize()?  if rlb_enabled is false, why set up / tear down
the RLB hash table that won't be used?

> }
> =

> static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding =
*bond,
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 236e5219c811..8fcb5d3ac0a2 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4217,6 +4217,7 @@ static int bond_open(struct net_device *bond_dev)
> 	struct bonding *bond =3D netdev_priv(bond_dev);
> 	struct list_head *iter;
> 	struct slave *slave;
>+	int i;
> =

> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter=
) {
> 		bond->rr_tx_counter =3D alloc_percpu(u32);
>@@ -4239,11 +4240,29 @@ static int bond_open(struct net_device *bond_dev)
> 	}
> =

> 	if (bond_is_lb(bond)) {
>-		/* bond_alb_initialize must be called before the timer
>-		 * is started.
>-		 */
>-		if (bond_alb_initialize(bond, (BOND_MODE(bond) =3D=3D BOND_MODE_ALB)))
>-			return -ENOMEM;
>+		struct alb_bond_info *bond_info =3D &(BOND_ALB_INFO(bond));
>+
>+		spin_lock_bh(&bond->mode_lock);
>+
>+		for (i =3D 0; i < TLB_HASH_TABLE_SIZE; i++)
>+			tlb_init_table_entry(&bond_info->tx_hashtbl[i], 0);
>+
>+		spin_unlock_bh(&bond->mode_lock);
>+
>+		if (BOND_MODE(bond) =3D=3D BOND_MODE_ALB) {
>+			bond->alb_info.rlb_enabled =3D 1;
>+			spin_lock_bh(&bond->mode_lock);
>+
>+			bond_info->rx_hashtbl_used_head =3D RLB_NULL_INDEX;
>+			for (i =3D 0; i < RLB_HASH_TABLE_SIZE; i++)
>+				rlb_init_table_entry(bond_info->rx_hashtbl + i);
>+
>+			spin_unlock_bh(&bond->mode_lock);
>+			bond->recv_probe =3D rlb_arp_recv;
>+		} else {
>+			bond->alb_info.rlb_enabled =3D 0;
>+		}
>+

	Why is all of the above done directly in bond_open() and not in
bond_alb.c somewhere?  That would reduce some churn (changing some
functions away from static).

	Also, I see that bond_alb_initialize() is now called from
bond_init() instead of bond_open(), and it only calls rlb_initialize().
However, this now duplicates most of the functionality of
rlb_initialize() and tlb_initialize() here.  Why?

	In general, the described race is TX vs. close processing, so
why is there so much change to the open processing?

	-J

> 		if (bond->params.tlb_dynamic_lb || BOND_MODE(bond) =3D=3D BOND_MODE_AL=
B)
> 			queue_delayed_work(bond->wq, &bond->alb_work, 0);
> 	}
>@@ -4279,8 +4298,6 @@ static int bond_close(struct net_device *bond_dev)
> =

> 	bond_work_cancel_all(bond);
> 	bond->send_peer_notif =3D 0;
>-	if (bond_is_lb(bond))
>-		bond_alb_deinitialize(bond);
> 	bond->recv_probe =3D NULL;
> =

> 	if (bond_uses_primary(bond)) {
>@@ -5854,6 +5871,8 @@ static void bond_uninit(struct net_device *bond_dev=
)
> 	struct list_head *iter;
> 	struct slave *slave;
> =

>+	bond_alb_deinitialize(bond);
>+
> 	bond_netpoll_cleanup(bond_dev);
> =

> 	/* Release the bonded slaves */
>@@ -6295,6 +6314,12 @@ static int bond_init(struct net_device *bond_dev)
> 	    bond_dev->addr_assign_type =3D=3D NET_ADDR_PERM)
> 		eth_hw_addr_random(bond_dev);
> =

>+	/* bond_alb_initialize must be called before the timer
>+	 * is started.
>+	 */
>+	if (bond_alb_initialize(bond))
>+		return -ENOMEM;
>+
> 	return 0;
> }
> =

>diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
>index 9dc082b2d543..9fd16e20ef82 100644
>--- a/include/net/bond_alb.h
>+++ b/include/net/bond_alb.h
>@@ -150,7 +150,7 @@ struct alb_bond_info {
> 						 */
> };
> =

>-int bond_alb_initialize(struct bonding *bond, int rlb_enabled);
>+int bond_alb_initialize(struct bonding *bond);
> void bond_alb_deinitialize(struct bonding *bond);
> int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
> void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
>@@ -165,5 +165,8 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding =
*bond,
> void bond_alb_monitor(struct work_struct *);
> int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
> void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
>+int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond, struct=
 slave *slave);
>+void tlb_init_table_entry(struct tlb_client_info *entry, int save_load);
>+void rlb_init_table_entry(struct rlb_client_info *entry);
> #endif /* _NET_BOND_ALB_H */
> =

>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
