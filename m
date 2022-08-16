Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B7C595351
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiHPHFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiHPHEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:04:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9BF11893E;
        Mon, 15 Aug 2022 19:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6K138kv3TNTIwQ2zA4KoxsKMZmA5OYq44r1uqu4+r7eEOjzPEpn3lTHL0KZwPsHDSHFgRpm7po9F0zMqkeW+uZXJUaI5Hyn/oPVfctx/+rVPnML/2egcCjNDPanpeANfyn0mI92shlM0XLsZdUieSgTq1uRGr+Um/nP3z3FPxrIREnds8zTm/D/8INlVWvHOcWJ+4keebwOVQinAm28rWyPBBAR0yjCManni79Bjp0sXuYFCddr+ZGTaUmrMFSxp1TQK9ZKrqGbNcKSafeGk/B1jfLd13oRegmhhlLm7XUw+jVt2T4CURg0AJgaFDsf4eL63P2Bf6BBJAKUTt6hQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOn4Ua2pQsmlujyZANFmIedivYmCJ2GsYOpSYcEDID4=;
 b=oOZNDnUs72qq1mKGO2+mQEkW6Ou99CL3tyQQbBvs1oTYUihBYwSipSax7vGJJBpZW8StZZONQLr+F9zG7N5oLCKIkuitvAlCecJJGQx0EqSLVSawf+d4EheaYkUL/Rzcke64UK01AkvaicLtWvBRXRnK816LwQAwjQ5gsNGt1Z/8RxQ+YYWrNro8rbGF3x6zL6oaBup6BRhTtYGNhCV1LZRfryxxkmYbB1waa2IwVQGqfOGPsVuEJA0Byfydhz8HhAssVuiPaIfj+aDmdZ0+0BIzamlqct1nH/sraF9SzcREfgmEul2eB7RxByN+9A9HuBra3U/RYd23dSxUl+bE2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOn4Ua2pQsmlujyZANFmIedivYmCJ2GsYOpSYcEDID4=;
 b=aX+TEPhPxJohioVZLgNwzgNOGaUwD+zdl+77niTrYWooIniWkeA4Owi2NRy6YIfPK+4+vymUE96Ml/TKqAAZP+Tw/O60B3RCfDEYPRSZNIx612CjlffPyocL/B2Zf5jIk/uLboIXRoNw3qBCLlfohtDdzy2a2Znbva/v4IjD1QlQYBKEY5T1SgFpT1q4G6ghzvqupA0/k+dwY/FipLN/EAeU+aaFGFVY8n5KSGF5GZsYcpOQUZKQuYKPfdzuW7UVrZrEFdrX8sR4GOFecRJM8AcCIyrOKpBZCR9fa3tlyDdc00Itw8v8A26yeswPORW2MKPjf/wJt9q1zJsRd1wLMA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN6PR12MB1889.namprd12.prod.outlook.com (2603:10b6:404:105::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 02:32:43 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%6]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 02:32:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Thread-Topic: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Thread-Index: AQHYsIpJtq9YpvWt2kmNOt5VAnquUK2wzXWg
Date:   Tue, 16 Aug 2022 02:32:42 +0000
Message-ID: <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
In-Reply-To: <20220815092638.504528-3-lingshan.zhu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6ef8011-dad3-4e98-055e-08da7f2f984e
x-ms-traffictypediagnostic: BN6PR12MB1889:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hiDbKZdY1zTxSUh/xBGexXOLfxsWxReBjuk2IJKZwRXbtdhRCTZ4iq4y1Mhf6tGXiNEH8D/C6w5LcZetBowE7dCgeVsd2Qhos+T793O6mbg46uXlehislkgcxRY6PwFifYtOXZqVid5gx8rccvlmq14+QsqQcOZCjxWTqUh2OwqY1LXI6IinnyWWzivxgkeLxKmGpJnYcrtBoAbx+QBs1vF4qIhE7nnwoS20o5PwxODRv5T5zG8fKBRuTIo0aOYlkoaxxreyUmF30qZHWN+scS7RRr+y7WbY+Y279qsnL/eqsZbiTsoJYlT+SipDM5tLAZ5vEnJlFqQsF1RuUeJNik9a/YN/8h6BsQ6J+B6G9MxOd+A+vxj+VTngJ3tFn7F0HpEMMavcsk1HNEJjVDpd3d6BRtgdQBYg/oYRkXMK/2dgBU/tlefEs32beyCkGvaKhyXzzf3M5qJvLWtGwkmZJD0chXbO0t195QQugxC8AezI1SXy2LtHnVhnRMDGM5RNbcklY+pe5hZeZDXr9PfUW4LcWy4MmQthDaPxvyiLZl6zW5wOM+2pmvwa0bXjXcbIWpuyG7DkwHwgb35Wfcar2g89/jiARhOuB30mumfPrKhAYsnO+9pw26Snl29qr0z0QAEyhqgXDQq3+Qh6W8S9CWa2sh7J97JW57CASiRFm84CU1ZN2fX7tp1EQbMX2O53UofEJDbrldEq6HMpLdGv/D6n51q6XWcb8988HDXuC59r+y9DnIKTXNXsJ/u2CJymK7oTVeyENrjKCKiW2moG/DTbmfnYSkPopP8/hp5orpHrlSNeEFbjRd6A5S/z1oMznuKyV05s4FMiYyWZUFbh3bnp3WWkYj0d0Ni+QsH66XQluwJx2qRljXDZBQvAgnSn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(4326008)(26005)(9686003)(2906002)(41300700001)(7696005)(52536014)(55016003)(16799955002)(8936002)(6506007)(86362001)(110136005)(966005)(54906003)(71200400001)(478600001)(33656002)(38070700005)(83380400001)(186003)(76116006)(8676002)(66946007)(66476007)(316002)(66556008)(64756008)(5660300002)(122000001)(38100700002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2x1K0ZwQ3owN25wdGc0RDBSdExvSFZNL2lFVmRyOURUMDFyUjJsV25vRk5C?=
 =?utf-8?B?SlVvUzU5NTdQWVN1OW5PbWp2R05nSXpuSWE5L3IrU1hlWlJwWjBOMkZBaTVN?=
 =?utf-8?B?U1NjdkpOVllTWnM2N0FBT2NuT3VGQnQrclVwMkNJRkxqV3l4dC9VS0FMdWZI?=
 =?utf-8?B?YXRybStWYlJ4bGJITXJobk95V3dZbU9wL0c5QWhQck5LbXBSWTJCdXVKWTlU?=
 =?utf-8?B?TVArVE0vMnlOb3g2U1BWUUpGQUo1UUtZbFVBeGlxZDBSN293KzJMeElQQlNZ?=
 =?utf-8?B?em9vUWJuWm9hK0pnOSs3SUZnc2JKa0FKUGFhZUpzRjd3aTlQUnlLUVMwUi9O?=
 =?utf-8?B?clJ1M3NOVnVibHBSV3JaRXJRa21qQ1B3SVlqWlBNY2FYUnVTTldyY0xCWEtv?=
 =?utf-8?B?RENVS0tYQVp3TjlHcHZyY0dwR1haNjliLy84QjFHVk4wOTNYR1BGWXRzRjJM?=
 =?utf-8?B?SVBJM1psVlNuR0d0MnlvT1NaQm5sL1J1SFQzNUhFc0FxNTNOcllZY0RMOWFF?=
 =?utf-8?B?OVoxd3JkMUxKKy9lcHZQc3daZTRqYlhkRlBwdkJNQ1pYNGlsdzYrREdPc2lw?=
 =?utf-8?B?YUg2MEhwNFFicGtvNklURzFqdWFkWlkxQ3kzQi9Ib0FqbXJHalVVMDhrMkhy?=
 =?utf-8?B?dlpIQVUxcFdsdHhTRm40TzVuV2l1QXFhQ2g0TzlRQVhpNkQzRjFxOHYyVUdD?=
 =?utf-8?B?SUN4VGNVS3JiamVIckRaWnJSSmpKV1ZTUjI0YVJSTWd2T1F4TGtBSm5jUVZn?=
 =?utf-8?B?TlVmM3B0andYQ3RuSjVGOElEN2Vwa2d5UXNaWlYwZGVMYWN3Myt0aFdsbVBP?=
 =?utf-8?B?UHoxaDVtbHcrcytJYlJTL0RlcG9kc3BST3VwS0tWck54bkErUjk3UG5YL2lO?=
 =?utf-8?B?azF5N0NSZGFMU0UyWHNaTGJxYjZFR1Jab0V5WFc2VW01RVF5S2JaWFJIZHNj?=
 =?utf-8?B?eWR0a3B4SkFXb0llczZrYlVGbUdOVFNTaWdlbFFYUmZKZVlTQjczajZCZ1lI?=
 =?utf-8?B?M2hWRndGRC9jblBodlVIWkptNml6RHZSYklkRGp6RnE0enZqcHJtL1FUQThU?=
 =?utf-8?B?cmw1eWxCdUU2TzZpTWZxY2tJZkFTMktBN01uRW1PaHFEeE56TTZyZ2g3OEds?=
 =?utf-8?B?b2ZteE1Za0xOSDk2ZldKVXBmbjhkT1dXSWhiK05xNmFvMHp6ZnhiWmhtYjRX?=
 =?utf-8?B?WU1QS0tLS1E1YSsxR2ZvTmF2RnZBUEpudEN2anJsZXF0U29FM2xBL3Y3SHZC?=
 =?utf-8?B?YVo2MXlDNlJUbnlWVERDeFZDbTJGSVFHRWprSHhYNU5QRkpyYjVEc3h6WC81?=
 =?utf-8?B?cmo5TTF4UWhUTGZFNGwxUUlwT2lHSlJTLzZMU3NsMHNTajFCdjRvcmZzK0lo?=
 =?utf-8?B?eEt5aThEUHBIK2c5S3BPWTROcExFVVJBdzRaMkhzS1hTWllTSDYxN3gyMDZY?=
 =?utf-8?B?R3g1MDZnRStDelhPWHFTWlFIYVhmWFppL3l1SFc4RWYyNy9ENlhyM0hOR2RL?=
 =?utf-8?B?WFMzR3BvRm42bmtHdjlzdkVtSHp4T0FFM2h0ajdQZnE5Qk11c0xPdVA4VTU0?=
 =?utf-8?B?Wms2RWFKUk5yY1JUQy9wTjN6MnZEZGZKYnd0U0hqdnQyK2Z1VUZ0RDFPMkla?=
 =?utf-8?B?c09pcmtia2lFK3ptNXFiQUt0Y1E3OVJqNEp1T2pvaCszVVEva1dBZDVqTlNi?=
 =?utf-8?B?TVVFK29vK2hEckFQdS9HdHlCMEpadWxrMUxqcTYzVU8vaE4vbGk1bUtvRmdx?=
 =?utf-8?B?ZEdEVEdIZTNyN1hIaEdlbHE2QzVndWVlOTV1T3o4VDVmdnpDWGhCcmhxMFN3?=
 =?utf-8?B?aVMxbllTNDdkS1ZqUnY5cEZzcWhDekdOaXNTUlozMFlzbTFTQ0dpdjhUaTJa?=
 =?utf-8?B?UlIyd3luYUhmelpJK200cHh5TTk3UDh3bm14WG1kVmp2aGZqTnBudlFlSXlZ?=
 =?utf-8?B?ZDhtMldKODJVK3MwZ29NYU5aUExBaXY4N1hsa0pidmVKRXhIOVBxMXA0eEFQ?=
 =?utf-8?B?MkJ4WjFhd2VRR3dTeFozZHBZRWgyMGtlZThsSmV0NFc5QjUyV20wRlZwUlA3?=
 =?utf-8?B?dEwrM2ZUZ2RRY1JDUkhRTEMwMW1HZlUwUzJqbDlBUmlsZ1Z4TTlQVlUwY0xl?=
 =?utf-8?Q?gOns=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ef8011-dad3-4e98-055e-08da7f2f984e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 02:32:42.1318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I/BWGzlRZiTcJhMgQIlX+A0w64xWxBsa8UfX3AicLriCkaO85JXrLu+EsMQvq2JdBWG8QOuMQJoyq2LldmStEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gU2VudDog
TW9uZGF5LCBBdWd1c3QgMTUsIDIwMjIgNToyNyBBTQ0KPiANCj4gU29tZSBmaWVsZHMgb2Ygdmly
dGlvLW5ldCBkZXZpY2UgY29uZmlnIHNwYWNlIGFyZSBjb25kaXRpb25hbCBvbiB0aGUgZmVhdHVy
ZQ0KPiBiaXRzLCB0aGUgc3BlYyBzYXlzOg0KPiANCj4gIlRoZSBtYWMgYWRkcmVzcyBmaWVsZCBh
bHdheXMgZXhpc3RzDQo+ICh0aG91Z2ggaXMgb25seSB2YWxpZCBpZiBWSVJUSU9fTkVUX0ZfTUFD
IGlzIHNldCkiDQo+IA0KPiAibWF4X3ZpcnRxdWV1ZV9wYWlycyBvbmx5IGV4aXN0cyBpZiBWSVJU
SU9fTkVUX0ZfTVEgb3INCj4gVklSVElPX05FVF9GX1JTUyBpcyBzZXQiDQo+IA0KPiAibXR1IG9u
bHkgZXhpc3RzIGlmIFZJUlRJT19ORVRfRl9NVFUgaXMgc2V0Ig0KPiANCj4gc28gd2Ugc2hvdWxk
IHJlYWQgTVRVLCBNQUMgYW5kIE1RIGluIHRoZSBkZXZpY2UgY29uZmlnIHNwYWNlIG9ubHkgd2hl
bg0KPiB0aGVzZSBmZWF0dXJlIGJpdHMgYXJlIG9mZmVyZWQuDQpZZXMuDQoNCj4gDQo+IEZvciBN
USwgaWYgYm90aCBWSVJUSU9fTkVUX0ZfTVEgYW5kIFZJUlRJT19ORVRfRl9SU1MgYXJlIG5vdCBz
ZXQsIHRoZQ0KPiB2aXJ0aW8gZGV2aWNlIHNob3VsZCBoYXZlIG9uZSBxdWV1ZSBwYWlyIGFzIGRl
ZmF1bHQgdmFsdWUsIHNvIHdoZW4gdXNlcnNwYWNlDQo+IHF1ZXJ5aW5nIHF1ZXVlIHBhaXIgbnVt
YmVycywgaXQgc2hvdWxkIHJldHVybiBtcT0xIHRoYW4gemVyby4NCk5vLg0KTm8gbmVlZCB0byB0
cmVhdCBtYWMgYW5kIG1heF9xcHMgZGlmZmVyZW50bHkuDQpJdCBpcyBtZWFuaW5nbGVzcyB0byBk
aWZmZXJlbnRpYXRlIHdoZW4gZmllbGQgZXhpc3Qvbm90LWV4aXN0cyB2cyB2YWx1ZSB2YWxpZC9u
b3QgdmFsaWQuDQoNCj4gDQo+IEZvciBNVFUsIGlmIFZJUlRJT19ORVRfRl9NVFUgaXMgbm90IHNl
dCwgd2Ugc2hvdWxkIG5vdCByZWFkIE1UVSBmcm9tDQo+IHRoZSBkZXZpY2UgY29uZmlnIHNhcGNl
Lg0KPiBSRkM4OTQgPEEgU3RhbmRhcmQgZm9yIHRoZSBUcmFuc21pc3Npb24gb2YgSVAgRGF0YWdy
YW1zIG92ZXIgRXRoZXJuZXQNCj4gTmV0d29ya3M+IHNheXM6IlRoZSBtaW5pbXVtIGxlbmd0aCBv
ZiB0aGUgZGF0YSBmaWVsZCBvZiBhIHBhY2tldCBzZW50IG92ZXINCj4gYW4gRXRoZXJuZXQgaXMg
MTUwMCBvY3RldHMsIHRodXMgdGhlIG1heGltdW0gbGVuZ3RoIG9mIGFuIElQIGRhdGFncmFtIHNl
bnQNCj4gb3ZlciBhbiBFdGhlcm5ldCBpcyAxNTAwIG9jdGV0cy4gIEltcGxlbWVudGF0aW9ucyBh
cmUgZW5jb3VyYWdlZCB0byBzdXBwb3J0DQo+IGZ1bGwtbGVuZ3RoIHBhY2tldHMiDQpUaGlzIGxp
bmUgaW4gdGhlIFJGQyA4OTQgb2YgMTk4NCBpcyB3cm9uZy4NCkVycmF0YSBhbHJlYWR5IGV4aXN0
cyBmb3IgaXQgYXQgWzFdLg0KDQpbMV0gaHR0cHM6Ly93d3cucmZjLWVkaXRvci5vcmcvZXJyYXRh
X3NlYXJjaC5waHA/cmZjPTg5NCZyZWNfc3RhdHVzPTANCg0KPiANCj4gdmlydGlvIHNwZWMgc2F5
czoiVGhlIHZpcnRpbyBuZXR3b3JrIGRldmljZSBpcyBhIHZpcnR1YWwgZXRoZXJuZXQgY2FyZCIs
IHNvIHRoZQ0KPiBkZWZhdWx0IE1UVSB2YWx1ZSBzaG91bGQgYmUgMTUwMCBmb3IgdmlydGlvLW5l
dC4NCj4gDQpQcmFjdGljYWxseSBJIGhhdmUgc2VlbiAxNTAwIGFuZCBoaWdoZSBtdHUuDQpBbmQg
dGhpcyBkZXJpdmF0aW9uIGlzIG5vdCBnb29kIG9mIHdoYXQgc2hvdWxkIGJlIHRoZSBkZWZhdWx0
IG10dSBhcyBhYm92ZSBlcnJhdGEgZXhpc3RzLg0KDQpBbmQgSSBzZWUgdGhlIGNvZGUgYmVsb3cg
d2h5IHlvdSBuZWVkIHRvIHdvcmsgc28gaGFyZCB0byBkZWZpbmUgYSBkZWZhdWx0IHZhbHVlIHNv
IHRoYXQgX01RIGFuZCBfTVRVIGNhbiByZXBvcnQgZGVmYXVsdCB2YWx1ZXMuDQoNClRoZXJlIGlz
IHJlYWxseSBubyBuZWVkIGZvciB0aGlzIGNvbXBsZXhpdHkgYW5kIHN1Y2ggYSBsb25nIGNvbW1p
dCBtZXNzYWdlLg0KDQpDYW4gd2UgcGxlYXNlIGV4cG9zZSBmZWF0dXJlIGJpdHMgYXMtaXMgYW5k
IHJlcG9ydCBjb25maWcgc3BhY2UgZmllbGQgd2hpY2ggYXJlIHZhbGlkPw0KDQpVc2VyIHNwYWNl
IHdpbGwgYmUgcXVlcnlpbmcgYm90aC4NCg0KPiBGb3IgTUFDLCB0aGUgc3BlYyBzYXlzOiJJZiB0
aGUgVklSVElPX05FVF9GX01BQyBmZWF0dXJlIGJpdCBpcyBzZXQsIHRoZQ0KPiBjb25maWd1cmF0
aW9uIHNwYWNlIG1hYyBlbnRyeSBpbmRpY2F0ZXMgdGhlIOKAnHBoeXNpY2Fs4oCdIGFkZHJlc3Mg
b2YgdGhlDQo+IG5ldHdvcmsgY2FyZCwgb3RoZXJ3aXNlIHRoZSBkcml2ZXIgd291bGQgdHlwaWNh
bGx5IGdlbmVyYXRlIGEgcmFuZG9tIGxvY2FsDQo+IE1BQyBhZGRyZXNzLiIgU28gdGhlcmUgaXMg
bm8gZGVmYXVsdCBNQUMgYWRkcmVzcyBpZiBWSVJUSU9fTkVUX0ZfTUFDDQo+IG5vdCBzZXQuDQo+
IA0KPiBUaGlzIGNvbW1pdHMgaW50cm9kdWNlcyBmdW5jdGlvbnMgdmRwYV9kZXZfbmV0X210dV9j
b25maWdfZmlsbCgpIGFuZA0KPiB2ZHBhX2Rldl9uZXRfbWFjX2NvbmZpZ19maWxsKCkgdG8gZmls
bCBNVFUgYW5kIE1BQy4NCj4gSXQgYWxzbyBmaXhlcyB2ZHBhX2Rldl9uZXRfbXFfY29uZmlnX2Zp
bGwoKSB0byByZXBvcnQgY29ycmVjdCBNUSB3aGVuDQo+IF9GX01RIGlzIG5vdCBwcmVzZW50Lg0K
PiANCk11bHRpcGxlIGNoYW5nZXMgaW4gc2luZ2xlIHBhdGNoIGFyZSBub3QgZ29vZCBpZGVhLg0K
SXRzIG9rIHRvIHNwbGl0IHRvIHNtYWxsZXIgcGF0Y2hlcy4NCg0KPiArCWlmICgoZmVhdHVyZXMg
JiBCSVRfVUxMKFZJUlRJT19ORVRfRl9NVFUpKSA9PSAwKQ0KPiArCQl2YWxfdTE2ID0gMTUwMDsN
Cj4gKwllbHNlDQo+ICsJCXZhbF91MTYgPSBfX3ZpcnRpbzE2X3RvX2NwdSh0cnVlLCBjb25maWct
Pm10dSk7DQo+ICsNCk5lZWQgdG8gd29yayBoYXJkIHRvIGZpbmQgZGVmYXVsdCB2YWx1ZXMgYW5k
IHRoYXQgdG9vIHR1cm5lZCBvdXQgaGFkIGVycmF0YS4NClRoZXJlIGFyZSBtb3JlIGZpZWxkcyB0
aGF0IGRvZXNu4oCZdCBoYXZlIGRlZmF1bHQgdmFsdWVzLg0KDQpUaGVyZSBpcyBubyBwb2ludCBp
biBrZXJuZWwgZG9pbmcgdGhpcyBndWVzcyB3b3JrLCB0aGF0IHVzZXIgc3BhY2UgY2FuIGZpZ3Vy
ZSBvdXQgb2Ygd2hhdCBpcyB2YWxpZC9pbnZhbGlkLg0KDQo=
