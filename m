Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0976C5F9E30
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbiJJL6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiJJL6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:58:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFC465D4;
        Mon, 10 Oct 2022 04:58:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/87/vhYv+nc0eHrWdIiGY8RgzcnomYunMEq518D5r4/zQ/1ImVC86HwayojjXpjd3wmOjSFOmYMuSsI0E90ztgwJmpRxgwLYYl62N9kb2BT5yEJ/URdt/S0uO+KP9s8O7lg8ZTZe+T/EK5u6Cx/3wqLkAfWgmiQVyQFb6+TQP/oQn3YlAvpM0u1vqqiN1njZ7eX0d00EnAeE0ZDVR8NUgsEEsLnF4XliVdzm3l0wh4uCcLn9EbkBo+bKHmTM8tiy5cghdTmwgxcnR30lJaynMi+kHOXWImYU3LHn0AI5ZN+ozbYj5oK+Jjky/c3fIZOlCLcteqK7XtQ6m3RsJB/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLBbLPBR+VX0t39Qbi9Kazp+clpRMV9fJWECYvj78HY=;
 b=kF6cJ4xA3vuS2FQrPbQHM6UcRxEFYhqVsWzG13oRwtCOgf8+h7fWrB0gQHAbu/IzshKiKlS3aw8W9Rn1fE8tvXVlM7ttL7N2zcW/rs8CZezZRWpoFrObenZIDMBhaQmy8BvJMfwZxp7wL986gX3mrDhRB/7gVbAcdo6nF1VjquTmMPzTbxcRaCc9YW6pCfVXFUSxG8idYZP4gMak8GTCK3OQMyR7yD4zPk/6dVaFQ1wZnmosLc1LKLm05zCdO/VP4UvIN1OJjxFQHzr7vPGWciumNFipEftFcLoqX/ZlTjarKvfTzjL2mb+GZiysc60QDL8YzvoC/BODwXngCwTdZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLBbLPBR+VX0t39Qbi9Kazp+clpRMV9fJWECYvj78HY=;
 b=pdk0Iy0VPAyI/9hYDm7cDCVV0ZLLYSSyaHnPzwRA41Q7VPv7wXjWPxqbgpOhz5SbGn2jyoKhbhWks3OoQQZ/C+aEizNm/AgYK41JVUdAiOBylPd3cbaQAfbYiFaYntgcLhViKR861HRN1JqQ9FuUe220XziCuidsFI7wTop+TMA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8282.eurprd04.prod.outlook.com (2603:10a6:10:24a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 11:58:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 11:58:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.19 34/73] net: mscc: ocelot: report FIFO drop
 counters through stats->rx_dropped
Thread-Topic: [PATCH AUTOSEL 5.19 34/73] net: mscc: ocelot: report FIFO drop
 counters through stats->rx_dropped
Thread-Index: AQHY3Czle6uZNn/1Fk2h6S84nLKWJK4Hhs0A
Date:   Mon, 10 Oct 2022 11:58:15 +0000
Message-ID: <20221010115814.7zag4ivzuwh4psm7@skbuf>
References: <20221009221453.1216158-1-sashal@kernel.org>
 <20221009221453.1216158-34-sashal@kernel.org>
In-Reply-To: <20221009221453.1216158-34-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8282:EE_
x-ms-office365-filtering-correlation-id: 79d05b71-cd2d-4fc5-0100-08daaab6b69c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6pCW1ZfdUOImUeMOB11031x2HshVhzaBNMcH15tjt/LJ9iSxUpx0wMXBaM6LtCMNmnO/39BfP+42XgVab2f1txSEvoOuiwCncBiRrBs7naPQhRIV+Db8bvRyu/OFV2qSJfwyclWkmEhi/fhkHVYFSrXvMJjp99pJrKy8vxlYQBy33EcLOsszZJ6FVFcS7bMzUZ0jc48oc7yKXTILspKoILODMVzx6feocW46sNMoufBPS3K1BuCM2dupJmXkzYXE6qv3MTT03zBfrII7wzYNwiMvg5lh6BdoPFCt22W0rJHdw9T9f/SD42HpOtDUnXFHJ8DGA4hxiogntXyQhny9YhWo8lJV4ISVxoXZBrjx/UU/HOoG2e4UYGk9vXVH1aoMUNhZ6tKUkuCAFlaM6vRylyhLnU10/8Jo0SiQcCvVRJu62RPCEFwR1qivgN6WT/PDQXLYChbZ1+WEzFNu4EsJO8lcAhKuRbz7ukRACLg5DladIXf816Ob64mIHjx1MNyzJsmTU+oTNl8BUeinkCKTkQc2IoyXomYD3/7E3QnsCso6Edxaa2/82tzRJzWZjifjaKNvm/eTC6FsaEVZCVWbGLbDSGwF2UafGVgaHuB8pWvXdCzFWY4o5lmbNWTbT5Fz9E4Ach2EaMDScQHvEnK5CUG3y6uQk0Qa7aVYVCVdos7JIhib4h9UVPWOp4pacg1w/5lkTBK8gad8BYZVKmlpjJ+LyM5C35RPg3FLuGhls1E14qZmq7RsuaP7GVRqhaFyLxJE8rqG28QplHdebl0m+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(76116006)(66476007)(316002)(66946007)(64756008)(86362001)(66556008)(66446008)(44832011)(33716001)(6916009)(54906003)(7416002)(2906002)(8936002)(4326008)(5660300002)(41300700001)(1076003)(186003)(38100700002)(6506007)(478600001)(122000001)(6512007)(71200400001)(8676002)(6486002)(9686003)(38070700005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CiL7ZhgQNAj+GedPsiJWeDrK4pwJQoDNOKrJDBQ3TyGLm8XKteATorPBCobR?=
 =?us-ascii?Q?EOyI98/vlNkOmDw27htFVoVcr8kn2Meje2GiuSRDLWpb8VYjFUCiRO76CjgW?=
 =?us-ascii?Q?Q5s0YQKzJRuzcpDNBZHp6ygYaQUtV+sZ9GNP+hYVTanXoGU0P+hcpDsqkD8H?=
 =?us-ascii?Q?HqsJA+81gfLOhqUn4wXxZvtGrWDCiomEGq7NCxjUHA4jmyTwWezJPTp7XFP1?=
 =?us-ascii?Q?gzzTY4EZVY9OGaZe03fGmxLZcHMlRo8laVAM2g7nGnJulUEnbplGWX8MKRKu?=
 =?us-ascii?Q?kasJ+1wgRlRDvpEmYaJRs/g5cDPvUmJv5e+w63hTgUoO2xbjZviPaA2ikm81?=
 =?us-ascii?Q?NlMqhU5nx6x+1VYv2GnaoaqXigG2WlnIWUaYYAGX3ZwBXEX9FMUV+ckP5QvL?=
 =?us-ascii?Q?9o51XyM/4CKu+RAIqhl4oB55FFmGL3dmlWJ+4s3P3GLI35+pVOqDqE3rVVLa?=
 =?us-ascii?Q?Nl+hcp2AgL4RQABftkxSZht0R5SPN46OXaITXEr8o16j+5ZfGlEcL28PiAMe?=
 =?us-ascii?Q?+wyh6r0GPzHkMdyV/dFL7cptKSPSexrHmRGNqkHjw/yBeYd0pcBFoMrTK5FH?=
 =?us-ascii?Q?lzCrO3KkWUL+bVpTPIF+jXj5m3KuDABvTIAafwJ837Y7sgemT6FdtSKTDP/n?=
 =?us-ascii?Q?TVsjwvy1ICAE9u3pCLmsHfKuEWoqhpbMmzUPeRkj9n9bZjmAm71Ubm3ywtZk?=
 =?us-ascii?Q?Wqwz4iLrImDmG9rYBNMNOFyIMijPxSwfz+3BWTa0x3ke8iF7+2f7/MV7zzVv?=
 =?us-ascii?Q?bD2854O5FEDI2+NQeh1zG+xnRxsqrlSrP9WgJyLA7WtPpkHHzPBBTYoxXzt8?=
 =?us-ascii?Q?hqPyQIX9JYVuJ0VDAUUNbj3CWxbN12j7xEQBRXbr997Z8q/BJxdE1MUmq9Nk?=
 =?us-ascii?Q?jHC9NujEitTcCFnU1Qiuog7mch1hSIfaxQ0SkFrME0lA40rleOgQeUkY5hQi?=
 =?us-ascii?Q?3+dXOh/WIC//639r+aNQj1kOMI5GCcCpvJlDmKgduvjTTl0o7HYMQorbdHP8?=
 =?us-ascii?Q?piA2ZpZNyqgD+eNVDT5fn6YHjkcm+cBXdkdwug1nND1k2dtiHywXl6oLsVUn?=
 =?us-ascii?Q?qPg4bZLNmt7dc8gmFhFF9Rgm81zmg7CYStaiv2+Pal8Fcfm9fK/c4ONI1sW4?=
 =?us-ascii?Q?qG4DS2SsmeNhBNKOwHW2dE4na9Nq5nIdRfd44xsV66DbeC4FANiD4hL5A6AD?=
 =?us-ascii?Q?DrzMo8I9oZt3y6/peaks4uqBUItnIkk3CgKQ/7RBIEMv481slJoTfJhH/gkz?=
 =?us-ascii?Q?37sfwOpkpArmcxOvs53Pkx1hVszZp5Idw5dumTtstCeumJDptIe14igndA2c?=
 =?us-ascii?Q?z05g5N52qdbyjZgwyW3pdqit+wihWMA8yOlu/2wzLABLZsFGovX44/oq8H0a?=
 =?us-ascii?Q?zzcjZcQ1VdkhN1Cszm7D4ycr0Lt9RPtie4RhUc07vYMIyzvRyFehJoAROOwG?=
 =?us-ascii?Q?E0ER888KUE/dt4aSsvj/D4qa2NWlB/TULH8oEhEFwJh9nmKrwa4RLweSUHgK?=
 =?us-ascii?Q?MXQrhZjgVtVvPsps/QE2PEaYxzOAGyeu/0BIb0hCDFS4IP+WL2HV3CfxK2CL?=
 =?us-ascii?Q?ntb7y/ODer0P6BPuSS/fj62WCSRtHU+6JWU/89we683eLWVw3q6Pd/ZEtaor?=
 =?us-ascii?Q?+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A69548CC84ABD49AD0F376B7C14809E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d05b71-cd2d-4fc5-0100-08daaab6b69c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 11:58:15.0637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SqtGbXqCHTmpbxi9Zm1Iiz1te+Wo4tUm8RTRG8NWjWIcbw/1hWkNmDHzDb7mx9GkOitcJ6hpNkdI3TXTidnQLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:14:12PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit cc160fc29a264726b2bfbc2f551081430db3df03 ]
>=20
> if_link.h says:
>=20
>  * @rx_dropped: Number of packets received but not processed,
>  *   e.g. due to lack of resources or unsupported protocol.
>  *   For hardware interfaces this counter may include packets discarded
>  *   due to L2 address filtering but should not include packets dropped
>  *   by the device due to buffer exhaustion which are counted separately =
in
>  *   @rx_missed_errors (since procfs folds those two counters together).
>=20
> Currently we report "stats->rx_dropped =3D dev->stats.rx_dropped", the
> latter being incremented by various entities in the stack. This is not
> wrong, but we'd like to move ocelot_get_stats64() in the common ocelot
> switch lib which is independent of struct net_device.
>=20
> To do that, report the hardware RX drop counters instead. These drops
> are due to policer action, or due to no destinations. When we have no
> memory in the queue system, report this through rx_missed_errors, as
> instructed.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
