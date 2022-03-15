Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0E4D9F98
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347393AbiCOQGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242578AbiCOQGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:06:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04CE2A27F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:04:56 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FFYnSF028819
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:04:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HY01HyD7YuG1e1XuOWIPG5Lj9MowcnQL/UKTHSpRcm8=;
 b=NVRUq/gl6gRDbuCn2sm/JPNTSGrSu0Avx6b9vPkY+3YXLd4aszcLz8tFIjo2Y0hUGD7x
 7vf0o5GK6hjNXzBBKj/IKgyT5hn8Q/DFmHJzNSQ9l7614wqScK4YrQccHLDO6v8Jqb4K
 o602l1AN/x0XfQ2hkO9Y+FkQAUuksE7lEfI= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3et9d082m0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:04:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKcvJNEQF5KBJ1YASbarX1U8OTFSuWLdd7so67Jms+rWvaRFXFCQuc4uHwx7WPkOBwB40aXyTtk5HYKqFUe/9i+i9qHtMbWYXGS4FOh8igVPOHQEC6yCIeLnsVjutTMQuCtA4xyR7F6QCM0OKFkP3gNABzczk8reVl1VTg3ZUyr0H0l3lYbKiAoMtSOEDSCOHAbHVZc6sbQ0qIWBJcqbFCyDAHhQtazeQ5M4THgpXr4zRioYSwRU5j5g3Q1BrlTcxR2yYMmCE2dLLXdTVXq6DSchuS2ImeDC8RxyDoCwKhzJXr6ixbK3nWgrSqWMi/NjTX67+6zIL1ZzA4XLaP0aWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HY01HyD7YuG1e1XuOWIPG5Lj9MowcnQL/UKTHSpRcm8=;
 b=d+BGy5UqmnknEEXHB+w8qnNMFqQ0LoQvm33sQw8t2sqJZ7uj6m3FgfgRz/pDKemA+3YThX6OAa9cbYzO7gSoO2fuCxt61Gn70cxVhJr7dy7X9SP5EzdnPjfWcpJKgO/c05fXuKrkbtvbXuJOo7RdmE3/U6WPOQwBywdPpWnSdfDgjQslzyzeSXQXvsvRlHPZ78qdHPqc79wXR64ipkJlAqOjJtkMcuMPj6G5xfFsOScmudyebrt0qQnwI9w8/9NuyUmCa1fTpzAZzL3Npchralkz4YF3zQW9XAqvChtuweJH8qwG340N7uO0zOJ15QahjUY0SB83509IZDNBc1ogTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW5PR15MB5121.namprd15.prod.outlook.com (2603:10b6:303:196::10)
 by DM5PR1501MB2103.namprd15.prod.outlook.com (2603:10b6:4:a0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 16:04:54 +0000
Received: from MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b148:70ce:c1aa:a84f]) by MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b148:70ce:c1aa:a84f%6]) with mapi id 15.20.5061.026; Tue, 15 Mar 2022
 16:04:54 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Eric Dumazet <edumazet@google.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: RE: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo
 header
Thread-Topic: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo
 header
Thread-Index: AQHYNEJSnWEJal66q0u1G6893pPNnqy6YFQAgAZDCgCAAACeAA==
Date:   Tue, 15 Mar 2022 16:04:54 +0000
Message-ID: <MW5PR15MB51215DDB0EF5F5046EF86E37BD109@MW5PR15MB5121.namprd15.prod.outlook.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
 <20220310054703.849899-7-eric.dumazet@gmail.com>
 <bd7742e5631aee2059aea2d55a7531cc88dfe49b.camel@gmail.com>
 <CANn89iJOw3ETTUxZOi+5MXZTuuBqRtDvOd4RwVK8mGOBPMNoBQ@mail.gmail.com>
In-Reply-To: <CANn89iJOw3ETTUxZOi+5MXZTuuBqRtDvOd4RwVK8mGOBPMNoBQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64390da6-8de6-4db6-e0c2-08da069d8b3b
x-ms-traffictypediagnostic: DM5PR1501MB2103:EE_
x-microsoft-antispam-prvs: <DM5PR1501MB2103B2884F5F4F672C214680BD109@DM5PR1501MB2103.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z66o094rAgDIEIjzq4a47LeNsNw/MuDDAC0ywmwBOkUoz0EDEENUaLcGw80NCYXwXn94wdt6sWBjJyPXDDSkWlQm9yheCQ5J+eqqAfJqxHcPdRTwQ3ntgJTFFZ4EXXQB5GJ48ahmMlZoRfhA5yBAHvmaNux/21uiJQSaXRuwJy66riNz5BrpXRrXsLq4HD4dHwwoYmGzQ73fJVGq13EzR6iWWH9FgxThkJOim90Hv6yHi9iJ0foV5dLx1l3OwvKD3zjsFfwvbRxTrBgge3rumnT+snazdFJTwC+yUOHn0/i8q8r9A+afLgTBGCFA/O7YOwmJBFqVV99ndcFaVezH8jdTfPtP9pPZuPfbqKBFbRLb8dGKUfmdS9NCJCpx7R0qcEclHefl3wJoM1GOfXTP6Jnx92qFRIncG3RfaMo/fZvptWm8wGM0Rg+8e23gx6bepscXs38GXxwbBd0phqGVcVVvpDS1wJB9vHOJW0Nw/hMJRdEUL6jN1hGjb91cZDT+Rf4ppe1Nb4kySKXQM1RQyc0l5kTe5FW1pYVHiaXwayJISYQizazUb6yH+groSTw+/eBj9Au4y2bJ55IXBAC9TENHZDiT2z/avSaGoHYqFZ9YjPK1Ww3Zc08/qqvMjOLioAMA/9EK1MS14qPVobiJdp4VnYm7QnF1WfNN7dnRrtu7xteH7fDK9u/ny4tMHdGrikcmLUI832+5mU8bjmEKog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR15MB5121.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(2906002)(9686003)(33656002)(38070700005)(5660300002)(76116006)(508600001)(83380400001)(186003)(7696005)(6506007)(53546011)(55016003)(4326008)(54906003)(52536014)(38100700002)(86362001)(66946007)(8936002)(8676002)(316002)(66556008)(66476007)(64756008)(122000001)(66446008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzd4NUV6amQ0V3R0bERpajUyYmxPUFFqV3crL3VJNFljUTI0N0oxN1FkTXhE?=
 =?utf-8?B?NlJHMmdFb3Y1TnRnZzRFNVhYdHp0M1h6WkpPWmJtVFYzcG80T1FaRVg1YzNm?=
 =?utf-8?B?S01UcjhWVVVQa3lEQWhWM3RQYjJ3czhwZm4vdzRRUTAwS1N3UVp1M25MdHV1?=
 =?utf-8?B?aHBINTIxbXB2dWMxZkpWT2l4clYwSkJaNEZMRnZwL3l3MW1WMHA3RnpUU1dC?=
 =?utf-8?B?L1hGaVIrMjlMaWs0YVhGT1pXdHg0ai9IRG9saG14U2ZCenAzSmpoME82Q0dk?=
 =?utf-8?B?blNIdE4vMmtyU3ZPUFF6WDRCK0daUmVJWG9IWEsvR0lLUFQ1VHBEd1FZQjUr?=
 =?utf-8?B?cDd4UWo3N1g2dVNuMWI2VS9vbUFFQldTY1NoRzNYbEMzV0JsT1BxZzBhVmxa?=
 =?utf-8?B?WDF6cUkrTGVHZHhTSW5yOERpNHV4VzRZSDZMS0pEaVhHTFJTWm9HSC85UWVI?=
 =?utf-8?B?c1RGMlZuTnRTeFFHM3E4WGxreWVpT3RERmhKc2EvUDVTYUMwWjVKWjA5S0Ri?=
 =?utf-8?B?SFRrbTRWNDhQVDViOU8zMWNUKzZvOHp4Wk9XbzgvSzJqZmZTUjVlYVZES3Ft?=
 =?utf-8?B?L3hXazFIdXAwTzdseVZGbXY5VGhmQXZubk9NbmpWWnFTbzRMQ0ZVYnJHc1BN?=
 =?utf-8?B?dE1oOTJFaFNqbzdTMjZCRnlKQlNuenZoS2NoTGtrcFg2SDFGODZCS3h6KzNy?=
 =?utf-8?B?djBvSG5DaFBTcTJFQ2ZqSy9MSXBqeHVVSHJKNU9UQi96NzFGdjZSVWVRNm9W?=
 =?utf-8?B?YmN6NGYrVVlsRllqbHAxMUJ0cGl3SEphYzRsU3ZjVFJrTXNHRVhRQlpRNFpo?=
 =?utf-8?B?TWNlU2lrZFFDYncyNnh4cEUyRXU0d0IzK1JPNkZsQkRlckpuUWpRK0JjMnV3?=
 =?utf-8?B?RXcwazVLRUNydlRrampTZFJ2N1BlYVVrSDVHYnplL3pyWUJJdlRzVmgybXM1?=
 =?utf-8?B?eUZzU09NY2Z3cGxtWnFaMHRrbzBBYlZ2NHJTQTBZTFA4elRxbTk0MTNiWUJn?=
 =?utf-8?B?VWVaQXZ2c1U0eVFBejlJT0w1b0VlczFkODVZbnBUTm8zN0pIeUxWL2Y3VHJR?=
 =?utf-8?B?R0plRGFaL3llanh6Q2NQQWNzMDJRN25ncTZnVy9PZFVnajhiOUpFOS95bDZS?=
 =?utf-8?B?MnZvY2MwWko1a1J2dmVuWUgxZW1RaUMyUTU3U0VPWlhmSWpDUnRDeGNLcGpk?=
 =?utf-8?B?YS9OdjRGaGxFSVRZbHRhbUx2T1lDaDB5T3RYaHhuNkJZRFdxYTZ3NTJ3TW83?=
 =?utf-8?B?WTZkWDhEWExJdzRBZ3VNdWY4bFkwcXBRV21hTWpWQytUQ2hZSXdma0haMDF3?=
 =?utf-8?B?UXY1L2p0dlZaTDBCdUoyck1jb2wrOGVNMDZOOVBkTHl5MzBBWTlJNkhBc244?=
 =?utf-8?B?MmxLc0NJL0lPUmVMbStsU2ZMSEtzRkRVbUwvaUJWdE11cUt5MXBTeFQ1NCs1?=
 =?utf-8?B?NHM2cnVaMjQ5S0l2c3J5eUcwSWVVVExCYWxrZVgyY2VQLzBqenVOS3ZiSEQ2?=
 =?utf-8?B?eWkvNnpJRHhwZ1NsbkJMT21QM0YwaEFpWnI2U0ZqZkl4TWNXRC9tN2hyOUlT?=
 =?utf-8?B?S0M2dncxL2NCY0pkUkd2T0dVMFMvaHZ1cTdoY0pFVnlvcTRRVHBnN3VUUEl0?=
 =?utf-8?B?M3ZKYjFNZGt6YldyS1AydnlmbDJsZXJTa0hlV0NzcVJDaFZNRVZ3L2ZVd09V?=
 =?utf-8?B?cjNKSnBzdkxZWVdYSVgwQmtuTGFERGZMTklCM1Q3NXVZZXNYbjdJd01LUUNh?=
 =?utf-8?B?c3QxOWdSbVhOM2tpUGlSYmpMN1pDM3ZQS0g1NE13cklqd2lXS0lhYnRpL1pP?=
 =?utf-8?B?MU8yNkFiQWxlazZ1Q08yL3dyQUw0ZTdwaVZGeTlrQ28vOHlWU1Y5dGRCZ1Ft?=
 =?utf-8?B?V2pPR3VLdTFwWCtHcHBRUklhb2Z0T3hxcCt5eVVKRERIcnhvdWlhWUgxTExp?=
 =?utf-8?B?bStNUmh1VTNJbzIxK1huTG5NN292SUJrVGdJOFFwYktWd2dhaE81aUczdGdk?=
 =?utf-8?B?RktLcWk4aDZiMUtYQXRQRkFVd3R0dGc4YjFwTjdqeWhuY0dJczQyVkQ5QUt3?=
 =?utf-8?Q?LzyXqT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR15MB5121.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64390da6-8de6-4db6-e0c2-08da069d8b3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 16:04:54.1310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ATPogRNSGhe+q1wgZQE7d/5bUvOC2W23/JC+viTiQz7PblsH7D+cTtXGd5/QiNcoq/u3xA/NJlGbh1jjuSWVUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2103
X-Proofpoint-ORIG-GUID: _7sNHVBzXac03o7VrqpGEb61vQRG45x7
X-Proofpoint-GUID: _7sNHVBzXac03o7VrqpGEb61vQRG45x7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAxNSwgMjAyMiA5OjAy
IEFNDQo+IFRvOiBBbGV4YW5kZXIgSCBEdXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4N
Cj4gQ2M6IEVyaWMgRHVtYXpldCA8ZXJpYy5kdW1hemV0QGdtYWlsLmNvbT47IERhdmlkIFMgLiBN
aWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPjsgbmV0ZGV2DQo+IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgQWxleGFuZGVyIER1
eWNrIDxhbGV4YW5kZXJkdXlja0BmYi5jb20+Ow0KPiBDb2NvIExpIDxsaXhpYW95YW5AZ29vZ2xl
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCBuZXQtbmV4dCAwNi8xNF0gaXB2Ni9ncm86
IGluc2VydCB0ZW1wb3JhcnkNCj4gSEJIL2p1bWJvIGhlYWRlcg0KPiANCj4gT24gRnJpLCBNYXIg
MTEsIDIwMjIgYXQgODoyNCBBTSBBbGV4YW5kZXIgSCBEdXljaw0KPiA8YWxleGFuZGVyLmR1eWNr
QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBXZWQsIDIwMjItMDMtMDkgYXQgMjE6NDYg
LTA4MDAsIEVyaWMgRHVtYXpldCB3cm90ZToNCj4gPiA+IEZyb206IEVyaWMgRHVtYXpldCA8ZWR1
bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiA+DQo+ID4gPiBGb2xsb3dpbmcgcGF0Y2ggd2lsbCBhZGQg
R1JPX0lQVjZfTUFYX1NJWkUsIGFsbG93aW5nIGdybyB0byBidWlsZA0KPiA+ID4gQklHIFRDUCBp
cHY2IHBhY2tldHMgKGJpZ2dlciB0aGFuIDY0SykuDQo+ID4gPg0KPiA+DQo+ID4gVGhpcyBsb29r
cyBsaWtlIGl0IGJlbG9uZ3MgaW4gdGhlIG5leHQgcGF0Y2gsIG5vdCB0aGlzIG9uZS4gVGhpcyBw
YXRjaA0KPiA+IGlzIGFkZGluZyB0aGUgSEJIIGhlYWRlci4NCj4gDQo+IFdoYXQgZG8geW91IG1l
YW4gYnkgIml0IGJlbG9uZ3MiID8NCj4gDQo+IERvIHlvdSB3YW50IG1lIHRvIHNxdWFzaCB0aGUg
cGF0Y2hlcywgb3IgcmVtb3ZlIHRoZSBmaXJzdCBzZW50ZW5jZSA/DQo+IA0KPiBJIGFtIGNvbmZ1
c2VkLg0KDQpJdCBpcyBhYm91dCB0aGUgc2VudGVuY2UuIFlvdXIgbmV4dCBwYXRjaCBlc3NlbnRp
YWxseSBoYXMgdGhhdCBhcyB0aGUgdGl0bGUgYW5kIGFjdHVhbGx5IGRvZXMgYWRkIEdST19JUFY2
X01BWF9TSVpFLiBJIHdhc24ndCBzdXJlIGlmIHlvdSByZW9yZGVyZWQgdGhlIHBhdGNoZXMgb3Ig
c3BsaXQgdGhlbS4gSG93ZXZlciBhcyBJIHJlY2FsbCBJIGRpZG4ndCBzZWUgYW55dGhpbmcgaW4g
dGhpcyBwYXRjaCB0aGF0IGFkZGVkIEdST19JUFY2X01BWF9TSVpFLg0K
