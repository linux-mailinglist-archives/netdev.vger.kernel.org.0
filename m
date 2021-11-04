Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1A444E77
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 06:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhKDFxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 01:53:54 -0400
Received: from mail-dm6nam12on2107.outbound.protection.outlook.com ([40.107.243.107]:48608
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229871AbhKDFxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 01:53:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5iQEo3zvTwgweaBvOti5LpHnVj2YTWA+McSj9OWCS7pv92Y9DiYL+iH6gYKfNDgZvIuK8BNMN4sxx+qAJDWlaVOv4i9Qd+Ejwmow8HnSVQL9wMe8wukNfXd40RPW/mcSJYcGQerS7jF6pml4kgcD+1h8jEu2CkN69Hs3UTBtG2Wwy2SGW1NEMEHcmXKwaK9FDpT8QQLa2Ud4dkh0W6V3YQQPnb8KpQLcmeQ7X/DNxCZ7iBMY6VCtR+p1nTKLrXa82KzHWYLXnUF/nz7z7AHoksComCI0NrPH7iyl/TXeIPWDJ5ZyIJKe4mv9QT7OMPkaN+aOslPxB43G8lJ3OX/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OeA2itidg+YWFavoMaN2D/n3rPbV+aI1Q2VJjK7bc8=;
 b=kcuq9vdJwcWUTe2Sa251/xamfLo26OTFMTDjQ/+c97oMeL80Fbo7PC7ttlC+HA5XMD+3rOvheencKykxvfm0QSQIvwsiunHsf6KODap7JItfbWzp9jNXqyX+3E6KhYkCb3zbHWx63eR7Tjzr/MkNBXk/7LUg3sPM13jra3hPmcdYqZmNAJdEIqQ808DZMlQTHxbmL4q8V0Er80wWkhW1aciGtcOQL/aP5M2ql8WgqmZdWlSu4yeFY8HTHm+IDMSYbbBfWNxfyehCV5fG4SZLkkCGUR3JXfk+1vqZdodLMlb/XnEtq+wTT4KzXqSfy4Vxma/mA+9qe5Z9saRLvUGCpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OeA2itidg+YWFavoMaN2D/n3rPbV+aI1Q2VJjK7bc8=;
 b=Rz3wlHZMV2+FRZwxIhnHDJiLHG/d5J+7OItj5hqnsqja4J41ASlepqsHMz6BxRcpmu4BER1OiiLHM2mxoPbjY6g9Jj/HyXdcG2sUDUzm2mBKhfIugd+87z5nXA3U/Dh5Bzyqn0kW0YpAdaCtr61hnIyg8tXdAcEEPWhyH7dt6IU=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB3164.namprd13.prod.outlook.com (2603:10b6:5:198::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.8; Thu, 4 Nov
 2021 05:51:14 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Thu, 4 Nov 2021
 05:51:14 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAhnPzCAADm2QA==
Date:   Thu, 4 Nov 2021 05:51:14 +0000
Message-ID: <DM5PR1301MB2172E10FBDD2EA06E156BEDDE78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <DM5PR1301MB21722934E954B577033F0F56E78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
In-Reply-To: <DM5PR1301MB21722934E954B577033F0F56E78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0b49a9d-8af9-409b-ecde-08d99f571cf9
x-ms-traffictypediagnostic: DM6PR13MB3164:
x-microsoft-antispam-prvs: <DM6PR13MB31647642F3CD306354A768F2E78D9@DM6PR13MB3164.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hm1PRFjSKPS4QGVCLSTBU5ezRZJmJReEsvxGPWUITHOLq+Uh5hFFIYx9qjyxjn1GaCU752OMIM4BbLjIeyCMdGr+KE0JUupNMyr1VK/x6Mvo4ATVOg2jgjW4DtI/yCBcz2ntexjfNIVW5fKxBdcPUPBDsF/2So3Kv96i5/V+dv0Ihxzf0W//qY7Lgb9HP1Ce+uO+VvOOp/fSqr+18UEfchRmvCZ+x7sUgbP1Uyx4lmAbuMuBW9egpmizMvjZjz4bnZLTdGXsZJrS8joWx0bs9gCthPPZUwASKqzrLXbDcQT9C/3BG6r70SfRvJd/EvxRwkOrbbjFaY83qtVi8ORU4a9atHKqowh5ejBDWkor5S+nhReS2RbbiwRw3oNbB1DgcfN3FjEV9o4/lhuYThzH8XDzj1lts8t59xypTIaa+ODXeH/IYN9HFslSi32y5Zf8TpvWV4wTMOueFY2kOkk4Hq77cVYrf054apehEkdusosoc50qWQZfBPSovcC+NAb7aboIZ3P+sNS/tNgnNt+IY+tA6rrtiBleOIx+NKHpJzBIhFFq+bfThqBQ2wL9aAjMUS00bjUOhRS+H5s7w/X/77G/oAb37NR3Zss8GCldwibUHY3JqU9T6xm5WeqqJT5lkyGTaRE1HhwQaZxSZrksv0sQ3m2inVU4CdhPncbNenVPzGSz2CuckjzcMuIwnr669AUPxjz82u56GuJazAd8BQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(396003)(366004)(38100700002)(54906003)(44832011)(66556008)(2906002)(38070700005)(4326008)(6506007)(15650500001)(508600001)(66476007)(66946007)(122000001)(66446008)(5660300002)(64756008)(33656002)(2940100002)(76116006)(110136005)(86362001)(6636002)(26005)(52536014)(83380400001)(7696005)(9686003)(71200400001)(55016002)(8676002)(8936002)(107886003)(186003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dm9NcVBKY1hXZjdhalNLdHlUWmV4U2hXdC9ZOHplakpvM1FmenQyeDJvU1BL?=
 =?utf-8?B?WWtJdExScUNOcTQrWHNIREY3RUUydmdiSVloWEI4enJvNzJLYTZzMmZiSlVB?=
 =?utf-8?B?NjBKVG1JUnN5WDV0SUcrakRSVXVVblYwV3VGR2lwdjVhVkR5SmFRN0pQMWlX?=
 =?utf-8?B?VGVQMmUwYUlteS9qaGFaQThtUnFWWC84VXZlN0RvZjJNSklYYzJvdjRrNGpB?=
 =?utf-8?B?R2xWUVJReVdCeTEyTzhuUkwrUEh3ZkZIdEliZGw5RHMxNlZBR0diS240bk93?=
 =?utf-8?B?QXJxQlgyWHZoaExjQ1hnTDhQY05PME1qZzRLMUJ2L08xMmlRR3UxYjFtd2Zi?=
 =?utf-8?B?b1BLQXlPM1RNZXc5NGduRzJGNWZ3REZQNnZsTjMwejhZeHpaYzl3cGdBUmlv?=
 =?utf-8?B?QjJWZU9sZDVlb1BuWTYvbENNTU53b2VpbGQvSHVwZFR0NEp4YjJVZzdzRnRj?=
 =?utf-8?B?NGN0bEFaSzlIN09EdTR4bGRxT01GNUZmZzdqMVpuNWdNRVhFL3FTMGlXUDMx?=
 =?utf-8?B?SFdjKzlWb1RLc0c5TUhXWTg3RXJVR2dZV2lRNEw4VktiUmRCcnM4Slp4M3Mx?=
 =?utf-8?B?SXpUMWxvTWQ4bVpraC9kTEN5ZkU3c2dpNExyZVFlSGdORy81cDF2cVVqcHAw?=
 =?utf-8?B?aENjNUo0UW8zd0dpcytDczVhdW85bGVNajlvZVBJS1oydVNVcXVrczdvSS9y?=
 =?utf-8?B?UCtRbjFha1F0cCtHR2pCRlJuUTZJc203dVNmaWtOYjJiaWMrY29tWkFzRzNp?=
 =?utf-8?B?TFk2ZnQ0RTBtMDYrZkF3M1FKZE5FeURaS2NxNHNhRGpWWjZkYmNzcDZPeTZF?=
 =?utf-8?B?eTNRUVZicnRPdWlTRG9BZFJUSzJyZzNpYWJaMDZrN1pUR2xSTWMxbFJWalFZ?=
 =?utf-8?B?YzNoUXFyTEhsSjUrUGREUlgrZmtjenA2OE42RDBwbnoxcmR2THBQTW53NGU0?=
 =?utf-8?B?MUNGN2RCZmYzNnRhYnRianprWE5VREZlUlpPd1BwNUFVQlB5ZUpGTGYySlFh?=
 =?utf-8?B?dGFIVGhId1NIaU1iUHBmRFI5MElKbVExanVuL1BnR1E4d0VSeFJDMForb0Mv?=
 =?utf-8?B?QzkrNkttNGJKbmJlclQ0OWVaNHFIUWxKeTc2MFllVWpPVGpjWi9ZVGMxWUhP?=
 =?utf-8?B?aFRxQXBZMlZqOWN2T0NrUFdGVXpnZUN2NmRPVkFCdVhQUlo4QTRoU04yZTZ3?=
 =?utf-8?B?VkgyZ1VvQTBZbzhoUkMzMUZ2UmtKUUZiS1BVeWVPWjNYK3N5RURnSlFZR1dh?=
 =?utf-8?B?TlJUOXRyWk9SRm9OVGVSSXN6WVdxZ001bzUrQ1JtZUhXdlVYL3NwblNSbWo1?=
 =?utf-8?B?NFBKQnB0eVRDbEt0MCtVeEUzVGFhRFRHdytDSGhHOWYzN3RVYjEzZU1MWStp?=
 =?utf-8?B?c1ZSQ2pydWNIcnNML1NCYkNtUW44NTZsNnVBYlVlWWx2V2NZU3lDUjVwMkU4?=
 =?utf-8?B?YlpGYUNmd055UVhkWVc0V3lUTm9USEFlQ2hQcGc5RXE4WHA2T2p2TDdDQm1v?=
 =?utf-8?B?Q3pYQTladm0yRzJkSDFmbkoyYlZsMFIzcEtxeXVNaVJ6bVY3cVN1MzZuNllJ?=
 =?utf-8?B?YUU1dXNWNVN0SUU3aWZBZDNUWXJLYTV3bHRKTmNRNUhHWUtma3g3MDQwTzJC?=
 =?utf-8?B?Skhzd2NlZlhFV1VqQkQ5VmptcDUrNGkrOUpjQlhpK043cGg2VmtCc2Mva0J5?=
 =?utf-8?B?UjJUeFdwRjZENUU1dmlQdUc2YmlqVXJSZUQrSFVaaG5uaEVaTXEwV056RzNE?=
 =?utf-8?B?TFBsNnZnTyszOTBrczhyN2pnc2VIN25WMTZLdExLVytQam83MDMwSTZSNzBT?=
 =?utf-8?B?NzhJb2wyb2EwbnZVMXUvbHZJdXNBbklMRjFUZ251bUg1QVExUXEyU2FxQ2JJ?=
 =?utf-8?B?UFE1a1diV1hzR05lSTk4TVJVY2FiTURkQ3JDRkdpRFJCWHNTL1lBcHNMbkxp?=
 =?utf-8?B?WkJmc0VPaUwwMUU2bnE0SVJmV2dLMTRRaFVWMUg0UUZ3ZjN3eHU2c2NuR21J?=
 =?utf-8?B?LytMdEtXVXdqRHhlTHRKVU1URjVZTVhXMFhkOUF1TXNaU0YzZU0yenZoQ3dh?=
 =?utf-8?B?ZXZlVFNjRWNFbVpxNjNUTDA5eXVKUTdqSGlIZ2lOM3lUS0E5NWx0M0NmZFBn?=
 =?utf-8?B?blcra0RYK1JoRWZESE84R1ZMU0NDY2FWcW0yRTBMNUsyMkpCYWkxdmlPeCt2?=
 =?utf-8?B?QUNiNjAvQlQ4YlAzVjQ3NjJROExGb1p6YlhpSXhzdGdFOTFuTjBxd2VoU3Ro?=
 =?utf-8?B?enVSRlVMZFZGVFgveEs1YXNtc0VBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b49a9d-8af9-409b-ecde-08d99f571cf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 05:51:14.4739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bet/32wtShlN3kdj4STczOtttXjGU0JmJundN9VkmW+D3poqRJ/ccBtcTAkAZ0Fj5t+ogiFKYdm6M/WbQROyz7DtZlO5pzpmJWfBXlVqBCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3164
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29ycnkgZm9yIHJlcGx5IHRoaXMgbWVzc2FnZSBhZ2Fpbi4NCk9uIE5vdmVtYmVyIDQsIDIwMjEg
MTA6MzEgQU0sIEJhb3dlbiBaaGVuZyB3cm90ZToNCj5UaGFua3MgZm9yIHlvdXIgcmV2aWV3IGFu
ZCBzb3JyeSBmb3IgZGVsYXkgaW4gcmVzcG9uZGluZy4NCj5PbiBPY3RvYmVyIDMwLCAyMDIxIDI6
MDEgQU0sIFZsYWQgQnVzbG92IHdyb3RlOg0KPj5PbiBUaHUgMjggT2N0IDIwMjEgYXQgMTQ6MDYs
IFNpbW9uIEhvcm1hbiA8c2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbT4NCj4+d3JvdGU6DQo+Pj4g
RnJvbTogQmFvd2VuIFpoZW5nIDxiYW93ZW4uemhlbmdAY29yaWdpbmUuY29tPg0KPj4+DQo+Pj4g
QWRkIHByb2Nlc3MgdG8gdmFsaWRhdGUgZmxhZ3Mgb2YgZmlsdGVyIGFuZCBhY3Rpb25zIHdoZW4g
YWRkaW5nIGEgdGMNCj4+PiBmaWx0ZXIuDQo+Pj4NCj4+PiBXZSBuZWVkIHRvIHByZXZlbnQgYWRk
aW5nIGZpbHRlciB3aXRoIGZsYWdzIGNvbmZsaWN0cyB3aXRoIGl0cyBhY3Rpb25zLg0KPj4+DQo+
Pj4gU2lnbmVkLW9mZi1ieTogQmFvd2VuIFpoZW5nIDxiYW93ZW4uemhlbmdAY29yaWdpbmUuY29t
Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IExvdWlzIFBlZW5zIDxsb3Vpcy5wZWVuc0Bjb3JpZ2luZS5j
b20+DQo+Pj4gU2lnbmVkLW9mZi1ieTogU2ltb24gSG9ybWFuIDxzaW1vbi5ob3JtYW5AY29yaWdp
bmUuY29tPg0KPj4+IC0tLQ0KPj4+ICBuZXQvc2NoZWQvY2xzX2FwaS5jICAgICAgfCAyNiArKysr
KysrKysrKysrKysrKysrKysrKysrKw0KPj4+ICBuZXQvc2NoZWQvY2xzX2Zsb3dlci5jICAgfCAg
MyArKy0NCj4+PiAgbmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jIHwgIDQgKystLQ0KPj4+ICBuZXQv
c2NoZWQvY2xzX3UzMi5jICAgICAgfCAgNyArKysrLS0tDQo+Pj4gIDQgZmlsZXMgY2hhbmdlZCwg
MzQgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9u
ZXQvc2NoZWQvY2xzX2FwaS5jIGIvbmV0L3NjaGVkL2Nsc19hcGkuYyBpbmRleA0KPj4+IDM1MWQ5
Mzk4OGI4Yi4uODA2NDdkYTk3MTNhIDEwMDY0NA0KPj4+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBp
LmMNCj4+PiArKysgYi9uZXQvc2NoZWQvY2xzX2FwaS5jDQo+Pj4gQEAgLTMwMjUsNiArMzAyNSwy
OSBAQCB2b2lkIHRjZl9leHRzX2Rlc3Ryb3koc3RydWN0IHRjZl9leHRzICpleHRzKQ0KPj4+IH0g
RVhQT1JUX1NZTUJPTCh0Y2ZfZXh0c19kZXN0cm95KTsNCj4+Pg0KPj4+ICtzdGF0aWMgYm9vbCB0
Y2ZfZXh0c192YWxpZGF0ZV9hY3Rpb25zKGNvbnN0IHN0cnVjdCB0Y2ZfZXh0cyAqZXh0cywNCj4+
PiArdTMyIGZsYWdzKSB7ICNpZmRlZiBDT05GSUdfTkVUX0NMU19BQ1QNCj4+PiArCWJvb2wgc2tp
cF9zdyA9IHRjX3NraXBfc3coZmxhZ3MpOw0KPj4+ICsJYm9vbCBza2lwX2h3ID0gdGNfc2tpcF9o
dyhmbGFncyk7DQo+Pj4gKwlpbnQgaTsNCj4+PiArDQo+Pj4gKwlpZiAoIShza2lwX3N3IHwgc2tp
cF9odykpDQo+Pj4gKwkJcmV0dXJuIHRydWU7DQo+Pj4gKw0KPj4+ICsJZm9yIChpID0gMDsgaSA8
IGV4dHMtPm5yX2FjdGlvbnM7IGkrKykgew0KPj4+ICsJCXN0cnVjdCB0Y19hY3Rpb24gKmEgPSBl
eHRzLT5hY3Rpb25zW2ldOw0KPj4+ICsNCj4+PiArCQlpZiAoKHNraXBfc3cgJiYgdGNfYWN0X3Nr
aXBfaHcoYS0+dGNmYV9mbGFncykpIHx8DQo+Pj4gKwkJICAgIChza2lwX2h3ICYmIHRjX2FjdF9z
a2lwX3N3KGEtPnRjZmFfZmxhZ3MpKSkNCj4+PiArCQkJcmV0dXJuIGZhbHNlOw0KPj4+ICsJfQ0K
Pj4+ICsJcmV0dXJuIHRydWU7DQo+Pj4gKyNlbHNlDQo+Pj4gKwlyZXR1cm4gdHJ1ZTsNCj4+PiAr
I2VuZGlmDQo+Pj4gK30NCj4+PiArDQo+Pg0KPj5JIGtub3cgSmFtYWwgc3VnZ2VzdGVkIHRvIGhh
dmUgc2tpcF9zdyBmb3IgYWN0aW9ucywgYnV0IGl0IGNvbXBsaWNhdGVzDQo+PnRoZSBjb2RlIGFu
ZCBJJ20gc3RpbGwgbm90IGVudGlyZWx5IHVuZGVyc3RhbmQgd2h5IGl0IGlzIG5lY2Vzc2FyeS4N
Cj4+QWZ0ZXIgYWxsLCBhY3Rpb24gY2FuIG9ubHkgZ2V0IGFwcGxpZWQgdG8gYSBwYWNrZXQgaWYg
dGhlIHBhY2tldCBoYXMNCj4+YmVlbiBtYXRjaGVkIGJ5IHNvbWUgZmlsdGVyIGFuZCBmaWx0ZXJz
IGFscmVhZHkgaGF2ZSBza2lwIHN3L2h3DQo+PmNvbnRyb2xzLiBGb3Jnb2luZyBhY3Rpb24gc2tp
cF9zdyBmbGFnIHdvdWxkOg0KPj4NCj4+LSBBbGxldmlhdGUgdGhlIG5lZWQgdG8gdmFsaWRhdGUg
dGhhdCBmaWx0ZXIgYW5kIGFjdGlvbiBmbGFncyBhcmUgY29tcGF0aWJsZS4NCj4+KHRyeWluZyB0
byBvZmZsb2FkIGZpbHRlciB0aGF0IHBvaW50cyB0byBleGlzdGluZyBza2lwX2h3IGFjdGlvbiB3
b3VsZA0KPj5qdXN0IGZhaWwgYmVjYXVzZSB0aGUgZHJpdmVyIHdvdWxkbid0IGZpbmQgdGhlIGFj
dGlvbiB3aXRoIHByb3ZpZGVkIGlkDQo+PmluIGl0cyB0YWJsZXMpDQo+Pg0KPj4tIFJlbW92ZSB0
aGUgbmVlZCB0byBhZGQgbW9yZSBjb25kaXRpb25hbHMgaW50byBUQyBzb2Z0d2FyZSBkYXRhIHBh
dGgNCj4+aW4gcGF0Y2ggNC4NCj4+DQo+PldEWVQ/DQo+QXMgd2UgZGlzY3Vzc2VkIHdpdGggSmFt
YWwsIHdlIHdpbGwga2VlcCB0aGUgZmxhZyBvZiBza2lwX3N3IGFuZCB3ZSBuZWVkIHRvDQo+bWFr
ZSBleGFjdGx5IG1hdGNoIGZvciB0aGUgYWN0aW9ucyB3aXRoIGZsYWdzIGFuZCB0aGUgZmlsdGVy
IHNwZWNpZmljIGFjdGlvbiB3aXRoDQo+aW5kZXguDQo+Pg0KPj4+ICBpbnQgdGNmX2V4dHNfdmFs
aWRhdGUoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgdGNmX3Byb3RvICp0cCwgc3RydWN0IG5sYXR0
cg0KPioqdGIsDQo+Pj4gIAkJICAgICAgc3RydWN0IG5sYXR0ciAqcmF0ZV90bHYsIHN0cnVjdCB0
Y2ZfZXh0cyAqZXh0cywNCj4+PiAgCQkgICAgICB1MzIgZmxhZ3MsIHN0cnVjdCBuZXRsaW5rX2V4
dF9hY2sgKmV4dGFjaykgQEAgLTMwNjYsNg0KPj4rMzA4OSw5DQo+Pj4gQEAgaW50IHRjZl9leHRz
X3ZhbGlkYXRlKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsDQo+Pj4gc3Ry
dWN0IG5sYXR0cg0KPj4qKnRiLA0KPj4+ICAJCQkJcmV0dXJuIGVycjsNCj4+PiAgCQkJZXh0cy0+
bnJfYWN0aW9ucyA9IGVycjsNCj4+PiAgCQl9DQo+Pj4gKw0KPj4+ICsJCWlmICghdGNmX2V4dHNf
dmFsaWRhdGVfYWN0aW9ucyhleHRzLCBmbGFncykpDQo+Pj4gKwkJCXJldHVybiAtRUlOVkFMOw0K
Pj4+ICAJfQ0KPj4+ICAjZWxzZQ0KPj4+ICAJaWYgKChleHRzLT5hY3Rpb24gJiYgdGJbZXh0cy0+
YWN0aW9uXSkgfHwgZGlmZiAtLWdpdA0KPj4+IGEvbmV0L3NjaGVkL2Nsc19mbG93ZXIuYyBiL25l
dC9zY2hlZC9jbHNfZmxvd2VyLmMgaW5kZXgNCj4+PiBlYjYzNDVhMDI3ZTEuLjU1Zjg5ZjBlMzkz
ZSAxMDA2NDQNCj4+PiAtLS0gYS9uZXQvc2NoZWQvY2xzX2Zsb3dlci5jDQo+Pj4gKysrIGIvbmV0
L3NjaGVkL2Nsc19mbG93ZXIuYw0KPj4+IEBAIC0yMDM1LDcgKzIwMzUsOCBAQCBzdGF0aWMgaW50
IGZsX2NoYW5nZShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdA0KPj4+IHNrX2J1ZmYNCj4+KmluX3Nr
YiwNCj4+PiAgCX0NCj4+Pg0KPj4+ICAJZXJyID0gZmxfc2V0X3Bhcm1zKG5ldCwgdHAsIGZuZXcs
IG1hc2ssIGJhc2UsIHRiLCB0Y2FbVENBX1JBVEVdLA0KPj4+IC0JCQkgICB0cC0+Y2hhaW4tPnRt
cGx0X3ByaXYsIGZsYWdzLCBleHRhY2spOw0KPj4+ICsJCQkgICB0cC0+Y2hhaW4tPnRtcGx0X3By
aXYsIGZsYWdzIHwgZm5ldy0+ZmxhZ3MsDQo+Pj4gKwkJCSAgIGV4dGFjayk7DQo+Pg0KPj5BcmVu
J3QgeW91IG9yLWluZyBmbGFncyBmcm9tIHR3byBkaWZmZXJlbnQgcmFuZ2VzIChUQ0FfQ0xTX0ZM
QUdTXyogYW5kDQo+PlRDQV9BQ1RfRkxBR1NfKikgdGhhdCBtYXAgdG8gc2FtZSBiaXRzLCBvciBh
bSBJIG1pc3Npbmcgc29tZXRoaW5nPyBUaGlzDQo+Pmlzbid0IGV4cGxhaW5lZCBpbiBjb21taXQg
bWVzc2FnZSBzbyBpdCBpcyBoYXJkIGZvciBtZSB0byB1bmRlcnN0YW5kDQo+PnRoZSBpZGVhIGhl
cmUuDQo+WWVzLCBhcyB5b3Ugc2FpZCB3ZSB1c2UgVENBX0NMU19GTEFHU18qIG9yIFRDQV9BQ1Rf
RkxBR1NfKiBmbGFncyB0bw0KPnZhbGlkYXRlIHRoZSBhY3Rpb24gZmxhZ3MuDQo+QXMgeW91IGtu
b3csIHRoZSBUQ0FfQUNUX0ZMQUdTXyogaW4gZmxhZ3MgYXJlIHN5c3RlbSBmbGFncyhpbiBoaWdo
IDE2IGJpdHMpDQo+YW5kIHRoZSBUQ0FfQ0xTX0ZMQUdTXyogYXJlIHVzZXIgZmxhZ3MoaW4gbG93
IDE2IGJpdHMpLCBzbyB0aGV5IHdpbGwgbm90IGJlDQo+Y29uZmxpY3QuDQo+QnV0IEkgdGhpbmsg
eW91IHN1Z2dlc3Rpb24gYWxzbyBtYWtlcyBzZW5zZSB0byB1cywgZG8geW91IHRoaW5rIHdlIG5l
ZWQgdG8NCj5wYXNzIGEgc2luZ2xlIGZpbHRlciBmbGFnIHRvIG1ha2UgdGhlIHByb2Nlc3MgbW9y
ZSBjbGVhcj8NCkFmdGVyIGNvbnNpZGVyYXRpb24sIEkgdGhpbmsgaXQgaXMgYmV0dGVyIHRvIHNl
cGFyYXRlIENMUyBmbGFncyBhbmQgQUNUIGZsYWdzLiANClNvIHdlIHdpbGwgcGFzcyBDTFMgZmxh
Z3MgYXMgYSBzZXBhcmF0ZSBmbGFncywgdGhhbmtzLg0KPj4NCj4+PiAgCWlmIChlcnIpDQo+Pj4g
IAkJZ290byBlcnJvdXQ7DQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc19tYXRj
aGFsbC5jIGIvbmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jDQo+Pj4gaW5kZXggMjRmMDA0NmNlMGIz
Li4wMGI3NmZiYzFkY2UgMTAwNjQ0DQo+Pj4gLS0tIGEvbmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5j
DQo+Pj4gKysrIGIvbmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jDQo+Pj4gQEAgLTIyNiw4ICsyMjYs
OCBAQCBzdGF0aWMgaW50IG1hbGxfY2hhbmdlKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0DQo+Pj4g
c2tfYnVmZg0KPj4qaW5fc2tiLA0KPj4+ICAJCWdvdG8gZXJyX2FsbG9jX3BlcmNwdTsNCj4+PiAg
CX0NCj4+Pg0KPj4+IC0JZXJyID0gbWFsbF9zZXRfcGFybXMobmV0LCB0cCwgbmV3LCBiYXNlLCB0
YiwgdGNhW1RDQV9SQVRFXSwgZmxhZ3MsDQo+Pj4gLQkJCSAgICAgZXh0YWNrKTsNCj4+PiArCWVy
ciA9IG1hbGxfc2V0X3Bhcm1zKG5ldCwgdHAsIG5ldywgYmFzZSwgdGIsIHRjYVtUQ0FfUkFURV0s
DQo+Pj4gKwkJCSAgICAgZmxhZ3MgfCBuZXctPmZsYWdzLCBleHRhY2spOw0KPj4+ICAJaWYgKGVy
cikNCj4+PiAgCQlnb3RvIGVycl9zZXRfcGFybXM7DQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvbmV0
L3NjaGVkL2Nsc191MzIuYyBiL25ldC9zY2hlZC9jbHNfdTMyLmMgaW5kZXgNCj4+PiA0MjcyODE0
NDg3ZjAuLmZjNjcwY2M0NTEyMiAxMDA2NDQNCj4+PiAtLS0gYS9uZXQvc2NoZWQvY2xzX3UzMi5j
DQo+Pj4gKysrIGIvbmV0L3NjaGVkL2Nsc191MzIuYw0KPj4+IEBAIC04OTUsNyArODk1LDggQEAg
c3RhdGljIGludCB1MzJfY2hhbmdlKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0DQo+Pj4gc2tfYnVm
Zg0KPj4qaW5fc2tiLA0KPj4+ICAJCQlyZXR1cm4gLUVOT01FTTsNCj4+Pg0KPj4+ICAJCWVyciA9
IHUzMl9zZXRfcGFybXMobmV0LCB0cCwgYmFzZSwgbmV3LCB0YiwNCj4+PiAtCQkJCSAgICB0Y2Fb
VENBX1JBVEVdLCBmbGFncywgZXh0YWNrKTsNCj4+PiArCQkJCSAgICB0Y2FbVENBX1JBVEVdLCBm
bGFncyB8IG5ldy0+ZmxhZ3MsDQo+Pj4gKwkJCQkgICAgZXh0YWNrKTsNCj4+Pg0KPj4+ICAJCWlm
IChlcnIpIHsNCj4+PiAgCQkJdTMyX2Rlc3Ryb3lfa2V5KG5ldywgZmFsc2UpOw0KPj4+IEBAIC0x
MDYwLDggKzEwNjEsOCBAQCBzdGF0aWMgaW50IHUzMl9jaGFuZ2Uoc3RydWN0IG5ldCAqbmV0LCBz
dHJ1Y3QNCj4+c2tfYnVmZiAqaW5fc2tiLA0KPj4+ICAJfQ0KPj4+ICAjZW5kaWYNCj4+Pg0KPj4+
IC0JZXJyID0gdTMyX3NldF9wYXJtcyhuZXQsIHRwLCBiYXNlLCBuLCB0YiwgdGNhW1RDQV9SQVRF
XSwgZmxhZ3MsDQo+Pj4gLQkJCSAgICBleHRhY2spOw0KPj4+ICsJZXJyID0gdTMyX3NldF9wYXJt
cyhuZXQsIHRwLCBiYXNlLCBuLCB0YiwgdGNhW1RDQV9SQVRFXSwNCj4+PiArCQkJICAgIGZsYWdz
IHwgbi0+ZmxhZ3MsIGV4dGFjayk7DQo+Pj4gIAlpZiAoZXJyID09IDApIHsNCj4+PiAgCQlzdHJ1
Y3QgdGNfdV9rbm9kZSBfX3JjdSAqKmluczsNCj4+PiAgCQlzdHJ1Y3QgdGNfdV9rbm9kZSAqcGlu
czsNCg0K
