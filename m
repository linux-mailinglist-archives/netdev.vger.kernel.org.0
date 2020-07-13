Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3085A21CFB7
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgGMGaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMGaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:30:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84FC061794;
        Sun, 12 Jul 2020 23:30:39 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594621837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wdy2pYUgtX5O0ZnAsCX1Q0gvVhkeuvcHMm9eVwIP7GE=;
        b=Qr9+j4iYPJcP4rqSrMWvV7No78WGM83c01FF/aA0PlmFwtJiX5/qiNHAvj2lHyowwKSi7q
        JW/I/pVL6BlNxWZwUpOGnayQX8gsHkJRfgCBYl2T7JoicZLdLEgmUWCnSuYWCKcFZPP87G
        QBnZrH/hSB27B2TiGQEfb0KseoDKRaJzYLRgKQcfaaO2SsxdIRIyx1vKohjS2FYMwQzPRb
        vIy80UlwKrmn11OKZQOqFub8SZOEYQYlSEsayTyaCRwOLJTF1CGzKXBKNpME/oipukohia
        d/Gz3iN4jZyYteQ7HoKWD4Kppli/ibrH82PXn0wLhOgsW3MsDqJEEIiKhOa2kw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594621837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wdy2pYUgtX5O0ZnAsCX1Q0gvVhkeuvcHMm9eVwIP7GE=;
        b=2zKQUN6JP5NmCT5PkHKCdiZ2Rtkc848iunZ12EnKeWgZcMsrH4V42UOgWnLxdzydx2eP+E
        4YvZKnt771PqeXBg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-3-kurt@linutronix.de> <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com>
Date:   Mon, 13 Jul 2020 08:30:25 +0200
Message-ID: <87v9islyf2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Jul 11 2020, Florian Fainelli wrote:
> On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
>> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches=
 are
>> implementing features needed for Time Sensitive Networking (TSN) such as=
 support
>> for the Time Precision Protocol and various shapers like the Time Aware =
Shaper.
>>=20
>> This driver includes basic support for networking:
>>=20
>>   * VLAN handling
>>   * FDB handling
>>   * Port statistics
>>   * STP
>>   * Phylink
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>
> [snip]
>
>> +++ b/drivers/net/dsa/hirschmann/Kconfig
>> @@ -0,0 +1,7 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +config NET_DSA_HIRSCHMANN_HELLCREEK
>> +	tristate "Hirschmann Hellcreek TSN Switch support"
>> +	depends on NET_DSA
>
> You most likely need a depends on HAS_IOMEM since this is a memory
> mapped interface.

OK.

>
> [snip]
>
>> +static void hellcreek_select_port(struct hellcreek *hellcreek, int port)
>> +{
>> +	u16 val =3D 0;
>> +
>> +	val |=3D port << HR_PSEL_PTWSEL_SHIFT;
>
> Why not just assign val to port << HR_PSEL_PTWSEL_SHIFT directly?

OK.

>
>> +
>> +	hellcreek_write(hellcreek, val, HR_PSEL);
>> +}
>> +
>> +static void hellcreek_select_prio(struct hellcreek *hellcreek, int prio)
>> +{
>> +	u16 val =3D 0;
>> +
>> +	val |=3D prio << HR_PSEL_PRTCWSEL_SHIFT;
>> +
>> +	hellcreek_write(hellcreek, val, HR_PSEL);
>
> Likewise
>
>> +}
>> +
>> +static void hellcreek_select_counter(struct hellcreek *hellcreek, int c=
ounter)
>> +{
>> +	u16 val =3D 0;
>> +
>> +	val |=3D counter << HR_CSEL_SHIFT;
>> +
>> +	hellcreek_write(hellcreek, val, HR_CSEL);
>> +
>> +	/* Data sheet states to wait at least 20 internal clock cycles */
>> +	ndelay(200);
>
> Likewise.
>
> [snip]
>
>> +static void hellcreek_feature_detect(struct hellcreek *hellcreek)
>> +{
>> +	u16 features;
>> +
>> +	features =3D hellcreek_read(hellcreek, HR_FEABITS0);
>> +
>> +	/* Currently we only detect the size of the FDB table */
>> +	hellcreek->fdb_entries =3D ((features & HR_FEABITS0_FDBBINS_MASK) >>
>> +			       HR_FEABITS0_FDBBINS_SHIFT) * 32;
>> +
>> +	dev_info(hellcreek->dev, "Feature detect: FDB entries=3D%zu\n",
>> +		 hellcreek->fdb_entries);
>
> You may consider reporting this through devlink.
>
>> +}
>> +
>> +static enum dsa_tag_protocol hellcreek_get_tag_protocol(struct dsa_swit=
ch *ds,
>> +							int port,
>> +							enum dsa_tag_protocol mp)
>> +{
>> +	return DSA_TAG_PROTO_HELLCREEK;
>> +}
>> +
>> +static int hellcreek_port_enable(struct dsa_switch *ds, int port,
>> +				 struct phy_device *phy)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port *hellcreek_port;
>> +	unsigned long flags;
>> +	u16 val;
>> +
>> +	hellcreek_port =3D &hellcreek->ports[port];
>> +
>> +	dev_dbg(hellcreek->dev, "Enable port %d\n", port);
>> +
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>
> Your usage of the spin lock is not entirely clear to me, but it protects
> more than just the register access, usually it has been sprinkled at the
> very beginning of the operations to be performed.
>
> DSA operations should always be RTNL protected and they can sleep. You
> do not appear to have an interrupt handler registered at all, so maybe
> you can replace this by a mutex, or drop the spin lock entirely?

Yes. However, the TAPRIO offloading patch adds hrtimers. Therefore, the
spin lock in the irq variant is needed.

>
> [snip]
>
>> +static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
>> +				      struct net_device *br)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	u16 rx_vid =3D port;
>> +	int i;
>> +
>> +	dev_dbg(hellcreek->dev, "Port %d joins a bridge\n", port);
>> +
>> +	/* Configure port's vid to all other ports as egress untagged */
>> +	for (i =3D 2; i < NUM_PORTS; ++i) {
>> +		const struct switchdev_obj_port_vlan vlan =3D {
>> +			.vid_begin =3D rx_vid,
>> +			.vid_end =3D rx_vid,
>> +			.flags =3D BRIDGE_VLAN_INFO_UNTAGGED,
>> +		};
>> +
>> +		if (i =3D=3D port)
>> +			continue;
>> +
>> +		hellcreek_vlan_add(ds, i, &vlan);
>
> Can you explain that part a little bit more what this VLAN programming
> does and why you need it?

Sure. To reflect the DSA port separation, I created two VLANs containing
each the CPU port and one front port. The bridge setup is now just
extending this to include all ports.

>
> The bridge will send a VLAN programming request with VLAN ID 1 as PVID,
> thus bringing all ports added to the bridge into the same broadcast
> domain.

I see. Maybe that works as well. I'll have to test it. Should the bridge
callbacks be removed then?

>
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
>> +					struct net_device *br)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	u16 rx_vid =3D port;
>> +	int i, err;
>> +
>> +	dev_dbg(hellcreek->dev, "Port %d leaves a bridge\n", port);
>> +
>> +	/* Remove port's vid from all other ports */
>> +	for (i =3D 2; i < NUM_PORTS; ++i) {
>> +		const struct switchdev_obj_port_vlan vlan =3D {
>> +			.vid_begin =3D rx_vid,
>> +			.vid_end =3D rx_vid,
>> +		};
>> +
>> +		if (i =3D=3D port)
>> +			continue;
>> +
>> +		err =3D hellcreek_vlan_del(ds, i, &vlan);
>> +		if (err) {
>> +			dev_err(hellcreek->dev, "Failed add vid %d to port %d\n",
>> +				rx_vid, i);
>> +			return;
>> +		}
>> +	}
>> +}
>> +
>> +static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
>> +			       const struct hellcreek_fdb_entry *entry)
>> +{
>> +	int ret;
>> +	u16 meta =3D 0;
>> +
>> +	dev_dbg(hellcreek->dev, "Add static FDB entry: MAC=3D%pM, MASK=3D0x%02=
x, "
>> +		"OBT=3D%d, REPRIO_EN=3D%d, PRIO=3D%d\n", entry->mac, entry->portmask,
>> +		entry->is_obt, entry->reprio_en, entry->reprio_tc);
>> +
>> +	/* Add mac address */
>> +	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FD=
BWDH);
>> +	hellcreek_write(hellcreek, entry->mac[3] | (entry->mac[2] << 8), HR_FD=
BWDM);
>> +	hellcreek_write(hellcreek, entry->mac[5] | (entry->mac[4] << 8), HR_FD=
BWDL);
>> +
>> +	/* Meta data */
>> +	meta |=3D entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
>> +	if (entry->is_obt)
>> +		meta |=3D HR_FDBWRM0_OBT;
>> +	if (entry->reprio_en) {
>> +		meta |=3D HR_FDBWRM0_REPRIO_EN;
>> +		meta |=3D entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
>> +	}
>> +	hellcreek_write(hellcreek, meta, HR_FDBWRM0);
>> +
>> +	/* Commit */
>> +	hellcreek_write(hellcreek, 0x00, HR_FDBWRCMD);
>> +
>> +	/* Wait until done */
>> +	ret =3D hellcreek_wait_fdb_ready(hellcreek);
>> +
>> +	return ret;
>
> Can you just do a tail call return here?

Sure.

>
>> +}
>> +
>> +static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
>> +			       const struct hellcreek_fdb_entry *entry)
>> +{
>> +	int ret;
>> +
>> +	dev_dbg(hellcreek->dev, "Delete FDB entry: MAC=3D%pM!\n", entry->mac);
>> +
>> +	/* Delete by matching idx */
>> +	hellcreek_write(hellcreek, entry->idx | HR_FDBWRCMD_FDBDEL, HR_FDBWRCM=
D);
>> +
>> +	/* Wait until done */
>> +	ret =3D hellcreek_wait_fdb_ready(hellcreek);
>> +
>> +	return ret;
>
> Likewise
>
>> +}
>> +
>> +/* Retrieve the index of a FDB entry by mac address. Currently we searc=
h through
>> + * the complete table in hardware. If that's too slow, we might have to=
 cache
>> + * the complete FDB table in software.
>> + */
>> +static int hellcreek_fdb_get(struct hellcreek *hellcreek,
>> +			     const unsigned char *dest,
>> +			     struct hellcreek_fdb_entry *entry)
>> +{
>> +	size_t i;
>> +
>> +	/* Set read pointer to zero: The read of HR_FDBMAX (read-only register)
>> +	 * should reset the internal pointer. But, that doesn't work. The vend=
or
>> +	 * suggested a subsequent write as workaround. Same for HR_FDBRDH belo=
w.
>> +	 */
>> +	hellcreek_read(hellcreek, HR_FDBMAX);
>> +	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
>> +
>> +	/* We have to read the complete table, because the switch/driver might
>> +	 * enter new entries anywhere.
>> +	 */
>> +	for (i =3D 0; i < hellcreek->fdb_entries; ++i) {
>> +		unsigned char addr[ETH_ALEN];
>> +		u16 meta, mac;
>> +
>> +		meta	=3D hellcreek_read(hellcreek, HR_FDBMDRD);
>> +		mac	=3D hellcreek_read(hellcreek, HR_FDBRDL);
>> +		addr[5] =3D mac & 0xff;
>> +		addr[4] =3D (mac & 0xff00) >> 8;
>> +		mac	=3D hellcreek_read(hellcreek, HR_FDBRDM);
>> +		addr[3] =3D mac & 0xff;
>> +		addr[2] =3D (mac & 0xff00) >> 8;
>> +		mac	=3D hellcreek_read(hellcreek, HR_FDBRDH);
>> +		addr[1] =3D mac & 0xff;
>> +		addr[0] =3D (mac & 0xff00) >> 8;
>> +
>> +		/* Force next entry */
>> +		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
>> +
>> +		if (memcmp(addr, dest, 6))
>
> ETH_ALEN instead of 6 would make it obvious what this is about

Of course. I've simply missed that.

> , don't
> you also need to compare against a VLAN ID somehow?

The hardware doesn't provide VLAN information for fdb entries.

>
> [snip]
>
>> +
>> +/* Default setup for DSA:
>> + *  VLAN 2: CPU and Port 1 egress untagged.
>> + *  VLAN 3: CPU and Port 2 egress untagged.
>
> Can you use any of the DSA_TAG_8021Q services to help you with that?

Maybe dsa_port_setup_8021q_tagging() could be used. It does distinguish
between RX and TX, but I assume it'd also work. Needs to be tested.

>
> [snip]
>
>> +
>> +static const struct dsa_switch_ops hellcreek_ds_ops =3D {
>> +	.get_tag_protocol    =3D hellcreek_get_tag_protocol,
>> +	.setup		     =3D hellcreek_setup,
>> +	.get_strings	     =3D hellcreek_get_strings,
>> +	.get_ethtool_stats   =3D hellcreek_get_ethtool_stats,
>> +	.get_sset_count	     =3D hellcreek_get_sset_count,
>> +	.port_enable	     =3D hellcreek_port_enable,
>> +	.port_disable	     =3D hellcreek_port_disable,
>> +	.port_vlan_filtering =3D hellcreek_vlan_filtering,
>> +	.port_vlan_prepare   =3D hellcreek_vlan_prepare,
>> +	.port_vlan_add	     =3D hellcreek_vlan_add,
>> +	.port_vlan_del	     =3D hellcreek_vlan_del,
>> +	.port_fdb_dump	     =3D hellcreek_fdb_dump,
>> +	.port_fdb_add	     =3D hellcreek_fdb_add,
>> +	.port_fdb_del	     =3D hellcreek_fdb_del,
>> +	.port_bridge_join    =3D hellcreek_port_bridge_join,
>> +	.port_bridge_leave   =3D hellcreek_port_bridge_leave,
>> +	.port_stp_state_set  =3D hellcreek_port_stp_state_set,> +	.phylink_val=
idate    =3D hellcreek_phylink_validate,
>
> No mac_config, mac_link_up or mac_link_down operations?

No, they're not needed. Currently the hardware only does 100Mbit/s full
duplex. So, I've just created the phylink validate function to advertise
that mask.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8L/4EACgkQeSpbgcuY
8KZEXQ//fMJyfNx6s6XWIT1USRpH4AL7M3S0JdQWiwKLJy1GA94oskjppnTU7iXy
kUg0Yi8lvxZ4GE9rpNhtLDj7k7+7tduUMpDE0wj5EmeXmEuZsOG6eGQ+7AONBS0g
QNqDbLGBJZk1XXgEWSdCxxjRumFsSBDeh/CJtfO0a4pu+6ZNOM7d63VPONN1Xhsa
I04BMULrGtRg9PVBooaAWGqNB2EV4g3k+puTh+xD67FGkdgdeuznb+RVsiz+SK7V
Sz52AHU9qMv0GGU+OtmdWZeUpqsl9ZoxvVgdsZ93GoE5b1pNvBcgIVW7UXRRYAwx
OWsf2U4EuyjXYDPboqstY6QDNDzVMLS+NzbMs3JmLX+TvkSRz3cymxKPGGHgf9Qw
5bIAknVRDKRav9lVJ88yJ7gSMqkuGAPq6V0eDwqtYrJXnzNbz8TN1m0nXpi1lAul
pm7sOystPBEqbeoKEzFiE6Vir5fLjvmZW3sID2RAe2ufMlqXH+KuS4DXiIGBHLJS
BnNSFL8pQ7b70GPKQBN2rSN+ZQXtRDu2D3TfNYfg21bjO9JHFcnA/TsYaZqMv19S
Qo/O8dL/UxhH7pqTR08M53yx4/lBMzbHuVP0GwlLGsXJBbOlyxegz9XKs1wGFXW2
gBFdL/7Mcer9kEkdE64E4O6tdp6tfaBjmN7hDPiAJ6t5ylmLkxE=
=MtV4
-----END PGP SIGNATURE-----
--=-=-=--
