Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07625AA726
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390376AbfIEPWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:22:09 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36271 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388057AbfIEPWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:22:08 -0400
Received: by mail-lj1-f194.google.com with SMTP id l20so2944583ljj.3
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XR7kP2wYWkoYel5HDCFkqT6mR09A6mh7IjRFTfd+Ks=;
        b=ataIcrKR2wksCN32CLNxbf0vYJCrNff1iMUKg5aCzY5f2UQJky8+BxjGJSbv54veYy
         28urWxcgeIPNTkWbv1hZSaWqWiNgywM1K5SdcbZ57RmQwze0fTFYwLsRihyR6fDdVk2O
         V65pTNDWQpFzLrCP5C3i4VMQ38t2PhhRO6k1nWO27jBAT8X33on7XRhjBOVMMwyyRcWm
         qIq3pfMWVgNSCALRSh2cOtULhRw3aaASDY5HJuYuy9C9HF15T0tGHlzVM/s8k6eI98Ts
         E4ltmozt4YgblA4VSz8R0yOy0ng0Zrgn915h0MB0QRTr0VEPUuMigpMHyOCAAopWx/HF
         vLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XR7kP2wYWkoYel5HDCFkqT6mR09A6mh7IjRFTfd+Ks=;
        b=elkuD3g1PhcLtzZpVPFsyXAwp4xU9c86HGeGvlJFA+Ag1NvW1lCzXx2MLnd1rUdc8A
         YgNyXLOQm5oTqG+IBBPgeSBkEBUcxVjzhxHcTxlx8lg1ZhPpgf79fpLwpl0QAcCXpLkv
         lYZ4DX4sxaYMsbL2zwujRnibIm9vRDQicz3Zw01UygdRJFBc+3W309l2PcZgyH6Fx4Hw
         u6RNRueY263O5tX7RCZllf3glqKe/aCVZXjVTe9ywm5N120bI24Ar2t0mnil4UWVq8A7
         69JODuOwInlrzFG71CKWXu611qeGiG51n/nh6StkCckDYeFLSCIoppS1run/vK9u4rVl
         wnLA==
X-Gm-Message-State: APjAAAV8q9/C39tkpUUQZdF1Y5Dszsml72d2847tVYbkUJ+7+ceAQMc5
        fYHmROU18wd1DYyDO3FelkAfdedjcfilong6y0o=
X-Google-Smtp-Source: APXvYqwHn24px4jqEmiMxcrA0oSIZywRi9We0ldJz5p3pkDQzbFUSVef8/QzclOTNJGI2HcukKKs/iVEhzH8XO5ynBQ=
X-Received: by 2002:a2e:8051:: with SMTP id p17mr2515938ljg.222.1567696925618;
 Thu, 05 Sep 2019 08:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190904183927.14754-1-ap420073@gmail.com> <22680.1567624963@famine>
In-Reply-To: <22680.1567624963@famine>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 6 Sep 2019 00:21:54 +0900
Message-ID: <CAMArcTWuycr9PMtx-UvjKA=PxvX0VY6whrVweowq03aqoQ163Q@mail.gmail.com>
Subject: Re: [PATCH net 03/11] bonding: split IFF_BONDING into IFF_BONDING and IFF_BONDING_SLAVE
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 at 04:22, Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>

Hi Jay,
Thank you for the review!

> Taehee Yoo <ap420073@gmail.com> wrote:
>
> >The IFF_BONDING means bonding master or bonding slave device.
> >
> >->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() removes
> >IFF_BONDING flag.
> >This routine makes a problem in the nesting bonding structure.
> >
> >bond1<--bond2
> >
> >Both bond0 and bond1 are bonding device and these should keep having
> >IFF_BONDING flag until they are removed.
> >But bond1 would lose IFF_BONDING at ->ndo_del_slave because that routine
> >can not check whether the slave device is the bonding type or not.
> >So that this patch splits the IFF_BONDING into theIFF_BONDING and
> >the IFF_BONDING_SLAVE. The IFF_BONDING is bonding master flag and
> >IFF_BONDING_SLAVE is bonding slave flag.
> >
> >Test commands:
> >    ip link add bond0 type bond
> >    ip link add bond1 type bond
> >    ip link set bond1 master bond0
> >    ip link set bond1 nomaster
> >    ip link del bond1 type bond
> >    ip link add bond1 type bond
> >
> >Splat looks like:
> >[  149.201107] proc_dir_entry 'bonding/bond1' already registered
> >[  149.208013] WARNING: CPU: 1 PID: 1308 at fs/proc/generic.c:361 proc_register+0x2a9/0x3e0
> >[  149.208866] Modules linked in: bonding veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv4 ip_tables6
> >[  149.208866] CPU: 1 PID: 1308 Comm: ip Not tainted 5.3.0-rc7+ #322
> >[  149.208866] RIP: 0010:proc_register+0x2a9/0x3e0
> >[  149.208866] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 39 01 00 00 48 8b 04 24 48 89 ea 48 c7 c7 a0 a0 13 89 48 8b b0 0
> >[  149.208866] RSP: 0018:ffff88810df9f098 EFLAGS: 00010286
> >[  149.208866] RAX: dffffc0000000008 RBX: ffff8880b5d3aa50 RCX: ffffffff87cdec92
> >[  149.208866] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888116bf6a8c
> >[  149.208866] RBP: ffff8880b5d3acd3 R08: ffffed1022d7ff71 R09: ffffed1022d7ff71
> >[  149.208866] R10: 0000000000000001 R11: ffffed1022d7ff70 R12: ffff8880b5d3abe8
> >[  149.208866] R13: ffff8880b5d3acd2 R14: dffffc0000000000 R15: ffffed1016ba759a
> >[  149.208866] FS:  00007f4bd1f650c0(0000) GS:ffff888116a00000(0000) knlGS:0000000000000000
> >[  149.208866] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[  149.208866] CR2: 000055e7ca686118 CR3: 0000000106fd4000 CR4: 00000000001006e0
> >[  149.208866] Call Trace:
> >[  149.208866]  proc_create_seq_private+0xb3/0xf0
> >[  149.208866]  bond_create_proc_entry+0x1b3/0x3f0 [bonding]
> >[  149.208866]  bond_netdev_event+0x433/0x970 [bonding]
> >[  149.208866]  ? __module_text_address+0x13/0x140
> >[  149.208866]  notifier_call_chain+0x90/0x160
> >[  149.208866]  register_netdevice+0x9b3/0xd70
> >[  149.208866]  ? alloc_netdev_mqs+0x854/0xc10
> >[  149.208866]  ? netdev_change_features+0xa0/0xa0
> >[  149.208866]  ? rtnl_create_link+0x2ed/0xad0
> >[  149.208866]  bond_newlink+0x2a/0x60 [bonding]
> >[  149.208866]  __rtnl_newlink+0xb75/0x1180
> >[  ... ]
> >
> >Fixes: 0b680e753724 ("[PATCH] bonding: Add priv_flag to avoid event mishandling")
>
>         I'm not sure this Fixes is technically correct, as I don't think
> nesting bonds has induced an oops since 2006.  I don't think nesting
> bonds really does anything useful, but it's been allowed for years (but
> has been broken on and off all that time) so I'm a bit leery of simply
> disallowing nesting of bonds for fear it would break something already
> in use.
>
>         In any event, it would be desirable if this fix could be changed
> to not need a new priv_flag, as this patch would consume the last free
> bit in netdev_priv_flags.  A bond master device that is also a slave
> should have IFF_MASTER set in dev->flags, which could be tested at
> removal time to avoid clearing IFF_BONDING.
>

I have been testing another way that doesn't add a new flag and that
just checks IFF_MASTER and IFF_BONDING when an interface is being deleted.
I think it is simple and works well. so I will send a v2 patch after
some more tests.
Thank you!


>         -J
>
> >Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> >---
> > drivers/net/bonding/bond_main.c                     | 13 +++++--------
> > .../net/ethernet/qlogic/netxen/netxen_nic_main.c    |  2 +-
> > drivers/net/hyperv/netvsc_drv.c                     |  3 +--
> > drivers/scsi/fcoe/fcoe.c                            |  2 +-
> > drivers/target/iscsi/cxgbit/cxgbit_cm.c             |  2 +-
> > include/linux/netdevice.h                           |  9 ++++++---
> > 6 files changed, 15 insertions(+), 16 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 931d9d935686..abd008c31c9a 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -1560,7 +1560,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> >               goto err_restore_mac;
> >       }
> >
> >-      slave_dev->priv_flags |= IFF_BONDING;
> >+      slave_dev->priv_flags |= IFF_BONDING_SLAVE;
> >       /* initialize slave stats */
> >       dev_get_stats(new_slave->dev, &new_slave->slave_stats);
> >
> >@@ -1816,7 +1816,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> >       slave_disable_netpoll(new_slave);
> >
> > err_close:
> >-      slave_dev->priv_flags &= ~IFF_BONDING;
> >+      slave_dev->priv_flags &= ~IFF_BONDING_SLAVE;
> >       dev_close(slave_dev);
> >
> > err_restore_mac:
> >@@ -2017,7 +2017,7 @@ static int __bond_release_one(struct net_device *bond_dev,
> >       else
> >               dev_set_mtu(slave_dev, slave->original_mtu);
> >
> >-      slave_dev->priv_flags &= ~IFF_BONDING;
> >+      slave_dev->priv_flags &= ~IFF_BONDING_SLAVE;
> >
> >       bond_free_slave(slave);
> >
> >@@ -3221,10 +3221,7 @@ static int bond_netdev_event(struct notifier_block *this,
> >       netdev_dbg(event_dev, "%s received %s\n",
> >                  __func__, netdev_cmd_to_name(event));
> >
> >-      if (!(event_dev->priv_flags & IFF_BONDING))
> >-              return NOTIFY_DONE;
> >-
> >-      if (event_dev->flags & IFF_MASTER) {
> >+      if (netif_is_bond_master(event_dev)) {
> >               int ret;
> >
> >               ret = bond_master_netdev_event(event, event_dev);
> >@@ -3232,7 +3229,7 @@ static int bond_netdev_event(struct notifier_block *this,
> >                       return ret;
> >       }
> >
> >-      if (event_dev->flags & IFF_SLAVE)
> >+      if (netif_is_bond_slave(event_dev))
> >               return bond_slave_netdev_event(event, event_dev);
> >
> >       return NOTIFY_DONE;
> >diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> >index 58e2eaf77014..5e0389ba1f13 100644
> >--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> >+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> >@@ -3340,7 +3340,7 @@ static void netxen_config_master(struct net_device *dev, unsigned long event)
> >        * released and is dev_close()ed in bond_release()
> >        * just before IFF_BONDING is stripped.
> >        */
> >-      if (!master && dev->priv_flags & IFF_BONDING)
> >+      if (!master && netif_is_bond_slave(dev))
> >               netxen_free_ip_list(adapter, true);
> > }
> >
> >diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> >index e8fce6d715ef..6831202d9bcb 100644
> >--- a/drivers/net/hyperv/netvsc_drv.c
> >+++ b/drivers/net/hyperv/netvsc_drv.c
> >@@ -2439,8 +2439,7 @@ static int netvsc_netdev_event(struct notifier_block *this,
> >               return NOTIFY_DONE;
> >
> >       /* Avoid Bonding master dev with same MAC registering as VF */
> >-      if ((event_dev->priv_flags & IFF_BONDING) &&
> >-          (event_dev->flags & IFF_MASTER))
> >+      if (netif_is_bond_master(event_dev))
> >               return NOTIFY_DONE;
> >
> >       switch (event) {
> >diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> >index 00dd47bcbb1e..750a6540eb9d 100644
> >--- a/drivers/scsi/fcoe/fcoe.c
> >+++ b/drivers/scsi/fcoe/fcoe.c
> >@@ -307,7 +307,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
> >       }
> >
> >       /* Do not support for bonding device */
> >-      if (netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER) {
> >+      if (netif_is_bond_master(netdev)) {
> >               FCOE_NETDEV_DBG(netdev, "Bonded interfaces not supported\n");
> >               return -EOPNOTSUPP;
> >       }
> >diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
> >index c70caf4ea490..16c8cae333b2 100644
> >--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
> >+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
> >@@ -247,7 +247,7 @@ struct cxgbit_device *cxgbit_find_device(struct net_device *ndev, u8 *port_id)
> >
> > static struct net_device *cxgbit_get_real_dev(struct net_device *ndev)
> > {
> >-      if (ndev->priv_flags & IFF_BONDING) {
> >+      if (netif_is_bond_master(ndev) || netif_is_bond_slave(ndev)) {
> >               pr_err("Bond devices are not supported. Interface:%s\n",
> >                      ndev->name);
> >               return NULL;
> >diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >index 5bb5756129af..a2c47f43e54b 100644
> >--- a/include/linux/netdevice.h
> >+++ b/include/linux/netdevice.h
> >@@ -1441,7 +1441,7 @@ struct net_device_ops {
> >  *
> >  * @IFF_802_1Q_VLAN: 802.1Q VLAN device
> >  * @IFF_EBRIDGE: Ethernet bridging device
> >- * @IFF_BONDING: bonding master or slave
> >+ * @IFF_BONDING: bonding master
> >  * @IFF_ISATAP: ISATAP interface (RFC4214)
> >  * @IFF_WAN_HDLC: WAN HDLC device
> >  * @IFF_XMIT_DST_RELEASE: dev_hard_start_xmit() is allowed to
> >@@ -1474,6 +1474,7 @@ struct net_device_ops {
> >  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
> >  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
> >  * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
> >+ * @IFF_BONDING_SLAVE: bonding slave
> >  */
> > enum netdev_priv_flags {
> >       IFF_802_1Q_VLAN                 = 1<<0,
> >@@ -1507,6 +1508,7 @@ enum netdev_priv_flags {
> >       IFF_FAILOVER_SLAVE              = 1<<28,
> >       IFF_L3MDEV_RX_HANDLER           = 1<<29,
> >       IFF_LIVE_RENAME_OK              = 1<<30,
> >+      IFF_BONDING_SLAVE               = 1<<31,
> > };
> >
> > #define IFF_802_1Q_VLAN                       IFF_802_1Q_VLAN
> >@@ -1539,6 +1541,7 @@ enum netdev_priv_flags {
> > #define IFF_FAILOVER_SLAVE            IFF_FAILOVER_SLAVE
> > #define IFF_L3MDEV_RX_HANDLER         IFF_L3MDEV_RX_HANDLER
> > #define IFF_LIVE_RENAME_OK            IFF_LIVE_RENAME_OK
> >+#define IFF_BONDING_SLAVE             IFF_BONDING_SLAVE
> >
> > /**
> >  *    struct net_device - The DEVICE structure.
> >@@ -4569,12 +4572,12 @@ static inline bool netif_is_macvlan_port(const struct net_device *dev)
> >
> > static inline bool netif_is_bond_master(const struct net_device *dev)
> > {
> >-      return dev->flags & IFF_MASTER && dev->priv_flags & IFF_BONDING;
> >+      return dev->priv_flags & IFF_BONDING;
> > }
> >
> > static inline bool netif_is_bond_slave(const struct net_device *dev)
> > {
> >-      return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_BONDING;
> >+      return dev->priv_flags & IFF_BONDING_SLAVE;
> > }
> >
> > static inline bool netif_supports_nofcs(struct net_device *dev)
> >--
> >2.17.1
> >
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
