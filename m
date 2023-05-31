Return-Path: <netdev+bounces-6945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E7BD718EEB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EDF11C20FAB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D11E40773;
	Wed, 31 May 2023 23:07:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEAB18C3B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 23:07:22 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EB897
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:07:20 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d604cc0aaso194081b3a.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685574439; x=1688166439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uy59neeN9/91OVWd5bbeIT1cJmDJB7Xs59i1W7SFP7k=;
        b=JP8NaQWSCX2tkSzU7KvjVGQMuQUk1DZlA6w0dQ3V02TFJ4/9KQuJB7ciggfzKd34nA
         EWaTR6Akn0eXHFZUPdCsZ1URoajntqqRQ6JCk3FrJeYPGuWniaS29atn86oafPLLZKkt
         8WHJKxDZrV9wwDNSPB2hDw0Laf+KFJ9VImMXGD9VjftJuS8YBOsFvvCN83eVdwiYc78K
         CxAlZgUO36BPlubqGm/SaX3YoHyDmXOwMD5Ea5c4MjNj2ThdiLJwMFkMX/zv8JOyWUIt
         FyNPjsBMRh4TLjRFfn+GsZDMczbat99ucgkKDNNsirS0o51jp+z6lbZArXJ9Y2L0JLoE
         Qc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685574439; x=1688166439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uy59neeN9/91OVWd5bbeIT1cJmDJB7Xs59i1W7SFP7k=;
        b=eaH0+TMKYCcr/jc3UxwURkevJFQCLuAdnGcjSakV89osa49x5/BqctsXNd36a7weRH
         wuJY8BdmCv/PTj9KMecpfc7QhvWlEKWyqE4pTorZhLIvhhRWvdciCvSf6SeZl7e0nir2
         oarBPHRVMZvU8YXQvpsdTarlHZdZQBwfbxTbhmYo3H6wmwP5YgKX/NoAhTCLqw3LUcep
         WMn9EzgG7PGPruSlvKdOnupJYpd0XNGHfm6LdQPygoRF20SmMF8RsieKlWZwxYYQ/0H3
         5Q9ww4jeqJWtZRh+29p0zWXdwsrb7ZKuujYVwlkBX/Pd6J+jKtjDfqmK2RFZbpoWoBWD
         +D/w==
X-Gm-Message-State: AC+VfDz3JOEY5EhCcH/i1mY9ge+6DYBIW2q1uL/2fbdQkfgzNysNUjHt
	lt3GbfAiRmT63e6zYcSOlO4=
X-Google-Smtp-Source: ACHHUZ5ooJkRE1AxWqXg87JiH4a8e80AbZA7kK2s8VOY9vgEA/4T0XKOBhcPUUR1YgFiENA2yKqarQ==
X-Received: by 2002:a05:6a00:21cc:b0:64d:41d5:d160 with SMTP id t12-20020a056a0021cc00b0064d41d5d160mr6857294pfj.20.1685574439302;
        Wed, 31 May 2023 16:07:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y12-20020a63fa0c000000b0051b36aee4f6sm1812305pgh.83.2023.05.31.16.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 16:07:18 -0700 (PDT)
Message-ID: <40c2010e-337f-6bc1-5080-ab710fc4f991@gmail.com>
Date: Wed, 31 May 2023 16:07:10 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Content-Language: en-US
To: Tristram.Ha@microchip.com, "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/26/23 18:39, Tristram.Ha@microchip.com wrote:
> From: Tristram Ha <Tristram.Ha@microchip.com>
> 
> Microchip LAN8740/LAN8742 PHYs support basic unicast, broadcast, and
> Magic Packet WoL.  They have one pattern filter matching up to 128 bytes
> of frame data, which can be used to implement ARP or multicast WoL.
> 
> ARP WoL matches ARP request for IPv4 address of the net device using the
> PHY.
> 
> Multicast WoL matches IPv6 Neighbor Solicitation which is sent when
> somebody wants to talk to the net device using IPv6.  This
> implementation may not be appropriate and can be changed by users later.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
> ---
>   drivers/net/phy/smsc.c  | 297 +++++++++++++++++++++++++++++++++++++++-
>   include/linux/smscphy.h |  34 +++++
>   2 files changed, 329 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 692930750215..99c1eb0ab395 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -20,6 +20,11 @@
>   #include <linux/of.h>
>   #include <linux/phy.h>
>   #include <linux/netdevice.h>
> +#include <linux/crc16.h>
> +#include <linux/etherdevice.h>
> +#include <linux/inetdevice.h>
> +#include <net/if_inet6.h>
> +#include <net/ipv6.h>
>   #include <linux/smscphy.h>
>   
>   /* Vendor-specific PHY Definitions */
> @@ -51,6 +56,7 @@ struct smsc_phy_priv {
>   	unsigned int edpd_enable:1;
>   	unsigned int edpd_mode_set_by_user:1;
>   	unsigned int edpd_max_wait_ms;
> +	bool wol_arp;
>   };
>   
>   static int smsc_phy_ack_interrupt(struct phy_device *phydev)
> @@ -258,6 +264,285 @@ int lan87xx_read_status(struct phy_device *phydev)
>   }
>   EXPORT_SYMBOL_GPL(lan87xx_read_status);
>   
> +static int lan874x_phy_config_init(struct phy_device *phydev)
> +{
> +	u16 val;
> +	int rc;
> +
> +	/* Setup LED2/nINT/nPME pin to function as nPME.  May need user option
> +	 * to use LED1/nINT/nPME.
> +	 */
> +	val = MII_LAN874X_PHY_PME2_SET;
> +
> +	/* The bits MII_LAN874X_PHY_WOL_PFDA_FR, MII_LAN874X_PHY_WOL_WUFR,
> +	 * MII_LAN874X_PHY_WOL_MPR, and MII_LAN874X_PHY_WOL_BCAST_FR need to
> +	 * be cleared to de-assert PME signal after a WoL event happens, but
> +	 * using PME auto clear gets around that.
> +	 */
> +	val |= MII_LAN874X_PHY_PME_SELF_CLEAR;
> +	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
> +			   val);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* set nPME self clear delay time */
> +	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_MCFGR,
> +			   MII_LAN874X_PHY_PME_SELF_CLEAR_DELAY);
> +	if (rc < 0)
> +		return rc;
> +
> +	return smsc_phy_config_init(phydev);
> +}
> +
> +static void lan874x_get_wol(struct phy_device *phydev,
> +			    struct ethtool_wolinfo *wol)
> +{
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	int rc;
> +
> +	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
> +			  WAKE_ARP | WAKE_MCAST);
> +	wol->wolopts = 0;
> +
> +	rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
> +	if (rc < 0)
> +		return;
> +
> +	if (rc & MII_LAN874X_PHY_WOL_PFDAEN)
> +		wol->wolopts |= WAKE_UCAST;
> +
> +	if (rc & MII_LAN874X_PHY_WOL_BCSTEN)
> +		wol->wolopts |= WAKE_BCAST;
> +
> +	if (rc & MII_LAN874X_PHY_WOL_MPEN)
> +		wol->wolopts |= WAKE_MAGIC;
> +
> +	if (rc & MII_LAN874X_PHY_WOL_WUEN) {
> +		if (priv->wol_arp)
> +			wol->wolopts |= WAKE_ARP;
> +		else
> +			wol->wolopts |= WAKE_MCAST;
> +	}
> +}
> +
> +static u16 smsc_crc16(const u8 *buffer, size_t len)
> +{
> +	return bitrev16(crc16(0xFFFF, buffer, len));
> +}
> +
> +static int lan874x_chk_wol_pattern(const u8 pattern[], const u16 *mask,
> +				   u8 len, u8 *data, u8 *datalen)
> +{
> +	size_t i, j, k;
> +	u16 bits;
> +
> +	i = 0;
> +	k = 0;
> +	while (len > 0) {
> +		bits = *mask;
> +		for (j = 0; j < 16; j++, i++, len--) {
> +			/* No more pattern. */
> +			if (!len) {
> +				/* The rest of bitmap is not empty. */
> +				if (bits)
> +					return i + 1;
> +				break;
> +			}
> +			if (bits & 1)
> +				data[k++] = pattern[i];
> +			bits >>= 1;
> +		}
> +		mask++;
> +	}
> +	*datalen = k;
> +	return 0;
> +}
> +
> +static int lan874x_set_wol_pattern(struct phy_device *phydev, u16 val,
> +				   const u8 data[], u8 datalen,
> +				   const u16 *mask, u8 masklen)
> +{
> +	u16 crc, reg;
> +	int rc;
> +
> +	val |= MII_LAN874X_PHY_WOL_FILTER_EN;
> +	rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			   MII_LAN874X_PHY_MMD_WOL_WUF_CFGA, val);
> +	if (rc < 0)
> +		return rc;
> +
> +	crc = smsc_crc16(data, datalen);
> +	rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			   MII_LAN874X_PHY_MMD_WOL_WUF_CFGB, crc);
> +	if (rc < 0)
> +		return rc;
> +
> +	masklen = (masklen + 15) & ~0xf;
> +	reg = MII_LAN874X_PHY_MMD_WOL_WUF_MASK7;
> +	while (masklen >= 16) {
> +		rc = phy_write_mmd(phydev, MDIO_MMD_PCS, reg, *mask);
> +		if (rc < 0)
> +			return rc;
> +		reg--;
> +		mask++;
> +		masklen -= 16;
> +	}
> +
> +	/* Clear out the rest of mask registers. */
> +	while (reg != MII_LAN874X_PHY_MMD_WOL_WUF_MASK0) {
> +		phy_write_mmd(phydev, MDIO_MMD_PCS, reg, 0);
> +		reg--;
> +	}
> +	return rc;
> +}
> +
> +static int lan874x_set_wol(struct phy_device *phydev,
> +			   struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	u16 val, val_wucsr;
> +	u8 data[128];
> +	u8 datalen;
> +	int rc;
> +
> +	if (wol->wolopts & WAKE_PHY)
> +		return -EOPNOTSUPP;
> +
> +	/* lan874x has only one WoL filter pattern */
> +	if ((wol->wolopts & (WAKE_ARP | WAKE_MCAST)) ==
> +	    (WAKE_ARP | WAKE_MCAST)) {
> +		phydev_info(phydev,
> +			    "lan874x WoL supports one of ARP|MCAST at a time\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
> +	if (rc < 0)
> +		return rc;
> +
> +	val_wucsr = rc;

You need to take into account the case where an user wants to disable 
Wake-on-LAN entirely, e.g.:

ethtool -s <iface> wol d

[snip]

> +
> +	if (wol->wolopts & WAKE_UCAST)
> +		val_wucsr |= MII_LAN874X_PHY_WOL_PFDAEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_PFDAEN;
> +
> +	if (wol->wolopts & WAKE_BCAST)
> +		val_wucsr |= MII_LAN874X_PHY_WOL_BCSTEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_BCSTEN;
> +
> +	if (wol->wolopts & WAKE_MAGIC)
> +		val_wucsr |= MII_LAN874X_PHY_WOL_MPEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_MPEN;
> +
> +	/* Need to use pattern matching */
> +	if (wol->wolopts & (WAKE_ARP | WAKE_MCAST))
> +		val_wucsr |= MII_LAN874X_PHY_WOL_WUEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_WUEN;
> +
> +	if (wol->wolopts & WAKE_ARP) {
> +		const u8 *ip_addr =
> +			((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);
> +		const u16 mask[3] = { 0xF03F, 0x003F, 0x03C0 };
> +		u8 pattern[42] = {
> +			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x08, 0x06,
> +			0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00 };
> +		u8 len = 42;
> +
> +		memcpy(&pattern[38], ip_addr, 4);
> +		rc = lan874x_chk_wol_pattern(pattern, mask, len,
> +					     data, &datalen);
> +		if (rc)
> +			phydev_dbg(phydev, "pattern not valid at %d\n", rc);
> +
> +		/* Need to match broadcast destination address. */
> +		val = MII_LAN874X_PHY_WOL_FILTER_BCSTEN;
> +		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
> +					     len);
> +		if (rc < 0)
> +			return rc;
> +		priv->wol_arp = true;
> +	}
> +
> +	if (wol->wolopts & WAKE_MCAST) {
> +		u8 pattern[6] = { 0x33, 0x33, 0xFF, 0x00, 0x00, 0x00 };

A multicast Ethernet MAC address is defined by having bit 0 of the first 
byte (in network order) being set, what you are programming here is an 
IPv4 multicast MAC address pattern. Having recently submitted 
Wake-on-LAN for a Broadcom PHY (B50212E), I read WAKE_MAGIC as meaning 
"any multicast" and not specifically IP multicast.

> +		u16 mask[1] = { 0x0007 };
> +		u8 len = 3;
> +
> +		/* Try to match IPv6 Neighbor Solicitation. */
> +		if (ndev->ip6_ptr) {
> +			struct list_head *addr_list =
> +				&ndev->ip6_ptr->addr_list;
> +			struct inet6_ifaddr *ifa;
> +
> +			list_for_each_entry(ifa, addr_list, if_list) {
> +				if (ifa->scope == IFA_LINK) {
> +					memcpy(&pattern[3],
> +					       &ifa->addr.in6_u.u6_addr8[13],
> +					       3);
> +					mask[0] = 0x003F;
> +					len = 6;
> +					break;
> +				}
> +			}
> +		}

That would need to be enclosed within an #if IS_ENABLED(CONFIG_IPV6) 
presumablye, but see my comment above, I don't think you need to do that.

> +		rc = lan874x_chk_wol_pattern(pattern, mask, len,
> +					     data, &datalen);
> +		if (rc)
> +			phydev_dbg(phydev, "pattern not valid at %d\n", rc);
> +
> +		/* Need to match multicast destination address. */
> +		val = MII_LAN874X_PHY_WOL_FILTER_MCASTTEN;
> +		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
> +					     len);
> +		if (rc < 0)
> +			return rc;
> +		priv->wol_arp = false;

priv->wol_arp is only used for reporting purposes in get_wol, but since 
the same pattern matching hardware is used for WAKE_MCAST and WAKE_ARP, 
you need to make that mutually exclusive with an if (wol->wolopts & 
WAKE_ARP) .. else if (wol->wolopts & WAKE_MCAST) otherwise whichever was 
specified last in the user command will "win".

> +	}
> +
> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_UCAST)) {
> +		const u8 *mac = (const u8 *)ndev->dev_addr;
> +
> +		if (!is_valid_ether_addr(mac))
> +			return -EINVAL;

Same comment as Andrew, I would not care about that particular check.

> +
> +		rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +				   MII_LAN874X_PHY_MMD_WOL_RX_ADDRC,
> +				   ((mac[1] << 8) | mac[0]));
> +		if (rc < 0)
> +			return rc;
> +
> +		rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +				   MII_LAN874X_PHY_MMD_WOL_RX_ADDRB,
> +				   ((mac[3] << 8) | mac[2]));
> +		if (rc < 0)
> +			return rc;
> +
> +		rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +				   MII_LAN874X_PHY_MMD_WOL_RX_ADDRA,
> +				   ((mac[5] << 8) | mac[4]));
> +		if (rc < 0)
> +			return rc;

Can you implement this as a for loop maybe?
-- 
Florian


