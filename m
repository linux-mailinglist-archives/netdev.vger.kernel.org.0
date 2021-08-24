Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA33F6024
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbhHXOWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:22:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237792AbhHXOWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:22:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O8uFfC009556;
        Tue, 24 Aug 2021 07:21:18 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by mx0a-0016f401.pphosted.com with ESMTP id 3amwpqsew7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 07:21:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg65G+ZsGSC+JDh7irLJL8/aRgDfsYQRG4Nr3ORVXr+unF/dP2TQwVqb09YHLwbwSUiWkZ+7/UrRaMjNsp0xYtkSs4zuP+jeDXRe/X29a6V2l3/RkNuAiTdRTHEXw/QGj4Mw2nfNjFgd9LuKhsNJQ20rrundc9HHOMcUraq/fZO7ihdrejVQmYts+TYunVcEiaKWqqUV+u2hg72CaSXfS8I4c+8RADvRKNY96XzTi3ppMLWpBWv7mpEyjsWKFRHsX9e9W2hkqJSluQ8S/smOLddp5PysqfKxNApIzD/I5Kagx5j8HXOY/Ax4T9saRGy7VxG1ImCXGvO5tMp7CBSjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKBvyIoodvDzer0eus7KNL2QK9S6fE6HPCJ+kEPb2y0=;
 b=AJtcGpu2+YqwDWqcFzOUl9RKfZpbQwaFFsoQ3p3zc35aA+bY1DoTEtfXUxpou+zNibaLw51JuoOmTZTs1Ba7C+98bc4rbHFZ6nZxcMmqfLqAc9sVJ7jN+AswkmetpUbjyOOn2PLNSWu+l3tvgUUTASDLIUtLfvHO0/cCxZkjoL6HsvEazxqVDpSajEElXxi28tsZCMgA/euv2bESP3kXfho3/DQtOGARW/RWc4GJqJpLoWTlBkTJmW8rpX88vnJ89/ozbeSMk7avagCzw2tqU5Q7t7pJJVO+5tBk2eTqUeO0V+sKrld9g/UzJnepzrxLU0Sh5NEWZwCtv+w+ACY0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKBvyIoodvDzer0eus7KNL2QK9S6fE6HPCJ+kEPb2y0=;
 b=dZiJ7YsqfQ6Qp0XshA5og56aSBjec+fPJrAKQehIDKnN01AQeBp878+5jXt529/GcZ9lXSJArv4x5hjzBLCTQFgTvEQFsX89hptuZW7j9caYYATaqX+9/nMtCVhi/l385A1HelwRX78tCI6YgJJE1qzGVGUJmxdbPoN5EZhYLRw=
Received: from DM5PR18MB2229.namprd18.prod.outlook.com (2603:10b6:4:b9::24) by
 DM5PR18MB1146.namprd18.prod.outlook.com (2603:10b6:3:2c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Tue, 24 Aug 2021 14:20:57 +0000
Received: from DM5PR18MB2229.namprd18.prod.outlook.com
 ([fe80::a9c9:dccf:5e59:fdec]) by DM5PR18MB2229.namprd18.prod.outlook.com
 ([fe80::a9c9:dccf:5e59:fdec%2]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 14:20:57 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shai Malin <smalin@marvell.com>
Subject: RE: [PATCH 05/12] bnx2x: Read VPD with pci_vpd_alloc()
Thread-Topic: [PATCH 05/12] bnx2x: Read VPD with pci_vpd_alloc()
Thread-Index: AdeY8zT9Cd18BcyVRh6TBhi0uoAoFw==
Date:   Tue, 24 Aug 2021 14:20:56 +0000
Message-ID: <DM5PR18MB22290BC6E0BB57B39A72E865B2C59@DM5PR18MB2229.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1aef7b0-4566-4970-e8cf-08d9670a63ca
x-ms-traffictypediagnostic: DM5PR18MB1146:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB114678D7C8358BD4CA1C1EADB2C59@DM5PR18MB1146.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: atQl46tWw4pL1FLSma5CPtR1NJCXyAW3z4PgS4EQGfSbUpBkwna6tSK4HjVazu9zZ5OsyyK5AdNpsAcmHK3Qsi8G5f3PiX6rWDrwRTxcEaw/Z7K4mYCYuhXa6VHbuF/M8k+VZmsi/AxEzbNsxB4WhoXCLBT24TrQZJgP/NKc23TCgIYFkusEMM2QKYieNPFLmSGkogikzIf+3YcjjwnFzuyVE+Sj9mbNKL+mrVg7qw7LYSeNNcWPoZ//GY1jJ3u1MKqZudf1bPYrYmjy4/t9Hhxya2BkBh0+eoKO+HO6/LSzMZ40aXWd4x7UdzsTP7Y88+3yXetr9XmKS+7190MMVIAu0sMi2YX1lYiDbyrF0okAZBxhX5O6KZ8XskXd7hAVBArHTDMAVGKOdfrhfFlR8PInvaBwyfW7XwotWKVnIXfmdMq+IO09bwTIdw1fLmTNTlr+ufKrm6PO7AsCCN09TEE6S29JsYZROks8gqrXAdN4FryZc11W4xwPeBglzwbd7q30ymZNjPMKDg3ozUEWG8n15erpNTDYA7XDvro7w1XS58kFSUJIGheZXiirouzk1BQNZj5ERoAvtcAP4HSAD71Oyb/J2IaiJFeCbVKbPFaHShugnFfsjmI+LMbtK//Sg+SEyGwu2N7Psq2GUXiNXQgswlCD1syceLxczWrqKw47mA7N2Y0NQpGBCveDazwWuUQaVfMbh4RSmcQx1OUFAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB2229.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(5660300002)(8676002)(38100700002)(66556008)(66946007)(122000001)(66446008)(66476007)(8936002)(64756008)(54906003)(83380400001)(52536014)(110136005)(2906002)(478600001)(4326008)(33656002)(86362001)(55016002)(7696005)(38070700005)(107886003)(186003)(316002)(76116006)(6506007)(53546011)(71200400001)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEp2Q2MvZXhIWklmakdDNlJqVlJhay9EaFpiWHpLamNpeGFqY0dLSkZGOEFa?=
 =?utf-8?B?ZFJGejhYS3ZiNkFvWXVidnA1SW1VaVd4RnBnMEN0ZWo4cGtJZmpXc1pHNlBi?=
 =?utf-8?B?WWJVQXJVYThRNGlTL08xYjcxOVMwMUUvWEFYa2lwT0Q1QXNldnBQblU3NEhR?=
 =?utf-8?B?eW5JWTlydVY0bzVyVEpPZitKNDdPL2YwVGhoK1VvYUx3WE5TdFBmbUpma09t?=
 =?utf-8?B?TDZkTXVwWi9yV0JzeFM3RXRMRkh6MU0zS1JDdGs2MWU1R1l3VUIzdWRQaWxD?=
 =?utf-8?B?SllYY2dUT21XOThxUHNHNUtEam9VN29yWHNkUmI2eUZBclpIZndTckI4UVJO?=
 =?utf-8?B?clVJcTdWb0lCQmNSZHNMMU9WdmNiMXRtMDFSWkFXUk51WXJpZnphY21USmhP?=
 =?utf-8?B?eGFPYm9QeVF3SmIxVCtOQXRvdndUNU56TzhVejVnbER1V0srZ0lZRjZRWVo4?=
 =?utf-8?B?dFVuai9rckJQbGtmc2RFb3RVcFRjUDR0UW9nZGk4QWswcjdPS1dyR1RRaFpu?=
 =?utf-8?B?VkRibWxLZHpLMy9zeWcvTEwvb1o3Tm1OUnhvMzdlTmtyOW1pSWhsNWpyb0dF?=
 =?utf-8?B?Rm9VOUk3ZVN2d01ZRE0yVXpaSGpYczA2NFRXQjYvMHJXekZDak00L3ZPSlc0?=
 =?utf-8?B?dE52bjJNT2RENTBRcnVleFpkMGppVVdrMWxzYW5wQkhqcTdRWDZEbnNCSzNj?=
 =?utf-8?B?dlhFWlBqTHZoazRVcHZid2U0b3BSQ0E2MGRjOHNvZ3VyMGVibVkrMmdLS3lI?=
 =?utf-8?B?SlVpcXJKdWdBTzdXTTlnWkhjYWgzNjhqZWRNQ3ZUNFAxT2Y4TXQwK1FYVWww?=
 =?utf-8?B?RkNReFU5UEhkV3lRTkFCTUxWNXBWT3I2Zlk4bUFOWnk4M3dsTW5Kdy9WZTIw?=
 =?utf-8?B?Q1BONnhVd0xzM29MSjhyQTZEZHlMbWxWM2Q3SmZUTjVoWnpicVhLRWMyaXBk?=
 =?utf-8?B?dmFvcHZ3eEoxWmFnRk9CUUJWZG9XWkU0T0F4dXRiaWVCbkVsbVArbWJDNDZ3?=
 =?utf-8?B?aVB4OXp5dzZJd2hrQkhmWnluc3I1a3RZMStRQ3VJWVVQeXZaeWZ1VHF1QUxm?=
 =?utf-8?B?ZDFLWWJWRHpsbHJhQnE2VWZWeWd0WTdlMFlnYThvellEZ1B6NVdkRHNHbVBW?=
 =?utf-8?B?MlQrYTJWeWM3RmlVdkFlK0JqWWw3NXhjcy94OGF4YVFHZHo0MS9RMEZ3Ujdp?=
 =?utf-8?B?R0dYNDhqVkZoUEY5NlAwWnFUeVJlNHJkSE0wMEhVSEt5WU9mK2FZNk5ucThj?=
 =?utf-8?B?S1p2VnRtZ0dHUjNGbzF5YXpUVERQNXI2b2N4blZFR0xvRkQrdGhJank4WGxZ?=
 =?utf-8?B?L2k0ai9GNFB6NkQxTGgzQkdEMklXZVZKVXJ3ZVdEcE5IRVNpd0NrY29hM1FO?=
 =?utf-8?B?d0NjbExTVXgxYnJHb0U2dFFPR2h4NFEyMUtjaGc1L3JLc2pKdUZ4RXQvcnlX?=
 =?utf-8?B?VVhBa1AvN3BjOVVLOFFUOEhuZzFnQ3VOYXZNNHFnTTcrZy90MWQ3UGVGT3o1?=
 =?utf-8?B?NDJkOUM3WkswZ21CdmtYQ0FOVi9ZNkkyUU1tS1c0RkRiN1cwbHdDVlpQWWQw?=
 =?utf-8?B?U25SZDhmZm1MaXNGM0FvRkF2TklpZjJuV3hlV0RkSVF1VHZYU0FzaHppV2lv?=
 =?utf-8?B?MjRWVFZtVjQzUTlTSWl4WjNSMVhYNE55ZDIxMTBiMk0wR05ieGV6YjJtQy9n?=
 =?utf-8?B?NGNCZzNVdWd0Qkkzb0xhbkFuZThUTGF2U3AxeG5IWHpPbjcwZThhbFM2Skdk?=
 =?utf-8?Q?CutBXOoYgOjl2uBvIWnTdEBpknppckLZ7O6K73s?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR18MB2229.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aef7b0-4566-4970-e8cf-08d9670a63ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 14:20:56.9123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eB5lPDRpeZxe8gvlcu/fC0+LLyXEBGDamo9wR1UlgcuPwaqW3c6Hb8pGOzCuzMa2dQppaneIBxhzSLvZODd3iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1146
X-Proofpoint-GUID: vWR61s_T-0YWjgtOQe8Ccc_U6nLT5RWz
X-Proofpoint-ORIG-GUID: vWR61s_T-0YWjgtOQe8Ccc_U6nLT5RWz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_04,2021-08-24_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpbmVyLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlaW5l
ciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IFNlbnQ6IFN1bmRheSwgQXVndXN0
IDIyLCAyMDIxIDc6MjMgUE0NCj4gVG86IEJqb3JuIEhlbGdhYXMgPGJoZWxnYWFzQGdvb2dsZS5j
b20+OyBBcmllbCBFbGlvciA8YWVsaW9yQG1hcnZlbGwuY29tPjsNCj4gU3VkYXJzYW5hIFJlZGR5
IEthbGx1cnUgPHNrYWxsdXJ1QG1hcnZlbGwuY29tPjsgR1ItZXZlcmVzdC1saW51eC1sMiA8R1It
DQo+IGV2ZXJlc3QtbGludXgtbDJAbWFydmVsbC5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBr
ZXJuZWwub3JnPjsgRGF2aWQNCj4gSMOkcmRlbWFuIDxkYXZpZEBoYXJkZW1hbi5udT4NCj4gQ2M6
IGxpbnV4LXBjaUB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogW1BBVENIIDA1LzEyXSBibngyeDogUmVhZCBWUEQgd2l0aCBwY2lfdnBkX2FsbG9jKCkN
Cj4gDQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IFVzZSBwY2lfdnBk
X2FsbG9jKCkgdG8gZHluYW1pY2FsbHkgYWxsb2NhdGUgYSBwcm9wZXJseSBzaXplZCBidWZmZXIg
YW5kDQo+IHJlYWQgdGhlIGZ1bGwgVlBEIGRhdGEgaW50byBpdC4NCj4gDQo+IFRoaXMgc2ltcGxp
ZmllcyB0aGUgY29kZSwgYW5kIHdlIG5vIGxvbmdlciBoYXZlIHRvIG1ha2UgYXNzdW1wdGlvbnMg
YWJvdXQNCj4gVlBEIHNpemUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZWluZXIgS2FsbHdlaXQg
PGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jy
b2FkY29tL2JueDJ4L2JueDJ4LmggICB8ICAxIC0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvYnJvYWRj
b20vYm54MngvYm54MnhfbWFpbi5jICB8IDQ0ICsrKysrLS0tLS0tLS0tLS0tLS0NCj4gIDIgZmls
ZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMzUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnguaA0KPiBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4LmgNCj4gaW5kZXggZDA0
OTk0ODQwLi5lNzg5NDMwZjQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jy
b2FkY29tL2JueDJ4L2JueDJ4LmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRj
b20vYm54MngvYm54MnguaA0KPiBAQCAtMjQwNyw3ICsyNDA3LDYgQEAgdm9pZCBibngyeF9pZ3Vf
Y2xlYXJfc2JfZ2VuKHN0cnVjdCBibngyeCAqYnAsIHU4DQo+IGZ1bmMsIHU4IGlkdV9zYl9pZCwN
Cj4gICNkZWZpbmUgRVRIX01BWF9SWF9DTElFTlRTX0UyCQlFVEhfTUFYX1JYX0NMSUVOVFNfRTFI
DQo+ICAjZW5kaWYNCj4gDQo+IC0jZGVmaW5lIEJOWDJYX1ZQRF9MRU4JCQkxMjgNCj4gICNkZWZp
bmUgVkVORE9SX0lEX0xFTgkJCTQNCj4gDQo+ICAjZGVmaW5lIFZGX0FDUVVJUkVfVEhSRVNICQkz
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyeC9ibngy
eF9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyeC9ibngyeF9t
YWluLmMNCj4gaW5kZXggNmQ5ODEzNDkxLi4wNDY2YWRmOGQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4X21haW4uYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyeC9ibngyeF9tYWluLmMNCj4gQEAgLTEyMTg5
LDUwICsxMjE4OSwyOSBAQCBzdGF0aWMgaW50IGJueDJ4X2dldF9od2luZm8oc3RydWN0IGJueDJ4
ICpicCkNCj4gDQo+ICBzdGF0aWMgdm9pZCBibngyeF9yZWFkX2Z3aW5mbyhzdHJ1Y3QgYm54Mngg
KmJwKQ0KPiAgew0KPiAtCWludCBjbnQsIGksIGJsb2NrX2VuZCwgcm9kaTsNCj4gLQljaGFyIHZw
ZF9zdGFydFtCTlgyWF9WUERfTEVOKzFdOw0KPiArCWludCBpLCBibG9ja19lbmQsIHJvZGk7DQo+
ICAJY2hhciBzdHJfaWRfcmVnW1ZFTkRPUl9JRF9MRU4rMV07DQo+ICAJY2hhciBzdHJfaWRfY2Fw
W1ZFTkRPUl9JRF9MRU4rMV07DQo+IC0JY2hhciAqdnBkX2RhdGE7DQo+IC0JY2hhciAqdnBkX2V4
dGVuZGVkX2RhdGEgPSBOVUxMOw0KPiAtCXU4IGxlbjsNCj4gKwl1bnNpZ25lZCBpbnQgdnBkX2xl
bjsNCj4gKwl1OCAqdnBkX2RhdGEsIGxlbjsNCj4gDQo+IC0JY250ID0gcGNpX3JlYWRfdnBkKGJw
LT5wZGV2LCAwLCBCTlgyWF9WUERfTEVOLCB2cGRfc3RhcnQpOw0KPiAgCW1lbXNldChicC0+Zndf
dmVyLCAwLCBzaXplb2YoYnAtPmZ3X3ZlcikpOw0KPiANCj4gLQlpZiAoY250IDwgQk5YMlhfVlBE
X0xFTikNCj4gLQkJZ290byBvdXRfbm90X2ZvdW5kOw0KPiArCXZwZF9kYXRhID0gcGNpX3ZwZF9h
bGxvYyhicC0+cGRldiwgJnZwZF9sZW4pOw0KDQpEZWZpbml0aW9uIG9mIHBjaV92cGRfYWxsb2Mo
KSBpcyBiZWxvdyBhcyBwZXIgcmVwbyAiZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2hlbGdhYXMvcGNpLmdpdCIgYW5kICAgYnJhbmNoIHdpcC9oZWluZXItdnBk
LWFwaQ0Kdm9pZCAqcGNpX3ZwZF9hbGxvYyhzdHJ1Y3QgcGNpX2RldiAqZGV2LCB1bnNpZ25lZCBp
bnQgKnNpemUpDQp7DQogICAgICAgIHVuc2lnbmVkIGludCBsZW4gPSBkZXYtPnZwZC5sZW47DQog
ICAgICAgIHZvaWQgKmJ1ZjsNCi0tDQotLQ0KICAgICAgICBpZiAoc2l6ZSkNCiAgICAgICAgICAg
ICAgICAqc2l6ZSA9IGxlbjsNCn0NCkhlcmUgaXMgbGVuIGlzIGFscmVhZHkgcGFydCBvZiBwY2lf
ZGV2LiAgDQoNClNvIHdoeSBjYW5ub3Qgc2FtZSBiZSBzZXQgaW4gY2FsbGVyIGZ1bmN0aW9uIGku
ZS4gdnBkX2xlbiA9IHBiLT5wZGV2LT52cGQubGVuDQoNCg0KPiArCWlmIChJU19FUlIodnBkX2Rh
dGEpKQ0KPiArCQlyZXR1cm47DQo+IA0KPiAgCS8qIFZQRCBSTyB0YWcgc2hvdWxkIGJlIGZpcnN0
IHRhZyBhZnRlciBpZGVudGlmaWVyIHN0cmluZywgaGVuY2UNCj4gIAkgKiB3ZSBzaG91bGQgYmUg
YWJsZSB0byBmaW5kIGl0IGluIGZpcnN0IEJOWDJYX1ZQRF9MRU4gY2hhcnMNCj4gIAkgKi8NCj4g
LQlpID0gcGNpX3ZwZF9maW5kX3RhZyh2cGRfc3RhcnQsIEJOWDJYX1ZQRF9MRU4sDQo+IFBDSV9W
UERfTFJEVF9ST19EQVRBKTsNCj4gKwlpID0gcGNpX3ZwZF9maW5kX3RhZyh2cGRfZGF0YSwgdnBk
X2xlbiwgUENJX1ZQRF9MUkRUX1JPX0RBVEEpOw0KPiAgCWlmIChpIDwgMCkNCj4gIAkJZ290byBv
dXRfbm90X2ZvdW5kOw0KPiANCj4gIAlibG9ja19lbmQgPSBpICsgUENJX1ZQRF9MUkRUX1RBR19T
SVpFICsNCj4gLQkJICAgIHBjaV92cGRfbHJkdF9zaXplKCZ2cGRfc3RhcnRbaV0pOw0KPiAtDQo+
ICsJCSAgICBwY2lfdnBkX2xyZHRfc2l6ZSgmdnBkX2RhdGFbaV0pOw0KPiAgCWkgKz0gUENJX1ZQ
RF9MUkRUX1RBR19TSVpFOw0KPiANCj4gLQlpZiAoYmxvY2tfZW5kID4gQk5YMlhfVlBEX0xFTikg
ew0KPiAtCQl2cGRfZXh0ZW5kZWRfZGF0YSA9IGttYWxsb2MoYmxvY2tfZW5kLCBHRlBfS0VSTkVM
KTsNCj4gLQkJaWYgKHZwZF9leHRlbmRlZF9kYXRhICA9PSBOVUxMKQ0KPiAtCQkJZ290byBvdXRf
bm90X2ZvdW5kOw0KPiAtDQo+IC0JCS8qIHJlYWQgcmVzdCBvZiB2cGQgaW1hZ2UgaW50byB2cGRf
ZXh0ZW5kZWRfZGF0YSAqLw0KPiAtCQltZW1jcHkodnBkX2V4dGVuZGVkX2RhdGEsIHZwZF9zdGFy
dCwgQk5YMlhfVlBEX0xFTik7DQo+IC0JCWNudCA9IHBjaV9yZWFkX3ZwZChicC0+cGRldiwgQk5Y
MlhfVlBEX0xFTiwNCj4gLQkJCQkgICBibG9ja19lbmQgLSBCTlgyWF9WUERfTEVOLA0KPiAtCQkJ
CSAgIHZwZF9leHRlbmRlZF9kYXRhICsgQk5YMlhfVlBEX0xFTik7DQo+IC0JCWlmIChjbnQgPCAo
YmxvY2tfZW5kIC0gQk5YMlhfVlBEX0xFTikpDQo+IC0JCQlnb3RvIG91dF9ub3RfZm91bmQ7DQo+
IC0JCXZwZF9kYXRhID0gdnBkX2V4dGVuZGVkX2RhdGE7DQo+IC0JfSBlbHNlDQo+IC0JCXZwZF9k
YXRhID0gdnBkX3N0YXJ0Ow0KPiAtDQo+IC0JLyogbm93IHZwZF9kYXRhIGhvbGRzIGZ1bGwgdnBk
IGNvbnRlbnQgaW4gYm90aCBjYXNlcyAqLw0KPiAtDQo+ICAJcm9kaSA9IHBjaV92cGRfZmluZF9p
bmZvX2tleXdvcmQodnBkX2RhdGEsIGksIGJsb2NrX2VuZCwNCj4gIAkJCQkgICBQQ0lfVlBEX1JP
X0tFWVdPUkRfTUZSX0lEKTsNCj4gIAlpZiAocm9kaSA8IDApDQo+IEBAIC0xMjI1OCwxNyArMTIy
MzcsMTQgQEAgc3RhdGljIHZvaWQgYm54MnhfcmVhZF9md2luZm8oc3RydWN0IGJueDJ4ICpicCkN
Cj4gDQo+ICAJCQlyb2RpICs9IFBDSV9WUERfSU5GT19GTERfSERSX1NJWkU7DQo+IA0KPiAtCQkJ
aWYgKGxlbiA8IDMyICYmIChsZW4gKyByb2RpKSA8PSBCTlgyWF9WUERfTEVOKSB7DQo+ICsJCQlp
ZiAobGVuIDwgMzIgJiYgKGxlbiArIHJvZGkpIDw9IHZwZF9sZW4pIHsNCj4gIAkJCQltZW1jcHko
YnAtPmZ3X3ZlciwgJnZwZF9kYXRhW3JvZGldLCBsZW4pOw0KPiAgCQkJCWJwLT5md192ZXJbbGVu
XSA9ICcgJzsNCj4gIAkJCX0NCj4gIAkJfQ0KPiAtCQlrZnJlZSh2cGRfZXh0ZW5kZWRfZGF0YSk7
DQo+IC0JCXJldHVybjsNCj4gIAl9DQo+ICBvdXRfbm90X2ZvdW5kOg0KPiAtCWtmcmVlKHZwZF9l
eHRlbmRlZF9kYXRhKTsNCj4gLQlyZXR1cm47DQo+ICsJa2ZyZWUodnBkX2RhdGEpOw0KDQpBcyB2
cGRfZGF0YSBhbGxvY2F0aW9uIGRvbmUgaW4gUENJIGxheWVyLiANCkl0IHdpbGwgYmUgbG9naWNh
bCB0byBhbHNvIGZyZWUgdnBkX2RhdGEgaW4gUENJIGxheWVyLg0KDQotLXBrDQo=
