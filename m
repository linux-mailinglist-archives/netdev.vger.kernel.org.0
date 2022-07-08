Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9391D56C08E
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbiGHQNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238272AbiGHQNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:13:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2101B5FE6
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:13:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0+Hcudo/KD2dMSHlAaR/ZhB5KE166Qj9IwKswNlWa/Lqt/fS6smgLmcY9erOMS5i0/F0IoYMzC9tyl1Z1VKhJ8INR/dv4c3UUDK6FFsCPni42n3++aNt7/YjlhtzgBLEATg+gOOL+7MpsJmZCnoKTjOOfHp42vTi4Ij7KZSxId/52uZUSMF6ia8VvoK3ftAeky72byk4Bs58IFPSvTTiHPjQ3sNcrWjP85Qv8fG+JxNa3x82zdxZjbf9ECDdh+3UAOeG9+S719qhO0QTRC+KIHN3s/47hQgluTfLMIFercIoC060pqs/BlSrrcC/bry40YSKDOgHMzogYeDbTOX+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqUKcEA9aWL2ObS5mfX9hPQDbOtWckaJEp4uN308G4Q=;
 b=ayKAi64XHG6EUUNGaaIlYU4Uk0UlJBHSI8VW98IYTeAG4vQECi99N/EgIHxOpgKIv9JV4a9BRzCMet82M3+I2fnoDS7dhuyuaEr5rzKbWQhRu0ywbIMgLfHq9DoY3FAvk1wSPRTzP5lw4QM+ZeLxWngsBGTHeVTyV4u6Xb7nHVCRxQ50nrZlnnkajEdmdc0TyT9THQFwo9fqrUuv7gWgaS7kQOxqWaFu2bcn9R8KzUvbWCaIdusYOUMvGAkLl5Al2Q24tg4aQAFWqgJFaX4llowt7jUANbHPp2wyYlMbQaMlrmLs5aDfnw1kq9LCtLVURBZCMlAHzn/fUQEkRZ3iHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqUKcEA9aWL2ObS5mfX9hPQDbOtWckaJEp4uN308G4Q=;
 b=a6Izhv1SrcvA8hkZ9yTBYotXpfHBh5ylfQVGM2Chr+E86dIymjUMKk0PIeLR5EKzecxbsryb3CRnDEq0Xq0pLSlWIMb/OZcZtqM/yUU+qbiGSMXpZUHlPkpeVuTRyOrfQO1nV0R7cJutGJ1Q25ZjfcDeFeeDLausSFMmXkfWMvP7bv8VLFcrXmWbZiS2oEDxfdObFEE+uDFubmY169u+gCuhsNM5b+usrRPYoGUfHBDOyuVlyoNpfiKdSnCLx2Vgud6bfEo7NScfAw57FZQRfTSgNz+pZbbh/G3P2MuOwfNerXN/BpKy6nuspo1vuEhP5+S8TO7RlKCWaVxldro0ag==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Fri, 8 Jul
 2022 16:13:27 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 16:13:27 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYjU+MYrbSKcBokU6ni+IvOk3zwK1qDqQggAn7HwCAAKXIYA==
Date:   Fri, 8 Jul 2022 16:13:27 +0000
Message-ID: <PH0PR12MB54816D143AAB834616FAEF67DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <bfd46eb1-bc82-b1c8-f492-7bcaaada8aa4@intel.com>
In-Reply-To: <bfd46eb1-bc82-b1c8-f492-7bcaaada8aa4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86b7b176-2535-4096-03e1-08da60fccae6
x-ms-traffictypediagnostic: SN1PR12MB2477:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Ht40wUZDL2TMcAIqMcvHcJaOWM9Lz3WuXoZHsDDTYTVqHHtiTZP/mfarLs00+uuF6cXt18N4e19HwnVUpG/AadFGNbHtFvyZENhvxYRKoL0r6p7MnMAjp77jrSFekPVeKVa1zmbLx7S7fMu4QrrZZZXNLbTt1lHqgN2bWnOvWVykIuHKjh5QVSk2sG/bqlrhnSef4G63N01ifQM1hmuuSNg239Ln5M1DVcmUpgKqiivZRq0UTGKDHeiGjB7MpEHt6Or2pThz4HIBfzBb+pJm1bJv6PBGUu/zgeNeTq2iSLti2RyeRLagiOrDwQZJ1aizg6oxmBGL+r3oMY2a5Kc0YLrKL89/jytC/YBY/u7Lt/U3S5oqFqE7vWJTe6qGCGl6Yrxl6rUMxHMj03TTOV46/3O3l4woEDllJ7Zr84J/xgHQNeBBA2rkc4HUH3b5pfvxiFC9KUV+kos86OlPoUQYtem4A/98/Oaqr0DY5B339sUhl+9tsLfd/sekiZsGAJ0zaaYIlgd2jqw2+DAaCFJG/FrpONbK/fsnKMWnaRDl9rLQhs6WYRpBdLj/2e1gGn+0LZdWEkEI8NA+qBxHmqSOEcav98Q/d/PewbAJTsLyXpX/97Oyn3tRsR61oGF6XUiMdNaMbRM+ELncA0pgYvNGpBrDdm7y8h91UyoZwWP5DjWYIuARarK9mI2qdXrjJqr0YOz9WhbrmxYSONZ9p/9n40SvXl0M4UsPoRzwPeh8pMr/z3YaTiziskHGZ23wfULgfegPErcMpNi8YGBUYIYurxeghIMo2a08uxvmOr+VXxBjsgDXnn3pijXFvVMKRwL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(71200400001)(478600001)(4326008)(122000001)(38100700002)(33656002)(53546011)(9686003)(26005)(41300700001)(66476007)(6506007)(7696005)(110136005)(54906003)(66946007)(76116006)(66446008)(64756008)(66556008)(8676002)(316002)(186003)(55016003)(2906002)(52536014)(5660300002)(8936002)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmtIOFJxTm5xdWZ6V0NwSmVpUmF0b0ordktObkxIQWZLNU1ZSGV2TW9OQXlQ?=
 =?utf-8?B?Nmo5WVdKMlk3SFd5WXk3V2lQMzhIb3hSbHBNelZwQU1SbXd0YVVGU1dPbVVN?=
 =?utf-8?B?clJ1eDU0dnYzbWppN292MHV5Qlhpb21hekJaZk1Fak1MTm03eW9PeEE0MjVu?=
 =?utf-8?B?K2NmUzEwUCt5T0NndHloUUI2eWFFL0Jjc1FrMXl4NmhIdGo1Zyt1S1BLNnZ4?=
 =?utf-8?B?OTM1SzhuQVo0VlFFQmMwd2grTnF1YkFIS28xSUZNSEswU1hnS0ZjUmErZElT?=
 =?utf-8?B?Tk40THBmMGxyZkhPbUg1MHpsWHJXY0N5VUorcG51OHVNWWk0bVdDbDRKOEV1?=
 =?utf-8?B?Zm5mZ1JreVY5TDFaakhNY3NLWURKb3gwRkFNYnRTWUpveGk5YmQ5L3B2cHdQ?=
 =?utf-8?B?MkJ4OW41WWRGZFFKaW1nZ0hodGRhSllwNFJaTGRvOFV4Y21KVXQ1UGM4bFRB?=
 =?utf-8?B?bEoxWmZXNFFyWDNKTDIrcU1iWG1LdHBOd3ZaZkNUNEZ0cGRtMmtUVlNlYisz?=
 =?utf-8?B?RmZhVGR6MFJ6RVB4QjZSYzl2WmU4NmxGRllIUlNlZzBYUkN0MzJML0Q4a0Qy?=
 =?utf-8?B?cGR4NmsyZmJIaS9yZ3ZDeDVKM1ZzTlczL0FJVWRHRlhoNjNSUHZ3MmcrMGt4?=
 =?utf-8?B?SDFzWTJYc2Z1SVN0RGZnaTd0MUE1ZVJtOEJQTGVHb05KeE8rM2tWYVY1KzZ2?=
 =?utf-8?B?M0dlYjUrbjZwczd0Y0plY1dUVkJreFUyVU9lYmROQW1ScG9Ya3RnUklUcG45?=
 =?utf-8?B?OElKZ3dZT1FVL0M1UTVKeGh4dFlWZWJmVjBJdCtxOUFkN0ZMZTBSaTI1OTdv?=
 =?utf-8?B?UElubDJyT3BQS3hZZ3VJVUVJSGxjNEdmVHRSVWNIekw4NnBBQnR3VnBiZXB2?=
 =?utf-8?B?SVBhQnNrdldzYVhJOTFYNUF0RkRseUZSeHp3RDBybHlzTnMvUjNMUE4wV3A0?=
 =?utf-8?B?TnU1akRMVDd3VDVFK3d5YVhCTjNHVjc2MkhUcThtMTUramswdjdkY2xrNkZC?=
 =?utf-8?B?dS9idCtBcjhSak9aLy9CY1pXMm9WdExjR2k1WkRJcS84cmRUVm5mZHRpS1ht?=
 =?utf-8?B?WHdjNWU2ZHB3eG05TFpZWmxxUDhqM2pXZkkrMXRZcVU5L0Nkb2xkNEV6c29Z?=
 =?utf-8?B?Uk44UDkyZkVUVnhBcXliSWtzT3RRS1BMazIrc1UzTzBkNFFHK1MvQ2VFeHdY?=
 =?utf-8?B?VnVYWUZDLzJ6citSK1A0Rk5vU1dUUk9RVWtOQVlVaVA3cGk1YlRPeUYzRkhF?=
 =?utf-8?B?UEJRWk1mT2NnQ24rN054UXJyRkpMcnRzbjhTNzFqSjRtb3lJOUR3UzNabFZC?=
 =?utf-8?B?elA0OHp5Mm1ZOTFaSG9ZQWxtZXlWeVYzZUZqREt0NmRpcXBlT1ZNL2ExRDZy?=
 =?utf-8?B?QlF5UEdwdUQvYmRlNitPR0FyQlg2Yzc2QjdLTHR5VWRBRzNqdlVVWXBqTnFX?=
 =?utf-8?B?U05JbDRKV0hzaXJlRTBLL2hiLzAxSTV6Rlpxdk1jaG9yODF1VVFnNk1xOUZ5?=
 =?utf-8?B?SWExY2x0RGVxaEhFbFBBQUd0aWdSMWdsTFFyQkJIRHhIaGR0UW9QUjJKVklq?=
 =?utf-8?B?WlNvTTFIL2hoWUVmZGJLTmdFWHh6S3NGUW05bStTS2UySGhyOGt0N3Qzcnkw?=
 =?utf-8?B?NTlJZXB6NTJ4UUZxVGpKaFJoK21yMzNLbmhuVVNiY3FsYmpxeGtQVS92S1Fl?=
 =?utf-8?B?aHpjcHY0VXREZ0FXY25LSVNvVTFiKzFlbzVpSWw3eVRPNWJ1eDNuYzlPVWU3?=
 =?utf-8?B?UkxTQnBsbk5oejlQNVZXaS9peVhMSHlwSVhvZ1A4ZmJUZzlBdzVKRmE2VXQ3?=
 =?utf-8?B?OEJQQjNwZzFYSUZqN1JCVjRkQ1hkQ0N1aGZSaE8ybUd2ZUpZbmJKOE1kZGww?=
 =?utf-8?B?V0htcXJnVUhGb1lKaWlmUHBwNFMwZ3ZTaC9qUUlFODY2UWRmbTlnTWFqTkZi?=
 =?utf-8?B?d2ZqN3RrcEVkK2lCUlc2NGJrWHFuMmJBTGVCVU1Kb1RsTXBoY3NnRzA4ZGFF?=
 =?utf-8?B?aHFwT2NKZitEck5UNE1oV0RhQkVKamRETVl6aFlRL3dQNGhycDFWNGhnVmpH?=
 =?utf-8?B?Wjc0M09EMEFFSFdVaEZFb2U2TWdoUkdmajV5M0lmMlN4aytwZEVuQVhlYWxz?=
 =?utf-8?Q?kfTY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b7b176-2535-4096-03e1-08da60fccae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 16:13:27.8131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2DovzV3/jvrtXezgB/cxmUeKT5W3wWlBzJdi/OgobbOgStxa+bdlAjrOnTYUP5JPaqrcbHRDMY551R/b+j6xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2477
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWmh1LCBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gU2Vu
dDogRnJpZGF5LCBKdWx5IDgsIDIwMjIgMjoxNiBBTQ0KPiANCj4gT24gNy8yLzIwMjIgNjowMiBB
TSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+DQo+ID4+IEZyb206IFpodSBMaW5nc2hhbiA8bGlu
Z3NoYW4uemh1QGludGVsLmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBKdWx5IDEsIDIwMjIgOToy
OCBBTQ0KPiA+Pg0KPiA+PiBUaGlzIGNvbW1pdCBhZGRzIGEgbmV3IHZEUEEgbmV0bGluayBhdHRy
aWJ1dGlvbg0KPiA+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLiBVc2Vy
c3BhY2UgY2FuIHF1ZXJ5DQo+IGZlYXR1cmVzDQo+ID4+IG9mIHZEUEEgZGV2aWNlcyB0aHJvdWdo
IHRoaXMgbmV3IGF0dHIuDQo+ID4+DQo+ID4+IEZpeGVzOiBhNjQ5MTdiYzJlOWIgdmRwYTogKFBy
b3ZpZGUgaW50ZXJmYWNlIHRvIHJlYWQgZHJpdmVyIGZlYXR1cmUpDQo+ID4gTWlzc2luZyB0aGUg
IiIgaW4gdGhlIGxpbmUuDQo+IHdpbGwgZml4DQo+ID4gSSByZXZpZXdlZCB0aGUgcGF0Y2hlcyBh
Z2Fpbi4NCj4gPg0KPiA+IEhvd2V2ZXIsIHRoaXMgaXMgbm90IHRoZSBmaXguDQo+ID4gQSBmaXgg
Y2Fubm90IGFkZCBhIG5ldyBVQVBJLg0KPiBJIHRoaW5rIHdlIGhhdmUgZGlzY3Vzc2VkIHRoaXMs
IG9uIHdoeSB3ZSBjYW4gbm90IHJlLW5hbWUgdGhlIGV4aXN0aW5nDQo+IHdyb25nIG5hbWVkIGF0
dHIsIGFuZCB3aHkgd2UgY2FuIG5vdCByZS11c2UgdGhlIGF0dHIuDQo+IFNvIGFyZSB5b3Ugc3Vn
Z2VzdGluZyByZW1vdmUgdGhpcyBmaXhlcyB0YWc/DQo+IEFuZCB3aHkgYSBmaXggY2FuIG5vdCBh
ZGQgYSBuZXcgdUFQST8NCg0KQmVjYXVzZSBhIG5ldyBhdHRyaWJ1dGUgY2Fubm90IGZpeCBhbnkg
ZXhpc3RpbmcgYXR0cmlidXRlLg0KDQpXaGF0IGlzIGRvbmUgaW4gdGhlIHBhdGNoIGlzIHNob3cg
Y3VycmVudCBhdHRyaWJ1dGVzIG9mIHRoZSB2ZHBhIGRldmljZSAod2hpY2ggc29tZXRpbWVzIGNv
bnRhaW5zIGEgZGlmZmVyZW50IHZhbHVlIHRoYW4gdGhlIG1nbXQuIGRldmljZSkuDQpTbyBpdCBp
cyBhIG5ldyBmdW5jdGlvbmFsaXR5IHRoYXQgY2Fubm90IGhhdmUgZml4ZXMgdGFnLg0KDQo+ID4N
Cj4gPiBDb2RlIGlzIGFscmVhZHkgY29uc2lkZXJpbmcgbmVnb3RpYXRlZCBkcml2ZXIgZmVhdHVy
ZXMgdG8gcmV0dXJuIHRoZSBkZXZpY2UNCj4gY29uZmlnIHNwYWNlLg0KPiA+IEhlbmNlIGl0IGlz
IGZpbmUuDQo+IE5vLCB0aGUgc3BlYyBzYXlzOg0KPiBUaGUgZGV2aWNlIE1VU1QgYWxsb3cgcmVh
ZGluZyBvZiBhbnkgZGV2aWNlLXNwZWNpZmljIGNvbmZpZ3VyYXRpb24gZmllbGQNCj4gYmVmb3Jl
IEZFQVRVUkVTX09LIGlzIHNldCBieSB0aGUgZHJpdmVyLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBp
bnRlbnRzIHRvIHByb3ZpZGUgZGV2aWNlIGZlYXR1cmVzIHRvIHVzZXIgc3BhY2UuDQo+ID4gRmly
c3Qgd2hhdCB2ZHBhIGRldmljZSBhcmUgY2FwYWJsZSBvZiwgYXJlIGFscmVhZHkgcmV0dXJuZWQg
YnkgZmVhdHVyZXMNCj4gYXR0cmlidXRlIG9uIHRoZSBtYW5hZ2VtZW50IGRldmljZS4NCj4gPiBU
aGlzIGlzIGRvbmUgaW4gY29tbWl0IFsxXS4NCj4gd2UgaGF2ZSBkaXNjdXNzZWQgdGhpcyBpbiBh
bm90aGVyIHRocmVhZCwgdkRQQSBkZXZpY2UgZmVhdHVyZSBiaXRzIGNhbiBiZQ0KPiBkaWZmZXJl
bnQgZnJvbSB0aGUgbWFuYWdlbWVudCBkZXZpY2UgZmVhdHVyZSBiaXRzLg0KPiA+DQpZZXMuIA0K
PiA+IFRoZSBvbmx5IHJlYXNvbiB0byBoYXZlIGl0IGlzLCB3aGVuIG9uZSBtYW5hZ2VtZW50IGRl
dmljZSBpbmRpY2F0ZXMgdGhhdA0KPiBmZWF0dXJlIGlzIHN1cHBvcnRlZCwgYnV0IGRldmljZSBt
YXkgZW5kIHVwIG5vdCBzdXBwb3J0aW5nIHRoaXMgZmVhdHVyZSBpZg0KPiBzdWNoIGZlYXR1cmUg
aXMgc2hhcmVkIHdpdGggb3RoZXIgZGV2aWNlcyBvbiBzYW1lIHBoeXNpY2FsIGRldmljZS4NCj4g
PiBGb3IgZXhhbXBsZSBhbGwgVkZzIG1heSBub3QgYmUgc3ltbWV0cmljIGFmdGVyIGxhcmdlIG51
bWJlciBvZiB0aGVtIGFyZQ0KPiBpbiB1c2UuIEluIHN1Y2ggY2FzZSBmZWF0dXJlcyBiaXQgb2Yg
bWFuYWdlbWVudCBkZXZpY2UgY2FuIGRpZmZlciAobW9yZQ0KPiBmZWF0dXJlcykgdGhhbiB0aGUg
dmRwYSBkZXZpY2Ugb2YgdGhpcyBWRi4NCj4gPiBIZW5jZSwgc2hvd2luZyBvbiB0aGUgZGV2aWNl
IGlzIHVzZWZ1bC4NCj4gPg0KPiA+IEFzIG1lbnRpb25lZCBiZWZvcmUgaW4gVjIsIGNvbW1pdCBb
MV0gaGFzIHdyb25nbHkgbmFtZWQgdGhlIGF0dHJpYnV0ZSB0bw0KPiBWRFBBX0FUVFJfREVWX1NV
UFBPUlRFRF9GRUFUVVJFUy4NCj4gPiBJdCBzaG91bGQgaGF2ZSBiZWVuLA0KPiBWRFBBX0FUVFJf
REVWX01HTVRERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLg0KPiA+IEJlY2F1c2UgaXQgaXMgaW4gVUFQ
SSwgYW5kIHNpbmNlIHdlIGRvbid0IHdhbnQgdG8gYnJlYWsgY29tcGlsYXRpb24gb2YNCj4gPiBp
cHJvdXRlMiwgSXQgY2Fubm90IGJlIHJlbmFtZWQgYW55bW9yZS4NCj4gWWVzLCByZW5hbWUgaXQg
d2lsbCBicmVhayBjdXJyZW50IHVBUEksIHNvIEkgY2FuIG5vdCByZW5hbWUgaXQuDQo+ID4NCkkg
a25vdywgd2hpY2ggaXMgd2h5IHRoaXMgcGF0Y2ggbmVlZHMgdG8gZG8gZm9sbG93aW5nIGxpc3Rl
ZCBjaGFuZ2VzIGRlc2NyaWJlZCBpbiBwcmV2aW91cyBlbWFpbC4NCg0KPiA+IEdpdmVuIHRoYXQs
IHdlIGRvIG5vdCB3YW50IHRvIHN0YXJ0IHRyZW5kIG9mIG5hbWluZyBkZXZpY2UgYXR0cmlidXRl
cyB3aXRoDQo+IGFkZGl0aW9uYWwgX1ZEUEFfIHRvIGl0IGFzIGRvbmUgaW4gdGhpcyBwYXRjaC4N
Cj4gPiBFcnJvciBpbiBjb21taXQgWzFdIHdhcyBleGNlcHRpb24uDQo+ID4NCj4gPiBIZW5jZSwg
cGxlYXNlIHJldXNlIFZEUEFfQVRUUl9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTIHRvIHJldHVybg0K
PiBmb3IgZGV2aWNlIGZlYXR1cmVzIHRvby4NCj4gPg0KPiA+IFNlY29uZGx5LCB5b3UgbmVlZCBv
dXRwdXQgZXhhbXBsZSBmb3Igc2hvd2luZyBkZXZpY2UgZmVhdHVyZXMgaW4gdGhlDQo+IGNvbW1p
dCBsb2cuDQo+ID4NCj4gPiAzcmQsIHBsZWFzZSBkcm9wIHRoZSBmaXhlcyB0YWcgYXMgbmV3IGNh
cGFiaWxpdHkgaXMgbm90IGEgZml4Lg0KPiA+DQoNCg==
