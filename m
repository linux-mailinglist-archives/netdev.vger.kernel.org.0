Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A7C57CAEB
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiGUMv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbiGUMv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:51:26 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150071.outbound.protection.outlook.com [40.107.15.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2FC32DB3;
        Thu, 21 Jul 2022 05:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY0DM+0yHII81oq9gCGUOoK+moQTocBDrl9LreiltGblcGHnRNszkP/k9w2pokYrPFMH3l1KzQePHp+FR5Xy+MdjvDvyBAHoL8pAf/DwVVdoi51lLPdsvKFUR5YgvvrMGq+xy7PAqkSkoGf1dmZVH/emANO0ohOghH70TV8pnTLXWdNvbzpCA2kigCa4PjRkwv3RMpMSANd34GROtZaFy1BjQMHctaobs1+vftijvAa6J97ljin0vVVgcwwYNQj+iFYePQXw0Z40TnS8nPbVM5usy973wSzKTP/VJK3Ggv8Mhv6llgWhEeR1wEA2MVOGaDPrhXuprtoybRCjXZVnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9r20wHMU50u3P9ZNufIxNT8C+avIDLytNaADKuxx44=;
 b=Af79hwsH/+VBOL7AFLCW94UoouS10qU53cY0rzhMGKAD9C092PrBZRw5BYtX5b7RjiMg82sbxwu6cIPmAVX227tbixsAt1NJ0QgDi4MP8ekqse4bcygvQUL0bSRlRIzKqygY7uV6j2WUTvMvkik2tCxGjR5yGHcdPaw/LYfNVvhwwwMLS/hhpC1DDTJo+RtNt9pCpehu3pMq9rmGYE1btSfR99KyI/5HHiVcgE4aMG6ZuWK3dwE+ToAfEX6VA0QEMcc1miMcV+3F/Vv+PC2G1TviZjCamySYGiv0t2GKKAufuCbGDp43vnCXxX2WAgcH92eYHhMLB+F6NkcNySIz1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9r20wHMU50u3P9ZNufIxNT8C+avIDLytNaADKuxx44=;
 b=U65cVVZKCrWb9R6q1VQrXl4/xApnEgYB37dss3GND5wkZAm8KkfrZKjwPGnLjqeLFXZvom5GbVIib/lYJb1+fUdcpvmnFaqm3izaD6VMPe068Nl8miIiGFS9vFYjyKTPBPhidi/3AvyNXw8uE318XdBNq/sGW7dAJT2X0GzH0rU=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4623.eurprd04.prod.outlook.com (2603:10a6:803:70::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 12:51:21 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:51:21 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 20/47] net: fman: Store initialization
 function in match data
Thread-Topic: [PATCH net-next v3 20/47] net: fman: Store initialization
 function in match data
Thread-Index: AQHYmJcTwEc1y483MUKTEndPJEkOG62IzQUg
Date:   Thu, 21 Jul 2022 12:51:21 +0000
Message-ID: <VI1PR04MB580745EF94973A1468C9FE80F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-21-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-21-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57ec4c25-589e-4180-0273-08da6b17b692
x-ms-traffictypediagnostic: VI1PR04MB4623:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ryz8QCgc9njAN9VnOCpuplIh6iwTDLg6AQjrKlUnFTY4a5GCVp08DE+OfqCIJVkVcL5e3RvhzESFSBpwSq3TTwUuq9p8n88/b+hG55J/1OLr1ToouhSxZ5txDLcX/7wOGEQsifGBKYL3dWS847uFKCF9MhK0QMVTpLim++iy9cxxIqESzyFcdoT0I07gS1e/XGPpPRYN1gpvsSid/3t/ca6vOBy6h9ms7M8n7QIALonfW9TTNkEfuTk1ctE1t57SAt3+bnsWcZ0s4ZoIFW9PI7XC9Q4Cq9vRumeYsYMPAso+63Z459Z+B6PP10CZrEY6X2bik86OiOJaQyCBcut6TsRnVMvI+5Zo67IHEOutIhIFqziybkOUKXcGZ4NSlKBlGjv7pmSmaqkBDwm/1gYq+6k3Kg0kOwLyHz4SHTNG9xy06oZbi0iuWsh4FS4IujgTlmTh3ZyDSVJVPeGht3wiUyhLsPJyfNE6SJN1CEIicRDVqmfPt+Z7TFioJtjaC8y7KZq5zUmJ3n/S1/wtpQhu54FLQok7Vn0RRObI0zP2aZaHfaSJN8OCQ/i5o3u2tYSYDvNTVYGiZgTza6OBFzVqeMQaoummo/Mt9XEYqmme2Gilp1CNsrl9+X8qnjcjzR8qqWWle8GY2uRfFZLVW0w0g+IX7FA3agKdef6X+PjVUVXmyq8MlIjuk8HNF1iYPT/B57KxFS+ex0zRavdiYowZq4eAPrPuJWGpLC12CrKj3YaAszchVYcFQz1SzNzCSQfABefxusNs2w5tY3Mp5Le4Vj5v1dN7HWeO758n2eUyJv6nEwXVEGQdzyjYGPaLb3eJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(55236004)(2906002)(110136005)(53546011)(26005)(478600001)(7696005)(41300700001)(6506007)(9686003)(33656002)(86362001)(71200400001)(55016003)(38070700005)(186003)(316002)(38100700002)(122000001)(8676002)(83380400001)(5660300002)(54906003)(8936002)(4744005)(66556008)(66446008)(4326008)(66476007)(66946007)(52536014)(76116006)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Eue7Va2am3EUYXrMuMVgpqeQNfqUXn3jwi8rZRyT8dkoNqKhYFPJ4rPx2mJh?=
 =?us-ascii?Q?WfMQSI6Eo4mU5V7X9OS3R8DjrnMi4hcmeHXcUZgK0LRCECtIvEne1I9cR3Iq?=
 =?us-ascii?Q?SFhuDAVOOEAPHl/r1oZEZcXQtuuumidf9dpLyMO+do48mRBi5seBryDlQAc1?=
 =?us-ascii?Q?YZnWqFFKoKOSPNSEZqpbCtwkNIvdNbPhWgSX8fIqMb23lmjrQnaIx5BV6pfA?=
 =?us-ascii?Q?hzs3D3M/xhuehg7fXN7N+0yFVqI/5yVsLTcMif/cEEWK7TwBpCEMDWtDTee7?=
 =?us-ascii?Q?hkjtvjYpqRIqEw3AePb3RYtXFirqoZDb9AxeazfrPgPj4TU1xHDyypTaXW3R?=
 =?us-ascii?Q?qti2zsRBQqshidvxCAvkrLOGpH2wMEUWhNiWpcaNQ7BkLQGmmcJqW9ZmTw5m?=
 =?us-ascii?Q?+mJysVAPDMFG63FSNAGLn/Cpf3lFQAMhQOj1vpTranecoXHmPoY8XuwcEzOe?=
 =?us-ascii?Q?QQp/aE5H3W/hHhzWzTE52Mu66pG+MeGO7CLE8kgAd4DUXwgpuU31jD/3pOvM?=
 =?us-ascii?Q?xPLy09fRncX2sDgRKiPAGf3jOipPtPhs5KBzruiKea7rUEHPF9waF9m7AtnQ?=
 =?us-ascii?Q?MoCLTx2Svi4qUyEYQuo0V7XwSDVTJdRYGM+DB/J+t/Bx3LA7/WVX9fx+ZfFi?=
 =?us-ascii?Q?KR3oSdKobZpMSRj7UGaWD+VdPd5Shkkh31u70Zcpqyb9zMad/6teSGnxVA+0?=
 =?us-ascii?Q?ylRSTeNZ+83iKJg4S9tOHyg/qhI3vRcMMB4GUl7FI71Fip7Q047otZo63q9W?=
 =?us-ascii?Q?XWZF7VeIOxIrsJ1lmpnk1/Z84gYkYM99ztkm09B5ipCdGOtCXs3ePqCmM0pR?=
 =?us-ascii?Q?9BLF0JIwJc+iM845zlZP6AdFJY8IttsxMpOu+8zwgZyCMpq8q24BYUqODSCZ?=
 =?us-ascii?Q?qrBG1TqgGHABjqLfZyEB6Ztrkm9ZH1pRPbm9LNVpF99It+xFJkTFOHeguJ27?=
 =?us-ascii?Q?QQ9z7szvuhYLfx7D2KGr08+EBJRN+a2pRZ8xlMk3+3objOJTPnaZDqwFX6VL?=
 =?us-ascii?Q?3f5TMnJ6P9kY/9mCrdDACaJZhGjGNCGFb7m1SjcVstSv47IGKIqia47xApet?=
 =?us-ascii?Q?/mUT6msk4gN7tcKEi5W3+M0e+c/PuTAs4sUL8NDvdkjtnu9VI1bcmbpi3sPJ?=
 =?us-ascii?Q?73HyZdmO/KGDNeBsVRy/CnN0BbXwofdzzP2xvI6CedrACnZg/B20tB+Hc3fn?=
 =?us-ascii?Q?tcSEGBRHDovrZtXl2rcNswFGQ3DvecvJRG34T7J7L5/zuoWw0Lw3wnu/+hq2?=
 =?us-ascii?Q?EAa3f28riV/g5H1zBK37+nYPj9pVNU85PjcJZIinTKV3xIALT+uY+UU5OWIZ?=
 =?us-ascii?Q?dVxjUjOrTQJtHBz9d5cqB5LuH8DFQ84m67ATb0AAdrv1h9WR7ZrV3RRCwTj5?=
 =?us-ascii?Q?n34JvE6XcmYFBI6Oyi5Yv4ImQlnZ7nMmEOO0b/mmW+wemqJyAgZYA4KHBQ8T?=
 =?us-ascii?Q?Onl/e2M2o1bJBPizZ76Zvenn7+pUjKKFfZml4/zc2K35GqW2pxdS8NvqwIfL?=
 =?us-ascii?Q?0QQmkBcaJ6c72HOMsVpR6uCCxn/AlUCqotiZ+C5jasZaQyM3o8Zt4ZInMiif?=
 =?us-ascii?Q?WgdoUQgKc95FeyldIebvujsAmoxeBh4fcydbRWUv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ec4c25-589e-4180-0273-08da6b17b692
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:51:21.7319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NvTKkI9fQVqVt/LzGEY5pDFa1/QRmsozX80Dj9NH0yZt7YhhI9EgJehD1MbkvJqoBHrPSxoDXqvVlUFInbbV1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4623
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 0:59
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 20/47] net: fman: Store initialization functi=
on in
> match data
>=20
> Instead of re-matching the compatible string in order to determine the
> init function, just store it in the match data. This also move the settin=
g
> of the rest of the functions into init as well.=20

This last sentence can be rephrased to be clearer. Maybe something like:
The separate setup functions aren't needed anymore. Merge their content
into init as well.

> To ensure everything
> compiles correctly, we move them to the bottom of the file.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

