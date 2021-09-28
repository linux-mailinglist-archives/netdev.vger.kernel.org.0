Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D4741B30D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbhI1Pil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:38:41 -0400
Received: from mail-bn8nam11on2106.outbound.protection.outlook.com ([40.107.236.106]:53376
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241371AbhI1Pik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 11:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EumoeL2MiM6Qiw6dKkAQCAp9juxUyiL4IO7TDYUYvqrQo56SrUHkXMfMbnBwhnGAAXP8qAr8JFEWo+c6sRRcsmAjzSEDHguyW7K/2EeUikomoO7I0OVblzP846kOCXJSLtVf1LA6xRwBLxbvinTXieq2vss0WiB8L1R3Bn4K1OUfpB9rWOjeqiXnYl4KfFtxC+pOIUR4i9Js92Q8OKYlb8OMINuq/WrJqjCF3c9N/PLxsGgvhIt37h7/kq0mo7T58YqEawSpbXG1m9mDNevIzFwLkwo2kGsuP9yFZp/tvMYbk6YVbH08obHn8MQ/UTw6Mlrrnc2RV3Tyhp6qdn2oig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lzMY2PSPB+P3vucidIAhnA/ZEOW49Mf0xg/83u+yLEo=;
 b=HOJvzkfyCfo+9EYrnWoisg8JVkOGeIsJ3WEidYpufvCuUKhJFFuDauV5nFH+rLV3X7L/tXmwI22/REmeb91dZTaeVDjbLmGhF5FPBK1BPJbJ8FU3QJcXJN1aM7uRrzyyJx+kYvIPkr1Cb4q7xzs+tYnsyEL9SbyLdcGyd/ILrDDqocuQOYSeHt9sHYb4sv7fRhCBa/agiIvPF+SBwpW8mmdLa2cd6ULvLrY8JdKJljhPLapC6jzu95wr2nc58v05o1FKEHv9vKqxBVvhOLynxyux37HK/493UvBPoHyfPgy2z799nuPo4A/vPxI2c5PIUqg1GH1gYktdTRB6IHCgmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzMY2PSPB+P3vucidIAhnA/ZEOW49Mf0xg/83u+yLEo=;
 b=Dav0WuzBxCQcSQcBe97Llfd7nMYARKfWIo6W0vpAzdq9adl/xVE2kNOdGSMhqDjvbm7NQngzNmo/nuWhGU+p+VL/aqM8t53GsjtgZ9HIMvg++GqGy9v0q4xz9FMO0M8N24PoyDg6zUw9FmiUEp31Dz6O4zpAS0i2ZCV+VwEtWBU=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CH2PR13MB3480.namprd13.prod.outlook.com (2603:10b6:610:16::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9; Tue, 28 Sep
 2021 15:36:58 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2%6]) with mapi id 15.20.4566.014; Tue, 28 Sep 2021
 15:36:58 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>
CC:     "neilb@suse.com" <neilb@suse.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "kolga@netapp.com" <kolga@netapp.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Topic: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Index: AQHXtBciMSJq8UTGIk29qdNL+Xnf4qu5ccKAgAAFewCAAAQtAIAAA34AgAAC2oCAAAh1gIAACvAA
Date:   Tue, 28 Sep 2021 15:36:58 +0000
Message-ID: <8b0e774bdb534c69b0612103acbe61c628fde9b1.camel@hammerspace.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
         <20210928031440.2222303-3-wanghai38@huawei.com>
         <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
         <20210928134952.GA25415@fieldses.org>
         <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
         <20210928141718.GC25415@fieldses.org>
         <cc92411f242290b85aa232e7220027b875942f30.camel@hammerspace.com>
         <20210928145747.GD25415@fieldses.org>
In-Reply-To: <20210928145747.GD25415@fieldses.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53b66136-f9c3-4429-decb-08d98295cf04
x-ms-traffictypediagnostic: CH2PR13MB3480:
x-microsoft-antispam-prvs: <CH2PR13MB34803DC0F6AAD4CA13F64637B8A89@CH2PR13MB3480.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fu1MaQz/2TjkwKP/+v5XTEBVdCKha3UJ6di+pZ/B76Veezmpl7AzJwUGUAUv0+UmILh6OXZ9CZ5m0sos5hEUpRJiyLgW4nwjZ/UclfMmkxKhVl6zekpXB//c9vEx5vAZ1FR8uBQhbhzHM5yuArPx/R0O6EeJs0j/KbeEdDHcuI8x34TQ6/4D5zYl3gRGa0SNje5158TjPilmHxi+LOnwPYWwUFEKrr1dnd+pd14QG/AHVAsnZOlO8bHfGBPEYeARjeotDIdsayhq7cyJltpB8gv4YlTSmbzRXf8gGg/6lawZUSF0eJ645mffxtQYTWA5OWIl02m3Ze/MKJbKmVCr+oM6C94S2Thj3i/flb+/mUawb2qw2p9zuk7rEt6cVOUQQ7vXuAXycZjMUHU3gkOP2vxep3g6gMBHG3YtNtuqRa2ab3Z4FJDe0MDIKXlq/l6qJDczwvwKNR4SAU3O2B3SmxQDiIEZpE63PJhX5KNlIGiuZFLxW5ci9wKonwM1YbhC2Dr/bsosvb9BqBRXJYDjiVuR/7vlHt98un7yabI1EkIOLC+pQT1mhGNFKsln86p60JvTya+jhu/dWsGegfImATHrN1lT963GQjEH+/rBuAFVupoLOImVPsLQi/dJglO6QMCewq3J+HDh0G9s4+N+4iR2KFMGGvVk3dEPjN275Nd3Qm9X4DUGBJHTXqiDS9BG2xHzyemwoXZbIGW2V4n81w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(186003)(86362001)(38070700005)(66476007)(2906002)(66556008)(66946007)(71200400001)(36756003)(6916009)(76116006)(2616005)(5660300002)(38100700002)(26005)(6506007)(316002)(8676002)(83380400001)(6486002)(122000001)(4326008)(8936002)(66446008)(7416002)(6512007)(54906003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXRLek40OWcxVmxqbUVOdkZhT1dxNi9mSnRxbTVsMjRqRm0wZ2pKTWNHSnZH?=
 =?utf-8?B?UFdhd054QXllT1pIZ0tTKzdNaGtGc1RaS05JaEU3SUJyUmI1VnE4b1BBUG8x?=
 =?utf-8?B?ak5HY095Sm1jaGphNGVSVWFaZ3ZLa1FYbE5mVFdNTGx5RElIQjZYeWpJd2pj?=
 =?utf-8?B?K1hpTXpwZE1NK1VpQjdNN1dHbG1NUFFWdjJwSFVUc202YzFaVS9Ga2ZyVjBj?=
 =?utf-8?B?MTMxaTFzRDA3S295dU8yQ2hSbUhFN3pZbGhGd2dGNjBXdXdMRDE1cWp2L0N6?=
 =?utf-8?B?ZHE2bll1RjZUUnI4aGNzQVlEOWpsNC9YN3MwTTBSdFhvcTNKQUc1bDZVTFZD?=
 =?utf-8?B?SVBDdDA2Z1ZxZ3FUVlM2c2hXVzlsdDJpTEt2eEtKZVFlaGthOW9LOEtvY0ZF?=
 =?utf-8?B?bGhiRnFsWndPMXQzOTNHYXM3cDJDWWE1ekpNMHp0ZHdxQXhKQzNKL3FEUUZo?=
 =?utf-8?B?Z0tSNVpxWXZMZUlXV2pNYTgwejBWZVJveXo5bWJySGZxTS9TSjFqc3FwVU5m?=
 =?utf-8?B?K3BYZVpKWkFySkpCcURkOTdycDlIM280a2hsZDVTUUNYek1JTG9CU254Vzlr?=
 =?utf-8?B?anhjRHlvMG5NdzROT1VXT0psUGswMzFFM3FYcmY2TnUwVmtHam5FcUVzZ0dW?=
 =?utf-8?B?Q3Z2bEx3Tm5YNjJyS2NPWm5oZWJXVFVoUWZnZjVRZ3ptMXJFYURwU2h0Q2dv?=
 =?utf-8?B?MU5xMnNwSk4zQlVjaFVyRjdzb1hzNkhvT3JpVjU1RzlxbDV6VStPWjkvelg5?=
 =?utf-8?B?UkJZZDJBOTVEY2xZWWRweWYvbEpqd2R4bFE1SXRXUmFldDRuUXc2Z1lOeFJZ?=
 =?utf-8?B?THNKWUNkV1JlKzVYVTZmRHJRc1pjNUF4aVM4elYxdUU4alJSU0xzOXR5SmZV?=
 =?utf-8?B?bC9TdS9RN2FxWmJPTkhGenA3NWwzSTQwM3JoeUVzejUydGFnMXcxQjZpUkhL?=
 =?utf-8?B?N0VqeWU2TTlOL1RXcjFTcnU0RHdoS05ZOGt5bGkvUzlPTzljOGQydFBoSGxp?=
 =?utf-8?B?NXp1RmtGSjBVdythSUtoMDc4M0prd1RicjN2bTFVZ1JheW5zLzRtR0pNdGFC?=
 =?utf-8?B?ZjZrVndKdXkvYjJNK2x3Tkh6djcvT0lkUU9RWEoxOENSYjA1S1B3Vlc3QTdK?=
 =?utf-8?B?ZCtBa3ZIa0xpekFsUW9VYXR3Mk9VUGNNUWtLT1R1RVJtRFpqb0xTZTBBVEJS?=
 =?utf-8?B?NUphdHg1LzZKQ1BmVy9lNVVHa2R3MTFNK0tUOEhzRTVHTi9tdnZWUWlEUGpR?=
 =?utf-8?B?T3ZQWXJlM3pITXdJLzVWcGo0aGd4anNzajVkSnNnQVhJK09xZ2orLy8wUWpX?=
 =?utf-8?B?UmZoTE80M3FyYnZPSjRxNzZvWE9sKzNmN0ZOMVM4LzB3MWxyNmR0bVVQVHJM?=
 =?utf-8?B?b0R1WWhmclNkU3JQM2JDRFYzcEI2amttbDE4Vkx2alRLWGJJT3M0bmlNbVhp?=
 =?utf-8?B?ZE1VS0JBSDVVVWZUbTd5RmZUaFFMd1hIV1RZVW4xckFvdWJ0VzBCTWFoWUxF?=
 =?utf-8?B?VDFwYi94OHNjZnlKanNiY2tJbXU4eDZBZllYZ0NLODN3Sk1PRGpkd0MxNGxl?=
 =?utf-8?B?TkpWbVZwMkQ2UFM4SGM5RncxcjFRaHR0R0VKakVLWVc2V1Q5VUEzNlNJdkp6?=
 =?utf-8?B?QzgwV3JVWkU1UXBlNW5TRjZkTDdYSGJ2OUZUeVBPRzBoNjVvV3ZGeFlIaXcy?=
 =?utf-8?B?eVVoQUlXWS9yU1h2MzJzdm9VOW4rY1E0TW9aRlprbXg0MldZZXpOMnc1VkFY?=
 =?utf-8?Q?V4GU0G4IWqr0Gy/tth1o/c2C4IcHiWIziwBB7Bj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <99E975C59D4FFB428CFD865A249B1A95@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b66136-f9c3-4429-decb-08d98295cf04
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 15:36:58.3391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M+6uKb/8I7+UMLDUumN43Tk9uIsxeeA1GdnPfdbYOj+8JzRmeMFzMfdwb8px4xsgQ4eHjK0WTfIqmfHcVXXN9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDEwOjU3IC0wNDAwLCBiZmllbGRzQGZpZWxkc2VzLm9yZyB3
cm90ZToNCj4gT24gVHVlLCBTZXAgMjgsIDIwMjEgYXQgMDI6Mjc6MzNQTSArMDAwMCwgVHJvbmQg
TXlrbGVidXN0IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMS0wOS0yOCBhdCAxMDoxNyAtMDQwMCwg
YmZpZWxkc0BmaWVsZHNlcy5vcmfCoHdyb3RlOg0KPiA+ID4gT24gVHVlLCBTZXAgMjgsIDIwMjEg
YXQgMDI6MDQ6NDlQTSArMDAwMCwgVHJvbmQgTXlrbGVidXN0IHdyb3RlOg0KPiA+ID4gPiBPbiBU
dWUsIDIwMjEtMDktMjggYXQgMDk6NDkgLTA0MDAsIGJmaWVsZHNAZmllbGRzZXMub3JnwqB3cm90
ZToNCj4gPiA+ID4gPiBPbiBUdWUsIFNlcCAyOCwgMjAyMSBhdCAwMTozMDoxN1BNICswMDAwLCBU
cm9uZCBNeWtsZWJ1c3QNCj4gPiA+ID4gPiB3cm90ZToNCj4gPiA+ID4gPiA+IE9uIFR1ZSwgMjAy
MS0wOS0yOCBhdCAxMToxNCArMDgwMCwgV2FuZyBIYWkgd3JvdGU6DQo+ID4gPiA+ID4gPiA+IFdo
ZW4gdXNlLWdzcy1wcm94eSBpcyBzZXQgdG8gMSwgd3JpdGVfZ3NzcCgpIGNyZWF0ZXMgYQ0KPiA+
ID4gPiA+ID4gPiBycGMNCj4gPiA+ID4gPiA+ID4gY2xpZW50DQo+ID4gPiA+ID4gPiA+IGluDQo+
ID4gPiA+ID4gPiA+IGdzc3BfcnBjX2NyZWF0ZSgpLCB0aGlzIGluY3JlYXNlcyB0aGUgbmV0bnMg
cmVmY291bnQgYnkNCj4gPiA+ID4gPiA+ID4gMiwNCj4gPiA+ID4gPiA+ID4gdGhlc2UNCj4gPiA+
ID4gPiA+ID4gcmVmY291bnRzIGFyZSBzdXBwb3NlZCB0byBiZSByZWxlYXNlZCBpbg0KPiA+ID4g
PiA+ID4gPiBycGNzZWNfZ3NzX2V4aXRfbmV0KCksDQo+ID4gPiA+ID4gPiA+IGJ1dA0KPiA+ID4g
PiA+ID4gPiBpdA0KPiA+ID4gPiA+ID4gPiB3aWxsIG5ldmVyIGhhcHBlbiBiZWNhdXNlIHJwY3Nl
Y19nc3NfZXhpdF9uZXQoKSBpcw0KPiA+ID4gPiA+ID4gPiB0cmlnZ2VyZWQNCj4gPiA+ID4gPiA+
ID4gb25seQ0KPiA+ID4gPiA+ID4gPiB3aGVuDQo+ID4gPiA+ID4gPiA+IHRoZSBuZXRucyByZWZj
b3VudCBnZXRzIHRvIDAsIHNwZWNpZmljYWxseToNCj4gPiA+ID4gPiA+ID4gwqDCoMKgIHJlZmNv
dW50PTAgLT4gY2xlYW51cF9uZXQoKSAtPiBvcHNfZXhpdF9saXN0IC0+DQo+ID4gPiA+ID4gPiA+
IHJwY3NlY19nc3NfZXhpdF9uZXQNCj4gPiA+ID4gPiA+ID4gSXQgaXMgYSBkZWFkbG9jayBzaXR1
YXRpb24gaGVyZSwgcmVmY291bnQgd2lsbCBuZXZlciBnZXQNCj4gPiA+ID4gPiA+ID4gdG8gMA0K
PiA+ID4gPiA+ID4gPiB1bmxlc3MNCj4gPiA+ID4gPiA+ID4gcnBjc2VjX2dzc19leGl0X25ldCgp
IGlzIGNhbGxlZC4gU28sIGluIHRoaXMgY2FzZSwgdGhlDQo+ID4gPiA+ID4gPiA+IG5ldG5zDQo+
ID4gPiA+ID4gPiA+IHJlZmNvdW50DQo+ID4gPiA+ID4gPiA+IHNob3VsZCBub3QgYmUgaW5jcmVh
c2VkLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSW4gdGhpcyBjYXNlLCB4cHJ0IHdp
bGwgdGFrZSBhIG5ldG5zIHJlZmNvdW50IHdoaWNoIGlzDQo+ID4gPiA+ID4gPiA+IG5vdA0KPiA+
ID4gPiA+ID4gPiBzdXBwb3NlZA0KPiA+ID4gPiA+ID4gPiB0byBiZSB0YWtlbi4gQWRkIGEgbmV3
IGZsYWcgdG8gcnBjX2NyZWF0ZV9hcmdzIGNhbGxlZA0KPiA+ID4gPiA+ID4gPiBSUENfQ0xOVF9D
UkVBVEVfTk9fTkVUX1JFRiBmb3Igbm90IGluY3JlYXNpbmcgdGhlIG5ldG5zDQo+ID4gPiA+ID4g
PiA+IHJlZmNvdW50Lg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSXQgaXMgc2FmZSBu
b3QgdG8gaG9sZCB0aGUgbmV0bnMgcmVmY291bnQsIGJlY2F1c2Ugd2hlbg0KPiA+ID4gPiA+ID4g
PiBjbGVhbnVwX25ldCgpLCBpdA0KPiA+ID4gPiA+ID4gPiB3aWxsIGhvbGQgdGhlIGdzc3BfbG9j
ayBhbmQgdGhlbiBzaHV0IGRvd24gdGhlIHJwYyBjbGllbnQNCj4gPiA+ID4gPiA+ID4gc3luY2hy
b25vdXNseS4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSSBk
b24ndCBsaWtlIHRoaXMgc29sdXRpb24gYXQgYWxsLiBBZGRpbmcgdGhpcyBraW5kIG9mIGZsYWcN
Cj4gPiA+ID4gPiA+IGlzDQo+ID4gPiA+ID4gPiBnb2luZyB0bw0KPiA+ID4gPiA+ID4gbGVhZCB0
byBwcm9ibGVtcyBkb3duIHRoZSByb2FkLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJcyB0
aGVyZSBhbnkgcmVhc29uIHdoYXRzb2V2ZXIgd2h5IHdlIG5lZWQgdGhpcyBSUEMgY2xpZW50DQo+
ID4gPiA+ID4gPiB0bw0KPiA+ID4gPiA+ID4gZXhpc3QNCj4gPiA+ID4gPiA+IHdoZW4gdGhlcmUg
aXMgbm8gYWN0aXZlIGtuZnNkIHNlcnZlcj8gSU9XOiBJcyB0aGVyZSBhbnkNCj4gPiA+ID4gPiA+
IHJlYXNvbg0KPiA+ID4gPiA+ID4gd2h5DQo+ID4gPiA+ID4gPiB3ZQ0KPiA+ID4gPiA+ID4gc2hv
dWxkbid0IGRlZmVyIGNyZWF0aW5nIHRoaXMgUlBDIGNsaWVudCBmb3Igd2hlbiBrbmZzZA0KPiA+
ID4gPiA+ID4gc3RhcnRzDQo+ID4gPiA+ID4gPiB1cA0KPiA+ID4gPiA+ID4gaW4NCj4gPiA+ID4g
PiA+IHRoaXMgbmV0IG5hbWVzcGFjZSwgYW5kIHdoeSB3ZSBjYW4ndCBzaHV0IGl0IGRvd24gd2hl
bg0KPiA+ID4gPiA+ID4ga25mc2QNCj4gPiA+ID4gPiA+IHNodXRzDQo+ID4gPiA+ID4gPiBkb3du
Pw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSBycGMgY3JlYXRlIGlzIGRvbmUgaW4gdGhlIGNv
bnRleHQgb2YgdGhlIHByb2Nlc3MgdGhhdA0KPiA+ID4gPiA+IHdyaXRlcw0KPiA+ID4gPiA+IHRv
DQo+ID4gPiA+ID4gL3Byb2MvbmV0L3JwYy91c2UtZ3NzLXByb3h5IHRvIGdldCB0aGUgcmlnaHQg
bmFtZXNwYWNlcy7CoCBJDQo+ID4gPiA+ID4gZG9uJ3QNCj4gPiA+ID4gPiBrbm93DQo+ID4gPiA+
ID4gaG93IGhhcmQgaXQgd291bGQgYmUgY2FwdHVyZSB0aGF0IGluZm9ybWF0aW9uIGZvciBhIGxh
dGVyDQo+ID4gPiA+ID4gY3JlYXRlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gc3Zj
YXV0aF9nc3NfcHJveHlfaW5pdCgpIHVzZXMgdGhlIG5ldCBuYW1lc3BhY2UgU1ZDX05FVChycXN0
cCkNCj4gPiA+ID4gKGkuZS4NCj4gPiA+ID4gdGhlIGtuZnNkIG5hbWVzcGFjZSkgaW4gdGhlIGNh
bGwgdG8NCj4gPiA+ID4gZ3NzcF9hY2NlcHRfc2VjX2NvbnRleHRfdXBjYWxsKCkuDQo+ID4gPiA+
IA0KPiA+ID4gPiBJT1c6IHRoZSBuZXQgbmFtZXNwYWNlIHVzZWQgaW4gdGhlIGNhbGwgdG8gZmlu
ZCB0aGUgUlBDIGNsaWVudA0KPiA+ID4gPiBpcw0KPiA+ID4gPiB0aGUNCj4gPiA+ID4gb25lIHNl
dCB1cCBieSBrbmZzZCwgYW5kIHNvIGlmIHVzZS1nc3MtcHJveHkgd2FzIHNldCBpbiBhDQo+ID4g
PiA+IGRpZmZlcmVudA0KPiA+ID4gPiBuYW1lc3BhY2UgdGhhbiB0aGUgb25lIHVzZWQgYnkga25m
c2QsIHRoZW4gaXQgd29uJ3QgYmUgZm91bmQuDQo+ID4gPiANCj4gPiA+IFJpZ2h0LsKgIElmIHlv
dSd2ZSBnb3QgbXVsdGlwbGUgY29udGFpbmVycywgeW91IGRvbid0IHdhbnQgdG8gZmluZA0KPiA+
ID4gYQ0KPiA+ID4gZ3NzLXByb3h5IGZyb20gYSBkaWZmZXJlbnQgY29udGFpbmVyLg0KPiA+ID4g
DQo+ID4gDQo+ID4gRXhhY3RseS4gU28gdGhlcmUgaXMgbm8gbmFtZXNwYWNlIGNvbnRleHQgdG8g
Y2FwdHVyZSBpbiB0aGUgUlBDDQo+ID4gY2xpZW50DQo+ID4gb3RoZXIgdGhhbiB3aGF0J3MgYWxy
ZWFkeSBpbiBrbmZzZC4NCj4gPiANCj4gPiBUaGUgUlBDIGNsaWVudCBkb2Vzbid0IGNhcHR1cmUg
YW55IG90aGVyIHByb2Nlc3MgY29udGV4dC4gSXQgY2FuDQo+ID4gY2FjaGUNCj4gPiBhIHVzZXIg
Y3JlZCBpbiBvcmRlciB0byBjYXB0dXJlIHRoZSB1c2VyIG5hbWVzcGFjZSwgYnV0IHRoYXQNCj4g
PiBpbmZvcm1hdGlvbiBhcHBlYXJzIHRvIGJlIHVudXNlZCBieSB0aGlzIGdzc2QgUlBDIGNsaWVu
dC4NCj4gDQo+IE9LLCB0aGF0J3MgZ29vZCB0byBrbm93LCB0aGFua3MuDQo+IA0KPiBJdCdzIGRv
aW5nIGEgcGF0aCBsb29rdXAgKGl0IHVzZXMgYW4gQUZfTE9DQUwgc29ja2V0KSwgYW5kIEknbSBu
b3QNCj4gYXNzdW1pbmcgdGhhdCB3aWxsIGdldCB0aGUgc2FtZSByZXN1bHQgYWNyb3NzIGNvbnRh
aW5lcnMuwqAgSXMgdGhlcmUNCj4gYW4NCj4gZWFzeSB3YXkgdG8gZG8ganVzdCB0aGF0IHBhdGgg
bG9va3VwIGhlcmUgYW5kIGRlbGF5IHRoZSByZXMgdGlsbA0KPiBrbmZzZA0KPiBzdGFydHVwPw0K
PiANCg0KV2hhdCBpcyB0aGUgdXNlIGNhc2UgaGVyZT8gU3RhcnRpbmcgdGhlIGdzc2QgZGFlbW9u
IG9yIGtuZnNkIGluDQpzZXBhcmF0ZSBjaHJvb3RlZCBlbnZpcm9ubWVudHM/IFdlIGFscmVhZHkg
a25vdyB0aGF0IHRoZXkgaGF2ZSB0byBiZQ0Kc3RhcnRlZCBpbiB0aGUgc2FtZSBuZXQgbmFtZXNw
YWNlLCB3aGljaCBwcmV0dHkgbXVjaCBlbnN1cmVzIGl0IGhhcyB0bw0KYmUgdGhlIHNhbWUgY29u
dGFpbmVyLg0KDQotLSANClRyb25kIE15a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBtYWludGFp
bmVyLCBIYW1tZXJzcGFjZQ0KdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
