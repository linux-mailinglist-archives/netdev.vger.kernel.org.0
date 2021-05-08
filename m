Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2342F377166
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 13:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhEHLWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 07:22:06 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:40288
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230234AbhEHLWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 07:22:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz3t7WNsI+wPD+ncytnW9C//oCcHW0DEjeCvVmslpGrwKpW56fcMotKIxkem7j3A1RsL6hR9Hp7cuAc631hUN0wt6KVxX8f/tiXF9nD1/1ex2zfpMd2ToR0kdb758i5tYgJgISjrmdc2fgHLYobgVe2nt96pfiDDN1TZ7EWt/nlh4i/emewdftQFexHGKFjuAJYUt4hYkWI514r0zJLxbhyrncCUzYzt0s6MNh8yCi5rPBaVCS4GD4skhCx4q3X8yGiyh1ezSK0TyJNNHN/gBC2A9m7hJ1sxN/bYwqnoKP1wRBEhV4D0n0wiV4i14yHd9E5H7aXO9op1ZRweu1AHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxpqAkuL5mQQiv3rBxYlEIyK3KaiPXiwHbmlaYhjYFk=;
 b=l1JNAhX5Cn/dVkzYpZvrKlgsC/3gS8SfmPyflODMjdL/MxnzNPdD2SuUZ+gg6wIb6TOxyySbdRJFh1JzRTYSVIDnvT6cQ4ZF67wXHQASUjXgCMDTnFocABZpOtuJz20ZAh7XiMjTtu0ewiJ7/V3jri8J7n44WzJasWdmbzv+8wJvYFOhYdYeZ5tyueTMyzev6h9QMQpi2jT6iFlkrMIV+mpx5aJg5RA/L0YhfQDG157wXTDl5iOurc+mWYHVV+Kjtr1ccRG1cRlI90f0EmQa7MyRDMy0DED7xZJi2umauxjz1yDTo5q8TR0tK2WVf36HHFYZTDsRTlq5r0/B/oIY7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxpqAkuL5mQQiv3rBxYlEIyK3KaiPXiwHbmlaYhjYFk=;
 b=h8oLdyM92YxfNbO2On+v/6RKvekfWag9HHmh68gGk4uh6EMMmNrApAAIz+VXJyDsRV7QtA/fQzgbIijlNzC+MZHBxa2/3qOU3fTMVGL/kMf/CR0v9gUkqCjLlv9hI0is31vrvANTTUVhVYrmgyGbCMwxOqTBOeVkt1Q/Em0erWA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7770.eurprd04.prod.outlook.com (2603:10a6:10:1ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Sat, 8 May
 2021 11:21:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4108.031; Sat, 8 May 2021
 11:21:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqq78qqAgACuHyCAAMibgIACfU4wgADPWgCAAW5iAIAT9FVggAIV2YCAAL0YIA==
Date:   Sat, 8 May 2021 11:20:59 +0000
Message-ID: <DB8PR04MB6795D3049415E51A15132F59E6569@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
 <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <c4e64250-35d0-dde3-661d-1ee7b9fa8596@nvidia.com>
In-Reply-To: <c4e64250-35d0-dde3-661d-1ee7b9fa8596@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 262d9b7f-680b-4e25-a834-08d912135ba4
x-ms-traffictypediagnostic: DBBPR04MB7770:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB777071EB05DA29BF7DCD620AE6569@DBBPR04MB7770.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GrzTJ9Xr2LtmvkjU93uJopxKcazl4ZSdu98mUFSagMVtfXu/3VXKIvgcoeBkO3a1JGLhNfpseoOkGoNmsj+WpcndlrMgE0nQaaXhFlBBkrNP0AV2IZSiSSRoeKX7StSM1cKFQ4xO1qk2bD0mkT1YftTFCJl9ER80b8bqLgOGGqBETEELuvlSRRJP8OWSiu88kgqU21M2A9H5HCTQOB3juSLbDAPaRD5WsqPLVorwTKLS/LSZ6+UX2574OsbxrBcsIxxEZWTcLmCp2iyzFIhFU2/Fs1q/beAv1FjxeXCdx/08GlFMCearMj7XY7XF7jmOkWR6ejRwm8NArRpbgxa94j3KejiuLMoZp8UfdD0ehCtoXQPtoal0ArB67Q/aZQlPZDJQqxNVllvSmpt7sXbg8QztnZ2QMFhJJIsVHg6FTVmzQXKE9E8fUsEyvqs//l06F6L08jrzZcwi85JLJxbvsfFCEg6R/rvO+XaEDrH9xes5DPqea+pJNOR7ENaQszT9iZioOOJbVOE0CHu98MM0rtl/KmJWm7Hbfjef60RlITlcUCDNZLq4Tx+Erhkn7gQ4hJNuNeqUC75MLodok/jxAGle5kz4sHlDG69JEaqt9+A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(316002)(186003)(8676002)(110136005)(7696005)(7416002)(54906003)(122000001)(478600001)(38100700002)(6506007)(5660300002)(33656002)(76116006)(2906002)(86362001)(8936002)(52536014)(53546011)(4326008)(66946007)(66446008)(64756008)(66476007)(66556008)(71200400001)(55016002)(26005)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UEhGeWRDai9QeXEvWEZPYVdOcmVEMzNkRHE2M1B1dTYxQTAvSEEyRHMyZEFH?=
 =?utf-8?B?aHRSV1dHaXdJS0doWkl3T25wc3JVLzZmU3N3SkI1emN3d0owL3Q5c0xXaXdq?=
 =?utf-8?B?SStsWWY1KzR2TTl0VitxZ1JRVUJuWFVwUmtqWU5sR1dRYWowTmRlTXNiTG05?=
 =?utf-8?B?NVdrdXR1ek5MZDRPQTV6Tmt4R0JnNkM3WGdFdHA3T2FkWmFmdjhyaVM1N0VW?=
 =?utf-8?B?eGhBUWNtSGtxUDh2b0RHei93SVI0RENrTE5JYXJYVnJIbE1oc0E3VWFaMmk4?=
 =?utf-8?B?SGVEWG9wL21Nc0hXYTMzSmFnRk1vYTRFOUFTMldnSkd0Z0dlNzA5LzlHVWdW?=
 =?utf-8?B?UkxwV2NtdWJzNVQxRTNjVmZnazZNOEIzTGZWMHZsTmZvYW1KajFvYkREVnUw?=
 =?utf-8?B?OWNMN3B3SHJyTjdhQUNSZmhHR0xYNmk2QmhrSGVxODdoMFAxQWpPUFhTYVNO?=
 =?utf-8?B?V0dPRVFCeE9nS0VhREc1Q1dLdG1zeWVnMUlvV1RnWGN5YzY1cHZGaGNnaEMy?=
 =?utf-8?B?UG9XTEk4TWFRODNYdkJoQXNCdEU5ZTVmMTVPQVJpSm1vWmtsa1JxVXBGdm43?=
 =?utf-8?B?MG0rckdHQTlKSkU4WHNvVklVZzEzYUdhTkdzSk1mM0lETkNmalhiSjJMdjJE?=
 =?utf-8?B?NTMzTmloUUFzZCtnVjErZ0lZcndPam9GZVE2NHQ2WDdnaGQvYzdPcHMwVjlm?=
 =?utf-8?B?UFFWMllmQnJDeWdSRzB4clFNQmZhQ1hOREI5aTEyREZ2aVdzdjBSOWl2Zkhs?=
 =?utf-8?B?dmhWQVNnYzRKNjhicXZRWHl0Qng3VTg1K2dQWmowblF5NzlKc0w4MmlUUGJC?=
 =?utf-8?B?NWFSZlYxampjWDRSUUs2b1gzb2N4c2VVSUJLZUthcURCeFRQbDdFR0NpVE5z?=
 =?utf-8?B?Rkx5VjYvM1JlNWhDdzdSZ3RUMlJmallnQ0Mra1l5U2Z3dVJDODMvVldtYVFw?=
 =?utf-8?B?SldpMUpGd004WGRlcUthMEY0SG9CdXdYc2ZoREcyY3R3SFFkRE5Kdi9ydTBN?=
 =?utf-8?B?L1NIaHJuZk5jaFJiZ0E3cFpxS0ZsNm9xR3JkTjgyTWJBMXlxKytYRFVzcHd5?=
 =?utf-8?B?bWVmTFplcXMyVlo4QmtWYmJkRnhsclRTWUhRUFBRZnhQWlpQSzQwcDZucHFT?=
 =?utf-8?B?bTFUWXY3bnE2UWNwQ1NDL2N3THJaUUxPa3hvRlZSNXRIWVh2aGx0T1lZbDQx?=
 =?utf-8?B?dFMyK1d6THhHdmpJRTFDQWNwaXB0UTN1cTAzNzZRSjdzWElidHdBZVJNUHpp?=
 =?utf-8?B?WkxKMzVUUnFYUUVIU1djdlpqUXBoRlQrODVLRDFsK2s4b1BMcGVZMzljK1ZJ?=
 =?utf-8?B?TmhzN25KL2xsZHN6VjhERlRURFhDNEtpQ0FmNktYa0hqRVZzOFd4RisrcWtu?=
 =?utf-8?B?MS9tNEM0Qlc5YlFDV0JFcFBZcXFBNWFrMjQrdnVlSVB0YzM3MU5HekRsMkRE?=
 =?utf-8?B?U056MG9McDZSZFRDNWZuTEFPK1hEN2hZS0dBYVNFVFdiUDE2ck5ISSs5M3hz?=
 =?utf-8?B?QTRsVm5yS3k0WUcwNVlkQW9qTjhrdlNGRC95SjhNa2ZieWh0ZUNCTjVQNldj?=
 =?utf-8?B?M2JCZ2hTaUF3M29hMUw2ekZBV0p0U1l0RFVXS0U3TDVrdDZ3L3FGZzJzQ3JT?=
 =?utf-8?B?RTlOdjgvdnFCNStmd1FPaFE3UUUvNzlrOEdKK1RaY1VNSTd4bk4wblFlWXht?=
 =?utf-8?B?eDUwNXl5K3VRaDZUc2UwMmpmNWZmNHFBOEdKVTZpbzVBeXZOQzc1WlVNTGNt?=
 =?utf-8?Q?3AEP13jhumE7i8bFwU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262d9b7f-680b-4e25-a834-08d912135ba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2021 11:20:59.9826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MnsjhN9Lo8eGqPZGYZzNpoQ4A8jeWJoYAw67YvqI8U1id6r9wxJ0dKWLjl5AZx+vlwyxF92Q34kHCeaRvYaU4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKYWt1YiwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb24g
SHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gU2VudDogMjAyMeW5tDXmnIg35pelIDIy
OjIyDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgSmFrdWIg
S2ljaW5za2kNCj4gPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5j
b207IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207DQo+IGpvYWJyZXVAc3lub3BzeXMuY29t
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOyBhbmRy
ZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+OyB0cmVkaW5nQG52aWRpYS5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtSRkMgbmV0LW5leHRdIG5ldDogc3RtbWFjOiBzaG91bGQgbm90
IG1vZGlmeSBSWCBkZXNjcmlwdG9yIHdoZW4NCj4gU1RNTUFDIHJlc3VtZQ0KPiANCj4gSGkgSm9h
a2ltLA0KPiANCj4gT24gMDYvMDUvMjAyMSAwNzozMywgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEpvbiBIdW50ZXIg
PGpvbmF0aGFuaEBudmlkaWEuY29tPg0KPiA+PiBTZW50OiAyMDIx5bm0NOaciDIz5pelIDIxOjQ4
DQo+ID4+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgSm9ha2ltIFpoYW5n
DQo+ID4+IDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gPj4gQ2M6IHBlcHBlLmNhdmFsbGFy
b0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207DQo+ID4+IGpvYWJyZXVAc3lu
b3BzeXMuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBtY29xdWVsaW4uc3RtMzJAZ21haWwu
Y29tOw0KPiA+PiBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207IGRsLWxpbnV4
LWlteA0KPiA+PiA8bGludXgtaW14QG54cC5jb20+OyB0cmVkaW5nQG52aWRpYS5jb207IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtSRkMgbmV0LW5leHRdIG5ldDog
c3RtbWFjOiBzaG91bGQgbm90IG1vZGlmeSBSWA0KPiA+PiBkZXNjcmlwdG9yIHdoZW4gU1RNTUFD
IHJlc3VtZQ0KPiA+Pg0KPiA+Pg0KPiA+PiBPbiAyMi8wNC8yMDIxIDE2OjU2LCBKYWt1YiBLaWNp
bnNraSB3cm90ZToNCj4gPj4+IE9uIFRodSwgMjIgQXByIDIwMjEgMDQ6NTM6MDggKzAwMDAgSm9h
a2ltIFpoYW5nIHdyb3RlOg0KPiA+Pj4+IENvdWxkIHlvdSBwbGVhc2UgaGVscCByZXZpZXcgdGhp
cyBwYXRjaD8gSXQncyByZWFsbHkgYmV5b25kIG15DQo+ID4+Pj4gY29tcHJlaGVuc2lvbiwgd2h5
IHRoaXMgcGF0Y2ggd291bGQgYWZmZWN0IFRlZ3JhMTg2IEpldHNvbiBUWDIgYm9hcmQ/DQo+ID4+
Pg0KPiA+Pj4gTG9va3Mgb2theSwgcGxlYXNlIHJlcG9zdCBhcyBub24tUkZDLg0KPiA+Pg0KPiA+
Pg0KPiA+PiBJIHN0aWxsIGhhdmUgYW4gaXNzdWUgd2l0aCBhIGJvYXJkIG5vdCBiZWluZyBhYmxl
IHRvIHJlc3VtZSBmcm9tDQo+ID4+IHN1c3BlbmQgd2l0aCB0aGlzIHBhdGNoLiBTaG91bGRuJ3Qg
d2UgdHJ5IHRvIHJlc29sdmUgdGhhdCBmaXJzdD8NCj4gPg0KPiA+IEhpIEpvbiwNCj4gPg0KPiA+
IEFueSB1cGRhdGVzIGFib3V0IHRoaXM/IENvdWxkIEkgcmVwb3N0IGFzIG5vbi1SRkM/DQo+IA0K
PiANCj4gU29ycnkgbm8gdXBkYXRlcyBmcm9tIG15IGVuZC4gQWdhaW4sIEkgZG9uJ3Qgc2VlIGhv
dyB3ZSBjYW4gcG9zdCB0aGlzIGFzIGl0DQo+IGludHJvZHVjZXMgYSByZWdyZXNzaW9uIGZvciB1
cy4gSSBhbSBzb3JyeSB0aGF0IEkgYW0gbm90IGFibGUgdG8gaGVscCBtb3JlIGhlcmUsDQo+IGJ1
dCB3ZSBoYXZlIGRvbmUgc29tZSBleHRlbnNpdmUgdGVzdGluZyBvbiB0aGUgY3VycmVudCBtYWlu
bGluZSB3aXRob3V0IHlvdXINCj4gY2hhbmdlIGFuZCBJIGRvbid0IHNlZSBhbnkgaXNzdWVzIHdp
dGggcmVnYXJkIHRvIHN1c3BlbmQvcmVzdW1lLiBIZW5jZSwgdGhpcw0KPiBkb2VzIG5vdCBhcHBl
YXIgdG8gZml4IGFueSBwcmUtZXhpc3RpbmcgaXNzdWVzLiBJdCBpcyBwb3NzaWJsZSB0aGF0IHdl
IGFyZSBub3QNCj4gc2VlaW5nIHRoZW0uDQo+IA0KPiBBdCB0aGlzIHBvaW50IEkgdGhpbmsgdGhh
dCB3ZSByZWFsbHkgbmVlZCBzb21lb25lIGZyb20gU3lub3BzeXMgdG8gaGVscCB1cw0KPiB1bmRl
cnN0YW5kIHRoYXQgZXhhY3QgcHJvYmxlbSB0aGF0IHlvdSBhcmUgZXhwZXJpZW5jaW5nIHNvIHRo
YXQgd2UgY2FuDQo+IGVuc3VyZSB3ZSBoYXZlIHRoZSBuZWNlc3NhcnkgZml4IGluIHBsYWNlIGFu
ZCBpZiB0aGlzIGlzIHNvbWV0aGluZyB0aGF0IGlzDQo+IGFwcGxpY2FibGUgdG8gYWxsIGRldmlj
ZXMgb3Igbm90Lg0KDQpUaGlzIHBhdGNoIG9ubHkgcmVtb3ZlcyBtb2RpZmljYXRpb24gb2YgUngg
ZGVzY3JpcHRvcnMgd2hlbiBTVE1NQUMgcmVzdW1lIGJhY2ssIElNSE8sIGl0IHNob3VsZCBub3Qg
YWZmZWN0IHN5c3RlbSBzdXNwZW5kL3Jlc3VtZSBmdW5jdGlvbi4NCkRvIHlvdSBoYXZlIGFueSBp
ZGVhIGFib3V0IEpvaCdzIGlzc3VlIG9yIGFueSBhY2NlcHRhYmxlIHNvbHV0aW9uIHRvIGZpeCB0
aGUgaXNzdWUgSSBtZXQ/IFRoYW5rcyBhIGxvdCENCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo+IEpvbg0KPiANCj4gLS0NCj4gbnZwdWJsaWMNCg==
