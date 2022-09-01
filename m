Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A95A9771
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiIAMy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiIAMyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:54:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444F513E90
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:54:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ym1sj2GBkmARn+R+JBYcu7Ihfxt0ZF1nPp6g5KFIGrnmYOKxHhJWYsaxuUS0gmUCiJesKAmXn0i1CdaGN32w2TLk8rrlDInGNGApTh9FT/s3MCk6bafWV+dc7SglLLcf7LcF92Ld/PPS4XurVFeZXw9M6R2pFkJXeu7HQxfSp2ZMrKVCCg8RkmrmsnM5yrGCoguS+ubwB6X9hE5f9h4b31WmcTcaKFDljV74Aacb9SPD7Z+8RATLrfWAhPilazDELvPeVAfdXrX4sS4w7dwWo9BNqpD5fSG+njA1HVi6I3SUmHp1BcOHB+S4Kp+6a6aPIigz+hbhws2P5Bo2AlA35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yksdvmzkOR9Jl4S/J+H8PEdkdc6CIKvDAGNrB1sJlk=;
 b=epz2ZDsoW05+OOyY72IAKWMZfE8UBbQPmMb1MH/yCKxKj2C7AM6MpygqKyA4NBnIeOrWdTFoj9r3g2MpOsOJDKcQgb9sS7NEXzZRnlHzcHPizbuvxJKv/f+uMI2e9+8J8CtRhhAFWfQWf3oMTECxAmcCAG6GIf9LFtVhniDm2+WQ2uGgYrpeZTHcxNasvOahhz7wKFjeTW+X0WPADqQvHsUnxmdY8Q9E/KcXV2vpv0p0NSdkqXLhZg8XB3rvEpo8UiXbzi12YcTDxyjdJPEsrVkrxFfc8i8SD3sjmgBJUkda2/yvoo9MM/CkYit25EpDuBcSSziOiX/VEd/TteAb/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yksdvmzkOR9Jl4S/J+H8PEdkdc6CIKvDAGNrB1sJlk=;
 b=hKTQZMQZNL5UxROnL310IrzHT2p0W/KA3nJehYNMQVnk/O3A30S2ERp7naOz9MAl0vgD7n1kPgsM7DfdOU/Zd+AM/x8wS6vF+cQo0fq7nsD24nX1axsjyeeb0uwtzEqQxcD65AQq+pwFgM3chs9Nt0oKifr2Xvb5SPD3Gui3l85BpiAD+L0ZzgUgA8U6aJPJXuVEa5ULoQq9Gi/bpqErnefzjLTxOpju3IoDz1A7yLfEN5GifSKN046+JNvykBVkRdtrChDdIdgWzWpTAMYOjSnjID1zsl7vWX+hh+sPl3Ecqab6tfT0Vd4kOmULVgS7TvmVwmHJbVuDXWdOfOivew==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SJ0PR12MB5488.namprd12.prod.outlook.com (2603:10b6:a03:3ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 12:54:52 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::e041:11a1:df43:9051]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::e041:11a1:df43:9051%9]) with mapi id 15.20.5525.010; Thu, 1 Sep 2022
 12:54:52 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH main v2 1/2] macsec: add extended packet number (XPN)
 support
Thread-Topic: [PATCH main v2 1/2] macsec: add extended packet number (XPN)
 support
Thread-Index: AQHYt5p61poxP/U5DkKCySUJ4x9KCa3J7JoAgACn1TA=
Date:   Thu, 1 Sep 2022 12:54:51 +0000
Message-ID: <IA1PR12MB6353F9B26B5141F5F6F1EC82AB7B9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20220824091752.25414-1-ehakim@nvidia.com>
 <07bc7668-3107-bea2-58e0-75a77af57f7c@kernel.org>
In-Reply-To: <07bc7668-3107-bea2-58e0-75a77af57f7c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb056a9a-d123-495d-85cd-08da8c19293d
x-ms-traffictypediagnostic: SJ0PR12MB5488:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b6yt+TknR/5SUAFg7L7nlu9xdbAH/+v7bmuQ/NkBl0C8+sHhohHJyxgubdxwmyLivARU0nPkHDqRdjgkPEERkh6QJoDw8hlZYgDIxveRkuzIFjFOA4FrahZ9ty+R8jvwrR5J1C+Bk6ilI6/FC69x61Jjq7brJiXxPRsj0wVv4BrvuMRFPWHim3+zhWug2xlQcO6t1cqkt6E0MlvBn+a+hLWL/6MJqVvYa75/r9WGVw3B/DRtB/ydi/0OjJ+SGNNT3vKar3w+JPuPLBJh8qRYi2H8mhBPc507hoAYiWqaDKjEQDyVUV98WPbmmfzQ2t4wM34fAjZIWtwRlvXsAM/fajvz2RBvktXngAfc0gmDwBfs5i9EA18rQNJWu0GpqLY38TNgAonS5XKFJN9GMMU0iRol6qsqdA8/g4qc1vEbC+c3BUrDHMvksWrANRJlMLXCcJ6cmYxQcRb6L2VRueCljrBXLDcHhxeO45We9hA/tE1npYedR7BjTsC+mvDKtdRANrpKGRvWU8vQFKT99uI6byjuAcn3KWvTD2y5mifuB1EUtqgVHvI4NzJrEaqWKyFDWZzdL27A/kED+meXgPEAJ+xFLKlA2Gl9cUucGLS5MeeiDF9shiTrBjO8FYj2hPVKxPaUCXCctCsDBivI1i8Psw16mmnU84iIBZQJyKOSy2R0fGIasmX9UDbk8SJx6GkIMhvf8QZq6QT7OtP+Q2dyZax3TI1v7nJuhO5982Z8vbzhIgL7R51u+WE+YxLWxuumQySbjykAGDld0baQJssw8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(38070700005)(66476007)(86362001)(38100700002)(55016003)(66446008)(122000001)(64756008)(8676002)(4326008)(66556008)(478600001)(66946007)(8936002)(110136005)(71200400001)(54906003)(316002)(6506007)(186003)(83380400001)(9686003)(52536014)(2906002)(26005)(41300700001)(5660300002)(7696005)(53546011)(76116006)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1NBTnZSZ3dOR1JYQ0lZa1BNUHBPK1c5Tzh3YVBWZGRsTit5eENSVDdHVDlB?=
 =?utf-8?B?dWlJUnh1aHVRY0tHL3ZHUWZ1UnZ5eGNjQmVzTDJqenZaZ01nT0paejVUUXEr?=
 =?utf-8?B?MHIyWUN5RmVMVWp6UmJJUlEvN3VCdE81akhGK1pZbnk5NC96VkF5dVZiQ2Rs?=
 =?utf-8?B?Vk83UnA2RWFRTGRWOXZwTXMyTDQ5QmxpbzlZM2tKVm4zd1UyRk1INHhhU0dh?=
 =?utf-8?B?Qkl6VGdOdmRiTmxPZjhnRFJYVDNITVhSSGhLWERiWjNndmpld2FLamlWMWlH?=
 =?utf-8?B?WUE1anZ1M0FINE5DdmgwcFNiMTBGMkw4UEovcElYalZuTkZxS1VYTVd5bmVD?=
 =?utf-8?B?MFBBUWlOVTlHOVRrV3cyWFl5TGRWS3l1VXR1NytYbzN3SllQcUZXWGpUZEpR?=
 =?utf-8?B?dmdBQjZ4WC91MjdzSldSVEl1Z0c1RDdVWkFrU0M3aU1KQVJ2MkQxZmhpUXox?=
 =?utf-8?B?N2RybnhNVnFTWS8ralBubDZoVjQ1Z2N3VGUzYktybUw4MkZUY2xzTDdncmRV?=
 =?utf-8?B?OEtRU1NxWFp3eEhzN0JPbitHc1N0NmZHWDFZMWJjbjFvb254eXJ0bHdJaFpU?=
 =?utf-8?B?TkZJLzR6Nm1IWXRkMGRVbmlCVml3bHhqTHlvdDh5MUV5MjRHQ0MvaHZWdWVX?=
 =?utf-8?B?dGMwait0TXMvS1JOLzgycENGOWdyTzFVWGt6aVp5WVp6Wk90UWxVMGQ5WGI0?=
 =?utf-8?B?N1ZybldGU0l0M2lQV1dDSW5PYjJCQ1cyczhESjFiaVZyRFdkVGpOVjVRTnh0?=
 =?utf-8?B?L3BBR3JJSzVIemhNL1ZiaG5TVHdKSGF6eTJZSk0xcFNQY0FDUFJ6Vm56bDIz?=
 =?utf-8?B?bGVGNngzNjFndHlVTkRjWTh0MnZjTTJzd3J0Zmp2Rjk1Tmx3V0VnZEtHdDZJ?=
 =?utf-8?B?OFc4UWhiNWVFeExVbHJvdXZhVWQxbnR1d1pEbDVvc2lvVEgwdFcweGRFd3Zt?=
 =?utf-8?B?ZGVWTmtpcWZlbGNPeFlBUHZnQ3NPekFQU29SVDFlWVY0Q3BxWkIzMGl0UkI3?=
 =?utf-8?B?WlZUQktOUG4rODljYjgrRGNRQzJVVTNrVitjanZub3preE9SYVRTUE93dHYr?=
 =?utf-8?B?dlViM2tqRlVpQ3psQzJBOU1yM1FPWFh1emxpUlJqTVE0Q3VqbHlWZzhQaUtX?=
 =?utf-8?B?Q2QzSHVLcnlralMwVDY0SE02M2NaUWFseXlPQ1JvQ0JlVUZIMUhRZmtrd2dW?=
 =?utf-8?B?QWxJcTFsTTdrdTRYWWkxRk5aRkFxQk5xaVdhOFRkL1k2enBvVXpHZ0U1NVFS?=
 =?utf-8?B?YjBQMDRHMmJDR0tnVk9iWG55Sjd6K08yKyszb0IrVExCeTI3SWF4dVlqM1Jv?=
 =?utf-8?B?QzJOUnlnL1RpTVpGZjloVEZka2xrL044QWZoVUJEVFQvcVltUThzdmhCdHY0?=
 =?utf-8?B?d2FNZVJOdEgyaGxuQy9tV2pRMWttWlVHeFh0N05pTGM3b0txK2pycjZpcGhK?=
 =?utf-8?B?Z0NEbjB2cWdRR0ZwdzFicElTUk5wZjBlbEtTRGRqVTdDcDZ5eFg1ck9LcUZI?=
 =?utf-8?B?aEU1YlE5bEZjS1hrenVkRkMzY0szUzVDdXE0UlhxSXhFeFpXTGkwaWY0aFpD?=
 =?utf-8?B?TU11QWxKSW1NdzBGa2hjSWtqM2x1YTV4ZlJ6UXlTdUcwYXFlVHJwRHpta2NN?=
 =?utf-8?B?VzFNK0RpWS81SlV1OW9JeTVidVo1aTNlLzRFZ1VXRlN5d0dLYTBPcUFzd1l2?=
 =?utf-8?B?amNlVUliRHh1ZEtMckY4bEw0YzRCS2dmbHpwTkR4VTNWUm41VFNsdWd1Rk9E?=
 =?utf-8?B?OUViRzBCSFhQT21nUU53aDU3N0tObEQyK2FjY1JodE1Va2hLSXY4eEZJRlYw?=
 =?utf-8?B?cTdXSklFRmRldjJpdGM1K2w2V2Nvd3VlRlhueitaSmxZSFJuaWorNFBCWGZY?=
 =?utf-8?B?bFVDa3A2alpMOTg1MW4vZkxtVWJueUFJclVGN2IySjV5RzRCTktyTVhqRTFy?=
 =?utf-8?B?elQvKzh3Q2kzOWVHN2V0YXVPSHNEblZwUkk3dGg3VEVxVEN0ODZiY1FuSDNz?=
 =?utf-8?B?VTJzZjU5OG1tUGVmUlFDQU1zR255KzBKb1JBUUJieGNCRUdja0hXODhqd1ZT?=
 =?utf-8?B?bXdEUE5qbGpNbFFHRUJSd2pIL3BvZlc5RGVQaXBoaTFQRTNHWGZXM1JWQzJq?=
 =?utf-8?Q?zMGU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb056a9a-d123-495d-85cd-08da8c19293d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 12:54:52.0159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WKFtGRZ5DHrImH2A7G50WvgjwQjx0h8ecnP2bFRonwkwZrEnnO7qtgG/OlU7C3IMCPTqUUYwiadxnZz/QZ/+QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5488
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVy
bkBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgMSBTZXB0ZW1iZXIgMjAyMiA1OjUzDQo+
IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+OyBzZEBxdWVhc3lzbmFpbC5uZXQN
Cj4gQ2M6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG52aWRpYS5jb20+OyBSYWVkIFNhbGVtIDxyYWVk
c0BudmlkaWEuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG1haW4gdjIgMS8yXSBtYWNzZWM6IGFkZCBleHRlbmRlZCBwYWNrZXQgbnVtYmVyIChY
UE4pDQo+IHN1cHBvcnQNCj4gDQo+IA0KPiANCj4gT24gOC8yNC8yMiAzOjE3IEFNLCBFbWVlbCBI
YWtpbSB3cm90ZToNCj4gPiBAQCAtMTc0LDE0ICsxODEsMzQgQEAgc3RhdGljIGludCBwYXJzZV9z
YV9hcmdzKGludCAqYXJnY3AsIGNoYXINCj4gPiAqKiphcmd2cCwgc3RydWN0IHNhX2Rlc2MgKnNh
KQ0KPiA+DQo+ID4gICAgICAgd2hpbGUgKGFyZ2MgPiAwKSB7DQo+ID4gICAgICAgICAgICAgICBp
ZiAoc3RyY21wKCphcmd2LCAicG4iKSA9PSAwKSB7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAg
IGlmIChzYS0+cG4gIT0gMCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaWYgKHNhLT5wbi5w
bjMyICE9IDApDQo+IA0KPiBwbjY0IHRvIGNvdmVyIHRoZSBlbnRpcmUgcmFuZ2U/IGllLiwgcG4g
YW5kIHhwbiBvbiB0aGUgc2FtZSBjb21tYW5kIGxpbmUuDQoNCkRpZG7igJl0IHJlYWxseSBnZXQg
dGhlIGNvbW1lbnQgaWYgdG8gaGF2ZSAicG4iIGFzIHRoZSBvbmx5IHBhcmFtZXRlciBpbiB0aGUg
Y29tbWFuZCBsaW5lIG9yIGp1c3QgdG8gc2F2ZSBhbGwgdGhlIHBhY2tldCBudW1iZXJzIGluIGEg
NjQtYml0IHZhcmlhYmxlIGFuZCBwcmVzZXJ2ZSB0aGUgY3VycmVudCBBUEkgLCBjYW4geW91IHBs
ZWFzZSBlbGFib3JhdGU/DQpwbGVhc2Ugbm90aWNlIHRoYXQga2VybmVsIGhhcyBhIGNoZWNrIGZv
ciB0aGUgcG4gbGVuZ3RoICwgaXQgZXhwZWN0cyAzMiBiaXRzIGluIGNhc2Ugb2Ygbm9uZSBleHRl
bmRlZCBwYWNrZXQgbnVtYmVyICh4cG4pLCBoZW5jZSBwYXNzaW5nIDY0LWJpdCBpbiBjYXNlIG9m
IG5vbmUgeHBuIHdpbGwgZmFpbC4gIFhwbiBpcyBhIHNlY3VyZSBjaGFubmVsIHByb3BlcnR5IHdo
ZXJlIHBuIGlzIGFuIFNBIHByb3BlcnR5IHNvIGR1cmluZyB0aGUgcGFyc2luZyBvZiB0aGUgU0Eg
Y29tbWFuZCBsaW5lICh3aGljaCBpbmNsdWRlcyB0aGUgcG4pIEkgZG9u4oCZdCBoYXZlIGEgbGVn
aXQgd2F5IHRvIGRpc3Rpbmd1aXNoIGJldHdlZW4geHBuIG9yIG5vbmUgeHBuIGNhc2VzIGhlbmNl
IHRoZSBzZXBhcmF0aW9uLg0KDQo+IA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGR1cGFyZzIoInBuIiwgInBuIik7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIE5FWFRfQVJH
KCk7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgIHJldCA9IGdldF91MzIoJnNhLT5wbiwgKmFy
Z3YsIDApOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXQgPSBnZXRfdTMyKCZzYS0+cG4u
cG4zMiwgKmFyZ3YsIDApOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBpZiAocmV0KQ0KPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludmFyZygiZXhwZWN0ZWQgcG4iLCAqYXJn
dik7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgIGlmIChzYS0+cG4gPT0gMCkNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgaWYgKHNhLT5wbi5wbjMyID09IDApDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgaW52YXJnKCJleHBlY3RlZCBwbiAhPSAwIiwgKmFyZ3YpOw0KPiA+
ICsgICAgICAgICAgICAgfSBlbHNlIGlmIChzdHJjbXAoKmFyZ3YsICJ4cG4iKSA9PSAwKSB7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgIGlmIChzYS0+cG4ucG42NCAhPSAwKQ0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGR1cGFyZzIoInhwbiIsICJ4cG4iKTsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgTkVYVF9BUkcoKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
cmV0ID0gZ2V0X3U2NCgmc2EtPnBuLnBuNjQsICphcmd2LCAwKTsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnZh
cmcoImV4cGVjdGVkIHBuIiwgKmFyZ3YpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBpZiAo
c2EtPnBuLnBuNjQgPT0gMCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnZh
cmcoImV4cGVjdGVkIHBuICE9IDAiLCAqYXJndik7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
IHNhLT54cG4gPSB0cnVlOw0KPiA+ICsgICAgICAgICAgICAgfSBlbHNlIGlmIChzdHJjbXAoKmFy
Z3YsICJzYWx0IikgPT0gMCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBp
bnQgbGVuOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgTkVYVF9BUkcoKTsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgaWYgKCFoZXhzdHJpbmdfYTJuKCphcmd2LCBzYS0+c2Fs
dCwgTUFDU0VDX1NBTFRfTEVOLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgJmxlbikpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW52YXJn
KCJleHBlY3RlZCBzYWx0IiwgKmFyZ3YpOw0KPiA+ICsgICAgICAgICAgICAgfSBlbHNlIGlmIChz
dHJjbXAoKmFyZ3YsICJzc2NpIikgPT0gMCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBO
RVhUX0FSRygpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXQgPSBnZXRfdTMyKCZzYS0+
c3NjaSwgKmFyZ3YsIDApOw0KPiANCj4gdGhhdCBjYW4gZmFpbCwgc28gY2hlY2sgcmV0IGFuZCB0
aHJvdyBhbiBlcnJvciBtZXNzYWdlDQoNCkFjaw0KDQo+IA0KPiA+ICAgICAgICAgICAgICAgfSBl
bHNlIGlmIChzdHJjbXAoKmFyZ3YsICJrZXkiKSA9PSAwKSB7DQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgIHVuc2lnbmVkIGludCBsZW47DQo+ID4NCj4gDQo+IC4uLg0KPiANCj4gDQo+ID4gQEAg
LTEzODgsNiArMTQ1OCwxNCBAQCBzdGF0aWMgaW50IG1hY3NlY19wYXJzZV9vcHQoc3RydWN0IGxp
bmtfdXRpbCAqbHUsIGludA0KPiBhcmdjLCBjaGFyICoqYXJndiwNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBh
ZGRhdHRyOChuLCBNQUNTRUNfQlVGTEVOLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBJRkxBX01BQ1NFQ19PRkZMT0FELCBvZmZsb2FkKTsNCj4gPiArICAgICAgICAgICAgIH0g
ZWxzZSBpZiAoc3RyY21wKCphcmd2LCAieHBuIikgPT0gMCkgew0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBORVhUX0FSRygpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBpbnQgaTsNCj4g
PiArDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGkgPSBwYXJzZV9vbl9vZmYoInhwbiIsICph
cmd2LCAmcmV0KTsNCj4gDQo+IGRyb3AgdGhlICdpJyBhbmQganVzdA0KPiB4cG4gPSBwYXJzZV9v
bl9vZmYoInhwbiIsICphcmd2LCAmcmV0KTsNCj4gDQo+IGJlc2lkZXMgeW91IGhhdmUgaSBhcyBh
biBpbnQgd2hlbiB4cG4gaXMgYm9vbCBhbmQgcGFyc2Vfb25fb2ZmIHJldHVybnMgYSBib29sLg0K
DQpBY2sNCg==
