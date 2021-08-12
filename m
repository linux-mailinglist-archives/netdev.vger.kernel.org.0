Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43BB3E9F7E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhHLHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:36:06 -0400
Received: from mail-eopbgr1400120.outbound.protection.outlook.com ([40.107.140.120]:14992
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234500AbhHLHgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 03:36:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkOc19fwM+vyy2uq0ZbID8O16deb0eID+1+aK02bslwbfnUOQXOOFrnNXOXBvUx4twFknsI/zjMBqYkXiLuTffQ53tegNxoqfHNW69cBRNMbn8SYAwraUYs2cWek/RE1oBEkRfyNg1E5JgTL9jcdW7T0XxxUadb6lLi25cRnm8PWIR6j4ybvN0R3BBKmLLMnrTlZtpzvBHIaTBhzM+mSnCKe04NoZKg6nq+qIc6+77AobAppzSQJ/+M2zqy5bimgU6F5Aq2thQPTn+cF1GSlsSr063Ki2HDLrn10Oj68VikWagOHYolojfi+gsVxvBlO7IuyUr0zhO5z4MZc11VR6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqMLwK50ZU1PnB1Eiru/N6MROxwACKvD5yz6o5z0hrA=;
 b=ZsDSIy+H47Hh3mgBk70PJ5f+1BwllodwifgbQMyfjlrzY98xA6kXc+jZb9vi4YYqV273LhnekkErz2qZplj9uRTBJWHSuk9o3Iaq76dWp1ypHaQ55rJY91VgZODA2jVYh1q2RRsi1ohuq62m9Z3FsanlSuCBp+yD8T9L4JRWCRzR2eGPxdFTRlRj9dGvwP8Zg+KKdEUYtyjIPP6D2X6dNmJlRgQ3A/CgLo6d262nQ0Rrku3YYEVvwOTOceDGgvB6um8GMlRDvgE+51WQxb0+5EjtrO7ynOuE+aJuiMp0FKsJsYGRqW15ywrcdngusDH5QacG7KlSJoqZaiLtXtPXBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqMLwK50ZU1PnB1Eiru/N6MROxwACKvD5yz6o5z0hrA=;
 b=atCQrSAIfB0osaXAVWqkUIy2geTOL0zaGApb6huUmGyttJC1yYPAkUNBpY1CllU06LQt3LLepR9PEDWHQgR1Gx24RARIZeV7qunq8ly5HFW3nUfvHSjoP7NC2Am+Jcq5BQu66Ztg0oC2DKCXljx+9n0v/eVcewq6devdmR8jczg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4321.jpnprd01.prod.outlook.com (2603:1096:604:36::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 07:35:36 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 07:35:36 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
Thread-Topic: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
Thread-Index: AQHXh4kFp+geaJbxPkSeNoy79C/vbatlSxwAgAABWNCAAaV7gIAIlm3w
Date:   Thu, 12 Aug 2021 07:35:36 +0000
Message-ID: <OS0PR01MB5922967B28A3D4E8252F8A9C86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
 <0daf8d07-b412-4cb0-cbfb-e8f8b84184e5@gmail.com>
 <OS0PR01MB5922C5EE008113DEA3354BFA86F29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <d038bed9-def6-9035-18fa-28ee527a149c@gmail.com>
In-Reply-To: <d038bed9-def6-9035-18fa-28ee527a149c@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae0b3985-beb3-4bc8-37a9-08d95d63c69d
x-ms-traffictypediagnostic: OSAPR01MB4321:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4321DB24088F5CBA56AC048E86F99@OSAPR01MB4321.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LB0bFpWsrr3mt5pUj+j8N8jX7cN3ZQ9XiekX8FHRAxuZTrRbolO4E5HbOPvkihqsLoW+TIdiCUQDx5NprbOSGGpInPk8MgATZhmiRvT75HUSSivV6V83TbGvGs3wzEp7bz8kRDRNO+KhDrlmamk6SrPfCwfUR4Soj5uLJO2ujyrUfWOJ8rwkx3eAzDnpxv+yYx68zLmDHCGk0ZGgQpIHx7djNEMIxXzX145qMRbpbTXXRzpny54OUZh3ZzKFOBLo84ij9QLc2BebZq130/MvtBF5ZDDaKVud5ipAaSVYVu3+x0tTC8LkDA/wySYg7L8V57DMnaqv3hKzyC6XYjWFIw6drv3+vkOD2VkiMJDePW+O7i9UBaxjR/WT8HmJd45JEiy8LxgSzPrIUQr1CgmlRUcp4E+uRmKFz0AgCbxvxZc4mPGOdWZ8wcoa2kuW5BOhoDCSQQkCQYp6Qod6OjtaixwGWEQuY0nVW+L6ybFPLTPKfdV2MiZ+7/VLbdjyG8nSe9KaNbZEZbBIpEaGDoMuZJQa37Od9xfMGftBFaD+1Qfy0OxI4v9gi24CrepEvfdt7i+j2DT8zjPrsOYbAM0KPOFnfkyTp8mT2D4oOLc9ARpHuEciYGT8LwSaahGt7CF6OrkjPNcgxDtVxENR3fUW9IeFjPnOvXxbocl7AYs2jRt7vKVmTzNECEHqyw7rvO+nDrHdMmP2ntm0OgOqCpMIZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(66446008)(64756008)(66556008)(9686003)(316002)(66946007)(7696005)(186003)(26005)(66476007)(8936002)(52536014)(53546011)(6506007)(76116006)(2906002)(55016002)(4326008)(110136005)(86362001)(478600001)(122000001)(5660300002)(33656002)(107886003)(7416002)(71200400001)(8676002)(54906003)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDgyN2tsWmR1WDBYRXZnOE5IMG9hbk9nb2FOay9TbVB4NUtBUE5haUlwd1Fh?=
 =?utf-8?B?NXBUUHhnQW5oODVIdkgwN1FIQm0wZ01rZHBZUXc5MmNwdDNHazIvcFo1cjJa?=
 =?utf-8?B?eFVQU0dieW8ydXkrSWhNKzBUeGlsV2RGaFdkUjV6T2VWRUJFdDl4c1RWUklN?=
 =?utf-8?B?T203Y05yVlZlOVVaaHd2cmdZOTNDZEZjSGZya0VBSms0NTRUMDB1SlZhYkxo?=
 =?utf-8?B?N0Q0QXZYblZBV2M1bDRuZFNTc0RMaW1nZDlaRjRQaWtqT0FkdHB6VHVUZFV0?=
 =?utf-8?B?Z1o4UzRxZDNyS3IwdWl1SEFpMEJ1bVhyKzRxTGtKbEtwamI4a0RTRDQxc2NE?=
 =?utf-8?B?d3JVNml3a0tuNlg4ZERheG5jWWlHY3FPZzFOOXhqRVFzek9vL2FrN1FMVjU4?=
 =?utf-8?B?V3FKbHFwRFcyQ2pmTHRIUTFRTk54ZnJFWjR1TVlqempEZGFZQkNMQnBXMjZJ?=
 =?utf-8?B?djFza0gvQlVCZWVmTkV0cmRXajFDYU04QVNkVmE4bEFzZ3h6dnVZQy9oSFpY?=
 =?utf-8?B?dmJRVjhVZlZ1VG1oQUR0RHU3Y3JhbXZMRWxHYXhmcFdDZWN6MUxTcUcrbzlk?=
 =?utf-8?B?MjJuUnZhWjdTcVFqOFJ0ZWRVTmhqZnJ0Smp5NmxpOE1FNUIxZmlCaTk2dHB4?=
 =?utf-8?B?cG8yZnV1ZFFoWmNYYU1sWGpJQk1wZkQ5bHBjeGg0dnhpOHl5ZHNSWFFaUUdh?=
 =?utf-8?B?ejdqdGpOVkdPOWV2eGRmU3EvWFJJRWtIZW8wUzF2aFBZdE9PZzdtdDVNZGh5?=
 =?utf-8?B?aEhGdDRWNzFteTcyb1hld1JWSWNDL3M3NERSeGVUNmdaNXA0TTJJZkxUcGFj?=
 =?utf-8?B?TTRxU01YMS92UFp1am9ZMHdPayt3ZnBHRjFPb0ZUSjNVUkFucFNWTjJKekVs?=
 =?utf-8?B?UDFza1kxdkpoL011ZCtPQzZ5MHExSkpSTWJUWmxiUWg3UStMZmVKVGNUMzk3?=
 =?utf-8?B?UmpjT3ZXS29pTXJHa09zTTZlTGU0SHpSb24wS3c4QzBkeEEvN0pJNkwvVkg2?=
 =?utf-8?B?TURPc1hMRklKK1BkcU4zS250eXZXK2QyQVdjUllSSTc3bU54VlYwYWdiYlJL?=
 =?utf-8?B?N1kzQVpCb0xyL3Z3OWZ1NTJRc21OYWFEODhCdmlVZ0IwTjFJU3Z5c2FQZUU5?=
 =?utf-8?B?VjI5Y1dwMlkvV2JFdGI4UXA0OWZUejFka0xxSk5lbzdsb2h2a1orWnd6NSsy?=
 =?utf-8?B?cGFrVXhhb1l0ME9IZlQ0Wms5Zk1BVmdFaGtVeXVzV3NHVG1LT3ZtdTJveWZB?=
 =?utf-8?B?RHlnNm1pNjRzL3FRVUs3MW9CM1NtMjhaQUltdUN3cjdpOXhMaWxmK3BGQWtq?=
 =?utf-8?B?UUtmdW9COGtCYVNwNUhLTzVlNGRVaXd0NlB4anpkOFhvQkRJL010ZjFjT1V3?=
 =?utf-8?B?eEwzblFGeGx2bHByaU1HTnpxWE9wT3RoY2Z3b2dQRjNnZjJxY0ErVnZ4emtF?=
 =?utf-8?B?SzN6NUlhd083UEFUV1pEWC84bWYzbmpOSzhEaEpWeE1DaldvRmRyL0pvNUVq?=
 =?utf-8?B?Sy92S3hrdTFQNlZONEUzYlQxMnpRSkJXcFMyRUlHM3hEU2YvSG9MK2VjS3Nz?=
 =?utf-8?B?ZjQ1aWFFMDhFbGRQcWFDSm42SlAzUnpPQjVPLys5M0lPNU1zYVlucXNFTXQ3?=
 =?utf-8?B?WlhVRzBHZERDSzRnYTlkOXpJZUhHWmdGaW93REdlV1puVG54bDZ2TnBTU1RV?=
 =?utf-8?B?cVNSVkhCeDRFVUU1b2NveXZObU9UZlNMVllYSVgwdms3dkVzRi9FUUh6UENX?=
 =?utf-8?Q?NWdsOaatrFfAFtAM13+Jl8wrPo5G0C8qv6AcoK6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0b3985-beb3-4bc8-37a9-08d95d63c69d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 07:35:36.3086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: edoiO6j4gxjkWU2yhGJjgiVHpB+79yImPYW1d4fhnNh/rkBE1dK1ivsvpmfI9swqRGULFSlK2J4BytKAOmlK6hqMpNK7C0EUfMH3zrkM/Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4321
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDYvOF0gcmF2YjogQWRkIG5ldF9mZWF0dXJlcyBhbmQNCj4gbmV0
X2h3X2ZlYXR1cmVzIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IEhlbGxvIQ0KPiANCj4g
T24gOC81LzIxIDEwOjE4IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+IFsuLi5dDQo+ID4+PiBP
biBSLUNhciB0aGUgY2hlY2tzdW0gY2FsY3VsYXRpb24gb24gUlggZnJhbWVzIGlzIGRvbmUgYnkg
dGhlIEUtTUFDDQo+ID4+PiBtb2R1bGUsIHdoZXJlYXMgb24gUlovRzJMIGl0IGlzIGRvbmUgYnkg
dGhlIFRPRS4NCj4gPj4+DQo+ID4+PiBUT0UgY2FsY3VsYXRlcyB0aGUgY2hlY2tzdW0gb2YgcmVj
ZWl2ZWQgZnJhbWVzIGZyb20gRS1NQUMgYW5kDQo+ID4+PiBvdXRwdXRzIGl0IHRvIERNQUMuIFRP
RSBhbHNvIGNhbGN1bGF0ZXMgdGhlIGNoZWNrc3VtIG9mIHRyYW5zbWlzc2lvbg0KPiA+Pj4gZnJh
bWVzIGZyb20gRE1BQyBhbmQgb3V0cHV0cyBpdCBFLU1BQy4NCj4gPj4+DQo+ID4+PiBBZGQgbmV0
X2ZlYXR1cmVzIGFuZCBuZXRfaHdfZmVhdHVyZXMgdG8gc3RydWN0IHJhdmJfaHdfaW5mbywgdG8N
Cj4gPj4+IHN1cHBvcnQgc3Vic2VxdWVudCBTb0NzIHdpdGhvdXQgYW55IGNvZGUgY2hhbmdlcyBp
biB0aGUgcmF2Yl9wcm9iZQ0KPiA+PiBmdW5jdGlvbi4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2Zm
LWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+PiBSZXZpZXdl
ZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMu
Y29tPg0KPiA+Pg0KPiA+PiBbLi4uXQ0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yi5oDQo+ID4+PiBpbmRleCBiNzY1YjJiN2Q5ZTkuLjNkZjgxM2IyZTI1MyAxMDA2NDQN
Cj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gQEAgLTk5MSw2
ICs5OTEsOCBAQCBlbnVtIHJhdmJfY2hpcF9pZCB7ICBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4g
Pj4+ICAJY29uc3QgY2hhciAoKmdzdHJpbmdzX3N0YXRzKVtFVEhfR1NUUklOR19MRU5dOw0KPiA+
Pj4gIAlzaXplX3QgZ3N0cmluZ3Nfc2l6ZTsNCj4gPj4+ICsJbmV0ZGV2X2ZlYXR1cmVzX3QgbmV0
X2h3X2ZlYXR1cmVzOw0KPiA+Pj4gKwluZXRkZXZfZmVhdHVyZXNfdCBuZXRfZmVhdHVyZXM7DQo+
ID4+DQo+ID4+ICAgIERvIHdlIHJlYWxseSBuZWVkIGJvdGggb2YgdGhlc2UgaGVyZT8NCj4gPg0K
PiA+IFItQ2FyIGhhcyBvbmx5IFJ4IENoZWNrc3VtIG9uIEUtTWFjLCB3aGVyZSBhcyBHZXRoIHN1
cHBvcnRzIFJ4IENoZWNrIFN1bQ0KPiBvbiBFLU1hYyBvciBSeC9UeCBDaGVja1N1bSBvbiBUT0Uu
DQo+ID4gU28gdGhlcmUgaXMgYSBodyBkaWZmZXJlbmNlLiBQbGVhc2UgbGV0IG1lIGtub3cgd2hh
dCBpcyB0aGUgYmVzdCB3YXkgdG8NCj4gaGFuZGxlIHRoaXM/DQo+IA0KPiAgICBJIG1lYW50IHRo
YXQgd2UgY291bGQgZ28gd2l0aCBvbmx5IG9uZSBmaWVsZCBvZiB0aGUgbmV0X2ZlYXR1cmVzLi4u
DQo+IEFsdGVybmF0aXZlbHksIHdlIGNvdWxkIHVzZSBvdXIgb3duIGZlYXR1cmUgYml0cy4uLg0K
DQpCYXNpY2FsbHkgYXJlIHlvdSBzdWdnZXN0aW5nIHNvbWUgdGhpbmcgbGlrZSB1bnNpZ25lZCBo
d2NzdW1fdHhfcng6IDE7DQoNClRoZW4sDQoNCmlmIChod2NzdW1fdHhfcngpIHsNCgluZGV2LT5o
d19mZWF0dXJlcyA9IE5FVElGX0ZfSFdfQ1NVTSB8IE5FVElGX0ZfUlhDU1VNOw0KfSBlbHNlIHsN
CgluZGV2LT5mZWF0dXJlcyA9IE5FVElGX0ZfUlhDU1VNOw0KCW5kZXYtPmh3X2ZlYXR1cmVzID0g
TkVUSUZfRl9SWENTVU07DQp9DQoNCkNoZWVycywNCkJpanUNCg0K
