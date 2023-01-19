Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDF16742E6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjASTeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjASTd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:33:59 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6177E58975
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:33:55 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JJXNsb2328081
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 19:33:25 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JJXHCB3915586
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 20:33:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674156798; bh=ilBSKOfltYscqDSwDiQ8FEb5/E+5h/r6IhBRVF/CDlI=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=jSWoRJYrVUXvgZ4mthj1Lj8oweVoMQOv0hSYQuPRDli7aIDTlPGFEBG04QPV2VML6
         XQM7Obu+wXCbMHy76C3hvc+3lEPDySqSC37eYHvNnITxEHvSkxR2veZZI3/JhwaID1
         trmWJtL+a8Y5N/cKGLHoTtHFVCSIj3MxHq3E9EdI=
Received: (nullmailer pid 501956 invoked by uid 1000);
        Thu, 19 Jan 2023 19:33:17 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net 2/3] net: mediatek: sgmii: autonegotiation is required
Organization: m
References: <20230119171248.3882021-1-bjorn@mork.no>
        <20230119171248.3882021-3-bjorn@mork.no>
        <Y8l8NRmFfm/a8LFv@shell.armlinux.org.uk>
Date:   Thu, 19 Jan 2023 20:33:17 +0100
In-Reply-To: <Y8l8NRmFfm/a8LFv@shell.armlinux.org.uk> (Russell King's message
        of "Thu, 19 Jan 2023 17:21:57 +0000")
Message-ID: <87v8l2uxoi.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> On Thu, Jan 19, 2023 at 06:12:47PM +0100, Bj=C3=B8rn Mork wrote:
>> sgmii mode fails if autonegotiation is disabled.
>>=20
>> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>> ---
>>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/eth=
ernet/mediatek/mtk_sgmii.c
>> index 481f2f1e39f5..d1f2bcb21242 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
>> @@ -62,14 +62,9 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, un=
signed int mode,
>>  	 * other words, 1000Mbps or 2500Mbps).
>>  	 */
>>  	if (interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
>> -		sgm_mode =3D SGMII_IF_MODE_SGMII;
>> -		if (phylink_autoneg_inband(mode)) {
>> -			sgm_mode |=3D SGMII_REMOTE_FAULT_DIS |
>> -				    SGMII_SPEED_DUPLEX_AN;
>> -			use_an =3D true;
>> -		} else {
>> -			use_an =3D false;
>> -		}
>> +		sgm_mode =3D SGMII_IF_MODE_SGMII | SGMII_REMOTE_FAULT_DIS |
>> +			   SGMII_SPEED_DUPLEX_AN;
>> +		use_an =3D true;
>
> I wasn't actually suggesting in our discussion that this is something
> which should be changed.
>
> The reference implementation for the expected behaviour is
> phylink_mii_c22_pcs_config(), and it only enables in-band if "mode"
> says so. If we have a PHY which has in-band disabled (yes, they do
> exist) then having SGMII in-band unconditionally enabled breaks them,
> and yes, those PHYs appear on SFP modules.
>
> The proper answer is to use 'managed =3D "in-band-status";' in your DT
> to have in-band used with SGMII.

Well, yeah, I'd love to.  But then I'm back to the drawing board without
a link.  That just doesn't work for me.

What I did here also reflects what I saw in the mt7530.c debug dumps,
and how I read that code:

static int mt7531_sgmii_setup_mode_an(struct mt7530_priv *priv, int port,
				      phy_interface_t interface)
{
	if (!mt753x_is_mac_port(port))
		return -EINVAL;

	mt7530_set(priv, MT7531_QPHY_PWR_STATE_CTRL(port),
		   MT7531_SGMII_PHYA_PWD);

	mt7530_rmw(priv, MT7531_PHYA_CTRL_SIGNAL3(port),
		   MT7531_RG_TPHY_SPEED_MASK, MT7531_RG_TPHY_SPEED_1_25G);

	mt7530_set(priv, MT7531_SGMII_MODE(port),
		   MT7531_SGMII_REMOTE_FAULT_DIS |
		   MT7531_SGMII_SPEED_DUPLEX_AN);

	mt7530_rmw(priv, MT7531_PCS_SPEED_ABILITY(port),
		   MT7531_SGMII_TX_CONFIG_MASK, 1);

	mt7530_set(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_ENABLE);

	mt7530_set(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_RESTART);

	mt7530_write(priv, MT7531_QPHY_PWR_STATE_CTRL(port), 0);

	return 0;
}

static int
mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
		  phy_interface_t interface)
{
	struct mt7530_priv *priv =3D ds->priv;
	struct phy_device *phydev;
	struct dsa_port *dp;

	if (!mt753x_is_mac_port(port)) {
		dev_err(priv->dev, "port %d is not a MAC port\n", port);
		return -EINVAL;
	}

	switch (interface) {
	case PHY_INTERFACE_MODE_RGMII:
	case PHY_INTERFACE_MODE_RGMII_ID:
	case PHY_INTERFACE_MODE_RGMII_RXID:
	case PHY_INTERFACE_MODE_RGMII_TXID:
		dp =3D dsa_to_port(ds, port);
		phydev =3D dp->slave->phydev;
		return mt7531_rgmii_setup(priv, port, interface, phydev);
	case PHY_INTERFACE_MODE_SGMII:
		return mt7531_sgmii_setup_mode_an(priv, port, interface);
	case PHY_INTERFACE_MODE_NA:
	case PHY_INTERFACE_MODE_1000BASEX:
	case PHY_INTERFACE_MODE_2500BASEX:
		return mt7531_sgmii_setup_mode_force(priv, port, interface);
	default:
		return -EINVAL;
	}

	return -EINVAL;
}


AFAICS, this calls mt7531_sgmii_setup_mode_an() unconditionally for
PHY_INTERFACE_MODE_SGMII. Resulting in AN_ENABLE|AN_RESTART being set in
PCS_CONTROL_1 and SGMII_REMOTE_FAULT_DIS|SGMII_SPEED_DUPLEX_AN being set
in SGMII_MODE.  Regardless of inband or not.



Bj=C3=B8rn
