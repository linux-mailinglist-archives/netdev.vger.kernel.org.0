Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B42862A0B9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiKORwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKORwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:52:41 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2043.outbound.protection.outlook.com [40.107.22.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A983E12;
        Tue, 15 Nov 2022 09:52:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SplvX8WVQnsbrOKeR+PPUNAm2L3iIywjtplpOKCkWASiPF6UNPcFfsNRhirwCGCkjnKxbbbH4s/tb/DpDNnIbpOwOgYc3SbYaq2rARRc3bnTlkXeNdsTf9ip+Vk1U1q9xa9OEORjJhgAbocvUgafrRvgjTQVI+N3OmztrJYairArUOx3jioph38aqWloePeXFgD5n4oG3sshF7mJcO5V75bEgtRnQtHBvU9nO4fdqJjagp6CYPDGSrNh3PRT034GSTkIaktb9fhuUbgFtaDWWtVAVGOFLAY4RbBhR7ahGlOw5FhqgKVSLgKEVYzszqHPoflHKrayGBKOQHtBHnGqTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJ5Md0ZQD6unN+QEnNDEBHgf51AwbQGImrnNowZQCoQ=;
 b=HTQ1dGmTgnwbwQGGjmFzl55j22h2yoYqozt1hQMMJ3PrnHM/nEJXOEsvWZtE4LgvxAQeWaHdz/77Ephg7ByKSMc+Z8PB86fI3ZKNFevYmOIYmtlnq/5yIVlC3drhh76smwV4I1W495mR6G+VIIJT4G5lyloUdftgxt+azhOy2nfTNRtxqd8QibIgct+PTmnwZYzjfIkoEnjNA9sFcJMuA5fMsZYX8Sbvtp4V7to4PaSMtLmn5jLEupHVLtoOcC7xgI48nxQcJYl1RzxYQuV+6m7pfyXIkXMt47zbre+asz7BIfuMe8zZ+1JK95zHwdufTD94Q/clgpxFwkVj3G0o/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJ5Md0ZQD6unN+QEnNDEBHgf51AwbQGImrnNowZQCoQ=;
 b=aa+oNyiS0/c/SmBfMwBsoPvQ3YGQDZvlPkfDfn+KgjFeLS+Ll6mUNY0RyGj8SAC1TA/owIcmYrVd6zhmndJ8DUKRIBWoKF+OCcyyZ/pLBI8o8UwDDfByAIlMvP/bRNLCTnGUVHCBx/dbMf65zN/wOCmmimghOZIITmMvQ47xXAE=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8588.eurprd04.prod.outlook.com (2603:10a6:20b:43b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 17:52:20 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 17:52:20 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats
 definition
Thread-Topic: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats
 definition
Thread-Index: AQHY+QsTb4VRDCZRLEmyB3vYgHUBZq5AOKsAgAAA6vCAAAfDgIAAAjNg
Date:   Tue, 15 Nov 2022 17:52:20 +0000
Message-ID: <PAXPR04MB9185330823A685659C53AA6D89049@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
 <20221115155744.193789-2-shenwei.wang@nxp.com> <Y3PIYg+VsuBxq5cW@lunn.ch>
 <PAXPR04MB9185EEE74B09159C18C0FBDD89049@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y3PPqVK1p+9vso8T@lunn.ch>
In-Reply-To: <Y3PPqVK1p+9vso8T@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM9PR04MB8588:EE_
x-ms-office365-filtering-correlation-id: f1136cc3-fe79-4513-2a9d-08dac73224f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hNDoSPsW+5FtBJwNr3PwooYru9fR0UZCT70fBm0jwU2X5H1/TRACppeD4+758hwJzEghC59cRtDEK7O0C6nG4r3yR3FDcw9gAxNPqFNZQ6/C/rnd2wjRsnITQkwQci37bi69UBsY3w3m7S5G7DaOe5Fi4aOXRWC1NZLF0VFqjauLW0vfiKGhW94zWFpAn7c/T5+ZKWji5DthvJYw2B4E7mITWtTfBMEhD1SvFu5kDDazgPF8zIiY3RaPCLeTXXMYXtA/OAub6Uliflnod6iAAaMVRXlie8vlq7i0s82m7hN2nqBzcfVgjEhwkr1bCLaget8LjqMREJkukdXce5D3SoOr8kecC/6OpAracjatuAKRkE1SBgAkYEYAug9fsFO9cLNuhBZ9hhY6NJyLLOjuyYQbkIsEiZbT7mQ0frbKF8s617p8vXE4ePhuWav8kyoXGIvA6Qn7HezKGRuydZxzehMc9sALWUFFKja7Qp3/IOBM6BoC174TEo+SYwGJpLuDZIJSEOFlspfOJnafqkGgGZPnqe/zDauNZvhLFpnL7/96+ewYRPEs5U2/0Opz1uUJ3xgKEy0AHKFECal5Q1sPfT9Op0p2h8HfFIdIZCIfpgfwHFYENOOctw4mLWvDyy+doEHhNAI1tiyzZAGBtEI8+brx9YaAfpvo/TLJCuQ/zemoZlZgM35n6t5BGzOXhUDTuux4VpIYqg9RWq6ZAEX7ilYyYWf7BtyMHMa0Z8V6VkntunTeizIIbXIvzhkHHzAirCWEUynvla9OymDQhPtYZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(38070700005)(52536014)(8936002)(478600001)(66899015)(55236004)(33656002)(316002)(6506007)(2906002)(6916009)(54906003)(55016003)(83380400001)(71200400001)(122000001)(41300700001)(86362001)(38100700002)(66476007)(4326008)(186003)(66556008)(5660300002)(26005)(66946007)(64756008)(66446008)(8676002)(9686003)(7416002)(76116006)(53546011)(7696005)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xSHO+UoThaNyXRau801AbemCQGSDDtHr7GVE0js4sJ4Y6lP2Jc+JOnWfKns1?=
 =?us-ascii?Q?xrhpnrg4hXsZEeQaurMKZaz+8ECWKPX6qbUjarGvnNpnD3YkuMzYQ3gqCIwP?=
 =?us-ascii?Q?Xo3X8Vic/tU0Dm85lvAoggYVCBMp2c2cEAb2eZwmOhWuBtbSd6wvdMHp8CzO?=
 =?us-ascii?Q?MiZsANHzJvIUuYlMuVn/g7xEU2k3cnXVpPdRPn4HbVjBTCfrZHKUAmZ2Xjd1?=
 =?us-ascii?Q?tweK5zIme1CpWXGGzzxSsCUM5CbDMppvMgCUlAitKKt0rQ/+rYJynFprlQL4?=
 =?us-ascii?Q?MD1rg1tJTotuIqkj199k/JlVvxA1KMkCeffAm9viniHIV5Pk84f555o18rEE?=
 =?us-ascii?Q?vprQ8HUUQla7ZtL0jwmrQIKsiy/Qu33K/f7Am9ren2ojIPMHEYYKmXLSa4zz?=
 =?us-ascii?Q?tCwhRrIkuBUAL/XuNxgZTKt3Ra47LuWbox1vYvV6EW/Y5F2CPDq55gxrL4lX?=
 =?us-ascii?Q?Ch+qJTGXIfCZsa3e5MjyEi1b/ydZymAJEUqQsPzbsJntm2xeLZaeWrv9QCCv?=
 =?us-ascii?Q?6Jp7p+5Lh2nzlbTXPhzEZx7SIdafk8YFmRrXV3U0iTMLnRd8uqnpVd8FOpL3?=
 =?us-ascii?Q?6HsNy+lBAs1s5WzubgjIcV1BQIlSibrjqlhBPYS9jhJgUjGqGugN3d5Tk8PO?=
 =?us-ascii?Q?Dry2395kzUe+mEAe1HIx/KbS1tYCRgt+ry1m6zzQ9usNWm/PWiEM9GJYZAyy?=
 =?us-ascii?Q?4Fp/gp7diEKesEEq1JnYKb/B4XEiNBEuNC6JODFD+aJwYGqWQE4HIvxtHEM7?=
 =?us-ascii?Q?0IRIc6iBT+sRBdg9JtpDp/hd2YWJEBok0RrFV/DTRctMD4X+6saD9UtoaRct?=
 =?us-ascii?Q?VdPJXESCPFCEYkS8ibAYeYraGq786ll8lL0JQmcsVrfAIEwJ0RLmqRHbvz9z?=
 =?us-ascii?Q?ynp2CZ/0Mx1VoJxAnMbJ/VzRFdgmnSIV9WOWhQOGhEcVa1FjoMoAD9NtctAR?=
 =?us-ascii?Q?N23TN2nQhzuDxKWi+YolAJfhIQ6rgbWzL9ywEDakdvwpuFsnkcD2zQyRAIlm?=
 =?us-ascii?Q?RQV2ckEtub+gHLPtQMPlsEhg00fub5bh7k/4on1umqlDyrG6DmKxLfTPSL7P?=
 =?us-ascii?Q?l9o7/Qc7pMX6xp83Rraw7OyT5vvnnzGhJIJAAqrDz+xpQyqtmLFV989rj8oR?=
 =?us-ascii?Q?OLntm6A7+KAAXafcx7upQb5AjHRtZ7tmyYltFLBc5V7F4NZdZMu8trZ85Bqq?=
 =?us-ascii?Q?5Ll/MoLo4KXB+nZAKOpKFUESyxvMT7qJGb71Wy7j/228SWzAvJPEPsdDRRhG?=
 =?us-ascii?Q?xJQiXociNsHwozGVViLXfGGzOT1fpCRRi4wgJFCTETiBRm71zQ3ifRsaHy2x?=
 =?us-ascii?Q?YTq6XkJWF+oaaqB/jTDWRO/jHXpYKcbgf4TxcWiTMcWXU3DEVCJABOaq0O/Z?=
 =?us-ascii?Q?nwL5c40D4UM4C585G/o3kF5KTkjef8IDvV6svuc5ZBAyHkVfXHlb8D30oQCb?=
 =?us-ascii?Q?eFk4WdSc5I6GBpPq7PZZRN2Y5zCuJZBFi1+2C+PzGkEQKrVTbvyTOumeaf1Z?=
 =?us-ascii?Q?sVmk4IwRArCr3ndM/gRoXd/dc+JENJNX9sSvYKwcU5mE+cvIxZfB0lwSkmhp?=
 =?us-ascii?Q?HN21UDHK4DFKB+mu+kXplrfm6BOvgXcKaSutCUYQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1136cc3-fe79-4513-2a9d-08dac73224f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 17:52:20.8282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDeC2s6KMdxO1ABYa7+Ub6NkCh/WpSxdeUQ4qdJlYRtSINYIm49MPPoN4bLcTCdRADn2pkkVTIhy/U7pSMfpCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8588
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
> Sent: Tuesday, November 15, 2022 11:43 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Jesper Dangaard Brouer <hawk@kernel.org>; Ilias
> Apalodimas <ilias.apalodimas@linaro.org>; Alexei Starovoitov
> <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_st=
ats
> definition
>=20
> Caution: EXT Email
>=20
> > > I agree the API is broken, but i think there is a better fix.
> > >
> > > There should be a stub of page_pool_get_stats() for when
> > > CONFIG_PAGE_POOL_STATS is disabled.
> > >
> > > Nothing actually dereferences struct page_pool_stats when you have th=
is
> stub.
> > > So it might be enough to simply have
> > >
> > > struct page_pool_stats{
> > > };
> > >
> >
> > As the structure is open when the CONFIG_PAGE_POOL_STATS is enabled,
> > you can not prevent a user to access its members. The empty stub will
> > still have problems in this kind of situations.
>=20
> The users, i.e. the driver, has no need to access its members. The member=
s can
> change, new ones can be added, and it will not cause a problem, given the=
 way
> this API is defined. Ideally, page_pool_stats would of been an opaque coo=
kie,
> but that is not how it was implemented :-(
>=20

Okay if the assumption is the user would never access its members.

Regards,
Shenwei

>             Andrew
