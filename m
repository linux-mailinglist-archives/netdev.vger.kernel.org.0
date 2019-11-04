Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00331EEE1F
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389220AbfKDWML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:12:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389586AbfKDWLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:11:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA4M1PLx024543;
        Mon, 4 Nov 2019 14:11:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=t4LYFXf3fyvS32HJGD5AQBk/yQltZLID5kWr5S1ieZo=;
 b=jmcxPrnmsFg2bWfC+PnPnRCE0+QFIAu3CQXcILwdlt17oXPK+4NS4W09/lSDZc4FQdwZ
 uhDn1UbmpkA4CcQHT9sdG7aWzlrS6hV7QTheBuJ1qklVFWbvkplDhUfLZWlVfX0eQQQI
 UucbKkwIrmC1qWRPNhcekp6EkYaJ4+l1nNAL8xWp/+H+VamwMTypI2psJNBB9k8qsFT5
 gc/S8lUJVGmrRHVokwPro9LYMPKZI5tqiCLLZQNId6bExUYorCVw3jLX8ZTLF6qKt1Yg
 Sh9v1DbamJYeNGPGCfTLSD5pUHVSGgi7puPyy3cXiZ9IDQo+ieZc0U2IKmMKC9O/D/vW Wg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n8yu0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 14:11:40 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 14:11:39 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 4 Nov 2019 14:11:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKtmm08RJTLsk+rdNIjqHBBKyHWMMbA8F+e3Cgbqq70LLWbM5cW6EdByiyLNjyD4hANjRLmZpdumrExrUrorkPsSmeLlVnXGdBnzue4/oeAJhMvZJdDYP0ZCjjRzBUkh5qy+sCQijf2ASsNvP9S3q4WScj7pC1KvM+aZQk4m+q+bP00D9D95nPTOefZxj3nYoJVNYQ/glgaoGP7OZUaeXflgU7j/vZ+E/kwMFV1n+3i9fpPQ2q1+RnpESqZ7WPHdVMTPtWG7Ui0hu0LoKHoHge1if9NZkW2HdHbyw0GXM4hGbpXP6AxYL6KS3YYgHevA79PTtJAjvg2nGJ8CbZY4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4LYFXf3fyvS32HJGD5AQBk/yQltZLID5kWr5S1ieZo=;
 b=Hkwq4/c+BjIMO+QPXp5c9zvVfRArBCNztYbWB1DJIhwEEEtm2HwMWCTTbd6SDIejK88vJwrYo+PMNDO+6t6lZZGbgUJ/km4aNmb+TyRfEznxGMubjYAT4crAlYAxWBnfnpB0x44SLpI+0qWUl66t8XdytCFBTQnB7fOQkbKoaWKTgoxSWyUq1/xHBBYXFUEGGIbtspmlvxog82vZ279xlf25s0KIVMHyW5aUq2i1E6ngvqoMu0DqJfk4duZ1NNPO9eLbzEC+2U6lM+z+YyD3ZT472meHb6x2k+3/sQC4fr7hM6Qj/x0HLnz/frXEtWf0wVdGBkbXuYm5i88QUb+5Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4LYFXf3fyvS32HJGD5AQBk/yQltZLID5kWr5S1ieZo=;
 b=gX2XsFP2WosUu/5Ca7CjlBqak9Lr5RFeZc6TIEfbAlaP45srK8BbB4d/h3tWmwg2s3G/Er04lNpit4td4kx/KycWm9xfaZ1kmd19wbsOirW9CGgFZ/KuykWPfyZ+mIKJtCP6Y2+nL6jtck2+cHvtiOdPfB9WRIPDuw1d3au8ddI=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB0971.namprd18.prod.outlook.com (10.168.116.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 22:11:38 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 22:11:38 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>
Subject: Re: [EXT] Re: [PATCH net-next 11/12] net: atlantic: implement UDP GSO
 offload
Thread-Topic: [EXT] Re: [PATCH net-next 11/12] net: atlantic: implement UDP
 GSO offload
Thread-Index: AQHVkK5TrID/dPWqnk6zS6twyvLpdA==
Date:   Mon, 4 Nov 2019 22:11:38 +0000
Message-ID: <20d6b8df-8108-657a-0468-b25917cee0f6@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
 <e85100822a4656332c8aa208a2e98af3df12e325.1572610156.git.irusskikh@marvell.com>
 <71644e07-8dc1-3391-2701-d989906d38a3@gmail.com>
In-Reply-To: <71644e07-8dc1-3391-2701-d989906d38a3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: GVAP278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::27) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cf20ae0-a5ed-4911-56d1-08d76173f67b
x-ms-traffictypediagnostic: DM5PR18MB0971:
x-microsoft-antispam-prvs: <DM5PR18MB0971520BAA4681E99E209C8FB77F0@DM5PR18MB0971.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:250;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(189003)(199004)(6506007)(4744005)(7736002)(86362001)(25786009)(3846002)(186003)(8676002)(6512007)(256004)(31696002)(5660300002)(305945005)(486006)(66946007)(66556008)(8936002)(66446008)(476003)(64756008)(66476007)(81156014)(4326008)(6116002)(99286004)(11346002)(36756003)(2616005)(446003)(6246003)(6436002)(478600001)(52116002)(2906002)(26005)(66066001)(6486002)(81166006)(76176011)(2501003)(110136005)(14454004)(71200400001)(229853002)(71190400001)(102836004)(386003)(316002)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB0971;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62NQtzWsxW13e1faFsfD1TFHWVNkc1OsLQ0IY5kr5rSJY4hpqRQEz1SyaRzsPK4gctMEsLIcLuJDkDvQ0S4LvUX/3uO7zpzil7PFwX3o+00f4xi82LgoNk72Ww+34y0UmzxAiG3Ir2U9xPUpO7ERqzN3Kn7M/2e3kws2dIWz/AUP5gmu1Vo36+ZDaWhYgthJUM+T5Dygi1E+uTwESOoMqyiCw9JnKa/ugUVqEjtyHBgJ4r3S9PZkVqwRlDGuegMex4iIxaADvkEEpeEIHkaorBz4sjOfGf3mUDGu9drXEkQIDvUD0r2VPw3tet7YyCObuTE6/9ScDGSj3Sv3onVPXNA/BjJv71HclP5RajRVbHxMBvfPZLuzrmHyPRRByRjLY7L6mY8D4BCL98VVK3CNOPAVx7q7HK29jLVFXAEh92IxCmJh3P/y2JhcyKrvsIPL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <073658447331F7489BD0BCAF8587D4F8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf20ae0-a5ed-4911-56d1-08d76173f67b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 22:11:38.3085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ff/tz2tX1lebxpmpnIeEGPEwKLWPDzkSScixhAkDMFxOxfp9hx4R60cdoymVes2U2nlbV8XbOtoxagYs4kR8pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0971
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_11:2019-11-04,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiArCQkJLyogVURQIEdTTyBIYXJkd2FyZSBkb2VzIG5vdCByZXBsYWNlIHBhY2tldCBsZW5n
dGguICovDQo+PiArCQkJdWRwX2hkcihza2IpLT5sZW4gPSBodG9ucyhkeF9idWZmLT5tc3MgKw0K
Pj4gKwkJCQkJCSAgZHhfYnVmZi0+bGVuX2w0KTsNCj4+ICsJCX0NCj4gDQo+IEhhdmUgeW91IHRl
c3RlZCBJUHY2ID8NCj4gDQo+IA0KPj4gIAkJZHhfYnVmZi0+bGVuX3BrdCA9IHNrYi0+bGVuOw0K
Pj4gIAkJZHhfYnVmZi0+bGVuX2wyID0gRVRIX0hMRU47DQo+PiAgCQlkeF9idWZmLT5sZW5fbDMg
PSBpcF9oZHJsZW4oc2tiKTsNCj4+IC0JCWR4X2J1ZmYtPmxlbl9sNCA9IHRjcF9oZHJsZW4oc2ti
KTsNCj4+ICAJCWR4X2J1ZmYtPmVvcF9pbmRleCA9IDB4ZmZmZlU7DQo+PiAgCQlkeF9idWZmLT5p
c19pcHY2ID0NCj4+ICAJCQkoaXBfaGRyKHNrYiktPnZlcnNpb24gPT0gNikgPyAxVSA6IDBVOw0K
PiANCj4gSSBhbSBhc2tpbmcgYmVjYXVzZSB5b3Ugc2VlbSB0byB0ZXN0IElQdjYgaGVyZSwgc28g
YmxpbmRseSB1c2luZyBpcF9oZHIoc2tiKS0+cHJvdG9jb2wNCj4gZmV3IGxpbmVzIGFib3ZlIGlz
IHdlaXJkLg0KPiANCg0KSGkgRXJpYywgdGhhbmtzLCBpbmRlZWQgaXQnbGwgc2NyZXcgdXAgb24g
aXB2Ni4NCkhXIHNob3VsZCBiZSBpcDYgY2FwYWJsZSwgSSdsbCByZXRlc3QgYW5kIGZpeCB0aGlz
Lg0KDQotLSANClJlZ2FyZHMsDQogIElnb3INCg==
