Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A1BF17DB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbfKFOCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:02:47 -0500
Received: from mail-eopbgr1410110.outbound.protection.outlook.com ([40.107.141.110]:21152
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726926AbfKFOCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 09:02:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgjqYiRJ3D/Hr5YHr/V2u846JHqPrCEwqguE5EZBwDln0aNM8HR41ch32RF953kF9sreVBa3dv2CpDVKYyCAuSZ0j2QgXd+Q957r6/H3Lq1oet14CCgOaYPOn58Gao3OZVI92pAM1jh7z4OIQ+10UCIfbFcfDzVhUYxlPRYnBHUxWUTre/oS7BZSt89FdsbnfqoGSgdR+jnceSPshU1CT5XeRhQ09jCBYRtNFdqK9uvwHjKOpmS/CbbonKn0Tyz6Mgz/NR1avLiaE3Pb46wVuT4c7AlYG1m5PBZY8b99E8sSoivqcetIwYhcL5ksMFI4mYwcrs+Lb3OaEzH4t/gyAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWeW3xOfLnJ9yvqVy4z9Pz2dveNCi9QWpys9+zyOh9g=;
 b=NsTDb01bLtsgP+yP3g4/wdfrsJQ5E0ntI44uZk+mpZvzLoufMmul3DKdqLFXeExWVTUECJylauEoarRB0FBSBJuzpdU1M4VfTOWw6VDCge3BaUH5QYb6WJljzBDSkzSDC3X5KyhFWXkLhv0Qhy5T/KAFVWhwSrC90oV6YtXCokNhDDXmAy73UbiRy83CQiygs8YTHUMbPSmNkapMVJz/Le9onYua+nCdtxbCStHIh+pFmJAwTmHI6/9ak9ojoLVhOiNqXEqwJsAGJIRMxJw8pYGw+XFtmc2VYAkLCke3R/HkiC1cwaY4fIiS8rkjmAGxKOj1qF+fKQUauZDRvDLkgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWeW3xOfLnJ9yvqVy4z9Pz2dveNCi9QWpys9+zyOh9g=;
 b=rmkp8tmL5etJfpYGt5mXEOfSLqcsPFygHdkb5aAuZnhkoK4p2tiQegxN79KP7ZhmQR0sBPmuvp8DVPw/76UM7wgQj2GmugHw7MMlZfNSzrdGZ485UZNLc+pSEh4l8jC301/hErzrqLczOIAXGSNropCnxQlLLag+DKN2nsj8C1M=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB2290.jpnprd01.prod.outlook.com (52.134.235.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 14:02:43 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::fcbd:8130:e86:e239]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::fcbd:8130:e86:e239%6]) with mapi id 15.20.2408.025; Wed, 6 Nov 2019
 14:02:43 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH -next] ptp: Fix missing unlock on error in idtcm_probe()
Thread-Topic: [PATCH -next] ptp: Fix missing unlock on error in idtcm_probe()
Thread-Index: AQHVlJjiCPlqzOaK1EuJpaAhEMieVad+LHYA
Date:   Wed, 6 Nov 2019 14:02:43 +0000
Message-ID: <20191106140228.GA28081@renesas.com>
References: <20191106115308.112645-1-weiyongjun1@huawei.com>
In-Reply-To: <20191106115308.112645-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2ed47e56-aa7b-47bf-f022-08d762c1fe30
x-ms-traffictypediagnostic: OSAPR01MB2290:
x-microsoft-antispam-prvs: <OSAPR01MB22907A8E826E97A93056EE41D2790@OSAPR01MB2290.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(346002)(376002)(39850400004)(199004)(189003)(14454004)(1076003)(36756003)(11346002)(66946007)(86362001)(446003)(6246003)(66556008)(6512007)(476003)(256004)(14444005)(4326008)(316002)(66446008)(64756008)(66476007)(5660300002)(6916009)(26005)(229853002)(305945005)(102836004)(76176011)(186003)(386003)(4744005)(6506007)(8936002)(54906003)(2616005)(486006)(71190400001)(99286004)(71200400001)(7736002)(478600001)(6116002)(3846002)(33656002)(81166006)(81156014)(2906002)(66066001)(8676002)(6436002)(25786009)(52116002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB2290;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OrpOrwCnCDUProZu9L/b9YnSdN5zIz2txbLFCX5Z7xNzeE7c4TLclEFwrAG9lLts9N5v6wsy6Du3wNgqGr8sE+lRf9f9kgLVofjl7TNFXCig7mk7y7B2dQVMOkTUiollpj9hKJil+sFOKgH/hEnx2/UygOfsxrcEXb7e9k5/GbMcsWaAHzldVds0YXTkFSBWaJMRZHKBq/WtzfBW1GdSX6qK5TDpSAM+jSNJ1B3g+LDOGIb7C87VMta2lcMfBcfZANbwD1nGGQotdo82qX8sRPkgDmLwKh1a9g9kRHiWvYDiYy/kZfQb9TH0akJyyR/ECFAZH5BYY2b66YPEaUKuJ/XBUsT0qouRI7bZY2lhjd0L9t5Bbu8sCqDJCmdc06al9n97BhRhewFTlWpbMpxbzmGIvW5DIgRApgnZWkjj3Ln9rEEdsKGZq1I6SFcm2uYL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A13F2DF847C3B14E99E91DCE89CE208E@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed47e56-aa7b-47bf-f022-08d762c1fe30
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 14:02:43.1203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Isgd1Lw2RpTChhGx4N/lhyQ25DHTJvq1pOZN5PUTQgtLodBGGgD/ugMbBJZYNqCcfpd7EpIQ68fnWj8ZYvaUXJCIr3Ct053R2IiZIK1QaA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2290
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBOb3YgMDYsIDIwMTkgYXQgMDY6NTM6MDhBTSBFU1QsIFdlaSBZb25nanVuIHdyb3Rl
Og0KPkFkZCB0aGUgbWlzc2luZyB1bmxvY2sgYmVmb3JlIHJldHVybiBmcm9tIGZ1bmN0aW9uIGlk
dGNtX3Byb2JlKCkNCj5pbiB0aGUgZXJyb3IgaGFuZGxpbmcgY2FzZS4NCj4NCj5GaXhlczogM2E2
YmE3ZGM3Nzk5ICgicHRwOiBBZGQgYSBwdHAgY2xvY2sgZHJpdmVyIGZvciBJRFQgQ2xvY2tNYXRy
aXguIikNCj5TaWduZWQtb2ZmLWJ5OiBXZWkgWW9uZ2p1biA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNv
bT4NCj4tLS0NCj4gZHJpdmVycy9wdHAvcHRwX2Nsb2NrbWF0cml4LmMgfCA0ICsrKy0NCj4gMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPg0KPmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3B0cC9wdHBfY2xvY2ttYXRyaXguYyBiL2RyaXZlcnMvcHRwL3B0cF9jbG9j
a21hdHJpeC5jDQo+aW5kZXggY2Y1ODg5YjdkODI1Li5hNTExMGI3YjRlY2UgMTAwNjQ0DQo+LS0t
IGEvZHJpdmVycy9wdHAvcHRwX2Nsb2NrbWF0cml4LmMNCj4rKysgYi9kcml2ZXJzL3B0cC9wdHBf
Y2xvY2ttYXRyaXguYw0KPkBAIC0xMjk0LDggKzEyOTQsMTAgQEAgc3RhdGljIGludCBpZHRjbV9w
cm9iZShzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LA0KPiANCj4gCWVyciA9IHNldF90b2Rfd3Jp
dGVfb3ZlcmhlYWQoaWR0Y20pOw0KPiANCj4tCWlmIChlcnIpDQo+KwlpZiAoZXJyKSB7DQo+KwkJ
bXV0ZXhfdW5sb2NrKCZpZHRjbS0+cmVnX2xvY2spOw0KPiAJCXJldHVybiBlcnI7DQo+Kwl9DQo+
IA0KPiAJZXJyID0gaWR0Y21fbG9hZF9maXJtd2FyZShpZHRjbSwgJmNsaWVudC0+ZGV2KTsNCj4N
Cg0KWWVzLCBnb29kIGNhdGNoLiAgVGhhbmsteW91IGZvciB0aGUgZml4Lg0KDQpSZXZpZXdlZC1i
eTogVmluY2VudCBDaGVuZyAgPHZpbmNlbnQuY2hlbmcueGhAcmVuZXNhcy5jb20+DQo=
