Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4B159BAC7
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiHVIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiHVIBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:01:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87752B1A2
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:01:53 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a22so12764965edj.5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=zmWJBppFs4jf3CI+TolXkskhhFJP1MDvf3fkZZOTeTo=;
        b=NnCxrcAZz4yEZx/RZrxJi1YRxlUa5j4wySP8FoIkI/1cnD3uXVda95UMuxGNwMEn8p
         ltilsvaDQZWEdQOBwDDw0pInlqNvYq3pib9n1eoShus1EM58Z27bLWBreMnfwIVFSOfx
         inRYRixb3OQYGrQ1mlP/k9bgHob7mZqwtuPHxeVr1LDFoXOWpoEW0jbjhrKcbFUWE3vW
         Pq6DAu6ezJRSLGGVbqwpSadlGfKpx7fPlVtdfmYBkctEeMJ4a3NpblG5wqY9/TncuMWH
         n5Lf6tSGn2tSvlO3SXjMVVFWsh0qAcx82NPXKApDg/3VPS8PFLBt38vS34+hEj7mnYdq
         lf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=zmWJBppFs4jf3CI+TolXkskhhFJP1MDvf3fkZZOTeTo=;
        b=GcEW/nSQUtgP3Wm49xZGhzlJVwIdCI2+aswIUXIBvfRwHYICPPPZYk/7mcAZLtXVTd
         dg9MemC5g4bYtlEsC4BO9a5bwbRPeqwpm0Kq/nnilnTPdKVQg5F8vmuRIrOc+LdJjnGl
         A5bTVRy4hyZelutcrO5rOgw4b1UsC4XygWNzQSRvzYPHRhiLrNYwA7Bm1VwxVluZe4DH
         3eJZaRsaaT0Hrcz7JsKcdM1QML08K1VohYj06y/gWqAT2OMLH1+XlTzbf8G2Tfj3CR6C
         W7nclpZd3MhpbORPJ391ZnaG/jdQ5bqU/EbQvlGwkJjxe3GN4Yrt3y3wQXmFd5gmJptL
         7n1g==
X-Gm-Message-State: ACgBeo1Gc1mD3WKECsDjcTHrcoyCwk3VBRTzX0gB1DrfiHAODt8vXLUa
        YxqPgt6JMyI+jnl19J1sMI0vCw==
X-Google-Smtp-Source: AA6agR7NeoWcIDcDxxnrfJObXjcXCmMFnOxudHUMiTKn7UtA0DwLk5D/9py8TIX8jg8gdScTnWAfKw==
X-Received: by 2002:a05:6402:d05:b0:435:b2a6:94eb with SMTP id eb5-20020a0564020d0500b00435b2a694ebmr15115795edb.87.1661155310221;
        Mon, 22 Aug 2022 01:01:50 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090643c900b00730b61d8a5esm5740578ejn.61.2022.08.22.01.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 01:01:49 -0700 (PDT)
Message-ID: <601ac27e-b1b1-43c0-34fd-15cdc2224d85@blackwall.org>
Date:   Mon, 22 Aug 2022 11:01:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior
 and add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Cc:     netdev@vger.kernel.org, aroulin@nvidia.com, sbrivio@redhat.com,
        roopa@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
 <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org>
 <CAMWRUK4Mo2KHfa-6Z4Ka+ZLx8TtmzSvq9CLmMmEwE5S7Yp7-Kw@mail.gmail.com>
 <34228958-081d-52b5-f363-d2df6ecf251d@blackwall.org>
 <CAMWRUK43+NG63J2YCiKijREjUg5zjii=_2knN6ZCL6PHMP3q8w@mail.gmail.com>
 <46deef15-a67b-91ad-bc47-1b1306d1d654@blackwall.org>
 <CAMWRUK6BQpABuutUwaX36rmQsfuJShQbDjyjSdfDawrQ=pcvaA@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAMWRUK6BQpABuutUwaX36rmQsfuJShQbDjyjSdfDawrQ=pcvaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2022 14:33, Sevinj Aghayeva wrote:
> On Thu, Aug 18, 2022 at 8:00 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>
>> On 18/08/2022 14:50, Sevinj Aghayeva wrote:
[snip]
>>
>> Hi,
>> Handling all vlan device-related changes in br_vlan_device_event() sounds good to me.
>> Please add it to br_vlan.c.
> 
> Hi Nik,
> 
> Can you please review this diff before I make it into a proper patchset? Thanks!
> 

Hi,
A few comments inline below, but in general when you prepare the rfc commit please
explain the motivation in detail why this way was chosen and a new notification type
is needed (e.g. why not use NETDEV_CHANGEINFODATA or extend NETDEV_CHANGE).
As I mentioned earlier it'd be nice to get feedback from others about adding this
new notification, so they should know the "why" in detail.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 2563d30736e9..0ce3da42325e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2762,6 +2762,7 @@ enum netdev_cmd {
>   NETDEV_UNREGISTER,
>   NETDEV_CHANGEMTU, /* notify after mtu change happened */
>   NETDEV_CHANGEADDR, /* notify after the address change */
> + NETDEV_CHANGE_DETAILS,
>   NETDEV_PRE_CHANGEADDR, /* notify before the address change */
>   NETDEV_GOING_DOWN,
>   NETDEV_CHANGENAME,
> @@ -2837,6 +2838,13 @@ struct netdev_notifier_changelowerstate_info {
>   void *lower_state_info; /* is lower dev state */
>  };
> 
> +struct netdev_notifier_change_details_info {
> + struct netdev_notifier_info info; /* must be first */
> + union {
> + bool bridge_binding;

this should be in a vlan-specific structure, defined in if_vlan.h
every other link type which wants to use the notification would define its
own struct type

> + } details;
> +};
> +
>  struct netdev_notifier_pre_changeaddr_info {
>   struct netdev_notifier_info info; /* must be first */
>   const unsigned char *dev_addr;
> @@ -3836,6 +3844,8 @@ int __dev_set_mtu(struct net_device *, int);
>  int dev_set_mtu(struct net_device *, int);
>  int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
>         struct netlink_ext_ack *extack);
> +int dev_change_details_notify(struct net_device *dev, bool bridge_binding,
> +       struct netlink_ext_ack *extack);

this helper is not needed

>  int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
>   struct netlink_ext_ack *extack);
>  int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
> index 5eaf38875554..71947cdcfaaa 100644
> --- a/net/8021q/vlan.h
> +++ b/net/8021q/vlan.h
> @@ -130,7 +130,7 @@ void vlan_dev_set_ingress_priority(const struct
> net_device *dev,
>  int vlan_dev_set_egress_priority(const struct net_device *dev,
>   u32 skb_prio, u16 vlan_prio);
>  void vlan_dev_free_egress_priority(const struct net_device *dev);
> -int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
> +int vlan_dev_change_flags(struct net_device *dev, u32 flag, u32 mask);
>  void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
>          size_t size);
> 
> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> index 839f2020b015..489baa8435de 100644
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -211,7 +211,7 @@ int vlan_dev_set_egress_priority(const struct
> net_device *dev,
>  /* Flags are defined in the vlan_flags enum in
>   * include/uapi/linux/if_vlan.h file.
>   */
> -int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
> +int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)

please don't remove the const, this function shouldn't change dev's struct

>  {
>   struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
>   u32 old_flags = vlan->flags;
> @@ -223,19 +223,29 @@ int vlan_dev_change_flags(const struct
> net_device *dev, u32 flags, u32 mask)
> 
>   vlan->flags = (old_flags & ~mask) | (flags & mask);
> 
> - if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
> + if (!netif_running(dev))
> + return 0;
> +
> + if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
>   if (vlan->flags & VLAN_FLAG_GVRP)
>   vlan_gvrp_request_join(dev);
>   else
>   vlan_gvrp_request_leave(dev);
>   }
> 
> - if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
> + if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
>   if (vlan->flags & VLAN_FLAG_MVRP)
>   vlan_mvrp_request_join(dev);
>   else
>   vlan_mvrp_request_leave(dev);
>   }
> +
> + if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
> +     netif_is_bridge_master(vlan->real_dev)) {
> + dev_change_details_notify(dev,
> +     !!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING), NULL);

this helper is not needed, just fill in the details here and send the notification

> + }
> +
>   return 0;
>  }
> 
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 96e91d69a9a8..62e939c6a3f0 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -51,6 +51,11 @@ static int br_device_event(struct notifier_block
> *unused, unsigned long event, v
>   }
>   }
> 
> + if (is_vlan_dev(dev)) {
> + br_vlan_device_event(dev, event, ptr);
> + return NOTIFY_DONE;
> + }
> +
>   /* not a port of a bridge */
>   p = br_port_get_rtnl(dev);
>   if (!p)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 06e5f6faa431..a9a08e49c76c 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1470,6 +1470,8 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
>  void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
>  int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
>   void *ptr);
> +void br_vlan_device_event(struct net_device *dev, unsigned long event,
> +   void *ptr);
>  void br_vlan_rtnl_init(void);
>  void br_vlan_rtnl_uninit(void);
>  void br_vlan_notify(const struct net_bridge *br,
> @@ -1701,6 +1703,11 @@ static inline int br_vlan_bridge_event(struct
> net_device *dev,
>   return 0;
>  }
> 
> +static void br_vlan_device_event(struct net_device *dev,
> + unsigned long event, void *ptr)
> +{
> +}
> +
>  static inline void br_vlan_rtnl_init(void)
>  {
>  }
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 0f5e75ccac79..70a9950df175 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1768,6 +1768,20 @@ void br_vlan_port_event(struct net_bridge_port
> *p, unsigned long event)
>   }
>  }
> 
> +void br_vlan_device_event(struct net_device *dev, unsigned long
> event, void *ptr)
> +{
> + struct netdev_notifier_change_details_info *info;
> + struct net_device *br_dev;
> +
> + switch (event) {
> + case NETDEV_CHANGE_DETAILS:
> + info = ptr;
> + br_dev = vlan_dev_priv(dev)->real_dev;

you're not guaranteed to have a bridge device as its real_dev, so you should
validate that the vlan's real dev is a bridge

> + br_vlan_upper_change(br_dev, dev, info->details.bridge_binding);
> + break;
> + }
> +}
> +
>  static bool br_vlan_stats_fill(struct sk_buff *skb,
>          const struct net_bridge_vlan *v)
>  {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 30a1603a7225..dcdbc625585d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1624,7 +1624,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
>   N(POST_INIT) N(RELEASE) N(NOTIFY_PEERS) N(JOIN) N(CHANGEUPPER)
>   N(RESEND_IGMP) N(PRECHANGEMTU) N(CHANGEINFODATA) N(BONDING_INFO)
>   N(PRECHANGEUPPER) N(CHANGELOWERSTATE) N(UDP_TUNNEL_PUSH_INFO)
> - N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
> + N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN) N(CHANGE_DETAILS)
>   N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
>   N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
>   N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
> @@ -8767,6 +8767,27 @@ int dev_pre_changeaddr_notify(struct net_device
> *dev, const char *addr,
>  }
>  EXPORT_SYMBOL(dev_pre_changeaddr_notify);
> 
> +/**
> + * dev_change_details_notify - Call NETDEV_PRE_CHANGE_DETAILS.
> + * @dev: device
> + * @bridge_binding: bridge binding setting
> + * @extack: netlink extended ack
> + */
> +int dev_change_details_notify(struct net_device *dev, bool bridge_binding,
> +       struct netlink_ext_ack *extack)
> +{
> + struct netdev_notifier_change_details_info info = {
> + .info.dev = dev,
> + .info.extack = extack,
> + .details.bridge_binding = bridge_binding,
> + };
> + int rc;
> +
> + rc = call_netdevice_notifiers_info(NETDEV_CHANGE_DETAILS, &info.info);
> + return notifier_to_errno(rc);
> +}
> +EXPORT_SYMBOL(dev_change_details_notify);
> +

this helper is unnecessary, just fill in the struct at the caller site and
send the notification directly

>  /**
>   * dev_set_mac_address - Change Media Access Control Address
>   * @dev: device
> 
> 
>>
>> Thanks,
>>  Nik
>>
>>

Cheers,
 Nik


