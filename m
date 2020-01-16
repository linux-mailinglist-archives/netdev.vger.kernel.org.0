Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E7A13DCB6
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgAPN7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:59:02 -0500
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:7434 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbgAPN7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:59:02 -0500
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GDwrDs030185;
        Thu, 16 Jan 2020 08:58:57 -0500
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0b-00128a01.pphosted.com with ESMTP id 2xfbvbe6cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 08:58:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq5qQYFTH/qDBgqqaXfmzGLQuWNVKqQFi3xRS7vA7ML/f2W2+r05IpSMnObOTaJ+ENrxZZ2Cvn8FqK8Jk6KB2jFsHoQmPr/7zqwB+iKHuA6fmJOiHfA8WwnaPVSuCfFt++DoUEEZWHnrsGdF591rQMjntiKhXg6C1Ud/si4ifBxqEkBqHiK/2yYNo2XHnxJaQe/LGPJCBnW1TLnSDQxZXqwKVWaKIwvIj5WgK6lr9zt1I0/piTVOm7XoC2g1G9UYUY1jMjsEUlxBzQHNrSDLt2woGJ2f9bpEylqHRgumE9sC2Q0gPra/ifXUQqbPx1K8gUlrsFSo91BXCcnQdUMSwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nNen1aCrCsrx6GbO7sIyfgdfhFF6iAGuMbD4NKeEkY=;
 b=RNi+cfi14ZAb978Stuv2hexQktZQV4w7GerE0DlweQN75LsToZEBWRY6hlTKjGtSo7nP1pkisLkN5Es2Z9PkVNCIxEV3Cwh13tnom+ljIg+K/KyM8cbjeb3PiKg6f9/jyT6CK/0WkbV4Be0t1V3//SrYJ7IvcqmHIjH6PCPDQbA8GgZyV+G+WLXXwwKyF+G6/PHxJNmITGO3SS9aLzhZv9pUZBa+uQ1oEDsJmvexUQeKoNktKOez0vNyu4s6UgCFnTvJxyg3oLa4h2idf5Q948XjbMPh0CoNhmbwZtffAPVG712zK6KQrQPzirYY9da2nnnMV7Zcync3oX2IElcLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nNen1aCrCsrx6GbO7sIyfgdfhFF6iAGuMbD4NKeEkY=;
 b=ngGm8gGZarTrcGJLzuPwAU06uDCiGlNYTZsTB2FQpq1JgkNBRMcZPiaBFRz1y8Bvxo/FM8gC+uRmR8dU4u3SHeOKlqHx8cs42/uN3C5FhqbZXolVlGckdWTEuTUTaFa0hpFEqhPGB/uKEMkL1B9oAfbmn2rNoaJJ59X2HQDo76w=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5221.namprd03.prod.outlook.com (20.180.12.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 13:58:56 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39%7]) with mapi id 15.20.2644.021; Thu, 16 Jan 2020
 13:58:56 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 3/4] net: phy: adin: implement support for 1588
 start-of-packet indication
Thread-Topic: [PATCH 3/4] net: phy: adin: implement support for 1588
 start-of-packet indication
Thread-Index: AQHVzE0qb1PjEEbCPEazD7W9RZgA8aftUJEAgAABnoA=
Date:   Thu, 16 Jan 2020 13:58:55 +0000
Message-ID: <efab72f360a2043bc8cf545dcc7f24d00f3269c6.camel@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
         <20200116091454.16032-4-alexandru.ardelean@analog.com>
         <20200116135518.GF19046@lunn.ch>
In-Reply-To: <20200116135518.GF19046@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 86d72532-1f67-40e7-f159-08d79a8c3a60
x-ms-traffictypediagnostic: CH2PR03MB5221:
x-microsoft-antispam-prvs: <CH2PR03MB5221882C7E877601DEBC10F8F9360@CH2PR03MB5221.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(478600001)(66476007)(66556008)(6486002)(66446008)(4744005)(66946007)(2616005)(8676002)(81166006)(81156014)(2906002)(64756008)(86362001)(8936002)(186003)(6506007)(6916009)(54906003)(4326008)(6512007)(5660300002)(71200400001)(76116006)(36756003)(316002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5221;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zXIu/4poptrVerfN6yXGX+NRhSMBfdhGs3lQyAQ4QuqtPzAVGaRjjdtAJa3zdzr5u5/XuKLoazvq2FILJv5oGORke8f5ai+dEO6UM9kK+vyPElLjWooIPtgMhXuTvFLA+NHKRak9+O2TCoLfXDruP7x4OwZxh1CgBSfx/Vtl/RR6AMlbooyBwBHLuSFQxpt3LoJJCpY7eK3eVn5v9ip7sOJXTPyC9MEnLAHOrWFCT2eqxPZZWt8cuvJiQ+RNjbesQQMUD63p7OuvPAumMFT8nuN0FlzV4W1DcrawxLy+4f0+s46LQQELWBPDCJxPlJWIhBrRIQM/TGgYz7avgbQEeve6SWbQfFKkOynwoSqgnZFlSHKqbLI9mWjNfJ2v1lZJu7U6P10fOUfb3S8ZT0KY6BaxEfysDtq4WXd0N+wGKtxVenSVcUMiPJEu/DkWpkyK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <169DED2DD4374343B376390A43952FAE@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d72532-1f67-40e7-f159-08d79a8c3a60
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 13:58:55.9983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YYEkkOk9r0o3PphOuO6HYsUhbgChSoRG5HdCToKDJEUkqOeuvZffEI05ckUOOAPyv6DyyuL4JxA2/UzLg/rNd+/r2pMtx7UMtMS2eMwn58U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5221
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=793 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTE2IGF0IDE0OjU1ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVGh1LCBKYW4gMTYsIDIwMjAgYXQgMTE6MTQ6NTNBTSArMDIw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoZSBBRElOMTMwMCAmIEFESU4xMjAw
IFBIWXMgc3VwcG9ydCBkZXRlY3Rpb24gb2YgSUVFRSAxNTg4IHRpbWUgc3RhbXANCj4gPiBwYWNr
ZXRzLiBUaGlzIG1lY2hhbmlzbSBjYW4gYmUgdXNlZCB0byBzaWduYWwgdGhlIE1BQyB2aWEgYSBw
dWxzZS0NCj4gPiBzaWduYWwNCj4gPiB3aGVuIHRoZSBQSFkgZGV0ZWN0cyBzdWNoIGEgcGFja2V0
Lg0KPiANCj4gRG8geW91IGhhdmUgcGF0Y2hlcyBmb3IgYSBNQUMgZHJpdmVyPyBJIHdhbnQgdG8g
c2VlIGhvdyB0aGlzIGNvbm5lY3RzDQo+IHRvZ2V0aGVyLg0KDQpOb3BlLg0KDQpJIGFkbWl0IHRo
YXQgb24gdGhlIE1BQyBzaWRlLCBJJ20gbm90IHlldCBmYW1pbGlhciBob3cgdGhpcyBpcyBpbnRl
Z3JhdGVkLg0KSSdkIG5lZWQgdG8gc3R1ZHkgdGhpcyBtb3JlIGluLWRlcHRoLg0KDQo+IA0KPiAJ
VGhhbmtzDQo+IAkJQW5kcmV3CQ0K
