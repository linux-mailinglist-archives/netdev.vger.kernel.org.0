Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEDA526F5A
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiENCwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 22:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiENCwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:52:35 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150049.outbound.protection.outlook.com [40.107.15.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB9630B2FE
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFj9HYKyE0UYZZkCqRYdYwe2oZtP95w6F4dq8+4b9VIuNxXEpPR/B+ztPvQybhU8K/t4ahhUoFnsnYzJrtX1m0GKB2aS165aPKWD9mxwymc2DK8Y/npXOevoFpF5B0HWnH1cglGB5thaFeIZXgMDOzX4QKWN+YXUqRdSpnmcOQ7Dha2rhQDk6cyD3laj7I2gpoubO4m+Kj4z0mcSfwc3Oos+Asd0UjeZCYq0kqYxEKnd+KzBinn/0qHS2ap1ILMnjlv1aK0poXYh5sDmvR8UGOlXAUV9lIYfLRrQAoHSkXHh5cpgetLcpCoXPK4u+/JnoRekCFzpm2367kxx2N9OcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BltCdbTJGISPEcBVxeLeVBcb4brb5yi14waEPPnigzg=;
 b=F4a7+UkIAaNFFImiARfcDgsCIsgMFgsLWZ/qJICw5k40UAvrheMhMHAEazxuKPKlF8l21HG38vyNLDVY1mqk0eNT6kAJmSyQV5JSZJG4lHc3ZxDaUvsZHmLKo1qvdCDtbb+uzY5BSJOD0+Ee1Lwo6/0aTWv7U6wQLPGUToKtNmnaA4CIgMftVFEO2rd3gdjy2U5Hi01rex3PGF8KNz/xmSCYq5bccCdZD4jUm7jP4MCVp5ooge5uHZe6BjBGMT6WXDOOJmJrUuzJgGRekTZXPXB6Pyc/KTQCGOKS0rJJvydAx7Mo/xXsjOtLDXYG7dNfTFx2+VnwtLfyPCMm5pRFig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BltCdbTJGISPEcBVxeLeVBcb4brb5yi14waEPPnigzg=;
 b=o2RStjyl9A/7wv1eUJIDKpGfPvIfIn/xt51ULLpStLFL86wv9zYpku3z2/np8T/0GQe8N3la2IjN7K3VDbS5qTn83v/M2dF+6CeB7jQzmZGp4FG8hKDKNIyJGZueNCYk+BCxzkxBBtKiAvJw8F5oYGDeWDevwV9BTteDnBSRpH0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3770.eurprd04.prod.outlook.com (2603:10a6:8:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Fri, 13 May
 2022 23:59:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 23:59:18 +0000
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
Subject: Re: [PATCH RESEND net] bonding: fix missed rcu protection
Thread-Topic: [PATCH RESEND net] bonding: fix missed rcu protection
Thread-Index: AQHYZrT4uJlvsiW3Ukim0F+8NWxzjK0dfX6A
Date:   Fri, 13 May 2022 23:59:18 +0000
Message-ID: <20220513235917.ptywcm65aydz57sk@skbuf>
References: <20220513103350.384771-1-liuhangbin@gmail.com>
In-Reply-To: <20220513103350.384771-1-liuhangbin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba8dc4a7-a98f-46e5-c711-08da353c97ae
x-ms-traffictypediagnostic: DB3PR0402MB3770:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB377001EE8920A953EDE53F98E0CA9@DB3PR0402MB3770.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mdf4ni4GI5Ysrj1b0yFmjwGDxt3tsY/nYbeaTecEPmlX9aIeCS7tK31dRaLrr9N1J7bYTvm9RIxPrClhb/dtxmmBkPIFLeZ1JzTIiY/o3zobDkR0OLms0VbbHanFvUM+AauoATiXzRYmr9nQFES1R5n7rGsaOH/nohmaKlk7Bc0w+v++CvXjgU4St6UrtShAJ2s+hu2k5GmDK9dM5QNoSFUjEDor1dnqLX+YPSIoNdY1UNbW6yHD+2amOz6QjlZlw6m/RkSIw9ILNiND46U1D5VfjxDLhAAdgieDBEHIQDqHB9tUPG1Yz7MdB34jyVTW9GmM17Isg7ekrZw7WnoozRWYPZ94C7hF7rDCoqNikqUELoVM1Nc1S5zEQ5I3Zrw9ZtDLvdx/YEdj3AUHXRL73I6kMQTgh5qGpoBCzK4/ZE9OWm7iqOXJ+soV/3jtnF9E8RPlnRYkJ3Scn7Ep4PlOTBNOj0Tlg7+7BUxMxZZB6O1XnvJhveWngrtHxp6yJ9MhcNJODhL7vFba2EvYRCuiKu526G30N/4AuVcBvQkrjxR0De0NMBdrxSWmrN7mxu1ds1lOt1sz2l4bV3YIDN/J5lRdO22VQaWZufEm/z5l/uw+ANZzlKbBR/uNCU5Fxo5WaUavPUp+JSeXjEZbie7dp4vaTzwzGNt8vxzSZbuzHjc/TEWYS1Buz7a+1C+Oz8ZB+Pm4kw1180sUJf4YSkf8qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(7416002)(316002)(66946007)(9686003)(64756008)(66476007)(6512007)(66446008)(91956017)(8936002)(76116006)(8676002)(5660300002)(66556008)(26005)(44832011)(122000001)(2906002)(4326008)(38070700005)(1076003)(38100700002)(186003)(6506007)(83380400001)(71200400001)(54906003)(6916009)(508600001)(6486002)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HzcyKjtSl5l0WpSKrUY0ch0itmY7Yo+qvihuWgaKwhjDrwl6ZH9dzlIlcS7q?=
 =?us-ascii?Q?HL+dYVmWuUTfF+Jclu8kAI49yJCby1xkH0QaYuGIUfsGQpempGw2Q1Mzf4Jf?=
 =?us-ascii?Q?XLy/VCyyo+kynwvJHhVxHaDltgxEunLkfFueL3qVneQGx1eelGlx5k9BNCTb?=
 =?us-ascii?Q?iJxLHg30OZTbgcfaDBFN86kM4OhOnlAkpAtHipfTNqnwOlG0yWmUYTl93C0B?=
 =?us-ascii?Q?g+thJdX1LaNJ3HU3HmJ0WwJDo5GzRqPUKp4yUQhJxMuVhkajiQmbLXpcuw3d?=
 =?us-ascii?Q?2utkodvS0szpdMvQJPp7cXxpORZZCyLtRchO67t57kkktSVqnZ42WNmD4Ky/?=
 =?us-ascii?Q?drt4cAFxmhYwOSCnLnFHk6soFJqD0OE9yCKdn/dzboWPM08lBAJOyainimtR?=
 =?us-ascii?Q?QpIylCCLcjLKdpGcd3ZA1ulJ/Oj2oNzC7ZqV/KarZQJLczL3sWBUHRNSDWdh?=
 =?us-ascii?Q?glkvLw0RI3ikmV3Qko7igCBrsCJUh6dNU7sQJfbR7XJBjDbJUiieb1mmSh4G?=
 =?us-ascii?Q?xD0TwtHjjDN0gFAorhXPjWaN/Mst1o4dM02fxdg3VhKqPQeGoW0HmFtRKE4n?=
 =?us-ascii?Q?VHV0npVs6dVoVMp6uvCC0pJ7f2ZT/q9rBWZlQoU6IsJ315tFKQZTq6iFHP3q?=
 =?us-ascii?Q?qENPgKnF0fDtHqkGrbBF+3psN2EWOKovkFpiYKG9Q8o5gJXcrPwQejA/LCVp?=
 =?us-ascii?Q?pF8OMiW0HweBiSsSWC4YBbZIzM3bB8mR1r9/y9q5HdFA7eUUD9WAdSXaVgIL?=
 =?us-ascii?Q?kZPdHlQltu8sSOepnHz7GCTcI0ldLI/PgbzBPjLTCINmzjNsNc3mNE18Cnix?=
 =?us-ascii?Q?yUZKd10b6oIezI8NpCTA4MHexfBWv8frPvqBawK3KpRH25SMp+kFdhpio6v0?=
 =?us-ascii?Q?bJmsLopk5Bp+nZodZ4W1Iovhs/CV46Tkaks/JAUg2rWh6gPlEhjUkWJGzxV0?=
 =?us-ascii?Q?8dq5NJdG6TiG8VSyIKj0AEQQaE75gON2sRikHILkd8iRgl96fidZG3ENM7pl?=
 =?us-ascii?Q?F54I7WieNpJmoYArlJ3DvtoYRTpKod02otk1qjDc88+/Acf10PTkaZVod9Pt?=
 =?us-ascii?Q?Gd2mdrz7xQ0Jabuk5n58Oy0g6a4xGy7nKEQE20lCZiONSuzt3AS1srP5taf7?=
 =?us-ascii?Q?a1UMJoO8aTiOKOmlDqTwMIWoYkowe703QWfaw/tFRABl11/U+jH2z4m5t32C?=
 =?us-ascii?Q?Rifevrlp2MPJA5yRmwx+oy+IUcE6uIbHOaA41zWi8CDx7g9Aw6v7ZrIefIAR?=
 =?us-ascii?Q?ju2F2YxrT/thyVaJe8ekvO2tmvOXlXuEhSzqPSyb238XXftM7w10nFYnLuVM?=
 =?us-ascii?Q?U6sw1/SJq1B8gnU1MU9JZgJqIWJuiYbJ0unEC6AXYAqSWygBpFJwCVgn4p1U?=
 =?us-ascii?Q?IxmdGV/PGXZ+d787B8wxM3ak0gXjbrqxJFFceoZ3mLbAReRV0maWAEKnOnfg?=
 =?us-ascii?Q?QLCZwqqtcgzcJS0A3nKe6NhsbXaSCMRbR0z1HjdutS/J1JSFtWXhEowhAerc?=
 =?us-ascii?Q?eQ5B+UW1xjrvlrpZHhXVkWSnKUdfVTqv5COGBZIOwk6TsEtBcTuS6JFlkWJG?=
 =?us-ascii?Q?KUSn2xexSI+53Tc3kBI1ThCHGZTPu18xzmwj1GB1JyaopHdbfqkwt7sLo9Vw?=
 =?us-ascii?Q?r1gIfZi+h8c22e9eNDPTyi7dJf/22MTiVsXGW2p/iO3E6qWj2S3vNYMreP/P?=
 =?us-ascii?Q?5JB9b8UuYmRSyBZYTt9jYLvZbmL/Ptp4naLOzQ4IuX+exHAleU/fA9jrUC8S?=
 =?us-ascii?Q?Tvp32Fi/XbP2NYX5Vwg7RXrxbP4fNTY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D3968779EB23D43A4793FC7EDEFB7A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba8dc4a7-a98f-46e5-c711-08da353c97ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 23:59:18.5001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 908rOIBNXcYcuwfodnEFWdUzecNZDIWNqGIwJJeDu6zFqCH7EJ+d86QBJBS17AsWQBx5NU/N/I7qhR472uYLsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3770
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 06:33:50PM +0800, Hangbin Liu wrote:
> When removing the rcu_read_lock in bond_ethtool_get_ts_info(), I didn't
> notice it could be called via setsockopt, which doesn't hold rcu lock,
> as syzbot pointed:
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
> Fix it by adding rcu_read_lock during the whole slave dev get_ts_info per=
iod.
>=20
> Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
> Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding =
active slave")
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

General feedback, the whole stack trace kind of clutters the commit
message and you could trim most of it. Otherwise the patch looks good to me=
.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
