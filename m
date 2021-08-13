Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605433EB687
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhHMOIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 10:08:17 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:56485
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235317AbhHMOIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 10:08:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjPdnGhN2kf7tO6kQH4YGf9DhU8I7+yhLTnGFRLELX4+SJkdWDrLTtEmR80f1K2nAKEW9bY3z/qkvV9ivsy/JA7tsYcwjDiRyrQiaifv9Mbe4GC2iWuGysMeJwB/XvnlVjXj698Dl9Z0vLfKacvh97zNX/a77i7XgM72gJyy9Pgk6TygXVLKXkNcRQops9EX9yaEqe+ka3hPnmHvwRDmLCGFUqFd8TkEs59hKW+nqu6fqP6K8MIcTIekJ0AMaApkuaK29CUjVs30nBgzJySDQR0l9mOGtuvpa2R8XQ/+j7H4awPaVvs5DbHZQvNnOZ3xjfQcbY2KnOzVrnsATt1FWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIk1epR4g3Rcu35TW2zifKT5+v+l9c5l/miqKf+lCmg=;
 b=jjfnsVHVmhHyqaz+zOPbxVTOpsLq8LM4EUD2EPHF2gfl/Rc2PVjlxzQAvfzIlcNeEce1x1YUeFegwFwcL57MYVP4MgDLb7GNV+UOs9+Yf9IE2eQmFOeNYiF4Q3Jo0nba63tScPTTinW+IKpFq30bPDIhXe3WhtYGnxQ+k4xvfxmRXg60y+dytGp0RfCHmPVejXLufqn+N/aMbvLpqUbpMgIgFFNWwkMwgR2VAtflQIIqYET5lX9w6CBspLs7d0I8gmLpLBrnCIZBUmUYIdXekk5HrjtpUrJlkdQpIVlw2zQRMEpvVfCp39tBi4PU7YMMhRVhq7rrQMf/yyGyQ53XyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIk1epR4g3Rcu35TW2zifKT5+v+l9c5l/miqKf+lCmg=;
 b=F+Zntg8wLrRaMKXox/Q2r0R3pYXwIplhGLgKgE97PwaYvn9gfiIVFYP06E3yxU/EbGzWH87nw8/HQyvjKXgr7AYvc+jAFT5VdbfwQjI978sS/NumqEn3jZYNihLm9IcJ/saXFdoyLgIvzbKcW5Zc8hwput/7vdOj9BLKfVmNdWU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 14:07:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.018; Fri, 13 Aug 2021
 14:07:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hongbo Wang <hongbo.wang@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Hongjun Chen <hongjun.chen@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Topic: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Index: AQHXj+75z1qD/BGTVEaJLO5FNXuRQ6txaSUAgAANIYCAAAMJgA==
Date:   Fri, 13 Aug 2021 14:07:46 +0000
Message-ID: <20210813140745.fwjkmixzgvikvffz@skbuf>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
 <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bba11f75-2b07-4462-d6ec-08d95e63b9ee
x-ms-traffictypediagnostic: VI1PR0401MB2512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB25124F82CFC88729C812E83AE0FA9@VI1PR0401MB2512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ki9cuGRdq+5J6pKH3UBgVhwTUuFTXyRg72Fp7DLVwo2eqPTjo3RfLikJgl8jKE6sH69//H7nG9qEJPOisXU0oseS1IUZXdvk+eZgFxbuwbkF6LoUJDGKb/hmXyR8rFOwMBKeBdJQE0wtYBhOtarusQlZicZ5t8wz7q6OCvxxF0ErdYH+zbYPJaPAIoyjT+eNCqURm+ZAaKnS/EBJeIxGfAnF3m7wiuGotibOg7k7cUVYO/EF8Kh2PTNY19VltajJM2YyrK6W8XHMccj7ql2LjVp+10Y2KouCerxIZSuzA6wlHqhhACRIGljQSyN07sIHZZjkjdgipBXRLIYAoGvxPTmS6OR433dfVCAE+wz/NIDDcSoNomViwPWIDgTybX43U0YrjxGPOywqAwBxiVY5TO+87Ebvk6LkSg/ulzQI3e+76tl1sS+KBQd2E/6ufMRoU12dm4fSsC0hFhY1+4bI6PHLkZmSCKQOdwWA5AunZE5XPh6Y6lS8FhBtNTZMSvtnE6be24rPZg+D+Q8tKmdjRKvCM1WE70Q6p14qGFZQq3LAngdEkzkvcu3PcuXfT6WMiMLlVm3Ley0i09f1EbKZxDmF4/oFeJixcNxymz8PJTl8tdVpvxt0GDXNhpQGbrfl+NoT3235gY4gdeqpiIzuAjHqd7If6ai9wGEpbUQnYALRmMO7MaLTniFponCkViIF/gFGviLc1x2tHBxGEuD3ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66556008)(66446008)(6486002)(64756008)(33716001)(5660300002)(38100700002)(8936002)(186003)(66476007)(8676002)(3716004)(86362001)(508600001)(44832011)(2906002)(71200400001)(9686003)(6506007)(26005)(6636002)(83380400001)(6512007)(122000001)(6862004)(316002)(4326008)(1076003)(7416002)(54906003)(38070700005)(91956017)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7OSHdI0VzdcZrPs9M4SNvnvanBMkyACeMZ3fo/YTEsXHuLw2mcyRv/7kYiWI?=
 =?us-ascii?Q?4OrWkKv79hQ5L0SgMOhz5qgUmRSBuiq0Ga5QUoz00rFhSWPRO8p8Enh4+0JK?=
 =?us-ascii?Q?fIBIL/AD2jcnBLCVEg8GMr5rc4dsjGVJCagdr1Yj6/mpOoab5JWmWox9/aFp?=
 =?us-ascii?Q?58NUZok10Mq8VYUhmeVyjhKQ0ssmMPg5wldsErCeJ4XDK6XnzvLCnad/OZHF?=
 =?us-ascii?Q?AHsbvdJj7kdPqP3YFTp+4tcmO4khlJys8Yt6TrdJzFdpNlB3epibcibffXqE?=
 =?us-ascii?Q?S/82NmFoMPbB0ZRBBSkBEWBc4Z5Gb5XDA60DCbm2f1wZMfvemvmLQHHiUDUU?=
 =?us-ascii?Q?L79g1MeyviHmcDrE7JjhrcGU5rMS1soIjv7gLEOfTr+ugXqwGORpPncKKJq+?=
 =?us-ascii?Q?1cCyqCXVTfEa1cqa60a2B87vEy7qk/cha8nOia5852jlQWRzyuuW7LRS1uM1?=
 =?us-ascii?Q?fmqLgu5T6ZBWYXo6dfqELy/NAQ/7KFGQ+wjDqA9zECDl1aKHVnDoTQlO70zO?=
 =?us-ascii?Q?0gXmIY77rV047QtCkOcscNQszz0MFbVVJyfrwV01+fkBT8fYS/4KdVbxHKeI?=
 =?us-ascii?Q?QlEFAiB4Cr1DeQb6ekhjTGtPu1UztEVoGZUfH6Su4KHe32Zts8ncuJR/qqs6?=
 =?us-ascii?Q?YS1XUfeyWwlE5P3IiY+XOPKSz451LWqIOcl7TYIHa+CbMmfa6i8A9xO5XUR1?=
 =?us-ascii?Q?Hl35WPbr3rYIB+uTI6HohIq15k+zgBTHFTadBQ/ZJJMLKDdd2fWHEVdISAMU?=
 =?us-ascii?Q?TLBYkMS80y45o0KUbNS+SU3HyuWB7VIDhdK2qTfg6s/CtiWwTwGGmgZrNSOm?=
 =?us-ascii?Q?BnKjVUqcJA6yk7H+YccY/9Dw+6oiczu7xbgzR2P27lcsIbFEohing89AOAFb?=
 =?us-ascii?Q?jcb1Xah1/BQ1e/ZzjBKEjYYcIvJowAzkjM9CrTY0gUH+MAWIs6KJcwGsUXsD?=
 =?us-ascii?Q?ahtUXiZ2Dz/mPjHpbyusOttw1nAOnyn7L4KY0csDgtaunFW8eRq59LJ1etNW?=
 =?us-ascii?Q?XpgLBrr0JRthLovpNuLmlPSVYlDTMt9yI/iC0wVXMPHF6R7gX/X6kvdkOP7J?=
 =?us-ascii?Q?yXbgJ1KSsSkPru7Nhol+wCvkEMtoRfyZSQSO7+Y1IShzgFTC7ytzlr0Fodok?=
 =?us-ascii?Q?1q73fYT7g4TNPXLy0cHeZqYxesD4sXl5Jp2S9niNUdJpDqtsS+U03Q4Gtw5o?=
 =?us-ascii?Q?0cPqUDWLXZa2WWy9ABNRQh17aXhTA5tZ0Dv2zo4AUokQn72JPu0gOKPD82Jv?=
 =?us-ascii?Q?oKSaW+DxUn+s81uekXfiFNtqLtAsIrdSQl02f2TLTJ6iYUodVGNRZrVmB0HH?=
 =?us-ascii?Q?hN7+g2r/a4A7rEPQlkKIKQnc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D522912A499D54B81DF80E89BDC11A1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba11f75-2b07-4462-d6ec-08d95e63b9ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 14:07:46.2877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MVVJT6sX2iZs0p4Uqe+AC1T2fBMaVhtTGQREkyErTWtfw/Try9RSmVULIIqskOJfSWC9scFaOw/eAkm030rcaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 01:56:53PM +0000, Hongbo Wang wrote:
> > You will end up with two DT blobs with the same top level compatible. T=
his is
> > going to cause confusion. I suggest you add an additional top level com=
patible
> > to make it clear this differs from the compatible =3D "fsl,ls1028a-rdb"=
,
> > "fsl,ls1028a" blob.
> >
> >    Andrew
>
> hi Andrew,
>
>   thanks for comments.
>
>   this "fsl-ls1028a-rdb-dsa-swp5-eno3.dts" is also for fsl-ls1028a-rdb pl=
atform,
> the only difference with "fsl-ls1028a-rdb.dts" is that it use swp5 as dsa=
 master, not swp4,
> and it's based on "fsl-ls1028a-rdb.dts", so I choose this manner,
> if "fsl-ls1028a-rdb.dts" has some modification for new version, this file=
 don't need be changed.

I tend to agree with Hongbo. What confusion is it going to cause? It is
fundamentally the same board, just an Ethernet port stopped having
'status =3D "disabled"' and another changed role, all inside of the SoC
with no externally-visible change. If anything, I think that creating a
new top-level compatible for each small change like this would create a
bloat-fest of its own.

I was going to suggest as an alternative to define a device tree overlay
file with the changes in the CPU port assignment, instead of defining a
wholly new DTS for the LS1028A reference design board. But I am pretty
sure that it is not possible to specify a /delete-property/ inside a
device tree overlay file, so that won't actually work.=
