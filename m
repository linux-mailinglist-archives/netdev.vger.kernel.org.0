Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4C9598277
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbiHRLuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239197AbiHRLuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:50:17 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757CB76758;
        Thu, 18 Aug 2022 04:50:15 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u1so1809724lfq.4;
        Thu, 18 Aug 2022 04:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oPkzYt3uSefU6VFSetnOWuaZ26MkCKMu+97oFrrfyCk=;
        b=aHTvdIYTIzF7IAANM/f6GYGBH7eO+SmI79y5ICK921cHdrssQ2DLIzDc33x30Tam/R
         aaBTB0GAC2I4d/d4vPZAqOXr08Ykh9cnpsPzJeQQiwZMYNPIRzY4KcSyww/Kw9HFhcFZ
         7CzE7Reniev4s7c/yNU3OWUfVplLA3g5HLaWwl8v11sApjLHLQ5JDmSjphjWV0Povx7Z
         rrMFXXFcyau+HuBjNnoThKMHxugK76uGmMjN5NemBxDYio2y9zKR6dNsV1GyZ8kuVySS
         14iTjpq2aLLZWeFIeOHYjQ3wQ/UgrzkElO38Bed+T0fkaiEc8OazJAeqM+dFltWJx3zq
         9SyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oPkzYt3uSefU6VFSetnOWuaZ26MkCKMu+97oFrrfyCk=;
        b=ZlL12XD0RWeLg8NJAVq+S9wZK+QLsGgazfa8fTdMKzdOj+8PXeEliwRJ83ttwvW3R5
         TpbyEPQavdO+COhBGcki+WDd94+dlDqGxFjgxpTWXas7awWKhq2bPMzUM8NwhM68S1gL
         ofzXcNzC4DjWP7wW7leR6A2YOZR9ZjSLBFeDM+jVoxvMKIAgYRwtIhSsv3fsBWwtW7v8
         iVEpUE1vivRUQLUU+V/swPhHJ03ZwLTfo8W0RZHCF29vHSE8ZfcSMAqgY2lCIq+sYq3L
         m8iojozzFaRHQFyUneCriebUKkeuQscHqrw0vawKw8JKI4GcOdYIMgx6bGzWMR/l1agT
         U5Sg==
X-Gm-Message-State: ACgBeo1TqFYD9ClLdt6fPLZHrIifnm6QgArS9jsPCjvgjUECv5tLKYzl
        Re/uh8w1Dmh9cdUTAbicI6G/tMKpWGYZTyhlJe4=
X-Google-Smtp-Source: AA6agR7TYmo2hRoRye/NU6zw9DlbDzzcDfGDvg42qQPFE4KPJ9gkX5bDlDsNLao/Q35j4MTgqGr7JzgbfsJrP7gpW/0=
X-Received: by 2002:a05:6512:314e:b0:48c:9d5a:2e79 with SMTP id
 s14-20020a056512314e00b0048c9d5a2e79mr870894lfi.538.1660823413345; Thu, 18
 Aug 2022 04:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
 <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org> <CAMWRUK4Mo2KHfa-6Z4Ka+ZLx8TtmzSvq9CLmMmEwE5S7Yp7-Kw@mail.gmail.com>
 <34228958-081d-52b5-f363-d2df6ecf251d@blackwall.org>
In-Reply-To: <34228958-081d-52b5-f363-d2df6ecf251d@blackwall.org>
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Date:   Thu, 18 Aug 2022 07:50:02 -0400
Message-ID: <CAMWRUK43+NG63J2YCiKijREjUg5zjii=_2knN6ZCL6PHMP3q8w@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 14, 2022 at 3:38 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 12/08/2022 18:30, Sevinj Aghayeva wrote:
> > On Wed, Aug 10, 2022 at 4:54 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
> >>
> >> On 10/08/2022 06:11, Sevinj Aghayeva wrote:
> >>> When bridge binding is enabled for a vlan interface, it is expected
> >>> that the link state of the vlan interface will track the subset of the
> >>> ports that are also members of the corresponding vlan, rather than
> >>> that of all ports.
> >>>
> >>> Currently, this feature works as expected when a vlan interface is
> >>> created with bridge binding enabled:
> >>>
> >>>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
> >>>         bridge_binding on
> >>>
> >>> However, the feature does not work when a vlan interface is created
> >>> with bridge binding disabled, and then enabled later:
> >>>
> >>>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
> >>>         bridge_binding off
> >>>   ip link set vlan10 type vlan bridge_binding on
> >>>
> >>> After these two commands, the link state of the vlan interface
> >>> continues to track that of all ports, which is inconsistent and
> >>> confusing to users. This series fixes this bug and introduces two
> >>> tests for the valid behavior.
> >>>
> >>> Sevinj Aghayeva (3):
> >>>   net: core: export call_netdevice_notifiers_info
> >>>   net: 8021q: fix bridge binding behavior for vlan interfaces
> >>>   selftests: net: tests for bridge binding behavior
> >>>
> >>>  include/linux/netdevice.h                     |   2 +
> >>>  net/8021q/vlan.h                              |   2 +-
> >>>  net/8021q/vlan_dev.c                          |  25 ++-
> >>>  net/core/dev.c                                |   7 +-
> >>>  tools/testing/selftests/net/Makefile          |   1 +
> >>>  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
> >>>  6 files changed, 172 insertions(+), 8 deletions(-)
> >>>  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
> >>>
> >>
> >> Hi,
> >> NETDEV_CHANGE event is already propagated when the vlan changes flags,
> >> NETDEV_CHANGEUPPER is used when the devices' relationship changes not their flags.
> >> The only problem you have to figure out is that the flag has changed. The fix itself
> >> must be done within the bridge, not 8021q. You can figure it out based on current bridge
> >> loose binding state and the vlan's changed state, again in the bridge's NETDEV_CHANGE
> >> handler. Unfortunately the proper fix is much more involved and will need new
> >> infra, you'll have to track the loose binding vlans in the bridge. To do that you should
> >> add logic that reflects the current vlans' loose binding state *only* for vlans that also
> >> exist in the bridge, the rest which are upper should be carrier off if they have the loose
> >> binding flag set.
> >>
> >> Alternatively you can add a new NETDEV_ notifier (using something similar to struct netdev_notifier_pre_changeaddr_info)
> >> and add link type-specific space (e.g. union of link type-specific structs) in the struct which will contain
> >> what changed for 8021q and will be properly interpreted by the bridge. The downside is that we'll generate
> >> 2 notifications when changing the loose binding flag, but on the bright side won't have to track anything
> >> in the bridge, just handle the new notifier type. This might be the easiest path, the fix is still in
> >> the bridge though, the 8021q module just needs to fill in the new struct and emit the notification on
> >> any loose binding changes, the bridge must decide if it should process it (i.e. based on upper/lower
> >> relationship). Such notifier can be also re-used by other link types to propagate link-type specific
> >> changes.
>
> Hi,
>
> >
> > Hi Nik,
> >
> > Can you please clarify the following?
> >
> > 1) should the new NETDEV_ notifier be about the vlan device and not
> > the bridge? That is, should I handle it in br_device_event?
>
> Yes, it should be about the vlan device (i.e. the target device that changes its state).

Hi Nik,

I implemented this and tried to handle NETDEV_CHANGE_DETAILS in
br_device_event, but there's a check there that performs early return
if the device is not a bridge port:

https://github.com/torvalds/linux/blob/master/net/bridge/br.c#L55-L57

Should I add a new function before that check, e.g.
br_vlan_device_event, and handle vlan device events there, similar to
br_vlan_bridge_event? Or do you have a better idea?

Thanks

>
> > 2) is it still okay to export call_netdevice_notifiers_info or should
> > i write a new function for this?
> >
>
> If you need it, export it. But if you do it similar to netdev_notifier_pre_changeaddr_info
> then you don't have to, more below.
>
> > The answers to the above wasn't clear to me, but I came up with the
> > following patch anyway, so perhaps you can also comment on it. I'm
> > pasting it inline; this is against 5.19.
> >
>
> A few comments inline below,
>
> > Thanks!
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 2563d30736e9..c63205eb1f72 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -2762,6 +2762,7 @@ enum netdev_cmd {
> >   NETDEV_UNREGISTER,
> >   NETDEV_CHANGEMTU, /* notify after mtu change happened */
> >   NETDEV_CHANGEADDR, /* notify after the address change */
> > + NETDEV_CHANGEUPPERFLAGS,
>
> Please don't use CHANGEUPPER, that is about a device changing its
> upper device. Also make it more generic, NETDEV_CHANGEFLAGS is too
> specific. For example today we have NETDEV_CHANGEINFODATA which TBH
> sounds good, but is tied to bonding in a few places, e.g.:
>         case NETDEV_CHANGEINFODATA:
>                 rtnl_event_type = IFLA_EVENT_BONDING_OPTIONS;
>
> which is very unfortunate. We really need a generic notifier that can pass
> link-type specific information alongside the device. As I mentioned please
> see how netdev_notifier_pre_changeaddr_info is handled, we need something
> generic that extends netdev_notifier_info and the various link types can add
> their own structures in a union which is to be interpreted based on the link
> type. For example if the new notifier is called NETDEV_CHANGE_DETAILS then
> in the bridge we'll check if the target device is a vlan and interpret the
> structure's union as the vlan change information. It'd be nice to get more
> feedback about this from others as well.
>
> Also note that this notifier is for internal use for the time being so it's not necessary
> to export these notifications to user-space yet.
>
> I would've opted for extending NETDEV_CHANGE itself, but that would be quite the
> adventure. :)
>
> >   NETDEV_PRE_CHANGEADDR, /* notify before the address change */
> >   NETDEV_GOING_DOWN,
> >   NETDEV_CHANGENAME,
> > @@ -2837,6 +2838,12 @@ struct netdev_notifier_changelowerstate_info {
> >   void *lower_state_info; /* is lower dev state */
> >  };
> >
> > +struct netdev_notifier_changeupperflags_info {
> > + struct netdev_notifier_info info; /* must be first */
> > + struct net_device *upper_dev;
>
> just dev, not upper
> we should be able to use this construct for any link type and actually
> we don't need the device here, we already have it in info.dev
>
> > + bool vlan_bridge_binding;
>
> add this into a vlan-specific structure that should be in a union here so
> other link types can add their own later
>
> > +};
> > +
> >  struct netdev_notifier_pre_changeaddr_info {
> >   struct netdev_notifier_info info; /* must be first */
> >   const unsigned char *dev_addr;
> > @@ -2898,6 +2905,8 @@ netdev_notifier_info_to_extack(const struct
> > netdev_notifier_info *info)
> >  }
> >
> >  int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
> > +int call_netdevice_notifiers_info(unsigned long val,
> > +  struct netdev_notifier_info *info);
>
> No need for this if you handle notifications similar to dev_pre_changeaddr_notify()
> with netdev_notifier_pre_changeaddr_info
>
> >
> >
> >  extern rwlock_t dev_base_lock; /* Device list lock */
> > diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
> > index 5eaf38875554..71947cdcfaaa 100644
> > --- a/net/8021q/vlan.h
> > +++ b/net/8021q/vlan.h
> > @@ -130,7 +130,7 @@ void vlan_dev_set_ingress_priority(const struct
> > net_device *dev,
> >  int vlan_dev_set_egress_priority(const struct net_device *dev,
> >   u32 skb_prio, u16 vlan_prio);
> >  void vlan_dev_free_egress_priority(const struct net_device *dev);
> > -int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
> > +int vlan_dev_change_flags(struct net_device *dev, u32 flag, u32 mask);
> >  void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
> >         size_t size);
> >
> > diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> > index 839f2020b015..68da3901dfb0 100644
> > --- a/net/8021q/vlan_dev.c
> > +++ b/net/8021q/vlan_dev.c
> > @@ -208,11 +208,18 @@ int vlan_dev_set_egress_priority(const struct
> > net_device *dev,
> >   return 0;
> >  }
> >
> > +static inline bool netif_is_bridge(const struct net_device *dev)
>
> no inline in .c files, let the compiler decide
>
> > +{
> > + return dev->rtnl_link_ops &&
> > +    !strcmp(dev->rtnl_link_ops->kind, "bridge");
> > +}
> > +
>
> there is already netif_is_bridge_master()
>
> >  /* Flags are defined in the vlan_flags enum in
> >   * include/uapi/linux/if_vlan.h file.
> >   */
> > -int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
> > +int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
> >  {
> > + struct netdev_notifier_changeupperflags_info info;
> >   struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
> >   u32 old_flags = vlan->flags;
> >
> > @@ -223,19 +230,33 @@ int vlan_dev_change_flags(const struct
> > net_device *dev, u32 flags, u32 mask)
> >
> >   vlan->flags = (old_flags & ~mask) | (flags & mask);
> >
> > - if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
> > + if (!netif_running(dev))
> > + return 0;
> > +
> > + if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
> >   if (vlan->flags & VLAN_FLAG_GVRP)
> >   vlan_gvrp_request_join(dev);
> >   else
> >   vlan_gvrp_request_leave(dev);
> >   }
> >
> > - if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
> > + if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
> >   if (vlan->flags & VLAN_FLAG_MVRP)
> >   vlan_mvrp_request_join(dev);
> >   else
> >   vlan_mvrp_request_leave(dev);
> >   }
> > +
> > + if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
> > +    netif_is_bridge(vlan->real_dev)) {
> > + info.info.dev = vlan->real_dev;
> > + info.upper_dev = dev;
> > + info.vlan_bridge_binding =
> > +    !!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING);
> > + call_netdevice_notifiers_info(NETDEV_CHANGEUPPERFLAGS,
> > +    &info.info);
> > + }
> > +
> >   return 0;
> >  }
> >
> > diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> > index 0f5e75ccac79..cbcb0877d4a4 100644
> > --- a/net/bridge/br_vlan.c
> > +++ b/net/bridge/br_vlan.c
> > @@ -1718,6 +1718,7 @@ static void nbp_vlan_set_vlan_dev_state(struct
> > net_bridge_port *p, u16 vid)
> >  /* Must be protected by RTNL. */
> >  int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
> > void *ptr)
> >  {
> > + struct netdev_notifier_changeupperflags_info *flags_info;
> >   struct netdev_notifier_changeupper_info *info;
> >   struct net_bridge *br = netdev_priv(dev);
> >   int vlcmd = 0, ret = 0;
> > @@ -1739,7 +1740,11 @@ int br_vlan_bridge_event(struct net_device
> > *dev, unsigned long event, void *ptr)
> >   info = ptr;
> >   br_vlan_upper_change(dev, info->upper_dev, info->linking);
> >   break;
> > -
> > + case NETDEV_CHANGEUPPERFLAGS:
> > + flags_info = ptr;
> > + br_vlan_upper_change(dev, flags_info->upper_dev,
> > +    flags_info->vlan_bridge_binding);
> > + break;
> >   case NETDEV_CHANGE:
> >   case NETDEV_UP:
> >   if (!br_opt_get(br, BROPT_VLAN_BRIDGE_BINDING))
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 30a1603a7225..bc8640d77d83 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -160,8 +160,6 @@ struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
> >  struct list_head ptype_all __read_mostly; /* Taps */
> >
> >  static int netif_rx_internal(struct sk_buff *skb);
> > -static int call_netdevice_notifiers_info(unsigned long val,
> > - struct netdev_notifier_info *info);
> >  static int call_netdevice_notifiers_extack(unsigned long val,
> >     struct net_device *dev,
> >     struct netlink_ext_ack *extack);
> > @@ -1624,7 +1622,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
> >   N(POST_INIT) N(RELEASE) N(NOTIFY_PEERS) N(JOIN) N(CHANGEUPPER)
> >   N(RESEND_IGMP) N(PRECHANGEMTU) N(CHANGEINFODATA) N(BONDING_INFO)
> >   N(PRECHANGEUPPER) N(CHANGELOWERSTATE) N(UDP_TUNNEL_PUSH_INFO)
> > - N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
> > + N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN) N(CHANGEUPPERFLAGS)
> >   N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
> >   N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
> >   N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
> > @@ -1927,8 +1925,8 @@ static void
> > move_netdevice_notifiers_dev_net(struct net_device *dev,
> >   * are as for raw_notifier_call_chain().
> >   */
> >
> > -static int call_netdevice_notifiers_info(unsigned long val,
> > - struct netdev_notifier_info *info)
> > +int call_netdevice_notifiers_info(unsigned long val,
> > +  struct netdev_notifier_info *info)
> >  {
> >   struct net *net = dev_net(info->dev);
> >   int ret;
> > @@ -1944,6 +1942,7 @@ static int
> > call_netdevice_notifiers_info(unsigned long val,
> >   return ret;
> >   return raw_notifier_call_chain(&netdev_chain, val, info);
> >  }
> > +EXPORT_SYMBOL(call_netdevice_notifiers_info);
> >
> >  /**
> >   * call_netdevice_notifiers_info_robust - call per-netns notifier blocks
> >
> >
> >>
> >> Both of these avoid any direct dependencies between the bridge and 8021q. Any other suggestions that
> >> are simpler, avoid direct dependencies and solve the issue in a generic way would be appreciated.
> >>
> >> Just be careful about introducing too much unnecessary processing because we
> >> can have lots of vlan devices in a system.
> >>
> >> Cheers,
> >>  Nik
> >
> >
> >
>


-- 

Sevinj.Aghayeva
