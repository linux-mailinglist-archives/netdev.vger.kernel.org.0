Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79285912EF
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbiHLPbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbiHLPbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:31:00 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7A13D4D;
        Fri, 12 Aug 2022 08:30:58 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u6so1271180ljk.8;
        Fri, 12 Aug 2022 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=NruPjTk/HmaZpTA0ffeIQNQN6xhq/h854KF8R2vt4Yc=;
        b=V2IX904QajXxrYcWcks3PKikwA2DU7441h5JjfjRjwDU0aDd0+Ekhmfs8JoFC7ZWFr
         yXy/zixxwdPlizlHz0AlA54Z5CnavI1P+KYumrJCnR7S7zoW5KyvBDIBLgg2mJ6E7OpK
         0f3ORO6OBI0SILmT4tEMJ3x+Hd9mD4r2LOZlHKbrLeVy81mDu7t8cc0OHhwBC5wEdlSO
         mJdrGJBVussEfFlkvjM6suxffLEhlXNtpvfwpuxjtUFaPrLxbwQGsF7xG0bEsmwsLKsg
         3DSk76Q2DcKG1PkrPCpKO7yMpZxfiI0MeXrWrFnPUUJ0ImYTjkq9Ot0R6Oeda8DP0TaD
         75bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=NruPjTk/HmaZpTA0ffeIQNQN6xhq/h854KF8R2vt4Yc=;
        b=Twnv78omXjUGEcXA4qvi35Qf04Bf9L7O1iVEzBoOscVmGq7mwevFms4ck0y9YnYRCA
         0OrmrOcsjsbdlZsCdGRzRS1WN2oy6PVEz7Ueb5EbY5p0U0QudXHLYP4XEy1QTl6Cc7Ly
         eEWTSC16hXVxalKdRxWI4jEY1Mt5uzVhSjw/WO6tac9sKQE3SFzq9dpXr7L1tvQuUqzJ
         Hbiu1FENyPGvhzp7ycwC1WQ8yqGOhMY71cJBFFisU9c3uW12tZqcoJvaA1fVMcy+EoYF
         VXE48Y5ZG7Gkjb4y2O8jblaqIaxoC5ezRj7v22Z66n+sYRHP9W37kJAY4NDcrFBTGEn0
         iE+Q==
X-Gm-Message-State: ACgBeo20YyBjl47nbgzvUrtxLxZQUjAhHzxeIpAsFdYCUZi9YtoxlQV2
        I4osqi3Nyzhpy+EvG87hHfUGhqBbOSE6ozRGTVA=
X-Google-Smtp-Source: AA6agR4djbPt9Cq4PHrr26EeM+plpQZ0d00tRxmtBl612zZ6ppcJzhmbyZzT1QQC9CWbfrQds/0XWwnFoBFxdL9RrFU=
X-Received: by 2002:a2e:9201:0:b0:25d:d5e5:59b7 with SMTP id
 k1-20020a2e9201000000b0025dd5e559b7mr1393375ljg.375.1660318256463; Fri, 12
 Aug 2022 08:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com> <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org>
In-Reply-To: <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org>
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Date:   Fri, 12 Aug 2022 11:30:45 -0400
Message-ID: <CAMWRUK4Mo2KHfa-6Z4Ka+ZLx8TtmzSvq9CLmMmEwE5S7Yp7-Kw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior
 and add selftests
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, aroulin@nvidia.com, sbrivio@redhat.com,
        roopa@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 4:54 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 10/08/2022 06:11, Sevinj Aghayeva wrote:
> > When bridge binding is enabled for a vlan interface, it is expected
> > that the link state of the vlan interface will track the subset of the
> > ports that are also members of the corresponding vlan, rather than
> > that of all ports.
> >
> > Currently, this feature works as expected when a vlan interface is
> > created with bridge binding enabled:
> >
> >   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
> >         bridge_binding on
> >
> > However, the feature does not work when a vlan interface is created
> > with bridge binding disabled, and then enabled later:
> >
> >   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
> >         bridge_binding off
> >   ip link set vlan10 type vlan bridge_binding on
> >
> > After these two commands, the link state of the vlan interface
> > continues to track that of all ports, which is inconsistent and
> > confusing to users. This series fixes this bug and introduces two
> > tests for the valid behavior.
> >
> > Sevinj Aghayeva (3):
> >   net: core: export call_netdevice_notifiers_info
> >   net: 8021q: fix bridge binding behavior for vlan interfaces
> >   selftests: net: tests for bridge binding behavior
> >
> >  include/linux/netdevice.h                     |   2 +
> >  net/8021q/vlan.h                              |   2 +-
> >  net/8021q/vlan_dev.c                          |  25 ++-
> >  net/core/dev.c                                |   7 +-
> >  tools/testing/selftests/net/Makefile          |   1 +
> >  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
> >  6 files changed, 172 insertions(+), 8 deletions(-)
> >  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
> >
>
> Hi,
> NETDEV_CHANGE event is already propagated when the vlan changes flags,
> NETDEV_CHANGEUPPER is used when the devices' relationship changes not their flags.
> The only problem you have to figure out is that the flag has changed. The fix itself
> must be done within the bridge, not 8021q. You can figure it out based on current bridge
> loose binding state and the vlan's changed state, again in the bridge's NETDEV_CHANGE
> handler. Unfortunately the proper fix is much more involved and will need new
> infra, you'll have to track the loose binding vlans in the bridge. To do that you should
> add logic that reflects the current vlans' loose binding state *only* for vlans that also
> exist in the bridge, the rest which are upper should be carrier off if they have the loose
> binding flag set.
>
> Alternatively you can add a new NETDEV_ notifier (using something similar to struct netdev_notifier_pre_changeaddr_info)
> and add link type-specific space (e.g. union of link type-specific structs) in the struct which will contain
> what changed for 8021q and will be properly interpreted by the bridge. The downside is that we'll generate
> 2 notifications when changing the loose binding flag, but on the bright side won't have to track anything
> in the bridge, just handle the new notifier type. This might be the easiest path, the fix is still in
> the bridge though, the 8021q module just needs to fill in the new struct and emit the notification on
> any loose binding changes, the bridge must decide if it should process it (i.e. based on upper/lower
> relationship). Such notifier can be also re-used by other link types to propagate link-type specific
> changes.

Hi Nik,

Can you please clarify the following?

1) should the new NETDEV_ notifier be about the vlan device and not
the bridge? That is, should I handle it in br_device_event?
2) is it still okay to export call_netdevice_notifiers_info or should
i write a new function for this?

The answers to the above wasn't clear to me, but I came up with the
following patch anyway, so perhaps you can also comment on it. I'm
pasting it inline; this is against 5.19.

Thanks!

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2563d30736e9..c63205eb1f72 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2762,6 +2762,7 @@ enum netdev_cmd {
  NETDEV_UNREGISTER,
  NETDEV_CHANGEMTU, /* notify after mtu change happened */
  NETDEV_CHANGEADDR, /* notify after the address change */
+ NETDEV_CHANGEUPPERFLAGS,
  NETDEV_PRE_CHANGEADDR, /* notify before the address change */
  NETDEV_GOING_DOWN,
  NETDEV_CHANGENAME,
@@ -2837,6 +2838,12 @@ struct netdev_notifier_changelowerstate_info {
  void *lower_state_info; /* is lower dev state */
 };

+struct netdev_notifier_changeupperflags_info {
+ struct netdev_notifier_info info; /* must be first */
+ struct net_device *upper_dev;
+ bool vlan_bridge_binding;
+};
+
 struct netdev_notifier_pre_changeaddr_info {
  struct netdev_notifier_info info; /* must be first */
  const unsigned char *dev_addr;
@@ -2898,6 +2905,8 @@ netdev_notifier_info_to_extack(const struct
netdev_notifier_info *info)
 }

 int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
+int call_netdevice_notifiers_info(unsigned long val,
+  struct netdev_notifier_info *info);


 extern rwlock_t dev_base_lock; /* Device list lock */
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5eaf38875554..71947cdcfaaa 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -130,7 +130,7 @@ void vlan_dev_set_ingress_priority(const struct
net_device *dev,
 int vlan_dev_set_egress_priority(const struct net_device *dev,
  u32 skb_prio, u16 vlan_prio);
 void vlan_dev_free_egress_priority(const struct net_device *dev);
-int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
+int vlan_dev_change_flags(struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
        size_t size);

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 839f2020b015..68da3901dfb0 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -208,11 +208,18 @@ int vlan_dev_set_egress_priority(const struct
net_device *dev,
  return 0;
 }

+static inline bool netif_is_bridge(const struct net_device *dev)
+{
+ return dev->rtnl_link_ops &&
+    !strcmp(dev->rtnl_link_ops->kind, "bridge");
+}
+
 /* Flags are defined in the vlan_flags enum in
  * include/uapi/linux/if_vlan.h file.
  */
-int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
+int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
 {
+ struct netdev_notifier_changeupperflags_info info;
  struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
  u32 old_flags = vlan->flags;

@@ -223,19 +230,33 @@ int vlan_dev_change_flags(const struct
net_device *dev, u32 flags, u32 mask)

  vlan->flags = (old_flags & ~mask) | (flags & mask);

- if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
+ if (!netif_running(dev))
+ return 0;
+
+ if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
  if (vlan->flags & VLAN_FLAG_GVRP)
  vlan_gvrp_request_join(dev);
  else
  vlan_gvrp_request_leave(dev);
  }

- if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
+ if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
  if (vlan->flags & VLAN_FLAG_MVRP)
  vlan_mvrp_request_join(dev);
  else
  vlan_mvrp_request_leave(dev);
  }
+
+ if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
+    netif_is_bridge(vlan->real_dev)) {
+ info.info.dev = vlan->real_dev;
+ info.upper_dev = dev;
+ info.vlan_bridge_binding =
+    !!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING);
+ call_netdevice_notifiers_info(NETDEV_CHANGEUPPERFLAGS,
+    &info.info);
+ }
+
  return 0;
 }

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0f5e75ccac79..cbcb0877d4a4 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1718,6 +1718,7 @@ static void nbp_vlan_set_vlan_dev_state(struct
net_bridge_port *p, u16 vid)
 /* Must be protected by RTNL. */
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
void *ptr)
 {
+ struct netdev_notifier_changeupperflags_info *flags_info;
  struct netdev_notifier_changeupper_info *info;
  struct net_bridge *br = netdev_priv(dev);
  int vlcmd = 0, ret = 0;
@@ -1739,7 +1740,11 @@ int br_vlan_bridge_event(struct net_device
*dev, unsigned long event, void *ptr)
  info = ptr;
  br_vlan_upper_change(dev, info->upper_dev, info->linking);
  break;
-
+ case NETDEV_CHANGEUPPERFLAGS:
+ flags_info = ptr;
+ br_vlan_upper_change(dev, flags_info->upper_dev,
+    flags_info->vlan_bridge_binding);
+ break;
  case NETDEV_CHANGE:
  case NETDEV_UP:
  if (!br_opt_get(br, BROPT_VLAN_BRIDGE_BINDING))
diff --git a/net/core/dev.c b/net/core/dev.c
index 30a1603a7225..bc8640d77d83 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -160,8 +160,6 @@ struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly; /* Taps */

 static int netif_rx_internal(struct sk_buff *skb);
-static int call_netdevice_notifiers_info(unsigned long val,
- struct netdev_notifier_info *info);
 static int call_netdevice_notifiers_extack(unsigned long val,
    struct net_device *dev,
    struct netlink_ext_ack *extack);
@@ -1624,7 +1622,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
  N(POST_INIT) N(RELEASE) N(NOTIFY_PEERS) N(JOIN) N(CHANGEUPPER)
  N(RESEND_IGMP) N(PRECHANGEMTU) N(CHANGEINFODATA) N(BONDING_INFO)
  N(PRECHANGEUPPER) N(CHANGELOWERSTATE) N(UDP_TUNNEL_PUSH_INFO)
- N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
+ N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN) N(CHANGEUPPERFLAGS)
  N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
  N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
  N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
@@ -1927,8 +1925,8 @@ static void
move_netdevice_notifiers_dev_net(struct net_device *dev,
  * are as for raw_notifier_call_chain().
  */

-static int call_netdevice_notifiers_info(unsigned long val,
- struct netdev_notifier_info *info)
+int call_netdevice_notifiers_info(unsigned long val,
+  struct netdev_notifier_info *info)
 {
  struct net *net = dev_net(info->dev);
  int ret;
@@ -1944,6 +1942,7 @@ static int
call_netdevice_notifiers_info(unsigned long val,
  return ret;
  return raw_notifier_call_chain(&netdev_chain, val, info);
 }
+EXPORT_SYMBOL(call_netdevice_notifiers_info);

 /**
  * call_netdevice_notifiers_info_robust - call per-netns notifier blocks


>
> Both of these avoid any direct dependencies between the bridge and 8021q. Any other suggestions that
> are simpler, avoid direct dependencies and solve the issue in a generic way would be appreciated.
>
> Just be careful about introducing too much unnecessary processing because we
> can have lots of vlan devices in a system.
>
> Cheers,
>  Nik



-- 

Sevinj.Aghayeva
