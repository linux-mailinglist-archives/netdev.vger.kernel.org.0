Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1840E540150
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245458AbiFGOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245450AbiFGOZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:25:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD2CF338C;
        Tue,  7 Jun 2022 07:25:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chIdHxObcF+lwoEZdLHExpC72fvyIBwrBZbjwl2qwAs7us5ac2MeL+5Tj2071lAKdiZtkwzVpwZWBKDiBeVZqpNxrNfKAF2uoi9QwLTjFzexjKI+gBnyG+JyeFCZzI1piFMvOG79pm3FGAOkChSMEzdQM6Hb86JbEPU5w1Bj90jGxC2k+Gl/Lbo3PTY/Hmsv0v4CbkEB556GH+sVHUGKO2FftA/4xXZvp+kLdbiHVC4PcAJMUbfbV32cKkMvxeZRD342dYbB3wy2O32hZPYnJFW0GWA3CEUdIufjEgs+Zqa4Q6C2UgIAjhnluwnTWpTM9+CMUr6KDBtfPWB4sScVQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wU1wdbqskG9nxtGpU08i1tYEjX3pH4czwaNus2kmcdo=;
 b=UDnnNW8ExX/dpR0h3j/RAzkTvMN8lBxFvjhbAAeVuiMRg1mLqORcKP/6Y8vrun2JWDFpDF839BwIF91kDDP9AXnV19llW7gjQKyfzWwmO7o/nTA6cqvNH1zW1FHAmKqAPD8nE71oDa/XtoAD9Avj/HZVzO2+oYJyhbgiFQGrAtrjQ5e7sloqmadsiiKJlLddxs5oLj6mP3HA+sFNgaeG+yloWnYu0Q6jtlvDVpZqme7juXNnx+82mhr/TeJ5ryRIqtFM5dTkImJAoIcTr+wlXAEUHkLNeYdWl0FBWM7MrQ9UpLGvkCJcIOzIm71z67GknSz6Y9njCn5UYv5Svv6qyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wU1wdbqskG9nxtGpU08i1tYEjX3pH4czwaNus2kmcdo=;
 b=bM+dSOEflkD38IFjeo+9Okhtti6dZ83wockGIoSvT08LJtv4kFZmNGcuodjw3R/aiYjUSpcDq1Hb+OgJQpLcglRgqX2LbqfCcN8a7DK9/+9XE7Blgi7bfOzhZup9wLf+FPhMjDlKBnjztMEWYvlvnw8pHcG5p6kB6rHmZyZhQ/U=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AM0PR04MB6180.eurprd04.prod.outlook.com (2603:10a6:208:140::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 14:25:21 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::ac4a:d6c6:35f6:84fb]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::ac4a:d6c6:35f6:84fb%6]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 14:25:21 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Madalin Bucur <madalin.bucur@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] net: fman: Various cleanups
Thread-Topic: [PATCH 0/4] net: fman: Various cleanups
Thread-Index: AQHYdSjoWKqkKVQTN0OhpbCwitFEiK1EB2Xg
Date:   Tue, 7 Jun 2022 14:25:21 +0000
Message-ID: <VI1PR04MB580729C22E9B2B537CC9C9BCF2A59@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220531195851.1592220-1-sean.anderson@seco.com>
In-Reply-To: <20220531195851.1592220-1-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 719cf039-fbad-4c45-065b-08da48918e00
x-ms-traffictypediagnostic: AM0PR04MB6180:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <AM0PR04MB6180ED99331D4A219304B94BF2A59@AM0PR04MB6180.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gn6eTLYI7X2+tB724KS4EL0kXclbdGJrMqqYTFo/Y7UmerL4WLOS9RGLq2v3cM7S+Sam2SkBUjpNRpfHhT0fMwXjm01Q/qrQj/epr4SUCc+8oTbKJDEbUxljKbmVckDplYtUlXCHSyIPwwp6wVYkwZJw2pWGayCVDnfDMhiMdAyCEnarR86CU7Pdrdu5J7qrznCJ6XmGiIQ8RnjM54CeTqIHjqWyw9v3i77zUVBUI9AlT19r/dgR4LAQe1VqM1dPuOBGBs0W2hG3CCwcOmyr/EcJs12/POgxi5tWDOL1QMNI/OyfTvxK+qeOdwjbY8jz9W3POjJ796mjgYqqeqf+vdyEA0cHYg/HPDWh7mxOQOff8H8FstTegq2WvK3ge2zkvKaw38KOO0k8GC87fb6eI6yEqLVdHcZXuHzYb3y4WcGACYgd/lpDJ6zACnorT8CVUy6oGkHeJZeV0UxyA1OFG5Avklw0cTgZEh/DRlKh3r38Yvihzij5c768eV6xtMzmP/NFS/HMfymkRFHqJvV4PM5kZes2sUjXWGO68g3aEkVZuFsQ7W6HDK3zYFYzapUMuCEItFFGMMlrpCySUUoZKSz98AmhHSEOEXCyG8sZkLiHinsYwCDdhrCaSA5ehgVsY+BxPbAqlGRXe5mCrNvkaMlxSBiCubwKwZ9sn8psURRA4rmKGRpawk2HuN0faZas08g8JELDwdI+wEK6531MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(52536014)(86362001)(110136005)(7696005)(122000001)(53546011)(55236004)(9686003)(26005)(186003)(316002)(33656002)(54906003)(6506007)(8936002)(508600001)(83380400001)(5660300002)(38100700002)(38070700005)(4744005)(76116006)(66446008)(66476007)(8676002)(64756008)(66556008)(71200400001)(66946007)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o1YOpVtBj0+UrRNJc50nkOHgyURkUho2JMgxhUTE01b0Ncjj//RXkzQczMiX?=
 =?us-ascii?Q?foOnpHfYa/e9Er67/bQ8sqlivSqmjRKhQQWj30wb1COuZN+Q/bQiCvbui93P?=
 =?us-ascii?Q?kVZkcmu+BY8IeFwFwawhoAusFQfOf8IEOPdjc4LVCfBooH6xqBP8RKaE/ZZo?=
 =?us-ascii?Q?wciXByJbhM52gkfpLz6AiJ3lX3F5gsuvUhObAXyIXS4lVhawFhNvFOnvTMXS?=
 =?us-ascii?Q?y4/8CvMOh6qNQSQTIXLmTfwiVaXPkkqxSp3/Z7nDVBPpM7pnZgBnlc+QhZaj?=
 =?us-ascii?Q?9teMSqDGaGo3lODJOZHoadt0btfqmx28jEts9oWWixgo6DNw+g7FRfguhlwD?=
 =?us-ascii?Q?3JIm2U2ZrV8KbQMAW1gI/HpfR9pmoN8DT60nnZkUix5ZqAtGKG2+Rx5/S9Ef?=
 =?us-ascii?Q?U+DouD/sTIRdIGaKmxFGkNs5tNg+5uO7gAkXNFNjhv6r3sl/T74FCyeXvxMK?=
 =?us-ascii?Q?o0zLDQnv5vOVY7TFox+F6BKFSKm8qHCDuPiHRlJx4xIxDqNx4jmzjwMO9U1K?=
 =?us-ascii?Q?1kUkOgSeykm5z1qtDVGHujNfkoRid02HgfYXpo7dSPnYBVeQKTn6nzWgPGks?=
 =?us-ascii?Q?027OH+hZU8Q52UOfcKJuzH0mZAgaeTtU5idmgKAQL3vLonTqf5S9DP0DmMoQ?=
 =?us-ascii?Q?oS0fbDmD3lYUVlQ43qyL6wIAixu07ckEBzM8pW9ok1FDKC3K712nUTOscA/O?=
 =?us-ascii?Q?UKuQtO8Ttpnu+KMHdPeVksCWWiPlqJTATf0JMJYImM6IEGM1f3TSl1YfzGjQ?=
 =?us-ascii?Q?GMj93/vyI8ksecdyWcfd2OgAj+yBcMvKjn/YVuVRVQE+8FUGrSzUbQGPny5s?=
 =?us-ascii?Q?ESlw18BkKo22emNY4YgdkY2XHbX5A6QI3hfAyN6GK4RVdM7SV1i/Au2MO1Dj?=
 =?us-ascii?Q?n64WyFmrXyGYjYbShfw4VtpVz5tiQm7kJCwisO5talsvtyALYOmL5cISCKWd?=
 =?us-ascii?Q?3INrwXEnMcqWLxrWqlUiW5nBTP03pai0I2GeflNNtEgLU9Dm2TSWlKsPDnrx?=
 =?us-ascii?Q?8Oc/KmSc4v0flWMBYSzjO/rmo0+QnylXL2ghu8+2k9b3NSCIob/VXAVIhHzo?=
 =?us-ascii?Q?+PsnEvFUv/pPer6Ke7tS3+XdIXlFJsyjWEH4M9mNIStlyLmJEv/1L2P/my7h?=
 =?us-ascii?Q?UokMVUQLl6n7MFWVqZDEE4apwV7+DDwwimeVAMb7yqiluFyvjwzvXuzsJH2z?=
 =?us-ascii?Q?IAdH7mp5a7c7ooJj7e5GwVWImp6ty2FHUGzl1tqTsestayCdqeX0+dhag9FQ?=
 =?us-ascii?Q?20f+5M9/2YrTMBXLRrOz3H/cuk8UjKnjhifszRyLQAGRN4Q71+xT+y+rZttx?=
 =?us-ascii?Q?PC9sJdpnOo7ZikfC/CsDPECK4SMNa6pRCzoXFo7B5Wzp06yzMpb/Nz9wKAqU?=
 =?us-ascii?Q?CIvfE5259CylaufQvnVirHegQbhYrrq1CppsVkO6w253be0tKmvGd5gzN58j?=
 =?us-ascii?Q?3NYPulNKqF1lWK/dhxwCXPr91cnMLvnuF5iv32z/B/njeirdI0fgA3w33CUZ?=
 =?us-ascii?Q?rFguqXEkcTBcLziQCHVU6T7LxdfB4gQ9m5ryZTspwRpB74R0LY7aaAxXgqhE?=
 =?us-ascii?Q?7Qa6VdqgpP58B5lOUHKgTTxPSdv+654b9IIt1yA+lsHeODpy8xX9X9pIhvkM?=
 =?us-ascii?Q?aK3nDDCAjYxL3cgnyat0vFGHuEkkSUOa602XRBOUh/+O4S7999Q3A6b0ouDT?=
 =?us-ascii?Q?/fIR4k7g0TNFgdNgwaJsgreBbobtwnMLkPNRQ8RqN2CJ08zFK6oUBgfV80M1?=
 =?us-ascii?Q?rnMyDFvLEA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719cf039-fbad-4c45-065b-08da48918e00
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 14:25:21.6014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6dTPIyVNgEGuulSHaupOPC0nvB4BH3vtCCzWV+Igb4umKNVot0vkZJtLOVze5sXLe5PWbQ9oU+Sxo0djOgH5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6180
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Tuesday, May 31, 2022 22:59
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; linux-kernel@vger.kernel.org;
> Sean Anderson <sean.anderson@seco.com>
> Subject: [PATCH 0/4] net: fman: Various cleanups
>=20
> This series performs a variety of cleanups for dpaa/fman, with the aim
> of reducing unused flexibility. I've tested this on layerscape, but I
> don't have any PPC platforms to test with (nor do I have access to the
> dtsec errata).
>=20
>=20
> Sean Anderson (4):
>   net: fman: Convert to SPDX identifiers
>   net: fman: Don't pass comm_mode to enable/disable
>   net: fman: Store en/disable in mac_device instead of mac_priv_s
>   net: fman: dtsec: Always gracefully stop/start

Hi

I ran sanity checks on two PPC platforms (T2080, P5020).
If you resend you can add my tags:

Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>

Camelia
