Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33292515D71
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378007AbiD3NXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378527AbiD3NXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:23:24 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2045.outbound.protection.outlook.com [40.107.20.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A654CA8895
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 06:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ir2K2AerGxJhEBJlx/qB3uohkDz2eXIje5tyt5KSNBqUkn5uOXb3hqPKR5Ob+oCR6ay+B/13OaxhH66o0FnzfpJEbNp4LKVVgnVg1PpcSUQ0g9sysuuPyYJzw8Rovg58selJRSpvFX9zx9k7Ut++QU+sddQ7znfuAHrgXH9O5jKBK/iH7S3+PsDYI0/10RDFjs2Hem1isA6kZg5U5fC42gfAbFt/+QtO5ArV3MQVQcVxujVVyGmw25zQJhvLydV7qr9dDa080jrDKV7VwC7/pl4gkewJAUnE3qTIsxFBMph9w1nyOkDia4t5T0m2z0rx55DxjrVyCYbZFWedkPIxCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qfWTf9QqRyZl+K470iKrhGYRhcIXjWykWT9gb0BTKg=;
 b=DTC0P1ep3MaOVuhoD1+ZW8a2RDorULj+KeHi12y+45fG1RJhS2KzP+CyZ4H9aI7XI/OkA9jgPr0J9xTFzK3fP6mEJCB/4Kljyd+qQb5ITMXr6GA5aKJCcW05J68wl0m6Eg0kn5WrUvTE1H7LsDRWUrKj/iL+Sqc61Bcc8oCDWiIuglyFwbdQpQJHBEz69vuixuRiCRbirmYCwnDN9Lsi+BCN/htpbr8CRNowhVLXOPi2vpxcwZZRToYWi8usIn7+d7M/a0TpTqiOk8O+fh1jr4JdqNBDSthskOLHM3tXHUp1Oz7Fjb9wKd+0KH352qxXLbJM6fOPmsuxUNz9Y+EB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qfWTf9QqRyZl+K470iKrhGYRhcIXjWykWT9gb0BTKg=;
 b=Wqa0zI1KKmZ2owVIkpPsqLk7vUtXO6PBH/WTJ5xdyREMmheBPEHtrBSdIGsDUbbsKkjISt0rqcnlPhUPmSErR2Q5R1wRU1wpeNPfYrGfbEeFeyG71jwlsGb8MTbkCijiaw+VYhACoSPdq4Bp19ZJxfeqlAHQkuofGcggPhqwHWg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5404.eurprd04.prod.outlook.com (2603:10a6:10:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 13:20:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sat, 30 Apr 2022
 13:19:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     Kurt Kanzenbach <kurt@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Thread-Topic: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Thread-Index: AQHYW0GuNYRSTEqn4026FUjTTdPmD60Gb0AAgAA0E4CAAApPgIAADJIAgAA6t4CAAX6NgA==
Date:   Sat, 30 Apr 2022 13:19:59 +0000
Message-ID: <20220430131959.obb74c2z7ihap6ek@skbuf>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
 <87v8usiemh.fsf@kurt> <20220429093845.tyzwcwppsgbjbw2s@skbuf>
 <87h76ci4ac.fsf@kurt> <20220429110038.6jv76qeyjjxborez@skbuf>
 <Ymv2l6Un7QXjrXFy@linutronix.de>
In-Reply-To: <Ymv2l6Un7QXjrXFy@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a36a4ef-3375-4471-e11f-08da2aac20c8
x-ms-traffictypediagnostic: DB7PR04MB5404:EE_
x-microsoft-antispam-prvs: <DB7PR04MB54042C3BC4039022CEB07DBAE0FF9@DB7PR04MB5404.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vD5hylWjOg7hvXGyqYVeMkh5Lw8AFyP7oAawXYyWrdEnhrNbN1byLZrbIRrq38A01of2Rk+7k/0WGDUKOKkJKBi5eXDSGWIu3mzsAzL400dLDPXZ0G2Y68TFbOgIfcTkLEqM8AALwCJYgllcKiGXZeri2+u6uxQqyMwz0FgXzLlG+KXr6j5JPc2gFuLeEkBHzExa33XSY10Yv9aMEn9+mDGvg7wnIj8DOm+may8Pq64qhcvslbmSVT1RZmgK/1CazPiddxDw1DKbAs6mAVtACgdj7ThVCsBbyRNeNhHvUPjIm0zbas29VbH/opwZrjeO7K9Hqc4bK50AVJ+6ulim1B0Dm10S2x+EzYIRhyGK42W0ohTt6+SBaxCFfsbyCl5lkIgRv+j198Jx3G9+47AVaKDwl3AEJCKECQVfVV2IwVY2jFnNCTqEtheo7a7K9XHHqdbeKjTstD13xcmguortiVQph4KYl0+fwd2HOm6/TCbhNDZyFg5qgw7eSjfsR3TK8haahihosKJ7eEvA5m2ddSH7ncXSCexw2sV+riJ3YmRrrlYKIBuccx5Va1+vlbXszWq6UqWX/WJtJUxfIxxBXi9RI1oz4qDL2ISPZdwwgGdML5gpyMVTF/lKAwvxBEGgbuK86LoxCsY9Cdz1FOmIb8xV0aywLxQFoHK7DXVWm6/AFgfEN6+veDFKyS3oAucdofH0Be68XnjCYXucYtnc5QnyRJ78cwTGLeQKceG1y9ccp/hrZcWaaB5gFFJMPRytIyPWT9vbJG4x+ADdAUJ5BLvKQfrHjYT4ZNi8IqlHl7c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(71200400001)(8936002)(316002)(508600001)(1076003)(186003)(6486002)(966005)(53546011)(5660300002)(38070700005)(38100700002)(76116006)(7416002)(6512007)(6506007)(6916009)(26005)(54906003)(9686003)(2906002)(122000001)(44832011)(66476007)(66556008)(66446008)(64756008)(4326008)(8676002)(33716001)(66946007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zzm6RaEVeVYVkO/kJ9cWV1swo/TvGETrWbHtxPGZxWtTTLkVMFWq6LXxjTi1?=
 =?us-ascii?Q?OL0b/Id/5hZZb414+q5RePD4NmFuzP02R1OtEjpb04FRecJx8WQeIBwcQyyC?=
 =?us-ascii?Q?Otoopbx+ARTNox3SNbx65pmfufkRfWnRxj+LBWSMYk3PnY25qwXkUhsiHawc?=
 =?us-ascii?Q?qtIL+7txIX9DSrpw/rOZGGZ7XoJlxxqedj8tiW3qGtNu3/v35j5uBqOFc/5H?=
 =?us-ascii?Q?KG7RkfIWHJvJX2wQ1dpq07FFQafVqU/F0FZ0WoM44obrlOWo6gHBjx3B1obz?=
 =?us-ascii?Q?LzuMjOI56N680dEQZCFAhlPRw2147kuLqDXJIx2Y7erOSRNSQfFw81GEqdzV?=
 =?us-ascii?Q?PfgnJwoav2I4ciwddhTt5hcvCKNEbjkJbDjbFJJh2pi9MKhauueGGij/Sefu?=
 =?us-ascii?Q?JrrhAe87b4Wa9nr4Flvl1ohe0QOdEblIK+mXyaexKR9efFgwy11eWDSPmRoy?=
 =?us-ascii?Q?o8Z0bJU+FKgDxSrEu3aZrxSNKP8PE8ZSEp5QNkbG3Qq/zNWmRO653h1z1Cjo?=
 =?us-ascii?Q?nkdK7eyQsXLrP+met1IgK3ojLJfliwghQauFem98EhKe6NpMPUqS37Zg8W0O?=
 =?us-ascii?Q?ywgzF2evOBWgmgWAAh1AYKe1SwRMJR+le3l6EMiHtW2ifWVx4qn8KCLwvv/l?=
 =?us-ascii?Q?PCyrtAgteISvTlVr6qCnFUbL4xXLEd2n07cB2BEGp0QubPPJmw8PN5a6HAsR?=
 =?us-ascii?Q?ZGtk5ssOc8igW0BduWr4a1VPQHH5BnC4XUcLoE3pN8kFYFm08dED+x895VjB?=
 =?us-ascii?Q?c/hDm2Im2QSg5n7SIy77/niq0JXrla26fgwplToKtzPUog/vCas4mJ6DzAgO?=
 =?us-ascii?Q?WQ6/jSyrKfAR4JO1lGgjMIG3t534LyJzA76XUV5SBJgUUbRTqFng9rG891YE?=
 =?us-ascii?Q?/rfhxYVFGc9/yMI/jVAanQ6wakbZCp1igsoj8jPXKi0+zevb3E9pTExP7g2x?=
 =?us-ascii?Q?tNyAmMnoHz2IeYuWCXWTLJKX5XktLYVwM6k6Hbb0vbjGxp9qwipfA7xXyn6U?=
 =?us-ascii?Q?fWU5I9QmptwI+GzovGzoYiR6vnRXzp+52ECVBifK5DrF9OasiTG2beBwYCdW?=
 =?us-ascii?Q?nesITlY+BvllDeeCrrSrzTDfAiD9T3pvB2KUW6E/1jE/7mbrMH+2+PFGarAD?=
 =?us-ascii?Q?TOmqd6D40TeHIAaIfMvnDBWyMa5jolR0rbVyfD04WLtW9tlSO2pYvhIHIWoI?=
 =?us-ascii?Q?IAjxx0eQyzuLYrUzE5LjuPvXgJcgnd8ngeBfpHWyoVz13liUnZ0irmu36kyH?=
 =?us-ascii?Q?50QSgGG8dNmrrz+zkxbf5CmML5K0wJCgNPs9AWfy6Xpxcah0zoBGfNCjGiuU?=
 =?us-ascii?Q?O2gUYxTSRQ5aVxHsl5EpcsP9aZgEUQ8xCuBazVeopCCUxL2r2EKnu6/LKDss?=
 =?us-ascii?Q?PJ8OhC9rHsUh14ipVRmJITu/4EMHwtbhmBoR7u9t7WUs89+kBDlz4X98a7UP?=
 =?us-ascii?Q?0ME1N/sxakD1CYRwQohg3ixYnU5n2WNyteSECkXzN25Dz+9ZuI1c5oXgDLFn?=
 =?us-ascii?Q?77O+E+0yAY1xt7phLjXqWGBEVR3Erdsb9oT+O/ZhxeS8uNJN0YPHSaYQTX9S?=
 =?us-ascii?Q?NK9/pfXHhVmnVhN7eieQwK43WO1TRqz4FczC3WTCrS9koK0J0uoVU9HRY+yE?=
 =?us-ascii?Q?lKS1vvhwGc9Ib0cELcp69A1wQkcBSWHIQrRZlaQtp/J6qosgYMJ8DqeGh77E?=
 =?us-ascii?Q?YYik/nwa4scnoOVb0TqhJC3NedmBxVSIxEHKtyXxio8RFCjB/4f3QhsnnUAW?=
 =?us-ascii?Q?INWUHc2AiZqmv+3YP/rkri6esdD/iak=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <55FE9C885115BB42814667CBA89D5644@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a36a4ef-3375-4471-e11f-08da2aac20c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 13:19:59.8655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XgLfo5EquMh9ZqbTvMuQ57jwmiRsBPPWqGTMQqscC7GcaCxn9obk37I877pqe1WFXdTK3GTD8hznP9kohiNUcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5404
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Fri, Apr 29, 2022 at 04:30:47PM +0200, Sebastian Andrzej Siewior wrote:
> On 2022-04-29 11:00:39 [+0000], Vladimir Oltean wrote:
> > > I agree. Nevertheless, having a standardized tool for this kind laten=
cy
> > > testing would be nice. For instance, cyclictest is also not part of t=
he
> > > kernel, but packaged for all major Linux distributions.
> >=20
> > Right, the thing is that I'm giving myself the liberty to still make
> > backwards-incompatible changes to isochron until it reaches v1.0 (right
> > now it's at v0.7 + 14 patches, so v0.8 should be coming rather soon).
> > I don't really want to submit unstable software for inclusion in a
> > distro (plus I don't know what distros would be interested in TSN
> > testing, see above).
>=20
> Users of those distros, that need to test TSN, will be interested in
> having it packaged rather than having it to compile first. Just make it
> available, point to it in tests etc. and it should get packaged.
>=20
> > And isochron itself needs to become more stable by gathering more users=
,
> > being integrated in scripts such as selftests, catering to more varied
> > requirements.
> > So it's a bit of a chicken and egg situation.
> If it is completely experimental then it could be added to, say,
> Debian's experimental distribution so user's of unstable/sid can install
> it fairly easy but it won't become part of the upcoming stable release
> (the relevant freeze is currently set to 2023-02).
>=20
> Sebastian

If I get you right, you're saying it would be preferable to submit
isochron for inclusion in Debian Testing.

Ok, I've submitted an Intent To Package:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1010396

but if you don't mind, I'd still like to proceed with v2 right away,
since the process of getting isochron packaged by Debian is essentially
unbounded and I wouldn't like to create a dependency between packaging
and this selftest. There is already a link to the Github repo in
tsn_lib.sh, I expect people are still going to get it from there for a
while. I will also make the dependency optional via a REQUIRE_ISOCHRON
variable, as discussed with Kurt. I hope that's ok.=
