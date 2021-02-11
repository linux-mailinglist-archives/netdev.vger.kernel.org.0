Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E9D3182E4
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 02:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBKBIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:08:06 -0500
Received: from mail-dm6nam08on2133.outbound.protection.outlook.com ([40.107.102.133]:44032
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229601AbhBKBIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 20:08:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHa0NZ5a4hAVkfxwBsCQFxwakwfvqhvBSfDjebOpkDA4vv/j7CLHN2sS74RU88jryTSXZ2cg31kMpI23bLAT7LXNzo56RVjeKpiaMHaLC+Zva14X1jK2p8GXFAiB1802/of6F7ClY1bURJnEVmem+ao8psjSb7qPKrB6jpzeXhDHYYftK3djWicZ/JRMOh5U6pE7PG0UAIywVvvR5UB5w8yzpflDkBhI1xWajIqSLRR+jEH7ATLUqlcEjqyGAk5mLuaL+rOp7n2ooVyJvpnBXy+/+zea37DgdNPIbTBNQ4zDrsNm3bBD46i5CvZUsQ1omxb9sueLxb26irO0kWzpTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x41W0CSCdL6MRw8QeNQV7l1qLB18F9bo/205dL6fLfM=;
 b=gJk9xr5zv3x0FE6F281AboCPtdecQu5wvHJakdcNzr3x1wSHgIKQqAvIsPF7+p6nvIw/HXgf5Q1j6CeXFgDLlBjHBELzYy7sni2Q5qcSslgOBOIldQwuUtr88VtBuTooaeLJttUn67dTBBFWmxkhRaLaRFXqPapoRxwr8SD7ItXO/YDt7GwEm/0gn//sNXRiVug+/FevVA3n6am4BBbCIvOBU9P0usL02CF6aZNje8lxeK3V28if5O6umZnu8W2JovO3qlGhu2I2EbneQhAqrOSC3BSbDAfcavLOuAhCMgFkYbcRbRoLrBVERTS8X/YzC8HSsrgsK+7hi4T5ezru/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x41W0CSCdL6MRw8QeNQV7l1qLB18F9bo/205dL6fLfM=;
 b=JxwQk9G1tEDtSqGVh5BgvvvJLWeCzmZzTUqx4TNytFdvdw6HsrbBgjs2joIuDWrxh+OLBeeZ8GSDuyQGX4qCPgsJLvgONlwDcnlwlg8KCoA6u6o2YrXsEGK3qOZO8VmT58hu91/UFfEFV5WETt1Jmu8P6GzmGUYvdf2i2s5a4/A=
Received: from CH2PR13MB3525.namprd13.prod.outlook.com (2603:10b6:610:21::29)
 by CH2PR13MB3654.namprd13.prod.outlook.com (2603:10b6:610:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11; Thu, 11 Feb
 2021 01:07:10 +0000
Received: from CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063]) by CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063%3]) with mapi id 15.20.3868.011; Thu, 11 Feb 2021
 01:07:10 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com" 
        <syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: Re: UBSAN: shift-out-of-bounds in xprt_do_reserve
Thread-Topic: UBSAN: shift-out-of-bounds in xprt_do_reserve
Thread-Index: AQHW/0t2+5dQHLeS4UOD/bE63bVR7KpSIbQAgAAEJoA=
Date:   Thu, 11 Feb 2021 01:07:10 +0000
Message-ID: <d3a0733144edccb0842a39d9eb54da6cd1662ea5.camel@hammerspace.com>
References: <0000000000000f622105baf14335@google.com>
         <258ca358-d4ea-2bc0-9b0d-1d659eec04f7@infradead.org>
In-Reply-To: <258ca358-d4ea-2bc0-9b0d-1d659eec04f7@infradead.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9179be86-6aed-4896-d7e1-08d8ce295c09
x-ms-traffictypediagnostic: CH2PR13MB3654:
x-microsoft-antispam-prvs: <CH2PR13MB3654F9A0BCED37418FEFBBAEB88C9@CH2PR13MB3654.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LK5pOOqJNiwd7Z3cMe2FA0q2A0/o6EKcJl2PMheuWVL7s0AH3TeFEL1pDs9ol0VwROWOLV/yPOlcbTVjMDDbbnabZlUSiNCil8zyYHYLvOs6aUiMTxfRPMDhZ5gUBMoTUVTJtgX3S+k+whdiJI1Wbjd6GLnqX+ALh0OZ+Ua01VOrtzRRZrm4zCTEk89hFsoLZqvdhebS2T59eoHfoUbsJGCBDDtSvfj+Dh8Vade1xfm65WT4i1NQfQH9JcLicU/kQVtVQh+PB41apmKI++zZRflKvvkkeAX3hF786Af78EMf+kWW99P3qz6ntGZXKL+m59jt+woyyTtLA0frd/t6O6GrEMKjhu7qaECvn5YXE9b73PNmwyNpqwF0FKE7hGQYOwVeZfR2e7dpLnV8/tPf0Uv4wpE5t6oD9+a+U7GVjcwR542L936F6JwM1bu+NouYEnN+y0Y9HphXb0UkBNTcsrr2dB40Y9Z0rYLTqs3k2Nl1LpGCMXWX8lhsbjIFNw6QSv54U0Tlc/MNE9xWQjaisLRX9os6NF/edZrC++FhP2+MfO6n8AnbFnUoEjJWdQ4QLSxfosvF1Fs90AlCKvEua1pvex9Ew/rpcG265rukbByGwhXOsXnUTJRFq1xyhWWcZV18qTyN0L9mSwFMQfOVegvbhiWZaU2O+ZKr+PgTSRs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3525.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39840400004)(396003)(376002)(26005)(53546011)(6506007)(966005)(478600001)(2616005)(2906002)(76116006)(66946007)(7416002)(66556008)(8936002)(86362001)(66446008)(64756008)(66476007)(186003)(8676002)(6512007)(316002)(6486002)(71200400001)(110136005)(5660300002)(921005)(36756003)(99710200001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cWVBQVVCbnFMZUhKUXlIclRqaDJ2TitYY3NHekQ1Z3ZsNUUxTGwvWWlUNEdh?=
 =?utf-8?B?eUxKVHozT0FlZ2hlMks0Y1hCNytHT3RQUWJHcFh4b2dLSEgrOGJNNUd6NlJn?=
 =?utf-8?B?WWpiMUtoN3pRVGdiQWk1SElnVFFRZzJyaEI0ZVJsUVlNanM0TGxXc0RselZW?=
 =?utf-8?B?eVRtWXUwU0thcnhiendETlp3U0ZscXdPVThOREdyczRXamJGZ1E3SUZLUnpR?=
 =?utf-8?B?RUFsdytBZ3lCdE01YzN1WnE1SDNOQlh6Qm4vYXdCK1ZpMjJxa2xVNVFBVFZn?=
 =?utf-8?B?UjFnWXVJV0l6WmZBV25YQWZOQTdCWFp0YnBMWkZsV1E2NnlOcHBnUldOL0g2?=
 =?utf-8?B?QWsyZDlzbE9KOTJBMXBHMkxkSXJWbFNSMHE4d0VRK2orUHVDci9EaFRGN2xD?=
 =?utf-8?B?aGZiaTBNREptcGRSUDJ5K1JXcXpYY1hsSUlpdUdpMnlsODZBUXg3QlBYV0Zn?=
 =?utf-8?B?Mm1aL1NFTnlpeWQ5bE1sdXZmMWpqNjdnV1lDYWM1RXJ0R25NMVROMjA0d1lX?=
 =?utf-8?B?S2JRcGplWm5GZVRRSHBOSUMyQkFaMDhYcGhEaERvVUZjTnppTmNlczBlTnNW?=
 =?utf-8?B?RDQ0TjJOSUx1RFFBVHBZaU1Pd0RIN0hucGp2MTNMVktWN3FES1RXL0pWdTlG?=
 =?utf-8?B?VTBQcTRTZHJwck90cysvK0ZJNkxSamhXK2NDVjZJbzZ6S05SaFpnd3ZHYXEv?=
 =?utf-8?B?T1I1QzcwMVFSYmxad3RNUzRqdlAxc21ISjQyejgxSEpnaU8vVHE1VTlpRXlE?=
 =?utf-8?B?bURRYkoyZXhGcUtld2p1MWVyaVFZWHZOOE1XZEZ6QkVHellJeFFOK3NpZnY0?=
 =?utf-8?B?Rm1CYUwyMS9uWDhvY2p5R0d6QktGQ1pDNk9RRGhRc3dRTUhOUDZGWURNSDB5?=
 =?utf-8?B?empHNVk3WEpYZHVwNUNQZGZMWkxzbmVKUlptMkZ4b01iNTY3eE94UmltZW1y?=
 =?utf-8?B?T0QwdU5vditCaFpOd0g1cHFWNXUxSlNoc3p4eUdsSFdjOFVGV3dHNkF1dTdo?=
 =?utf-8?B?ZWRoSGdWdEFIQ1djNFgveEpwRVBpNWJLWFVBQnpqU2Fab0pKcWVDMGVrNFhE?=
 =?utf-8?B?Ymh1ZnhhMnI5MW40Y3lwMml4amZpbjBxK0NzRVVHU2lWL2N5amhNbGl6ODdm?=
 =?utf-8?B?WWozay9mZHhMeGFkZTlxUys1Y0FWeWdNMHpqMm1SV292QmZPUVU1RUd6N2gv?=
 =?utf-8?B?QUozSDg3VTN3YVpmVm9CdC8wWmo2dG5WSEROYzMvVjBjUEtTeG0wTE5EV2RF?=
 =?utf-8?B?NHJ1UmdCMC9yZm5xR1VGWi9XcG9HbExRNXY3SHg1TzdidEwvazdqRmxlaTlO?=
 =?utf-8?B?ZjdLWmI4ZEYzWlR3MlNacHZ3OVhUaEgraGFtOFdzWDd1dENWTm9mcDhyM0o0?=
 =?utf-8?B?VmJ4V3Q4bzBlQWRrVmJZWkZjdzUrK25RU0NobDAxK1pHSG5PRTRvVlFVK01R?=
 =?utf-8?B?L0ZFOGVZUFpNcEdRZVkyeEVqVFpMTzNaYVExMWdubldzT1lMcFZQNERCSnhW?=
 =?utf-8?B?eElFZ05KUzlLaThSTTdoM0MxRWhyblR0dDNBMWhRTGhGV280YURPZXpDajRu?=
 =?utf-8?B?UkNFbXUyd3ZPSEQxU0hoZXYzdmpDNXNoZFdySWpGU2x3MWEvTDY2K3M2d1Jx?=
 =?utf-8?B?MkJKUFFYMUpvWUNadUVRdVRUN0NPbWRldzg1dTMrV3dZZVkzdmcxYi9KZUdx?=
 =?utf-8?B?WFhTdFNIMHhlZUJ3L0pJdlFHRkxmMXhqeVkyZGRpMDRqWUlMYXBWSVNCZzNS?=
 =?utf-8?Q?DIUc6CBldHPJtXLhyuTOIUgojkVDmbjOik1jcnt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <38CB1D0A0B95E949B066C6D769CE3FAB@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3525.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9179be86-6aed-4896-d7e1-08d8ce295c09
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 01:07:10.4795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KFomlHDH8m4HtxRXb7FxWcjR0uM7OCQMIVLtOYP4QiAdccgYPgZWjYij6FnU+TyoyUwXJyjjwgXqvx5MUuQwPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3654
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmFuZHksDQoNCk9uIFdlZCwgMjAyMS0wMi0xMCBhdCAxNjo1MiAtMDgwMCwgUmFuZHkgRHVu
bGFwIHdyb3RlOg0KPiBPbiAyLzkvMjEgNToyNCBQTSwgc3l6Ym90IHdyb3RlOg0KPiA+IEhlbGxv
LA0KPiA+IA0KPiA+IHN5emJvdCBmb3VuZCB0aGUgZm9sbG93aW5nIGlzc3VlIG9uOg0KPiA+IA0K
PiA+IEhFQUQgY29tbWl0OsKgwqDCoCBkZDg2ZTdmYSBNZXJnZSB0YWcgJ3BjaS12NS4xMS1maXhl
cy0yJyBvZg0KPiA+IGdpdDovL2dpdC5rZXJuZWwuLg0KPiA+IGdpdCB0cmVlOsKgwqDCoMKgwqDC
oCB1cHN0cmVhbQ0KPiA+IGNvbnNvbGUgb3V0cHV0Og0KPiA+IGh0dHBzOi8vc3l6a2FsbGVyLmFw
cHNwb3QuY29tL3gvbG9nLnR4dD94PTEwNTkzMGM0ZDAwMDAwDQo+ID4ga2VybmVsIGNvbmZpZzrC
oA0KPiA+IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL3gvLmNvbmZpZz94PTI2NmE1MzYy
Yzg5YzgxMjcNCj4gPiBkYXNoYm9hcmQgbGluazoNCj4gPiBodHRwczovL3N5emthbGxlci5hcHBz
cG90LmNvbS9idWc/ZXh0aWQ9ZjNhMGZhMTEwZmQ2MzBhYjU2YzgNCj4gPiBjb21waWxlcjrCoMKg
wqDCoMKgwqAgRGViaWFuIGNsYW5nIHZlcnNpb24gMTEuMC4xLTINCj4gPiBzeXogcmVwcm86wqDC
oMKgwqDCoA0KPiA+IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL3gvcmVwcm8uc3l6P3g9
MTdiYTMwMzhkMDAwMDANCj4gPiBDIHJlcHJvZHVjZXI6wqDCoA0KPiA+IGh0dHBzOi8vc3l6a2Fs
bGVyLmFwcHNwb3QuY29tL3gvcmVwcm8uYz94PTE1Y2YwZDY0ZDAwMDAwDQo+ID4gDQo+ID4gSU1Q
T1JUQU5UOiBpZiB5b3UgZml4IHRoZSBpc3N1ZSwgcGxlYXNlIGFkZCB0aGUgZm9sbG93aW5nIHRh
ZyB0bw0KPiA+IHRoZSBjb21taXQ6DQo+ID4gUmVwb3J0ZWQtYnk6IHN5emJvdCtmM2EwZmExMTBm
ZDYzMGFiNTZjOEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IA0KPiAjc3l6IGR1cDogVUJT
QU46IHNoaWZ0LW91dC1vZi1ib3VuZHMgaW4geHBydF9jYWxjX21ham9ydGltZW8NCj4gDQo+ID4g
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQ0KPiA+ID09PT09PT09PT09PT0NCj4gPiBVQlNBTjogc2hpZnQtb3V0LW9mLWJv
dW5kcyBpbiBuZXQvc3VucnBjL3hwcnQuYzo2NTg6MTQNCj4gPiBzaGlmdCBleHBvbmVudCA1MzY4
NzA5NzYgaXMgdG9vIGxhcmdlIGZvciA2NC1iaXQgdHlwZSAndW5zaWduZWQNCj4gPiBsb25nJw0K
PiA+IENQVTogMSBQSUQ6IDg0MTEgQ29tbTogc3l6LWV4ZWN1dG9yOTAyIE5vdCB0YWludGVkIDUu
MTEuMC1yYzYtDQo+ID4gc3l6a2FsbGVyICMwDQo+ID4gSGFyZHdhcmUgbmFtZTogR29vZ2xlIEdv
b2dsZSBDb21wdXRlIEVuZ2luZS9Hb29nbGUgQ29tcHV0ZSBFbmdpbmUsDQo+ID4gQklPUyBHb29n
bGUgMDEvMDEvMjAxMQ0KPiA+IENhbGwgVHJhY2U6DQo+ID4gwqBfX2R1bXBfc3RhY2sgbGliL2R1
bXBfc3RhY2suYzo3OSBbaW5saW5lXQ0KPiA+IMKgZHVtcF9zdGFjaysweDEzNy8weDFiZSBsaWIv
ZHVtcF9zdGFjay5jOjEyMA0KPiA+IMKgdWJzYW5fZXBpbG9ndWUgbGliL3Vic2FuLmM6MTQ4IFtp
bmxpbmVdDQo+ID4gwqBfX3Vic2FuX2hhbmRsZV9zaGlmdF9vdXRfb2ZfYm91bmRzKzB4NDMyLzB4
NGQwIGxpYi91YnNhbi5jOjM5NQ0KPiA+IMKgeHBydF9jYWxjX21ham9ydGltZW8gbmV0L3N1bnJw
Yy94cHJ0LmM6NjU4IFtpbmxpbmVdDQo+ID4gwqB4cHJ0X2luaXRfbWFqb3J0aW1lbyBuZXQvc3Vu
cnBjL3hwcnQuYzo2ODYgW2lubGluZV0NCj4gDQo+IA0KDQpTbywgZmlyc3RseSwgdGhpcyBpcyBh
IGNhc2Ugb2YgJ2RvY3RvciBpdCBodXJ0cyB3aGVuIEkgZG8gdGhpcy4uLicgc28NCml0IGlzbid0
IGEgY3JpdGNhbCBpc3N1ZS4gSXQgaXMgYSBjYXNlIHdoZXJlIGdhcmJhZ2UgbW91bnQgb3B0aW9u
cw0KcHJvZHVjZXMgZ2FyYmFnZSB0aW1lb3V0IHZhbHVlcy4NCkhvd2V2ZXIsIG1vcmUgaW1wb3J0
YW50bHksIGl0IGlzIGEgY2FzZSB3aGVyZSB3ZSBjb3VsZCBlYXNpbHkgYmUNCmNoZWNraW5nIHRo
ZXNlIHZhbHVlcyBvbmNlIGF0IG1vdW50IHRpbWUgaW5zdGVhZCBvZiBhZGRpbmcgcnVudGltZQ0K
Y2hlY2tzIHRoYXQgY2FuIGVuZCB1cCBiZWluZyBjYWxsZWQgc2V2ZXJhbCB0aW1lcyBwZXIgUlBD
IGNhbGwuDQoNCkNoZWVycw0KICBUcm9uZA0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5G
UyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJz
cGFjZS5jb20NCg0KDQo=
