Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0751341F1F9
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354687AbhJAQS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:18:58 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:30958
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231913AbhJAQS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 12:18:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZNxSBCnYn8wKZA/Eklw9XDK+LvlqS8k94JD43BfkNhhay4AJLXHsoBHy+XgbHhlYWPC0jhKo0g6xKpNQsfabgSXgVnjiz7xv7ajbDikjm9RPDQAisbKvOB1CAgCHaF90uXF/K1+54AFV7KzWYKUOEwy9qLgjPiI5vI4yV0P4kJYJND+iirMDh+PTL0cazhdns/uq8m8PYabOvmoIkpYELV3K/QeCb6x7gqihBVYRf6I9bcV6dVytY4zHDSPGM/swlFl44faMJ3bJTqOuD0eQ8MW5y6NW59fpm+YZw5pUbygsf8dm3injJmJSyu/8OJXFmkngM80SeBayvrCE+jhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFX3tiNuch/Qz6BzSkcS9sOmWEpGRIQubvoKm2OHEaU=;
 b=egIYfKL5HX19x4L6L75tRPrs53ahPimRWpmwgaNXvgT6zUKPHemKtJV1bOSy7bVzf3yhB1XcQCvkyUrDeMOCNSFVZ2cvZBM6Tz9AjDSyyPRMAzXztXSDe9jE8vTdBbsFYTZH6VmcpWmOymq7gGYrsvkgMyH5MlB1spOGnq8yoJm9FbDTbWMTtcO5v2nIL2GzN0vNiiSQYV98a4W/uLSGtxYFME0YW4taopLlDCZgV4u2MNREUmXD6zUHPBcvewK4MiBUlyj3Nn7uqSwCMJZRQekTkwN3cEXYUgWjDQ7tU/dsqnzmnAN3QnPJpZ5SX3j9I9JoAm1XiLEpdyw18erB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFX3tiNuch/Qz6BzSkcS9sOmWEpGRIQubvoKm2OHEaU=;
 b=m9Yz7bRfkTB3QeYBIoWpEN+KqQEXgeWRvkCq7tBCHFJbAq93VQAgcc6bbAD+KKipMq44f3506QUbnt/vewnuZI5Q83f74XZ/vwQGDEDmSiYjKYdBj5iwfOxw59caS3bQJeYxmdKZ3IbB8WjUIFEAfbqoYVGbn+cCsXn0Z1Btr8s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Fri, 1 Oct
 2021 16:17:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 16:17:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Index: AQHXtFznyGH2JvuT50mNvd/a5fV2Jau6CVIAgADGvQCAA4bJAA==
Date:   Fri, 1 Oct 2021 16:17:11 +0000
Message-ID: <20211001161710.2sdz6o6lh3yg7k6p@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
 <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f497b6f5-8f3b-4988-fbae-08d984f6ec75
x-ms-traffictypediagnostic: VE1PR04MB7471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7471E35D4F81010962EE4027E0AB9@VE1PR04MB7471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TX6avSk+wBt+WQ/FjlYALgAhoiGoZZd56EEdhNugKjgZN/TuTByqivVH+qkJvm/mqD0pJMNQjQHhylLGkBySm3dyGFjqB6/mJyW/9UN/MZTkZkdOfKbVEgd4c5bpx4TP6Eh8JHQflCMPVRq1NgNtFKWMODoSOXnEJ/lFXNLSKC9CLvpdwQUa0MQhis00XCPL6s0CKaSVnthuaQybXJT8GHNR3pHuwqs+wgJfvXiYEOFqQ0OaiVp+My2s/Jacou204fQm4Z+wnZSyVDsn/E1iJni9npwW3RU36guAPMUYHkmJ7ccBvDmuG0bYUMEzAS3QtoJLoAxpVE1Yvxej/I3/OjiqNb1ZjSv96pbEUuhkM9SI+Fb+S+RBDof+pN4OkJqMOcc/2McGWWAlgYSb9gIK+B18PjyPGHJwJh3IgToIjECkApm42eLYQB6mW+iho/IHDyWrJRmGpGNkj/x3Oukjx6ZCkKNAIVkJa3jHv9CIOFakw2rvcMGd8agBlWKvPwoxYfw5b7y7LzHQp64+yiPKiJG+1PwLMFTy3FIGjQW3Q/P2dlr6Qi3B9zBSuXHXlF9EKm3OsHSwbzrmPsNAhRhEh6ZDs1WN3nyrkuLNKUt+EAIgh3KTydsu7Wi7XkJg9K2S36882SCRJkV2tLgpQv2GH/86KZGKhAE744cK+M9ezw2VAlMo3Uuk+5Fwciiv/yRg1hTMDKvaxXywXjoBO5TOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66446008)(86362001)(6862004)(64756008)(76116006)(6636002)(66476007)(66556008)(66946007)(1076003)(122000001)(38100700002)(2906002)(91956017)(4326008)(38070700005)(6486002)(44832011)(33716001)(6506007)(53546011)(8676002)(316002)(508600001)(7416002)(54906003)(9686003)(6512007)(71200400001)(5660300002)(26005)(83380400001)(186003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YL8cp9Km921ukK/3Zwb6SwXHyrMO5u7xg83wyU7YLrQLWjNs8DwXU2mRcSBc?=
 =?us-ascii?Q?S9WEOQ+QLZqbuDIzL5FDgOngd7s2v5bXOjVdQYCGJTTZNlXyDFXXDmZZRUl8?=
 =?us-ascii?Q?cNWjRkSNaoM0WZfjnFM14ATApQVv7WyigwKB5sue1ZN1+TFWTHlBiw0vskcm?=
 =?us-ascii?Q?HbDgfZYOWzhcbCm0D4PgzeXiTdrpDlkYdIernll8HHOZnDl0p5M55qWu2/GV?=
 =?us-ascii?Q?DwBkl+JGZmh0ZNHymYynu+SOvLxM/niUhRvKscf+gbLOislCwIn8rflhCbFH?=
 =?us-ascii?Q?kIqitU5FJ4x2ojsdj4PwqlINq5Br1zcDzm1WXAItJnvHJgwKW/XKTf4PUDDp?=
 =?us-ascii?Q?ephB4w/gRkzZg6MYbZ/Xhajhz6k2aFggYo2VfSgg9n3FfGIa5ZYTG1EkyrQ0?=
 =?us-ascii?Q?p86PBu6XlY4KRsIsMNSwhMkO6+wrDorKdRa6kYMLvfBiGIzt/j0rRa/JyCbz?=
 =?us-ascii?Q?4cfrIYre12OmJAmzZZLQPc+vjq63bl2nY7oO9qQEUUwRLokT5E5gj+611mpb?=
 =?us-ascii?Q?NoaClv2B1BeWo6PxOBlOmC8ysJd5OUYhwmlhMdQlKt4PJZmCDCFRzNxwZ+EH?=
 =?us-ascii?Q?pNaoHzSgtPEYhDvRnquBHozJ4N954xYf5NYqcGUMbMNFkfQBPXEh3pDc7P5m?=
 =?us-ascii?Q?fDvEQZKElVdpZSruKXiNpCoX/bvAe4Wvvu/Y1i6S9McX2sGVloLe+kax1XTK?=
 =?us-ascii?Q?IkKNTFZwrFAKQk5Kv8sGlV5hJspzRlUejIDeOgqYlIWf9HlfFXJ/9b0fzzZR?=
 =?us-ascii?Q?wEybmBd7CByfNQkMiM8HBmLg7HoDciycAweb9KOeabynBweh7PfPxw6RuSch?=
 =?us-ascii?Q?WmzAu2GPz+NYXOv5rzai7PqKgVgu6ADCE87kAPQoxDUIP8VAgK3R0Lufg2ak?=
 =?us-ascii?Q?F5ZhW8gdmAVf7d2eiZqWI7ZW62OR4U9HFZzIDp1rweL6POtgusVcDQ/BJmKG?=
 =?us-ascii?Q?i8hnOCalcu5hi/Ttbl4OlCjeoEJCPYY4dgRvPRBfM7H1/PHtgTEutbWp4akK?=
 =?us-ascii?Q?cL4XlkWIpNQ1wBItuYyKEFfNRLV7IQCsIEQ3JrE8OMIlg07P+drYXlQPrxx5?=
 =?us-ascii?Q?7Pvpu6P5iJgtnmQTp6KqVsn3NUYNnS5X965uooI8X6fFEIfN+jIWv90qmwGI?=
 =?us-ascii?Q?ITfPdniF9y+c3h7qMp637mmk8hTAsLPDVn5tZKHrzfNrG9NEsskYQ+RblWNr?=
 =?us-ascii?Q?4+hY+HKTySZtFzcNx0xppklXVdHjz5d/AAAtrG8QYEVhRuoWnZ5Jp5yXMDyz?=
 =?us-ascii?Q?mlJRG3v/3TBuXHavpoXCcVadmWVCSKdF/fioQsuUKijqwL3QAHUHzMTKGiVV?=
 =?us-ascii?Q?A0IW6EvjV2W5zjREaUctAMsA?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8BA9500280EDB04E8D5A3434AC3896A1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f497b6f5-8f3b-4988-fbae-08d984f6ec75
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 16:17:11.1773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRAATmoNkENWtFNpL6BAAXyeAocWGH6aKl2Nu0eOk8errl54QEnwsToN3mNS8KtknriJluXANrRnAadzrcKI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Wed, Sep 29, 2021 at 10:25:58AM +0000, Xiaoliang Yang wrote:
> Hi Vinicius,
>
> On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
> > > This patch introduce a frer action to implement frame replication and
> > > elimination for reliability, which is defined in IEEE P802.1CB.
> > >
> >
> > An action seems, to me, a bit too limiting/fine grained for a frame rep=
lication
> > and elimination feature.
> >
> > At least I want to hear the reasons that the current hsr/prp support ca=
nnot be
> > extended to support one more tag format/protocol.
> >
> > And the current name for the spec is IEEE 802.1CB-2017.
> >
> 802.1CB can be set on bridge ports, and need to use bridge forward
> Function as a relay system. It only works on identified streams,
> unrecognized flows still need to pass through the bridged network
> normally.
>
> But current hsr/prp seems only support two ports, and cannot use the
> ports in bridge. It's hard to implement FRER functions on current HSR
> driver.
>
> You can see chapter "D.2 Example 2: Various stack positions" in IEEE 802.=
1CB-2017,
> Protocol stack for relay system is like follows:
>
>              Stream Transfer Function
>                 |             |
>                 |        Sequence generation
>                 |            Sequence encode/decode
>   Stream identification        Active Stream identification
>                 |              |
>                 |        Internal LAN---- Relay system forwarding
>                 |                        |        |
>                 MAC                    MAC        MAC
>
> Use port actions to easily implement FRER tag add/delete, split, and
> recover functions.
>
> Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
> Action to be used for stream RTAG/HSR/PRP set and recover.

Did Xiaoliang answer your question satisfactorily? :)=
