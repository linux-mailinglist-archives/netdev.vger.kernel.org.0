Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF78E36ECCF
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhD2O4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 10:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbhD2Oz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 10:55:57 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AADEC06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 07:55:09 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id c11so1342790lfi.9
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 07:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ozmC8r951jLL3NZOoRI0H0AZonB0eVQumQbYKyKKZaI=;
        b=inY9ZxoiVttgUDK85aetuU+8eWPCLxu2/cbyjqcMqovWlBdWYff0EAg8S1GQ5iwVWH
         6t4mtC8k6J0EsvwB+G/zA+InEZsRfgRQXHEDmxMW6AtP2xlWnMciJtd4Lh4hgGLx5K9Q
         3VLIFX5SPkatX8Qu3LPPI6f9AN5+2br3D6m0cwtAOwSSb/+3yLl2N+s+fGNEv5az3pW2
         vWrWF1bPRXleCmoB0J3sAblLg/X6GzqnVAIykBhZZkb9Jb50IKT24xd1yk3WMVgFbpc7
         bauO9Ni9/G5iLrb8F2uk/rYGwsEIiqHp/zd+9aKOgu4EF0Ifb6zBgs1dvGLVW4DUfsRg
         I02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ozmC8r951jLL3NZOoRI0H0AZonB0eVQumQbYKyKKZaI=;
        b=amF3M+Ra0qPG/RjVt0JnIpTeK5v5hhV6i9WbS719f8MG2cc8TyLlv2ZYrNHMmQ3pt2
         2SJ2N19uAfH/KwscSzqM28bZ5DjU3XO+cofPMU8xvdzP+dqv6NJDh/793KizhO0PO9SZ
         fVyQ1RxX4NGbYvmCwmAlLb8EzCKZQ9QSem1dq1Tkcc7L2NqWZi0MDAw/k2pkfmON+gG0
         r6cV7swa0Qh+kJ4cdScydc06Z2VARC8oEfKHK5DeLNJDYBvDn5iFWVQNmeI7+T31yabH
         9Wq2OygSfDZlllugTK+9SCtitwDlLyMjt1dHsr6wg6DXY5m96U6dAiRkjEfdWupHcKqG
         7FDg==
X-Gm-Message-State: AOAM532761XoAtC01rU1mreQ3xcqe5XUFSrnolbYUV8SKhKX4f5eX4qy
        CiapGObZ9bnZJL2RqrAlVnFFjQ==
X-Google-Smtp-Source: ABdhPJxOnYJ9izhBdpYyZZluy/c4h0ZaQOlSbG9FlrpFFMqG65zwQ9/kfxVQWOocsWs8t+fuAJqbLw==
X-Received: by 2002:a05:6512:3987:: with SMTP id j7mr24180821lfu.635.1619708107624;
        Thu, 29 Apr 2021 07:55:07 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r124sm3940lff.13.2021.04.29.07.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 07:55:07 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 4/9] net: bridge: switchdev: Forward offloading
In-Reply-To: <51e241f3-cd75-44a1-f4bf-4f040dae0d7c@nvidia.com>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-5-tobias@waldekranz.com> <ac177d80-6530-be48-95bc-57652a31fe6a@nvidia.com> <87tunqni1d.fsf@waldekranz.com> <51e241f3-cd75-44a1-f4bf-4f040dae0d7c@nvidia.com>
Date:   Thu, 29 Apr 2021 16:55:06 +0200
Message-ID: <87lf91nnsl.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 12:16, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> On 29/04/2021 01:47, Tobias Waldekranz wrote:
>> On Tue, Apr 27, 2021 at 13:35, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>>> On 26/04/2021 20:04, Tobias Waldekranz wrote:
>>>> Allow switchdevs to forward frames from the CPU in accordance with the
>>>> bridge configuration in the same way as is done between bridge
>>>> ports. This means that the bridge will only send a single skb towards
>>>> one of the ports under the switchdev's control, and expects the driver
>>>> to deliver the packet to all eligible ports in its domain.
>>>>
>>>> Primarily this improves the performance of multicast flows with
>>>> multiple subscribers, as it allows the hardware to perform the frame
>>>> replication.
>>>>
>>>> The basic flow between the driver and the bridge is as follows:
>>>>
>>>> - The switchdev accepts the offload by returning a non-null pointer
>>>>   from .ndo_dfwd_add_station when the port is added to the bridge.
>>>>
>>>> - The bridge sends offloadable skbs to one of the ports under the
>>>>   switchdev's control using dev_queue_xmit_accel.
>>>>
>>>> - The switchdev notices the offload by checking for a non-NULL
>>>>   "sb_dev" in the core's call to .ndo_select_queue.
>>>>
>>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>>> ---
>>>>  net/bridge/br_forward.c   | 11 +++++++-
>>>>  net/bridge/br_private.h   | 27 ++++++++++++++++++
>>>>  net/bridge/br_switchdev.c | 59 +++++++++++++++++++++++++++++++++++++--
>>>>  3 files changed, 93 insertions(+), 4 deletions(-)
>>>>
>>>
>>> Hi,
>>> Please try to find a way to reduce the number of new tests in the fast path.
>>> This specific feature might help these devices, but the new tests hurt everybody else.
>>> I don't mind the control plane changes, but I'd like to minimize the fast-path impact.
>> 
>> Wholeheartedly agree.
>> 
>>> Do you need "accel_priv" to be a pointer, I mean can't derive sb_dev from the port alone ?
>>> Either way - you can mark the port via its internal flags if it can accelerate, those are
>>> used frequently and are in a hot cache line (by the way that reminds me that the port
>>> offload mark/hwdom should be moved in the first cache line).
>> 
>> I need to stash accel_priv somewhere as .ndo_dfwd_del_station expects it
>> sent back when unregistering the offload. But there is no need for it to
>> be part of the fast-path. Would it be ok to add a BR_FORWARD_OFFLOAD to
>> p->flags, which would be used in the fast-path, while also keeping
>> accel_priv on the port, but on a colder line?
>> 
>
> About the flag - yes, that is what I'm proposing. Use an internal port flag for it
> and for the tests.
>
> About the pointer - it is certainly not appropriate to use net_bridge_port for a void pointer
> coming in from a driver or external place. I see that it's always the bridge device so can
> we just compare the result of the add op to the bridge dev and set only the flag based on it?
> Then on the del path if the flag is set we know it's the bridge and use it as sb_dev.

I am not an expert on this API, but I believe that the returned pointer
is supposed to be treated as an opaque cookie that the driver can use to
associate with anything it likes. On mv88e6xxx I saw no need for it, so
I just returned the device pointer to indicate success. But other
drivers might have use of it if we add a getter - similar to
macvlan_accel_priv.

Now that I think of it, the DSA tagger might also benefit from it. It
would avoid lots of pointer chasing on egress. I will probably try this
out in v1 and see what you think.

>>> For example you could possibly drop fwd_accel, add the bitmap in a union with sb_dev pointer
>>> in br_input_skb_cb which can be set at __br_forward at the accel check and pass it down to
>>> avoid the final test.
>> 
>> Great idea! I will add it in v1.
>> 
> Actually you can also use a static key to avoid all checks and effects of this feature on
> the bridge fast-path. You can enable it when the first device that can accelerate shows
> up and disable it when the last one leaves.

That would be great. Never used the static key stuff before, but it
looks pretty straightforward. These are always global, right?  Since you
rewrite the actual .text when you toggle the keys? So it would have to
be enabled as soon as an offloadable port joins any bridge in the
system. Anyway, I will read up on it and add it in v1.

> By the way __br_forward() can take one more argument (sb_dev) and always set it because
> that cache line is dirty anyway due to the tstamp zeroing, but that doesn't matter if
> static keys are used. Just noting it. :)
>
>>> Furthermore since the hwdoms are bits and if the port accel is a bit
>>> you could probably reduce the nbp_switchdev_can_accel() helper to one test with a few bitops.
>> 
>> Not sure I follow. The current code has two tests:
>> 
>> 1. Is offloading enabled on the port. (To be done using p->flags in v1)
>> 2. Is offloading allowed for this frame to this port.
>> 
>> The port can be part of a hwdom that does not support forward
>> offloading; indeed only one driver would support it initially. So how do
>> I avoid having to test the conditions individually?
>> 
>
> Coming to think of it with the port bit test first it should be fine.
>
>
> For the sake of fun here's one way that can turn it into one test,
> obviously I haven't tested anything:
>  - reserve a few most significant bits of hwdom as "feature" bits, say 4
>  - add a "feature" bit which encodes ability to accelerate
>  => test becomes p->hwdom | (src_hwdom & hwdom_bitmask) > (accel feature bit) | p->hwdom
> It's very hacky and _not_ to be used. :)

I stand corrected - and in awe :)

>>> In nbp_switchdev_allowed_egress() I'd make the hwdom tests rely on skb's offload_fwd_mark
>>> so in the software forwarding case we could avoid them.
>> 
>> Flipping the left and right side of the expression is possible, but I
>> think that would only impact the case where the frame is _not_ allowed
>> to egress. Is that what you mean? Otherwise you still need to test for
>> the condition that we have forwarded to this port's hwdom already, to
>> avoid sending duplicates on the wire. This is independent of
>> skb->offload_fwd_mark as both Rx-offloaded and non-Rx-offloaded frames
>> can still be Tx-offloaded to other hwdoms.
>> 
>> A typical example would be a broadcast frame ingressing the bridge from
>> eth0 in the figure from the cover letter. skb->offload_fwd_mark would
>> always be 0, but you still need to test fwd_hwdoms to skip over swp{1,2}
>> after you have sent the skb to swp0.
>> 
>
> Yeah, you're right I was still thinking only of offloaded skbs, didn't consider
> mixing the two.
>
>>> I might be missing something above, but we have to try and reduce these tests as much as
>>> possible, also the port's first cache line is quite crowded so avoiding any new fields
>>> would be best, i.e. at some point we'll move the hwdom/offload mark there to avoid pulling
>>> in the last cache line of net_bridge_port, so it'd be best to avoid having to move accel_priv
>>> there too.
>>>
>>> Cheers,
>>>  Nik
>>>
>>>> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
>>>> index 6e9b049ae521..b4fb3b0bb1ec 100644
>>>> --- a/net/bridge/br_forward.c
>>>> +++ b/net/bridge/br_forward.c
>>>> @@ -32,6 +32,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
>>>>  
>>>>  int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>>>>  {
>>>> +	struct net_device *sb_dev = NULL;
>>>> +
>>>>  	skb_push(skb, ETH_HLEN);
>>>>  	if (!is_skb_forwardable(skb->dev, skb))
>>>>  		goto drop;
>>>> @@ -48,7 +50,10 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
>>>>  		skb_set_network_header(skb, depth);
>>>>  	}
>>>>  
>>>> -	dev_queue_xmit(skb);
>>>> +	if (br_switchdev_accels_skb(skb))
>>>> +		sb_dev = BR_INPUT_SKB_CB(skb)->brdev;
>>>> +
>>>> +	dev_queue_xmit_accel(skb, sb_dev);
>>>>  
>>>>  	return 0;
>>>>  
>>>> @@ -105,6 +110,8 @@ static void __br_forward(const struct net_bridge_port *to,
>>>>  		indev = NULL;
>>>>  	}
>>>>  
>>>> +	nbp_switchdev_frame_mark_accel(to, skb);
>>>> +
>>>>  	NF_HOOK(NFPROTO_BRIDGE, br_hook,
>>>>  		net, NULL, skb, indev, skb->dev,
>>>>  		br_forward_finish);
>>>> @@ -174,6 +181,8 @@ static struct net_bridge_port *maybe_deliver(
>>>>  	if (!should_deliver(p, skb))
>>>>  		return prev;
>>>>  
>>>> +	nbp_switchdev_frame_mark_fwd(p, skb);
>>>> +
>>>>  	if (!prev)
>>>>  		goto out;
>>>>  
>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>> index aba92864d285..933e951b0d7a 100644
>>>> --- a/net/bridge/br_private.h
>>>> +++ b/net/bridge/br_private.h
>>>> @@ -332,6 +332,7 @@ struct net_bridge_port {
>>>>  #endif
>>>>  #ifdef CONFIG_NET_SWITCHDEV
>>>>  	int				hwdom;
>>>> +	void				*accel_priv;
>>>>  #endif
>>>>  	u16				group_fwd_mask;
>>>>  	u16				backup_redirected_cnt;
>>>> @@ -506,7 +507,9 @@ struct br_input_skb_cb {
>>>>  #endif
>>>>  
>>>>  #ifdef CONFIG_NET_SWITCHDEV
>>>> +	u8 fwd_accel:1;
>>>>  	int src_hwdom;
>>>> +	br_hwdom_map_t fwd_hwdoms;
>>>>  #endif
>>>>  };
>>>>  
>>>> @@ -1597,6 +1600,15 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
>>>>  
>>>>  /* br_switchdev.c */
>>>>  #ifdef CONFIG_NET_SWITCHDEV
>>>> +static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
>>>> +{
>>>> +	return BR_INPUT_SKB_CB(skb)->fwd_accel;
>>>> +}
>>>> +
>>>> +void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
>>>> +				    struct sk_buff *skb);
>>>> +void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
>>>> +				  struct sk_buff *skb);
>>>>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>>  			      struct sk_buff *skb);
>>>>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>>>> @@ -1619,6 +1631,21 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
>>>>  	skb->offload_fwd_mark = 0;
>>>>  }
>>>>  #else
>>>> +static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
>>>> +{
>>>> +	return false;
>>>> +}
>>>> +
>>>> +static inline void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
>>>> +						  struct sk_buff *skb)
>>>> +{
>>>> +}
>>>> +
>>>> +static inline void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
>>>> +						struct sk_buff *skb)
>>>> +{
>>>> +}
>>>> +
>>>>  static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>>  					    struct sk_buff *skb)
>>>>  {
>>>> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
>>>> index 54bd7205bfb5..c903171ad291 100644
>>>> --- a/net/bridge/br_switchdev.c
>>>> +++ b/net/bridge/br_switchdev.c
>>>> @@ -8,6 +8,26 @@
>>>>  
>>>>  #include "br_private.h"
>>>>  
>>>> +static bool nbp_switchdev_can_accel(const struct net_bridge_port *p,
>>>> +				    const struct sk_buff *skb)
>>>> +{
>>>> +	return p->accel_priv && (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
>>>> +}
>>>> +
>>>> +void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
>>>> +				    struct sk_buff *skb)
>>>> +{
>>>> +	if (nbp_switchdev_can_accel(p, skb))
>>>> +		BR_INPUT_SKB_CB(skb)->fwd_accel = true;
>>>> +}
>>>> +
>>>> +void  (const struct net_bridge_port *p,
>>>> +				  struct sk_buff *skb)
>>>> +{
>>>> +	if (nbp_switchdev_can_accel(p, skb))
>>>> +		set_bit(p->hwdom, BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
>>>> +}
>>>> +
>>>>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>>  			      struct sk_buff *skb)
>>>>  {
>>>> @@ -18,8 +38,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>>>>  				  const struct sk_buff *skb)
>>>>  {
>>>> -	return !skb->offload_fwd_mark ||
>>>> -	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
>>>> +	struct br_input_skb_cb *cb = BR_INPUT_SKB_CB(skb);
>>>> +
>>>> +	return !test_bit(p->hwdom, cb->fwd_hwdoms) &&
>>>> +		(!skb->offload_fwd_mark || cb->src_hwdom != p->hwdom);
>>>>  }
>>>>  
>>>>  /* Flags that can be offloaded to hardware */
>>>> @@ -125,6 +147,27 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
>>>>  	return switchdev_port_obj_del(dev, &v.obj);
>>>>  }
>>>>  
>>>> +static void nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
>>>> +{
>>>> +	void *priv;
>>>> +
>>>> +	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
>>>> +		return;
>>>> +
>>>> +	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);
>>>> +	if (!IS_ERR_OR_NULL(priv))
>>>> +		p->accel_priv = priv;
>>>> +}
>>>> +
>>>> +static void nbp_switchdev_fwd_offload_del(struct net_bridge_port *p)
>>>> +{
>>>> +	if (!p->accel_priv)
>>>> +		return;
>>>> +
>>>> +	p->dev->netdev_ops->ndo_dfwd_del_station(p->dev, p->accel_priv);
>>>> +	p->accel_priv = NULL;
>>>> +}
>>>> +
>>>>  static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
>>>>  {
>>>>  	struct net_bridge *br = joining->br;
>>>> @@ -176,13 +219,23 @@ int nbp_switchdev_add(struct net_bridge_port *p)
>>>>  		return err;
>>>>  	}
>>>>  
>>>> -	return nbp_switchdev_hwdom_set(p);
>>>> +	err = nbp_switchdev_hwdom_set(p);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>> +	if (p->hwdom)
>>>> +		nbp_switchdev_fwd_offload_add(p);
>>>> +
>>>> +	return 0;
>>>>  }
>>>>  
>>>>  void nbp_switchdev_del(struct net_bridge_port *p)
>>>>  {
>>>>  	ASSERT_RTNL();
>>>>  
>>>> +	if (p->accel_priv)
>>>> +		nbp_switchdev_fwd_offload_del(p);
>>>> +
>>>>  	if (p->hwdom)
>>>>  		nbp_switchdev_hwdom_put(p);
>>>>  }
>>>>
