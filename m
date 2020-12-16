Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DCF2DBA35
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 05:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgLPEp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 23:45:58 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:36708 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLPEp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:57 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd990db0000>; Wed, 16 Dec 2020 12:45:15 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 04:45:12 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.52) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 04:45:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2uC9vG4st4GEBef+xvQ4sRMRf7l7nBoyxFQLER7IorHjPuuEnsCzYZrxZLx9XfnIE3TBIXKkoBeRkAjpv5R4Zlvlj6G3NXqf8i1LuKLgU3gcMoP8o87Ng3sQ/psHaG1S/QiRDgd9/X6dMKVlEbs6o3ms6Beh7R3CrbcbyrkIMTCzdA08AzC0A41Dz9JVkdD9UCJEiNeZmeFoQT2EjcQfrGspC51zP6mEzccIaK9y54d4jzQz0naseLApIHRriz+IMIbKMIjfRNJi/CETTmH0OzAEUANEABxPNU/GzIsdWe/Tv0invNxvqfkhWbbaGP7gr/Mvs+XukYufgs85LlCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ag7eBANEyGVc2eHdWLwXV8pAcXciXy/jIxHG88uzHA=;
 b=LB+hRGW5YWef94j+6/le1r43eFWm3vxtKk/ifSXY8JqNZex3FmiY05jxKrx9KifOX4cOaLziBfncaYQqc9SPIqlv29nqrkwnQdwr+pJpCxyTO7dSlchFb/PvjhjNqO+KuDeZ/C1HoHPmXVoTWVcilRjhBL2mHL2Ktp5mD9Uc5V1cuhFuxBc1hnyUPng7Il/1DEwz47PRSw86HSpTbbNFwPI70ipP/y3Sd7PTF3LnevreR+8JJUE7HqRIYJT/kdrGT8qM97zNMWVHZanGJJRO4kyyABxlLOn+ZmFr/Ei3WXT//KmwasfHLPOyGzu0dhAWgFCgW4pn74akXq96JTlhXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4616.namprd12.prod.outlook.com (2603:10b6:a03:a2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.19; Wed, 16 Dec
 2020 04:45:10 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 04:45:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kiran Patil" <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Topic: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Index: AQHW0mKFU48o8ZNlzEyGRue6Xkj1U6n3ZWwAgABJMwCAANkqgIAAFw4AgAASXQCAACxXAIAAIWYAgAAMc4CAABNrgIAABb3g
Date:   Wed, 16 Dec 2020 04:45:09 +0000
Message-ID: <BY5PR12MB43228933A645DFAC0CAEFE5BDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
In-Reply-To: <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77459a68-ce40-48bf-e88f-08d8a17d5e5b
x-ms-traffictypediagnostic: BYAPR12MB4616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB4616C1E92DA0138E6F0E403BDCC50@BYAPR12MB4616.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QfVdskQQpO55EK91Ye7Ijp+Di5/VilerTksPPwxpkgNKpDt81bZr40hH9EQlg7/lU8aCvnNLCncDbQLY3WrKeyr2ry1fpFy4t1XyOAxerNf5z/kthRvPqyt4x3aOD+pAYksJkV7YCTJhyqL9vQfsIiCbGWLY+zbn0YdAibSOMGtRs8t9HYsiSodyLWcxynUuCeMcT6J4Y5gMnHkerVighGj+/bcftsNkMoRrei4TYoiygk8wvSkumQdrH1HNrG1MAMs49lYZvDNq9++qH+1MYpKIhkqo7JpwFXbsXY/xKtvaqAmktye27zR+GNvho70VmRfm2wNixE3qSEybQ9dv+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39850400004)(33656002)(55016002)(316002)(86362001)(8676002)(7416002)(478600001)(6636002)(5660300002)(110136005)(52536014)(8936002)(2906002)(54906003)(26005)(9686003)(76116006)(186003)(71200400001)(64756008)(7696005)(66476007)(55236004)(4326008)(6506007)(66446008)(66946007)(66556008)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MlZDYWgwU0Z6YjV0WmxHR2paaVkrZEJPVzRZUGZIZGw4dVJpcElEQUYyYnhj?=
 =?utf-8?B?WDdyR05VOUFraE8zbU16NVoyVTM2Rk5FUU8wQVJLMGZVZ2N6OXNINEc2eHdH?=
 =?utf-8?B?aFQxVVlaOWF1emZRRnl6MVMzaFhkT253d3lxTGxzdmEzWmNzTU9pZmlpMGRt?=
 =?utf-8?B?R0crZFZFb0lnRzl1c1BZOS94UThRc0x1UXZUajVkYTJ4ZDFBaTE3cHQyVUJM?=
 =?utf-8?B?N01OTkw1RHRBdFNKYTYybExvNm1tZUdNVjAvN3V3OWhYQjVtRUpBK25XQTJC?=
 =?utf-8?B?cTJsV2pHQm45T2U0ZCswK0FPN0YwSWJ0NzBUNEU0cFNoanMybzQ5eDhQdkpL?=
 =?utf-8?B?KzdZcGtrTjNGREhsaERNUTBkdWtYa2Jib1JoSDNXek1jY2NMSkdLbCtLOXVo?=
 =?utf-8?B?ZmFLdjJYRVJEUHFDSERpS0tURVp0SGNkTGt1c1NaemxSNlJScDRpV2hWdnE1?=
 =?utf-8?B?ZmtIbUoyYUE4K29FV21Oc0llVTdmWFAzUGZDdXNsQk5YbGdMWkpTeHBMc2Ev?=
 =?utf-8?B?eW1Nc1o5Q0h6YldhT1J1WWRHTmsrMlRUQW1mZ3VDc21paGdGUHJvYUdBTm5Y?=
 =?utf-8?B?SlRSOXk2U1ZxK3pJYmdIYlRqSnFXZDU5dXI0TC84b0J1NGVrZkdLUkJGNGpF?=
 =?utf-8?B?b0hXSUFMNUtrOWthQ1FCbXZNZG1BdWltbFoyWmdnak5LZ0JLU004cjBzUUg2?=
 =?utf-8?B?dHJtcHZ3ZkpxdWFuRE1SZGxNSXp3UnQ4eSt5Rm1BNHVtZWg2bUVlNnMvdTVV?=
 =?utf-8?B?Rnh3bWpRSUpzai9vaUx2MmhZVnVMa3pMMWRFcG9WdlRXeGwzMlYyaWdDTFlv?=
 =?utf-8?B?c3RqNFBoNER3bTZVdElBa2VTOTB2cjhzSTdzZXpHTVkwRzNtcVM1ck03MnZW?=
 =?utf-8?B?V0N6NUFJUzJaYk5jWFUxS2RVMm1tNGhGcFU5RkcvMS9CVXVhMHhIczAvMDFy?=
 =?utf-8?B?QVJhMkx1ZCtaS1BCZCtFZ1Erb2tDQUYyNE5sUzhGZHJPZEszQW44TjZQL3B5?=
 =?utf-8?B?L3drN09IQjJnTy8vYXAwSDVDd1IyR3pkK05EbWJQeVZKcGNPbHpVbjB5N0Yw?=
 =?utf-8?B?NGZXK3o3bndZemswQ1BCYlBwRWdSay9hMzZDcmEra0c3UlBwWjBWa1JJZW5o?=
 =?utf-8?B?SU1zWkNqR0xVSk5aODUxbllRelRQL3hRTXJVYTJYYVZrUEI1TkNiMXhmdy9y?=
 =?utf-8?B?a1FqcURSYlZ0ZGJ5SWFDemFiVEZ1bDZhaEZoMFRvc3FGZHk2VXBQR3B2WmE3?=
 =?utf-8?B?VGM2UjVpcm1UakYraFZ0VXJkRXFKblRXczN2VnBubUlQdWR4WGhjL1AwbHNU?=
 =?utf-8?Q?OBm3tO6wOY7mc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77459a68-ce40-48bf-e88f-08d8a17d5e5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 04:45:09.7825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2x8mVKl07SwpzD71Jdc9ZwVTmKeY30JOd8QvNYcdKRnXepPLo5bOOt4kTvuXpwjotFy5CwnbaiA5dgfjyc66g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4616
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608093915; bh=4Ag7eBANEyGVc2eHdWLwXV8pAcXciXy/jIxHG88uzHA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=qgPN2UJaHyAhhpR9ii5m1cuVGnwZsASU9iPrisyYBZDCmWN5nspXsYkmIO8H/5nMG
         +yTKega7UOObckL5v4cxpeOZ48NfUbaMghAo76dMziEGXuXBnOQcvx9NfIbj3slqKs
         HkmEJZ60zJD2pAwc2Rxs3nghV+sLkbFXNDsKL1pltEEcGEiIZDiqFB8fNqHW95bAox
         qTlfQdYeNn2in3BhoxpKHvMcbKdW7+5E4ztuZ+TUFhhTC7gaT+GHiUTeqW5Aoc0+wQ
         VS2EVCMMrByKI2fbqMCJMXumbiW4M+VXjzyT7VwH9pu59JeRfosT4YYVlTy/lxoYhB
         v2YD6VAm07QLA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tPg0K
PiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDE2LCAyMDIwIDk6NDMgQU0NCj4gDQo+ID4NCj4g
PiBUaGF0IGlzIGdvYWwgaGVyZS4gVGhpcyBpcyBub3QgYWJvdXQgY3JlYXRpbmcganVzdCBhIG5l
dGRldiwgdGhpcyBpcw0KPiA+IGFib3V0IHRoZSB3aG9sZSBraXQ6IHJkbWEsIG5ldGRldiwgdmRw
YSB2aXJ0aW8tbmV0LCB2aXJ0aW8tbWRldi4NCj4gDQo+IE9uZSBpc3N1ZSBpcyByaWdodCBub3cg
d2UgYXJlIG9ubHkgc2VlaW5nIHRoZSByZG1hIGFuZCBuZXRkZXYuIEl0IGlzIGtpbmQgb2YNCj4g
YmFja3dhcmRzIGFzIGl0IGlzIHVzaW5nIHRoZSBBRElzIG9uIHRoZSBob3N0IHdoZW4gdGhpcyB3
YXMgcmVhbGx5IG1lYW50IHRvDQo+IGJlIHVzZWQgZm9yIHRoaW5ncyBsaWtlIG1kZXYuDQo+DQpt
ZGV2IGlzIGp1c3QgeWV0IGFub3RoZXIgX3VzZV8gb2Ygc3ViZnVuY3Rpb24uDQpUaGVyZSBhcmUg
dXNlcnMgb2Ygc3ViZnVuY3Rpb24gd2hvIHdhbnQgdG8gdXNlIGl0IHdpdGhvdXQgbWFwcGluZyBz
dWJmdW5jdGlvbiBhcyBtZGV2IHRvIGd1ZXN0IFZNLg0KaS5lLiBhcyBuZXRkZXYsIHJkbWEsIHZk
cGEuDQpJbiBmdXR1cmUgZGlyZWN0IGFzc2lnbm1lbnQgY2FuIGJlIHZpYSBtZGV2IG9mIHN1YmZ1
bmN0aW9uLCBsaWtlIGhvdyByZXN0IG9mIHRoZSBhYm92ZSBkZXZpY2VzIGFyZSBkb25lLg0KDQpD
cmVhdGluZyBhIHN1YmZ1bmN0aW9uIGZvciBub24gdmZpbyBwdXJwb3NlIHZpYSB2ZmlvIG1kZXYg
aXMganVzdCBub3QgcmlnaHQuDQpJZiBJIHVuZGVyc3RhbmQgeW91IGNvcnJlY3RseSwgSSBob3Bl
IHlvdSBhcmUgbm90IHN1Z2dlc3RpbmcgdGhhdC4NCg==
