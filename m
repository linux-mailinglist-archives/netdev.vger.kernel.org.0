Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78B6127B26
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfLTMhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:37:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51435 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727269AbfLTMhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576845458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tej/n4A7UHRnvHhgibQAxYCuLBCu3uUQkoxEy/wczjQ=;
        b=d7zTI3NPIuH71A3zRRqn7rmdXbdPlMzQowk2VsZ9idRGxFWsnJIQ3RnN2jMb75Phn91JWB
        BPP+w+7D7UC7yDegO9wtmVfCsqQv+eTsA9y5xnRrUM4c+gH08YmWD5g3e+ZEZmDYKJBw0y
        iPD0lcy/49XROFIsKwahyIxyC1+HG1o=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-I9wnPQk5NX2zJXUOi9oEEw-1; Fri, 20 Dec 2019 07:37:37 -0500
X-MC-Unique: I9wnPQk5NX2zJXUOi9oEEw-1
Received: by mail-lf1-f72.google.com with SMTP id t8so805316lfc.21
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tej/n4A7UHRnvHhgibQAxYCuLBCu3uUQkoxEy/wczjQ=;
        b=KlqoWdyDusKPF+p4hpgRWu98N3wwB8hwMD/mVUob7PWkjlKM1yGurfP6rnbmx2Od+R
         Pu3ncEliuXvFTN+d+ywRUkxcyFGLIvyNPMeRS8CKcjzOB7V30wvk3ZgWcRM2xGpsQU1X
         emgm0csBU5K1GE0qXnRYYphUOgaMlXwS1f7IBkcVT4iyLVPYKbgVBZfnOphKwBk1yrQ7
         MbD+NGQ37IOsZux+fblwmZaVoqYnf6Z3sBPbFw3yZYKHhqqFFkEaJ3YKOTcRskQ4CBwY
         gySe84LiEN0AOR8SLFQiysqEC5VqWVA4pZ0PxWItWX2s0PYa7NoRLoVLKqicRjr7rIFo
         xuRg==
X-Gm-Message-State: APjAAAXgR/JBgk/N4whdNGZwxTiNabLsWRq4jBVxqpyz4Sl0ADKxQWq6
        qInXQkK4zu/MkyX9+PGCmQ5hYuu5Bhs4/vPtPKPMHOnjFhWJ/C+ufVUKicG8PibBv3B1+KDSb3F
        cLB7y3dynvRe7nZ35sRy98zegoVg5M90j
X-Received: by 2002:a2e:8651:: with SMTP id i17mr1302200ljj.121.1576845455804;
        Fri, 20 Dec 2019 04:37:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjcFwLWNXUWhpwZbSBTQMMtBvo1yLTIpd7B1ajcwgvUn0r3M/kG8StilrMXG5hkksOQ+A/qz6YwkFNsV2FPpg=
X-Received: by 2002:a2e:8651:: with SMTP id i17mr1302188ljj.121.1576845455600;
 Fri, 20 Dec 2019 04:37:35 -0800 (PST)
MIME-Version: 1.0
References: <20191217155102.46039-1-mcroce@redhat.com> <cf5b01f8-b4e4-90da-0ee7-b1d81ee6d342@cumulusnetworks.com>
In-Reply-To: <cf5b01f8-b4e4-90da-0ee7-b1d81ee6d342@cumulusnetworks.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 20 Dec 2019 13:36:59 +0100
Message-ID: <CAGnkfhxaT9_WL4UR8qurjBTkkdkuZFbfTQucLjoKOP-1eDEoTw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: add TTL decrement action
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>, ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 5:30 PM Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> On 17/12/2019 17:51, Matteo Croce wrote:
> > New action to decrement TTL instead of setting it to a fixed value.
> > This action will decrement the TTL and, in case of expired TTL, drop it
> > or execute an action passed via a nested attribute.
> > The default TTL expired action is to drop the packet.
> >
> > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> >
> > Tested with a corresponding change in the userspace:
> >
> >     # ovs-dpctl dump-flows
> >     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,1
> >     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,2
> >     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
> >     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
> >
> >     # ping -c1 192.168.0.2 -t 42
> >     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
> >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
> >     # ping -c1 192.168.0.2 -t 120
> >     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
> >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
> >     # ping -c1 192.168.0.2 -t 1
> >     #
> >
> > Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
> > Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  include/uapi/linux/openvswitch.h |  22 +++++++
> >  net/openvswitch/actions.c        |  71 +++++++++++++++++++++
> >  net/openvswitch/flow_netlink.c   | 105 +++++++++++++++++++++++++++++++
> >  3 files changed, 198 insertions(+)
> >
>
> Hi Matteo,
>
> [snip]
> > +}
> > +
> >  /* When 'last' is true, sample() should always consume the 'skb'.
> >   * Otherwise, sample() should keep 'skb' intact regardless what
> >   * actions are executed within sample().
> > @@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
> >                            nla_len(actions), last, clone_flow_key);
> >  }
> >
> > +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> > +{
> > +     int err;
> > +
> > +     if (skb->protocol == htons(ETH_P_IPV6)) {
> > +             struct ipv6hdr *nh = ipv6_hdr(skb);
> > +
> > +             err = skb_ensure_writable(skb, skb_network_offset(skb) +
> > +                                       sizeof(*nh));
>
> skb_ensure_writable() calls pskb_may_pull() which may reallocate so nh might become invalid.
> It seems the IPv4 version below is ok as the ptr is reloaded.
>

Right

> One q as I don't know ovs that much - can this action be called only with
> skb->protocol ==  ETH_P_IP/IPV6 ? I.e. Are we sure that if it's not v6, then it must be v4 ?
>

I'm adding a check in validate_and_copy_dec_ttl() so only ipv4/ipv6
packet will pass.

Thanks,

-- 
Matteo Croce
per aspera ad upstream

