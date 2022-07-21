Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A964757CB06
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiGUM7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiGUM73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:59:29 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B72ADE8D;
        Thu, 21 Jul 2022 05:59:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lO4hoFxODCGO9iuW5wD+Dex7voUZiuhF5Y/NiorHCKZq15+iYiLLhWJsxGYoJswo5Aa7Dcgy1/iz1BYvtRm1+r9bYSTq5UpsYC+DmlF3oite/VDlYFK56phRILaDYxlNtnl9KR2ULqfZ6V6Hs/zcF3dc7/xx96zhUJg4dcfxPM1udkAg2dPFZ1Myc9Snc0+Y9QnLANuizmUdHs5njhlT3QobftaGEofntMloR0wEMJiYIgEZ9XrNwJ1qssABURR+6b66pBFCqb3ECYNNCO+O1FzVGrb5C07MHbRJNBAkKB2g3vgelavd5OV1bwxPG3bys0Q7GUZ0ZwKYCz7Ac85VBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siJF+2HUSwT7tqUHlXOuBnr6h7PAJP/kEi2gkoEEVrg=;
 b=iXf/H/i+WjJZg3ahU/Gnab8Qq443RRZUT79mc/9LjuC27MNQEHJZPYBVKdar492/lQDKmDnb387J5Q/uOyoSKJRAYwFh7mEc6lbgTAUkPzPY+FYV3ONefvZLxqzf3H9tfjXn5oXn91Z9d8IYCJBgRV8pi1v1nuLfMcPPEls43R+j4peNJemsuO6XKLgr694bEgHiE91QOubg9JLQ8PSe4AGIQeJzKHkAuBNhIbYjoLBeoGWXyHJoJdi7wad5T1zSsirsoQqUUay/f6VK65t+yk51/LHvV/UPpBCPJoRwjP42wQ77jD7o/SPHC3F/dm/21MS5PO177PmxgjrlLBdsAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siJF+2HUSwT7tqUHlXOuBnr6h7PAJP/kEi2gkoEEVrg=;
 b=VtVENHwV0AXkxHlsEhpsZqDYEf7jyRP9cYTQzOHIVQswVg3JA656448FV6yy2f3SzUNARvBIsrrqrbYD07Bukr7SuzlIjJEUOmVtf7CRh+Ezs2/uT0n8/7kx5MbX1nea2Tinf0qyTNN0+xxP4tHzABEoMNmX+M5KYIA3l2+SA/0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6814.eurprd04.prod.outlook.com (2603:10a6:803:138::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:59:25 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:59:25 +0000
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
Subject: RE: [PATCH net-next v3 25/47] net: fman: Move initialization to
 mac-specific files
Thread-Topic: [PATCH net-next v3 25/47] net: fman: Move initialization to
 mac-specific files
Thread-Index: AQHYmJcWJAj2LymupkK/KmJeG6PPuq2I0h7Q
Date:   Thu, 21 Jul 2022 12:59:25 +0000
Message-ID: <VI1PR04MB58076FF6AD9F21C7C3E9A97EF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-26-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-26-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcafbd18-fd96-43d1-b1f5-08da6b18d71c
x-ms-traffictypediagnostic: VI1PR04MB6814:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mtrgRNkSEiWD4f5brPeSdWPONR3SMnQoLY8X7jdNxG1Pi5y9vAMDuwD3H8iOiVKHlGrFIcpVsA+rvNJP5NJdWPxqCY+bGbzahUwwYTTsOhGDSefug7CLVESDDgfXZVYD8A4GKaCgYTZLMjZ1fVNfzr/74xbiQIxd/7JUyP259/wchsArq65O2etRBN57gQrQ2mrWuvdPNAeoz/b5Ko3w+wcZ1JdF/CZTBPrLTdRUnxcr8rxyVpfNkY8L1KPAMag0BP/x5HGLTFJsrBqGdlpZzvp2Qu8ug67vGSDb+d4OnD6GxR8/BXc0KGXFYADv1EtJPR2LhlZyNKQoF1PwI4INM06Ish6+rnSVIVD3lygK6gfkUOi0OSKYSg1vHKXLe0Yxn9XoY8kKZEok9lj98GgWcBlGHlLRQ30rxVVUu8Sm1XqGxY+tO4OVANwPxuHzad3GZIDpxT470nS+Z5fXmU6GqbDBCRE90hLQszfu+Am1ZGayjWLEfG/p6zlfKMnksVbU/EKohBHZkn7aoFy7D0nJDjU4oX8aBslR4LEMPzE0CWRMPixQDNq8J0w5oeivUC719AR0qBlrZtotpdpXg0uw1QgKRFbtS5klwkLLMzulUt084OFLl5TV1tVyS4tPe7YrmYDYa86GO95Jj9AIT41Q9Nl0BRTn13NwGKGvxJJKWFLg8ZlolD9LoYywXN2oKdrRYZErsoRtkzUKezmBcDsVnbQKiy6rsXmAa5ynnVo0JJxf4lonCY8G4EFe1ByOpd5PN7sDibwThdYJZvjIEG+1u5M2F0ml3kiS4l7uVqPD9hc9e2Cmw69ZQgpfmgYN7BkX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(71200400001)(6506007)(7696005)(41300700001)(8676002)(4326008)(2906002)(55016003)(64756008)(478600001)(66446008)(66556008)(66476007)(33656002)(316002)(54906003)(66946007)(110136005)(76116006)(38070700005)(86362001)(186003)(122000001)(53546011)(83380400001)(26005)(55236004)(9686003)(4744005)(52536014)(5660300002)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1jEAwh4jy6A2j3N7/TwS7OQOtSt6XvTK7hsk9epAV1g1d90Bm1Ht6HdA1vY/?=
 =?us-ascii?Q?COPf/ZcKNdAVu8A5/uE2eVdhqu4QV0SSymXTTbCPj5CE7zJeQG2PiREQUS9x?=
 =?us-ascii?Q?V85lJJM2aSiaJagb1KWeBLzSCUTBC+xou/b20lZcaycggTx/5z4GWvzC84Xk?=
 =?us-ascii?Q?zqnYm9nShSTxjdtQIxAxLmF9WH/eGTLQ8MzbPReJzKkTwCC55trsJYkx/GpG?=
 =?us-ascii?Q?/iikKT4THptQDFbApC/YX+BMVRi4gjuO9/BL8dtv80UP3gJyapQCTKsoHEuB?=
 =?us-ascii?Q?FmB+BGSuEftNtewly7MyWl9cZXWnRkZUOVZzfbhskCslQ7XTwziHgDQOL3a3?=
 =?us-ascii?Q?VnWzKnJ9Ka8/CIHZQ7YiMlhETQ5sGkP0SwZwltZ3MwyJ1gdp+tb6j0NvN2ce?=
 =?us-ascii?Q?vBn4t84fNw6vGuWY242DnFWTNno4XJNbfMalcp48sBUieFOZ/o3BNoX90nbq?=
 =?us-ascii?Q?2I+nELgFq7YKc7NHbtoImMZlnnm1HET8mfE8s/2btgaPIuR6qP//ooOtoM6f?=
 =?us-ascii?Q?nUtrk2Q6nsV4JjuYemGApuC9ohiO19Qj1WedVZpbPQbP14I2ID/GWqfqY5pN?=
 =?us-ascii?Q?dEmJvAKCoV/4Rsy+Qm2Hd66crTUtgcQkjlqK1GWqigg6RqvzjQNxuXtktjnD?=
 =?us-ascii?Q?UZ2qEd3pGucGH2UK9TP5xTpCWXnRbcTqqRIVeVuh8N4Sj2oup+96Mul/QtV/?=
 =?us-ascii?Q?tQeGy3a2GDoVaMX6veoROSRrfHNHzRghU2EuOtadqzvuvdVugOlR8h0sOMiJ?=
 =?us-ascii?Q?r+E21ny9g3oK1eWQI83bhA5P/OzI3A7kh3fsBMUXol/ojdLJqxP7SPoBNZi9?=
 =?us-ascii?Q?s2chJEL7Ynf//UK4ZDOM/QZQvk5lsks7aKvwKqC9srWPr6pkzU+ZHFyuuQTR?=
 =?us-ascii?Q?BMdnjx2HVkuYiUbfZArXR9VsjGcLjEysCulOwHY6I7x/QFfevCQf1ZeLsQZe?=
 =?us-ascii?Q?NMIf005XH0Kh/KYA6dw7BsW+9cZurrJK2iIBvLto95ryt7ENOawKvAuXZYD/?=
 =?us-ascii?Q?kdoXi2Zddnla/IU2TDRW3Gn6gLqVoXEszCpG2klebGqfikr5Wa2f00OkAwrw?=
 =?us-ascii?Q?mFGLx7GEkl59jRcEA08PsHniYQ4WDs3W46qWGRj44swE9qq+kiaMbktEu5q8?=
 =?us-ascii?Q?QGw/TYdsqkEGmbdfewp8RWHS3PMafPPrsJIhxB7M+ekJMIvYa4TkEzJOTGkV?=
 =?us-ascii?Q?IDyS8aG/Y1Af3phrHXls6dY1PxDPCr02bAH9JQs7LZtzdEy2cjSq4PHJVKUj?=
 =?us-ascii?Q?+tcFsgEpqryMbfCnrRcUDODPuHTlNasERMY782fDBc8AUp+GSh4D2vuWcF3T?=
 =?us-ascii?Q?EortUNTIonFGPCNFVKk/Nitd2yo4YUR7BLmr2lr9l8eRUnmxph1h9oBkE1kZ?=
 =?us-ascii?Q?q8n3C+WjNr72JW5dLLSr75X21iCNZeMIHBk/2TVt3dwZpjeTL0VrUuEhaYuV?=
 =?us-ascii?Q?r/BP1k88wwYy+g07GGnLEOZlU3j4mHl7CLb6hE8MWbogKssBCwvQrPZifKci?=
 =?us-ascii?Q?8Y0OsWHXC7mefc7iIHweb+iuNVs6LuJz5l3vHNBvcTQHC9HnxjKUKUKgoitC?=
 =?us-ascii?Q?1tZSoyznjJ6SzkZrN11l0WSK/mYuj84VuOaPgSku?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcafbd18-fd96-43d1-b1f5-08da6b18d71c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:59:25.8403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f8klNgKh5eDoN3IlTUQx0Hap9Dx+eQcX6Pt+HLUckQ21jf4LcqSovTG2boUPNDNjFqoDfS/3KEJYaYy6TKKIdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6814
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
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 25/47] net: fman: Move initialization to mac-
> specific files
>=20
> This moves mac-specific initialization to mac-specific files. This will
> make it easier to work with individual macs. It will also make it easier
> to refactor the initialization to simplify the control flow. No
> functional change intended.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

