Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0B522FF9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbiEKJyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiEKJx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:53:58 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F26CF40
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:53:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN+qLvz16Fj8L7U/dQfENGpRg+VdrzWxKDG3oFurHRL7oLgIzl/J6q6hrRRb7ZeXcM2b28P5KLcfMH8mzyvwGmNnFjUiyJsqu2m3JjwiSiOYMcUt+Km/GQDO1MXM77tUjOzpWFFxzStDHRlgJ8O+mcmhjrP9YFa1ze17QHBlbxGPFGoVabtPAL7lR6OR6x3AxmKy1MXmuJzzP90mspP1yFvM2ocqL7sLqmnEt0Ei48UqrzC5aigkGc5jR1q3+LE1H5X2bhr5/BwreXUyIJT+oPV1X977Scx8gku4tXCjcw1Uw6tIEIr7AjlC+flaCAJ+Dm1amT6T6Zq+ADuTXSKqtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cbd+lNf+a2LaIiJT4n0LvxZQ6M+TMYuABNaWFDj1kI=;
 b=eL8RDIfzdSzVL09MkuwUsMlBPGvubaXEHaz6OD3AhmT1HSrSgw2K83vVVghVyx/eFLkrohYzDSkULkOh0Vm2yhwgQsbWbLHHsyfPsa4qee8AOaYCyjxyFQht/pyLzOvrX+xmaOC5ZmPWUj0vsR/W6FD5I5fxpSc+LKYMiRsbj7lGrL4JkbLk+p6rUulOcq8yg2RHCZJTwNRFLdlD0TXid7WwcG1renUqfqvqnD668eEeAblGeRzlM8OoMWhsKc1dwy3ZMPiKl41jqVqtjA1EtiIKyIzoiRf3pqTAWvG9QshUECutcVhahyvKVTk3R/GGP3AlXE5cb8TDBjb+KDWt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cbd+lNf+a2LaIiJT4n0LvxZQ6M+TMYuABNaWFDj1kI=;
 b=HDlKp+t6Z+DxEOgOJkIyHNwy7YPhf/WPABVEPBWuUjetw6wEOTJ3XuZVNpnWOVkmf3BnYw6yqssTEtNDtrk76c0R98Ef2PA6oV/J9IBqerlFVcs7Z9ygXRsIcu393FLV1swavJSMpIkIfP6o+7KWMpBeNwK80IUdMAXE0zz3B2M=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by HE1PR0402MB2747.eurprd04.prod.outlook.com (2603:10a6:3:e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:53:08 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 09:53:07 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Michael Walle <michael@walle.cc>
Subject: RE: [PATCH v2 net-next] net: enetc: kill PHY-less mode for PFs
Thread-Topic: [PATCH v2 net-next] net: enetc: kill PHY-less mode for PFs
Thread-Index: AQHYZRtjF2bs2Z3SwUSOH3WkiVEV6q0ZbtJA
Date:   Wed, 11 May 2022 09:53:07 +0000
Message-ID: <AM9PR04MB8397AA018C842CE30CB85B3496C89@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220511094200.558502-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220511094200.558502-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d609399-a1fb-4316-5f3f-08da33340d00
x-ms-traffictypediagnostic: HE1PR0402MB2747:EE_
x-microsoft-antispam-prvs: <HE1PR0402MB274706672EFD527E269F0B0E96C89@HE1PR0402MB2747.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: clVrSDpnyNC5sOcvLHnqzcxmMUG0xWBud09QJIkxjGiTY0HbyS3SI6nXmk2+OaA/fwtv9tKr/RsH00ngaaOIOuNi2Z1rB970fyrGWiugfZGf+MlIWrq7KXCnNbWxdY8StPYniJ1k2VTqzdyVmpmUvUhzGxuCWviYbfV5XNa8WEzE5hXbBAW/I0iSVcN5sFk6cHaY0nTLfKgF4O77sVaVMCsOZkpT9t52S/+94WkMheESCBxZ17mJ7GtARjjvLpLsOSpWmmu+bid/idLBDyMy+uqwQkEOtLMzU3Q3bG30n8uepwv/rHwfAXMKtXfuqQ6y6ld3KtVXxTmtNen5j5PjKwwG5qnMzO1uyquYIwjA5r6fmwp6vU54Ju5jmt75Qqh7ecqH+G+2tHvCVvYVUSryOZn7JRg7YDsQKm/7MF95VcWBFAbZZHPpyEl9MNt51FWWLvsWdH/kZKmiQjze8xWtOlRDN9Mdpj/hZD6Z+lh0AdensWaTnd9IF1OcxJ8HkRFIUMrjg3nIZ3sJeBE6pGYDSmxNuoSyfa6/ss+2Q4kBKDka0lWBOHUUIWgc2EUN70GEpFVgKFEvQH/aiXQC0SSzpEIUqucfKmfEZjmXmC+KtD3UsNC8wIKjMGBeuYHBzgBJmOCWpkOTvrpKFGOioiKaJ0ZeoO5gRqS4OzFpEm5BEde/SyFWgH0BT8JF8LdRyv23
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(508600001)(8936002)(5660300002)(86362001)(26005)(52536014)(55016003)(7696005)(2906002)(83380400001)(33656002)(6506007)(55236004)(186003)(53546011)(4744005)(66946007)(66556008)(66476007)(64756008)(8676002)(4326008)(66446008)(76116006)(122000001)(316002)(110136005)(38100700002)(71200400001)(38070700005)(54906003)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4uOObMRBYyib/UCO3LMsk9fGFBFD+OIVq/ytRTGknTOAYDlY6xA7Ar6RKOti?=
 =?us-ascii?Q?w8MFwVDh0EBuV+03TYONQ5LEtVTWCBvdbeWdTWefRs7EVHvs793nDJGkICPY?=
 =?us-ascii?Q?yFoPA4hColDR88B1jkYVHbge1IfGoxOGkwYst96q6xhn+3EhZ27cjN9nzQFH?=
 =?us-ascii?Q?P2Ksf2Ndxq2MGt6POjYwzcNbPJO0zDhPLXLxKXnshzHKzTbuMARnaaqr6LN1?=
 =?us-ascii?Q?p5r5+5yHCVWUrsxVjQd4ZzuOU0o51Bf6u3zuGAEi1q1oqcRYJHHWwqSqn8TM?=
 =?us-ascii?Q?Jcwu7Si9t4cxiAX6dmu7k0H6MLKJwJsI8rdNDQDtEGuja7pNePEYD43I4/qG?=
 =?us-ascii?Q?vqPB1vSr9QPgA+NXUqFTa4u86ZvlDAQT3eF3aBRgA843aR0zP918z7Xg/ZqR?=
 =?us-ascii?Q?vu3UPdRHFne8lWcewzE1adl4FuwqKntfPQO+eS1RRhtCl7BusqrPw3qR0g+4?=
 =?us-ascii?Q?sxdk7UxyCkZDQVKIDHCi5DaPgZAe4/pgq2o+U1/KzTCLXD92jHMgJ92syH6B?=
 =?us-ascii?Q?uEhEzEx+yGKM2oZW15p8v7CjnyF265NHumCsG9tASS/r5W4zxgNgNQyLnaTo?=
 =?us-ascii?Q?davLJj3TvnsV4XpI+yLNLPHmO1zCzYvzLa+VvjX8PxMmLCUG3hfxay41gCCX?=
 =?us-ascii?Q?tKLnGCHhkDs6HmPFtrMOA5Kt81DEL0HWqA5Rk/h9mWhBn3buWKtxgM4niC8O?=
 =?us-ascii?Q?VedwT81nwejtxCAGojEWZUd3FR0SDzOiePxWjM8XD5oH4ikCNXTcitc0K8AG?=
 =?us-ascii?Q?nXxdp7fJ9mybuX3NqHX7aUH5ybZ2Ar8oxqMQL80G350Okt0E7SwIdBZcoR32?=
 =?us-ascii?Q?Lp4iUhEciLc6L/5uwcHcV3ph5w87YR5vlq4WPeowvjsJJWCKF+UqpWuPa1tc?=
 =?us-ascii?Q?FkfiK2v7o0SyCHigCkdADRiWI0tUOtTBLmeX+eGH6CleNxbihJmAIUxlwgzJ?=
 =?us-ascii?Q?3MVXtzNwpeyAsrHXNHmYf4xfPTHysxGBDpYs/vlDC45bCvDkkNdh4aJW/qqQ?=
 =?us-ascii?Q?WqQx7faqX6RnKkzb7wNMybHDkk/4VzAYfZ4zf+/wtFO8cI7B+o2Vd+1h3A4t?=
 =?us-ascii?Q?s9ubGtOBWTOTFG6kfCb3/i4S/KL9G4WvOgcc0g2gpQdkZ9UCDV9ObxnMIAQ9?=
 =?us-ascii?Q?wHhzGRIBqwNISWAcl8FgxgXJkddqHYfsu7EQgaB1V+A5TNNM40SMcgxgAl9A?=
 =?us-ascii?Q?pxDA51/GBmTNhPh3AndF+FqmXEExQOVfvo1SIm0AWCq1Q0W0h4zPjM4s2FAC?=
 =?us-ascii?Q?IF71Qtr96DK4sn/t7InY5CIHkS1lB/rOzSnwOOqLXFOSUmzHAP8qo6E7M2L3?=
 =?us-ascii?Q?XvF5w5q5SRGKHPijNKMxU0jVdtAXB7IzjOovW7NMHEVhWoUZ7yyb0bNZzeaG?=
 =?us-ascii?Q?5BQSblXewCSj9n5JaYFLkKvc5aHggDCcSxVvm1WDcAKHFu3K2auCRjKs1ToU?=
 =?us-ascii?Q?XNnyXZFZqeyDfEAl9B2pxMG0JoUVj5hOAejPO0APTdCYlVj0ZD/tvu5N2oaB?=
 =?us-ascii?Q?hV6HyovJE2K35HV/Fb5HK/NvIHrr0Z35ZALXWggAc1FhyURHqEILVcuW7tKt?=
 =?us-ascii?Q?JYq3f5rpbd3TLU7IB5LJD7+Vb6F39wwZsZAkai4AzahGCHxIc27nHZ8fz87u?=
 =?us-ascii?Q?pHQX1CE3a3Pa53IT8nEYvM+hC5+b0eeNP36egD1CnjQtHJER/JFtcUbGfD6g?=
 =?us-ascii?Q?jSJZ/sHORZhR7qsjE8unXRQZuNul2q3O4OM4cynm/90x0UjZB7NTGrll9ZV0?=
 =?us-ascii?Q?0T4f2rSNKMKy08odx2WIDcwY2IhvAzg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d609399-a1fb-4316-5f3f-08da33340d00
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 09:53:07.5321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Fdc6ovvaJ4EEhOlHA+E34yMWKFgN8mpaxtPP8MTVmqHg2GHTqOlF692WCZwbT1dVxGuDYOEEyHGdfo9dW25Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2747
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, May 11, 2022 12:42 PM
> To: netdev@vger.kernel.org
[...]
> Subject: [PATCH v2 net-next] net: enetc: kill PHY-less mode for PFs
>=20
[...]
>=20
> Just deny the broken configuration by requiring that a phy-mode is
> present, and always register a PF with phylink.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: fix of_get_phy_mode() error path in enetc_pf_probe()
>=20

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
