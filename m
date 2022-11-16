Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA9F62C565
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiKPQvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238758AbiKPQuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:50:50 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20060.outbound.protection.outlook.com [40.107.2.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D683C6CE;
        Wed, 16 Nov 2022 08:49:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5fAAui++sIyQzjIvN/k0d5FHY0+k/+4DYnlZAtpEOdTQPWWknAdKbhNQrY/22sGf1nQEQgF1LGTKeE/HpcdR+QRT7EpIHDhfM7pfRBai+fL5JhrNVPmcPeXax49k2PyyLwlaTB/LRLVlItm6WsyjBinpepDXio1tdd5gQ7EGluFhebHlMjuLAGhlBXlWksEdQVNVLIhb4PN199v8HtHjv8BTJH62CfvwLA+A0Tr+mZxIspE5jXsU7VVLP6rBn7lAgES5QabIaj68JDFvpKyoolk2hLoObbT7S993zqHV2kbFTLFDqJzbhQ1yYhK8503rEocTEkdHIl5vc1ysCbKXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwtJvxA4W5SzrGY14tzJLcTSw97zPXkfrRYDcnQMUgI=;
 b=b4V21W9fUb2Cku2FeIbJRWcNecF/k1gYzcztVzzYhGYCrIL3dt+g4gtZrQRyBi97kK/itTUlvJyG9JAjqhbHA5pJFUbQoXhHFVMgGSTSQFuftem62tyAUZG7pypwnkwoQdlg7oinVli+s+jefvw3YuqMuwckpKbeAzUMu0huuhoXDnAAbTyA+K89OGDWQqUJiRtrHP4Xd/42pviddkoJzNoK4GfklCGGscY4SiLD1eR83KqEpAoMxyRjC3Tg+5rtcyeDYrn3DkfZUEkXjD5cvC/emga12m9y3q/XmNb+KQjqJlDTx5VydcC8duz6PqJeDENZgSV2YX+oKQOMfzEUJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwtJvxA4W5SzrGY14tzJLcTSw97zPXkfrRYDcnQMUgI=;
 b=EzGPJo9z0hW2hKfQdUK4xW2Cb2L65I958yQGrZYj6rRWpWPBPp2Jo2UapmnvApwVJQSEXgVUnR/ZVaaxDXcwtJJs+wz6vBBZRVZ/x3QfQaZ8YBqGQU8u1SCJCb3NvSCtda2DMZczPOGMvgutxHeIkF5ZnRWjhyEMGeRAtwOqafs=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS1PR04MB9504.eurprd04.prod.outlook.com (2603:10a6:20b:4d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 16:49:40 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 16:49:39 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v5 0/3] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v5 0/3] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY+TPW3WuHII9tiUKIB6LsAho+865Bw7qAgAAAjFA=
Date:   Wed, 16 Nov 2022 16:49:39 +0000
Message-ID: <PAXPR04MB9185939C06726FC6531ECD6189079@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221115204951.370217-1-shenwei.wang@nxp.com>
 <20221116084709.6b7eeaea@kernel.org>
In-Reply-To: <20221116084709.6b7eeaea@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS1PR04MB9504:EE_
x-ms-office365-filtering-correlation-id: ca28a9aa-4d1a-4c5e-541d-08dac7f28da2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J+89ijI1Imj1ge3BVYgenT48o8qXkLXo/FlB8AXNFvxzUjKAzig6HFOYx1HAIxwaJ6z6qfxurbsvCalhJG4bl7lKeVkSFSxuLjVbJMyRcNf84PamFB9tNnF4yPV8r/NUP40vha2L1IzAaN4wxI2/kYN+HZMZ5Z8RHLnwiWm6I66v8LXxAk7p5Pi2lyOo8JAt6euCHVoLbyjgBuD7PEUXTlLGJeePkPJnPLhFpjRGz6XmeNZjnhDs6yxhCLhsilbthNx0fuvCT6KitfymavisU+f8tGkGuBXNFlfwp/bxCy6UEqIS5E0d/ei0I41EhwGTIoDvclRG4yNo8DANMO7ugSv/isfAcXKjte98m0hRRk/8Ov19klJayjdsfrhU03Fi54zTT/+VwaxvB+5moDQYtOLhTJXBZa7IQiUSpHktW4TrwYkUu1Lp/KygI2SFoq814v5vpTKG6Hjf6WMP2i9UFTbkFWnGP/6tip8VoTC5mIoWQmcU2Gdoj/qYkIdF7x+YOi4Men//7iy6p/1LHvcsXprCoaX/DcQJSdDND0imJRpGkbEBvTnZDAkLqYEN+3xjzGB3UhGD3raNtR5MLg/X39ScZ1TUvleQxlXN5shE6kaR6JolJChfgy0VAtY3vfO2JPj2D/QFN7iO7zzvNiMa1gycoNWRTxoZiBIlltqxJGifqe4j+62nk6Esdra11zeLnHJn1PEK7mK1DpMnnf2GPjLrLiG2QpFJkRQk+IaBDARp6QF0EN8rUoDStdAMi0rxt3mvaU3jFIqFsMunGadsAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(5660300002)(316002)(7416002)(66476007)(54906003)(66446008)(186003)(8676002)(52536014)(66946007)(64756008)(66556008)(76116006)(4326008)(122000001)(6916009)(83380400001)(38100700002)(38070700005)(8936002)(44832011)(41300700001)(55016003)(86362001)(33656002)(2906002)(7696005)(9686003)(478600001)(26005)(71200400001)(6506007)(53546011)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zeV/zHRELAI6Mk2WY98P9uBZ3dzK9ZuZBdCQk/KUG6mt/VdVI/lPSMLdJ4d1?=
 =?us-ascii?Q?0ERc4fSmgPLHIwo3icJBsnRieLgLT3dA9fR9Waz1eR298hFQ2UVhv+KY11EJ?=
 =?us-ascii?Q?D2EcAg/F6UMKmFOTriWLOegXv96KVzZ3Uab5PdLjKNw2UGJUxEfeibEql8u2?=
 =?us-ascii?Q?+6FMOIwzNrrF1jLz3Tf/75TeqdCaeK2Jni64Q1tfAoX90qg/TcDEzK01ZbID?=
 =?us-ascii?Q?COjaKt3Q49tvqgC60PzuPg9s8sOQQMF+Pq+mYWK5rKWM/ayOp7Xbqwlqq/AD?=
 =?us-ascii?Q?HJF3qm7rsj0Ytnfa+pCQNV+LbLMbZ17evK2Jlc4VvcdOnpOV1iDn7/BzP4l6?=
 =?us-ascii?Q?27kqk/UN7V/9HwXgSHvdwthuR766HagLzBQ2Ca97HQN6/dTV37wTt9KkNsai?=
 =?us-ascii?Q?FVLeeBuubW8M0YvqeG+WGgsFI6jARyXEc6pvf73mur4fbpneNkHLGV0Ou+68?=
 =?us-ascii?Q?as9z6/e/sddDOZz5+SIgNCxFJwljWagaOn+7qnGMVXmO8ufA+zPB7ZuGKg6R?=
 =?us-ascii?Q?7Jo5EL6uB3B1nf43k8mvLvX89SDi4i/LVqkO3Cr6GRarBQUh+NCiwpFdFFRW?=
 =?us-ascii?Q?Vhmg/bAZz6fgLKrmuvuklRFipM2fV0aZMu3sSZOu1BJbvr9Leya1LYUXUnf2?=
 =?us-ascii?Q?6Iy4IQJjPjnodheyHc9AT0r7n6aw7G8TO9ibu+tOs7zlZ3FfgRMOKC42uOoF?=
 =?us-ascii?Q?BW+cVQUGEx34bYd916XbqYCmoZPE3co+zBHJG78kcPrJRj1MWR83QTBT+cN1?=
 =?us-ascii?Q?IeNBYwam0T525Zu4wVB4j2HgF+oWpB954EPWUkyfJLQovkPJlzeABsuZdxcU?=
 =?us-ascii?Q?HRPqhh4kgfGlT6GEQ3NpWOvj/ZMfcUlNrvPqwP1msQ0KmPS/V8cgiroJrbRQ?=
 =?us-ascii?Q?66Z3b8a17+GtzBMuCL7P1gHDKM0hNOHxeKKPi3FQ2IxqppbxyFWvTEYLs/M6?=
 =?us-ascii?Q?finQoFFZxpq3Y+jT0ZAp6XD2tPHZH28TmUSd2JEpwkJZSZeCvWyCnSSlcoa5?=
 =?us-ascii?Q?3RlthweV9X4lnkE16YsC+Vk27JORUAUHF+vX9ppHomwse5PE8XzVAwOR0rxk?=
 =?us-ascii?Q?LK72y/VFG2BWI+/Rf7UgX5bBGknmDe2uhOOkTppUNmTzQhX1rYZZjhRgvaDk?=
 =?us-ascii?Q?/7OSr02Ya7Fl8FxIw3svDtK2XoaUexz/NXVA1gzAIgvIST23F2Cr2ZC0RctR?=
 =?us-ascii?Q?hgo/civDwDCFsTp3DyHNuJ/iIVenU8kueDAxv6KwSY/cPn5leoZcezFSpVRe?=
 =?us-ascii?Q?5iad+lc/TR0jq1R2zYO4GBPUMqim38rZFB+SpRLQOVBOtlkH3cVvBo6tFg+r?=
 =?us-ascii?Q?qQQsFrj/cquGCa+9wb1l2HFeHFf66kWdbdbX7lwTYo3ifEnTfzKy2KpgKAo0?=
 =?us-ascii?Q?H5xcn1mnsH3fvlrH5WFTfFllepy8za/6f6y4atOKcYA920lCDiFCg+dfl8oh?=
 =?us-ascii?Q?9CPfUkuISbP9wLmd+Y6G/QpKlBlkj2ZynZTy7mPlg5DPihGT2V5hGTSOPDea?=
 =?us-ascii?Q?xTc9Fj4dDdt/YjBB9sMCKwaryTUTDV7CfqGDSNRvneQ2jk73p290KR4IFRRX?=
 =?us-ascii?Q?L6Br8piiOUSzquX6S1YGv+fYVOEs42J0J3wmE6iD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca28a9aa-4d1a-4c5e-541d-08dac7f28da2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 16:49:39.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XFLKejKcy7FmLObPIicwjV23+LpwSnhHsJ1ZUXLwcHFs+mJ7RIYr1TSVadX5xg8KhCrIK0IWYvuezbhgVn5gdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9504
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 16, 2022 10:47 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; Jesper
> Dangaard Brouer <hawk@kernel.org>; Ilias Apalodimas
> <ilias.apalodimas@linaro.org>; Alexei Starovoitov <ast@kernel.org>; Danie=
l
> Borkmann <daniel@iogearbox.net>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v5 0/3] net: fec: add xdp and page pool statist=
ics
>=20
> Caution: EXT Email
>=20
> On Tue, 15 Nov 2022 14:49:48 -0600 Shenwei Wang wrote:
> > Changes in V5:
> >  - split the patch into two: one for xdp statistics and one for page
> >    pool
> >  - fix the bug to zero xdp_stats array
> >  - use empty 'page_pool_stats' when CONFIG_PAGE_POOL_STATS is disabled.
>=20
> Hi, IIUC there was a previous revision of this set which got applied too =
hastily.
> Unfortunately that means you need to rebase on top of what's already appl=
ied,
> or add a revert to your series. Otherwise the patches won't apply cleanly=
.

I will do a rebase.

Thanks,
Shenwei
