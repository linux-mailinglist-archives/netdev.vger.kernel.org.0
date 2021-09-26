Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E467418921
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhIZNuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:50:25 -0400
Received: from mail-eopbgr1400138.outbound.protection.outlook.com ([40.107.140.138]:19251
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231754AbhIZNuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 09:50:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltbSoy3yZAngOCMHv0v8wkpXHcCvKtwWFCPawTReRsjT4SLM0EGKInFEEgpTp2BAIVIjlsc4CGKqTXB/bJDbSch7xhDHw2X9DVxVGJq/LQBDhHcKfTkETXS76MoRk5tT9p3vxYCeLFvZg6uCo2cIZ8Ezq3boAEsGQcfMfMxeXPioZTRDaGSZfUNe45BXnqoergWCyCWFvcLmZQ4orFd7RFtxoIvL1v4x0NnhZehnGcbXao07E3ClknQOytlvuCqG/9aoJaoYRKufhD2LraOStR2ibdf/Kp29we8ybjdgioxB5FsvsR43F2tozi64jUT9NLgAa26UjE/tUIE1rYHCFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AIJGH13SazXXkni00xbzb8f4PxwYQyWBUXPYgf5fW/8=;
 b=IZYOOeYjN+nybd47RcS1nX7bV759wrXc9zeg5VIjQEYDKTar/su/+spLm1QKJ4isIqDb9jIlsj3jp0cSa9xtBmVpYn4IF3SyX0/MVMUjnzrGGM7fne+sKDuzds+50G1G80gAuGVb3QVIrE0/ez4XCFtORK7NWnSPx2lmpBdKvCMUvfs3ZSn8O7BRt+u4wLdQ+X+IVUM4woZlG58HRfJwUa8wVwT6xT4zlMcwBYlA3mqEfByAEBI0IR1bDutkPmPWxAmDO8g7IJ9UfsYnwRgAk+iNacLWgOpDC8cTByoeWYdhEqUuyEq0f8n6JQrXNdR+FOavNPK3+P6Y/GyYI9QNVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIJGH13SazXXkni00xbzb8f4PxwYQyWBUXPYgf5fW/8=;
 b=SOXw+pv9loH4eLmiLkDL2p5l7nuC825lqsg2oxUh0rWz/BCzqJx+Hwtm6uXn7v56qzopsfGDFQU9ksLDb+/QoPpg5vm/NJpvNwk3P249tYrM4t4eLrlIK8aYrqyyiRoeKDY/UOe7sTbd7cJAMoRNRUt3hhGNSUfgVDzYx+0L44Q=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1906.jpnprd01.prod.outlook.com (2603:1096:603:19::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Sun, 26 Sep
 2021 13:48:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 13:48:43 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Thread-Topic: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Thread-Index: AQHXsISAOfY/2JLZEkuO1R4Mf2Gbvaux+WeAgAABF/CAAAqGgIAAADgwgARSUFA=
Date:   Sun, 26 Sep 2021 13:48:43 +0000
Message-ID: <OS0PR01MB5922FA566A26F50382F789F286A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
 <2b4acd15-4b46-4f63-d9e7-ba1b86311def@omp.ru>
 <OS0PR01MB5922F3EE90E79FDB0703BCEC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <484f6f91-c34d-935d-1f42-456d01e9b8ca@omp.ru>
 <OS0PR01MB5922FCB43284B938A4E12D1686A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922FCB43284B938A4E12D1686A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f178a51f-abe1-4920-abc5-08d980f45ae6
x-ms-traffictypediagnostic: OSAPR01MB1906:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB19062D216033ED835503C01886A69@OSAPR01MB1906.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZoLH1CjfSW9S3OXsPAv6g1yYvTQnn3uRbe6e8FM10mKmbbqIOYZ0uxt2ORcLH8hljLttcdEVsWFN2DWgUekgZ/jWUcBmEMgJE3CWosv3F7zEgcN8MhRveYUEMy+ClmKScD7tO8mQKWe8gJpWQYIQK6KINsXVoWvlNdz/1fsp07jqRpa2zR2sqpmhAT5Kaem2uz2ctykuUUqzhaPQCp/HYgKjqSNnHd5jg+4rJFOjFcRnRl69QjNu2kB+KP9E4TisgutRxnYHCGfNH54eK0N3EoaJqU7PXZmTVNT5H4u6A9S99kvyppBSYO1zWPKG3UFIxQ2+nBuUYwhaCAGnh0jvIu+F1fC5VwOs7Ao134JG3uwJ6YJvME72Sk38TxD8qzMPW/9kDOOVJLzRGeFlC1FIJZReiUrexajalsamWGkvg1PerivXmRp1VmiwLSD4n2s0uYmbiAHRegg5N8+TVyAVv/DC4nTx80WL3wsgfurGpbl4q1P4+PPTU8mB19inf6N/aSPzaqfF6qankU9IOHZrr3P1L+43+uBr9UCgEbpN041Q2Dd05LWrwMQP/q2d09m/3CKS9GhR2jUwYph0iuqQ6zpbe81YefsRaBF0E2QHtfi0x3/Gr/h1EkCjK6Jb2cshgJLEO/J2AsTuyfCprm1HLRFPUUCesZFdgDIZCtdEidbgOzGXEGeWoAEAdL/I6r7Mn/NRMlhVxtY9NxWe9TwOiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(38070700005)(8936002)(38100700002)(122000001)(6506007)(53546011)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(5660300002)(9686003)(55016002)(86362001)(2906002)(7696005)(4326008)(26005)(54906003)(33656002)(71200400001)(110136005)(52536014)(316002)(186003)(508600001)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0FmQncxa3BYRWgxeGtSNGkwOXhVR1p3cnFLdkY1S0RIeWowZndadTVmUVhS?=
 =?utf-8?B?R29OMGFiaXorQnd1eTg1ei90N0J0cUhXWmpvL0hGSTdmbFB6WkFZY2t4MFZC?=
 =?utf-8?B?ZTY0MWd1cjM1cmVFUlRWdWtmVk5odlIwQkQ2dWJucnlEVWFQdFhxOHZ2ekVU?=
 =?utf-8?B?NFI3eEp4d0VkRDdQT3loMmkrRDhtTG56ZlNyQzRLYzY0SG1JL05SRE5kOHZU?=
 =?utf-8?B?c3dtTTFTSG5ITGVJdEw1ZEEwRndOV0h4OC9COHorM0NxMzQ3Y1k2RXI1YWts?=
 =?utf-8?B?WUx1dU83eFBibkdzYmNwdzdHN3hKVG1sZ1N0cFhJT2hLclR4a0Fab0lGY3Nm?=
 =?utf-8?B?dFQ1TkNpWXpMcjFzTjEyNU9Lcy91TUdTNG4zWFBrcGJKbGt5emp4T2ZYUVNQ?=
 =?utf-8?B?QTRvOStjZUUrbWtUc1VZN0kzNWFtclgwSTJFK2l2dmdkbjVaanNxYzZSQXY1?=
 =?utf-8?B?WEhJeVlEbGU0VFhCRXlSa1JITWRuREZJM25vd3ZoaGFONjYzYlZWTStqZklF?=
 =?utf-8?B?a0dONEhOeDFob3VQRXpSTzdyeVlKMUJjbHhVZzc3WWtEa09lVzZHU3hUSnZj?=
 =?utf-8?B?YnBxcC82NVp3V2gwK2dBWVpyOUlwVEQ3R0hNRzZRQks3dzNXcHA3aG9qQzZH?=
 =?utf-8?B?MWpFeW1oV3VwaE44R1VBcEVGRGhnd0lMZEozZDB3OXlHODRvVVN5b0M0ZFln?=
 =?utf-8?B?V2Vna2xnQ09pbXFvRm8rY2pqVncrdVc3aTJETTFGT1MreHF1YzBnK0xCc3N5?=
 =?utf-8?B?dUNzWnJLUm9BV1NoMm1aM1JDSmdGMVkyUXVhWFpHcXo3QlR2UnI1cWtmRlBB?=
 =?utf-8?B?eitXYk15NklTaHhMa2l3MXBFbHdmNDJrbXRpNit4LzVEb2hoWmM5OFc0L1k2?=
 =?utf-8?B?MHlJRXBqV0xsT1g4RDZUSFh0aU1xend3VVlLK2YrQ2RsZENZcGx5UTF4aW5Q?=
 =?utf-8?B?eDZHdTVvUDE3cVhpR3d0NjljVDY2dDhrOThmKzY2MkVsNjB6cUZ3SHlVS0p0?=
 =?utf-8?B?bThrZWFKUEpLMzJNdWs5NDNid3BYVkM1MHlsU2lTL1N0ZVJzUmhCWVY1SWl3?=
 =?utf-8?B?M2tjei9ZYktpb2kyWDgrdi9sNnhMTUlHRVZ6QmRVUENrdExyOTVSalJIVHE2?=
 =?utf-8?B?NUN5empqZWRMTWtRTUtkVituaFg5UTlXdUZTWXVwVFBaSjdCdGJSZVlpVW5l?=
 =?utf-8?B?MDAvSDFtaUlGd0VYU3lEUUJmUmFDSWNRaGNnR2RiYXh2TCtJQTZ4TWtZbzFS?=
 =?utf-8?B?cFlsSlF4aWtyU0MzRlZZemRTY1NWVm1CY3k1MFZuV1pOcDl6d2dYeTFEUFE5?=
 =?utf-8?B?MWhzK04zRVB4RFJQTkRvZHEwTGljVVczM1RmbitMSk1KL01kTk8yY3RNMElj?=
 =?utf-8?B?MS82M2tVMi9FcnpQaStPa1l4aGZDU0hMMmRMazJPUERPY21IWmRnbEVtcW9N?=
 =?utf-8?B?Z2h6c3VWOUlXcm1FejBFTUpDRWRrNGVvaDlpUUsvQlFIOVY5ZnpaOVJyRXps?=
 =?utf-8?B?MC8zTi9kbnAxUXo0bUJROGh3RU5WVDUyV3F0UlRDdXdBcC9vUnVhN29LcWZ3?=
 =?utf-8?B?ejZYWm01Q2JJK3JSdGVlaHlmNzJJOVplRTVhZEtRT0pmZ0lDbis2UmIxYlZj?=
 =?utf-8?B?QkZCQUFnYTFTOTRuV201aVJseXp6LzYybzhGa1h0MDZaQUpyQ0k4VGpCVy83?=
 =?utf-8?B?WC9JNTRYUGtlQk54blFUQ0pKaDRCalhqTnBnL0ZyK1hqNmRMZUNvK0kwR000?=
 =?utf-8?Q?npzvHisb9I3d7VDtYyFaJhlvprpRAKnDYu/waZO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f178a51f-abe1-4920-abc5-08d980f45ae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 13:48:43.3206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SOgWEE5nGhM5mKQ3Tp5RCdJRVJORsfRtpZvA9GNpma6bZE9vanuZiT+yD0cF7OK3IlUbLDUAsocUE1EImu6bA/Xvax1v7jZZo3jRG7uWaBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1906
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDA1LzE4XSByYXZiOiBFeGNs
dWRlIGdQVFAgZmVhdHVyZSBzdXBwb3J0IGZvcg0KPiBSWi9HMkwNCj4gDQo+IEhpIFNlcmdlaSwN
Cj4gDQo+ID4gU3ViamVjdDogUmU6IFtSRkMvUEFUQ0ggMDUvMThdIHJhdmI6IEV4Y2x1ZGUgZ1BU
UCBmZWF0dXJlIHN1cHBvcnQgZm9yDQo+ID4gUlovRzJMDQo+ID4NCj4gPiBPbiA5LzIzLzIxIDEw
OjEzIFBNLCBCaWp1IERhcyB3cm90ZToNCj4gPg0KPiA+IFsuLi5dDQo+ID4gPj4+IFItQ2FyIHN1
cHBvcnRzIGdQVFAgZmVhdHVyZSB3aGVyZWFzIFJaL0cyTCBkb2VzIG5vdCBzdXBwb3J0IGl0Lg0K
PiA+ID4+PiBUaGlzIHBhdGNoIGV4Y2x1ZGVzIGd0cCBmZWF0dXJlIHN1cHBvcnQgZm9yIFJaL0cy
TCBieSBlbmFibGluZw0KPiA+ID4+PiBub19ncHRwIGZlYXR1cmUgYml0Lg0KPiA+ID4+Pg0KPiA+
ID4+PiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+
DQo+ID4gPj4+IC0tLQ0KPiA+ID4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYyB8IDQ2DQo+ID4gPj4+ICsrKysrKysrKysrKysrLS0tLS0tLS0tLQ0KPiA+ID4+PiAg
MSBmaWxlIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQ0KPiA+ID4+
Pg0KPiA+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYw0KPiA+ID4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiA+Pj4gaW5kZXggZDM4ZmMzM2E4ZTkzLi44NjYzZDgzNTA3YTAgMTAwNjQ0DQo+ID4g
Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+
Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4+
IFsuLi5dDQo+ID4gPj4+IEBAIC05NTMsNyArOTU0LDcgQEAgc3RhdGljIGlycXJldHVybl90IHJh
dmJfaW50ZXJydXB0KGludCBpcnEsDQo+ID4gPj4+IHZvaWQNCj4gPiA+PiAqZGV2X2lkKQ0KPiA+
ID4+PiAgCX0NCj4gPiA+Pj4NCj4gPiA+Pj4gIAkvKiBnUFRQIGludGVycnVwdCBzdGF0dXMgc3Vt
bWFyeSAqLw0KPiA+ID4+PiAtCWlmIChpc3MgJiBJU1NfQ0dJUykgew0KPiA+ID4+DQo+ID4gPj4g
ICAgSXNuJ3QgdGhpcyBiaXQgYWx3YXlzIDAgb24gUlovRzJMPw0KPiA+ID4NCj4gPiA+IFRoaXMg
Q0dJTSBiaXQoQklUMTMpIHdoaWNoIGlzIHByZXNlbnQgb24gUi1DYXIgR2VuMyBpcyBub3QgcHJl
c2VudA0KPiA+ID4gaW4gUlovRzJMLiBBcyBwZXIgdGhlIEhXIG1hbnVhbA0KPiA+ID4gQklUMTMg
aXMgcmVzZXJ2ZWQgYml0IGFuZCByZWFkIGlzIGFsd2F5cyAwLg0KDQo+ID4gPg0KPiA+ID4+DQo+
ID4gPj4+ICsJaWYgKCFpbmZvLT5ub19ncHRwICYmIChpc3MgJiBJU1NfQ0dJUykpIHsNCj4gPg0K
PiA+ICAgIFRoZW4gZXh0ZW5kaW5nIHRoaXMgY2hlY2sgZG9lc24ndCBzZWVtIG5lY2Vzc2FyeT8N
Cg0KSSBoYXZlIGRyb3BwZWQgdGhpcyBjaGVjayBpbiBuZXcgdmVyc2lvbi4NCg0KPiA+DQo+ID4g
Pj4+ICAJCXJhdmJfcHRwX2ludGVycnVwdChuZGV2KTsNCj4gPiA+Pj4gIAkJcmVzdWx0ID0gSVJR
X0hBTkRMRUQ7DQo+ID4gPj4+ICAJfQ0KPiA+IFsuLi5dDQo+ID4gPj4+IEBAIC0yMTE2LDYgKzIx
MTksNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbw0KPiA+ID4+PiByZ2V0aF9o
d19pbmZvID0NCj4gPiB7DQo+ID4gPj4+ICAJLmVtYWNfaW5pdCA9IHJhdmJfcmdldGhfZW1hY19p
bml0LA0KPiA+ID4+PiAgCS5hbGlnbmVkX3R4ID0gMSwNCj4gPiA+Pj4gIAkudHhfY291bnRlcnMg
PSAxLA0KPiA+ID4+PiArCS5ub19ncHRwID0gMSwNCj4gPiA+Pg0KPiA+ID4+ICAgIE1obSwgSSBk
ZWZpbml0ZWx5IGRvbid0IGxpa2UgdGhlIHdheSB5b3UgImV4dGVuZCIgdGhlIEdiRXRoZXJuZXQN
Cj4gPiA+PiBpbmZvIHN0cnVjdHVyZS4gQWxsIHRoZSBhcHBsaWNhYmxlIGZsYWdzIHNob3VsZCBi
ZSBzZXQgaW4gdGhlIGxhc3QNCj4gPiA+PiBwYXRjaCBvZiB0aGUgc2VyaWVzLCBub3QgYW1pZHN0
IG9mIGl0Lg0KPiA+ID4NCj4gPiA+IEFjY29yZGluZyB0byBtZSwgSXQgaXMgY2xlYXJlciB3aXRo
IHNtYWxsZXIgcGF0Y2hlcyBsaWtlLCB3aGF0IHdlDQo+ID4gPiBoYXZlDQo+ID4gZG9uZSB3aXRo
IHByZXZpb3VzIDIgcGF0Y2ggc2V0cyBmb3IgZmFjdG9yaXNhdGlvbi4NCj4gPiA+IFBsZWFzZSBj
b3JyZWN0IG1lLCBpZiBhbnkgb25lIGhhdmUgZGlmZmVyZW50IG9waW5pb24uDQo+ID4NCj4gPiAg
ICBJJ20gYWZyYWlkIHlvdSdkIGdldCBhIHBhcnRseSBmdW5jdGlvbmluZyBkZXZpY2Ugd2l0aCB0
aGUgUlovRzINCj4gPiBpbmZvIGludHJvZHVjZWQgYW1pZHN0IG9mIHRoZSBzZXJpZXMgYW5kIHRo
ZW4gdGhlIG5lY2Vzc2FyeQ0KPiA+IGZsYWdzL3ZhbHVlcyBhZGRlZCB0byBpdC4gVGhpcyBzaG91
bGQgZGVmaW5pdGVseSBiZSBhdm9pZGVkLg0KPiANCj4gSXQgaXMgb2ssIEl0IGlzIHVuZGVyc3Rv
b2QsIEFmdGVyIHJlcGxhY2luZyBhbGwgIHRoZSBwbGFjZSBob2xkZXJzIG9ubHkgd2UNCj4gZ2V0
IGZ1bGwgZnVuY3Rpb25hbGl0eS4NCj4gVGhhdCBpcyB0aGUgcmVhc29uIHBsYWNlIGhvbGRlcnMg
YWRkZWQgaW4gZmlyc3QgcGF0Y2gsIHNvIHRoYXQgd2UgY2FuIGZpbGwNCj4gZWFjaCBmdW5jdGlv
biBhdCBsYXRlciBzdGFnZSBCeSBzbWFsbGVyIHBhdGNoZXIuIFNhbWUgY2FzZSBmb3IgZmVhdHVy
ZQ0KPiBiaXRzLg0KPiANCg0KT0ssIHRoZSBuZXcgcGF0Y2ggZXhjbHVkZWQgZ1BUUCBzdXBwb3J0
IGZvciBSWi9HMkwgYW5kIEFsc28gYXMgcGVyIHlvdXIgc3VnZ2VzdGlvbixkcm9wcGVkIHRpbWVz
dGFtcCBmZWF0dXJlIGJpdCBhbmQgbWVyZ2VkIHRoYXQgY29kZSBpbiB0aGlzIHBhdGNoLg0KDQpS
ZWdhcmRzLA0KQmlqdQ0K
