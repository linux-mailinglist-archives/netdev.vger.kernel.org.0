Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6E6B7A16
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjCMOPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCMOOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:14:54 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A046122A27;
        Mon, 13 Mar 2023 07:14:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDZyZTv6baM0RRyjra9I4VTHHV5iZAGOsG+a0RYvoOvWLNlZbvgB9J5FjqG5rdQbb4hCz3cinja0qAC2fY6D4gL8gewLUGx8ClwNlWaoqxi8Qv9E7aQSzjV3wOlSPOk0fE3LRurjXCptpDcuzIDb+U/JQDwxygWV1JnCiLMYCICmQqFtDpJh/+IJnVtQMRXW+86eVUwsnhuAIO2pgUFc/mHB4377dej+WLa4/6KSb0xWxMg/Zi3CAt0S99mvCR357AVJjS1PZ+SUowbjto7+DrU6jpwgSVBLwppRpFXZLUVqJa4wbd4wmGTcMsHARuJJ//U7yb/s2LnfeCpYpB9+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLSdXiKIPS+b00eRSw5gLuoBRub/Q3juC2oAcjYajpc=;
 b=h0WaTv8TNGA5fdcE7KxjQFkjOwAYGKIwSaIyQ8j2WEwCEHliECZ8nkYVEI70A/2hvu9UrHii2Mlose+XyN8ZQ13ZzliWKRkjKR6AnqTpo0bnbDZGBPUhBC6delFo9aQPs656hDSrnzD+u3E7XuU++5VaC3nEMet6FOE/IFQjQP0kFWy2ex421F/Ov50EUjLtQEYrSsKUb1MZGfovLUeyUE/Cdkbpmxqnd/sJajnsETtb2Liu4+sqzJKz1FmhEdM00NtdvvMgEn1rMc/SmMwmP+GXSR2sC71maLtpljO6SoOrzBqn5QU3FP/A1vT+Axu6KYWPxgeC2Bdfg2qdyemrYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLSdXiKIPS+b00eRSw5gLuoBRub/Q3juC2oAcjYajpc=;
 b=QC+weVCEzdEH6SuU0TVxnI7l9/POpChG6jOR3/wMG16GVuz3LscnualkOIxmiJPMJ02/42r4W8SOlwvVZWcoEh8DKPOkielN8EUb4gHhFs2T1R+OI1bYGtPHBMbUZgSCQqysX9bbT/XHwcQBS9C7lC6lm9Nlj9qmhkLMUXnjroQ=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by GV1PR04MB9117.eurprd04.prod.outlook.com (2603:10a6:150:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:14:36 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:14:36 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v8 1/3] serdev: Add method to assert break signal over tty
 UART port
Thread-Topic: [PATCH v8 1/3] serdev: Add method to assert break signal over
 tty UART port
Thread-Index: AQHZVbYkxiQfQDJFrkKHI7fmrvbkoA==
Date:   Mon, 13 Mar 2023 14:14:36 +0000
Message-ID: <AM9PR04MB86030F36CD0C202F26566B42E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
 <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
 <ZAx1JOvjgOOYCNY9@corigine.com>
 <AM9PR04MB8603EDB41582B5B816993B12E7B89@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ZA4kG1gG2qoEGZLK@corigine.com>
 <AM9PR04MB8603CD84C41775AE83CCDB88E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ZA8RsRtUuCc++wb6@corigine.com>
In-Reply-To: <ZA8RsRtUuCc++wb6@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|GV1PR04MB9117:EE_
x-ms-office365-filtering-correlation-id: 1d7182e5-cb93-4402-97be-08db23cd46da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nannq2IFweK9Q5VYsbUC3X2uL44dveVi7VT0uPLaA7mqQrlDfLVsrhohZuTmfj/AgxbyAH/EQVKA+hurI2ek4ZMKyb3ISIlaXA7MO2Bake88dPgKW6JIiD5sUkGQd5eA/fWuAtiGVgWx3H409R6bZMONFf8NSbApIZ8gLkZgKGp1+pfupZsFh5xZB5rLZQMOQt4GjgBVNwZCoKKVQcjhCwg17mJWdrUzToX/uHfImvPAR3hAIySPNZ7CJeRZzKQ5HLXHUPbpkDf7fcrJ2zw979VjCyOiFJDMdxdGaRb8Y3PVza79R7MqMEltZJj2Lt+V3UUKojM7Yzc8I50Onqsh5z9HjE9Q90EUflJTpSdGgckxgGLwfjcoIOElYSUZrwHiVoyBFtY7bBoSdjYdBGs4ANOUmsC1K+1yEZbAW/DvD1nZ5vdn1s4bet0LOKzzZ7qwAEmI6yEWHOPfeO94TVObgZFL7tMvsdeJZ5AxVJ3DMOEHnQ4IjrSHMqMCd/8GHhmFC1w7gnX8Ha7NQKoXBfTJTKY90VmyTPBK9C/QlBzXis0t++B+zTxBcxQgm1VtdADKYJL9u+IWkjfXmDsijdKsGF3/2lAKtPxNucz+FSuk0C53qwaXJYI2lozzllgLvxRCiHB8X888YY9p19CJWPrZo54eCu88ijqwQb0lzDSLy0clF20n882nVIvQe507eYnC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199018)(45080400002)(7696005)(76116006)(2906002)(71200400001)(41300700001)(8676002)(66446008)(66556008)(64756008)(55016003)(66476007)(33656002)(4326008)(478600001)(316002)(66946007)(54906003)(86362001)(6916009)(122000001)(38100700002)(966005)(38070700005)(5660300002)(55236004)(26005)(6506007)(186003)(9686003)(7416002)(8936002)(52536014)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LGO1ACUaUnpp+vMCHM2OqjbociJChB+vkVpZqaE+1cfRK/pmBiZDdo3Ar4AN?=
 =?us-ascii?Q?p9IpkK5lt4+dOHVRWzds+scammCFGDXB74OgdAKuEc7bFSeOAtsy4SyxOzu9?=
 =?us-ascii?Q?nNgqVLntfkSYfvuXs9lLtHK9V94kbEPV0TGaPJ2HCSEBB73oFuJDEPNqDXQq?=
 =?us-ascii?Q?59A+tRdOwmFeFGMNCi8gWo74/gcbi27rg9s0sJ/5ep7hrm3+U/wzkAi1XpHp?=
 =?us-ascii?Q?LNog3mNAM6n9wPUa+YNuES4O7mT5aGGG4/zucW6wdnfyfpBlaInhjYjVQLKx?=
 =?us-ascii?Q?zY+GCGZkHNzxUovuZraRRl3pUyEso19BPQ0WdI5HH2GoBSlyQxFcGIH1CGAr?=
 =?us-ascii?Q?6IRbm8om2kwlW81YR68xvbVpngRNINlVCh3LHgIzBvPPSj4jlZb/FJwlfKNv?=
 =?us-ascii?Q?Yf11OGoXVj0bX4jbu1tx1P+Mmqo5DVLCwq0taSJtOWKAO4YyhTW1F97voc7q?=
 =?us-ascii?Q?UoZsXhr7hHxxh2r3gYaY/c/ISuqPnG7aLlaF4agMIG36fWHbDbvoFbt5qFcL?=
 =?us-ascii?Q?+QH7XDK2wpVfBhHX4XZcGJFRT5/5cjzo5puX/4tnezCfGCj5fNRE8hY0kM3U?=
 =?us-ascii?Q?s0vpGQZWTuXzFu5nyEv2MekjqVtgDzfyGBXOl7R8C5ci7wIiieSfeTgI85Rg?=
 =?us-ascii?Q?xjpJh8Nv7L9o9mxQmVDm35h939BU+OWmn5Ql04ShKa/3CoxGlQ/p6Z5q9Bng?=
 =?us-ascii?Q?jeR8QYzL4uWpipA3rOsXTG0zztiwOwqOcV+qso4lgUKdg1+G38Af113j52io?=
 =?us-ascii?Q?yJVG/Y/SMjSWSD1yqHMSAkTbZ0Y4MpVRRKFgmyXNhQyPl7kyzzN3j4kP8l7L?=
 =?us-ascii?Q?rmqBDG0oW8xhmtmn3PNGYbTKdv91Itk8O3gD+wAYRwFrrdCCb6O8jeZcU3gi?=
 =?us-ascii?Q?baaug7GaDykXFT96nW6kdSxWXgzYd9sO35xpb6xaYaZCqfKACmTHkNtwjDZ3?=
 =?us-ascii?Q?yHZNC67z1Ar26RuqDofI4lce0EXKcElwuaPhwmhqh0vr8GvRuUiTcLPWKC0M?=
 =?us-ascii?Q?ZUQ+9tA903rRAt9hoGJEbKjNR9UKUvJqA/Sp4m5qONK4ul7qtr4LSgA2zQBS?=
 =?us-ascii?Q?K+uI89XZYqfNEiyZ92HYBHbaS3eOgtLlkFebQnimht1iKuNJjwF3aeGC4Txz?=
 =?us-ascii?Q?1HFElELSVbYYmCrxP7CGt6ux+BoNwZkIf+4cmT6LeYa/hQ1kH57+eOtO0Qpf?=
 =?us-ascii?Q?BRHf47FVNK1XZS0anusjrc/O+ADDw1KHeo1MRcLvchcsjvahx44FF1Aj9sBa?=
 =?us-ascii?Q?gEKkhjvykj2NRX+1hMqKh61/8b+puD7SXS4BTEtthKw+LroOppxJZphV+xtF?=
 =?us-ascii?Q?8NgLeQIJcy4yTOgj9QsLRmurtd50AiLA4vfv1LGIFGlGcmNYe+IVvyLU8QU+?=
 =?us-ascii?Q?WowbChPWUwv6lx7I1Nq/y5swAvrQlLKyp5zt3x5K+sgwAonwB2Vifojr4Tax?=
 =?us-ascii?Q?g2x3Fbwy1bi22tdfdY3quAlUAck6k4T1g243vOKwS2pxmQ+4reN/r62G9qLb?=
 =?us-ascii?Q?AKhY579YrO0IuPAe9jqDWxua6mBjQnpzOrZwlsaSYWt9kXvEYAmxNZue3Pm9?=
 =?us-ascii?Q?UBrcE5UFsWnQUw8WjJE407L5/+GlgrmrnROF4ld7DIP6m4SrQFZrb2c9M4SN?=
 =?us-ascii?Q?lQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7182e5-cb93-4402-97be-08db23cd46da
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 14:14:36.6430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LgCjtOZiUSAnTriWEcXIE1gqZuXbPaFFxphZfSK2djkv8ZvVlA6kB6CT2jaLXTwJ2Fp/EfyQclrgpO/zJ5fAOvZkeZultKFW6RYVez72sK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9117
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

> > > > > > diff --git a/include/linux/serdev.h b/include/linux/serdev.h
> > > > > > index
> > > > > > 66f624fc618c..c065ef1c82f1 100644
> > > > > > --- a/include/linux/serdev.h
> > > > > > +++ b/include/linux/serdev.h
> > > > >
> > > > > ...
> > > > >
> > > > > > @@ -255,6 +257,10 @@ static inline int
> > > > > > serdev_device_set_tiocm(struct serdev_device *serdev, int set, =
 {
> > > > > >       return -ENOTSUPP;
> > > > > >  }
> > > > > > +static inline int serdev_device_break_ctl(struct
> > > > > > +serdev_device *serdev, int break_state) {
> > > > > > +     return -EOPNOTSUPP;
> > > > >
> > > > > Is the use of -EOPNOTSUPP intentional here?
> > > > > I see -ENOTSUPP is used elsewhere in this file.
> > > > I was suggested to use - EOPNOTSUPP instead of - ENOTSUPP by the
> > > > check
> > > patch scripts and by Leon Romanovsky.
> > > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
F
> > > >
> patc%2F&data=3D05%7C01%7Cneeraj.sanjaykale%40nxp.com%7Cd6011072c88
> 94
> > > >
> b141a3008db23bb5bc0%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0
> %7C6
> > > >
> 38143059832335354%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> DAiLCJQ
> > > >
> IjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata
> =3Dk
> > > >
> gk6w%2Fn2d3rNx%2FXe1rLfN0U%2BeTBJTxztSRUEUW2Noqk%3D&reserved=3D
> 0
> > > >
> > >
> hwork.kernel.org%2Fproject%2Fbluetooth%2Fpatch%2F20230130180504.202
> > > 944
> > > > 0-2-
> > >
> neeraj.sanjaykale%40nxp.com%2F&data=3D05%7C01%7Cneeraj.sanjaykale%40
> > > >
> > >
> nxp.com%7Cf2ae2c9ad3c243df2c1a08db232dc0f1%7C686ea1d3bc2b4c6fa92
> > > cd99c5
> > > >
> > >
> c301635%7C0%7C0%7C638142451647332825%7CUnknown%7CTWFpbGZsb3
> > > d8eyJWIjoiM
> > > >
> > >
> C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> > > %7C%7C
> > > > %7C&sdata=3D6cF0gipe4kkwYI6txo0vs8vnmF8azCO6gxQ%2F6Tdyd%2Fw%
> 3D
> > > &reserved=3D
> > > > 0
> > > >
> > > > ENOTSUPP is not a standard error code and should be avoided in new
> > > patches.
> > > > See:
> > > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
F
> > > >
> lore%2F&data=3D05%7C01%7Cneeraj.sanjaykale%40nxp.com%7Cd6011072c88
> 94
> > > >
> b141a3008db23bb5bc0%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0
> %7C6
> > > >
> 38143059832335354%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> DAiLCJQ
> > > >
> IjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata
> =3D9
> > > >
> wojVR7aEgzoeajvy%2FMAkSqAYGBkxrJZtyxlvIpeZ%2Bw%3D&reserved=3D0
> > > > .kernel.org%2Fnetdev%2F20200510182252.GA411829%40lunn.ch%2F&
> data
> > > =3D05%7C
> > > >
> > >
> 01%7Cneeraj.sanjaykale%40nxp.com%7Cf2ae2c9ad3c243df2c1a08db232dc0f
> > > 1%7C
> > > >
> > >
> 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638142451647332825%
> > > 7CUnknow
> > > >
> > >
> n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
> > > WwiLC
> > > >
> > >
> JXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3DwFgYY6VnZ8BBn6Wme8%2BYj
> > > aJRy98qyPnUy
> > > > XC8iCFCv5k%3D&reserved=3D0
> > >
> > > Thanks.
> > >
> > > I agree that EOPNOTSUPP is preferable.
> > > But my question is if we chose to use it in this case, even if it is
> > > inconsistent with similar code in the same file/API.
> > > If so, then I have no objections.
> >
> > No, it was just to satisfy the check patch error and Leon's comment. Th=
e
> driver is happy to check if the serdev returned success or not, and simpl=
y
> print the error code during driver debug.
> > Do you think this should be reverted to ENOTSUPP to maintain consistenc=
y?
>=20
> My _opinion_, is that first prize would be converting existing instances =
of
> ENOTSUPP in this file to EOPNOTSUPP. And then use EOPNOTSUPP going
> forward. And that second prize would be for your patch to use ENOTSUPP.
> Because I think there is a value consistency.
>=20
> But I do see why you have done things the way you have.
> And I don't necessarily think it is wrong.

When you put it that way, how can I say no to a first prize! :D
I have replaced all instances of ENOTSUPP with EOPNOTSUPP in these 2 files =
after making sure none of the functions returning it has a check for ENOTSU=
PP.
It seems most of the instances do not check for a return value anyways.
Please check v9 patch for the changes.

Thanks
Neeraj
