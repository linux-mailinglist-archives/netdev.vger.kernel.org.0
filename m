Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE26489E80
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiAJRh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:37:58 -0500
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:13089
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238197AbiAJRh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 12:37:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VB5+xQBy7XRyTX0gbxMlY7uoN3gZChCV3glZCbWsOCuxvsn/bmrz+QtUT1q1R4BFhUFUyFRpP59WWEUQtokzOMwcKa8cuOLWbQrQ+9QATXXetNFP4ssFAingpYIIyS22RKAMuowyh+m854f6K6wWQ0uJvotx1vVHI/gZHuEwh5twCSq7JdJUMJ22beiQtHo4M7ClhsCbMpuO8X30EBZVvVWcyG/EQkzW4mBSfGDkJ/DJPvt99Xwby/YbXEkBLfyt7M3B8eRkbEUW6nsSbXqc0ArKTPMIfkD7FEUEHgpsbf2mjUdKlLJx8yNDzbr3SHz4sjejPZfIIh1V9oEjaTAAeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGdsBkQDLjT42Klfw1iOsd6Ng2n33NIETh/08mNXHlA=;
 b=I84Gyh8yo2arsFuogwKMf+58ymKzMTNkbfQIqDxSrfFfuLM1/GtD8IG4vDYT2n05cHVOP5hk6kyBsK3DHW2E7nKUMmTLMLxBWP7cBKxN3wyJO8wE/zfZxDLY4h7XIem63EqJiUXjmWjL3o24Jgx95JydTig3MVALRQ3RlSQuVApQ1IHgnU9UkMcuDUoSTfAhd/LDinABsOf856/dkP2J4waARSsbIAAQfqJUfrKURyxjgvoJ1fsQ3cn7bk7dF470tmFQSWStUqgNtQHd3FSvHz/W06Aw5T962mE1Y+SUKA3Q9DYKpiih8ZMhtH+7prRuC2obXjmOIkLP24ckiZ3C+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGdsBkQDLjT42Klfw1iOsd6Ng2n33NIETh/08mNXHlA=;
 b=TUvmDj70BCS4qh8A6BFn8jsqCF63MELE/974gkCj9rnoKTwLk2PRsj4SAlMiF68VGLDqpW0dYYz/wCoTTZ+bI2uCQl1fhGY+/z7lEG1Aqa/k7en6dRbPgRLMD0RHThCqE+qSgwbhzY/feN8Mn8bhx4shfzpLuuvoDOfrn6dgj5c=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB4065.eurprd04.prod.outlook.com (2603:10a6:208:57::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Mon, 10 Jan
 2022 17:37:55 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e507:6815:70b7:f379]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e507:6815:70b7:f379%8]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 17:37:55 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
Thread-Topic: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
Thread-Index: AQHX8npJLeRvaAz/zUWeXla1iOJ756xXs4wAgAT3T3A=
Date:   Mon, 10 Jan 2022 17:37:55 +0000
Message-ID: <AM9PR04MB83977DD63CD3DB191E79DC7D96509@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk>
 <YdhDAHxFaUhiQFbd@shell.armlinux.org.uk>
In-Reply-To: <YdhDAHxFaUhiQFbd@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26c57f46-d0b8-4f73-c279-08d9d45fefa6
x-ms-traffictypediagnostic: AM0PR04MB4065:EE_
x-microsoft-antispam-prvs: <AM0PR04MB406522A4598FAECC018959B996509@AM0PR04MB4065.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ECNMx8c+nhjjiDwn/DOh6LmrPO3PkQJgvp/EXr8J5RG6DiV6UnDf3rV7HQe8El+ux4JavFP4erD/6lAdA7UES/MRsx60HmIhn6xj0EeJUOh5s8i2S8YLnvUWkulYbG+nX+J0Qz4cMgnTKskUomjXy2qukyjsG4SOIXU85iQ7CCDtF4+QKpf+uoZKDtal/Y0WqapkSFpeadsyP1BmorBDxflpyVEyYqpRyjJMUzFjKZ9nnfeok4VAshrfRAUSFQwd6RON5cg5gUcM7JPo1fo17fcY198cbmHTMvXCbx9csxC87gavhSD584HEFC0JuSq6yaMDA0PFb5nNJekZ/qorTaldtlKYQ90Q4X8ex433EVY4QYJsOoW+971No5gEw4OLtV1DxHYhGuiMEaBo4QRqvUS4bbeZ4zV0lKuPo28lobgOGmH3dhk1jzC0yeleWJDLiRGsznXSkihtljSnGMNP8XVRm5RlT1czTOyV6RQ0DXdPlfUFKsjOSRy/FaaR6VWcHpFFbLuXi4NLTMSjwrP9OeRQTEltpsIe6xl0gG9XmZaaiAdcTFhemotgErBbLd+/lvcZ34iFR3tqakuenYejagqbcDsEiJPsX87bjNMHrDpSTj+dipcg3Ibz9Uw8nSkKUS65vMOOmFPC9mWh9Jb6QXsM/goMLktc58FNYbdfiRLfbpNP28X9eRRGkYs4oqY4qFkB9HUzQIlmXbRzNZh5d61RwP9MGWY5vvrxITAFleY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(55016003)(66946007)(66476007)(52536014)(38100700002)(64756008)(508600001)(83380400001)(71200400001)(38070700005)(66446008)(8936002)(8676002)(53546011)(9686003)(6506007)(7696005)(26005)(122000001)(66556008)(4326008)(76116006)(44832011)(86362001)(316002)(2906002)(33656002)(110136005)(186003)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fZ3EXrLopuz2uLwKOF49L7/d5we0vADa6TezYQsikqNDii92gqZdD2lYm+oX?=
 =?us-ascii?Q?2YDMCAqq61NJMLeJC+7HTrLvGWJHYeb3BLpyuryI04Pc5s6B2EAKOhAq8iNx?=
 =?us-ascii?Q?OSDxfv6Lo/d9p65wz7r78Jr/fk7dzHrP039CFQrf3pcdGbnS3TGk/lCAf5Qy?=
 =?us-ascii?Q?yl+7V+hW9S6S6ck6D205hMgYJXrKb+43BsHVooJXhoOdDWo2riWjU03y/LEA?=
 =?us-ascii?Q?GiC+o7Y7ZoNLu6R+Y/BzKBH7w56eoDwGb1SRxqzZIfc1liwGDpUp9TJcerC2?=
 =?us-ascii?Q?kcDBAdupr+UXrjwu7XYYfip4s6VnqnFcx/ndQ7XCD4GDH8GhMjgmJFBufC8Q?=
 =?us-ascii?Q?bHUM9EwUpwYx/sg8qP43EWdnKzWE/eeJ2CpgN8Ng6cAB7rlwBMI+NHY+TVtq?=
 =?us-ascii?Q?BSPEdM4NL3mlM4vUHOhPyxeP4s0uB5yppPijMmpjV2MifthFlvoHgZ8aX+vq?=
 =?us-ascii?Q?sYkFrFxEGfRcb/CSHzmC3SJG4DRp64x+bbK8MU/HA6Duv4LTUny23ib1IGGU?=
 =?us-ascii?Q?2WzJPKvZVQ+z8Z8PnldDHSVtdUtC1BYHOiuq+t8FHeJUCBdKrAh/ILwjzqtU?=
 =?us-ascii?Q?S0MaKEJr35749mjtBMU0OFxtUZ56G0L8pgxNZSs2BbWcQrah26N2bgslb51u?=
 =?us-ascii?Q?Y7l1gktf/U8ENUUZuZ5MhpIrlDNHF34HlFn+M1iNPbWHPOUOnwzrWZcg71SW?=
 =?us-ascii?Q?+/302WUhukcuAkO9qaXwZLL00DJz3ED9ukEswBfzUZNibLyXHutzqsr3+TLN?=
 =?us-ascii?Q?RAM1VfTGYQPVDDaCmhIpzfszutGRUXPHKkmiue3Dpmk2ioW6qPTl3jJK6MSQ?=
 =?us-ascii?Q?xu5X6+J9hMKFOueZFvoR9XYLijvvxoXKsrRB61qBstj30EQ+ZmkrjXNzBdwT?=
 =?us-ascii?Q?ZFQA+ob85RSJ+phpj96keewLlu/1g73vwXGsQn3GdsPJhcgdqWTTcV/6G0Ur?=
 =?us-ascii?Q?tlFhRUPZ3daFTXfzG2cvlFQcXBjtJWzs96EciXJeAJZbaz6+C3PoNXW8v5wG?=
 =?us-ascii?Q?S0KLprLrMmen7pK2lk1nywqTV4lACgkBZVpKtcaG574Q5O9JAAQpu9ZNUy+Q?=
 =?us-ascii?Q?JxKOYQorcXvCp4KkkNYOyMQfwDCx0XqehmeCa++0V5Q0NxW3tsJdivhZn919?=
 =?us-ascii?Q?BwnOfokiSvsCbr87eiUPuX4KkFqdFOmO1fxE2h7g1Z84sCLsmvg/wGsi2H3b?=
 =?us-ascii?Q?ehhYCpeo+6Mh0cPrSeQyfrAsP7zfM/h9ghxg3OdmJdmEmBUVs7zEwSwaYmi6?=
 =?us-ascii?Q?NkXXQ1X4GbJa2YzC9f49gVEXuya+FIL9NX3SuUL02XkPZx7jKRTg8Qxz0yxB?=
 =?us-ascii?Q?tzZIsxBzHZuq808WL2V2vke05jeiAr6zZ6n7ushdxvmRILl3APVO3URq1qPJ?=
 =?us-ascii?Q?E8NXBgl54OB76dfmsq7gWM0DYiU1oVrZOZg4mxbsr3b8EFNJfkNcwyCEije5?=
 =?us-ascii?Q?7wP1OVlupKm2+M3/kQaFfAphVzUXTASEDEZtqybxZam9feWNYupD2VrjYsBh?=
 =?us-ascii?Q?hB++y4b4T+qtgZQJgBvLRCo1brbRFEdfxAVWw+fQi33mxLKZQhZpbFz2iZA4?=
 =?us-ascii?Q?MlwxGVw0JC2CxPQ/t7Gnmxvet9aAImySqFjue9UqaADbNuEE4PmigLouzCpb?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c57f46-d0b8-4f73-c279-08d9d45fefa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 17:37:55.6676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6QzvTL7243WiCi+4ofeSYX96V7Qb6x3PgR5e+D5Q6dZuKUri7NHI54lml+h7TMboM4TiKDcyTHP6OScwGC2i+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Friday, January 7, 2022 3:41 PM
> To: David S. Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH CFT net-next] net: enetc: use .mac_select_pcs()
> interface
>=20
> On Thu, Dec 16, 2021 at 12:41:41PM +0000, Russell King (Oracle) wrote:
> > Convert the PCS selection to use mac_select_pcs, which allows the PCS
> > to perform any validation it needs.
> >
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>=20
> Hi,
>=20
> Can anyone test this please? Claudiu?
>=20
> Russell.
>=20

Hi Russell,

drivers/net/ethernet/freescale/enetc/enetc_pf.c: In function 'enetc_pl_mac_=
select_pcs':
drivers/net/ethernet/freescale/enetc/enetc_pf.c:942:27: error: 'struct phyl=
ink_pcs' has no member named 'pcs'
  942 |  return pf->pcs ? &pf->pcs->pcs : NULL;

I suppose you meant:
-       return pf->pcs ? &pf->pcs->pcs : NULL;
+       return pf->pcs;

With this correction I could bring up the SGMII link on my ls1028rdb.
The patch needs also rebase.

Thanks.
Claudiu

