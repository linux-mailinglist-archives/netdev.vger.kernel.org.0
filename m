Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B50580226
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiGYPqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiGYPql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:46:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2056.outbound.protection.outlook.com [40.107.21.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD7DA443;
        Mon, 25 Jul 2022 08:46:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+9dI3dQWh6RDt6qe1JndKHbMpbbW3fKnm47r1T27FpNUM+w6VHOk1K9KqgcP++kemb/v2uwN0NXjR3Wn+SeCaR6GBJQ79StJtC4EOX1polea34ykn0kb0VRYk7SonbsZiMkkme31wUBgeUcLK/Sqw4XAcHen6YfenxflnvIEldC2+obD/On4DTw9KVtTxCqlddAJ2eB2RNpP/B6ad8iWnwlq9ZB+jkjEDTsZAFRtYWEsH2ovgUr3VKV3CB3CP1Kg7MZ0r91flWAKx4upUPa4l7V1v5DbOkXx33/NvsdIqeFyf/3/PxGx3Xo4iBS5wZQ5In+B4z4EfOY5opyMeSYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0l9UoGMg21vmiohxIaRWIyK6/EIKEkNVummfUkO0CLg=;
 b=Bhq8lv0SvXAQXLmW6lExvjbWvBx3o84EtQQKwNDCSXByYoAhSSZFjG/OvsWnXZVAZ6Zsi6NYBAZl+DlLAMqq02QpPtgXYqo1B1LofKtXyYNDTaZnHnwnVB24TDkevTTKVvXuaV/gEdwxHL70/8s08HQwsn/SIKmcXPxHNFGODkcx3KyG0AKC48aLmLpbw8JGwb4olCcr0Ahsbx0hbg8wA/PSuHPMV7tHSK3p2O+F2K6S6OMd//wVDUWkEunOQLi3k7dNjG0pEjohCv4b9F5lkekWrfsKYnyhpN1D4aY7MLn3kUjBvmU/DLsJV9YSCzMCrc9euD4e6FRZA4Yz9a0tAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l9UoGMg21vmiohxIaRWIyK6/EIKEkNVummfUkO0CLg=;
 b=goFrSb4zB6uhLgo7/ceu7U0mrlNpvjqC2gzyflDEd+o36ldMn0UxHYm29Wb5krINYLAX8G2I+lZVaxbjV+6BkWPyfmEElQMJYoVJL79PszdYA2puEV8a6Fk/p7StamaVmPKQWskSlikH1pqP/382tTZdvsPaokHy84V1OuYC6wI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6071.eurprd04.prod.outlook.com (2603:10a6:20b:b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Mon, 25 Jul
 2022 15:46:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Mon, 25 Jul 2022
 15:46:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 06/11] net: phylink: Add some helpers for working with
 mac caps
Thread-Topic: [PATCH v3 06/11] net: phylink: Add some helpers for working with
 mac caps
Thread-Index: AQHYoDyCh+mIA8W3VEWBqR7iDWfkxa2POWuAgAAAYoCAAAEbgA==
Date:   Mon, 25 Jul 2022 15:46:24 +0000
Message-ID: <20220725154623.ynt64sgphyhm3wgm@skbuf>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-7-sean.anderson@seco.com>
 <20220725154103.e3l4cde3bhgdl65y@skbuf>
 <2c7b01e3-0236-3fae-7680-05a47b9c266a@seco.com>
In-Reply-To: <2c7b01e3-0236-3fae-7680-05a47b9c266a@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b47af1b4-9df3-43eb-85c4-08da6e54d431
x-ms-traffictypediagnostic: AM6PR04MB6071:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iZCg96++cFjUghmqtaT9HdcyDN0J5VkkgQUotzk5qgZejpkZHMQGC25Ll0Bxp/6VnVdhAoQpEMcFg0/titJHFOV9cESVXgUbymTpG481DNkc/MpL/e7BL6QKmwdwa1Vpor/q74Nm9Xpg2skiqdRg5Et5aPgHcP7Ogj9iUGGg+WmGcQRZxGxOTQg5qhOFWfNnde+xkknY3r4YoGl8W7aCE423re139BSYE4J6b2zfnPWAQd3WkCA3M9sqtgzWx2nO/w8uG30PSBpMFVHxJHRoYPhNLx8F7sCQ8CVuacjmm78YZn+heHdILBoPE8U2Bp5U8vHh/swtbSg6E3QLN30e7mbgbKqhktE2ZWqE+YwqPUKGf937mh700LOuMUxkx3Mv+paCk2Lc87ESiefgd1khSXzIMHkM/nqM8DlPgFeynTIbl8Qb5u7SH8DZhmJAVWKcXQZba93abObbI1Hr2o9YTQ+awkV9zDhYDmHJ5VlB124hgRbZfAA8wl4j3Yxc6aKx/j6p93CuQ1Up5YhvSUmOSrFQBXaXDax8B3mCDCgN3o4vjTrUxDt+xHlJRUw/N64HP/+zCFC67feOY4XKzxRT/ylzFQPB1HY/XuCzo+kmrE9VZlogh/m7zszujy8J0alW1tsCkkziVPjMnzI2foJp4oTZ7e+Y8xQxyy0bfzJproR8NbaICJub6F59veT0oh2QGCCheFq5Uabro7Fdhkqrd5Pl/X9HErbcGUbX4Py3Fs7wjyAM520riG9k5ayJLxeVklmV4CEXnCC4RW6bFusQUIMa/cFPGF4YuK1JAMUepNLEkR9ycrNH84PIn1SFetZrwul0Oswp2DBjl5epHhO4gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(136003)(376002)(39860400002)(346002)(366004)(186003)(66476007)(316002)(66946007)(966005)(4326008)(38100700002)(76116006)(66556008)(1076003)(86362001)(122000001)(478600001)(6916009)(64756008)(26005)(7416002)(54906003)(2906002)(33716001)(8676002)(9686003)(71200400001)(53546011)(6512007)(5660300002)(44832011)(38070700005)(91956017)(6486002)(66446008)(6506007)(8936002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yNZmvjAlzG95PAXAPA/8/K1ZttcRBwBiHav8r6ojOiXXNd7WVsD5v65LX3jE?=
 =?us-ascii?Q?ljjYY+hdOHvu8teSFq92ocEnD98SYPL2kREj5lGnhWw06hUpKNpLGYzsxDno?=
 =?us-ascii?Q?4M4aCQ2/u7xT+W3HQdCKljG5JSbpXCn7OqrQayrZ5CSuUh+RaDt4EqNHfI5b?=
 =?us-ascii?Q?QQoNAfd6fWCHZXg7cJtoeNHuA1/J7R0J7j3DgIfwFsEYrEDgf/DPcTuxquyj?=
 =?us-ascii?Q?I71oXqUaEkVaaAGnr2DIgnSMwpVu9Aso3K2u3G7GgLomg4TdNMabIfJEa2Tw?=
 =?us-ascii?Q?HdrMdrfCF6zSVBbW6wh87acr5R2OsobOI9PsVtbIExmXBsm9IYmvNlo1Wd90?=
 =?us-ascii?Q?tQOhN7QC9mgFXsCmPnqhDklosS/XGw0s0HMe2dhDtGMSHx0YXnxrDFJUDpGt?=
 =?us-ascii?Q?tanVio/98BdbsEQ9tZQ71oXch+URsPxo6lnZA0X0JrZFpAaeIjjRtnHo1HFL?=
 =?us-ascii?Q?+XOEHl83eUhq+DYrC/2LUSU7R6mAp3sC3ka9OMlmhTtuiJjeLp9reCIzLwFv?=
 =?us-ascii?Q?P/Y8G9+kUVkoaVT44wCJkNYFb6O+y/wflffPzqGKiscHN6wE3r6TjjKEsQsN?=
 =?us-ascii?Q?s0HJuesBFvBwGsi4eJUqcVKiw2lTmQtLxAwCacL6UgGLDVy1SiQNr95v1cNH?=
 =?us-ascii?Q?8vE4L1oZVY1OdLgEpD+IEflc0jKvckAO49kJtUv8d2K1yjFoO6/hBp4Z076T?=
 =?us-ascii?Q?fzW8oWE/sF7dZcr4CrAjD4jko8hi5ABSmOgdbtcuNa5LF1lSgqZtVhtxq/yH?=
 =?us-ascii?Q?+gBV9RJLiIgHw4972PUnvdI3RUHPmkajMWdOtMTnYB+5hzX7z4zeWXsmWWjI?=
 =?us-ascii?Q?vkSAOtLE5bYLjA7yUqZRy6Mc7tyHi/5tXVb6fPRGXRxgDnuh33iZxM7Q7D/G?=
 =?us-ascii?Q?/JZX1zQdA7qckCBnZY437lXaZmd9vc1fEYYiAxMsNAGnH3yZ+uJNQN+E3dQ7?=
 =?us-ascii?Q?KhnHlAOH2OWBs/kB5H6T69eR/SmkdzRXUArAXRgDe2CbE8/7iaXnSHvkH+hK?=
 =?us-ascii?Q?CQuG0HpbtJv0waKq27Oi55F4njaGi681JwbKsnFfX6jZR7M8CHXJUFJHIHqq?=
 =?us-ascii?Q?nt9Xa6JSKcGzsf6reqI1lEpEXlNx5aDle37yRbSL2Kw5WCmMrjOh0f486nJt?=
 =?us-ascii?Q?JW9aTLMj4Sag0ZO7CyPFyaY66WLwQ69HCkqrBfQXXSfLa6/jbeDqoY7CRFVX?=
 =?us-ascii?Q?FvxDm0M8tlOffr6JeRPctR8oxyoLA9GINGwH8crT+tTErvZMgbpHlemB5wHR?=
 =?us-ascii?Q?8hjDxa4kbS6e2QDyoI9902aXTY+EOl1a6cfVyz9ACi3QlvTcPk9k/d1/WzhR?=
 =?us-ascii?Q?2Bwdhx0yHKodHR5jcZFAxNF8wH/Sn9FH5Uwo9BgEMARPRMPqAi7MZ9U+F89R?=
 =?us-ascii?Q?JF+TaChZjghc2u2+jxtEvGqLZwHWDOz3ZCyZbl1sl6DMKunkrUszMIctX56V?=
 =?us-ascii?Q?gW1sUQM4sB9H6fmM0PFKeBhEAkg+L/ayVGRG6GMy/l+UbEfwDPtXIu3/g6Lh?=
 =?us-ascii?Q?8dyTiQaC9kJ8Lhmw5DYc2zHOSckoDBLRhIUPA0WK0DQNaJr059UscjayYBrS?=
 =?us-ascii?Q?PJuLV7LvfBNI3eNLvcHGHHffMpVn1eKcAYpZodyKnTy7tS+2azd01k7rp9Rw?=
 =?us-ascii?Q?ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <59E186851D63C34C8543BEDDAEDF1065@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47af1b4-9df3-43eb-85c4-08da6e54d431
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 15:46:24.2357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1keuD5IMc+W2sYZw5tPTGA1bK319Bqoek5z3w3ZSAQMbEvggpHAbuSBdfqir2rJFIk++WXi3XOE8nNVkCx6BvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6071
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 11:42:25AM -0400, Sean Anderson wrote:
> Hi Vladmir,
>=20
> On 7/25/22 11:41 AM, Vladimir Oltean wrote:
> > On Mon, Jul 25, 2022 at 11:37:24AM -0400, Sean Anderson wrote:
> >> This adds a table for converting between speed/duplex and mac
> >> capabilities. It also adds a helper for getting the max speed/duplex
> >> from some caps. It is intended to be used by Russell King's DSA phylin=
k
> >> series. The table will be used directly later in this series.
> >>=20
> >> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >> Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >> [ adapted to live in phylink.c ]
> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> ---
> >> This is adapted from [1].
> >>=20
> >> [1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.o=
rg.uk/
> >=20
> > I did not write even one line of code from this patch, please drop my
> > name from the next revision when there will be one.
> >=20
>=20
> I merely retained your CDB/SoB from [1].

Yes, but context matters, the logic that you cropped out from that patch
was exactly my contribution to that change, the result no longer has anythi=
ng
to do with me. Maybe you didn't have any way to know this, but now you do.=
