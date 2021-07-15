Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20763C9936
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 08:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhGOG5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 02:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbhGOG5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 02:57:52 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1F2C061760;
        Wed, 14 Jul 2021 23:54:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d2so6363478wrn.0;
        Wed, 14 Jul 2021 23:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M5NwdGajzImtf+rA0R6crLR2Js+53H3IkmZEIs+p8zo=;
        b=vQEk7dhVjFoCUsFK+Wi0ucD8cSPeN45ankMJXJtuVI2X8GYbrNRb4MhH5WmhH5R1RF
         G6SVhJG38896HrJfvazIJZQIq9C2LPnB6GHG2dXQ1o87T2W2TxawyJaiGlxMSooegWV9
         Jm16K/EG+awC8l9IGUxoY+tGOUCpuZCX37LrkW8ceGdLtWbLyshZF5OoQkJwE9dGRcIH
         +Bezgby8u6uC70VblHKbvBYnat/HyRV9ES1wK2tSexQSEhmX2lKGXsqVIOQxn1mhlGCT
         eltbKpYal5bGGOuq0K6a0iyCzh+UzZvh3T2gI4sfE/ZIjjEFU6AeAOxur4K8REeIRHYL
         GC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M5NwdGajzImtf+rA0R6crLR2Js+53H3IkmZEIs+p8zo=;
        b=UdHQz5i4fdYet2wS00+dlYaW2syxWzdBawPBgfWP3a4+WJdRX+bWNGpVdqfXpgI0CT
         fv0Wi16l7GcG6fRocyIomh79z5pUVKfmmLJITvm1oAQxuonS5i8ILKFJphXJSpqOUK+Y
         vvMYE8tEfG9d6cpwMriEeLsiVdIKjw0qN7HZPY8ar+cWRg5POt/pLCPts0eLgT4vZt3z
         6nEu4wjvlqfX+oCOkj6vNEWMqKSNTCmheFQfVSHNKeiWNNytqbJZcsNwTpiKcg80GPPl
         hQpAn4xrMcQ+hdppDDT8p7gGrRq1bX66zbfSVm/2nS+v7hfbwP5H71zC0v7kdpW9i/Io
         qBkQ==
X-Gm-Message-State: AOAM531Ue0mak63xYwTVJf9Jgkiv+ZAeLNz1fkfYGmMhU426Jd9eCrVH
        kcfoplmSLn/0leDscmPodfM=
X-Google-Smtp-Source: ABdhPJxQLW3ZwX2obsB/Y1J7wZN/NF/RYBsmwg3N+XhHqbFia9Ck++fZv9Zn/yoyVNEC1w6PUE4dnQ==
X-Received: by 2002:a5d:5257:: with SMTP id k23mr3518536wrc.50.1626332097607;
        Wed, 14 Jul 2021 23:54:57 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id d18sm3867386wmp.46.2021.07.14.23.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 23:54:57 -0700 (PDT)
Date:   Thu, 15 Jul 2021 09:54:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <20210715065455.7nu7zgle2haa6wku@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO9F2LhTizvr1l11@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 10:15:20PM +0200, Andrew Lunn wrote:
> On Wed, Jul 14, 2021 at 10:48:12PM +0300, Vladimir Oltean wrote:
> > Hi Lino,
> > 
> > On Wed, Jul 14, 2021 at 09:17:23PM +0200, Lino Sanfilippo wrote:
> > > If the checksum calculation is offloaded to the network device (e.g due to
> > > NETIF_F_HW_CSUM inherited from the DSA master device), the calculated
> > > layer 4 checksum is incorrect. This is since the DSA tag which is placed
> > > after the layer 4 data is seen as a part of the data portion and thus
> > > errorneously included into the checksum calculation.
> > > To avoid this, always calculate the layer 4 checksum in software.
> > > 
> > > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > > ---
> > 
> > This needs to be solved more generically for all tail taggers. Let me
> > try out a few things tomorrow and come with a proposal.
> 
> Maybe the skb_linearize() is also a generic problem, since many of the
> tag drivers are using skb_put()? It looks like skb_linearize() is
> cheap because checking if the skb is already linear is cheap. So maybe
> we want to do it unconditionally?

Yeah, but we should let the stack deal with both issues in validate_xmit_skb().
There is a skb_needs_linearize() call which returns false because the
DSA interface inherits NETIF_F_SG from the master via dsa_slave_create():

	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;

Arguably that's the problem right there, we shouldn't inherit neither
NETIF_F_HW_CSUM nor NETIF_F_SG from the list of features inheritable by
8021q uppers.

- If we inherit NETIF_F_SG we obligate ourselves to call skb_linearize()
  for tail taggers on xmit. DSA probably doesn't break anything for
  header taggers though even if the xmit skb is paged, since the DSA
  header would always be part of the skb head, so this is a feature we
  could keep for them.
- If we inherit NETIF_F_HW_CSUM from the master for tail taggers, it is
  actively detrimential to keep this feature enabled, as proven my Lino.
  As for header taggers, I fail to see how this would be helpful, since
  the DSA master would always fail to see the real IP header (it has
  been pushed to the right by the DSA tag), and therefore, the DSA
  master offload would be effectively bypassed. So no point, really, in
  inheriting it in the first place in any situation.

Lino, to fix these bugs by letting validate_xmit_skb() know what works
for DSA and what doesn't, could you please:

(a) move the current slave_dev->features assignment to
    dsa_slave_setup_tagger()? We now support changing the tagging
    protocol at runtime, and everything that depends on what the tagging
    protocol is (in this case, tag_ops->needed_headroom vs
    tag_ops->needed_tailroom) should be put in that function.
(b) unconditionally clear NETIF_F_HW_CSUM from slave_dev->features,
    after inheriting the vlan_features from the master?
(c) clear NETIF_F_SG from slave_dev->features if we have a non-zero
    tag_ops->needed_tailroom?

Thanks.

By the way I didn't get the chance to test anything, sorry if there is
any mistake in my reasoning.
