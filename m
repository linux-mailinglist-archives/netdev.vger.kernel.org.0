Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB90DB9B3
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441655AbfJQWWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:22:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51900 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438484AbfJQWWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:22:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so4134204wme.1;
        Thu, 17 Oct 2019 15:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KXeXgTLWxkAeKtFohWiEYLASe0tyOCWkZ6O2Q+1CwK0=;
        b=RnLuTusouvtmxgvc5T1svm4hlFc7muH4xkCgbKzexxbqVnxVZKbm0RibCQgLQd78kA
         EvI64x8MgDDMvG+BIynOt0mRAE0HJUV/z8PYP+CT21teQ91in+ta/j5En/PHTrzfckVL
         nHaqEHvT7gG0WGe885KEt7B4NtvWT4iJsdZrPaOztuyx3nTn+gIUEAwOIl+ZXq+51G82
         6X5+UkpakZ54HwVwcwNLAWH7RRARjjTTG3CLdLClwcdDdX3hKXp6NCD5U+CnUdueWg09
         TKEw3eC2KncnvTQRmaZoh9esIC/ghKaWG1p+e3qIcXApxlzIl5ggf8dz7AROPaIFJyHg
         T38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KXeXgTLWxkAeKtFohWiEYLASe0tyOCWkZ6O2Q+1CwK0=;
        b=XsnFB9n08YmFY0d7tfrl7YnHjV/LUtKD4Gw36ePWV8r7Z7JAA34obTPMWj5DRE47rc
         chFcOM7KNBd3Lk1m25JDSv1nL0enUTZ9o/fAa77FC+CgwIjKoeIFM/DTDRqOKmEjOPpS
         AhXeGlM8cFCFluEc6alpx1uwkaWTL5+ALjly0YR3n4P/zR7CeH9jbLpE57soMfrXjXuq
         bkKJtFwMQ56uXXK7+OZ/gkzDwNnAjPWyWH8uyItlnuRFcRVAb+9b6UeWdPE3U1Eb5KKz
         pSDHUVh0pAdHUCQ5YqZ1RqKdi2DwnD81CNENZnek1zUhTQGX4E50q8nqEwYX+dEfvUqe
         pqOg==
X-Gm-Message-State: APjAAAUx6MLShx31JRDiNU2B3dQ7iGGUJVk85zyBkoRb5wFqOityHj6h
        RBIr82/Oh+SURtFGs9FcZDo=
X-Google-Smtp-Source: APXvYqxZezsyJVUQZXKb135yZqy/QMuxMvuekAojOSRYAmfi5ldgkbhsJfTusUvcSibFzzTR2I9kVw==
X-Received: by 2002:a7b:c631:: with SMTP id p17mr4874271wmk.165.1571350969972;
        Thu, 17 Oct 2019 15:22:49 -0700 (PDT)
Received: from [10.230.29.119] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y186sm5147693wmd.26.2019.10.17.15.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 15:22:49 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmk+kernel@armlinux.org.uk,
        cphealy@gmail.com, Jose Abreu <joabreu@synopsys.com>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
 <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
Date:   Thu, 17 Oct 2019 15:22:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/2019 3:06 PM, Vladimir Oltean wrote:
>> +static int phy_rgmii_debug_rcv(struct sk_buff *skb, struct net_device
>> *dev,
>> +                   struct packet_type *pt, struct net_device *unused)
>> +{
>> +    struct phy_rgmii_debug_priv *priv = pt->af_packet_priv;
>> +    u32 fcs;
>> +
>> +    /* If we receive something, the Ethernet header was valid and so was
>> +     * the Ethernet type, so to re-calculate the FCS we need to undo
>> what
>> +     * eth_type_trans() just did.
>> +     */
>> +    if (!__skb_push(skb, ETH_HLEN))
>> +        return 0;
> 
> Why would this return NULL?
I don't think it can, good point.

> 
>> +
>> +    fcs = phy_rgmii_probe_skb_fcs(skb);
>> +    if (skb->len != priv->skb->len || fcs != priv->fcs) {
> 
> I feel like this logic is broken. How do you know that this skb is that
> skb? Everybody else can still enqueue to the netdev, right?

That is true, so I could be defeated by someone sending an Ethernet
Frame with a 0xdada ethernet type through, e.g.: raw sockets, good point.

> 
> Actually if I'm right about the FCS errors resulting in drops below,
> then any news here is good news, no need to even compare the FCS of two
> frames which you don't know whether they're in fact one and the same.

FCS is a bit overstated here, although it actually is what the HW would
generate/verify but the point was really that if you have a RGMII issue
you may very well end-up with two packets instead of one, because of the
clock/data misalignment.

> 
>> +        print_hex_dump(KERN_INFO, "RX probe skb: ",
>> +                   DUMP_PREFIX_OFFSET, 16, 1, skb->data, 32,
>> +                   false);
>> +        netdev_warn(dev, "Calculated FCS: 0x%08x expected: 0x%08x\n",
>> +                fcs, priv->fcs);
>> +    } else {
>> +        priv->rcv_ok = 1;
>> +    }
>> +
>> +    complete(&priv->compl);
>> +
>> +    return 0;
>> +}
>> +
>> +static int phy_rgmii_trigger_config(struct phy_device *phydev,
>> +                    phy_interface_t interface)
>> +{
>> +    int ret = 0;
>> +
>> +    /* Configure the interface mode to be tested */
>> +    phydev->interface = interface;
>> +
>> +    /* Forcibly run the fixups and config_init() */
>> +    ret = phy_init_hw(phydev);
>> +    if (ret) {
>> +        phydev_err(phydev, "phy_init_hw failed: %d\n", ret);
>> +        return ret;
>> +    }
>> +
>> +    /* Some PHY drivers configure RGMII delays in their config_aneg()
>> +     * callback, so make sure we run through those as well.
>> +     */
>> +    ret = phy_start_aneg(phydev);
>> +    if (ret) {
>> +        phydev_err(phydev, "phy_start_aneg failed: %d\n", ret);
>> +        return ret;
>> +    }
>> +
>> +    /* Put back in loopback mode since phy_init_hw() may have issued
>> +     * a software reset.
>> +     */
>> +    ret = phy_loopback(phydev, true);
>> +    if (ret)
>> +        phydev_err(phydev, "phy_loopback failed: %d\n", ret);
>> +
>> +    return ret;
>> +}
>> +
>> +static void phy_rgmii_probe_xmit_work(struct work_struct *work)
>> +{
>> +    struct phy_rgmii_debug_priv *priv;
>> +
>> +    priv = container_of(work, struct phy_rgmii_debug_priv, work);
>> +
>> +    dev_queue_xmit(priv->skb);
> 
> Oops, you just lost ownership of priv->skb here. Anything happening
> further is in a race with the netdev driver. You need to hold a
> reference to it with skb_get().

Doh, yes, thanks!

> 
>> +}
>> +
>> +static int phy_rgmii_prepare_probe(struct phy_rgmii_debug_priv *priv)
>> +{
>> +    struct phy_device *phydev = priv->phydev;
>> +    struct net_device *ndev = phydev->attached_dev;
>> +    struct sk_buff *skb;
>> +    int ret;
>> +
>> +    skb = netdev_alloc_skb(ndev, ndev->mtu);
>> +    if (!skb)
>> +        return -ENOMEM;
>> +
>> +    priv->skb = skb;
> 
> Could you assign priv->skb at the end, not here? This way you won't risk
> leaking a freed pointer into priv->skb if eth_header below fails.

Makes sense.

> 
>> +    skb->dev = ndev;
>> +    skb_put(skb, ndev->mtu);
>> +    memset(skb->data, 0xaa, skb->len);
>> +
> 
> I think you need to do something like this before skb_put:
> 
> +       skb->protocol = htons(ETH_P_EDSA);
> +       skb_reset_network_header(skb);
> +       skb_reset_transport_header(skb);
> 
> Otherwise I get a lot of these errors on a bridged net device:
> 
> [  142.919783] protocol 0000 is buggy, dev swp2
> [  142.924436] protocol 0000 is buggy, dev eth2
> 
>> +    /* Build the header */
>> +    ret = eth_header(skb, ndev, ETH_P_EDSA, ndev->dev_addr,
>> +             NULL, ndev->mtu);
> 
> A switch net device will complain about having SMAC == DMAC and drop the
> frame. Don't you want to send broadcast frames here?

Yes, that makes sense, if you do not have broadcast in your network
filter, your network adapter is not great use.

> 
>> +    if (ret != ETH_HLEN) {
>> +        kfree_skb(skb);
>> +        return -EINVAL;
>> +    }
>> +
>> +    priv->fcs = phy_rgmii_probe_skb_fcs(skb);
>> +
> 
> I'm far from a checksumming expert, but if the FCS was invalid, wouldn't
> the RX MAC just drop the frame?

Depends if the user has requested NETIF_F_RXALL, this was just a
convenient way to produce a strong enough checksum to compare against,
the HW will have to insert it and strip it back on its way back to itself.

> 
>> +    return 0;
>> +}
>> +
>> +static int phy_rgmii_probe_interface(struct phy_rgmii_debug_priv *priv,
>> +                     phy_interface_t iface)
>> +{
>> +    struct phy_device *phydev = priv->phydev;
>> +    struct net_device *ndev = phydev->attached_dev;
>> +    unsigned long timeout;
>> +    int ret;
>> +
>> +    ret = phy_rgmii_trigger_config(phydev, iface);
>> +    if (ret) {
>> +        netdev_err(ndev, "%s rejected by driver(s)\n",
>> +               phy_modes(iface));
>> +        return ret;
>> +    }
>> +
>> +    netdev_info(ndev, "Trying \"%s\" PHY interface\n",
>> phy_modes(iface));
>> +
>> +    /* Prepare probe frames now */
>> +    ret = phy_rgmii_prepare_probe(priv);
>> +    if (ret)
>> +        return ret;
>> +
>> +    priv->rcv_ok = 0;
>> +    reinit_completion(&priv->compl);
>> +
>> +    cancel_work_sync(&priv->work);
>> +    schedule_work(&priv->work);
>> +
>> +    timeout = wait_for_completion_timeout(&priv->compl,
>> +                          msecs_to_jiffies(3000));
>> +    if (!timeout) {
>> +        netdev_err(ndev, "transmit timeout!\n");
>> +        ret = -ETIMEDOUT;
>> +        goto out;
>> +    }
>> +
>> +    ret = priv->rcv_ok == 1 ? 0 : -EINVAL;
>> +out:
>> +    phy_loopback(phydev, false);
>> +    dev_consume_skb_any(priv->skb);
> 
> Don't consume the skb if the xmit has timed out. The driver will have
> already freed it in that case, leading to:
> 
> [  145.994328] sja1105 spi0.1 swp2: transmit timeout!
> [  145.999259] ------------[ cut here ]------------
> [  146.003901] WARNING: CPU: 0 PID: 163 at lib/refcount.c:190
> refcount_sub_and_test_checked+0xb8/0xc0
> [  146.013029] refcount_t: underflow; use-after-free.
> 
> That means, in practice, moving the kfree_skb call to phy_rgmii_debug_rcv.
> 
>> +    return ret;
>> +}
>> +
>> +static struct packet_type phy_rgmii_probes_type __read_mostly = {
>> +    .type    = cpu_to_be16(ETH_P_EDSA),
>> +    .func    = phy_rgmii_debug_rcv,
>> +};
>> +
>> +static int phy_rgmii_can_debug(struct phy_device *phydev)
>> +{
>> +    struct net_device *ndev = phydev->attached_dev;
>> +
>> +    if (!ndev) {
>> +        netdev_err(ndev, "No network device attached\n");
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    if (!phy_interface_is_rgmii(phydev)) {
>> +        netdev_info(ndev, "Not RGMII configured, nothing to do\n");
>> +        return 0;
>> +    }
>> +
>> +    if (!phydev->is_gigabit_capable) {
>> +        netdev_err(ndev, "not relevant in non-Gigabit mode\n");
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    if (phy_driver_is_genphy(phydev) ||
>> phy_driver_is_genphy_10g(phydev)) {
>> +        netdev_err(ndev, "only relevant with non-generic drivers\n");
>> +        return -EOPNOTSUPP;
>> +    }
>> +    return 1;
>> +}
>> +
>> +int phy_rgmii_debug_probe(struct phy_device *phydev)
>> +{
>> +    struct net_device *ndev = phydev->attached_dev;
>> +    unsigned char operstate = ndev->operstate;
>> +    phy_interface_t rgmii_modes[4] = {
>> +        PHY_INTERFACE_MODE_RGMII,
>> +        PHY_INTERFACE_MODE_RGMII_ID,
>> +        PHY_INTERFACE_MODE_RGMII_RXID,
>> +        PHY_INTERFACE_MODE_RGMII_TXID
>> +    };
>> +    struct phy_rgmii_debug_priv *priv;
>> +    unsigned int i, count;
>> +    int ret;
>> +
>> +    ret = phy_rgmii_can_debug(phydev);
>> +    if (ret <= 0)
>> +        return ret;
>> +
>> +    priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>> +    if (!priv)
>> +        return -ENOMEM;
>> +
>> +    if (phy_rgmii_probes_type.af_packet_priv)
>> +        return -EBUSY;
>> +
>> +    phy_rgmii_probes_type.af_packet_priv = priv;
>> +    priv->phydev = phydev;
>> +    INIT_WORK(&priv->work, phy_rgmii_probe_xmit_work);
>> +    init_completion(&priv->compl);
>> +
>> +    /* We are now testing this network device */
>> +    ndev->operstate = IF_OPER_TESTING;
>> +
> 
> Shouldn't you put the netdev in promisc mode somewhere?

If we send with a broadcast MAC SA (which is a good suggestion) and our
own MAC DA, then no.

[snip]

>>
> 
> Despite the above, I couldn't actually get this running successfully. At
> the end of the test I always get "-bash: echo: write error: Connection
> timed out".
> It's a fun toy, but I don't really think it's very useful in catching
> any bug.

Looks like it just did, with itself :)

> It's basically a glorified ping test, and brainless ping tests are
> precisely the reason why people get this wrong most of the time. You
> can't have a generic software tool identify for you a configuration
> problem that depends entirely upon a private hardware implementation of
> a specification that is vague.
> 
> I mean in theory, the arithmetic is simple enough for a MAC-to-PHY
> connection. These 2 equalities always need to hold true:
> 
> MAC TX delay + PCB TX delay + PHY TX delay == 1
> MAC RX delay + PCB RX delay + PHY RX delay == 1
> 
> meaning that delays in each direction need to be applied at most once.
> 
> For a PHY-to-MAC connection, there is this unwritten Linux rule that the
> PHY should apply the requested delays in both directions. This already
> contradicts common sense, as it is not uncommon, from a hardware point
> of view, for each device to add the delays in its own TX direction (so
> the MAC would add the TX delays and the PHY would add the RX delays).
> That is not possible to specify with Linux. But let's go with the flow.
> So the PHY adds all specified delays, and one can assume that the
> unspecified delays up to rgmii-id were added by the PCB. This small
> kernel thread would basically probe for PCB delays, in this case,
> assuming that the MAC driver and the PHY driver are both compliant.
> 
> Let's say there is more than one phy-mode that works. Andrew said to
> raise a red flag in that case, because the PHY driver is surely not
> doing the right thing with the delays. But:
> - Maybe it is, but the equalities above aren't completely set in stone.
> Maybe the inserted propagation delays aren't high enough that two of
> them would break the link again.
> - Which of the multiple phy-mode configurations that work is the right
> one? A tool that can't tell me that is pointless, IMO. My PHY works due
> to pin strapping, but the driver is buggy. Do I care? No, as long as it
> works, and as long as it will continue to work after somebody fixes the
> driver. How do I know what delay mode is right? Well, of course, if it
> works with the configuration out of pin strapping, then obviously I
> should put the pin strapping settings in the DT. End of story. Can this
> kernel thread tell me that? No....
> 
> And then, there's the RGMII fixed-link. The rules are cloudy for that
> one, because now there's potentially 2 phy-modes that operate on the
> same link. To complicate matters even further, your patch does not
> consider the fixed-link (no PHY) case, and there is no generic interface
> to even add selftests for that in the future. You would need to unbind
> the MAC driver, mangle the DT bindings, then bind it back again...
> 
> I guess I'm just concerned about the chaos that a tool returning false
> positives would create for people who don't really follow what's going
> on ("look, but the tool said this!").

And maybe I should have marked this RFC, the commit subject is clear
that this not fool proof, it cannot be, for all the reasons you
outlined. The thing is that I have spent many hours of my life (like
you, like Andrew) helping people troubleshoot why RGMII does not work,
if we have a good litmus test we can submit, that gets us half-way there.

I am completely fine dropping this if you believe this is going to cause
more harm than good.
-- 
Florian
