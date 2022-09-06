Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7415AF0E4
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiIFQky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiIFQk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:26 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70059.outbound.protection.outlook.com [40.107.7.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E336F78229;
        Tue,  6 Sep 2022 09:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/LsV/zXQQkshnQBLsOT1X1IJgzmYOqmgFJhs6kEa4LLUWzF3R7kCWrOAMFJvQW65QYjNUI+OLTRjTlxxjPDZWvZvjqqy/FyytVBqKXn2xdbPI68+M8ZjmWG283gKz0+mUkGfRlRnXf/cVSPI5AN3NYWqiyrVyyY7DjMH9S++I0yFmFZxjE6/nFB5nK7OiouKFEEvGnn7bbg4HYxv8V1VYTGx5oA6pDqJi3sYptYO/nJI6mj+6FaXRyz7DykaHOT05URPq+zSGbCYvkZL6FWTv9wtFrGJC6hBQufPilgjsek/iu6BJrxpmJlUWqyGh+JOy9baJekOSUklcORqymw3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/M+2/nGx6uRpytoCjdC977XIAayixipRp+ShXrzouy0=;
 b=D6lT6OCtBC8APKKOaxvXSP3EgAEURcb1pyER2XbOcL9SbT+/z7O5ny4pyYyINuWUJx2Y2KTk+h4wTHqLgZIc+GsUl11rXmHJYwjEWakU+IT0463uwU+dnsUT7qCdofTX54BOo6M0Qmx+hBVaoKG0N6v8xRr/k/E9Wr7m6OVDpisYHDWU2rGK9UP43NiTq0kS96ACsbD6N7RoMttjjdRbArUVZjmlltVn/PXuglg3VjTtWatnbDQI76L/x5T4fSfALOUz+1l1QZSRuFlVnOsejR1onqJ7CbI3sBE6TYujPYfTNi7bY5PvuewN0djk7WEx5f8MZ3UcEMD0A/goFYx5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/M+2/nGx6uRpytoCjdC977XIAayixipRp+ShXrzouy0=;
 b=NpQdKdRWRVDm5rERADvAmwZtK4rvPBU8GddOSVoJ4wugrisIflUVtJRURo/P4pxOulAfGKgWMub62FbjLJ3eYqxihLZACnnNyNQPM1jzDvzCiK2q4LBmlGEirip+1uV62afSsScLOgLKRBatKQzMIywW3xhkpE6OEqZk62UhQac=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3418.eurprd04.prod.outlook.com (2603:10a6:7:82::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:18:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Tue, 6 Sep 2022
 16:18:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Christian Marangi <ansuelsmth@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Topic: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Index: AQHYvKsLmg9+Fvc+3E2TksPGMZq+1a3MfsSAgAMyhYCAAuvOgIAAAkMA
Date:   Tue, 6 Sep 2022 16:18:49 +0000
Message-ID: <20220906161848.sbmz6x7xsfdgdx3g@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <63124f17.170a0220.80d35.2d31@mx.google.com>
 <20220904193413.zmjaognji4s4gedt@skbuf> <YxdxA1yrWOTwAZhZ@colin-ia-desktop>
In-Reply-To: <YxdxA1yrWOTwAZhZ@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 744ca57c-39a9-4af2-a25b-08da90237b41
x-ms-traffictypediagnostic: HE1PR0402MB3418:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: erjC6KG1rkOU4PAkhu0n7NDQYwgtb37MgkZSnfwhSZrGBbryVsI6v6SV9js2BuvcLHDdFOvvD96nhHiIJN/3AHUaQk0ASZxH5R1TqshE8ofGlzN62OEOoDdIo98OugKh2baKWOtfcchvMIjzHQHz04LlET4WZ/FhjpF+zgbSIhqJCcEFXwNFKPyvOuuj0UraN0dbzpk0G7A2h+CV8w9VcYNfjYYDLd5TB2ocbQOAYP8eKtflkC/QEOEk4nN9sV/H1mi7f3YyDAlL0Ypfy6E+kMp3OVCq1uKJkKm4VN3jFvcVgfFQ04BvwemAZaJUWzeRXtoRUFb/oJmghUw8xHkE4B73gVM5rd+9yt8HdH50hPfAqo1Syc/fbFOLeIebetVgAkiq6ALxxKahkow2pZHBvSu5CCToR72GU8lAEHLmV++tDqmh2ygtSAo6sjEAn/d5wQih/19jRO/gbriPUIMFIVYZ43i2Qww7ZGvxuZ0dEYTAxOaUmUrhYvlrup6SMifnPIYuv1+r4CA8nRsS3T1tOgU9eZtHuUSLBq1prYoqEttoWF7z0YY1ocEHLhvyR1VwfHa+NBUriRvZB8ufb7Im6GSqN8Uemj3DN+TzVs87Iv097dVfTQ6+QxRyhT5P2m++bF9FQ1tm00ja+s9L7OG+Xw0ybolY4+/RhNZEfR+MiLpvV3Jj6w3DhAuYgUhnvAPbLoVyUdZnkUFIMKm45i+vD2KVOKg4zizsRQXcGD/AxwVpR4EKd9JcBRCPHl3R2pGh/N0sqsCzyrn55e638feRWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(8936002)(5660300002)(7416002)(186003)(1076003)(2906002)(44832011)(26005)(9686003)(6512007)(6506007)(41300700001)(86362001)(83380400001)(71200400001)(6486002)(478600001)(316002)(38100700002)(122000001)(38070700005)(4326008)(8676002)(64756008)(66556008)(66946007)(76116006)(66476007)(66446008)(33716001)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?tf81wxzDLILkriutC2/DgqOgZIIWyIGohQCE209N98y6RCAHHuL/XlvT?=
 =?Windows-1252?Q?h0qorVUiH9hjl6ZZf4KaEZYa2+vAVULsFMFWqclMYADUv3VqPNx0Lkqs?=
 =?Windows-1252?Q?shmdAXZccOSfTjfdzr8dmbYwQnUTwqj/Hc6wdoNplauEe37eGYOXZb+3?=
 =?Windows-1252?Q?k8/vLOhZj7TuufX9hyCwkt0S6dtoxENaRKmGTTlC5+hBeQpfLDwEHskr?=
 =?Windows-1252?Q?GIXL1/b/KGJBvcmNcfaZjqfko2mDY3R6rz8kcma44MuVu3Uv5fndHX+x?=
 =?Windows-1252?Q?Q7dJdp743MrJLagYB2EO1uJ5P4IgUyr5jV+JNK+RNszCvHwdLNG9CuVW?=
 =?Windows-1252?Q?xNy4pwYaMOOsw8z6pgS4vEMynO2jfCRwRufxrfJRC8W1LDSXqO34zT+O?=
 =?Windows-1252?Q?p793FfXwlU3LFG5XZqQF8e9c0BZwescHKBWix3oH7reuxVn4/59AHiog?=
 =?Windows-1252?Q?K6+0NB6M8guQKPtNkWLFZaZNc5x/bh/1SPl2CdSHY30clqfz+2nDFtzM?=
 =?Windows-1252?Q?1Zo8pNJtCh3nhMMOzNeA6TvJehMRBFO5uWLYlhyhEFZNlXgH1X8V7XT0?=
 =?Windows-1252?Q?/ZElYbny5WdXqRNAouCJM2XNjvUMLJKzuRJs2QqbxlXw00h92Kbj1SPG?=
 =?Windows-1252?Q?LgREUEra5zXafjvnIomaOFuusO6ak2y8OYD3DbKC5L/ZkJ8+EJ4HyBak?=
 =?Windows-1252?Q?S2ljA2oziBgimgI80ZtaJCO359wT7kr3xJ2QmuzQVMj1aGnPknL1fxOu?=
 =?Windows-1252?Q?yMZ65LYdOoRKLGKYmzkPxVszQjBOpBUTWyA0/M2fierBUpxHcTqrIlwB?=
 =?Windows-1252?Q?36Wpmex3JyhPrUyIO9QYq26bp46OzOoSit8WBmFmdUKbKIGT0wFjzAvM?=
 =?Windows-1252?Q?lMnXkbjDjai+7usUyLP/Cnby0XmROlT72Skb4h4Xo3FdZWKR0YJn3L3r?=
 =?Windows-1252?Q?TPRoZQlQOd60Z3PghQcCtaPEk9XsfsAWQkX9rQf7UiXe6KKj5SoN5ZpN?=
 =?Windows-1252?Q?1w67bzrQ/2Tp/DHF61AO9MfRh98tZ8kjH41PtZCwCn0MrglF7UHk9ujP?=
 =?Windows-1252?Q?XjtHJ8oInMFRn4fKC/9tRX6KkXqGYcwBe2VimQv97YCq0XDB8Q8oOpjH?=
 =?Windows-1252?Q?fs/qMFqkPiaFKLS7pKAU+cy6p66ElhBWw8kiL3iBG4TrFNsbkulD5RCw?=
 =?Windows-1252?Q?jLXSjZ5pBPKKrv6WZ2Bl+rvDTF4ze03vUIAVRFkczdrBmSU872hDajJl?=
 =?Windows-1252?Q?PlkCDCRO0VGbUaNtSXv+P8tDMXDqHqmAHx4sqM7f8wBv1GCigEBEnOSl?=
 =?Windows-1252?Q?wqufV8+SaRTRHwKY8S8iNE+8lLZLd37s+gBT+4S5rWEmRdiP5XS241NB?=
 =?Windows-1252?Q?w9AQ6sRxF8D492mebXpLixbpBBeX/+gtyWCWH+X2yZQtTMTuqispB/ak?=
 =?Windows-1252?Q?peyL6sBDbY7+var1F0wLEkyw1/gljsL4L2BDVBUEXtcr9jZh6mHypLyf?=
 =?Windows-1252?Q?Q4eCvRYVCgsr1ItYmqvEbP7WRmapAr4npECwN8doYqJkRfoTBXmQ/Tln?=
 =?Windows-1252?Q?8JBEqOPjOl+O+xOFdNePO0vu4DqWM80u06q5EDYaUQavfl/UhPpAhAXM?=
 =?Windows-1252?Q?/4FQ35HZ4jMaiYO6jdiRhZBRHFyHH63e/2GwBAc8Ka/NFBjO3+c59Qnz?=
 =?Windows-1252?Q?AQ0Gw1fLhAuBIjbicp1Ohv+uI+c0On/gUFiSM31EC15eYu9vwpCSbg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <621A42126499004B97604A6A6DB03665@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744ca57c-39a9-4af2-a25b-08da90237b41
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 16:18:49.2188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFXbhZYMeEw7NoHtav6lleN21YUv0IaPU8jsBXYzHzSSacj8dg2x81pJDv01ho6+CXmWDNiK1yxeJ0CEpnRNtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3418
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 09:10:43AM -0700, Colin Foster wrote:
> On Sun, Sep 04, 2022 at 07:34:14PM +0000, Vladimir Oltean wrote:
> > On Fri, Sep 02, 2022 at 08:44:37PM +0200, Christian Marangi wrote:
> > For transparency, here is the commit list I used to produce the backpor=
t (top-most is most recent):
>=20
> Tangentially related: how did you come up with this list?
>=20
> I can only assume this is a manual process based on intricate knowledge
> of net / DSA as a whole. I just want to make sure there isn't a "git
> backport net/dsa origin/master v5.10" sort of thing ;-)

Years of practice ;)

Although I found a tool called git-deps and I ran it in a few places,
I found it to be fundamentally lacking for correct kernel backporting
work. The way that tool works is it finds patches related to the current
one based on what other lines from this patch's context they touch.
This obviously isn't going to work too well. There may very well be no
connection obvious to this tool between, say, a function prototype added
to include/net/dsa.h and its first use in drivers/net/dsa/mv88e6xxx/chip.c.
So it may not know it has to backport the include/net/dsa.h change.

I suspect one way in which git-deps may be modified in order to be much
more useful for kernel work is for it to backport the entire patch
series from which the dependency commit came. But (1) I don't know
python even enough to be able to manage a pip virtual environment, let
alone code up such a change, and (2) I'm not sure, from a kernel devel
process perspective, that we offer enough machine-parsable hints such
that a python program can just figure out "yes, these are the patches
that all belong to the same patch set as commit X".=
