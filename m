Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9255BB457
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIPWQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiIPWQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:16:21 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60083.outbound.protection.outlook.com [40.107.6.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6062AB82;
        Fri, 16 Sep 2022 15:16:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQpYszoSHmnH8Y92mTbjjWBsR3gsoavS5aHsEC96O7H4TT4dZA+1pEtV4aRsbf6lPNaFIIRXQAzrJJ2lrsvsoqPjz13otjg83gjJtx7vjAZDm5pIdmSrfRXUaE8yoGBA0I51rZ93007xfk6VQZCqtYdOUYL/Au9vnHeN83lCAN/N/Q8c+o2/eTgJ9Mhrg4xS61A8tVfxy22rP/Mbo0OwjEhP7bU+LPNBxK5pA8rSh3uaXqNGgMlS5o6a8xY0WvFiaBRm0le3MfJ4RLbBE3Xtl9GVdqn2bJy5oiIWK4BAkmgLIs8J6T6qpORjFUTpwjUtdhryjPHcgcnRYrA0wv944A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpv/eEG7Zcx3Z3t9gZ0uHkQAl5D1ovchUzGmTYo+wt8=;
 b=Ssdjd1UiRwprVeamms4JYwjO7FnYAnoLxhiU9nyM5G8SLKHVvh0/emATb9kyW9RNvCkmJseLj2Y6sqAUaF3iOs20qJvxQrhjtfmYSSj+8afLVCe5ADj0qquJYeLnpbOgcYg0F8V3Pnxv7uM/MZMP/V8Q9IuDIfBLYAPwVTl5WoY2qWQy7oE6PEofpCj8Fqnn2QEgn7Sbd8RwKpZkkszGtp/ZnEw8geSbyaltkgc//ozOywjbx/6tHEOziVVlNj7SCQkmVfCORpqJZ7hAdKiUY7xtaoHoSOs3MupWRRKIhGvtRTrpzC+1l6Rkb06/clQZHKr/NNmIVSkLztIWwOtvXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpv/eEG7Zcx3Z3t9gZ0uHkQAl5D1ovchUzGmTYo+wt8=;
 b=RzGdgQjY7WT6q/LCJH2X262VTbF4CM0VmqSjDog2DxaU2gvv6kVesULgN/HVLWvdJF7R+82VTzgNO80LOVfyivDOjueRkS/O28ij4MZYKw/PLd2PB8duQn3Dl92qHF7p771gxI91tYEj06/Qm0RDoBlqWnKYt2k7H7HhFXfRjFA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8624.eurprd04.prod.outlook.com (2603:10a6:102:21b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Fri, 16 Sep
 2022 22:16:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 22:16:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc
 max SDU
Thread-Topic: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc
 max SDU
Thread-Index: AQHYyE9kpcxLYCJ3dk68mHHPDBjrxq3g2nSAgAE9jQCAAGN8AIAAJ8OA
Date:   Fri, 16 Sep 2022 22:16:16 +0000
Message-ID: <20220916221615.k33pn7zdsixcz4mz@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-11-vladimir.oltean@nxp.com>
 <ecf497e3-8934-1046-818e-4ee5dc5889eb@engleder-embedded.com>
 <20220916135752.abmpagmyjt4gnolk@skbuf>
 <7f09367e-2236-692c-4adf-cb262ff1c109@engleder-embedded.com>
In-Reply-To: <7f09367e-2236-692c-4adf-cb262ff1c109@engleder-embedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8624:EE_
x-ms-office365-filtering-correlation-id: 53bb0052-2b5e-4afc-42f0-08da98311318
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fQ5qHYEaKugYsRTFjjD8SOc0KW6FUzHK+N01gdgUWkMr6Ve6ZX34Y79+597rE7ErFK2lmstj9RO6Q+CHDU1LGl/3Nb9rn/YJov40Njbwxp1tG/I3i2qsjnXLwvd07eCZQi8oKDVhxa1XnMYUzxZmkQN+0YJaeG6HjsM/ENLgXiG+0Bo3SEDGTg2H5HRjaGzFFqJkpOYklPSdC9MI0NBIRfHZveX4vvT4rJUUF/XIKXM5LFlbIbhw0x6uxkdbOm3tLnoW4d6rgmltoa2ZPO/XmAA+jTAt9VEikxNN32r+YSu7UIxY+7wq7uDigGdQW2SqccX0yzSOGpNV8UPJgTq9wDJGJzy5D0kO0uRsmDWfwtIrkpNP7SjtsRzJzfj290NOcPmVCXCSKUdd/ytPWdoaOnZFyFOitmljbg9TAvjeRcjLVoKmCS6zJf24nii3oyy/VxBHFZAEOAWl6uIf9XJvKqgnI4JEQLpRD/RF56GZO5/RGNWXN3uhxdLksVv3qvfuaxTyzmgh2eGWBlWBjgl2Xc/QMl+y7+/Ot3HTI0lSp+Sjbl8y7qF5A631hMweZf4zUePZtsS/slmmu2m5fc4pawm1E2t9AoPTjgVKtVEU4MOfoi35k/yVnzGG/snOkJlo6tJ5Bj4+DVA2tE8jvLsfFFaRl2+b3VUxEwNHfBr+K4CV+QNoUBhFtHl3ts8dmXrvg0z8Ti0WDITVx0VINWWkegFbZlOByzHpr1RNmWJ3wwizGZMKeHDwVrjqHl3Abwg1L3fr/UoXJRTYKDuVqqYPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199015)(186003)(1076003)(4744005)(44832011)(38100700002)(26005)(8936002)(6512007)(9686003)(5660300002)(66446008)(76116006)(66946007)(64756008)(8676002)(4326008)(41300700001)(66476007)(91956017)(66556008)(86362001)(122000001)(7416002)(33716001)(38070700005)(2906002)(6486002)(71200400001)(6506007)(478600001)(54906003)(6916009)(316002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FoK5lHWQsKV3VW2ai1ReTGN5M+nrOh/iUZxbAzYtIZik55cyql0KF+EBe/Op?=
 =?us-ascii?Q?mFaKMIdSqI3Ymw40FHO5RkRKeuA8XqvGtuyF3UmI0WIUe8RPzlREJQMPhseE?=
 =?us-ascii?Q?ukMlNOBp/AeBxDINit/JUne+cQhfR9cx6aX3xzDHuckllsEYPBSHnooOlByc?=
 =?us-ascii?Q?GBdRSZTpdLP9BWFOYOtNKNj+SvXdt3fzI5VzUUIbyubvzsnET4ooMXfAcfNS?=
 =?us-ascii?Q?FEhALgiNm6yLqkd6Pv9KHIHPYBPkgQ4MjzAO+ILlu+Wm++ojHsWr+wZjx4LQ?=
 =?us-ascii?Q?hYkKeI44gYBG86ig4bH5Py6XuDJUjYEBlxQG9yfCk2oZQGvPNiheaqUHYshJ?=
 =?us-ascii?Q?YcDvRRL+gh2VcsJq/+ONDIPWbnK3rMSb0QsOBKdNPh/N5Te+aPNQMnNaz/yO?=
 =?us-ascii?Q?bk21hw1I/lByvi7KYH3Nbo8rAup5eCK/6i4+r0cFOur1ldxQoOZnwrboz0ed?=
 =?us-ascii?Q?h1Ofh/QzxtGyZZtxxAwlpogcUJiIn7uaJWMNMb46cNUOUWE9aOos/XPWeKgs?=
 =?us-ascii?Q?wadkcKWz0h/xk5me39Ga982Mn7m1iEdtSBOdzG0d0k5TAfE0tYoUckV9TL9p?=
 =?us-ascii?Q?WQ0XI+CWMswaJzMWwVfCUG04h+7LwUDToUtufdSf3sGBBzpnFvTcXD8o4Dvc?=
 =?us-ascii?Q?5LwgyAWus4cIecZ3arC8WiPZD9+SoKymjtACm14EhV7+8kxJWtF+gGMCvvnX?=
 =?us-ascii?Q?bBS5PpubqcQLWCowKE9ZUMDCNKxupojt7lTEW1AOHwbyJXdXjFf23oz1HXPF?=
 =?us-ascii?Q?FonUg9WB3dZNQHFlnINFnx0sGmmgZnYzbKnbTALmvdhaCYxW5rlp+cVUt0Bz?=
 =?us-ascii?Q?Fza2kMJ9tDRqhMbvXTxcWk61XpTKLTc7K0H2j0toVlMnOA+U3P9QuxUmgvPs?=
 =?us-ascii?Q?yzrEdy0pcVxkSZz5NdzB7HtHVcgyQbuKI9INxdsvKQFgkxAES0EN+ZXGLQ6t?=
 =?us-ascii?Q?dsrze98EsvSkwAskTbGlVwsAsBDI8tXlOEg4HU6h59e+I16AhcwdvLyHr1ZP?=
 =?us-ascii?Q?L4D8VV4Ie5glimnPDFwy4TFB05dMtMt9a2viYALqWOGL8BQ6axWZ5scEFODa?=
 =?us-ascii?Q?CSQ50RnXDRR3h0tZeV/TKpmkWq7tBk5UpUjK65Ro1ubH6oc1SzB567nl6lLX?=
 =?us-ascii?Q?QAsQjluc/dmlWdotllp0ySIiUf5Lhl5F+OQWfCjw0HRwbBYKfaE6Fv9UeBvA?=
 =?us-ascii?Q?hyIvqZupvpQx1XzhNMY5696Qwag7PE2fIXbd/I5WFFFmiuUVWoBITzXMlvUN?=
 =?us-ascii?Q?cvzbvxD05cYm3Mo/sYF2u1ug71nZ3WSM0+JkgODlQUXIwP/dqcOnJ5+5QPTm?=
 =?us-ascii?Q?rveIZc8BoRs448KPI/t61R6w5Rh9ZxVLKz2kwk7lXj3b2GlO1+ZEbkGk9dtc?=
 =?us-ascii?Q?+BP1aeR7EGZuxUDpZ0Z0qdWr+Cpx95L0cVtY7Jj8IT8gF5lNFB9arRl2IpZz?=
 =?us-ascii?Q?PzIvew/EAw2myDIQcpa0wRRDE8Y5c8H8jUy6twHvCbygA26J9UYN9tAGIpol?=
 =?us-ascii?Q?i65WF9wglTn0ij52jayUheCXX3PobxJCk6JBqIcGO57ysHjaPJJCq6LuvbO9?=
 =?us-ascii?Q?zibKwkUq4TD8FLW/UUX59RUqIxMh7+AvGbLKm25G5lPYJn1S6ixzXUOyNgPM?=
 =?us-ascii?Q?yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <098727EF00782F43AE38B5EBA76BE447@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53bb0052-2b5e-4afc-42f0-08da98311318
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 22:16:16.6898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4ktNJi7RTROvG8ilp7hYVKJ1mSdMDhT25MaDthx63bbMcNxK5sGAD/18lvruZiB1UtjVLQ0jeQeFij7bcI/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8624
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 09:53:56PM +0200, Gerhard Engleder wrote:
> Ok, denying max_sdu makes sense. It can be used to prevent too large
> frames for a traffic class by discarding them.
>=20
> In my opinion for MACs a software implementation would make sense even
> in full offload mode, because it would prevent copying frames from RAM
> to MAC which are discarded anyway. But that should be decided driver
> specific.
>=20
> Thanks for your explanations!

Depending on how your hardware architecture looks like, discarding the
oversized frames in the driver might or might not be possible. If you
have for example queues exposed to user space, you're at user space's
mercy. Since for example enetc can have virtual station interfaces
(essentially a set of queues with a way to reach them, by MAC address)
exported using vfio-pci to a guest OS running arbitrary software,
dropping them in the physical port MAC is pretty much the only way you
can ensure you meet your latency target.=
