Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A74618B44
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiKCWUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKCWUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:20:18 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60054.outbound.protection.outlook.com [40.107.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34E11D0FC
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeBpnC+awLRJPwNvGHTluj77SNhMbomYAdH8Wo0eROCKWW2B7tzhcRpnXS/5vvw28THkaT4kAZH9hfxFnlGQVeY45AlmKD/pHBLGonVFKrk04VgG0aZrVEWBWku9Cz9ZC2a8cPcchop+nwY58Rw4db42c/DTOJuEvyPJPKj2b61xfgAwI1jlhmuko/PvoCvF/86h85Smrb1USdmOPkjmwiR21+MNDCXNU3Hc8p3Fa8BVPfjdG88E6sbMbvmKnOe5UWsDJXqPZ30fpCZV4kk7iLWNwarf3h9LyE+/DoyVIbMX7f9I5Lgy8EotU1cvKip/aRSQJy+UwUeJWLPUhgq/4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8ihNlYd9G0h4C/EZYO8CyluuoY+V7ehhOavnKjAUlI=;
 b=gmCJWwEC8bqxGlfAFPCXnjyXs64/OhcwvdtUQUH1s8gPW+Nsl0PHe5vmP7pNAgviI5NKqORG7Phiqj9Eg5aZ0zridC76ptDsbXth/BNWjZ+Mj9rByL0P9CDJ6RR/1X6D4O4veB6yeKGUro4/mFTJBqaMsaQTlBj9qZNJlYbCPNjpEFW3jBxM2wE34NnqSI7RqBUxFaO38570vlexrQi3VhmiwtOGXnhLlgyb4ffhWJdjQlFL9qoZDr/Z2xvNKrC/OwfOrwGj2M3lAD4Edn3VeoKyMfvRYKqOkRYqoNsSfdJqe6KMEPhqqeLw2/gVgrzbJb/XGGdRhF3H2+KEd9J8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8ihNlYd9G0h4C/EZYO8CyluuoY+V7ehhOavnKjAUlI=;
 b=jnyIVNZb9L9+dVCG3h4k3HUBwcou1nmC+UsipL32Z65L2MSySNKhKIwX2TejF7kmYYvA60fUihI0Hfd7l+5jSHQalWHd7pvcCi/pyfvAD6hGqTqvhrSd+uwTIOOw+/lyQzJtnT1CI+fINKlRU68G/KMJBcmJNPno/zQDWdl0ep4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7694.eurprd04.prod.outlook.com (2603:10a6:102:e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 22:20:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Thu, 3 Nov 2022
 22:20:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH ethtool] fsl_enetc: add support for NXP ENETC driver
Thread-Topic: [PATCH ethtool] fsl_enetc: add support for NXP ENETC driver
Thread-Index: AQHY6W3/Pa4Sx/Lx3kOqEASPat4paq4qTOCAgAOFJwA=
Date:   Thu, 3 Nov 2022 22:20:15 +0000
Message-ID: <20221103222014.6hi4sxn53j5s4cw2@skbuf>
References: <20221026190552.2415266-1-vladimir.oltean@nxp.com>
 <20221101163453.jtouqmz3m6hrnftz@lion.mk-sys.cz>
In-Reply-To: <20221101163453.jtouqmz3m6hrnftz@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB7694:EE_
x-ms-office365-filtering-correlation-id: cefbe4a6-808d-4a4e-2e99-08dabde994fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uc5y1ZDL5XPGgMZzLQLDai6Eu5Xl9xoIU56cWre9++3LMA/wYqN6ID2RAmlznJJr4iPWmdH59O6erO/KJfV+MstZJtZNBIjXNMAQDVBmPsn+2wARM2zlc5UcQDGUrQDshD9WkK3Zu0ITbw5guqx3vL1Mj8Kn2Kki9m4D/4K0ZOgGJLYCkoCnTw2cltl9iAfoXqJEzJDkNHfj84StILQRDxN80Z4rb60HYlqXl3wjvVa+NtF4xCIWRrRFO8WgnNFI1pRnjHXWz2EwDeVxG1vAjJyeTMmTVVlR1dmmYvhqP5lmKHSz4XgveTln2BVV1OdsqccMtbMt47SSafDNSUz3WcuHzsLYF0oCihHWeNm4cHxJHG3BZgcG4Tvz2Z0nvYbqNHH0DCZ9H1TsPbhlIn7iGzLAI+umvkj+FFVwXDbv5hEW1wo7KZNpInHoVbfi7ggt0+4nb/aGNOZ7fYKwGwBUn3uUrX9ekCfNuTghegahvSgXsZV3iqKWgAx0TNzvKwhCHxEHWYOitUBV3kY0iQ65x2+7PQFHbLL8jl3gAgOFfgIuMpkZwhOIjMVXNTGcHdMbBMljU/lgKq+DjT1VRdhjJgMszdzbdXnxpE+ok5DuZ5IwxHEenbymgIMypKpQGY/DaSt26fxQlGBO6J3675PvNbE9ngXqPy6QM9h53iZBmmSIQfwQUO+FsPa+1Y17jtf0xun5uQsVZfG9Og14Pdtk1MmQnJdKY0vcRnzEGKDYcSZnSX8wU9HOrrRsQG4a/E3ofXDBmFER+ehdt6TctrOCBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199015)(8936002)(86362001)(478600001)(6486002)(44832011)(5660300002)(2906002)(9686003)(26005)(71200400001)(4744005)(6512007)(6506007)(33716001)(38070700005)(1076003)(38100700002)(186003)(122000001)(41300700001)(6916009)(66446008)(76116006)(66946007)(66556008)(4326008)(66476007)(64756008)(8676002)(316002)(54906003)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ef5wZ+q/GWH+9U3dfVTKkDdfpFAv7+U5wGbSeYBpl57nc+4OgTeB+V2tKN0O?=
 =?us-ascii?Q?flSm0Q2qOs/I8NELmkqFfYG4wZM0ITWlEgzzRlz7o6SgY143RJ6owcQh2sdY?=
 =?us-ascii?Q?gwfc/QRhNjUl41Oyf/IK9Uf3gCakbjTndG7tElAkPpQh7r0Nk0BpfFOpvuZ1?=
 =?us-ascii?Q?8qI7CJuEeRlmHbmmD9b4XX0LtU1WkVJNeaSmeo8I7acTIYB6ClfBZz+YAH+k?=
 =?us-ascii?Q?NPWtuQp0J71ybWbbnAp13E+/ATi/LL54cupUzZsAYb72JthYV3T/dVIg1B0T?=
 =?us-ascii?Q?3Xl9ES3jJQ5ASIa/ZDSzBptN3/Hc0GyVnP4EMf0y+aFmsj2slduPobwIeefO?=
 =?us-ascii?Q?ZvbRcNaFUMkiObt0N8IP6fiJN7UWN1jf1zPqA5lvbpwvrPnwTNkzE8BWJg1o?=
 =?us-ascii?Q?u6i+pzU829uDcVIs/+FHI3qdjuJLHPKcxmRLPUMPCZPvftTrJBxzBf7yxcsl?=
 =?us-ascii?Q?b+AhVfudksVlyzeFUKEvrx0pVKcE0+jzWzDPnkCR81XuyB4p/L2T75lGRHt9?=
 =?us-ascii?Q?u8WCTK3cS/ThDInh6xnznF12cKScStXLv+o1DICiQNTudkpJ0W6oXze6KP5T?=
 =?us-ascii?Q?X42upOCkl1qQU4fUpSG5nOsyDWrXmkhfjxUB15SITgKmc5KB1jSsYQgBF+TQ?=
 =?us-ascii?Q?FTkQZzImUy6FWTl0i8tfhxosNbGArerBj7J1AXewGwB+fYUuMqGKM5efg9y5?=
 =?us-ascii?Q?dzCk69HwEo519hXaQ3UCaMFGF65yki1E+KK89v3F/NvVHfhmsdD81lQMyA+P?=
 =?us-ascii?Q?Fw5yLpGCNLOo8molnLu0baJIJmPjSCXjmu9Xx82YtdRrwo4MjGn+fphb4AU1?=
 =?us-ascii?Q?qpJ/oG3HSJr9GalUQes+IL8oF+clGqEqR2UVW3jmy50ibwp+YXI911vb2raL?=
 =?us-ascii?Q?WZCqBBEiWMSGpi4FiMxwJuoI/9EgMbPsvYkFrKWmHw5tMO11RExXsNkLh/bN?=
 =?us-ascii?Q?BZEUvPoXYTIgrN73HCt4pjNehurNe1B2TAa9NDac0+gp5oJIew0ci4GdLwjc?=
 =?us-ascii?Q?DkQVnUXC9csn/u3P65cV9FR0lTpI+5bl47ftu1q4+mRYXlukw77jHZfDZ16m?=
 =?us-ascii?Q?RKPOSSozDHEMovctOznGb2U+xcrSrGyiiWEjZALPTTDUx8TbR+U1vH3Uhuqf?=
 =?us-ascii?Q?osmqAlHJOxviwntaj5vZ2D8V4UmwyZN6tDSuIFQTzmoYreK7Bho9P2X3r0l7?=
 =?us-ascii?Q?GKAVyGVgeK3UCdcaGQR17JG1RkAeS+1/MKg03Yk9ySod5RcvfQcWbbo1qoM/?=
 =?us-ascii?Q?PMiILrlg3ljBfOrP7BPQw+iF8V+alOXkHLzzqXYMZsucu3vtgLPTHAzWNaS6?=
 =?us-ascii?Q?hzTaxFQuYQBDKkMCnF9U8aO2kWN1Byy0nEBX+H7nuAcvqr3USH6r6THjrTnV?=
 =?us-ascii?Q?bnUAt3rZ3Wv9rBhwqI7K69SyYXCESj64RBGiFV+dLZ7HlUxlqD7vUB2OaRnF?=
 =?us-ascii?Q?J/fAB0oZRf/iENbE2U/cuxJ4UbzDrAp2nAovmdC6G9W6qZZX+F3OMhg6Ozo5?=
 =?us-ascii?Q?1USlEuk4qLziUuYW3F99wBJWUSLUZQex6XI1Nl9oXR41TCSkVmpx+k1Yc0Q/?=
 =?us-ascii?Q?x2dir3zEcB7eQ0kczxzR5JXJ0+a0AMEYEMLnjkTrGQ0FtSQ1BtcnF2FV//Kg?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61C0BE632CD8A3458A948FB853AD46CF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefbe4a6-808d-4a4e-2e99-08dabde994fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 22:20:15.0553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LyH4kNoZ9y1lZ/3RvMoSzqo9f6s20uy7WZ0C44BqpgxlnB9IcP8NHmUiUulv+wTJNY0eibJMoh9aBQXjnJZz9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7694
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Tue, Nov 01, 2022 at 05:34:53PM +0100, Michal Kubecek wrote:
> > +#define BIT(x)			(1 << (x))
>=20
> This macro is only used to mask bits of a u32 value, wouldn't "1U" be
> more appropriate?

I'm not sure that signed vs unsigned operands make a difference for left
shifting (as opposed to right shifting where they definitely do), but I
will make this change and resubmit. Thanks for the review.=
