Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5445816D9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiGZP4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiGZP4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:56:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3FF2C119
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:56:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NE8aDojkwBOBTRDtTGs9FSuG/4wVsO8fPegFzkYZbWlmTlYlNZ0m4VOcH2FjuaSLQZ/ouO+2mtRlb9VQpKo1BwzLOjGtiOlOVg9IHP+bHb3P1a6pJ+xll+FM1gqOLRi7SnXKSzAcDfTeLN4lgf34QcdJLjgYNr9JMD2oO2EYIzwtN33DttQ+Ri/jIh7B+9ZCDnvqMG6d/GXnZqdTOhVwUmHgvkV64zTDZ84ngdkfkv5x50OkjDrOmZvLXHOi+H4QOPSPW2V/7k1jEwnyOkFek2R+9ZGvKwQngtaZP1mS1TNXeo6Qoo3F12o+vzmjHZdKDKk0qcNCqIexMgPFY7jo/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzYzV3sFYsSwUFtqpBZnQ7fTbGLW8pVtP/4NJ2ct6Xc=;
 b=Cbca0kS0yW1C3GvOzIC+SMxyTkRXghsVEDYJbcZ4p/yDAOvv21Gs+0sk3kElqVTJ2/+Q/Z4UMyDJFt07dBi8qX58qoZF0eCjUW/nMzbL3tdfpBbXPQ1Qx9iiRHUErwt8eE0tH1v3Q4CNWmzjSlO1uE1ULmnmy8niNcb+FBHtsQluaAUzoyYZE1yw5D3TPg/6VjMsZuFncBIsS8t0IK8FgX0V3P8OIsVH6pQlU/lGIri5V7numqNUEiKl5dNAzdE0K3oirT6UNiUQ/SXdGekML9sLPs85DWelCRqE+w1f5zmVdzpddcw135sqaG6tD3z7eIx5PjuptV8bOuK4QbQI9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzYzV3sFYsSwUFtqpBZnQ7fTbGLW8pVtP/4NJ2ct6Xc=;
 b=GmZrG0xry1AGxra3qyA+VA8UMJiO6SyF0VVN157Y6uOY/rgnjJNTdoRVw/L3DSf2OdNR1+b35O93rlfEgHR7QLZvNDiIYiqIltoZPDq4QsDUOIDMENJ8WNdwdphHR2U1GnYMAt2dvuNQSO5hUGcWmL9CO0F+/V+WaaPsQ3pwMRifGVb+oeI/NqM/4ibfqySjWN674txYQ/9XqnSm4Z1CtlD3cPquVx6X5B4MtJ1ycnkGHVhFQy0PSOO47oqGMKJGMGSueMdMX8REq/Id0eoBqUgKFjhr8xZXMRfAUQVfHSvWfcJs91qIK7DIIH4SNLPejWmtXj7VGOOXnAO5vLOnag==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BYAPR12MB3608.namprd12.prod.outlook.com (2603:10b6:a03:de::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Tue, 26 Jul
 2022 15:56:32 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 15:56:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYjU+OpP/4aLhN20eCCMO4rbOEoq1qEloggAn4zwCAAKXGEIAD0JkAgAJ/vUCAAK5SAIAAADPwgAALqACAFTnxEA==
Date:   Tue, 26 Jul 2022 15:56:32 +0000
Message-ID: <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
In-Reply-To: <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb9fd284-f31f-40a8-2900-08da6f1f6916
x-ms-traffictypediagnostic: BYAPR12MB3608:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gIrUCSjMh8Rb/9Lm4q0CqNovJQ5w0s24bJhfrkEPsovNlznosy9hyKeANHp+gpZb8JuqNw1mw/ZEDTNyqVciDVvXJm1N01Hz44sYZtiDdR12eWLcXA3dLcBG6bIZw/rcuIz9XjiXJmttcJzbgiBXQ3Fx1XNOWWMIH9KQYpizs6JItV9Ftg8Rr3S1wye9A1yYors+aY9z0RuxcPxrqmvpXP7iQkAg+aeaKvvfvEKCXHNvtxmGxRjFurX7nuNAYIyd/zcFOzJeKQbTjwjm+RodZJXPAmVQ0ualYnznAH5PDzAlvuZgr5b2c0ChDYjXwarKIYi4++CBk/zRJb4LwcmC9iOA2r4NezC8cVEq0zA7xE51Xu+fqlR08a/9MB0RIbiooe96vr2oocs9rOJsxtcxhM+8LDmU7t7TPUKS8vT0sNctXCtni9qIGvxLbPgS9ukqZo5wkECja9wxdAAWeExQXSh9yWrodcMQ/gzmEbguBth0lyPz9R7ThDJbFaif54TOzAr0sPKPOZJGx+x4FNBV1C9HlkAk1cmJKy43Q/iNli5BJg6PNiBURx243Bx2WaK2NsKM26MmNPJ8pc3NmMp3VnOz5rR3yzeR5iucY1CjxVXf6uszIPEswRI5o0XteaCaTZH1FQlYIewWVmv4pBfqjazNoU5kNirMu7chvhtuGifvkOx4lT9K7Nys7Y3Hoxpys8LOGPWBetlTy5Iju3VRIiEewhzfLq+kpuqs4FGr8mtIT0SayO2ykxaRfPWV5xFvEMbXD27pA2s92m63+AFiQoDknM+t9mbGJ0pL9sSBU9J6b6hy3wXXGtjGW7N2tHXx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(8936002)(52536014)(38100700002)(71200400001)(83380400001)(86362001)(5660300002)(41300700001)(33656002)(186003)(478600001)(110136005)(122000001)(66556008)(8676002)(66446008)(4744005)(66476007)(66946007)(64756008)(4326008)(54906003)(55016003)(38070700005)(6506007)(9686003)(26005)(316002)(7696005)(2906002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVFGS0hlaTZuUDltNTRjT3VoOUZSb3BxVE45dFBjOVBGRFRKVUdGeUlHQkNB?=
 =?utf-8?B?T2xCT0x3MmFlYWtDcm8yTDQ4eVBjcGIxV1dUeUY0NVRieUdvdWpIM1lhNmVv?=
 =?utf-8?B?TUE1T2ZYWXFHRlF4VTZqVVA3QituSnQxeFRKWVFiY05oSE12Y2ZPZHZVbUli?=
 =?utf-8?B?Tkszd1Q0RmtvWFEydUJBdjZTcnVHQjRFclE0NTdRNnNrTFJPY3h6R2VYUkp1?=
 =?utf-8?B?TG5hRDRyU1lnL2ltL2Z6RkRzR1VsSXZJOURmdEpUTlloQm9nR3dzeU5vbDZS?=
 =?utf-8?B?OFNQbm1Yd1d4U1pvOHAyU2pJMU5DU2l5WHlNTmx5VnN1clBFMC9zYWtQc3Bq?=
 =?utf-8?B?ZE1nK01lUkdUbU1lRFUwNlpGYVViZFlsSi9nTXB4QVJaQTBSQmdnMlBOUzBh?=
 =?utf-8?B?QWlGT1FGdlN0THNhWU1LdmVMNDBMYTNuaWFKSHFyV09sTzdJWTdWUUd1ck4v?=
 =?utf-8?B?UXpRaUhndUpJSjNFMEdadDBtU2FtQ00yblhEZEg4NXEwNSs4Zk94YmhBbFMv?=
 =?utf-8?B?bTJGRXVSOTF2VXErOGYwN205TEd5VzhZb2xiaGtFMkVVeDRPUHpHaXNDSGk4?=
 =?utf-8?B?OEVOY3VINDZZNTdBZGJtbWE2akN0MVJCWEVrdm1mY1Z5VW5JNXNlUEZUNlAz?=
 =?utf-8?B?Z0RubGZUZnhod2F6Q3FwYzFDQWd3S0NER1JZcktVT1pSU3ZkdmJGZ2czZnkw?=
 =?utf-8?B?VFZUYVBWejFkMUxNN1ptSDk5Qi9GbUM0anpPeTdhYVhxT3UwRGJRbk0xeXZk?=
 =?utf-8?B?U2ljR0hYcDBMT0RFR2d4MXVyeFgyazBXQVBqRVVmKzdHU1pTM2J5YjVhell1?=
 =?utf-8?B?UVdKSUlDY2hobm04ZDc0emJ1U1EvUjhEeURXQTVOcmk3dmhqTmtsNjZLZmpx?=
 =?utf-8?B?R2hIajV1QUFoOXZnQUNGNmtVVE9IOGs3TDd1OG8zMFBnSnl2NHZWdW1uYWtS?=
 =?utf-8?B?bEtQS0w2L21Jb09tTFNBYU9TTWtDYzk3WVdmcWh0c2V5MnpaTythRTdvbVNB?=
 =?utf-8?B?VmNPRjZZS0E4RWkxRmV0Tmd1SXZXS09WZ2RjdHlCakpJUUxjUU9NNElFaWdO?=
 =?utf-8?B?U1Z6djE1QjlDTU9HR2x0MlRBWmJLVlVMVDhWbW8xM3J4T2VWSytKdHNuOHMw?=
 =?utf-8?B?Nmt1YjVOTjNTL1A1ZFQ5NmNaTk5aQndqSUFwOVhxY1I4czhyRWFCcU5ULzdT?=
 =?utf-8?B?WGdhWTVXNlpaVi9mT0dYOUZjYnAxeWxnT1ozN1phVVE1VXVPVmVlcnVwMjRC?=
 =?utf-8?B?VjE5aENWbndaQkp3UGpUTHFlMkVvS3hyRlpWNzNjb2w1QzJ4UlFNNFBTdDVz?=
 =?utf-8?B?ODhjQ0tjMmFScSsvK3krQ3FQb3RoZlZnK1hjSXd1emQvVy9GcXRNcWQ5RWZk?=
 =?utf-8?B?alhlMElaM2FtM1RUUXhteElvR0tqMVI1eElLWmlYSlRyZ21WMXE2R2E5TUZm?=
 =?utf-8?B?Z0NxZEs0Um9RdUlHNUU5aFAvTVpqUWJCNjJHTW9QVnM2RHVYZGgrVFZubXNx?=
 =?utf-8?B?T21EdWZ6UWlxQXIxTllwUDhRZ0JIN2h2WS9PREcwS21NTEpVbmhHWTBWRjNG?=
 =?utf-8?B?RGVuSlpwRnpzZDNJaFAvNlZxMHpYSFRtK0tTd0s5VXkzMTVocEtKYVc1NW1B?=
 =?utf-8?B?azNaSWlRenN2OTJ0c1lPb2syY2owcG9Ydkx3cXNhOXIwVDRQTlJ0eFM5ODk4?=
 =?utf-8?B?ZU10YjJqWUZJVkFPaVJzR3QyWGN3NlVBV2FkNzZOMGJ6eFF0a1FqelhxUGtF?=
 =?utf-8?B?TWZKL1VqTDFDYkpQdktpM0hnSEFIMXAxL3FpVHV1MmUvRmg0am5vamNzRU8x?=
 =?utf-8?B?dXpNdXlGMG9PSm5yZ1FyWUs4alI4bkpSL2phYWtJYWdmOVFMYXY4b2w1dUJo?=
 =?utf-8?B?NnQ4Nm5WSklwMDhPMUtmZ3lsRmEzcExid0ZaTmVHUTdpWFVmdHZuTXB5amVp?=
 =?utf-8?B?QmFsOVhLczlUaFNyd0gzOFRDY0FKKytnbTRDS2hJTmNTRU9pMEhhL3d4YThZ?=
 =?utf-8?B?dzdFMXBYWUQyU1FNRE01RWlVZUVZSS9WenFsRld3TWJwWTNFZFZQRlN1SE9p?=
 =?utf-8?B?NlBmQVZxMTlOMjZtWlIzenJiQ01BZ3RmYitrK1d1Qmh4OUc3SEsxWE9LYmRp?=
 =?utf-8?Q?TIcQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9fd284-f31f-40a8-2900-08da6f1f6916
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 15:56:32.3763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wSu6DT82WQilbF/Dkuz+VLG8J0BFvuUN2hiZW8qZQ70aOQEbZ8DNWf/d9fX50Wi+XLxMGG1zycSPEJk9ZRWmiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3608
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
IFR1ZXNkYXksIEp1bHkgMTIsIDIwMjIgMTE6NDYgUE0NCj4gPiBXaGVuIHRoZSB1c2VyIHNwYWNl
IHdoaWNoIGludm9rZXMgbmV0bGluayBjb21tYW5kcywgZGV0ZWN0cyB0aGF0IF9NUQ0KPiBpcyBu
b3Qgc3VwcG9ydGVkLCBoZW5jZSBpdCB0YWtlcyBtYXhfcXVldWVfcGFpciA9IDEgYnkgaXRzZWxm
Lg0KPiBJIHRoaW5rIHRoZSBrZXJuZWwgbW9kdWxlIGhhdmUgYWxsIG5lY2Vzc2FyeSBpbmZvcm1h
dGlvbiBhbmQgaXQgaXMgdGhlIG9ubHkNCj4gb25lIHdoaWNoIGhhdmUgcHJlY2lzZSBpbmZvcm1h
dGlvbiBvZiBhIGRldmljZSwgc28gaXQgc2hvdWxkIGFuc3dlciBwcmVjaXNlbHkNCj4gdGhhbiBs
ZXQgdGhlIHVzZXIgc3BhY2UgZ3Vlc3MuIFRoZSBrZXJuZWwgbW9kdWxlIHNob3VsZCBiZSByZWxp
YWJsZSB0aGFuIHN0YXkNCj4gc2lsZW50LCBsZWF2ZSB0aGUgcXVlc3Rpb24gdG8gdGhlIHVzZXIg
c3BhY2UgdG9vbC4NCktlcm5lbCBpcyByZWxpYWJsZS4gSXQgZG9lc27igJl0IGV4cG9zZSBhIGNv
bmZpZyBzcGFjZSBmaWVsZCBpZiB0aGUgZmllbGQgZG9lc27igJl0IGV4aXN0IHJlZ2FyZGxlc3Mg
b2YgZmllbGQgc2hvdWxkIGhhdmUgZGVmYXVsdCBvciBubyBkZWZhdWx0Lg0KVXNlciBzcGFjZSBz
aG91bGQgbm90IGd1ZXNzIGVpdGhlci4gVXNlciBzcGFjZSBnZXRzIHRvIHNlZSBpZiBfTVEgcHJl
c2VudC9ub3QgcHJlc2VudC4gSWYgX01RIHByZXNlbnQgdGhhbiBnZXQgcmVsaWFibGUgZGF0YSBm
cm9tIGtlcm5lbC4NCklmIF9NUSBub3QgcHJlc2VudCwgaXQgbWVhbnMgdGhpcyBkZXZpY2UgaGFz
IG9uZSBWUSBwYWlyLg0K
