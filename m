Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337036865FB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjBAMeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjBAMeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:34:01 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8785C0D1;
        Wed,  1 Feb 2023 04:33:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEe+z717JjIz6hds6UG+GtJMCj9MpRITHk9xGW39h5tSuQtFY9MGdm0b4fdZBnMwN02ZPYsznet7cZ0ZPkIMVBi2oYH+1uIs/iV57zVMXXLpU4cwOxSbGzrmz8Jd6H8PllKrRSFKfTNUQXtZJljT2APwBVDSEYYtVJUpgNyxKwBRB8pFQa+g2d5AFSJ0BkOHLqm7YQItUjyJSMIiYnhDH3kqx1X9kj6kXOY0QnZJdaVr10/4P7w9qDtIvBXpecyFwa1Hp2N5zz29cJ2a2YyG3zLpE1IvzV4ufnCGPAV6ush3I16mzHjlWun7siQDsUMSeBCoyMFHKCGaohtkuG18zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9Kxf2+aq5UBylNWe1Bf4hw/bYTFukr6DAgKI9R8ZFM=;
 b=aSa2jYjBHcScz85mdC0NR4n7WD7oMZMK2og1yBrgEBDb/Ugt6NuHvcehnoMyG+0bwwZqZ7QGIUPGT7DPSYY+tI5zB7V/7r3GO8msWYB0UZOmVaawEb5TOdgY8Ar1+FXfV/afn6ohCtRzE+BGd6sxQO6QBbdHbj5ajUP6+8rdnCS5t/OWJpYxBmtsBpl+h9YB93MAYZWyqQ37sDSwYvGYMNKXGlqsTQTv708EYK1C+ik4sziXEVzruXpUQOWPXkzqdGnopx9pYvmveMnhViz9+DMqy+XNiqFuLLMQt5zXq1lc+k8gUstV8ey3iA55ZfW9I+0p9Nn0BgSF239VeD1jnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9Kxf2+aq5UBylNWe1Bf4hw/bYTFukr6DAgKI9R8ZFM=;
 b=gpUoNuU7nFFDj2u43bk4ailSuIsLdGkNhGQTVU/uB4taCfloPdVIkDBBNrUoOnZL4M0ysrbwdKhjDyHdbzX1NNIEPJiYX4raumffzD17ICMVFDr4+Hj9JNpeY67NFzqRmrILw21T0ZGqJXgunYXKTARXrcVKNgpYFBh1MmNGsGg=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS8PR04MB7925.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 12:33:50 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%6]) with mapi id 15.20.6043.036; Wed, 1 Feb 2023
 12:33:50 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v2 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v2 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZNjlvc3KPU/mXzUmdiUoieetwDA==
Date:   Wed, 1 Feb 2023 12:33:50 +0000
Message-ID: <AM9PR04MB86039B970C497F603BBAB74FE7D19@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
 <20230130180504.2029440-4-neeraj.sanjaykale@nxp.com>
 <20230131022041.GB4082140-robh@kernel.org>
In-Reply-To: <20230131022041.GB4082140-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AS8PR04MB7925:EE_
x-ms-office365-filtering-correlation-id: 58051d51-ec87-4082-3f8e-08db04509258
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RTukSMjdzKa0sSXZWzZJ4i8vfMPobR9YaT0iBVfyOuh/gFXk7KnH/YnHzjMex0YzKK3PwVUvz6IcrW8EGq1rz/GJOirDJa04vfICNdUuCTwJZYS0gn+4fAZ1FHiGYbGt0tC2afeN5UcZdxwHS0Zwh6Z43ml07LXbeHrJzHA6zF2DNfgi0AjowMP6Oeo2yPjsU27WdthMy7ajHSORnYlQi38Mz/6S0zn9CDfsokrKSO6/QJ+RuFHFiEG6Hv/Se7CdcTOlM3QLJRsUfaToh/A1RH6XJ/rnZHqcYh6u8piPhDFaqXcVsWsLVb08cXRXY7T+seJ3aa9RRk4nKR+umWEKiASDvS2c8jRKX703GneOMACc7rL3q97qw7WP+yo3YXlsDF3cdfPcZamonLeYKe4SPQXDz6bfpnxhUWh8FdlmCoEl1SUQmEyTw3CIWKdycRwW/APXgv4MtPa+OPTdlgDyOxmuWS1WRymklvXpOdIjGmkn7qjHf+1FQHsoGIvIQbWo0pwUfZ5GYvSggqO8T0cB81cHNXhcSkmBF5p+H50os6B7zEyPplywlceZJdfl1/6whdxq8xWt75Fr6NnwvqNkdF9lMG6JBVq9xtsXESLxsW1dZdEU0mcys/vlqw7+2Momfu+lxbwdBHMpeZl/CMOfjbrMZXv/dpiTNK7Fk+EFEE7weSDxsnsGdke9yiJ6GIyKW8R/BTyXQmwrRV/fF4/btQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199018)(478600001)(33656002)(55016003)(52536014)(54906003)(5660300002)(38070700005)(6506007)(55236004)(2906002)(7416002)(9686003)(26005)(4744005)(186003)(86362001)(122000001)(316002)(38100700002)(7696005)(76116006)(66946007)(4326008)(6916009)(66556008)(66476007)(64756008)(66446008)(83380400001)(71200400001)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/vjxAvvSgNz7NQn2Fg8jo7F0JsU/+wLMJXGYsgXI/SWCIlHSHcriTsPpq4F0?=
 =?us-ascii?Q?mu8rNkenyg0Maopk6cAvHpWFoAsj2181SwqaZKvs89qKdN4KcQFMcofP1Xau?=
 =?us-ascii?Q?0iab52FPUAUPS5kagZFrvyh+4q9VxLLxzm4JvuTyFgP6uiS8aePjd4CmjRpa?=
 =?us-ascii?Q?+gEzbNyBohWjRvZaNntb6jdPSK0dd4pa6TCB1rRgyRaxnelzWGCCkxjigTA0?=
 =?us-ascii?Q?64cQuOf743XTfFNHQWyUH6H5jx91RR9kf9R8yxhHJx9mgsyC36OrCx5L3PMD?=
 =?us-ascii?Q?U1Pa0eP8H8sgyR0T58M8r3tujRIwO2SM5B7Apa8BDTmaV0UKVNwHQ3k5fMf/?=
 =?us-ascii?Q?qgaN8l1HGo2KWfATGKbGIJUub3CERmJDyTcUKzimUyv/IkhgEU22hWYLIGUn?=
 =?us-ascii?Q?rtEcjurzLpv57nU+C+EPNgrVhAvUrEnewY62KaK+WIU+1yMQz3kbQ6BFNRoL?=
 =?us-ascii?Q?H/u/5qxgy5HC5yx0RLNeBnMfTrP5kDlwD1OHkC7owOIzM4Uw4BYW/GXqtQst?=
 =?us-ascii?Q?sL8Vbli5NtRYfEwAmSApWxuEsDlNs7rX3Wu1LURy3VT6nqk8/hpNIbPL7oRR?=
 =?us-ascii?Q?lYHAClMbzBDfONza3ra73KWdQsB16pcvjODYsiwzJi8pXSrLmz9X6c1j1NPh?=
 =?us-ascii?Q?rZIanRVh7MpzEuEoYyFRYmOrEbBYJz1DuOWJGB4Tz94lXgtSIKIYKK6I65LJ?=
 =?us-ascii?Q?s3A5Rvqectw7XSiOMtGlGT26tvccp8ragh7haJ9vBf9R1z8BFH5N+v/OpKXJ?=
 =?us-ascii?Q?xJSqI0nqVxdn6aqzzUs5GZQYMSnVke0SdNYAyQP1ceDzGr0//tYTH9U6pRCZ?=
 =?us-ascii?Q?47QFcPG9YqjntTW6+Xu7l2NHnEI10DUxLTU6y1wany0fdZabcXdBMRizgGnh?=
 =?us-ascii?Q?YDMENBW9EQVggCiefH0evgaY4RgFOzg8xf3VBUqRFfx1UpwV9dHx5Fwyjyus?=
 =?us-ascii?Q?p26Rm+PNcY1TXEoDjwTZE2ZNbc1XJab5BzSC+sh2dTk17inNfL6XVWXJ986s?=
 =?us-ascii?Q?xgc0UDFlETbARPtsVPHU02IAMoUSXRjHPXTHTr/2wTYv7NBmu1803y79DN/q?=
 =?us-ascii?Q?7Zi5rlTC3FcYUFOkpx8a5hARbCKlfo+jsfU9BckBGKv2yCVPf3gTPiOMC1LO?=
 =?us-ascii?Q?LqxQXLCPA2tRt3sbbzu1Xp8ttAMnUrArJZAM5Jo5ugjqESH/g676cCPYzLZn?=
 =?us-ascii?Q?LYjZclCKNi/h/HNuLRgsM9eS97XahGhhgmmTEAP6fyDFQK337l+SaiUKaFrS?=
 =?us-ascii?Q?CKseVIB8Kar51XLj8CV973jWMEq8bT56D0fbwjEjerKaWETpuocm7hKkKYZW?=
 =?us-ascii?Q?8hh1CSbowdBYeVq6mfBMEWs+/VZjK4RNLpk3XiXXQAyERo97EN2TzKDZFu0Q?=
 =?us-ascii?Q?5PBb3MWXsXO+bYdQ+LKbJFEihiJ5/B8A6WVr3R8g5qPR0MLxQyyz7Vw+tv2x?=
 =?us-ascii?Q?eRsWT1vE6DXSn/4YdAZyx5VEB/QXtTTlwQMl024Zjv6Wz2yNP6nAY6fKahbg?=
 =?us-ascii?Q?5T30h5OOuYRgqZTAMNV1OKxtZ/a5hrfRrIK9yP+Mlz6CT0KjE7qFBAMtxh7K?=
 =?us-ascii?Q?iX7VWBRWHqPnfF24/68o4p8Y45ByLYeJzAzP58Kb+N8xaMA2ZelMFlqIkKyE?=
 =?us-ascii?Q?nQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58051d51-ec87-4082-3f8e-08db04509258
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 12:33:50.1896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FwW4VRFAHdP/gyc2pgeOoN7bOX1TfTP2p+HNh6NrHHVfOL8ej6FWQh/5tMWuaQ/vvP7xnqpoH1lydO2b8sGtRx2ELaR91/iKZL7NHPYdaXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7925
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thank you for your feedback. I am working on all the review comments receiv=
ed.

>=20
> On Mon, Jan 30, 2023 at 11:35:04PM +0530, Neeraj Sanjay Kale wrote:
> > This adds a driver based on serdev driver for the NXP BT serial
> > protocol based on running H:4, which can enable the built-in
> > Bluetooth device inside a generic NXP BT chip.
>=20
> These are rebranded or descend from Marvell chips, right? Maybe this
> should be merged with the 88w8897. The firmware download seems to
> match
> the v1 protocol.
>=20
The 88w8897 was a legacy Marvell chipset, while the newer chipsets we are t=
rying to add here are branded under "NXP".
Most of the newer chipset download FW using V3 protocol and few of them use=
 V1 protocol, which is still different from the V1 protocol seen for 8897 c=
hip.

Initially we tried to add support for NXP chipsets in hci line-discipline, =
but Marcel Holtmann advised us to implement this standalone driver based on=
 serdev.

Thanks,
Neeraj
