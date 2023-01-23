Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D2678245
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjAWQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjAWQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:53:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922942DE43
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:52:49 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30NFxNpw003306
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:52:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=PzkzurL01SCYJSYJaNO5uFZFisHlyStAsGwSN6Q6gF0=;
 b=T32puHii5//d0e8t0PyG2H0BZ7Sh+Ei9OgX4u9tzhxvP3nbObuwOR0t2W8DgelHT6PoR
 RLkXceSJaPipXoRYJmGE90GbMUKDg+Y3mcIcUkUEBxSJG2PC/1KAo2JTmOeuH2cpYYjs
 u9dlP3ZHDq9zgagUmqB3/Q0dqBkVQlkVGwvHEV8gYW4WaAPv6MAcHHaaCgB0Nl9BoSyx
 J5wH9M4M1j0SM8nBCE+bbz3SpD9r7pXt3MXL9fLijvBir8NSUhJlcj/kHumjDKXXuNmY
 fh7t8ZUtO3ozOWSxgodGqasNKRTqVe1sELJZ1dczz/bG6ot9uxnKR/QBlYjcgSWALC3Y xg== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by m0001303.ppops.net (PPS) with ESMTPS id 3n8cm1k1jh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:52:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbXW5PfDL0UCXK4Ah72et7Zv5ltwxXJM0sngS5PHgrpJmJ2YWok5rZpVfcNwuW5GPEB/UTPqHT+C142fMeY4u38zD6ghBdy3SF4f0hF2wtesx3tSp+P9YhLmXpMqg9M6BnJOEyr2RNbyz5TfZZV4SZ0ooZknRioQaPVeD+VcrpPbhBKbYcO/TfR9+o4k/KUe2x8IHXZmwIggL22ecSrF3rifLekb80sbwgXA+tdBZ3OexysJrmDka7Gax04EYOIKAc56AsxCMn8aiDIK1hGoYr5rgy+dGrom28ftfgNSVbH+/u6WV4Sv/3+znCX26mvfdphjja4jKMaXO13MrWPh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzkzurL01SCYJSYJaNO5uFZFisHlyStAsGwSN6Q6gF0=;
 b=axe6BE3kVPGVvz6Tj6EeiE3qGTLl/I9DmZEMZCRx3aRJ8ib+cQJPHyv1B38ncYwomZZzMhuOWHWXjtmzmfK45Mkf1z48J4u+fQLeSKdyDoPOWPHKhFSGbQGjNnNjerygy3m4wTXTnkid9lB8rhIGMZYWtUfgyLoOg9BlFo+dYA/W8uEGjFYF8yzje6zEjrQoJT9KIsOS5ZhKsd4APaPTs/K56oU5Cg9GIkiNTZJn5ZwrIFgUpWCOPtshrvijOR6PThoM1APgACqeMPERUy+0ODEUXPBFXykWMidh8CO/bsQDjoi6M5enyh0422J7Z7Ptw+BmxzMCkxCyaFKjTOJ4DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by IA0PR15MB5790.namprd15.prod.outlook.com (2603:10b6:208:409::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 16:52:31 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 16:52:30 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Gal Pressman <gal@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] mlx5: fix skb leak while fifo resync
Thread-Topic: [PATCH net 2/2] mlx5: fix skb leak while fifo resync
Thread-Index: AQHZLnzb9qm5OuogFUegSwQlchNEZq6r8j6AgABG8QA=
Date:   Mon, 23 Jan 2023 16:52:30 +0000
Message-ID: <c0872e41-a765-5d5f-77ae-49c15977114e@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-3-vadfed@meta.com>
 <8537aa82-8ac9-3f76-c8ae-395a60ccddf8@nvidia.com>
In-Reply-To: <8537aa82-8ac9-3f76-c8ae-395a60ccddf8@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|IA0PR15MB5790:EE_
x-ms-office365-filtering-correlation-id: a039bb8d-b6a3-43a8-6fa4-08dafd6237ab
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Aej9QQ5uOmGtT3jQrtdfETXZ2jq5ORYmg/aLdZuHlxXFHKRGQ8HwHFx02mEb0dnelJ0M8HFzpxpp5LUqI13DukaLemkZnj0I2j+tycWBFM8G2UgTO8iP3ZRJnK83tYEcw7oNgYeAYDXzA4dpDiPZ4khdqayW/kbOGuzbIqPtZKp8YcK8irAwTIsXpT2X/jwf4fRyfG354YOxAcMQUpsqLFfKUht3tFDU8JhWzY0hCPuHofus7Zh0U87ctcvaBcQPvKSkYgIyCGWT8H2vGZqIdOmJwwIMNusBYsct34DK3VTVLLzvZqOKbJ6ASuFkFM82XiKbsiG+gsNmoYcavu1MpLdDnTzRNiwKwQMhWKiblahFFRzdPPEhEBQdJv+M4+UXqqaeA9vWY1L97Pbc6MMcjsKjpQw8XjkSZY0lqqCGO9B+U1y/zGhY/Kv/sjl+G64XPbbnTgW749fPTcEJWztk3gn53/KQeg0DGq7PEBnzqT9ZZcYe456mh++bFsEQo+xUGMtlEOpYErsX1Qkpbp/rkV37NNGodRlmsFBdqrGePAkYLlOTFLzJwtslrE/ZKOnR6VWo/nFAaIMnBdR6ZoaZfIn+ovzUrMlhRzq6Wf29vGlLvvyjoYWxyPuLxbrNGlHzItRSGSBglNdxxzVjsxcQgOIF5JKX2EYn+HxVncOfMytpay/cbZAuOtgBwwdqRREgur3BgHepyNCHHMzbty3SphuGkmExkQ5vOAfMJMonck=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199015)(66476007)(91956017)(66946007)(86362001)(64756008)(66446008)(66556008)(76116006)(4326008)(8676002)(53546011)(36756003)(316002)(6506007)(186003)(6512007)(71200400001)(6486002)(110136005)(478600001)(2616005)(31686004)(38070700005)(8936002)(122000001)(5660300002)(31696002)(41300700001)(2906002)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzZGTDlNNFVWeEYrbVpEMGtWQ05qZXE1b3k2dzYrSGtxVGxiVjVOa1luR1lD?=
 =?utf-8?B?VlVSQTlPL2M2d0VwQTJPV0trVUNRdUdqeThNYWExRm9ZZUYzMWtCRW4yQ2o1?=
 =?utf-8?B?WTlRUUQ5R1ZLbDlIK3hmTTRIV1JTLzhSN095cEZNUkhaZTBBQnl1ck9KV2Z4?=
 =?utf-8?B?bVUrRVYwVEUyOFFRMTVoOXdCZmhqTkVqcmNyUTdsU2pSSTZSOC82ZHJ6WVo1?=
 =?utf-8?B?cGlzVTk3MzhYTnVldExBaEsvL2VFN1c0cnRGMlJkd21LajRoSGp5VnBjTWRa?=
 =?utf-8?B?azFmVGI2elJSYzk2cW92L29VOFZjdnp2eUF4TG5KYXZFdlJUNFhrdFIweVBR?=
 =?utf-8?B?WEhET29WRXNsQzlEbzRYQVpOSFFsN3V4elFVRGtRdCtyZEpVeG8wdldSQ1M0?=
 =?utf-8?B?Z1RWa3NJTHBxcmJWZUJHMC9sN0hJei83NldDWWR6UnBuUnlleU1VVkM1VUxk?=
 =?utf-8?B?bzN1Vm9UaCtvMHo5MTZpZmUxU2lnc3VIWnRsR1pkRjZIQWIzT2JON1c2aVkx?=
 =?utf-8?B?V2trVTl6dXN3MS9RSzBHSnZCSXFrWFE5S1hVQUw2ZU85WVpkbFE2OGRyaGxv?=
 =?utf-8?B?ZldQS1VHaW1RWTBCem1NamcrQmVFL3BtL1lVbzB5dElvYXE1dWhBc0JXYkJC?=
 =?utf-8?B?RERKSnk1U0RSRTRNWElyVTZDd1dyVUlpTDlMVFg5dnJEWjBtelFNc2NaRnVz?=
 =?utf-8?B?SU1ZMSsyaWJRcHYwM3BWdlJRK1NWcC90U0haRVlsUU83elZPZWNTVzJrdEha?=
 =?utf-8?B?YXQ1TmNWMEszS2lSekU0YU5KNmJBaVdQSU43dlg4N24rYVE5aGtTN085OG1v?=
 =?utf-8?B?c1hkMWhwRTZFS21Ic2RQQXIyNkZQNXliQjBaYmRNdVQyanorVDlxL2gyTnNN?=
 =?utf-8?B?WUp3YWgzWDN2U0Zhb3pLR2dETkFLbTR1SXBESkdSTTZMVUM4dXVONGJrWmFn?=
 =?utf-8?B?ZEJnUFpQdjVZanhjZTZqNHRUb2E5SVpaNUEyZ29NZlBHYjFXT3hsR1E0cXMv?=
 =?utf-8?B?YmRCejBIM2pnRlVrQjNKd04xVThGcE1vemtJSURSRVJKUlNxdzhVU3hrSFN3?=
 =?utf-8?B?VVh1cTNQd3NOZG9HSFRGWWpsTlljVC9FTlhOZVpFbFlvM0pEeDExeS93c3N3?=
 =?utf-8?B?SGhSOENNdm5xblNoVEhBZ3MrRkVCakRqS3NBUXdrb2hXS09qUzdsSzlRdTh4?=
 =?utf-8?B?TmpDeFBwUFc4czNoKzRBRnN3a2gxWFN1ZzAwc0FJY1hyaFhzbmRMeHZBMmNK?=
 =?utf-8?B?Qmh1T01JWkhraHowVXg5aGkrbzczRU15bmxrU2c1ZW5IVHBwQ0haSFhQVUdE?=
 =?utf-8?B?bmwwZG93RVZ1RlY5QzNmYnBVb1BLZ05XR0dwOEZWN1JCclRTMWpxZEgyTENm?=
 =?utf-8?B?RFdKZDU5NzNRSnhhc1NPK3NoZTcrVDVQOEtiN0xTSmpNeXhYSnhKVU83dUZG?=
 =?utf-8?B?MHQwMHBueTU0bGRYVEdVazg5dnhWY01LbGVJYXVOVUl6NVhBZGQ1dHJaRFRL?=
 =?utf-8?B?TzhlWlJRUFVqWjIyV1MyOG9vQ2NZa1YrL09PTEVYQ0ppYUkycDlNaks5QThF?=
 =?utf-8?B?UnpMc2x3N1hRVTdGQnRrUU5YSkZhYlF1TGpTc1FsalJJcUlkVDBIU2tXRTJj?=
 =?utf-8?B?MURpQ29zbXg5VlIwRytRYlc4TUJwM0VPUHpSaWNQTGFHa0RmMnZVYzkvZlhi?=
 =?utf-8?B?YXhWUGt0cEFuNlBsbVVCVVcvSlBWVVdoRmRhR3FaRjRiNXJxWVI0OHdJd0hB?=
 =?utf-8?B?cENHQ0NmUUtlSkFBc1hPR2hrMVhBSEw5dWZkSUkwSzFEMHVpQlRwQktwZzl6?=
 =?utf-8?B?dzZsQmIyd3Bxd3BPNlRnWDM2MkdoMDVxOU9nc1Y2Tk1RaURNa3ZvUzBGOVFG?=
 =?utf-8?B?d0RrK1NIaDlrWG93V0JWMUVQWUV1ZzRWRTRpV0pEZjd6T1kycTBMWDlVWlRK?=
 =?utf-8?B?M0ZKdkduQjkwYXRmWHJGU0QzQTU3bzFtcUdXMjJSTWJXY0pGcWZ3eUZxSTk1?=
 =?utf-8?B?d0pYRmVEYnB3UDY4RmlVVnoxMk44b000cU40Ulc0aTF3dURpQnV5aEZDT3NG?=
 =?utf-8?B?TjFPMlR0OUJsMld1UElpSHQ4NXdlS0cxdVRHVnRLaXhGeHdRS3JVbTZrQ2dT?=
 =?utf-8?B?b0pnYW5wLzM0MDEybDUzRXZLanA1bEQvQVRzQWFqL1UwS1UxeHJxTHZUazdH?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <444B7581D8D76A458C07CFBF3D97E7AB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a039bb8d-b6a3-43a8-6fa4-08dafd6237ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 16:52:30.8482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmFHeKLiBfqGUFdFszELHzGmvncY6jsrC3i84OLZOqfCznj9q8pFESYsH534l4ML
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR15MB5790
X-Proofpoint-GUID: DTbljivlTeJook9SsBteaYqB8ZbmuJ7i
X-Proofpoint-ORIG-GUID: DTbljivlTeJook9SsBteaYqB8ZbmuJ7i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMvMDEvMjAyMyAxMjozOCwgR2FsIFByZXNzbWFuIHdyb3RlOg0KPiBPbiAyMi8wMS8yMDIz
IDE4OjE2LCBWYWRpbSBGZWRvcmVua28gd3JvdGU6DQo+PiBEdXJpbmcgcHRwIHJlc3luYyBvcGVy
YXRpb24gU0tCcyB3ZXJlIHBvcGVkIGZyb20gdGhlIGZpZm8gYnV0IHdlcmUgbmV2ZXINCj4+IGZy
ZWVkIG5laXRoZXIgYnkgbmFwaV9jb25zdW1lIG5vciBieSBkZXZfa2ZyZWVfc2tiX2FueS4gQWRk
IGNhbGwgdG8NCj4+IG5hcGlfY29uc3VtZV9za2IgdG8gcHJvcGVybHkgZnJlZSBTS0JzLg0KPj4N
Cj4+IEZpeGVzOiAxOWI0M2E0MzJlM2UgKCJuZXQvbWx4NWU6IEV4dGVuZCBTS0Igcm9vbSBjaGVj
ayB0byBpbmNsdWRlIFBUUC1TUSIpDQo+IA0KPiBTYW1lIGNvbW1lbnQgYXMgcHJldmlvdXMgcGF0
Y2g/DQoNClllYWgsIGFuZCBpdCdzIGNvcnJlY3QgZm9yIHRoaXMgcGF0Y2ggdG9vLiBDb21taXQg
bWVudGlvbmVkIGluIEZpeGVzIA0KaW50cm9kdWNlZCBzZXZlcmFsIGJ1Z3MgYXBhcnQgZnJvbSBh
cmNoaXRlY3R1cmFsIHByb2JsZW0uIFRoZSBmaXJzdCBidWcgDQpvZiB3cm9uZyBjaGVja3MgYW5k
IHBvc3NpYmxlIG92ZXJmbG93L3VuZGVyZmxvdyBvZiBGSUZPIGlzIGZpeGVkIGJ5IA0KcHJldmlv
dXMgcGF0Y2guIFRoaXMgcGF0Y2ggZml4ZXMgYW5vdGhlciBpc3N1ZSBvZiBsZWFraW5nIFNLQnMg
ZnJvbSBGSUZPIA0KZHVyaW5nIHN5bmNocm9uaXNhdGlvbiBwcm9jZXNzLg0KDQo+IA0KPj4gU2ln
bmVkLW9mZi1ieTogVmFkaW0gRmVkb3JlbmtvIDx2YWRmZWRAbWV0YS5jb20+DQo+PiAtLS0NCj4+
ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3B0cC5jIHwgMSAr
DQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPj4NCj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMNCj4+IGluZGV4IDEx
YTk5ZTBmMDBjNi4uZDYwYmI5OTdjNTNiIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3B0cC5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMNCj4+IEBAIC0xMDIsNiArMTAyLDcg
QEAgc3RhdGljIGJvb2wgbWx4NWVfcHRwX3NrYl9maWZvX3RzX2NxZV9yZXN5bmMoc3RydWN0IG1s
eDVlX3B0cHNxICpwdHBzcSwgdTE2IHNrYl8NCj4+ICAgCQlod3RzLmh3dHN0YW1wID0gbWx4NWVf
c2tiX2NiX2dldF9od3RzKHNrYiktPmNxZV9od3RzdGFtcDsNCj4+ICAgCQlza2JfdHN0YW1wX3R4
KHNrYiwgJmh3dHMpOw0KPj4gICAJCXB0cHNxLT5jcV9zdGF0cy0+cmVzeW5jX2NxZSsrOw0KPj4g
KwkJbmFwaV9jb25zdW1lX3NrYihza2IsIDEpOw0KPiANCj4gV2FzIHdvbmRlcmluZyB3aGV0aGVy
IHdlIHNob3VsZCBwYXNzIHRoZSBhY3R1YWwgYnVkZ2V0IGhlcmUgaW5zdGVhZCBvZg0KPiAxLCBi
dXQgbG9va2luZyBhdCBuYXBpX2NvbnN1bWVfc2tiKCkgaXQgZG9lc24ndCByZWFsbHkgbWF0dGVy
Li4NCj4gDQo+IEFueXdheToNCj4gUmV2aWV3ZWQtYnk6IEdhbCBQcmVzc21hbiA8Z2FsQG52aWRp
YS5jb20+DQo+IA0KPj4gICAJCXNrYl9jYyA9IFBUUF9XUUVfQ1RSMklEWChwdHBzcS0+c2tiX2Zp
Zm9fY2MpOw0KPj4gICAJfQ0KPj4gICANCg0K
