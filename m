Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A153475652
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhLOK1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:27:10 -0500
Received: from mail-db8eur05on2118.outbound.protection.outlook.com ([40.107.20.118]:54496
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236502AbhLOK1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 05:27:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUCSFwA8bRz7+LT9n+1gVjkudC41YT+Nt3RXDpZeKSsbZ71RqOsIXwWO7uev6WM47Yi7JfOe/eulnxhvOiq847ec9KPQBIB/bkoaJEF+7shXIO1S366liXmFrQykW3h49+eg7S7FyCDEAfg6U4v6Fog115Yl2afV5PHX6Li9t9HceEOoX2wvlbfs0diR0LIF6BdzTFxerd4bKVQL8wf1ncYymSH32l1N97+Wc4XM5e2Y8jPq+3Zn7rdqZwovAQg4dbnYSrMfVzyuBQtczj13kRMH6w/xswINI9gi7IFYg1qX+aY8uBkEDuys0LrWJEGzKjszbMkUWZuSGa94DJLULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tb/Pbf+Mt1EM8Aac0BYlgP8mCTZxL9eZVccTLPBVgsA=;
 b=bY13wVRpw/rW+28wK5KTLGshnXJSv1UQyhg65IzrRzf9KWp1SMz6hVV4+v2eWKQYZPQARaEMYeADmUQcp8MI6BHhcDL+HyB3FZjjFSnl8EVHlfE27BotgqOHvwhTGzPqa0gt2JOQzFE0mOk4nsk2fVoxYIIsirzMCyCehqgDbRIari1X3yszTmznbfl0LhAgTP04Az7LMmwbMNzgcjNz+0QDXxNNCzofaMRWZAdB8Ro8+2kL3xyq1FEenK5UwnAalvyY3UlwN+OmLyIbuEQI9wgyS0n1SRIUxvG/Ezaxktgal3t/tijmK8bly9zmD0G/lp9Xh7Ha/5MOG+pkY7BH4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tb/Pbf+Mt1EM8Aac0BYlgP8mCTZxL9eZVccTLPBVgsA=;
 b=Andas6+XgpAVGG0hsIIAkMvQ+X4oDdC1zf7xdEYIJtnyZr1nvrJuaCHuorShSZ8YpfZC7VlN9+J5CBcuPnXy/0XpyqtOfNcKBBnpsAVKKGeQliJgW7DYGK9DuokgN4bekTASJe2P+ZZN/TiOyK1kGh3byOHz6qQVlYkVGN+MnVc3JbXeOZQzfv+6nMfVIUisqPFzCHqUJK3OOfQNbhNcEgeg2xGrtnqmZmoeHznOj8O6I8T2Ux8c5FRt/MwR6f4l18nRfCOl3S8/kNc7HIwu5AJGxg/VI0vi+KMBVwai/8OBYDx20llKMjwOMFtMIUC5FB6xNzXsF23l5E8NhaD8RQ==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM0PR06MB6579.eurprd06.prod.outlook.com (2603:10a6:208:19f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 10:27:02 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::3174:c9da:963:63c3]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::3174:c9da:963:63c3%3]) with mapi id 15.20.4778.012; Wed, 15 Dec 2021
 10:27:02 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude
 configurable
Thread-Topic: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Thread-Index: AQHX6525E9BoIskIRkqx58mIW7K4x6wnabuAgAEYVdCAADdQAIAAAK4wgAAM3QCAAAvxgIAABI6AgAF6ciA=
Date:   Wed, 15 Dec 2021 10:27:02 +0000
Message-ID: <AM0PR0602MB366630C33E7F36499BCD1C40F7769@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>      <YbDkldWhZNDRkZDO@lunn.ch>
 <20211208181623.6cf39e15@thinkpad>
In-Reply-To: <20211208181623.6cf39e15@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f0cc13a-5ca6-4ee0-0c1c-08d9bfb56f6f
x-ms-traffictypediagnostic: AM0PR06MB6579:EE_
x-microsoft-antispam-prvs: <AM0PR06MB657960BE88AEF4445F9CDACFF7769@AM0PR06MB6579.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i/txd+cMYbiqh3N93jOYVyl3Yaz/3bXp3oM8G2w24bCw8NO339u9hfaMky9veCQuSruBKqPkDq0q4dkryLBQF658+UktZoRNNH+0QyzJnmD/UzQLODnOxKCu0dTi3XFR4WyzcYJn/++0N14QeJMkJP0u2WJQrG/Xn2ke3pz5JZ60PqVlv3WZmzU4OiFbovz9pQF98+8dMA00uYhrECYytZZwDnepA7IUfrHCBU9zUuJpyndDio7tVQeXOHBlYdYgWLpAxIgvQQ4bcSzX1gT20j526mJENX1GlTdqVONdebUpjVBqYbodvPzTx6NQ3xnsBTojqn+JAalixIAm/RGNQDHuD4gDPiw6tQjyqsxsxkuASYlaq8U/olYCS2KN1IctV71gSEQI/C7MlgR5GEdtpAiFOqvcrDFvAgwYV1RkLYLYyo/ravs5BchRMzz6dX8Esim1/3YwLGinIktf2O+/zffdOAUwfKhrxT+HUPcWs6aNqqS76CIv34ptd3M6f6LYePwDqs7pTY8Z29O1T+/G23Don627LrDLyMXhDGi4HYoi8FMOwfEwb/gctg1p34YsbetMkPjNzShVdK+XiqhxYOl31olcOtrkJsnmiUCWVWRPL2ZDPkrLwHBIzp+jXxAbj0QmzYMRGPW2YxsX67IfwPaDjkQGIVabVQ98uEJmn867tZcgTC25CBOdabKRffgp1lprCr/jkgxKSt8ScYrdCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(4326008)(4744005)(186003)(82960400001)(26005)(38100700002)(5660300002)(8936002)(71200400001)(316002)(6916009)(122000001)(54906003)(52536014)(6506007)(2906002)(7696005)(38070700005)(86362001)(9686003)(33656002)(55016003)(66946007)(66556008)(66446008)(66476007)(76116006)(64756008)(508600001)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?OthWKPRKlHs//RQDcAmBX3W7SWcdxseCfG5x2EB0TYoGmNqpo8AuNPLQkp?=
 =?iso-8859-1?Q?VqJ7vPZuK+R2ebk3sHEiDq/2V+ZqndW+Hy6CR9awgXC8ydjG6EJn3XWa9s?=
 =?iso-8859-1?Q?oGcQl/fhpSi3aFtVlKwxoQbNfkB5NzIyPydrxU6CxFCcFIlFk2G+EVdi/4?=
 =?iso-8859-1?Q?DcGVTbP0IF9OgWehxCghk30gwQUM6rROg0L5IofCh7W5nwjsWTUCm356tC?=
 =?iso-8859-1?Q?yez0afCZomM4OsPc4gSZeEcNuwNFIKDOBPSecmeiT0+tbf4H202cJwbKIK?=
 =?iso-8859-1?Q?2w9f4/A921QIusGJZF5Kvl3oyuqzFJ0s+6xK720A2RD3ggAl2+43Cp578Z?=
 =?iso-8859-1?Q?Otlso4uYvo363DkImzLaQp4tmhEsAgoVweW/VhK1blR8Ky9+SSvu3Svt27?=
 =?iso-8859-1?Q?WIN1TGPftN4a0UqA5sdl/8fI659ejD7HC3kr9F+O7NmptINVQT4hZbg6hH?=
 =?iso-8859-1?Q?BoSCOr4rjdhoGhzuCxs8HkQmsK9oBqmk53dsm4y5gSgfAZjK9YxlcEUoqj?=
 =?iso-8859-1?Q?SPMXkOGdZPJ6i1XYHMGHQsIjZ8F066DMK9FgE8RIadLNysDst09eUYM9p0?=
 =?iso-8859-1?Q?XGgiWNNLINqp0eRF84mPHHqT9JI9d0wPXMYF8bRPRaHldtNHeT/SgxrnIn?=
 =?iso-8859-1?Q?OP2QlTix914ED880pSeY8uANuxogVhPQnbHeQnMJhzh7ACvsU1wE0QiC3u?=
 =?iso-8859-1?Q?3Cyg/UbCdNzVXQfeL+R5jtvwCJtKIQz9K9puvvuG5n2192vhekhfLUZUQ4?=
 =?iso-8859-1?Q?KJFWnvvAu7nJflKWbgAk28V0cP5+e2b3/69hOfhEN1OBx/VzrEPuhSocdx?=
 =?iso-8859-1?Q?vBMeLJxvfQoTkbBX/kI4iYmlakbOd/94JkGtcDPFXOGV3Q7uEFJh7F+F9O?=
 =?iso-8859-1?Q?ouh2DhoRvg8dWl2gcT80mpu+cd+L5/Ysof/rAel5cpVYbuCe77IXl8VysX?=
 =?iso-8859-1?Q?2OifmDpH/ItJ5RDuo02Epn8oGrYu6yq6FS5ai2gWvFtcalH0Q96thqnAOt?=
 =?iso-8859-1?Q?wR12fiTGbg1JcSYQLirC00RPq2v+j0+jX9cQkcAeCsZlb+glo9NiHuxbkF?=
 =?iso-8859-1?Q?5L/00LbtcTDQP2gVJgEaGmk7xuRuBqcmEYSOfLaDHzKDxmuZrPrKluwiJe?=
 =?iso-8859-1?Q?5Z51EN55NMO+e/ZIvVCYi0Ch/pPACFZA7Ln1kzxDgEaX90l6vvi2joPcbq?=
 =?iso-8859-1?Q?bg/9Gow3taHhqfMpCBawtZXwLPk5jsWCTnOH+CSiHQ7ud9ClnBkMIpzswS?=
 =?iso-8859-1?Q?0MZloGyGv1ydZgrNprYikXl+zkXZXc8AxYzxyZu574QHjAxQh+XA/6mlgB?=
 =?iso-8859-1?Q?P05zQJJYCkzVVLBfe5MMQPNR7/X924in9cFLIkXbUWqyeQwMBMoD2KF0ma?=
 =?iso-8859-1?Q?/bWe/c+uInoqB/gYGCX34durM2S1pUWYdb+Z/7I2An+CSxjRmVCsP0q/gh?=
 =?iso-8859-1?Q?Bqc+r7rAFgyWaT4nKHVSG2YZH0e7D9A4amavo745cWH1O0Q6ZJ2n1xLRx2?=
 =?iso-8859-1?Q?8LzI4z7PH77cYyYUEMI1Q9F1j4UV22UHtxB7kv4OraeqW8A+c2T/qlneto?=
 =?iso-8859-1?Q?5sfGuTEmMsT2RQ/Gwm4NipA/WUMEr6jKLIA8MiwLp0DHaTMKUPrIedDtyB?=
 =?iso-8859-1?Q?ya15ZmZEBCqXgvSo+1/4OaScEwOM2E4ZlR9PCg3ceQMvmNd3+mSF03sX78?=
 =?iso-8859-1?Q?UXSTNCJRNcZg7+3XETnfXohgs3zf85XPZJCCRuQZBDk7s7EsLpOe+6PB7o?=
 =?iso-8859-1?Q?5Tzw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0cc13a-5ca6-4ee0-0c1c-08d9bfb56f6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 10:27:02.8389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yjq5umX7uJ5huPujQldPhsTnFXnumEU1dUqsv27wg0JZPsKJOUt5eveNTFfSeax0wNDbJjQ0tJr4/23V9r5EmPIrMs6ibYcY8fXPcd2CKbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB6579
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

> > This gets interesting when PCIe and USB needs to use this property,
> > what names are used, and if it is possible to combine two different
> > lists?
>
> I don't think it is possible, I tried that once and couldn't get it to wo=
rk.
>
> I am going to try write the proposal. But unfortunately PHY binding is no=
t
> converted to YAML yet :(
>

I saw you recent patches to convert this. Thanks!

This make my serdes.yaml obsolete then, correct? Should I then only re-post
my driver code, once your patches are accepted?

Best regards
Holger

