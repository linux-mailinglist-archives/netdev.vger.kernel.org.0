Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35EB679E26
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjAXQDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 11:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjAXQDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 11:03:48 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BE61CAC1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:03:47 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O8J2UT020973
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:03:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=wbr0/xfg7J5yNyko1cQ7TOFpSqltQFvB0WRtJAxIUkw=;
 b=cIWpBHZWwioerlazgEPRVmeoHnmvCiCPfyww8Ie/7YSoyla3j05VdAvhHN0dd+Qr0/a+
 vPAqFADcdMFfSGLR2Ieq24xSLX9hHDrl0XB/0xcLq9IgwUaZuPE/q1ZcoV0u1JhJJomN
 HX9mRXdAbphWhJDaztxiLQtXEA/wN+H67b7Ew1gEH1RIAa/BdkjAof03waJHT2vjGelt
 C6HcfVnUo2BSI1111HriMyRdMrx8PtAnevgp9H6cVzHxLGEWj1JdeS7mRhO5C+TODDbf
 TwcbOn37UsQUxw9zGqiyRhEaWlsCqzfL2ZyHJygC2GnrMp1CPvGtIqc6HUnwncrmeTg/ JQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n8ep4t61j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:03:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n//AnHm3J3XfyAbVApLOX+Y589Ezgi+oesV8PLkFuf+tPaeWrbQu6AOWzvWTl2p0fQ2M9kgmp4g9Q8ZCY4luiO17JjVQCLDWrXuftQ/br3uzVWr74pEfgCIVwNzpAOv0In6HDsjwtiL40ixEdeJXPailR7pb6LqE7K5azsHWeh2nSfpADK7//umQF1aVwcMirTzDQToyuAyBS02ezRhDv1C10zFY3+Ult1A+yi/W/P0aYYc4A5V17muhf09xOEbN9SCkcs1R0XJ2YXfBXex5Nh/iS8c1Fp3xyFqwOQGj4atVWZ2EL5MnJN7ZC2uJ6SkgSL8aNCYJjRkAGgnxH0Iflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbr0/xfg7J5yNyko1cQ7TOFpSqltQFvB0WRtJAxIUkw=;
 b=ZSr9g5osn1xxEsXHDulmkP8bLZLrFynf7xgdvhx1sdCLF0C+7Eu0Y45/vZXNpxNn5N557nwFVaCGx56igskB307S+0EmljBD3Tm1pIZwEJyIet0AQeUuS/tj4ersA4ZzLZFHtXsI4n5ZGDtnITybU1Cl4Wl1GtzprkjFKQDALeDeaX+MqWWOdaNeIsbTZ9mAGr/DxTzU3FOtJwkRklriMy/4nwCZAhORgRqVl5m+u0VhTBT0CSlAIFSOizK6fXa98rdxhSza0oH/M2A14liiOveKe+f2VcnEBPxpIM+w5kYhsHrHzvwIDYnlr77Z/YYlfe847C6UhhfYpQ5QV2Crqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by MW3PR15MB3833.namprd15.prod.outlook.com (2603:10b6:303:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:03:42 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa%8]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 16:03:42 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>
CC:     Vadim Fedorenko <vadfed@meta.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Topic: [PATCH net v2 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Index: AQHZL4gaUZVEkZ2Wu0KD7WGZdrWl+a6s9vUAgADE1YA=
Date:   Tue, 24 Jan 2023 16:03:42 +0000
Message-ID: <85fe01df-e194-2f3c-f20a-99a71051d1d9@meta.com>
References: <20230124000836.20523-1-vfedorenko@novek.ru>
 <20230124000836.20523-2-vfedorenko@novek.ru>
 <20230123201912.42bc89fc@kernel.org>
In-Reply-To: <20230123201912.42bc89fc@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|MW3PR15MB3833:EE_
x-ms-office365-filtering-correlation-id: 80e13ac9-c0bb-4226-6a9f-08dafe249061
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yLcvONXoFjGvFfgmi5Oo6Ze7kDeDLZvkxKE0OUdSQiIbKm1eobeTZh2YQM+pFxiDe5Ufqjq7H9sWC9d6HwtXwbNNZpBBLQmV2kz0D0JTwlQkjKLVX8tco7hqEI7dH4dmM6XMjHEfH6Qj6XpXxTquqNJA5VJLircMegTKBIQuV8hH+4OyYKSYTrsvUpDIw9KfYpvbaCiHGKubFxRM2a40SADVwdL1a+0wqnzQVnBCPWYHjqW6DPf4XksLn8R0em3l4PGLKQ0CynyPagO7NXQLv41ZiVmbqPU0DbpmiLDlzVd9oRvvjzcSaHnEjfk9Hfyra2+QTDn3VqDoUadnYaVAphAc1Ihe/xTLKT9JGYvlTy85/zIfi27hUT/S/4Cu7TWpSrn2y7gLH2i6JSxorolRznHH8WPpqY1Z1LpqD018IKK8XMhkX+fJCVI9NgELmw6eg2Qd4y+r93dgmgeEY1rrv5MTf3qxAk3ryCHqc4dFB8L9WyEOCnWzZeLQzv649H93CbhYwNgQh0aXA68TSZ2p7SKVCVYsDUOOui1TCCaqXAF1dV1xjO5ZwN9ygnN5wzAXK08zHL1cexQ5fm2i2XiIyn5Skh6o+gayvkuze7+Psqn9+ay9PejFbDVH+J23X5IEU+5EVEsatlqQmsQbjMoyA8Ls7SUmxWQPgk2BgQek6vDpLbqNHuq0aqUk6BhwXDiiZcQMpQwBkMxy4See51/s6CT+uaFbyamxbzEfC3rW6/o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199015)(38070700005)(31686004)(2616005)(31696002)(38100700002)(2906002)(41300700001)(122000001)(8936002)(5660300002)(8676002)(4326008)(6506007)(36756003)(54906003)(53546011)(316002)(71200400001)(83380400001)(66556008)(66476007)(76116006)(86362001)(66946007)(64756008)(91956017)(66446008)(110136005)(478600001)(6486002)(26005)(186003)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmNac0R4ODRZVmpsZ09nZlgyVWxHbWU4bytqYTVBanhWY2gvaERYWjlBWUJn?=
 =?utf-8?B?SXh5Y2tNYS81OXV2R0xBeXBCcCtvOUxzYXdodlJUWGhkaHBpSlhud3ZwK1Mr?=
 =?utf-8?B?RmxaRENaTGNTdVdvbVNQYW13UHZzMnY0RHczNFpGVTA4SmFxZkNjbWltSXFt?=
 =?utf-8?B?cjlUOVdXNkFUMHp3Sm8vVE9HS2JDNitXR0tFc3I2ZmZhSDV4aU1SR2FPMU9k?=
 =?utf-8?B?ckd6SVVFMXZNSFFVbDNEbUFmOFFBeWhNaVBlbzlpbzcvWFpIWGxQWVlHYTFs?=
 =?utf-8?B?cGdjYnJsTklCK0pQUjdTZkM3TW5KeTJlcjVPSEZCVHBkQm9UQkM3R3RMVjBy?=
 =?utf-8?B?WnFiK056T0kyQ0xySVJQS1hrSFl6RUh5RFV3ZDlCOVl4TEZudVdYVjdPZzRH?=
 =?utf-8?B?c01CdlZaOFlHQWVYRjYydUx5Y1cxYUJETGtmTThtZGtidFJRbjVuK0pWQjZ5?=
 =?utf-8?B?dmhpaEhsKzEySEFiK0p5OWVXU0duSTFtT2RGSVAwZmZRcEpoc3BmWm94T2NW?=
 =?utf-8?B?ZUNzcUlVNEMrMTlNeC8vSUpyRWEzL2hFeVFsNVl6alhVeGE4djNYbUJFb3ov?=
 =?utf-8?B?aWg3ajQ5ekE4VUwwd1QwTUkzZnpyQ0diN2JMMGx4cWgxcWZtcGhKWHJTaXBt?=
 =?utf-8?B?eVc0bmk1WDU1M0dveXBOc29qTjZKVWhyZTNaYU41Z1ZFZ0ZPN0w1QUUyZHNT?=
 =?utf-8?B?WkdjU0ppeVBHVTBodStzaEt5d3pNWWNIMHlPVjJJUFZGeGtmVlRJTDdIWWF5?=
 =?utf-8?B?bUh5M29icnpNeXcwVjVIbmdMN293Nlp4OHFrSDh5WndSWVpsbHFIc3k1dyt0?=
 =?utf-8?B?UU5nLzNxeHpLTU1SU1NTTGRPYllzUXM4SWY3dmc0bk16aytsZnRwODRKWnV0?=
 =?utf-8?B?TUdlY3kzQnZmd09LYVExNDZSaDFkcnEzcmlwakh3RFVrOG1ybE1PTUtvQ25R?=
 =?utf-8?B?Skp0RG9kSGh4SjIxQnJ4dXoxSEcrMHNMWjBiTnQyNDlycW12QkIvYWZzNk9G?=
 =?utf-8?B?Ymg4aFlkeDBPWitSU1lNN25mTEZtOFo3b1IwQ0N3L0ZMNzBEa3BEU3lFQ2RU?=
 =?utf-8?B?QWNDaklWb3M3cTNYVm9IRGFCTHQ3R3N4VFQzeWVtV0g3eTlydWNyckJKNCsr?=
 =?utf-8?B?bmtNN0N1eFczbHlFVEpPemdqYW1lM1JnZ3BhUDRZVmEwajd6YmhPeHhraHI4?=
 =?utf-8?B?ZnJnUDEzUlJIT1NzRlJkZkVvSGU3Vmc4YldSRnhhd2pqWnNWY014VWdRZVZo?=
 =?utf-8?B?d0gzajVoZHlzZHJDNitZTnBxWmpIZU1sc1NReklsZndISmFrbjRnTmxrRnc5?=
 =?utf-8?B?VitsMjduaHczSlVmSlNaa1RUZ0NUYnRNSkl5eC9uY1oyU29pdjJvY3RwUVZx?=
 =?utf-8?B?eGI3WUd2NEtFM0VROWF1VHpNczVKT0UrVTdpNHFOY3RGQ0xMOHc4R2s0V3hk?=
 =?utf-8?B?UEFGMUxYN2FFc1FRWC9SbHp2cFFJUUFQSWJjbXV0QU5xWUZqdFJrQjVxeGtV?=
 =?utf-8?B?Q0xIWEp5OVlIOGhpRjNrQXprVWQ0STBhSlc1UGhiRzZzNmg0TkZyUThZZEpi?=
 =?utf-8?B?THlIODEwWC9MSWtwNXI0S0ladGo5U1ZabjFPOGpCVUFMa2x3S0lsOFhEeE94?=
 =?utf-8?B?YTFsZ25mTXB4T3VsY1NRaDY5TU5hRmhQRXdjSFF0M3pOMkIwREFGZXROdDNB?=
 =?utf-8?B?Zy82Vm1kVmtzdGJTVmNNVFpOdGsrYUJGZWE5Vm1GN1JMWDNRSkpTK0FzWEVZ?=
 =?utf-8?B?QXovUW5MZE5uYkRaNmVTVEJ6T2YvbzJSYUp6cFYwSVZ3WlJTeFk0bkVCVU1O?=
 =?utf-8?B?aXg1bjEvVExDNy9rRjF1K3JBU1BBZWhBNUlCMFVXYzhkQzlXb3JCSFV2cGJK?=
 =?utf-8?B?dkVmbU5vV2VuaDc0bXlJSW8yZVhWa0VxOGNxR1NjTkpoMmU3WlAzNW1oNWlQ?=
 =?utf-8?B?VEE4NEZheHBIcVJVNk05SjZLZXhlVWE4a0prc0RaTjlramt4YXRvb0s4ak5r?=
 =?utf-8?B?MUpkTDJHR0NQRGZzQkt4bThIaXhhOVZZNFdHNWRCK2xCaEhXQ0JVSVdnRDZB?=
 =?utf-8?B?ZFA5Z3cydmVvNTN4UFVRRDAzU0IxS2wvQm9Xd1JFTzVsOVY1OVRKRnV1emxv?=
 =?utf-8?Q?kMNo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3679DBE1A05E4F449D72C816DA9E5C13@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e13ac9-c0bb-4226-6a9f-08dafe249061
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 16:03:42.0302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GuqRgQDvh9G0Qf8gKLhmWTFxWA1iAFD2pu9xSEdHac2h7EsdWcQAvSi350Tyljil
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3833
X-Proofpoint-GUID: mOVan2nb1c5a479RmkP-zAHFYrRBLq8l
X-Proofpoint-ORIG-GUID: mOVan2nb1c5a479RmkP-zAHFYrRBLq8l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDEvMjAyMyAwNDoxOSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFR1ZSwgMjQg
SmFuIDIwMjMgMDM6MDg6MzUgKzAzMDAgVmFkaW0gRmVkb3JlbmtvIHdyb3RlOg0KPj4gRnJvbTog
VmFkaW0gRmVkb3JlbmtvIDx2YWRmZWRAbWV0YS5jb20+DQo+Pg0KPj4gRmlmbyBwb2ludGVycyBh
cmUgbm90IGNoZWNrZWQgZm9yIG92ZXJmbG93IGFuZCB0aGlzIGNvdWxkIHBvdGVudGlhbGx5DQo+
PiBsZWFkIHRvIG92ZXJmbG93IGFuZCBkb3VibGUgZnJlZSB1bmRlciBoZWF2eSBQVFAgdHJhZmZp
Yy4NCj4+DQo+PiBBbHNvIHRoZXJlIHdlcmUgYWNjaWRlbnRhbCBPT08gY3FlIHdoaWNoIGxlYWQg
dG8gYWJzb2x1dGVseSBicm9rZW4gZmlmby4NCj4+IEFkZCBjaGVja3MgdG8gd29ya2Fyb3VuZCBP
T08gY3FlIGFuZCBhZGQgY291bnRlcnMgdG8gc2hvdyB0aGUgYW1vdW50IG9mDQo+PiBzdWNoIGV2
ZW50cy4NCj4gDQo+IE1heSBiZSB3b3J0aCBhZGRpbmcgYSBtZW50aW9uIG9mIHRoZSBicm9rZW5u
ZXNzIG9mIHRoZSBlbXB0eSgpIGNoZWNrLg0KPiBDb21wYXJpbmcgZnJlZSBydW5uaW5nIGNvdW50
ZXJzIHdvcmtzIHdlbGwgdW5sZXNzIEMgcHJvbW90ZXMgdGhlIHR5cGVzDQo+IHRvIHNvbWV0aGlu
ZyB3aWRlciB0aGFuIHRoZSBjb3VudGVycyB0aGVtc2VsdmVzLiBTbyB1bnNpZ25lZCBvciB1MzIN
Cj4gd29ya3MsIGJ1dCBjb21wYXJpbmcgdHdvIHUxNnMgb3IgdThzIG5lZWRzIGEgZXhwbGljaXQg
Y2FzdC4NCj4gDQpZZXAsIHN1cmUsIHdpbGwgYWRkIGl0IHRvIHRoZSBuZXh0IHZlcnNpb24NCg0K
Pj4gLXN0YXRpYyB2b2lkIG1seDVlX3B0cF9za2JfZmlmb190c19jcWVfcmVzeW5jKHN0cnVjdCBt
bHg1ZV9wdHBzcSAqcHRwc3EsIHUxNiBza2JfY2MsIHUxNiBza2JfaWQpDQo+PiArc3RhdGljIGJv
b2wgbWx4NWVfcHRwX3NrYl9maWZvX3RzX2NxZV9yZXN5bmMoc3RydWN0IG1seDVlX3B0cHNxICpw
dHBzcSwgdTE2IHNrYl9jYywgdTE2IHNrYl9pZCkNCj4+ICAgew0KPj4gICAJc3RydWN0IHNrYl9z
aGFyZWRfaHd0c3RhbXBzIGh3dHMgPSB7fTsNCj4+ICAgCXN0cnVjdCBza19idWZmICpza2I7DQo+
PiAgIA0KPj4gICAJcHRwc3EtPmNxX3N0YXRzLT5yZXN5bmNfZXZlbnQrKzsNCj4+ICAgDQo+PiAt
CXdoaWxlIChza2JfY2MgIT0gc2tiX2lkKSB7DQo+PiAtCQlza2IgPSBtbHg1ZV9za2JfZmlmb19w
b3AoJnB0cHNxLT5za2JfZmlmbyk7DQo+PiArCWlmIChza2JfY2MgPiBza2JfaWQgfHwgUFRQX1dR
RV9DVFIySURYKHB0cHNxLT5za2JfZmlmb19wYykgPCBza2JfaWQpIHsNCj4gDQo+IEFyZSB5b3Ug
c3VyZSB0aGlzIHdvcmtzIGZvciBhbGwgY2FzZXM/DQo+IERpcmVjdGx5IGNvbXBhcmluZyBpbmRl
eGVzIG9mIGEgcmluZyBidWZmZXIgc2VlbXMgZGFuZ2Vyb3VzLg0KPiBXZSdkIG5lZWQgdG8gY29t
cGFyZSBsaWtlIHRoaXM6DQo+IA0KPiAJKHMxNikoc2tiX2NjIC0gc2tiX2lkKSA8IDANCj4NCg0K
SGVyZSBJIHdvdWxkIGxpa2UgdG8gY291bnQgKGFuZCBza2lwIHJlLXN5bmNpbmcpIGFsbCB0aGUg
cGFja2V0cyB0aGF0IA0KYXJlIG5vdCBnb2luZyB0byBiZSBpbiBGSUZPLiBZb3VyIHN1Z2dlc3Rp
b24gd2lsbCBub3Qgd29yayBmb3IgdGhlIA0Kc2ltcGxlc3QgZXhhbXBsZS4gSW1hZ2luZSB3ZSBo
YXZlIEZJRk8gZm9yIDE2IGVsZW1lbnRzLCBhbmQgY3VycmVudCANCmNvdW50ZXJzIGFyZToNCiAg
KGNvbnN1bWVyKSBza2JfY2MgPSAxMywgKHByb2R1Y2VyKSBza2JfcGMgPSAxNSwgc28gMyBwYWNr
ZXRzIGFyZSBpbi4NClRoZW4gc2tiX2lkID0gMTAgYXJyaXZlcyBvdXQtb2Ytb3JkZXIuIEl0IHdp
bGwgYmUgY291bnRlZCBiZWNhdXNlIG9mIA0KKHNrYl9jYyA+IHNrYl9pZCksIGJ1dCB3aWxsIG5v
dCBiZSBjYXRjaGVkIGJ5IChza2JfY2MgLSBza2JfaWQpIDwgMC4NClRvIGNvdmVyIGFsbCBvdGhl
ciBjYXNlcyBsZXQncyBjb250aW51ZS4gTGV0J3MgdGhpbmsgdGhhdCAyIG1vcmUgcGFja2V0cyAN
CmxhbmRlZCBpbiB0aGUgcXVldWUsIG5vdyB3ZSBoYXZlIHNrYl9jYyA9IDEzLCBza2JfcGMgPSAx
IChiZWNhdXNlIG9mIA0Kd3JhcGFyb3VuZCkuIHNrYl9pZCA9IDExIGNvbWVzIGFuZCBpdCdzIHN0
aWxsIG91dCBvZiBvcmRlciBhbmQgd2lsbCBiZSANCmNhdGNoZWQgYnkgdGhlIHNhbWUgY2hlY2su
IFRoZW4gbGV0J3MgYXNzdW1lIHRoYXQgc2tiX2lkIDEzLDE0LDE1IA0KYXJyaXZlZCBhbmQgbW92
ZWQgb3VyIGNvbnN1bWVyIHBvaW50ZXIsIG5vdyB3ZSBoYXZlIHNrYl9jYyA9IDAsIHNrYl9wYyA9
IA0KMS4gSWYgc2tiX2lkID0gMTIgYXJyaXZlcywgaXQgd2lsbCBiZSBjYXRjaGVkIGJ5IA0KUFRQ
X1dRRV9DVFIySURYKHB0cHNxLT5za2JfZmlmb19wYykgPCBza2JfaWQuDQoNClNvIEkgYmVsaWV2
ZSB3ZSBzaG91bGQgYmUgZmluZSBoZXJlIGFuZCBjYXRjaCBhbGwgb3V0LW9mLW9yZGVyIChvbGRl
ciANCnRoYW4gc2tiX2NjKSBza2JzLg0KDQo+PiArCQlwdHBzcS0+Y3Ffc3RhdHMtPm9vb19jcWUr
KzsNCj4+ICsJCXJldHVybiBmYWxzZTsNCj4+ICsJfQ0KPiANCj4+IEBAIC0xMjgsNyArMTQxLDgg
QEAgc3RhdGljIHZvaWQgbWx4NWVfcHRwX2hhbmRsZV90c19jcWUoc3RydWN0IG1seDVlX3B0cHNx
ICpwdHBzcSwNCj4+ICAgCXB0cHNxLT5jcV9zdGF0cy0+Y3FlKys7DQo+PiAgIA0KPj4gICBvdXQ6
DQo+PiAtCW5hcGlfY29uc3VtZV9za2Ioc2tiLCBidWRnZXQpOw0KPj4gKwlpZiAoc2tiKQ0KPj4g
KwkJbmFwaV9jb25zdW1lX3NrYihza2IsIGJ1ZGdldCk7DQo+IA0KPiBJIHRoaW5rIG5hcGlfY29u
c3VtZV9za2IoKSB0YWtlcyBOVUxMcy4NCg0KWWVwLCB3aWxsIHJlbW92ZSB0aGlzIHBpZWNlLg0K
