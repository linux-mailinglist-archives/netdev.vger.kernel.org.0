Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B046500076
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 23:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiDMVCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 17:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiDMVCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 17:02:51 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F070C2AC68;
        Wed, 13 Apr 2022 14:00:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ur4jOeMPlV7AXILKInoB40+cEFtVncCDOxE8Is6E5eO8JgYVzpUB6+aDn3iUgHIn5l8nspSiQFZycToGsVrXfsoELw5dsGN08p2j4WaSXIdY0zhJXEUuBv4D+cY0VgwV7YW3kfN1M1CE0RkGvt22EwmMkyvWXEjHI8qKKih4ZuqyLKUKkh8jqo0WpCsDrgF3e81OCOTmeo1czck3kqJdq9bgIc2Yt7zfxJxW+09G6D5EZc+qIlemGPxKQWLjzDysinxxfE5H2Jk1FgnsymXLLG7YzhuTt5gVVibJrTk4DupdHz7jFA78XZZQ+CkOB004WFfozJwjKActh4MrMtaalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8OsQkMtPPzygbbuaT86xWybSRQVOXC84+CuRWyt24I=;
 b=f1eBY+pB6YeC9WsbF/t9f9qwpkuLp26v9CdFFjIV0FW4X+3cKPkFaueJGwWE/FgqBh7KqxY1tzz26xR0CzRyNx/rdSRaeQjAaxoMmAgSN3p63yfpGR7SbbqjLl1uc0gJvAt43EFPBnyvgBeAfO+w545rJ/HdoyVwNur41EtqSQX/0MMiCXzT9b3+w+jwdCbsjRzD1U7vXTTw7kGvRRQbJxYTLwXWLWHs/OecB39zz1vOf0fATTn5E4ke5bzUzLNs78MIn8Nufeq9B2KTcIdjNbllr1mm+RcL9HdnYaL9anLCMGXS9+YgKtuNEUy2D4PTFGJi0xgg79rJGWakdUqKtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8OsQkMtPPzygbbuaT86xWybSRQVOXC84+CuRWyt24I=;
 b=WMM+tyJR7/vFr3MlQUVW2Nx8f+Crb/4vBViXWbn4oEImvU1LEVxDTgW6DtiFguGGXkS5M3Hbo80dx9AJPYevXY4Qmlms79diRwnaw4LC24sBQrigtMQMvVEmio8PBrPxrE9RZvObXTGVFYZ/UxljBaut5H/jGUsat0Ecv8gdr+s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7248.eurprd04.prod.outlook.com (2603:10a6:800:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 21:00:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 21:00:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Thread-Index: AQHYTfheCzBrufjauEu7NwJglkZ/ZKzuSJmAgAALg4CAAAEaAIAAARUAgAAAwwA=
Date:   Wed, 13 Apr 2022 21:00:26 +0000
Message-ID: <20220413210026.pe4jpq7jjefcuypo@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf> <Ylc3ca1k1IZUhFxZ@lunn.ch>
 <20220413205350.3jhtm7u6cusc7kh3@skbuf> <Ylc5RhzehbIuLswA@lunn.ch>
In-Reply-To: <Ylc5RhzehbIuLswA@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 892ba76a-4685-4ec1-c1cf-08da1d90a2d7
x-ms-traffictypediagnostic: VE1PR04MB7248:EE_
x-microsoft-antispam-prvs: <VE1PR04MB7248A0CE6863F7DE37397528E0EC9@VE1PR04MB7248.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VKbv0emHL0LtepGTVklVo7+2n3tC5sN/OkvULrLkK71aRqfi+XPPrRp88N0hCfFDBTo6dQOi/NqahbCepKiVFU0VzQljnjeOIXs3Y3My+l3nbj7MzFqogZOJqumbXsgHdOpDKUSWMCXnzGti77WI522yttJHnVPyioB6kJuBNzvrlxmwHP2v4RzxLYX1FqMD1wGNIMYbM6nGR8fLA1X2ranUZTXji8W5H55C269b5l0vlE5wisPdUwD5uJxkv1S3vse3USo5aCJCvd21/f1eQlVfH5cIMX00ybvcCzCN10qV3HMo1oRhF4xq66K+UHiZNjtthLyEUJrFxJgqim6budT6nLxXf7BGH/qeVEtWEMqOA0GXrboxev2rPsOOylluFDnN/rvqyMXz65x73ZAm8emIxTHpYY2DgJ804/4iRgHCBPaor1fhqR0TI9+nIgvwr1lknZs7lcgHKiPTw6HdwRIvvE6FN3coKOZI5EhPWSCwn6cyC2s30qkp8KX9iYEqgSoLS1q/XWh7z5O6brgidK4XBjaFvhv9PBMx2/fzQz7tI/JdXSb5jxuxFfQVayawXZvOSE7aHyykoVZtBMwK3bxtOoQZEk7OnWxcsgvZxjY9C/dgbgQgklnADvw67z9C0Pd8pyzKHTjgInVJYohWcaT5Hy7xaqTUbPfQc3k8nEnSYjhpUvxt32hdDjE/SMjxunDR0n3WocG8P6KNL3ohVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(8936002)(5660300002)(44832011)(38100700002)(7416002)(4744005)(6486002)(6506007)(122000001)(186003)(38070700005)(26005)(1076003)(86362001)(9686003)(2906002)(6512007)(316002)(91956017)(54906003)(6916009)(66446008)(8676002)(66476007)(66556008)(64756008)(33716001)(66946007)(76116006)(4326008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7uSG4uAvR3boch6t08cY2YnaOgmwr0KVlrXWbCPVIB27DWG2jCGsEIkOi0Hv?=
 =?us-ascii?Q?XD9hDiYdT8oBo+1q3eNesQEf7m1owV+w8OL5BCRjCesJpk4Zug0qM7sIyw7Q?=
 =?us-ascii?Q?rxcJSEvLEm0DvCVnx7E4F0BXBSIxd37k/z2iQgb4y0cV5OJXo2NZ5AaDF7jU?=
 =?us-ascii?Q?miu8X+EoCm84crOkWctwwHi43TwO9RIQ5qQ2SuYaEwC1Ow2TOEpC1CsFPKLu?=
 =?us-ascii?Q?4jQpaj+HTtVXAUSOPi8h0XjZ2D1zPCE3SziMx8A5p2OdEQ5MUGMFLbU26kbg?=
 =?us-ascii?Q?QmBx8NpJqgp9gvML30QEhI51tNBKv4DaOreaEzSmp4gx7KW7tRK8ROfBYmmH?=
 =?us-ascii?Q?5k7RECCigMsIvMKKxA9UUnvlGSDvubk957D5hdMLMhpZGgyY0as4v8+V9jZt?=
 =?us-ascii?Q?kwBMun4y68CsNjVVdDSc2IbynGthn8kVXGWUEEkb7yW9Bi+qqWUCYIm7w99C?=
 =?us-ascii?Q?fAjGZbzOkIRYvc9HCPUWdzveeE/hJPLn5dKeNxK6jpfdny8xyLRSlNZdfJWv?=
 =?us-ascii?Q?ANxe6g8Qqd+WodcQgS4T1VCbRPNYy8Kn5AW9hyEGMRASmPogfQBgdajvOecc?=
 =?us-ascii?Q?ncAw/kRynAaGtxN7w1KXo+q7MTzRMpcxfajGoerpZoIRBMfCD2dkBmHTdn+t?=
 =?us-ascii?Q?goJwzkQytxF4xDfAM3+4Jc7em+JMWzDVLFjkgTH9m+DybWyr3rffFndkovMr?=
 =?us-ascii?Q?sfeUyKBeM3zAaWx82lf1XddG1KKsZuLGQ3EZ6n36DoFpidQKTRoVwpFFRJbq?=
 =?us-ascii?Q?tEp6oMIPVwDYYdbtXgfwKt4PsDxLLn+7FA0AJ4xV7NHKaKSFsAoQSJ5kBgz8?=
 =?us-ascii?Q?hx1EQwhg4cEXYWI6MS9Wof5KEEekTHRU3H6YUJMLWEtKN+LEGhfnjPBPY41u?=
 =?us-ascii?Q?G8FpEW6nzw8aabyYJJ3fZvm2+E7nmXQHBdWYf6D1f5XmD1wmEsjzSR0QGG7m?=
 =?us-ascii?Q?StyGYtVsK/G8RQEb6+QlIEDMBQdOPD0TpDcv0Vs5XBJfDGpcZMTGF4V5kObZ?=
 =?us-ascii?Q?IbEElb/iHDILCBxU+zKVpj3q9dusTA2wldjHb/teA3RUXoJ2z5ZolNIOlgxG?=
 =?us-ascii?Q?/mjksg23f4n4oZZ7l5zRiY30eIdJxN/qnn1IdazhowsKVJQyWkrzXjxj+rhp?=
 =?us-ascii?Q?1AJue9MhrhutAuh3P6iTlYTeQiW3CzYA5ByX6aqI3agLBSRg495XmyXZtFD1?=
 =?us-ascii?Q?YU9xvJolkTonG0TcDk6QplmsGo8HcQcE0d0/nPBWdwrYt0GDecb6+GQn7nug?=
 =?us-ascii?Q?lhLD8ojIUB9ZpszqiXXLOFobgV7/7588ySu1+qam1ja+9bSI8nT2cf+rnVvj?=
 =?us-ascii?Q?uE74HBlq6qc/dPPHcsVqeKi2wbZDpOige/we0sHRyAO9wuUGF1U9DGgak1s2?=
 =?us-ascii?Q?SP5M0BeGAg+AWIrP7DENMPX2Z9jpR/558DD3BW/5OjUfXkmhczbnfBNVkAHm?=
 =?us-ascii?Q?nCJDzXUJ6+Mnow/2iriSe7HlTOXPvD+7wPL4a5BXbVmtwuNLWwI7z5LuRYlL?=
 =?us-ascii?Q?a+PMKWDXmYMGbFsO/1zu1jnVqMqgQhcRLnwkbshb9fxde/isBQHk/NNOyHg8?=
 =?us-ascii?Q?6MwV7JloVkDxn1XySMSuI2iDF1ydMmDJO/paYH268iEPf/LLxe2iQW7hS2pv?=
 =?us-ascii?Q?1ZTyc5WSmrEYQSZ8pmRNLiiQTVcl0l+HhSd6lp5MTf5WhPheEKJza5x7EXLj?=
 =?us-ascii?Q?zL9Bo82VPdHi4bNzcr/+HCnd/upOptFTuKRUVL+st3VBrkc8Isk7I8wUd3lU?=
 =?us-ascii?Q?wpNS4asI0jfFrKJNTIt8hkdJAf73IPk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21BF10D7C4156D48B1DB14A5327189E3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892ba76a-4685-4ec1-c1cf-08da1d90a2d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 21:00:26.9641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JeccCPfNp1g3EQs9gX51EndBOY1Lk6GlbicVqHtUNA4bsfsTT7fievoJIskErwDgU5+VzkKpywJzqTJe58gWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 10:57:42PM +0200, Andrew Lunn wrote:
> > I meant to ask about the actual mv88e6060 driver, the one that uses
> > tag_trailer.c, not mv88e6xxx.
>=20
> Ah, sorry, i don't have one of those. And i've no idea of anybody who
> does. It is a long long time since i heard of anybody with one.
>=20
>       Andrew

Ok, I'll go with "no checksum offload for its trailer tag, and bugs
never fixed because no one uses it", in any case no Sasquatch. Thanks.=
