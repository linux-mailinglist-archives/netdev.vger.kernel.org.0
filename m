Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48CB52DA18
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbiESQXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiESQXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:23:15 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30047.outbound.protection.outlook.com [40.107.3.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AA8C3D18
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 09:23:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrEms0UXIYBzzKlx90TZ/AY0F4WISXfu6FMLNVG8KOL+QCWym6qUShYERCuWSFMy+A3hJYBU4IbY1lPZJSS/PFEHvIDJc/pgTPyOaIGDXxvl/68iE+3Xy8/U0iyUkk3rJKKGTqgPv0BSBFv3Rqnrw8p3dN7iGRW0SWlUjybOgBClVfILhL92/ZMOOtNq6wqxd/kHoC/uEr3etvmYUNFC7G2sLCB+FGJaVzqscqsLHTNEi0hlwPeaBL/zIgq1hbQq3qeFGTeGF01m1xjZgC/eoq1WNADGEG+qBQ2Cqln+gwOPI8SrDLTRWGV+7EjnpbJZNeIPyjBD1+iiy+IeBVJYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzihW6DP65aZ1aYlQJ7qVkfQNEeZxKQJg9gEtxS51w8=;
 b=CA4JZwD0grUsV30fSpuc5WDyJ1WkTj+V96nXNum4qnSunHILgMYUaL7YQVQl259/zHm+l9XtIVNqtpMwvnB3qObZXYrfa91w/7tohN1+SgUsao8/JZcl2wmJUcmllmURWIB5gEG7nWvIFncmKGQEuiZqUjXXth2u2TTqVPNWaxiDRkoIhFphC/0Ik7lDxBSL7vNkSMldhNOlSJUT2qKC5I3D/q44zsDyKJ70Ucrbno0MDy9RCsNE4jEy2i4ai3XR/JAzNDl/mUkwtjISwzOeVx9pr8RqqQ/bSjmEdr1gEdp7iFMBliHm05ChAoTSdu53dsN8Hf8vL2IA9FyGwSeABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzihW6DP65aZ1aYlQJ7qVkfQNEeZxKQJg9gEtxS51w8=;
 b=cFU0TCFD0EFDZ2fJ9jg39h8qB65LKM64N7bT5TZ+SYRUL8iaAHVrDYgNCd2A9oComh79TctRW5dMGUlSiWkXjHBcFWLKhzLwTIrlS2vXn7fuJTSoOmlWSPfYgKXMpHhM9EnzBIhw7zzNfoxFWpZM4ruFWKOoprMbvznYOKpAjFw=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by VI1PR04MB5853.eurprd04.prod.outlook.com (2603:10a6:803:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 16:23:11 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%5]) with mapi id 15.20.5186.021; Thu, 19 May 2022
 16:23:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [regression] dpaa2: TSO offload on lx2160a causes fatal exception
 in interrupt
Thread-Topic: [regression] dpaa2: TSO offload on lx2160a causes fatal
 exception in interrupt
Thread-Index: AQHYX4sgSGttsWNE0UqPktXtQunnrq0OXLUAgA0i/oCACj9FAIAAD1GAgACmfQCAAAWYgA==
Date:   Thu, 19 May 2022 16:23:10 +0000
Message-ID: <20220519162309.ln2ecihifesntuff@skbuf>
References: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
 <20220504080646.ypkpj7xc3rcgoocu@skbuf> <20220512094323.3a89915f@kernel.org>
 <20220518221226.3712626c@kernel.org>
 <763a84db-d544-6468-cbaa-5c88f9bb3512@leemhuis.info>
 <20220519090308.77e37ffb@kernel.org>
In-Reply-To: <20220519090308.77e37ffb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bf3a2a9-72e2-47d2-c741-08da39b3ddc5
x-ms-traffictypediagnostic: VI1PR04MB5853:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5853A2141FCEFB39511856B0E0D09@VI1PR04MB5853.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmnkloFBdKIFyxYldk0R9oGuIHKe+twZLgpIfYyFviC5CjMT7iBjUr3JNVATi7/EnW5fUvlsGHSAfUVrMQcp2LyfogsajW5ze21d5ziXxs42omHsfBPcJW2js/kJcQ0t8aHkdEgwcD9CNcJ8s9vv/G/ZaZXlEGIWTr5jLlGHXgepqecPr2cOZ34e6v19DPSYsWY5lRwLRat/0CJyuNzS9IKRpyflGeAqpDjXZbQcolIr4/5VuNXhmQY/7VNTfifQgkuNmppkLOZ/eAlnEvL2QY5YAoC7LoihSHncmAEFlVbQzEXWTRdNBBNllSe3EqOAvayVxw2P+XbkawXxGZt6VAn34pk9XedaYbcmMgz7i4Z4Lq1wFoRj0M5g76wL1tQ+7ns1ggMpo6UiehReYmxJ3dj754iLEsbCteWQM3hh4EW1ES1ZSCBUqileuOfwtMRjxC1uccbzYwk/JPy4hRnDxUCdroTB6HjTWlL8uyf0+WjT+4Sv0bM1xNdnp1mk7KbTV3TKf695Tx3rOf7d07rjyp7gGlWgujEGuDhdd3oecBjM2/9POfoW6s0c0F0tkzxWJX69Lupn0yAqUNCVc2hg8Wf1GcOrq4oSfInk8UMB6ql+H5ELqahvW9ahWjTmFAGmdkx7qT0hOX7zvCVysyhVrJq2ssrWP3kaxL19B7rQ+YsScZik1zC092Ec0LZaEQZeT7LQ7AJAA4G0XElj5tXv4942jMy1+RQKtuW5pZybb8pyOMBv1inMd+oKb9QMVWiCP5m73xoae8nsIKYdmvWSeBaLTcxqzhpd1fikHUrBOy0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(76116006)(66556008)(6512007)(966005)(508600001)(6486002)(4326008)(186003)(54906003)(316002)(26005)(9686003)(6506007)(91956017)(83380400001)(71200400001)(66946007)(64756008)(33716001)(66446008)(66476007)(8676002)(6916009)(44832011)(38100700002)(38070700005)(8936002)(122000001)(4744005)(1076003)(5660300002)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iWAQ3qWLKtMVTh7VyIwXVEkrjkFGip6j9iBs7/BLSAxm46TkHNvfufwg3/8F?=
 =?us-ascii?Q?DQ3hZPyAmj5r8IRjq+fgh1zOj/JVwAL1ajB5Kt9tKJGLx+sUHCWyc/EhIEhU?=
 =?us-ascii?Q?6EJ9/Y4uevoG7Ouvq2WCLENd6eMK+y+2Gpe7siOHxWKvck8F0+r1LMYKuXnX?=
 =?us-ascii?Q?VBHK9mirshO+xKTv/KEMRchAAOWuA+aY1YM36lNbOFPsJ2YfQGx/E2snGfBg?=
 =?us-ascii?Q?X8EMJScOUpY3nQTcZ8e6RGzwqKugYqBC9b/BiG/pml4u3A4bxy4WK7oSaw7Y?=
 =?us-ascii?Q?XNKxlJ62iVu0NDsmqS4o3dpt0HMmFwOWhi60VGMZCOxiVlXVH255gnoccyG/?=
 =?us-ascii?Q?xZSiRY5S4huEJsS1HVpY4b9lILqQaJuSyQLXgh7qh3d91BoGp4sWlRzIrRDt?=
 =?us-ascii?Q?jr0qOqHYO8BP5ZiKVn7cJZzOele4AG1zeodRggTjlZDr0/W4pebfpDpIdnm5?=
 =?us-ascii?Q?7v+AcS4M3M0GzJj5nZHPk2BuTnfqYJllXC539Q0YQQY2SDqW/9Y/bKvJ95g9?=
 =?us-ascii?Q?I1jRt6BjCcw+KiCBrWkQFL9TRmB0n9z5SiKif0p6yhmUVfXVl5mMOAjxf/SN?=
 =?us-ascii?Q?T0T18h1m+ILW/VYnS2RXqkS62WbjO2kraOPP3wpT0ILdWNo93ySym9rtZEO1?=
 =?us-ascii?Q?L7DOX7a25d2owN+OkHQeMJNFs2UER5hOwDmjM/XpXOdlvZnST0TOPSfU3vq8?=
 =?us-ascii?Q?Nwp6Pc1/ie2TgD053KSiaE8pJTSG4f0lQAlAYd+LoEgv9LP2CSr7qMZIqerm?=
 =?us-ascii?Q?9fPHHqSZXu5VTWUcB9Tq22q2Z1a4FpEq1yqZ5nC8PUhhlSDSVzRe5RUwp7RL?=
 =?us-ascii?Q?wdaNAt5oM5nwSwR43VZjeHLLnZ62ij0kS8J93PkWFwiNJHzxlaDOyn1Bs+DS?=
 =?us-ascii?Q?GbZhv5sDZUBLrS+7cDZ9Pn3U4Z/8booN0LjtWgDlnHKkI7SyhX87gFxkFelI?=
 =?us-ascii?Q?RfjQE4bnRW5Pp61+IaNxUmONkpnLMdrdGIDDd7nXwY/J/dYsoSxpnb1LsIni?=
 =?us-ascii?Q?Br43Fkq9OyfSubMAzJP9Ii+pGGCewEMnR+nzVhm8I7U45i2PIFaZ7Ijc/r/z?=
 =?us-ascii?Q?WLBaKr1ZgcxCjDr2FeJZHpvrDj6Xg9uC7qQg0j4flXNbWp+yeltG2mColCSZ?=
 =?us-ascii?Q?OYqmoXe1SpL7wS3W6PAHxjuOteWZGZF8fpt55CPwIVFLA8maobsXOE7bQsyf?=
 =?us-ascii?Q?o/OLWd2Pl9aU2jPcPsAy6P6BdF7SzXqtXhjPBcRPPtyp2fCULWE8l4HUEm36?=
 =?us-ascii?Q?2/JkEVZ+zLL0EpeSciL9JU8ZlC3LCUW4T3H4yLDUbm/FxL3N9WlcO6HMogoK?=
 =?us-ascii?Q?jHAhypYDAZSj+rYPLwnztUZtaJghlaS108bXE5XixEVNZLFK/EaOTG9wMxWv?=
 =?us-ascii?Q?dUeLm2uHrpmNAASxG1G+AnBuQubiM5LiBA1ON7WwypXmuDz5oT0j8MwPCP5i?=
 =?us-ascii?Q?cWb3EFwLNjgKLo3uEkVfYhxfyCyGoJvJ2/qCQHdJKTIzmqQ8GnbCEzN5xoCM?=
 =?us-ascii?Q?MeJLaja1q+5CDK9mtbC4FC3Vsh7hnUAp+NyiEOfe4Twe7Eu1+WrdMNpxncOa?=
 =?us-ascii?Q?IU3DnrJwseQI1MoADUhCUA6sBwQxAGMWOHx1Z2rqShqRUwvCRoLKhuX7MPwR?=
 =?us-ascii?Q?UDxt4AIgmNxGwMFsr7wF+uV65nkAFbC+IC340F9I0NHG+aogR4qzMJ/FiKDV?=
 =?us-ascii?Q?AeTCa8fkxuoDjkzNk6/hGvkwPlQFs2nE+Somp/8c0ZHfw3TGFZZveyq39UxN?=
 =?us-ascii?Q?GT5X0Nq77nS12aKurns0G5jTKR/CN3E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A41F92C44B233046905EB8652377340E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf3a2a9-72e2-47d2-c741-08da39b3ddc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 16:23:10.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tIG5K5ZkBD4cfE+YEiHCnzJZhIozB9oZbXqiGyhw0DxzsV0Lfc08H33VGMhL/qmxKF25WOF3va7Ws2YbAcuaUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5853
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 09:03:08AM -0700, Jakub Kicinski wrote:
> On Thu, 19 May 2022 08:07:15 +0200 Thorsten Leemhuis wrote:
> > ICYMI
>=20
> Oh, I forsurely missed it, don't look at the bz.
>=20
> > There was some activity in bugzilla nearly ten days ago and Ioana
> > provided a patch, but seems that didn't help. I asked for a status
> > update yesterday, but no reply yet:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215886
>=20
> Well, GTK, thanks.

I just sent a new reply on the bugzilla thread just as you responded.
There is certainly a bug there for which I just posted a new patch to be
tried. I am just not sure that this will fix the entire crash that is
seen by the reporter (I am still unable to reproduce it).

I will try my best to get to the bottom of it, if not I'll submit a
patch so that we start with TSO disabled.

Ioana=
