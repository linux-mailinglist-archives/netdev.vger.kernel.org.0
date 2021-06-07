Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C5E39E006
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFGPOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:14:31 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:61536
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230237AbhFGPO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 11:14:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/y8Tlfnk/qCRl2ye0Ic6kB1edi8vdBpBAyzYPDLzxChUojGhaRTwUby8XmX9/Ww7XE/VzmxNZnHD7W+a4oriLK0T9+lsLclqFgLE2C2grIkc8YBjodEAhQJcXUAd1mLsw7GH3MlEdQLOHrktB8vLwku2EzMSPBdgcr5og6bumK4WmADFDmtKHzb8iANc5ThIoLj7YNLjYfEBTIbjtvcqpOxnuspS48Q/YD9u50+RonfDR06g5KTehzS1YcX1jKeVF8Wo81EOaxeWTjyThWfADSEah0t+EJSZMTrdAmuJJfpbwajchNb3JgjljjZLZnSsp55W2B+m60fwhr574Nbbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cd4i2M0EzHsx/HSZK/T1Vw7qahzk5thfhMIzWv6PL5w=;
 b=au+LKerkdr/TVJs5LtYNztm0aMKBsLk950kQyhDIMtIpYUCCTTJzqX4CbHoO0LHx4aMxWocpyuO5wXWja/Q1mTSq28Dpaq6qgCXkG8QKYhUDZvczNQ1NKuOTQfKhWRBTL/nsTs1xdIszV1G1xRjzsq0M8cJazY+AmJY9lz7DNxPimNz7YhphonrXwXaqLUacLfENPHYcRhyPrjl1WLZp/t1QZqbdSACt9fNFHNPfh0CKdxfsexkyaCClQEw+FSBiWXMUO160nWAzH4ILfkKRGLDkEHW9Rlo2R8Wrn6ULc7H/Qqe/DJ20FI296hsJ+XXElkim9ngv9+Mi9zk5GE+aOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cd4i2M0EzHsx/HSZK/T1Vw7qahzk5thfhMIzWv6PL5w=;
 b=OqkSaM0XzrGJ83js8wbNSapXDDWVBbd70bAlMwW4ABCBz5fsfCEssbQWmo+e3gnvy9nyWDejq9bKA2nQpJCXBhLgAwRvd6tVgDN0wZ8I8YPfhTfyvix0BqRSPzi3irV2EoNLqXdQF/2QhQ4xLopQsdhTeHzq7N73qb5+fISXaOg9351C0Wbp8jZEr9yMiz43n6mCUPi0H4HBVxPZXl4IZD4FdQ+YQFGjeiptBkLMn/0ixnbDNGr+DN16DZu5CiCuWBfsXrzT2uqkQTYKGxwSWRSjInx0VEd26fcXs3mIYHzSRGNiFW6zg96AQZ4vxYMv4nLrmsupSz6EdNUavFRt8w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 15:12:36 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 15:12:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Topic: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Index: AQHXWGpNwXhSEOm/yUu2yThJsUjGQKsH4bwAgACRO4CAADKKgIAABmLA
Date:   Mon, 7 Jun 2021 15:12:36 +0000
Message-ID: <PH0PR12MB54813150C3567170590BE36DDC389@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
 <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <d41a4e6c-0669-0b6c-5a2d-af1f3e5ae3bd@gmail.com>
In-Reply-To: <d41a4e6c-0669-0b6c-5a2d-af1f3e5ae3bd@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.218.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 408e73e7-d489-40a4-92f2-08d929c6aec0
x-ms-traffictypediagnostic: PH0PR12MB5401:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5401FB7E9FA2C33641BF7293DC389@PH0PR12MB5401.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1kED6S+vBou+G3lBJdMYAHmC/p824E91O3kV920JzjlPoVKMraNyWP/8QGOgUhjwmG5PEGXKZHZ4zR80IVFzCGFARVq0o7cRDQChEBpCrEDWva+41vEMZJyq9K6nhl7eQ1DtW8IN/zl5coHJ6r9KJm2LIricqPuRAb10K8PceO15DYVFTZOxZvb7rIe14tWd0ytdYXxyNIaUJN6xJ3RLviEsm6/u8xjvk/mwQrJ5s0tCUEajq7ji0cb01qY5hFyVP8/WW+g3t/pKHSSTgRiJnE0wu8S4ocQAFrvSCHlYimBmEYQk/ygIbbS7D8jCOAQt50N3iM+N5uMa5exxTgGoz4hwd6DPWEbtBqpUJCc4FzQOpcTFgHL58wCLT/j4DfpipufSEyQfpRXymmbmrGuc88c863FM4RYuTLFCJ+0SuLfPBbDdzg3GqMHtSfLfYSy1C0/QQvT6QPMB2GL3CVZfI+b3dlF+EmYU1NC/62H5Me2h/s9ZUx7dSQjCC4zs0nHO8Gk7xl7MqGRLHRElnA+wM2yIDwXLlAi6LdzBjBchMwtDl05T9P9CWvuVMnfPh+IgPEIDSIw8bx0nXsSIzz1qCP2YZs4FFVVch4uxjj3SS6GIQHkRtUHmQjHFZBgEBm07uu7AoT3ObamBW2QqfnkYqc7GdbTz2CKVuCTuuJNXM06S/oSAf5Fd1PvTkwBZIYA//Me76yAEolAK2wy+GOz0G3ZbVeyV/vXqp8fpDVc2+TY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(7696005)(64756008)(71200400001)(107886003)(186003)(66476007)(26005)(66446008)(86362001)(316002)(38100700002)(5660300002)(33656002)(66946007)(76116006)(6506007)(55236004)(110136005)(53546011)(2906002)(478600001)(55016002)(9686003)(83380400001)(8936002)(8676002)(966005)(122000001)(52536014)(66556008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Ti85SnFDK3FPM0o4QnBBR1RrRXZMcjZOV0pKcWsxcGJLelE4bnhsaFJvSVNC?=
 =?utf-8?B?TWkxeEl4dDZCenNCTHpDT3RyeDdhQVNvdnJBcE9aZ0Ryc2FaQmIrakswTWFG?=
 =?utf-8?B?VVVTWUV2aTRkbVc1UUREM0Q0Q0NzTUpSQ0lsRjYrMHozMFB4UVJydXJnR0VP?=
 =?utf-8?B?eHZMQ1YrODlZWVNSemRVTWtDVm9PK1RXWlFQUE1YMUh3MWJIUGlyYU5QbEhR?=
 =?utf-8?B?RTc1M0FDYUI0NnpONHNseXhFY0YrS0ZEcmc0STBUWE42RUQxTWhBU2hTZHBL?=
 =?utf-8?B?VnYvb2tzamhGUE5nTHhKQXpuYU82dWpRR0dseFg1Z0E3eUFDUk1KamgrazBG?=
 =?utf-8?B?VXlBd2Z5NGQvV0F5RVFPT29NNVNaQzN1L3hHZ2Y0Y1JTaFhoOS9ieE1pd2dX?=
 =?utf-8?B?YVkzdXV0V3Zoa1cyc2VUWW9VbXVqUmNLUG40cEdEM3RxcWRZMkhSalY1RWhJ?=
 =?utf-8?B?b1gwMy9TK09UeCtoN2kyOTY4QjVJMFM5ZG9OOUxZb3l1TnoyMm01SlVSRmVH?=
 =?utf-8?B?T3Z6a2liS1B1emZTdHU1V1k0V1ZHYXhGT2dJS0lDOUI5LzE3dmZGaHlPM3dG?=
 =?utf-8?B?dXhkdWp5SVJodDB4bGozK2NDRFBFZllwRkFHaDZkZVZQWVoyMXdhakYxNmJH?=
 =?utf-8?B?MnFoVHpNeW8yNVRrWTRiODhIdTdUOEluTzd0cnBjWkM5TkVYL2p1U3Nacjkr?=
 =?utf-8?B?dVpITU4wMllrOHZoSEg0d1FtaXk2bEZOSXFFRGJGcjMzem1VZFdCV2pxWXVj?=
 =?utf-8?B?bEsvMC9HT29rdEhEcy9UVzdOUlI1QWY4UDduRjBVZlh4SDRNSmFjbmNIT2Jk?=
 =?utf-8?B?dEdYYVJMSm10VmlJSEl3eFBXYXhQTFozQmtwanJYVUtZNlUzUDdmeEI1M3dQ?=
 =?utf-8?B?NjR2Z3pvaXQxRHZlaVJjSEQ2OTc2ZkNmY0NCc0Fxc3docUd3cDZKbm9rRzFS?=
 =?utf-8?B?V2ZzUGR3QVdUUjBmVjViczFiTjhxckFoOStnVURhVjNvVVdOUTJFc2FLYmhw?=
 =?utf-8?B?WWtGZUZmSUZwb0V1RzBjMWNmRzYzaVlNbmJMV1B2UVlJaVBUL0JFVWVreXk1?=
 =?utf-8?B?dTJJK0lXL0UraDlEN04zY0V3Y3doZk83eC9QUTNTaEhKQTMzcW5uNm44YmV2?=
 =?utf-8?B?OEFLR0kzZTcrV0pWWU5CKzhhdXdNYytqaVJKayt6RFRBVXpad1lKeUYrMkpX?=
 =?utf-8?B?Y04xM1lWRmh2SVd5Y3cxa2E3azZkVlRidFFXdm9PZVRlU3JEV3Y0Z05pUXEw?=
 =?utf-8?B?UGdhYldzT012UDFkQVZWdzM5MkpKK2NEK1laUjIzM2JHZm9uV2FvRHd5dm13?=
 =?utf-8?B?KzRPRXRUbEoxL2ZqNlNEd0dNTWFJQzNiWnBFdGxSNzN6eUxSTHE0cnpQVTk4?=
 =?utf-8?B?dCtQTkttekpRMHZiZ3NlQmlnQ0NUbFFDZjlqRXYzZC9LRWNnNTZJaXY1OERZ?=
 =?utf-8?B?NmdFbGk1bDZqQjRUdW52c1ZnbEZSdkwyNmtKSkQybXJKVCtkSzZKUTA5Umhu?=
 =?utf-8?B?RVp0Q3FNcCtncFZTVkhqK3dHOUlXYmd5c3ZMSWJ3cVlEeGp1bDkxQnZ6dks4?=
 =?utf-8?B?cHJYUk5jaURwTnV4bkZTRExKSVRtdC9OZ2dnUDFidCs5VWt2ejhHQzlBZ2pB?=
 =?utf-8?B?L25saGM3K0dFLzBGVW40MFVScDZoTDdGM2U3a0JlZCtpZVRiWGVCcU9keGNj?=
 =?utf-8?B?alJKbmd0WG9lQXVGeTRucm00cGJiNWgzbTdTRldKSHU5S3U2UVhNSXRtNXBG?=
 =?utf-8?Q?3Dst9swAKG6hFUPUg4+08q+WcJZ7hUoFws4MUf/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408e73e7-d489-40a4-92f2-08d929c6aec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 15:12:36.0341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APGleEkO4wJhE7F/IAgWpn5YD4eFY9Y2ka7lfGBtszrHtaYOBR2wV5fl3kgOflhL4aEiaAqPee6VduV1YrHwQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBNb25k
YXksIEp1bmUgNywgMjAyMSA4OjExIFBNDQo+IA0KPiBPbiA2LzcvMjEgNTo0MyBBTSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+IEhpIERhdmlkLA0KPiA+DQo+ID4+IEZyb206IERhdmlkIEFoZXJu
IDxkc2FoZXJuQGdtYWlsLmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBKdW5lIDcsIDIwMjEgODoz
MSBBTQ0KPiA+Pg0KPiA+PiBPbiA2LzMvMjEgNToxOSBBTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0K
PiA+Pj4gQEAgLTM3OTUsNyArMzgwNiw3IEBAIHN0YXRpYyB2b2lkIGNtZF9wb3J0X2hlbHAodm9p
ZCkNCj4gPj4+ICAJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IHBhcmFtIHNldCBERVYvUE9S
VF9JTkRFWCBuYW1lDQo+ID4+IFBBUkFNRVRFUiB2YWx1ZSBWQUxVRSBjbW9kZSB7IHBlcm1hbmVu
dCB8IGRyaXZlcmluaXQgfCBydW50aW1lIH1cbiIpOw0KPiA+Pj4gIAlwcl9lcnIoIiAgICAgICBk
ZXZsaW5rIHBvcnQgcGFyYW0gc2hvdyBbREVWL1BPUlRfSU5ERVggbmFtZQ0KPiA+PiBQQVJBTUVU
RVJdXG4iKTsNCj4gPj4+ICAJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGhlYWx0aCBzaG93
IFsgREVWL1BPUlRfSU5ERVggcmVwb3J0ZXINCj4gPj4gUkVQT1JURVJfTkFNRSBdXG4iKTsNCj4g
Pj4+IC0JcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGFkZCBERVYvUE9SVF9JTkRFWCBmbGF2
b3VyIEZMQVZPVVINCj4gPj4gcGZudW0gUEZOVU0gWyBzZm51bSBTRk5VTSBdXG4iKTsNCj4gPj4+
ICsJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGFkZCBERVYvUE9SVF9JTkRFWCBmbGF2b3Vy
IEZMQVZPVVINCj4gPj4gcGZudW0gUEZOVU0gWyBzZm51bSBTRk5VTSBdIFsgY29udHJvbGxlciBD
TlVNIF1cbiIpOw0KPiA+Pj4gIAlwcl9lcnIoIiAgICAgICBkZXZsaW5rIHBvcnQgZGVsIERFVi9Q
T1JUX0lOREVYXG4iKTsNCj4gPj4+ICB9DQo+ID4+Pg0KPiA+Pj4gQEAgLTQzMjQsNyArNDMzNSw3
IEBAIHN0YXRpYyBpbnQgX19jbWRfaGVhbHRoX3Nob3coc3RydWN0IGRsICpkbCwNCj4gPj4+IGJv
b2wgc2hvd19kZXZpY2UsIGJvb2wgc2hvd19wb3J0KTsNCj4gPj4+DQo+ID4+PiAgc3RhdGljIHZv
aWQgY21kX3BvcnRfYWRkX2hlbHAodm9pZCkgIHsNCj4gPj4+IC0JcHJfZXJyKCIgICAgICAgZGV2
bGluayBwb3J0IGFkZCB7IERFViB8IERFVi9QT1JUX0lOREVYIH0gZmxhdm91cg0KPiA+PiBGTEFW
T1VSIHBmbnVtIFBGTlVNIFsgc2ZudW0gU0ZOVU0gXVxuIik7DQo+ID4+PiArCXByX2VycigiICAg
ICAgIGRldmxpbmsgcG9ydCBhZGQgeyBERVYgfCBERVYvUE9SVF9JTkRFWCB9IGZsYXZvdXINCj4g
Pj4gRkxBVk9VUiBwZm51bSBQRk5VTSBbIHNmbnVtIFNGTlVNIF0gWyBjb250cm9sbGVyIENOVU0g
XVxuIik7DQo+ID4+DQo+ID4+IFRoaXMgbGluZSBhbmQgdGhlIG9uZSBhYm92ZSBuZWVkIHRvIGJl
IHdyYXBwZWQuIFRoaXMgYWRkaXRpb24gcHV0cyBpdA0KPiA+PiB3ZWxsIGludG8gdGhlIDkwcy4N
Cj4gPj4NCj4gPiBJdOKAmXMgYSBwcmludCBtZXNzYWdlLg0KPiA+IEkgd2FzIGZvbGxvd2luZyBj
b2Rpbmcgc3R5bGUgb2YgWzFdIHRoYXQgc2F5cyAiSG93ZXZlciwgbmV2ZXIgYnJlYWsgdXNlci0N
Cj4gdmlzaWJsZSBzdHJpbmdzIHN1Y2ggYXMgcHJpbnRrIG1lc3NhZ2VzIGJlY2F1c2UgdGhhdCBi
cmVha3MgdGhlIGFiaWxpdHkgdG8gZ3JlcA0KPiBmb3IgdGhlbS4iLg0KPiA+IFJlY2VudCBjb2Rl
IG9mIGRjYl9ldHMuYyBoYXMgc2ltaWxhciBsb25nIHN0cmluZyBpbiBwcmludC4gU28gSSBkaWRu
J3Qgd3JhcCBpdC4NCj4gDQo+IEkgbWlzc2VkIHRoYXQgd2hlbiByZXZpZXdpbmcgdGhlIGRjYiBj
b21tYW5kIHRoZW4uDQo+IA0KPiA+IFNob3VsZCB3ZSB3YXJwIGl0Pw0KPiA+DQo+ID4gWzFdDQo+
ID4gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvcHJvY2Vzcy9jb2Rpbmct
c3R5bGUuaHRtbCNicmVhaw0KPiA+IGluZy1sb25nLWxpbmVzLWFuZC1zdHJpbmdzDQo+ID4NCj4g
DQo+IFsxXSBpcyByZWZlcnJpbmcgdG8gbWVzc2FnZXMgZnJvbSBrZXJuZWwgY29kZSwgYW5kIEkg
YWdyZWUgd2l0aCB0aGF0IHN0eWxlLiBUaGlzDQo+IGlzIGhlbHAgbWVzc2FnZSBmcm9tIGlwcm91
dGUyLiBJIHRlbmQgdG8ga2VlcCBteSB0ZXJtaW5hbCB3aWR0aHMgYmV0d2Vlbg0KPiA4MCBhbmQg
OTAgY29sdW1ucywgc28gdGhlIGxvbmcgaGVscCBsaW5lcyBmcm9tIGNvbW1hbmRzIGFyZSBub3Qg
dmVyeQ0KPiBmcmllbmRseSBjYXVzaW5nIG1lIHRvIHJlc2l6ZSB0aGUgdGVybWluYWwuDQpJIHNl
ZS4gU28gZG8geW91IHJlY29tbWVuZCBzcGxpdHRpbmcgdGhlIHByaW50IG1lc3NhZ2U/DQpJIHBl
cnNvbmFsbHkgZmVlbCBlYXNpZXIgdG8gZm9sbG93IGtlcm5lbCBjb2Rpbmcgc3RhbmRhcmQgYXMg
bXVjaCBwb3NzaWJsZSBpbiBzcGlyaXQgb2YgImdyZXAgdGhlbSIuIPCfmIoNCkJ1dCBpdHMgcmVh
bGx5IHVwIHRvIHlvdS4gUGxlYXNlIGxldCBtZSBrbm93Lg0K
