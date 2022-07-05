Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11321566A5A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiGEL4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiGEL4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:56:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA77D17A86
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 04:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3hf2y5DROM4V/N1k51y7rnL3XGA8sBddEZRjJoGzQIIMIx6c1/bvSdcxjlcfdbyt8bJCjg5vweQGMTIp57w2styfAVk7tlSvFoU4e+dEv1Hpt1Y6zzm1Du+tzZ+bQTUWUlKeUR9Vb+jJi1QMJP3skcbe1enXDRHqTV4vOlZTz6dof02GUY3A3R5C5poF0Ld+BQFcHRmAgNN6iLCCpFFxchxzHR7V39kHXUey0Ugx9xrfw9Z4rXl/q9BKH/DvA/wJjLFHw6gq2UsQIOhoUrGeAOkJz/arIytAKOiVBqd9Y7pr5TtaoIUX9ZYUyMvMl4BWxpKu1JJOtrFoVdRiR5HeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlGXJ+MTm+RSY2LuzrPOrMcy5bcGmp8W+UQ9va07Kcs=;
 b=jgilb3FdjcY/h7xKxjpaMyMhLQAqfa0aUS9mtYL5HQpW0QT9jmknHB3wEZO5+webPT4fvmXjfJ6lA2YIEbMuKbIwafHOZkRXHL9axH2KNt61NAgb8t6GAZqk2KMujC76ExjaDybOeekN9iCU/jFopyO0sh3iUfS03nnlxkwDMVC98NYviySKUMQVfGc2DwIoBGIhHnPZKFm7pzW0OIHQ7xB0Jyne2i1tv6+owCayABXPEVI7Sqfrz3R18BERKn9QtOv78iyyfrTW0yHDbqNDeXRbviHekpkoIUeqKbbJjoZZFE7t9kpVs+1cIYvu3/RbjYx6iSXPBm0yds83nv7hhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlGXJ+MTm+RSY2LuzrPOrMcy5bcGmp8W+UQ9va07Kcs=;
 b=Ssb0mPmdblb6oMc1gCoqvEC7Ub3qjeuEDd/j3crjHP7FtV5DG4tZHvNL/jMCzah02/yeZx2WYpM5kUKwPw0NqFebRNFJOuhNF5RNTuvYAsTVz3GfhX4Jo787qaI5f6bg4QpnchPAxAZpdC7BYZaP/ayvmDEnW6wmH4AS6LP+EpwABQGhGA1B9xfAts1PajnQHbZzUM1nfZXcAi06DXJXCWC6o2lLJumYNB0gZrYk9ObJoHQZCI9vZffY9nkLhYs3fDkFabwMNcPNRLp0KvY3ZuCDGfsyouvjSOrcluVa4PnWjT2EX65bJsM1Gu0ZqwCzpWl/oPTixIEc5rjJkc7TFw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DS7PR12MB6334.namprd12.prod.outlook.com (2603:10b6:8:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Tue, 5 Jul
 2022 11:56:50 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5395.022; Tue, 5 Jul 2022
 11:56:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
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
Thread-Index: AQHYjU+MYrbSKcBokU6ni+IvOk3zwK1qDqQggAOY1gCAAIePkIABQJ6AgABBuVA=
Date:   Tue, 5 Jul 2022 11:56:49 +0000
Message-ID: <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
In-Reply-To: <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e414071-7730-43bc-6376-08da5e7d71d3
x-ms-traffictypediagnostic: DS7PR12MB6334:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ufI/6CspBmNfKyfz+b4TUx051grHgEgl+lbbgBiTAHXTQYitW4YGEZeoedUzftj4OF7KnAqanJsjsCIbK0LFBrr++UvZkJKs5iawRltNMxEhvWLHURkrFUy7KDlWdJ+J7qBwu7efICSl5MDM2mqrSf2BD2szYupecdHpbssV1zMC4dAQJoSsE8iuLAfvOX50IE3O0MEDvdkL0chfI4ulgFRhchRUJ2q0L43hA4c7eclWiQ1kOddN5Q2CLxbDsDALphFmbNy0ll4kAVjCnTwoN7/DCgbCxh0mpA2vS+vsR5w88wcxM2yq5hwXzENVpHCWgvvGTZSxK3FvPjNxnfjsaiNHl1WntQA1YjfqcJNMfzRv82Wg3IPJu/UUaoDvyBCxVbwGGFHYlYZzqWa1Us0aa/8zrcP1WgD8TNZJ5IAVJMRS8m1L7Ff0A7B+vXKN64H985brs6HKFd8VNqXG2Kcnmv4ApG04UXiPZOh/8jnpov5XFTT5PcJsOxPbSnXgYcaRmw1ARMFUKw9LmfFYlqtEJZcTbHkHMkXq+rHdFAeE0dF0jWKly2NoN6VSK6nXiB1xghbilbba34E6D22IVJnRwowRqbqyZJmFESLSLTdBa/B3G8ucybnPalr6p7alCWZIDT89IHe/1m5uSwNXna1z3YEGMc/RX1fyE3lRa70wx+3nKekZ6PrKg6L7gZ3bJxx8bFM/IQI3jrGlmgjKoQd42iQtRHc64zE3XUyavb+ayR4VdFOSRYxxptkV3eUUbpxP3qrJvk4oNj+9Qrr/J148WIuw8Hyldx1lUOIu/4kGeaocoSe3Wg9UlgaAWwRFOJ7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(5660300002)(478600001)(26005)(6506007)(52536014)(8936002)(7696005)(2906002)(41300700001)(86362001)(9686003)(53546011)(66556008)(316002)(186003)(66446008)(110136005)(66946007)(66476007)(8676002)(54906003)(76116006)(4326008)(55016003)(122000001)(64756008)(38070700005)(83380400001)(38100700002)(71200400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEdQOEZpbDI0L29idTh3cHI5UHc3dUxlL1dGUXphTjBtRXY4UC9HWjNsSm9v?=
 =?utf-8?B?eXhtdUhkd0RLai8vQ1hXOGdmc1k2Z0hxSW05Y3RqaTFWMHI2SFRWV1NBTVQr?=
 =?utf-8?B?ZXk3bnZBV3l1dzA5QmI1d2J0aWUwQ0t1VmtkeXkvYituQ2pBOUMyaU1rRldB?=
 =?utf-8?B?aFNSYTZzSDZ5b3JkWDBST2ZuUEprdDFRdUptQTMzbGlSKzFHZE0zU0hKdU5C?=
 =?utf-8?B?Q1dGdVYxZG41cVEzaSszY1hMTTBMSzM0NExmbkV6ak5XTFVWa05qelVKYzNn?=
 =?utf-8?B?SVlZSXJRWTE4S3JJTGMzcXlta2ZvTXJVbnpIVlBGUXVqU2lEcVNqUDdZVnFQ?=
 =?utf-8?B?Q0NJcmQwTDRNVDZYSEZxNk54RDAxMVB5a3lrdjJXNmdlRXE3eGhjbE0zQ3JK?=
 =?utf-8?B?K2ZRdEJSR0NQSnlPQk1meTN3dk0vbGViNS9KSFAvd1MzMmJjRWZDays0S083?=
 =?utf-8?B?U2FWaXYyUUlyUC81aTlUWHltVE9jbU9ETDlFTkEva04rS0tHVHBmS3hjKzJh?=
 =?utf-8?B?bEFDVjhQSTJrc2NDYjZQOUVaaDdaQXBPa2NONmVhRSs1bEJ1Lzdab1Y3ZGNI?=
 =?utf-8?B?NzhHVmxQRjJwZjluUmlkZ1dYY3luTGh5ZU9iTnJyMldKQnJIQmFIZkMwd2d4?=
 =?utf-8?B?dnpEL1BjU3hPTGRvempEeVRDRVcrTmoyb0JRalBpcXNvcEtOTVU5MVkzL2Zh?=
 =?utf-8?B?bWROQ3lrQVl4ZkZtQXBqVFVuT1hmcHp4NzlzR2ltZkU2a2tCL25lUHozcFls?=
 =?utf-8?B?MnB5Y3BzTTVVcm8wbkxnb0Z4aXdaU3pDenBXZFA4ZVpSY1dTUlJQVXowekFm?=
 =?utf-8?B?MHdXN0xLcTlWN3J1OGc3VFdBcTNyL0FHbGNkdGVKYVp2UlRmRlBzZHVFbUcr?=
 =?utf-8?B?cmlueWY5SC9hc3Qxa091Q1FYdkJ3dldWd2hDY0RKVVhaNmtzb3JFN0JrclRT?=
 =?utf-8?B?L3dzODdyQmliOUlland4YW1mb29tWkNVdUNhYkFyb3ZZS3RQc2ZneSs4M3M5?=
 =?utf-8?B?K0R1V2NzZ3g0UUhpVTlsVTdwRVdBazI2ckN1b2MxSFhmKzd3akoxeGd3NGdj?=
 =?utf-8?B?SkZEVHh5VjJwRDQ0Z2hqd2ozVU8rQVk4OTVlTytTN2lpSGV4TFhoc2pFRktC?=
 =?utf-8?B?U3BIdkEreU5vY1BTU1FhVHFiZVRVdmNEdWlzMTR2dmZrK05QM0hBMHV6clgw?=
 =?utf-8?B?VGMvdGVPT3BKOGR3N3k5SHlzRlREVWhQc1FveWd6b0dSK1Vsdk9DY0g4cjB6?=
 =?utf-8?B?TGVobzFXL2pIbE5KVVB1Y3hvcFExZ3gyeHlMUW1JTTlkQkptZ1F2WjVSNWU5?=
 =?utf-8?B?RU9TNUhFcXVWS0R4eEd2d0hUSmNZZEhBRmJhbnpEbUV3ZjhRWldKQXYwTWxL?=
 =?utf-8?B?L3ZVRS9wMnF2bDVOa1o0bzFEN3pZcUh3SG5kQU5mNkdYNGQwdndIWTlUOUIr?=
 =?utf-8?B?bU42eWJzSmRiZFhZMUJKbXNxaDhvaWlxMnM1NlloL1hOb2l2a2c5dUptaEdO?=
 =?utf-8?B?Mm5EUUQ0ZFNlQnl3ZktlRk9RNjFPZDVSMTYyNk8waThMWTVYNU5rbmxkM082?=
 =?utf-8?B?Z05pemJDblZTTkJ0MHRmNkl6aVdWRDFCVHBBYURnTkxvbGhKWjRwaUNrL3hV?=
 =?utf-8?B?aE1IUFVWNkVVVFZBVVhlZU16ZE12dXMxRjVtZVNWdWd0WlM4ZTM1L2NmbURz?=
 =?utf-8?B?SzVwM3FrVWUzVngzVEZMMlFqSG9kTU94VDhsdGM5VGJiQkNXWGMrYVB2NktQ?=
 =?utf-8?B?WU5kMzd5M2lRRkc2ZU5oSXBvdW1vc0U4cWdBKzg4YVArTG5LTVVtWW5ETGFr?=
 =?utf-8?B?NEx0T0pPd3FZZnZjY09NTjhOZVNpRDVlb09wcWYwUUxXelQ4NlA1TGZXUmhH?=
 =?utf-8?B?eTRVTjNiM1JJR25oc2xRcnhmRkkyays3dnc3QTkvSW1wMjRseWF6U3h3TXlO?=
 =?utf-8?B?WENaMzFHekJtREUvL2RLbVdJWXBKSXRCd21nUDZzZmxDeTFZZXNueU9GSGpZ?=
 =?utf-8?B?L3BqRDA4UjkvOGtBRDQvT3czaDkrRUtySWIydXZOcU9wR1UwSjJXNmhzRjcr?=
 =?utf-8?B?eURoK3BoYXZHRy90Y3QwTlg5RlpNa0U0bWJEQjNJVWNUUjZiVTBBc3VrZWU0?=
 =?utf-8?Q?fSwE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e414071-7730-43bc-6376-08da5e7d71d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 11:56:49.9792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0iPblfwkjYJOtCzdkYkCdUY63J2g9Hak+2J1F0F9TNgpotC1IL8xPBdDS28O++TcVPJ+YjZU22qti4pKo5jojQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6334
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bHkgNSwgMjAyMiAzOjU5IEFNDQo+IA0KPiANCj4gT24gNy80LzIwMjIgODo1
MyBQTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2Fu
Z0ByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEp1bHkgNCwgMjAyMiAxMjo0NyBBTQ0K
PiA+Pg0KPiA+Pg0KPiA+PiDlnKggMjAyMi83LzIgMDY6MDIsIFBhcmF2IFBhbmRpdCDlhpnpgZM6
DQo+ID4+Pj4gRnJvbTogWmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPg0KPiA+
Pj4+IFNlbnQ6IEZyaWRheSwgSnVseSAxLCAyMDIyIDk6MjggQU0NCj4gPj4+Pg0KPiA+Pj4+IFRo
aXMgY29tbWl0IGFkZHMgYSBuZXcgdkRQQSBuZXRsaW5rIGF0dHJpYnV0aW9uDQo+ID4+Pj4gVkRQ
QV9BVFRSX1ZEUEFfREVWX1NVUFBPUlRFRF9GRUFUVVJFUy4gVXNlcnNwYWNlIGNhbiBxdWVyeQ0K
PiA+PiBmZWF0dXJlcw0KPiA+Pj4+IG9mIHZEUEEgZGV2aWNlcyB0aHJvdWdoIHRoaXMgbmV3IGF0
dHIuDQo+ID4+Pj4NCj4gPj4+PiBGaXhlczogYTY0OTE3YmMyZTliIHZkcGE6IChQcm92aWRlIGlu
dGVyZmFjZSB0byByZWFkIGRyaXZlcg0KPiA+Pj4+IGZlYXR1cmUpDQo+ID4+PiBNaXNzaW5nIHRo
ZSAiIiBpbiB0aGUgbGluZS4NCj4gPj4+IEkgcmV2aWV3ZWQgdGhlIHBhdGNoZXMgYWdhaW4uDQo+
ID4+Pg0KPiA+Pj4gSG93ZXZlciwgdGhpcyBpcyBub3QgdGhlIGZpeC4NCj4gPj4+IEEgZml4IGNh
bm5vdCBhZGQgYSBuZXcgVUFQSS4NCj4gPj4+DQo+ID4+PiBDb2RlIGlzIGFscmVhZHkgY29uc2lk
ZXJpbmcgbmVnb3RpYXRlZCBkcml2ZXIgZmVhdHVyZXMgdG8gcmV0dXJuIHRoZQ0KPiA+Pj4gZGV2
aWNlDQo+ID4+IGNvbmZpZyBzcGFjZS4NCj4gPj4+IEhlbmNlIGl0IGlzIGZpbmUuDQo+ID4+Pg0K
PiA+Pj4gVGhpcyBwYXRjaCBpbnRlbnRzIHRvIHByb3ZpZGUgZGV2aWNlIGZlYXR1cmVzIHRvIHVz
ZXIgc3BhY2UuDQo+ID4+PiBGaXJzdCB3aGF0IHZkcGEgZGV2aWNlIGFyZSBjYXBhYmxlIG9mLCBh
cmUgYWxyZWFkeSByZXR1cm5lZCBieQ0KPiA+Pj4gZmVhdHVyZXMNCj4gPj4gYXR0cmlidXRlIG9u
IHRoZSBtYW5hZ2VtZW50IGRldmljZS4NCj4gPj4+IFRoaXMgaXMgZG9uZSBpbiBjb21taXQgWzFd
Lg0KPiA+Pj4NCj4gPj4+IFRoZSBvbmx5IHJlYXNvbiB0byBoYXZlIGl0IGlzLCB3aGVuIG9uZSBt
YW5hZ2VtZW50IGRldmljZSBpbmRpY2F0ZXMNCj4gPj4+IHRoYXQNCj4gPj4gZmVhdHVyZSBpcyBz
dXBwb3J0ZWQsIGJ1dCBkZXZpY2UgbWF5IGVuZCB1cCBub3Qgc3VwcG9ydGluZyB0aGlzDQo+ID4+
IGZlYXR1cmUgaWYgc3VjaCBmZWF0dXJlIGlzIHNoYXJlZCB3aXRoIG90aGVyIGRldmljZXMgb24g
c2FtZSBwaHlzaWNhbCBkZXZpY2UuDQo+ID4+PiBGb3IgZXhhbXBsZSBhbGwgVkZzIG1heSBub3Qg
YmUgc3ltbWV0cmljIGFmdGVyIGxhcmdlIG51bWJlciBvZiB0aGVtDQo+ID4+PiBhcmUNCj4gPj4g
aW4gdXNlLiBJbiBzdWNoIGNhc2UgZmVhdHVyZXMgYml0IG9mIG1hbmFnZW1lbnQgZGV2aWNlIGNh
biBkaWZmZXINCj4gPj4gKG1vcmUNCj4gPj4gZmVhdHVyZXMpIHRoYW4gdGhlIHZkcGEgZGV2aWNl
IG9mIHRoaXMgVkYuDQo+ID4+PiBIZW5jZSwgc2hvd2luZyBvbiB0aGUgZGV2aWNlIGlzIHVzZWZ1
bC4NCj4gPj4+DQo+ID4+PiBBcyBtZW50aW9uZWQgYmVmb3JlIGluIFYyLCBjb21taXQgWzFdIGhh
cyB3cm9uZ2x5IG5hbWVkIHRoZQ0KPiA+Pj4gYXR0cmlidXRlIHRvDQo+ID4+IFZEUEFfQVRUUl9E
RVZfU1VQUE9SVEVEX0ZFQVRVUkVTLg0KPiA+Pj4gSXQgc2hvdWxkIGhhdmUgYmVlbiwNCj4gPj4g
VkRQQV9BVFRSX0RFVl9NR01UREVWX1NVUFBPUlRFRF9GRUFUVVJFUy4NCj4gPj4+IEJlY2F1c2Ug
aXQgaXMgaW4gVUFQSSwgYW5kIHNpbmNlIHdlIGRvbid0IHdhbnQgdG8gYnJlYWsgY29tcGlsYXRp
b24NCj4gPj4+IG9mIGlwcm91dGUyLCBJdCBjYW5ub3QgYmUgcmVuYW1lZCBhbnltb3JlLg0KPiA+
Pj4NCj4gPj4+IEdpdmVuIHRoYXQsIHdlIGRvIG5vdCB3YW50IHRvIHN0YXJ0IHRyZW5kIG9mIG5h
bWluZyBkZXZpY2UNCj4gPj4+IGF0dHJpYnV0ZXMgd2l0aA0KPiA+PiBhZGRpdGlvbmFsIF9WRFBB
XyB0byBpdCBhcyBkb25lIGluIHRoaXMgcGF0Y2guDQo+ID4+PiBFcnJvciBpbiBjb21taXQgWzFd
IHdhcyBleGNlcHRpb24uDQo+ID4+Pg0KPiA+Pj4gSGVuY2UsIHBsZWFzZSByZXVzZSBWRFBBX0FU
VFJfREVWX1NVUFBPUlRFRF9GRUFUVVJFUyB0byByZXR1cm4NCj4gPj4gZm9yIGRldmljZSBmZWF0
dXJlcyB0b28uDQo+ID4+DQo+ID4+DQo+ID4+IFRoaXMgd2lsbCBwcm9iYWJseSBicmVhayBvciBj
b25mdXNlIHRoZSBleGlzdGluZyB1c2Vyc3BhY2U/DQo+ID4+DQo+ID4gSXQgc2hvdWxkbid0IGJy
ZWFrLCBiZWNhdXNlIGl0cyBuZXcgYXR0cmlidXRlIG9uIHRoZSBkZXZpY2UuDQo+ID4gQWxsIGF0
dHJpYnV0ZXMgYXJlIHBlciBjb21tYW5kLCBzbyBvbGQgb25lIHdpbGwgbm90IGJlIGNvbmZ1c2Vk
IGVpdGhlci4NCj4gQSBuZXRsaW5rIGF0dHIgc2hvdWxkIGhhcyBpdHMgb3duIGFuZCB1bmlxdWUg
cHVycG9zZSwgdGhhdCdzIHdoeSB3ZSBkb24ndCBuZWVkDQo+IGxvY2tzIGZvciB0aGUgYXR0cnMs
IG9ubHkgb25lIGNvbnN1bWVyIGFuZCBvbmx5IG9uZSBwcm9kdWNlci4NCj4gSSBhbSBhZnJhaWQg
cmUtdXNpbmcgKGZvciBib3RoIG1hbmFnZW1lbnQgZGV2aWNlIGFuZCB0aGUgdkRQQSBkZXZpY2Up
IHRoZSBhdHRyDQo+IFZEUEFfQVRUUl9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTIHdvdWxkIGxlYWQg
dG8gbmV3IHJhY2UgY29uZGl0aW9uLg0KPiBFLmcuLCBUaGVyZSBhcmUgcG9zc2liaWxpdGllcyBv
ZiBxdWVyeWluZyBGRUFUVVJFUyBvZiBhIG1hbmFnZW1lbnQgZGV2aWNlIGFuZA0KPiBhIHZEUEEg
ZGV2aWNlIHNpbXVsdGFuZW91c2x5LCBvciBjYW4gdGhlcmUgYmUgYSBzeW5jaW5nIGlzc3VlIGlu
IGEgdGljaz8NCkJvdGggY2FuIGJlIHF1ZXJpZWQgc2ltdWx0YW5lb3VzbHkuIEVhY2ggd2lsbCBy
ZXR1cm4gdGhlaXIgb3duIGZlYXR1cmUgYml0cyB1c2luZyBzYW1lIGF0dHJpYnV0ZS4NCkl0IHdv
bnQgbGVhZCB0byB0aGUgcmFjZS4NCg0KPiANCj4gSU1ITywgSSBkb24ndCBzZWUgYW55IGFkdmFu
dGFnZXMgb2YgcmUtdXNpbmcgdGhpcyBhdHRyLg0KDQpXZSBkb27igJl0IHdhbnQgdG8gY29udGlu
dWUgdGhpcyBtZXNzIG9mIFZEUEFfREVWIHByZWZpeCBmb3IgbmV3IGF0dHJpYnV0ZXMgZHVlIHRv
IHByZXZpb3VzIHdyb25nIG5hbWluZy4NCg==
