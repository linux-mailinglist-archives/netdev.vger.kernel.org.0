Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4042F360F1B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhDOPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233328AbhDOPjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 11:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5AB6115B;
        Thu, 15 Apr 2021 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618501118;
        bh=ajiCW3bOWWnZTSmBCSOGub9XjKmKohmVprRSzmu8/IY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qbhm92yl74XIHHfzw+L1JSIcMLKV+ilBujlGZHNZtwIIZDvPL86mBvEdnvVUnIhEf
         JJ4Q2jbi3CGClA7Qsr8KdCvBazAgBukZjL52Dz3OECdJe56wAIjeLZySxgQxSkg16C
         ndN+j+Ww3uKMwZ5/IxhedKhLFt383uiyCVV97JUbDRrWf0ROmVjO9nQCzXTVsRpi7x
         w8Gpl7/vU9mgVJtIcsHoNDk/JeY0iDmTThsaMYx0PiLvl8AyeGugy9pTzGhf6RoPdY
         EEp49lck0EC8ZXMMdYO+c6idp8Z/gPO0XzJmmi6Osxsqx0dD1CYOhELSqV93j1v3U0
         LKXIzFLw0OiCg==
Date:   Thu, 15 Apr 2021 08:38:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com
Subject: Re: [RFC net-next 4/6] ethtool: add interface to read standard MAC
 stats
Message-ID: <20210415083837.6dfc0af9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <335639a79d72cec4abb3775bc84336f8390a57b7.camel@kernel.org>
References: <20210414202325.2225774-1-kuba@kernel.org>
        <20210414202325.2225774-5-kuba@kernel.org>
        <335639a79d72cec4abb3775bc84336f8390a57b7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 23:12:52 -0700 Saeed Mahameed wrote:
> On Wed, 2021-04-14 at 13:23 -0700, Jakub Kicinski wrote:
> > Most of the MAC statistics are included in
> > struct rtnl_link_stats64, but some fields
> > are aggregated. Besides it's good to expose
> > these clearly hardware stats separately.
> >=20
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>

> > +/* Basic IEEE 802.3 MAC statistics (30.3.1.1.*), not otherwise exposed
> > + * via a more targeted API.
> > + */
> > +struct ethtool_eth_mac_stats {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesTransmittedOK;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 SingleCollisionFrames;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 MultipleCollisionFrames;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesReceivedOK;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FrameCheckSequenceErrors;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 AlignmentErrors;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 OctetsTransmittedOK;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesWithDeferredXmissi=
ons;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 LateCollisions;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesAbortedDueToXSColl=
s;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesLostDueToIntMACXmi=
tError;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 CarrierSenseErrors;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 OctetsReceivedOK;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesLostDueToIntMACRcv=
Error;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 MulticastFramesXmittedOK;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 BroadcastFramesXmittedOK;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FramesWithExcessiveDefer=
ral;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 MulticastFramesReceivedO=
K;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 BroadcastFramesReceivedO=
K;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 InRangeLengthErrors;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 OutOfRangeLengthField;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 FrameTooLongErrors;
> > +};
> > +
> > =C2=A0/* Basic IEEE 802.3 PHY statistics (30.3.2.1.*), not otherwise ex=
posed
> > =C2=A0 * via a more targeted API.
> > =C2=A0 */
> > @@ -495,6 +523,7 @@ struct ethtool_module_eeprom {
> > =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0specified page. Returns a negativ=
e error code or the amount of
> > bytes
> > =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0read.
> > =C2=A0 * @get_eth_phy_stats: Query some of the IEEE 802.3 PHY statistic=
s.
> > + * @get_eth_mac_stats: Query some of the IEEE 802.3 MAC statistics.
> > =C2=A0 *
> > =C2=A0 * All operations are optional (i.e. the function pointer may be =
set
> > =C2=A0 * to %NULL) and callers must take this into account.=C2=A0 Calle=
rs must
> > @@ -607,6 +636,8 @@ struct ethtool_ops {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct netlink_ext_ack
> > *extack);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void=C2=A0=C2=A0=C2=A0=
=C2=A0(*get_eth_phy_stats)(struct net_device *dev,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 st=
ruct ethtool_eth_phy_stats
> > *phy_stats);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void=C2=A0=C2=A0=C2=A0=C2=A0=
(*get_eth_mac_stats)(struct net_device *dev,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct e=
thtool_eth_mac_stats
> > *mac_stats); =20
>=20
> too many callbacks.. I understand the point of having explicit structs
> per stats group, but it can be achievable with one generic ethtool
> calback function with the help of a flexible struct:
>=20
> void (*get_std_stats)(struct net_device *dev, struct *std_stats)
>=20
>=20
> union stats_groups {
>     struct ethtool_eth_phy_stats eth_phy;
>     struct ethtool_eth_mac_stats eth_mac;
>     ...
> }
>=20
> struct std_stats {
>      u16 type;
>      union stats_groups stats[0];
> }
>=20
> where std_stats.stats is allocated dynamically according to
> std_stats.type
>=20
> and driver can just access the corresponding stats according to type
>=20
> e.g:=20
> std_stats.stats.eth_phy

Kinda expected you'd say this :) The mux make life simpler for drivers
with a lot of layers of abstraction. Separate ops make life simpler for
simpler drivers.

Basic Ethernet driver goes from this:

get_mac_stats()
{
	priv =3D netdev_priv()

	stat->x =3D readl(priv->regs + REG_X);
	stat->z =3D readl(priv->regs + REG_Y);
	stat->y =3D readl(priv->regs + REG_Z);
}

to:

get_std_stats()
{
	priv =3D netdev_priv();

	switch (stats->type) {
	case MAC:
		stat->x =3D readl(priv->regs + REG_X);
		stat->z =3D readl(priv->regs + REG_Y);
		stat->y =3D readl(priv->regs + REG_Z);
		break;
	}
}

or likely:

get_std_stats()
{
	priv =3D netdev_priv();

	switch (stats->type) {
	case MAC:
		return get_mac_stats(priv..);
	}
}

I prefer to keep the callbacks separate, there isn't that many of them.

> > +static int stats_put_mac_stats(struct sk_buff *skb,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct stats_reply_data *data)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (stat_put(skb, ETHTOOL_A_=
STATS_ETH_MAC_2_TX_PKT,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesTransmi=
ttedOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.SingleCollisi=
onFrames) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.MultipleColli=
sionFrames) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesReceive=
dOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FrameCheckSeq=
uenceErrors) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.AlignmentErro=
rs) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.OctetsTransmi=
ttedOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesWithDef=
erredXmissions) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.LateCollision=
s) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_11_XS_COL,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesAborted=
DueToXSColls) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesLostDue=
ToIntMACXmitError) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.CarrierSenseE=
rrors) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.OctetsReceive=
dOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesLostDue=
ToIntMACRcvError) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.MulticastFram=
esXmittedOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.BroadcastFram=
esXmittedOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FramesWithExc=
essiveDeferral) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.MulticastFram=
esReceivedOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.BroadcastFram=
esReceivedOK) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.InRangeLength=
Errors) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.OutOfRangeLen=
gthField) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stat_put(=
skb, ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data->mac_stats.FrameTooLongE=
rrors))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EMSGSIZE; =20
>=20
> lots of repetition, someone might forget to add the new stat in one of
> these places ..=20

If someone forgets to add a stat to the place they are dumped?
They will immediately realize it's not getting dumped...

> best practice here is to centralize all the data structures and
> information definitions in one place, you define the stat id, string,
> and value offset, then a generic loop can generate the strset and fill
> up values in the correct offset.
>=20
> similar implementation is already in mlx5:
>=20
> see pport_802_3_stats_desc:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mella=
nox/mlx5/core/en_stats.c#L682
>=20
> the "pport_802_3_stats_desc" has a description of the strings and
> offsets of all stats in this stats group
> and the fill/put functions are very simple and they just iterate over
> the array/group and fill up according to the descriptor.

We can maybe save 60 lines if we generate stats_eth_mac_names=20
in a initcall, is it really worth it? I prefer the readability=20
/ grepability.
