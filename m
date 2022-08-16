Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2927F5963DD
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiHPUmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiHPUmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:42:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C679485F9A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:42:12 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id o22so14987847edc.10
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1Bar65IvpSUjU+op1Jd16NCsGSD3gLFDfmKjC6ww7rk=;
        b=phFlpyCcJJxaNppNT+uY1LyE96/CGnIqeVxVFbECJ8f4TLKqdu6g8rjPfJuwN9aNjP
         dGFLsGExvLs782cUqnzdW4Qpu1HSFsPCQrnz2xaNECjyxIyYZ9gbjdUrOviZ2eOeaSBz
         X51D9OaRZSqB8YjwJoa0hbXVhE6+bf30EtdBspDxy9H7qyqpAiW6/hwWEbXQjqssACUD
         nhPaVJevAUHPIPaJ0WkdTQJXgIrYV4UBPKYyngrwff8kFvmrPdhegoQEVCf4YPqK+wgx
         AXrldHW5NdbeEujCFtqo9G0upkTMkYqudQpDg+3jAqbRG9HPr8CtzO/n38SJwxYg9hVy
         Cmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1Bar65IvpSUjU+op1Jd16NCsGSD3gLFDfmKjC6ww7rk=;
        b=lU/A31n7RtRVLREty+50gRFSKGLgJIsdR4VgZ1SEutr7jRzphizVvTI+eAPkax1SnO
         9wavtTW+TzOi3OdYaMFS1Dd4r5dWF0aN/qHQXuRGJpP46NOYcxjpsovq66yPlu8b8KKp
         Rl6/Y/xfWTSCiaqVqGiebkQn42n0co6nGsQYp+3S2qzgrlzQWJzu62PsSgmy/EgTaJSs
         pL4nGYCS9TN3RVcyNFzOUe+nAvlZ36uB8ggyTc1Jvcjy5Xh5xTI0U+/2pAFs1CmPfRKW
         CsIBw88d0iYZsXEkS0Eea+EGYzj6DaxtzC9L7g5sjHh+6pqn/8btlhLGCD8wLwq8djUr
         2Q5g==
X-Gm-Message-State: ACgBeo0OXUI00b1xqezpAU5inDs480ASqrRL4bp8uEuoTkmzFO06FnHB
        xIjlPCOycHzgD/oeYiYqJi64qkEsjf0=
X-Google-Smtp-Source: AA6agR4B+qOPJm/EHsqtB8NJR2g9CsP0pafY16KbvLbOKO+H4DETnSwBx4ZRxl8ZSe/Ufpfwi+dA9g==
X-Received: by 2002:a05:6402:3495:b0:43d:d76e:e9ff with SMTP id v21-20020a056402349500b0043dd76ee9ffmr20748207edc.227.1660682531219;
        Tue, 16 Aug 2022 13:42:11 -0700 (PDT)
Received: from skbuf ([188.26.184.170])
        by smtp.gmail.com with ESMTPSA id s23-20020a508d17000000b0043d7923af6esm9148515eds.95.2022.08.16.13.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 13:42:10 -0700 (PDT)
Date:   Tue, 16 Aug 2022 23:42:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
Message-ID: <20220816204208.zp5rvrcl2i4vmfgx@skbuf>
References: <20220810082745.1466895-1-saproj@gmail.com>
 <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
 <20220810133531.wia2oznylkjrgje2@skbuf>
 <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
 <20220810193825.vq7rdgwx7xua5amj@skbuf>
 <CABikg9wUtyNGJ+SvASGC==qezh2eghJ=SyM5hECYVguR3BmGQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9wUtyNGJ+SvASGC==qezh2eghJ=SyM5hECYVguR3BmGQQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 11:23:02AM +0300, Sergei Antonov wrote:
> > > Is it correct for eth0 and lan2@eth0 to have the same MAC?
> >
> > It is not wrong, it's a configuration that many deployed DSA systems use.
> 
> Is it also not wrong with several lanN@eth0 interfaces? I'm asking it
> because I will probably need to support hardware with more than one
> port on the 6060.

Having multiple DSA interfaces share the same MAC address is also not
entirely wrong, no, and is quite common. But here you'll have to do some
more reading.

The thinking goes, since each DSA netdev constitutes its own L3
termination interface, then they are either connected to different L2
networks, or they are connected together (back to back, in an external
cable loopback). The first case doesn't violate the rule that an L2
network should have a single MAC address per VLAN, and the back-to-back
case should work too. While the other would imply sending packets with a
MAC SA equal to the MAC DA. That's not illegal AFAIK either - as long as
no switch sees the packets*, at least.

There's also the possibility for ports to be bridged together, and in
that case, the L3 termination interface stops being the DSA netdev and
starts being the bridge itself, so the ports' MAC addresses stop
mattering too.

There are limitations though, for example this won't work:

                br0
               /   \
              /     \
 lan0 ---- lan1    lan2 ----- lan3

When all of lan0 - lan3 share the same MAC address, and lan0 wants to
ping lan3, br0 will say "oh, this packet is for me!" because the bridge
marks the MAC addresses of all its bridge ports in the FDB as BR_FDB_LOCAL
(local termination, no forwarding).

The last topology I presented is quite common in the kselftest framework,
and the reason why tools/testing/selftests/drivers/net/dsa/forwarding.config
sets STABLE_MAC_ADDRS=yes; so that each port is given a unique address.

*if you're thinking "well, DSA is a switch, too", then not quite. The
ports, when operating as standalone like mv88e6060 does, should have all
bridge layer functions disabled, like for example address learning.

> > So you should run some tcpdump and ethtool -S on the DSA master and see
> > whether it receives any packets or it drops them. It's possible that
> > tcpdump makes packets be accepted, since it puts the interface in
> > promiscuous mode.
> 
> When I tried to make it work with different MAC addresses, I used
> Wireshark and saw that ARP packets did not reach the interface unless
> they were broadcast. I might have been a configuration issue rather
> than driver issue. Thanks for the explanation! But I will happily
> stick to the common MAC address solution if it is not wrong.

After you said that the driver is moxart, I took a quick look at its few
lines of code and I think I know what the problem is.

Basically this driver has a "slow race" between:

static void moxart_mac_set_rx_mode(struct net_device *ndev)
{
	struct moxart_mac_priv_t *priv = netdev_priv(ndev);

	spin_lock_irq(&priv->txlock);

	(ndev->flags & IFF_PROMISC) ? (priv->reg_maccr |= RCV_ALL) : <- this
				      (priv->reg_maccr &= ~RCV_ALL);

	(ndev->flags & IFF_ALLMULTI) ? (priv->reg_maccr |= RX_MULTIPKT) :
				       (priv->reg_maccr &= ~RX_MULTIPKT);

	if ((ndev->flags & IFF_MULTICAST) && netdev_mc_count(ndev)) {
		priv->reg_maccr |= HT_MULTI_EN;
		moxart_mac_setmulticast(ndev);
	} else {
		priv->reg_maccr &= ~HT_MULTI_EN;
	}

	writel(priv->reg_maccr, priv->base + REG_MAC_CTRL);

	spin_unlock_irq(&priv->txlock);
}

and

static void moxart_mac_reset(struct net_device *ndev)
{
	struct moxart_mac_priv_t *priv = netdev_priv(ndev);

	writel(SW_RST, priv->base + REG_MAC_CTRL);
	while (readl(priv->base + REG_MAC_CTRL) & SW_RST)
		mdelay(10);

	writel(0, priv->base + REG_INTERRUPT_MASK);

	priv->reg_maccr = RX_BROADPKT | FULLDUP | CRC_APD | RX_FTL; <- this
}

(called from moxart_mac_open)

Basically moxart_mac_reset() overwrites the RCV_ALL bit from priv->reg_maccr,
not taking into consideration that an interface may be put in
promiscuous mode even while it's not down. See commit d2615bf45069
("net: core: Always propagate flag changes to interfaces") from November
2013 as proof that it can (and btw, DSA does exactly this). The moxart
driver dates from August 2013, so probably this wasn't an issue for a
few months, and then started being one.
