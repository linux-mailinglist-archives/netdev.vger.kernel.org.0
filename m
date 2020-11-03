Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE12A4DB7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgKCR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:59:34 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26458 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728815AbgKCR72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:59:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HtUB1016923;
        Tue, 3 Nov 2020 09:59:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=xb+g/luwpEg5pG5CfIt0DWlMgc8vi5WXmPrBLsWdjv0=;
 b=B2d3bR8HHfVJ+wxdl8AMuCZyXp7W0prUJNh4UnjNRLKMek3UemJSPLHUhdJ9IX4hFJh6
 4cGByBuj9OzZQyl+Q0j8K427SL2jrdVGFQu+XDo/d9RJdgXc3Dq+j0Ju5sMbXdquXbAK
 6gViZd7+rmJclbldRSaUEqo3aHPLeq2qBLBZYMpi8pRbg87UJ3Q873bYVjKedeiKqKEO
 khQqZKT+hxpQiwnaexEUFNHTfjCPIYUQ9uCyZYhkdAY/mhhpDHELNinFdXgaCa+GJpjD
 uNhA8n0dM1R+JkP5ykNQsYMwF0wBTrdslWpN3vwBTglh5k46F5zB+jG9GhvRNusIm3tt ug== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mxwe5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 09:59:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Nov
 2020 09:59:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Nov
 2020 09:59:23 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 3 Nov 2020 09:59:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsZO6e7o9ohF+tV+Y+W36CcG2nsD4v8QDsqGM4fi801wM8PJQclU0QW6jd+fOW8U7lRBxGAp5kTmeK8UQarniog6WiZ7gTp0A41HJvU2b3KchOHQGjp7EIwTvJPxaad1UVFMT9eVmH0q4at8WTmtBsAd8tvZMRiR39gC23LeCtrSvTY9fyeTTXROqThfgSMnKHRKjueNkHpRmZJizsP53ZHbsw8/K1r9ImeOsppIqcFBVeVWntPxlnF2uyk/5xMPu/9OIMbCjR/4piMfMB16lKhqphjBpeR4hoYcIRsqOATGhP4MkRLDZkgFIm80kZ9Cjj88vaw7BmYTCLwX3sPuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xb+g/luwpEg5pG5CfIt0DWlMgc8vi5WXmPrBLsWdjv0=;
 b=DklALh0l1YONDxHhPgf9MRmYun+MbO5lqTdFn3S8/H6gCf/xDtZrN8LNWbIOXoSNfNfp2W1Yw6GDKKU3R+WcFPd57yslMXQjsltzFDWpydvpqH3PtWV+kX8BlAXyum1CEbdM2IRxUlJJpvT+glz2m2gt+S2WqRGWuRkpeCMw2G4yTLmSRe4HBcuqquhRQ4l4Vr87fRNfNY/qRtA+/VL6ejrXu/My/SkQpRWG6EwoeTcNO7rzdhZX2ElhR6x4pUAnQU7f8qnHjFycECZNNaQKCX4obIjrky319U7DV0V3BIQ2MdrnYphlmhPQ8XBhD/Au+RD5DeeDj2Y5DeVKQM5heQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xb+g/luwpEg5pG5CfIt0DWlMgc8vi5WXmPrBLsWdjv0=;
 b=bW44Zb1oxJgmV3+ItErgk27trFtF0q4Nui0erf9mOe1ZFKzR/kTFlWUtTpuW5yqSJaiVOjzDIDuB4WfxTIRMuGFpvY4cuj0PBvz6Z8BsyyO2l/FizndpH+4sgUHfc6sgdr3CQtSG/GLIcWtD+axW83HhTOMTxkaxMJH7CDM/gjA=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BYAPR18MB2421.namprd18.prod.outlook.com (2603:10b6:a03:13c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 17:59:20 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:59:19 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David Miller" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Index: AdayCuctgGMTHQz4SyeKXxB4Xaomug==
Date:   Tue, 3 Nov 2020 17:59:19 +0000
Message-ID: <BYAPR18MB267934F9299BE9E390B17A55C5110@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [111.92.87.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1570cdb7-8d4a-4d9c-0559-08d880223043
x-ms-traffictypediagnostic: BYAPR18MB2421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2421999250762C36415791E5C5110@BYAPR18MB2421.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +QkgyJ9fX4JdO7IPHM7M/X0ZQ3v1YqVTwxUWcTkz5LoMwf+dvcLlb1MM/fWTnPGRbIEFdcycf3ckzUKYVjeALQ6KfIcwGaRnbNeP3gCPAmVdbvt0vqBnLKZvLrWMcuxyydfnMO9yDrRmpM2az3LL4yiNZif8aevuk16bk6K9jsdNYn1lbAVJrZRwiehFST2747ltXawPHPtLCGVWlBAydmhEAVZM3Sf5o0SDHltVZu1qZMF9UpyZuRpjuegswIPdVJaz+VLTTx7fYQ19fNe7hdyQlM6mnXyKnEqoKgHXoT1LJ0PRIwVSjEhE8bnhEvnR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39840400004)(376002)(346002)(136003)(7696005)(55016002)(54906003)(86362001)(4326008)(5660300002)(9686003)(316002)(53546011)(6506007)(6916009)(26005)(66446008)(66476007)(52536014)(8936002)(2906002)(478600001)(71200400001)(76116006)(64756008)(66946007)(83380400001)(66556008)(33656002)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JQGK/6hZalkR2ZyHTvKRfrP/pF1yfMSRrmxfGEZ+9NrwqWEzOzKNmT0EL5K/BIputGKVGjErfqV7yyd9SZi9UoVwnGtlrA0gcPxbiVVqgSKU42a3Fg9IU5Mcq1V507AtF0q4V4PaBU/2IEJ8rq3+5zYHjDhFq0Ea8DEKfSFPsWl3nuojkPE4fik/MVasADgRg7d6tMm1du3LoOqDPUSAX7lE99iHOQ8QKwxslXj/Oxh5YFD5Kyw4E+L8Piu1acFh9/ZvKaHxr6/HK4oP2U+qN+NSMXvB9oFw8bHII1e0q70F2qNPFEFI5Uayiaf9F9kf+X1/HMySJRrbuRl9JZQPP716VVb0B4Qd08Jf1gogwVet9L1gkpZajl9Gm0bb5+7wMIA+GBYnyTSfHXMq3tgL8/VxAa/7EzCsUmlHSZH0PCFFyX1JOA0l9BfKPg50WjKveu0TpxcgPJTLdHhlen5yBWBHtLAE+2tCgInxQyYkFjhHRn2XjZyN6h++AIP7EY0j5RYnif4vEu4F3ch6sdlH/v1gPsSuomqaIaSOSBJ4stfXY5RgnBh0w3F/LYbnWhUDd3q6gW1wRiAbN/+AGaz5f/LGuj3H1kY3gftmL9slypRRY5IPR2fBqwh96d+3Cnd0KyYuppHSsVblzF0X3AlNfg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1570cdb7-8d4a-4d9c-0559-08d880223043
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:59:19.7188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HhSgPnXW5TYW7Q4QC3Un5TI6ANeROeOVWk0+JKbzvbxLj3zuwdFbQbh1oSm3wplHoaxHrLTxjW4lRXf1LT+48g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2421
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxl
bSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1
ZXNkYXksIE5vdmVtYmVyIDMsIDIwMjAgMTE6MjYgUE0NCj4gVG86IEdlb3JnZSBDaGVyaWFuIDxn
Y2hlcmlhbkBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWwgPGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IERhdmlkIE1pbGxlcg0K
PiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFN1bmlsIEtvdnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRo
YW1AbWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4g
R2VldGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IG1hc2FoaXJveUBrZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQgUEFUQ0ggMi8zXSBvY3Rlb250eDItYWY6
IEFkZCBkZXZsaW5rIGhlYWx0aA0KPiByZXBvcnRlcnMgZm9yIE5QQQ0KPiANCj4gT24gVHVlLCBO
b3YgMywgMjAyMCBhdCAxMjo0MyBQTSBHZW9yZ2UgQ2hlcmlhbiA8Z2NoZXJpYW5AbWFydmVsbC5j
b20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gSGkgV2lsbGVtLA0KPiA+DQo+ID4NCj4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBXaWxsZW0gZGUgQnJ1aWpuIDx3aWxs
ZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgTm92ZW1i
ZXIgMywgMjAyMCA3OjIxIFBNDQo+ID4gPiBUbzogR2VvcmdlIENoZXJpYW4gPGdjaGVyaWFuQG1h
cnZlbGwuY29tPg0KPiA+ID4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc+OyBsaW51eC1rZXJuZWwNCj4gPiA+IDxsaW51eC0ga2VybmVsQHZnZXIua2VybmVs
Lm9yZz47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+Ow0KPiA+ID4gRGF2aWQgTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgU3VuaWwgS292dnVyaSBHb3V0aGFtDQo+ID4gPiA8
c2dvdXRoYW1AbWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29t
PjsNCj4gPiA+IEdlZXRoYXNvd2phbnlhIEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBtYXNh
aGlyb3lAa2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogW0VYVF0gUmU6IFtuZXQtbmV4dCBQQVRD
SCAyLzNdIG9jdGVvbnR4Mi1hZjogQWRkIGRldmxpbmsNCj4gPiA+IGhlYWx0aCByZXBvcnRlcnMg
Zm9yIE5QQQ0KPiA+ID4NCj4gPiA+IEV4dGVybmFsIEVtYWlsDQo+ID4gPg0KPiA+ID4gLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4gPiA+IC0tDQo+ID4gPiA+ID4gPiAgc3RhdGljIGludCBydnVfZGV2bGlua19pbmZv
X2dldChzdHJ1Y3QgZGV2bGluayAqZGV2bGluaywNCj4gPiA+ID4gPiA+IHN0cnVjdA0KPiA+ID4g
PiA+IGRldmxpbmtfaW5mb19yZXEgKnJlcSwNCj4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IG5ldGxpbmtfZXh0X2Fjaw0KPiA+ID4gPiA+ID4gKmV4dGFj
aykgIHsgQEANCj4gPiA+ID4gPiA+IC01Myw3ICs0ODMsOCBAQCBpbnQgcnZ1X3JlZ2lzdGVyX2Rs
KHN0cnVjdCBydnUgKnJ2dSkNCj4gPiA+ID4gPiA+ICAgICAgICAgcnZ1X2RsLT5kbCA9IGRsOw0K
PiA+ID4gPiA+ID4gICAgICAgICBydnVfZGwtPnJ2dSA9IHJ2dTsNCj4gPiA+ID4gPiA+ICAgICAg
ICAgcnZ1LT5ydnVfZGwgPSBydnVfZGw7DQo+ID4gPiA+ID4gPiAtICAgICAgIHJldHVybiAwOw0K
PiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgICAgICByZXR1cm4gcnZ1X2hlYWx0aF9yZXBv
cnRlcnNfY3JlYXRlKHJ2dSk7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiB3aGVuIHdvdWxkIHRoaXMg
YmUgY2FsbGVkIHdpdGggcnZ1LT5ydnVfZGwgPT0gTlVMTD8NCj4gPiA+ID4NCj4gPiA+ID4gRHVy
aW5nIGluaXRpYWxpemF0aW9uLg0KPiA+ID4NCj4gPiA+IFRoaXMgaXMgdGhlIG9ubHkgY2FsbGVy
LCBhbmQgaXQgaXMgb25seSByZWFjaGVkIGlmIHJ2dV9kbCBpcyBub24temVyby4NCj4gPg0KPiA+
IERpZCB5b3UgbWVhbiB0byBhc2ssIHdoZXJlIGlzIGl0IGRlLWluaXRpYWxpemVkPw0KPiA+IElm
IHNvLCBpdCBzaG91bGQgYmUgZG9uZSBpbiBydnVfdW5yZWdpc3Rlcl9kbCgpIGFmdGVyIGZyZWVp
bmcgcnZ1X2RsLg0KPiANCj4gTm8sIEkgbWVhbnQgdGhhdCBydnVfaGVhbHRoX3JlcG9ydGVyc19j
cmVhdGUgZG9lcyBub3QgbmVlZCBhbiAhcnZ1LQ0KPiA+cnZ1X2RsIHByZWNvbmRpdGlvbiB0ZXN0
LCBhcyB0aGUgb25seSBjYWxsZXJzIGNhbGxzIHdpdGggd2l0aCBhIG5vbi16ZXJvDQo+IHJ2dV9k
bC4NCg0KWWVzIHVuZGVyc3Rvb2QhIQ0KV2lsbCBmaXggaW4gdjIuDQoNClRoYW5rcywNCi1HZW9y
Z2UNCg==
