Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29091471977
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 10:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhLLJWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 04:22:43 -0500
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com ([104.47.56.169]:6136
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229888AbhLLJWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 04:22:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+7GOiV7FEiSYWWTQ8db4h38afctkChsjqcj8I2873C44B/IFd6E1OXXPEDWnzyEjmf3DEWYTu4yj8RnuuObztoZ0fb4YOr638mVN0eLwkxDhqkWtKHzfrB9qUWKgCnn9n70OmNI1W3192Ed39bubFluKHr8GxFmZfbFYXzPOTJS6DuxAsKhGkYTonOU8VdwS+4U4hyyxj+31pbNflbhZKDcLed+jhmn6aJpAwfx9WKU/lgGr/N1Y11UsHYJZNbsT1I2mKxvAVWI/pj3C+VYDDosp+ClnakobOkzvD6CJbIfvocx1E8XIED4fRr+698gLdeBeTvhhZAUajCqPqLvmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFMmx+5YiA99kM+uMjNgcUBkxpwdwhAoQNBCy8D4ejM=;
 b=SNygapgmf5iaa8obbpBjMb+uqa38AJQmzCYTlHQ8b91T3dTK2Bn5/8hlEJZXxYzULyYKKqXnkhNi18llZm38V6mIEvneiHrJQ3dVsppVVCGwUrt5D2Ym9ONYugOQ2xcznLF/P0jf0dVt+TY5etAs5ibveF/kgMAsF0aYQHDet6FARkZgQRkBIInZLxReGdVW3oxMf7vorKLBBx9L1KiSn1zzuOw0nU5a31jwOdfpsLRZ74MKfnWiz6+BGGaDBoD/Ki+Vy4EGeY6AUBI2nKJ3xuJktWonRpblKBNfR0dVy8CNZVSt2K9ECb9gjdlvpkK7qxkMYm8SY5xWLHOoKVWPVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFMmx+5YiA99kM+uMjNgcUBkxpwdwhAoQNBCy8D4ejM=;
 b=lQ9EROi0qTNQhsxC5Y4VZxACRVqMyYLZnyviWH5iJtv5o1IdwlzRS1lemLOwjksBBPQRelf52IuBowd6vYxCV+ssMfCIAL+Sj1Ep1wadVfR3lfXkurR+9kpfTfT42R/lNP4Gn9hiBTAirLpmEs/FPpTxR+ZMKSdYIXfXCtq9s4g=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (10.174.182.149) by
 DM5PR13MB1788.namprd13.prod.outlook.com (10.171.156.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.12; Sun, 12 Dec 2021 09:22:36 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4801.010; Sun, 12 Dec 2021
 09:22:40 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v6 net-next 06/12] flow_offload: allow user to offload tc
 action to net device
Thread-Topic: [PATCH v6 net-next 06/12] flow_offload: allow user to offload tc
 action to net device
Thread-Index: AQHX7N8om2S/XyUbQEmVhAvouL7NLqwttLOAgADgqZA=
Date:   Sun, 12 Dec 2021 09:22:39 +0000
Message-ID: <DM5PR1301MB2172DE0606380ADBFE6FCCE2E7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-7-simon.horman@corigine.com>
 <a262c1ba-27e4-25cb-460c-c168a938f70e@mojatatu.com>
In-Reply-To: <a262c1ba-27e4-25cb-460c-c168a938f70e@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60779861-2ab8-4e31-a178-08d9bd50f1d3
x-ms-traffictypediagnostic: DM5PR13MB1788:EE_
x-microsoft-antispam-prvs: <DM5PR13MB178873E3217A99F6A93BC7C5E7739@DM5PR13MB1788.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 81ERmRASuc98QqfwF/Lr8zZS8l3qY59GN9I2HVp1/2WMKpO6rn55xfr+6vKBZ0PvtAhCTZafpbX40l0iaa1EZv2w4otkkEfy4A7O6KOgEuqbtpLPSyk5NNRFCFljfTkApufD0gLbIVEpu+HtdbcTR9gnUFtRIMX3rLN3b4J+EiW9CdJR05zSwAKWqt5skF1+XfYQQQb4aLVweKeBkNFqP9+/R1y/1+/cAlkhI3S3kRA6FjogBkgItUINtcZz4g9WVfSRZ7Vj65dNLQUSmLKVCiSApvyefOGldbammbEqWAgS8PbXGpt6YBQ9Y+tmG7mXtRHyVQGuUxgbXBa2WA8XOLZgyV+53/YnpyOCYfRYnOYoBfguc1q77oRAKpKw8RHLCf0Wl42y4CFLL8mGQg7cWaiRbO4er0w+M5yVitCTTufUji7yFJpJJ0qsbHgIsn/riS92mWVvzIE+6KA5znm8Da30ak++JNTGwi9dl6viqpnZsIyy0UoIwFk1d4CVIpYNdsmmggWhDbMIt8vTBuaT9ePfxuh+DD2j5Eaib5Vpt5r7vtVflOF3I41+jtz7Zidv20TQhhssGnSJjmkYbn9U8TwyTYSI0VuKe4OXHL9xYcaofd85jAF59/Yny4+r5ddmpZuDWKGcPzUeEae6Lsc6+a0EtABBpgZHQQg9ilLlxQeM8oVPOT1olzqgDNMC8+15YM4DQYV3i/DAFwiC6d4CKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(376002)(346002)(396003)(39830400003)(26005)(4326008)(64756008)(66476007)(52536014)(66446008)(66556008)(186003)(8936002)(44832011)(2906002)(5660300002)(33656002)(71200400001)(7696005)(508600001)(9686003)(6506007)(55016003)(107886003)(38100700002)(38070700005)(122000001)(83380400001)(76116006)(54906003)(66946007)(110136005)(86362001)(8676002)(316002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlI0ZEdjN1JHWktGemdpMTRNM0lrQkxzdUxTSXVmaGpONlhXVlVyeWNNandB?=
 =?utf-8?B?bHlOMzBmK2tVNm9QVzBMdU5tZkhmU01mTlE3ZWp2VVl1enhvUENENjBwT1VF?=
 =?utf-8?B?WSs2bkYwL2FXSkgwOS9vK2hsY0FSNElCZFhzNUM0cFNSSmkyUEhKL0MvUVJJ?=
 =?utf-8?B?akNYb25IM3R3VzkxUHpHa01hS3dYZHRESlMzekpoL29uRmkrazV2ODIxQUla?=
 =?utf-8?B?cUVpZFhTZEMzd3NGcll3djR3VlJtcDNyVklyUFFPdmhzQjU0UUVXS1NrMk5x?=
 =?utf-8?B?S2M5THBXNnFLMXBxcUdNTmIzcVVENi9zTkR2ODB0SDhhckFFN1NHclhSZkll?=
 =?utf-8?B?aEJ2dkZ3YWFNTVI4Z3VXdGJjUlFpODJOYkhETThuL1JNaityc3M2QTg0aUFY?=
 =?utf-8?B?QmhMZDlyazV6R0Q0YXkvRCtEZjBVcml5UkJGSG10bEpKVXhzdkc5MnphNHVI?=
 =?utf-8?B?STZQcVpxY1VaakZBWTJuejByV0I5OVkxNVFVWDRQakc2WktyYkV5U0dKaENN?=
 =?utf-8?B?OXJXbmpNc2FuV3gxcW9mQjlTMHlNSitnRWVEZ0NOMmw5ZTMySkptVDBQR0VZ?=
 =?utf-8?B?N3FTaGs1VTh2bjR5MHhuSkRkWWJMV3o0dFF2V1ZqbnNqdm11NEY3Q1NzeGFU?=
 =?utf-8?B?dmxFemJTOXpuUjFPOE5ZYzYzTmdaM0hsL1BBZ1l4UzZiang2azF4YjhKanhN?=
 =?utf-8?B?NENUcEZjNUxRZCtpRzh2UDNhUmFYSFhvZHVwT0g3RXVma2U0WWlTa1NBSEFx?=
 =?utf-8?B?ZklOMktSeDh1Q29YVjl2WURRSmRqQnBISGRucVZYVTBtbU54cUppS2locmRN?=
 =?utf-8?B?bkZic28vSjFhbU5hclpZTmdiOTVqUmZFNkZQeHM4K21sVmRtQU1ER2NMZDQv?=
 =?utf-8?B?ZGJuWkVtRHdZWm1yekRXTDV1OEJzYjJzRGZjNjdCUXNMQ0svbktPUXEyMjNo?=
 =?utf-8?B?WWVMMEo2S0VFajBYRVIwYnFReFRXVHZ0N3BlQUR5MGlac01YRGZNYjQ3MUNG?=
 =?utf-8?B?NHB3ZWJRM2VjZUZza1Fiek5BTXdQSkErSUxnMlVnZXJnQXMrcEowVlRQcDJr?=
 =?utf-8?B?a0Qwa0FiRUZNTFg3SkFIS0UwdG9JTFdmZmc5a0Y5WTZOMXlJZG5sak92b0ow?=
 =?utf-8?B?czViUHJMRkw1Q1FIYnZjQ1JHdnUyNEhoZ0Vka1podXljQ0o1Q08rZ3ZiUWYx?=
 =?utf-8?B?ZHoyWGRycnVjL2ZrNmFUY29PenkrRE5oTGFXS3puVG5lTEpUT1JIdUxEN29r?=
 =?utf-8?B?OTN2OTVPMEJTTUcySW1rQVcrakppQ1FPanc2T3FGMDVONGxCSWZKNDMxamtG?=
 =?utf-8?B?UmJWVEY2ZjNJeU16OUJLdlVBa04xMTFjSTFaWDNHZThEVlFmRGpsdFFPd1hX?=
 =?utf-8?B?TmJRRHNZZ0JqSDhCQTZLNEhweSt5dVhnaFZTVUQyaG5sRUw4SkVnc09lVzIz?=
 =?utf-8?B?cTVCMzM5VXFTTjBTNW03cDlVbXo0UXpLdnRnTHNtUUphQkkwOHMxUk1Fajlr?=
 =?utf-8?B?UHloWDRscjJ5cjJmd0pWKyszaURoVFhJVHoya2h4cUhDd2hSVkk3c3J5VzRJ?=
 =?utf-8?B?cjBKZzREMldLcUttbktRSlM1UTUyM05ibDVzckFlc05MbXNpWUxkdm41eVNL?=
 =?utf-8?B?UmJmdDhOMWNuZEhWN3B6Z00rREdGKzYwaXlXV2hJUXNpL3hqbzdBS1RPcU1Z?=
 =?utf-8?B?dUZTeTF6bG5GYnBZSC90dXBSQm1PeTdXaXM5aGVsYmFJKzZqWk44dlBmc04r?=
 =?utf-8?B?dC9WYnN4MG9UeXg1WW5NdU5xQVp5NEhzR1RPTHNSMVpuTnZQckFtWkE4UUQ5?=
 =?utf-8?B?OGVRMEM0VS9UY1BNYm5TaFBCS3ptWXp5c2R3Nk5pQkp1M09sSHhHeDdaZnlj?=
 =?utf-8?B?NEJ2UllWcHhtY3EvbE9GVGdkcE1PaXVmNDVTNG44YmtoUHlYb3E5NG05V01C?=
 =?utf-8?B?SkM4OUE4ckxMbU5yTER2Wk45S1MwVWtwL283YmMwZ0hoc0Q0Zk5QRlR5c0Rw?=
 =?utf-8?B?Zm9VN3hwVWZpTWJRZzhRVjQ0L2hsRjU2TFdhejVkTlZvYmtNemhTaUFTOXgx?=
 =?utf-8?B?MU1MUlJiNU5tVE54OGVKWFdXdzFwVldtS0xTNTh4ZTNXRWtQMEE4aVh0Zmta?=
 =?utf-8?B?QjVhTlErc0NnSEJQS3hvN2tpS0dWRGtxM3Bua1RRMWJLbnBZcVk2eGwwUG1l?=
 =?utf-8?B?RFVvcjI5VkxRODNQeU1HdFJEN0l6aWlFbDJVbUMvcWVyU055bE5EWE83UUw4?=
 =?utf-8?B?TnMyMnJDNW9Wa25xR1NGcC9ncGFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60779861-2ab8-4e31-a178-08d9bd50f1d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 09:22:40.0088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upJucQvXrN4uliPx6FZvLeqIkk0yis62zPg78JC8hzp3pY8xIYW9n7cqeUrXB5ZRXeMAcFkNKLlq8yAVBbNReIhyPVcb3fIu1fp09hq8spc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRGVjZW1iZXIgMTIsIDIwMjEgMzo0MiBBTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTEyLTA5IDA0OjI4LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBGcm9tOiBCYW93ZW4g
WmhlbmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+DQo+DQo+Pg0KPj4gICAvKiBUaGVz
ZSBzdHJ1Y3R1cmVzIGhvbGQgdGhlIGF0dHJpYnV0ZXMgb2YgYnBmIHN0YXRlIHRoYXQgYXJlIGJl
aW5nDQo+PiBwYXNzZWQgZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+
PiBiL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oIGluZGV4IGY2OTcwMjEzNDk3YS4uMTU2NjJj
YWQ1YmNhIDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4+ICsr
KyBiL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+PiBAQCAtNTUxLDYgKzU1MSwyMyBAQCBz
dHJ1Y3QgZmxvd19jbHNfb2ZmbG9hZCB7DQo+PiAgIAl1MzIgY2xhc3NpZDsNCj4+ICAgfTsNCj4+
DQo+PiArZW51bSBmbG93X2FjdF9jb21tYW5kIHsNCj4NCj5SZWFkYWJpbGl0eToNCj5mbG93X29m
ZmxvYWRfYWN0X2NvbW1hbmQ/DQpPaywgd2Ugd2lsbCBtYWtlIHRoZSBjaGFuZ2UuDQptYXliZSBp
dCBpcyBtb3JlIHByb3BlciBmb3IgIm9mZmxvYWRfYWN0X2NvbW1hbmQgIiBhcyB3ZSBkaXNjdXNz
ZWQgaW4gcHJldmlvdXMgcGF0Y2g/DQo+DQo+DQo+PiArDQo+PiArc3RydWN0IGZsb3dfb2ZmbG9h
ZF9hY3Rpb24gKmZsb3dfYWN0aW9uX2FsbG9jKHVuc2lnbmVkIGludA0KPj4gK251bV9hY3Rpb25z
KTsNCj4NCj5TYW1lIGhlcmU6DQo+cy9mbG93X2FjdGlvbl9hbGxvYy9vZmZsb2FkX2FjdGlvbl9h
bGxvYw0KPg0KPj4gK3N0cnVjdCBmbG93X29mZmxvYWRfYWN0aW9uICpmbG93X2FjdGlvbl9hbGxv
Yyh1bnNpZ25lZCBpbnQNCj4+ICtudW1fYWN0aW9ucykgew0KPg0KPg0KPg0KPg0KPj4NCj4+ICtz
dGF0aWMgdW5zaWduZWQgaW50IHRjZl9hY3RfbnVtX2FjdGlvbnNfc2luZ2xlKHN0cnVjdCB0Y19h
Y3Rpb24gKmFjdCkNCj4+ICt7DQo+PiArCWlmIChpc190Y2ZfcGVkaXQoYWN0KSkNCj4+ICsJCXJl
dHVybiB0Y2ZfcGVkaXRfbmtleXMoYWN0KTsNCj4+ICsJZWxzZQ0KPj4gKwkJcmV0dXJuIDE7DQo+
PiArfQ0KPg0KPkFnYWluIC0gYWJvdmUgb25seSBzZWVtcyBuZWVkZWQgZm9yIG9mZmxvYWQuIENv
dWxkIHdlIG5hbWUgdGhpcw0KPmFwcHJvcHJpYXRlbHk/DQo+DQo+PiArDQo+PiArc3RhdGljIGlu
dCBmbG93X2FjdGlvbl9pbml0KHN0cnVjdCBmbG93X29mZmxvYWRfYWN0aW9uICpmbF9hY3Rpb24s
DQo+DQo+DQo+SSB0aGluayBpIG1lbnRpb25lZCB0aGlzIGVhcmxpZXI6DQo+DQo+PiArDQo+PiAr
c3RhdGljIGludCB0Y2ZfYWN0aW9uX29mZmxvYWRfY21kKHN0cnVjdCBmbG93X29mZmxvYWRfYWN0
aW9uICpmbF9hY3QsDQo+PiArCQkJCSAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKVwN
Cj4NCj5uaWNlDQo+DQo+DQo+PiArDQo+PiArLyogb2ZmbG9hZCB0aGUgdGMgY29tbWFuZCBhZnRl
ciBpbnNlcnRlZCAqLw0KPg0KPiJhZnRlciBpdCBpcyBpbnNlcnRlZCINClRoYW5rcywgd2Ugd2ls
bCBtYWtlIHRoZSBjaGFuZ2UuDQo+DQo+PiArc3RhdGljIGludCB0Y2ZfYWN0aW9uX29mZmxvYWRf
YWRkKHN0cnVjdCB0Y19hY3Rpb24gKmFjdGlvbiwNCj4NCj5uaWNlLg0KPg0KPlwNCj4+ICsJZXJy
ID0gdGNmX2FjdGlvbl9vZmZsb2FkX2NtZChmbF9hY3Rpb24sIGV4dGFjayk7DQo+PiArCXRjX2Ns
ZWFudXBfZmxvd19hY3Rpb24oJmZsX2FjdGlvbi0+YWN0aW9uKTsNCj4NCj50Y19jbGVhbnVwX29m
ZmxvYWRfYWN0aW9uKCk/DQo+DQo+DQo+PiArc3RhdGljIGludCB0Y2ZfYWN0aW9uX29mZmxvYWRf
ZGVsKHN0cnVjdCB0Y19hY3Rpb24gKmFjdGlvbikNCj4NCj5uaWNlLg0KPg0KPj4gK3sNCj4+ICsJ
c3RydWN0IGZsb3dfb2ZmbG9hZF9hY3Rpb24gZmxfYWN0ID0ge307DQo+PiArCWludCBlcnIgPSAw
Ow0KPj4gKw0KPj4gKwllcnIgPSBmbG93X2FjdGlvbl9pbml0KCZmbF9hY3QsIGFjdGlvbiwgRkxP
V19BQ1RfREVTVFJPWSwgTlVMTCk7DQo+PiArCWlmIChlcnIpDQo+PiArCQlyZXR1cm4gZXJyOw0K
Pj4gKw0KPj4gKwlyZXR1cm4gdGNmX2FjdGlvbl9vZmZsb2FkX2NtZCgmZmxfYWN0LCBOVUxMKTsg
fQ0KPj4gKw0KPj4gICBzdGF0aWMgdm9pZCB0Y2ZfYWN0aW9uX2NsZWFudXAoc3RydWN0IHRjX2Fj
dGlvbiAqcCkNCj4+ICAgew0KPg0KPm1lbnRpb24gb2ZmbG9hZCBzb21ld2hlcmUgdGhlcmU/DQpG
b3IgdGhpcyBmdW5jdGlvbiBvZiB0Y2ZfYWN0aW9uX2NsZWFudXAsIGl0IGlzIG5vdCBvbmx5IHJl
bGF0ZWQgdG8gb2ZmbG9hZCBwcm9jZXNzLCBpdCB3aWxsIGFsc28gcmVjeWNsZSByZXNvdXJjZSBm
b3IgdGhlIHNvZnR3YXJlIGFjdGlvbi4gDQpTbyBpdCBpcyBiZXR0ZXIgdG8ga2VlcCBpdCBhcyBp
dCBpcyBub3c/DQo+DQo+DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc19hcGkuYyBiL25l
dC9zY2hlZC9jbHNfYXBpLmMgaW5kZXgNCj4+IDMzYjgxYzg2N2FjMC4uMmExY2M3ZmUyZGQ5IDEw
MDY0NA0KPj4gLS0tIGEvbmV0L3NjaGVkL2Nsc19hcGkuYw0KPj4gKysrIGIvbmV0L3NjaGVkL2Ns
c19hcGkuYw0KPj4gQEAgLTM0ODgsOCArMzQ4OCw4IEBAIHN0YXRpYyBpbnQgdGNfc2V0dXBfZmxv
d19hY3Qoc3RydWN0IHRjX2FjdGlvbiAqYWN0LA0KPj4gICAjZW5kaWYNCj4+ICAgfQ0KPj4NCj4+
IC1pbnQgdGNfc2V0dXBfZmxvd19hY3Rpb24oc3RydWN0IGZsb3dfYWN0aW9uICpmbG93X2FjdGlv
biwNCj4+IC0JCQkgY29uc3Qgc3RydWN0IHRjZl9leHRzICpleHRzKQ0KPj4gK2ludCB0Y19zZXR1
cF9hY3Rpb24oc3RydWN0IGZsb3dfYWN0aW9uICpmbG93X2FjdGlvbiwNCj4+ICsJCSAgICBzdHJ1
Y3QgdGNfYWN0aW9uICphY3Rpb25zW10pDQo+PiAgIHsNCj4+ICAgCWludCBpLCBqLCBpbmRleCwg
ZXJyID0gMDsNCj4+ICAgCXN0cnVjdCB0Y19hY3Rpb24gKmFjdDsNCj4+IEBAIC0zNDk4LDExICsz
NDk4LDExIEBAIGludCB0Y19zZXR1cF9mbG93X2FjdGlvbihzdHJ1Y3QgZmxvd19hY3Rpb24NCj4q
Zmxvd19hY3Rpb24sDQo+PiAgIAlCVUlMRF9CVUdfT04oVENBX0FDVF9IV19TVEFUU19JTU1FRElB
VEUgIT0NCj5GTE9XX0FDVElPTl9IV19TVEFUU19JTU1FRElBVEUpOw0KPj4gICAJQlVJTERfQlVH
X09OKFRDQV9BQ1RfSFdfU1RBVFNfREVMQVlFRCAhPQ0KPj4gRkxPV19BQ1RJT05fSFdfU1RBVFNf
REVMQVlFRCk7DQo+Pg0KPj4gLQlpZiAoIWV4dHMpDQo+PiArCWlmICghYWN0aW9ucykNCj4+ICAg
CQlyZXR1cm4gMDsNCj4+DQo+PiAgIAlqID0gMDsNCj4+IC0JdGNmX2V4dHNfZm9yX2VhY2hfYWN0
aW9uKGksIGFjdCwgZXh0cykgew0KPj4gKwl0Y2ZfYWN0X2Zvcl9lYWNoX2FjdGlvbihpLCBhY3Qs
IGFjdGlvbnMpIHsNCj4+ICAgCQlzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgKmVudHJ5Ow0KPj4N
Cj4+ICAgCQllbnRyeSA9ICZmbG93X2FjdGlvbi0+ZW50cmllc1tqXTsNCj4+IEBAIC0zNTMxLDYg
KzM1MzEsMTkgQEAgaW50IHRjX3NldHVwX2Zsb3dfYWN0aW9uKHN0cnVjdCBmbG93X2FjdGlvbg0K
PipmbG93X2FjdGlvbiwNCj4+ICAgCXNwaW5fdW5sb2NrX2JoKCZhY3QtPnRjZmFfbG9jayk7DQo+
PiAgIAlnb3RvIGVycl9vdXQ7DQo+PiAgIH0NCj4+ICsNCj4+ICtpbnQgdGNfc2V0dXBfZmxvd19h
Y3Rpb24oc3RydWN0IGZsb3dfYWN0aW9uICpmbG93X2FjdGlvbiwNCj4+ICsJCQkgY29uc3Qgc3Ry
dWN0IHRjZl9leHRzICpleHRzKQ0KPj4gK3sNCj4NCj5JIHRoaW5rIGkgbWVudGlvbmVkIHRoaXMg
b25lIGVhcmxpZXI6DQo+dGNfc2V0dXBfb2ZmbG9hZF9hY3Rpb24oKQ0KVGhhbmtzLCB3ZSB3aWxs
IG1ha2UgdGhlIGNoYW5nZSBmb3IgdGhlIHJlbmFtaW5nIGZ1bmN0aW9uIGFzIHlvdXIgc3VnZ2Vz
dGlvbi4NCj4NCj5jaGVlcnMsDQo+amFtYWwNCg==
