Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344D956AE58
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiGGWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiGGWZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:25:23 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCB461D77;
        Thu,  7 Jul 2022 15:25:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfeNtPv+4mFQdNAJPXs7tipPfjCUiF6zYuLMSyKoADWRXmgPnUmtj0HvSlig82hau3QE/4iHm+z2pVbYNEH15902OXCbJQJ7VGrKqaifU6J85Uc0M2hZddk0nVMVnD3FsTjiFKn1Cn1OC/uXjiNvov9Q0iGlySx2uiYBvxeIWhkMEge1mtE8wdCgD9wFzCz0RN9mS7Ii/RlNIBq0k63SkFJnsD+TFhPP935udJv71wd91LzgKYbMCnZqxWVgg+5FsSMYlqrC+bialbg4ronwDfsWhXM8I/W7/reJ9RAsYYrYBpgZA7V1cY6zQ6/l6jUwz7zEs0BdSWfH9xtS5OZONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6knciJHb+nbKJS0MKfWTbbhKCui61woVwt//KcNl7eI=;
 b=j5vNuBUNWDz2AVS8N0mAjf9lnKFi+4WEL0wtycQhJId+lQIYDN60nVqdztf6aFhlxxRfSozaFKIj5dS+wwyn6GcuTaqGO2Ro9mV2x6m0CBuhlJqbv31ed7Te0Sf0yZjOtRaJejcFAgsNe3xNvFljFrieY3YLrPD7XiaIfMksDbl0+a2bgjvD3l4REaMbxQLK4bxL/kHtDNIElWdhn4IZPYCTIVToSLkqtznrfPubhwgxC5Z24cq9KIPeWUKs9pSYkKNjVRzcVAxB/kpaFsaSQytXKQqp43MyEE4Y6c/xtpc8QIwFdYTWFjSEZ1h08fkPWTHYhUI9MYApV1biyZN+GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6knciJHb+nbKJS0MKfWTbbhKCui61woVwt//KcNl7eI=;
 b=JwHAxbUr1bKziihYpYLBv8ZEuCFH6D9V9bA49Pp1o0ZjwJJgA+DgXNAI0yDhaC/csWQ8EmXsUKtG57Dyn1wojOuHBtUss85bVm8FxBl1TLluV26SGbBQj/j9RV7qztEK8T+hvXOA/aEIxFHJIjRf2/e3Kac8ez5W9rYZXFz11oA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8390.eurprd04.prod.outlook.com (2603:10a6:102:1c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 7 Jul
 2022 22:25:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 22:25:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [PATCH 0/2] selftests: forwarding: Install two missing tests
Thread-Topic: [PATCH 0/2] selftests: forwarding: Install two missing tests
Thread-Index: AQHYkglGod/4OBSADUyoR9bNezs0w61zfM6A
Date:   Thu, 7 Jul 2022 22:25:19 +0000
Message-ID: <20220707222519.movgavbpbptncuu6@skbuf>
References: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ce79f9b-050c-49f1-7da1-08da60679394
x-ms-traffictypediagnostic: PAXPR04MB8390:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BQ+Ta2P+j4tohd1+Q2xe8wDX89orCOU3s69lB1IkO2q5BiS1MnLBVzHvBCY0K+ekwUPzShboJmipuNFufo/bxlEOHNOmq+29azgQe7ZoPVgT7W3eBfi1crU7JAWQ5b7KZ49KmoUfDrdYQRl+gCUXNPOPL/2zRA4wcvFowVWIIQS8y5VTAM6Vl/Qks1ryTONuLc+REEGEujpDPcAhfebxnCcuIOlda4sZzH+WCtmVM4DQFyxehTBEAFM44ns5/9ObSnS3OJhlhQQAWxJ8pfIrnmFGyvxBFEWREE2ldNTJM4SCsq5VOhRAfRO+VkK7XR0EsYeY8U1S25R4RhfI/h1qq2do6A/fFcDskQmxv0C+zWFqRqd2AYupOQg3hBfYh5z8G94sNckuTRCDEVmmM3pBQ2CUcrmN70RYzmpTvxOTo44S8hZF2F0LWHnMiPUyVpN83Eb+DYD+kT14i4JlMMCyS2r43QtOn584j3iuSiYqft//5AC7bOKydXVZ5SdFSooJpfYb/Zex2J3TTV48TLvtKMAhzt/pPt+fTtw6s+JS8R7fSlCBk9tWLk4wjRmALd2tjnCl4SOWEi4oJZoHGF/lqMGKXdVV/Oersj7EufmEtAL95R6uoP753QcFK9PNMdLRqeul33DOxE6M7fpmIFSmV+YNg34mob23L8xQVsCRLe+MHUL23Oz81C7U52emVymC3q9IlbxV4a/1bExqTUqsegVvYaDMKTT5on6RJWofF/2BxYMDV0gK8zkcvyUF7osEYAG8VFyAy/0vI5wap10By7ZY7thuqOkT9XCP6uA1iW1UROFUOaWyvpFkIJZ7/Rxy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(91956017)(186003)(33716001)(1076003)(71200400001)(5660300002)(66556008)(66446008)(66946007)(76116006)(66476007)(64756008)(44832011)(6506007)(6512007)(9686003)(8936002)(478600001)(41300700001)(26005)(6486002)(122000001)(38070700005)(86362001)(316002)(8676002)(4326008)(38100700002)(6916009)(2906002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tH/o0VqMOdTUg2Z+bvH0QPiRgmS+xMgM0XatjY9mlJalursZ/dHv0Zn/hDrG?=
 =?us-ascii?Q?WsfEB62Kw4zap9ntDrd80sze1EnO/yHifLm6Dmgd4fzChohzHrFBQLDVzQy9?=
 =?us-ascii?Q?OuQ7VnPqzYUT1AGu/3jye+f5I/pFTpR1kWSSFC1qOBBv/mzPstdyz0i/qinD?=
 =?us-ascii?Q?6n3ZzZM8CqyQE4p4LdKqXAj4OXXjUimAbaR787/swZC5Bez7zoQB86Sx9JZv?=
 =?us-ascii?Q?oEn2bGaV402VxSG4JqskaMCytBnrLY86M+Po/s6x91jf13bqXifmMHSeH5y5?=
 =?us-ascii?Q?PEK5EgdDqfPKoBlx9Be7EgTr9vVdueLruos2hsnoGNAAhY54J7ysOpqhFzLt?=
 =?us-ascii?Q?0Shzp1bt1h5pNlwhH1MUeyb28bcJRtJ56qGGNmOJLxtqCaPgZTUWsoQPpLu2?=
 =?us-ascii?Q?ZEZ5v/NbOhg9coLmeyFcALjwBDG/g1IbqUbvWjA/an82VSu6jCq4HBAL8Aj/?=
 =?us-ascii?Q?R+4AbM/OpA3Vb6Ax3/J0QUHjpJbf3r9yCd2a93ara+wDS46FZv5NZPRIIXCi?=
 =?us-ascii?Q?YUR//Hp5LMZULFRZnUvCb2648h9oT6CFPrXeue4zDyoyIbVF5fsMSC3hFLPI?=
 =?us-ascii?Q?HwkkU8Hc21MmuoTKtkOlN7U4qzEReHe1U3SV3Gc8swtag6lcFEdNnux94RyN?=
 =?us-ascii?Q?Cg6IJrWQPpUEkBDHq7hiyZbIuV/0i1cGNT5IEsmMvlvSxqrp6LhsEJ4mQPto?=
 =?us-ascii?Q?Ed0veK3psfowSmZ18UNP60tXjUISUxmaaBWk9cDIQ7zXWG/atbJ0zodAwh6y?=
 =?us-ascii?Q?uXxCNU7a1XsOsoub7gSbB4D4QMj7c0NyH/rkGSJtEKVQ7iIDivfBFgR1NbW1?=
 =?us-ascii?Q?UQ522xP4nmRCc+UOOVVQUTzhI/qD8o1hNr1DdCgBcuhFVPrltfu8HO7EHVce?=
 =?us-ascii?Q?mdq18LWSsEDRj4RfLci7//i9nbXsVodebcyEcqGs3jz27fC1EFTRv5twizLf?=
 =?us-ascii?Q?GKykcIySrkwEbZUNJii+kTDWu5Il63vDsNw4u7N9KLvJSj5Ea6runDy+phPx?=
 =?us-ascii?Q?jIWa5GjgpIq3J7W6NS+uD8HoJ+X3LrpOLZoRa4GTrVYh6J6x6IyZ+xgMgDzG?=
 =?us-ascii?Q?fLIWoY+MAKQKJmpO48olFvbFw7Z3dxHAPKfTV8Z/RnDEe3B7nppJhttfzwPi?=
 =?us-ascii?Q?rZw8SzvWSy2mu2UWB0HuqWOLHSa3QgiHUPu1qn1D+fWYRpTURLB2VcIzLcVT?=
 =?us-ascii?Q?7BMu1eeu1H0pbC1PuD+G0CXl6yeis/ltm5jMULpV/HrITF9wa6z+yuZsbD2F?=
 =?us-ascii?Q?h1xxeJBUFSRj6q/OV7gEXFGOYyDgLjNGgLMUPQUDsrC2Yd9w/44BBwwMAwZR?=
 =?us-ascii?Q?icv7j5ibWfXD2RTnL5aJAedlblZXRym8p/09LQQJ1WwKYBcF0NzLHPrGXbPB?=
 =?us-ascii?Q?WXa4rZ5NQq8fI5TZDNmWsDZXuXtvx+RBK/jO6ZGBCo8rw0tWQRdMl5dB7QGG?=
 =?us-ascii?Q?5Q/k7r8BEWLXIwHZ3zS263nnlA5mgpZj0SxhdByRDj7/mvMInZ6J1EMFI173?=
 =?us-ascii?Q?psWP1JxAZiJ33YA/Vcfb0W2B/Mj/enVhDnv4gFxsgPV6+irq/7ClJNr9kSKJ?=
 =?us-ascii?Q?41NSsxKmnuduVO/5TzQCLK4etYIgJcWiyARX/gU7QMIJCu2VQHO0cJ6tBUdh?=
 =?us-ascii?Q?Qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D5D682C0E6F7D43989A29F36680B33D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce79f9b-050c-49f1-7da1-08da60679394
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 22:25:19.9601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uLlSJOAOVgiapTTsfqqrC33pLjsGSX5bpT9JmyYMTIBZ4ii3oqgSuenrC44uTjcLdWZNr6BP2W+vJQ2J155lFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8390
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Thu, Jul 07, 2022 at 03:55:30PM +0200, Martin Blumenstingl wrote:
> For some distributions (e.g. OpenWrt) we don't want to rely on rsync
> to copy the tests to the target as some extra dependencies need to be
> installed. The Makefile in tools/testing/selftests/net/forwarding
> already installs most of the tests.
>=20
> This series adds the two missing tests to the list of installed tests.
> That way a downstream distribution can build a package using this
> Makefile (and add dependencies there as needed).

Just for future reference, the netdev process is to mark patch sets such
as this one with "PATCH net" since they fix a packaging problem with an
rc kernel. There's more information about this in
Documentation/process/maintainer-netdev.rst.

Do we need to create a Makefile for the selftests symlinked by DSA in
tools/testing/selftests/drivers/net/dsa/, for the symlinks to be
installed, or how do you see this?

The reason why I created the symlinks was to make use of the custom
forwarding.config provided there, and also to reduce the clutter a bit
and only focus on the selftests I felt were relevant for DSA for now.=
