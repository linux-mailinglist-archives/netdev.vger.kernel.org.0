Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22931450707
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhKOOfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:35:02 -0500
Received: from mail-eopbgr20049.outbound.protection.outlook.com ([40.107.2.49]:24325
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236500AbhKOOeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:34:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATanutrBqKBM0nP3oeDYL1HPoYKH+8JenPNJLtG2+h6871Aa7IWISuaxPd5/JiopvWz9kASs12J8xBtUI1JutC5E8b3hSVHuUVCLztcarrPZRIiarVw1qHfaiNXIhM9hkZcUKQ/AN0hT/matctDejzTzvOp0jW4L5lDb5SEBIu1Lc7DpMvh3cfldvl//wrsrXGeSGoaLAQiaYNBS/vVLJyjnZ5W1no5YtSBd3IEc0HjSMLw8ayBudxpLQseFIG8lfhR71yOLbOTSgEbR/PP7zGyNxhxFxPa5FRiMA7tTa/SPrZIDmbkEWV8SNlPrhnNXcnemGXwni0MaF5tIFO3vyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RyJjVwVF0gN+wvTndSuPyNlUu2zTXUxN0WhpL1A+hnA=;
 b=PtFbtqtvVDAh3K24UXdgC1bsJuaF7McSH0nnBpmdmrzC9jPYxOXuilvKHpftREOhLF3/ArLR0UeDqT+luVMcMhfhO8zUpq12YwyrqwA1HNQwCj0YWHt6Mb5rAJ6iSOxnW2M/vHpFoyRQJps5A1zejxUfvG4hDp26fJr4v+gloTyPRVkC3N+864a+cX41g7izvg4MOVkj6ykW4ZGfZtQSgAUBoz8P+bQ8vzeipKc/dWVq+Cqfm18aFoIuO07P7GiDW4eIA7JhNBndTxODictjp7nq3/CYTRiTcqEuHNrBowuW8AUi6aTIVrciGv8tdFZLlYD5JJazwunvg5KCAPXddg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RyJjVwVF0gN+wvTndSuPyNlUu2zTXUxN0WhpL1A+hnA=;
 b=X1EjTDCHCAj2H7wQk1Emyk2IrfLBf4CaD2ACHtitAC6kaW5Tb3U8B57djwyASIVaMtS/nSexVRiWSKAZCEFaxIvWhP8kQQ2dafqHK3WBGNbFVDeGRWVXHcN4qjBXSRBT4IqR8XisTgvYAuRKD4CnQxqqZvJxyQe6geHm74gLWAo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3837.eurprd04.prod.outlook.com (2603:10a6:803:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 14:31:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Mon, 15 Nov 2021
 14:31:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Thread-Topic: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Thread-Index: AQHX0JQMizPbr20xM0ur1htXAvgjtKvxviqAgAAVJICAEp56AIAAQXQA////iQCAAAbqgA==
Date:   Mon, 15 Nov 2021 14:31:06 +0000
Message-ID: <20211115143105.tmjviz7z7ckmlquk@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-4-clement.leger@bootlin.com>
 <20211103123811.im5ua7kirogoltm7@skbuf> <20211103145351.793538c3@fixe.home>
 <20211115111344.03376026@fixe.home>
 <20211115060800.44493c2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211115150620.057674ae@fixe.home>
In-Reply-To: <20211115150620.057674ae@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: deb72273-39bc-4b3f-1a26-08d9a8448f7a
x-ms-traffictypediagnostic: VI1PR0402MB3837:
x-microsoft-antispam-prvs: <VI1PR0402MB3837129902311A2D71D9A31DE0989@VI1PR0402MB3837.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l4hEGP/I52/S1DptJXxdroabRXzW0UWCv4D5U4Yau2HVNShfsxsddpSUVAJ4QOutbLk/w4wvin4KyoCQrhxmk+BPGijKslOZgSl1qnhQWZpa2rd+wPsZfzJOzMA96ALvbUhvluVJWF/suqFpSOft8ucl7QTx+035ZI6UfMFcX2yp7fOJygTCC3S0pWiCBRuwssx9IOECqoSNtImW8vyobQlKin4N+4U6Fvc8hBHa0oO/qOqBRPU3WWQ9laRyqhUSUoPKpfLNUrbvYNr3GrMakhRlgZ1KbkFXe1GdCWnsP/1PAKJCnQwLiGdqjvtzFTm0A8HEeZ0uoEzhsPTECFxbiytGm/ybWmIaETCB3A75Ig551uxZcp0AR2yCq/KgcT8lMZL4nemv8uUNawe8YvISayoayjE7wBTooeMwUmhYAJOpJ7x27YNmGJ7UjygsmsXe/hUKtE8ktrAMcwRCwTaIAsakXjP6DryaxfJIBTqg9G+zgjKK5tGfjVyrqc1enqoZ6mE/JXtQsR9mV9gOPnSySjsG3ar/1OJA5aqyQkSI6WerQb+PKQDKyc08ztuwRu5PIojO4qR32z3En/F9gmfpoAwq5rvKhlZU4AposP2feWRzWhNgsSqhw//L/u5zGh7Cdyajhzk8/uSyffmYkQkE+hLrM3ZSbcT9GtA8hBt0E+Lh/7v0yJ+Wd28gpyJe6ZPSmL1FR06CUXq1XRQqQY9DsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(76116006)(38070700005)(86362001)(44832011)(4326008)(8676002)(2906002)(5660300002)(38100700002)(33716001)(316002)(186003)(71200400001)(26005)(6506007)(6916009)(7416002)(6486002)(54906003)(64756008)(66556008)(66946007)(66476007)(66446008)(1076003)(8936002)(508600001)(9686003)(6512007)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hOM6SBzSbdTeEtnr55VAMZaHZH0Zs1iYnaYoXOUxhjqSuJG8Rcby5urUI5?=
 =?iso-8859-1?Q?EDPv0aslIfP7sOkyJcRG3RDivzEGJee5V8kWwKRoWLkR+vgXSu9nyc3JYD?=
 =?iso-8859-1?Q?d4Z3Sj31HvrMs/8TP0OFB2WURsgPkF54TZfZ/WPgblbxd7RMrxS3t+t/N6?=
 =?iso-8859-1?Q?nOSSblrQntS8wPSwxowWcXGANP1PBe1aZIg0/M7rxlX32yZoRVcYZU0tlQ?=
 =?iso-8859-1?Q?AA0bdZI0pUPGcOh7l4YRgKz43ZERGRGfdwAvppv4GbGDEbY/HJmifwb7Qj?=
 =?iso-8859-1?Q?7dLCHAtLsl2KyXG6q+vECfXagLkA0DWiCm3Frj1OvvRU1jW8YEMN2neHNx?=
 =?iso-8859-1?Q?+JoQP07FjjJ06EpTiQ08cCD27E3Nx4PiqwFC5+elGzxzUmO1eJHMAzWzb8?=
 =?iso-8859-1?Q?mEuA1mtX8igyL1aFl1QIzOVBB3Sh6q4YkZHHvQWrIE21P8SZF4LhvdrjSK?=
 =?iso-8859-1?Q?fSeCyReoC/eBh63l7qbzSsxDXcISmqTlnU05EB7R1AI5KC6Io2eNQRZUNU?=
 =?iso-8859-1?Q?04BUc3V/IIDnmCdmZXzNLS3IwmfL73xvgKqQL6FhOlFTEyaWJbl3xNcPpf?=
 =?iso-8859-1?Q?2p9eeoUaU6VWWQPYnsVyeytPsSzfSTfoVpQKeILmkYIsCV6qCuyh/OpFjH?=
 =?iso-8859-1?Q?ArIz8FfMco3glSv6fUgjsFkIr1CmbfsASdr3XOjXQNo5cGvllqaLafG89n?=
 =?iso-8859-1?Q?wySPBw/K84NCCXKNEEKXYc7V2aiNTnonI5koLX3U6YXHEPfEe37jpci9jF?=
 =?iso-8859-1?Q?cNKRqqNQWkDG23hsFc9OYa3JeG+uJAjog7JPS+EVq30G8vtc3octMLXiuS?=
 =?iso-8859-1?Q?t3eDSwC5B09K732g7iSgR4Fxtt17FiTnfY2G8vuYwdyFtnvBeeuemf+1Yu?=
 =?iso-8859-1?Q?0HJeXBWMM8ll0Zujka+sxyJA9jHHkC2+GGImtwSmpig1TuYyjMj//eX8yY?=
 =?iso-8859-1?Q?nr797Mix/nW7j5/scvXroynaSPAPodp7pOBAM87ftoJTQ1EYDvjyAZMy7X?=
 =?iso-8859-1?Q?Z5TbXYw21I66ZWzjQR3wXgn3PYDZFwfJFVogUea/QneFHIwmLUzvu/Mp5b?=
 =?iso-8859-1?Q?5gnAe9t5LdEMmgnDwLo7lG3lJGku+h2Lex+82oZntBwO4ILjOlQyg/KV4J?=
 =?iso-8859-1?Q?Fir/C9LOfJdjSin4c6taM72gnBKVNkLJRGZoibY7/payrclPx+zsfQOHDx?=
 =?iso-8859-1?Q?qrW+rJaQvz6sPnvB/6NcRpFF+l9rsCLapZ4GN/iTT0FMhX2YdnK/FS4cus?=
 =?iso-8859-1?Q?8qug5HVyylzjG72nVDmDF5Bow4sJcXGpByJQ3+D+CHgoE1deFeo7QoXKT0?=
 =?iso-8859-1?Q?piR67Stjx9QwFBTl9hePFq5I1y4lkRffw7/CUoASp455Y2Pm6pEMUOzZNv?=
 =?iso-8859-1?Q?G2U55tgbB3RekA0W3FQvtN4ZP3+t+W8fkE5PReLnvteE++cNXhM/+hLV6p?=
 =?iso-8859-1?Q?bnvTurvHLZF6T+8xV326OaX6sh66j8Jl2cpcTs0j73EJtM6yvOAcbIDY6C?=
 =?iso-8859-1?Q?GvXKCkKlE+L6nTFGNu0ecYeINQE132oy+D2L5uyhifLV4F0dO+Lt82zAuh?=
 =?iso-8859-1?Q?Kyzw1n6Avff1x/yJfCfFX3J9+tGuSY4q1uZOUTepCyiwZaASHWLVYn9t3b?=
 =?iso-8859-1?Q?lcG91YV0+crVVRZlH2Zs2JV1C3FWPsQlN5ZraJGPMw7f2tO/CPZIXaXAdx?=
 =?iso-8859-1?Q?20mBr+Zfi+s8mYcfjAw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <63C3D735D3354C4EADA76079B8540318@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deb72273-39bc-4b3f-1a26-08d9a8448f7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 14:31:06.6683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zq+LshN35YEJLx4nRcia/ytKlRPw9R48q5ZY3rG+UfYQ5dZfmwV2usP0REHaevYn050emoQfdo6IjeIa9JSpOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 03:06:20PM +0100, Cl=E9ment L=E9ger wrote:
> Le Mon, 15 Nov 2021 06:08:00 -0800,
> Jakub Kicinski <kuba@kernel.org> a =E9crit :
>
> > On Mon, 15 Nov 2021 11:13:44 +0100 Cl=E9ment L=E9ger wrote:
> > > Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *=
)
> > > - With pre-computed header: UDP TX: 	33Mbit/s
> > > - Without UDP TX: 			31Mbit/s
> > > -> 6.5% improvement
> > >
> > > Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> > > - With pre-computed header: UDP TX: 	15.8Mbit/s
> > > - Without UDP TX: 			16.4Mbit/s
> > > -> 4.3% improvement
> >
> > Something's wrong with these numbers or I'm missing context.
> > You say improvement in both cases yet in the latter case the
> > new number is lower?
>
> You are right Jakub, I swapped the last two results,
>
> Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
>  - With pre-computed header: UDP TX: 	16.4Mbit/s
>  - Without UDP TX: 			15.8Mbit/s
>  -> 4.3% improvement

Even in reverse, something still seems wrong with the numbers.
My DSPI controller can transfer at a higher data rate than that.
Where is the rest of the time spent? Computing checksums?=
