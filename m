Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E21B4B6F40
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbiBOOmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:42:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238812AbiBOOmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:42:18 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150040.outbound.protection.outlook.com [40.107.15.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AF51029DF;
        Tue, 15 Feb 2022 06:42:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gS9ply+3UbfgZfM7jRhRHllt6NezI9sVVq0WG1iyhTLTfUJl9JM14e5uwfLB1V5TnlXroSeIxJNl00Y76+RFWf0QjvBBNssDhkazCEyHDmSKkPR2yL70KXoplp9B3MFxcL0a18YR7yVj9jvK//5HJl5jY7XjP8g59ZqoFHQ+ToGp0+6czHDyOUEGLk/udI1qXP14kdKOkSaFpimEoIY+W3mhKqFUJJTlNXze/4O/MHgxWp1cNGlrCITEGUIF12ggPsD1DMuvMc0qrCoH9htJmxJCZacFv9eCtir+CWgn4yA9Y63Wu9ObLC7/bAlup+kboK/ZdKniPymLawradu/oxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCpHgLTiotAUKrR8Sz9WR3ApKv2zFJFOCG77YXhc2Sk=;
 b=miy8+j6qr7g7gkkdZRs01JpJFOfSSLKySPIYLz9DaSd/Kz2/cwk8zC56Z3i4yc+HMslfpHiBVff16dv1D03P7LrClFDHYlIAu7z7tm3AW66MiIDsJw5+Cg8+1vByiAp+KCbJR1SK6BGLjBzFEiIN1a5jNdJDE1MSDIC8ls+MrqfGU7CMcbk66HT1KAELWEpiR5OZcy6QbXq6Tl1WLGCg7OFcayILpmgol7OydBzaQisgBRJwbc3A7/vYQ3eQN2XH2mAE+WBZ9K7rJLr08J0XjainWQGSdFXYnEIGnNRlCiSG1g4MiOHfbIkNednSFz/nOZir/4LKNg06u/5bj9HlWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCpHgLTiotAUKrR8Sz9WR3ApKv2zFJFOCG77YXhc2Sk=;
 b=l53AgbepiixGXEQm7szRA9PrncAiKX2kmHTegY492G+i/bFNcndF7EntKPATOEUSlVt9zf4ZyFrux73Zw/mzMtDyjAfu+OQGSQsny190a9ZRPxjRIJW228Ki3QWj2VEFqQMBLlqdzs95tCh0B4yaVSrNWgfirqeA+dAQduH055E=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM6PR04MB4693.eurprd04.prod.outlook.com (2603:10a6:20b:7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 14:42:05 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%8]) with mapi id 15.20.4995.014; Tue, 15 Feb 2022
 14:42:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] dpaa2-eth: Simplify bool conversion
Thread-Topic: [PATCH -next] dpaa2-eth: Simplify bool conversion
Thread-Index: AQHYIgir0C0IEbYDEkevN9Xh+htaIayUsFQA
Date:   Tue, 15 Feb 2022 14:42:05 +0000
Message-ID: <20220215144204.qsd5tgvneajvoamu@skbuf>
References: <20220215010913.114395-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220215010913.114395-1-yang.lee@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07158e8f-5b7a-4981-4faa-08d9f0915621
x-ms-traffictypediagnostic: AM6PR04MB4693:EE_
x-microsoft-antispam-prvs: <AM6PR04MB469301BCFB049830049335ECE0349@AM6PR04MB4693.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Axe4YHf2VFL56raZkHI6qYx69gTpt8rmV3B3vMOJzhT5EsxZqdJjuad4TukA6uOz5rhzQCW8NdUew8rRgceRWxCw2fBsK8PA/gJqqvwvVsjajrDSp2wTccvPX+hExplshk0eebf+3UWEVkWQ9rbPX1HMPNAXxxqnk3SpsaSzPKEODprBiMm/0vrELwlYouVT7X0Om2RfsQFuH2yOg1dbwbxwX/jmhNLmx/B3d3CN+0ssN8w6OGSRqGjUAsiASar47NpVMWImllwIRj1XirjJvREAkTunwQ8yCTFR0UfFjfptfBgFI5PflQNsbG7MGaGuKK1vBhdnxw1JtvW2e3f7wuEbEcmlVJvpHcNm4LOORkLv4RHMhJ4FPZFl9/HZWMpdOjtaSSGuV0eSgk2iq1DVfGOZFkDCIX9gfyv1udLgbaUOLNtcjFYYM7i2x6gSaqkGqYP+DYStxmgxGeOPMMyK7D1su8Iv28D2NZTMZJeIqDw8NZP9gP4XrsBYlABPtII8T3iSLy5ZsN+esheJ94Ykfz62UjWVGAZRY1BfYnbDLk8vn1rZ9i9fKthAxZHf4qR6NSRVfGxqO2rMpuJSHI/lD2tmkopC0SE2XfUBcWAU4+1A14OrkTDtAJc4GrGjrN7ZWBQywyWXyDijf7ew5vVUXEaZmqPDuS8gbHwUgY4/zae1r/RdpBgzhkyq6C8hbArExwY2SMVWRlpjkDd/ly8bCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(122000001)(6512007)(6506007)(54906003)(6486002)(316002)(6916009)(4744005)(9686003)(33716001)(86362001)(4326008)(91956017)(38100700002)(8936002)(8676002)(64756008)(83380400001)(71200400001)(5660300002)(1076003)(26005)(186003)(66476007)(2906002)(38070700005)(76116006)(66946007)(66446008)(44832011)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YbgC8MOVcBDofX0pbOJdCPKkMjKiAd4/weRgz0MoxDQCGKBeEOCQedv8s4YG?=
 =?us-ascii?Q?6KMqoIURKmd3nuwU9sV2TRzD6V/56QbZ3dZCWUH99AS07f6vF7lz/LdgZaR9?=
 =?us-ascii?Q?NL4Yow96wZWNyARGmMN7WJMfSsIIH24ebrW4cQ4QKViKbjLMRJvuJD0E15DR?=
 =?us-ascii?Q?NTeN4K/E12HiclvyrZGkV5wVrFH08UZ2KF9Hmjpd4CpZZqzXQfbvRNho444i?=
 =?us-ascii?Q?Nm29GmL1Ea1ihrGkc/yxjfR9Nb/hJk9J5LXYYsjT5crZnofsxwn04Ch1mtOA?=
 =?us-ascii?Q?L9+4kmrU5+2vhTshILmsu586dgBphu1YFHIcCy7T6ydS5gIBW7ZYAmgzqEPM?=
 =?us-ascii?Q?ehAMQkExD4P4C6RA8DFq0YqDUvvVv99OXm8a4Br0TO7lzVwXBqjOdcbe1Ria?=
 =?us-ascii?Q?IOy2UNv86oJ0WpStW8sfCjucoN+A7Sk8juT3okffh0bZO1s5i1a/K5km9BN9?=
 =?us-ascii?Q?xsw7KT5xBwkivHB+t/mLRcwXbi3oXlXCNkhnodfGYz2c29xKfPqlACZdtMqX?=
 =?us-ascii?Q?vWb8jIOKr5C/sivNgWOY0fMEoX7oO73eQlu0Lzd/q90M9lZvE/D1qdNsgOnI?=
 =?us-ascii?Q?7Xu7TYQtFFyC5poQrgsOcFtScYlzih38reWZi5dM9Qiswb0KfCuD4BLGPFdU?=
 =?us-ascii?Q?fuRjS4EgpR7oJ0W54geGX0LeEO6yWANMLOVQ3LWIHDzZtAGIua1RabVTRu1j?=
 =?us-ascii?Q?+Lq+EilOkcUdKCrpcBq8m32LLvxHUTUwOq2JXdyWuujdZIlwAyaGyifORYnf?=
 =?us-ascii?Q?lhAaXnaAJe61n1zevdLIW9PbA8CLgH1tB519BBFAlxgTVStTDa8MkWuN0oXk?=
 =?us-ascii?Q?ugOe5hdrMpkajhTqd6v67r5FsOAUTQH75PGO2/8YL5INniXOAjswpNqU3XKs?=
 =?us-ascii?Q?iPLNgJNqpFe+ax5R3wSJhl/yz6hayu3Vau8EAUA9ja1qwsqvCkgK91NVoW42?=
 =?us-ascii?Q?pZ8PWsCi2Ib1jwqJauK8Ch76abgRtDGF0oCaROpHai74pewqumH6ghvLG/h2?=
 =?us-ascii?Q?+PtTUsOJ8um0Yvwf0k+0JhggOiDtAuC6VQ9H3w+yxi1rb5CwqJ2Cb45uYsRT?=
 =?us-ascii?Q?ysl48vUToS4ReGftHepGAzrudBSQ7ha+gWjGwpBnMmVp+WBa93y/yGCXXRDm?=
 =?us-ascii?Q?p7AB9RBCgGo+AH29/i6hr7a8Gl/1roB8U5eKLUMmGE5A8BpX+qfLMKu5B4hX?=
 =?us-ascii?Q?FCIQck1h6AoNH/AVPIL5E8RxbNok4rhhxzoaxHSVmd6VstT+/isXcnrsOpFW?=
 =?us-ascii?Q?dOq/beHNt6IqXXJdSZn1/60/Tr3Ev5oG/IlPT3jHrhU0j3GNqkTWm5sc7wyw?=
 =?us-ascii?Q?LGMXwa5ONYNN/WyyJ12HyIxGsemRLaSHkp0Y2dooKDbA1EqzqIf2dxzDfxiN?=
 =?us-ascii?Q?7iPTS7OXJe/2PoUmkY9LLUDkxAhqDyW1ILDeMcv2ATUPla0JNE/ja3tU3bQE?=
 =?us-ascii?Q?kp/Y8w22r0H0a104thMETNrpbpaFajo/8RPceygBtICINIn51ieP+v7vdSjE?=
 =?us-ascii?Q?znweM5VSyzNTyPNoC5VHTkBxIs1Y5MRnc0zCFBFgJEZ0RBW96K2FuQHLNzBA?=
 =?us-ascii?Q?YZ8OqqqATJKKHDXZTQMTBqLnuY0CMlWrmW7I6YY+IHhGh71aWx6LGWWnWJ32?=
 =?us-ascii?Q?1AUDfY/Mh9j+BLLyCNJfqIs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54AACA1C8568294E94DB2E6AE6C366F0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07158e8f-5b7a-4981-4faa-08d9f0915621
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 14:42:05.4646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /8AA5WRzeq1lgs/FkJZfFIT+SxBaaoGwiv0zJK/hBVMGAJkowhubVQFbQ8aD8XcBzvLvZnA0+0dWEHi3LDwKbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 09:09:13AM +0800, Yang Li wrote:
> Fix the following coccicheck warnings:
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1199:42-47: WARNING:
> conversion to bool not needed here
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1218:54-59: WARNING:
> conversion to bool not needed here
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
