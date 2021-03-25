Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512BC348B46
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCYINc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:13:32 -0400
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:43361
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229461AbhCYIND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:13:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKNJz/Be9eP/6l/Q6SAhU611LfkQ8Lpsf1hPIUpMm34ZEWrzgMYOJtmokXX2Z23gjYQvUmQWEzedDJJDeg53uHV0a8bgKFF+GQ3NnyyStbjoFqxbMqS4tlxhflWrimgwPELXHnmgGmTgC3WfQUMzNQyC6B0vIHmXitn1wikAdWnoK1dSNank3Ut60jBtObdePoqP/Q26nw03D3xgTGDiTTPVZ2kiSrEyn4CnXNfSj5E1qJrga09MNSo5bDdGg557bCKoo1PV/PAvyIo4Vdod8uGJA5d+poUTztrwBS5nfY2QDW6do6zDeoPuNWEEGx6enMtrCm34h0BEqRZIK2lVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKvoT9m3MNGMEZdlPjYjXXz1a1p6sty4PKjNmYSMKe4=;
 b=RLAoKC4RIYtk8EMBXqJ4O/yzYocKebBU9sY0dwW+aC1KNa+iL8A5uPIqYzfNnCioIesRUmosKcgSujZ5k8mq1HRtsTdbcGZGBKYNhjCFJTk/TAFuDDOEcT7TAfvHiYHf3rKSrMhJmpLaVVyB9yxYxGjmk559uOcPMdRttLv9GxjU60mtDJX6sqML1SC1iAuLZSLZPT2YxvuLj9dccdCaxIr39DQSmEX96v7geXl3wDHbR6H8cmudWajLigaLUIKnBFuTr3W3P5FqCI+ZqupxTnCk5EDg7b+ZxHtvZAFJqCTYJUJ9/UNXsj3I4g+vA88JkIw0K7elJ2PhB3T7fBylxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKvoT9m3MNGMEZdlPjYjXXz1a1p6sty4PKjNmYSMKe4=;
 b=kQOOC50mhlNcGiE9f6/w8icrJWc4XbA+PCygGdoyJSNOrlfyXzWGK+71Uex+SUmCIE961iiQRMI6h84uAIRr8vWJjK0L05L6nRiuq1ht4cED4xcS9LNrCXAFmQukvq1DkLdurQuReilvCboIgyAjgkODszKAdFCPsf2Bl1/8S9o=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7770.eurprd04.prod.outlook.com (2603:10a6:10:1ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 25 Mar
 2021 08:12:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 08:12:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9OwgAAITACAAT8a8IAABYcAgAABmVA=
Date:   Thu, 25 Mar 2021 08:12:58 +0000
Message-ID: <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
In-Reply-To: <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4cba5f7-3bad-4978-9f57-08d8ef65cd76
x-ms-traffictypediagnostic: DBBPR04MB7770:
x-microsoft-antispam-prvs: <DBBPR04MB777056C57EC74EF8E29E2894E6629@DBBPR04MB7770.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uc3PZKmRTdR98TifDdV2lAgHnGhSIXAyru95QrRxVY+/SrDn2tgfFF24UojUnc+qtjZgTMrIdDr+dtfH0qczmW7qq6KVvfroCPX2wNgLMqYV49DtViaxRiAgg4g1jj85SmYWMjPbZdoVQG+b3QV47cznifvOtp+OyPALfuRiWvgifhzg8ePcwPZkjGlk2jO/LnfNoO/1kqRdbwx2UQR1Y/vVsAjYvBwjnM4l5Fl1vBptLTmTgTF08oKsky/sOrnKAg858O/UWFyxpJLsZ02eB95l4rGLA9bJBJq59b5gT66H8YriiRk4Ds85Vwla7c0k5mOdIOQq9sWrhhQbyKddoiuLcdYRLX+Jr0JACL5dCGFeamr1Zyf4qH3IwIGHZmpoQhR8xCM5yue7OcVLmhWD0VMNoXSjz+7jGp7SMoR9qXc6KA2kYbLqQlaMrytTcUQ1mIOscwAUruMoj4BHDFHCE3GwHWZTjbbMT92EiNZt8t6XgzQMPpC1hbR7V2orMlxxkd4tF3snBZVb+lT6dmE/NqcHYG8qeLK46Ipzg/nV4yLodWAnwsK5pdGyse2wKd2d/JFx/khBexMX1JJjLaGq0pa5X0XPjxBdWw2kqPUSKkhpEvOUmSmYheUBhFN8dB+9Ksbfk8VsanjwR7Ixup0C7Pr21TOP0TDmPLFGc0uUsNc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(83380400001)(86362001)(66476007)(5660300002)(52536014)(76116006)(33656002)(66556008)(64756008)(66446008)(66946007)(54906003)(2906002)(8936002)(316002)(71200400001)(186003)(9686003)(6916009)(38100700001)(26005)(55016002)(8676002)(6506007)(53546011)(4326008)(478600001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b0ZLV2MvaTdpQU80andzazFPcFRMc3RjZDViQ2hvNUNvM3VLc0VaaWludmU1?=
 =?utf-8?B?eExTWk9WWHF6cUpaYWM4Um9nVHFySzU2ZzgxZTNHSG9iM0gzVmllNURRbEM4?=
 =?utf-8?B?Sm45dFpROWFZZHEyZTcrTUJDVEpBcC9tWmpSeUdCQXFLVEtQUmh3N0J6TThW?=
 =?utf-8?B?d1E4TTJOdG4ydkFzMnE3eEJzOWgxcFRYbG9GTDJzMWtPVVU4QWxhSkpmNE52?=
 =?utf-8?B?SElGM1hPWFR1UmcrK1NPUTVTdDhqUHcreVBoVEZUUDdoM3RQNE14S2RhN3k1?=
 =?utf-8?B?U3E3Y0FuKzBLOE4zRXJnM2x2Sm1odUpGRngrNENIUTBML1I1am4wWUZCVFNG?=
 =?utf-8?B?eHRkZTBiMHdCK01RZThtSHdGWWE3ejJsVnkvV1VSR1FLdmliaDlwZW5wd0do?=
 =?utf-8?B?dE9tWUdlQ2ZkL2RucHlJenczekNrM1VXZmk3L0p2YUFwK3JrUm5yYldyTVQx?=
 =?utf-8?B?anBFNjFCdkI3YXR4UlN3V2tuc0tKR3N4RXQxa1Rob0dFWDBITHVGNEdpZFZh?=
 =?utf-8?B?cmFwQVVUV1BENERKci8ya1JTYjMyck8waXVMMVdoSlVnQUxUOUxzZ2RWQUlM?=
 =?utf-8?B?S2R2RHVyK1hJZjAwcWYvZkovS2JiUU0yQ291Z3BKSlE0aUJVcmFKa3hVSHBY?=
 =?utf-8?B?K1R1RGd2NzBGWWlGay9ldTBObkNOSkFUbHZockd5UGFpZW44cFJnRzRpUThv?=
 =?utf-8?B?aHpBKytER09XbTcyYVVybEVVeE1rKzJRM29WejRYMzRxZTNIOGRCNlpncU4v?=
 =?utf-8?B?WXRTSHRibWwxemozUjJZemt0TnVVVFJIcllNNjRyRTFPMUFSclhOSDFLcElE?=
 =?utf-8?B?UnFrMk5heHd4NHVKNTNtTHdkemJISCtObGZ3czB2Y2pkV09GYTFEcmZSZkZU?=
 =?utf-8?B?TTlHbEVnSUQrZmNnR1cwamZjWk56QjRsWnN3Q2JNekwyOGdZMUhHbEdodW50?=
 =?utf-8?B?NGVqTDJHUmJneUtmODBlemN4TjhBbUMwY1k1cDlMVExSZXYvMmxFbHRrcXFX?=
 =?utf-8?B?Nmk5WlVMZ1I2UnVkdG02M0ZPcEk1NGc1NTBKNkF2eWZ3UEVCMG9xaXFxS29a?=
 =?utf-8?B?OHBMbHNoc0RmWWNPK2p4Q01KRE9MeU43MVNwWFBhSzBWeVFxYStaSmNhUldN?=
 =?utf-8?B?Y3ZGL3VsWlFuWWx4Ykp3Z1B2MTZuQU9lMEF4eDE5SW1IcFliaENLbS9xeWVn?=
 =?utf-8?B?MkZvSWtaTmdZNmgrMXdGNXJJM3VPZnBkdjZQbnhyZEF0NkpheHNPeTcvbDZz?=
 =?utf-8?B?cnBsWmIya0xOM2tLNktXc2pHYmlKbkxDU0hRUzNqOWdNVHNBcGk5cG1uTGZD?=
 =?utf-8?B?MWlhaHBTS0s4SXZ4dFZ6Szc0NzQrUWNZOGZLUTdOd1kwYml2dUlITGFyNHBT?=
 =?utf-8?B?V3Uwc3lseGRXcjdBV2pnaW5CTk5qNVZaMmRNcXVGajdkU1Q0blJSb1hpVytm?=
 =?utf-8?B?NksyRGI1ZFp0bDZzN2l2VWh1RytpdmMrZ1hNRjd2bHZyV0k2emxWdWowNGsv?=
 =?utf-8?B?L245aDJIUW14QjhNQWVodDU2YUJRSU41TzR2dzJhVFpXSS9wYkt5ZW9ZZzI1?=
 =?utf-8?B?RG5yUzZ6MEhWMzFqd0FScU9mTVpOeU5XUEx1ZW1XT0xYNjFpWlZiUjd2VUhH?=
 =?utf-8?B?bktNcUFJOFZGckh0SHBocDN1N1o5UFJoa2MrU2hJY1ZhWDZTTCtKc2JlRFJG?=
 =?utf-8?B?RWhQVmtBQmZYSnlESG5SUVZjYzZuWG4rU0cyWHNXUzhMc0orRnJkc2FRWHI5?=
 =?utf-8?Q?wegK5EkbXsJnZ9SihmOr0MvMn5hzU3jjlbQOeZw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cba5f7-3bad-4978-9f57-08d8ef65cd76
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 08:12:58.9997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKmXJOW8RGmrRnvALBL7p6m1d9DeEcNx4XyhB08IbRCi/PsWfMv5i2+y66avrJw5FdyUXN1H1U8se6FPaDPT6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0M+aciDI15pelIDE2OjAxDQo+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IGxpbnV4LXRlZ3JhIDxsaW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+
Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogUmVn
cmVzc2lvbiB2NS4xMi1yYzM6IG5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBt
YWMNCj4gcmVzdW1lIGJhY2sNCj4gDQo+IA0KPiBPbiAyNS8wMy8yMDIxIDA3OjUzLCBKb2FraW0g
Wmhhbmcgd3JvdGU6DQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4g
RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQo+ID4+IFNlbnQ6IDIwMjHl
ubQz5pyIMjTml6UgMjA6MzkNCj4gPj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5n
QG54cC5jb20+DQo+ID4+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBMaW51eCBLZXJuZWwg
TWFpbGluZyBMaXN0DQo+ID4+IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgbGludXgt
dGVncmENCj4gPj4gPGxpbnV4LXRlZ3JhQHZnZXIua2VybmVsLm9yZz47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4+IFN1YmplY3Q6IFJlOiBSZWdyZXNzaW9uIHY1LjEyLXJj
MzogbmV0OiBzdG1tYWM6IHJlLWluaXQgcnggYnVmZmVycw0KPiA+PiB3aGVuIG1hYyByZXN1bWUg
YmFjaw0KPiA+Pg0KPiA+Pg0KPiA+Pg0KPiA+PiBPbiAyNC8wMy8yMDIxIDEyOjIwLCBKb2FraW0g
Wmhhbmcgd3JvdGU6DQo+ID4+DQo+ID4+IC4uLg0KPiA+Pg0KPiA+Pj4gU29ycnkgZm9yIHRoaXMg
YnJlYWthZ2UgYXQgeW91ciBzaWRlLg0KPiA+Pj4NCj4gPj4+IFlvdSBtZWFuIG9uZSBvZiB5b3Vy
IGJvYXJkcz8gRG9lcyBvdGhlciBib2FyZHMgd2l0aCBTVE1NQUMgY2FuIHdvcmsNCj4gPj4gZmlu
ZT8NCj4gPj4NCj4gPj4gV2UgaGF2ZSB0d28gZGV2aWNlcyB3aXRoIHRoZSBTVE1NQUMgYW5kIG9u
ZSB3b3JrcyBPSyBhbmQgdGhlIG90aGVyDQo+IGZhaWxzLg0KPiA+PiBUaGV5IGFyZSBkaWZmZXJl
bnQgZ2VuZXJhdGlvbiBvZiBkZXZpY2UgYW5kIHNvIHRoZXJlIGNvdWxkIGJlIHNvbWUNCj4gPj4g
YXJjaGl0ZWN0dXJhbCBkaWZmZXJlbmNlcyB3aGljaCBpcyBjYXVzaW5nIHRoaXMgdG8gb25seSBi
ZSBzZWVuIG9uIG9uZSBkZXZpY2UuDQo+ID4gSXQncyByZWFsbHkgc3RyYW5nZSwgYnV0IEkgYWxz
byBkb24ndCBrbm93IHdoYXQgYXJjaGl0ZWN0dXJhbCBkaWZmZXJlbmNlcyBjb3VsZA0KPiBhZmZl
Y3QgdGhpcy4gU29ycnkuDQo+IA0KPiANCj4gTWF5YmUgY2FjaGluZyBzb21ld2hlcmU/IEluIG90
aGVyIHdvcmRzLCBjb3VsZCB0aGVyZSBiZSBhbnkgY2FjaGUgZmx1c2hpbmcNCj4gdGhhdCB3ZSBh
cmUgbWlzc2luZyBoZXJlPw0KSGF2ZSBubyBpZGVhLCBoYXZlIG5vdCBhY2NvdW50IGludG8gc3Vj
aCBjYXNlLg0KDQo+ID4+PiBXZSBkbyBkYWlseSB0ZXN0IHdpdGggTkZTIHRvIG1vdW50IHJvb3Rm
cywgb24gaXNzdWUgZm91bmQuIEFuZCBJIGFkZA0KPiA+Pj4gdGhpcw0KPiA+PiBwYXRjaCBhdCB0
aGUgcmVzdW1lIHBhdGNoLCBhbmQgb24gZXJyb3IgY2hlY2ssIHRoaXMgc2hvdWxkIG5vdCBicmVh
aw0KPiBzdXNwZW5kLg0KPiA+Pj4gSSBldmVuIGRpZCB0aGUgb3Zlcm5pZ2h0IHN0cmVzcyB0ZXN0
LCB0aGVyZSBpcyBubyBpc3N1ZSBmb3VuZC4NCj4gPj4+DQo+ID4+PiBDb3VsZCB5b3UgcGxlYXNl
IGRvIG1vcmUgdGVzdCB0byBzZWUgd2hlcmUgdGhlIGlzc3VlIGhhcHBlbj8NCj4gPj4NCj4gPj4g
VGhlIGlzc3VlIG9jY3VycyAxMDAlIG9mIHRoZSB0aW1lIG9uIHRoZSBmYWlsaW5nIGJvYXJkIGFu
ZCBhbHdheXMgb24NCj4gPj4gdGhlIGZpcnN0IHJlc3VtZSBmcm9tIHN1c3BlbmQuIElzIHRoZXJl
IGFueSBtb3JlIGRlYnVnIEkgY2FuIGVuYWJsZQ0KPiA+PiB0byB0cmFjayBkb3duIHdoYXQgdGhl
IHByb2JsZW0gaXM/DQo+ID4+DQo+ID4NCj4gPiBBcyBjb21taXQgbWVzc2FnZXMgZGVzY3JpYmVk
LCB0aGUgcGF0Y2ggYWltcyB0byByZS1pbml0IHJ4IGJ1ZmZlcnMNCj4gPiBhZGRyZXNzLCBzaW5j
ZSB0aGUgYWRkcmVzcyBpcyBub3QgZml4ZWQsIHNvIEkgb25seSBjYW4gcmVjeWNsZSBhbmQgdGhl
bg0KPiByZS1hbGxvY2F0ZSBhbGwgb2YgdGhlbS4gVGhlIHBhZ2UgcG9vbCBpcyBhbGxvY2F0ZWQg
b25jZSB3aGVuIG9wZW4gdGhlIG5ldA0KPiBkZXZpY2UuDQo+ID4NCj4gPiBDb3VsZCB5b3UgcGxl
YXNlIGRlYnVnIGlmIGl0IGZhaWxzIGF0IHNvbWUgZnVuY3Rpb25zLCBzdWNoIGFzDQo+IHBhZ2Vf
cG9vbF9kZXZfYWxsb2NfcGFnZXMoKSA/DQo+IA0KPiANCj4gWWVzIHRoYXQgd2FzIHRoZSBmaXJz
dCB0aGluZyBJIHRyaWVkLCBidXQgbm8gb2J2aW91cyBmYWlsdXJlcyBmcm9tIGFsbG9jYXRpbmcg
dGhlDQo+IHBvb2xzLg0KPiANCj4gQXJlIHlvdSBjZXJ0YWluIHRoYXQgdGhlIHByb2JsZW0geW91
IGFyZSBzZWVpbmcsIHRoYXQgaXMgYmVpbmcgZml4ZWQgYnkgdGhpcw0KPiBjaGFuZ2UsIGlzIGdl
bmVyaWMgdG8gYWxsIGRldmljZXM/IFRoZSBjb21taXQgbWVzc2FnZSBzdGF0ZXMgdGhhdCAnZGVz
Y3JpcHRvcg0KPiB3cml0ZSBiYWNrIGJ5IERNQSBjb3VsZCBleGhpYml0IHVudXN1YWwgYmVoYXZp
b3InLCBpcyB0aGlzIGEga25vd24gaXNzdWUgaW4gdGhlDQo+IFNUTU1BQyBjb250cm9sbGVyPyBJ
ZiBzbyBkb2VzIHRoaXMgaW1wYWN0IGFsbCB2ZXJzaW9ucyBhbmQgd2hhdCBpcyB0aGUgYWN0dWFs
DQo+IHByb2JsZW0/DQoNClllcywgSSBjb25maXJtIHRoaXMgcGF0Y2ggZml4IGlzc3VlIGF0IG15
IHNpZGUuIEl0IHNob3VsZCBub3QgYmUgYSBnZW5lcmljLCBpdCBjYW4gcmVwcm9kdWNlIGF0IG9u
ZSBvZiBvdXIgYm9hcmRzLg0KVG8gYmUgaG9uZXN0LCBJIGhhdmUgbm90IGZvdW5kIHRoZSByb290
IGNhdXNlLCB0aGlzIHNob3VsZCBiZSBhIHdvcmthcm91bmQsIEkgdXBzdHJlYW0gaXQgc2luY2Ug
SSB0aGluayBpdCB3aWxsIG5vdCBhZmZlY3Qgb3RoZXJzIHdoaWNoIGRvbid0IHN1ZmZlciBmcm9t
IHRoaXMuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBKb24NCj4gDQo+IC0tDQo+
IG52cHVibGljDQo=
