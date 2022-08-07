Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6E658B9F6
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 09:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiHGHBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 03:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiHGHBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 03:01:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A01B4AA
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 00:01:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltEIDQoCmJ/n+qYZoEQ/DeVR9UmiaTG2mk58UKac83IcsKb/p/DJKOfrS/aatnZoDlqIBCvy6taVFsVZEI4AGguqXUqbe49FdJOKSEe+groOY2Tvu6u7FYKC8HIpVG1iYa0bY0Ggorx7E31PeYsKFqGgr1LYCi6m46sEBk8ELCCooWroIfU1NVDrEU9Hia6CWmNuNi0vEbz5WvjwlHd//FQp0LAuE+k/q1LOH/MTR9D0CU+qHifPgJ+nyo3vR8JW36lm+lDcFMLEmY19gIGXBXr6t+WfA0Clg20TBbFztOe4SsMgZdM5m/p1UnsnSoicZ3nJgXLVxd8DdYzuepuFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SK4dwZDghYPB1MDv6hd1165GcqRMKM9ctalMqZG1Da8=;
 b=c97Ufywlql3dVl2IqZan/XEve/QqjBzREZVZTJ0k+POcqnzMzwmZy+clNfr5gWY+Rk2EMo/MbK/SUBvf0X4veujJce2A4VOeJheET29RTvMq/HsaDBCx0iEkSygR0QG9Ualh919rIKGwVkZsWrgGCPCiQ/ODnClIVi/qtOBpuyD0ZZxMx4Aw3gRrmRXM5Dv+WjOnExbHCHYqbszyNaPjUjMip3XSKg2zjLFrsWSedIOwfyLXgKVAgxYh6o9QHRB57xn3XfOC7klHlswLHxXLBB6CP2xjaOEuxo6vgn1BKxCTFaelfNMQBMUKi+Sextzer08+diGVc5/fpjOT+M/Reg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SK4dwZDghYPB1MDv6hd1165GcqRMKM9ctalMqZG1Da8=;
 b=MxhiScVCfravCDVURzKiLoajkzTa+RpVrHWrfIGap9nQl/4EojTcOal9MJfMMvM7vLkzylCgmsWF8dmVQG3MlvB+sTBqv2B5U9jyusBrY//TZ75+zn0R/61Bam4bEP2GUc5xEumzHe0UcqMg7TPrhu9V6DFHgaSKM32vy5lbRjAtLewlPlyV/3E5jDxGDITyXgTDLTu+3BOvKmqgpqruro+FQPOLfJWGJkKFulzuwDeWveeDZ2Gz1b+KquF4xeSdOMyZaLKzDfQId8Lx3h2tXNtp94ekg93lZ7OKO/ZYW0xXAb4Y/ORsQj0QAcea5SP4tTIQHfj6p3p2+w8p7SpQAw==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by CH2PR12MB4838.namprd12.prod.outlook.com (2603:10b6:610:1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Sun, 7 Aug
 2022 07:01:10 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::8c93:ee3:9321:997c]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::8c93:ee3:9321:997c%2]) with mapi id 15.20.5504.014; Sun, 7 Aug 2022
 07:01:10 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: RE: [PATCH main v2 2/3] macsec: add Extended Packet Number support
Thread-Topic: [PATCH main v2 2/3] macsec: add Extended Packet Number support
Thread-Index: AQHYpjeyTWDMWBt53EeMmZdV/KWh3q2e93+AgAAeUgCAA/STkA==
Date:   Sun, 7 Aug 2022 07:01:10 +0000
Message-ID: <IA1PR12MB635329D8F3D33A42C5977D1EAB609@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20220802061813.24082-1-ehakim@nvidia.com>
 <20220802061813.24082-2-ehakim@nvidia.com> <Yuv4RXYlYE6LM2d5@hog>
 <5798fe5b-8424-c650-aac0-5293e1d907b4@kernel.org>
In-Reply-To: <5798fe5b-8424-c650-aac0-5293e1d907b4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d56f5c1f-8083-4253-c8a4-08da78429b9e
x-ms-traffictypediagnostic: CH2PR12MB4838:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XFubUCqHvvibBzRIYif+4vemWHVSHpan9vxHzjTj2CzhDYu8KHyOd05NzKR0UwGuEg34h1Zht90hSxIrvX7+XDPKdYz2ylaQW5zLRZKJnEnvKxEGgL5thAIrB3atXk46eThhmFki/dyTAl0K5E/JwtgxLnD2NU5WcEC9BdyS2bZ2kLFzSA/Xp1j10lCLk985DpEJx2HBdmSGCtswpEcfJsv0UkCv7/CnLHahFl/NIHL5WuKLePzd7E5PwPJgKhtr7/FxmHRmLRDeFCnzosj70lvfZAeyBYOEjZNa2nQPrP6uO6wUXA1qRyfpVSaUZV3i4UbU+oGajF3HxuPgrESUnUe2tMUukBLaAGmRVIbcZb16997mvx9pCWizdePlofF783vTOv9nQvcF1OTfmebSJvTP4eAPsJAyeHU6F5dYFZ+fBceLKKppwUIPHh3w+KUTbsOxqxfQin0JpdCO3z/nrZ9H5ktiyN0QODi0J+wXEmj83T0YFc8KpX0ouLCvlg12r3IO76ZeU2vQiwRir/9hQ+a4A+rEeIWjA3P3kBBSCgzwECjagDHWD6WFyJ+bp3dxNdUuHwTQNUfy2/wa/wMujrA44ZAEzIxFxdaX0zPOlKX78f2/Bf37X6ijwKhcD0jyV4RPNC7ISTaMSHjJdygyfvyg+2kU1Ixx/Dw0TsFjrhJ80tSWXWvaVcN8raUbvpp/0OHQeJy/uDoeJfkWd+YgsdxVB1Kh/ekgpYVv4glPmevjgy4f+iJ/f9pCbuD/YP+0sFFuADymazkhhKg6IKagWtNDZIXau/lL0rYgKizz+aM08UnUSURT8y1vzMhUafSi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(83380400001)(38070700005)(71200400001)(7696005)(33656002)(107886003)(55016003)(54906003)(110136005)(316002)(9686003)(6506007)(76116006)(66946007)(53546011)(4326008)(66476007)(66556008)(8676002)(26005)(186003)(86362001)(64756008)(8936002)(5660300002)(2906002)(41300700001)(478600001)(122000001)(52536014)(66446008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXhmTjVmcXJ6YllzZXREdVVTSmdNdTY4NHY0bzNRM2RDSlU5eDFISlM2SzRu?=
 =?utf-8?B?NDdNU1hMUG43bTB5dVA5eXg1NlFjaVJFQzZXVFJCL1JodlFkREk2RjFBV3d3?=
 =?utf-8?B?RHZOeTVhdkl6ejMza3lUOUVTTzJITGg3Y0lkVDFzaWdCK1k5WlZPUnV2SUFB?=
 =?utf-8?B?eW1ZM052a2s0V1FMODRyV0xheHNmbEY0UXQ1d3FoeDNxanhyYkYyYzJ3UVVD?=
 =?utf-8?B?TnFQN1d4d3E3K3BPNDdHRytQdXdTYU80cHVHdzRTbFlQcE9KU2ljRTFCRXUy?=
 =?utf-8?B?eG9ZRndjUTkzK09DdnF6SjVJc3ZGbmRFSExsQXBVWWlxam5aZnExbmVvNmN3?=
 =?utf-8?B?MGZMcUt5VC91WXhHVFh3V3NqYWNqYnZ1eFhZeEFlVG1PenljZ2FEUE5mLzdp?=
 =?utf-8?B?K0VpVFhpcmVncVlueUdiZm1oN2VMcEVlWWI0MEJGWVpzRjRhNUNwUm5weFh2?=
 =?utf-8?B?SzdEaUZGRFk2MDlyTjRPY0xvemEzdzMrVmNwQ1NOQ0NGV0x0MTZEVi9OSnRT?=
 =?utf-8?B?N2JUMEpzNXFoRHIwVnljdmxIYmFaYlBLR3ZrQzRQTVhHTnVySnJhczZQKzEz?=
 =?utf-8?B?VEc0VUoyMnNvaGthTXBZS29HVElaWlN3cVduMXVBY0lYK29sbmJLUVluWnJ4?=
 =?utf-8?B?RWk4Z1RSQit5VUZOQkFzWCtEbDZNRXNINEdmbHA3ZVZaK2hXTGhVZlU4NWNI?=
 =?utf-8?B?c1FlZVNqbTM5Zkc4MUI1TDIrNEhiMGY5b0R5Sm1Oc21zTlBadG9wY1hCVk5G?=
 =?utf-8?B?SmRhRWE0ZDQ4akYvOXJ6clNZY1pwU08vcVlnckExUnY4dlBqUEVLOVphSTZZ?=
 =?utf-8?B?TTdTUXNtYkpiMEhtK3l3TXlnL2VSNFpOZUJQdjRnTHFMeHRpRTZXcFNjNXZZ?=
 =?utf-8?B?M3ZEY2E2WnpubkRNS2FEMExMZXpURkUzV3J1SGEzTG1RVFFJbytKY0V4RXhx?=
 =?utf-8?B?TFBGMmk5WDZESStTa1lXRmNnblRyaGViWHJyUWMvOW1vUk1mTFR4MTNSVmVG?=
 =?utf-8?B?TTQveEU5Qk96UWFaTytTL2hOMkhQVjVRU29KQ1YvbUc4SmQ3ajk2bWxtcCtl?=
 =?utf-8?B?OGxFWmk4MEhMMkp2VXpHcjg1K0JPYTZESUxOMkpjNm1xYjdvdERZOHh2bkZq?=
 =?utf-8?B?dkxOUEpJUTZhNTVSOFBzVnZVZGhjM0Z3SEFidE12a0ZYQW9vQ21ubFZGMWov?=
 =?utf-8?B?Z0lIdjY1R25Yc29zSmdzY1ArQU41UERSQ1NyWDBvellKSHg0MjhVTnFyMkJl?=
 =?utf-8?B?dFZrRWM1RmNneWdBRG91VmN3RThaS0FKTUdNRm1JWDJNeWU1SW93V1Y3UnRt?=
 =?utf-8?B?OVlyVyt4bkt4d0JGVlhPclBwSkRWY1NPQldTNWZzcVQ0elBkSWVCWWJmSDBr?=
 =?utf-8?B?WEZxMjZvdGk1VnFvdVlkRGRwVCtGT1JsMkU3TGRoeVFCUlRibUhFd3ZRaWRL?=
 =?utf-8?B?ZXVNWDEwM3lsSXMwY2xMOFFoTWNkWVRUa3FJZHFXVE1UWUZ5ZHVkVzZ0QllE?=
 =?utf-8?B?SXlHdzhGTE1IZkMyVDJWRWZ5Ymx6empveFRzbUg0M1JUYlJqSmJhKzZ0cW93?=
 =?utf-8?B?RzhWVWNIblRhSXJpOU42RWtSMHkwS2VWY3BXQlF6TW1LMjlQcFRrVXhiL0Mv?=
 =?utf-8?B?WUt3N3Vqa3J6b2VibkdibENxVDlzWFo4TzJoVm01THU3ZDBuMWc0Si9sQ0N2?=
 =?utf-8?B?aEQ5WEZSaEYzVVVlWUNZeHowRStyblFPZXQ5VU13Z2ZpbzdHL2pPd3RPL0V0?=
 =?utf-8?B?SWR2Nm82TDFCcG9MU0h0MTBMYXZ5ZllqZzE5dndLdGxqUFpaTGFDNTNvMGdm?=
 =?utf-8?B?Wi9kREFpQk4vem1MYW5KL2djSU4rMHBuc2JBWGpPNmZOZFZPTUx5SHZ3RUE1?=
 =?utf-8?B?anRQak5ZR3FkUmlWdzhsTEF3RDh3YjBQK24rc3hDWlhGdmlQenVrOGxiSHEr?=
 =?utf-8?B?NkhiM0ptbEdCK2F0VDYzd3RzVm52VlNGdzVJRTFiMVBuSnRidGtHcHNZNzNy?=
 =?utf-8?B?cnhxVEhINGRFOUVxTzE2WlQxa0UxWWZLZWU2UFMxWFRiWllxVWlTSURVdHcx?=
 =?utf-8?B?RXh5MXJMVkdRaXVCb0RJUlRaSTNRMkR5QXduRGNGMDM0MnBrWDlYUDhQWVl4?=
 =?utf-8?Q?VxfA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56f5c1f-8083-4253-c8a4-08da78429b9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2022 07:01:10.0239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KwF0AnEkC4nD9FE5hQyLcUiF+wLETd6SVrJMhh2IyvhSD67ON2S+jK1lgrzoLLhHoZZq5cSlCLDccFq0+hxr+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4838
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5Aa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIDQgQXVndXN0IDIwMjIgMjE6MzcN
Cj4gVG86IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5c25haWwubmV0PjsgRW1lZWwgSGFraW0N
Cj4gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgUmFl
ZCBTYWxlbSA8cmFlZHNAbnZpZGlhLmNvbT47IFRhcmlxIFRvdWthbg0KPiA8dGFyaXF0QG52aWRp
YS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbWFpbiB2MiAyLzNdIG1hY3NlYzogYWRkIEV4
dGVuZGVkIFBhY2tldCBOdW1iZXINCj4gc3VwcG9ydA0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVz
ZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiA4LzQv
MjIgMTA6NDggQU0sIFNhYnJpbmEgRHVicm9jYSB3cm90ZToNCj4gPiBIaSBFbWVlbCwNCj4gPg0K
PiA+IDIwMjItMDgtMDIsIDA5OjE4OjEyICswMzAwLCBlaGFraW1AbnZpZGlhLmNvbSB3cm90ZToN
Cj4gPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pZl9tYWNzZWMuaA0KPiA+PiBi
L2luY2x1ZGUvdWFwaS9saW51eC9pZl9tYWNzZWMuaCBpbmRleCBlZWUzMWNlYy4uNmVkZmVhMGEg
MTAwNjQ0DQo+ID4+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9pZl9tYWNzZWMuaA0KPiA+PiAr
KysgYi9pbmNsdWRlL3VhcGkvbGludXgvaWZfbWFjc2VjLmgNCj4gPj4gQEAgLTIyLDYgKzIyLDgg
QEANCj4gPj4NCj4gPj4gICNkZWZpbmUgTUFDU0VDX0tFWUlEX0xFTiAxNg0KPiA+Pg0KPiA+PiAr
I2RlZmluZSBNQUNTRUNfU0FMVF9MRU4gMTINCj4gPg0KPiA+IFRoYXQncyBub3QgaW4gdGhlIGtl
cm5lbCdzIHVhcGkgZmlsZSAocHJvYmFibHkgd2FzIGZvcmdvdHRlbiksIEkgZG9uJ3QNCj4gPiB0
aGluayB3ZSBjYW4ganVzdCBhZGQgaXQgaGVyZS4NCj4gPg0KPiANCj4gY2FuJ3QuIHVhcGkgZmls
ZXMgYXJlIHN5bmNoZWQgd2l0aCBrZXJuZWwgcmVsZWFzZXMsIHNvIHRoYXQgY2hhbmdlIHdvdWxk
DQo+IGRpc2FwcGVhciBvbiB0aGUgbmV4dCBzeW5jLg0KDQpBQ0ssDQpJIGNhbiBzZWUgdGhhdCB3
ZSBoYXZlIHRoaXMgZGVmaW5lIGluIHRoZSBrZXJuZWwNCihub3QgaW4gYSB1YXBpIGZpbGUgYnV0
IGFzIHBhcnQgb2YgaW5jbHVkZS9uZXQvbWFjc2VjLmgpLCBpZiBJIHdhbnQgdG8gdXNlDQpzdWNo
IGEgZGVmaW5lIHdoYXQgaXMgdGhlIHByb2Nlc3MgaGVyZT8gZG8gSSBuZWVkIHRvIG1vdmUgdGhl
IGRlZmluZSBpbg0KdGhlIGtlcm5lbCB0byB0aGUgdWFwaSBmaWxlPw0KQWxzbywgaW4gc3VjaCBh
IGNhc2UgV291bGQgdGhvc2UgcGF0Y2hlcyBnZXQgYWNjZXB0ZWQgdXNpbmcgc3VjaCBhIGRlZmlu
ZQ0Kd2hpbGUgdGhlIGtlcm5lbCBjaGFuZ2UgaXMgbm90IGFjY2VwdGVkIHlldD8NCg==
