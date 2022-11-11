Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A83625A2D
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 13:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiKKMFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 07:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiKKMFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 07:05:33 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2060.outbound.protection.outlook.com [40.107.247.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1A885443;
        Fri, 11 Nov 2022 04:03:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb+ykLL7N1o/LO9bApUOj/986ln+z9b8i3wkdEpvXvwk3ZdsHPtZnDOR2pCn8ovCwUnSc8kElgwbghrr0v1d6nnBOd4JOe85qYg/DmYoiwsryoVD+ybBEwTm4FEcSxlkqOROU0U6g4MSCrWbaL1CopZUj/zn2dlSR2U9T0fYeyI31sZcWM237ihFEJlz4kNU+z6yBuKBZMLSKLsHV+OQpWkiPWCo0at67sPNvlCn27ovyj8wGtJ2rAi64Cu9wBfaPy1EVWeRnOeIFEXD+hvs/6mBO9qxYu4AwhvnFwk6OhqQeC7IvXn1RpvfgB8/zHnYtRA20bnqKx/t0UazSo7gRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVz6XJGO4BGbgrgabVci8Gw8NjG6YgaRfJ4fFXUlkOo=;
 b=eT6Cl9bkmqfK6KJaC5a1c83JkRr8FK9DZxD4roRIafaZBCwhJIiFU1dhbPg5XQCpg52loMCCfvnBddl03AWyGx4dvg1d7bDj1pVpLTHKApQ19SDLzLYzGoT705avv80MCO1UN35fXbUtuxPZ5TjNP9NaQdJjHxLc1TuC43AmvATF5m1WFbd7ynOycq70LTrBn+obLAGsassSeqv2uMcxqf0o7V8TNParTHGZCdAE0OIYXT1m+yeLave1t7ioEu07ovtP5qwq8RrSSkXPfA7qqYus/qFmY8zGjAQc3Bl8bHw41IX7NXcWyoj/nghsE6IHExgBJEWAyZJ4+aACOKjTvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVz6XJGO4BGbgrgabVci8Gw8NjG6YgaRfJ4fFXUlkOo=;
 b=MYhIozVo8dAFjD9I7TJvwlSAz4qnlNL0iqpiCkm9KHlcFFW9Gwuh4ZVIP3Y3GLsZollzyACWhcJAcJbKptQ2DU2ng2p+WMGkd4R0KHPw6n61Rc1xOvZ5VALx9osGT2srxRwuX99WedLq6dHFYG/uemiwogMJCJyqpf0Upz0hYZs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9309.eurprd04.prod.outlook.com (2603:10a6:20b:4df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Fri, 11 Nov
 2022 12:03:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 12:03:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Roger Quadros <rogerq@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>, "srk@ti.com" <srk@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Thread-Topic: [PATCH] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Thread-Index: AQHY9UOf6d0jOPcLAEibv/K33FIufK45oMoA
Date:   Fri, 11 Nov 2022 12:03:54 +0000
Message-ID: <20221111120350.waumn6x35vwfnrfc@skbuf>
References: <20221108135643.15094-1-rogerq@kernel.org>
 <20221109191941.6af4f71d@kernel.org>
 <32eacc9d-3866-149a-579a-41f8e405123f@kernel.org>
 <20221110123249.5f0e19df@kernel.org>
In-Reply-To: <20221110123249.5f0e19df@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS1PR04MB9309:EE_
x-ms-office365-filtering-correlation-id: 73bd697f-4c03-4d4c-cda9-08dac3dcce5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LPQIa5OjUXM6IAtsh3HgVCoWydjcTAz+5e1ROfmzEQZKGAm3gdCPHCb9Ci6v66mnxzcybfLNcN5fJZ7JcxK+FmQ20TVBD8Bl6yFk5jIHrrtp5KHSrPu803BQgs01YbfbJruySb8/RZSEe3Fc9qVgCA2YyTrWPrgwQEW0cHkPi//mn+V2koL09GdDF6jIvBUXnv+1jLosHs5tf8ideT9mZBd0K40J45DAjdCkSMzhIYvUYnvsfhHIjAHF+I6XG8cNwrkAXcMvuYmEnZcfnr1XEp93e1lXE8hSp7QLqesN+B13PhjOPO6pO7pOHwcwKHxTmTH31Kr24FCggQFDsb8dBbIO0EZhva3MLGQ2TiypFFQA9gGEjH5YFXz46mO2XRB338KkQr1Gi/iCNji+irbh8nUAy4y9rdO+q4m2Ww+Cj14CblBiCnH7pmXey3Jvn7RztlXcl3qS/vtakKjZR6Euzf+wzF/A9R/aor5O2SSHUAYCRja+6Iums5541RM7ydmaq1FxuYBglBlAmiwAbJkWfLez98ADylMFOJlBMK+jA16rzh1IGRBqRehxzmHhBm1XYlATl36O58FP2Kvchhi09ueug6FZzCSMw+BuO2+U+/7UXyXgMlobo53V2BG43PDaEwbSDobowqRkrGeojkDSv36OCnUHS+10vRJhUO71pe9c4pV7q5l2KwqN9e43b+VysSJks+AUJxTYmDCiBDHeriQ9m1D/Wkko90UAf8TaoaVsjJMI2jgBTz50UJ/M8U8E5tTuoanRZDUDMXnovLxx3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199015)(5660300002)(6506007)(6512007)(9686003)(38070700005)(44832011)(7416002)(71200400001)(478600001)(33716001)(8936002)(4744005)(26005)(2906002)(6486002)(38100700002)(316002)(66446008)(64756008)(83380400001)(54906003)(186003)(41300700001)(1076003)(4326008)(8676002)(6916009)(66946007)(122000001)(76116006)(66476007)(66556008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZBtqGqaucKtP6m3C+oGg4521FZ1YjD09Qpil82HXFRj55FPXxi0B9NWljypN?=
 =?us-ascii?Q?H8lVcLzfuXe3nufJJJcMuUTan0HvBZLXp9C2rmEAQ4rCP4nt0xFpn1RH5jSR?=
 =?us-ascii?Q?MZR5PaVVk+2BYBmSjGuSCxIlCH6dmLEpmnlLcdryp3nhMXczT4ehzRbyMM1i?=
 =?us-ascii?Q?NzIC1FtiFU5xosf2KjZMoQb6Chu3JWbje0crP3dXZhG+gzEwLs+jKLsE61Ii?=
 =?us-ascii?Q?+O7Z9eAgApylL5godt0b4xgmjuBCXeJABZSG53O/dU8fgJMRxhgIH5h3gyji?=
 =?us-ascii?Q?GF1KCAok5qxvuC0V11b9CLxDAJmJtlv3puDsSgXHFJdAx2LL7xd85eyeWvey?=
 =?us-ascii?Q?dkUCJ81unUMELKkoAIS6J1aipCT0Ef8N57gmaRz/uxFv31w2B+Bo2/+BXVzv?=
 =?us-ascii?Q?QlsSI8meHBaXuEv53UroQd/rXUPChcPreHrNOBdi4BP+rPe0ujP/DcKdUp7j?=
 =?us-ascii?Q?3viu0SBWyBjGo+VJx5ozZlQrO4wmdmRZOaRCCjMAjtDTTAahEn/Uw111I+PT?=
 =?us-ascii?Q?/BwNOr/eHZgEWSQnLLVjtsupCqnw9X+7iDX7c+EBNw2y6KMpdj7TeuZJJ62J?=
 =?us-ascii?Q?EDUuKt4UkUYC7Y8gef5kAp/uZlDRt4WZzFWsZFQd6R9+U/pMhnbt4C3tQBOj?=
 =?us-ascii?Q?jWQwFyaQikgckUR7jVGw5kfj7f98GKjYpmtN3ZRKPvC80zsCe/O6Xbg6P6ra?=
 =?us-ascii?Q?2a/xcW8RXVr6CJEt/ZVBpLBDsQc+aRpv5p9/tYTCQWT8xQsUATBzF/Mio6MY?=
 =?us-ascii?Q?oJWrjGjH/gV20MeUtBY/w69hWg5mOOYuy+GXgG+dTCa2FZn8RMKQtpL2KWmq?=
 =?us-ascii?Q?jsXYrrQ+EyQIJ6Cio1xgXiStzFS39ZAkrIdGrCFs5IEr4ceJChpLo4KluRFu?=
 =?us-ascii?Q?wuHxyvYRdpjGrf5tCRwNGP/4leMrRiUv5Jh37WIDyYeqH0F8rg+XYTHuqfFr?=
 =?us-ascii?Q?kQvHfSll/zitDAf9mHbvUZrX6nxfrLIYO0pv+RA46g9QWCLt41O2UcEjApcT?=
 =?us-ascii?Q?F1zk300RvKT1zXfdNh2uiTafF6EUlq4AnkC0M3zqpyj2fppe2p/JSlcQzEFV?=
 =?us-ascii?Q?HY2c3birIYxMohEoFnEc5IG9BYWAQ1MaX8RTAljesPjqa9F8fsFCwVNEpNfb?=
 =?us-ascii?Q?txTPCLJOq89bJkb7f6iCbGyKxwyovZu5pHHjnXTvES3X7hg40Kadd2+/2cHI?=
 =?us-ascii?Q?E99OTHXWcHdDBRRVrWTjYkC0v5fW9PV5S8RZuXGBfWWQd7rZmNcTQgSjHRED?=
 =?us-ascii?Q?G4yNZwkrwYIV6MpixgMYmxSWyhaziYe51EVYjmbBmtfqgc3JOy9Wa5qupuwu?=
 =?us-ascii?Q?AUZZ3LxunBArVUcdO9/wvEP0Amzm1UHbdrPzh0h6KcmEgTlHvTZ3vfVYX1cD?=
 =?us-ascii?Q?xraniGEOWeuO/Jx+xX3YMa7DviBIDxdooRIna2zJwIkr1vQprc6LpzQderTh?=
 =?us-ascii?Q?ZgUGQ+JixGfkeLgp40NUpHtA3DCpo1bEnWcHS3eDhGOy7RPgkZbd+wjfrs+q?=
 =?us-ascii?Q?59C5F94/B3zFM/96Vz7ZYChWJXw+/LPUJ2EAOCy4ld0L3zxVXLnwv1JFKQj8?=
 =?us-ascii?Q?N2mp7K2cKIIGn0v4NdmNVgvHpGKcsLDETB+mjMDX4n3/RPb8GbkQAI3LMmAO?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7AD27B94EC8204B81EE43AFD7A894C5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73bd697f-4c03-4d4c-cda9-08dac3dcce5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 12:03:54.8484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D6AOSaNC9TOSbh16GFDzQ2ksc9kQQWnwun3booah0pO5exG4q1OF8c6cEK6W3+AELuYYn39c9EVK3hiCx+dSCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 12:32:49PM -0800, Jakub Kicinski wrote:
> > I have a question here. How should ageable entries be treated in this c=
ase?
>=20
> Ah, no idea :) Let's me add experts to To:

Not a real expert, but if suspend/resume loses the Ethernet link,
I expect that no dynamically learned entries are preserved across
a link loss event.

In DSA for example, we only keep ageable entries in hardware as long as
the port STP state, plus BR_LEARNING port flag, are compatible with
having such FDB entries. Otherwise, any transition to such a state
flushes the ageable FDB entries.

A link loss generates a bridge port transition to the DISABLED state,
which DSA uses to generate a SWITCHDEV_FDB_FLUSH_TO_BRIDGE event.

I'm not sure if it would even be possible to accurately do the right
thing and update the ageing timer of the FDB entries with the amount of
time that the system was suspended.=
