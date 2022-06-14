Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B391D54BA81
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 21:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiFNT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 15:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiFNT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 15:26:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBF9192B2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 12:26:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqVI2H+T1aTRhl6gtGmmLcXZHnd7aWT1BpeoEe4rZmG/gF9nkwVaYHkbH7QkS8RRbmjKKsvSG/2Cq3Js3vIYYgzVPOCoyrFUXJK1UjL5Z3x0/eICmomlw3RU6tWpsax99zON8S31hWDdiw4I4Dx7BSwiE9ZvpIeBC+lgPUUrcbdY4yY88SNCtnm4Ww9D1kwuHsVd25HzAwop+9B8MNbUvPKVHs6dmlnVQR1LjUrqnOBMKWXceQbuugq1UudNAzLG8H3g6K2I2XXDxkEq5+JmAU/7Es4DnXUPz/VJ55dCenxWbnRq1H9Yq9X0fVB9S0368h/q7h9BQ0ZjuLBlzMsTlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=By2o6MqVglrsiAh9BQiu3lVSE/u5YkpJvA2jKKusqcI=;
 b=mE5H8zk+WIuNT5BhUJK1jonbumwyw0L9Kee8fwsFXllEp6MnrnVW0wJf5XcmG174zQT7O+Rgtmayh+dZ5AFnrRLIKcRqi+Cp7dofV77Q0SQQw8k7JxcPE0641Fac3+HO+MC6Duf6C+TGy0sUI6dmxgJ7WMcF9Pi4kADcercKm681BtEB+eEvlAq9lhsOJaLK2MSrYwn0nMDPnApqqwCCH3mtffq6LWUyhJF4mzhtgHHhyffPrUSNxB3Qrr6xhFb/aK9UUcxxgQZSyTEjhusGrAlMcdPQCqER7cwBrYQPB4l8axe3erbAwzSXR7/Eq0PxOSyPqa43uwdfDrSI0xB61w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=By2o6MqVglrsiAh9BQiu3lVSE/u5YkpJvA2jKKusqcI=;
 b=IvcL1XKzaLPoenbeKlm+HN+9JyOtSOFTn6eJ+od2gS2KMw76qyLcLtIvHHrfZFmUtdFvkP/nMQr+B3kKQhKQOXmvTbH0LN+Ki/OWl0u67u3w1sLg4a6j0SoDsJyoP2SZCKohttvckWZRa+5PXggxfbeZ9vIx0hbEBB8OGMlIHvC7MnLU24nlzI+SUDMDD/ZEi5G7t0LW+Gw4LQSiTHX8xreBX8IMeny4uL+0uhjXEg/zyJJM6IMyonKsFqIG20GzyoFT7CIuApowijKqmeBr5M56FpGw8fES3ZluRfmxWbHQeLlc/67y0yvIEWYpqkqiP35QgisAbtASsJckVvUrmw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY4PR12MB1702.namprd12.prod.outlook.com (2603:10b6:903:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Tue, 14 Jun
 2022 19:26:10 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e%3]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 19:26:10 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYfw/TaqeKf3NIjk2lTwhHry2CmK1NyyuQgABk9wCAARG7oA==
Date:   Tue, 14 Jun 2022 19:26:10 +0000
Message-ID: <PH0PR12MB548194393655B8638A2FA4B2DCAA9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
 <20220613101652.195216-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481D2A01569549281D01411DCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <05c09bdd-278c-af18-e087-d74a511a4305@intel.com>
In-Reply-To: <05c09bdd-278c-af18-e087-d74a511a4305@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a30f6002-3145-4aee-9384-08da4e3bbcee
x-ms-traffictypediagnostic: CY4PR12MB1702:EE_
x-microsoft-antispam-prvs: <CY4PR12MB170276942A4047FEB10137E9DCAA9@CY4PR12MB1702.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJJS0AL757/gJVssPh5JaMqd9Qaa7HRb7J+8otgRA0czI0cImBgNLn3m9ZmA6ivsZeFRCTB0JqoPdxH7cIsvFDlUMtDDY4INg9Ioo0qK3cr039OXPkNvQDU1RiEabuJ9Q3TiuCpoLGJ5aglW5+2mAu8/w08JDo9Oe6sLa6mcOSYZSFP8mqhr5wHYsdRSnweOjzgezob5OTPrUc0CVJ5tQSQBko7DjqgzFiseepVfD79VFA5IyRzh5/s/VRBMAhc9iLEsSDmfO/eIx2BXUBiyi4yAf0UCqY28/X70zCMpYhFt8ZSkSv4zcdfzXa9NI55ipim/Ch+mkF5G502uzqL7/P9gIASOGKOAa/7NzEf1pSzMM5szepQ39ovIIFob9ZTz08LGXE22gIeMr5AMu4njygWvpJT8kttaN2N7vY+TgwqlB8zveWvJNK1h32mHsKSoINFR0ITxn2eBWlIrziN34QHgR7AhD4ftvQtwUQNgLOtgZAbzS0EDmLbeeZRrX2vGhOzRfEjbEPPWTCX9RVIJWAdvSQAwV44npZq+eCOZnXHA1bsq9hzzUWXiVbZN3FlF5CU4dK+RLNaMxKOhPfbgtYesoIFvewukyRHVf8DkxhqM/ERjwYTW1cSWyWW5PoQoPY8vxqhJTNSLAigJhh5Kb1IslZ7uBd76mmxzzpRTTus4wquPTDJ4ab3zECKqKd6wFOI2tQzlVIFgofFBvWipgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(9686003)(26005)(186003)(54906003)(38100700002)(110136005)(76116006)(38070700005)(53546011)(5660300002)(66476007)(2906002)(86362001)(66556008)(64756008)(8676002)(66446008)(66946007)(316002)(508600001)(8936002)(52536014)(83380400001)(122000001)(55016003)(71200400001)(33656002)(7696005)(6506007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkR3NEE3YlZVVjF4TVJCZUZZRFlqSy9DeGdMVEx5RktjTkd0Z2hydmJxb0dC?=
 =?utf-8?B?K3g1aFNyTHJhbUVBZkE2UW5XdTlTNkt6WE94WnFhVytKVUgxV0N2S2ozTjhS?=
 =?utf-8?B?c25oTEhpczFlVVp0aVRCZVJVdUVhS3h4THRZUXczcEFwdldYa2JwOU9wSDF3?=
 =?utf-8?B?VDRneVlqMUJhQ1k4YUsrTDg2ZkRtTy9kcnNDZkZvSXRNY0xtUDdyRWpURUUv?=
 =?utf-8?B?QkpROEdKbExTTW9uR2RPQTNGRUh3TGt1OTF6NXQ0Tzl3eFB6THVHTlpyY2NN?=
 =?utf-8?B?M3pDYVU5WWRPMWFwWG5sTG0vWVFtRWcrQ3MxUmdKK1Vid28rL3RJZ0dKcEFk?=
 =?utf-8?B?YUJ4TGJWY3BqYXMwSlhkUGlLREFiejFVdndhcE5KbHN1ejNrbk5jQkxHZjVx?=
 =?utf-8?B?bk9JM0FTUmNqN3FUb3dUVzluTU1NY3ZyZ3gveXNYbC9hMzVqZnZoUzhya3pU?=
 =?utf-8?B?aFVxV0Y5UXA5WDFhbEN5VTR3d2k2ZktwaGlQZG5PM2NwU2cwMFVtRFVDTmxm?=
 =?utf-8?B?V2xpUXZkdFFmbFdjbVlVUWZqZU54bThJS29ZeitqTTVUZVZoZ0dydkEzeEdK?=
 =?utf-8?B?NjVMUWM2dEJLVDNaQXl3bUVPNWdmd0x0QlB3V294eVpiWGMwYVZJbkdocFo1?=
 =?utf-8?B?OEZNMnlodUhWN2VRRjh2MGhrY0hZYldCQlcyUVNuSFNyTVZ5VlRKNXY0eWNq?=
 =?utf-8?B?Yk04NUV0Tng3R1JoMlg4RUdqdy9DTWxYRFZXK1QrRGFTY0FYeFRSV1cvUGp0?=
 =?utf-8?B?MCs0NFJoallZUTZVT0UrL25WamI2eE9WSnQyTXNpeWs2QmdzLzNzN2lBSnlj?=
 =?utf-8?B?Q3lkY1ptZGdlZGMvNVRCeFpFbHA2Qm9KY1NwYnM4ZEFFeGdiaDdWbjN1ckRT?=
 =?utf-8?B?VmgreGt4MWRXbnB1SnNrMnJrd3ZUZW9ZdGJNSHpXZzNBV0xBOXpJemlqMDkw?=
 =?utf-8?B?Wnh2a1dPeXdOK0ljNGlBV2kyd1dyUG0wR1JDSWlWcU1MMGUrYlU5WTIzY2lS?=
 =?utf-8?B?bHhjeXpsTHFFYlJBTXFNejNOUnJsdXljcXgyYTAwNjkxU2hPSjhRcGRQaVBK?=
 =?utf-8?B?cCt6d3RBeG1zcDlwZmlXNUQ1cTlVb05NVHhUeWtaOWM1ZE5HQTA2eG5hQ0JM?=
 =?utf-8?B?TXA2ZjdxSzhVRWd1dFpRWmNERm9tbHQvZDBwMTA1ZTVOR2NZN2RZYnExYy8w?=
 =?utf-8?B?b3Rkb2lXQXdGUWJ3S3ovVmh6M2llZmNMcit1TTlCU0hjYmNBaHRWRitHWFRq?=
 =?utf-8?B?OS9vZFRpVTN5SmU4ZlVBb2NyL2VhMWlTV0V5UlBNQmJFeWR1MnNHSWVCdjFN?=
 =?utf-8?B?TjJIRjdpU3NUT1YxMjRvazAwUzN1NmtEMk5SZHpBellTMDU4a0pRZ00ya3NY?=
 =?utf-8?B?NS9FcHowYjhhK0lhSldQbCszM3lIRTlUQjZqbHIvUEpyQ1hHejF5SnhTNFVR?=
 =?utf-8?B?Sy9TMmpZa2xIcndEUWlud0RIOVZQc2pwR2YvRlRyaUtPRlVQNWFvWTUreG9E?=
 =?utf-8?B?aWhTN0Yxdit3SlZ6Y2tiT3oveHBIdmtTNloxNXdjdlYwSUdFYzYrVVZrdUo2?=
 =?utf-8?B?SWlkRW9SNURaeWR6UlBRMy9iYlFCS0wveERHZjg4WWFZMktOU3Jqb1R4TERL?=
 =?utf-8?B?OVgrUmZVRnJ4SlFNZDVKQVd6UEZmNWUxTjd4cWtzUFZwTFNFMkxXazVVMkNx?=
 =?utf-8?B?NjhtUHpBb3RnM0puR0M0ZWNlUnFla2p5NkF2QWtpQ01VS3g3SWs4OGc3Ymxr?=
 =?utf-8?B?SFA3cTVuTndScHRPcy9DeGRxdGUzVjh0Wmh3d2NDc2xLTGMrMGt1S1pRQlVr?=
 =?utf-8?B?RzllQmpNajYzWkZ0Z1FsSktqSkI5WC9VdDRaaEFObzRYZldjOStObHR2TllP?=
 =?utf-8?B?L0pkSko5UlVIcWxBSEp4SVFGT0NSR1A4ZHZOaVpvb3ZCcUttT3BHVnRxY21q?=
 =?utf-8?B?aUhwdVZMNENNcGgveWhXNElYNTFpV0tGTURTQndHcGVtSGNpWEtXRmRVdzIr?=
 =?utf-8?B?RnhsR3VMRnFOR2p4ck16K1QveHpDS0Zpb0xiVzdPb3Zqa3Y2SG1WWlJaaGhP?=
 =?utf-8?B?aUM4RjVsSGIvT2l2MW80bVdjeWRxSnFORVhnZXRiQ0hOeXdNMHhRSStSZURI?=
 =?utf-8?B?V3M3QmlLbStCa2tNY2VBQ0pFcjBLbzZLL3F4ZmR6WlVjcE15T3MvdzRvZnpN?=
 =?utf-8?B?WC9DcmMrSWVwSGc1RExwbi95L1lWcG9CZHcyRlEvUHd3TWlsTWIxWW1ySldw?=
 =?utf-8?B?U2xTdzdNQU5Lb0ZPeVdJd1JuUGRpc2QvTmhleVRtR2VseVFUaW44emx4Nmxn?=
 =?utf-8?Q?PPz8eJrZZNkakJgbSf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30f6002-3145-4aee-9384-08da4e3bbcee
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 19:26:10.5822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3KKm56760B9iEY2XU5nj6X+AwUvuAKdbrRxiTki5+6wb6Sgqzbo307NNOI3ca6oMt077tlmnTuCZwZW/hWlxMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1702
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWmh1LCBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gU2Vu
dDogTW9uZGF5LCBKdW5lIDEzLCAyMDIyIDEwOjMzIFBNDQo+IA0KPiANCj4gT24gNi8xNC8yMDIy
IDQ6MzYgQU0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBaaHUgTGluZ3No
YW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+IFNlbnQ6IE1vbmRheSwgSnVuZSAxMywg
MjAyMiA2OjE3IEFNDQo+ID4+IFRvOiBqYXNvd2FuZ0ByZWRoYXQuY29tOyBtc3RAcmVkaGF0LmNv
bQ0KPiA+PiBDYzogdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7DQo+
ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNv
bT47DQo+ID4+IHhpZXlvbmdqaUBieXRlZGFuY2UuY29tOyBnYXV0YW0uZGF3YXJAYW1kLmNvbTsg
Wmh1IExpbmdzaGFuDQo+ID4+IDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPg0KPiA+PiBTdWJqZWN0
OiBbUEFUQ0ggVjIgNS82XSB2RFBBOiBhbnN3ZXIgbnVtIG9mIHF1ZXVlIHBhaXJzID0gMSB0bw0K
PiA+PiB1c2Vyc3BhY2Ugd2hlbiBWSVJUSU9fTkVUX0ZfTVEgPT0gMA0KPiA+Pg0KPiA+PiBJZiBW
SVJUSU9fTkVUX0ZfTVEgPT0gMCwgdGhlIHZpcnRpbyBkZXZpY2Ugc2hvdWxkIGhhdmUgb25lIHF1
ZXVlDQo+ID4+IHBhaXIsIHNvIHdoZW4gdXNlcnNwYWNlIHF1ZXJ5aW5nIHF1ZXVlIHBhaXIgbnVt
YmVycywgaXQgc2hvdWxkIHJldHVybg0KPiA+PiBtcT0xIHRoYW4gemVyby4NCj4gPj4NCj4gPj4g
RnVuY3Rpb24gdmRwYV9kZXZfbmV0X2NvbmZpZ19maWxsKCkgZmlsbHMgdGhlIGF0dHJpYnV0aW9u
cyBvZiB0aGUNCj4gPj4gdkRQQSBkZXZpY2VzLCBzbyB0aGF0IGl0IHNob3VsZCBjYWxsIHZkcGFf
ZGV2X25ldF9tcV9jb25maWdfZmlsbCgpIHNvDQo+ID4+IHRoZSBwYXJhbWV0ZXIgaW4gdmRwYV9k
ZXZfbmV0X21xX2NvbmZpZ19maWxsKCkgc2hvdWxkIGJlDQo+ID4+IGZlYXR1cmVfZGV2aWNlIHRo
YW4gZmVhdHVyZV9kcml2ZXIgZm9yIHRoZSB2RFBBIGRldmljZXMgdGhlbXNlbHZlcw0KPiA+Pg0K
PiA+PiBCZWZvcmUgdGhpcyBjaGFuZ2UsIHdoZW4gTVEgPSAwLCBpcHJvdXRlMiBvdXRwdXQ6DQo+
ID4+ICR2ZHBhIGRldiBjb25maWcgc2hvdyB2ZHBhMA0KPiA+PiB2ZHBhMDogbWFjIDAwOmU4OmNh
OjExOmJlOjA1IGxpbmsgdXAgbGlua19hbm5vdW5jZSBmYWxzZSBtYXhfdnFfcGFpcnMNCj4gPj4g
MCBtdHUgMTUwMA0KPiA+Pg0KPiA+IE1heF92cV9wYWlycyBzaG91bGQgbm90IGJlIHByaW50ZWQg
d2hlbiBfTVEgZmVhdHVyZSBpcyBub3QgbmVnb3RpYXRlZC4NCj4gPiBFeGlzdGluZyBjb2RlIHRo
YXQgcmV0dXJucyAwIGlzIGNvcnJlY3QgZm9sbG93aW5nIHRoaXMgbGluZSBvZiB0aGUgc3BlYy4N
Cj4gPg0KPiA+ICIgVGhlIGZvbGxvd2luZyBkcml2ZXItcmVhZC1vbmx5IGZpZWxkLCBtYXhfdmly
dHF1ZXVlX3BhaXJzIG9ubHkNCj4gPiBleGlzdHMgaWYgVklSVElPX05FVF9GX01RIG9yIFZJUlRJ
T18tIE5FVF9GX1JTUyBpcyBzZXQuIg0KPiA+IFRoZSBmaWVsZCBkb2Vzbid0IGV4aXN0IHdoZW4g
X01RIGlzIG5vdCB0aGVyZS4gSGVuY2UsIGl0IHNob3VsZCBub3QgYmUNCj4gcHJpbnRlZC4NCj4g
PiBJcyBfUlNTIG9mZmVyZWQgYW5kIGlzIHRoYXQgd2h5IHlvdSBzZWUgaXQ/DQo+ID4NCj4gPiBJ
ZiBub3QgYSBmaXggaW4gdGhlIGlwcm91dGUyL3ZkcGEgc2hvdWxkIGJlIGRvbmUuDQo+IElNSE8s
IFRoZSBzcGVjIHNheXM6DQo+IFRoZSBmb2xsb3dpbmcgZHJpdmVyLXJlYWQtb25seSBmaWVsZCwg
bWF4X3ZpcnRxdWV1ZV9wYWlycyBvbmx5IGV4aXN0cyBpZg0KPiBWSVJUSU9fTkVUX0ZfTVEgaXMg
KnNldCoNCj4gDQo+IFRoZSBzcGVjIGRvZXNuJ3Qgc2F5Og0KPiBUaGUgZm9sbG93aW5nIGRyaXZl
ci1yZWFkLW9ubHkgZmllbGQsIG1heF92aXJ0cXVldWVfcGFpcnMgb25seSBleGlzdHMgaWYNCj4g
VklSVElPX05FVF9GX01RIGlzICpuZWdvdGlhdGVkKg0KPiANCj4gSWYgYSBkZXZpY2UgaXMgY2Fw
YWJsZSBvZiBvZiBtdWx0aS1xdWV1ZXMsIHRoaXMgY2FwYWJpbGl0eSBkb2VzIG5vdCBkZXBlbmQg
b24NCj4gdGhlIGRyaXZlci4gV2UgYXJlIHF1ZXJ5aW5nIHRoZSBkZXZpY2UsIG5vdCB0aGUgZHJp
dmVyLg0KPiANCj4gSWYgdGhlcmUgaXMgTVEsIHdlIHByaW50IHRoZSBvbmJvYXJkIGltcGxlbWVu
dGVkIHRvdGFsIG51bWJlciBvZiB0aGUNCj4gcXVldWUgcGFpcnMuDQo+IElmIE1RIGlzIG5vdCBz
ZXQsIHdlIHdpbGwgbm90IHJlYWQgdGhlIG9uYm9hcmQgbXEgbnVtYmVyLCBiZWNhdXNlIGl0IGlz
IG5vdA0KPiB0aGVyZSBhcyB0aGUgc3BlYyBzYXlzLg0KPiBCdXQgdGhlcmUgc2hvdWxkIGJlIGF0
IGxlYXN0IG9uZSBxdWV1ZSBwYWlyIHRvIGJlIGEgZnVuY3Rpb25hbCB2aXJ0aW8tbmV0LCBzbyAx
DQo+IGlzIHByaW50ZWQuDQoNClRoZSBjb21taXQgWzFdIGlzIHN1cHBvc2VkIHRvIHNob3cgdGhl
IGRldmljZSBjb25maWd1cmF0aW9uIGxheW91dCBhcyB3aGF0IGRldmljZSBfb2ZmZXJzXyBhcyBt
ZW50aW9uZWQgaW4gdGhlIHN1YmplY3QgbGluZSBvZiB0aGUgY29tbWl0IFsxXSB2ZXJ5IGNsZWFy
bHkuDQoNClRoZSBjb21taXQgWzJdIGNoYW5nZWQgdGhlIG9yaWdpbmFsIGludGVudCBvZiBjb21t
aXQgWzFdIGV2ZW4gdGhvdWdoIGNvbW1pdCBbMl0gbWVudGlvbmVkICJmaXhlcyIgaW4gdGhlIHBh
dGNoIHdpdGhvdXQgYW55IGZpeGVzIHRhZy4gOigNCmNvbW1pdCBbMl0gd2FzIGJ1Zy4NCg0KVGhl
IHJpZ2h0IGZpeCB0byByZXN0b3JlIFsxXSBpcyB0byByZXBvcnQgdGhlIGRldmljZSBmZWF0dXJl
cyBvZmZlcmVkIHVzaW5nIGdldF9kZXZpY2VfZmVhdHVyZXMoKSBjYWxsYmFjayBpbnN0ZWFkIG9m
IGdldF9kcml2ZXJzX2ZlYXR1cmVzKCkuDQoNCk9uY2UgYWJvdmUgZml4IGlzIGFwcGxpZWQsDQp3
aGVuIF9NUSBpcyBub3Qgb2ZmZXJlZCwgbWF4X3F1ZXVlX3BhaXJzIHNob3VsZCBiZSB0cmVhdGVk
IGFzIDEgYnkgdGhlIGRyaXZlci4NCldlIGRvIG5vdCBoYXZlIGEgY29uY2VwdCBvZiBtYW5hZ2Vt
ZW50IGRyaXZlciB5ZXQgaW4gdGhlIHNwZWNpZmljYXRpb24uDQpTbyB3aGVuIF9NUSBpcyBub3Qg
b2ZmZXJlZCBieSB0aGUgZGV2aWNlLCBlaXRoZXIga2VybmVsIGRyaXZlciBjYW4gcmV0dXJuIG1h
eF9xdWV1ZV9wYWlycyA9IDEsIG9yIHRoZSB1c2VyIHNwYWNlIGNhbGxlciBjYW4gc2VlIHRoYXQg
X01RIGlzIG5vdCBvZmZlcmVkIGJ5IHRoZSBkZXZpY2UgaGVuY2UgdHJlYXQgbWF4X3ZxX3BhaXJz
ID0gMS4NCihMaWtlIGhvdyBpdCBpcyBkZXNjcmliZWQgaW4gdGhlIHNwZWMgYXMgLSAiIElkZW50
aWZ5IGFuZCBpbml0aWFsaXplIHRoZSByZWNlaXZlIGFuZCB0cmFuc21pc3Npb24gdmlydHF1ZXVl
cywgdXAgdG8gTiBvZiBlYWNoIGtpbmQuIElmIFZJUlRJT19ORVRfRl9NUSBmZWF0dXJlIGJpdCBp
cyBuZWdvdGlhdGVkLCBOPW1heF92aXJ0cXVldWVfcGFpcnMsIG90aGVyd2lzZSBpZGVudGlmeSBO
PTEuIg0KDQpTbyBsZXQgb3JjaGVzdHJhdGlvbiBsYXllciBjYW4gY2VydGFpbmx5IGRlcml2ZSB0
aGlzIE4gd2hlbiBfTVEgZmVhdHVyZSBpcyBub3Qgb2ZmZXJlZCwgaW5zdGVhZCBvZiBjb21pbmcg
ZnJvbSB0aGUgdmRwYSBtYW5hZ2VtZW50IGxheWVyLg0KSSBhZ3JlZSB0aGF0IHRoaXMgZXh0cmEg
aWYoKSBjb25kaXRpb24gaW4gdGhlIHVzZXIgc3BhY2UgY2FuIGJlIGF2b2lkZWQgaWYga2VybmVs
IGFsd2F5cyBwcm92aWRlcyBpdC4NCkJ1dCBiZXR0ZXIgdG8gYXZvaWQgc3VjaCBhc3N1bXB0aW9u
IGJlY2F1c2Ugd2UgaGF2ZSBtb3JlIHN1Y2ggY29uZmlnIHNwYWNlIGF0dHJpYnV0ZXMuIGkuZS4s
IHRoZXkgZXhpc3Qgb25seSB3aGVuIGZlYXR1cmVzIGFyZSBvZmZlcmVkLg0KU28gdG8ga2VlcCBp
dCB1bmlmb3JtLCBJIHByZWZlciB3ZSBhdm9pZCB0aGUgZXhjZXB0aW9uIGZvciBtYXhfdmlydHF1
ZXVlX3BhaXJzLg0KDQpQbGVhc2Ugc3VibWl0IHRoZSBmaXggZm9yIFsyXSB0byBjYWxsIGdldF9k
ZXZpY2VfZmVhdHVyZXMoKSBmb3IgcHVycG9zZSBvZiByZXR1cm5pbmcgY29uZmlnIHNwYWNlLg0K
Q29udGludWUgdG8gdXNlIGdldF9kcml2ZXJfZmVhdHVyZXMoKSB0byBzaG93IFZEUEFfQVRUUl9E
RVZfTkVHT1RJQVRFRF9GRUFUVVJFUy4NCg0KSSBkaWRu4oCZdCByZXZpZXcgdGhlc2UgcGF0Y2hl
cyBhbmQgaXQgc2xpcHBlZCB0aHJvdWdoIHRoZSBjcmFja3MuIDooDQoNClsxXSBhNjQ5MTdiYzJl
OWIgKCJ2ZHBhOiBJbnRyb2R1Y2UgcXVlcnkgb2YgZGV2aWNlIGNvbmZpZyBsYXlvdXQiKQ0KWzJd
IGE2NDkxN2JjMmU5ICgidmRwYTogUHJvdmlkZSBpbnRlcmZhY2UgdG8gcmVhZCBkcml2ZXIgZmVh
dHVyZXMiKQ0K
