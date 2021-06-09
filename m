Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110823A139C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbhFIMB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:01:29 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:32768
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231928AbhFIMB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 08:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUGwMotCrlWCQJGbkOwpzMkONyng3AJkOlJHedoGPArgUoECARMCkeNoyE+R/FieyH/ySM7t+0b8Cfby2xFPjEV1proa23qEMEpAxL6lRtGCgssJJgyc8oBpDHRfzGI2LU+sTqOcA0wXUjDUtVVyd0AbNUaktioxEsqQxnhQMAvUPCw1HBS4FrDoRVlZT7qjKklVXr9eyYiwh3W6wFNOaAJF0LiakJ1gkEjejcs77o/nqHmNA7rWexrayfnjXxsesnJUaCk1rx1HpPP12tieanqbeqL7HjD27lvRJDVSoonVBBDBswsAQxCj01OohRvkcu+rO19Bo5uzd3I5hthSgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/wt3GfaU9hMjNoUOL5s4Lt5/W+3lRB81VlBxdqipu8=;
 b=DspGwWBB82Xbz4xCqFVHvEyTdYrQWX1bUah4Fq8X9bCXaGKwkVpMF6zHvUTKbbmp0FKklg3In2FyxA+67SDGrDRGBrw3MbxKjycA/2hLeF3AecXvUSEPwqFtG+P084lK5Sj0u6zViq2xlnMgDKcrsBzFAR3nCVoIMFdy7nYIWaB0WxovIB04dqKtmH6HGpId6PtMrlrarFD8ivAY/gJ9fxOf/6AQVp4RAfaEv3HvW1UkuWX/Ks8kUbNuEB1+gugAgxHOL0cKcNtRA/ms4D8lq04C91lI64VVylpamP8nwseQGP+me2TmSdLxi8gvGdt7rZUMlKespmVuS8lXTHfAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/wt3GfaU9hMjNoUOL5s4Lt5/W+3lRB81VlBxdqipu8=;
 b=Jd7xztzsr0V1Jpe6DcCyLzJu9+L0iAeT0l2aeFJQAvmCA0XqpiuKZVxjY97VxVATwoVDPVE50wq6JsGOkKyMMsRMunEATUIRUEiq+IuhYrQsSBI0tYehC4slbV8zR2ccIDNF+lKr6MuySrFmwyHJ1fo/g0/GOjRNEqounW4H7zIdTxUcHRYGAlEZZx+8icJjlAUghZuArIS8WPbZvBKIiUIWDcGD0puOFv9+qOJC6jxn+0fmltGmohs2nocz0YFczL/et7ipct2KxlCZ9UDev3FuYVvMhpZJFBk8agJtjMIQ+8PQs0kbaLSJJ+84naEPIZECL6XvjAuuHftzIJPWhg==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Wed, 9 Jun 2021 11:59:33 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 11:59:33 +0000
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
Thread-Index: AQHXVqgtOTo5DdccDUWHkWiFIp83jqr+w2yAgADrK4CAAFDXgIAA7Z8AgAC7xYCAAOyAgIAAfE0AgAEjb4CAA5i/AIABMJGAgAES5oCAAFkqgIABCGgAgAAEzBCAABm9gIAACjJA
Date:   Wed, 9 Jun 2021 11:59:33 +0000
Message-ID: <DM8PR12MB5480F577E5F02105B8C1FE9BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
 <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
In-Reply-To: <d54ae715-8634-c983-1602-8cd8dea2a5e2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a73b965-84fa-4d66-cd6b-08d92b3e0bc1
x-ms-traffictypediagnostic: DM4PR12MB5216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR12MB52162238A9377E1D69630901DC369@DM4PR12MB5216.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gpaVQLo2+Jrg3zRzhUb2EVTulAL3My0f6oqlOw42WF57KOTbEy7TF0vqGKw3PlIhfbmPdd1ls23bfUEQLbb9ZNaCH2u2HirrCsJULRlEFV+nWJkh6CrQmiSfgkBJB/L0YC7py30gVwER8v+5kViCjUyvRIzV51N6KjZyNIaiXfPUVVeih3J2bJ3xltu+RxY9jEFv0Y14uiJmvxYZSnBU1H8U2xwpJkPYZBfUceng3DuoD/mBA4z1yAdpsZ073Y3Iofwspz8s/Z7w1TcMPtxgbe7ctry01OpAvrdDcjdbeP3gQmHEmruv/cze5ExbYZ3AigG5EWBp2ME/+BBR24MTXH45LfaCKaPsPRN3ScsSiY445ycjTC/joB7m4TtZ72TtET2aYVOa/50R4vvfsyywSVMbvWpClI5RtRcwnJirUaHIzVXfE4MeuFg/5tROKSYKxGc9G1X1dn3OgxWrPs2X8RIrVfYVNr3R+1IsM74cw6AfGgqn7JOdIo1J3cy1I0CVzoro061Q1kKKzqVeTbZ/ztYgqyEu0i3dNNmyHJjtHj09Pq1E7QRcwVptt5qu1JLw/cYRhx5V2vCFsPFNKGiO6zj+ui92ygphIHaYhcPS95OJjrGH4kwq6LRr7bcryQFTMXreOGae+9fd6DcUwiYHdVWLyprgjD38Zh7Jcp3Ppt1MgeqNvg+Bv2YVEeJcRTru1HAr3bj3Z31pN/dZBB95IT7gp5D1jX3otIVjBsGgfzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(66556008)(86362001)(66476007)(9686003)(8936002)(26005)(966005)(66446008)(52536014)(64756008)(478600001)(55236004)(54906003)(76116006)(55016002)(110136005)(38100700002)(2906002)(33656002)(8676002)(4326008)(122000001)(316002)(186003)(5660300002)(53546011)(66946007)(83380400001)(6506007)(7696005)(7416002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzlzWEF0WVltMFJmbE9YVThoTlFXdEYwL1VDT1JTK253dVFiT0Y4bC80a1hI?=
 =?utf-8?B?SkhZOFkwUVNyRzlXMkl5K1lIRWZWTFdUUWs1RUxuN3VvREhYWUdPaG5ONkZh?=
 =?utf-8?B?WENQYk9JUDhaMEFHK1d4ZjZSMk9qN1VXQlFCYnMzZndNNExZV0J3TndYb0NB?=
 =?utf-8?B?czI2dUNuZ2NzTEdvb3ZVdDVKVU40ejFRcGR4dS9iUk1yQStJNm9JNU1VNTMy?=
 =?utf-8?B?OXFZd3JmNzhmbmZ4cnFCZ3ZIVGtzbWo2TjZWR1Y4d2FFSkFTd2xwL1JXQTlI?=
 =?utf-8?B?dFJuWStRLzRsMThXZnVtMEtVR0pkcWJBdTZJYk4rZ3AxbGhNSnBtdjdzTTJY?=
 =?utf-8?B?Rkp0a1MzNVhyR1V4YmtNVFFqRzNpU3IzTFJwRmQ3bDZodmlMTG92SkJtMU44?=
 =?utf-8?B?bzZYVEhxbmdTYWNoMnVkYXJsSy9iYTB4V3huYjVlY05Yc2liNmpra2VjbVhM?=
 =?utf-8?B?ZFVOWlU1blAxd3dWR3UyZE5sQWs0YUJTeTkyamV5cVF3ZjZhZ2VhY0dUbkQ4?=
 =?utf-8?B?VmoxbVdOYWo3WVd5aDJIa2N4VzdBVDdIbENHczNqUXV1VUtpZ0c2QXhHTDNL?=
 =?utf-8?B?YVFPSmVkSmd3WTlYTDM0cWhmRVBZM1dqQkJKbFFWV0JudlZVZCttUkhpZ1ht?=
 =?utf-8?B?VDk2d1lLV2pUTFNZVTVrVTNTZWkxWmdoSmgwUlNVQjBFd0pKV0I2UEhPcnFm?=
 =?utf-8?B?dDZ0WlRUZktHT2FZM2FqODlwOXJOQ0JQQ2FYaU9OVk5peGhQcEFCUlFNT2Vs?=
 =?utf-8?B?dGdFLytBNkhKL2NXMjVOUTBRT1JMMXRDUXlBRU1JVTJqaXc0WFEweWdPMmNk?=
 =?utf-8?B?a3Fndlk3TFlPYlpWaVpNVHFDNTdQVDlJZEtFWlZjeGVZK1BoQWF4OE5lclFh?=
 =?utf-8?B?SlRvT0RBajBZejhjY3hVdGUySHRkOEVRN0trYVZ1RmZROEMzNElKOVREUElW?=
 =?utf-8?B?Z3VHTG1LV25IM0ZQLzBFS2Y2QkFCTzYwSXZZS3VPQWJCR1FTQjBZc2xpeEl6?=
 =?utf-8?B?TUM3TXhHanZhQ0RXeExtQjF0dU0xbm1jWVRnZWd2VDJPMnJGdFlDTXdySmR5?=
 =?utf-8?B?WTdRRzlRWThJWm1XQ0ZuY1psZTQ4Ym5xQ20wMXlNV2txMVRzdXlFNzR2N05z?=
 =?utf-8?B?QVFya1JxWG1qV3NsSkQycGNwYldkSkZIc2YzYnQ0TUxkOGZqcDRudCtObito?=
 =?utf-8?B?L0Ruay9CSlN0ZlpHZGNvWFlYdHlqeHhUZVdsazdHTFBiY1NFMVJTWjNhb2t6?=
 =?utf-8?B?VFJkVjJmejl0cDN5ZWx5ZUh3ZzF4YU1pTVc1dGNxT2NmSjRIUkdLY0J4NXJ2?=
 =?utf-8?B?cUNwZGxhbktBYlpFM0Y3VDNrVXgwSmxkNkxYNHJCaCtLZThoY2MrQTNXcTRU?=
 =?utf-8?B?YjhCT3NoUTZCRjVYZXd4a1hzZTBMdUdMVTM5Rk9HT3RGdEVYMmZDYStDQ0tk?=
 =?utf-8?B?clcwcEEvT2VqdGZkdkxHQ08rTm9pTkVaazFaeXVQajZnL3NlZkFFdkE2WWtE?=
 =?utf-8?B?WTVySW96T1AzcGhzZXN6Rmk1WGFoKzJpb2czeGE0MlhVR0hyQmxqSVJyRWl6?=
 =?utf-8?B?MWg5bU9BWWpjYTJyK1hHUE05a1YzUTd0aFlvbjhsanRiaTc1aEJSU05xWFhY?=
 =?utf-8?B?a25QYjJwMjk4cmxScjJhYWVJOHNUaE4vMkRTU3RFZk0zSVh2c1BqNHdOTmph?=
 =?utf-8?B?ZXJxaGVNaTU3YXVPQ1pmcUNDaFNmcmE5U3czMS9KbktOR25YRlMrdGVhanVj?=
 =?utf-8?Q?XmaIXsKsLIWt7oJT42pbZ+i9pWMlrBiH0EnOIZe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a73b965-84fa-4d66-cd6b-08d92b3e0bc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 11:59:33.3528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZkajPJW0aWd6ONjrt9SECJISsG+SwtCvgZoAsxAfeZOEc90H/L1dk5tssHWaLrmSnqQG/aDr1Kh3OHVMmLMuRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIEp1bmUgOSwgMjAyMSA0OjM1IFBNDQo+IA0KPiBPbiAyMDIxLzYvOSAxNzoz
OCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+DQo+ID4+IEZyb206IFl1bnNoZW5nIExpbiA8bGlu
eXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDksIDIwMjEg
Mjo0NiBQTQ0KPiA+Pg0KPiA+IFsuLl0NCj4gPg0KPiA+Pj4+IElzIHRoZXJlIGFueSByZWFzb24g
d2h5IFZGIHVzZSBpdHMgb3duIGRldmxpbmsgaW5zdGFuY2U/DQo+ID4+Pg0KPiA+Pj4gUHJpbWFy
eSB1c2UgY2FzZSBmb3IgVkZzIGlzIHZpcnR1YWwgZW52aXJvbm1lbnRzIHdoZXJlIGd1ZXN0IGlz
bid0DQo+ID4+PiB0cnVzdGVkLCBzbyB0eWluZyB0aGUgVkYgdG8gdGhlIG1haW4gZGV2bGluayBp
bnN0YW5jZSwgb3ZlciB3aGljaA0KPiA+Pj4gZ3Vlc3Qgc2hvdWxkIGhhdmUgbm8gY29udHJvbCBp
cyBjb3VudGVyIHByb2R1Y3RpdmUuDQo+ID4+DQo+ID4+IFRoZSBzZWN1cml0eSBpcyBtYWlubHkg
YWJvdXQgVkYgdXNpbmcgaW4gY29udGFpbmVyIGNhc2UsIHJpZ2h0Pw0KPiA+PiBCZWNhdXNlIFZG
IHVzaW5nIGluIFZNLCBpdCBpcyBkaWZmZXJlbnQgaG9zdCwgaXQgbWVhbnMgYSBkaWZmZXJlbnQN
Cj4gPj4gZGV2bGluayBpbnN0YW5jZSBmb3IgVkYsIHNvIHRoZXJlIGlzIG5vIHNlY3VyaXR5IGlz
c3VlIGZvciBWRiB1c2luZyBpbiBWTQ0KPiBjYXNlPw0KPiA+PiBCdXQgaXQgbWlnaHQgbm90IGJl
IHRoZSBjYXNlIGZvciBWRiB1c2luZyBpbiBjb250YWluZXI/DQo+ID4gRGV2bGluayBpbnN0YW5j
ZSBoYXMgbmV0IG5hbWVzcGFjZSBhdHRhY2hlZCB0byBpdCBjb250cm9sbGVkIHVzaW5nIGRldmxp
bmsNCj4gcmVsb2FkIGNvbW1hbmQuDQo+ID4gU28gYSBWRiBkZXZsaW5rIGluc3RhbmNlIGNhbiBi
ZSBhc3NpZ25lZCB0byBhIGNvbnRhaW5lci9wcm9jZXNzIHJ1bm5pbmcgaW4gYQ0KPiBzcGVjaWZp
YyBuZXQgbmFtZXNwYWNlLg0KPiA+DQo+ID4gJCBpcCBuZXRucyBhZGQgbjENCj4gPiAkIGRldmxp
bmsgZGV2IHJlbG9hZCBwY2kvMDAwMDowNjowMC40IG5ldG5zIG4xDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5eXl4NCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgUENJIFZGL1BGL1NGLg0KPiANCj4gQ291bGQgd2UgY3Jl
YXRlIGFub3RoZXIgZGV2bGluayBpbnN0YW5jZSB3aGVuIHRoZSBuZXQgbmFtZXNwYWNlIG9mDQo+
IGRldmxpbmsgcG9ydCBpbnN0YW5jZSBpcyBjaGFuZ2VkPyANCk5ldCBuYW1lc3BhY2Ugb2YgKGEp
IG5ldGRldmljZSAoYikgcmRtYSBkZXZpY2UgKGMpIGRldmxpbmsgaW5zdGFuY2UgY2FuIGJlIGNo
YW5nZWQuDQpOZXQgbmFtZXNwYWNlIG9mIGRldmxpbmsgcG9ydCBjYW5ub3QgYmUgY2hhbmdlZC4N
Cg0KPiBJdCBtYXkgc2VlbXMgd2UgbmVlZCB0byBjaGFuZ2UgdGhlIG5ldA0KPiBuYW1lc3BhY2Ug
YmFzZWQgb24gZGV2bGluayBwb3J0IGluc3RhbmNlIGluc3RlYWQgb2YgZGV2bGluayBpbnN0YW5j
ZS4NCj4gVGhpcyB3YXkgY29udGFpbmVyIGNhc2Ugc2VlbXMgYmUgc2ltaWxpYXIgdG8gdGhlIFZN
IGNhc2U/DQpJIG1vc3RseSBkbyBub3QgdW5kZXJzdGFuZCB0aGUgdG9wb2xvZ3kgeW91IGhhdmUg
aW4gbWluZCBvciBpZiB5b3UgZXhwbGFpbmVkIHByZXZpb3VzbHkgSSBtaXNzZWQgdGhlIHRocmVh
ZC4NCkluIHlvdXIgY2FzZSB3aGF0IGlzIHRoZSBmbGF2b3VyIG9mIGEgZGV2bGluayBwb3J0Pw0K
DQo+IA0KPiA+DQo+ID4+IEFsc28sIHRoZXJlIGlzIGEgInN3aXRjaF9pZCIgY29uY2VwdCBmcm9t
IGppcmkncyBleGFtcGxlLCB3aGljaCBzZWVtcw0KPiA+PiB0byBiZSBub3QgaW1wbGVtZW50ZWQg
eWV0Pw0KPiA+DQo+ID4gc3dpdGNoX2lkIGlzIHByZXNlbnQgZm9yIHN3aXRjaCBwb3J0cyBpbiBb
MV0gYW5kIGRvY3VtZW50ZWQgaW4gWzJdLg0KPiA+DQo+ID4gWzFdIC9zeXMvY2xhc3MvbmV0L3Jl
cHJlc2VudG9yX25ldGRldi9waHlzX3N3aXRjaF9pZC4NCj4gPiBbMl0NCj4gaHR0cHM6Ly93d3cu
a2VybmVsLm9yZy9kb2MvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3N3aXRjaGRldi50eHQgIg0K
PiBTd2l0Y2ggSUQiDQo+IA0KPiBUaGFua3MgZm9yIGluZm8uDQo+IEkgc3VwcG9zZSB3ZSBjb3Vs
ZCB1c2UgInN3aXRjaF9pZCIgdG8gaW5kZW50aWZ5IGEgZXN3aXRjaCBzaW5jZSAic3dpdGNoX2lk
IGlzDQo+IHByZXNlbnQgZm9yIHN3aXRjaCBwb3J0cyI/DQo+IFdoZXJlIGRvZXMgdGhlICJzd2l0
Y2hfaWQiIG9mIHN3aXRjaCBwb3J0IGNvbWUgZnJvbT8gSXMgaXQgZnJvbSBGVz8NCj4gT3IgdGhl
IGRyaXZlciBnZW5lcmF0ZWQgaXQ/DQo+IA0KPiBJcyB0aGVyZSBhbnkgcnVsZSBmb3IgInN3aXRj
aF9pZCI/IE9yIGlzIGl0IHZlbmRvciBzcGVjaWZpYz8NCj4gDQo+ID4NCkl0IHNob3VsZCBiZSB1
bmlxdWUgZW5vdWdoLCB1c3VhbGx5IGdlbmVyYXRlZCBvdXQgb2YgYm9hcmQgc2VyaWFsIGlkIG9y
IG90aGVyIGZpZWxkcyBzdWNoIGFzIHZlbmRvciBPVUkgdGhhdCBtYWtlcyBpdCBmYWlybHkgdW5p
cXVlLg0KDQoNCg==
