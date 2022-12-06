Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5683E644382
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiLFMyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiLFMxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:53:43 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E905813D10;
        Tue,  6 Dec 2022 04:53:41 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 82B433200957;
        Tue,  6 Dec 2022 07:53:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Dec 2022 07:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670331220; x=1670417620; bh=DiEBz3UAqOWU+ZLLvEMouQwfav4g
        XjuMlfcry/rE0aE=; b=Eh4a5CGv1lc5sGqk/Y3egq8AZaVGQCmQPPAWFuBKE5EU
        jZ9BraJAMoU9VPTqs0v4q4nw5q8uKMTv4n61JzklztSallnvh7u7H950eUoL/T9w
        2dha82KJY1/ScTazKmQAWWLJJARqSnvLdlUfBmY3tYbj6RNsnvqUw2BYMod0qXcE
        Egnq85EoyQD0mnliIOkTrt+LJPBQRU4ndXkjSWneRpjXGbuzqqs5TEAMAxh+/Ubk
        l44434tddYEiUlQZYP+HZDBm2Sh1U1KXLJTQ/395lxPxNogZSfvogQTq0/4xEnLK
        CHTlexraYb6VBfrxfG16XpSfHMoJBWOjN9A8ff0KPQ==
X-ME-Sender: <xms:UzuPY2cpUtL2IWs8hwux-gP8BkSm5W74xfaADGPxM0jBLlGtGcluzA>
    <xme:UzuPYwNHGCOc5qUMuCYamJeV1ogkv6FY2l9hepiQkD2ACtik8UVrQnRE6D5YoI-Cd
    q3bPopYHyzBEko>
X-ME-Received: <xmr:UzuPY3hGR8kziVJMYd46UKtW5N1a_L2l8sX-vTkTnSW6sIRBKM4iHy1xevHGPRwkpOTQxKycXNIHGXWLEz5oDJj3ob8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UzuPYz89LAhJbzu2Jm-ovlTrdnE_necRBYK6WgAf81zYnKWwNEtHwQ>
    <xmx:UzuPYytyNI538Udn2D19KSH39w_3L80fEyRSQtfxh3cgNdReGBqpxg>
    <xmx:UzuPY6HacbUnQubnvjJIDtqJWPAat_wOZgXTY_5cFS5FEAISUDiVqw>
    <xmx:VDuPY_-XfVkW6fJktTOWhc66nil1-rdbjE-ib9CLGjYqMoFj6BlKlg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Dec 2022 07:53:38 -0500 (EST)
Date:   Tue, 6 Dec 2022 14:53:35 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <Y487T+pUl7QFeL60@shredder>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205185908.217520-4-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 07:59:08PM +0100, Hans J. Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series, is based on
> handling ATU miss violations occurring when packets ingress on a port
> that is locked with learning on. This will trigger a
> SWITCHDEV_FDB_ADD_TO_BRIDGE event, which will result in the bridge module
> adding a locked FDB entry. This bridge FDB entry will not age out as
> it has the extern_learn flag set.
> 
> Userspace daemons can listen to these events and either accept or deny
> access for the host, by either replacing the locked FDB entry with a
> simple entry or leave the locked entry.
> 
> If the host MAC address is already present on another port, a ATU
> member violation will occur, but to no real effect.

And the packet will be dropped in hardware, right?

> Statistics on these violations can be shown with the command and
> example output of interest:
> 
> ethtool -S ethX
> NIC statistics:
> ...
>      atu_member_violation: 5
>      atu_miss_violation: 23
> ...
> 
> Where ethX is the interface of the MAB enabled port.
> 
> An anomaly has been observed, where the ATU op to read the FID reports
> FID=0 even though it is not a valid read. An -EINVAL error will be logged
> in this case. This was seen on a mv88e6097.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

The changelog from previous versions is missing.

>  drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
>  drivers/net/dsa/mv88e6xxx/chip.c        | 18 ++++--
>  drivers/net/dsa/mv88e6xxx/chip.h        | 15 +++++
>  drivers/net/dsa/mv88e6xxx/global1_atu.c | 29 ++++++---
>  drivers/net/dsa/mv88e6xxx/switchdev.c   | 83 +++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/switchdev.h   | 19 ++++++
>  6 files changed, 152 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
> index c8eca2b6f959..be903a983780 100644
> --- a/drivers/net/dsa/mv88e6xxx/Makefile
> +++ b/drivers/net/dsa/mv88e6xxx/Makefile
> @@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
>  mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
>  mv88e6xxx-objs += serdes.o
>  mv88e6xxx-objs += smi.o
> +mv88e6xxx-objs += switchdev.o
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 66d7eae24ce0..732d7a2e2a07 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1726,11 +1726,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>  	return err;
>  }
>  
> -static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> -			      int (*cb)(struct mv88e6xxx_chip *chip,
> -					const struct mv88e6xxx_vtu_entry *entry,
> -					void *priv),
> -			      void *priv)
> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> +		       int (*cb)(struct mv88e6xxx_chip *chip,
> +				 const struct mv88e6xxx_vtu_entry *entry,
> +				 void *priv),
> +		       void *priv)
>  {
>  	struct mv88e6xxx_vtu_entry entry = {
>  		.vid = mv88e6xxx_max_vid(chip),
> @@ -6524,7 +6524,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  	const struct mv88e6xxx_ops *ops;
>  
>  	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
> +			   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB))
>  		return -EINVAL;
>  
>  	ops = chip->info->ops;
> @@ -6582,6 +6582,12 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
>  			goto out;
>  	}
>  
> +	if (flags.mask & BR_PORT_MAB) {
> +		bool mab = !!(flags.val & BR_PORT_MAB);
> +
> +		mv88e6xxx_port_set_mab(chip, port, mab);
> +	}
> +
>  	if (flags.mask & BR_PORT_LOCKED) {
>  		bool locked = !!(flags.val & BR_PORT_LOCKED);
>  
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index e693154cf803..f635a5bb47ce 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -280,6 +280,9 @@ struct mv88e6xxx_port {
>  	unsigned int serdes_irq;
>  	char serdes_irq_name[64];
>  	struct devlink_region *region;
> +
> +	/* MacAuth Bypass control flag */
> +	bool mab;
>  };
>  
>  enum mv88e6xxx_region_id {
> @@ -784,6 +787,12 @@ static inline bool mv88e6xxx_is_invalid_port(struct mv88e6xxx_chip *chip, int po
>  	return (chip->info->invalid_port_mask & BIT(port)) != 0;
>  }
>  
> +static inline void mv88e6xxx_port_set_mab(struct mv88e6xxx_chip *chip,
> +					  int port, bool mab)
> +{
> +	chip->ports[port].mab = mab;
> +}
> +
>  int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
>  int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
>  int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
> @@ -802,6 +811,12 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
>  	mutex_unlock(&chip->reg_lock);
>  }
>  
> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> +		       int (*cb)(struct mv88e6xxx_chip *chip,
> +				 const struct mv88e6xxx_vtu_entry *entry,
> +				 void *priv),
> +		       void *priv);
> +
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
>  
>  #endif /* _MV88E6XXX_CHIP_H */
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> index 8a874b6fc8e1..bb004df517b2 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -12,6 +12,7 @@
>  
>  #include "chip.h"
>  #include "global1.h"
> +#include "switchdev.h"
>  
>  /* Offset 0x01: ATU FID Register */
>  
> @@ -408,23 +409,25 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  
>  	err = mv88e6xxx_g1_read_atu_violation(chip);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &val);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_atu_fid_read(chip, &fid);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_atu_mac_read(chip, &entry);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
> +
> +	mv88e6xxx_reg_unlock(chip);

I was under the impression that we agreed that the locking change will
be split to a separate patch.

>  
>  	spid = entry.state;
