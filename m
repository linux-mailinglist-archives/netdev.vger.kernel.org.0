Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539E6163FBD
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 09:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgBSIuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 03:50:03 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1312 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgBSIty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 03:49:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01J8eXM0023134;
        Wed, 19 Feb 2020 00:49:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=HexkNmwbah81/tJZnntqUJ8XzjMcI7ESJ3iFYaWoT2g=;
 b=Ra5Kt4DPIODox3nznwq4kV0a/bb8Kha1BK52IZOFJrsxqWBqZQjhVv/4Mv25xlDbTxWK
 jsuCNfnmIz6wyGr+FysuT75oBamNeUxMP3IFnDTcKrBkCk8lSTyByPfg/7N6oifNnFO9
 n4lJ32ywdedQ2RmkhHuDzRSMYMxiLo6uOilh7+yN8xFwr+ua9kxB+WDluSJYvLnum8bC
 qdT6ufdNK98Xy7GPt53ju3LQ4EtHiWdrx78lPjxM9hjulVe/WibODNqQi8FfRq4o+oYM
 pusHVc4OL0f6JW65WppTcVoE765V0IAsM9q14DZF3pHNpCNciNYRRhg42667uiTk1Q81 7g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y8ubh9bjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Feb 2020 00:49:36 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Feb
 2020 00:49:35 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 19 Feb 2020 00:49:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3I1pyfvzTLQ5zFIQq6iBEUU71yC2e4z14rzlHMMQlv0lUaxK9nJ8URUN6BPY/U+uTqxAH1wwSREtg1u9Qtxem53el+UGZZYzM2F6M59NOzuNHs8IPoH0iku/4G1GIRXSRioW2TiVMK793F8TDS9TPjb1J7BnOPEc8fG2dGd33/synPMEVPHw/PB7NcKFcLKBs1EcoUX/GX8KHE4o4f5ulkYCfJYIZWqjFNJnfSWfzqAxkKPKBrq4OOxgqsrctGZwAEvzVBmjx7xMCRbz9pNPuyrhPogg2wzhHCwKfFGv1Uo1T9ranhVWNWiXbOgRluxKvwb4apqz8V0KdmFJjzBmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HexkNmwbah81/tJZnntqUJ8XzjMcI7ESJ3iFYaWoT2g=;
 b=aJ0Z1HM1E976L8XjbAREbvTeNfjmpbQnh0EdNP7IbEes5JVvK+6ecg4xCSskjy+WelhPRBj6V/Hl4W0ehDAkzZPdFI5dJ97rLMtGHss5eD+5BHtZz4wegyhtkdELccvWbXG4CT/KkXleP9bUl7nCnLqIDAkxOdR94jauxj7NZp9oDzZGE1W7/l5Mr7qFu4MLj2enxdMnIBzNfXy/qgn2e5v3Slp4y+nDPuj1YpHw6LO4Nv69wxuwaYiGku/gtyUNZR8Nr4wyrNWSixIUn+14m0CtDHssQiPcCGLU+ZjTRAPOVmIK079BIAQhJmmg0jdGlY3EQGEGERk6F0J03hFfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HexkNmwbah81/tJZnntqUJ8XzjMcI7ESJ3iFYaWoT2g=;
 b=TUqHt91LyO9iYjCn8I7GYYHTmvdPL1PlUiDuVdEhq2Jsnsxt43a54OeEszH35EObdrVlIt8QvwPr7rvS9EEYKlGRXLfU9LWBog250b1RFWHl+uHdadE682bcodDPyNpfBh17yAARWSaS8QGpgBq3Zo8L55PuDgp+jgZTCFPhNCE=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3008.namprd18.prod.outlook.com (20.179.84.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Wed, 19 Feb 2020 08:49:33 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::f03e:3f60:650a:4d56]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::f03e:3f60:650a:4d56%5]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 08:49:33 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "it+linux-netdev@molgen.mpg.de" <it+linux-netdev@molgen.mpg.de>
Subject: RE: bnx2x: Latest firmware requirement breaks no regression policy
Thread-Topic: bnx2x: Latest firmware requirement breaks no regression policy
Thread-Index: AQHV5ZS7DZVeCVVRU0OIrjv7PCOj3qgiLvOw
Date:   Wed, 19 Feb 2020 08:49:33 +0000
Message-ID: <MN2PR18MB2528C681601B34D05100DF89D3100@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de>
In-Reply-To: <ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.48.74.160]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 291d695d-3a55-4d47-385a-08d7b518a446
x-ms-traffictypediagnostic: MN2PR18MB3008:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3008F1A48C5D7B7416BFD5C2D3100@MN2PR18MB3008.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(346002)(396003)(136003)(199004)(189003)(110136005)(316002)(55016002)(81166006)(64756008)(186003)(76116006)(26005)(7696005)(8676002)(5660300002)(66476007)(9686003)(66946007)(81156014)(66556008)(66446008)(54906003)(33656002)(53546011)(52536014)(4326008)(86362001)(6636002)(8936002)(6506007)(2906002)(478600001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3008;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sbopKEImzI0tfA8FnXyCCClOZoABWCisIruXdA3B/IIvBZ+Q5qtlA88F4007vjC22uMhttPUB9zrrN4TwI3OibBDsFbqdFluZ8XyBhUm/7CuVvOMBqkqxyCo1CGAGkdihBN3xd6JTl2htwJaCMtgAYShO+ZbkHxfBxSlKlRfZ6+cbNtOBMdxWE2UCmv7KeqMWUAZs4Q7VzTK+3W/a8s8wpyC5SFCl7OObbj90KYbgTKUjCDmrZJGV6BcYmjnFDDglIIKJal8psvuAlDRmd3ouSVjesbPWZubZJxQsTUq19ESJAbFOURPDF4azy9LFMH6C94WNdIGyZREv+rxtTPx4SfsDG5WWNhhGIVidrdCl2uD2xUFC4hUNKU5YfuJBADNOf7We0JMUI6L6mX9X13n2cuQ4/Au8R1ZIjuFgX36l87GUdO2c4Pz7zd1OdFI5SfE
x-ms-exchange-antispam-messagedata: siyfDG4Ii3YvWWiWJF392ADoSod2X7qU2ARTHr9r7rn+XCvqKv0TCoUujtUYxGwdbNWHPPAQjxhtBNXU0XUGAX+mbBs36trvnUQMm06x/AKDcFAX7fNg96ZI5dHFPhK49s0GihIExDNQLBmqVcBpSQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 291d695d-3a55-4d47-385a-08d7b518a446
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 08:49:33.5023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k6GMtqq6fWAkRhRYyy/YgGYeVdMJJ+PTT5WyZIXP+XwJNufIEMvLM++qSV8cZPvGC+nBWvMW8xbM89zypiOo1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3008
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_02:2020-02-19,2020-02-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF1bCwNCiAgICBUaGUgZmlybXdhcmUgZmlsZSByZWZlcnJlZCBiZWxvdyAoaS5lLiwgc3Rv
cm0gRlcpIHNob3VsZCBiZSBwcmVzZW50IG9uIHRoZSBob3N0IChpLmUuLCAvbGliL2Zpcm13YXJl
L2JueDJ4LyBwYXRoKSwgbm90IHRoZSBkZXZpY2UuIERyaXZlciBtdXN0IHJlcXVpcmUgdGhpcyB2
ZXJzaW9uIG9mIHRoZSBGVyB0byBpbml0aWFsaXplIHRoZSBkZXZpY2UsIGFuZCBoZW5jZSBwcm92
aWRlIHRoZSBuZXR3b3JrIGZ1bmN0aW9uYWxpdHkuIEFsc28sIHRoZSBkcml2ZXIgaXMgbm90IGJh
Y2t3YXJkIGNvbXBhdGlibGUgd2l0aCBvbGRlciBGVyB2ZXJzaW9ucy4NClNvIGl0J3Mgbm90IHBv
c3NpYmxlIHRvIGhhbmRsZSB0aGUgYmVsb3cgZXJyb3Igc2NlbmFyaW8gaW4gdGhlIGRyaXZlciwN
Cgk+ICAgICBibngyeCAwMDAwOjQxOjAwLjA6IERpcmVjdCBmaXJtd2FyZSBsb2FkIGZvciBibngy
eC9ibngyeC1lMWgtNy4xMy4xMS4wLmZ3IGZhaWxlZCB3aXRoIGVycm9yIC0yDQoJPiAgICAgYm54
Mng6IFtibngyeF9pbml0X2Zpcm13YXJlOjEzNTU3KG5ldDAyKV1DYW4ndCBsb2FkIGZpcm13YXJl
IGZpbGUgYm54MngvYm54MngtZTFoLTcuMTMuMTEuMC5mdw0KQXQgdGhlIG1vc3QsIHdlIGNhbiB2
YWxpZGF0ZSB0aGUgZXhpc3RlbmNlIG9mIEZXIGZpbGUgb24gdGhlIGhvc3QgZHVyaW5nIHRoZSBr
ZXJuZWwgYnVpbGQgb3IgaW5zdGFsbGF0aW9uLg0KRlcgaW1hZ2UgbmFtZSBmcm9tIGRyaXZlciBz
b3VyY2VzOg0KCWRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4X21haW4u
YzoNCgkjZGVmaW5lIEZXX0ZJTEVfTkFNRV9FMSAgICAgICAgICJibngyeC9ibngyeC1lMS0iIEZX
X0ZJTEVfVkVSU0lPTiAiLmZ3Ig0KCSNkZWZpbmUgRldfRklMRV9OQU1FX0UxSCAgICAgICAgImJu
eDJ4L2JueDJ4LWUxaC0iIEZXX0ZJTEVfVkVSU0lPTiAiLmZ3Ig0KCSNkZWZpbmUgRldfRklMRV9O
QU1FX0UyICAgICAgICAgImJueDJ4L2JueDJ4LWUyLSIgRldfRklMRV9WRVJTSU9OICIuZnciDQpG
VyBpbWFnZSBwYXRoIG9uIHRoZSBob3N0Og0KCS9saWIvZmlybXdhcmUvYm54MngvYm54MngtZTFo
LTcuMTMuMTEuMC5mdw0KDQpUaGFua3MsDQpTdWRhcnNhbmENCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93
bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVoYWxmIE9mIFBhdWwgTWVuemVsDQo+IFNlbnQ6
IE1vbmRheSwgRmVicnVhcnkgMTcsIDIwMjAgNjo0OCBQTQ0KPiBUbzogQXJpZWwgRWxpb3IgPGFl
bGlvckBtYXJ2ZWxsLmNvbT47IFN1ZGFyc2FuYSBSZWRkeSBLYWxsdXJ1DQo+IDxza2FsbHVydUBt
YXJ2ZWxsLmNvbT47IEdSLWV2ZXJlc3QtbGludXgtbDIgPEdSLWV2ZXJlc3QtbGludXgtDQo+IGwy
QG1hcnZlbGwuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgTEtNTCA8bGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZz47IGl0K2xpbnV4LQ0KPiBuZXRkZXZAbW9sZ2VuLm1wZy5k
ZQ0KPiBTdWJqZWN0OiBibngyeDogTGF0ZXN0IGZpcm13YXJlIHJlcXVpcmVtZW50IGJyZWFrcyBu
byByZWdyZXNzaW9uIHBvbGljeQ0KPiANCj4gRGVhciBMaW51eCBmb2xrcywNCj4gDQo+IA0KPiBV
cGRhdGluZyBhIHNlcnZlciBmcm9tIDQuMTkueCB0byA1LjQueCwgdGhlIG5ldHdvcmsgZGV2aWNl
DQo+IA0KPiAgICAgRXRoZXJuZXQgY29udHJvbGxlciBbMDIwMF06IEJyb2FkY29tIEluYy4gYW5k
IHN1YnNpZGlhcmllcyBOZXRYdHJlbWUgSUkNCj4gQkNNNTc3MTEgMTAtR2lnYWJpdCBQQ0llIFsx
NGU0OjE2NGZdDQo+IA0KPiBmYWlsZWQgdG8gaW5pdGlhbGl6ZSBkdWUgdG8gbWlzc2luZyBmaXJt
d2FyZS4NCj4gDQo+ICAgICBibngyeCAwMDAwOjQxOjAwLjA6IERpcmVjdCBmaXJtd2FyZSBsb2Fk
IGZvciBibngyeC9ibngyeC1lMWgtNy4xMy4xMS4wLmZ3DQo+IGZhaWxlZCB3aXRoIGVycm9yIC0y
DQo+ICAgICBibngyeDogW2JueDJ4X2luaXRfZmlybXdhcmU6MTM1NTcobmV0MDIpXUNhbid0IGxv
YWQgZmlybXdhcmUgZmlsZQ0KPiBibngyeC9ibngyeC1lMWgtNy4xMy4xMS4wLmZ3DQo+ICAgICBi
bngyeDogW2JueDJ4X2Z1bmNfaHdfaW5pdDo2MDAyKG5ldDAyKV1FcnJvciBsb2FkaW5nIGZpcm13
YXJlDQo+ICAgICBibngyeDogW2JueDJ4X25pY19sb2FkOjI3MzAobmV0MDIpXUhXIGluaXQgZmFp
bGVkLCBhYm9ydGluZw0KPiANCj4gVGhhdCBpcyB1bmRlc2lyZWQsIGJlY2F1c2Ugd2l0aG91dCBu
ZXR3b3JrIGFjY2VzcyBvbmUgaGFzIHRvIGhhdmUNCj4gZGlyZWN0IHN5c3RlbSBhY2Nlc3MgdG8g
ZmluZCBvdXQgd2hhdCBpcyB3cm9uZy4NCj4gDQo+IENvdWxkIHlvdSBwbGVhc2UgY2hhbmdlIHRo
ZSBwb2xpY3kgdG8gb25seSBwcmludCBhIGJpZyB3YXJuaW5nLA0KPiBpZiB0aGUgbGF0ZXN0IGZp
cm13YXJlIGlzIG5vdCBhdmFpbGFibGUsIGFuZCBhbiB1cGRhdGUgc3VnZ2VzdGlvbj8NCj4gDQo+
IA0KPiBLaW5kIHJlZ2FyZHMsDQo+IA0KPiBQYXVsDQoNCg==
