Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DEF4AFF7F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiBIVxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:53:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiBIVxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:53:37 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on0712.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE47BE00D104
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:53:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNLGi3HhPOIDF3lU9B4KGdyRNFpPpjphf6lcOT7OtkeAOdgkjXPvDzBbA7p5mTX9M0cmOlo2wH0vqLEuRHzx37IISfKulVA2cNNb68SoKpt6zv9HBf2s+viC99wnaljCgEt1qk2yiLP0YcDxElYP8+KpE8IsqBNaCMLjTaJVad0AlzopQCTrDPmYS/4tSI1GDUBtY/UXIb73X6gbHcuhrr8gs6nDia3EUwhW/QA7nUdzpOQGqFEGKsj01O6PClxpGf3fnkc0Qwvbg8oKrcpR/V14ymdeaYVBHjNighWdWM5g8aBhq6uFl78cyIBdvmWlTbZ0ffDywN8ldG370XUULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ck+S2m8VZPG5eBh7GqZ5UGXWAlSHTquOFfn/3FVY3NM=;
 b=YRDgFjyBeFOh7iWrCu88sXLApxe21VllPipaSXTVJrWa1bVX2f4cPEtWBC0IIb4JTV7e7CqbeqpfBgwiP9yNYxdwDWiwAvJt+VcSoDlznBUjVXJeGHIJ+dCozXZnMfgHlTUwdLK3yBw3H8ZcwZuV1KYZfiD1vsXafBZqOng4LsH2PK/kmT+RZuIUfhuPJp3fVL6xk6K6hMLqE5rEVi/IoFDNK81/jbaA22ZSE0z2aPbLRpIOog4ex3nJF2aTJ4djC0NXp+jK8v2AUphbKPqLEJVjBvybDkn8r5WFRbWgJSR6mrs16G+n3wXZV0HFjj0TqXm1V1DWB2LP3AjNdjabvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ck+S2m8VZPG5eBh7GqZ5UGXWAlSHTquOFfn/3FVY3NM=;
 b=fJjoM5VJZ0zlUH3bA3rGThPb0HJzpHBEluyKgqRJQxO7UqgkzY1Yf0OUhPbeZgFYzmmRS5wt/I8qT/6qhyg5+JmAJwRJn1tqkri+JEGRIw07+L5IWoph/ElQoOwv9YR2yMTNnYFAQGlPscHa4qqN0zEkXFttJa4KFaK2mhEiojM=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PR2PR03MB5308.eurprd03.prod.outlook.com (2603:10a6:101:21::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:53:34 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:53:34 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: read phy regs from
 memory when MDIO
Thread-Topic: [PATCH net-next] net: dsa: realtek: rtl8365mb: read phy regs
 from memory when MDIO
Thread-Index: AQHYHfNklnF6V33xxkat7gm19ezsyw==
Date:   Wed, 9 Feb 2022 21:53:34 +0000
Message-ID: <87leyjhfkx.fsf@bang-olufsen.dk>
References: <20220209202508.4419-1-luizluca@gmail.com>
In-Reply-To: <20220209202508.4419-1-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 9 Feb 2022 17:25:09 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22f05e32-64c9-4456-6dd8-08d9ec169e9c
x-ms-traffictypediagnostic: PR2PR03MB5308:EE_
x-microsoft-antispam-prvs: <PR2PR03MB530872A03F67D23F36820765832E9@PR2PR03MB5308.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6picF4XUPcRhsoC3XoMixZx1Lt7Lw3xpl+6nSMmJmTUEoJBqX422M59ivRo5AGN/nI9wssO4P0Nq33xWipGmbnbz5REn1sv88xC0+fjVi6mSSa2K1DckXsOIEXciHA9tNpvRSaybOWJBDDPpEaYOVv9nY9yZzl4+QE+vkXmUi2IyV1bJWyDuX595EkoUCZEM1EEVKOQq2l/ufheQ0/RiJIqZMGzpC2yw340TLoqfg1fWZ9J8VhANAlJ3H/zV6UNh///EplhGBVgxxMiYez1PrXJ85PyZHt1MwwcJWYJpWh+ETQrXvMIBJd3LPXJwqkjK2NWdo8kNeHjYWyvAF8tRs0ak97QuqegiG7O3EuXOYrlDtLG1mutVcRpNDGM1fak8gTt6eux+CswRO1duzsM7w0Qqdu//twe6AXYlcWQiaGMZouRxPrM3jFyxPNHlxLBDNvIHXekb+GJPLYn4DWqLoQPvQwWMpOQGIl/zS+58ESjFfRgNavDVAmbK3vOIi5k/ce52mKlwKU1IE0kLBX3Chrm1QJfoIYy1qKlzHT6ZHvxsa/8DU/EKb+Mj+e7dPZY/1AxjjkNgY3N15qb/fZ5tNsvGRRyG58lqXvgLgopi/rXU4pKvDifItbHz47/lXxws6892XSII4bOHbreFcs3E79mD884qsauPvZ1XMl/YFEdwLblj8mIwYpPUacw9vlEDq8aho0PIuDlGRtnMw5azwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(5660300002)(38070700005)(83380400001)(7416002)(122000001)(186003)(71200400001)(8976002)(38100700002)(6512007)(508600001)(6486002)(86362001)(91956017)(66556008)(54906003)(316002)(6916009)(66476007)(4326008)(64756008)(2906002)(66446008)(66946007)(36756003)(8676002)(8936002)(76116006)(2616005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?jR54YI24wV1u6IljNiwrsenwce2027TOqWb88cIoh6R5ot1A4vgY9CF+?=
 =?Windows-1252?Q?CHGo+wYGmu4rTVyn3eDFty4EEXW5p5qc/kx0Wnqhr0rCXENSRYOCYS1b?=
 =?Windows-1252?Q?fxu+rhUl9Jw5e/5fqiRC6Mp2PoKk8Kh0xHeBLaAh9cSuRYQ0J+dSkTbD?=
 =?Windows-1252?Q?Kx9SCr2Jf9tqLMNYeiR94ek2aZkO+5Ux6NzARnw1ZGLSFGZKkLgXJUfW?=
 =?Windows-1252?Q?HcWMoWeZGqSPiscI83qWQCyayV/T7RmWau2fUEz4HeoDgQvlaFfaV5B1?=
 =?Windows-1252?Q?CH8x7CjBcESQAR68wKYdWM/cCyIaC/WZCynFv0P/ii0zt1tQ7gsJr1jW?=
 =?Windows-1252?Q?siInh+A5MsWt009UUZuSVxMWmA1plctoC6aoWkpwU5vf7zyuZ8WB42H7?=
 =?Windows-1252?Q?rkKlf/+dDZ00G8jFjffHSEOkZgj03h4ZutR5leJTFXHS8hhfeHmQceSO?=
 =?Windows-1252?Q?M+mZLNLSsqf/n3VEVTRdT+AeEUOKrBu65zeGbNrddS4SxvMYBlJYGnYs?=
 =?Windows-1252?Q?4mj1BoV1Iyya7ygznYg+WxCe0XyNmHQ/VAgBzBTybuie+a0UOuVchJDF?=
 =?Windows-1252?Q?0bU3bNfP75JnRPMSldT9EOQFkEdDON9ciaIUhIXIn76O3u1cVzG1NGj3?=
 =?Windows-1252?Q?jAKTpVZ1OK2/WySIW+b02sSUyytc1NOKjxfLzsowoNfcaau9dYOyKOaQ?=
 =?Windows-1252?Q?anvqmQ//RJuwhtRKEVJH4liLIGfyYNwW70qwkszc9Au1O88m4XSpjWE8?=
 =?Windows-1252?Q?GkDnfo2Y8hSAbn656DIAzX4haB4sQ4wpiTNKIL++fVlzc1kjJxQBdIo7?=
 =?Windows-1252?Q?It3EzC2NyDEUSETNGK39CuPvkrulHpnUXFLQLyypzXhdjGrk5K4sQ9+j?=
 =?Windows-1252?Q?lWNScnz6c3hcIleNeQAS7sMyhgqN6BSY+pooWRXbBEs6/UGB8p546WKt?=
 =?Windows-1252?Q?ZM3Eabky7lr/1HDk+muRsEf/reyhIqHsdHssjzxT1guhcd1irrpcRFaP?=
 =?Windows-1252?Q?+0rAljBPc4T/XM8yCj+IgA7W/GFXcGcDiufj6g5uwVMa31NThkviG1LX?=
 =?Windows-1252?Q?iBi+QZHvY0bmgdH/5ywFY+n8WRijyBT6SR9GrxOe2R7rBXUbMGXQUCd2?=
 =?Windows-1252?Q?NFGX5vX4qZO6+UL+/jnX1AXrcG0+LjrQswCbQW2apm06s7m+akeVNm5R?=
 =?Windows-1252?Q?jxcdMsoEeH1PaWa4EbhrEkwLlOomeJnsDnzj3jPQZEpcbtCKu8fvdiDy?=
 =?Windows-1252?Q?bfZXColtt9VThDS6khSR1evdJe3Nc5wlrfz55bMBt8RUDYptlVCkoE/E?=
 =?Windows-1252?Q?kySyXnTX9hbB6ukyvakYhD/TyA1F+8qQ6sBtVNyvntj64C3B/GjIlxJF?=
 =?Windows-1252?Q?ZoFbEhlE9bByQ8oMAy1Yq/aQ+La32SjjPjPknVDFffY5Azqfh86I4q9q?=
 =?Windows-1252?Q?qlJrUp4ClQeZyYqPLaap5gOEBr/Gqn15PGUEd9exeIcyV+QIakTGaFlN?=
 =?Windows-1252?Q?IO4cTTJxWppeY4T6h0aItYnttTzP+bvfVb4WtyM/FIjRelHW88H4am/H?=
 =?Windows-1252?Q?uifDh52IKn9SjUC0WmIOg8QJVJDR/95Ch2F/dDNJLmdPck1s5MtjDIZk?=
 =?Windows-1252?Q?JDDJSnkIiQ7GVp+jKhNJo1BBVH4cQjwuh4+PH+AMZP0vWvtExhEB216h?=
 =?Windows-1252?Q?A9ejNravmKu12wFCQl4yP1HS7H8T+jZU+nIzbP6Z4WSAWC+P6aUxAaUx?=
 =?Windows-1252?Q?z9lnzvlK5F4NOzdgh1o=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f05e32-64c9-4456-6dd8-08d9ec169e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 21:53:34.3185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EN1tnyB73JM8JD+ggNhtac/9cyZUhGQFQ+e7su5PTtFrBmPioBbwe4p004Y5ovnwGfs22Y0MeljxyTk//qYpJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR03MB5308
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> In a SMI-connected switch, indirect registers are accessed commanding
> the switch to access an address by reading and writing a sequence of
> chip registers. However, that process might return a null reading
> (0x0000) with no errors if the switch is under stress. When that
> happens, the system will detect a link down, followed by a link up,
> creating temporary link unavailability.
>
> It was observed only with idle SMP devices and interruptions are not in
> use (the system was polling each interface status every second). It
> happened with both SMI and MDIO-connected switches. If the OS is under
> any load, the same problem does not appear, probably because the polling
> process is delayed or serialized.

I am not sure I agree with your description here. It is more likely that
there is just a bug in the driver, rather than some problem with
indirect PHY register access "when the switch is under stress". Please
see my reply to your earlier thread.

Having said that, using the more direct approach makes sense - I think I
said the same in your original MDIO series too. So this change is
justifiable in its own right.

I suggest resending this without talking in too much detail about a bug whi=
ch
is still unresolved.

Kind regards,
Alvin

>
> Although that method to read indirect registers work independently from
> the management interface, MDIO-connected can skip part of the process.
> Instead of commanding the switch to read a register, the driver can read
> directly from the region after RTL8365MB_PHY_BASE=3D0x0200. It was enough
> to workaround the null readings.
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 115 ++++++++++++++++++++++++----
>  1 file changed, 99 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realte=
k/rtl8365mb.c
> index 2ed592147c20..e0c7f64bc56f 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -595,8 +595,7 @@ static int rtl8365mb_phy_poll_busy(struct realtek_pri=
v *priv)
>  					val, !val, 10, 100);
>  }
> =20
> -static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
> -				     u32 ocp_addr)
> +static int rtl8365mb_phy_set_ocp_prefix(struct realtek_priv *priv, u32 o=
cp_addr)
>  {
>  	u32 val;
>  	int ret;
> @@ -610,19 +609,22 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek=
_priv *priv, int phy,
>  	if (ret)
>  		return ret;
> =20
> -	/* Set PHY register address */
> -	val =3D RTL8365MB_PHY_BASE;
> -	val |=3D FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK, phy)=
;
> -	val |=3D FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_5_1_MASK,
> +	return 0;
> +}
> +
> +static u32 rtl8365mb_phy_ocp_ind_addr(int phy, u32 ocp_addr)
> +{
> +	u32 ind_addr;
> +
> +	ind_addr =3D RTL8365MB_PHY_BASE;
> +	ind_addr |=3D FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK,
> +			       phy);
> +	ind_addr |=3D FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_5_1_M=
ASK,
>  			  ocp_addr >> 1);
> -	val |=3D FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
> +	ind_addr |=3D FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_M=
ASK,
>  			  ocp_addr >> 6);
> -	ret =3D regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
> -			   val);
> -	if (ret)
> -		return ret;
> =20
> -	return 0;
> +	return ind_addr;
>  }
> =20
>  static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
> @@ -635,7 +637,13 @@ static int rtl8365mb_phy_ocp_read(struct realtek_pri=
v *priv, int phy,
>  	if (ret)
>  		return ret;
> =20
> -	ret =3D rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
> +	ret =3D rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
> +	if (ret)
> +		return ret;
> +
> +	/* Set PHY register address */
> +	ret =3D regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
> +			   rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr));
>  	if (ret)
>  		return ret;
> =20
> @@ -673,7 +681,13 @@ static int rtl8365mb_phy_ocp_write(struct realtek_pr=
iv *priv, int phy,
>  	if (ret)
>  		return ret;
> =20
> -	ret =3D rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
> +	ret =3D rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
> +	if (ret)
> +		return ret;
> +
> +	/* Set PHY register address */
> +	ret =3D regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
> +			   rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr));
>  	if (ret)
>  		return ret;
> =20
> @@ -757,13 +771,82 @@ static int rtl8365mb_phy_write(struct realtek_priv =
*priv, int phy, int regnum,
> =20
>  static int rtl8365mb_dsa_phy_read(struct dsa_switch *ds, int phy, int re=
gnum)
>  {
> -	return rtl8365mb_phy_read(ds->priv, phy, regnum);
> +	struct realtek_priv *priv =3D ds->priv;
> +	u32 ocp_addr;
> +	u32 ind_addr;
> +	uint val;
> +	int ret;
> +
> +	if (phy > RTL8365MB_PHYADDRMAX)
> +		return -EINVAL;
> +
> +	if (regnum > RTL8365MB_PHYREGMAX)
> +		return -EINVAL;
> +
> +	ocp_addr =3D RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;
> +
> +	ret =3D rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
> +	if (ret)
> +		return ret;
> +
> +	ind_addr =3D rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr);
> +
> +	/* MDIO-connected switches can read directly from ind_addr (0x2000..)
> +	 * although using RTL8365MB_INDIRECT_ACCESS_* does work.
> +	 */
> +	ret =3D regmap_read(priv->map, ind_addr, &val);
> +	if (ret) {
> +		dev_err(priv->dev,
> +			"failed to read PHY%d reg %02x @ %04x, ret %d\n", phy,
> +			regnum, ocp_addr, ret);
> +		return ret;
> +	}
> +
> +	val =3D val & 0xFFFF;
> +
> +	dev_dbg(priv->dev, "read PHY%d register 0x%02x @ %04x, val <- %04x\n",
> +		phy, regnum, ocp_addr, val);
> +
> +	return val;
>  }
> =20
>  static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int r=
egnum,
>  				   u16 val)
>  {
> -	return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
> +	struct realtek_priv *priv =3D ds->priv;
> +	u32 ocp_addr;
> +	u32 ind_addr;
> +	int ret;
> +
> +	if (phy > RTL8365MB_PHYADDRMAX)
> +		return -EINVAL;
> +
> +	if (regnum > RTL8365MB_PHYREGMAX)
> +		return -EINVAL;
> +
> +	ocp_addr =3D RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;
> +
> +	ret =3D rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
> +	if (ret)
> +		return ret;
> +
> +	ind_addr =3D rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr);
> +
> +	/* MDIO-connected switches can write directly from ind_addr (0x2000..)
> +	 * although using RTL8365MB_INDIRECT_ACCESS_* does work.
> +	 */
> +	ret =3D regmap_write(priv->map, ind_addr, val);
> +	if (ret) {
> +		dev_err(priv->dev,
> +			"failed to write PHY%d reg %02x @ %04x, ret %d\n", phy,
> +			regnum, ocp_addr, ret);
> +		return ret;
> +	}
> +
> +	dev_dbg(priv->dev, "write PHY%d register 0x%02x @ %04x, val -> %04x\n",
> +		phy, regnum, ocp_addr, val);
> +
> +	return 0;
>  }
> =20
>  static enum dsa_tag_protocol=
