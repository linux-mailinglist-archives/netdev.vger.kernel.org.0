Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130453A1053
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbhFIJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:40:47 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:32993
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234802AbhFIJkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 05:40:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA1YDnDhhzMplgbP1ttdn6fqGgGlVo2t6vFc1o7g/5kAgxs1/p6O8a//AvAsywuOWTCi2/Fm+MeLY03OdauhEbJGk2qI0Onk17pyljEKXY99zWvHP66zN/Aif8Pe6QQhfExF1nXbd/4VFz/vnEhiCC+psEZmqT1CH1rqQ/YvNk7Q0nXtlWbDyhqawh9u1D3kTlbZd+wzkAeiBQxUnHm/JcQnLdqLPqCagI4TPN2e2ukLnOQnyCf7OihIaApMsDHFcXGUPB/Xe/FzhNnHTEHaPWZS6GyRa99XbeZkXf1CobnkN4dZoQIZv+TLQUvaxY47KJILIR6Rb6PViQGG/pDtWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7+NHCcXg3Xkd+yUVkUaKvz26bqJmFZ9uYjnFlpPiaE=;
 b=ElligW1UR1s0Gn4rGEVaVMiQe8Zq4o5Ub1cxmZPx1j42OSmn5zeeOOgeyBfreGqPR3uB8zNW2ls6FtbCMHNy2AI5/Tel9ruKDWzjBce5BUAe05rLEYbLJPh8Pf01SPanGZvJEE3SHtN4LHKegagOQjS0FAAOSlrj0MNKYjyglza3tqfeTAg5RzIln2X5WxHxkNlyTK7pzYPxFU/+RTmh+REM+czYbO0IpqTvrhSSVsxVc1vEwhmNS6/ejzctVypKzrZpEkiQ8mZ/agF+Op7t78/2zqK/R5ZYdUgCWaEiYTW0eDs7odk+Ia9SfsenEP3P0SxLL9hVfbnk1wCgeqQuGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7+NHCcXg3Xkd+yUVkUaKvz26bqJmFZ9uYjnFlpPiaE=;
 b=WBij8JJcHP5ZEGBVNSibITc/FGHB0hmpeNxaN4ZlbW/qvHFBnm0D/YyS/H+cAPMD+7lWWk8BhC9/xo0zdOTIW3JyP5Xa84EkcWuA1ylaWPMzo0Uxd8Y9Y+AT+ORzwDs0Gl1lk9sApiBRANr4+OuML2rmqF+7zz3SrtwCHeJzjA/8ro6JbM+7k+kzBZx7ysq0P/UEWaq8ydQ4MBQ0rIa0fQ+hZFQk7XHAxrMTM7oK/9xiRvriTGw6mfReJG4b3Ri2Tuo8ncDbbyZ7gFpCZlt7hkq0oY5rQEoGte4u5RTuIPh2mOyMHB91CgtURMKIq2U5q1vWa9NCf/gpDsACpU78tg==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.23; Wed, 9 Jun 2021 09:38:50 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 09:38:50 +0000
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
Thread-Index: AQHXVqgtOTo5DdccDUWHkWiFIp83jqr+w2yAgADrK4CAAFDXgIAA7Z8AgAC7xYCAAOyAgIAAfE0AgAEjb4CAA5i/AIABMJGAgAES5oCAAFkqgIABCGgAgAAEzBA=
Date:   Wed, 9 Jun 2021 09:38:50 +0000
Message-ID: <DM8PR12MB54802CA9A47F1585DC3347A5DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
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
In-Reply-To: <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 638b16a8-8765-455e-4998-08d92b2a6397
x-ms-traffictypediagnostic: DM6PR12MB5567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB5567FDB4B447C44CA866596FDC369@DM6PR12MB5567.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9kUmg8e11VJXhQMZ4SsHHzaNcMbS1HHNUp9yzDlWgz3JECDDemlUNLSSIeMRb44sI57x3AhQrawWn39FVxxxHDO/3dKd65NfLMyUieqnl+EsSHWeN7IdWBHMGRGZkvf/FKVS1kqYbcqUM6WIrbtP6xuHa50CC17zxLgUxcsh1RFS5Pyw8LkuGiLqGoToGSm+zN1o3sQod2DsTouOqlUm/XjjBFFZL2McOdzgET6SxdPQTocoXiLH363oBT9kE8pjyDwcDpOebPQVyOfoYuQdy3sZ1ZrGjPDFpNl92J6cTptw/XC/58JQeNyJXR4Hlc9JoYHlE3fymTF+kMxjxKTSc/5hZlV0U7HoYrkWdzPsXoB5SZrsbrRRz0LNTNyAgBdInfTgsJsFBmMdNasa+89eHSVmadXNIHyf3QdfpX+pZugYnqdyq6DGQAHizC1U3/gN/JNQHIJjNSZlZ7mJVAGyG4/9SRNCgwAIunGPnOO5ZRvntwciSYPXZ/XWxDKNTkA+il1LikytIsvC7WNmZpQ9CozWtIeoagJhX+Fvwh7aIxa6fZF0WwpOPIe0K6g4G6lELyiN7N6jNQwxbqBvfn2XWIP7FwtunMzlGI8Bo3t659UoatwHqsNJECVzqOlep6t3fC5/KP3xaHwTSMipFyeXDTRQ+eyINzmkxx7edeHG9v2toNKgYN34Mq+fxbrhrNEKjeQvuGNVPR2tpu1CAg5K6qJZAsHduRb8vFl017sGdtc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(7696005)(66446008)(64756008)(38100700002)(316002)(86362001)(5660300002)(7416002)(66476007)(26005)(186003)(2906002)(55236004)(66946007)(110136005)(6506007)(33656002)(54906003)(966005)(52536014)(83380400001)(9686003)(478600001)(8676002)(8936002)(55016002)(122000001)(66556008)(76116006)(71200400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnRjbnVVeEJDczVhYjFudmhRdzdaWnhRYmNjbkhFMDgxQXlMcXpGZXFQbm5k?=
 =?utf-8?B?aWk1LzBLRjZFN2lVei9JRElLdC93VTYrNklLOHdVanZxRXF2SmJVSkZ6QjBM?=
 =?utf-8?B?Um5kenBnc2E2K010TkZmZEpXZDZ6SjJ5S2h4OGxZSVVNeXJvQ0I1RDZtQmM3?=
 =?utf-8?B?YmpCZ2crT1l1TGJFVEJoYWFwb29HdlVMck9WaGIxcy9oTVd3QkNXMEN2YXJm?=
 =?utf-8?B?L1R0ZTZEL2FISVlXVnA5dmkyZTdqSXJPY1lxSWwvdHVhR1dmV2YrQ1VvSFFD?=
 =?utf-8?B?SFVoaTlYczU2MHRFNmpwNU1OdkoreU1qM280c0JyNCs0SDNEN1pBTjAxQ3ZC?=
 =?utf-8?B?S0szL0ZselhPWFBtUmhmS0pUODBjOC8vcm1POS80SGhEU01selh1WVNmWTdU?=
 =?utf-8?B?Q0JYN1orYXZBMWZibDFKM29kNzRaOS8xdUtZYkNKaGR6UVVCRVozYlFVZzRJ?=
 =?utf-8?B?QTQ0c2hySUF4c0JRWG9iOFk4bXcvaXh1S0h5OGFpYWtLUExUdWIvL0hiN1B6?=
 =?utf-8?B?dGJrNUtBU2RNUWRibmRmWU1qMm1paEdTWXhUU1JjcFpOaWJSUmpKNjYxODcx?=
 =?utf-8?B?ZHBFRjE0NnpnVGwveGhMQUZmd3hnRGYxYThGVXU2NWEyK2J3cG9JQmRCRG9s?=
 =?utf-8?B?cVJkSGVRcFpRVVhsUVN0eC9OT2ZWQmswTDJVMk5IUGpudmRWRTlOdWxPV3Uz?=
 =?utf-8?B?Z2ZySW9FdDVLUEhpNXVPVjhZUi9PWUQzODRJZUtuWmNXU283dFlaY2tKdm1i?=
 =?utf-8?B?MkdDaXNsMWZTUmRPUjR5Ym9Nc3g2OGFmY0ZUNjhBUm4zNXI3SFl2M0V4V2xa?=
 =?utf-8?B?ajgrVmxWRitJTlRSRXJiOThJNFhBY3plSUlBeVF5T29jRkwwOWVpUCtiU0RF?=
 =?utf-8?B?R2RBZjU3ZGxMQ2REcEkzNnd4bW1BQkdmODhic1NBeUoybWs3UFhnZEM3WEVp?=
 =?utf-8?B?VGZZby9HMlExK1Rud2dRWGd2UWtLRXIyWTNvYWVnTVliL0dFMXlheVNCaWFz?=
 =?utf-8?B?aE5tZWZ4KzdxUjBiK2dUVk1sNGdWNjQzUGVuVjdtUy9tVmo5VFVONytGSUFm?=
 =?utf-8?B?dFZRMkxQRHNOamN6RWNRR0N1eTdjODdtb005Q0d1UG9nYUhRbU1HMTBnVmxy?=
 =?utf-8?B?dTJOaS82WkgzVVBnQWhRNHNud1A1Ri92MGhTSXNkSXlwbU5wd1doaCt5SWZu?=
 =?utf-8?B?M2IyNzRSd1NRQ2N2U2taZlRvWGNxbVA3eXZLRDhlUFBqQnFoUlU1WGJycFoz?=
 =?utf-8?B?aVVHaEVVTTB2VmdaamxBRVUrblA3VVM3NHVXTzlkYzR4eVBjbWIydXY2T1Rp?=
 =?utf-8?B?L1JSbUhwUlRvRGxMckx4TVJlL2lzbVJiNUhldml2QTJlZ2lWTEU3YnYzNDFr?=
 =?utf-8?B?SHFiN2xVZW8xWUgxdE91dVNkVWdWMC8yejNhOVdKVksyYmgzVTN3K09TWEhp?=
 =?utf-8?B?T2JnWlU0SmRuQVNRbkVpcWlyQjhwa1pyRXZwNnZKWFAwaDlnQzdWYVRPMFlI?=
 =?utf-8?B?Sk9sdmlPdTFjdkJjZGc3bU1TVXF4dkQvd2k3UnRwblo2dTBDRmRqK2lDVGJD?=
 =?utf-8?B?UHorV2pGeTErYWozaVZrM2lScWs1MVpDQks0OE5PZUM1TUF1c1FnZlIzMVlr?=
 =?utf-8?B?N2RDTmIvT0wrV09kenQ2NERSc3JkT0FKb21SWS9QTWVEbWtvK1BZVngxMUNF?=
 =?utf-8?B?a25mSjczTVE0N2dGekErZDBqNXdhTVAyd0ZJMlpFRzVjQS82amR5K21VSFNQ?=
 =?utf-8?Q?ahBbK12UtKiGWUJJB31ZzqJHBSMhMU/APpsRAIc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638b16a8-8765-455e-4998-08d92b2a6397
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 09:38:50.7512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lA33K3ebXI5NCYAOYsV1yWhE4GxRt753+QPNaR+05zXkj/osZMZYFQcGZaQk9W1/V857MdbM3T5D1MMfNW5+uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gU2VudDog
V2VkbmVzZGF5LCBKdW5lIDksIDIwMjEgMjo0NiBQTQ0KPiANClsuLl0NCg0KPiA+PiBJcyB0aGVy
ZSBhbnkgcmVhc29uIHdoeSBWRiB1c2UgaXRzIG93biBkZXZsaW5rIGluc3RhbmNlPw0KPiA+DQo+
ID4gUHJpbWFyeSB1c2UgY2FzZSBmb3IgVkZzIGlzIHZpcnR1YWwgZW52aXJvbm1lbnRzIHdoZXJl
IGd1ZXN0IGlzbid0DQo+ID4gdHJ1c3RlZCwgc28gdHlpbmcgdGhlIFZGIHRvIHRoZSBtYWluIGRl
dmxpbmsgaW5zdGFuY2UsIG92ZXIgd2hpY2gNCj4gPiBndWVzdCBzaG91bGQgaGF2ZSBubyBjb250
cm9sIGlzIGNvdW50ZXIgcHJvZHVjdGl2ZS4NCj4gDQo+IFRoZSBzZWN1cml0eSBpcyBtYWlubHkg
YWJvdXQgVkYgdXNpbmcgaW4gY29udGFpbmVyIGNhc2UsIHJpZ2h0Pw0KPiBCZWNhdXNlIFZGIHVz
aW5nIGluIFZNLCBpdCBpcyBkaWZmZXJlbnQgaG9zdCwgaXQgbWVhbnMgYSBkaWZmZXJlbnQgZGV2
bGluaw0KPiBpbnN0YW5jZSBmb3IgVkYsIHNvIHRoZXJlIGlzIG5vIHNlY3VyaXR5IGlzc3VlIGZv
ciBWRiB1c2luZyBpbiBWTSBjYXNlPw0KPiBCdXQgaXQgbWlnaHQgbm90IGJlIHRoZSBjYXNlIGZv
ciBWRiB1c2luZyBpbiBjb250YWluZXI/DQpEZXZsaW5rIGluc3RhbmNlIGhhcyBuZXQgbmFtZXNw
YWNlIGF0dGFjaGVkIHRvIGl0IGNvbnRyb2xsZWQgdXNpbmcgZGV2bGluayByZWxvYWQgY29tbWFu
ZC4NClNvIGEgVkYgZGV2bGluayBpbnN0YW5jZSBjYW4gYmUgYXNzaWduZWQgdG8gYSBjb250YWlu
ZXIvcHJvY2VzcyBydW5uaW5nIGluIGEgc3BlY2lmaWMgbmV0IG5hbWVzcGFjZS4NCg0KJCBpcCBu
ZXRucyBhZGQgbjENCiQgZGV2bGluayBkZXYgcmVsb2FkIHBjaS8wMDAwOjA2OjAwLjQgbmV0bnMg
bjENCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl5eXl5eXl5eXl5eDQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUENJIFZGL1BGL1NGLg0KDQo+IEFs
c28sIHRoZXJlIGlzIGEgInN3aXRjaF9pZCIgY29uY2VwdCBmcm9tIGppcmkncyBleGFtcGxlLCB3
aGljaCBzZWVtcyB0byBiZQ0KPiBub3QgaW1wbGVtZW50ZWQgeWV0Pw0KDQpzd2l0Y2hfaWQgaXMg
cHJlc2VudCBmb3Igc3dpdGNoIHBvcnRzIGluIFsxXSBhbmQgZG9jdW1lbnRlZCBpbiBbMl0uDQoN
ClsxXSAvc3lzL2NsYXNzL25ldC9yZXByZXNlbnRvcl9uZXRkZXYvcGh5c19zd2l0Y2hfaWQuDQpb
Ml0gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3N3
aXRjaGRldi50eHQgIiBTd2l0Y2ggSUQiDQo=
