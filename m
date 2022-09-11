Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC65B4CC7
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiIKI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 04:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiIKI5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 04:57:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570352CCB9
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 01:57:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjycdoKEwqa3j4rkCvQlP8eBV6z88otMzTfEMmE9lyYua4WlNkatm9k++F0WyTNaaUsYnLRutOfhw0t95tbp0tV5VG3BWNqlKrknu52PrHPeswlJCLnUseYhL9wwfM/anpJztPEXcjOxKTPDNPZyhuzx76zXCuT7aIL9nxCrI9XCTzkH7n0BuqOYSy8aIR+TqiV56zjDOy2J3h/yz6zSO/BZZo2xAuYs3x8WYpAbdjbO/cpGDEi/BnXOB9aqmgQynlrdsOlfbUpkU/QNMn/qiWglSWZHCnY+1Wd6CpnKa9pFolFZIQ2HGgZXSknaYL477uhVTx8l52Xj96MzwRQ5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NiYK+1Xlrjq2pCKRvhM8crvdEyO9CCjr8G7TJwlBxhw=;
 b=YSUuJwH8GroQYAYD/VFoOvVZTFktaFOctA2Sd007WMOvOj/BsklYQswn3fEwrb27Wx5TdfSXUn+9x4QAXYWlxcHlg/LLg+x1BoE7WQpK2MmIZpelJtlgkkk20D2VageN5qYh+WX2SpZaO7mDOR/Yt3OO6ZVxew0/ctcrcREe5vONIkI0Eb22bg8WW3JX5WRLqRCE36ePgfRg5PMQznVsKsk+fvgpNOpplj5WiMNJJm08xlGvktXRirjV3opJGvCbDt6ZE+b6eKkyMRRMMIfBqUzTeKP9p4xFOC2bbiElX7RaxWy6tKLo/evZ4v0xSQdUh/jY4K7IRGJlvS1BtpjlcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiYK+1Xlrjq2pCKRvhM8crvdEyO9CCjr8G7TJwlBxhw=;
 b=De2XbymiZHrsJxKpmiGTm22rmPnGnUp8lCR4TU95xiNFDObIPfjG98bFa2BZzDZKN2/RF3bqkJT98Swu8wVvjaLwhDpcqMiU1u7c7pLctaGC/LmT3Jcp+rg0tm2qr6JTZLW0//OFH3pgdjucp1IODKJ/40/RB3rmeKxluB32u+i9yUZ8k1kS0FzchGuA2BH/hVtcxoHK1TxpWW/LBLJP6wU2H7ZbeQRru1SsHtfeAuP9XpD2SwCrD+yQoCGxdrDxkha+16o1zQ16r+Xe8YVzBr4kYfkxMyo/UpGP0OMYW424rBbkfUPQ7EfZBIrg2XwVHFP6rW3XsKPQA2v0wKxecw==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SJ0PR12MB7007.namprd12.prod.outlook.com (2603:10b6:a03:486::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Sun, 11 Sep
 2022 08:57:08 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::2cfb:63f0:9f0:706a]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::2cfb:63f0:9f0:706a%5]) with mapi id 15.20.5612.019; Sun, 11 Sep 2022
 08:57:07 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: RE: [PATCH main v4 1/2] macsec: add Extended Packet Number support
Thread-Topic: [PATCH main v4 1/2] macsec: add Extended Packet Number support
Thread-Index: AQHYw3FOnFJIqGvLY0yzNp4Q/RS6LK3Z6/SAgAAFpjA=
Date:   Sun, 11 Sep 2022 08:57:07 +0000
Message-ID: <IA1PR12MB6353BD6758BB05B3DDFAF491AB459@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20220908105338.30589-1-ehakim@nvidia.com> <Yx2dxUxOt1Dlpy7f@hog>
In-Reply-To: <Yx2dxUxOt1Dlpy7f@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SJ0PR12MB7007:EE_
x-ms-office365-filtering-correlation-id: 26870193-95ac-443a-02e5-08da93d39b48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 21x+CPpKWqix7e0/bygx6RVWJAxWz0i7dHFOxhJwiuydYm2kvJ1QbwlEnsSAap++XO6B3FccWvLxz/G33O4ae/qLBlH1ELfA7BA2BUq2cmeB6s8ra0kV/zdx69PqbSPJsxBrOEyg0oBYuYz5+585RNBQllw+y/iyc4dFfOM1L+Qv/T9ROUnYjBcLahkSu+NhScOQjS45UIcW+MjXsHAS5LyVOwe1xZSpQIlyQxsZo/EFMPsQ9uiLHITjST0K1pXSMrokjbAtjG+Is9x3n5xYpLG3Kg5xZD4YZhxCSe7v9u/ZsBvHN7XRiTqkD5tJwVe46JMLFss0uM3j5Ys3jK8P89dEgOf6SvkdzKdQizJCdG0jtnsAGBa6Wxe0nOhXRBOcrS+ySKaw0WMhmpyEyxtRJ0aGlZqxlYjZN0crVsZUbPfrC4BM+zPw794zA9gANLET7ENndZO9ExXO8GEjd8TUWDwCbR+OJqpwH3S5HDGVFv0w48REUnaQF9hM7uEjZf2fteAPClKH/ds5JMCLw1c7awe5q4oQgMXdbw8DeBlb2Rqwd++XLKbo48d6vTztfZe5cAe1vlZsmLAMY9GA0uXQL+2CYXUV/DsIbzwJDEP02YRP8jcoGclLPj4uWhoxvakm5UATYk42vZocuHbbgjJUjTtPSKQiigHa2MndJn49R+4R18GneF+BnO7GhWH5KzDUWScbxQLQMUClK7ODvNTutrS8KC3ZGbaSdrC7nDT1AbHVsp0N5tbx8kNML2G8NHpDkX6ZMKRoqHa0BmvVsrBJdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(8676002)(38100700002)(86362001)(64756008)(66476007)(66946007)(76116006)(66556008)(66446008)(4326008)(33656002)(122000001)(38070700005)(83380400001)(26005)(186003)(107886003)(6506007)(53546011)(478600001)(9686003)(41300700001)(71200400001)(7696005)(55016003)(316002)(54906003)(6916009)(5660300002)(2906002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0g2cHpVS1poTnlkSTdKOEU3TUg1cmJBTWZRSklURVhBNEVjRGUvRnVrcW5I?=
 =?utf-8?B?eTJEVXUvVlZFbVZueG51ZG9xYlpLUkUydlh3M3M3dVlSOXQyelVTWXZFR1k2?=
 =?utf-8?B?a2pPcnBQRU9QV1N4SU1PRlRLWk55ZnZKWTBwM29Ib2JBYWdVRGhYOEJIazIr?=
 =?utf-8?B?L2lkYlZaWU9pNzJxd0VBZm8xc0o4NWU5cVhYeXgwdy9reEZTczVYQWE5Ny9x?=
 =?utf-8?B?QkZMb2JTbHF0aHBzUTFqN1dMN01hOGFERC81bU5ROTZOcGhQR1cxaUdFOWtC?=
 =?utf-8?B?QzZxUDBoS2lLZEplbUlvOWZaT1d5ZXhPVXhzaFdrVjN1WUpvNlpUdkJkckdv?=
 =?utf-8?B?bmthZzJZYlo3Zkw2UFJzejZUMEJPSnNTQTdPSFZOMGlnNGwvT1lJdmE0TzQ5?=
 =?utf-8?B?bHZoK1ZVYmVEZitIUUFvWmlvVDdsR2IxQThtc2IxbGFwSHdBSW9jbHRVNUd6?=
 =?utf-8?B?MlljM3Nvek5saXY2b1JiVWxheUpPQ3h5dGtFTnVnb2lqN25aTXJMeTdQM1Ax?=
 =?utf-8?B?dS9PT1ZXdENHTG8xNmlxTHBjay91Q0MvSVJEYTE5NWs4LzJjU05ZeEJJMWs0?=
 =?utf-8?B?QWZXbjhqR0NJVDEycTBJUUZaVW14a0xoaTBTZks1K0NrVkJIOEJjS1dxT1dj?=
 =?utf-8?B?UUJNTWxHQk1lUDVTSDVVZmdKeUlzL0QwK3NVSmowbTJmMEhkcWVDcndOdHox?=
 =?utf-8?B?ZGhBNGJzTmhSQ28xQnF4MVRRNzAyWVRzclUzUzZDNFQ0ZVduUWJJU2t1OVNM?=
 =?utf-8?B?YTViMGlKeDZLd0F3OTNVd2hrTWdQQVlEOUYrL05ialhZeW95MlQ0VWFMZWpG?=
 =?utf-8?B?T3luZmpBR3I0Yjh4YmVUcDBQUEJsejVOcEg1a09wSXBaWjRFTCs0Uk9td2Nl?=
 =?utf-8?B?MWoxajRwbGRQZ3RlaVhHOUdpczFNMTJ2dmVGU214Zm5ZZmdEQnorV0tZbXVx?=
 =?utf-8?B?OS9lTmV3SS85UUZ5Z1d1dUxGV0lVQm9jY2tyWm1wMFJCY2VCNE5DaXp3VEpo?=
 =?utf-8?B?aFRrWlRIcnJneXhRcFhxdUpTNElzc2E5SFhqMlcwQzJYTDFFd1RjdzNUSWhB?=
 =?utf-8?B?NmdtM3ljZFd2WHdZbXJhenlGZ1Q1dGsyUEl0bmNKZUR1OEtvVmViY3I3b3FJ?=
 =?utf-8?B?VjNndExYakRyaFhuZFZWLzRWKzA3N2tiSzB0Ly9UdGlzdFd3VERXc2lLaDN5?=
 =?utf-8?B?YXozc3J0TWFFSTNpbkl6UmJyclFTUisvbUcyVFNKVHY0VmUwVlNIMWluWTNo?=
 =?utf-8?B?WmhKZUtwWkJkWHZPSldrWDJFd0c3TldRNlowbVNIRXdUU1NWWFRNdkd2TnRx?=
 =?utf-8?B?My9XWmhnL1hTaXJtbktJRWNHbkxrVHp1QW5uNkVFNGZoZnRvMGF0THRIenNz?=
 =?utf-8?B?TjlueXRSQUFqYzlITjhid3hlYWtLcE1tY2dEL2ZQQkRkT3dZaEwxZFNHUFJp?=
 =?utf-8?B?WGt2Z1JGN1ZhT0M2NzA2R25Mek9DTmpBa29tNGwwaXdONWFERUYyenpoZGlT?=
 =?utf-8?B?SEM3ZzJmbmE4K2tzY3ZRb0tpbS85VE1IRVEvdzFWVHNIUHlkbnc1WWl2RENr?=
 =?utf-8?B?WUd0NGR2RjVEVWJmVmhMS2t5TVAzK3Y3dXBwQ3FFZUZxRStMMXVQSmtseFN1?=
 =?utf-8?B?Uy9wUERRNGkwQXkybCtjUTFEOERrTmNkb0ppL3lReWE4NUluT3RmVXM1Smsr?=
 =?utf-8?B?V0FCOEhRTk9jY2R0R3lqQ0hUOTJxSFBpOEhxcG5FeGpuUzJrQWQzQjZQOFJj?=
 =?utf-8?B?TWNjdXNyTjREc2doOUNrL2VxU3pOS3orcTVvZjdiVVlOMVdmajdwaGozcUVk?=
 =?utf-8?B?bW9kT1BYcldWbCt1Ym93UU1uZ21CRWl0M2tPZDJMQ2pNTllYeDB5N3k5cFNP?=
 =?utf-8?B?VTRHOFNqbmFIV3ZxZExrVjhSWjJUbE4xeEdjUm91bEN5Y05DL1pBRkVJSjV6?=
 =?utf-8?B?UTV1WGhKRG9UQjd6K1A3OXY1dG15Q3B4MDByeExTT05jU1FDbmprWmh3MnNG?=
 =?utf-8?B?QVZKVjBXZHZZTmo0VHM5L29OY3A5Y1I3M1E2bXB2M1RqazU2c0VMb2lsK2RN?=
 =?utf-8?B?MjVSNVRHUGFhdkxhQ3BlbFBYZklmOXFnYVkxMU41NXBRa0M2THZDK3Erd1JF?=
 =?utf-8?Q?+TyM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26870193-95ac-443a-02e5-08da93d39b48
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2022 08:57:07.8291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nsczh7nNuh8rE9hVpUSUNOG1TzUh6JsvkdNsgnWJsPU8vgNfCB+P4OCaekMwDXrv/QIe9o7FBpAzWpkVRiyXuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7007
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWJyaW5hIER1YnJvY2EgPHNk
QHF1ZWFzeXNuYWlsLm5ldD4NCj4gU2VudDogU3VuZGF5LCAxMSBTZXB0ZW1iZXIgMjAyMiAxMToz
NQ0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogZHNhaGVybkBr
ZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtDQo+IDxyYWVkc0Bu
dmlkaWEuY29tPjsgVGFyaXEgVG91a2FuIDx0YXJpcXRAbnZpZGlhLmNvbT4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBtYWluIHY0IDEvMl0gbWFjc2VjOiBhZGQgRXh0ZW5kZWQgUGFja2V0IE51bWJl
ciBzdXBwb3J0DQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5r
cyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IDIwMjItMDktMDgsIDEzOjUzOjM3ICswMzAwLCBF
bWVlbCBIYWtpbSB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBmb3IgZXh0ZW5k
ZWQgcGFja2V0IG51bWJlciAoWFBOKS4NCj4gPiBYUE4gY2FuIGJlIGNvbmZpZ3VyZWQgYnkgcGFz
c2luZyAneHBuIG9uJyBhcyBwYXJ0IG9mIHRoZSBpcA0KPiANCj4gImNpcGhlciAuLi4iDQoNCkFj
ayAsIHdpbGwgc2VuZCBWNQ0KDQo+ID4gbGluayBhZGQgY29tbWFuZCB1c2luZyBtYWNzZWMgdHlw
ZS4NCj4gPiBJbiBhZGRpdGlvbiwgdXNpbmcgJ3hwbicga2V5d29yZCBpbnN0ZWFkIG9mIHRoZSAn
cG4nLCBwYXNzaW5nIGEgMTINCj4gPiBieXRlcyBzYWx0IHVzaW5nIHRoZSAnc2FsdCcga2V5d29y
ZCBhbmQgcGFzc2luZyBzaG9ydCBzZWN1cmUgY2hhbm5lbA0KPiA+IGlkIChzc2NpKSB1c2luZyB0
aGUgJ3NzY2knIGtleXdvcmQgYXMgcGFydCBvZiB0aGUgaXAgbWFjc2VjIGNvbW1hbmQgaXMNCj4g
PiByZXF1aXJlZCAoc2VlIGV4YW1wbGUpLg0KPiA+DQo+ID4gZS5nOg0KPiA+DQo+ID4gY3JlYXRl
IGEgTUFDc2VjIGRldmljZSBvbiBsaW5rIGV0aDAgd2l0aCBlbmFibGVkIHhwbg0KPiA+ICAgIyBp
cCBsaW5rIGFkZCBsaW5rIGV0aDAgbWFjc2VjMCB0eXBlIG1hY3NlYyBwb3J0IDExDQo+ID4gICAg
ICAgZW5jcnlwdCBvbiB4cG4gb24NCj4gDQo+ICAgICAgICAgICAgICAgICAgICBjaXBoZXIgLi4u
DQoNCkFjayAsIHdpbGwgc2VuZCBWNQ0KDQo+IFsuLi5dDQo+ID4gQEAgLTM5Miw5ICs0MzksMjEg
QEAgc3RhdGljIGludCBkb19tb2RpZnlfbmwoZW51bSBjbWQgYywgZW51bQ0KPiBtYWNzZWNfbmxf
Y29tbWFuZHMgY21kLCBpbnQgaWZpbmRleCwNCj4gPiAgICAgICBhZGRhdHRyOCgmcmVxLm4sIE1B
Q1NFQ19CVUZMRU4sIE1BQ1NFQ19TQV9BVFRSX0FOLCBzYS0+YW4pOw0KPiA+DQo+ID4gICAgICAg
aWYgKGMgIT0gQ01EX0RFTCkgew0KPiA+IC0gICAgICAgICAgICAgaWYgKHNhLT5wbikNCj4gPiAt
ICAgICAgICAgICAgICAgICAgICAgYWRkYXR0cjMyKCZyZXEubiwgTUFDU0VDX0JVRkxFTiwgTUFD
U0VDX1NBX0FUVFJfUE4sDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzYS0+
cG4pOw0KPiA+ICsgICAgICAgICAgICAgaWYgKHNhLT54cG4pIHsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgaWYgKHNhLT5wbi5wbjY0KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGFkZGF0dHI2NCgmcmVxLm4sIE1BQ1NFQ19CVUZMRU4sIE1BQ1NFQ19TQV9BVFRSX1BOLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzYS0+cG4ucG42NCk7
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGlmIChzYS0+c2FsdFswXSAhPSAnXDAnKQ0KPiAN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHNhLT5zYWx0X3NldCkNCj4gDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgYWRkYXR0cl9sKCZyZXEubiwgTUFDU0VDX0JVRkxF
TiwgTUFDU0VDX1NBX0FUVFJfU0FMVCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc2EtPnNhbHQsIE1BQ1NFQ19TQUxUX0xFTik7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIGlmIChzYS0+c3NjaSAhPSAwKQ0KPiANCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgaWYgKHNhLT5zc2NpX3NldCkNCj4gDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgYWRkYXR0cjMyKCZyZXEubiwgTUFDU0VDX0JVRkxFTiwgTUFDU0VDX1NBX0FUVFJfU1NDSSwN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2EtPnNzY2kpOw0K
PiA+ICsgICAgICAgICAgICAgfSBlbHNlIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaWYg
KHNhLT5wbi5wbjMyKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFkZGF0dHIz
MigmcmVxLm4sIE1BQ1NFQ19CVUZMRU4sIE1BQ1NFQ19TQV9BVFRSX1BOLA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzYS0+cG4ucG4zMik7DQo+ID4gKyAgICAg
ICAgICAgICB9DQo+IA0KPiBbLi4uXQ0KPiA+IEBAIC0xMjUxLDYgKzEzMzksNyBAQCBzdGF0aWMg
dm9pZCB1c2FnZShGSUxFICpmKQ0KPiA+ICAgICAgICAgICAgICAgIiAgICAgICAgICAgICAgICAg
IFsgc2VuZF9zY2kgeyBvbiB8IG9mZiB9IF1cbiINCj4gPiAgICAgICAgICAgICAgICIgICAgICAg
ICAgICAgICAgICBbIGVuZF9zdGF0aW9uIHsgb24gfCBvZmYgfSBdXG4iDQo+ID4gICAgICAgICAg
ICAgICAiICAgICAgICAgICAgICAgICAgWyBzY2IgeyBvbiB8IG9mZiB9IF1cbiINCj4gPiArICAg
ICAgICAgICAgICIgICAgICAgICAgICAgICAgICBbIHhwbiB7IG9uIHwgb2ZmIH0gXVxuIg0KPiAN
Cj4gVGhhdCBzaG91bGQgYmUgdGhlIG5ldyAiY2lwaGVyIiBvcHRpb25zIGluc3RlYWQgb2YgInhw
biBvbi9vZmYiLg0KDQpBY2sgLCB3aWxsIHNlbmQgVjUNCg0KPiA+ICAgICAgICAgICAgICAgIiAg
ICAgICAgICAgICAgICAgIFsgcHJvdGVjdCB7IG9uIHwgb2ZmIH0gXVxuIg0KPiA+ICAgICAgICAg
ICAgICAgIiAgICAgICAgICAgICAgICAgIFsgcmVwbGF5IHsgb24gfCBvZmZ9IHdpbmRvdyB7IDAu
LjJeMzItMSB9IF1cbiINCj4gPiAgICAgICAgICAgICAgICIgICAgICAgICAgICAgICAgICBbIHZh
bGlkYXRlIHsgc3RyaWN0IHwgY2hlY2sgfCBkaXNhYmxlZCB9IF1cbiINCj4gDQo+IC0tDQo+IFNh
YnJpbmENCg0K
