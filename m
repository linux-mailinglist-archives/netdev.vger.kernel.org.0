Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D0259E1B0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353834AbiHWKX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 06:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354425AbiHWKVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 06:21:25 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2042.outbound.protection.outlook.com [40.107.105.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4502712;
        Tue, 23 Aug 2022 02:02:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0fC2R2qGopL59L+fSe9GUPrc8/KtAw2psEvbEJcHOHNdtfr5EGX/HfZETRu0gkiwrrWBBFggD3FGlrJHzaxGEm+AzcKPEQpHGbBz+ek5aRLzQCReI3Xa2m/to5fgwNEfCXA1AuA8ZncTbe9+WdxYywe8yAICafM7NGVppdeiXQ/tVgEwfnEqkVA/KmCM1aaJvmfTJgU6ZuJphIvsoTRix62yfLUMoggx30elwY3H8Qj1JCJKqoWmttunx8HdXGTjFkTMVKff6iRuWgmwM6U0H2dGo1lPlCuep5C1o9cWjRvKZMqqHZRFn2Aq7Jn8OCHwpZ7n+3+cknT2cupJP964g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6+gz53THb9IKBdAPXGUslMpSgpCRteKMVDm3JpTVoI=;
 b=mZ3i9qrdv4UGk6etS7gzQxK3CrOpR1FP9udiqa+5KxoIKiXqAC+jguQVXrM5QbyAx3wYD9GcCstMz65llTG8ga1kXJNTS9j7hkcnKM+zowQy3HOR7RAzM/JCA0Edk+3cn9ptgqDXmeRliFscRini55cLOSP7FnurAUDZgHeIz1soRXjcGdxfgLKDEZK1zDNWM9mQGiYbuuvObpHWnTHw1oE4S8znKJ0cIWXd9yrys13kAmqmO7fsqlnqd9iIyrkJv2Hl6M0iiQM2nMxj1kdkBAyTjBoDhVhMQSmnvMviegQLEpxCYSp3kqr0APX3SqV/he4HGMHbPqfrRmGxO1KRPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6+gz53THb9IKBdAPXGUslMpSgpCRteKMVDm3JpTVoI=;
 b=s2wjS4VD5ec/Q7pmaBZKgyXBk+vwIF9KsqoF6aRIC7aqcfpS+tt/jl2IlzSZb1dFhGCwNv9nnSfcZYvl3CxATJlxwYjt1HsxdeKH7PV2kfScdjwUTedZKtfQfDfehkQEwM0f10SAMPgPX31SI74JG++zoJxXxR5Ljmekm4KKMtA=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by PAXPR04MB9023.eurprd04.prod.outlook.com (2603:10a6:102:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 09:02:44 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::3c6c:b7e6:a93d:d442]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::3c6c:b7e6:a93d:d442%4]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 09:02:44 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 3/4] Revert "PM: domains: Delete usage of
 driver_deferred_probe_check_state()"
Thread-Topic: [PATCH v2 3/4] Revert "PM: domains: Delete usage of
 driver_deferred_probe_check_state()"
Thread-Index: AQHYtBlVRIWNGmQZmkmHPgDs2PsKi628Nejg
Date:   Tue, 23 Aug 2022 09:02:44 +0000
Message-ID: <DU0PR04MB9417D2C1941420921426398188709@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220819221616.2107893-1-saravanak@google.com>
 <20220819221616.2107893-4-saravanak@google.com>
In-Reply-To: <20220819221616.2107893-4-saravanak@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3cb91fc-e661-489f-1a52-08da84e63e07
x-ms-traffictypediagnostic: PAXPR04MB9023:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9o4VA9wo870TJW1FNR8jW93TEjv0mTHhy1OFOdOJ/OAqcBbAy3q+eHHLgID1dMu0irjcp8ONvQ0PrGcm+BDfKte487mUxbq+7Xp2P2ItT+17+Ch3sV8uezzbGT2jHpqsyw9waBERrHbq1NwOKjvXKaEUmEyMQY6yIKJBAxRZcdYJrhIC/OkqxKuSD9EVPFIlCyGPBIfZV6RrCzc4vIfrYLM5tmDI3lLIq4rLBlBvWYZgcTjd+igj/wgbrlA8P3O7ybzSez2BCJDWWJaZq85eYkJ8fsX7ZL/TGE8VnHxEm/b4PnzedkluxRLyh56iwVie149EJ5im66ZTXSEWV6zSPxQR3YPqQBNV0C+VMB38b51GF+eM5GNTjo1HDa0WzyPKpcBc3jpnfSkKvx0g323aNWDtghvoWymizhAcT4yVNAy0t+R3PfIP9YtQfQupaiPYahC4g2HW8jyvk+2O/hb1+/MZsJt4+K8c5+HwYCJuHBwodOPWpgTqkapZ/85hga4ALcbCsw0C6Q4bxmkXNbbFtI+6sp533C41ysuDaRTw5pKlUT0R2fDi24Ghw0L5lFZVsR1elQqA/JkRM8HeZqFtZtz/NVQ//A0Xsh+tpiquFUVjYAeosmc+YKk1TpAni54pRVPRl8OCUT8kNfR5xS7EUVenObncq2x7F3lONDNhxKRRIW2gT46dUnIvPov4OXF5mZPGhc5V/O6FL3+IMgfoMixQPD/NkZkmGkZJARz++yEg4eLhfQXH9RXerc6okukgAQ0oYv6fkgA5LjpeNHNkeqPaWp4OaSfzggC11ZahSbcI9iAgrjnyQgmbYq+uOlc+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(45954011)(2906002)(9686003)(83380400001)(26005)(6506007)(186003)(33656002)(921005)(86362001)(38070700005)(7696005)(8676002)(55016003)(38100700002)(64756008)(122000001)(7416002)(966005)(66946007)(7406005)(66556008)(76116006)(41300700001)(44832011)(316002)(66476007)(5660300002)(54906003)(66446008)(52536014)(478600001)(110136005)(71200400001)(4326008)(8936002)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o2ieA1n+IzPegrkVF33m+oMCeBCsFtyhyNcZjH8Q+kNG9a+CQbqiWETgOEGY?=
 =?us-ascii?Q?TWufwdhTeg9JuBU9wCDfw9zKO8r1CyhzjiJ1/byA2vsBbl6wxruG///9YXDK?=
 =?us-ascii?Q?IY5/PSDAtPf8lz0l7g5QKTsz9y1saTJ1rNH47tRFk6BYmaivqnzkKiuCmRWI?=
 =?us-ascii?Q?f6bZ995URoTOwyeCn+sCaFpc2pmlifn83PhHZgZywqaMg/02KHjloOvSrueY?=
 =?us-ascii?Q?t+AmCffKZe5nbgcUja+YWmSIQV0eEFOwE2DjJP0UeBZSRUEOb+Ft4ukT8FGX?=
 =?us-ascii?Q?rxg1wtWWLvkHMCxSIaSeWU7U92wkrwyJxNZqZAF52ehFdN2Q/nzikAFURNlp?=
 =?us-ascii?Q?7DwiaexkpxzbHafX7kq4uQKEBa2PCJPE74vqhRrRmvz9wJLmham2Gkzfo17z?=
 =?us-ascii?Q?2QScHnNgLcgOexp+WLQdu+k4B2IAshnEG4avrAfDeVA8nZf3lhzXWomGnDGa?=
 =?us-ascii?Q?ZGPKulaEU8Rv9s0POJ42c60ZjWXWnRoGpxM+w8CSC48kTPMtquXGEfXLRQpw?=
 =?us-ascii?Q?8TmuOnxZofRIDlfb+Gd1qY+oO/xM5Nl6GTKAgZVjkQTjVWlkZiyibqwZVxWr?=
 =?us-ascii?Q?PlOVs2sZbKgRqrFE/qbJ4JIMup7LVWNaUnQgV/RSdhVrSpbbLXfkdiFBGQG/?=
 =?us-ascii?Q?XC7KqSpymdbTo51j3FiA0zsgVilARF8rAlmP4OSXy5FGEJ42uBWtBW9/ujVu?=
 =?us-ascii?Q?IveFlSTtJoGg/XeWMwjFdck44Rk3vReOSrXW+kIkY/nJKoahDa/6EQI5ATHO?=
 =?us-ascii?Q?lkydEMjRTsEiR1SzJx1U5ObECZjAr0haJFvjdLfpGepa7dVJ65zIROeJ5lrC?=
 =?us-ascii?Q?f69wuI2qcTIDJlw3xCq70Nxl6WkoQARoJyEUKz2jU2iq4BUbvJaAu65KoZ+A?=
 =?us-ascii?Q?0VOKOo8vPVrtd1aONxZ2PThFJT19u7Y3KwmvUge4zsqfbkeJ1YHeqWWMt8ek?=
 =?us-ascii?Q?VOjiDatrl34BsuSfWdeQpBKkGSOOdUrVL1WUewzlRZkvPwz/MusJuw/zkjpy?=
 =?us-ascii?Q?NjbsofxXM0F621PhF0I4Tw2M+t++ToC6N4Fg8+93CGXBJmKs9SzmFmYqoGA0?=
 =?us-ascii?Q?L+HBr5CCoOt974fd7ffGlAt8QqFsYKM6S2NKMp3Kc0uZNT8q6CZ2icvTGtt6?=
 =?us-ascii?Q?3aOjbbsOoqxwN36O4Qo72PwI2z80NdNj3d/WL/5fFDDCCo9Poz1qaNXmOFkq?=
 =?us-ascii?Q?/DmWWtqnxoFrUxPy9kaMO5Th0Y1ZwdlTyicQVdpqiWUQ+oSQJzRHecbE2XUA?=
 =?us-ascii?Q?gDSqk6LmcJSPSR+YjgXloTRN6DAWsI+p7YEqO42GwDdRoo3nBxsYpfouSY5J?=
 =?us-ascii?Q?x5KuEkk/N2dszW9rtUlFFhmMWEKS1XCs2lQC1TuhXeQ8G6EFFw2ARWCaZHzL?=
 =?us-ascii?Q?gPcApYF4ptIA2JsWmhUvuBZmvEwuFZOfEUn+jhPsYXaBpTHboUPvvG8Pv7l6?=
 =?us-ascii?Q?hHE8ZSJtNohW30PtZUq9f6ZsV9Eeo2SR37WmN8nbueUwJDIqom4tggzgtzBd?=
 =?us-ascii?Q?WbkTtyl97VltmKzjyXYIJL7QRxcn6iMR3jYJIRwaDxzniCVtxn3V2SFKV4oN?=
 =?us-ascii?Q?8JM9OTq0BW8TlqAh3Dg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3cb91fc-e661-489f-1a52-08da84e63e07
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 09:02:44.3874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pko+NpXWUp7P+8ahyCnA5yMcJ6t7c7TKQSSbxtMeYaWeBh838QpJHjqMFezC32rhjDUkBimTQn5rH8y4D7yDNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9023
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_BTC_ID,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v2 3/4] Revert "PM: domains: Delete usage of
> driver_deferred_probe_check_state()"
>=20
> This reverts commit 5a46079a96451cfb15e4f5f01f73f7ba24ef851a.
>=20
> Quite a few issues have been reported [1][2][3][4][5][6] on the original
> commit. While about half of them have been fixed, I'll need to fix the re=
st
> before driver_deferred_probe_check_state() can be deleted. So, revert the
> deletion for now.
>=20
> [1] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2FDU0PR04MB941735271F45C716342D0410886B9%40DU
> 0PR04MB9417.eurprd04.prod.outlook.com%2F&amp;data=3D05%7C01%7Cpe
> ng.fan%40nxp.com%7Ce5c97577ea9c4d34e28008da8230773f%7C686ea1d3
> bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637965441917494552%7CUnkno
> wn%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1
> haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3Dpy122mCaQjLc7
> xFhApk61Zh9Hthol6tmprh5KDsOXqU%3D&amp;reserved=3D0
> [2] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2FCM6REZS9Z8AC.2KCR9N3EFLNQR%40otso%2F&amp;dat
> a=3D05%7C01%7Cpeng.fan%40nxp.com%7Ce5c97577ea9c4d34e28008da8230
> 773f%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637965441917
> 494552%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV
> 2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdat
> a=3DDYZ3eCmUPryFcqhgtexUZT1gYuL1utBgHrw%2BIH6apdk%3D&amp;reserv
> ed=3D0
> [3] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2FCAD%3DFV%3DXYVwaXZxqUKAuM5c7NiVjFz5C6m6gAH
> SJ7rBXBF94_Tg%40mail.gmail.com%2F&amp;data=3D05%7C01%7Cpeng.fan%4
> 0nxp.com%7Ce5c97577ea9c4d34e28008da8230773f%7C686ea1d3bc2b4c6fa
> 92cd99c5c301635%7C0%7C0%7C637965441917494552%7CUnknown%7CTW
> FpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJX
> VCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DMesNMmK2dr%2BkEZQ9fE
> BzFWgZhx9PWRQSk3U7zqcRaZo%3D&amp;reserved=3D0
> [4] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2FYvpd2pwUJGp7R%2BYE%40euler%2F&amp;data=3D05%7
> C01%7Cpeng.fan%40nxp.com%7Ce5c97577ea9c4d34e28008da8230773f%7C
> 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637965441917494552%
> 7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLC
> JBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D31VDc
> KodaAH9dOYDnN%2BcJ1LhhAbyEQc8fYX743f8MY8%3D&amp;reserved=3D0
> [5] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Flkml%2F20220601070707.3946847-2-
> saravanak%40google.com%2F&amp;data=3D05%7C01%7Cpeng.fan%40nxp.co
> m%7Ce5c97577ea9c4d34e28008da8230773f%7C686ea1d3bc2b4c6fa92cd99
> c5c301635%7C0%7C0%7C637965441917494552%7CUnknown%7CTWFpbGZs
> b3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6M
> n0%3D%7C3000%7C%7C%7C&amp;sdata=3DeE20zTJ7rKVTY1b0%2F4Pgp8sOx7
> zVTLnSIFsG%2FepL9Lo%3D&amp;reserved=3D0
> [6] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2FCA%2BG9fYt_cc5SiNv1Vbse%3DHYY_%2Buc%2B9OYPZu
> J-
> x59bROSaLN6fw%40mail.gmail.com%2F&amp;data=3D05%7C01%7Cpeng.fan%
> 40nxp.com%7Ce5c97577ea9c4d34e28008da8230773f%7C686ea1d3bc2b4c6f
> a92cd99c5c301635%7C0%7C0%7C637965441917494552%7CUnknown%7CT
> WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiL
> CJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DnYfyk%2FlEwmYsH%2F
> U028t8tnFjpnTZ7G8ffHgyLBZ4Czo%3D&amp;reserved=3D0
>=20
> Fixes: 5a46079a9645 ("PM: domains: Delete usage of
> driver_deferred_probe_check_state()")
> Reported-by: Peng Fan <peng.fan@nxp.com>
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Reported-by: Tony Lindgren <tony@atomide.com>
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Tested-by: Peng Fan <peng.fan@nxp.com>
> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 5a2e0232862e..55a10e6d4e2a 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -2733,7 +2733,7 @@ static int __genpd_dev_pm_attach(struct device
> *dev, struct device *base_dev,
>  		mutex_unlock(&gpd_list_lock);
>  		dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
>  			__func__, PTR_ERR(pd));
> -		return -ENODEV;
> +		return driver_deferred_probe_check_state(base_dev);
>  	}
>=20
>  	dev_dbg(dev, "adding to PM domain %s\n", pd->name);
> --
> 2.37.1.595.g718a3a8f04-goog

