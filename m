Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507DF6885C7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjBBR5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBBR5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:57:50 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2047.outbound.protection.outlook.com [40.107.15.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999D86A714
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y074rcxBiHZYVSCtjUPq0AEm74hcDf3fBu3/ms6c7XSKmY1sw2sBmSHSc85dKiDtOz3yMQbMyInjlNtq2D8j9Yq+Irx3Cx1dzuSZ3z1srOA+JUW4R2M+vRRZ6pvNohsFhUFX+Y9b5l9zOCMBQAqtWU4t80OoybpK3W7BOahKG729K3oLCoYf+v6Wo4FSrekUV8L+URuizILd66h9ePj7xuWH0fJH/EPQ+zRlU6MC4BbmRO/pNEZ1/SnlWrzfeY955G1/D4EiKg7zo+pyFgOZqG3BT8/xmo8yrOdDUMoi13N8HfTK99TkC5t8JBEfRyz0wP43tW29OEl90Z0z9mbISw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKnQWpPjF6vQQdgd1Pgx54ljmC07AI2+WKHqzL/KLYQ=;
 b=cDtXnsUbXMIHfg9WNUVOPNhNVAo1WVDr2ki6efxY0Z7Kv+EmleprRIkgmz6wiVMVMF9nf7Mc0zDPXmPgfHhu5x7nSc/wepuYBmRTUQJJR0qDIxA4tBO9W+EfL1KNbAj5inbyAMITkg7tPTX1Sbj7Mj797THfm5lR2p785s0g0utMJUcl4DxRhJj9xN7Qocc8/fu0tEFyp0IMRswwQrWVFy3SS3iN1m/vuMimVJ2C9OYfQu07M5Bg9RzwqNSGvw4Jk0TVDC73K/7aZE+2jQGHa8h8RRoleerXbrkd79EuPpivs7m2s2Z8/3uVLZ/9AhGIgXY/NHnxS7hRJ8V+KWEdjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKnQWpPjF6vQQdgd1Pgx54ljmC07AI2+WKHqzL/KLYQ=;
 b=ZRN7EJZmLoLLWfd1ZEDPR8wgYtJ/BDTPO9BhZ1U9iYwgupiYBFzrVM43QaS45i4xKuoPmjF09BYr9OvDqtySV7TJM8cpRhE4nOts4Fak7nv0WQ+UY0l9dy+TEGfhleYXYwL29qarIq/1gyQIv0yk6sE/bCdaHmZ/MssIfQJfQPqFnIKXT2w/+oGflI6bVW46BF6DhP34CLHysh8xe5Bobcaqv5Zzz4/KIv2h6JUV7mYjbkxZUJToaBkf9TBg9ilPY3oWi4k7HBWRTwG0XqLs32sELd3VUOxDtFdAGmjfE8+EYE84OG1OgqU2ThOYMiXHOBNm7cudH0Ln+bBAn0KILQ==
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:138::9)
 by VI1PR10MB7755.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:1cd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 17:57:46 +0000
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0]) by DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0%8]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 17:57:45 +0000
From:   "Valek, Andrej" <andrej.valek@siemens.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Thread-Topic: DSA mv88e6xxx_probe
Thread-Index: AQHZNxmfDlWccw5bT0qZPgjeOkJESa670gKAgAAffgA=
Date:   Thu, 2 Feb 2023 17:57:45 +0000
Message-ID: <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
         <Y9vfLYtio1fbZvfW@lunn.ch>
In-Reply-To: <Y9vfLYtio1fbZvfW@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR10MB3977:EE_|VI1PR10MB7755:EE_
x-ms-office365-filtering-correlation-id: ff6aa316-be4e-4433-7b23-08db0546fd05
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xmSad/5ZLtsZpDAIBYI1c8K6tEzcyf5+5bS5RrXzDYP2lMFMw9rEG9yK1O3o98G1pgnj9UxuFsTb6UzPhz5sCyqsZHjuMxIsan54/CO/9Rr1XvVz27ikvVwOCtako0Ysg8LoZ4c9WGuK0ZmorfEGTEZIgoovkQUzXs9H/XlG31hJipPKSgJ5jrvSdisgT/XWcs1Wm+nFZkHepgkEfN0p4oIGNxHUhp8V5q8VuRACzpyx49nj3C1af32iTaO8/evUtpZSghjG8SP/mB7F63OJcl+y+0RWIsTrrV7c0QvDoAnt8fc9yVhaGXHAg8e5mqGo6/JbOjNy4o3QI6uR4jmfSDruiKzKkaFUyfe152DUlMGPGiexw2IqynfFy3oHr+tPUg0gvq0YeqeAWpS/OF51/2gc3wohov0Uz0o7pObhrr2vrhTUvBAzPknEUIjQ9jYLAIy5OjTh4iOdsuEO8KFF/aBn9gqGaOgDNF9Zk+7y0XLjAKHO1JQKfW4qBE37goT/zYPbqAsbFlhAiK0ncJFVgXLEAGeSMIOAUIa8Yiidzs7ZUmiB/Z/SqBxsFMB2wB++25XLa37Ch+3XoiLEr4LrPACCmVyPox1zPMyoau/XjHMd/SbnjuKzUEuWTO5c85YddL+K9TaST+fPgBNAGcAboUKFARARNsseq+y/h/VJeeqzS9q0DgrqaIoYj1b2MhBEGQJ4bQz0JtboansLdN2Kxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199018)(82960400001)(36756003)(38070700005)(316002)(122000001)(38100700002)(66476007)(6916009)(26005)(76116006)(66446008)(64756008)(8676002)(86362001)(54906003)(4326008)(91956017)(66946007)(66556008)(71200400001)(7116003)(41300700001)(8936002)(2616005)(2906002)(83380400001)(478600001)(6506007)(6512007)(186003)(6486002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHFLWVg0MzJycG5HTzRySzU4cTAzd1JQamQwM2JCeGVWNDE0cDRkOFNCSE5h?=
 =?utf-8?B?SWdtVnYwQmQvS3BaOHpVWDIxYXdPTmEyWjhQMkdGcHAzV3Jkc0krM2hnMDkz?=
 =?utf-8?B?OW5QS05XdTAvemVxVXpxdm91anJuOEl4ME16Z0V1bEZOSGZEZzR3WkwzZlk1?=
 =?utf-8?B?bGVTQkE3TmFpVk5ycWFtc0ZIaXFaeFVIRUxaOGdObjFPSEN4UlZhWGZWejlI?=
 =?utf-8?B?UUc4cFQ1NklMSkIyTG01RFgvQzV3NTVhYzNqZExiYkdCWlI5dDJ1VnNSU1dP?=
 =?utf-8?B?L3Q5SEFCQUFJS1h0OGExTW4rWnQ3N1RleHVnTWdHNDkwUllsVWlNSkRsd0Fp?=
 =?utf-8?B?WWtrR3VWUmxsVkVKS2NLSG5HbkRCZ3dJQ3FQYUFGQ2wva2pSTzNyMG5NYjdn?=
 =?utf-8?B?Ti9vVFVtUXNWR3RUNFNqZmtRWlNCUlZyMU5sbUIySkpzUjlURDhjYlo2QlJa?=
 =?utf-8?B?TzJwdDZGRmZ3eHp4bHVUcWNIdENwUnZBVjN1UmJhRTRRV056SzhOQzBqT3hT?=
 =?utf-8?B?Mk1UNmVUbHFoSEVtanV3cVdUU0dQdmZsVHdxdXYzQVNpTmw2TTg2NXNKaEVK?=
 =?utf-8?B?QkNGcXBIbVJyNktQSE1vQkVadWNPSWk4UlEvemVhNkVWR0I1RmJYdFNnaWlF?=
 =?utf-8?B?aHZwbCtXYjlmTm5KMjdrU1hkTTIyY0htS1lCMHpJd1ZScGNmN3BMdTdxcFhv?=
 =?utf-8?B?NU0ybmRsMFdNdnRRczFDdUtGaXJKc1B6eElpRDQ3VUJpUldLZXYxQ0FaaVdW?=
 =?utf-8?B?d1FDVjdiWEF4NldHVTJsa0xVRTZ6ZnhQLzNrNEk0MDNBZmp1Umw2dGEwem4z?=
 =?utf-8?B?THMvU1N1TkdNNGxCdkNaN1dnRGVLNk03S01NUk5qTWgvUWlLTTNhOHpRQk1v?=
 =?utf-8?B?SFNYNWIwRzZXbndWRE4wcEdxVzVjc3BWTDZJQklyYU50aEpwUUZGMXBXalR4?=
 =?utf-8?B?ak5rajNleCt5MVN2NDU5VDlveVYzSmMvRWZUVVo3TWJUVk9WOUdWTkZuNFR0?=
 =?utf-8?B?R2ZSS3gzdDl3K0VYc3hBQlZTNm9DNUpoaXRMMVQ1UWlpbDBFVWQzdmh2Y0NR?=
 =?utf-8?B?VUdEektmVDU1SE14R1ljS0hmSWdmTHQycVVlaEc3bCt0bXZRSVY1aUlLVFcx?=
 =?utf-8?B?ZVBNTnN5SU5udmNsVStMTW5NNnNVLzhTcDhlRDQ1cStwazVWQTZpcExPT3VL?=
 =?utf-8?B?OWJXSlgydloxNkVQWTdnU0NzL0VERHZZemxRNlNaL1lxU1RyMW83c0hYTGxu?=
 =?utf-8?B?eWkxR255YlhUVTd1Z3Y1M3dZaVFLSVRCdGFlalNLVHNySE1ZMWZlYVI2QTdU?=
 =?utf-8?B?T0IreURBb2VuY1hwazYwcSt6QmdjQm81RWtQemNRZGlKcEdyNm9ZdldLQjR1?=
 =?utf-8?B?Uncrdmw2L29QV0E0NmN4TW5CM2N1a2FWb3NmeEp2RFlkcGxURkRtVWc3KzE0?=
 =?utf-8?B?RDM5aXBERWJxN0xpM09rc0dtM1g5RTFvZGRNczJIdWNqQ24wTVgxT2FtMWps?=
 =?utf-8?B?UHhJdUc1aXdDYXBaVEVGOWdYZVk1SWRoQjFrRW9iRko3VTZ3dXh3Y2YzUldX?=
 =?utf-8?B?Y0tBbUpWeVVaMkN4MFFlaG5tOHZWa1VLTk9iQ0pXNXFBeGoyc2YzM2ZuQWhm?=
 =?utf-8?B?cjJFODFWZk14SWlId2VkMkZVRkp2TVg4OW1ETEFFRHZ4c2NyTUVyRGh3N21Y?=
 =?utf-8?B?VEZYR2pDSWlmYlIvUW95dTlEbmRhbUdERGRqQ25zSnF5YXlQY2IvOENLVjJU?=
 =?utf-8?B?emx2OS80VUVaUEJHbEt2VnN6NytlSlRqdmRKZUFqL0luYUlQUDd1M2dnQytv?=
 =?utf-8?B?UG9yMG5UVjEycmdIblZHdFdxdXJnR1FwemMxcmg3REo2MUsvZnQrSmVLdWZ1?=
 =?utf-8?B?Njl6R2NpUi8xNHA1SjlLSm0yWHhrZmJVSndCMEJUdzdqNEJKQVllcllJWkpm?=
 =?utf-8?B?UkdzL1oyNWxEdmRwTG01akJQUjZJSjE2bC9EQ0V4YUNMUHR4MjRJVnZzSGV4?=
 =?utf-8?B?dHV0N29NM2x6czJEZ3NORzBGT2tmZXlKeW8wNlZMNWFjQ1VzU2JaNHQ0cGZw?=
 =?utf-8?B?NE5DeTFpdHJ4a2RYb2lHc3ZsamQ5d3NacG5PWmUwbVk2N28ySkV0T011bVli?=
 =?utf-8?B?Q29tcWdpOFJuMTZYZWx2eVVhTFM4SysxNUxINHRxeXhSZDRRcE5qSFR0MUcz?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EC33CCE1AC0154DB1FCFC3447AD6AFD@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6aa316-be4e-4433-7b23-08db0546fd05
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 17:57:45.3432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uIVucmlb1SaZO+DvMfr9BsxIvUUplm5eJu1Qn+WJmH9nNnaA0AjorMIL2nNf4FD7wMsdVayrFjWiPxBn2dRtl2kPnPdJ6cHXp3GKbPDEIWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB7755
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGZvciB0aGUgZXhwbGFuYXRpb24sIGJ1dCBJIGhhdmUgc29tZSBhZGRpdGlvbmFs
IHF1ZXN0aW9ucy4uLg0KLg0KDQpPbiBUaHUsIDIwMjMtMDItMDIgYXQgMTc6MDUgKzAxMDAsIEFu
ZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUaHUsIEZlYiAwMiwgMjAyMyBhdCAwMzoxODozN1BNICsw
MDAwLCBWYWxlaywgQW5kcmVqIHdyb3RlOg0KPiA+IEhlbGxvIGV2ZXJ5b25lIQ0KPiA+IA0KPiA+
IEkgaGF2ZSBhIHN3aXRjaCBtdjg4ZTYwODUgd2hpY2ggaXMgY29ubmVjdGVkIHZpYSBNRElPIGJ1
cyB0byBpTVguOA0KPiA+IFNvQy4NCj4gPiANCj4gPiBTd2l0Y2ggaXMgbm90IGJlaW5nIGRldGVj
dGVkIGR1cmluZyBib290aW5nIGJlY2F1c2UgdGhlIGFkZHJlc3MgaXMNCj4gPiBkaWZmZXJlbnQg
KGR1ZSB0byB1bmluaXRpYWxpemVkIFBJTnMgZnJvbSBEVEIpLiBUaGUgcHJvYmxlbSBpcywNCj4g
PiB0aGF0DQo+ID4gc3dpdGNoIGhhcyB0byBiZSByZXNldCBkdXJpbmcgYm9vdCBwaGFzZSwgYnV0
IGl0IGlzbid0Lg0KPiA+IA0KPiA+IFNvIEkgd291bGQgbGlrZSB0byBhc2sgeW91IG1heWJlIGEg
Z2VuZXJpYyBxdWVzdGlvbiBhYm91dA0KPiA+IGRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFsIGZ1bmN0
aW9uIGluc2lkZSBtdjg4ZTZ4eHhfcHJvYmUuDQo+ID4gDQo+ID4gSXMgdGhpcyAiY2hpcC0+cmVz
ZXQgPSBkZXZtX2dwaW9kX2dldF9vcHRpb25hbChkZXYsICJyZXNldCIsDQo+ID4gR1BJT0RfT1VU
X0xPVyk7IiBsaW5lIHJlYWxseSBkbyB0aGUgcmVzZXQ/IEJlY2F1c2UgZnJvbSB0aGUgbGluZXMN
Cj4gPiBiZWxvdw0KPiA+IGxvb2tzIGxpa2UsIGJ1dCB0aGUgcmVzZXQgcHVsc2UgaGFzbid0IGJl
ZW4gbWFkZS4gTWVhc3VyZWQgd2l0aA0KPiA+IHNjb3BlLg0KPiA+IA0KPiA+ID4gY2hpcC0+cmVz
ZXQgPSBkZXZtX2dwaW9kX2dldF9vcHRpb25hbChkZXYsICJyZXNldCIsDQo+ID4gPiBHUElPRF9P
VVRfTE9XKTsNCj4gPiA+IGlmIChJU19FUlIoY2hpcC0+cmVzZXQpKQ0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoGdvdG8gb3V0Ow0KPiA+ID4gDQo+ID4gPiBpZiAoY2hpcC0+cmVzZXQpDQo+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgdXNsZWVwX3JhbmdlKDEwMDAsIDIwMDApOw0KPiA+IA0KPiA+IFNvIGl0
IHNob3VsZCB3YWl0LCBidXQgZm9yIHdoYXQ/DQo+IA0KPiBUaGUgY3VycmVudCBjb2RlIGlzIGRl
c2lnbmVkIHRvIHRha2UgYSBzd2l0Y2ggaGVsZCBpbiByZXNldCBvdXQgb2YNCj4gcmVzZXQuIEl0
IGRvZXMgbm90IHBlcmZvcm0gYW4gYWN0dWFsIHJlc2V0Lg0KPiANCkhvdyBkb2VzIGl0IHRoZW4g
d29yaz8gSSBzZWUganVzdCBhICJkZXZtX2dwaW9kX2dldF9vcHRpb25hbCIgd2hpY2gNCmp1c3Qg
YXNzaWduIGFuIHBvaW50ZXIgdG8gImNoaXAtPnJlc2V0IiBhbmQgdGhlbg0KIiBpZiAoY2hpcC0+
cmVzZXQpIHVzbGVlcF9yYW5nZSgxMDAwLCAyMDAwKTsiIHdoaWNoIGp1c3Qgd2FpdHMgZm9yDQoi
c29tZXRoaW5nIiA/IFdoZXJlIGlzIHRoZSAicmVzZXQiIHRvb2sgb3V0PyBJIGRvbid0IHNlZSBh
bnkgZ3BpbyBzZXQNCnRvIDAuDQo+IElmIHlvdSBuZWVkIGEgcmVhbCByZXNldCwgeW91IHByb2Jh
Ymx5IG5lZWQgdG8gY2FsbA0KPiBtdjg4ZTZ4eHhfaGFyZHdhcmVfcmVzZXQoY2hpcCksIG5vdCB1
c2xlZXAoKS4NCj4gDQo+IEhvd2V2ZXIsIGEgcmVzZXQgY2FuIGJlIGEgc2xvdyBvcGVyYXRpb24s
IHNwZWNpYWxseSBpZiB0aGUgRUVQUk9NIGlzDQo+IGZ1bGwgb2Ygc3R1ZmYuIFNvIHdlIHdhbnQg
dG8gYXZvaWQgdHdvIHJlc2V0cyBpZiBwb3NzaWJsZS4NCj4gDQo+IFRoZSBNRElPIGJ1cyBpdHNl
bGYgaGFzIERUIGRlc2NyaXB0aW9ucyBmb3IgYSBHUElPIHJlc2V0LiBTZWUNCj4gRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZGlvLnlhbWwNClRoaXMgbG9va3MgcHJvbWlz
aW5nLiBTbyBJIGhhdmUgdG8ganVzdCBtb3ZlIHRoZSAicmVzZXQtZ3Bpb3MiIERUQg0KZW50cnkg
ZnJvbSBzd2l0Y2ggdG8gbWRpbyBzZWN0aW9uLiBCdXQgd2hpY2ggZHJpdmVyIGhhbmRsZXMgaXQs
DQpkcml2ZXJzL25ldC9waHkvbWRpb19idXMuYywgIG9yPw0KPiBtZGlvIHsNCj4gCSNhZGRyZXNz
LWNlbGxzID0gPDE+Ow0KPiAJI3NpemUtY2VsbHMgPSAwPjsNCndoaWxlIGhlcmUgaXMgbm8gY29t
cGF0aWJsZSBwYXJ0Li4uIC4NCj4gDQo+IFlvdSBtaWdodCBiZSBhYmxlIHRvIHVzZSB0aGlzIHRv
IHBlcmZvcm0gdGhlIHBvd2VyIG9uIHJlc2V0IG9mIHRoZQ0KPiBzd2l0Y2guIFRoYXQgYWR2YW50
YWdlIG9mIHRoYXQgaXMgaXQgd29uJ3Qgc2xvdyBkb3duIHRoZSBwcm9iZSBvZg0KPiBldmVyeWJv
ZHkgZWxzZXMgc3dpdGNoZXMgd2hpY2ggaGF2ZSBjb3JyZWN0IHBpbiBzdHJhcHBpbmcuDQo+IA0K
PiDCoMKgwqDCoMKgwqDCoMKgQW5kcmV3DQoNClJlZ2FyZHMsDQpBbmRyZWoNCg==
