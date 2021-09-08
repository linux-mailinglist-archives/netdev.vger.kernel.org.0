Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9716D403E67
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 19:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350222AbhIHRfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 13:35:33 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:55936
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349974AbhIHRfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 13:35:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/44T/sr57cIp61lySOGwFJd6taX+6vqnJQjdS3jnOjtVR+4UszNgArlB28GZDJX++anNCSsWwEPhNlv6XPC4s0nU2f0NSQNniwnPvXVxh9j8/2r2fz7aBJs+D2GnJPx4fUSTtxSNPuCepXcDps399aEwsdQexAwwTdFZcRD0fvshV2BajI40PTsKqD1k2a8IsDlqgknmYtPJYv2m5Ojs8Ee5+gOyG9jilTXQonJBl9Z77qAnv9Jf1UFVLVFkLtNY+ad9W27PcMsMPZABxD43RsbjlJ78kREDzM9CiqK/hIwA/RQltYxn5MpkA6p3E8HNp8jsKXRa+h+w9JBtBbFew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jpicMpy6X87Ji0mrS7j9gn8yGzWtrLUfFaEtcGNEFlY=;
 b=Dw7+ablgCvv1EaWRVQivRVPRVTGxF1K+ks4IFoHKCkruw10gIuekp9vERy58gUabv6Sm88BfkGkHmpyE7bIM71x3HmaukHVCTOfRP7zb+6s+/lPHV7R3zh8kUraSuMeubh7DCO7gq43O4LyXau26AVqFUau1UP4WPZdKS3mbgwYWsLrBI62mis68Ifm6ixEDXDILWZfRmr7c8ojBSy/BwYwdGcYZUy9QX2sY2XVEYJHqPkCZ4NwVUC/dweJ59kFWxK9J2w/WFvhr4W/t2bq8qNhyud5EbhflrD49rN7E25FWB9IlmgZOsbjji3xTckg/aDxXKWLybLZfwjqaWN54tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpicMpy6X87Ji0mrS7j9gn8yGzWtrLUfFaEtcGNEFlY=;
 b=YVS7AApk53CBvyTzmmXRx7N6Tfdmzuo06Wjs3qHx+spUpjNAbkfJefACeU4BxsaUW+qWjHP3L4OHgTsQ+wnC3RLTHZyQzcYwSLud5ed1xJnIFxWu7xbEvHsWPEYJvbfEc/8dPefzYnNecJduhbnarAfpucNJzShyUFgheFH0EIwyhizRm8fGSKT1C2AMjex7xeF6c27FI8W+Dr8mrYrkIqgBolLLo9BRPoQYvI0Jn4C6ZJFeP08bzqaEcqvCCxJy7TA6iNEYDrTIVhEKG9Saa3pABsHQvQBI7T0bxWYIWrtmDaaqLnWogGAl0AJkq9Oy1vICDh5i15quBOoU+2w+DQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2711.namprd12.prod.outlook.com (2603:10b6:a03:63::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Wed, 8 Sep
 2021 17:34:22 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::5815:52a1:6171:e70]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::5815:52a1:6171:e70%9]) with mapi id 15.20.4478.026; Wed, 8 Sep 2021
 17:34:22 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>
Subject: Re: [net 7/7] net/mlx5e: Fix condition when retrieving PTP-rqn
Thread-Topic: [net 7/7] net/mlx5e: Fix condition when retrieving PTP-rqn
Thread-Index: AQHXpC7AsIy1St+5eUGPevPZHpcPEKuaV/WAgAAN2wA=
Date:   Wed, 8 Sep 2021 17:34:22 +0000
Message-ID: <5f050810b7bba249a66606fdf8a0aab7dba3f613.camel@nvidia.com>
References: <20210907212420.28529-1-saeed@kernel.org>
         <20210907212420.28529-8-saeed@kernel.org>
         <20210908093959.59e40d36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210908093959.59e40d36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbd69e02-eca4-4cc4-43e2-08d972eee55a
x-ms-traffictypediagnostic: BYAPR12MB2711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB271184540306583916D0F85EB3D49@BYAPR12MB2711.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bllfsZA50eZ/6jWIcspjIg5LbCID1E/y5fHhL9m7UGnwiZC648Bp4IbRtB7uWrtsBCy1aN3lovHxwBzFWx79IXSWC83TR1fS/tBg+ZJGBatoOOxYIiSSegNHY1k8xRJq9ymTmJn4+zQ82TUtO746fZEXti4TvZTtBxn0oaWOBdhNQ2XoFc8CpaEwJpY6nX5S5zFCQqiYO9ELcT4itnxrX8hK4Gcm1T78Ecp82GDVdkq7cNSv8iZWB/N1aEIvAyeJK6X8ubqsBEUJfKQzltRx1frmKxHeZ1j+uQA183DHbKJSKHqxQq4MS7wj81gctKQ5FL7uUxmIbgXzZ+BdnepeMZXV669etOVG2VgZLx+jXgDaU9NtzR3EM83nXLMMFaPiYaGCLTp7y6sXY/bYIGC2nx5j3rsMqCDOM8oRFQZJe5TdM/fTqKSbnIb5a1Q3Nss4zfzYxD8OhjZXOaXkIQDj8zpzuaWmCMlQyIhmMfPdT8YRVOHxF4K41Mc2587d23XfI7MP6SlUTcFH7GDc7KUexmdNfRmRyyAhyaBiw+NHcAnV5nFOSo1aqyeBVFP9VxF/Mtg8tUfp+Ii3vx79CC2qle6dOkHYxnnEbnPjqxNAzbIY1nPgfkYku/nK7H8xoZdvzSNGPl9/fwrkaLZlOdGL2HYgLIpXxyjYXUr4v9Pn+IXXwy2yMF/xU4r3CtfewFS23MyIwILjyX/XWtvptfqxlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(4326008)(2616005)(71200400001)(83380400001)(122000001)(107886003)(2906002)(38100700002)(66476007)(64756008)(66446008)(66556008)(316002)(8936002)(66946007)(76116006)(6916009)(186003)(5660300002)(86362001)(6506007)(54906003)(38070700005)(6512007)(36756003)(8676002)(6486002)(478600001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1NCNXoreUhrVWhkUWtVNktRZThYZTNqb29OR3Q0OGFqOEVMRzdNV3Vxa2lP?=
 =?utf-8?B?MnFWU3J6THkzQmVReHlHUDdnY2o2U3RCQ3VwSXp6WDVUWExtZkM4NFpCdkx3?=
 =?utf-8?B?QnNiVE93NWRKZGZmWWJPZTNsRWxYQjhjOTZ4UlUxbXJTeFExRWlhVldOSkxx?=
 =?utf-8?B?MVdUeE4wekVERkdEZzVkcElqNndTRWM0UVIyMkFCSG5zemwrblMvc0t2TFFw?=
 =?utf-8?B?eUYzY2IxMWU2bkVWbnZsU0VlSFA1SVMwMEZZT3d3MDVkckhmblBaZ2E2UUdN?=
 =?utf-8?B?WTBGV3ZiMUgxVUN3Sy9vdzVBci9XWWJEOUVoUmsrRnFOYW1kdERMY3NyY0Nm?=
 =?utf-8?B?VE53bjV3YmJYanVFOHVoMlZTK1R4MXFRN3AxVEtjVHkvT1FJYkowMWJrbWtR?=
 =?utf-8?B?aTZuT2VTeFU5WHFmc2RZYUQ5aDF0eldqR0RjdWU1clgwK0NpZ1pCM21CMnBP?=
 =?utf-8?B?TmM0RXpYZmJFNTd2VHRiaC8xR1EwSk9VdmZqVE1OanlqZ2Nhalpia0JvV3ZZ?=
 =?utf-8?B?Zjk2akU2QUNKMUx1aDJCQ294SzlrUHpoL2NxV1RHRTFLWTNnZTFWVzJFNTZs?=
 =?utf-8?B?RS9CejJDL2JLSkpaY2FGL0d3SDIwZkdoVnBLWnlIOG94ckVHeWYrMnRYRlhW?=
 =?utf-8?B?dTNHaDNHYXhJY0pid0JuODNGLzJySVBBQkNWSE9RMExOSDVhL1d1N2VrMXpO?=
 =?utf-8?B?em01c215TmpDMkE1ZTE4OUNLL1hUeEpBSnJORDZzSEk3MVhTZWI5YWZCd3B5?=
 =?utf-8?B?bXlaOXZMYVhsM1MrSVBqUXRvZUFOdU9ENXBJTDV4QkhFd0xDN0twdG90c2ho?=
 =?utf-8?B?OVVNclZDdTd5N1ltc2g5cktTS3FjK0ZqNGZUdldHeVdTZXVUbmRZeFZyWTNz?=
 =?utf-8?B?cys5SzczK2ZtZWdQOG5zeUZEZjg2UXFoVittRkJwTjhjQy9yRFBzeGk5NzdX?=
 =?utf-8?B?aUpYdFFUWVYwTGlQMVNLeWllS2tHaE1uL3BhQTVNS1JwYjZVY1hyYzhBYm9S?=
 =?utf-8?B?UUsweHY4YlBoSmFvNjRuOWVxR3VvV3lwOTFpTVF6SDU0UnAyVUdoR3RWNUNk?=
 =?utf-8?B?eU9nNWpvS01iNFlxVnNNUG9QekVTMEVJZ1cydWtRVkdkeG9DRHRiV29pYlVM?=
 =?utf-8?B?OXdSR2JocVJPUUhjVS8wcjliU1lCaXpZZ0pGMlFHVEpxaHJKVWhSanZpTHRW?=
 =?utf-8?B?bktza1Y4aUR1ZGs0a1Fwdm1QZ1lyZ1B3THYrclNBdnd5VkRLRGo3SzZITXhG?=
 =?utf-8?B?b2YyOE42ekttUWsyRUQzUStVZDZDU25UaWFCWFRmYnFOYmc4UjQ3UzBmRHpW?=
 =?utf-8?B?UDE0a280NVZQdHFDeDIzOEFGTE1vTGdkd2RwK2dkZlN0K3NYSGJ0dDVvZUtq?=
 =?utf-8?B?QVZxL0dDaCsyaDBIancxYTlZYVk0UEpBemRlSUNsSUQvZGFXQU44aitSc2tF?=
 =?utf-8?B?UVppdTAvMUtJVDNra3A1NUpya3BPQUpXbVVkZU5lV1NWdU5aQUpPbndFSTRp?=
 =?utf-8?B?RzVMWnd5dEFtdVhRQXU0aEJ6dU5OUnVDV29tb2xwNDRtNGIzTngyMzJ4T0ZW?=
 =?utf-8?B?OWZZS2lTQWJ1RWxqekZNY1A5b3JxNDBjTm5mQ3Q3OXVNaWx3QjlwS0NxZTFN?=
 =?utf-8?B?ZE1EZ3IvNy90czNzb3B2VHhZS0U1eVJ6cUsxOWdVOGNFK3pxb25HUlgrT1BK?=
 =?utf-8?B?QVQwblB0ckZyQWxHUXVtOVRDWnc1VzRFT211aUV5ejVQeVkzYzdrbHZ6anhn?=
 =?utf-8?B?WlZwbjdZSTdQNDhhZldOd0UxWlp3ekJnbXczaTlHSmFFUkthRnJuSTcrc3h1?=
 =?utf-8?B?RmpsM1N6UDB6V1dsMEJHZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69A838270342244282FF3281C3AF25FC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd69e02-eca4-4cc4-43e2-08d972eee55a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 17:34:22.4450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nhMrVw//IKHdZGSYHVx0yhsu8p2++HvbdaD/fK6eH0gagyvfUMbkXI9g4GFJURItbKb2t9dNrlSijybNUXQDaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA5LTA4IGF0IDA5OjM5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLMKgIDcgU2VwIDIwMjEgMTQ6MjQ6MjAgLTA3MDAgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gRnJvbTogQXlhIExldmluIDxheWFsQG52aWRpYS5jb20+DQo+ID4gDQo+ID4gV2hl
biBhY3RpdmF0aW5nIHRoZSBQVFAtUlEsIHJlZGlyZWN0IHRoZSBSUVQgZnJvbSBkcm9wLVJRIHRv
IFBUUC0NCj4gPiBSUS4NCj4gPiBVc2UgbWx4NWVfY2hhbm5lbHNfZ2V0X3B0cF9ycW4gdG8gcmV0
cmlldmUgdGhlIHJxbi4gVGhpcyBoZWxwZXINCj4gPiByZXR1cm5zDQo+ID4gYSBib29sZWFuIChu
b3Qgc3RhdHVzKSwgaGVuY2UgY2FsbGVyIHNob3VsZCBjb25zaWRlciByZXR1cm4gdmFsdWUgMA0K
PiA+IGFzIGENCj4gPiBmYWlsLiBDaGFuZ2UgdGhlIGNhbGxlciBpbnRlcnByZXRhdGlvbiBvZiB0
aGUgcmV0dXJuIHZhbHVlLg0KPiANCj4gSXQgd291bGQgYmUgcmVhbGx5IGdyZWF0IHRvIHR1cm4g
ZG93biB0aGUgZGlhbCBvbiB0aGUgYWJicmV2aWF0aW9ucw0KPiBhbmQNCj4gYWRkIHNvbWUgdXNl
ci12aXNpYmxlIGltcGFjdCwgYXMgaXMgYmVzdCBwcmFjdGljZSAoc29tZSB3b3VsZCBzYXkgYQ0K
PiByZXF1aXJlbWVudCkgZm9yIGZpeGVzLg0KPiANCg0KQWNrIGFuZCBhZ3JlZWQgISBJIHdpbGwg
ZW5mb3JjZSB0aGlzLg0KDQo+IEkndmUgYmVlbiBmb2xsb3dpbmcgdGhlIFBUUCB3b3JrIGluIG1s
eDUgYSBsaXR0bGUgYml0IGJ1dCBJIGhhdmUgbm8NCj4gaWRlYQ0KPiB3aGF0IGEgUlFUIGlzIGFu
ZCB3aGF0IGtpbmQgb2YgaXNzdWVzIHRvIGV4cGVjdCB3aXRob3V0IHRoaXMgcGF0Y2guDQoNClJR
VCBpcyBhIHNpbXBsZSBSUSBUYWJsZTsgd2hlcmUgd2UgZ3JvdXAgcnEgbnVtYmVycyBpbiBvbmUg
dGFibGUgb2JqZWN0DQpzbyBzdGVlcmluZyBhbmQgUlNTIG9iamVjdHMgY2FuIHBvaW50IHRvIGEg
dGFibGUgb2YgUlFzLg0KDQpUbyBzaW1wbGlmeSBkcml2ZXIgY29kZTrCoA0KIDEuIHdlIHVzZSBS
UVQgb2JqZWN0cyBhbHNvIGZvciBzaW5nbGUgUlEgZGVzdGluYXRpb25zLg0KIDIuwqBIVy9GVyBk
byBub3QgYWxsb3cgZGVzdHJveWluZyBSUXMgd2hlbiB0aGV5IGFyZSBkaXJlY3RseSBiZWluZw0K
cmVmZXJlbmNlZCBieSBTdGVlcmluZyBydWxlcy4gUlFUcyBoZWxwIGtlZXBpbmcgc3RlZXJpbmcg
b2JqZWN0cw0KcG9pbnRpbmcgdG8gYSB2YWxpZCBSUVQgb2JqZWN0ICB3aGlsZSBkcml2ZXIgaXMg
ZGVzdHJveWluZyBSUXMsIHdoaWxlDQpyZS1jb25maWd1cmluZywgd2UganVzdCBzd2FwIHRoZSBy
cSBudW1iZXIgaW4gdGhlIFJRVCB3aXRoIHRoZSBuZXcNCmNvbmZpZ3VyYXRpb24gUlFzLCBvciB3
aGVuIGRldmljZSBpcyBkZWFjdGl2YXRlZCAoaWZjb25maWcgZG93bikgd2UNCmp1c3Qgc3dhcCBh
bGwgUlEgbnVtYmVycyBpbiBhbGwgUlFUcyB3aXRoIHRoZSAiRHJvcCBSUSINCg0KDQoNCg0KDQo=
