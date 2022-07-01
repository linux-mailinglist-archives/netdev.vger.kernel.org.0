Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCFF563801
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiGAQeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiGAQeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:34:19 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10071.outbound.protection.outlook.com [40.107.1.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F6B37A3D;
        Fri,  1 Jul 2022 09:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehfwcIgDv0r8wnGE8kAv4ux5Pwp9KULTljeHgiAucVLuU+rRDnL1P7ncliGQ342IfNBwBr4SepZ+v6VcTrnGM1nChcphHDtvM/xwxTFweaW6NJvEFqwMcglctxEVISZdZg1Sz3KFIWhxFSY09hEmNMpukRiWNIRJRvxH6qICsRAfkg+HOrp57YidclT/8VGLV13i5F3PaGfA6/PWOeMetLT+TW+WSC2zDLcWRMLPOMNyNOhPAYf7ae7m2oYT5521R0pdaxPCJPYUwzaVUCxR4Nnx/cme8YiSaps5dIZABVwcPOImCy1ARotn/VwtWBNDB93iUVOMSt5mZ1+rKSSLcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OXACVsPZMVMbGCXOeU4E2gvRnGDNrz3Fud3Khz+ZK4=;
 b=i3tFUMxvPOGFoKRh3eerZgKXmoMoL0lkRVbAn1qKrz/pebVzf/5zKhrdhgiSRhGCTa4XVkpmIRavHXpUepBIhwDP6cOTKvXrO/cZcefJfYWUMQjcWzF/M7imu9W9AdPREe0TaynWBlRvlzhh3+fFjpuSIklboDvqp6nUVKPUlt9bGGre73foZa0S1eX/BlRS12ko3CK7PhFdlTHGKjH1caPUBnmKxnf6AoUVYM94QXS8EGqFxvIGxEkxKyw10yxPaQ9EDTgp7/+JpPLQp5G5VTkTdcVYURWsiNPPVTlfE0knJ4ZHdZj/6tgm8UugtvhjgC8n/1moxW1zg/R93443xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OXACVsPZMVMbGCXOeU4E2gvRnGDNrz3Fud3Khz+ZK4=;
 b=BsARMGrvc4nRqfrou2JSk9boTMeqI6fex6ykfxBHERQwETATFMXJp6KxxajX+emtpN4ZHsbyQNnuECt9prUjX9PlrZ6uM67lYPsfXlMEy8gXV2hiGZCkmNnBYmu+rAjIX9PDgui67YCrObYUgPHUoale81smQPEYzJ7ypLHb5B0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 16:34:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 16:34:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 0/7] net: lan966x: Add lag support
Thread-Topic: [PATCH net-next v2 0/7] net: lan966x: Add lag support
Thread-Index: AQHYimHdDTDh5jwai02cndkVFmS37q1mUicAgAICugCAAWcnAA==
Date:   Fri, 1 Jul 2022 16:34:15 +0000
Message-ID: <20220701163414.q3dpd32a2hwi6dtg@skbuf>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
 <20220629122630.qd7nsqmkxoshovhc@skbuf>
 <20220630190846.aqagifacrleejrjc@soft-dev3-1.localhost>
In-Reply-To: <20220630190846.aqagifacrleejrjc@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 698d57aa-0b65-4f4e-c228-08da5b7f89df
x-ms-traffictypediagnostic: AM8PR04MB7347:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EG3/t0baQV1EmV+fNjlbMabUJw0aMaSqTWwZiZScbvQ2cxB/KAQsnZono/nYFhlAXrZc+FUgNy4nrQlqEndMPptOy1tkxmy/UMeq3u5RLXL8QnS1wPIF3Ud54M030CYmdYTB/9t73vqnCgW8cFaejPvhXpbJyycHKerJ6/58YBsom9ALweF3rBrcyZ/ROuM138eOGGMZEcqQ37/pC5jyUFgfLuCJ/GRzhPzpREuby7xZw+MoOw/FYnZDIa0JZOpJVA1SuwXJTCyGDnvOWAGRX4wk/htfUOSgPpby9+3nSqDCA/iIt5M9S0fQGrjX1p2vWz6tFbO2spHrNgIDQcAMtKfq+XoLQkGzZKAI4h58QIA9uqn/ugAikWR6kaizDQFxaj13bJMXopVGbhirgtMzz4evyIHtgPfsiDmSjUNCCFl0gd2U98xWngP05Xwjvio3sgCIn12IbX4Jt1Si+IMqRHzh+lX9KAi9S65OdXdvmsW10InqRRqF7PBvWtFa5kj5stmsEmckHgTLovyrZaM01arMhtqns7oFm7azILCcjGnqWKvi2Mg7GLOjB8cx0u4Fet82RhnsREVfNHAwykt2kxmPEDy1aQafSvxajB145d+LBqH4r8etnL0qQelWAX+2lKUgc5Gbxf/ILHY9lTediqH+58sNHF+d/AOqAwm7XCGlf3bpGGbIifRWazzLCOpWpDhqdqnkxO5a4uJiOhT/5j3rXpGaLqcJ5ZsZnwPbjje4Hr6pQqPvpkGTRe0+zJns9yFuUN2dEamU0psvkjvrCfCUmUPzrku0D6rG1TSwkpT8GLwFZ/gutDKyIZm0+eDK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(376002)(39860400002)(396003)(346002)(366004)(186003)(9686003)(71200400001)(6512007)(2906002)(33716001)(478600001)(8936002)(5660300002)(44832011)(6506007)(83380400001)(1076003)(26005)(41300700001)(6486002)(86362001)(38100700002)(38070700005)(122000001)(4326008)(66476007)(54906003)(6916009)(64756008)(66556008)(8676002)(316002)(66946007)(91956017)(76116006)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x/sevI0LJ8VB3Dq32uq+jRzMmYp4rnZ7BSMYNZBt7aA/MckJFSfNI//YfKi1?=
 =?us-ascii?Q?S4xyn3Uv01nLOeqIDqyR9ym6J/34VLOGE+odiDhktmP5M8B6Af8Shvp64bC/?=
 =?us-ascii?Q?Up84HvjXUqTVvyPRiEycwNKs+Rm0RUqAQhXWIFHUSu8POyDX2buLUe3FOJ9J?=
 =?us-ascii?Q?biFYK9M8S0c8q6b75Q4iFpDVdmGEwmFHRxexHGsXBnF04TXwYenb2DvreAod?=
 =?us-ascii?Q?t75wJunpHpDFgotMihH8ysKuIwFeyShqAaVvQNl2LHyEI1LkhiCsbKRgDSJb?=
 =?us-ascii?Q?ykL5/+bZw9fsUuW5BqggqSO69Y1pwT9U+nG+uve9eQcbLeOG8RrEP5MSYeZf?=
 =?us-ascii?Q?QV1a2mf+Dy6LJQTnd0tcX4LIFLkd1g9tHRMdIb19b2JIQKPnS15p2Jlcbu3A?=
 =?us-ascii?Q?6W2AycNEjdWYwgO9wft/8ksJz2BO6r1ChjquleNcDjzYYkBj7xFW+T/BxNWX?=
 =?us-ascii?Q?SY3XEYpeUXV69nOrFSDh3GhJKJlB3Eoj5FjkWCiU4tAwaK95Xee/hDsuwXLd?=
 =?us-ascii?Q?bn8AUR2ib0xmKQdymkHPdSLzSy/bpYl3dlL0HkYWgvvWodXCPpscN5iyCtH/?=
 =?us-ascii?Q?Z/9RAvZJ7sAPpetN3gMXSPFOvG01w7Mdgohq72qtH8RnLjwnLjRISWAkHwDH?=
 =?us-ascii?Q?xtN1EfyC7GI4tHdFiMiEhF3drIKqOw6NeCPpq2AYpeTFmhOFA/sSxXU3MCGm?=
 =?us-ascii?Q?ozDxKgAeAtVfnk1DTSC60CTRyC0NXxlEeGMWLJLg/EXp6/VffxiRXmH5LOhd?=
 =?us-ascii?Q?m96LK0HH12YqotGQbyY/SBzWEWCjpDQSea5KjEbrC0oGeC7xda75aCWGfcWu?=
 =?us-ascii?Q?9pHhzed8iHMIm3Lus8TiLM79VnknKimEkHFe4/B5+wwI0XNp5znE3gc7xtTp?=
 =?us-ascii?Q?vLJOkx6UmnGIklhDTWXI9JtpXkHJhnqpQJkytFo4KNjhzSBQCp3vKVp9iMr7?=
 =?us-ascii?Q?hmK1zY29zMpdncKISi24yb5UNW/qqj6CL6d7WYUq+RV+ZXUKvAyjbZi8LOUu?=
 =?us-ascii?Q?/CUzKkZnvgjcEpvHhTaaHwAnyPjx7siWl0h2ws/VgL822RgTC0K2b41a7bpF?=
 =?us-ascii?Q?Sypy0xYt/+6ixZo9rJja66USg1NrGWyOYYqkzXwUukGq5AzymDVe+cXejl8u?=
 =?us-ascii?Q?BF58VX142sTX1KDwkVb+gOWqrGlR3Wz837QdZ3KPqDs4FHU3sJvSbGoM2nkA?=
 =?us-ascii?Q?GiJZJdyE8bIBRzelncQQ+aaWrGY06W0Wzkk2usdYmdHlQ4wj+14PeVrlB41G?=
 =?us-ascii?Q?ud68Gnp1udjp0FhnCyhLFnktg+xIorJMW5mrxcMygKAtnxdWLlvbsBjPJHZX?=
 =?us-ascii?Q?3S2kNN0WT4jjJk/PILgdoFYtQE7FlMsCKQ/mvey3+HI7xjKs+cXmZWqD9AVf?=
 =?us-ascii?Q?4JHxrZT+NVY+2SOnvxkVkMGHfb9wUc6VYrHfh9YbeQwtN37/6PMKJtnz62h8?=
 =?us-ascii?Q?Z+SMLHupHp7jZH9vVAOZCdcs7ErVwAI7evO7xkubqza8fnYCFSoAGu1TJ9Tr?=
 =?us-ascii?Q?tOvwvGNnuP7MYufcrykSpY5Sw4hyiR7eBPizTsOM85BOv78IpD32JkFCnZoO?=
 =?us-ascii?Q?G1i+H1ScdwuYkDt/L0N20tb77BhyljS0NvhN1tM2IceX0XsLRz+7i8XuQ5Ao?=
 =?us-ascii?Q?lg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E0A90D906843704FB8F5D1A2730815BA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698d57aa-0b65-4f4e-c228-08da5b7f89df
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 16:34:15.8307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JVLSjzsLiz8bYznaO0tLgw1f1F9tG3W5eeOWnYzyk0Ip4wIY86xymhscaV6NH9yd4Mwfbb31mw9Pn0k6n35aVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 09:08:46PM +0200, Horatiu Vultur wrote:
> > I've downloaded and applied your patches and I have some general feedba=
ck.
> > Some of it relates to changes which were not made and hence I couldn't
> > have commented on the patches themselves, so I'm posting it here.
> >=20
> > 1. switchdev_bridge_port_offload() returns an error code if object
> > replay failed, or if it couldn't get the port parent id, or if the user
> > tries to join a lan966x port and a port belonging to another switchdev
> > driver to the same LAG. It would be good to propagate this error and no=
t
> > ignore it.
>=20
> Yes, I will do that.
>=20
> What about the case when the other port is not a switchdev port. For
> example:
> ip link set dev eth0 master bond0
> ip link set dev dummy master bond0
> ip link set dev bond0 master br0
>=20
> At the last line, I was expecting to get an error.

switchdev_bridge_port_offload() currently only detects mismatched port
parent IDs, so it will not detect this condition where one bond slave is
switchdev and the other isn't. This is because the non-switchdev bond
slave does not even call switchdev_bridge_port_offload(), it's completely
silent from the perspective of the bridge.
Fact is that we don't have a common layer that enforces all common sense
netdev adjacency restrictions with switchdev, and that is one of the big
problems of the system.

> > 6. You are missing LAG FDB migration logic in lan966x_lag_port_join().
> > Specifically, you assume that the lan966x_lag_first_port() will never
> > change, probably because you just make the switch ports join the LAG in
> > the order 1, 2, 3. But they can also join in the order 3, 2, 1.
>=20
> It would work, but there will be problems when the ports start to leave
> the LAG.
> It would work because all the ports under the LAG will have the same
> value in PGID_ID for DST_IDX. So if the MAC entry points to any of
> this entries will be OK.

OK, I forgot DEST_IDX selects PGID and not logical port ID directly.

> The problem is when the port leaves the LAG, if the MAC entry points
> to the port that left the LAG then is not working anymore.
> I will fix this in the next series.=
