Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797DC512BE5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 08:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbiD1GwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 02:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244368AbiD1GwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 02:52:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E319859D;
        Wed, 27 Apr 2022 23:48:54 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23S49dDX032177;
        Wed, 27 Apr 2022 23:48:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0aWCBP2CT5iC6HqwCWFrxu0cWUIHPt7p+Bupx384I1w=;
 b=Cd/87CkvSMAf3/y6ryb81VbultwLT9gwLjoGKZ7meYngrZdYM0aHNja/HoKhWwcolr1H
 UJpi9WfiwThlUjI9NFxP546ziKgkteYA+j9P/K3o4T6UuwO69KdVfbLgk0zjobWPeqf6
 4R8US31hZ59rLbEjQJwXC/ib6tbQl3/uvwI= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fqkncrh5v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 23:48:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obE1aMWi16dtfrTfvBhMqNB3uBtEs1ODAxWXQKP1sYbNIuVQHs29zAVMpOfNCOggYVkHnJeYDq9I8LLzOGYyGDtW7pW+hJpwExKeMKZvGmfnUGm5hHp/w4RKPh/JmjFLzhrKcZmO/Zof09BivyhCsIyUAqo1Krdyj/rmq42as1e1uwHt3q2lZ7stWnaqSgQyHM61MzIMv2bUXGCpAif5L9fIKKpoFeMM6y3de4RfBP4dCjIuQkHunNl/eyLSTPP7HWo7eQHnmTE3xTOtw0Xk4GcEbSqgWa7s11lhWAM60k6YeFTEQzgWt257BIn5LgGsVr81GQtmm4UsvyJE/Wp4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aWCBP2CT5iC6HqwCWFrxu0cWUIHPt7p+Bupx384I1w=;
 b=lVy7DYYhY8e2l6cs66Hawq9MXhwhAeuKkgDtT9g0gyvvquL/CULUycKFrEL30tp7gO/w1SUUm/n3DMwrtOxttpqkc9+DS7QVZBnqKYuzjuJwr0eepX1nZaETWtQVyyc/np6DZHtF6xKrXHWx9U8NfC+zh1uB3nwCEGns5zvVgA782W3l9+OdYXZMArFBhfq4TS73cfJT2j02M0a7kYkq84sUu9rUicMlHetsnWm7GtUPmwIdhhNYTAIRFJzLjEuBErqkBQu5olohQ6kWDweB/5VpskXIOVNFLggLKpHEJQXQbENVxFDip4UHEGI0RVptkxBjrQoiwFNr8nFXDXhRMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB3970.namprd15.prod.outlook.com (2603:10b6:208:271::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 28 Apr
 2022 06:48:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::15bd:ee6f:cffa:44d8]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::15bd:ee6f:cffa:44d8%7]) with mapi id 15.20.5206.014; Thu, 28 Apr 2022
 06:48:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf v2 0/3] bpf: invalidate unused part of bpf_prog_pack
Thread-Topic: [PATCH bpf v2 0/3] bpf: invalidate unused part of bpf_prog_pack
Thread-Index: AQHYWOUphDgBQzjiX0ac6c+Sg/0OBq0EVWkAgAA8D4CAAFTGAA==
Date:   Thu, 28 Apr 2022 06:48:51 +0000
Message-ID: <57DBEBDB-71AF-4A85-AB8D-8274541E0F3C@fb.com>
References: <20220425203947.3311308-1-song@kernel.org>
 <FF2E0EC1-F9D6-4196-8887-919207BDC599@fb.com>
 <CAHk-=wgA1Uku=ejwknv11ssNhz2pswhD=mJFBPEMQtCspz0YEQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgA1Uku=ejwknv11ssNhz2pswhD=mJFBPEMQtCspz0YEQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17cf2906-9d36-4efe-087c-08da28e327a0
x-ms-traffictypediagnostic: BLAPR15MB3970:EE_
x-microsoft-antispam-prvs: <BLAPR15MB3970E70D2E8E2031C7D878A5B3FD9@BLAPR15MB3970.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OTuqB8fG6KB2QLtKbqYARH2/BFQFkORjyIk2Qw3fSWL4rSLVub8lz5OPr1q0WAFTkbqgg5e3WFBe7wfRH3Bo3SKSZ7N8WWnSArTplT2Tw/Q+Xe6WNbhWDGJHCkQmy6ynuhef+PCWDzR2OVetSgwaFht1ZomlQERFwGpre0mLpoAQwMSV/SeZg0xcaqyxP7xoCh+HUC3gnmMhZOEnj8CnAFv7jWlqcrXv4X8FVhYS8IuIW837VPQnHV63cE2iT1EouCJRYGNZwxVFIN20GziR1U4mMZrP5+X85jKpQByQt5e8qg64d0AlnntHq7CCj2la6B5pg1uHCRQgkyHrwYTb+455hbhtydeKvhVt6wb/eedoEWXWu9WH8hpLmCG0NuVvXbd51wbtnM6XcVHs9ZIGxPGVGiN1e3HmSWUadrVISuyF0DXYhv6Xqlq0iXF0i+zxh144iaDtPfXJBHU2ulIpy/aCHn3OVd8zfiLbmkCLddMknyQXec+qCHK0gSDbeUSXhaI5zrfxAbdOa5NqM7hawrzljHG8UzotPZGeE01BYYWye8/32tNNb5Yc/WGcKr0h5R5nHLCzexaLNOi9bArCiPYcgJ73WVXHQji1iBKQRnpT14FE0P1f3T52hmdkoanJL00G9L21wyuws1Nprn9lvUve2iTD/w9DZ24Vq0jOpkrXprqTUre3qN9M6GeSJoOPurA+zzhPJ9NZG3vHSAyZKKuVvmdvCdr65jY0vW8FMOSjnVR8I2B+85ws+Bi9+FU7zBKrrvvV05Sc4RarLYjAtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66476007)(66556008)(186003)(8676002)(316002)(91956017)(64756008)(66446008)(76116006)(6512007)(86362001)(71200400001)(33656002)(53546011)(6506007)(54906003)(6916009)(2616005)(36756003)(6486002)(5660300002)(8936002)(508600001)(7416002)(38070700005)(83380400001)(38100700002)(2906002)(122000001)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2VDWk5ZS2ZLNkIrZ0hWeFJGS0V0aUYvWDZSSHBCWWZNMXVGVXF0cDBYV0NB?=
 =?utf-8?B?T1N0T3pxVGtqZmROYXU0QlhxWXJtQUI5WWpzWmRFNXlUVlhQZUk4dlIrUEJM?=
 =?utf-8?B?dVVBcndwVlNRN1Y1SkgyU2hBdElOYk5wdTYwN2NzbjJKVS9PZnJPY2Q4YVBT?=
 =?utf-8?B?bEpmSWxSaHAraE9LNDA0NjNWNnN4UUdGY1VPYkFOeXB4MExnT0VGYTlJSUg3?=
 =?utf-8?B?djZwalBCR0svNzJQbThFQWQzMm9zOWtyZnVtREVPU1RiQ1BUQ01ZdkNSNmVw?=
 =?utf-8?B?dE82YjlXOG5DSEM0VXBhZGdSSTFtbnVkSVRQbXQwNVBZYjRCYm1zc0FWTWp5?=
 =?utf-8?B?NUg5VUZOQ1NTQitmWFcvd1JEMTJxU1RHbk9KTzg4VC9YK3BWa2Vpc0ZoYVZv?=
 =?utf-8?B?aUNYM3ZPUklTakFqMFBMa0d6L1VFQS9SZ2xiZmg3TWFjcnZKUERDRlUzVU1K?=
 =?utf-8?B?YW1va0wrV09GaGNqVGg3WWIxQkRaMkR5UEtqTGVJSVkyN0RpMWtENDc4b1Ru?=
 =?utf-8?B?MVd6UGJSVjNWYjNnVExlSWV4WUE2b3JWZnpYZGFhK0xsOFRFUUZVOVdOb0JT?=
 =?utf-8?B?TVJoTUNQb1RaVDFhN0VrSGxWT1FkdDVjSXNWNDlNU08wWng5WGNMcENxT3Fi?=
 =?utf-8?B?Rk03UjZubHJLZEc0RGlOeXFtcXFmeFdJTkI3R2pRZHNBQ3dRY2t3a2V5cWxQ?=
 =?utf-8?B?TFlQOCs5ZHZYdENOcXBQZ25sNjNlY2JkL1N2NWVHNzdGL3hCNXZ5aXBicnB5?=
 =?utf-8?B?bExXSml4a0NUT2l2SzJiYnJJNmVmU3gvOGgvQ1lYa1Y5S2ppaGZFaEpLSHls?=
 =?utf-8?B?TWV6a0M3ZzRuYTMycGRjdmVnSlh0bEVBd3NqSHVIbEc1U0kwM2JtWjBUTEQy?=
 =?utf-8?B?bXd6SnhzMU9WVGpOT2E2UVBTZDBGdHVWRnZ4SGtxOEFwMlVYNURXR25wbHBw?=
 =?utf-8?B?UGVGTlNLOU42ODRFRXdoS1hGeHFKaU1hekUxcDRKcXJjZFlkRk5NblpiWCsr?=
 =?utf-8?B?U0lNRjM0Q3pEY20wZE5zL2g4Y2w4U1lWd1Qya0QrVm1WeGFSbHlKL25VMkpF?=
 =?utf-8?B?cGhoMlZSaFAxVkpzWXpuL1V5Umhkd3htQm9Sa1JWY1F2YmtDdHIvbWRQdnZk?=
 =?utf-8?B?OVc2L3o4dXo4Z3FzQXJpSnhJMjJzVnNwKzlyZHdPck9OWmVGRUZBR1FHK1NI?=
 =?utf-8?B?Y1RKQzlJWFdESDdnOHZkM01GcGZBMlNOWWN3TXNhZFU0WVlFYkhFQ0ZmbTFM?=
 =?utf-8?B?SFNuejJ3dFVNRzdVTzh5S3IvUDlCTmdxejZvL0FjQ1FLUmhuY0paamdGeWhl?=
 =?utf-8?B?NjVCVDJHcGZCUGcrSUdRUkJnbWY5emNyVGxFQXZHM0R5RUx4bmhGbC9CZkNz?=
 =?utf-8?B?MDdWVEpBVTcwaUsyQlA5dnpEVW9rQ3JsUjBuYlNUaGJIbWJDcklIQlBMbzM0?=
 =?utf-8?B?dXBhdEZVT2w4bkNnSEQ1bXRsdnFDZVBvL2taVG9EREJxbFNXNU9GZUxna2c0?=
 =?utf-8?B?WXR5bUswZzAzL1FwWERKZTVKM2RHT1lPaUtUS0VxUGFYbUdLbHQxVDh1RlBj?=
 =?utf-8?B?N3p3bDFHbHhRK0dwdHBuOWROVU13c0hZYXhsRldlQ2F1RmlUOHZMRWhZL2Y3?=
 =?utf-8?B?akNZeWF0NFJrejFvRlRhSGF3SUFXQnpHbkFBd0cvN2FqeTRweXJ3bXBpRHhC?=
 =?utf-8?B?dndnWlJxdkhVRXU0S1A5cHZSRzZHY0p3UzZnKzcrL2xleVlJR3VSRHNZOGJY?=
 =?utf-8?B?NVBkZkQyOWNZMlgvTWdPUmxRMjZJMDZBVldxM1dtRjdxUjF0MjVtc0FrNmtD?=
 =?utf-8?B?QWMrRTk5TDZHaXJrUnM0cDdnVCswZ2lkWFdPSW1aalI5WGgweThhdVpPL2E5?=
 =?utf-8?B?VlM4SHFmWlE3bFV5eVgwa05Yais3cDVjeiswNWdFckNCM3NPTXhWeWlOdzA3?=
 =?utf-8?B?YjlvZS9EenNheEJJTzM3ZnVuQzRiVVVoSFJmSzNwUkFnMGZqd0F2bTJodDll?=
 =?utf-8?B?STMwTEhnZWh5blZ3S0ErYkZ4TWFtVjZKQXp6YkJjRS9OS04xYlpiamxybjEz?=
 =?utf-8?B?SlBnK2lyNU5DRjk5Rk9FK1lLVTg2Y2krMXJDZzVib2FSTWJUWkpFNXQ0eVZM?=
 =?utf-8?B?YW9NdkcyUW51aUNhNXp0MTh4WnVjcGFyZEpsMU04UEVBSnVhem5MK3lkbXg5?=
 =?utf-8?B?OGc2WEJUWWxIeWxPWjlQQXdISTZsSUhxOURKanFOcHNZcDZaeE1keDdvTFBW?=
 =?utf-8?B?Vk1VTU41eWN6RWdEOERoTksvQ0xSRy91RzRlNWxFdk1haWhYK1lUclZmZ2d1?=
 =?utf-8?B?R2I2OURGZVRHTVJaOTV1MGV6ZHN3NmpCcEwrbGdrVmVPNXBQS3dXQUpXNUpV?=
 =?utf-8?Q?7ZGGJhWVQtnUzp2qCQHvrUXGihDpoH5EfyL63?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <774754A887715B428DA4922DF25C187E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17cf2906-9d36-4efe-087c-08da28e327a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 06:48:51.3208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rv3YU4+/v3OLldMPvQCgNSqYjOxHFj4ywoptPcIXwdTKR4MAKiXmbjDIFPumWd7nYx/oSLRzz3qmBYgWXNLySQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3970
X-Proofpoint-ORIG-GUID: 8QTUVe7yYyxGuXsEVsb3_3B-jqpuI0m-
X-Proofpoint-GUID: 8QTUVe7yYyxGuXsEVsb3_3B-jqpuI0m-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTGludXMsIA0KDQpUaGFua3MgZm9yIHlvdXIgdGhvcm91Z2ggYW5hbHlzaXMgb2YgdGhlIHNp
dHVhdGlvbiwgd2hpY2ggbWFrZSBhIGxvdCBvZg0Kc2Vuc2UuIA0KDQo+IE9uIEFwciAyNywgMjAy
MiwgYXQgNjo0NSBQTSwgTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24u
b3JnPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgQXByIDI3LCAyMDIyIGF0IDM6MjQgUE0gU29uZyBM
aXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4gd3JvdGU6DQo+PiANCj4+IENvdWxkIHlvdSBwbGVh
c2Ugc2hhcmUgeW91ciBzdWdnZXN0aW9ucyBvbiB0aGlzIHNldD8gU2hhbGwgd2Ugc2hpcCBpdA0K
Pj4gd2l0aCA1LjE4Pw0KPiANCj4gSSdkIHBlcnNvbmFsbHkgcHJlZmVyIHRvIGp1c3Qgbm90IGRv
IHRoZSBwcm9nX3BhY2sgdGhpbmcgYXQgYWxsLCBzaW5jZQ0KPiBJIGRvbid0IHRoaW5rIGl0IHdh
cyBhY3R1YWxseSBpbiBhICJyZWFkeSB0byBzaGlwIiBzdGF0ZSBmb3IgdGhpcw0KPiBtZXJnZSB3
aW5kb3csIGFuZCB0aGUgaHVnZXBhZ2UgbWFwcGluZyBwcm90ZWN0aW9uIGdhbWVzIEknbSBzdGls
bA0KPiBsZWVyeSBvZi4NCj4gDQo+IFllcywgdGhlIGh1Z2VwYWdlIHByb3RlY3Rpb24gdGhpbmdz
IHByb2JhYmx5IGRvIHdvcmsgZnJvbSB3aGF0IEkgc2F3DQo+IHdoZW4gSSBsb29rZWQgdGhyb3Vn
aCB0aGVtLCBidXQgdGhhdCB4ODYgdm1hbGxvYyBodWdlcGFnZSBjb2RlIHdhcw0KPiByZWFsbHkg
ZGVzaWduZWQgZm9yIGFub3RoZXIgdXNlIChub24tcmVmY291bnRlZCBkZXZpY2UgcGFnZXMpLCBz
byB0aGUNCj4gZmFjdCB0aGF0IGl0IGFsbCBhY3R1YWxseSBzZWVtcyBzdXJwcmlzaW5nbHkgb2sg
Y2VydGFpbmx5IHdhc24ndA0KPiBiZWNhdXNlIHRoZSBjb2RlIHdhcyBkZXNpZ25lZCB0byBkbyB0
aGF0IG5ldyBjYXNlLg0KPiANCj4gRG9lcyB0aGUgcHJvZ19wYWNrIHRoaW5nIHdvcmsgd2l0aCBz
bWFsbCBwYWdlcz8NCj4gDQo+IFllcy4gQnV0IHRoYXQgd2Fzbid0IHdoYXQgaXQgd2FzIGRlc2ln
bmVkIGZvciBvciBpdHMgc2VsbGluZyBwb2ludCwgc28NCj4gaXQgYWxsIGlzIGEgYml0IHN1c3Bl
Y3QgdG8gbWUuDQoNCnByb2dfcGFjayBvbiBzbWFsbCBwYWdlcyBjYW4gYWxzbyByZWR1Y2UgdGhl
IGRpcmVjdCBtYXAgZnJhZ21lbnRhdGlvbi4NClRoaXMgaXMgYmVjYXVzZSBsaWJicGYgdXNlcyB0
aW55IEJQRiBwcm9ncmFtcyB0byBwcm9iZSBrZXJuZWwgZmVhdHVyZXMuIA0KQmVmb3JlIHByb2df
cGFjaywgYWxsIHRoZXNlIEJQRiBwcm9ncmFtcyBjYW4gZnJhZ21lbnQgdGhlIGRpcmVjdCBtYXAu
DQpGb3IgZXhhbXBsZSwgcnVucXNsb3dlciAodG9vbHMvYnBmL3J1bnFzbG93ZXIvKSBsb2FkcyB0
b3RhbCA3IEJQRiBwcm9ncmFtcyANCigzIGFjdHVhbCBwcm9ncmFtcyBhbmQgNCB0aW55IHByb2Jl
IHByb2dyYW1zKS4gQWxsIHRoZXNlIHByb2dyYW1zIG1heSANCmNhdXNlIGRpcmVjdCBtYXAgZnJh
Z21lbnRhdGlvbi4gV2l0aCBwcm9nX3BhY2ssIE9UT0gsIHRoZXNlIEJQRiBwcm9ncmFtcyANCndv
dWxkIGZpdCBpbiBhIHNpbmdsZSBwYWdlIChvciBldmVuIHNoYXJlIHBhZ2VzIHdpdGggb3RoZXIg
dG9vbHMpLiANCg0KPiANCj4gQW5kIEknbSBsb29raW5nIGF0IHRob3NlIHNldF9tZW1vcnlfeHl6
KCkgY2FsbHMsIGFuZCBJJ20gZ29pbmcgInllYWgsDQo+IEkgdGhpbmsgaXQgd29ya3Mgb24geDg2
LCBidXQgb24gcHBjIEkgbG9vayBhdCBpdCBhbmQgSSBzZWUNCj4gDQo+ICBzdGF0aWMgaW5saW5l
IGludCBzZXRfbWVtb3J5X3JvKHVuc2lnbmVkIGxvbmcgYWRkciwgaW50IG51bXBhZ2VzKQ0KPiAg
ew0KPiAgICAgICAgcmV0dXJuIGNoYW5nZV9tZW1vcnlfYXR0cihhZGRyLCBudW1wYWdlcywgU0VU
X01FTU9SWV9STyk7DQo+ICB9DQo+IA0KPiBhbmQgdGhlbiBpbiBjaGFuZ2VfbWVtb3J5X2F0dHIo
KSBpdCBkb2VzDQo+IA0KPiAgICAgICAgaWYgKFdBUk5fT05fT05DRShpc192bWFsbG9jX29yX21v
ZHVsZV9hZGRyKCh2b2lkICopYWRkcikgJiYNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaXNf
dm1fYXJlYV9odWdlcGFnZXMoKHZvaWQgKilhZGRyKSkpDQo+ICAgICAgICAgICAgICAgIHJldHVy
biAtRUlOVkFMOw0KPiANCj4gYW5kIEknbSAidGhpcyBpcyBhbGwgc3VwcG9zZWRseSBnZW5lcmlj
IGNvZGUsIGJ1dCBJJ20gbm90IHNlZWluZyBob3cNCj4gaXQgd29ya3MgY3Jvc3MtYXJjaGl0ZWN0
dXJlIi4NCg0KQUZBSUNULCB3ZSBoYXZlIHNwZW50IHRoZSB0aW1lIGFuZCBlZmZvcnQgdG8gZGVz
aWduIGJwZl9wcm9nX3BhY2sgdG8gDQp3b3JrIGNyb3NzLWFyY2hpdGVjdHVyZS4gSG93ZXZlciwg
c2luY2UgcHJvZ19wYWNrIHJlcXVpcmVzIHJlbGF0aXZlbHkgDQpuZXcgYnVpbGRpbmcgYmxvY2tz
IGluIG11bHRpcGxlIGxheWVycyAodm1hbGxvYywgc2V0X21lbW9yeV9YWFgsIA0KYnBmX2ppdCwg
ZXRjLiksIG5vbi14ODYgYXJjaGl0ZWN0dXJlcyBoYXZlIG1vcmUgbWlzc2luZyBwaWVjZXMuIA0K
DQpUaGUgZmFjdCB0aGF0IHdlIGNhbm5vdCByZWx5IG9uIHNldF92bV9mbHVzaF9yZXNldF9wZXJt
cygpIGZvciBodWdlIA0KcGFnZXMgb24geDg2IGRvZXMgbGVhayBzb21lIGFyY2hpdGVjdHVyYWwg
ZGV0YWlscyB0byBnZW5lcmljIGNvZGUuIA0KQnV0IEkgZ3Vlc3Mgd2UgZG9u4oCZdCByZWFsbHkg
bmVlZCB0aGUgaGFjayAoYnkgbm90IHVzaW5nIA0Kc2V0X3ZtX2ZsdXNoX3Jlc2V0X3Blcm1zLCBi
dXQgY2FsbGluZyBzZXRfbWVtb3J5XyBtYW51YWxseSkgZm9yIA0KcHJvZ19wYWNrIG9uIHNtYWxs
IHBhZ2VzPyANCg0KPiANCj4gSSAqdGhpbmsqIGl0J3MgYWN0dWFsbHkgYmVjYXVzZSB0aGlzIGlz
IGFsbCBiYXNpY2FsbHkgeDg2LXNwZWNpZmljIGR1ZQ0KPiB0byB4ODYgYmVpbmcgdGhlIG9ubHkg
YXJjaGl0ZWN0dXJlIHRoYXQgaW1wbGVtZW50cw0KPiBicGZfYXJjaF90ZXh0X2NvcHkoKSwgYW5k
IGV2ZXJ5Ym9keSBlbHNlIHRoZW4gZW5kcyB1cCBlcnJvcmluZyBvdXQgYW5kDQo+IG5vdCB1c2lu
ZyB0aGUgcHJvZ19wYWNrIHRoaW5nIGFmdGVyIGFsbC4NCj4gDQo+IEFuZCB0aGVuIG9uZSBvZiB0
aGUgdHdvIHBsYWNlcyB0aGF0IHVzZSBicGZfYXJjaF90ZXh0X2NvcHkoKSBkb2Vzbid0DQo+IGV2
ZW4gY2hlY2sgdGhlIHJldHVybmVkIGVycm9yIGNvZGUuDQo+IA0KPiBTbyB0aGlzIGFsbCBlbmRz
IHVwIGp1c3QgZGVwZW5kaW5nIG9uICJvbmx5IHg4NiB3aWxsIGFjdHVhbGx5IHN1Y2NlZWQNCj4g
aW4gYnBmX2ppdF9iaW5hcnlfcGFja19maW5hbGl6ZSgpLCBldmVyeWJvZHkgZWxzZSB3aWxsIGZh
aWwgYWZ0ZXINCj4gaGF2aW5nIGRvbmUgYWxsIHRoZSBjb21tb24gc2V0dXAiLg0KPiANCj4gRW5k
IHJlc3VsdDogaXQgYWxsIHNlZW1zIGEgYml0IGJyb2tlbiByaWdodCBub3cuIFRoZSAiZ2VuZXJp
YyIgY29kZQ0KPiBvbmx5IHdvcmtzIG9uIHg4NiwgYW5kIG9uIG90aGVyIGFyY2hpdGVjdHVyZXMg
aXQgZ29lcyB0aHJvdWdoIHRoZQ0KPiBtb3Rpb25zIGFuZCB0aGVuIGZhaWxzIGF0IHRoZSBlbmQu
IEFuZCBldmVuIG9uIHg4NiBJIHdvcnJ5IGFib3V0DQo+IGFjdHVhbGx5IGVuYWJsaW5nIGl0IGZ1
bGx5Lg0KPiANCj4gSSdtIG5vdCBoYXZpbmcgdGhlIHdhcm0gYW5kIGZ1enppZXMgYWJvdXQgdGhp
cyBhbGwsIGluIG90aGVyIHdvcmRzLg0KPiANCj4gTWF5YmUgcGVvcGxlIGNhbiBjb252aW5jZSBt
ZSBvdGhlcndpc2UsIGJ1dCBJIHRoaW5rIHlvdSBuZWVkIHRvIHdvcmsgYXQgaXQuDQo+IA0KPiBB
bmQgZXZlbiBmb3IgNS4xOSsga2luZCBvZiB0aW1lZnJhbWVzLCBJJ2QgYWN0dWFsbHkgbGlrZSB0
aGUgeDg2DQo+IHBlb3BsZSB3aG8gbWFpbnRhaW4gYXJjaC94ODYvbW0vcGF0L3NldF9tZW1vcnku
YyBhbHNvIHNpZ24gb2ZmIG9uDQo+IHVzaW5nIHRoYXQgY29kZSBmb3IgaHVnZXBhZ2Ugdm1hbGxv
YyBtYXBwaW5ncyB0b28uDQo+IA0KPiBJICp0aGluayogaXQgZG9lcy4gQnV0IHRoYXQgY29kZSBo
YXMgdmFyaW91cyBzdWJ0bGUgdGhpbmdzIGdvaW5nIG9uLg0KPiANCj4gSSBzZWUgUGV0ZXJaIGlz
IGNjJ2QgKHByZXN1bWFibHkgYmVjYXVzZSBvZiB0aGUgdGV4dF9wb2tlKCkgc3R1ZmYsIG5vdA0K
PiBiZWNhdXNlIG9mIHRoZSB3aG9sZSAiY2FsbCBzZXRfbWVtb3J5X3JvKCkgb24gdmlydHVhbGx5
IG1hcHBlZCBrZXJuZWwNCj4gbGFyZ2VwYWdlIG1lbW9yeSIuDQo+IA0KPiBEaWQgcGVvcGxlIGV2
ZW4gdGFsayB0byB4ODYgcGVvcGxlIGFib3V0IHRoaXMsIG9yIGRpZCB0aGUgd2hvbGUgIml0DQo+
IHdvcmtzLCBleGNlcHQgaXQgdHVybnMgb3V0IHNldF92bV9mbHVzaF9yZXNldF9wZXJtcygpIGRv
ZXNuJ3Qgd29yayINCj4gbWVhbiB0aGF0IHRoZSBhdXRob3JzIG9mIHRoYXQgY29kZSBuZXZlciBn
b3QgaW52b2x2ZWQ/DQoNCldlIGhhdmUgQ0MnZWQgeDg2IGZvbGtzIChhdCBsZWFzdCBvbiBzb21l
IHZlcnNpb25zKS4gQnV0IHdlIGhhdmVu4oCZdA0KZ290IG11Y2ggZmVlZGJhY2tzIHVudGlsIHJl
Y2VudGx5LiBXZSBzaG91bGQgZGVmaW5pdGVseSBkbyBiZXR0ZXIgDQp3aXRoIHRoaXMgaW4gdGhl
IGZ1dHVyZS4gDQoNCnNldF92bV9mbHVzaF9yZXNldF9wZXJtcyBpcyBjbGVhcmx5IGEgcHJvYmxl
bSBoZXJlLiBCdXQgaWYgd2UgZG9u4oCZdA0KdXNlIGh1Z2UgcGFnZSAoY3VycmVudCB1cHN0cmVh
bSArIHRoaXMgc2V0KSwgd2Ugc2hvdWxkbuKAmXQgbmVlZCB0aGF0DQp3b3JrYXJvdW5kLiANCg0K
T3ZlcmFsbCwgd2UgZG8gaG9wZSB0byBlbGltaW5hdGUgKG9yIHJlZHVjZSkgc3lzdGVtIHNsb3dk
b3duIGNhdXNlZCANCmJ5IGRpcmVjdCBtYXAgZnJhZ21lbnRhdGlvbi4gSWRlYWxseSwgd2Ugd2Fu
dCBhY2hpZXZlIHRoaXMgd2l0aCANCnNtYWxsIG51bWJlciBvZiBodWdlIHBhZ2VzLiBJZiBodWdl
IHBhZ2VzIGRvbuKAmXQgd29yayBoZXJlLCBzbWFsbCANCnBhZ2VzIHdvdWxkIGFsc28gaGVscC4g
R2l2ZW4gd2UgYWxyZWFkeSBkbyBzZXRfbWVtb3J5XygpIHdpdGggQlBGDQpwcm9ncmFtcyAoaW4g
YnBmX2ppdF9iaW5hcnlfbG9ja19ybyksIEkgdGhpbmsgdGhlIHJpc2sgd2l0aCBzbWFsbCANCnBh
Z2VzIGlzIHByZXR0eSBsb3cuIEFuZCB3ZSBzaG91bGQgc3RpbGwgc2VlIG5vbi10cml2aWFsIHBl
cmZvcm1hbmNlDQppbXByb3ZlbWVudCBmcm9tIDRrQiBicGZfcHJvZ19wYWNrIChJIGRvbuKAmXQg
aGF2ZSBmdWxsIGJlbmNobWFyaw0KcmVzdWx0cyBhdCB0aGUgbW9tZW50KS4gDQoNClRoYW5rcyBh
Z2FpbiwNClNvbmcNCg0KDQoNCg==
