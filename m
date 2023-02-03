Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735966891A7
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjBCIKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCIJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:09:11 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA89EF9E
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:07:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdCzuwYFAavmXN2DihesOtXauhGQuEuz48HVKxZO3rPFGTUdr3+TMoaoubSE/QGLPCOhuujXvYYX9M94ClhYyGbB2Y6RF5gbR2a/QVJn+sHi014bCZ272KaNcb6nzbYF6j42kOfl1iIryIEOsep4qN9suFRHy0jafGLMkx+zFW3URcXJkrb0oDlt2seMIA1IXzdH8RzBSQDrgtqOlmxMVXhC+fXx8IGshCY7JKG1Q4vhB898N7iouq4tszRD1yeSZ3kYY+5pR6HuA6BbJVriYRKVTi9BqyU0COCJa0CslROi9PKf3O+rzqqLUDqtrWkgnMEd0ImRl5lXPWIYmya0xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbdCw9dKtIBzgqJOK7euChg0JEynhgP+PZ1t/GEFiXk=;
 b=O8VxXTubsw9onBKdbFLiZJwlqmrzxKier6HA/YfkeB7UJW0kpRUhxeUKLRPwRv2UUODcevW4YmAkbeJJnaSTddUXoPv6VrieZj2dD7KkdsiYJTfpBMXtvuIm9o20JIm78OQC4snwKAbbA/1DDdK7Xx/1eotctiqQgSRhzByA69uO5QH6Bn1A9Yyen+z8FE7VkLdzBF1W/wkr7H8HKFdY9/ejqZswz1lkzvuRF6SW2z+uc3f4MqYmR6FyIcOQEXEBz90UHc2lTmhIJ+1LMAumfe3U2j/GQoTziL932wooParZAUlzg8iQTvxBYUPwXqiYgUPsP65o0DFUx5uJuqvg8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbdCw9dKtIBzgqJOK7euChg0JEynhgP+PZ1t/GEFiXk=;
 b=q07UIz4ekLIZOpSWMtWecUYQ+5K8NNrptCeRZD/Q0YruQpbIgfHZK48L3+uorlgQyQoiPCIZYq1gXXi5emf2F8NV9glIUhoj8s1zHGAiYNnVZH2wGhLuEQ9MWPKqI3ZfSCc9lZUbJKGfN1eLx1jDAr7wykFQQ52Aveht+a1oEsBt2nlDRNZJfHbLuVgh8L22MLD7n9Sr7YkS8REViUdeN6hkI8Alj54cKQfCoxPx3C5xpWSxs6yIKofrxr5maXnpBuXmWRmCKV/wyzDhyZ9HvJRQBtvd92M3dp3x3VG8D7t5oxj621Bp7ooXLpG+J/TKM03LnHP9fUYJh+glkyGIUg==
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:138::9)
 by DU0PR10MB6131.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3e6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 08:07:52 +0000
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0]) by DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0%8]) with mapi id 15.20.6064.029; Fri, 3 Feb 2023
 08:07:52 +0000
From:   "Valek, Andrej" <andrej.valek@siemens.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Thread-Topic: DSA mv88e6xxx_probe
Thread-Index: AQHZNxmfDlWccw5bT0qZPgjeOkJESQ==
Date:   Fri, 3 Feb 2023 08:07:52 +0000
Message-ID: <05f695cd76ffcc885e6ea70c58d0a07dbc48a341.camel@siemens.com>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
         <Y9vfLYtio1fbZvfW@lunn.ch>
         <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
         <Y9v8fBxpO19jr9+9@lunn.ch>
In-Reply-To: <Y9v8fBxpO19jr9+9@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR10MB3977:EE_|DU0PR10MB6131:EE_
x-ms-office365-filtering-correlation-id: 69a56fd1-0ed7-462c-915b-08db05bdbf86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W9O8Q3wFwv5/iCcz1zlRpRxX7p7OPi+LM2hAnQ2qTXlS+c0gs5YFBIgG4/Pk/kiCxZ0TtNRjspkDQkpVlr/Cm7OTDWUAlDKjLImRdq2EY2Cml8sPjtdJgdegbU/Jkk+AV38puaInMn47KccINAAGZc+mEdk/OWwC2m+eJTBOOyMKJZOknHAiufDm6JVyR04p+teaYZ4i8xUXIu+4EU060w5GGPr/+cXrwmK/q2KPZHPpC+7rcFqGif30IHLtfkaqrQc2MlaC1wXvQnGZJxmjoNhtbVqi/InvclYibFk7j3+kFxb5pyR7lGrmu6hHEBGFtBHZAnQd+sDE6nvz+PvCtfWq0REmRPySfma1GKhRZ206LfTSthO5wQXwm+s39dAwb3yMCl0WQErlS5SqSdE8ClL6+RP5qpXcWf+BhhqNdvHDSvOs/fRyIYTfUqBo3Yh8VDLlDU+WvnfDGakgtlQtFkl0+vgb6Dx059FM8h+YmAQVgZvu9UGFpity3vk2E5ivF82dfgzatyQ0Xk0nvrXUL7tEswf27/KfI2SWE5anxmogFkRW29pa37rr9ajtLlyfAcMRZRAF/bw4rXqKMiFmIPiMonIpaJ+YnJqvx1PoEHBFiSDhrLJSJjqv0gZjDs0RxQVZSRxvTRpTJ+JCWcXuC/9xUcOcjC53TkZciPbpziUHGIl10sUMTJAed2mXY/Yf3F6gLp2Bmt5n319USSGwZwRnKDvo5Gj3YzqrYP9NBlg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199018)(36756003)(2906002)(478600001)(6486002)(966005)(83380400001)(26005)(186003)(6512007)(71200400001)(2616005)(66946007)(4326008)(66446008)(86362001)(66556008)(6506007)(8676002)(6916009)(76116006)(91956017)(66476007)(64756008)(5660300002)(8936002)(7116003)(41300700001)(38100700002)(316002)(38070700005)(54906003)(122000001)(82960400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTRhNWZ1QURoSEdUb2k3VTRFVkRzMnZkRzRGZlNtd0JiV1lVUWpZUE52RTls?=
 =?utf-8?B?RUFEQ0FCek42bVBlR0N1SElKelkrV0hPNmtLQnc1ejRsV093QkgzY09aeXpX?=
 =?utf-8?B?SURIdFg5TFA3czJKaE16a1ROc3RHTjZwcjlDeTFzWm5QMTNaOUkzUXdBVTUy?=
 =?utf-8?B?cjE5WDVZbGRzQ1V6R2ZDb2tyVU8vS3V3ejRZOTlHTVFHUFJJRko3ZUNmSzR0?=
 =?utf-8?B?MkJVOU8wb0V1cENZS3JweXBzTGZic1dkSkpJamxKK0RpM3k4Mm9QbmhNNXZ4?=
 =?utf-8?B?RmhYd1l0clZ0ZDZZQjJYazFBS3JaZEtSenBTR2FHVzNoMVZ5TDlGMmR5WDh6?=
 =?utf-8?B?VldlK1RLdkxTOVJOWnN6N2lRYnVYZjU3QW8wYyt2VE9CQXI4RFMrcHEvMzEy?=
 =?utf-8?B?R2k1UkF2enpRM2FlY3g5N0JwaHdPM1VuWWRHeENvZ3B2djlNRklzT290WlRS?=
 =?utf-8?B?NCtOZWV5bUpUSkVCYWZBcng5UFBLYmRSOTBzZlRiTUVPWllTRHVOdGFRbnZT?=
 =?utf-8?B?V3M4VzllZmo2VHVpK0UwS0wzcmlJaGdpcUp0NUdidFlqYURaRHN3TzhkT09L?=
 =?utf-8?B?MFE5MkdkaDhibU5vSnN2aU1KczQ0d3NlSHNlT2hqL2ZXdGpZa1I1ZFdsZVJB?=
 =?utf-8?B?Z3NpSmFHY0NhNmtOVk5NODdzOUpubkEzTkZrVy9qU2c1NkN5d1ozL2diTmJV?=
 =?utf-8?B?TDBKNm1SNVNGR1p1VkpvVmd2ZGVWTXhZaGNFdjBndHQ3OXhxVmF4cWV5Yllj?=
 =?utf-8?B?WGRWM08wUGlrd21oN1JmWWdncWlaNHBZdW9CLzhQMk5YWEJDcDNXNHBxVnh0?=
 =?utf-8?B?Sy9EbkRsSUVrbnExeUpXdHRyMU1XaForRnV0V2o0SzRnR2tLcVNpRThFSzds?=
 =?utf-8?B?ZVB6T0ZZaTkwdmE2OTZpTDJBZzA4TFRJN3MwNys3N0tYQVBvYlNKWnJxTXFl?=
 =?utf-8?B?UldJKzg1dzFJakxWaVVvWEc3b3d1TmJFektCWmwvcmkwMW9WYjNjOElvS2Rs?=
 =?utf-8?B?czNiWG9qbW5TZVMzYWN0eGpQbGFvTVgwa0pQVHdtdHdLeEZucHRteXpsUjFq?=
 =?utf-8?B?YTBOd1FMNEhlUk5oVmtRUE5kRjBqVFpZTHA4NGFJQ2d0SHQ1Z1ZGb3N5cXBD?=
 =?utf-8?B?MWQ5YVdFVzJsT21qNW5pRG5VbmR3ZEkxTHloRWIxN3IxcHZzQ2VMTzNRQVFp?=
 =?utf-8?B?K1ZtTTFTVEEzNnl3NDFPTkVjL1A4c2IyV3ZkUlFaWFZGQmZYb1cxbHVwaDN5?=
 =?utf-8?B?eHJMaHdPeTlzdEhjSVB4K2t2QVM1Y1ZSSWFYVTFhalFGaGZ1c0ZwRzlQaEY0?=
 =?utf-8?B?UjNIQlB4Z2phUGd4QkM0UWJWMjJGMFB0TUtsT2hyZDEyY1E1d3g5TXVNS29i?=
 =?utf-8?B?VE9FejBjM0NGTGNWOVJKclFaYlB0a0RPY0Rvc0tTMHMwTFd6TUdoalBIeTdS?=
 =?utf-8?B?SHhFQ0JsaFJXSTI1MFo4NDVKanJJcFJjM0t4azM3enoyYURKQzV2YTluQ294?=
 =?utf-8?B?YlRkeTZObHBjK21hQlNaWWRROUNwQjlFWTlhTm1SRmY4Rnc1UFpTNEhPdklC?=
 =?utf-8?B?SGg1V01UU0ZpSkxQeTB4c2ZiMm9NY1lvMFJpMnVJb2dBc0E1VFo2NWNDK1dE?=
 =?utf-8?B?bDhYL2w4TnhOc2hNUnlMZm5RcXl5a092NG5lZzhmYnk3eHFubE5rbDdrS3BK?=
 =?utf-8?B?elQwdHhzNlVYbWM2Nnk5VjdYL3FUY1draWFBZFRsem5IUEdHdEMrYmdBdE03?=
 =?utf-8?B?ZFFFdzhoMjZkcUpvL0orem8vTkNoOHJadHR2RERiaERYNkk2WGhnVTE2VHdU?=
 =?utf-8?B?WlZGVzNrN053M0FJYjZEVkZrQjRYMEV5ZGNOSUc1akR3cVVjdE41UlRsam1s?=
 =?utf-8?B?bk1HV256M0FWcjRoR0VhcVFsdjNlYTA0S29vK2RVR09jeFpSNkk1UW1jQUx1?=
 =?utf-8?B?WDlZRU02dG9ubGpoYnpmeUZJc0RnQmdZL053QVhrZFBJNmtrS2RtbFdmTXJ3?=
 =?utf-8?B?RENEWDlqa1dCZ0x2d3NwSzhWcnBEeU16VkNOSkVOdHNOcSs0TXdCMWFpUTc0?=
 =?utf-8?B?SGFtRHR2alAxWkZJSWVsQWtDZGRnRC95U05XTWc5SENVY2tsSlB1RFZob1ZS?=
 =?utf-8?B?UVp1Ri9BTWJTaTNYS0VPRDcyQllWcmduQlE0N1F0bWFLTWlONFNPYThZSE5F?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEBF3FE59FED914AA3272BBE287201B3@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a56fd1-0ed7-462c-915b-08db05bdbf86
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 08:07:52.2969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tH+TXEhwxuTLgkFmUFXoS6f/z7EnfCSDiF/3sk5YPboDxbhCakTJ5vzG3aH6DtZLoTj8TbCb4V//pxDWLLm1QpKLteabAyfpOpQdDlaIZvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR10MB6131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gYWdhaW4sDQoNCk9uIFRodSwgMjAyMy0wMi0wMiBhdCAxOToxMCArMDEwMCwgQW5kcmV3
IEx1bm4gd3JvdGU6DQo+ID4gPiA+ID4gY2hpcC0+cmVzZXQgPSBkZXZtX2dwaW9kX2dldF9vcHRp
b25hbChkZXYsICJyZXNldCIsDQo+ID4gPiA+ID4gR1BJT0RfT1VUX0xPVyk7DQo+ID4gPiA+ID4g
aWYgKElTX0VSUihjaGlwLT5yZXNldCkpDQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGdvdG8g
b3V0Ow0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGlmIChjaGlwLT5yZXNldCkNCj4gPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgdXNsZWVwX3JhbmdlKDEwMDAsIDIwMDApOw0KPiA+ID4gPiANCj4gPiA+
ID4gU28gaXQgc2hvdWxkIHdhaXQsIGJ1dCBmb3Igd2hhdD8NCj4gPiA+IA0KPiA+ID4gVGhlIGN1
cnJlbnQgY29kZSBpcyBkZXNpZ25lZCB0byB0YWtlIGEgc3dpdGNoIGhlbGQgaW4gcmVzZXQgb3V0
IG9mDQo+ID4gPiByZXNldC4gSXQgZG9lcyBub3QgcGVyZm9ybSBhbiBhY3R1YWwgcmVzZXQuDQo+
ID4gPiANCj4gPiBIb3cgZG9lcyBpdCB0aGVuIHdvcms/IEkgc2VlIGp1c3QgYSAiZGV2bV9ncGlv
ZF9nZXRfb3B0aW9uYWwiIHdoaWNoDQo+ID4ganVzdCBhc3NpZ24gYW4gcG9pbnRlciB0byAiY2hp
cC0+cmVzZXQiIGFuZCB0aGVuDQo+ID4gIiBpZiAoY2hpcC0+cmVzZXQpIHVzbGVlcF9yYW5nZSgx
MDAwLCAyMDAwKTsiIHdoaWNoIGp1c3Qgd2FpdHMgZm9yDQo+ID4gInNvbWV0aGluZyIgPyBXaGVy
ZSBpcyB0aGUgInJlc2V0IiB0b29rIG91dD8gSSBkb24ndCBzZWUgYW55IGdwaW8gc2V0DQo+ID4g
dG8gMC4NCj4gDQo+IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3Vy
Y2UvaW5jbHVkZS9saW51eC9ncGlvL2NvbnN1bWVyLmgjTDQ5DQo+IA0KPiDCoMKgwqDCoMKgwqDC
oMKgR1BJT0RfT1VUX0xPV8KgwqDCoD0gR1BJT0RfRkxBR1NfQklUX0RJUl9TRVQgfCBHUElPRF9G
TEFHU19CSVRfRElSX09VVCwNCj4gDQo+IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4
L2xhdGVzdC9zb3VyY2UvZHJpdmVycy9ncGlvL2dwaW9saWIuYyNMNDA1MQ0KPiANCj4gwqDCoMKg
wqDCoMKgwqDCoC8qIFByb2Nlc3MgZmxhZ3MgKi8NCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChkZmxh
Z3MgJiBHUElPRF9GTEFHU19CSVRfRElSX09VVCkNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXQgPSBncGlvZF9kaXJlY3Rpb25fb3V0cHV0KGRlc2MsDQo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAhIShk
ZmxhZ3MgJiBHUElPRF9GTEFHU19CSVRfRElSX1ZBTCkpOw0KPiDCoMKgwqDCoMKgwqDCoMKgZWxz
ZQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IGdwaW9kX2RpcmVjdGlv
bl9pbnB1dChkZXNjKTsNCj4gDQpPaywgbm90IGl0IG1ha2VzIG11Y2ggbW9yZSBzZW5zZS4gU28g
aXQncyBhdXRvbWF0aWNhbGx5IHNldCBvdXRwdXQgdG8gT0ZGLiBJbiBteSBjYXNlIHRvIEhJR0gu
DQo+ID4gPiBJZiB5b3UgbmVlZCBhIHJlYWwgcmVzZXQsIHlvdSBwcm9iYWJseSBuZWVkIHRvIGNh
bGwNCj4gPiA+IG12ODhlNnh4eF9oYXJkd2FyZV9yZXNldChjaGlwKSwgbm90IHVzbGVlcCgpLg0K
PiA+ID4gDQo+ID4gPiBIb3dldmVyLCBhIHJlc2V0IGNhbiBiZSBhIHNsb3cgb3BlcmF0aW9uLCBz
cGVjaWFsbHkgaWYgdGhlIEVFUFJPTSBpcw0KPiA+ID4gZnVsbCBvZiBzdHVmZi4gU28gd2Ugd2Fu
dCB0byBhdm9pZCB0d28gcmVzZXRzIGlmIHBvc3NpYmxlLg0KPiA+ID4gDQo+ID4gPiBUaGUgTURJ
TyBidXMgaXRzZWxmIGhhcyBEVCBkZXNjcmlwdGlvbnMgZm9yIGEgR1BJTyByZXNldC4gU2VlDQo+
ID4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21kaW8ueWFtbA0KPiA+
IFRoaXMgbG9va3MgcHJvbWlzaW5nLiBTbyBJIGhhdmUgdG8ganVzdCBtb3ZlIHRoZSAicmVzZXQt
Z3Bpb3MiIERUQg0KPiA+IGVudHJ5IGZyb20gc3dpdGNoIHRvIG1kaW8gc2VjdGlvbi4gQnV0IHdo
aWNoIGRyaXZlciBoYW5kbGVzIGl0LA0KPiA+IGRyaXZlcnMvbmV0L3BoeS9tZGlvX2J1cy5jLA0K
PiANCj4gWWVzLg0KPiANCj4gPiA+IG1kaW8gew0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCNhZGRy
ZXNzLWNlbGxzID0gPDE+Ow0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCNzaXplLWNlbGxzID0gMD47
DQo+ID4gd2hpbGUgaGVyZSBpcyBubyBjb21wYXRpYmxlIHBhcnQuLi4gLg0KPiANCj4gSXQgZG9l
cyBub3QgbmVlZCBhIGNvbXBhdGlibGUsIGJlY2F1c2UgaXQgaXMgcGFydCBvZiB0aGUgRkVDLCBh
bmQgdGhlDQo+IEZFQyBoYXMgYSBjb21wYXRpYmxlLiBSZW1lbWJlciB0aGlzIGlzIGRldmljZSB0
cmVlLCBzb21ldGltZXMgeW91IG5lZWQNCj4gdG8gZ28gdXAgdGhlIHRyZWUgdG93YXJkcyB0aGUg
cm9vdCB0byBmaW5kIHRoZSBhY3R1YWwgZGV2aWNlIHdpdGggYQ0KPiBjb21wYXRpYmxlLg0KPiAN
Cj4gwqDCoMKgIEFuZHJldw0KSSB0cmllZCBwdXQgdGhlICJyZXNldC1ncGlvcyIgYW5kICJyZXNl
dC1kZWxheS11cyIgaW50byBtdWx0aXBsZSBtZGlvIGxvY2F0aW9ucywgYnV0IG5vdGhpbmcgaGFz
IGJlZW4gd29ya2luZy4gRFRCIGxvb2tzIGxpa2UgdGhhdDoNCg0KPiAmZmVjMSB7DQo+IAlwaW5j
dHJsLW5hbWVzID0gImRlZmF1bHQiOw0KPiAJcGluY3RybC0wID0gPCZwaW5jdHJsX2ZlYzE+Ow0K
PiAJcGh5LW1vZGUgPSAicmdtaWktaWQiOw0KPiAJdHgtaW50ZXJuYWwtZGVsYXktcHMgPSA8MjAw
MD47DQo+IAlyeC1pbnRlcm5hbC1kZWxheS1wcyA9IDwyMDAwPjsNCj4gCXNsYXZlcyA9IDwxPjsJ
CQkvLyB1c2Ugb25seSBvbmUgZW1hYyBpZg0KPiAJc3RhdHVzID0gIm9rYXkiOw0KPiAJbWFjLWFk
ZHJlc3MgPSBbIDAwIDAwIDAwIDAwIDAwIDAwIF07IC8vIEZpbGxlZCBpbiBieSBVLUJvb3QNCj4N
Cj4gCS8vICMjIyMgMy4gdHJ5ICMjIyMNCj4gCS8vcGh5LXJlc2V0LWdwaW9zID0gPCZsc2lvX2dw
aW8wIDEzIEdQSU9fQUNUSVZFX0xPVz47DQo+IAkvL3Jlc2V0LWRlbGF5LXVzID0gPDEwMDAwPjsN
Cj4NCj4gCWZpeGVkLWxpbmsgew0KPiAJCXNwZWVkID0gPDEwMDA+Ow0KPiAJCWZ1bGwtZHVwbGV4
Ow0KPiAJfTsNCj4NCj4gCW1kaW8gew0KPiAJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiAJCSNz
aXplLWNlbGxzID0gPDA+Ow0KPg0KPiAJCS8vIDEuIHRyeQ0KPiAJCXJlc2V0LWdwaW9zID0gPCZs
c2lvX2dwaW8wIDEzIEdQSU9fQUNUSVZFX0xPVz47DQo+IAkJcmVzZXQtZGVsYXktdXMgPSA8MTAw
MDA+Ow0KPg0KPiAJCS8vIE1WODhFNjMyMSBTd2l0Y2gNCj4gCQlzd2l0Y2g6IHN3aXRjaEAxMCB7
DQo+IAkJCWNvbXBhdGlibGUgPSAibWFydmVsbCxtdjg4ZTYzMjEiLCJtYXJ2ZWxsLG12ODhlNjA4
NSI7DQo+DQo+IAkJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiAJCQkjc2l6ZS1jZWxscyA9IDww
PjsNCj4gCQkJZHNhLG1lbWJlciA9IDwwIDA+Ow0KPg0KPiAJCQlyZWcgPSA8MHgxMD47DQo+IAkJ
CWludGVycnVwdC1jb250cm9sbGVyOw0KPiAJCQkjaW50ZXJydXB0LWNlbGxzID0gPDI+Ow0KPg0K
PiAJCQkvLyB0aGlzIGlzIHRoZSBsb2NhdGlvbiwgd2hlcmUgZHJpdmVyIGlzIGhhbmRsaW5nIHRo
ZSByZXNldA0KPiAJCQkvL3Jlc2V0LWdwaW9zID0gPCZsc2lvX2dwaW8wIDEzIEdQSU9fQUNUSVZF
X0xPVz47DQo+DQo+IAkJCXBvcnRzIHsNCj4gCQkJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiAJ
CQkJI3NpemUtY2VsbHMgPSA8MD47DQo+DQo+IAkJCQlwb3J0MDogcG9ydHNAMCB7DQo+IAkJCQkJ
cmVnID0gPDA+Ow0KPiAJCQkJCWxhYmVsID0gIndhbjAiOw0KPiAJCQkJCXBoeS1oYW5kbGUgPSA8
JnN3aXRjaDFwaHkwPjsNCj4gCQkJCS8vIG90aGVyIHBvcnRzIHBhcnQuLi4NCj4gCQkJfTsNCj4N
Cj4gCQkJbWRpbyB7DQo+IAkJCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gCQkJCSNzaXplLWNl
bGxzID0gPDA+Ow0KPg0KPiAJCQkJLy8gIyMjIyAyLiB0cnkgIyMjIw0KPiAJCQkJLy9yZXNldC1n
cGlvcyA9IDwmbHNpb19ncGlvMCAxMyBHUElPX0FDVElWRV9MT1c+Ow0KPiAJCQkJLy9yZXNldC1k
ZWxheS11cyA9IDwxMDAwMD47DQo+DQo+DQo+IAkJCQlzd2l0Y2gxcGh5MDogc3dpdGNoMXBoeTBA
MCB7DQo+IAkJCQkJcmVnID0gPDA+Ow0KPiAJCQkJCXNlbGVjdC1jbGFzcy1hOw0KPiAJCQkJfTsN
Cj4gCQkJCS8vIC4uLg0KPiAJCQl9Ow0KPiAJCX07DQo+IAl9Ow0KPn07DQoNCkFuZCBpZiBJIGxv
b2sgYXQgdGhlIGRlY29tcGlsZWQgRFRCLCB0aGVyZSBpcyBubyBwaHlzaWNhbCBhZGRyZXNzIGZv
ciBNRElPIGJ1cy4NCj4gbWRpbyB7DQo+IAkJI2FkZHJlc3MtY2VsbHMgPSA8MHgwMT47DQo+IAkJ
I3NpemUtY2VsbHMgPSA8MHgwMD47DQo+IAkJcmVzZXQtZ3Bpb3MgPSA8MHg4YyAweDBkIDB4MDE+
Ow0KPiAJCXJlc2V0LWRlbGF5LXVzID0gPDB4MjcxMD47DQo+DQo+CQlzd2l0Y2hAMTAgew0KPiAJ
CQljb21wYXRpYmxlID0gIm1hcnZlbGwsbXY4OGU2MzIxXDBtYXJ2ZWxsLG12ODhlNjA4NSI7DQo+
IAkJCSNhZGRyZXNzLWNlbGxzID0gPDB4MDE+Ow0KPiAJCQkjc2l6ZS1jZWxscyA9IDwweDAwPjsN
Cj4gCQkJZHNhLG1lbWJlciA9IDwweDAwIDB4MDA+Ow0KDQpTbyBob3cgdG8gdmVyaWZ5IGl0Pw0K
DQpUaGFuayB5b3UsDQpBbmRyZWoNCg==
