Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8066612BDD
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 18:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJ3RYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 13:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJ3RYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 13:24:11 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2071.outbound.protection.outlook.com [40.107.96.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638EF1BB;
        Sun, 30 Oct 2022 10:24:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGjrmHhNp1US7gOI9QoypQ0GasxAjSVAWhe5rhVJ0Kw43IJ5/4ivINt9OZ3bXxZ3/jCNfbYpp2Kyrf0fJubyQLzsLPrRMhDnLS3NYiF3PUGLTYWX8mWIedI7fXqJoJHlgdKlR/yfAhSa9bG3f663RM5aoL5yEEZNSjt2mFS9LXSv/d0JEh5i22TY3+HtSWJjPzuVLJcy7Agx1DKx/6d2p/eT765s62CvYYYabVLbYwHRpl4ka0MRbpb7LqLc5P7whcn8uAfQiFLmVWxuA/L5REUqgHQCA1PFbw5rfNIDg1+TuGvo59edA/BrscrxVJpG9J5dr5tKiHObHzK5HN54xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3qxFaIlt0pnpzQ8dzWSv0gPAkuabZmjssp4AzBhCCg=;
 b=ZguPOaypIqsNcT69CfiWEWKDNxEQSi5QcCGCiilYgEMJmzeDujXpMY4y04KPQ59SqLmBmPrGlFxytp7GHV9P6E5sFMPJMohUnCDUgg+ImILLwlLIlIoth3niS8T0tf2T+0Id2FY2t8MsFxn+cfvFYa5/gV4X8nxC9UYp1u7AXBcTXVA4OGjoCkIDa2JZAyYwieoaXCZRtmPmZcOdONhUFDxP5OyPVYxOaVo1TMwZyja5plb3bnbokfGO9m8lZogmlvpvKjP5lZd7p8B6yjq1HACbdMVDGDpvRSpxQjVViM3vLLcJabfWI1vf9sukk1YGQvryVH4grC4luYhXl4Cs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3qxFaIlt0pnpzQ8dzWSv0gPAkuabZmjssp4AzBhCCg=;
 b=KvG8uoWFVOJmHJMLepM4Ys9qtXFVl8qc2zwcTeqS/407A00W/cIFi0UQpTLCgjvwOWWZzCBDMC/l/yZRLJf1Y33oSj8AU2ocCOEDuqSritenPV6y+iOOmWcXbZn4C0tlP7y0KAXwzcCp92v+Ht/ky23GZzW53ZIoCOH7nS6BBakfEfFarCqQv3hIAEoQB3Zl/cQcLSxWBMDDcqVfari12JEcXaAgzZzxIYUrI3tk1jqP1QO7Tg9zMSTkgtEaw8/RYtyCVhLAzCZsheXc10D457VqewqPSQPSyW8/JCYjjBEINsCntWRgi6wovXS6BZcM+eIMKPP+W0SIKXIqD72fNg==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Sun, 30 Oct
 2022 17:24:05 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::baf8:b66f:96f4:41c]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::baf8:b66f:96f4:41c%8]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 17:24:05 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Thread-Topic: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Thread-Index: AQHY4rrj5yTYQO5x8keLlrVA7994K64eugCAgAA6pYCACE5PIA==
Date:   Sun, 30 Oct 2022 17:24:05 +0000
Message-ID: <BN9PR12MB53816062FAE98EEFEF319644AF349@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
 <20221014073253.3719911-2-daniel.lezcano@linaro.org>
 <Y05Hmmz1jKzk3dfk@shredder> <cb44e8f7-92f6-0756-a622-1128d830291c@linaro.org>
 <Y1e7MRozZYSHgV0V@shredder>
In-Reply-To: <Y1e7MRozZYSHgV0V@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5381:EE_|PH8PR12MB7207:EE_
x-ms-office365-filtering-correlation-id: 6276f85c-04cd-4027-5af3-08daba9b8bc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRlxYWYqCU00LmM7jARvJu6WCzuaZxXT2vfc1Jtf1F3Nv1kh81JvEUnktoP2ncL1fTRO7CdjmV3d6QC2zD4CkA07qwUL4D1yxL8mHOFpZ2gktDeIRQJ2nTBXvQ/f+YGei49aSeN/cr+fRtoOIxnO+PCASh4mKsJu38sfsx/wjANUVpXlHn+3OIJMT3zfev8MQR3wqdfHc/+CDlziM6oOz3EOD2eowEDBl2+Two8ha6sYZj/45P29OHJuRwWYw840tYTxKETg+/eR9BXIndXVFAJxEtvkVjgPkJbj0oYen2bcViswBiUnhyNZSOBjEcq597tu5+TAXqG2MxfZ4qjyioHKIQWX5tRTh2Uqv82kT0XINhzNtEfC0X/TiRcU6EANup2MvSh4Ihl59WqtyLK08WsyV7HdSKJhEe20Ub+4tgWBrNjSJbTi+J5mghGFLy85KmP9aRgWCpx27ObTnAhO47zo3relYefixUUnrosOCuNsI4yJ29Sz/NM822mqfyCLNG7JenOuvVJ7EnzNdXCIFqrarhHhcRNEP/iftIhSyoGk4PAr9c5vr17YZKbbhzSw/ImR2lfi9TIcWu2jT2iZYv75cy2xHtEjAZeYu9oxSkSX1rZC0P2KUzviaAxgvZg/adnKzbMqK3fTEyG7rpx51oLtbVnRpjjpSQZ0lD2CD6gRiRabEO+iU/HLxXt9EVPSUIKATcS9cN0L0VwnKqAIhOtkRunD0/BQ2lox7sMEqHnslB1wnJOMfx0Y6ui+GlFM7Xc70zblYUPeJtZDZHzknhn+BNzkp6+2n8EWtO6Aubc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199015)(7696005)(6506007)(26005)(71200400001)(316002)(8676002)(478600001)(9686003)(53546011)(66446008)(76116006)(66946007)(66476007)(66556008)(64756008)(4326008)(186003)(2906002)(5660300002)(83380400001)(8936002)(41300700001)(52536014)(38070700005)(33656002)(55016003)(122000001)(38100700002)(54906003)(86362001)(110136005)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alBHS1JiQVd2Y3VrZUN3VHlNc3JGV0lOdStDOVlqZFJQd2l2NGtEVlArNEF1?=
 =?utf-8?B?cldWM1VzakYwSFdqZFFOSElWMUgyTmxGYXJ1MmgvN3Z6WGwxZnc5bW1mVXdM?=
 =?utf-8?B?NUpKZTB5alpucE55QnZ0SVJsb3hqcUl3bTlxTXNOcHFQS2RtRWFndEVJbTBm?=
 =?utf-8?B?RVB5L1NweU16bHFDMzBGR0h0VjJyMkt4L252ei83UTJ2ODJNaXRNQzJvY3Fl?=
 =?utf-8?B?czNFTnVRWUhNSU9xR2hzbERaZ0FrTU9wVkNWYnJaM29xUDZLdzU0eElBUHg1?=
 =?utf-8?B?Y0dGeFhVNnpmMHcvczU3ZGtTaVJBSTYxd3AxL2lrVXNGQTVsSjM4K1lTY3BV?=
 =?utf-8?B?alZQYkNOK1dCVGF1Y3BKV3cwa1VxOXZkZXlTWEZKdjA5WkxjZnlUTmh3NDcr?=
 =?utf-8?B?dWJqMVVaeDZSODUya0xGd0YzQzN4WkN0YThwbFY1UTludmJsbVhodUV0dWlC?=
 =?utf-8?B?T2RuZWJVVFA0VkE1ZUxhQldva2FMdkY2UDFud3JIcEpLc1BkRzk2SzRVaXdQ?=
 =?utf-8?B?NEp1Rm5kSXNNWFpLSXZOV3RlZXRYdHlWVEFsTlpzWlgwVEpiUzhqNG9qZzF2?=
 =?utf-8?B?aFJuS2MvTGF1RU5UaXE3L3Z5VFJsODFZNDRuSy9iSWFrVEM4ZlNtMldoa200?=
 =?utf-8?B?eFgvL1pnc1Q1NzR0ZmZhQ01sclVidTBkNEpRaVVtNGVNc3NFemQrZURvMzVJ?=
 =?utf-8?B?MVdqNC83UU1JTDVyT01yVVh5SE00NFJtMVRXVXlQS0NaeHhnRnE1aldxQzlO?=
 =?utf-8?B?RE1QZzdJVjRWTHFCbGYxWU82K3d5aTNyakhCL0RZYWpQeEJyek1YaUhMMG1T?=
 =?utf-8?B?Q2Zlb2psWVJ5MlBkOUJrOUU0WjJmQ3R3cnpPbi9KMzdPRStGWFhtMnFPTGdB?=
 =?utf-8?B?aGlGME94YUxoVVBJSFlqcUJwd2Z4VDlIVzVrK2lXTlgvRWtzVmRGUVVGUVRo?=
 =?utf-8?B?T3AwNE43M1VaUzJESEtpZy9IdEpnWG9TQ3QzWTlXdjFrRkU4cHFEUElleW9a?=
 =?utf-8?B?NzhNRmVsT05ER2psOEpSQVpKZGFMNTV1SUE1cjJpNXZINzY0bU9vSmVNdmps?=
 =?utf-8?B?TnFuOGY4NjZtSFVJRjRVVDhhQWducC9tanZtWUdaYjFMZFZaVE10V1JjOUs1?=
 =?utf-8?B?cEdWQTR5TkkyZEdPUVFRYng4SS9FSDhyTnc2amFOK2c1RURKV2l1VWtBV3lG?=
 =?utf-8?B?MDI3ZFpYUW9uYTR1V05HdWZnT2xsT21oekZUL29MTTEyTy9mRXJPN1YwQ1I4?=
 =?utf-8?B?R3dxUWFrTkx2MmdQT01mUitwZk9MT0YySnIyL0g1MHNqYUo4Qlp5ekZjNXNK?=
 =?utf-8?B?RytYb3RwWHczZWY4d0VkWVFSd3J5UTNHa09JRzFVL1ZoMHZSclFicFdPcHFE?=
 =?utf-8?B?N3dEOTdYTjFZc3V6aEZKZ3dVMEpPZTJvMExjS0hCZjVRR1l6NThXWU0zaVlJ?=
 =?utf-8?B?M0JFVFRySTFZVUlWK0Z4TmUwekJoYkhPTUhkSGVzRW9YSy9IOC9qWTlQNjhZ?=
 =?utf-8?B?bk5nczF0a0VnMHkycnlMc0lIVzZLVGxKbWxDYXU1NWVUS29zQmQ1Qm1tQzVw?=
 =?utf-8?B?VGcycitXc0wyN0R1dkYwTndKc3RSWXZyemprNzFZbm5USWc3VGRQcVpEb1NO?=
 =?utf-8?B?ZkY3S3ErVXNBczluSWRwS0xGOVkyOG5pQ3UybVJEakRVTWdrMlRNeWdJaTY4?=
 =?utf-8?B?NFA0V1BZdkxLS0tlR3VxeU1kdzFKUjY1ZVlxbTZvTllaUHJvcjZuVkVIRFVN?=
 =?utf-8?B?VHZkWWlQQzlMVU11ZFRmdDltN3JmbGNxRW5mVXdtYWlqWGltblJDOVR1QWFN?=
 =?utf-8?B?K3YvSGpUVFZTSW9BU3I4RmVsSGlJajNURkllMDNFSXE0NUhWYVpncE9TMFlW?=
 =?utf-8?B?c1ZubUlXR05Gd3g3MUJJY0x4d3llMGt0VzNDYUJzL3U4V2ZWZ29FQkFJTFdo?=
 =?utf-8?B?SnVzaVBBOUQxcitqQ3JDM1AyZ0RGN0ltY0s4L1p4RjIwcGROcU5YWWZWeWtD?=
 =?utf-8?B?ZWVYbHdiWUN0TFNzdHNuSThuL3BxeVFtbUsvbXFGTWpnSStmLy92bTVackRp?=
 =?utf-8?B?Vzdrb3ZrREx5Y3dLZzV1cVVXa0JORXhoV25VTWV6b05nS2EwUkM5djFjaDVO?=
 =?utf-8?Q?au5pJXe/YCPYGl2Jjb1cWGZcr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6276f85c-04cd-4027-5af3-08daba9b8bc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2022 17:24:05.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RcosCaOHri42dcYGnr92vwNsZOfYr83JE3zOveVjlatcnD5hgcQa8l6nS5hbLlY/aoB7GzxffUKjA5uOpONLJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSWRvIFNjaGltbWVsIDxp
ZG9zY2hAbnZpZGlhLmNvbT4NCj4gU2VudDogVHVlc2RheSwgMjUgT2N0b2JlciAyMDIyIDEzOjMy
DQo+IFRvOiBEYW5pZWwgTGV6Y2FubyA8ZGFuaWVsLmxlemNhbm9AbGluYXJvLm9yZz47IFZhZGlt
IFBhc3Rlcm5haw0KPiA8dmFkaW1wQG52aWRpYS5jb20+DQo+IENjOiBWYWRpbSBQYXN0ZXJuYWsg
PHZhZGltcEBudmlkaWEuY29tPjsgcmFmYWVsQGtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBwbUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFBldHIgTWFjaGF0YQ0K
PiA8cGV0cm1AbnZpZGlhLmNvbT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD47IEVyaWMNCj4gRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+Ow0KPiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBv
cGVuIGxpc3Q6TUVMTEFOT1ggRVRIRVJORVQgU1dJVENIDQo+IERSSVZFUlMgPG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSB0aGVybWFsL2RyaXZlcnMv
bWVsbGFub3g6IFVzZSBnZW5lcmljDQo+IHRoZXJtYWxfem9uZV9nZXRfdHJpcCgpIGZ1bmN0aW9u
DQo+IA0KPiBPbiBUdWUsIE9jdCAyNSwgMjAyMiBhdCAwOTowMjoyM0FNICswMjAwLCBEYW5pZWwg
TGV6Y2FubyB3cm90ZToNCj4gPiBCZWNhdXNlIEkgaG9wZSBJIGNhbiByZW1vdmUgdGhlIG9wcy0+
Z2V0X3RyaXBfIG9wcyBmcm9tIHRoZXJtYWxfb3BzDQo+ID4gc3RydWN0dXJlIGJlZm9yZSB0aGUg
ZW5kIG9mIHRoaXMgY3ljbGUuDQo+IA0KPiBPSy4gVmFkaW0sIGFueSBjaGFuY2UgeW91IGNhbiBy
ZXZpZXcgdGhlIHBhdGNoPw0KDQpJdCBzZWVtcyB0byBiZSBPSy4NCkFueXdheSwgSSdsbCB0YWtl
IHRoaXMgcGF0Y2ggZm9yIHRlc3RpbmcgYnkgdGhlIGVuZCBvZiB0aGlzIHdlZWsgYW5kIHVwZGF0
ZS4NCg0KPiANCj4gPiBNYXkgYmUgeW91IGNhbiBjb25zaWRlciBtb3ZpbmcgdGhlIHRoZXJtYWwg
ZHJpdmVyIGludG8gZHJpdmVycy90aGVybWFsPw0KPiANCj4gSSBkb24ndCB0aGluayBpdCdzIHdv
cnRoIHRoZSBoYXNzbGUgKGlmIHBvc3NpYmxlIGF0IGFsbCkuIEluIHByYWN0aWNlLCB0aGlzIGNv
ZGUgaXMNCj4gdXBzdHJlYW0gZm9yIGFsbW9zdCBzaXggeWVhcnMgYW5kIElJUkMgd2UgZGlkbid0
IGhhdmUgYW55IGNvbmZsaWN0cyB3aXRoIHRoZQ0KPiB0aGVybWFsIHRyZWUuIEkgZG9uJ3QgZXhw
ZWN0IGNvbmZsaWN0cyB0aGlzIGN5Y2xlIGVpdGhlci4NCg==
