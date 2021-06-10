Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6553F3A2529
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhFJHTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:19:12 -0400
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:16960
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229634AbhFJHTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 03:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUgPbIh3N/y/iGvpLU1J5RqDuIGg3R+YzYPkdGcsqQjhhPvYTXbJfjOSE3h9vXouuq1jf11ITIs9+npjukh7Y7WNx4KU2Fbfg0LurCH37XNEI261JfTnTNKEEpray9H2Rv8g5R4bezLzGYOtHJfQyWBqQCDbG0UsBGK2hchhn3D43jdUrKoi7POfRFukI+DB036ssd2+fL09VtDpK7Ys5cCx2AnQd/PvlITbkP1219WdwkVtvAYng1197CyfJTj8cQ1dCZQnzDnYlVR35r7zee9b8ZzfGon3g5OzyMXNeU6b+bUydJ1Kvaoi+V60JbKrRPyuLO05GDdgbzGsCcAzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfUVDhKlIC0eU288su6GZ8FzGXDUSNbmUFTBx4fbKLs=;
 b=DoQbSvbIDPbvJdQAzgkZAZsCC5QhVS1M/s9N3JZfuoOed5hvYdjcWPPGPH10CRZRafyexo1FIJjP4rDcoRoYvSTAXeeSWeC31rrT5aHUbNYKeX52pSj9z3WaHzis9jnbxHCH9Mo7Wnb8j6EC4TSmpALu2OD/ozNojp/0IVYeCuvoAqH26YQGoTEZafJT6JAsCZwCq3o2AWR+Nf3twIo/ufpzVA9PU1aHYcAozr1kEoAGb+i8XC62/CsvUwrrXjipfzJ1ZdZOYHhtaiDBHgL0uTaPiiNeSiTwIKwsVIuAnl3i90Qd3u+71NISprNNAl892SARTjgex60uEPV7Il/0Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfUVDhKlIC0eU288su6GZ8FzGXDUSNbmUFTBx4fbKLs=;
 b=C7nYfnzNTy9KsUFeW6qNduAicHByayGK5J1Ex1h7duRb3gXEP+JIxy141RZ0bGDrjdoGdzgVQv1DBzmV+Bu8UtXbOgScGQfapSy2TTIEAZlWHskEayvQovS614ojudK7jfyJJsAjpFUO5139AzMUGly4zUwNYSOyl8xsRHqHe8IisoYHjRfyId/UpUYd4jFriTxyQQXoTutQ+5HPYJH+t+1qovc2rridbElUZw+9qyT/0Cw1Hy18s0gFEsZ/GwI78gcIVf84HKev9KyJY7Nj9nBqMI55JEulwPJ7j3FBniYnrmAj9igDrBMoOSj5MGoWpq2lTrPoFKJbM54pJMD3WA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5451.namprd12.prod.outlook.com (2603:10b6:510:ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 07:17:14 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb%7]) with mapi id 15.20.4219.023; Thu, 10 Jun 2021
 07:17:14 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Topic: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Index: AQHXVqgtOTo5DdccDUWHkWiFIp83jqr+w2yAgADrK4CAAFDXgIAA7Z8AgAC7xYCAAOyAgIAAfE0AgAEjb4CAA5i/AIABMJGAgAES5oCAAFkqgIABCGgAgAAEzBCAABm9gIAACjJAgAANgwCAABLRQIABJHoAgAADHAA=
Date:   Thu, 10 Jun 2021 07:17:14 +0000
Message-ID: <PH0PR12MB5481B90580C2B0791B5F138CDC359@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
 <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
 <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
 <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
 <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
 <DM8PR12MB54802CA9A47F1585DC3347A5DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <d54ae715-8634-c983-1602-8cd8dea2a5e2@huawei.com>
 <DM8PR12MB5480F577E5F02105B8C1FE9BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <acf08577-34c6-bc9e-a788-568b67fa8d2e@huawei.com>
 <DM8PR12MB5480CA5904F1242202F9D51ADC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <387c80e7-e50f-8f2f-0fea-d699902ef84e@huawei.com>
In-Reply-To: <387c80e7-e50f-8f2f-0fea-d699902ef84e@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b58b1d01-8318-4bb1-6a93-08d92bdfc5c0
x-ms-traffictypediagnostic: PH0PR12MB5451:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5451BFFE009E4D56699F59CFDC359@PH0PR12MB5451.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dGV8PFkF8dIUFM/jYF6N6yWhPRLYFh6Zx2KIANbPb97REt2YL3x9NaQt8vgHSIGOg3SkoPTyhufxKjNX5YufxhIy2X7wIF46cXH0TKV6gnqq8H1bIncPJe6Ynd2rDcka71y61swT2TFZNcfD1k3y6S9CddQyCW5ScTMums6n78Hs9Mnsrra9SBLkaYiOZahki39X5cB7RXN5nVLfHAJRhLae4j43r0GIj63BI3WGXD+km9vPV+T8TicgF7nP6z3z7mf7wUlIVgWqPW+uhGIMLiZf9juv5avgs/qnOEuVAzXHydgFPWCAS68wiUO5jxhbsfEb92xQV0Bab7SajMPh5OPiaB2MKFNEy49Lwsn8NOEUZ3aYx82xGP4IW2U79B1ybC9hERd8CiVkmvIatcbNdW18BlM07mdi19eg9oLRXNlj+ZguBYwBIkoPIBsg9VsuVHtZYTknkq0cDde2KgvKK6KUpHh1tPSsJ1cXp33drUOEjKIY90b+jKa92sQQm/XBtO0ZWd70UJ9ORFNHbKD8pyY+hD3vWG0QrEljUglci6YWpmbea8kAd7H79fDObZQjsYSBVt21X3ZsL9nHgOVp2y+45GqPeAq4uVG50rj129o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(55016002)(33656002)(8676002)(64756008)(71200400001)(478600001)(9686003)(86362001)(83380400001)(66946007)(52536014)(316002)(38100700002)(2906002)(110136005)(4326008)(5660300002)(7416002)(66446008)(53546011)(8936002)(54906003)(66556008)(7696005)(122000001)(55236004)(26005)(186003)(76116006)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RklWbFlIZEs2QUxTbzdSMkZhekpPWk9lQVpUUjJDUG5jUDlvNVhmODNLNkJC?=
 =?utf-8?B?MzZLUkI0ZzBDMzdmOGFiVzNHYm1WeTVPK3NSQS9YSnNtVmQvaGZiaHFoNkxL?=
 =?utf-8?B?eUZ6NU1jWmVBYlR1VkJQWWpZZUJkbCtsNzlsSXQ1R05uSFhQdFBhMkVDTDdJ?=
 =?utf-8?B?aTZmUGpudG9iNHY0cXp0NFl1MTBUL3hCVUxQVkhUZUNiYjduZzhOVXZLVVpP?=
 =?utf-8?B?MDFGcE8rYUxNZDhUVzd0ZXlLWEVmZERMeVY3WThMZHhMQlVUZlh5RHRLWkM4?=
 =?utf-8?B?cWg5M2hwYUpaY3h5WDJOZmw1dEJYdlhhZnZYQ1dJaTkrNVlYaWozTUJmMUFW?=
 =?utf-8?B?NTdqd0N3a1c0bHEzSWJSSzVHMDVUaUkxYjY1ak5pWmpNQnZON0d4UDJLUWZh?=
 =?utf-8?B?RE9KMk5xSTRIbkZCbytaeDdVam4vYmdrd2luSDRUcXJCeUxwekc1d0xmRVBE?=
 =?utf-8?B?ejB0bHo4WGZIcktLWmpoYmxYa2I5T2ZPWXNyMjVDT3I3czNKQURnRGF5ekRP?=
 =?utf-8?B?WVd0cXpUM1FLL0cyQWtDRWpSVjhyQ1o1c0xIbTdoZ3p5ei9IWVBLYS9QSmZs?=
 =?utf-8?B?cGh1aEZYVkpPQnFyb3BzbDQxVWF5TVZwS2xzWjF1N0k1QW5ZbmRoaktaQlY3?=
 =?utf-8?B?dnE3d1poMWhnbWVKVUNLaCsvNnZ6bmIwaXAvZjdFWk1hTjVWRXJyeThFUGpY?=
 =?utf-8?B?MjlWdGNqSWRCZTRGVjZoQmJRd1Vrcy81Mk1JemRTT1pPcjlpYXUzM3hHOXFm?=
 =?utf-8?B?WktaanZrQVlTbWZtZkxvdDlKenBPUzNQZElEem5OVU5idzkvUUxBbDNlMEQ1?=
 =?utf-8?B?WVk2N2R4VGFhUk5sMkJpNTBnVWRRUGhYMExQS3RQMXNaajRJNFN1M0U1VnNX?=
 =?utf-8?B?aUE1dk02S0FPeHdLdFdZMFVLdmJETWNiZCtKQVBSMXJjNnZqRmRYL1pJUHFx?=
 =?utf-8?B?dDdkOXhtOUt6eWFFdmlLZTVjYzR5dTd5UWh4RlJ4RU5ib3VsR3hHdGdzTHl4?=
 =?utf-8?B?UDRWTUV5SVJOaVlPN2Z2d1FJTzlpczZzUmpsTjVzRmRrYkI1YUYzK3l4TlZ5?=
 =?utf-8?B?aVVTdE95VkRpUmxOcndYTjN5UDJXN01jcWpjNno5MzBiVW9YM2pOTXJkSUc0?=
 =?utf-8?B?b3dueW54emlOSFJlSnh1TFkzcytEU3E5WE1TSWtXZEM2VWVDVkhlUkNvd3or?=
 =?utf-8?B?dlM3dzdTb0gzc29NcTRLb0RuSUJFdnE0VTFUTkszVldJbFJWOUxibUdaN3c2?=
 =?utf-8?B?Z2ZqQlRHYWoxUGQ2RUxMTFJMZGJ0NERxKzQ4RFlKL0xzU0FBUDlmek4wbGFo?=
 =?utf-8?B?ejkvTkRma0dKSFBpOWpYNXNOUlVqR3lFZnN1d1lkVzJjTXR5K0RIWXFCRm0x?=
 =?utf-8?B?Q0x4T1hqajl0dkF1UHVsRFVXd2RuN2ZNb2paWnhwcmcvNVNiSmgyV2VhRmtH?=
 =?utf-8?B?NXVQR1JualFIb3NldU9pUDFiTjFVVEh1Nnl4WTU2aVIzV2hlYjgxaUwyd3Fr?=
 =?utf-8?B?c0RDS3FVNFFYM3Y5TCtrQ2lxVVZrN0xsbzBqbWZ5emx3NFAvL2QvbHB2KzZO?=
 =?utf-8?B?OHpWSUxzWUkwYVYyR3VkMDY3MnM3ajI1MmdNclZXWmJPdzBldVdzOGJOa2hX?=
 =?utf-8?B?MSswQ3RGdlJEclpQeWVRNUtEV2hYZ1JtV1VXcXdVbmNZdkxBbmhXOFlDeUJG?=
 =?utf-8?B?VVB1VUVJWG5jL0RneGxhalVIbXgyQy9jcnh0SXpaSjFYdFFqRW9yRzczSzJ1?=
 =?utf-8?Q?bXth5b66jiC005I6Hpmitxa0fGdkxlxiCQ5g4Ih?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58b1d01-8318-4bb1-6a93-08d92bdfc5c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 07:17:14.4302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Xqbss3ZIi90nVfoyzL8MIPktwb4o+DsHsWx7L0pfz59jEuydo8HP+2aUbMv1HcrKhPNFgJoPd1Fwtb27notZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5451
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBUaHVyc2RheSwgSnVuZSAxMCwgMjAyMSAxMjozNCBQTQ0KPiANCj4gT24gMjAyMS82LzkgMjE6
NDUsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gID4+IEZyb206IFl1bnNoZW5nIExpbiA8bGlueXVu
c2hlbmdAaHVhd2VpLmNvbT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDksIDIwMjEgNjow
MCBQTQ0KPiA+Pg0KPiA+PiBPbiAyMDIxLzYvOSAxOTo1OSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0K
PiA+Pj4+IEZyb206IFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gPj4+
PiBTZW50OiBXZWRuZXNkYXksIEp1bmUgOSwgMjAyMSA0OjM1IFBNDQo+ID4+Pj4NCj4gPj4+PiBP
biAyMDIxLzYvOSAxNzozOCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+Pj4+Pg0KPiA+Pj4+Pj4g
RnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiA+Pj4+Pj4gU2Vu
dDogV2VkbmVzZGF5LCBKdW5lIDksIDIwMjEgMjo0NiBQTQ0KPiA+Pj4+Pj4NCj4gPj4+Pj4gWy4u
XQ0KPiA+Pj4+Pg0KPiA+Pj4+Pj4+PiBJcyB0aGVyZSBhbnkgcmVhc29uIHdoeSBWRiB1c2UgaXRz
IG93biBkZXZsaW5rIGluc3RhbmNlPw0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gUHJpbWFyeSB1c2Ug
Y2FzZSBmb3IgVkZzIGlzIHZpcnR1YWwgZW52aXJvbm1lbnRzIHdoZXJlIGd1ZXN0DQo+ID4+Pj4+
Pj4gaXNuJ3QgdHJ1c3RlZCwgc28gdHlpbmcgdGhlIFZGIHRvIHRoZSBtYWluIGRldmxpbmsgaW5z
dGFuY2UsDQo+ID4+Pj4+Pj4gb3ZlciB3aGljaCBndWVzdCBzaG91bGQgaGF2ZSBubyBjb250cm9s
IGlzIGNvdW50ZXIgcHJvZHVjdGl2ZS4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBUaGUgc2VjdXJpdHkg
aXMgbWFpbmx5IGFib3V0IFZGIHVzaW5nIGluIGNvbnRhaW5lciBjYXNlLCByaWdodD8NCj4gPj4+
Pj4+IEJlY2F1c2UgVkYgdXNpbmcgaW4gVk0sIGl0IGlzIGRpZmZlcmVudCBob3N0LCBpdCBtZWFu
cyBhDQo+ID4+Pj4+PiBkaWZmZXJlbnQgZGV2bGluayBpbnN0YW5jZSBmb3IgVkYsIHNvIHRoZXJl
IGlzIG5vIHNlY3VyaXR5IGlzc3VlDQo+ID4+Pj4+PiBmb3IgVkYgdXNpbmcgaW4gVk0NCj4gPj4+
PiBjYXNlPw0KPiA+Pj4+Pj4gQnV0IGl0IG1pZ2h0IG5vdCBiZSB0aGUgY2FzZSBmb3IgVkYgdXNp
bmcgaW4gY29udGFpbmVyPw0KPiA+Pj4+PiBEZXZsaW5rIGluc3RhbmNlIGhhcyBuZXQgbmFtZXNw
YWNlIGF0dGFjaGVkIHRvIGl0IGNvbnRyb2xsZWQgdXNpbmcNCj4gPj4+Pj4gZGV2bGluaw0KPiA+
Pj4+IHJlbG9hZCBjb21tYW5kLg0KPiA+Pj4+PiBTbyBhIFZGIGRldmxpbmsgaW5zdGFuY2UgY2Fu
IGJlIGFzc2lnbmVkIHRvIGEgY29udGFpbmVyL3Byb2Nlc3MNCj4gPj4+Pj4gcnVubmluZyBpbiBh
DQo+ID4+Pj4gc3BlY2lmaWMgbmV0IG5hbWVzcGFjZS4NCj4gPj4+Pj4NCj4gPj4+Pj4gJCBpcCBu
ZXRucyBhZGQgbjENCj4gPj4+Pj4gJCBkZXZsaW5rIGRldiByZWxvYWQgcGNpLzAwMDA6MDY6MDAu
NCBuZXRucyBuMQ0KPiA+Pj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xl5eXl5eXl5eXl5eXg0KPiA+Pj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgUENJIFZGL1BGL1NGLg0KPiA+Pj4+DQo+ID4+Pj4gQ291bGQgd2UgY3JlYXRlIGFub3RoZXIg
ZGV2bGluayBpbnN0YW5jZSB3aGVuIHRoZSBuZXQgbmFtZXNwYWNlIG9mDQo+ID4+Pj4gZGV2bGlu
ayBwb3J0IGluc3RhbmNlIGlzIGNoYW5nZWQ/DQo+ID4+PiBOZXQgbmFtZXNwYWNlIG9mIChhKSBu
ZXRkZXZpY2UgKGIpIHJkbWEgZGV2aWNlIChjKSBkZXZsaW5rIGluc3RhbmNlDQo+ID4+PiBjYW4g
YmUNCj4gPj4gY2hhbmdlZC4NCj4gPj4+IE5ldCBuYW1lc3BhY2Ugb2YgZGV2bGluayBwb3J0IGNh
bm5vdCBiZSBjaGFuZ2VkLg0KPiA+Pg0KPiA+PiBZZXMsIG5ldCBuYW1lc3BhY2UgaXMgY2hhbmdl
ZCBiYXNlZCBvbiB0aGUgZGV2bGluayBpbnN0YW5jZSwgbm90DQo+ID4+IGRldmxpbmsgcG9ydCBp
bnN0YW5jZSwgKnJpZ2h0IG5vdyouDQo+ID4+DQo+ID4+Pg0KPiA+Pj4+IEl0IG1heSBzZWVtcyB3
ZSBuZWVkIHRvIGNoYW5nZSB0aGUgbmV0IG5hbWVzcGFjZSBiYXNlZCBvbiBkZXZsaW5rDQo+ID4+
Pj4gcG9ydCBpbnN0YW5jZSBpbnN0ZWFkIG9mIGRldmxpbmsgaW5zdGFuY2UuDQo+ID4+Pj4gVGhp
cyB3YXkgY29udGFpbmVyIGNhc2Ugc2VlbXMgYmUgc2ltaWxpYXIgdG8gdGhlIFZNIGNhc2U/DQo+
ID4+PiBJIG1vc3RseSBkbyBub3QgdW5kZXJzdGFuZCB0aGUgdG9wb2xvZ3kgeW91IGhhdmUgaW4g
bWluZCBvciBpZiB5b3UNCj4gPj4gZXhwbGFpbmVkIHByZXZpb3VzbHkgSSBtaXNzZWQgdGhlIHRo
cmVhZC4NCj4gPj4+IEluIHlvdXIgY2FzZSB3aGF0IGlzIHRoZSBmbGF2b3VyIG9mIGEgZGV2bGlu
ayBwb3J0Pw0KPiA+Pg0KPiA+PiBmbGF2b3VyIG9mIHRoZSBkZXZsaW5rIHBvcnQgaW5zdGFuY2Ug
aXMgRkxBVk9VUl9QSFlTSUNBTCBvcg0KPiA+PiBGTEFWT1VSX1ZJUlRVQUwuDQo+ID4+DQo+ID4+
IFRoZSByZWFzb24gSSBzdWdnZXN0IHRvIGNoYW5nZSB0aGUgbmV0IG5hbWVzcGFjZSBvbiBkZXZs
aW5rIHBvcnQNCj4gPj4gaW5zdGFuY2UgaW5zdGVhZCBvZiBkZXZsaW5rIGluc3RhbmNlIGlz77ya
DQo+ID4+IEkgcHJvcG9zZWQgdGhhdCBhbGwgdGhlIFBGIGFuZCBWRiBpbiB0aGUgc2FtZSBBU0lD
IGFyZSByZWdpc3RlcmVkIHRvDQo+ID4+IHRoZSBzYW1lIGRldmxpbmsgaW5zdGFuY2UgYXMgZmxh
dm91ciBGTEFWT1VSX1BIWVNJQ0FMIG9yDQo+ID4+IEZMQVZPVVJfVklSVFVBTCB3aGVuIHRoZXJl
IGFyZSBpbiB0aGUgc2FtZSBob3N0IGFuZCBpbiB0aGUgc2FtZSBuZXQNCj4gbmFtZXNwYWNlLg0K
PiA+Pg0KPiA+PiBJZiBhIFZGJ3MgZGV2bGluayBwb3J0IGluc3RhbmNlIGlzIHVucmVnaXN0ZXJl
ZCBmcm9tIG9sZCBkZXZsaW5rDQo+ID4+IGluc3RhbmNlIGluIHRoZSBvbGQgbmV0IG5hbWVzcGFj
ZSBhbmQgcmVnaXN0ZXJlZCB0byBuZXcgZGV2bGluaw0KPiA+PiBpbnN0YW5jZSBpbiB0aGUgbmV3
IG5ldCBuYW1lc3BhY2UoY3JlYXRlIGEgbmV3IGRldmxpbmsgaW5zdGFuY2UgaWYNCj4gPj4gbmVl
ZGVkKSB3aGVuIGRldmxpbmsgcG9ydCBpbnN0YW5jZSdzIG5ldCBuYW1lc3BhY2UgaXMgY2hhbmdl
ZCwgdGhlbg0KPiA+PiB0aGUgc2VjdXJpdHkgbWVudGlvbmVkIGJ5IGpha3ViIGlzIG5vdCBhIGlz
c3VlIGFueSBtb3JlPw0KPiA+DQo+ID4gSXQgc2VlbXMgdGhhdCBkZXZsaW5rIGluc3RhbmNlIG9m
IFZGIGlzIG5vdCBuZWVkZWQgaW4geW91ciBjYXNlLCBhbmQgaWYgc28NCj4gd2hhdCBpcyB0aGUg
bW90aXZhdGlvbiB0byBldmVuIGhhdmUgVklSVFVBTCBwb3J0IGF0dGFjaCB0byB0aGUgUEY/DQo+
IA0KPiBUaGUgZGV2bGluayBpbnN0YW5jZSBpcyBtYWlubHkgdXNlZCB0byBob2xkIHRoZSBkZXZs
aW5rIHBvcnQgaW5zdGFuY2Ugb2YgVkYgaWYNCj4gdGhlcmUgaXMgb25seSBvbmUgVkYgaW4gdm0s
IHdlIG1pZ2h0IHN0aWxsIG5lZWQgdG8gaGF2ZSBwYXJhbS9oZWFsdGggc3BlY2lmaWMNCj4gdG8g
dGhlIFZGIHRvIHJlZ2lzdGVyZWQgdG8gdGhlIGRldmxpbmsgcG9ydCBpbnN0YW5jZSBvZiB0aGF0
IFZGLg0KPiANClRoaXMgd2lsbCBjb3ZlciB0aGluZ3MgdW5pZm9ybWx5IHdpdGgvd2l0aG91dCBj
b250YWluZXIgb3IgVk0uDQoNCj4gPiBJZiBvbmx5IG5ldGRldmljZSBvZiB0aGUgVkYgaXMgb2Yg
aW50ZXJlc3QsIGl0IGNhbiBiZSBhc3NpZ25lZCB0byBuZXQNCj4gbmFtZXNwYWNlIGRpcmVjdGx5
Lg0KPiANCj4gSSB0aGluayB0aGF0IGlzIGFub3RoZXIgb3B0aW9uLCBpZiB0aGVyZSBpcyBub3Ro
aW5nIGluIHRoZSBkZXZsaW5rIHBvcnQgaW5zdGFuY2UNCj4gc3BlY2lmaWMgdG8gVkYgdGhhdCBu
ZWVkIGV4cG9zaW5nIHRvIHRoZSB1c2VyIGluIGFub3RoZXIgbmV0IG5hbWVzcGFjZS4NCj4gDQpZ
ZXMuIG5vIG5lZWQgZm9yIGRldmxpbmsgaW5zdGFuY2Ugb3IgZGV2bGluayBwb3J0Lg0KDQo+ID4N
Cj4gPiBJdCBkb2VzbuKAmXQgbWFrZSBzZW5zZSB0byBtZSB0byBjcmVhdGUgbmV3IGRldmxpbmsg
aW5zdGFuY2UgaW4gbmV3IG5ldA0KPiBuYW1lc3BhY2UsIHRoYXQgYWxzbyBuZWVkcyB0byBiZSBk
ZWxldGVkIHdoZW4gbmV0IG5zIGlzIGRlbGV0ZWQuDQo+ID4gQW5kIHByZV9leGl0KCkgcm91dGlu
ZSB3aWxsIG1vc3RseSBkZWFkbG9jayBob2xkaW5nIGdsb2JhbCBkZXZsaW5rX211dGV4Lg0KPiAN
Cj4gV291bGQgeW91IGJlIG1vcmUgc3BlY2lmaWMgd2h5IHRoZXJlIGlzIGRlYWRsb2NrPw0KTmV0
IG5hbWVzcGFjZSBleGl0IHJvdXRpbmUgY2Fubm90IGludm9rZSBhIGRldmxpbmsgQVBJIHRoYXQg
ZGVtYW5kcyBhY3F1aXJpbmcgZGV2bGluayBnbG9iYWwgbXV0ZXguDQo=
