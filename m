Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BAC2EAD40
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbhAEOSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:18:37 -0500
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:39638
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbhAEOSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:18:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvr7ZgH0N1QB602WbtFEW5P0d5IEoGV2iozfvpZJt+DLSzF3VSbfZt8Qkk9nv9rOAfk6AsL2vG7gcauhMDsjqEMHR1pxIkUx0rVXikubjC+2jD5RlIegqjMm+4G2p5nsMssyLId8PdfN80E0hpPxQIa4Uw6QM5Bby6y5w1dvJzjdPvX+Ch27AM4/d3ULtD+gmzxWn6LyKOHzSMK0WAxLYgd+Goiew9qv5BZgqKxA/dZv2pVjcOIQ6D2DrWX+m3C6v7qKL5qb64SdJRUkWllq5cL6Bl/c5KOp1L9nsBMylgWmJM8SBOWDGcCO/NkgOP9WORQoHGrOkh3ws6IOZfMlGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJePtYBLAr40yF0gUjx0DgIFf4llN7s+DV7X2u3S/Mw=;
 b=ZsStXKNhqNbBs82Fd2AztjXYSEZvZ8afrtrLJjCohavMn9zNV0pBgu4s2lOQjKLMDLoDpHgxht0bofMGHAN67mxgmEedJumzldMDk3oGARHc3hBr04HSdGHuZ1I70uaoDlyE3brjoqwKAhCdfXskwpt0RMyQ7dgXkOwt2nL+L9CzA+x97DRG69rP9p/ThCHYTKCHd6QYdkbiIyYJiVpD3G7iMjsls7u2F7Zg+xvSFV7z8B3pIAo1gKDMd1DLAoT0XA69L+8uGema8axyU+Oas6E0h74EK6QAfIhfz+fYoEqc19r8G0hIFnXwThN7xTZQY4Bofsw21Pi4Ps/7vR5LTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJePtYBLAr40yF0gUjx0DgIFf4llN7s+DV7X2u3S/Mw=;
 b=LpYnf8sZpNt8AStu4tQgB0yioehiFURcxCIYaYQQ00VYreVeNsITAss0n8o4ymP2gXrUJyR+J04Hk6VMHMb8kQxg5k3h+z0V7dP+rpBDF2O9qa3MHvGG1V1sjsoWkoN5qSCIBcq9g8WRObb1/sXRZnbM2rZA0iibQgHlo35Z1mo=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR1001MB2312.namprd10.prod.outlook.com
 (2603:10b6:910:49::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.24; Tue, 5 Jan
 2021 14:17:42 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::e83b:f5de:35:9fa7]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::e83b:f5de:35:9fa7%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:17:42 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "murali.policharla@broadcom.com" <murali.policharla@broadcom.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "qiang.zhao@nxp.com" <qiang.zhao@nxp.com>
Subject: Re: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Thread-Topic: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Thread-Index: AQHWyzvztwOyjy9i30WJ0/nUUTDGzanvkBgAgCm0fAA=
Date:   Tue, 5 Jan 2021 14:17:42 +0000
Message-ID: <33816fa937efc8d4865d95754965e59ccfb75f2c.camel@infinera.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
         <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
         <20201210012502.GB2638572@lunn.ch>
In-Reply-To: <20201210012502.GB2638572@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86cbe9ba-9faf-4095-3fc5-08d8b184aa36
x-ms-traffictypediagnostic: CY4PR1001MB2312:
x-microsoft-antispam-prvs: <CY4PR1001MB23120102779635469298D607F4D10@CY4PR1001MB2312.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IaTAfWeT6/KN06pXDWtDxG8Ny6UzPb792D8ISzWm1Rfefxvi26wSXV1gYZtBByfw9hwtMXRa1ABjPCY/mIGILDXfIw7IHbSSM67juMHhvq8OgEu4yxMs27MrJwOuR8rAma1O6FSL/xvYDXJEsLOkTW9eGjfiP3FDQ3/vWYJyTyp9SPa8XyCiMluvae+9J5wCYkbCDC002BvWGUUVfhlBW4Ep9L93g4olMlG6EVleI681JCbGzJoS+S5vdPLxoAUPL4IO8SuQYdBPdlOHfDdDIpdCuCqxa82DitusPhQT4y5E9PMp20HzvescyVy63wtzxHRqcYH/w5wrfiOngn7Y28lxcaPP+ISEIUi0cca98gXEENY/c4bhG+l9LP2CA46kvILUxqL+zGE63qNcLRy3tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(366004)(136003)(396003)(346002)(66476007)(86362001)(2906002)(2616005)(8676002)(64756008)(186003)(316002)(66556008)(66446008)(4326008)(91956017)(76116006)(6486002)(6512007)(6506007)(26005)(4001150100001)(478600001)(71200400001)(66946007)(83380400001)(36756003)(54906003)(7416002)(110136005)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M2k5dWxHY25qanpETlE3SzR6KzdpSmNjNGNjSERuSkJSY2l2U09PcEsvQ2ZI?=
 =?utf-8?B?bUVWdzNjd1lFY1lPeW45NkM2OXB6RTcyWG9NaGgxN2NCTi93UTV3YXNkdWl5?=
 =?utf-8?B?U0p3aGlrMDh2bW5kOWxJRi8yVld0c2xzK2VTdllWUnZtVC9PSGx5WEJpZjVZ?=
 =?utf-8?B?SzJuMEQvYTRsVkNBMDJaNDhPNUoydUxnQkJMa3E0T3VLVXg1QXdFNFhFTEZi?=
 =?utf-8?B?TW1rc3NYNUlVNk0vS042RWlGSUV3S3ltSVZnZUFCblFnMTNxZFZZeTZkUU5s?=
 =?utf-8?B?M2NrOGNNQjVqYUFqSDZIdlpZS0x0RTIyWkVLN3dWNlpIRE8xSFVpS1Y4dEJt?=
 =?utf-8?B?YkxmYjQ2Z2RkdHhnWVJabW5adW1sbFdUdm43b2J4VkQreGJ4aFpIUlZCN1o4?=
 =?utf-8?B?K3J6eFk3NXdmbjM5dzNCVE53aUUybDVTaitCemxDYlVpRTg3UnFzR1lza1NI?=
 =?utf-8?B?MEdiNUNRRTRFd3c5VHVHYkMwSE5JRzJ0enpRYXZGTGZvTDNYbnQwaDRleEg5?=
 =?utf-8?B?cmpEb2liUjhjVnJGZjRJVFZuRE5oMUVQTFkwV0JsV3Rva1VUNDdPT3ZpelBN?=
 =?utf-8?B?enZTSkg4ck5vV3JqVmpDU0l0SXQ4UzNWWjBST2FSYkdhOTBabkdwTENjUksz?=
 =?utf-8?B?akdtZWFRUk1LbU11b2lvU3djbEZ5dURlc05pdnlnNDB4MXNxRjVmME85bFJ1?=
 =?utf-8?B?MTI1L1NLM2hDai9LVHVTMjNKcWVwdHpGV0JhaVFvQWpLZ1o0QjF4Z2VZYXgr?=
 =?utf-8?B?ODkrVW1YZk1Cb2krK3dva2x1TUorcmVQZjIrc210QTJjVHVoK2pEcVZzNmND?=
 =?utf-8?B?OVh6YmJEUEQxbVhSQlJLUCsyUUxHNnhUdjhhdWc2MkdjRENGaVdUdW1yOU84?=
 =?utf-8?B?QlZVVG9MYzB5ZTUxdmJ0ZElsdE94eFVITTYxbFZReVlCR2MxT2VDRytWTE53?=
 =?utf-8?B?N0tDWXVwd00wbnVlaVgxREEyVXI0bGVjbFdaQnFtK1lWdjUzRUlOL0xJQUw0?=
 =?utf-8?B?eWJhWjI1aldKQWd3dTlCK1RmMnd5L05yMmFIVVJSenpPaHFHOWV0ZGlzRG5y?=
 =?utf-8?B?d0gzbEJFWDNMWXVkeVp6cG1TMW1WZ1RqYjUzV1d1NXI3eFJqK0NnZkVPRWJE?=
 =?utf-8?B?MUpCYWV6Q0hBajlYSHZablhxeWlqSk9nYjZSd012cnVOWHFPUzdHc091WHB5?=
 =?utf-8?B?Y2tEaVlpSHRUaUNKYWtKaE9GSXhkUHNjU3Rnc1czR2dLakxMOHliS1kvYmpL?=
 =?utf-8?B?b240NHdNKzA0MkpPMEVlUisrYjd0eGR0QUJkcDh6RFVETTMrVXZ3aEEzSW9R?=
 =?utf-8?Q?A7C9nWqK0wP3Noe8JVmZ2sQOlYPmSMisHt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D24AF8C590D064A9D4993127EC4B716@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cbe9ba-9faf-4095-3fc5-08d8b184aa36
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 14:17:42.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wWKIKOtb00ROncMfMWhkU84cK10sQQwpERSNPq91+s6pdzYJjPE1aT8qJ7pG/qLSEABi5BdsLGoSI5S1FkuWbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2312
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTEwIGF0IDAyOjI1ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gU2F0LCBEZWMgMDUsIDIwMjAgYXQgMDg6MTc6MjRQTSArMDEwMCwgUmFzbXVzIFZpbGxlbW9l
cyB3cm90ZToNCj4gPiBBbGwgdGhlIGJ1ZmZlcnMgYW5kIHJlZ2lzdGVycyBhcmUgYWxyZWFkeSBz
ZXQgdXAgYXBwcm9wcmlhdGVseSBmb3IgYW4NCj4gPiBNVFUgc2xpZ2h0bHkgYWJvdmUgMTUwMCwg
c28gd2UganVzdCBuZWVkIHRvIGV4cG9zZSB0aGlzIHRvIHRoZQ0KPiA+IG5ldHdvcmtpbmcgc3Rh
Y2suIEFGQUlDVCwgdGhlcmUncyBubyBuZWVkIHRvIGltcGxlbWVudCAubmRvX2NoYW5nZV9tdHUN
Cj4gPiB3aGVuIHRoZSByZWNlaXZlIGJ1ZmZlcnMgYXJlIGFsd2F5cyBzZXQgdXAgdG8gc3VwcG9y
dCB0aGUgbWF4X210dS4NCj4gPiANCj4gPiBUaGlzIGZpeGVzIHNldmVyYWwgd2FybmluZ3MgZHVy
aW5nIGJvb3Qgb24gb3VyIG1wYzgzMDktYm9hcmQgd2l0aCBhbg0KPiA+IGVtYmVkZGVkIG12ODhl
NjI1MCBzd2l0Y2g6DQo+ID4gDQo+ID4gbXY4OGU2MDg1IG1kaW9AZTAxMDIxMjA6MTA6IG5vbmZh
dGFsIGVycm9yIC0zNCBzZXR0aW5nIE1UVSAxNTAwIG9uIHBvcnQgMA0KPiA+IC4uLg0KPiA+IG12
ODhlNjA4NSBtZGlvQGUwMTAyMTIwOjEwOiBub25mYXRhbCBlcnJvciAtMzQgc2V0dGluZyBNVFUg
MTUwMCBvbiBwb3J0IDQNCj4gPiB1Y2NfZ2V0aCBlMDEwMjAwMC5ldGhlcm5ldCBldGgxOiBlcnJv
ciAtMjIgc2V0dGluZyBNVFUgdG8gMTUwNCB0byBpbmNsdWRlIERTQSBvdmVyaGVhZA0KPiA+IA0K
PiA+IFRoZSBsYXN0IGxpbmUgZXhwbGFpbnMgd2hhdCB0aGUgRFNBIHN0YWNrIHRyaWVzIHRvIGRv
OiBhY2hpZXZpbmcgYW4gTVRVDQo+ID4gb2YgMTUwMCBvbi10aGUtd2lyZSByZXF1aXJlcyB0aGF0
IHRoZSBtYXN0ZXIgbmV0ZGV2aWNlIGNvbm5lY3RlZCB0bw0KPiA+IHRoZSBDUFUgcG9ydCBzdXBw
b3J0cyBhbiBNVFUgb2YgMTUwMCt0aGUgdGFnZ2luZyBvdmVyaGVhZC4NCj4gPiANCj4gPiBGaXhl
czogYmZjYjgxMzIwM2U2ICgibmV0OiBkc2E6IGNvbmZpZ3VyZSB0aGUgTVRVIGZvciBzd2l0Y2gg
cG9ydHMiKQ0KPiA+IENjOiBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNA
cHJldmFzLmRrPg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5j
aD4NCj4gDQo+IMKgwqDCoMKgQW5kcmV3DQoNCkkgZG9uJ3Qgc2VlIHRoaXMgaW4gYW55IGtlcm5l
bCwgc2VlbXMgc3R1Y2s/IE1heWJlIGJlY2F1c2UgdGhlIHNlcmllcyBhcyBhIHdob2xlIGlzIG5v
dCBhcHByb3ZlZD8NCg0KIEpvY2tlDQo=
