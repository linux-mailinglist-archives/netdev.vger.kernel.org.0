Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8AC568206
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 10:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiGFIpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 04:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiGFIpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 04:45:30 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6D613DEC;
        Wed,  6 Jul 2022 01:45:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMuAaOOCltg+qLs2SOgeN6Ng5pm5ISWpgZ037tjOtGb4rZdf1jIUdJiHUgRbs0mOkR+aQK6DV4yP6eqXMi982hHWJbc1bVEX4519JaGfTHQ8z4bFOg/SRSeELzg9s7yhpaXRJsNI0w76bfN6SE2C7uvg9NeRsdArwGTPTyKE9dRZqDJ/uYReiiVNDe/izXTKSqnaUsB9c+0Tu5PrNGHgmwWEKXT2qrNbXu7u5uobF26aGROUUgIJvoURYFUcRVmMWDojikJ7A/fODQ9ZBwro0T0XTgzowyKJRllgRSPbc+5KR5LIEaoCXalS3fILr2lZjMUvv5iMvxArG2Tn9V4vdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3e8WMq0Nycym2JMaknNxUTc3bzd9+MlLJiosSM+kfI=;
 b=Gjsvt7XzpFsqvfeU7xnDKTAkQyDgnH7mISq1JcpjgadPZTDwOY+C7Si7ZLe0JsYUDEYOTxwV7xnPBLvD9/mC+R/z4+wHiroOlFwPzJbVe4FNjIcp/es+UsSMKoOUYXAO1G1zXM8HIpR/8iWb4uGNs/CIcVEXjcxmw0FhmlqCgsjFM8WkCbbxx88g+4k8qc/XmT/QCczzem4q64QwPPKJAuCG9tvJ8gqNM9RJdldFMIktWjGnqZVu+zic0KCAjofwadDmOfb5NlnRAhgs3dZiXsYAJQ8OMvlwt1kYoHyPYsJ8ZeDSPghpqY25p3VMlByUnlLKkQ/DONKxpj6LIIaZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3e8WMq0Nycym2JMaknNxUTc3bzd9+MlLJiosSM+kfI=;
 b=Su0Mhbul20IZjq/EnzR7Kpz5ZLUZFU5mLVDuYRR8OuHRKpMscSJRZH/T9ULwzTz2moccQzv0Wbx9qFWAOc3a0fIcaRRS0gmBR0PmJcoq14qRk1x2zO6F4wOdfR+WLIrO8E33m+3LFnLn/da2487aMTHs92fkvlDdt+TMKqLGXOU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3668.eurprd04.prod.outlook.com (2603:10a6:208:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Wed, 6 Jul
 2022 08:45:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 08:45:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 5/7] net: lan966x: Add lag support for
 lan966x.
Thread-Topic: [PATCH net-next v3 5/7] net: lan966x: Add lag support for
 lan966x.
Thread-Index: AQHYjYwcNm8cypwpn0eaifU5TXdZ+61wIciAgADsmIA=
Date:   Wed, 6 Jul 2022 08:45:26 +0000
Message-ID: <20220706084525.qesqhlnnmodugj66@skbuf>
References: <20220701205227.1337160-6-horatiu.vultur@microchip.com>
 <202207060247.0TIpleTV-lkp@intel.com>
In-Reply-To: <202207060247.0TIpleTV-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22c7d6d6-651c-4dff-f105-08da5f2bdf96
x-ms-traffictypediagnostic: AM0PR0402MB3668:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2QHSAxJTdy2Loeg7Oa9d2PShIbtU6Pgei4rlrjOTeNn0nsJDjTMYOdLPbbpugPE+tzf03b6kpuqEuAdaExJb0+3gXjXrmhFW5vHNxFGLIfr+flSL7X6WcXRfL0nzq+fOREh2qW+kc7Rv4nhjLRyluUdwPfx27le7Ju+K4IOAQd9ElE9SY2vY0wMUcLnp0Z8g6Ld6YPFs3hhEbqEw08SCFn5Vgoim1uecv7gjkJ9jZ2m2sMv45prBXGF/m5BchCmOFZr75rsx66qaDCdr9ZswH4gx6u5ArQ9sMdXINc/5h1HZZe67etuSzWCQ/IfBG26Ug6l66q8sGITEwwCUR+bTNyhUeSlWEVSMKEBXiwNwuNzanyMHxIX4+zyu1P8BgNJZEta8WjR8/DiJw5tqTW1jymVCULqui5rrFUwuHWkOH0x2hOCuKUDEJf7/Yt0lm6mHc7ukDOjkZCkCfh1xPdkZkPhRLQem//raIEUPljw4hCwToLxAIbexFgQd1HEz0Zt+2tuYubu1cux6dJyYoKT9lEi+SWQT85kEZDNJYofc+aycxiyLdizsXGxR4xz3nSRIR2blAUwXnBzPd3gr/PPEz/tPoVLZozaEzXLFb8QjHoummK4zW8rMKNX0CB9gfjpM4G86MWfJzDeRhoCKhiO6Gf5k/JaBbmZDy0th6quOjgHZUCwHvrp7jxjX9lmyS63Uphqqktn8zEKd1E4etEU86fcbmlXU/k2wuHJHroJznopElng9fw4Uvmud8EAUcZarKHqMb3iwqwArewNRkbRSQkhOoycbQ8ZuX6kflGQ+0aZ75e7BAaWr5WAG9CYZNGRh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(376002)(396003)(346002)(136003)(39860400002)(6486002)(86362001)(38100700002)(76116006)(38070700005)(122000001)(41300700001)(9686003)(186003)(71200400001)(6512007)(26005)(478600001)(1076003)(6506007)(33716001)(66556008)(6916009)(54906003)(8936002)(4326008)(91956017)(8676002)(5660300002)(64756008)(7416002)(44832011)(2906002)(66446008)(66476007)(4744005)(316002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TKocMyd2YzfVJJ5UaAVY3PPVOWCkSy2yev2pLJm7lpMFpJLMtiUf2sbHLN1q?=
 =?us-ascii?Q?WikSTJv7+u5rJQV3pWBa1t8TmB9e4bElPrFXJSLAegPKTNNq2rPwVr+1uUDU?=
 =?us-ascii?Q?lAZhrVBMwwagNYAApKjzxRdDtim3kGqbt5BgWhe2KwNb8B3JkcGTUrhSUD8a?=
 =?us-ascii?Q?GOm7IWgH34CAnhx7EYB1qqFVRWu6xbnS0gJ+Z8Wsnoj37TQURPO6YS5tFVTY?=
 =?us-ascii?Q?Df0I8P1tQ3AReRKMNV9YiKd+tMDXnWIEQbiueusR7Lm19zPKa2N7CygBjtqq?=
 =?us-ascii?Q?n7DuwMewJGlwy4TlvMp8uM+hh8COrHA/Ownaxu7PD7IVQRpYFBorEw1O8E9i?=
 =?us-ascii?Q?znSF+fpMvhmxBs8QtiKZMub35qWTrJuxE+C6nHWCjc3ORiHMHbfwYd2gFmoD?=
 =?us-ascii?Q?ICTLKT6gFYYCteaxxmFTYiKfFJMRypk3qnD5nr3zb1FfgPVePijqj9WIghih?=
 =?us-ascii?Q?q6D53qQdD27hg+gT4Z6siui/65fzik8vYCyYeUHPQYRcJQTAMswdhtraLBSu?=
 =?us-ascii?Q?X5k2Ro8bY6pUmBE4Uz3lUhiq/x0mTPFa7FVe6RKLviz+gi7X59os3jtn9wOi?=
 =?us-ascii?Q?UQQUbQIZQCR6LbZ80W/vaX6I3+R+pX7MFiU5mBNpHAKCru1M2Xi2x5SPAayz?=
 =?us-ascii?Q?op8So1IW6we2VMjFJHkFnG53vFTwHvgAuUd8fwhsGtLtYkRo6rL+yY9onTZx?=
 =?us-ascii?Q?MlL5YJ7r1Rzp3Njvrm77IPjOJgpcTstl6KySK64f96ZSQFIkJhRi11MHeF9I?=
 =?us-ascii?Q?LltZcBFZVaDSSw5r+SUYhK0qLGOVmdNCJmFIRhalRWg5hJMsE49kXlxwoyVN?=
 =?us-ascii?Q?UP8dncGZklK0P8N0guNcmG9Nlr1Ade3aRlhuw+WyDi4PDXbJDtH57BwENDvR?=
 =?us-ascii?Q?uRAHh5OifD3Yc/HJfei47F9mkoBNiPvh6v7d27TxGCjelEDW67bpSns4VrL5?=
 =?us-ascii?Q?fJXqWSNOVSbBB9k2lnBXWGh/4cQBe03eHEDC0BJMgUXdheHb+ayk9QqPbRt3?=
 =?us-ascii?Q?CBHFpwitYW/tOjhGqdeWXV464pxjb65X9u/6vMxuVxAZuA1EsZvZ+btvWFVt?=
 =?us-ascii?Q?uWg7z2jot5mPG0F9+6i2kjP7/g/DNtfIRG64uEVTeQJMq/PZgIW+3p+QpLmZ?=
 =?us-ascii?Q?qfjJqGVBSVzJvjBuXyxVPrlbWSveDQT1L6UJDLLfIXFlFaQMHw99kb+lq8PW?=
 =?us-ascii?Q?+luGevWkkQcLisw/K8C2Ew6f0ioq8+IlobUIqYNIs+qRoRspeVMjEA7YxIGq?=
 =?us-ascii?Q?hyDp2vhBvjbfO607qkKIM3P9I9grM077evEZSXatqZ+yd540PMzA+WP7KLue?=
 =?us-ascii?Q?nbOqeF3pzqjtAWcHzk3wLyVKRvv7z6R93lscLBmZZG3nQmeWoF4sTiYA/2j2?=
 =?us-ascii?Q?kBm5N01k0K/fvZRt5RsYs0JgwjeDdq2FAZUsp0Af6ri3lqTjfB8MM6lUs3xj?=
 =?us-ascii?Q?J2IB4V3gmiiWoxpI8D//b2sFkFU63Y1MVQP9PhzlYVrqvN25lB8Ss10OAl+J?=
 =?us-ascii?Q?JQ8o0OFy0/v5NKZ62euejsMFkNAk8roKcCRgrz7YJuzAwhTms9U3BWAfwkxC?=
 =?us-ascii?Q?G879BhYLE9xI8zgHeKRobOsCVvkeR8oNBJKaayoHFICy2TSUy8g0lRk/8euq?=
 =?us-ascii?Q?sA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B2EE660833B6541811B8B54E8067138@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c7d6d6-651c-4dff-f105-08da5f2bdf96
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 08:45:26.5633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PWgeAnSECRbtpvsAWoEmtC3C/jL0Gq8uDyWTtMw4655QABQB4v4wLdQyXkvC10zZiw8vUIH8htEec8NTs+Cl0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 02:38:37AM +0800, kernel test robot wrote:
>  > 138		lan966x_port_stp_state_set(port, br_port_get_stp_state(brport_dev=
));

When you call a symbol exported by the bridge driver (in this case
br_port_get_stp_state) you need to enforce the fact that you should be
built as module when the bridge is a module.

	depends on BRIDGE || BRIDGE=3Dn=
