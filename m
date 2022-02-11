Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445004B2213
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245382AbiBKJfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:35:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiBKJfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:35:07 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2130.outbound.protection.outlook.com [40.107.22.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03721037
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:35:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sy18yCtVytsziqyHYk974mVjMUnCtOM3Ea2LpRWUPfsjHL1n6WH7CzXt2EyN8G7TsHODAUZpiC3e1gXTSkvSva2YopabNV2F+YXg36QP6sBUvv6HC1QR7YEZbHjJs7aczzL0Yfkj6t4HEIDhLDqt0jo0xr/r+PnQUfYw0ZGr1NRQLEz3c51QeJ90dyo5Op+QrpZ+2/Phvmkfuq/FMVlkDV8CuieBSWE8qrqlVrfdrh2xt4JBHjuX3i7069eMVx9BN3jVX4Fwjd2MF0qGbarNn7GJjpROoUt803dNnYqV6/DpKqkNxYIoiIEZp3hr2NhUS1mSj703OHXvcdQofGRARw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXdHliztLnaqgW0nSi7M2WGwGEzHgQCPCOsGjP90ZPg=;
 b=JuR0dWfVAnpZVZDD/DDXAgLTTyjdDqs8Q7FvNSpwfRN1/S4QhY/tKm5Md319aWsLQ2dXMwWukFDA8IEtIuB6perCcUoFGYGozINiRX/jYo0FhQUazZKEOC9hgiUzogfFwHboTIQiG5wk/MYlELOZvC+3nXlEXiei8Kyhne2aaYIO50b1c4XvMvwUHasgrGvWsBVCgGfwxnr77NBM15MXgfWuFyrDjYKUbkzomXGtgiHyiyFWSDJCjRUrxqflnTaGDM75Q5+rIDFYmsDiHTqOmnjFScI1iF3p0pIkxucSOQYTYJMRmKkzEBqhNMeX+RUXQYI7uPzLSPFKUuvka+7NQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXdHliztLnaqgW0nSi7M2WGwGEzHgQCPCOsGjP90ZPg=;
 b=GhtgK0YKz4qa9azGkw5xH0Bayjtmf36DOK34oo7ilFfOuQJ38khpl7XiIGcU+KlrBccnNK/swKI198hz/iMFYKrc8uuYzH8ct8gnDKrMTobzBBid9/kBFuFDUIadKrhDAqqVmIkIZ3dPLIqBpPt/l9ypcUbH1Ia/6lolxFIPzaY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PA4PR03MB7039.eurprd03.prod.outlook.com (2603:10a6:102:ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Fri, 11 Feb
 2022 09:35:03 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4975.015; Fri, 11 Feb 2022
 09:35:01 +0000
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
Subject: Re: [PATCH net-next] net: dsa: OF-ware slave_mii_bus (RFC)
Thread-Topic: [PATCH net-next] net: dsa: OF-ware slave_mii_bus (RFC)
Thread-Index: AQHYHwX/S16Y1GlrHEmx5xkya6A7mA==
Date:   Fri, 11 Feb 2022 09:35:01 +0000
Message-ID: <87fsopwxtn.fsf@bang-olufsen.dk>
References: <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>
        <20220211051140.3785-1-luizluca@gmail.com>
In-Reply-To: <20220211051140.3785-1-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Fri, 11 Feb 2022 02:11:41 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee8540ba-d96c-4cd6-f0ea-08d9ed41c6df
x-ms-traffictypediagnostic: PA4PR03MB7039:EE_
x-microsoft-antispam-prvs: <PA4PR03MB703900E7520920A9F4B3CC0783309@PA4PR03MB7039.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pUKkbblDA+5nFRZIxZE7acGu3XSn6w9D/cgfjz3O7NPSUmG/ijEn8tNoJTf85hIZBDW06SBH4RtB74/EuibaRnjSj1mkhKmi82RQypEsnq7elm15LoEmZHuCF2EBaXPvVQntj9Plfrx4JLA+fcb0I23R1FRw+xPOR5vQoeCjpaVw0Bezw3XBivPbG/H6N8Kmh6S3qYaa/3rIAPvD87Afz/ok/Rh0Tesa+ebjQg20ty6TN4ICvm0nUocKvJRf2fLBlAv8RQ1539BAofrZVQhQxf/Z9YvrV6Qm2u6omfgRf3ZH2ksI+IOW1L8N1hXKyDIU7RgAfWuYQCyN33nTP6oZlP8ORDFRSGtv7WgHn1DQ6zNEbRZNpL5EIeF2tEVRcofzwJDM8msE8y6xWrPmYSopW7XlKKniW74gAUMI0RCj/cwriNJWh4z4tu4mXctv/hx3uQOLb2qPNuaKQIjDf8HLdPZZMB2e5GZ2egd59dKTkORwUGcdNtMPFvj5OgbRCYndzzsVySW2FyayRN9CkKasNWjKL9QiIwzRyeB5a8/iQUEnp072sE58Sl595++At9EmfeBD5yKAETOjN/YbWATccxRcBHAY+JFq++ufvhF6oJwnuD0MLg2Z1VIQzDYVA0B/IaPjOkP47lanf6nQ3ukpryMHmo6MPqAmTrjEMWqd70xx31cOCiHoyLcmbG0WZ5ztqcP2xy0g+IEFwC4aO38eJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66446008)(66476007)(76116006)(86362001)(38070700005)(122000001)(8936002)(8676002)(508600001)(66946007)(66556008)(38100700002)(64756008)(71200400001)(26005)(6486002)(54906003)(7416002)(8976002)(316002)(6916009)(2616005)(2906002)(91956017)(186003)(6512007)(4326008)(6506007)(5660300002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?fSrgJj0lqnctTta8t4H6YwyHlNdt/wLK1hdf4ExdQIvdYda7GYBUe8q5?=
 =?Windows-1252?Q?pPO865oK+l9MIW9hhD/Orl+JvQp6rNJK8sp4zwpPEylTqYAf8hl8V3bG?=
 =?Windows-1252?Q?NbiPqzE8Vn37JhanA9tYGEwVRRJBh76MOodkp0TN9ClBsTYcUsXRZLXf?=
 =?Windows-1252?Q?WmWduXyi94YxgcQdBnSvsRIzwPfz8yIdBcZjAJR/EYMSHmLDYLJxvtT/?=
 =?Windows-1252?Q?ZPlOTWfnb7WZQu2ok9SGriHODGIkTCPw2q6yKuH/OtWu5AT62BPnYHc+?=
 =?Windows-1252?Q?21SXG68mJa3Ic/xFnd4QV8lYIXkZeZkCgYQAV0axiRkBVu8/CHDD8A8j?=
 =?Windows-1252?Q?W9RNiiQwDEvGX1/7ETHnND+iqQaq0xMqK48EPABX14fj3newijyzU8Jo?=
 =?Windows-1252?Q?kD3R1Jb+KnCyasxacnunkKyQeVwwDnCMoP3HxBjx3iEYtQz4WFouIpLg?=
 =?Windows-1252?Q?iz39zC6XinksdfTJBlbsOIqbZoaU4uWidM/2zRbSAgD45Zovd9JvKCp3?=
 =?Windows-1252?Q?0Qi5n7nbPltt+naJ/pOQMkLOTorNAcFQSypYu0bcggzco9RHRNLIJPJ+?=
 =?Windows-1252?Q?RIHuytfJyhW7LTR7UgBHwnLqVX/D/eP9kSWj+VLJ9ln7JEzEEitNCGiP?=
 =?Windows-1252?Q?qY7HaNyDbdTfvvxDLo+OzerY0ujCWgBWJXL7n3xEtgq+85q7bMtM2yae?=
 =?Windows-1252?Q?jAyvTr0zxp4dVnwI7KGwk/uEGrRKjt7dUlD0PahcLy16TtIRyK9ZZ13p?=
 =?Windows-1252?Q?/pQzd/BldtvKtQdvsVxfOfGTeU7BAwpvXDtczBG2giCnSzQDybWHtdBN?=
 =?Windows-1252?Q?CUT3HLW218ejwYn96PAWBd+WD56eCCR9i2Ch6B8/iHuf/vhCJp1T47eh?=
 =?Windows-1252?Q?Cf54SgnIBX7npq/YVb2TwY+TLwA0QuhhXVb/64E17jLSdbvj1b2kFK6t?=
 =?Windows-1252?Q?YKGh273VoYIbNAiF9097Zx/k1AeU1eCE9yPTRIqGJymUFgIYSqwPlTkx?=
 =?Windows-1252?Q?faWGmRdjG+6WbQ6mWDezqijrnwj/yYEXtafw+zrhcfPW06QgLlAknkS0?=
 =?Windows-1252?Q?iG29m81M0o/0rS1Id9YZi5tRFSTeif5cw3HkinC0/1tVQL2dQmpXwPc/?=
 =?Windows-1252?Q?zo4aJLwSvystAYSzIGaai8qSJIIZ9KrwBuiudje6qBD6J2BHZmnAyJv6?=
 =?Windows-1252?Q?Z/i/GHST9RbyMIcGNOPDqxGGhQ84qsXBlAkElUA8QuFVM9pjNhKZOcTR?=
 =?Windows-1252?Q?jNOzzxNfabPv1EP9/kgIyauqlriN9V80MF3yIl8OIqUTSm027IgjP+NN?=
 =?Windows-1252?Q?dphn5zv5qvfwysDMJyXohLNLD9+k4Uvx/rurZZIquONqQQVovkRHdEGL?=
 =?Windows-1252?Q?hnA/eBwtVeUSRty2ktSu1bVYkDJFFqmBU4zHl9+JHZZbfBmOIfIXfanZ?=
 =?Windows-1252?Q?UcGaAFLoEl3Y/7dbqzdE29NJdlY2nBs79lqiFUTSdE0r7P68aONRjip9?=
 =?Windows-1252?Q?LfeGRiwjqQoTE38zwvN6GmrL8OvQYN95ZoiPqo4/O0ZMBmq/GjnuT7Ql?=
 =?Windows-1252?Q?3PVqCswSzImhMy3UUYqgMRAquLmxBsSF+NnlASzzvsrAZdquJondQA+J?=
 =?Windows-1252?Q?qQ5DsJoZx3YRTvRp3+FvQny3ATNT8Iy/cjMvKAr0wvhKEj0E7KUTKE8u?=
 =?Windows-1252?Q?bgJtgxRGq6iniGX9XRXr20gv6bb3VX8CmX1iGmipWrOZDdRW1vwXOX9q?=
 =?Windows-1252?Q?KWEKWpJFmgTMz7sK6oI=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8540ba-d96c-4cd6-f0ea-08d9ed41c6df
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 09:35:01.3920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4tEWdbZAx0Y3mDBFABcEq8rKgHChWPRPxes/qbn/9Ek7hmNrGKdPpNWLFAUBES2BVQdRlc15mzIwGyQY5Gwwsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> If found, register the DSA internal allocated slave_mii_bus with an OF
> "mdio" child object. It can save some drivers from creating their
> internal MDIO bus.
>
> Some doubts:
> 1) is there any special reason for the absence of a "device_node dn" in
>    dsa_switch? Is there any constraint on where to place it?
> 2) Is looking for "mdio" the best solution?
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  include/net/dsa.h | 2 ++
>  net/dsa/dsa2.c    | 8 +++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index b688ced04b0e..c01c059c5335 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -421,6 +421,8 @@ struct dsa_switch {
>  	u32			phys_mii_mask;
>  	struct mii_bus		*slave_mii_bus;
> =20
> +	struct device_node	*dn;
> +
>  	/* Ageing Time limits in msecs */
>  	unsigned int ageing_time_min;
>  	unsigned int ageing_time_max;
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 909b045c9b11..db1aeb6b8352 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/of.h>
> +#include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <net/devlink.h>
>  #include <net/sch_generic.h>
> @@ -869,6 +870,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_s=
witch *ds)
>  static int dsa_switch_setup(struct dsa_switch *ds)
>  {
>  	struct dsa_devlink_priv *dl_priv;
> +	struct device_node *dn;
>  	struct dsa_port *dp;
>  	int err;
> =20
> @@ -924,7 +926,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
> =20
>  		dsa_slave_mii_bus_init(ds);
> =20
> -		err =3D mdiobus_register(ds->slave_mii_bus);
> +		dn =3D of_get_child_by_name(ds->dn, "mdio");

of_node_put(dn) after registration? Or else who will put it?

> +
> +		err =3D of_mdiobus_register(ds->slave_mii_bus, dn);
>  		if (err < 0)
>  			goto free_slave_mii_bus;
>  	}
> @@ -1610,6 +1614,8 @@ static int dsa_switch_parse_of(struct dsa_switch *d=
s, struct device_node *dn)
>  {
>  	int err;
> =20
> +	ds->dn =3D dn;
> +
>  	err =3D dsa_switch_parse_member_of(ds, dn);
>  	if (err)
>  		return err;=
