Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40735B90C1
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiINXDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiINXDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:03:40 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2043.outbound.protection.outlook.com [40.107.21.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C8986FF7;
        Wed, 14 Sep 2022 16:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkYEcrfAy0C8mJXY1BB+CDuH7pKJ6h5HhIaRYftWi13SQ4IX4Hxze3l4RUYJIPElI0FNU2oY1pqa6Ujj54ut/GLEXlMG2JQMsPhyXKf0yj2DrSrTtvAKxDK/vX/SsK9g1WotP+fI2gVlKCnBuIRH0SQr9JPNfuSu0iQLc457CoCHeCM6LJJ2O8xMcAtdsdppipI7zQtfwCAhp3ZTnNEt3Kyulyp0xh9a/u8SeT7+4ebAQVeIdW0TS/L+Ort7bLkeFqqluJJX9R1jHzlebelKs+LiVh87G6MaJ1LhVHtbh//R8k7K0kUH/EzFkUeYCI0Vp0rDLlrSRVE8Iheeem9tbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEEnJ6HNmRky2CwyBept2oiRHqNMlkOu+IsEVxObGOE=;
 b=fzP3wIsS/hf3bP4xdUzU4LZvItJvmLNpA3SyJNDoZtBlnSUDTQHH0y/TCqLYIyvgHe/fu+YwIlgYDTHuYCxwax9Zm2P0bBA2w5BQkGHY3ePnVjlea6C1/m7+HTUx/ujVx0TBCWDx9s4a8vGGSiv2MG2a6FRN7Wu3uxUbFB9345YnARoIN5giq8fajo9Wuxx3r2s3ieepqq8WV/kzEemIw0tz8jSz8Fo4v54ZWjvhJl5LfXs+erLhaD0twKig3gOvwe/QfewwqV563sDYGeJi9/CQdJ9vLzlKaugLAWaYQDfT7hebeBeaYq0s2AIfXal86oDK8zf5BJydEHSuElyBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEEnJ6HNmRky2CwyBept2oiRHqNMlkOu+IsEVxObGOE=;
 b=Gg/Bt29HAXag31QrjBeUmbLnKaa3D4eB0bWtJbrLBd9RgWAcc5aTMLCyNTTaOSfKMVd/sJrQuVkjTidrJBWC9sj7QouhBEpZj3ggyTHsgF3/J1eN3NbZNMpmgJbcwrcaCX51iB0nDVEEpce86rnQ1cOs2yzgDuz8UcbNTcgb3H0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9435.eurprd04.prod.outlook.com (2603:10a6:20b:4eb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 23:03:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 23:03:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
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
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Topic: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Index: AQHYyE9ZfT5bo6uCkEmd6s08JFlY763fdU4AgAAHuwCAAA3PgIAAAPiA
Date:   Wed, 14 Sep 2022 23:03:35 +0000
Message-ID: <20220914230335.lioxtjxbjiyd7ds4@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-5-vladimir.oltean@nxp.com> <87k065iqe1.fsf@intel.com>
 <20220914221042.oenxhxacgt2xsb2k@skbuf> <871qsdimtk.fsf@intel.com>
In-Reply-To: <871qsdimtk.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9435:EE_
x-ms-office365-filtering-correlation-id: b7dd0e74-faec-4aa4-cd9c-08da96a55a83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0BVGsLdAZbpqF5qypSri4Jug9S26Qm8icWRM8I4ot5Mg+UqWQBedEkOQLNlV1wEdqznKQNTWfsra3Chuq4weBAB/S8MVVfHSEaXLtjhiZWOIemifWdQWvpc8OsTGCAn3fyop1T5iqv2pPvRsel/IZRhubEZE2lr41LlQFpgY7lQdmGb4YiFoqWBludWLl0jDisGXj4KPtrx3A3CL7jJl/LurZK9ewz8Y+JWWngOyupqJLD5KrCPXY/RIUNAo522golkFCdsGT4K/XHwwY3vqAYJEqA31q8CV82jxQUfqcEvrR7MwciTA0aAEV5NBgZ4Sq9dARvoSQJYlBynVoFxqUZD4g7HiNqiMndtBxQnoGOjK2NLAYYhSo5f8I3KpjTbtLQalP8LbWawnrhlTCyBXxmg32N2X2lRat1fK/qbMxTBSVbohJtt9Bhawey7PdXJ4PS96Nn2jjmHZlJM+Yoyx4OnsRC2pCfm9bFKCGlSt+M2c13h+qTVH+6vX2TJkjygWkud+e0Z/iyGMompYUPlZbvNwjXL3CCJ7XupmggeGabv7Fo6+0l5fqc96WeWKgh/ANE3lAkqYwlRo0mBIutfwA7XpYeGE6K5h42YM58SeRyQtymMoJKcT53gy4udAwrc1iDZ3tJuEHw5MI5JyQcts0h/xRi7cHw/uPhX0BevW6sleBQiq2ZbY3na/7oUoww3o7j8Q4i4dCjBQI0+YzzZZS9jfD5w3wOUKrOv437kRhOWS4kLf66e1CIfwxA0Mmp8+oEfR3OaFTv4RPDVe31H0NqrOWKnGx2NxvIExMVnLGtc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(4744005)(478600001)(5660300002)(8676002)(33716001)(8936002)(66476007)(6486002)(66556008)(76116006)(186003)(26005)(41300700001)(66446008)(6506007)(44832011)(1076003)(64756008)(54906003)(83380400001)(71200400001)(38100700002)(9686003)(38070700005)(7416002)(4326008)(86362001)(2906002)(66946007)(122000001)(966005)(91956017)(316002)(6916009)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?11HsqE4lfR1AWruTUK0d01VWSe+SGRd6ZBVtZ3y+pO0h0TgjVk8+ZUihi0EG?=
 =?us-ascii?Q?d5u20t6SdJzqibA5qOBofIohfBMQWqJqNDracHBShN48Tvwj86eyWKhP0dmw?=
 =?us-ascii?Q?lXXEVYpvcZeG2h5LD5AB9JYGM5skaJJNZsEo+JSrqEaBA46PEVXkjV92koNj?=
 =?us-ascii?Q?hlNbBb76H53KsRC3L6qzKX63Fp8/SwsKGbNLL10rlbMwWn0Q1oTv2Vg4q5dK?=
 =?us-ascii?Q?lxSy4iLZuUDTyuOs0+wukmzqqPXIIwxNpA7DIWtma2rgSRsXDhnMBR5XTmT5?=
 =?us-ascii?Q?c+NGw/fFYGQSdOnlI8UJI91EfppshIYZDc5LCwzqOBRaT4vBae78zG4+fMYp?=
 =?us-ascii?Q?IZJHp0GKeOXxnVGXl41IVZgN2C4u7v07LEQnurr96Wani9eHO6jfBz9HwUmK?=
 =?us-ascii?Q?z1aV5EZ6d48pqtjybAFSY9YJAOhry+7JREHxuZ4F376XMOIwftyAAcmqwMyb?=
 =?us-ascii?Q?9iMAUP799796nyYiIqZb7G2jrSsMpzmStOfAbwm8mVVaToWaKoGGRoBggpHL?=
 =?us-ascii?Q?bwbekVl3ztHMT/HgptAVwrq/borOKis2sHhoZj1OJO4F25WOAaJELz62re99?=
 =?us-ascii?Q?cstqxgP6RTQ6tGRd5ZxknY/dT+Zs5v2c34mRn/v9BdpRI4/qNeU8+jFkYlGR?=
 =?us-ascii?Q?E9k28tOJETSi0q3N+SeShicPx75zq6KmZPaBfP319r4986PSyc+T5BrAsBGC?=
 =?us-ascii?Q?itWWtRapI9VRCnPT3vlgW4hWqG6yiwaduAZ6jsM9n1na9b9qXQkUGKYJw6hW?=
 =?us-ascii?Q?zbjMHT5jwGg8RIcKxnMIR5NUK7HLxujcWjmo6rCgYKT+F2wv78ZSumuwdXuG?=
 =?us-ascii?Q?3e62wanWZyed7uxdcIpmIFQW/dgEGJ8lnOjU06ET9if//CwnSj6m2+e+pX0Q?=
 =?us-ascii?Q?BYhUMwM+MeQVYlI/hbrCv+gIPpy+3PA4Bo3ay3tTw3abiM8vb/k9IZbSn/lg?=
 =?us-ascii?Q?Ty9K7kXGDBJInmIGgmI8+udecr3lsyFw1iI8uObPQiYZxdqKi8ZSzjqCBMvO?=
 =?us-ascii?Q?lfxrNXnp3bf0l20Y+1S6osZAVJ217OAbpUb/yLofwxiTz9qrlrYlwQMit2c1?=
 =?us-ascii?Q?82v9t68WenwhMLoxG3bKmpHrU/0vYCWVB0W9gqoccKqaXn1bySpFOKzLwcml?=
 =?us-ascii?Q?Cf3wQb6OND/ACo9v+r5q4niNzDg4Ea8Qn6bSVwIHzeNMhgnePPK9U6IVJ/Pz?=
 =?us-ascii?Q?zX/QrLvQWv2T3VF2dQYYvH1lXoos5au9GKS2eQhVEmXK57LL6NUjWMrGQwHU?=
 =?us-ascii?Q?FbpOhAABb/2UiKedMqrLBBzgSSxyuim8QTYWqcNsPGdXVB4+U55SOL9LsNWn?=
 =?us-ascii?Q?Po1DZxkJ9OHp8WwKt4UNCPe634+wCXpP+lJPaDaFUGm8pZKVKD5i8ApSwfjc?=
 =?us-ascii?Q?dnsgfYAY9xWl3NBQk5IdHEdZPHPJVf9ys4LCHfHo7y/mz0TCm0amiMfnYW52?=
 =?us-ascii?Q?IhVIOvcEG8JPrgpwO5baHsmZgE6ncbvY8NIhQzfTt+/6JVwFIp1hHTATClhn?=
 =?us-ascii?Q?YZ/Tw3a2dqa8pH3xJq5WL1D32wzT2clQVYuiTSDwkyU5xWbjNl/VT1brgwhw?=
 =?us-ascii?Q?0XxIVC8jhM0Q78nfxWfgxhlwETBscbUQOvjxuzOYjiRAhx8gfbKn26OdX9SL?=
 =?us-ascii?Q?0A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <06BE951E467DC2458BFA512A40152A4D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7dd0e74-faec-4aa4-cd9c-08da96a55a83
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 23:03:35.8547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjmr9zvLP9xAxiXgMf9sEcwg1RSXVwqT+mrow9tP2sFmQ8sN2D4L1fxwk5I2p5BUQPCf2NV17erHs1KJRLqQ3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9435
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 04:00:07PM -0700, Vinicius Costa Gomes wrote:
> Hm, I just noticed something.
>=20
> During parse the user only sets the max-sdu for the traffic classes she
> is interested on. During dump you are showing all of them, the unset
> ones will be shown as zero, that seems a bit confusing, which could mean
> that you would have to add some checks anyway.
>=20
> For the offload side, you could just document that U32_MAX means unset.

Yes, choosing '0' rather than other value, to mean 'default to port MTU'
was intentional. It is also in line with what other places, like the
YANG models, expect to see:
https://github.com/YangModels/yang/blob/main/standard/ieee/draft/802.1/Qcw/=
ieee802-dot1q-sched.yang#L128=
