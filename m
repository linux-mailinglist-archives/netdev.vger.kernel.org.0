Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4CF2164AA
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 05:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgGGDiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 23:38:50 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:56334
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbgGGDiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 23:38:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMABKDjkN2o189BMpY9JRciGHuDp0ViLZFb262n5c51lEZgMkeADOD4uol9LZ5buIg5vMjRUgUky+rIVXPrPxL9HHVYE1zHtJsz57wj5cKoPOekPkce2AWKmjrbfGNeFTafozdqy6yd3NJLtbDhYMB0PSgM4tMPRg55ot2kUN1ZV3N9hiwFQt/EzL736d/p8T9Mz18CsTx7NJfElAzy/5fMPigmRTKxjswdjVYsgdd6zQ4Rew/SzzzMyu/mUzB9+OAYM4YHNWml1YyWuYF7Zloj+7yR8kPzJiLHhn8vRKuBJy5bW4Hb9Xml+BtUf5h60NRs3HJYjxaBHowoQMQolng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jHC4TOvjgTEo40coA6j1Wybg9vg7m+4gelALYf92Pg=;
 b=j8oqS6c/yycwJ5uhxWl4diosju9ckO3rMBUYiGMNSbQ6lYpNV6Yce671YBLIXngOjeIJBbnXraDyMxdpQb/BM0/BvgXx6zJoJxIP47zEm4nJL4CK6zzct5jeMoVx4lyeZK53Pnvqo+x0qX8JBPXO2BwvBW1r90sKdhvOCd/ug7rGnrf4PJ2cq8BnsHcFfkECq0+/9XyRLx0SIZv5QJYI0D4ajPMhQnP7ncOiwcCdOnNWKJBSk/62WEVyi8bKO83or46EWPEoPDyVqzAHtYO0UOXc0t694lWXJ98pVl7W3IvReZ1WLIgtnfY3jwW6WkjzgViKZ8yfYj8Wy+BWM6NanA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jHC4TOvjgTEo40coA6j1Wybg9vg7m+4gelALYf92Pg=;
 b=L5iewm1YsVNzh7mLD4AzrMcwbGScAHtkEAEtAc6Kg5ARsmcv9ZMm35ohfBvEfT2vfPnMm95PbhIHQLUZV25dvkZZ+nf6/y1bxq1SHAB41q22MH9RoT7FUC0kCJ1p/Oh1YmGNDkXt86CgwcVIg34dOB3HJR67gFfoJDCm0ELWhHM=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR0401MB2642.eurprd04.prod.outlook.com
 (2603:10a6:203:37::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Tue, 7 Jul
 2020 03:38:47 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 03:38:47 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
CC:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Topic: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Index: AQHWUMBIY0/PmQIJzUKZXhlXPuzWDKj3d74AgAGaMECAABAPAIAA5FDQgACP3wCAABQBAIAAAHAAgADT71A=
Date:   Tue, 7 Jul 2020 03:38:46 +0000
Message-ID: <AM6PR0402MB36078DBF3B7737B1C3F032AAFF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200702175352.19223-1-TheSven73@gmail.com>
 <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
 <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com>
 <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAOMZO5ATv9o197pH4O-7DV-ftsP7gGVuF1+r-sGd2j44x+n-Ug@mail.gmail.com>
 <CAGngYiVeNQits4CXiXmN2ZBWyoN32zqUYtaxKCqwtKztm-Ky8A@mail.gmail.com>
 <CAGngYiX9Hx413BX-rgaaUjD9umS9hGg=gMLbM+QmdyEt2Nut5A@mail.gmail.com>
In-Reply-To: <CAGngYiX9Hx413BX-rgaaUjD9umS9hGg=gMLbM+QmdyEt2Nut5A@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a06ff749-b937-4d9a-186b-08d822274182
x-ms-traffictypediagnostic: AM5PR0401MB2642:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0401MB2642EA1D3464ADBA2CC2A5B4FF660@AM5PR0401MB2642.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A4vIqcXa60JRJTIiFs5XEkO2DeDGK44XzhtHncA/QgUVyz3jbEUxpjJIKiRwDd3jsxuTb7ofeNsVDFyGd2j+O+pVE8lODE+cyjbMIxlniLQF8iyXjRLyRY95/mq4aRsIj1REzFTYl0xjbKphm1/avki9VGd+hqkPUSegBaKdAYR7fiBgTtBwFWLt9PqlQPkKO0G3D3UNxidUBCKA0snwXELhpd3jwoyNdXySEFjsJsbfDjqTiEzzRs0tPlUXUExmjb7p+mr8k6FfTxcVUPYNmlKeUh5valb1GnLO2MrYd8KjSRtq3o9IY7MivY3MEYTz62jorR1kCE3mv9X+bzN6lXGhxlP8+dTgaThR/dXRSDTehCOXxkL5BkIh8u7erNAN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(4326008)(86362001)(71200400001)(83380400001)(5660300002)(4744005)(33656002)(9686003)(7696005)(7416002)(55016002)(2906002)(26005)(186003)(8936002)(53546011)(8676002)(6506007)(478600001)(316002)(110136005)(52536014)(54906003)(66476007)(66946007)(66446008)(76116006)(64756008)(66556008)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wb+GO4a03VrOxVTXiWbjM6ArVMYNAeH++uzeqlzM1UCS8RhZGpInu1iM5VAB5rN2jZubzuOQnfu9XnoEunCGl4ka1JoqmaVjh7rij+ncaXVLReo7a0AG1J7IDT2syzIc20oxHFvnIN9/QstPAjmxXCfmGXxAafaf+wPFvV9bMANDtyPI1NPjr5+2rsh21PwhtqaalKc9VaiQf+DBcMy7jACZ9gVeOggnJKVaAqd3GIbEHxLppvUwrZjBhepDv900wtzhfLNmu6zU/pLZDUomrAwJv0T+PIUj1aZ8q17W0dwUfiiv+jMmKLCauuh5fLokxBhIyufv2WvMhbtfxMapW5Ffg1R7GJeEtyEaxeDEQgy9dUVtr4wUUE2vUY46hrVjTv4ZU/c5ZwvoXyfh175CjAwG9PfjBE8oE2NEE+ZosfsKF2rRJI4e4vwQncA2zJ8P/93lkfa7ZaCOeKJzRwBVamp0gkEGswaJOO5qneVdB98=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06ff749-b937-4d9a-186b-08d822274182
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 03:38:47.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IfLAWBue8SGykUlkjeZncHKQ7WfM940vKDSgJe0FfV+ZM8BXz/EJxNT475emOpEQoJYxLkngXNrH4xJXCEodQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2642
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+IFNlbnQ6IE1vbmRh
eSwgSnVseSA2LCAyMDIwIDExOjAwIFBNDQo+IE9uIE1vbiwgSnVsIDYsIDIwMjAgYXQgMTA6NTgg
QU0gU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+DQo+IHdyb3RlOg0KPiA+
DQo+ID4gSGkgRmFiaW8sDQo+ID4NCj4gPiBPbiBNb24sIEp1bCA2LCAyMDIwIGF0IDk6NDYgQU0g
RmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPg0KPiB3cm90ZToNCj4gPiA+DQo+ID4g
PiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIHVzZSBjb21wYXRpYmxlID0gIm1taW8tbXV4IjsgbGlr
ZSB3ZSBkbyBvbg0KPiA+ID4gaW14N3MsIGlteDZxZGwuZHRzaSBhbmQgaW14OG1xLmR0c2k/DQo+
ID4NCj4gPiBNYXliZSAiZml4ZWQtbW1pby1jbG9jayIgaXMgYSBiZXR0ZXIgY2FuZGlkYXRlID8N
Cj4gDQo+IEFjdHVhbGx5IG5vLCB0aGUgbW1pbyBtZW1vcnkgdGhlcmUgb25seSBjb250cm9scyB0
aGUgZnJlcXVlbmN5Li4uDQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoZSBjbG9jayBmcmFtZXdvcmsg
aGFzIGEgcmVhZHktbWFkZSBhYnN0cmFjdGlvbiBzdWl0YWJsZSBmb3IgYQ0KPiBHUFIgY2xvY2sg
bXV4IHlldD8NCg0KVGhhdCBuZWVkcyB0byBhZGQgR1BSIGNsb2NrIEFQSSBzdXBwb3J0Lg0K
