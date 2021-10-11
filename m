Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D86B4299D9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 01:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhJKXci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 19:32:38 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:16705
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235583AbhJKXch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 19:32:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHeHCdjK+44eDCmpmP8xz2zRra9r7cfjB/mOMjiqzicMWXGBZjhSipGrr2lFm5xVaXsf/g7Y80Nm6d2zDkWhw3NPN0qysvyjwP1AIPEbcSmyOt12PH48jZabmQFKhxOwzlHeaqOhaBxsaCq/oM2fHvS4A9jyZlQATYs0O5LcyfaF8VUGegBPynPJcXCNO1OVsDc60+A/XHq+NMNYpTWgEQYG66lodu90EWIg+F+VaC8n5zd/yLaHgrnNeWnjxhyMOvgha/NfCYF6RU+EJIcwXj9bsX218q2HVFN5axHcbUWEmPY8j8kKrVMZ2QIhfM59JLNND5Jq9Rqg6gxWNgiWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6QO7pUQLlf7bzNlh/MolcGxXNEU7LBgptzp6TZYWt8=;
 b=KRu+Q7AdV6JZQiA7xcfwywLOxyvQKxpJLApnVih0GpPmfynwEwOQoAuocTE47zRqVgTF4bWbYH3wr+EypvNp3G3RtgZja7CDwTUZilPbfsRV3ZpptKYcJEkoX2e4LT/kw/s3t/zplIT6uqUPktsBW0cUheEM+/Rq+2SNsi0wgql2TfLU8E33+f4SHScJfeZt/6GKUkfNBFWRX5wE2W2xXEzic12xykw/+R53LMHTeNAkiiN0wSwjHFjYFkplm1b2LNf+8OI3b1eW5tqlWWRFy6FCFMbDqpQP0ZooDWAGUK/GTY87oFkzF3T3keoT+m36t4uHMWR7uscl6GNVL202sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6QO7pUQLlf7bzNlh/MolcGxXNEU7LBgptzp6TZYWt8=;
 b=BLWOQgUyQMpQXD8yRkP0zoJ2a7TCRdEe7sIzhL75OWY9Fm2UIiXqcRC5LpWH1n7/fZb1V2KBFIjvgHXA5+OaTsZHU6P93mxtiMCxlz4FFNELDsICGL7O6QTQNTBtB2zwSMdzx2qSD2EIkJGukFOe+e2Jarn2PBnCIphplHriwR8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6125.eurprd04.prod.outlook.com (2603:10a6:803:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Mon, 11 Oct
 2021 23:30:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 23:30:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net 04/10] net: mscc: ocelot: deny TX timestamping of
 non-PTP packets
Thread-Topic: [PATCH net 04/10] net: mscc: ocelot: deny TX timestamping of
 non-PTP packets
Thread-Index: AQHXvuarGrf5JiY3GkiVM9PNSoKKEqvOcioA
Date:   Mon, 11 Oct 2021 23:30:33 +0000
Message-ID: <20211011233032.vz2sb5yxmuekgyfd@skbuf>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
 <20211011212616.2160588-5-vladimir.oltean@nxp.com>
In-Reply-To: <20211011212616.2160588-5-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0ffe0a8-0d56-421f-6d7c-08d98d0f1f49
x-ms-traffictypediagnostic: VI1PR04MB6125:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6125E955FA215E5CF496F81FE0B59@VI1PR04MB6125.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3J65Ni9Z2xtrwpHgB0KXjh9d9shgAAfCgYRE8XOSOn49r6WWWtgy4laOav6v30qJKv4h/SqKV4tK42vG61Ad+leTGHbGcEQQS8kgADO98CS0J/N0kgoDcJWE1LbLLlCaZPdc8PoycXlVmgMnI9N59V5vRGWsRE+dA20e8dqIHb+J9QkndrWHbUolxli4ITHMJHMq6eOV+675yg92U/bi8fnkTMohMpENnsrOvBV72NhNWupIhlhEILq1oR1DskdB0uVyMuPbLODA9lAc/pvohXPa4HAWFtMqrDBSMX04NkJxVg4BoXU6q36HfmeCkWdhOmBhTyRDTSMKzzj7yYOoqOy4xA9JCO5fqGTQH+j3T4r3sa95ziQscDBCuCp4UlheIg7MIVml8WB/pnEJywTCS44k7LMitccntPofK745b2Q13MJ8xO3LWlC/OMKXo7NPtlw8R+xnv9cwsfAfjdqymvkEBlT3NWfPyRUu35rF2ll7llNbE0awqCR29aOP5QeWSXBtW+uFMv2tKYAe0cwfWj2D7sIGUn587yP1Du/3+donZC8Zafh8eowvmr31Lk0XRY8LyH9MZ+M32sgHu4ibMjdbMhip1xxFPDunilW7tcZ4ZHMpK4fasa9t5xI3ISfE1VEj+rs1q+CjZ8OhpvSdTt0f5TdDY5fRv8Mfhw+5rKq164hjmhBFKWqCnE2pdHqQ/ver7IYSXM4kKSbqX8IeBPgFYaXz5+ePM9rpgZnWh44WEMbChxoA2KhmOR/l/kLgCNXMRHW+3JtTIUNMqqBVLZbJgNB/Fppa0I8uPlUZTZg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(83380400001)(186003)(8676002)(71200400001)(8936002)(26005)(38100700002)(1076003)(122000001)(86362001)(5660300002)(508600001)(66476007)(66446008)(66946007)(76116006)(966005)(7416002)(9686003)(6512007)(316002)(110136005)(6486002)(54906003)(66556008)(64756008)(38070700005)(33716001)(4326008)(6636002)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7BZZEnlgUSazSwNnfTQ+wzfBZYUo665VLTkPq+T7jWQGmgN/i28jvy1nGuBQ?=
 =?us-ascii?Q?AGzNdO0eYKdqv7UmdtvEHTCPvqV2cyRJTkQL/RD+SdJb+0EvSWsBbsGBJaUc?=
 =?us-ascii?Q?GPCTH3cSTc5orTanaM9KDBxKqvzCq/vKnwBZRMhkxKQZgSIlNFaERBmD9d1M?=
 =?us-ascii?Q?RFa6QwfuXDAf0gYgxt+VsV1F1ZZtlXZ9nxlfb2UNCiLTvSSL902CUHK9jACp?=
 =?us-ascii?Q?2NNhsAgKbjHsGZhH8tMimFjXuKjUqhvc3iG46QLkg/uAnrI2YEr8BdHdMQ8l?=
 =?us-ascii?Q?6kvmpFMqxloV5ZM/f1Ledf58RUduWF/y45tAhsrrQqVxsVQaYHCttmryrvMB?=
 =?us-ascii?Q?dOVTokuIz7A5ZrnS4PqmloZbyUAo+7Y3aMJ7RLTpa9QzdbK0ZrQE00Ykm7eg?=
 =?us-ascii?Q?vvGrhnnXdYrlAGb+bHKX9VnztMMYRUoiSw4Msi2KEApphqYTABtIM9zQ9YQo?=
 =?us-ascii?Q?aYLtIAQSX1fCBMZW1qvEH31Ia2kNqSl2xf2reh7ihWd12r1jG+2sFS9JSpfO?=
 =?us-ascii?Q?tuLrniWXfuO9MqghtYyqm1fF6cehuzVquiL3cd88yys/6fu7cD4WH34Q0bjh?=
 =?us-ascii?Q?GZknTPPmTXcuLZMoHXp73AzBHtQFK5ud/0dzku9H3Ob+nvd4mLyxoPfJm/Bm?=
 =?us-ascii?Q?y/9w5EHoUIdXt0hajqr+MkZ77XzgVVkMtTaDIkqJBouUS6dZ6Un+uzC7yveQ?=
 =?us-ascii?Q?r61oqfpLxdegCqbayCz6eKiogkKi55UH+zVPf7FkRqi1vPuuc1k3O+ZEkVR2?=
 =?us-ascii?Q?SfwBqu9DOlm4K1wOAgiAqA7s1KmbqUV4MVH4+yMoypsOLKRoSZvrmjDJkRdu?=
 =?us-ascii?Q?D7bO8o7XRdr8cFSTYN1YbimuUQwhdwaW6isQjlfzp3tNToyUe/PjHwvkcmK1?=
 =?us-ascii?Q?Nnz+87Dg+HOtrHSmSPJAakkpLUubVU2X8tBtUIxQ4oWL53zUU05DYzjsozPj?=
 =?us-ascii?Q?ryjf9FwHHoZQUQLq1RyOxVRxHUuJAgjcqP+1y5zx8kSFMOw902r6ojkfo7By?=
 =?us-ascii?Q?RWRmSL7kQUu5g0RJ60lS/U15ei8f4mzq0BicA7kZaA6lK0m7AdQmBW1jQ9C+?=
 =?us-ascii?Q?akbsaS7CFdc1XV9EMqL9YMmZLDNVTPZdh43371yh4hCxh6dzbCqSuhTg8Sf+?=
 =?us-ascii?Q?AArXRyns30kjlvLdrL+3/tEao8IPfnf/Gw6OLd6h5OPH2qZgBSx9DHjqKnxn?=
 =?us-ascii?Q?NOdN6jRU9oOxyFp+IQBuhJ87YIw2Zki4ESDAs5BJANvLhmi0/MLnLYTb5dLA?=
 =?us-ascii?Q?ewdre7uRR/fOv485iAuGiM4wrBLThhnOr4R7PLRkZzH3pdWrKZH4b4RYS52X?=
 =?us-ascii?Q?Kd+DqOu32nDc0TEEHxnbLe+cgXLVPBhdDoori/KxdhnBYw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7DA1B959E18954FA114B0FD196648CC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ffe0a8-0d56-421f-6d7c-08d98d0f1f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 23:30:33.6768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: COi2NzFQd/lAAUjruTIrhBJli3gcTFAYDKcDnyZ0qAv9xFRWhAbW4TpY9HiI/zKJ4nbLqt6k2QdCeYkqwncZJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 12:26:10AM +0300, Vladimir Oltean wrote:
> It appears that Ocelot switches cannot timestamp non-PTP frames, I
> tested this using the isochron program at:
> https://github.com/vladimiroltean/tsn-scripts
>=20
> with the result that the driver increments the ocelot_port->ts_id
> counter as expected, puts it in the REW_OP, but the hardware seems to
> not timestamp these packets at all, since no IRQ is emitted.
>=20
> Therefore check whether we are sending PTP frames, and refuse to
> populate REW_OP otherwise.
>=20
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 190a5900615b..4a667df9b447 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -618,16 +618,12 @@ u32 ocelot_ptp_rew_op(struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(ocelot_ptp_rew_op);
> =20
> -static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb)
> +static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
> +				       unsigned int ptp_class)
>  {
>  	struct ptp_header *hdr;
> -	unsigned int ptp_class;
>  	u8 msgtype, twostep;
> =20
> -	ptp_class =3D ptp_classify_raw(skb);
> -	if (ptp_class =3D=3D PTP_CLASS_NONE)
> -		return false;
> -
>  	hdr =3D ptp_parse_header(skb, ptp_class);
>  	if (!hdr)
>  		return false;
> @@ -647,11 +643,16 @@ int ocelot_port_txtstamp_request(struct ocelot *oce=
lot, int port,
>  {
>  	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
>  	u8 ptp_cmd =3D ocelot_port->ptp_cmd;
> +	unsigned int ptp_class;
>  	int err;
> =20
> +	ptp_class =3D ptp_classify_raw(skb);
> +	if (ptp_class =3D=3D PTP_CLASS_NONE)
> +		return -EINVAL;
> +

I am actually introducing an issue here, sorry that I caught it just now.
The ocelot_port_txtstamp_request() function can actually fall through
without doing anything, for example when PTP timestamping is not enabled
(felix_hwtstamp_set was not called, and ocelot_port->ptp_cmd is 0).
We may still carry PTP frames that must be timestamped by somebody else
(a PHY, a downstream DSA switch etc), and ds->ops->port_txtstamp() will
still get called, because skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP is
true, DSA doesn't have the insight on who has PTP timestamping enabled
and who doesn't.

When attached to a downstream DSA switch who is also the one performing
TX timestamping, we are processing an skb here which has SKBTX_HW_TSTAMP
set, yet is DSA-tagged, so the call to ptp_classify_raw() fails to find
the PTP header. So we print that we are "delivering skb without TX timestam=
p"
(yay us), whereas before this change, we silently did nothing anyway
because ocelot_port->ptp_cmd was zero, so this is slightly annoying.

I will wait for more feedback on the series then repost tomorrow.

>  	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
>  	if (ptp_cmd =3D=3D IFH_REW_OP_ORIGIN_PTP) {
> -		if (ocelot_ptp_is_onestep_sync(skb)) {
> +		if (ocelot_ptp_is_onestep_sync(skb, ptp_class)) {
>  			OCELOT_SKB_CB(skb)->ptp_cmd =3D ptp_cmd;
>  			return 0;
>  		}
> --=20
> 2.25.1
> =
