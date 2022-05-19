Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0B52D61C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbiESObt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiESObr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:31:47 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5986AA55
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:31:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayyyHwaaS25YK0uWVNqAaBb3wTokSsohUZNereTgBPzaCEBQIiU6Pdvvnncoxi6MLBCga0Qm0ZutxfaES0Zst6dzBRiRyMiY+YkDtkLxOfJ1Cp0bL8jPjqY28u6Q1elDb3xtH2XmahZKfZTY4QV5zP48izchD8QbDSCXK8/KyURyGLzhUlLAqqiUqxHcI97Ns8Mq1ov/Q62yW5AgF2f35Wvd2Uo+m8ScUs8l+cwmgqvQK3lpNWvt7/M76TDCqjpNEa7wep2IevDXsKJSyIicnEUo0qYo6ZstCifrnUn0YphzI/I0+iSG3jEVZfLezcChL/nmBiwrhzAsevmgJmHSQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDF7COXMmAlagN0U5e96BeJADm9D5NT0hpY5HinFzho=;
 b=MVdqbUmnE9RgEuGZnicQJESNggaHHNgAEbHDHmort8zHNbQmOYmBiCo8y5HxXnODkkkEF/5mONAXehg9nhh366f+1iCE8f+/hRdjKLdbUOu8eYq2G22HSU8flu0BcoNhQWBb6WXGDNAg3lgQuKSPfsEPWV9n5rGnvpNNsef639FVJkjpenj3y6eXyzF5nBKsYesn3/4Jg4nq9F2Eg1Ht3AcXV2Cu+vrDo1Vv/M5QGi3U85y7v9Xcv/JP4a/LmCAk20Rwj2tVmRG4qRQPusCmEo57sXaINYHCG1CHlJZpnvDNlDO69X0YtGQ1qOvj6tx65T+UNguKFXofbrJRb01fUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDF7COXMmAlagN0U5e96BeJADm9D5NT0hpY5HinFzho=;
 b=gAoP32wvmR5Kukcwhmq7HYKJGpQj8miBpFfshQ2/h+VGlOZP9t3jMPrYOyf66k4hB3OBky+tNBUlOIkA9w8BIhRitf+H5z0iMFhgaTY+Q8ZTUTBjSwwN0ka8lUkcaZFn14PvLTh9o4xszMfPyDN63yLZ6GPkk4A5mKqHpVS/4K4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7761.eurprd04.prod.outlook.com (2603:10a6:20b:248::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 14:31:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 14:31:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com" 
        <syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com>
Subject: Re: [PATCHv3 net] bonding: fix missed rcu protection
Thread-Topic: [PATCHv3 net] bonding: fix missed rcu protection
Thread-Index: AQHYayRxKzz3kgV1LUq7PYZXsmraHK0mRAcA
Date:   Thu, 19 May 2022 14:31:43 +0000
Message-ID: <20220519143142.ox36nj7uvq2sq3fr@skbuf>
References: <20220519020148.1058344-1-liuhangbin@gmail.com>
In-Reply-To: <20220519020148.1058344-1-liuhangbin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5f5a7b5-acfe-4731-3abe-08da39a44bed
x-ms-traffictypediagnostic: AM8PR04MB7761:EE_
x-microsoft-antispam-prvs: <AM8PR04MB776119867179221AD5111000E0D09@AM8PR04MB7761.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XpQ9blR03cXCc7d65zn40FnIw0+ZZVqG1g++4T2DdLgZ9m4iHJP1TWOGU6kHePR8I3nV0L6GxaD1APwSCiw4CdK/SI4sqv0KZam2hqq3p1GUoQvpoR4VrHccgtRwLe9aOwDGvc7Y1pPt0uQMVGaruEcg/01nvSGBw3CieBLIbV0l/sBcI29+QTHkzc2B7Zh4HuAz4CfnGNqY2H+iVxbKdfBy0M8IFqzhyUK4nNroEaizOs1I/cW/XLtnicgmaRLGai5AhtWAosBoBuIBW3kRa9RR7mIXGrgZOWQBnidqOALvgr02LHDbeYrUfANZtXEmJGi7cFetb7y9aDFEWjO7nk/JMusc2eDiE4VyBb/e6Bo42RjTDBLdJflzGYz5dsTkfZwRvZWfm9IYd1dkgpbaC0iDVuUG0hqZX4SaGwhPZF0HAv6APwF0Wm4mBl2XkPg48hPHUORs9zxI+8HF1iLWsaZFz6GQUXvXL29w2XXzSTsG+PWGGtV7SuwMbyc4D+7PFw4jBmp2MZsy6iBCR00hy3jmXHNfc9qr5oVifhKrjukhuF2jaquUNTBvPBX0efwd74J3ciDCvajgAkoPaxA21ZEUrqPso77qxE4mXO4QyWVIEMkrSKAgq71qk+G+roz0fpl4YjKknBxQ8Qdm2d2GjWKtsZBWrGr0xCnZSyGn7KYbf4W0TWEvZhTDRFyTwm2qlBH+8w7T5zbdlzaVRDz+xgNBMUAHgTsoPZS6zul1vF9QlVW2Ph8pskdgXOGH3ulrLWdyfEm7E1C7wH9ZqHGhFtn2jeGgSGJgRkFMF6ab+Sc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8936002)(54906003)(66446008)(44832011)(5660300002)(7416002)(66946007)(64756008)(33716001)(316002)(8676002)(66476007)(91956017)(71200400001)(2906002)(6486002)(66556008)(6916009)(38070700005)(508600001)(6512007)(6506007)(26005)(86362001)(122000001)(966005)(1076003)(9686003)(83380400001)(76116006)(38100700002)(4326008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FwaRwNYKFXaEcwowLzFRusUeDHJKuiANUAlmnPRdUUXY09vSkWYb0J4y1PLO?=
 =?us-ascii?Q?uhzH+oN6S6k8dyipKc7Uzq/FsFw9kB/rhg4/xhK2BJqhxJAbbHmaSZZYcSLE?=
 =?us-ascii?Q?MChsI61LI9EJ/oNwQ+pax6woZBpcnOo9UfYPOzeknAvr0E2McnDKTHgyTp7x?=
 =?us-ascii?Q?KT9SgqXZ859qD2h4echaQ9AW83C0xiygHxyAzjQ45RTEb0/VB7VzOOiJ30IV?=
 =?us-ascii?Q?GlWAkRu/JLqqnjkZw7FOcyVjv8/GrROW7VtOHMlG9nzifLLKF+G69gkM49/3?=
 =?us-ascii?Q?oVbLywXfPIF6GrBKDqfVXPikkQndxvU57CHlVTdEDaSr+iXOyUsfqsd5CyHV?=
 =?us-ascii?Q?ZCg8Wg+rAzgqmjB2Fhctzi8pan70PiNrUThofkxRYBJ1SFXXknfepThIt9Vz?=
 =?us-ascii?Q?ESw3DKV4lx8BcfyATIsklDtp938HjNDY+2VdbBXV22iW5Y2L98i7GJ9HAvR5?=
 =?us-ascii?Q?vkGdh7vwV8WszF8Lacj2tGeaqr3JLaJrhG6vm+GcPcHH4x0GM8/2SPw3Uelj?=
 =?us-ascii?Q?gFsOlCkX/MGx7ae4Q3ltPxL5QrIj2glgMk5kKbh0ThCKd49o+e4BiunGzx41?=
 =?us-ascii?Q?iO5JlCvnJAVMPYOHkF2lWLd/6sCMkb5ATCcTPMVIZFZxbWVbuyqF4kc885WH?=
 =?us-ascii?Q?siPq1eq/fX0UDqzxjgll5KDUmFbFKACgQbGpLPB/+jUjUvMxNQk8KvCL9Y0s?=
 =?us-ascii?Q?PfnWSJJVV08kdNA12c/SYAFNA1aQCH/W7FZKmL18k4M8QG1ruR9A6ILhpb+f?=
 =?us-ascii?Q?JuhFEIBRS8SPm1sXhV+rXf3Y2tOhLEHJNYlIDtJXypCcKIKEyte6Xrq5id+m?=
 =?us-ascii?Q?PF/B6Jc+Lin2G6Drrf4qvEqLZ+r64emagmYU5jZIGQN+la8ZGNQSZm9TTI5G?=
 =?us-ascii?Q?E9j44MdzPnBZ6gkVQWrSloS2orI2oNquw1agoM4j1l6U3eWWjhLFQL4K8BmL?=
 =?us-ascii?Q?Ez1UrQ4PyI4Byyc/hdsePv04kJGzOWLPESSoPKs8l/JqvD9nXJ5sZnlLbXYT?=
 =?us-ascii?Q?lQ5PcOso5exgExJkJUkRo0JRDvQZfijdcf5MmnjGhDD3jR/RYcIF1KmFCWo+?=
 =?us-ascii?Q?wj0g6QOLb0FmXWPEO4ltJajKnT2oNYjr5etG9ZffN73oTiZzl54hF0dNW+uS?=
 =?us-ascii?Q?5HFVWQG00tv6xA1zx6Ph5zCWSqT7dqTu8Ks79VqCqKJJKXPWB3QoS5GPkZDI?=
 =?us-ascii?Q?B85DZXYpq2AIdPhPt3s5QOjPxA3BQDEKEZogZj7MFN0qOnMSTkcnIm4IOSst?=
 =?us-ascii?Q?i8Qfcp5VJ1LqFL20E+0gGtXhlhGA7UwmfcjtPwhgqEGCAWWZs3Ejg9ZwNIe9?=
 =?us-ascii?Q?sr8BZbxglMexFfhFA/xexYDCAv1cxp5KXSENxzZBn9Tk5VDIZZxQqyUIVv/Q?=
 =?us-ascii?Q?6QEB3ekYX4W6YwdyxoU7mG65r1k3sCorPE/OJXj5YkPIVgx2P65rE19OlVhN?=
 =?us-ascii?Q?HG62t6PEIMoysln/BqtbqqxzrAFYsoEm93AhlTAwut2bTOl08QrvfNUKdggc?=
 =?us-ascii?Q?FjEIoST1ljyU9Y8ldDcunPxjrViv9j2OgikkRKRyBLZtO50garFqfLuYL6+Q?=
 =?us-ascii?Q?kzD/7+KfRox1zLtRRDoJB5EhOw9WM3B2s27HJ80UEV/uZD9y29juekknupg/?=
 =?us-ascii?Q?CpAmlBe3DSt92P5sQiAIiqVDDM+5eKdVhOe78sqTDgHsbcKB8yWUeIJ/fq7O?=
 =?us-ascii?Q?mFiwIAG+Pqi2SH168KmHmkcrHFOz+IikpDPzzxj7XjSnWbjNwR+xRnuTMsc0?=
 =?us-ascii?Q?Ym4wmrEA+7R8vgJaHEbsOzVnMMx6vQg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E2416AA1906534382B589E5D00D28A7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f5a7b5-acfe-4731-3abe-08da39a44bed
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 14:31:43.6979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NHIMUQrYKh+PxvLh7JxTNeDOPPUBwBiBcrccfDn4loRPfBgq1DbU4GjMXNHGj0n4txgMyHFTY6i1OrvCFrkzJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7761
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:01:48AM +0800, Hangbin Liu wrote:
> When removing the rcu_read_lock in bond_ethtool_get_ts_info() as
> discussed [1], I didn't notice it could be called via setsockopt,
> which doesn't hold rcu lock, as syzbot pointed:
>=20
>   stack backtrace:
>   CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller=
-01392-g01f4685797a5 #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 01/01/2011
>   Call Trace:
>    <TASK>
>    __dump_stack lib/dump_stack.c:88 [inline]
>    dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>    bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
>    bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5=
595
>    __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
>    ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
>    sock_timestamping_bind_phc net/core/sock.c:869 [inline]
>    sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
>    sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
>    __sys_setsockopt+0x55e/0x6a0 net/socket.c:2223
>    __do_sys_setsockopt net/socket.c:2238 [inline]
>    __se_sys_setsockopt net/socket.c:2235 [inline]
>    __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   RIP: 0033:0x7f8902c8eb39
>=20
> Fix it by adding rcu_read_lock and take a ref on the real_dev.
> Since dev_hold() and dev_put() can take NULL these days, we can
> skip checking if real_dev exist.
>=20
> [1] https://lore.kernel.org/netdev/27565.1642742439@famine/
>=20
> Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
> Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding =
active slave")
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
