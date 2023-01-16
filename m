Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FE466D014
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjAPUXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbjAPUXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:23:37 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2045.outbound.protection.outlook.com [40.107.15.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B6E1B567;
        Mon, 16 Jan 2023 12:23:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MELzZy64AbhnpSikB0iOvq7ljdKQNdg5g9GJE168eBJoHBwsj2qMyJLKBC53cJVkKhSWyOPJTx/PzD7P9CnGZa8UeDG8wiGf6ax/YS8sa4AKpe/6wdFaENELtxdcBLe7QtO5Bwi9Ga7Q7iRtjVF1GgiubjE94e4ux95zNyzJ0ybTDF2GX6bUiOulKhNHGeLn8k2v2xHXbFOLD8pkf6EhMvBBHUjzfzm2yMgoFGP+8G/g0LZJvTFW5MQmllL/1Iw04ZHNbPZv0OZDv+5WNn6KG3YxU4ZZmXNBWGw344yW8KOXsSZ37wCL2urJ+VTNTTRc97679fgJ7K66Vy11zxcDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLbFvowhopI2UROyb0YCZMeVtpAqZv767ry8mnv3FgY=;
 b=FnCxHQw1zgO7TuEnpQxKNBnXH1EY1oKiQ6Wg9pgwlTIKVV8AZfyoG/UTcgGYm5g8hGFAlRMftna1ca79QR7Yml4dYPfNPoaI7KT9FplDOjweEFX8wmCpk78ZgfTdPRvMjIZY/FPbMzpdpSqPOShqWz4NqneZx+1BKRHqrSlHOLfsynuWnjCImCOCZ8TfTD7Yt0/q1P6o59/oatdqjZdnUOkLAOsiZ394YCTVeS8WsnR+RH1QpXsTMvtxTcnmibCOlDezCXCuwcPbX1lXlJhiVIzYDmk5u6StwDYuPSKhtUFOQB/Mo6H/DMD5wlKa1B2jGsNecuryLsAnjLWh/WbzOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLbFvowhopI2UROyb0YCZMeVtpAqZv767ry8mnv3FgY=;
 b=UylpYHa1UA5EIACoFQ827Pp2GQKBTFtaw4tqi4ppNlF2gfcPCSDJ7GyUhD8YxTZdh2VtkaLWGw53StE1DlazC1Th/XcBNt/xwwO71Sv2auXcLIPXnzdE1TeTa4yaXw1Z4CGRW7us5vvi2bGUQZo89P/6hMvZMe2+bKYppaVm/Vtnj3v+lUCFFJFeECnEQuBo8QyCJTYRd69zlj66OasMZR2y1cfuhYM32e31KHC5DwhaVH2mJqRsJTiMjIzg+bO+U8gyfjmuBRVjANoPMcU8+a1flqRK16mXzFv7cHtyUx0KnRdPutEO6zBEl3uWYOkna9BPyszXl7akTu6kydwj/w==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by GV1PR08MB7732.eurprd08.prod.outlook.com (2603:10a6:150:53::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 20:23:29 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 20:23:29 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Topic: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Index: AQHZKSmr1PIgZgy/I0G8u4g9Yr5d7K6gBiKAgAAHoYCAABs7gIAAlBIcgABwD4CAAFCj3Q==
Date:   Mon, 16 Jan 2023 20:23:29 +0000
Message-ID: <AM6PR08MB437621FD8AE1B6BEDF192958FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
 <Y8R2kQMwgdgE6Qlp@lunn.ch>
 <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
 <Y8STz5eOoSPfkMbU@lunn.ch>
 <AM6PR08MB43761CFA825A9B4A2E68D29EFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <Y8VuBbINetkFwQzY@lunn.ch>
In-Reply-To: <Y8VuBbINetkFwQzY@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|GV1PR08MB7732:EE_
x-ms-office365-filtering-correlation-id: 2a73bc3f-7b51-43e8-b0d2-08daf7ff87ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G7TY2qn7VDc+cGgM9Vu7aTcvT2V0AWutIbUwsTXsgfHs1dorES126crDCXgR/KSV/nm8QTJoY5tdwOdfZrX2tWcEMVwMyrCqTwFCtyrxDTWQUluZeoACr7FdJsMdlEw0S+l7eeeRb9Xx8w0S0S2wRYufXs+sfSTTRKzoL8xS6eIvSSsoiudgxNbmLcOG+HOQcThMKRG8GjIYJTVALObm9/ijLOe2DcLU9Xr3Dk0x+PDt20t0PI+qPOvAix4CSuFD6mvFHQsjXrqs9guBfuPE82SWMEOL7QDiynN4cDNxbVlUi0W32rAPB0GesuPflhQjB1kS+xMnO630uVHkgwyDSVxd7vIjTdY5Edzu40sV9PZCMsqh/7CRTQVt8mT+Bmj+hMr4Kf6u1nV7+31nqqzJE6zgN5yKFl3+flGruwljbD8KjcUvh7uCaH3wY9FW3tTFSQ5yIHbCTe+tvRu+d9aln99cUAS3PVygVC8vPyENGthiNUDm7ZCqISQkM96lvDn+CaCgP6tz9ajeReAbN7eo9PlDlLVc3qT9PnrBApaEgC4QDeiBGCO2DOjZXgBh73pVZ0Zi7mFwil7kqxuCiCjDdOz2jsOdxa7eMxcEzM/ZoYPsuP92fL92fwf/IWfQiyE7b0J1RhTnjBLqDWP0GeIA9XDdqX0C+WEujtCPJUJ1KYZMEpP3VLY6PvWiJ/G3u0yTccSTQKLtd5ivPBkZdcT0Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(366004)(39850400004)(451199015)(86362001)(55016003)(33656002)(26005)(9686003)(91956017)(53546011)(8676002)(6916009)(64756008)(4326008)(76116006)(66556008)(66476007)(66946007)(66446008)(41300700001)(186003)(7696005)(316002)(71200400001)(54906003)(6506007)(478600001)(38100700002)(107886003)(122000001)(2906002)(38070700005)(7416002)(52536014)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?XL8DWW+WyONnBq2f+WZkcorZ7GcQlt0Dz0bTOTQMEz5bSBlfpgjVBrBu1M?=
 =?iso-8859-1?Q?ltjOk0AxjTIEXresX8vWBNckbf8MOC0k976VNXRyWO44gqwYE3Coc+MlGF?=
 =?iso-8859-1?Q?OjRaEtrms31UxhUW2tNyThg2YCX4zgnSkiBfssdJ5C7byhge7kr0tz3gyO?=
 =?iso-8859-1?Q?teH9yWY+SKaEcq3U7r+EYIH/H40FbkTH790gVHX10dZwD+tjEQ0fLXekFp?=
 =?iso-8859-1?Q?VCFwrlQyPnUT8rufUzdwuBK60cVBfd44Ew1jwGt+jaY+6G8J2f2uDv2GKi?=
 =?iso-8859-1?Q?HYCmDbMsbVQjDvxQ+jr7HeaFC2IbucfXsTNzhyJO/SOkHq1nxCVoWy5LM/?=
 =?iso-8859-1?Q?R6tB992vzIFZ6SEKTJ+L/p3n+hVkBeQJkJnHQf9WUwj5ImoQDe9cr/EveM?=
 =?iso-8859-1?Q?Gwd/iU1LiIX/8zO3vhOe3iTD4P3kBqp2B+LLCEicaAuufuE7VUaEUJLE2p?=
 =?iso-8859-1?Q?mQRblt23inTFFd0XpaBmOzrYUUM1TCydGdFX+hiWnIuXV3MuM3FFdHgfk4?=
 =?iso-8859-1?Q?R2HXfO9s9pz92T07L9Z5VIDD6Zeyi4jXRRhfGhvYE+8SElhGQPuB+n1b6g?=
 =?iso-8859-1?Q?wpvdKWFbh6m6r9WY9fxqGUqr2QjiS5CweCOGYed+JM54pYvDaVuQpZG6ee?=
 =?iso-8859-1?Q?WsdCk2exCU7umGyi+YeX9rQjsofhrOqRW1oEDbOraH0Cr6hJQRI8mMg1xQ?=
 =?iso-8859-1?Q?B7W3gTXjSvrLh118npJ/QB93zgJTkpw51xxQmZmYOFzoYL1LSiNwjOazcY?=
 =?iso-8859-1?Q?d+jcRvulgqpjbKEfV3gkETMCXgiwMJ8eEy6rbrDnkYyUC/J14ZMa5y2r9S?=
 =?iso-8859-1?Q?TGzj5H+YlwDUM4gXTLxNenlbt4Bb2bZE3lC5DG4IRGrQquSMe4x1bRg08p?=
 =?iso-8859-1?Q?VMl2dX66JjZuF3JCOmReZLa+wFe3VEOpzejLnOCH8YvPVf1YgBFT3YWhjY?=
 =?iso-8859-1?Q?2ui9d6gIUPeeMXm8f5nOkw0F/pTi6UVB6DmsY7n0q95rilvgoFp+Y2Ti9P?=
 =?iso-8859-1?Q?UgzCMBYwtUGjUWRyzxWDNb86ZpsczHeVloccgag5kHajlKBFpdLJmGaRdL?=
 =?iso-8859-1?Q?WN6khvItVwDC5BlQ+uyBkTGsimY83uToLtMrEtYJhveQa2DnhW4Cs2akoR?=
 =?iso-8859-1?Q?jmwlHvZq2ob/8lfM2qbYL7S+VnSAaiwl4Hp/ZT1Lltlmk76lXdR5S9ePSo?=
 =?iso-8859-1?Q?8WIUhlizLAe0Hc4mujlsHR2uR1BPaazWOfxECcon4obWi1OoXrO3aerLRc?=
 =?iso-8859-1?Q?Zovh/fwOn2AsTnRhfGDxho+vID5gtYgEuHaht3HyrE0fKZtFQNzme+VlOz?=
 =?iso-8859-1?Q?d6eTzW0/Dtd6ew58NHfLrr3nGqo9xZwkjJSrY25ZFXDmXPxTfEAjrCKS0Z?=
 =?iso-8859-1?Q?++mhPDA5IcovoT1VAfbRLqMS0Qb9YhR+DO7SR+f9rTQamN+xB1w8CiieG6?=
 =?iso-8859-1?Q?pp7mfDo0rVCmQQ29rOcfYE0tNuPjgFEhqspiTeMqKxtW8WjvbCCgYnpG6A?=
 =?iso-8859-1?Q?jaa47l18L5K+Rv6Wcj0Ez4QAPvbMaI7Zj0gppf4rZyWYRGjVHfgQQX3htw?=
 =?iso-8859-1?Q?Lb3M4O62VkfD8uRupqK6a8LUzTssoDTyQO7dbw9S0p+WlRICpg5z2L0Yw6?=
 =?iso-8859-1?Q?DsxKQKYHPBzFW6wfbCeSU1nBKcUu+geAKV?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a73bc3f-7b51-43e8-b0d2-08daf7ff87ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 20:23:29.1087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N/g4CaJJ1MnYZ2Cfu457Oa/ph8k1wUxjff3zxei+hsgneeHEtERYSF0MkaY0/WJcGDy4KParOWEmdQBR22P4xoqgTiUWn+N/tiUaoq34VG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 4:32 PM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> > This is the setup of the corner case:=0A=
> > - FEC0 is the owner of MDIO bus, but its own PHY rely on a "delayed" GP=
IO=0A=
> > - FEC1 rely on FEC0 for MDIO communications=0A=
> > The sequence is something like this=0A=
> > - FEC0 probe start, but being the reset GPIO "delayed" it return EPROBE=
_DEFERRED=0A=
> > - FEC1 is successfully probed: being the MDIO bus still not owned, the =
driver assume=0A=
> > =A0 that the ownership must be assigned to the 1st one successfully pro=
bed, but no=0A=
> > =A0 MDIO node is actually present and no communication takes place.=0A=
>=0A=
> So semantics of a phandle is that you expect what it points to, to=0A=
> exists. So if phy-handle points to a PHY, when you follow that pointer=0A=
> and find it missing, you should defer the probe. So this step should=0A=
> not succeed.=0A=
>=0A=
I agree with you: the check is present, but the current logic is not consis=
tent.=0A=
Whenever the node owning the MDIO fails the probe due to EPROBE_DEFERRED,=
=0A=
also the second node must defer the probe, otherwise no MDIO communication=
=0A=
is possible.=0A=
That's why the patch set the static variable wait_for_mdio_bus=A0to track t=
he status.=0A=
>=0A=
> > - FEC0 is successfully probed, but MDIO bus is now assigned to FEC1=0A=
> > =A0 and cannot =A0and no communication takes place=0A=
>=0A=
> =A0 =A0 =A0 =A0Andrew=
