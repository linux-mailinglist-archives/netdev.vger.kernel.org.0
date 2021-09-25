Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBD8418424
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 21:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhIYT2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 15:28:47 -0400
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:20416
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229711AbhIYT2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 15:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDMelngmLJsHMCElPmV7eixtK1VLDQuQ+wIYSb+O+jKtJiJOzl/Ix6NMn1fJwFtB/Q6p5dxPhfYlo5A3sPgBrtHEuqyVKuEO4pcenB1chDGI2W0w/+/2wLHLIqb/D8BOzU2CH+4WU2IcSuniQDH9Etwx+XV/phI3NRSQF3xKPJG3PhlzI3K1NE0U9Xg/8mu634uSbgv9kjt72i8L6JDXLcnN0lGXhnP428CEObwh2GSJtxxQq8bJpn00dm9C065qbbju1ufUyob5ZEAoEpdbOxLZSXE94pT6AY+KPZX8XhjHxnmBBxbuwqYvf6cpRMGeLNmdHnfqHT7wV0l3AJtroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KJ1vMhSQLCphqvu3AfrZOTeAmOug2seu+xGc5s1iJok=;
 b=No3z/u91VqkI8SjxGOfXbfYPoJJQcuBm+RfzN9nlpMvz3fGlahtCiKBv6GCKyfax5T5PdCYw/YRky4g34hT9+9ulDrz3i04ZZwu40irW5Aps7H8vEJH1G88Oev63rOmfCmHawZvkui8/E9HCMR5gfgKkoquHrsyrA0B6XpLqbxnl3At+Hoi+Hu3mHIE/X58qya+C4+MaoihAemdEq3zq3rWtXsYkDtX0jEH7LcCOqU/v9/UYqcsTs8W4v4HSUCUDoI+fuisiYbLPCZvwPN9JgsZOxe1SfDd3IIpecvyoUSlHeNbBl0CKRog3Wh0uk6xdkMG/okZ9jHL9bu6wbPDLQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ1vMhSQLCphqvu3AfrZOTeAmOug2seu+xGc5s1iJok=;
 b=Su3dprtl6fo6xMGdb2Wf8zijVPcROxreDpDZ3clzEs4mdDepr7mfJF1ox6s0kLgWCTp+r70XQtNCfJDgLlILXT/K6q8nQNNejcX/Iwhf7lydfFrOEBET97sxxbTlvHQ3BRFYORO/BSET48qOwj7U7fzUu9Vo071dIPk0GYTdWG8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sat, 25 Sep
 2021 19:26:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.020; Sat, 25 Sep 2021
 19:26:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v5 net-next 3/9] net: mscc: ocelot: add MAC table stream
 learn and lookup operations
Thread-Topic: [PATCH v5 net-next 3/9] net: mscc: ocelot: add MAC table stream
 learn and lookup operations
Thread-Index: AQHXsSiIqyPSbQvi9k+5oHNKLiCyoqu1JEsA
Date:   Sat, 25 Sep 2021 19:26:59 +0000
Message-ID: <20210925192658.2wi6egpufqut5hsf@skbuf>
References: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
 <20210924095226.38079-4-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210924095226.38079-4-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ad77a97-9411-4dd0-c111-08d9805a71e2
x-ms-traffictypediagnostic: VI1PR0402MB2863:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB286373AD0E486608D7541111E0A59@VI1PR0402MB2863.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oIaGUcwjl3TaMx4dqngSGST0G8CkRTsXs7+b/H5UFun972FKUDzmFBV4lnNj5PjMiz7D10sfKbj+1uq0Af1uJjEScdAilO3c38Fr04xQ6FIq/BeX1FPjNvMcGUbLZz4P1vVFHuT/mm9PSE5u/6Z9iycqpejySU+iM8Yg56aGuwKRtXGye3urH7k+4rOjUgLdbrOTp5VfYEoVlQmCF8CuuUs91hRhM2cIQBTBNal9Zr7vcBhzyN268HqtUulzHsj3yevwhX3sZOXCXYBDOXAQdHvRS8IfQm4TegXkw6P4XvDeM9U8wFyQo+2BglRXBCigG/VdsCciGvk0EWi/4TyTAQ+cHf+WTy1Mklq+ISew3KUBEX24VJSjVJIyBjeMXTAsFOxdnuAxJpINBxUlA0AoUKswkdDasK6jySOpjVkmthtnifYBkPhUU0FHBKll8XLvELh3oLTyd79+JpSuGGjEGix55KMiAwsE6a5f7gGX+z+vkZ2MS3ZSFQZETZMZLr82KSpyKv4nISCtvrjG4x2pcz0zASZw65VleXNq6bmtmbg6gTRDv59OoJ/wH3YYp/XhSM7Z6LZgQ5DWEPabQHexNPACdDw2Cn0VParC7OP+d/aKQb2ZszSz4xNPr3NEV+SEJRlvWIIhhLWMuGk+dCwVRywcsKbxfzSJTHKYCkwcJ9mC7ZmdMJz691rHn81dzgfJwtyUrk98PQ4t6YdD4JIEBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(44832011)(54906003)(186003)(2906002)(38070700005)(6636002)(122000001)(26005)(86362001)(38100700002)(7416002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(4326008)(66946007)(71200400001)(5660300002)(8936002)(6512007)(6506007)(8676002)(9686003)(316002)(33716001)(508600001)(6486002)(83380400001)(1076003)(6862004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N8b9dXswWz7QD1ZNACeN1w5jGxQG8Vo8CPyk88MThe1D93E73ktM2yWidakm?=
 =?us-ascii?Q?98UaVUfT+4hGv+fPKIlqr55H593GivacLrR8JdcVk4kqS1X7/cwZrlzNBN3F?=
 =?us-ascii?Q?aKI4o5Vf/khfcVWsRUnCRfp0aew40eUK/KAXEcZKZe4KRWfviwWzl7xSWhxx?=
 =?us-ascii?Q?MlqVhTbs4BHAgV8+L0TzTaOOe415wGBoYt4GekOFZf++lD6c8isS+YqwFV8b?=
 =?us-ascii?Q?7OtWlWEJ2D7vUJZLJzrGa7prYWMxJsPX3EkmcHEFR4ICjcjBf846COF5Dz3n?=
 =?us-ascii?Q?l+UNL+2o2DXl6ck+0OdZ6/fwn86hYNJCcSt9slfSFTsYrWJGF1e67SJO8EC9?=
 =?us-ascii?Q?19LZL0TPcLEuXut6Y55R178jENUJPKLFNncAwiaXyPDMi8qF8dct9VH6p8oH?=
 =?us-ascii?Q?8pOJxxa0rdp6P6XY2D6R6rdyTjQE6i95KMHs8iG+p0bRHBE2T4LWlUoNMwm1?=
 =?us-ascii?Q?piipBOyjIiabO/6HnNf+BXc7kSA+i2quwHBZmeALzoeuwLmIX1iK5DRzj+1j?=
 =?us-ascii?Q?/AO/o4iEkLOBXRBBa0svXsSPAiOHlIFkDLsxfzALsCCCeV8c7dPdvf3cIq+m?=
 =?us-ascii?Q?PmJ2KQSUdoF1TLDtzHSH/yVt0sv1/fKT4XBSKmN4eiwN/0CmmYQRqedxgrnC?=
 =?us-ascii?Q?eUl7X6rIbUIo6Vqn/eiKf/pd1SwIqzcVZqLNYTRmCMq7gVQ7DsMBLopnIjvb?=
 =?us-ascii?Q?otsvOeaJJOqnvmMvuZfemAQkVkbDFvYQqcsIXVSFcYxwg14pEFEASREgpDJG?=
 =?us-ascii?Q?lw/G8ipYPcL65GVmBOeNBizz0seXXSIqdK0FYl0KR4b5oHXgm20NCPPM4o/y?=
 =?us-ascii?Q?yHtRgNapsHdsyvMa7SXJ1CU5U/Qn3HzgAa+9VmYRHknHMs/72C7xtfdWXypt?=
 =?us-ascii?Q?f/6HRta6bZvvrBvKga0a4EuMTUtaieKZFfG884eCDnvwD5ozn2eHj+FJQ8nO?=
 =?us-ascii?Q?WaeAKJcy1qKbbdFf1YO84jeoUlkVKUFUSBdArp0xeUvcxvvGYjcnb22YhkhC?=
 =?us-ascii?Q?UpL+KJI3/1+Po6AocWVJ72HSS0M18CiZBByDyOWTVdFcgQaFIM0t3bcQF4XO?=
 =?us-ascii?Q?k5PnftDeNf1YYbceXS+RBxC1UBe7MTP5GEwGcx1uG0RFJ/B4G1l8yIwp3QSE?=
 =?us-ascii?Q?zFamiH3ct+0MWqD14NJGZdRqSuENAUEfGCDVpLCh40VkVpq+is7fUFcHK0Yg?=
 =?us-ascii?Q?iPnVkAyjC698Y2SWpSvll45ZZ4XaqB518VayDcF3ebeE8scEtHzcBUJUsbmu?=
 =?us-ascii?Q?JXK9qxG21R3kd1dvZPheFto2q2he3yNzg5SoUHqMzT8Z1HI9ilaTOQkLFiJT?=
 =?us-ascii?Q?O2nWZE4fqAGYy76Y3xfmnhGw?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F37D92A3A128C94D9A3FB75B25D5FE8A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad77a97-9411-4dd0-c111-08d9805a71e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 19:26:59.4944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zHCGNlCc3hVzTMK/dfkU69+AhY7p27DatjAw7A02BscocurMKLGtr9k2sPY/C/Iq5AafJP+NvEt3lPWlLSU7qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 05:52:20PM +0800, Xiaoliang Yang wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> ocelot_mact_learn_streamdata() can be used in VSC9959 to overwrite an
> FDB entry with stream data. The stream data includes SFID and SSID which
> can be used for PSFP and FRER set.
>=20
> ocelot_mact_lookup() can be used to check if the given {DMAC, VID} FDB
> entry is exist, and also can retrieve the DEST_IDX and entry type for
> the FDB entry.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

This is most certainly not my patch either, so you can drop my name from it=
.

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 50 ++++++++++++++++++++++++++++++
>  include/soc/mscc/ocelot.h          |  5 +++
>  2 files changed, 55 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 35006b0fb963..dc65247b91be 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -114,6 +114,56 @@ int ocelot_mact_forget(struct ocelot *ocelot,
>  }
>  EXPORT_SYMBOL(ocelot_mact_forget);
> =20
> +int ocelot_mact_lookup(struct ocelot *ocelot, int *dst_idx,
> +		       struct ocelot_mact_entry *entry)

I think the arguments of this function can be improved.
Currently, "entry" is an inout argument: entry->mac and entry->vid are
input, and entry->type is output.

I think it would be better if the argument list looked like this:

int ocelot_mact_lookup(struct ocelot *ocelot, const unsigned char *addr,
		       u16 vid, enum macaccess_entry_type *type, int *dst_idx)

I think it's clearer this way which arguments are input and which are outpu=
t.

Additionally, you can stop exporting struct ocelot_mact_entry, if this
is the only reason you needed it.

> +{
> +	int val;
> +
> +	mutex_lock(&ocelot->mact_lock);
> +
> +	ocelot_mact_select(ocelot, entry->mac, entry->vid);
> +
> +	/* Issue a read command with MACACCESS_VALID=3D1. */
> +	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
> +		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_READ),
> +		     ANA_TABLES_MACACCESS);
> +
> +	if (ocelot_mact_wait_for_completion(ocelot)) {
> +		mutex_unlock(&ocelot->mact_lock);
> +		return -ETIMEDOUT;
> +	}
> +
> +	/* Read back the entry flags */
> +	val =3D ocelot_read(ocelot, ANA_TABLES_MACACCESS);
> +
> +	mutex_unlock(&ocelot->mact_lock);
> +
> +	if (!(val & ANA_TABLES_MACACCESS_VALID))
> +		return -ENOENT;
> +
> +	*dst_idx =3D ANA_TABLES_MACACCESS_DEST_IDX_X(val);
> +	entry->type =3D ANA_TABLES_MACACCESS_ENTRYTYPE_X(val);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_mact_lookup);
> +
> +int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
> +				 struct ocelot_mact_entry *entry, u32 data)

It would be nice if ocelot_mact_learn_streamdata would follow the basic
prototype of ocelot_mact_learn:

int ocelot_mact_learn(struct ocelot *ocelot, int port,
		      const unsigned char mac[ETH_ALEN],
		      unsigned int vid, enum macaccess_entry_type type)

just with the extra STREAMDATA argument at the end.
Also, could we format the STREAMDATA nicer than a raw u32?

> +{
> +	int ret;
> +
> +	mutex_lock(&ocelot->mact_lock);
> +	ocelot_write(ocelot, data, ANA_TABLES_STREAMDATA);
> +	mutex_unlock(&ocelot->mact_lock);
> +
> +	ret =3D ocelot_mact_learn(ocelot, dst_idx, entry->mac, entry->vid,
> +				entry->type);

Hm, if you temporarily drop the lock just for ocelot_mact_learn to take
it again, you allow somebody else to sneak in and learn another MAC
table entry, and the STREAMDATA will get associated with that other guy
and not with you, no?

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ocelot_mact_learn_streamdata);
> +
>  static void ocelot_mact_init(struct ocelot *ocelot)
>  {
>  	/* Configure the learning mode entries attributes:
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index e6773f4d09ce..455293652257 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -926,6 +926,11 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelo=
t, int port,
>  				bool tx_pause, bool rx_pause,
>  				unsigned long quirks);
> =20
> +int ocelot_mact_lookup(struct ocelot *ocelot, int *dst_idx,
> +		       struct ocelot_mact_entry *entry);
> +int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
> +				 struct ocelot_mact_entry *entry, u32 data);
> +
>  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
>  int ocelot_mrp_add(struct ocelot *ocelot, int port,
>  		   const struct switchdev_obj_mrp *mrp);
> --=20
> 2.17.1
> =
