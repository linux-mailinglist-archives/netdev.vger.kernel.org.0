Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFA3225D15
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgGTLEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:04:48 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:13795
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbgGTLEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 07:04:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9qnQX2NepmsgN7mHz43ApBDa8dKS5UvMZxNkaEconFnOFgjSwjlAdWi93PbzrBCESo0XB3U58q21D9FY6HPLIYD4szhQXwsCDptcjN9qThp+5Jt01je4HAfhNpfmmYDnb+mZ7Bu8yl4yfNb5+Y2N0POR+6+OqXp49KrdOfbUF+CBGa3g95lfjUm8fjaBi18Q92Vjm6JF7cph/L5+O8TIrXuhjDCKMJb0xR8tVnej/Oa1xF6dtb2PU1hIMroCPjoFds0h7nEffwEfOB34Xgq+IXSs0NZ17P3c/k6rXxkJ4BHPEu6ETy+Ty73E7+abFKje6OswD84DCdt0yrEr7Rgyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzkPV9JOyJV3WZ4TU7e6GlD7MOjlnEchY5o1Hh7L+Pk=;
 b=oSwc0YxNS7FvImWEqz2lDCgz4gKu+nTIrqbRopQ6E7IzZax1ioUThUcQu+oLRihhUpqlQwFZEfMBzRmtb5gbb5sTWbpGBKquRiYd5CT8be76QESLIpKyj9bGcEdaW6czZXtI7YgWwiOta+w5ZVDtXt+PTe9LUKCZGvtDHoq3j31wjSFZFc9L1q3vTEgQtF7sPuS6RCc+vauAvyLyydmaCnx8+J6DOrVDBqcdgk2Xu/5SpsLKs0RhsVInf/pZ0XD+qNBqAVSTZXVAraL913sJAapgbH1Uk8dkMTmXNDGPuEfWayBgxmVwzZ8+0uKOPGNNvfgtGJn3ORqbIqUItQLvkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzkPV9JOyJV3WZ4TU7e6GlD7MOjlnEchY5o1Hh7L+Pk=;
 b=kqJAJ1cHJPb11R/0rr895ES1ykZ5O1c1GmycRzXkXShZRemw+02CNzc3M0foYReMSfbLw6Fd8nK8ojjmjrxYP7Zf8f/siWcZBqLBqUuzg4FDVNyg3sV2juqZcfpdGY0lt5xHiD+sablSTAJrvdSq9UeRsKu3wiH157Lbd6Ox6rA=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB4107.eurprd04.prod.outlook.com (2603:10a6:5:1e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Mon, 20 Jul
 2020 11:04:43 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::346e:3fb3:d929:b227]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::346e:3fb3:d929:b227%2]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 11:04:43 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Thread-Topic: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Thread-Index: AQHWOJ4IR5sw1Ew6RUWo30td44MCGqjFAIOAgAGq+gCACByDgIABgUeAgAHscQCAN6b3AIAATnYAgAAVANCAAE4SgIABGeCAgAAaboCAAKgRgIAELWsw
Date:   Mon, 20 Jul 2020 11:04:42 +0000
Message-ID: <DB8PR04MB57851720278B98EE6E348E22F07B0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
 <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
 <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
 <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
 <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716085044.wzwdca535aa5oiv4@soft-dev16>
 <DB8PR04MB578594DD3C106D8BDE291B95F07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716144519.4dftowe74by3syzk@skbuf>
 <20200717073411.vjjyq6ekhlqqnk2p@soft-dev16>
 <20200717090847.snxizsgaqebbwyui@skbuf>
 <20200717191019.tvkmwrw2xwdxzmds@ws.localdomain>
In-Reply-To: <20200717191019.tvkmwrw2xwdxzmds@ws.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57082c96-cfdd-42f1-e5b3-08d82c9cb4c9
x-ms-traffictypediagnostic: DB7PR04MB4107:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB410707AB44A63CCCF360562BF07B0@DB7PR04MB4107.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCvBng8/PjY/noWFsjjmIJH4bW8ba0ZllkPq2/FqpTVMowVEz8LBlJ1Z6bfscvjHT688G89WEKrqqB3KcNikZ2CKs3BM85D4Foot7wD/vpqxDhViGfvtmW6XuCUXlhl3OTpcamdbmq0NCLMuFg0Rgx0VyxLSqExfyhjaaKnc8yyklYr4f6rOKhzdwrC3em/fNDwD3psIbIbyGMyjRTEvKU4ie7dUH7H8gL/bUiQa3Gq/ndes3mEUiI/cGU1RrkZSmcNwAK1o5xlO9GPvSAhrOUBCltFkLOJdT2tF0dK8Os7SKz/ns8nVvhwnMcgfRSqVOiyj6rH7JnUorvPrZEpkHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(478600001)(86362001)(316002)(33656002)(54906003)(76116006)(5660300002)(8936002)(71200400001)(4326008)(66946007)(66556008)(52536014)(8676002)(7696005)(6506007)(9686003)(186003)(83380400001)(2906002)(55016002)(66446008)(64756008)(110136005)(66476007)(26005)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0z0VMHgYZBCds3nJcY2ZmUzusYZl5hyChDRmozWqwvgRhoG+DlcwlY/rQA3ER7ZsODalfl7JHRdB0lL51+OlrXSQEedxI7tY9dGY95dIOSgPNZ0r/jVqT4une7V8n6X6pn67foX1gjZrmkWFCsBVYwFd7+0xxJvj8ZJVRfzO7S8zjREZJQ9h7YurwGVJ8weysj/gjxgoft4NoeFNgVdz4mD5JVNgGxaLLnrAqtnc/Sdc+uOuPnvgt3t88ASQT8O5PpltjuTSj1tx38gPTfp79jAKS3TSuDkBj1/ujBcKneDdm21mDTnaHYe84w3cmmMsOpH/2V0PH7QvUH4O4YpKVA3zLw97V8SwUAzqe2YPGdf54+nIAtYZzVFhYFdhaAhLZkYAJrOR0Hlexxv/mJ+ZXDwhz6ZVikNgfHIQekUXeX87bQFvQdPCaBN4Jv9KtbhdoQowXsdhYX7+wOjVDst84AVT5jQTDMTjMEXYLPo9pTY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57082c96-cfdd-42f1-e5b3-08d82c9cb4c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 11:04:43.0377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXZNql6flyh3LeZ/kbk7icg/gTuiKUj30TtzG1mTgsLuBHKk3Am9qmVIdm9Np8aj2pp5VViHSm6We5dFsqm31xZ7EU1tDjK2JOAMOjTo6KI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoxOC4wNy4yMDIwIDM6MTAsIEFsbGFuIHdyb3RlOg0KPg0KPiBPa2F5IC0gSSB3aWxsIG5lZWQg
dG8gbG9vayBkZWVwZXIgaW50byB0byB0aGlzIHRvIHJlYWxseSB1bmRlcnN0YW5kIHRoZSBjb25z
ZXF1ZW5jZXMgb2YgbWl4aW5nIGRpZmZlcmVudCB0eXBlcyBvZiBmaWx0ZXJzLiBBcyBmYXIgYXMg
Sm9lcmdlbnMgZXhhbXBsZSBnb2VzLCAibWF0Y2hhbGwiIGlzIHJlYWxseSB0aGUgc2FtZSBhcyBh
IGZsb3dlciB3aXRob3V0IGFueSBtYXRjaGVzLg0KPg0KPiBMb25nIHN0b3J5IHNob3J0LCB0byBt
ZSB0aGUgbW9zdCBpbXBvcnRhbnQgc3RlcCBoZXJlIGlzIHRoYXQgd2UgY29tZSB1cCB3aXRoIGEg
ZGVzaWduIHdoZXJlIHdlIGNhbiBleHBvc2UgdGhlIDMgbG9va3VwcyBpbiBJUzEgYXMgc2VwYXJh
dGUgY2hhaW5zLCBhbmQgdGhhdCB3ZSBoYXZlIHNvbWV0aGluZyB3aGljaCBiZWhhdmVzIHRoZSBz
YW1lIGluIEhXIGFuZCBTVy4NCj4NCj4gT25jZSB3ZSBoYXZlIHRoYXQsIHdlIGNhbiBhZGQgdGVt
cGxhdGVzLCBzaGFyZWQgYmxvY2tzLCBzaGFyZWQgYWN0aW9ucyBldGMuIGluIHRoZSBmdXR1cmUu
DQo+IA0KPiBJIGtub3cgSSBoYXZlIG5vdCBiZWVuIHZlcnkgYWN0aXZlIG9uIHRoaXMgdGhyZWFk
IGZvciB0aGUgcGFzdCBjb3VwbGUgb2YgZGF5cywgYnV0IEknbSBjZXJ0YWlubHkgaW50ZXJlc3Rp
bmcgaW4gY29udGludWUgd29ya2luZy9yZXZpZXdpbmcgdGhpcy4NCj4gSSB3aWxsIGJlIE9PTyBm
b3IgdGhlIG5leHQgMyB3ZWVrcywgd2l0aCB2ZXJ5IGxpbWl0ZWQgb3B0aW9ucyBmb3IgcmV2aWV3
aW5nL2NvbW1lbnRpbmcgb24gdGhpcywgYnV0IGFmdGVyIHRoYXQgSSdtIGJhY2sgYWdhaW4uDQo+
DQo+L0FsbGFuDQo+DQoNClNvIGNoYWluIHRlbXBsYXRlIGlzIHVzZWQgdG8gY29uZmlndXJlIGtl
eSB0eXBlIG9uIElTMSwgd2UgY2FuIHNldCBvbmUga2V5IHR5cGUgZm9yIGVhY2ggb2YgdGhlIHRo
cmVlIGxvb2t1cHMuIEluIG9yZGVyIHRvIHN1cHBvcnQgYWxsIGtleSB0eXBlcywgd2UgbmVlZCB0
byBhZGQgaGFsZiBrZXlzLCBmdWxsIGtleXMgYW5kIHF1YXJkIGtleXMgc3VwcG9ydC4gSWYgdGhl
cmUgaXMgbm8gdGVtcGxhdGUgc2V0LCB1c2luZyBhIGRlZmF1bHQgIlMxXzdUVVBMRSIga2V5IHR5
cGUsIHdoaWNoIGNhbiBjb3ZlciBtb3N0IGtleXMuDQoNCkluIGdlbmVyYWwsIHVzaW5nIGEgZGVm
YXVsdCBrZXkgdHlwZSBmb3IgZWFjaCBvZiB0aGUgdGhyZWUgbG9va3VwcywgYW5kIGxpbWl0ZWQg
b25lIGFjdGlvbiBvbiBvbmUgbG9va3VwIGNoYWluLCB0aGVzZSBjYW4gc3VwcG9ydCB0aHJlZSBw
YXJhbGxlbCBsb29rdXAgb24gSVMxLiBBZGQgUEFHIHN1cHBvcnQgYXMgdHdvIGxvb2t1cHMgb24g
SVMyLCB0aGVuIHRlbXBsYXRlcyBhbmQgc2hhcmVkIGJsb2NrcyBjYW4gYmUgc3VwcG9ydGVkIGFm
dGVyIHRoYXQuDQoNClRoYW5rcywNClhpYW9saWFuZw0K
