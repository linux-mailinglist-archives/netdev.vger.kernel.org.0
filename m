Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BAB6CD82F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjC2LIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjC2LH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:07:58 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0710D8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3BgQSkD8Ek2uRHIaAmmkkWnxHi71k/XQtYXLWnLhTaKP/vmlencXh7iEKugFolq+8rw1GvjVDhcHtjP+XTFXPOgEo/LHm6O5cgVXyK6/4nw63X1RQB9BNjtRpbyO3mA8Up5UlO2DJgmmHzd7A1E28SBb3MqoVlbuEkrpmyU/yp7vZ81xzUEtlyuHE7v0PmZVQA/XAKv1KxKrNx3rn9+joBmMbHi+VgU7HYmk41utpCF4E5chuub2i67roiaPBBHd5YyM3gGAGt/Tsd2PUrly13GihSW5yGnMyYHAVR4d3QvCyRo+gZF3f4z1oI4W0nil47p9A/DR6+Xk3MWgu9huQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLQIThA9W7C8IlRoNRaW/tZy+/Je1ifAekaio3ruPHY=;
 b=OO9RoIINVIMtkwaRx1JQCMU+NjzaiWdxvBnksQjBadY6txeKcaHYCc8vWtKGacOgfuc05e+4XjoTNdMZKx8wmqSScevYx6sjrBePlAD5D+fS3Il2FTJu/+vYwlijPz9GzE/9whzigDsHrulktIObIEjQYD15NdWGa5OLCUno6IpxSzqoPJIpZvQ4bsek20HgRzV6Lgl6ufnwF+bOXoNLeqRohAhqKm62IoI3owBtDCWmMVUvad8ZV/QKvb6r/xUVlGlY13DEQ5O3Drlm7HcUglLUJU/g+CFlAAOCMJdKvtnmObZSnFnr7RqRV0h3NBxRAQZoIdIPhARddT9wvAE0tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLQIThA9W7C8IlRoNRaW/tZy+/Je1ifAekaio3ruPHY=;
 b=Widn5pMlQcASXnP21smdZO8CYQNz3aEqUh4n53YXqXmwMBMFRzO2cGFC60nhVJcZnuhbi9RQbnQg+TaHgvxZDx0dMn3k0PF4C3UttLyu4LmbEzoHn7x31dzuJI6mBVOZso60oEGmn6xAi/uCEwAQwTrw6aMAGglkL1BQHV77di8h8MncB+J/u8AwcPIzStMoRq/VyoIv1gWx1xPnsbOTTDZ8OX8y/45aadLcQbRHSiWlDKNYFIBbdECI0Ec8TWniFkITWzy1Q+dt6GE6bjvYMEkmTW9jpCfxSjdQC0Z1M89nZeoE+XPwSKs/+3naau9dNX1UxmuBmskQ2ap5NaaR2w==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS0PR12MB8197.namprd12.prod.outlook.com (2603:10b6:8:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 11:07:53 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%5]) with mapi id 15.20.6178.041; Wed, 29 Mar 2023
 11:07:53 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/4] vlan: Add MACsec offload operations for VLAN
 interface
Thread-Topic: [PATCH net-next 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZX7RxM01RMOfCPEGm1w69wBk9+a8O1yKAgADrC2CAAMJigIABEH9A
Date:   Wed, 29 Mar 2023 11:07:53 +0000
Message-ID: <IA1PR12MB635314826FD5DBF23AA17A57AB899@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
 <20230326072636.3507-2-ehakim@nvidia.com>
 <20230327094335.07f462f9@kernel.org>
 <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
 <20230328182033.GA982617@electric-eye.fr.zoreil.com>
In-Reply-To: <20230328182033.GA982617@electric-eye.fr.zoreil.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS0PR12MB8197:EE_
x-ms-office365-filtering-correlation-id: 07cb9869-4946-40d5-6f58-08db3045d7eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HwgWVRdb+/7fduP815hrI//Om2ES1ZMGE1c6skYr2nmuldqYmXe5/MI0EWpa3VpCLtFefNuA6D4OjIvduB3ZIGOAr3cUmtv5cpi2w6AWCxOC/el+5093lDOSE8oMTnCWEJVPY1SZNIqh0Eoq5yGYyJIeBrIukVhAuD/IKmtFJgWCzLl6aYuP036+dgbp/o0YtxvkzcL31FyPTMFLji0lyUwvJbfp+7xj30C23Zb3KIvTueGjbMHefu4eq2CxfF892m3qugd7GfnEBFwbLsJjg32j8j/Sp0WgvsNqU5WLfcv3W9kzC3COV6qT9vIavDqJgxuvomDGCWcMTfuBUjfJDQhrBvTlCuSHolsycb2cFW1hnPPKkccB6at2+bE41JsXY+R/WSpxjqbtif0tZiSzMOXfDAi1+iQ9k0uK6+hx/dFjPIr7EQybsDipSKmvOi/dpQqLBc2TUp8x2P8TFG6JH4O1/zrdg3c9uDWcCQRp7rOsGd2Vrvsoz28XEqUQVKSHtztf9hGlhroxmBhc6GhmN7ebTiAOFlCqlOjZyN2MY4fSHmaaBje9+zxovd9jGr0GL29aQSii46V9q/jsPD+Ua8H/Lp6fnD024sN3ApJLha1mfahOERuNwhuZb3dP78Eq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199021)(86362001)(38070700005)(122000001)(5660300002)(186003)(53546011)(83380400001)(33656002)(9686003)(26005)(6506007)(52536014)(8936002)(41300700001)(55016003)(71200400001)(76116006)(4326008)(7696005)(6916009)(8676002)(66556008)(2906002)(38100700002)(316002)(54906003)(66946007)(66476007)(66446008)(64756008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFRtL1FTcXVOODBHSElrZHdYN1hzZkFtcmFrVndtN0RuM2lzQTFYVUFpSXBE?=
 =?utf-8?B?blhKa0h2aWlPbDNiTnkwMTI1b3dSS0RsVkdIRmlPNi9UZXVGa2hzYmFvMVEw?=
 =?utf-8?B?dElWZjFHK2pzZXJxT3g3TlNDWTd5VFN4eDc3RElqUkhkVlVpZWMrY2ZZSms1?=
 =?utf-8?B?VGZyN2lHUkZLUHZCYW5iWFFkWkpzVHN3b29RZlUvaVBUUlV6RlZ0dFA0RkNt?=
 =?utf-8?B?VUpiK3B6Z1l6UDBCeHJ2Ny9LbHpUc2phekhLeGpBQjlVYldrazVlNWc2d3hV?=
 =?utf-8?B?TUhUdlk2Y2FWYnEvMU5ndGUrd01WazJlTm9hY1JQUi9iTkhqLytrUHdGaWJ6?=
 =?utf-8?B?OVI1OUErZ2pRV05wcWVKbDlxTWJtMTlrdnlhQ285QlRrNWVaK0FmcTltVXUy?=
 =?utf-8?B?MmJkaTJpWGJUNGV5V0ExMVhCNUthWktwQXRiSEx5VHNmV3R1VmpLeXhmZGNW?=
 =?utf-8?B?TnJ3Vk1nTVJRZFFBenBIOUlTNk5HTjE2VEZCYjJMemhCcnRKVmtzcEdEQVU0?=
 =?utf-8?B?UFZacHdMRDFiNzdJdk5sSVZNREkyVGU4SE43OGJBVEVlYzlkeG5WTWVHcnhk?=
 =?utf-8?B?alo0cXRkQ2l5ZFJ5T2x1R3c3ZFg0THdoVlRMbDNhUWZtbFpzcVYreFFvSk9p?=
 =?utf-8?B?ZmZFenlnT0c0TkpWRGd3V2pLV0g1KzVtMnlTb25DcGVGTFJLWFpwMG9RNEN6?=
 =?utf-8?B?ZGl1d0ZRQTBmd0hCMHk2cERCeEhEaHFhQXpmaXhuSUJmYlRGZ09MbmVNSmI3?=
 =?utf-8?B?NGhuVjFzUTlMUko3YkZQVlpCY2VYTWJVODBrOUpWaFFxMDJ6N3A0VWFON2xJ?=
 =?utf-8?B?aGVOVERhRTF1UHBnQ2R4RTA3NEdISWpEeFJHY3BqRFFhMTlGd1cwWStlRzhT?=
 =?utf-8?B?c2o0eGIyVGxSUmpzSVY5a2ZxNklucFNkOFQvaEdmb3JoL2R4M3MzV0djME1P?=
 =?utf-8?B?N2V4M3BjZXFHVFZEbWxWb0I4czZGelJTSitha1FOTUJOdXRaMlV3WGNmdy9y?=
 =?utf-8?B?YVFZTHNEMUdEcm5zMzc3MEgyZ3hJWlVYWjZWSTlxSDM2eUdKeFNJaENUMGRN?=
 =?utf-8?B?b05NaGtVN0g4bm5hN29JUVdpMHkyOTVLVHlTVHZmenY2OG1wS0toNWl0YUdi?=
 =?utf-8?B?OWJSL0dtcjlrZTNJYmV1V2lIdHNXd1EwNTU5YXRmdXNHSDJOSm5WSEJRcWt4?=
 =?utf-8?B?Z012elk4SHlHUVlvTGV0aDJMaWpwdTI4TTRpamdkTGlKZDNpNkdUdlBLYnVa?=
 =?utf-8?B?VDhCVW1qd0lIM0NEZzEvWStNTkkwWC9uMDc3Z3FLOURhQ2NlR3E2TXlIR25R?=
 =?utf-8?B?ZkNtdXB5RU1IN1pDOGZVT2RNWDBKQmFrSVYrSk9RdkJXdndNTU54SDdqSmU0?=
 =?utf-8?B?bnFQQlVqWjFIcVFPRHVvMllhZ1l4ck9OeW5PeW9ZZitYbTlDclJIdDF4eHlY?=
 =?utf-8?B?L3JiQlhxRzdLWnJpcGZUcFhYdTBWL0xDUTdQdENHMVNwWVg2aXNtcU1kVnZq?=
 =?utf-8?B?T3pHQzlHZTRGdmR5K3FCWXlHdDJzTmw0SGQxN2dCNEQxTFRLOWRJN1hqQXBk?=
 =?utf-8?B?UGlhbldEa21oRWlzS1B1em9kbXZPRzBXeTE1clU2MHFiaEZobFpUczFCaUsz?=
 =?utf-8?B?RjN0bFdrUzdDM2lIeE9QclJ0N2c5RzVoTkVIWTkvQmtqa2RmcG52VUx2Q3J0?=
 =?utf-8?B?a0VMSEFrRVpybVBMbG9Vc3dOZGN3NlJZd3FZSjRYZWwxUENZRjBzWlJxbXRt?=
 =?utf-8?B?QjBvaVNvOXdpNkVhUjBmZnFrbmtlQXRCZGdlald5T3JXckV6b0Y4MjhqRWUw?=
 =?utf-8?B?dWQ5THA1TVYwWVpNOFVUblUrb216MFRTT215TytDNU5jTHBXeWpUL1FtY2po?=
 =?utf-8?B?Yi95NVJwdWwreDRIR1V5SzhaT2NkYWNVV1RSQTRURXRhcHlBQ254d2d1UlJz?=
 =?utf-8?B?bXZwYlRCbGdwTXR5SXFjMDdPcjRGK2xjT0Z5dFJxaHh5U0gwVWRBR1RIRzlM?=
 =?utf-8?B?RjVLdDQxVjZiV3hlZnNLRHprdWxhSTFHbWtZR2p0dy9hQUhmL3I5ckZJaWd0?=
 =?utf-8?B?aVdwVnlpMElua1hjUHl0dURVaStJZERQQWtjU1hCbVNIYStKNzg3Wk5FZnJ3?=
 =?utf-8?Q?WDRw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cb9869-4946-40d5-6f58-08db3045d7eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 11:07:53.6152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JMsD54HiBCugo9Bps8Z5X3KyzY9Yf7Ki8nw3e2EINWUkeKPZ3UF75gmi7WgXU/86mdrlrIBqePokzBL8OE73Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8197
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRnJhbmNvaXMgUm9taWV1
IDxyb21pZXVAZnIuem9yZWlsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgMjggTWFyY2ggMjAyMyAy
MToyMQ0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IHBhYmVuaUBy
ZWRoYXQuY29tOw0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBzZEBxdWVhc3lzbmFpbC5uZXQ7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzRd
IHZsYW46IEFkZCBNQUNzZWMgb2ZmbG9hZCBvcGVyYXRpb25zIGZvciBWTEFODQo+IGludGVyZmFj
ZQ0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0
YWNobWVudHMNCj4gDQo+IA0KPiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+IDoNCj4g
PiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPg0KPiBbLi4uXQ0KPiA+ID4gPiArI2lmIElTX0VOQUJMRUQoQ09O
RklHX01BQ1NFQykNCj4gPiA+ID4gKyNkZWZpbmUgVkxBTl9NQUNTRUNfTURPKG1kbykgXA0KPiA+
ID4gPiArc3RhdGljIGludCB2bGFuX21hY3NlY18gIyMgbWRvKHN0cnVjdCBtYWNzZWNfY29udGV4
dCAqY3R4KSBcIHsgXA0KPiA+ID4gPiArICAgICBjb25zdCBzdHJ1Y3QgbWFjc2VjX29wcyAqb3Bz
OyBcDQo+ID4gPiA+ICsgICAgIG9wcyA9ICB2bGFuX2Rldl9wcml2KGN0eC0+bmV0ZGV2KS0+cmVh
bF9kZXYtPm1hY3NlY19vcHM7IFwNCj4gPiA+ID4gKyAgICAgcmV0dXJuIG9wcyA/IG9wcy0+bWRv
XyAjIyBtZG8oY3R4KSA6IC1FT1BOT1RTVVBQOyBcIH0NCj4gPiA+ID4gKw0KPiA+ID4gPiArI2Rl
ZmluZSBWTEFOX01BQ1NFQ19ERUNMQVJFX01ETyhtZG8pIHZsYW5fbWFjc2VjXyAjIyBtZG8NCj4g
PiA+ID4gKw0KPiA+ID4gPiArVkxBTl9NQUNTRUNfTURPKGFkZF90eHNhKTsNCj4gPiA+ID4gK1ZM
QU5fTUFDU0VDX01ETyh1cGRfdHhzYSk7DQo+ID4gPiA+ICtWTEFOX01BQ1NFQ19NRE8oZGVsX3R4
c2EpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICtWTEFOX01BQ1NFQ19NRE8oYWRkX3J4c2EpOw0KPiA+
ID4gPiArVkxBTl9NQUNTRUNfTURPKHVwZF9yeHNhKTsNCj4gPiA+ID4gK1ZMQU5fTUFDU0VDX01E
TyhkZWxfcnhzYSk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gK1ZMQU5fTUFDU0VDX01ETyhhZGRfcnhz
Yyk7DQo+ID4gPiA+ICtWTEFOX01BQ1NFQ19NRE8odXBkX3J4c2MpOw0KPiA+ID4gPiArVkxBTl9N
QUNTRUNfTURPKGRlbF9yeHNjKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArVkxBTl9NQUNTRUNfTURP
KGFkZF9zZWN5KTsNCj4gPiA+ID4gK1ZMQU5fTUFDU0VDX01ETyh1cGRfc2VjeSk7DQo+ID4gPiA+
ICtWTEFOX01BQ1NFQ19NRE8oZGVsX3NlY3kpOw0KPiA+ID4NCj4gPiA+IC0xDQo+ID4gPg0KPiA+
ID4gaW1wb3NzaWJsZSB0byBncmVwIGZvciB0aGUgZnVuY3Rpb25zIDooIGJ1dCBtYXliZSBvdGhl
cnMgZG9uJ3QgY2FyZQ0KPiA+DQo+ID4gVGhhbmsgeW91IGZvciBicmluZ2luZyB1cCB0aGUgaXNz
dWUgeW91IG5vdGljZWQuIEhvd2V2ZXIsIEkgZGVjaWRlZCB0bw0KPiA+IGdvIHdpdGggdGhpcyBh
cHByb2FjaCBiZWNhdXNlIHRoZSBmdW5jdGlvbnMgYXJlIHNpbXBsZSBhbmQgbG9vayB2ZXJ5IHNp
bWlsYXIsIHNvDQo+IHRoZXJlIHdhc24ndCBtdWNoIHRvIGRlYnVnLg0KPiA+IFVzaW5nIGEgbWFj
cm8gYWxsb3dlZCBmb3IgY2xlYW5lciBjb2RlIGluc3RlYWQgb2YgaGF2aW5nIHRvIHJlc29ydCB0
byB1Z2x5IGNvZGUNCj4gZHVwbGljYXRpb24uDQo+IA0KPiBTb21ldGltZSBpdCdzIGFsc28gbmlj
ZSB0byBiZSBhYmxlIHRvIHVzZSBzdWNoIG1vZGVybiB0b29scyBhcyB0YWdzIGFuZCBncmVwLg0K
PiANCj4gV2hpbGUgaXQgc3RpbGwgaW1wbGllcyBzb21lIGR1cGxpY2F0aW9uIGFuZCBpdCBkb2Vz
bid0IGF1dG9tYWdpY2FsbHkgcHJldmVudCB3cm9uZ2x5DQo+IG1peGluZyB2bGFuX21hY3NlY19m
b28oKSBhbmQgb3BzLT5tZG9fYmFyKCksIHRoZSBjb2RlIGJlbG93IG1heSBiZSBjb25zaWRlcmVk
DQo+IGFzIGEgdHJhZGUtb2ZmOg0KPiANCj4gI2RlZmluZSBfQihtZG8pIFwNCj4gICAgICAgICBj
b25zdCBzdHJ1Y3QgbWFjc2VjX29wcyAqb3BzOyBcDQo+ICAgICAgICAgb3BzID0gdmxhbl9kZXZf
cHJpdihjdHgtPm5ldGRldiktPnJlYWxfZGV2LT5tYWNzZWNfb3BzOyBcDQo+ICAgICAgICAgcmV0
dXJuIG9wcyA/IG9wcy0+bWRvXyAjIyBtZG8oY3R4KSA6IC1FT1BOT1RTVVBQOyBcDQo+IA0KPiAN
Cj4gc3RhdGljIGludCB2bGFuX21hY3NlY19hZGRfdHhzYShzdHJ1Y3QgbWFjc2VjX2NvbnRleHQg
KmN0eCkgeyBfQihhZGRfdHhzYSkgfSBzdGF0aWMNCj4gaW50IHZsYW5fbWFjc2VjX3VwZF90eHNh
KHN0cnVjdCBtYWNzZWNfY29udGV4dCAqY3R4KSB7IF9CKHVwZF90eHNhKSB9IFsuLi5dICN1bmRl
Zg0KPiBfQg0KDQpJIHRoaW5rIHRoYXTigJlzIGEgcmVhc29uYWJsZSBjb21wcm9taXNlLCBJIGNh
biBkbyB0aGF0IGFuZCByZXNlbmQuDQoNCj4gT24gYSB0YW5nZW50IHRvcGljLCBib3RoIGNvZGVz
IGV4cGFuZCAxMiB0aW1lcyB0aGUgYWNjZXNzb3INCj4gDQo+IHZsYW5fZGV2X3ByaXYoY3R4LT5u
ZXRkZXYpLT5yZWFsX2Rldi0+bWFjc2VjX29wcy4NCj4gDQo+IEl0IGltdmhvIGRlc2VydmVzIGFu
IGhlbHBlciBmdW5jdGlvbiBzbyB0aGF0IHRoZSBjb21waWxlciBjYW4gbWFrZSBzb21lIGNob2lj
ZS4NCg0KQWdyZWVkLg0KDQo+IEFzIGEgZmluYWwgcmVtYXJrLCBWTEFOX01BQ1NFQ19ERUNMQVJF
X01ETyBhYm92ZSBkb2VzIG5vdCBidXkgbXVjaC4NCj4gQ29tcGFyZToNCj4gDQo+IHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbWFjc2VjX29wcyBtYWNzZWNfb2ZmbG9hZF9vcHMgPSB7DQo+ICAgICAgICAg
Lm1kb19hZGRfdHhzYSA9IFZMQU5fTUFDU0VDX0RFQ0xBUkVfTURPKGFkZF90eHNhKSwNCj4gICAg
ICAgICAubWRvX3VwZF90eHNhID0gVkxBTl9NQUNTRUNfREVDTEFSRV9NRE8odXBkX3R4c2EpLA0K
PiBbLi4uXQ0KPiANCj4gdnMNCj4gDQo+IHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjc2VjX29wcyBt
YWNzZWNfb2ZmbG9hZF9vcHMgPSB7DQo+ICAgICAgICAgLm1kb19hZGRfdHhzYSA9IHZsYW5fbWFj
c2VjX2FkZF90eHNhLA0KPiAgICAgICAgIC5tZG9fdXBkX3R4c2EgPSB2bGFuX21hY3NlY191cGRf
dHhzYSwgWy4uLl0NCj4gDQo+IFRoaXMgb25lIGNvdWxkIHByb2JhYmx5IGJlOg0KPiANCj4gI2Rl
ZmluZSBfSShtZG8pIC5tZG9fICMjIG1kbyA9IHZsYW5fbWFjc2VjXyAjIyBtZG8NCj4gDQo+IHN0
YXRpYyBjb25zdCBzdHJ1Y3QgbWFjc2VjX29wcyBtYWNzZWNfb2ZmbG9hZF9vcHMgPSB7DQo+ICAg
ICAgICAgX0koYWRkX3R4c2EpLA0KPiAgICAgICAgIF9JKHVwZF90eHNhKSwNCj4gWy4uLl0NCj4g
I3VuZGVmIF9JDQoNCkkgYWdyZWUgSSB3aWxsIGRvIHRoYXQuDQoNCj4gLS0NCj4gVWVpbW9yDQo=
