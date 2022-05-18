Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AF852B27A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiERGgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiERGgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:36:37 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2113.outbound.protection.outlook.com [40.107.22.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0129ABC0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:36:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXkE8WOvWRk2R/pHvXdWpaDh9b5eQwypvqP8nwl60szVUt3YKy3qmZ8oDOJxe1hhi7uFWBoA3hryzmMdM6sAF4dyzFlaZEYdSFHc+lV0S/VhzZ+CEUJllz6O3oTI+BK9kZ8x83u9oaNS+ekkb/l+7ve5g+TEpfzY33EdLizXkYuar7bRrVObAwDdifnkia7m0sxe7H4CgQ+WhxSUcMrKXQVM8AMIKTuKzgzq5x8QUDW6jUB4chuzIJ73AGly8Pn1u9v7O2E2P5ecWFSGEXWTFZwTJECN/02N5xBmbj0PS3FP9OmHQ4/iBdCwcFFFywR4W/6VTnT0ONsOMSlwhSMUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnvSQG9RN7mA22NmWfveEjPQQaE6CKfk+QS9UE80Lkw=;
 b=jj/3ANRg6W4gA3LcMtzDxiyShzgjMHS/E0sq19PWe+o4+W3YpT1S6hBWkFGyWinyAwKJiCl06m66ve9W1InMzDZC77TL/B60lx8cTgNMs42zoULspUWrs/UWXrLdcOw19r3iEo/mjab7anX+ov863Wnm/wp7weCJ/XFcnW4healGtE4tijZtucNeoDJ1l4kLiYW11Fpuiwn3DxaDmRRbmRjYCrY7navhoxMuGMFb14fmXwaSnEGIsYuMTlRJ6gsG0t5XQzyUBfDynnERL9s7wMfg3qDeVS18uYTLqkAch9lIdtyDLQVGxeFG9ffYFdR9Sb+g5EpmYgpBqo974VeoIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvk.de; dmarc=pass action=none header.from=cvk.de; dkim=pass
 header.d=cvk.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvk.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnvSQG9RN7mA22NmWfveEjPQQaE6CKfk+QS9UE80Lkw=;
 b=joW2vBPNwfJotGQt6BffZONT1EKR2dpDPdIZoLWlCYL60yKsgBD67maREMmpc9hOLI/3XAnYW5SVvE8SJlIdAQJeJ/qhx/2z8EGfS6584lZl8RMxCQfX8KDFVd4zIMv/aDt+8cddd55i/y74DBIdn2eAXTZ2znpqZMN6/fQod+M=
Received: from AS1PR06MB8442.eurprd06.prod.outlook.com (2603:10a6:20b:4c6::15)
 by HE1PR0601MB2587.eurprd06.prod.outlook.com (2603:10a6:3:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 06:36:32 +0000
Received: from AS1PR06MB8442.eurprd06.prod.outlook.com
 ([fe80::6881:4ae2:5a06:68ee]) by AS1PR06MB8442.eurprd06.prod.outlook.com
 ([fe80::6881:4ae2:5a06:68ee%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 06:36:32 +0000
From:   "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: [Patch] net: af_key: check encryption module availability
 consistency
Thread-Topic: [Patch] net: af_key: check encryption module availability
 consistency
Thread-Index: AQHYalB+9TiF+0Ik0Umk72NfBn/I8K0kKwBw
Date:   Wed, 18 May 2022 06:36:32 +0000
Message-ID: <AS1PR06MB8442A643D0EBE2DFD7190D208BD19@AS1PR06MB8442.eurprd06.prod.outlook.com>
References: <20220516125730.4446D160219F3@cvk027.cvk.de>
 <20220517174447.0e596e4f@kernel.org>
In-Reply-To: <20220517174447.0e596e4f@kernel.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvk.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31c8bdbe-d7ec-472b-bfc7-08da3898bf53
x-ms-traffictypediagnostic: HE1PR0601MB2587:EE_
x-microsoft-antispam-prvs: <HE1PR0601MB258700E8637A2B4BEBCDB8658BD19@HE1PR0601MB2587.eurprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2kX1phfhHhwBkBfwG2VuEexh6UbEbqrM5ZeHq5xLNsONik/aOA4r36yshfMEsiJLRXveMyfagPYY/02TQQwr4ooBiAqeWQFPPMxp3kqfiXmlPYRI6SECLbhVL0JPaX1N8dIisooajIlFPM2bobLVeuP3/+hmp7zH42uazSbdrN9xsDS9Mf+5H8UCHYQPbAtSJCUzh/pqVJTFUgXCTFvSPfp+6JgFxQHLn7C6nRyuLJ+SHCa836elczVIfE1+YdQ/Yj3sa/FMta0FLVn1opGneF2OBQCW6mjLRUknS5iUvV2B9l2kyQQQM0M7lG/hiQfpNYRkVnpB95JU2d10OpLAyzI1kuWIPyTqFWDWWATWyfhh64zr92WYT6FuDENw9AdgOCr1u1Qr+ZHsTp1CGloyUxBm7XrRlmq2kTWaB8C4v4Xn+HCRfxBIlm4ZG9EutzszqY2G3mrT+pb2IguiszMTj4pWKbtUol4A/lzKOVDZPtq7VAWUHuWooh0VRvJ3pxUUQ8y3gKWPLgl/kpijpdnWXY4JDtJVpWEPVHcZRXKygFRxjg1mcDrZfhqwKmdNjYFSN/bpARpn8JPSySAc2hpQF+G7mknnHDiSOv76KBsBy7IK+4xwIYurqSBNWW6pdHQs53Fbe4Gm4H/YAF4U+jw1gyqxzSFnuu+oLsbZVXW4VG5lT3dOgPlMAeWwKlHYF2YdigwsS6oEOWCOGEynVClx+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR06MB8442.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(122000001)(66476007)(64756008)(66946007)(86362001)(66446008)(66556008)(4326008)(38100700002)(186003)(2906002)(9686003)(26005)(76116006)(8676002)(5660300002)(7696005)(6506007)(83380400001)(33656002)(71200400001)(8936002)(52536014)(55016003)(316002)(6916009)(508600001)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?opnD70YnAgZdtIuDVpOUtZt46myX2FrXUsB00tsINiu9bl/X/ZDMVA6gn/?=
 =?iso-8859-1?Q?uOheGkYkFlLHTa9EzsPOc82a3sFeFcnsGvcWcrBuzoViwywjOx6bOiAVDL?=
 =?iso-8859-1?Q?/AhIdbdg16HiXzgFtG5Ezl/yLmnOsLoyJf2ONCNS7jYEYSgnUBp9vACIp1?=
 =?iso-8859-1?Q?pi7E5R7HefHzAGuUqsVtvPJ/rnk1xHXMjlZkSbTEBUERfNHfsaDK4YEACh?=
 =?iso-8859-1?Q?r2IbfUxgsdrQxAVIRPpQhL8AQ/CHbUE97sZntprX6Kmbqg33En1BCtszqq?=
 =?iso-8859-1?Q?OjLnKrWE54iM5/9Hhk/m381I92Ctse0eOI1n4yHoxiexsYsZrvicsnxaBC?=
 =?iso-8859-1?Q?mEhn/EuMMyVnZUdy8LZXfqYYZ+8pzsKtB7kN7OzptP5YLsLp9uC1hCil0w?=
 =?iso-8859-1?Q?uf7StmBD0iFexr2etkL1MJlURow5pZ2hIMXVC5AXZBQiUHL/kvgXHYjxh5?=
 =?iso-8859-1?Q?vJwwJZ8rAm8qw1G/lNErsh7GtBfR11lMH8iaDfy/OdDe+khAZz3AYlWt0m?=
 =?iso-8859-1?Q?49YLFOd9eHWd7+Z2a3lK1PUZtJX847mqlTUQMCS4moaU9pS1l9Ly2YAM1P?=
 =?iso-8859-1?Q?x6VcHwZ2bdHQUw9TxGWbI+sNMSppCbHsIo9+vR20/BKJLXH9pOD1+b+zzA?=
 =?iso-8859-1?Q?CvBoLMec91k1m78hT5PbJ3w24f5T5t9n9TbOKzVaL+46QDhB9GrtyWsyWk?=
 =?iso-8859-1?Q?UjhIiIVX3fXuJQ2OgBtt2tGdeCT6U1TKjsiJDVY7tuzlPxlXoL3axCdD12?=
 =?iso-8859-1?Q?+4dpo1wIxib2l8a4+dxZfha1OYbNeNDQXEQTZHO8Z+spUmH/DB6D1qlzPe?=
 =?iso-8859-1?Q?/iIPQ2AjCvRA6zbY1f06O3OhgV3hE+5wI0BJB4HklBTUUPSzL3H8BcKWWR?=
 =?iso-8859-1?Q?U061zwARZfppVLv8mdlf20t2baUWDnbRTVjUHOJ4ECKa/xvT+CBIPAmxFR?=
 =?iso-8859-1?Q?qINxj9eCQ9K3Ju15S6v8BBaK/WhPAYCwxLt1AEwdvBdKjlAThfnQr3N4ts?=
 =?iso-8859-1?Q?ZOg+D4kU69AY4W31SrrsHupsCAeNCYfzwgMTPMZU3cMlMstymcsVRlKUNx?=
 =?iso-8859-1?Q?IRYOf1X0aa3OEFcqq4VlH/hHaI8UfI47XjYpzS7BByIMyAdFlsHJMQp8sN?=
 =?iso-8859-1?Q?CL/wYNr8UKYP6Jo5CBoVI9x0+fZ9QIWm2aYmifMLPIiZL+G2FuzxdEmBet?=
 =?iso-8859-1?Q?v4AYKzbW17CnjrEScF9M4woa/pWJ80M+z8wIwYzRqI6O1dS28rRq0/k3eZ?=
 =?iso-8859-1?Q?oExi+cTNFomh0lw28XEegLow8G/De7z/ZlsGMlwtb6TeX1UiFAmJqC1Rzc?=
 =?iso-8859-1?Q?0WnOPnELc+K6z/V3Zl/NpMB2JKkkSp7ljjxy5xwX7c0S62SVbQQwjRYFky?=
 =?iso-8859-1?Q?U2Kmgt7fZcDIfWQwaNwl7BQjtdjz4R/hUb3+cml6KiXMBuBY75tXF1nVhe?=
 =?iso-8859-1?Q?FcJz22Jad5hNt5Uy2Jz+3fcGTjVtWDM4LzWkSMmgN8LaDexV2BF/t8pyMt?=
 =?iso-8859-1?Q?rFOxx+uomV5DYRonVy39JXujU7ui3iv03p3rw0Tz1CZffPQZb9ON20E9jx?=
 =?iso-8859-1?Q?RHIJKdx7Iwwz6sXD5EKhe+Yg/TlCk5OWLlvO+IRRVVDZ89pkBoP2ke6qEl?=
 =?iso-8859-1?Q?z8R4X8tcBfOpBoN1zSpdObYt4yZzNdwOYODkaOGfLaJThOWjUtFVpAvxrU?=
 =?iso-8859-1?Q?E/1MHP77Nr4LZrQPuGP4RVx/Bc+tpUGvZzcpK5ug3Gyb97IPLX7LZasg1h?=
 =?iso-8859-1?Q?IbmjwJPiK2bgMB8/pWkoOwoXPq2vKxxfowm7epwFlD2DzC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cvk.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS1PR06MB8442.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c8bdbe-d7ec-472b-bfc7-08da3898bf53
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 06:36:32.2155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0be0d70f-f404-4497-9fa7-3a7b7c98630d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xpd/+cRRAx90u5Be0uTAOiw8QMS7unXKqarWr/Pq+mHD5CdVfqc4l9ztBUVp0cLt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0601MB2587
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks for the info. I've reposted it with the appropriate mail headers you=
've suggested. Although I saw my first post in
the LKML and netdev archives. It's my first own patch posting.

Best regards,
--
Thomas Bartschies
CVK IT Systeme

-----Urspr=FCngliche Nachricht-----
Von: Jakub Kicinski <kuba@kernel.org>=20
Gesendet: Mittwoch, 18. Mai 2022 02:45
An: Bartschies, Thomas <Thomas.Bartschies@cvk.de>
Cc: netdev@vger.kernel.org
Betreff: Re: [Patch] net: af_key: check encryption module availability cons=
istency

On Mon, 16 May 2022 14:57:30 +0200 (CEST) Thomas Bartschies wrote:
> Since the recent introduction supporting the SM3 and SM4 hash algos for I=
Psec, the kernel=20
> produces invalid pfkey acquire messages, when these encryption modules ar=
e disabled. This=20
> happens because the availability of the algos wasn't checked in all neces=
sary functions.=20
> This patch adds these checks.
>=20
> Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>

This has not made it into patchwork.

Did you put the list on BCC or something? If so how would people=20
on the list see replies to this patch?

Please repost it with appropriate To: and CC: lists.
To: davem@davemloft.net
CC: everyone from scripts/get_maintainer
