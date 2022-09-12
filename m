Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317375B631A
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiILVxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiILVxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:53:49 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10056.outbound.protection.outlook.com [40.107.1.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4A4D179;
        Mon, 12 Sep 2022 14:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOZuGG1lt/BzqNZSbTTm0t0WYgfqA9PZFndqnA6LxXna41OZiH9m/vnGaqudZKtfhKB9IjawlqOWaDAzTgeZyRFvw+tPzclPJ+CnU6VdcQalJSwSBqLfuf5xbY9JYYj7IuflrzyEJ0Wj4xC++KBAA8hYWoK4pkniwpsk2aXceq2Cp14uqwE+oOJppeMtLc5CxAgqF/ndQQbaXRkGAlPrnbH1df8bKIFMSHtmZjgSYHz95F2bR/pMXnLaAXCj4EVG1fOv2iMeFR7O0l8KPHGmR7yNNC11xFo5FBGV3Z1ccTZRi9RtwMG+dvQvtZkV7WxS9dpI45MglvXI+KGF/wyQdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjiqXMRX1d09JV2AFtYuS93s8NuMo3TAQqvdMYlB2k8=;
 b=mw1KAT/wAMIIBR/BgfvmK6DG3rIEzUf6C+EJcCMLYl7lpE/0WP3tiPHxTCY11rjPMkB3J+0TiV5N6WsZvtAqCA16Cpyu6xpcX+nf3KscQU9Z9yxUxvB0DmHqMO3PfyTek0+BZdCcb9kxCgG7y5BcaLLfkvDsdIlUaacHWJ+gCAGekUhhYdoOS4mUfWK0z1FQJj5rtrItl+mG8iIwrbavuEO+qtEzrtsgdlLyVua4ElYeHjODGoebmMWTJ2f2OyfgQ7HhZzdKV8Sa8gDmD90icUP94Xt488UUkrv7+SyDmmFQtqaq1fUozuu2LB0INFoCZunKuRPkns33kQ80DteKwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjiqXMRX1d09JV2AFtYuS93s8NuMo3TAQqvdMYlB2k8=;
 b=T039Gkm+yWykBYcQN0SQl0dbTxXe5iqldOXw1rLj0eb4TfhqfI36sW6m3tiII+cmI370wYEHF0+EkuejkCIQwHA3N7zR3yhX1ZUMQLiu2lqlO8ZblE/ah1fXUTQ/vGXjNvHsXftbyPlBaCtcZc2YovMuxUkhXmK31JnUM32ldbY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6906.eurprd04.prod.outlook.com (2603:10a6:10:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 21:53:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 21:53:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Thread-Topic: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Thread-Index: AQHYxhmBZYjSTVdDzkG5f4rICTpo5q3cShSAgAAN+gA=
Date:   Mon, 12 Sep 2022 21:53:45 +0000
Message-ID: <20220912215344.attgqsxf5oph3cyu@skbuf>
References: <20220912170808.y4l4u2el7dozpx4j@skbuf>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220912170808.y4l4u2el7dozpx4j@skbuf> <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
 <Yx+CzUCbNgAjDK5l@colin-ia-desktop> <20220912202321.5yqmmf2j7gcljg4j@skbuf>
 <Yx+er8l1CzutF8jo@colin-ia-desktop>
In-Reply-To: <Yx+er8l1CzutF8jo@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB8PR04MB6906:EE_
x-ms-office365-filtering-correlation-id: 43bea7db-a28f-4a3d-9da8-08da950943ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6LxlLM92Ctucctwb3GDsyU9H9b8pwcotO84egxEQhMkFLjtrPnUMmpxSNkFNgydH1AcqTapMUqD44DeJpVRXmyC00o/7ZJiLBPeO5HeWB4ZMWJDt5Yap5WVRKZZ8Ap6QMbbSDBwv2sqJ5pfIInevGCnyymlS5PTj7OMRw8ZWnTSt3rG6AEvo+SFhu6sQrjfbRcbpj+P/6GJHtHL+NUkHQ8l+pJkhbhRZihaSr5OBgZb6ZgSgcaXgm4iu7Ekd75Paxzmod/hDmMxKJWCZvlVgnVJMPFxZoD6M+/tNmxlOxlln4OGH8BRy32OkEOIXfSaiuhQuASxajZLcMevhtyfjm105uBi4kvE/iB1tR/wAkD7MbuNbtwUCKovyWGGLt9iz5vLEV4HX6JHpwJMmGb/F4Fe5IE34vJYdrDYNLp7l2PC6nDEEiXJJVBabWnXCphpKy0g34ppVASVFvtuEM+/6U/+aXClH4lnDqD/m/aYZL5/0FJSA3h/M8QNIGhXzQNXiIm537MTZxR5scgmA6b367TZUvS9fjhKubmKsxaFflYCi7OuAcpoqX903mT6q62t1nd2Lj9i4B1PvQI5SuHYBO1QgWdEHowUDUGci+QMbdlWsEBMoa0l8vugYbJQsZCTFPP0JNODzY1dSXmCuFEnvRvJsUSC3Sb87iOyI96beL+q9L3gLi9DMb+21PXeTRhu7Vui2gcXoKh3Eii8OshpjXR0ZUG2R0Hunxcp2Hwr297uUdq7FDQFc9nt2zE9Jyhh9vw3k70v6mEDYUKZ0wu4IzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(26005)(6916009)(7416002)(54906003)(8936002)(41300700001)(76116006)(6486002)(478600001)(9686003)(71200400001)(186003)(2906002)(38100700002)(4326008)(38070700005)(1076003)(4744005)(8676002)(5660300002)(6512007)(86362001)(122000001)(44832011)(91956017)(64756008)(66446008)(6506007)(66556008)(33716001)(316002)(66946007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GCWlSvqH/ekDG3xfbKlDyFuzXIPElijiGXYcALndxi5XxmwKaGgPIX2qluMb?=
 =?us-ascii?Q?oyjxJuO/erRMJVq+bcNLRLOMfZ/krmZAvOnG5jXPuHk2KTkLHHMb0qUGjFb5?=
 =?us-ascii?Q?QMuUU8HlbkNKIEIbWtr0Owgh9Pnv44DNb7iUPQJcYeFaI9QbAfSk3t6xGewU?=
 =?us-ascii?Q?2cxreDW0O5gs80clCkxPJej9qazzQIPujh11eVzpUrqy/Oo5RomNfK6hs9Tq?=
 =?us-ascii?Q?nFEoncxu3jKuGaSClG7S8OifW+IDCU2FT/eFbmnrV4FxuTPmbb30mDj8TODG?=
 =?us-ascii?Q?6+h6nO6aut5eyaFjLmtfdVrXdKCIK1sOYzhB9ExOFAhLV+2DEsNY0aAHFYXs?=
 =?us-ascii?Q?/uC3Du463Oflb/ToPUn9wPSXncx0HyViaZ6As0yZaHwU1714DbYVzv80Pebb?=
 =?us-ascii?Q?KzA/ELodS0byOyPb8bLnA2fzNX0od1mruHEaaD/Xn0NMBd9P4szMCx6igX7c?=
 =?us-ascii?Q?1MmeOy55r0IY4WiTJXJ9LgQA2sDutnpc9ahdfYGF6s4jxKekDnlwHW087gdi?=
 =?us-ascii?Q?zWc0xaOKTy4Z4aY/2q0/jjLdpi86j96lNsggdTLF9pgtCGg+Dfk+Y5Darw6C?=
 =?us-ascii?Q?DR5iW96Ntieo8ZTz67BpdP2n+lrTU9U/bqiHbuDXEDHOdofaegjSwBpigFHw?=
 =?us-ascii?Q?t9bRMK9+FcWp5FXGcuKzQJHc267t/nw1Qmqr3kgoYxbSpN+Vq3xh+CttK2Vv?=
 =?us-ascii?Q?dV4iSOgE52SzW5CPixyK5yFB5Rl6DP8gYqb5NrxQ3QjWTlzbHTS8Zer13lE8?=
 =?us-ascii?Q?6mU75urxdUsU4HjzAVWY1KJft6yPvenO3Jce3hiK9rilG5rjVUvgP5Pmb/kk?=
 =?us-ascii?Q?XvO1fxsUkzAuTd8Z8QxrYJIv1TueAmHZ1zxw8VZyi7xLjethuK6ho/rfnrwy?=
 =?us-ascii?Q?DWFrEYWwYolGJkUBKJbVBso6ArEkI50seVD8TMhATqtzn+ygIBSSUokV70+K?=
 =?us-ascii?Q?8aPN2J1xhMj628rcLV97dx5Q7wpcZKOc9DbheLw6bqVdAT1iGriyzcNB8/2U?=
 =?us-ascii?Q?vwCdPyYGtTT6OltPUJ0qHcl8J0Th1IhjUBUAhavbekOx7XfQWL51xlQtLmh9?=
 =?us-ascii?Q?OvO0+D/Ji5LlRamdBEDCuNKMTapDOt2HdjANQcPd+V1ogrBQ8TDDx/C5kKgJ?=
 =?us-ascii?Q?o/gHSCCCmtiaZrYN2W1ouINZuc4f1Yu82T1B1rDEi5ee1RAAw0tRy7aWZPzB?=
 =?us-ascii?Q?z+i2w0H7H87/1EqBU0OuUAlqMzZoAggmYjHzKdww3FPFstXpAwThhhEEymvO?=
 =?us-ascii?Q?LDHuoYKIqUq7K6E9bT+HkKUW1/mrbkOsub2iluhjgMtd2UQjYjapwVzNOlFF?=
 =?us-ascii?Q?ffzo+i8YlY/9mlGks9ec97ckyGja/RLD2RDwQsRSk8NkFekJeucaw2RA2mu1?=
 =?us-ascii?Q?bCY7PN9fxxJ4X/dbXoAEVCTfZTRrz5S6OlDeaOOyrx41+mLBDsbYZdDDCikt?=
 =?us-ascii?Q?6oJB1cqNOxBwvWVBxgq+CJNCsDmJsbLja0LDB26rU9CwoqJLn/g5nT+7jQak?=
 =?us-ascii?Q?9iMgBqHt2Dw5PKxgHmR/fx+X8jYdskGR5SDYfYqUaNFzSaUsm/FYTUUwHrYp?=
 =?us-ascii?Q?JeFJbeAEKdKBS36QiKaWXCuoWY/iw6OFse/PqcPONu5JCo0xD6yZHG9gK3+Z?=
 =?us-ascii?Q?uQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <501C08EB7A71174F9B1843000AE56B16@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bea7db-a28f-4a3d-9da8-08da950943ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 21:53:45.3080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nOzQ/TF/b35IX2RDduBY/BebK4XoHnODHn3b3Cy3Nympf1tLkViAWwsfuKejrU8qSLuNJV6Va60Wb5EUU9x1nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6906
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 02:03:43PM -0700, Colin Foster wrote:
> Yep, that's what my example above shows. Not my favorite.

Yeah, sorry, I was on mobile and I had exactly one pass at reading your
response. You did point this out with the "two loops" comment.

> This sounds reasonable. So long as it doesn't muddy up felix / seville
> too much - I'll take a look. It seems like it would just be moving
> a lot of the "resource configuration" code from felix_init_structs() into
> the felix->info->init_regmap(), or similar.

Possibly so, yes. I don't have any other comments for this series, btw.
Just make sure to grab the attention of one of the maintainers somehow
to get Lee's branch pulled, before you send the next version. Not exactly
sure how; LPC has just started and most people have their attention
focused there, I guess.=
