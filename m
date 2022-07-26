Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A94581198
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiGZLGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiGZLGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:06:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0B02F012
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:06:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhKs/l5eamB7Mmk6dfcPE1gBhNcH2Qnm6QGJ8iN8+3K/4pIJdFLLf0ybOCueAgm4T+1Q1Q6euilhDY5ykskEmm0A5jhJe9We36dlS6JjQZ5v9QhMMKdZZAcXWgD7hv7eUDhSGvD9eit5WlFUkb91fy14LK8BV6zCo3HaYtZ3xlxxsZhxPXMAmfSqSlQgVLkJH5khRPMa2Lr6rG8wCVpxfjBuG98jAsjsU8j/g3JO4abBZcItk77BjaAUaMxSYIL0yUfX7KopMyqav+hjtouZuYMe+mpaVkM0QXC4Gykc5spq6/dDVjA00aKI/Wf5bIPg5CBsMtahE2/WIqrAxnO3yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmKQLXzuEBliKaOSLEp2wtUMQmv60u41ZuHIwk9hzRE=;
 b=j5XFY91kbOeG6C9F0X9MY6cZYonOfUymcfOZArDeMIOfPYaSOSFKglb19s8v3+Lyg7FIewOJpv+m0U71i2npv9cADji3MD4OuyUdRkG3lJYyv6IMHiUyu3jm3LFS7EeZG5x9EZrTX7uOMox1kBNw2+gNOQ3BINFSxi4gndhfDKpyueTbA81sdq0yI61J8Y9qf6so2EbkzltBJVme/yvdd20WDw/kfVzQkFoC0RsQ9mJyxuFxoitkhakgzB9ihb51El5RV74xAimEn0HBTVO+SpmmRi0RZqWEFGlLVqKI9oO88v+mlNcqIaIyRDlB9sY0o5BXbmxLEroGZvxGyAgJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmKQLXzuEBliKaOSLEp2wtUMQmv60u41ZuHIwk9hzRE=;
 b=rcS+p4h2u7tV/zpT6jVoVDGGuqXqRsFFNX5k2K0N7SVdd9X+/Q0nEDbFhYKmAfNfsTQvKfbuuyDT20PSMZLYRxKOuRntSdh7u1OkEA87df0gC5VmYY04eHXUQX43u8xOWb/mgIytn4tpfrHUImh5HfKvseu/TjrksWXCjbt/2V2EAPluC2EOc6mn6z3u+/r/LSxASXqYmFCLg+HDqjIgcM3UWdOuzWaIc82fPf8fAmL292Q85bOcm8KEBs0HBZzGME0J44r3tsSKgy3BY0Arcf5c5+vlGgasauweLjwikpkwPwVCfMlOFc20uNbPeVVQ5ji43++P6g1bbE/0XoTPyA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MW4PR12MB6708.namprd12.prod.outlook.com (2603:10b6:303:1ed::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 11:06:51 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 11:06:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYncLBTkGC7Q3QJk+hIdvX3SqZ2q2KXRuQgAF0rYCAAdS1UIAC3HsAgAAA0NA=
Date:   Tue, 26 Jul 2022 11:06:51 +0000
Message-ID: <PH0PR12MB548133788748EF91F959C143DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <6dc2229c-f2f3-017f-16fa-4611e53c774e@intel.com>
 <PH0PR12MB5481D9BBC9C249840E4CDF7EDC929@PH0PR12MB5481.namprd12.prod.outlook.com>
 <9d9d6022-5d49-6f6e-a1ff-562d088ad03c@intel.com>
In-Reply-To: <9d9d6022-5d49-6f6e-a1ff-562d088ad03c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bad2698f-c421-4f1e-e5f4-08da6ef6f151
x-ms-traffictypediagnostic: MW4PR12MB6708:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yhyq3P9jIzrImi9yf63yOSXfTjKKkPqYayl+dx+98MkoYz07SfpQrzzLIY5Ll+X5qmaLOgsxR52l7XB6OCMKj6ix8hq8BBaKX4+/C0c/X7Mz3Nie/DuGiS+eLM5TgPowuD0/H0g0ZdPyv8/rM+2XZGtPoAYiTFnS/G991KoiazcYzvM2aHnpB61VInihDNf/74oPSqFhZIt8ZAbzmufX0h8TTmuZoJPg50DFn9p09W7ZgdZgYywt9fRFkmCikdAHKYDrJPk3RHVlwtbIynmFeeeasILJpaGNdJmu9tdTyR2/Jwb6qs3//V+GscbqyKW+6gjo+HZyekp4CrmYTJjrwJ4lGiKBpKT4XArjHmzJ6iTOHGT8SnaWzSh6QGNPQUVOh4hObmhGp+Vz0WJtDKIWJ1jHoppyu2X2znUfls4jYl2hzux74HzJLFa2D5Q/7zexK+kvMnwYI7E7hC2XBM+U2IJiyAYgXFvt5SuJ8IWThx+Yd35YIjCq1+gC+kJoXubuFoT6puekKUxRsIHPWB7NCbHJynBtTZFrFZ4oEY7uT8Of29/BlV2loyaDIyYyo/m4ga0NgqoBnWB/e6+HMguI+aIyekFDAu9pbPQRlHpdtAcjDUohFgrgypmjJyKwZs+L4SPleQAW/61CN+dMljjEKTlEvKsAGhvoyPF0FXfOMxjVso6jdizrP7zg7j79apOeUTStE7ULpeL7SGm/kos6O/E7tc5wYnha2g5Y+e+DcZeVDR2jLjtW6BPl2L1UMH75GrHhLVVzXLBrErB3TSPj1WXwuNxHXEmqmu8Sj7ibM5jJGYUTY1TT63k3n4Re7GXC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(7696005)(53546011)(4326008)(8676002)(186003)(52536014)(9686003)(71200400001)(64756008)(66446008)(86362001)(66476007)(66556008)(66946007)(76116006)(6506007)(26005)(2906002)(54906003)(5660300002)(38070700005)(110136005)(8936002)(316002)(122000001)(478600001)(41300700001)(55016003)(33656002)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MW4vWU8zS1VnbW5ZREFSM252clN5bGVhQUZ0NllDWmVWK3JEbmx1UmFtU0dW?=
 =?utf-8?B?Y21vRG9Gb3poQnlqMVJCTzFlbjF5L29lZndaNlpXSFBmaU1XZnR6N3BkMjdj?=
 =?utf-8?B?VWU0aWVMVFZrdGN4aXN3aWZpRlY3TGVmZjIzYlVvVDAycjZVQUxwWTZhd2ph?=
 =?utf-8?B?OW9ZamdoclRnK1g3VG4zTktyNkJucG42MUR1NUxzeXRucDZIQXkxNEt2akYr?=
 =?utf-8?B?WGdaWVhPWDlWTFZ3cnNVU2Q0YWpXU0NlSWRJenQ4QlovTXZaN1VySEVrMnJS?=
 =?utf-8?B?S2wxNWhqdWpRNEZEc2E4TEw0ek02VHF4ajNYbi9iT0o1ZXVldDRDYVNTZExG?=
 =?utf-8?B?MXFtL1MwWGFVVDVDSEVnY3VyZXpMWjRtOGhpcmR6RXlUT2dDWUo3ZHlXbzJ6?=
 =?utf-8?B?SWJtMDA1L1RKQ3FBbjdySkQzOHEwdlk1RUpxYk9BTktERG80UTBmRTBIT043?=
 =?utf-8?B?dDhRZ0MwSzhOalE3aGZhbTRhWmhzV1hSRmdhaEZWclJwb0lndjdCcDAzSkNF?=
 =?utf-8?B?U2pqQWJvMU5rRG9sMGc5UlNvaHlONE1yNDF6M29kQ1UzUVNPK1ZDeTdOeFhv?=
 =?utf-8?B?M05vUktUbkdSeVlQdzRxNVRVd3FqWHBFaTVNeFZ1ckR1RGFaaGwvM2ErbnpS?=
 =?utf-8?B?RzZZZHYvVm9kM0RQUVM4U1NlM2pzZFB3SDh1ekNIbGpYNU5BUERMSmFwd1hk?=
 =?utf-8?B?U0tjaHZFeklZSHA4akhIQTFNMUlmYVR3VzF4MDVHWExlR0N3ZjlIY1hxS3dj?=
 =?utf-8?B?QnFkbWFjdWJMTUJsakJkUlFoUGk3bG12RkFlRFFMRGJ6WnE2aFR4emt2eVo1?=
 =?utf-8?B?ZG15QytJSjJGc2x0RFhBTlNJR0c1RnBGaVJkb1NXdUVFa1Z0a0x0NGVTcUk2?=
 =?utf-8?B?RWdscUN6bDVjUVZ5QmlmWFVvWTFuQUZOc2F2eGx6T1dTU1pFV2xvUnZaNHJ2?=
 =?utf-8?B?aWU2RjZYM0lZd013cTltRmxSUEJNT0t4NlVxRlZBcmxMNmd0ZTJ4d2pZQWd1?=
 =?utf-8?B?QTh0R2lsUHREVWZRMkRRQ054a01IcHcrN01Ra1cvcjFiNFJ5Qk1DazNneFdV?=
 =?utf-8?B?WjM4SmY5bStJSi9ESWJpMFVHVjMzdTdPWmxCbDU5OWtOTmFWU2p1RlhjTncx?=
 =?utf-8?B?YkV1MzB0SUhHNXY4cEUwOHBpcCszRjlJbTIrcG9WRE9veFVsbUhCRFlzTW94?=
 =?utf-8?B?ZkNSdUxPZjN1YzVlVUtDcEUraHhuamx6T3NMYjY3SXdEeWtxSW9yRG1oTmVJ?=
 =?utf-8?B?dWZnZHdNRGVNLzN5YVFMQkJML2Q3c3ZWNlBLUjU5Qm11alBQOEcwOXNPRHNV?=
 =?utf-8?B?SkJnZHVhR3pOazdYYTdvQW1rQm8vU1FYbVQ4YUo3Q3JHNmU3UTJJSDRVbFli?=
 =?utf-8?B?dTNjYjdSalBid3ZhTFEvZkkwR3RkYkNQSldVY1ZNTFpLYXBUYU5JUEdEY0pT?=
 =?utf-8?B?MnhoVXdEc2RBSkIzTHhISm5jcWZMa0Rod1hpYURjZ0xtNGhiNzIrbmZBeFV1?=
 =?utf-8?B?ejZEVnhzZDJnQm1kTVRJMW1yME5ycUhhUUREYU9GUy9kVUZuRHV2NWhmQ3ox?=
 =?utf-8?B?cWFIc1Z3ZDNKVGFzZ3dEZlV4aWNuZE5VeCt2RXlwTDF6UUVyYWRVZTJnc0du?=
 =?utf-8?B?NWVsdVdNYnpTK1JNbHRvS2txYlNIbmVhK1dZNnFDeWZkZllGUjU1UFQ0dEVj?=
 =?utf-8?B?SDZ5ZlRzN0hwenBQWjRnQUg4YXh3VFJOeDM0cDFvU0xhbWk5Wk80YW1tMmda?=
 =?utf-8?B?QmxIa0dWOHZ2ZTZxNUowaDNOMUNzS1loME96VEIwRkZGdFI1bjViYU1xOGpB?=
 =?utf-8?B?MXZZNVpBY0c0Q3p0c3VXc2NsOVFKWWEwd2dJRjhuQWJDQU1wam9jbVh0TjEv?=
 =?utf-8?B?cUFvaXBnaElDWmhOMGo4bGI0Qy85RGxLNjdQUDN6U2tJVHlac24zTVZrS3hm?=
 =?utf-8?B?M0FBcGpqcDFTME5QRkhIL2RoRVR1SFhOQjdLMkk5TW9ScnNBNHdPQVJLemVt?=
 =?utf-8?B?ZWZpc2pxQnViTGgrblVaMlJJOWZnclVVMEZLQ1B1eElTc2g1RXBiSnltSW9R?=
 =?utf-8?B?N2pDa2FOV1RYNEJDNTUycGNFM2RDa0Q2ZDlFRGozcFcyTzFrQU1xS0gvUlRM?=
 =?utf-8?Q?UC/w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad2698f-c421-4f1e-e5f4-08da6ef6f151
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 11:06:51.5585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jYyr1iiYcaFalfqg+XGyiL9JwDYWwBCIE5acnjXBjPYta8py3HJCCnIaI28LG4lQeTUxPaNwUKICrcqfbypMmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6708
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIgNzowMyBBTQ0KPiANCj4gT24gNy8yNC8yMDIyIDExOjIx
IFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4NCj4gPj4gRnJvbTogWmh1LCBMaW5nc2hhbiA8
bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gPj4gU2VudDogU2F0dXJkYXksIEp1bHkgMjMsIDIw
MjIgNzoyNCBBTQ0KPiA+Pg0KPiA+Pg0KPiA+PiBPbiA3LzIyLzIwMjIgOToxMiBQTSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+Pj4+IEZyb206IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGlu
dGVsLmNvbT4NCj4gPj4+PiBTZW50OiBGcmlkYXksIEp1bHkgMjIsIDIwMjIgNzo1MyBBTQ0KPiA+
Pj4+DQo+ID4+Pj4gVGhpcyBjb21taXQgYWRkcyBhIG5ldyB2RFBBIG5ldGxpbmsgYXR0cmlidXRp
b24NCj4gPj4+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLiBVc2Vyc3Bh
Y2UgY2FuDQo+IHF1ZXJ5DQo+ID4+IGZlYXR1cmVzDQo+ID4+Pj4gb2YgdkRQQSBkZXZpY2VzIHRo
cm91Z2ggdGhpcyBuZXcgYXR0ci4NCj4gPj4+Pg0KPiA+Pj4+IFNpZ25lZC1vZmYtYnk6IFpodSBM
aW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gPj4+PiAtLS0NCj4gPj4+PiAgICBk
cml2ZXJzL3ZkcGEvdmRwYS5jICAgICAgIHwgMTMgKysrKysrKysrLS0tLQ0KPiA+Pj4+ICAgIGlu
Y2x1ZGUvdWFwaS9saW51eC92ZHBhLmggfCAgMSArDQo+ID4+Pj4gICAgMiBmaWxlcyBjaGFuZ2Vk
LCAxMCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+Pj4+DQo+ID4+Pj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdmRwYS92ZHBhLmMgYi9kcml2ZXJzL3ZkcGEvdmRwYS5jIGluZGV4DQo+
ID4+Pj4gZWJmMmYzNjNmYmU3Li45YjBlMzliMmYwMjIgMTAwNjQ0DQo+ID4+Pj4gLS0tIGEvZHJp
dmVycy92ZHBhL3ZkcGEuYw0KPiA+Pj4+ICsrKyBiL2RyaXZlcnMvdmRwYS92ZHBhLmMNCj4gPj4+
PiBAQCAtODE1LDcgKzgxNSw3IEBAIHN0YXRpYyBpbnQgdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19m
aWxsKHN0cnVjdA0KPiA+Pj4+IHZkcGFfZGV2aWNlICp2ZGV2LCAgc3RhdGljIGludCB2ZHBhX2Rl
dl9uZXRfY29uZmlnX2ZpbGwoc3RydWN0DQo+ID4+Pj4gdmRwYV9kZXZpY2UgKnZkZXYsIHN0cnVj
dCBza19idWZmICptc2cpICB7DQo+ID4+Pj4gICAgCXN0cnVjdCB2aXJ0aW9fbmV0X2NvbmZpZyBj
b25maWcgPSB7fTsNCj4gPj4+PiAtCXU2NCBmZWF0dXJlczsNCj4gPj4+PiArCXU2NCBmZWF0dXJl
c19kZXZpY2UsIGZlYXR1cmVzX2RyaXZlcjsNCj4gPj4+PiAgICAJdTE2IHZhbF91MTY7DQo+ID4+
Pj4NCj4gPj4+PiAgICAJdmRwYV9nZXRfY29uZmlnX3VubG9ja2VkKHZkZXYsIDAsICZjb25maWcs
IHNpemVvZihjb25maWcpKTsgQEANCj4gPj4+PiAtDQo+ID4+Pj4gODMyLDEyICs4MzIsMTcgQEAg
c3RhdGljIGludCB2ZHBhX2Rldl9uZXRfY29uZmlnX2ZpbGwoc3RydWN0DQo+ID4+Pj4gdmRwYV9k
ZXZpY2UgKnZkZXYsIHN0cnVjdCBza19idWZmICptcw0KPiA+Pj4+ICAgIAlpZiAobmxhX3B1dF91
MTYobXNnLCBWRFBBX0FUVFJfREVWX05FVF9DRkdfTVRVLCB2YWxfdTE2KSkNCj4gPj4+PiAgICAJ
CXJldHVybiAtRU1TR1NJWkU7DQo+ID4+Pj4NCj4gPj4+PiAtCWZlYXR1cmVzID0gdmRldi0+Y29u
ZmlnLT5nZXRfZHJpdmVyX2ZlYXR1cmVzKHZkZXYpOw0KPiA+Pj4+IC0JaWYgKG5sYV9wdXRfdTY0
XzY0Yml0KG1zZywNCj4gPj4+PiBWRFBBX0FUVFJfREVWX05FR09USUFURURfRkVBVFVSRVMsIGZl
YXR1cmVzLA0KPiA+Pj4+ICsJZmVhdHVyZXNfZHJpdmVyID0gdmRldi0+Y29uZmlnLT5nZXRfZHJp
dmVyX2ZlYXR1cmVzKHZkZXYpOw0KPiA+Pj4+ICsJaWYgKG5sYV9wdXRfdTY0XzY0Yml0KG1zZywN
Cj4gPj4+PiBWRFBBX0FUVFJfREVWX05FR09USUFURURfRkVBVFVSRVMsIGZlYXR1cmVzX2RyaXZl
ciwNCj4gPj4+PiArCQkJICAgICAgVkRQQV9BVFRSX1BBRCkpDQo+ID4+Pj4gKwkJcmV0dXJuIC1F
TVNHU0laRTsNCj4gPj4+PiArDQo+ID4+Pj4gKwlmZWF0dXJlc19kZXZpY2UgPSB2ZGV2LT5jb25m
aWctPmdldF9kZXZpY2VfZmVhdHVyZXModmRldik7DQo+ID4+Pj4gKwlpZiAobmxhX3B1dF91NjRf
NjRiaXQobXNnLA0KPiA+Pj4+IFZEUEFfQVRUUl9WRFBBX0RFVl9TVVBQT1JURURfRkVBVFVSRVMs
DQo+ID4+Pj4gK2ZlYXR1cmVzX2RldmljZSwNCj4gPj4+PiAgICAJCQkgICAgICBWRFBBX0FUVFJf
UEFEKSkNCj4gPj4+PiAgICAJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4+Pj4NCj4gPj4+PiAtCXJl
dHVybiB2ZHBhX2Rldl9uZXRfbXFfY29uZmlnX2ZpbGwodmRldiwgbXNnLCBmZWF0dXJlcywgJmNv
bmZpZyk7DQo+ID4+Pj4gKwlyZXR1cm4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19maWxsKHZkZXYs
IG1zZywgZmVhdHVyZXNfZHJpdmVyLA0KPiA+Pj4+ICsmY29uZmlnKTsNCj4gPj4+PiAgICB9DQo+
ID4+Pj4NCj4gPj4+PiAgICBzdGF0aWMgaW50DQo+ID4+Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
dWFwaS9saW51eC92ZHBhLmggYi9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4+Pj4gaW5k
ZXgNCj4gPj4+PiAyNWM1NWNhYjNkN2MuLjM5ZjFjM2Q3YzExMiAxMDA2NDQNCj4gPj4+PiAtLS0g
YS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4+Pj4gKysrIGIvaW5jbHVkZS91YXBpL2xp
bnV4L3ZkcGEuaA0KPiA+Pj4+IEBAIC00Nyw2ICs0Nyw3IEBAIGVudW0gdmRwYV9hdHRyIHsNCj4g
Pj4+PiAgICAJVkRQQV9BVFRSX0RFVl9ORUdPVElBVEVEX0ZFQVRVUkVTLAkvKiB1NjQgKi8NCj4g
Pj4+PiAgICAJVkRQQV9BVFRSX0RFVl9NR01UREVWX01BWF9WUVMsCQkvKiB1MzIgKi8NCj4gPj4+
PiAgICAJVkRQQV9BVFRSX0RFVl9TVVBQT1JURURfRkVBVFVSRVMsCS8qIHU2NCAqLw0KPiA+Pj4+
ICsJVkRQQV9BVFRSX1ZEUEFfREVWX1NVUFBPUlRFRF9GRUFUVVJFUywJLyogdTY0ICovDQo+ID4+
Pj4NCj4gPj4+IEkgaGF2ZSBhbnN3ZXJlZCBpbiBwcmV2aW91cyBlbWFpbHMuDQo+ID4+PiBJIGRp
c2FncmVlIHdpdGggdGhlIGNoYW5nZS4NCj4gPj4+IFBsZWFzZSByZXVzZSBWRFBBX0FUVFJfREVW
X1NVUFBPUlRFRF9GRUFUVVJFUy4NCj4gPj4gSSBiZWxpZXZlIHdlIGhhdmUgYWxyZWFkeSBkaXNj
dXNzZWQgdGhpcyBiZWZvcmUgaW4gdGhlIFYzIHRocmVhZC4NCj4gPj4gSSBoYXZlIHRvbGQgeW91
IHRoYXQgcmV1c2luZyB0aGlzIGF0dHIgd2lsbCBsZWFkIHRvIGEgbmV3IHJhY2UgY29uZGl0aW9u
Lg0KPiA+Pg0KPiA+IFJldHVybmluZyBhdHRyaWJ1dGUgY2Fubm90IGxlYWQgdG8gYW55IHJhY2Ug
Y29uZGl0aW9uLg0KPiBQbGVhc2UgcmVmZXIgdG8gb3VyIGRpc2N1c3Npb24gaW4gdGhlIFYzIHNl
cmllcywgSSBoYXZlIGV4cGxhaW5lZCBpZiByZS11c2UgdGhpcw0KPiBhdHRyLCBpdCB3aWxsIGJl
IGEgbXVsdGlwbGUgY29uc3VtZXJzIGFuZCBtdWx0aXBsZSBwcm9kdWNlcyBtb2RlbCwgaXQgaXMg
YQ0KPiB0eXBpY2FsIHJhY2luZyBjb25kaXRpb24uDQoNCkkgcmVhZCB0aGUgZW1haWxzIHdpdGgg
c3ViamVjdCA9ICIgUmU6IFtQQVRDSCBWMyAzLzZdIHZEUEE6IGFsbG93IHVzZXJzcGFjZSB0byBx
dWVyeSBmZWF0dXJlcyBvZiBhIHZEUEEgZGV2aWNlIg0KSSBjb3VsZG7igJl0IGZpbmQgbXVsdGlw
bGUgY29uc3VtZXJzIG11bHRpcGxlIHByb2R1Y2VycyB3b3JraW5nIG9uIHNhbWUgbmxhIG1lc3Nh
Z2UuDQo=
