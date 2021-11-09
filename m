Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DE444AF69
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbhKIOZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:25:48 -0500
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:38840
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238103AbhKIOZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:25:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScKjMtDl5nzYovW8sq6sZO90Yg0kLFxh2zTak6AUxWG6MZGmjqxss6rdbxbvP1VSXJpRkbroY+CrQNTc7vwT0nO9Hz8WrlCWqxfrPH3l8nLZbKfeq71bs6k9zoM9E0/lFBKkuE5SlEBvGA5OErGaUHZu2R7loJ9Y3WOfRMRUmqCCb7QHQvyLnuZWD2WXa4kRuVJmFiDSGlyR/ARqyNjD/Ise1V5T138Ui+kczovurLKSIZQ7+qHyDsI+9gMSEukpzbl3os9CRnM/HWO0SsKptVKZftsLZzm+dAsNea3t6XsdUSKhmNXQc1Nbz0X/2n6xQ+huCNo8db0i4ofRgbBhaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsJGN42ZxuqHOiwt60A5yb6VA8TqqKe1/m87ijszZ14=;
 b=WvOUo44C8CmsOE5E+u0aY2JquPR7bzpe6bG8la97cxo+NzbmjwKBu4C3/pRUvymdRnXXFVwpheO5yKKlXMXLWXnUO1jtCYgE4+p0ez87Ax4mHhv579eMB+1MEdZ0EkZNVr0imlTBHAnoKv44o/m4KcQxXq21JtnmR7RPfOrw16BYeHi9HukAPvYlZPT6D6pZ8y3Rgo1JWVmJRkwLtJMB5O42I1VEfIDUbcjjVE6UuZMXQ/vJIS0wWt4neNmnW7wxXy7KoQ/2FsMK/4UcVbeEOZqljJ0DbPUvJ9vFCSGIBDgGfS/vIhZkHSUcNgHvzrlflYnW3H+y2Z5aGG/RslfQaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsJGN42ZxuqHOiwt60A5yb6VA8TqqKe1/m87ijszZ14=;
 b=YeKVLAcAV5G6LKu828JaX620UBaGWMof9VxIuKm2GgC1BN1EkIF+sQ1s/ZOE8f7kaKYLYNb3Tg2LtM/fF8Jh3ck8InOmXYjaCiNqhXJ+A+rD89DQZPpOW1taH+SndKU8Az6UMDsZ8fb33OZXTh5qtTZka9Fr+UoEekEaGmFxmIU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 9 Nov
 2021 14:22:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 14:22:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
CC:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [Linux-stm32] [PATCH net] net: stmmac: allow a tc-taprio
 base-time of zero
Thread-Topic: [Linux-stm32] [PATCH net] net: stmmac: allow a tc-taprio
 base-time of zero
Thread-Index: AQHX1N9HLp/45dXZAUyXM5qWRykZXav6262AgAAlfgCAAD6yAIAAAPeA
Date:   Tue, 9 Nov 2021 14:22:56 +0000
Message-ID: <20211109142255.5ohhfyin7hsffmlk@skbuf>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
 <6bf6db8b-4717-71fe-b6de-9f6e12202dad@pengutronix.de>
In-Reply-To: <6bf6db8b-4717-71fe-b6de-9f6e12202dad@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3189aa90-2da1-4172-f5ca-08d9a38c6c9f
x-ms-traffictypediagnostic: VI1PR04MB5504:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB5504072BA8EB8CC322A5DA2AE0929@VI1PR04MB5504.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RTFdaZHqgglxD875tsHaaQCYW87gkWu9dwNw1csbIUL/Zm6l0SViZD63mhw6p1ovXfdTGMt/MsXUcoKh7FLtkzaTXnrBOvv7OsKbcC1kbCPw0uOB1XNe7vMtVc0b3y7eoKSNXsUFIZtBxRUi5Qllv620rlxdfTGkBjS7yGTfMCAoELYFF0Um6bqNWMdjnfkQB+jTPVoHjYY0aDS61X9n/54gQqNxMh8b/TkTd6HzINV+2ZvCHC9LKxLnjPGjydocuwydUFt0SRjr84YE31C8IrzU/YH4PaQsdk41bIo4+20Wt5g9RhR8efqGFnmQioRlhOgfNoO6Hja5Tu0QxR5N/8xE/JoBTruwp+b88BxWkz29apyDO146MaX/vDvV/T2VnjElHCkPuB/WnillBzLq3RcS4D7lrk2s7ENqXXpZBbzD0QW9q+d6B6rFYOwqxx6MiVOFVMm8OtLEND3mlAZjwssuWiP++CjeedUpRgpxf/FW6sI9WIh/DSn5LdHv2V24QNrU92Z+O/itkEpvPUcb+TuF39DwcMDb8QFni29WxV2PL/wkpqA5Zl82XYa//O6ZNWjBHX8cd5shlNsg47EAqUKdORxmRFY4wBxkYwSe3kAQU2bWo4/DAhO8acI3Y4tEfHlQ39rFyTt6aFw0cAEcrceh7dUROaHPtyuoBmEzQse1pyUw8GnxJdl8Z2/mFoRE3irVBTwz9IeDJsbR+TVefllgWnEvCy9yfrI2C28UCY4XtvyNRpgCdu4PvMAv0KvhUKDWnINBI4k+hK/QF3Osdrod8sXHNPmuKSh1d1F1d6E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(2906002)(8936002)(66946007)(86362001)(26005)(53546011)(66476007)(83380400001)(76116006)(64756008)(33716001)(44832011)(8676002)(5660300002)(4326008)(6916009)(6512007)(9686003)(1076003)(7416002)(6506007)(966005)(316002)(54906003)(6486002)(71200400001)(186003)(122000001)(508600001)(38100700002)(38070700005)(66556008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8I3Nw5cZZsp9zLRzv0odq+3pslFD4qHR2o58UtF/U4wy1+N96ULvXfJWTvUL?=
 =?us-ascii?Q?uCvkJP1A+77PZS0ppgX6zebpbypylYaC7g+HqG1d4jHcH7VreThch4O9nyZk?=
 =?us-ascii?Q?HV4dnhwEWtivLa9BvgZiyuNa3BoI2I0I2zk+JingoP4cISASbZxcwU2z3Zph?=
 =?us-ascii?Q?Qmij1fFY30wCYVkqsB/k8GMlLQoD65yHGn/jem+kA4jLNEe6GTWQhxzM0UMA?=
 =?us-ascii?Q?YeczYx/RC7p11XEIHqZOTckX9thGDk8L1TvIDkQ2/bWj3cezdCq7/kS3S3j9?=
 =?us-ascii?Q?ifPk9dzfPRZwwpf3xS0omlM41jXbHLfCJiMyAhDXrmOMVp2rVb2d83EbNFxM?=
 =?us-ascii?Q?Q0pkW+zzedv74hU8UfwbaaWPdos2aH8JeT4El0hSqPeaxEwKumcRkB/rW2iW?=
 =?us-ascii?Q?nL3j+omRt+vD0ARZApP5L2qqIEIJurQbTqdRArTTJBlX03YnK84DguJT6Nua?=
 =?us-ascii?Q?bdIqSGN3uKFaiZ0TVxiJQtnSHLC1M1ntDtaYcj/KarmQsJbsPakPkO5rO0+K?=
 =?us-ascii?Q?h+cABIzp5itoC0DSTygUKeYpGAwQIMoy1EVam/FWtF5s8f5P3Lpm2BFgylT3?=
 =?us-ascii?Q?Pigeo5syicMgCzpMIj7waLULLXDOrD/uVvIc9VvQA4e1bJiG15MX3FRlP0VB?=
 =?us-ascii?Q?J+K1zYew6k2waK2FBQVAhJcryrfXDZhqpuXEH6VYCJnF3oZSOGzUp4m8CJ2h?=
 =?us-ascii?Q?VcUJPxtHU6asWZJr9UfQaa5pyoO0tXvWdzq9ONK/UDWsir4RaTNlegrQmy4a?=
 =?us-ascii?Q?BlVnscEe2GRqoO857hvcom2KCd8QIQn1DKfzAtmZAfNPZUo7PItOwBPriFrS?=
 =?us-ascii?Q?XgcX6OVqjy6qxj6iN+k5wTS5WiTlhP7lzHzooZVX/TBU1Qw03LlCm3sJNtms?=
 =?us-ascii?Q?2/WAmM8wt0el2mjwr37XvLfZRRb9rQHJRGjh8LZ+RTdefrYUJSs1sz3sTCE2?=
 =?us-ascii?Q?8H+lOgq9QDf1bz7pCryHQ6yIo1U/FHaLOC2cgsSyy524RthCSlcn7D2eIfGK?=
 =?us-ascii?Q?0gZxWUyhU7LdJbvYQL2sOqZgA5jKz2H4j07KEDVTRGtj5XzuWBZ0vcP2nk7V?=
 =?us-ascii?Q?u3JpPkduq2lliSVgQgM4bEDFNFtT96B7qDemKrmtQRdXBehJr7b57T3jHZAb?=
 =?us-ascii?Q?FZpFAH4Wa2spUJbkadxx+XR819YypfVEjjOWeCRiBWzWAgZ7NK6oEU9MxLdT?=
 =?us-ascii?Q?Gt7jG+f410jc9UzpAOL9mYvNAoGL2Fwlh+IfRGIljaIREFXOQ4bQ3+AyrhjO?=
 =?us-ascii?Q?5BwThq8UV3QdAPGejKZQOj1rHjkj1TCVEgSsbpOm4O994K1lElUsjYkkGI5p?=
 =?us-ascii?Q?x3mZzUkPymPP3aH4I9S4X2t8wPkECQx+6sFQb8aKl4+H5fYgFCww7n/l7mRk?=
 =?us-ascii?Q?0oqbtGiPphnZAOWqSJG4f6lzi8CsGCfZqUzRo8Pn4bOVyMuB/H1JFY6PyanH?=
 =?us-ascii?Q?sCdutpxiZWrRT5JQ/IloU16ka/7RQuSFqKuOpA8+6Jd3WOgAWXforCYNY2z2?=
 =?us-ascii?Q?C8EV/H8H+E93pqo3RHCULGmFN7N8EgEoVIwD1tO8hAdfw8DjJbovAZUgEb0s?=
 =?us-ascii?Q?/smxY5YAblfTvNaPxGDG7Wy1OInjdXQ8z+URb3a1BJFIIeAco8FIuqDX9nBg?=
 =?us-ascii?Q?/m+LoweA6XckLOMr2ba43C0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8690164EFC827142AC5912731C8D30D3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3189aa90-2da1-4172-f5ca-08d9a38c6c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 14:22:56.1637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uVZ4yEJCTsTCbFTBUEJHYfRpRyNmkyHhky17nNjsbEzKYXHRiWWP/qJbFXs9KQGMTBuF8E9mRnViy6zTk7M6sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 03:19:28PM +0100, Ahmad Fatoum wrote:
> Hello Vladimir, Kurt,
>=20
> On 09.11.21 11:35, Vladimir Oltean wrote:
> > On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
> >> Hi Vladimir,
> >>
> >> On Mon Nov 08 2021, Vladimir Oltean wrote:
> >>> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
> >>> base_time is in the past") allowed some base time values in the past,
> >>> but apparently not all, the base-time value of 0 (Jan 1st 1970) is st=
ill
> >>> explicitly denied by the driver.
> >>>
> >>> Remove the bogus check.
> >>>
> >>> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO schedule=
r API")
> >>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >>
> >> I've experienced the same problem and wanted to send a patch for
> >> it. Thanks!
> >>
> >> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> >=20
> > Cool. So you had that patch queued up? What other stmmac patches do you
> > have queued up? :) Do you have a fix for the driver setting the PTP tim=
e
> > every time when SIOCSHWTSTAMP is called? This breaks the UTC-to-TAI
> > offset established by phc2sys and it takes a few seconds to readjust,
> > which is very annoying.
>=20
> Sounds like the same issue in:
> https://lore.kernel.org/netdev/20201216113239.2980816-1-h.assmann@pengutr=
onix.de/
>=20
> Cheers,
> Ahmad

Indeed. Was there a v2 to that?=
