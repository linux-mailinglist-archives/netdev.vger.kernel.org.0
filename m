Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34AE141D9
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfEES30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:29:26 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41078 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfEES30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:29:26 -0400
Received: by mail-ed1-f65.google.com with SMTP id m4so12743899edd.8
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 11:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rliCdhRV9AV/j1xuEHsyzkrESggFfnpsIlBsoi8bKLI=;
        b=vZHXyYl4552Q0QrnFiH8J97dZGiFl2FBja8eZosAKaAdONmDUqvHtnKnOfZjDPKnyR
         sjkGJQr9cucMhrteCxakMHBFImhVweoeeb84HJBhxmTPV3Ha29IW8DDIHskOx2i3EbBg
         jRqA3EMoe8ToqrYL5zv2B+Tlbm88gSQ+KSLBwyhz+Nx8YF/0TZpLrPq4zvJasVVdKLFz
         rP72miuWzcyMUDrQp+Hm+jJhLq/h+jUXhV6NG6MvbjGismVGvQvNkg1MSyjFparwGtf2
         06vL5ewDaOT7V1k2X467jD9+Icr6x7qjcY+bPg3tu6mwl6LoCn5aQyRAab9fyuwkTB2q
         xPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rliCdhRV9AV/j1xuEHsyzkrESggFfnpsIlBsoi8bKLI=;
        b=TT92t6c6h1A+txoZ/kq5+ItuNVr455W6EoxoQsKYoo0NfcgXbDW09cPbly8rg+5ED5
         v6o098ay9SQQVzscUF//bAg0ngxn+BFt2OpCIOUPk7VaiI51JJGv+Y+MWjr2AcbD21wz
         CjkifbtYspkVYJrx4SeQ64LmxUccJWDS49n2BPhVDwwqo6XMr1WKvUtpEJ9vTBtNbdPY
         omqaLwC4X1p7uwb7vkYNOafTnhsLmGjA896eV+WzKZupQzt97fWVB4jrvFY/cVcxxRWy
         eKTYUbq1V6En/edShLq9GJGhqCyvH/J+YpoANytyxpjkfHXER+GgZhwn05tZGKdt7GIQ
         Bg3g==
X-Gm-Message-State: APjAAAXw+RzQukWym4HoF0ZADF2yyX8IgX48vBAJ6Ph5rI9yGnN5PpTk
        aCRiHG/YrlvUw0H3tLXXDGMTyVlvkO2eN/isnHM12w==
X-Google-Smtp-Source: APXvYqzF/x9Bse0aemVNY3yNXCE4roawlz8ezRAEOrgb+hH6QGyUMMB4KgHiRPAODjjo+e4G6B1LINS4/k+97pZQgW0=
X-Received: by 2002:a17:906:2e54:: with SMTP id r20mr15899773eji.146.1557080964892;
 Sun, 05 May 2019 11:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190505101929.17056-1-olteanv@gmail.com> <20190505101929.17056-5-olteanv@gmail.com>
 <0c7debc2-7ba4-3fef-031f-b70a2c3c219f@gmail.com>
In-Reply-To: <0c7debc2-7ba4-3fef-031f-b70a2c3c219f@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 5 May 2019 21:29:13 +0300
Message-ID: <CA+h21hoXpdxdQ+GNSiUcBDUE3RKv9h_CPXzDHnTp3U250VA+QA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 04/10] net: dsa: Allow drivers to filter
 packets they can decode source port from
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 May 2019 at 20:02, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/5/2019 3:19 AM, Vladimir Oltean wrote:
> > Frames get processed by DSA and redirected to switch port net devices
> > based on the ETH_P_XDSA multiplexed packet_type handler found by the
> > network stack when calling eth_type_trans().
> >
> > The running assumption is that once the DSA .rcv function is called, DSA
> > is always able to decode the switch tag in order to change the skb->dev
> > from its master.
> >
> > However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
> > user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
> > true, since switch tagging piggybacks on the absence of a vlan_filtering
> > bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
> > rely on switch tagging, but on a different mechanism. So it would make
> > sense to at least be able to terminate that.
> >
> > Having DSA receive traffic it can't decode would put it in an impossible
> > situation: the eth_type_trans() function would invoke the DSA .rcv(),
> > which could not change skb->dev, then eth_type_trans() would be invoked
> > again, which again would call the DSA .rcv, and the packet would never
> > be able to exit the DSA filter and would spiral in a loop until the
> > whole system dies.
> >
> > This happens because eth_type_trans() doesn't actually look at the skb
> > (so as to identify a potential tag) when it deems it as being
> > ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
> > installed (therefore it's a DSA master) and that there exists a .rcv
> > callback (everybody except DSA_TAG_PROTO_NONE has that). This is
> > understandable as there are many switch tags out there, and exhaustively
> > checking for all of them is far from ideal.
> >
> > The solution lies in introducing a filtering function for each tagging
> > protocol. In the absence of a filtering function, all traffic is passed
> > to the .rcv DSA callback. The tagging protocol should see the filtering
> > function as a pre-validation that it can decode the incoming skb. The
> > traffic that doesn't match the filter will bypass the DSA .rcv callback
> > and be left on the master netdevice, which wasn't previously possible.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > --
> just one nit below:
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> [snip]
>
> > -     if (unlikely(netdev_uses_dsa(dev)))
> > +     if (unlikely(netdev_uses_dsa(dev)) && dsa_can_decode(skb, dev))
> >               return htons(ETH_P_XDSA);
>
> Just in case you need to resubmit, should not the dsa_can_decode() also
> be part of the unlikely() statement here?
>
> --
> Florian

Hi Florian,

Does this matter, since the compiler performs short-circuit evaluation
and the first condition is already unlikely?
Also, if the netdev does use DSA, conceptually it is not unlikely for
it to be able to decode packets, hence it is strange to optimize the
branch predictor for that.

-Vladimir
