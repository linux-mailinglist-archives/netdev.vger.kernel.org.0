Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1E3F8D89
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhHZSF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:05:29 -0400
Received: from mail-eopbgr60133.outbound.protection.outlook.com ([40.107.6.133]:30151
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231648AbhHZSF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 14:05:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFPt7LOK4VY8Mb88EXs4bGgea55V/qTeJIcgOnWvCpeSEPcNwi1afXNlMM73raypYqJLlk/tQX8gsSIhpLP40aFCgog6gOk1XTe/CdlsauZxRK6SJ0I5QDosvhkp9Gu7t80uJf5W9zZmKffQFj94cDxKj4wgjkGv2oorAgArfp/Z1EF3xAVEAtjcKreUQFpXtRk0dMIM3ZzQ/kfCtQibsVMsHacefANt7hDjvhnMMva6SyJPMgKsF4mCB7h9LfTKm5xWHCgD10lbJlBRNUSrDMQGm7VBWYrv+QBFparkY2SWoje5ml6z+eC/D0kvP38KylnQBDUQ3mJP3OojncnDBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3PFIvZ9O4FjTir9X2y6wXXpzzIdQSqFg4ZLAc0pfNY=;
 b=Cx82gv4yUcAxal+/jnwBdGnQeF2O8KkVD8y9fOZeIq+xZOoFHkf+x168N58mfrbc7W3l0dNMt67Dh87etzAePGLUDcWoTUFOv9QXcRmzl6JQ84BQOQmZEXto+6Hl2o4x3X09cE3jbgk+yPBJcTyfWdAOh9TRmYtcu+pgD6Quc8iNnAIRw1oHuJFVfGr4roksTM5bemehKja9Lr4/as5hhYfCAgxLDBxOedqCsYPRTsqlB8ijseuzhnnDbSvYH1y5u/3olYj1jTJImFeEr7SKVV53AB43DZ1GucHXJhNHlzZShx4fkiMEb/m2l2ScIk73jW65uwdQsl7MVBuhF8YxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3PFIvZ9O4FjTir9X2y6wXXpzzIdQSqFg4ZLAc0pfNY=;
 b=UAL8v0rLdNmv5Q0cfnAkImo0JZHJOMKkYQDSr9oUQEcEc3dFI2mP4DUiJUqzEW9vM5BMI6+xIuMq8jNnqOsp9nOuvAurmLXFu3+wOaP40543mfDLb/vpxCTu/i8w4+9nsMgWF5qADDuzhFquk2CyV6jjfSgZA+KBKSHe0HE3SBY=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2490.eurprd03.prod.outlook.com (2603:10a6:3:68::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.17; Thu, 26 Aug 2021 18:04:35 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 18:04:35 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Saravana Kannan <saravanak@google.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with
 fw_devlink=on
Thread-Topic: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with
 fw_devlink=on
Thread-Index: AQHXmk5diAXgYO5EfEucUEByv4+R3KuFpoQAgABjxgCAAAq/AA==
Date:   Thu, 26 Aug 2021 18:04:34 +0000
Message-ID: <90623032-7012-d82b-2046-d9796727e53c@bang-olufsen.dk>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-3-saravanak@google.com>
 <455824c8-51bf-9517-98fd-1f6b2a21261d@bang-olufsen.dk>
 <CAGETcx8yhH8o791=DNP3kUAqY+3xyH-Mem717hADqak==qpUtw@mail.gmail.com>
In-Reply-To: <CAGETcx8yhH8o791=DNP3kUAqY+3xyH-Mem717hADqak==qpUtw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e17afc44-c8dd-4b38-0c7a-08d968bbf654
x-ms-traffictypediagnostic: HE1PR0301MB2490:
x-microsoft-antispam-prvs: <HE1PR0301MB2490CD6E41EA009DA6AE599283C79@HE1PR0301MB2490.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Co3w/si4GTYX5DYDhPGDiAkDLSIbbg/O+I6FlO4F2ON84IDY2S4CTeoLSReyiOi5BtV2d5vPVLfd01zWEj5NIO57J+FEmfEdJZri6aEJx4BJz4Zq9BE08u6hendHmlBX0f63qJg9AdL8WnR52Q9IX2+9ookSVwa4wspDT+cKtiTtYckBCN6ngC1Umh1I6O06djB/YL0zA3T36GjQTSnnpIhCVhPZXj/5+kr6y+tw/51L/P2JKMXImzKb+dFeu4mruXaF/9U7LYFKajQk4PvWHMEWSIEh2INOoYLcc4GA+VWNfgXrv1zbVlzoCYJASgtmfPUknJNolxVhNVQn4scVPEb1b77lz4+Wm075xM9gblMPvuXfyZu04SC2N1sYXCGG6w7RHsFuv52US3osHTQoGQMHbsXsLLwLINZT9EaZpJdEzHTbPPoM3C/iSviwCxXUhoFkkZrgCaUIV69y3KsD70Yd/qjvzglm4CEUgCJdWWj1p8yycT25ifZsliFvGLGzKeh3WsVR1gEzP10ClQrKEjYaTh57Ki3PU5c/GF1GIPAv3aam+Fjub3TfgZNBoKt9Iu5p/u3hqC2z3zM5AKkvnzNAJXXY1/l0KqW8nVBeEmiWOWxbzoKP2y/+n1qF+W0Aw7oI2EVKoMzSVQFFHmBpLYRoDJFgiDAxD/mfe5LsUIvrk2B/tLXevOcfYGAoBrs7knNWRy44XhTBNVDh2jxpwUj0sWauxE8vjC8uk67YvwOp19x5SKVHE2qb7MhJy3jclzsHLrY8SByEi4lrHf2tOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39840400004)(376002)(346002)(6486002)(316002)(5660300002)(31686004)(38100700002)(85182001)(186003)(122000001)(478600001)(31696002)(6512007)(86362001)(2906002)(66574015)(71200400001)(6506007)(85202003)(53546011)(6916009)(38070700005)(8976002)(7416002)(26005)(8676002)(66476007)(4326008)(76116006)(54906003)(66946007)(91956017)(2616005)(8936002)(66446008)(36756003)(64756008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3cwZjZjL2pIWEFHNmR0eXB4N1VmN0Z2Z043YnovMHAyTkY1eEVnR3liaEln?=
 =?utf-8?B?SDhqWkdPNXlLNGdQWlM5aWdTb1pQNGpyQ0ZML0Fxank0eEU0d21zRDljOTBi?=
 =?utf-8?B?VjdidnFRSEJXeDI0WWZuTWtXRG5YYVlRcnNJdVdkMUtHYmpZYXpSeDJselNu?=
 =?utf-8?B?NHBENzk5b0ZKV3d0d09xZDQvZkRNaTc4Wk9vdTVwQ3NVdVRvVDRVTEFxNE52?=
 =?utf-8?B?YjVvM29ObmlLUVY5K21rMmg2VmlTTlJjTmoyZFVZTHc5SmJYWDJCSnk2eWsy?=
 =?utf-8?B?YjlHZTEwRjk1WjdkMnVqcDVraFc2TURjYVdaS0FhRXp4bjVyZjlJZ0RmZ3hP?=
 =?utf-8?B?TVJoMndQUDN1UTNURVZlWVRMRFlYZm16eVl4V2UycmZMZEJ2clVjRzlaeTlq?=
 =?utf-8?B?WFhGRnBYZUdSMzNKYmk1VWxUWERpZXgvZ0NXRlptVUczWDRWR3Z0S21zbGc3?=
 =?utf-8?B?UEVabUtLNXhaejVLNmNRTEVzaFloUEIvUUxSUEN4YWlyN0JnMmxNeHIveTdw?=
 =?utf-8?B?SFVQVGtVc2l3T0s1MHdwOHRwZTdyTDVQcE90YUxKajBYc2RSSE5SYjc4S2Ex?=
 =?utf-8?B?cCt2NXR3NzJsNEY0bzJKemtUSHFKODdwU1J0elR3b3lHMlpNUHdYTDBmSnhv?=
 =?utf-8?B?Tll1Skt5SUhSVWdLSERjc1hvNEJDUGpDZ3Fta2VCK3hUOFJuUWg3cWlEam5p?=
 =?utf-8?B?YUk1YzJ0K0hiZEY2QW1kSTVYVGNvM2NWemFISzU2VGJ3aEFna0I3REttUFUw?=
 =?utf-8?B?ZGh6NkRLd3AzZmV2QWFQNWtVM2J1TktXaTBCUVJHUVFTSURuWktoM0FNRENY?=
 =?utf-8?B?dVk0WHNrUXFid1RUTld0czkxQjJ5UmdDd1M0Yk12Z1NOaWhLYmVZWDFiVHk3?=
 =?utf-8?B?eGE1UWEweHAwa2hhYXBTUDhiZmdDVXdnV0tJTElKYTdQeG9vUnhWbFZsSjV5?=
 =?utf-8?B?NDBZY2xJRlhuQkJxM1djY1FqTms1SWlxWmRhRW02K0s4THBrZ3pBQTZINjh5?=
 =?utf-8?B?VnIrUEQ0dnBzRXRla0U4Z3BIaVJmcUtxYnNHcXcyMitsY0RRUnRqajV6Zjli?=
 =?utf-8?B?QkNENGtXbkRYSEJJMERwMnJab1hUQlMzNWR5K3JtZzV5UHh1ZlZQMFpQdzNL?=
 =?utf-8?B?Y1NCQWg4MWhFRGthQnJOaEVhbjVtV1BrUmw0c3RKdVE4djF4S1Ixc1hzbmky?=
 =?utf-8?B?b1pKTmZoc3N1QXMwOGpLNXZmWkQxTFhVQVJwOHFKNkpwWGEwdWtNN0o1cHM1?=
 =?utf-8?B?b1FwL0NGcVlQc0lKUmEvdFNrZCttS1JybjV1MGR0RGJscUxsYTFBeUZzajZo?=
 =?utf-8?B?d1ZpMWNjY1VWTmJWVGd0dk1zTE5uY0R5eCsvdG1BcW00Qm5XNlVwdmZwTFR0?=
 =?utf-8?B?bDBZRUF0VHpEQXpPLzRpbGtnTzQ5OVJvUkYyeEJEb3lHa21mSHFuTVF3Nzlv?=
 =?utf-8?B?dENjZmkvdHMzRVN3MU43ek1ySk5UdFF0WGsxYXMwMVZkZC9KN1lWVkl6QlZ5?=
 =?utf-8?B?N0hVb1Awa2wrRHhFYURpZkNQb1NVNXdiWklCK3FvRHNTTkt4d0RjZHM5YmQ0?=
 =?utf-8?B?UTB5d2dyRHpNT05vZG5IbDNIbmFjQlJGbnZkcmxjemZpOEJtdVo1TjBTdzlL?=
 =?utf-8?B?MkU3ZnU2cmZMVkdsMDBOcStuTERVY0dlNTg3NjA4M0VLSUl2MDFlUUdNSXor?=
 =?utf-8?B?S1QvSVhCQWQzMzYyWjA2TXBYVGQvKy9KUExPbHpOWVBrZTRqSFlsbTZWL2Rm?=
 =?utf-8?Q?mNaN5qBWtPTGLPQDDC8tmiOwHJiutdsp0lBhSML?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7A82FEAB874A744B1EFA687CB937985@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17afc44-c8dd-4b38-0c7a-08d968bbf654
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 18:04:34.9013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EAfeLZZG+EMtzhluw9JQDXLttMl3SpTMVz9Wtp4IL+iNa/gvyOVbyqThfI5zUGswuv8Tz/wGLD8k8A8+F6PDlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2490
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yNi8yMSA3OjI2IFBNLCBTYXJhdmFuYSBLYW5uYW4gd3JvdGU6DQo+IE9uIFRodSwgQXVn
IDI2LCAyMDIxIGF0IDQ6MjkgQU0gQWx2aW4gxaBpcHJhZ2EgPEFMU0lAYmFuZy1vbHVmc2VuLmRr
PiB3cm90ZToNCj4+DQo+PiBIaSBTYXJhdmFuYSwNCj4+DQo+PiAgIEZyb20gbG9va2luZyBhdCB0
aGUgY29kZSwgdGhlIE1hcnZlbGwgRFNBIGRyaXZlciBtdjg4ZTZ4eHggbWF5IGFsc28NCj4+IHN1
ZmZlciBmcm9tIHRoZSBzYW1lIHByb2JsZW0gaWYgZndfZGV2bGluaz1vbi4gTWF5YmUgc29tZWJv
ZHkgKEFuZHJldz8pDQo+PiBjb3VsZCB0ZXN0IHNvIHRoYXQgeW91IGtub3cgd2hldGhlciBpbmNs
dWRlIGEgc2ltbGFyIHBhdGNoIHRvIHRoYXQNCj4+IGRyaXZlciBpbiB5b3VyIHNlcmllcy4NCj4+
DQo+PiBPdGhlciBkcml2ZXJzIG1heSBiZSBlZmZlY3RlZCB0b28gLSBhcyBBbmRyZXcgc2FpZCBp
biB0aGUgb3RoZXIgdGhyZWFkLA0KPj4gdGhpcyBpcyBub3QgYW4gdW5jb21tb24gcGF0dGVybiBm
b3IgRFNBIGRyaXZlcnMuDQo+Pg0KPj4gT24gOC8yNi8yMSA5OjQ1IEFNLCBTYXJhdmFuYSBLYW5u
YW4gd3JvdGU6DQo+Pj4gVGhpcyBpcyBqdXN0IGEgcXVpY2sgZml4IHRvIG1ha2UgdGhpcyBkcml2
ZXIgd29yayB3aXRoIGZ3X2Rldmxpbms9b24uDQo+Pj4gVGhlIHByb3BlciBmaXggbWlnaHQgbmVl
ZCBhIHNpZ25pZmljYW50IGFtb3VudCBvZiByZXdvcmsgb2YgdGhlIGRyaXZlcg0KPj4+IG9mIHRo
ZSBmcmFtZXdvcmsgdG8gdXNlIGEgY29tcG9uZW50IGRldmljZSBtb2RlbC4NCj4+Pg0KPj4+IFNp
Z25lZC1vZmYtYnk6IFNhcmF2YW5hIEthbm5hbiA8c2FyYXZhbmFrQGdvb2dsZS5jb20+DQo+Pg0K
Pj4gV2l0aCB0aGUgY2F2ZWF0IHRoYXQgaXQncyBhIHRlc3Qgd2l0aCBteSBSRkMgcnRsODM2NW1i
IHN1YmRyaXZlci4uLg0KPj4NCj4+IFRlc3RlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFu
Zy1vbHVmc2VuLmRrPg0KPiANCj4gVGhhbmtzIGZvciB0ZXN0aW5nLiBBbmQganVzdCB0byBiZSBz
dXJlIHdlIGFyZSBhbGwgb24gdGhlIHNhbWUgcGFnZToNCj4gV2l0aG91dCB0aGlzIHBhdGNoIHRo
ZSBQSFlzIGdldCBoYW5kbGVkIGJ5IHRoZSBHZW5lcmljIFBIWSBkcml2ZXIuDQo+IFdpdGggdGhp
cyBwYXRjaCwgdGhlIFBIWXMgYXJlIGhhbmRsZWQgYnkgdGhlaXIgc3BlY2lmaWMgZHJpdmVyLg0K
PiBDb3JyZWN0Pw0KDQpZZXMsIGJvdGggc3RhdGVtZW50cyBhcmUgY29ycmVjdC4NCg0KCUFsdmlu
DQoNCj4gDQo+IC1TYXJhdmFuYQ0KPiANCj4+DQo+PiBLaW5kIHJlZ2FyZHMsDQo+PiBBbHZpbg0K
Pj4NCj4+PiAtLS0NCj4+PiAgICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay1zbWktY29yZS5jIHwg
NyArKysrKysrDQo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQ0KPj4+DQo+
Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmMgYi9kcml2
ZXJzL25ldC9kc2EvcmVhbHRlay1zbWktY29yZS5jDQo+Pj4gaW5kZXggOGU0OWQ0Zjg1ZDQ4Li5m
NzljMTc0ZjQ5NTQgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWstc21p
LWNvcmUuYw0KPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmMNCj4+
PiBAQCAtMzk0LDYgKzM5NCwxMyBAQCBzdGF0aWMgaW50IHJlYWx0ZWtfc21pX3Byb2JlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+Pj4gICAgICAgIHZhciA9IG9mX2RldmljZV9nZXRf
bWF0Y2hfZGF0YShkZXYpOw0KPj4+ICAgICAgICBucCA9IGRldi0+b2Zfbm9kZTsNCj4+Pg0KPj4+
ICsgICAgIC8qIFRoaXMgZHJpdmVyIGFzc3VtZXMgdGhlIGNoaWxkIFBIWXMgd291bGQgYmUgcHJv
YmVkIHN1Y2Nlc3NmdWxseQ0KPj4+ICsgICAgICAqIGJlZm9yZSB0aGlzIGZ1bmN0aW9ucyByZXR1
cm5zLiBUaGF0J3Mgbm90IGEgdmFsaWQgYXNzdW1wdGlvbiwgYnV0DQo+Pj4gKyAgICAgICogbGV0
IGZ3X2Rldmxpbmsga25vdyBzbyB0aGF0IHRoaXMgZHJpdmVyIGNvbnRpbnVlcyB0byBmdW5jdGlv
biB3aXRoDQo+Pj4gKyAgICAgICogZndfZGV2bGluaz1vbi4NCj4+PiArICAgICAgKi8NCj4+PiAr
ICAgICBucC0+Zndub2RlLmZsYWdzIHw9IEZXTk9ERV9GTEFHX0JST0tFTl9QQVJFTlQ7DQo+Pj4g
Kw0KPj4+ICAgICAgICBzbWkgPSBkZXZtX2t6YWxsb2MoZGV2LCBzaXplb2YoKnNtaSkgKyB2YXIt
PmNoaXBfZGF0YV9zeiwgR0ZQX0tFUk5FTCk7DQo+Pj4gICAgICAgIGlmICghc21pKQ0KPj4+ICAg
ICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPj4+DQo=
