Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3022559AE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFYVHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:07:48 -0400
Received: from mx.0dd.nl ([5.2.79.48]:38928 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYVHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 17:07:48 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id F13985FD5A;
        Tue, 25 Jun 2019 23:07:44 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="HByB3laP";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id B31961CCC22B;
        Tue, 25 Jun 2019 23:07:44 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com B31961CCC22B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561496864;
        bh=4vo7rFhxCAiafA3iOtxWYUzE7WodARfguy9JW2N4n2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HByB3laPSE/v50IOHIvi2geXczr1w/oFwXCBck+y5+s675ecMUY2kNs4KcF8dc2sZ
         mLj2CD7aTwq4KeJUZ2IBHahVs88b1wU9LD2mYe11b+OS3yt3UG5usHlxAfhNSnHJQB
         5TZtAX8yBnV0w/5TF74giM1UDhnOonCeLAHWwlv1t/dmgSjkf5Aa5h77feL1KVZdX3
         GgIeaVA4wQVLYfPDVupnyJmcrd6QbsOgbmITtkpcJMHyzi+DSchpiVo25jLa09Osjw
         Hv+X8XE7TUJD3IkOrZDEvKsqAx9+0vhpH5Rx/y0zpBmbV9omfloWTTz797jRYvTnhc
         coQZIfSDEyiaA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 25 Jun 2019 21:07:44 +0000
Date:   Tue, 25 Jun 2019 21:07:44 +0000
Message-ID: <20190625210744.Horde.ByA3LNQBeBbFGQf62NKQDXs@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Santos <daniel.santos@pobox.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK
 API
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
 <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
 <20190625190246.GA27733@lunn.ch>
 <4fc51dc4-0eec-30d7-86d1-3404819cf6fe@pobox.com>
 <20190625204148.GB27733@lunn.ch>
In-Reply-To: <20190625204148.GB27733@lunn.ch>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Lunn <andrew@lunn.ch>:

Hi Andrew,

> On Tue, Jun 25, 2019 at 02:27:55PM -0500, Daniel Santos wrote:
>> On 6/25/19 2:02 PM, Andrew Lunn wrote:
>> >> But will there still be a mechanism to ignore link partner's advertising
>> >> and force these parameters?
>> > >From man 1 ethtool:
>> >
>> >        -a --show-pause
>> >               Queries the specified Ethernet device for pause  
>> parameter information.
>> >
>> >        -A --pause
>> >               Changes the pause parameters of the specified  
>> Ethernet device.
>> >
>> >            autoneg on|off
>> >                   Specifies whether pause autonegotiation should  
>> be enabled.
>> >
>> >            rx on|off
>> >                   Specifies whether RX pause should be enabled.
>> >
>> >            tx on|off
>> >                   Specifies whether TX pause should be enabled.
>> >
>> > You need to check the driver to see if it actually implements this
>> > ethtool call, but that is how it should be configured.
>> >
>> > 	Andrew
>> >
>> Thank you Andrew,
>>
>> So in this context, my question is the difference between "enabling" and
>> "forcing".  Here's that register for the mt7620 (which has an mt7530 on
>> its die): https://imgur.com/a/pTk0668  I believe this is also what René
>> is seeking clarity on?
>
> Lets start with normal operation. If the MAC supports pause or asym
> pause, it calls phy_support_sym_pause() or phy_support_asym_pause().
> phylib will then configure the PHY to advertise pause as appropriate.
> Once auto-neg has completed, the results of the negotiation are set in
> phydev. So phdev->pause and phydev->asym_pause. The MAC callback is
> then used to tell the MAC about the autoneg results. The MAC should be
> programmed using the values in phdev->pause and phydev->asym_pause.
>
> For ethtool, the MAC driver needs to implement .get_pauseparam and
> .set_pauseparam. The set_pauseparam needs to validate the settings,
> using phy_validate_pause(). If valid, phy_set_asym_pause() is used to
> tell the PHY about the new configuration. This will trigger a new
> auto-neg if auto-neg is enabled, and the results will be passed back
> in the usual way. If auto-neg is disabled, or pause auto-neg is
> disabled, the MAC should configure pause directly based on the
> settings passed.
>
> Looking at the data sheet page, you want FORCE_MODE_Pn set. You never
> want the MAC directly talking to the PHY. Bad things will happen.
> Then use FORCE_RX_FC_Pn and FORCE_TX_Pn to reflect phydev->pause and
> phydev->asym_pause.
>
> The same idea applies when using phylink.

Thanks for this information.


I updated mt7530_phylink_mac_config(), I think I done it right this time
with the pause bits.

Now mt7530_phylink_mac_config() looks like this:

static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
				      unsigned int mode,
				      const struct phylink_link_state *state)
{
	struct mt7530_priv *priv = ds->priv;
	u32 mcr_cur, mcr_new = 0;

	switch (port) {
	case 0: /* Internal phy */
	case 1:
	case 2:
	case 3:
	case 4:
		if (state->interface != PHY_INTERFACE_MODE_GMII)
			return;
		break;
	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
		if (!phy_interface_mode_is_rgmii(state->interface) &&
		    state->interface != PHY_INTERFACE_MODE_MII)
			return;
		if (priv->p5_intf_sel != P5_INTF_SEL_GMAC5) {
			priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
			mt7530_setup_port5(ds, state->interface);
		}
		/* We are connected to external phy */
		if (dsa_is_user_port(ds, 5))
			mcr_new |= PMCR_EXT_PHY;
		break;
	case 6: /* 1st cpu port */
		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
		    state->interface != PHY_INTERFACE_MODE_TRGMII)
			return;

		if (priv->p6_interface == state->interface)
			break;
		/* Setup TX circuit incluing relevant PAD and driving */
		mt7530_pad_clk_setup(ds, state->interface);

		if (priv->id == ID_MT7530) {
			/* Setup RX circuit, relevant PAD and driving on the
			 * host which must be placed after the setup on the
			 * device side is all finished.
			 */
			mt7623_pad_clk_setup(ds);
		}
		priv->p6_interface = state->interface;
		break;
	default:
		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
		return;
	}

	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));
	mcr_new |= mcr_cur;
	mcr_new &= ~(PMCR_FORCE_SPEED_1000 | PMCR_FORCE_SPEED_100 |
		     PMCR_FORCE_FDX | PMCR_TX_FC_EN | PMCR_RX_FC_EN);
	mcr_new |= PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
		   PMCR_BACKPR_EN | PMCR_FORCE_MODE | PMCR_FORCE_LNK;

	switch (state->speed) {
	case SPEED_1000:
		mcr_new |= PMCR_FORCE_SPEED_1000;
		break;
	case SPEED_100:
		mcr_new |= PMCR_FORCE_SPEED_100;
		break;
	}
	if (state->duplex == DUPLEX_FULL) {
		mcr_new |= PMCR_FORCE_FDX;
		if (state->pause & MLO_PAUSE_TX)
			mcr_new |= PMCR_TX_FC_EN;
		if (state->pause & MLO_PAUSE_RX)
			mcr_new |= PMCR_RX_FC_EN;
	}

	if (mcr_new != mcr_cur)
		mt7530_write(priv, MT7530_PMCR_P(port), mcr_new);
}

Greats,

René


