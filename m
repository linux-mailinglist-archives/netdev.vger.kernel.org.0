Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E20C20E017
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389643AbgF2Umc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731647AbgF2TOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:04 -0400
Received: from JPN01-TY1-obe.outbound.protection.outlook.com (mail-ty1jpn01on072c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe9d::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD20BC08E81E;
        Sun, 28 Jun 2020 22:25:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFAR9Grpm1+9gxI+3JqB2ND8XZpeJLAQGQ9tnSEendZKX5E17r+/FI+0nnt35vaDVrJnY0um+nVVUeoHeQycHJJKyyno+QTlotj91mMOnH2p4V0R8RDqWrgtYi2aUlUoCw4DNFXJmkaNMSqS7J45N8Jd2UREKGrHp+GjpoTDXaQ/UNyQbHqDiDP6NPz3+iFEfLDonmS1oWuD1ZS+zoLZqfXbQpHL/cXdqQck1WW3Dj4w0heut4kX/f3dU/3VeQh2wBJfXQGanWwrLA4UTQjVmWtQ3dh5hhSgxi+p/jeTyhzh2NDTIKoDyTQeRBtLqcngTosIkC7jsPdjfoG++sbejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULbvbTMru6+lMb0SSRhzBh9HbktyLOIrS6uN2qkOztM=;
 b=XWrDyB0KFZ+ixEqRyOTcFs27NcZtW5zngclB31ny62a1aqZNyUZRWFkolSogYCjXHp0Qh/4gpRbW5PWPa8MLJe/CheEnQeV/xs88mBmvee+rQcEb7rCjs13fF9kpuM4lreRVlIRZrIeV5pVdsM+gcM7wxNNLMBQY53PSkAuXaeFoIRrO2uuN4wxtEFlkyXVLFs8L1ZdbhUHa1N7WptNKZtn/CEm7xTLtBJXLGU2dW0vMeSulcPHlG210JW+KBV/5j7Emz+omjdOPj9YbSPpLpS6cKDTiSBp1uIE2ISdbBLh+g2q6qUV+dGC33NKWHy8bJLB8gCDnCfXHMzSowptjgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULbvbTMru6+lMb0SSRhzBh9HbktyLOIrS6uN2qkOztM=;
 b=OdDRb8Ndqqprzhr7JiaDJq28AWG3xWvM6q6CpYmQWOi0qOazLoStihjxeNATHJ3uMgZRxLjfb9OUqWdwxTmoRqX/IVEvZhy+37ZDqR5ynHkF/OigVkuGeZvSCkxFHsupTf6RhNvGeA5mdOP2HcyBtRoLgmNgc482FIPUf9gzS1s=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB2397.jpnprd01.prod.outlook.com (2603:1096:404:8f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 05:24:56 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 05:24:56 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>
CC:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Topic: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9ggAAmMYCABhvkIIAPtGcQ
Date:   Mon, 29 Jun 2020 05:24:56 +0000
Message-ID: <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
 <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
In-Reply-To: <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: acba7d43-162e-4873-e589-08d81becc2ea
x-ms-traffictypediagnostic: TYAPR01MB2397:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB23972B37209244ED7A0FFC9CD86E0@TYAPR01MB2397.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q7VCn23PR1q0o2/IzyRDel+Bbl2Esd9wUSZbV+53fdwuwpY8lFk5NR6An34xvxOk8ktki50fdq326m7Bhg/LDI/aKGV1Pw0pzwI6FOcSfMYgpb8B0H8FMV/NPLlK0rCRViDeVnECimJM1M2B6JNaOqKvuYDXvCX7QsE/ZXwchlAW5XIXH5ZhTIRp+NkVFw+Zv9uZCWMsde9ceNhn2VHSkFAP+5JVTvPodC448armKxxWjUZtHfg3qBi5ckQUbQXyFpYaLbazn4YyuXxLhMYSiel/Ru9cyZuV91OnXzwp6ayfbDc13oqL2D/TVU6iW2EzmBgCF5TvmqcptVSx3qnwkR34QUeNsSJDxnzClq7gDUSrhrsFdJWIe4Fb/Wd/BpUSjsgt3nX/n32bnONnYHO5kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(33656002)(66476007)(64756008)(66946007)(478600001)(76116006)(186003)(8676002)(66446008)(8936002)(2906002)(52536014)(4326008)(83380400001)(55016002)(26005)(86362001)(71200400001)(55236004)(5660300002)(316002)(66556008)(7696005)(54906003)(110136005)(966005)(53546011)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mMKRdC6GWMzvnoIByl0Z/OCBHeJQIoUHZI0zlRLdy2gSCdEvraYW5XTy5dqRai0ZUZHRcqIufdgzyjLkHHkOduWSrO3dT/uYRjl6Iaam/UeSugc7edg+xa28bMO3pRA1S6v/TKnfLIOraB7J67OL4wOioGz429n05g2mrjeZf7hSmYhOPqAWeUNoOLsFfcQwSaW9b85v0ksJ28aIBbzF1Ufc5eoAbjTKePNZQio2YH9nR5Hb5ESWuFc60or5W6eyYCSAHfDU9BL5Lkb6bbNFAbcPVQI56382bB+EaQn2MLV8cJAtLEm1EmRdUpV9IDmxYy3hGSGJmXUf/8U/THaoj3SHzGWUqm2KjMFq2jIViVh18xvsY7DNwXdN39NAF0bJhZlmNAFPTedqaTV42L9C1HR8zLwaqP20lfCbreSxWCribDTwh7rFkxtRt9pv6Z0s4z7kz3ISkUR1wkCoAuoE8BO9xvzaV3IDD4aIUhKZNQ3XbHC9eOkGKJ2Zxg7/OESN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acba7d43-162e-4873-e589-08d81becc2ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 05:24:56.7901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +z9n+RCz/QMht6CjJ+3OfArU70uofIyK6GGB3qs8Hb0z8M8RCatKM/Ge+As0hGAIA+c6+nppBqDbno7TQZ+a76hCmBt6ETjtQpqbDjgnttnoQFSSuNbx9FiDDge9iOEz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogWW9zaGloaXJvIFNoaW1vZGEsIFNlbnQ6IEZyaWRheSwgSnVuZSAx
OSwgMjAyMCAyOjQ2IFBNDQo+IA0KPiBIZWxsbyENCj4gDQo+ID4gRnJvbTogU2VyZ2VpIFNodHls
eW92LCBTZW50OiBNb25kYXksIEp1bmUgMTUsIDIwMjAgNToxMyBQTQ0KPiA+DQo+ID4gSGVsbG8h
DQo+ID4NCj4gPiBPbiAxNS4wNi4yMDIwIDg6NTgsIFlvc2hpaGlybyBTaGltb2RhIHdyb3RlOg0K
PiA+DQo+ID4gPj4gRnJvbTogWW9zaGloaXJvIFNoaW1vZGEsIFNlbnQ6IFR1ZXNkYXksIE1heSAy
NiwgMjAyMCA2OjQ3IFBNDQo+ID4gPj4NCj4gPiA+PiBBY2NvcmRpbmcgdG8gdGhlIHJlcG9ydCBv
ZiBbMV0sIHRoaXMgZHJpdmVyIGlzIHBvc3NpYmxlIHRvIGNhdXNlDQo+ID4gPj4gdGhlIGZvbGxv
d2luZyBlcnJvciBpbiByYXZiX3R4X3RpbWVvdXRfd29yaygpLg0KPiA+ID4+DQo+ID4gPj4gcmF2
YiBlNjgwMDAwMC5ldGhlcm5ldCBldGhlcm5ldDogZmFpbGVkIHRvIHN3aXRjaCBkZXZpY2UgdG8g
Y29uZmlnIG1vZGUNCj4gPiA+Pg0KPiA+ID4+IFRoaXMgZXJyb3IgbWVhbnMgdGhhdCB0aGUgaGFy
ZHdhcmUgY291bGQgbm90IGNoYW5nZSB0aGUgc3RhdGUNCj4gPiA+PiBmcm9tICJPcGVyYXRpb24i
IHRvICJDb25maWd1cmF0aW9uIiB3aGlsZSBzb21lIHR4IHF1ZXVlIGlzIG9wZXJhdGluZy4NCj4g
PiA+PiBBZnRlciB0aGF0LCByYXZiX2NvbmZpZygpIGluIHJhdmJfZG1hY19pbml0KCkgd2lsbCBm
YWlsLCBhbmQgdGhlbg0KPiA+ID4+IGFueSBkZXNjcmlwdG9ycyB3aWxsIGJlIG5vdCBhbGxvY2Fs
ZWQgYW55bW9yZSBzbyB0aGF0IE5VTEwgcG9yaW50ZXINCj4gPiA+PiBkZXJlZmVyZW5jZSBoYXBw
ZW5zIGFmdGVyIHRoYXQgb24gcmF2Yl9zdGFydF94bWl0KCkuDQo+ID4gPj4NCj4gPiA+PiBTdWNo
IGEgY2FzZSBpcyBwb3NzaWJsZSB0byBiZSBjYXVzZWQgYmVjYXVzZSB0aGlzIGRyaXZlciBzdXBw
b3J0cw0KPiA+ID4+IHR3byBxdWV1ZXMgKE5DIGFuZCBCRSkgYW5kIHRoZSByYXZiX3N0b3BfZG1h
KCkgaXMgcG9zc2libGUgdG8gcmV0dXJuDQo+ID4gPj4gd2l0aG91dCBhbnkgc3RvcHBpbmcgcHJv
Y2VzcyBpZiBUQ0NSIG9yIENTUiByZWdpc3RlciBpbmRpY2F0ZXMNCj4gPiA+PiB0aGUgaGFyZHdh
cmUgaXMgb3BlcmF0aW5nIGZvciBUWC4NCj4gPiA+Pg0KPiA+ID4+IFRvIGZpeCB0aGUgaXNzdWUs
IGp1c3QgdHJ5IHRvIHdha2UgdGhlIHN1YnF1ZXVlIG9uDQo+ID4gPj4gcmF2Yl90eF90aW1lb3V0
X3dvcmsoKSBpZiB0aGUgZGVzY3JpcHRvcnMgYXJlIG5vdCBmdWxsIGluc3RlYWQNCj4gPiA+PiBv
ZiBzdG9wIGFsbCB0cmFuc2ZlcnMgKGFsbCBxdWV1ZXMgb2YgVFggYW5kIFJYKS4NCj4gPiA+Pg0K
PiA+ID4+IFsxXQ0KPiA+ID4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJlbmVzYXMt
c29jLzIwMjAwNTE4MDQ1NDUyLjIzOTAtMS1kaXJrLmJlaG1lQGRlLmJvc2NoLmNvbS8NCj4gPiA+
Pg0KPiA+ID4+IFJlcG9ydGVkLWJ5OiBEaXJrIEJlaG1lIDxkaXJrLmJlaG1lQGRlLmJvc2NoLmNv
bT4NCj4gPiA+PiBTaWduZWQtb2ZmLWJ5OiBZb3NoaWhpcm8gU2hpbW9kYSA8eW9zaGloaXJvLnNo
aW1vZGEudWhAcmVuZXNhcy5jb20+DQo+ID4gPj4gLS0tDQo+ID4gPj4gICBJJ20gZ3Vlc3Npbmcg
dGhhdCB0aGlzIGlzc3VlIGlzIHBvc3NpYmxlIHRvIGhhcHBlbiBpZjoNCj4gPiA+PiAgIC0gcmF2
Yl9zdGFydF94bWl0KCkgY2FsbHMgbmV0aWZfc3RvcF9zdWJxdWV1ZSgpLCBhbmQNCj4gPiA+PiAg
IC0gcmF2Yl9wb2xsKCkgd2lsbCBub3QgYmUgY2FsbGVkIHdpdGggc29tZSByZWFzb24sIGFuZA0K
PiA+ID4+ICAgLSBuZXRpZl93YWtlX3N1YnF1ZXVlKCkgd2lsbCBiZSBub3QgY2FsbGVkLCBhbmQg
dGhlbg0KPiA+ID4+ICAgLSBkZXZfd2F0Y2hkb2coKSBpbiBuZXQvc2NoZWQvc2NoX2dlbmVyaWMu
YyBjYWxscyBuZG9fdHhfdGltZW91dCgpLg0KPiA+ID4+DQo+ID4gPj4gICBIb3dldmVyLCB1bmZv
cnR1bmF0ZWx5LCBJIGRpZG4ndCByZXByb2R1Y2UgdGhlIGlzc3VlIHlldC4NCj4gPiA+PiAgIFRv
IGJlIGhvbmVzdCwgSSdtIGFsc28gZ3Vlc3Npbmcgb3RoZXIgcXVldWVzIChTUikgb2YgdGhpcyBo
YXJkd2FyZQ0KPiA+ID4+ICAgd2hpY2ggb3V0LW9mIHRyZWUgZHJpdmVyIG1hbmFnZXMgYXJlIHBv
c3NpYmxlIHRvIHJlcHJvZHVjZSB0aGlzIGlzc3VlLA0KPiA+ID4+ICAgYnV0IEkgZGlkbid0IHRy
eSBzdWNoIGVudmlyb25tZW50IGZvciBub3cuLi4NCj4gPiA+Pg0KPiA+ID4+ICAgU28sIEkgbWFy
a2VkIFJGQyBvbiB0aGlzIHBhdGNoIG5vdy4NCj4gPiA+DQo+ID4gPiBJJ20gYWZyYWlkLCBidXQg
ZG8geW91IGhhdmUgYW55IGNvbW1lbnRzIGFib3V0IHRoaXMgcGF0Y2g/DQo+ID4NCj4gPiAgICAg
SSBhZ3JlZSB0aGF0IHdlIHNob3VsZCBub3cgcmVzZXQgb25seSB0aGUgc3R1Y2sgcXVldWUsIG5v
dCBib3RoIGJ1dCBJDQo+ID4gZG91YnQgeW91ciBzb2x1dGlvbiBpcyBnb29kIGVub3VnaC4gTGV0
IG1lIGhhdmUgYW5vdGhlciBsb29rLi4uDQo+IA0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29tbWVu
dCEgSSBob3BlIHRoaXMgc29sdXRpb24gaXMgZ29vZCBlbm91Z2guLi4NCg0KSSdtIHNvcnJ5IGFn
YWluIGFuZCBhZ2Fpbi4gQnV0LCBkbyB5b3UgaGF2ZSBhbnkgdGltZSB0byBsb29rIHRoaXMgcGF0
Y2g/DQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
