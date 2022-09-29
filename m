Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FF55EF67B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbiI2N1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiI2N04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:26:56 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2041.outbound.protection.outlook.com [40.107.20.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9264188BF4;
        Thu, 29 Sep 2022 06:26:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odp8bjYakhjPG+o16gkAbPnPMegwHk/162X/9OK9L/+AhCckoojAibzZj2RHQJFnGDUCs/MkOdxrxQrumFbH/Adw2iGZbUyTlk4qJNrqRnZhhagXl2FgZTHcNPopm1KTYZxvsMf7O1H+Ogfgga3r1b9hQ6Q9M87LW0ZDvQ8SL8EsTJ2BLFbOCQCQx/2BEtorjPa9AjtDRhoA00cgzASnU9Yde5VUFo+Om9fP+fZGMMqPCL2SE17JnQfW5qrZwtoepY9NRwL74dgZTUDJJWv8rhtRHvvXTOyJhsi/y8sOiZuDksH7pLerIcG/9gY43Y6/eE2wTgSON8kdtCLDvOWGFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQN0mZMHb2JvBtx9Ww+4dhoUbHZK3gu5y/2AXKtJTv4=;
 b=OwJNv2HNRXBuh7MZbN6+Sb7h3bmZ4hNYXyf4i5qpCEF00GNPT/mDEmL0KLax6PXcWDGVCUPNj40UK/xtGnobUvqcSrM7n2Y724bRL47JVP3bOUKe7y80Fh4+MS4ql/LSzxHsMr18SidVy0pMBdSHR0Flg+nPub90bXWsgcwn8ocyOwvUaXsslfhkB4fP0+eeWTqTHvbN5B+i9a27TeICNd+wX/5UJ4waTv1NPDQ2roHRTOgdGfPIKcNRb2vVtFzvtxXt2INB9xhOLOqflTC4Z5uXhwFoFtF1B+t7+e3K/Zjr++nKjgZt79t8wBaMsmJCtTlF3SutOfws8MRZ8J+mKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQN0mZMHb2JvBtx9Ww+4dhoUbHZK3gu5y/2AXKtJTv4=;
 b=feX7cSCt3Sy+JfMRYGnt1n1w57UfrmMNT7GyGdNkdlQw34fHNfR66Xyc3kLBdcMgBWt38cOuLn5FCXF1dJ/FNdo35vrRUasG06nzetDIVD++N+HNK65BEd+DOadykP1dgZed4+U0iFWhs0U+C4CYU/9wpgObczT16Y1U1AxwiG4=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS1PR04MB9336.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 13:26:32 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 13:26:32 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Index: AQHY006sqGpD/PA5gEmZiYlRlE0jhK31oHQAgAC4dcCAAA2WgIAAADZw
Date:   Thu, 29 Sep 2022 13:26:31 +0000
Message-ID: <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
In-Reply-To: <YzWcI+U1WYJuZIdk@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS1PR04MB9336:EE_
x-ms-office365-filtering-correlation-id: 1c05beec-24e0-4bd1-0a9e-08daa21e394d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /r48Qypf9n3TyFF25HL0WYsUhrf2JgOO9QnifQiOOTJgOMGuLprL+fYaMZ9dKeyokBu597yg5ykxUJOleVvoTMZo/99c+0mVTutiot3Y7l1Gxc+xigB+HCSu+ZknWg3IyXv9ZtR5ssKDg80V+2fd+p7SV8SHytLGi7LlstdKlymGg2wA+ZtOrHANFqmnoyCDZN30k+ZvbNXbSVfSN9D54oy6aqRpfORgfgbFHxUmkI+qvrBE0tCQsNIOw2mSImviLrII37Uj0IgPSRbeWaGanjnTRoDqIYsMonHh8qLXw8kO0Uu/rLf6a1vJPsCLLL5LTYQtRiWJ6AvVqapk9IUjhkSMy22i/GL5BgP8BX2rjBp2iaL7g0D2Bi2mRk8UBsjG0QsAiHomSTogmkQwJyuVp7VLve4ZYkKEhACacH+Eeu4Heov9mbArYcF5UGssAkci2/anJKLXUO4dVA7v1kTbdQ+vxMrXTKqoM1eWNXBt/Muzqb+diK5wRgDoCEZCsjlU0f7QJJbRYfjNQepeklY09SFy09xu6v2F6V2glENkScP1zBsVXxT06UY9ah3vx6q8VN3M8OVu+dkP51vyJLE7a8fPShG2+StQ2eMeQ5cCALKR725uOqXtaSo5zwpuG+Gtj8p9YPnaa6LJm/Y0wJMiGmwophvENhNfaomFWCKUrowRSXgxny5p6o0U6/JXsmxiwxtaElVbOrUlgRcdEtRe7Im1dqOnxSfBtCLnEPZuuUV517L3YlfKGWuqanX7lNF2fuUsKt3+WU6pBsmgKne32Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(451199015)(44832011)(33656002)(26005)(7416002)(5660300002)(66556008)(66476007)(6506007)(41300700001)(66446008)(64756008)(8676002)(4326008)(7696005)(122000001)(55016003)(86362001)(38070700005)(38100700002)(83380400001)(2906002)(186003)(71200400001)(6916009)(54906003)(53546011)(55236004)(9686003)(478600001)(8936002)(52536014)(316002)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aKap9MH5QRDLHIYolexmV0t9V+ry6Pz3EsuPpMzVaA7ga7OrNQeYLDQbXAGP?=
 =?us-ascii?Q?9QQgll+LR/vCfCHg64Qq2z0sbJi5KOYB8snh+5xkBODB67y5GGoMoxJAURwL?=
 =?us-ascii?Q?Ky61ZI8UAW875eFMqR/zuWl/yJzYu1XEYL31dhH+wXkLanerExX4W2Hbc24e?=
 =?us-ascii?Q?KLUdzeXD4iu2QBWtmSiYfJeUjIDtKXGQorgqJyHBUrmpy6jykvOXEozW4VEx?=
 =?us-ascii?Q?da2YoDxuP5xOK4/Wr4LiGw5RKBePP7SIeXG6jYpfUxuPvthUAsg8rsXTfAUi?=
 =?us-ascii?Q?A/fSFRR1f+u45Kvit2wDzdEgy/fkzvaG7hXeiBZEEzAul00JbPIkaLlqVLHB?=
 =?us-ascii?Q?PHU+6kXPa6j6gCDPKdbAHCmAxb/c+K8zqtT4yV/Aopyn95orYBDheYlmGHu6?=
 =?us-ascii?Q?X+bhMrNRc8mVk3lc43IOA3EWMQxh+oyIXAaIqjvWCAbGjxyfZwkAUMuMDzuv?=
 =?us-ascii?Q?baVOqZEpBpsCjq2j17XMug9lXkY/NsnuCb7JFE9jbSITd3SSryyJ0OdfQ6Kk?=
 =?us-ascii?Q?UMO0p2OQeNe2a1wReNKp90U217tjdwq10fKLeMNQkIAY3Vlnr1bRW27paAtE?=
 =?us-ascii?Q?5EzEAAI0KUQMsteq/DS9j3KN7LqE2c3yUmo03k8SVCFdlHEqzNIt3n5PnLBF?=
 =?us-ascii?Q?JhnyWZvkFkmvEUFX9DR8nCdbFad78I1iQMOD5Rqz/dO77s+CnZwTemWlWjPa?=
 =?us-ascii?Q?LS5w8MaQOMNrwX19eRes7r0dO2g9/7jggS3zddg8UOMzkeN+NgrMw7IlF2G2?=
 =?us-ascii?Q?nJ3h3+gcerhf/MlSIhXvKAzTZvO6QkzkewC8IAgMOPo+MQFwcWFjZ6FJTlFA?=
 =?us-ascii?Q?u89QjgRj95d++3VVWaDIbKTvz7T7w8YXHArpbMe2cS9G2kbrDsmeqcRs0wsj?=
 =?us-ascii?Q?5EXGBAoBtI4EEpI03plyFTlSwv6SfK2xkrYZk+QAaUiO2KIxx4JW0shibZ0S?=
 =?us-ascii?Q?eUw9nRxhYctk1hsJejZg3kGnwT9XCKQXcOujvRV6k8+sE4mR249UGWzpeIEm?=
 =?us-ascii?Q?aEjcCRwYSAVjL/2U8aLpjOvuaOT1kdKhH6sR4wtUuJUMO1rfeDByg1xDyagU?=
 =?us-ascii?Q?w3u6UFUgRE3mHDrTZldekWz6+axZlE3ZmnJQu0cnHgfzKVpjdt5bL2uku63A?=
 =?us-ascii?Q?F7wlyy/hWSHbfy0dey1fXw4ZP7DM3I8pcWS6uYU2mL1IHWma4lK520MT90aS?=
 =?us-ascii?Q?6dNRoApRR9mAqV1u1OMrqn4w7t5RcCzoKvO19ncqOGpgWCbtj5W79Uds5rEU?=
 =?us-ascii?Q?VYNJlKc5K5mo7D7lEJjw+t8cZqarUqEvr4RrhT2EC76XL2LrlJY1OGz6v47l?=
 =?us-ascii?Q?/Ih4rZkGTC5fsbKJfbViWNbjjv5ZqoRJsLeOMUXmC94rLhBWbwnS7BIUQoJg?=
 =?us-ascii?Q?BaGuII0agcnhgv0Ysx4IkKWcsmmBrEOfXBWVgXcw3iyEUSgiv3Vhw/vAMcuH?=
 =?us-ascii?Q?ILwDYlIM0NLFowuS3YU6Yad7HaXtJwQVJaFAba5JnBRI2glIPFMbguQH45hb?=
 =?us-ascii?Q?edc+pqYfX5IWem59c9HoT58gUFdqEjLxKkWc/POL03m63Y5x8yDrfFz64xnW?=
 =?us-ascii?Q?WneI94XwBau4JoTd/p1NcWmmdyXu5cM6iBf7gT5B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c05beec-24e0-4bd1-0a9e-08daa21e394d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 13:26:31.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VPtCexkAxyrePqrW4keWKmaz7cgFX+B25TgHuLirQHemU1cJjnwbnT0V1zZiZGvkRmoJLgM7yjb8ImOZmaXdeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9336
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
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, September 29, 2022 8:23 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
>=20
> Caution: EXT Email
>=20
> > I actually did some compare testing regarding the page pool for normal
> > traffic.  So far I don't see significant improvement in the current
> > implementation. The performance for large packets improves a little,
> > and the performance for small packets get a little worse.
>=20
> What hardware was this for? imx51? imx6? imx7 Vybrid? These all use the F=
EC.

I tested on imx8qxp platform. It is ARM64.
=20
>=20
> By small packets, do you mean those under the copybreak limit?
>=20
> Please provide some benchmark numbers with your next patchset.

Yes, the packet size is 64 bytes and it is under the copybreak limit. As th=
e impact is not significant, I would prefer to remove the copybreak logic.

Thanks,
Shenwei

>=20
>        Andrew
