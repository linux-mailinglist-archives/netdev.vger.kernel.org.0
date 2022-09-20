Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635DA5BD8C7
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiITA2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiITA2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:28:01 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2074.outbound.protection.outlook.com [40.107.21.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A962C4A109
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qhhn5vh+erlMybGXr+J0py+hgP8BBeuJfSMQh5PK8sZVm+977CkyaNkeC8+Uon9LSRtWhBxAQmi/BAQaTjdzhqWaNZIN3AG14S/s4OdR1pgHKysqqSSz2FyZ0cs3b8HJ4qdNfsnp023onkifNFdVthNMdtZmr0N39kCMs8Vf/DybQAFOqoScL2jzRWQat2jYWrsUD3bVmfct/wUZBqeXLS03uK3RwpVMQC9WEtZP6OjsclviR72c/Y1TXk+SVxz90rRJY/2DkHf1EjqxfP/Zq3Fa7a9HULsn7UL8mkg6Dl8FOLAKMdvdgHYz0Ufdo7hQdaTQZmg4P5QrNCOkoV+cNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdnmHei3MR3bCPGWOq0KSU0Zx2kfYZ4WWg9mzYVKIjY=;
 b=AsX6BTlEhUAk/8irz72nZGaqs+y/3Id9AWGGorya/dNCyFutS2gp/SDzfHUXy3gy4hqB2wGU6CYTLmxLFxX3Et4OfqKoI1M+cmsVEKSFZ+R2IZg6Q2BQvFLfZlTgubUqTcE6jXtoE+MpwjjuajYgXiPB8N34HB2veih22kshmmCV78rTgqutdFuOQL4GmLLyvPALZIiL4Vn4l+dDK8Tcok8+z5rsBWnML0UbSRTzQel6wucoZXTvKZYM+2Nva4JnOPtrC2Xqul9sk9UdM2ICrfkb1IqcmL0ZxNaFixXZ6gIyTgDfbeD0n2uek/1g1Wn+LvQ8BU+UHmKNglO+y8zeRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdnmHei3MR3bCPGWOq0KSU0Zx2kfYZ4WWg9mzYVKIjY=;
 b=Q/wk0GOoA5z9GamTFmmoqbGoOumHbj/auvvm6j7iARZPRpbS3JuUop04IJpZtCjI3iCo/VlPNGKgBfApVhMuweQvhwO9GsgV1+CoR84+9wYisFaiu9a3V8/g+TpDWTVoNltMEeJh7N8TKF6bL7OHJqQ31XrepmMJsf8O9zNcCAk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 00:27:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 00:27:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 8/9] net: dsa: qca8k: Pass response buffer via
 dsa_rmu_request
Thread-Topic: [PATCH rfc v0 8/9] net: dsa: qca8k: Pass response buffer via
 dsa_rmu_request
Thread-Index: AQHYzHXTNAkm8NWrEkyBGdtW9/qVkQ==
Date:   Tue, 20 Sep 2022 00:27:56 +0000
Message-ID: <20220920002755.wdmv67yiybksqji4@skbuf>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-9-andrew@lunn.ch>
 <20220919221853.4095491-9-andrew@lunn.ch>
In-Reply-To: <20220919221853.4095491-9-andrew@lunn.ch>
 <20220919221853.4095491-9-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM0PR04MB6898:EE_
x-ms-office365-filtering-correlation-id: 374685f0-d1a1-4be9-22f8-08da9a9ef73a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vgyfIFgNRrOCpL7qOIjnNM6L5+pumkBvgllf5NmXU6kHTjRbXyUmPPCQfrWy85rIAAauspgv16RJas3olSrCzlDtBjuLHXhFmVsuwoW96esxDHPmvFwv/NoIJggua4nai++3mm4b2tw6Ix9grZnQN/5UQJRio46RZUhWRPZIE2RE2rF34xG3nKtuAg6bDAKWVN+iPDD3+MzDgUWi/Gm7lHgPejic1bvWhdYzS6nLDMft6FdmOwXe9AXlqXS51SuGXbtx2OnT+HkdjScpwANmSSibOUCMMEmW4RHJOzwr0oOe7E16dAqlUElJ1n2z0DJYdlsBGoT4vW/ViOw6bW7M/Wrld4suSNaPGoF/X6dO4uMi31TJd4Eq4N9eeeTXJHMQZbJeMozRXvkfhrRlX239d3DK9mUfAr4YGx9lJ6HR4I7hz6GdZqJz8JeuaqWBqNQmGqzvfmUqcNiRP/qBUHcQU8uq1tKJ6pd0taG+G7xm9mRtPYnpvywbAqCjCzyKhSf8PwusA6VlE5f8td38X1kmgyiyGR7HQ06hVU0akUEor8UacKqE7EeiSsCH4bAydXd/ahB9p+SqrV3Wj+r/jY1FxKy+Wh+40goWaOUqCSGo/xnym61YsJvIferCwwc229Z19ZJgWft0QRH1i5gqzSZcitB8ahX+VOmpuyFLstYk2HXWabJurOnTVorYDxh7R8MxC7wd9HdYL7SVHkvAQXVOivz7xr0X3CTsj5Xb+LbQi0txdrTBpI5B4wwjXjJ+L89mMJ7rySWbKElwCYGuR6bBmgmWpiLYePInIsjqn3ufrNE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199015)(6506007)(186003)(2906002)(38070700005)(1076003)(26005)(6512007)(9686003)(33716001)(86362001)(71200400001)(316002)(6486002)(54906003)(6916009)(4326008)(41300700001)(8676002)(66946007)(66476007)(66446008)(64756008)(76116006)(66556008)(91956017)(478600001)(8936002)(5660300002)(66899012)(122000001)(83380400001)(30864003)(38100700002)(44832011)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ljUME8wTqlf+FOwdNFthW7K27dqI+/Om9mI2uwD+eSZaCKlPQmN8osshmYAO?=
 =?us-ascii?Q?qzXGZmFkTzrHzEf3VQIPQRB36H+H58ADx/ZsJSg57MK2yRB9UhgTpR6e9xWI?=
 =?us-ascii?Q?v1lKdJl21yuYjn1136aEWMEQmTJfg9st97EuE7rS6+frVjayVV2FahUdC38k?=
 =?us-ascii?Q?A3Wlzgv5xPFCNOo14vJc+dwgCAAuMl4MKInwJBDLUze8sHCf9VnxboCgOrDs?=
 =?us-ascii?Q?QE2Kn6wdbIm3yj1MnP2MGLlCDheFNqU4I4JHl6cyGTSsnsCkIBeJcl2NGsVo?=
 =?us-ascii?Q?wjN/9ngJzczVypB5hGkoVCWTpAlDUObUNAPkqaKRQ0YuEhvkvGXrgj3xDDtt?=
 =?us-ascii?Q?su/BqsP2P+lgQ7AN+xZqI5o3+oD/7PZVF9U0r81ZNf30Uwx2QLC6DPdI5bul?=
 =?us-ascii?Q?xFnD4gyR8cqEggFXWaNceoMb0d9WV03r0URh0Hhe3KOFEdqEDVeFZpe/YyhZ?=
 =?us-ascii?Q?d87GIooicAAcCaBCqqQ9VLtDh3PUUQRwE0adcDjv2Jz2zh2EPaernP/xfdkM?=
 =?us-ascii?Q?p4sFQLBsyxKBFw8kgaCCnmEz8FkOuakoXkYDzb+gSCzyhK+AZAIkiSg0Y7Wm?=
 =?us-ascii?Q?BQIXXH9W3u5ihNwP8xbyD0C3+3bh4y/eUn7GWt7v3w+AYudeYG3mFFICvWYL?=
 =?us-ascii?Q?VHnO/2fYKBmXGfGRIaKdnhOaS8fKgSFuYukExSVkiBZsKFh4WRO1wIy8sbJt?=
 =?us-ascii?Q?Gy6srDCLt78U3v2CqQXW7I35DxFiD+n+EmOAMJgq+3FIeuD6WvYCC4VxiNwi?=
 =?us-ascii?Q?tN5sSHRt6ZESck48SBOb4enJxz6PvU4l7teZhP3OOMdRhlJziw/5+k2sxyuT?=
 =?us-ascii?Q?+YXrbhKq4JemejDaYQ+4V1IUEmDKeqUTMuHASoaQq4G+OTYKeqoKepkDq5KN?=
 =?us-ascii?Q?xXfyCqGLvN8A9mFvzhCRrhbpxMWriwQN4V87H0CTWRJw60rBFGP4aJRv/Xw4?=
 =?us-ascii?Q?fP6TVHCXHBV5qyFn2dSvut54kQ6uQ/xCz+merI3NohDVh7U32Wa0ptEPI22w?=
 =?us-ascii?Q?ncx3olCWTkpFezyFQwvX6+yRPdBLKXpgB/gKqGyslzhNrtsDu02qLsUlPaQi?=
 =?us-ascii?Q?02m/5aRYUyRf2IjNC44ny01vjxXc7E0TLkWJENW43A0vywZjJiCzYPYkDRRz?=
 =?us-ascii?Q?EAPTT6/bVMEPLVS+xMNlDYUIZv0MeW6HQy7nNTjtnEpTUjXpV63xOSQp3lsW?=
 =?us-ascii?Q?axLFUwgMMX/v42uB9aLUoqOy1e1JoiR800U3+zd7axYNHdNxCxoktm3dkTKb?=
 =?us-ascii?Q?tH/n44qEbgAwFvL2LXT2lKP0aBgxTmWWFDwXLOA8fPnKnABlW6SsXgRaA/Kc?=
 =?us-ascii?Q?p/FMmcS6jWL1DO3fBNgVn2YzDVA2CzGpVHGFTa7RFW0GozSymkPqPK3ti6Y0?=
 =?us-ascii?Q?lNLplesbINg/fk+ZYS1eBN2IJjWHX6MnZcTNrnsIIpmc/vI2eBxv8CxNH+zw?=
 =?us-ascii?Q?knqkhWnBDxnIBCOJk3E0A8K8aFo41rAyAEbUkQV2+HCj9ER4lFWn5fPCpgyC?=
 =?us-ascii?Q?ADz6R37BKoP7w8Wufb70riKKtdsLaf1VBWAYLdYwswzF7bAzgXV6j3Qk862R?=
 =?us-ascii?Q?kDVmZgYaHHuK2D7FFGBPdMVEOhg7Y51BZ6psxBq7x/5zvu0OWOTCqS1eG/97?=
 =?us-ascii?Q?zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1ABAA37770001B4D968472E0A105D563@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374685f0-d1a1-4be9-22f8-08da9a9ef73a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 00:27:56.9014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wUp4kISH+o1IF3tu0lZWOB4gkE80s3GwIProvQsnyT0ftlp+d+tXLV2xMQ52K7xReF/+CrJOoAGOAI/NOND8Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:18:52AM +0200, Andrew Lunn wrote:
> Make the calling of operations on the switch more like a request
> response API by passing the address of the response buffer, rather
> than making use of global state.
>=20
> To avoid race conditions with the completion timeout, and late
> arriving responses, protect the resp members via a mutex.

Cannot be a mutex; the context of qca8k_rw_reg_ack_handler(), caller of
dsa_inband_complete(), is NET_RX softirq and that is not sleepable.

>=20
> The qca8k response frame has an odd layout, the reply is not
> contiguous. Use a small intermediary buffer to convert the reply into
> something which can be memcpy'ed.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/qca/qca8k-8xxx.c | 31 ++++++++++++++++++++-----------
>  drivers/net/dsa/qca/qca8k.h      |  1 -
>  include/net/dsa.h                |  7 ++++++-
>  net/dsa/dsa.c                    | 24 +++++++++++++++++++++++-
>  4 files changed, 49 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k=
-8xxx.c
> index 55a781851e28..234d79a09e78 100644
> --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> @@ -138,6 +138,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switc=
h *ds, struct sk_buff *skb)
>  	struct qca8k_priv *priv =3D ds->priv;
>  	struct qca_mgmt_ethhdr *mgmt_ethhdr;
>  	u8 len, cmd;
> +	u32 data[4];
>  	int err =3D 0;
> =20
>  	mgmt_ethhdr =3D (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
> @@ -151,17 +152,16 @@ static void qca8k_rw_reg_ack_handler(struct dsa_swi=
tch *ds, struct sk_buff *skb)
>  		err =3D -EPROTO;
> =20
>  	if (cmd =3D=3D MDIO_READ) {
> -		mgmt_eth_data->data[0] =3D mgmt_ethhdr->mdio_data;
> +		data[0] =3D mgmt_ethhdr->mdio_data;
> =20
>  		/* Get the rest of the 12 byte of data.
>  		 * The read/write function will extract the requested data.
>  		 */
>  		if (len > QCA_HDR_MGMT_DATA1_LEN)
> -			memcpy(mgmt_eth_data->data + 1, skb->data,
> -			       QCA_HDR_MGMT_DATA2_LEN);
> +			memcpy(&data[1], skb->data, QCA_HDR_MGMT_DATA2_LEN);
>  	}
> =20
> -	dsa_inband_complete(&mgmt_eth_data->inband, err);
> +	dsa_inband_complete(&mgmt_eth_data->inband, &data, sizeof(data), err);
>  }
> =20
>  static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 re=
g, u32 *val,
> @@ -230,6 +230,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u3=
2 reg, u32 *val, int len)
>  {
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data =3D &priv->mgmt_eth_data;
>  	struct sk_buff *skb;
> +	u32 data[4];
>  	int ret;
> =20
>  	skb =3D qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
> @@ -249,12 +250,13 @@ static int qca8k_read_eth(struct qca8k_priv *priv, =
u32 reg, u32 *val, int len)
>  	skb->dev =3D priv->mgmt_master;
> =20
>  	ret =3D dsa_inband_request(&mgmt_eth_data->inband, skb,
> -			      qca8k_mdio_header_fill_seq_num,
> -			      QCA8K_ETHERNET_TIMEOUT);

Argument list should have been properly aligned when this patch set introdu=
ced it.

> +				 qca8k_mdio_header_fill_seq_num,
> +				 &data, sizeof(data),
> +				 QCA8K_ETHERNET_TIMEOUT);

Kind of feeling the need for an error check right here, instead of
proceeding to look at the buffer.

> =20
> -	*val =3D mgmt_eth_data->data[0];
> +	*val =3D data[0];
>  	if (len > QCA_HDR_MGMT_DATA1_LEN)
> -		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN)=
;
> +		memcpy(val + 1, &data[1], len - QCA_HDR_MGMT_DATA1_LEN);

This is pretty hard to digest, but it looks like it could work.
So this can run concurrently with qca8k_rw_reg_ack_handler(), but since
the end of dsa_inband_request() sets inband->resp to NULL, then even if
the response will come later, it won't touch the driver-provided on-stack
buffer, since the DSA completion structure lost the reference to it.

How do we deal with the response being processed so late by the handler
that it overlaps with the dsa_inband_request() call of the next seqid?
We open up to another window of opportunity for the handler to have a
valid buffer and length to which it can copy stuff. Does it matter,
since the seqid of the response will be smaller than that of the request?
Is reordering on multi-CPU, multi-queue masters handled in any way? This
will be a problem regardless of QoS - currently we assume that all
management frames are treated the same by the DSA master. But it has no
insight into the DSA header format, so why would it? It could be doing
RSS and even find some entropy in our seqid junk data. It's a bit late
to think through right now.

> =20
>  	mutex_unlock(&mgmt_eth_data->mutex);
> =20
> @@ -285,6 +287,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u=
32 reg, u32 *val, int len)
> =20
>  	ret =3D dsa_inband_request(&mgmt_eth_data->inband, skb,
>  				 qca8k_mdio_header_fill_seq_num,
> +				 NULL, 0,
>  				 QCA8K_ETHERNET_TIMEOUT);
> =20
>  	mutex_unlock(&mgmt_eth_data->mutex);
> @@ -412,16 +415,18 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data =
*mgmt_eth_data,
>  			struct sk_buff *read_skb, u32 *val)
>  {
>  	struct sk_buff *skb =3D skb_copy(read_skb, GFP_KERNEL);
> +	u32 data[4];
>  	int ret;
> =20
>  	ret =3D dsa_inband_request(&mgmt_eth_data->inband, skb,
>  				 qca8k_mdio_header_fill_seq_num,
> +				 &data, sizeof(data),
>  				 QCA8K_ETHERNET_TIMEOUT);
> =20
>  	if (ret)
>  		return ret;
> =20
> -	*val =3D mgmt_eth_data->data[0];
> +	*val =3D data[0];
> =20
>  	return 0;
>  }
> @@ -434,6 +439,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool r=
ead, int phy,
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
>  	u32 write_val, clear_val =3D 0, val;
>  	struct net_device *mgmt_master;
> +	u32 resp_data[4];
>  	int ret, ret1;
> =20
>  	if (regnum >=3D QCA8K_MDIO_MASTER_MAX_REG)
> @@ -494,6 +500,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool r=
ead, int phy,
> =20
>  	ret =3D dsa_inband_request(&mgmt_eth_data->inband, write_skb,
>  				 qca8k_mdio_header_fill_seq_num,
> +				 NULL, 0,
>  				 QCA8K_ETHERNET_TIMEOUT);
> =20
>  	if (ret) {
> @@ -514,12 +521,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool=
 read, int phy,
>  	if (read) {
>  		ret =3D dsa_inband_request(&mgmt_eth_data->inband, read_skb,
>  					 qca8k_mdio_header_fill_seq_num,
> +					 &resp_data, sizeof(resp_data),
>  					 QCA8K_ETHERNET_TIMEOUT);
> =20
>  		if (ret)
>  			goto exit;
> =20
> -		ret =3D mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
> +		ret =3D resp_data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
>  	} else {
>  		kfree_skb(read_skb);
>  	}
> @@ -527,6 +535,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool r=
ead, int phy,
> =20
>  	ret =3D dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
>  				 qca8k_mdio_header_fill_seq_num,
> +				 NULL, 0,
>  				 QCA8K_ETHERNET_TIMEOUT);
> =20
>  	mutex_unlock(&mgmt_eth_data->mutex);
> @@ -1442,7 +1451,7 @@ static void qca8k_mib_autocast_handler(struct dsa_s=
witch *ds, struct sk_buff *sk
>  exit:
>  	/* Complete on receiving all the mib packet */
>  	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
> -		dsa_inband_complete(&mib_eth_data->inband, err);
> +		dsa_inband_complete(&mib_eth_data->inband, NULL, 0, err);
>  }
> =20
>  static int
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index 682106206282..70494096e251 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -348,7 +348,6 @@ enum {
>  struct qca8k_mgmt_eth_data {
>  	struct dsa_inband inband;
>  	struct mutex mutex; /* Enforce one mdio read/write at time */
> -	u32 data[4];
>  };
> =20
>  struct qca8k_mib_eth_data {
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 1a920f89b667..dad9e31d36ce 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -1285,12 +1285,17 @@ struct dsa_inband {
>  	u32 seqno;
>  	u32 seqno_mask;
>  	int err;
> +	struct mutex resp_lock; /* Protects resp* members */
> +	void *resp;
> +	unsigned int resp_len;

Would be good to be a bit more verbose about what "protecting" means
here (just offering a consistent view of the buffer pointer and of its
length from DSA's perspective).

>  };
> =20
>  void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask);
> -void dsa_inband_complete(struct dsa_inband *inband, int err);
> +void dsa_inband_complete(struct dsa_inband *inband,
> +		      void *resp, unsigned int resp_len, int err);
>  int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
>  		       void (* insert_seqno)(struct sk_buff *skb, u32 seqno),
> +		       void *resp, unsigned int resp_len,
>  		       int timeout_ms);
>  int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeou=
t_ms);
>  u32 dsa_inband_seqno(struct dsa_inband *inband);
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 0de283ac0bfc..4fa0ab4ae58e 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -521,14 +521,24 @@ EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
>  void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask)
>  {
>  	init_completion(&inband->completion);
> +	mutex_init(&inband->resp_lock);
>  	inband->seqno_mask =3D seqno_mask;
>  	inband->seqno =3D 0;
>  }
>  EXPORT_SYMBOL_GPL(dsa_inband_init);
> =20
> -void dsa_inband_complete(struct dsa_inband *inband, int err)
> +void dsa_inband_complete(struct dsa_inband *inband,
> +			 void *resp, unsigned int resp_len,
> +			 int err)
>  {
>  	inband->err =3D err;
> +
> +	mutex_lock(&inband->resp_lock);
> +	resp_len =3D min(inband->resp_len, resp_len);

No warning for truncation caused by resp_len > inband->resp_len?
It seems like a valid error. At least I tried to test Mattias' patch
set, and this is one of the problems that really happened.

> +	if (inband->resp && resp)
> +		memcpy(inband->resp, resp, resp_len);
> +	mutex_unlock(&inband->resp_lock);
> +
>  	complete(&inband->completion);
>  }
>  EXPORT_SYMBOL_GPL(dsa_inband_complete);
> @@ -548,6 +558,7 @@ EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
>   */
>  int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
>  		       void (* insert_seqno)(struct sk_buff *skb, u32 seqno),
> +		       void *resp, unsigned int resp_len,
>  		       int timeout_ms)
>  {
>  	unsigned long jiffies =3D msecs_to_jiffies(timeout_ms);
> @@ -556,6 +567,11 @@ int dsa_inband_request(struct dsa_inband *inband, st=
ruct sk_buff *skb,
>  	reinit_completion(&inband->completion);
>  	inband->err =3D 0;
> =20
> +	mutex_lock(&inband->resp_lock);
> +	inband->resp =3D resp;
> +	inband->resp_len =3D resp_len;
> +	mutex_unlock(&inband->resp_lock);
> +
>  	if (insert_seqno) {
>  		inband->seqno++;
>  		insert_seqno(skb, inband->seqno & inband->seqno_mask);
> @@ -564,6 +580,12 @@ int dsa_inband_request(struct dsa_inband *inband, st=
ruct sk_buff *skb,
>  	dev_queue_xmit(skb);
> =20
>  	ret =3D wait_for_completion_timeout(&inband->completion, jiffies);
> +
> +	mutex_lock(&inband->resp_lock);
> +	inband->resp =3D NULL;
> +	inband->resp_len =3D 0;
> +	mutex_unlock(&inband->resp_lock);
> +
>  	if (ret < 0)
>  		return ret;
>  	if (ret =3D=3D 0)
> --=20
> 2.37.2
>=
