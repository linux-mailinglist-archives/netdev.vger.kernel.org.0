Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E3410DD5
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 01:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhISXfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 19:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhISXfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 19:35:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36922C061574;
        Sun, 19 Sep 2021 16:33:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y8so14529366pfa.7;
        Sun, 19 Sep 2021 16:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VnTS+2gBOn9zmK09PKEGWQ2h0BtfZBmXwM4LvZZ5tNs=;
        b=RADgCXTtyIp8hlzuLC+OAJ8jXO3ltyQTzz373telbOm3ZBTd+49jtUVFU3lP0xC41O
         +4/ac7+uxP+aXf0cy3JZi1v9T/k7N08Zkv3s0QO630kGNGd7eknTfE1jQ0BaGLPnSLeU
         FcHBCUP7F77KGF4kzppssTVaxugVrnL1JoiIE7M1gVkD6TOw/kGi2JkDNGyanQIyNk06
         5WoV0/c+Z0SUtzc5teJBIbya6pm7sSharvvTc3upMX1iLxfzHOTFRM7vxZU30XrQZ8OO
         +0PiJpEr2NfoFSwwzTACuZfyhdkT92cqrgraHJhcLoIxxTYKnnxzD6opiRSmeFsDC4Dt
         Pg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VnTS+2gBOn9zmK09PKEGWQ2h0BtfZBmXwM4LvZZ5tNs=;
        b=Fra/9oF6EPtoF+2VkbKpGie8VCiXk8/KPsfLC1IIKrX4H1qOgp15CJjYp7UgyvbMU1
         xHI78MF4saxh48MHMS5hxLDc8C3Rl9xs4U9KuhWqNM+bbYWpneKbZ7+rykMpw58QOZB1
         DaHZMQeVEe/dz9udEAY1GR2LKFemdOQqg27+5mXYFbeHD3evjn++68lutqMYTTzxWtxC
         hrQGwlkodvKEjzzgy+ErJ3QghF393J8TT7nw8cSHP/Rdyhjix0c4LxH3RsVlWsOgXqru
         V8ncllr86DYhHEj8vKejChW+veIe9oo1TE4Kt+iyPdoY3sBig6MP/B+GkiMpyLJMdOg4
         ooRA==
X-Gm-Message-State: AOAM531/IhxJjjzICQ89V5E1qElkrnlpxeacZ86SM8XUal4FydBuhLzk
        LL0PBAjov0A4GtGxAWxK6RdsUcsKvDajNPIBTdxw1rGjSpk=
X-Google-Smtp-Source: ABdhPJzUeOAYMedftKIySkdFyKtjdWJundLdC8PxGs/nci2l8eP0M+3qlGeKyHCeLy1IQa3aX1yJJRaiE+u6VKKXs64=
X-Received: by 2002:a62:645:0:b0:3f2:23bd:5fc0 with SMTP id
 66-20020a620645000000b003f223bd5fc0mr22289611pfg.35.1632094438782; Sun, 19
 Sep 2021 16:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210919154337.9243-1-stachecki.tyler@gmail.com>
In-Reply-To: <20210919154337.9243-1-stachecki.tyler@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 19 Sep 2021 16:33:47 -0700
Message-ID: <CAM_iQpUeH7sOWRDfaAsER4HdRJQUuODB-ht0NyEZgnCXEmm2RQ@mail.gmail.com>
Subject: Re: [PATCH] ovs: Only clear tstamp when changing namespaces
To:     "Tyler J. Stachecki" <stachecki.tyler@gmail.com>
Cc:     fankaixi.li@bytedance.com, xiexiaohui.xxh@bytedance.com,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dev@openvswitch.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 10:59 AM Tyler J. Stachecki
<stachecki.tyler@gmail.com> wrote:
>
> As of "ovs: clear skb->tstamp in forwarding path", the
> tstamp is now being cleared unconditionally to fix fq qdisc
> operation with ovs vports.
>
> While this is mostly correct and fixes forwarding for that
> use case, a slight adjustment is necessary to ensure that
> the tstamp is cleared *only when the forwarding is across
> namespaces*.

Hmm? I am sure timestamp has already been cleared when
crossing netns:

void skb_scrub_packet(struct sk_buff *skb, bool xnet)
{
...
        if (!xnet)
                return;

        ipvs_reset(skb);
        skb->mark = 0;
        skb->tstamp = 0;
}

So, what are you trying to fix?

>
> Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
> ---
>  net/openvswitch/vport.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index cf2ce5812489..c2d32a5c3697 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -507,7 +507,8 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
>         }
>
>         skb->dev = vport->dev;
> -       skb->tstamp = 0;
> +       if (dev_net(skb->dev))

Doesn't dev_net() always return a non-NULL pointer?

If you really want to check whether it is cross-netns, you should
use net_eq() to compare src netns with dst netns, something like:
if (!net_eq(dev_net(vport->dev), dev_net(skb->dev))).

Thanks.
