Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE593E4DF7
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhHIUhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:37:31 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:16001
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233894AbhHIUha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 16:37:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWyl9Wz7bw5x3XL5cojtrc2m2WVtCAxZvpeBV8WjWRSByT2+0jiJRYMkey/uBG/IOGmr7Otm0r6HA2bKwj8pLec1C0tbp0Y0x/aSJqsycoO7zwEgLcTBGr1lmx6Di3MmhonRVzzD5V3AhW3Qxhlya7wUmRwnPNIPFFqdErknmg5Wj+f3FYsxXosBDJCfvZjyo+DG2QwK1iPB3+fapAXkWOC/+lhj5HPaDMiXrxSmSnSmiBRKJrrw8pXdSNIQyb9cprdWCPHpnf9CH/07sQ7WZCKagK7c0jaB+e7fmXrsb8Xcs8tEh+wnrGMKoVcBQO/ZGHe79+QSIhr29JAXuHfdfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRVK2olKBxicO2nymqJVfjtjQxcsLMZx63BGR7C8Wns=;
 b=ZxcUwsplzmmt4TYWSxDT8Ou0k5YFqQO61lgm09ziMqRt9UsTW8n4ztfuHS1gROOhKuIvFBB/YIRD5WV4tRBqYM5uY59iGqYrwANyh8omgdFL+okxQg5mgXTlDiSnvuUpAbzFu+zKFdZFLt68zOQyOZG2fATLpQ56edadn5Q1U68tdz06h9elPlOmgXZEnvfbimtQKf8rzBSftpcwu/HyBMO/FoF9pBptkYDKTc3ga2mXcya/AM09iJ/Wle4b3hg+zUPYNbUfyc5g0cs5MWz2NjJjfJgPWrIbCwJI543SUZVhJ7HIUu7F12bnOEGHGj82+CYFKWHSHyblbDjAmwurNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRVK2olKBxicO2nymqJVfjtjQxcsLMZx63BGR7C8Wns=;
 b=WatGjW2zoP0qHj9xPj5SDqlv0gGsXCSbRxYJEffVzE2NATjsMZmvhyeJfaM4Qydspjp2rkQzYpe9hPuCG/jkIBrx9l1g+rmxlJ5bXv4GPSfzjCr9gMaS7akUFASsm+vjllCzN0O1lrjW4Mum0v59Sv+DrgL/JD5G5mOgg6vAOV8vzDx0MUcPwCoU3564KsJKDmpQjHnhsBI7NRDHIyI5bHinhOrgstbveVCfZc8K0R2S1Et1w7d+iOlNu5i2p4D4PT9JX5hb6RHjqEpvP3qZKJS2/DxLNPIMzrr61qTKwkG8MXft9av/WFJm7PSNZvsznAaOC4ab2zIUhfwisuxhmQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3093.namprd12.prod.outlook.com (2603:10b6:a03:dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 20:37:08 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 20:37:07 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "caihuoqing@baidu.com" <caihuoqing@baidu.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Make use of pr_warn()
Thread-Topic: [PATCH] net/mlx5e: Make use of pr_warn()
Thread-Index: AQHXjP4ugjSAV+KcxUqFYL3OUnuGs6tq94cAgACrHwA=
Date:   Mon, 9 Aug 2021 20:37:07 +0000
Message-ID: <744a99a3de26300fc244d5b7702c87a9dd926e6e.camel@nvidia.com>
References: <20210809090843.2456-1-caihuoqing@baidu.com>
         <YRECZn/N9qSQkhKu@unreal>
In-Reply-To: <YRECZn/N9qSQkhKu@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d58b854-2619-461d-21bd-08d95b7574dc
x-ms-traffictypediagnostic: BYAPR12MB3093:
x-microsoft-antispam-prvs: <BYAPR12MB309385C4B83C6B972C9B68F7B3F69@BYAPR12MB3093.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8lggWnBTEu8vAs8s7beqW3oCD1tF3c7v9DJRggEFGCJmkbq9k642EvsPNEFPwmfhlSDdC+e/qygkYcUXpZbTJejPQjHEoc2m1MBy0O0GeaLZ/+8fG5RWitp+K1PzygFcKD6bknlZ0nJpTeT64K8q0Qe5XDwe3O/DhrAkNc6luQPjMJGvtgx6QZ6eueOfrbxWOeiBheutQlSJjDEQR4A4lygkEvOsZAXsYQgTqIV3G1HqO5m9E2h2RdALQOf7HPoXU0cEbZZn/gQswnIgF/D9pUXgFSiN99LntxzGvWWuoaqDS6p/rMux0jV++yS+vY+uKICPSc4LJIOr+lVwYTETYByxXr3JEbKBeWuG5zTna0L1nv13MOPhn/5pEdXOxbaTbE4mvioruLo/UvsmsFahsrtziWU0mSLF5FLO91jhO4X9edXnu3Ui3kucyVFc45aV21k+3soUHKwidyHNJ19b2Bd7vIB/J6u3KymsQqoqIH5gEUD2jUIUJsh0bGXd/7iFda+JLjdEGy4TbsQh6VUcqOIyaDIrzQyDxHp4+knvvEelJWb+uNsf4eDfkOC3UXFjd9UbpaQM+m9iRXhg6kaKyKU+tbk25H0iYfq8TAGkpju6vBfcmBrGxwUXN6qtpqSaNazhSAhNzmmgsqoVH1ZDBHGX6Nb4WYNTBiFND15w8l0zigN/TeeYpjMYocq4Msr+8ggpVG2sJsHETRyRomKz9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(4326008)(4744005)(6486002)(36756003)(8936002)(71200400001)(8676002)(6512007)(86362001)(66556008)(110136005)(38100700002)(66446008)(2616005)(2906002)(186003)(122000001)(66946007)(64756008)(66476007)(26005)(316002)(76116006)(478600001)(6506007)(38070700005)(83380400001)(54906003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rnp3L0h1MmtydFB5aDFWTWlQM0I2ODlCSGlTSmdqQ3R4ZGtNbzJDT29KMk8y?=
 =?utf-8?B?M1NiTmRhb2F4eGZUcVR2aE1MbnZxR2xyRnh2Q0xtS2dmRGhBcFJYVUdvb3FB?=
 =?utf-8?B?TDAxT1JVVk1hV0YxcXY3czRZMFA1RVhndk1nK2sxTW55ZmIyYTduNWRnRU1o?=
 =?utf-8?B?NFFyLytjUFFQOEJ0TDN2eW5sUjJNV2tTUyt1a0kxY1B3V2tIZjI4RnpGcGJy?=
 =?utf-8?B?Mm8wNXJXRW1wZXA1eWpaZTZWV0lJcElaZW9IbWdyczFmcXI0d0NSM0RsZ1c5?=
 =?utf-8?B?V1BEck0wZWZrbE9NMml4TmVObHVIZnBUOE0wZUx1SlhraFJKWk15dUZlVi9Q?=
 =?utf-8?B?aTFSc3Q3NzBJTWtBYXlXTENtR3g1NjRUMUVvY3ZmRlRRRFY4U2VPcXVsdDRO?=
 =?utf-8?B?Qzd6eitzT2NPMHRKYW16N2x3bFRMNVZJV0FaSy9EZWVmNzVqSlJaWFY3dDRI?=
 =?utf-8?B?Vnk0Tkw4c21EQldTMlRKVjh4d0hzcFhvQ3Rycm04Y01DT0V1WWVqNzJ1aWtF?=
 =?utf-8?B?VGx0MzVmdEFIZzAvbHJoMkF1MlJ0NGFZcGQyaXppYitrMml4Y2k1Uk93T1BD?=
 =?utf-8?B?RXU3c0RQZmxDRzh3QU5yMGlEbnBYNHptRGg5N05idUl0SXVyYnBGbmdQSDV5?=
 =?utf-8?B?bjF1UEMrMkpWQW9OcE5RNW03cTZYZXhORHRiWmR1MUhFbnNjZkFranNWYXpV?=
 =?utf-8?B?MmRjWDE2cHErWHAzclEzVFN3Vko0UGVVZ0gzNEc0UzVBM3BNa2thNVVtSWpW?=
 =?utf-8?B?TnFOTjZiOW9ONDhzUXZHbjZ3d2RUT2lweFNKYVpKVmR1SUxQTEpJNGxrangv?=
 =?utf-8?B?L3BNN1J3R282WkliOG40ZVp1TlBDRllNbGM2SzRJTkV4VGQ0YzJJMGRlZ0N3?=
 =?utf-8?B?ZEVMTjZVOE5RM2thekVJM0IyVU5RNGZqN1hqRE9TSXN3bThBYkZUN082UHBH?=
 =?utf-8?B?SFB3bUtRZEdTYmtYWTVZbkF5MzNRM0ZzZTFTTFBmZUNWTXlFemZnYm55UUNS?=
 =?utf-8?B?alRXT2NiTGdyejU2SlNGcDZvWlhtZVpKUDNWNkFxWG1Iakx0SUphTnBpdFE2?=
 =?utf-8?B?RXh4bTRkRXA3QmhMd3dzSHhyaExTcVRTb0VsaUpCTGE0cERkRXJ6eEw5ZkhG?=
 =?utf-8?B?TkZ1cTVVV3U3Z3VrRmRqRVJpVlZFNG9talNQRXA1SjZTc1BTTGpTcmtoSUNN?=
 =?utf-8?B?SVBLdEwzOVZEekNSOXVGSCs3YXB1dkxhcklNc3Z5ejN4LzNuRkJpVDE5d1N3?=
 =?utf-8?B?bEhLTVVYdEtObFVFTmMrS25XcjB3bjhlQ3NNa3dVSUN1TDVZSVJERnVFb2hQ?=
 =?utf-8?B?cXcwakNiV24vYm82SXZ3RnNYbEw5RVpYbFVlN1ZBN0FPbm5CU1hObmRBYXZk?=
 =?utf-8?B?TS9HUC9sOUN2RjBHbHNnWWZCY0gxUS9VaTlLNENTYjRRbExkN2krVTAzOXUr?=
 =?utf-8?B?QXJDNVpZRXBVUHl6cUFWVStTVkp2YVk0bTJGZmhTcHNFUzFqL05MUDE4MTRM?=
 =?utf-8?B?L1pNOGJNUEd3c0F5NlRpMFJuaGFwWDJ3Q056NEpaZEVNOFBmTDhId2FLUFRE?=
 =?utf-8?B?ajhaY3NSVUx4YzBmdFpOc0IvbDgxZ2lrcm8xRjZYMnVNV09KSERJbEd0SmI1?=
 =?utf-8?B?aXpaRGdNK0Q0cnltSklrdWlJcDdLbEc5bEJBREpEL0RJeTFJaWdOd0pQZUdZ?=
 =?utf-8?B?QTFKOE83SVFlQWJWU1Q1UDkxNU9EUEdaWjRzWmFkVWFrUHFWT01Icmt2ZlVC?=
 =?utf-8?Q?WtyYqsiNUtBoSkaxvZGr6zu5RFZqVTFp10If9rN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D65BB753DBFF74B99357C84501B6BE7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d58b854-2619-461d-21bd-08d95b7574dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 20:37:07.7041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ZHGPrMWmdx8dKgfZ0akiYuH5D0AWl/b1oKVtLJ8Ibu4JhpbzreDEjVI92f/Jins+qVnnFSbGA1nZNeC3ZbXTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA4LTA5IGF0IDEzOjI0ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
Cj4gT24gTW9uLCBBdWcgMDksIDIwMjEgYXQgMDU6MDg6NDNQTSArMDgwMCwgQ2FpIEh1b3Fpbmcg
d3JvdGU6Cj4gCgpbLi4uXQoKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcHJpbnRrKEtFUk5fV0FSTklORyAibWx4NTogY2FuJ3Qgc2V0IGFuZAo+ID4g
YWRkIHRvIHRoZSBzYW1lIEhXIGZpZWxkICgleClcbiIsIGYtPmZpZWxkKTsKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHJfd2FybigibWx4NTogY2Fu
J3Qgc2V0IGFuZCBhZGQgdG8gdGhlCj4gPiBzYW1lIEhXIGZpZWxkICgleClcbiIsIGYtPmZpZWxk
KTsKPiAKPiBJdCBzaG91bGQgYmUgIm1seDVfY29yZV93YXJuKHByaXYtPm1kZXYsIC4uLi4iKSBh
bmQgbm90IHByX3dhcm4uCj4gCgpwbGVhc2UgdXNlOiBuZXRkZXZfd2Fybihwcml2LT5uZXRkZXYs
Cgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIC1FT1BOT1RTVVBQOwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4g
PiDCoAo+ID4gQEAgLTI3NDEsOCArMjc0MSw4IEBAIHN0YXRpYyBpbnQgb2ZmbG9hZF9wZWRpdF9m
aWVsZHMoc3RydWN0Cj4gPiBtbHg1ZV9wcml2ICpwcml2LAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpZiAoZmlyc3QgPCBuZXh0X3ogJiYgbmV4dF96IDwgbGFzdCkgewo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgTkxfU0VUX0VS
Ul9NU0dfTU9EKGV4dGFjaywKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAicmV3cml0
ZSBvZiBmZXcgc3ViLQo+ID4gZmllbGRzIGlzbid0IHN1cHBvcnRlZCIpOwo+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwcmludGsoS0VSTl9XQVJOSU5H
ICJtbHg1OiByZXdyaXRlIG9mIGZldwo+ID4gc3ViLWZpZWxkcyAobWFzayAlbHgpIGlzbid0IG9m
ZmxvYWRlZFxuIiwKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIG1hc2spOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBwcl93YXJuKCJtbHg1OiByZXdyaXRlIG9mIGZldyBzdWItZmll
bGRzCj4gPiAobWFzayAlbHgpIGlzbid0IG9mZmxvYWRlZFxuIiwKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1hc2spOwo+
IAo+IGRpdHRvCj4gCgpzYW1lCg==
