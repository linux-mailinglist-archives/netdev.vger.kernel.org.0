Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2283C44520D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKDLSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:18:05 -0400
Received: from mail-bn8nam11on2114.outbound.protection.outlook.com ([40.107.236.114]:43617
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229809AbhKDLSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 07:18:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlA+7niLV/ikoAxRkJc4jlJoxGlAzlN4p0SEPDGm0UC5SGArKuxq0vp3mwHCm52urMEsQLd065xzT+MHJRGHmcFKiYDizqp75bcrObZLCyknuzj3T+unEksv/mMTClwtEcFUM0AWADig2WSjBxCqAdqkblm3Ip1zaoNlybp4JAUonca+xs8SCj04jnmwMnKaHppqQ/lB5uFh+RFKaWKDNDIxrTVuShH0/irPCpnxrygDE3sRuvR1T1lalsZwSFqBPh4KrDdDxsddn2EVyW/aU0pH3IaObVX8eyMNRRtnwKGmWidD1pL+CiGV3mr4DuR3fQLnLDeOeNYilSFud4lOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlQ9cp7vdrH3V/LDeqjIJ+xmwNnlaSpRsrpqnP07/uA=;
 b=AUonFI6CPWHC81PllIbaXyLFhnZnYLTTcpsDw3fXutuem/GC9MBkkMeWLACEvQ3HiWwhfUsbGX7Z1yQ5pEqmpy/9+gB2QV5ulBfbPM2vVDYbjVsO7LwxccH5KzfrZOV2JVjPXlyEGswnPA4XI8QlHsbMcsUGAFp4YsK3w79Y848eX0l+M/DZvQ1m6QP0roncj4FGi3oLA00mz35MIWP5E2ARQ00jGQGig5Oz79IP02VWdn/9PzVKUmv8pxqfcxSasxm2r9RnLUIoByj0Yp48dIKVZDrNeauoQjzXIp4ido9EpchiS4HSf0y80As5zvvKbZrUyNGs5G5B1KBrkbHWHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlQ9cp7vdrH3V/LDeqjIJ+xmwNnlaSpRsrpqnP07/uA=;
 b=R1vXW4VmH9Pag09V/p4SsGvp+5Ro+T8vWPDGak5Km7X/tZIbSb69wmb1OyIUJlGbT93RaNQXhX2iEp1UvqnvbX9St0BVLjx8yjDVQbyvqbWiu31j5M5m6SMBElIJX6aYwjWncBui+5JzAHaeBnxkC+fScKTPmcjC1a/x/DC81kI=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB3081.namprd13.prod.outlook.com (2603:10b6:5:192::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.7; Thu, 4 Nov
 2021 11:15:25 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Thu, 4 Nov 2021
 11:15:24 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAhnPzCAADm2QIAAN9+AgAAjEFA=
Date:   Thu, 4 Nov 2021 11:15:24 +0000
Message-ID: <DM5PR1301MB21720B3D0E2FEDA79E0CFC29E78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <DM5PR1301MB21722934E954B577033F0F56E78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <DM5PR1301MB2172E10FBDD2EA06E156BEDDE78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhsfwc8f26.fsf@nvidia.com>
In-Reply-To: <ygnhsfwc8f26.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30a645f5-4d90-4bf7-c791-08d99f846620
x-ms-traffictypediagnostic: DM6PR13MB3081:
x-microsoft-antispam-prvs: <DM6PR13MB3081497778C1B31DB7DE4F93E78D9@DM6PR13MB3081.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nc+7w/lNuKKPoUgR/x+xJ/O8yWjSQ7IbkzC9mqZ2HMrlZ/1/fjwcPX7Azr4Wx6r2bDfJmkThOjIMJDc18ds9p8azV0334z0QcadUhMEjTnDQi7VW3Sn2r8+5Ogf4lBI1r7kEN/t5+fyQR809lRVYzFsNpdlVbjvyQooly7UClvvulMq/fg0CTDbzXjpVXk37C6Ksj5i5gOxklYXWz4u0W3VVZ1Nvvtsh0ZzSE8BzJ7E9tcb+WFoZ6nFsc3k8AMWSBK9k+0cW0f8bTKNa83Ke3iTp2nnhkITw3TE0aghgQP4MlkCus0M9jG4U07RHwMqMkZjR0gjTR61s4RuercZ46pLTr/DDM2M3Xs0v/cvFrOrVqWnedg8XUK2wVABaLSFGuiSNB1XtsPp5j7ZUtHbJwQ4t/4JCdIADuiTNxczo7rw57zgXKPGnkzzhcqm42iR2H9Zu/6EWq14T67XtgEjYD5PbYIqNWuViaq8q0djIOrG2CTgogkocU9uy6sK859OPmMZEVCeDYPKRjsZ9xI1kc9jPmOGG+9KMpaEn+vHCxeiD0JKBzR0AGg9QFynTSpRdrKH1xoTXnN7LDXPJKIxxDYMMih9rWCfFMjvjx629KS0kp/jTF8bsCpSyl744VA57ATnCOYH3BNcoiBhs+M0EnmUL/KsLv2kWL6aHUyU1sP78A0dvdgN3E2xBLMLXW8ewqd7XHt9lqpt8Amvqj/tQFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39840400004)(15650500001)(5660300002)(33656002)(52536014)(186003)(7696005)(6506007)(508600001)(44832011)(66556008)(9686003)(8676002)(55016002)(66946007)(86362001)(66476007)(107886003)(66446008)(64756008)(71200400001)(54906003)(8936002)(26005)(38070700005)(316002)(6916009)(122000001)(38100700002)(2906002)(76116006)(83380400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3FMRG53WDQyT0tYWFlYb3hSYmRteG40bHcyYnVjVytDeUZrbjU4aFNGU1J5?=
 =?utf-8?B?NkZ6bFRUdjBUa25vZ2V5d1R3VGN5ZlFoSzZ0ZW9sZlpFUUN4eTZ1cXdrOWpZ?=
 =?utf-8?B?b3ZHT1Q2cDVLMmZpUXFsK1VzNEZIWC8rSy84eHNLNzlwWkF2clZLMFZFWU9G?=
 =?utf-8?B?NUwralFLZVp4SjNHRUZxdFAvK0VGYnJ2NzNDekRFQi9IT053OGhiajlHVVpu?=
 =?utf-8?B?RG5vUUk0enQrY3NnSmRLZGVwcWdwbW05anROZjN5MDVoVWIwNkE1OFA1REVz?=
 =?utf-8?B?QWkwdVhvMkhxbGZLZGIyRm5nT09RTFFxT0F0eHRoTVVvcDI5ZHA3YkxLOE5k?=
 =?utf-8?B?b2xObGhBQS9ueEZsR2grYVFFUWtwVkkrMi9hRHMyT2kvWVZSRkFkWEJ6TGhG?=
 =?utf-8?B?ODBjZXpvb0VpODRtVmhtQnlWOHNpQW9DNmNXajRRdUFSSmNKTnJrSUhJTjVC?=
 =?utf-8?B?dG03RTkzWUVSQ1pZV3pHcjlTTmVlQWViWFVsWVlYZVk3SnRzT1FPbHZWRFht?=
 =?utf-8?B?L1dmdEJuSDFxU1ViT3NWd1lSRCt4dlVqcThnd1FtT3pYVGpkSXlGdVVSYWFO?=
 =?utf-8?B?WHJFWWdwU2kzUG9QN2gxVnpPbHVLeWpkS3B6aTdLWldTeTVUd3hYcmlrS2x3?=
 =?utf-8?B?TTJTUW1hSXJzeTBkckR5Zm5mbk9NdzBURGg0TjFVd282TWhDWldYdEhMVCtT?=
 =?utf-8?B?TFBObkxEdHhpYjYrRFVKOUpWWHdhd2E3dzcranA3cEljYmdqV0h2cXl2K0hM?=
 =?utf-8?B?T0tEQVR1a0w4NzdaZGYxZERmdm1TdkQ5cjI3dGZhR0FPMFV2NEQvWFlXNzk5?=
 =?utf-8?B?VGV5QWRreVU2Um93QXF3MXBRMHlhdklGVVI3N1UvSCsyMld5VWNpV0pMamFr?=
 =?utf-8?B?eHJnNEdQczE5VkJzWEtFM2tmQTRVTjNKQ2FDOWdjYk1WNGVFSElSQ20wWnBE?=
 =?utf-8?B?d0JvOUFBREY1Y291QUI0RmVXWVAzK2xWNGxzaXpxdE1ZSlFlSXc0aFBUM25V?=
 =?utf-8?B?bnBQOXd3UnQrdU9UOSsyaFdwbExBZmdFMk9EWld5ZGFWSWdrbmNoTDFkWmc5?=
 =?utf-8?B?NHFmVXg0R0lCMTVPZzBlU3ZTNWMyTXdGYlNkRklQZzhkMlYrSlptTEY0VVds?=
 =?utf-8?B?cDlRc3pNVS9xWGFxbXNqRXdMUjgvcmdRZmhUTUwwNUZjU1ljaGVHS01CSlhH?=
 =?utf-8?B?SmM3ZVhXMnJlRzJxLzMyZTZKdG1UZ2paemVWOWhqc0RoVXo1dVFEZGRZbENh?=
 =?utf-8?B?TjZteTZZM0hTcmE1Z3VHalBRekFKSWpvZ1FCQjN0S0IxZWh1YVFOeVdueEVZ?=
 =?utf-8?B?c2I2TkozeVVFSE5QbGtZcWJoczlnVTRwS1ptUjJLWXUvSEQxUVVqcnhqU0lM?=
 =?utf-8?B?cGt4bXI1cnJGWU1RQmhweWNDTUxldWpiRkJFd2ZCNEhzajZlYTkxTVlNKzVF?=
 =?utf-8?B?RFU1emJwM2RreldwQXo1M1FlMXBpOXR2VGRkaFhGNFh1OFJzekg3UlJGNDU3?=
 =?utf-8?B?cjEySUQ2SFAvZ3ZzdjBoV1Z5Mi8vZU4vbWRaYnNWZmpNZDZ1bVNTU29SUis1?=
 =?utf-8?B?NTYvbFUyR25EMUlhenQ1Z2JlRkF3cXRFWStxYlNneEJaWU9BSU1zSVZVRmV1?=
 =?utf-8?B?TkgrR2svcXd6Y0lIMmlHNUdLNnVvazVySURrTmZJVFlGUlN6TWVxNmpLK2Yx?=
 =?utf-8?B?aGwwR1d3eWhwQmtEK0d3UnIzZCtvZUZSU1VBQkZscTRPd1hnQkdtNmlzbEJY?=
 =?utf-8?B?ckFKZWlFT2plZTdmVk1LOXAxajNLT25Gd20wcFB6RzRsanphN3ZZQjBMS2NK?=
 =?utf-8?B?eG03aVlreVlKbW9DTTZyZlhEVjlrMVRCWkJENXBVREpCT0trM3h5dWlrbzhk?=
 =?utf-8?B?a2wxU1V3U1h2VFlVR0NjYlJ2aGljVWExTERyYkFDM3ptOUh4S05pK1RkLy9O?=
 =?utf-8?B?MW85N2syczNDSzhmU3VqNlBBaG8yNDJ4M3gwUjZCMUkrNWpuaTlHeU9Cc1hU?=
 =?utf-8?B?bWgzZmFCS1dwcmVxbVNLVVp1blJJTU8xMzIxeFB0S3gwbGxqUWpmM3B3cThP?=
 =?utf-8?B?M2k3RnBmNi93cDNIZ2JKSjRvaWpDTWtlaGNRcGxoYkpibXZQM1poRmJzTEM1?=
 =?utf-8?B?enBhVTFnenRCNFpBKzhSZVJzM0tMVHlEU3d6Vm9ZbmduQkFpNG1UZTZaaEtO?=
 =?utf-8?B?S0xQSzdJTnZwQlkvOHgrbk9nS2MwM1BiZllCU1dEQjZ2RW1pUC8yVXl2ZW9R?=
 =?utf-8?B?Lzg1UHpEc2c5c1hVd0tSbmlOMlhnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a645f5-4d90-4bf7-c791-08d99f846620
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 11:15:24.5011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBMZ1WgwYFXhQEgNRa0T0Vv8TmfTbgpGsTkc0HN+1j9X0w2tX6XfSeZULFzrmUXP92vyb4i6FFRK1LKMLJZkA5pwHCmOYi0ZmT4c5jbNzYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgNCwgMjAyMSA1OjA3IFBNLCBWbGFkIEJ1c2xvdiB3cm90ZToNCj5PbiBUaHUg
MDQgTm92IDIwMjEgYXQgMDc6NTEsIEJhb3dlbiBaaGVuZyA8YmFvd2VuLnpoZW5nQGNvcmlnaW5l
LmNvbT4NCj53cm90ZToNCj4+IFNvcnJ5IGZvciByZXBseSB0aGlzIG1lc3NhZ2UgYWdhaW4uDQo+
PiBPbiBOb3ZlbWJlciA0LCAyMDIxIDEwOjMxIEFNLCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+Pj5U
aGFua3MgZm9yIHlvdXIgcmV2aWV3IGFuZCBzb3JyeSBmb3IgZGVsYXkgaW4gcmVzcG9uZGluZy4N
Cj4+Pk9uIE9jdG9iZXIgMzAsIDIwMjEgMjowMSBBTSwgVmxhZCBCdXNsb3Ygd3JvdGU6DQo+Pj4+
T24gVGh1IDI4IE9jdCAyMDIxIGF0IDE0OjA2LCBTaW1vbiBIb3JtYW4NCj48c2ltb24uaG9ybWFu
QGNvcmlnaW5lLmNvbT4NCj4+Pj53cm90ZToNCj4+Pj4+IEZyb206IEJhb3dlbiBaaGVuZyA8YmFv
d2VuLnpoZW5nQGNvcmlnaW5lLmNvbT4NCj4+Pj4+DQo+Pj4+PiBBZGQgcHJvY2VzcyB0byB2YWxp
ZGF0ZSBmbGFncyBvZiBmaWx0ZXIgYW5kIGFjdGlvbnMgd2hlbiBhZGRpbmcgYQ0KPj4+Pj4gdGMg
ZmlsdGVyLg0KPj4+Pj4NCj4+Pj4+IFdlIG5lZWQgdG8gcHJldmVudCBhZGRpbmcgZmlsdGVyIHdp
dGggZmxhZ3MgY29uZmxpY3RzIHdpdGggaXRzIGFjdGlvbnMuDQo+Pj4+Pg0KPj4+Pj4gU2lnbmVk
LW9mZi1ieTogQmFvd2VuIFpoZW5nIDxiYW93ZW4uemhlbmdAY29yaWdpbmUuY29tPg0KPj4+Pj4g
U2lnbmVkLW9mZi1ieTogTG91aXMgUGVlbnMgPGxvdWlzLnBlZW5zQGNvcmlnaW5lLmNvbT4NCj4+
Pj4+IFNpZ25lZC1vZmYtYnk6IFNpbW9uIEhvcm1hbiA8c2ltb24uaG9ybWFuQGNvcmlnaW5lLmNv
bT4NCj4+Pj4+IC0tLQ0KPj4+Pj4gIG5ldC9zY2hlZC9jbHNfYXBpLmMgICAgICB8IDI2ICsrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+Pj4+PiAgbmV0L3NjaGVkL2Nsc19mbG93ZXIuYyAgIHwg
IDMgKystDQo+Pj4+PiAgbmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jIHwgIDQgKystLQ0KPj4+Pj4g
IG5ldC9zY2hlZC9jbHNfdTMyLmMgICAgICB8ICA3ICsrKystLS0NCj4+Pj4+ICA0IGZpbGVzIGNo
YW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+Pj4+Pg0KPj4+Pj4gZGlm
ZiAtLWdpdCBhL25ldC9zY2hlZC9jbHNfYXBpLmMgYi9uZXQvc2NoZWQvY2xzX2FwaS5jIGluZGV4
DQo+Pj4+PiAzNTFkOTM5ODhiOGIuLjgwNjQ3ZGE5NzEzYSAxMDA2NDQNCj4+Pj4+IC0tLSBhL25l
dC9zY2hlZC9jbHNfYXBpLmMNCj4+Pj4+ICsrKyBiL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4+Pj4+
IEBAIC0zMDI1LDYgKzMwMjUsMjkgQEAgdm9pZCB0Y2ZfZXh0c19kZXN0cm95KHN0cnVjdCB0Y2Zf
ZXh0cyAqZXh0cykNCj4+Pj4+IH0gRVhQT1JUX1NZTUJPTCh0Y2ZfZXh0c19kZXN0cm95KTsNCj4+
Pj4+DQo+Pj4+PiArc3RhdGljIGJvb2wgdGNmX2V4dHNfdmFsaWRhdGVfYWN0aW9ucyhjb25zdCBz
dHJ1Y3QgdGNmX2V4dHMgKmV4dHMsDQo+Pj4+PiArdTMyIGZsYWdzKSB7ICNpZmRlZiBDT05GSUdf
TkVUX0NMU19BQ1QNCj4+Pj4+ICsJYm9vbCBza2lwX3N3ID0gdGNfc2tpcF9zdyhmbGFncyk7DQo+
Pj4+PiArCWJvb2wgc2tpcF9odyA9IHRjX3NraXBfaHcoZmxhZ3MpOw0KPj4+Pj4gKwlpbnQgaTsN
Cj4+Pj4+ICsNCj4+Pj4+ICsJaWYgKCEoc2tpcF9zdyB8IHNraXBfaHcpKQ0KPj4+Pj4gKwkJcmV0
dXJuIHRydWU7DQo+Pj4+PiArDQo+Pj4+PiArCWZvciAoaSA9IDA7IGkgPCBleHRzLT5ucl9hY3Rp
b25zOyBpKyspIHsNCj4+Pj4+ICsJCXN0cnVjdCB0Y19hY3Rpb24gKmEgPSBleHRzLT5hY3Rpb25z
W2ldOw0KPj4+Pj4gKw0KPj4+Pj4gKwkJaWYgKChza2lwX3N3ICYmIHRjX2FjdF9za2lwX2h3KGEt
PnRjZmFfZmxhZ3MpKSB8fA0KPj4+Pj4gKwkJICAgIChza2lwX2h3ICYmIHRjX2FjdF9za2lwX3N3
KGEtPnRjZmFfZmxhZ3MpKSkNCj4+Pj4+ICsJCQlyZXR1cm4gZmFsc2U7DQo+Pj4+PiArCX0NCj4+
Pj4+ICsJcmV0dXJuIHRydWU7DQo+Pj4+PiArI2Vsc2UNCj4+Pj4+ICsJcmV0dXJuIHRydWU7DQo+
Pj4+PiArI2VuZGlmDQo+Pj4+PiArfQ0KPj4+Pj4gKw0KPj4+Pg0KPj4+Pkkga25vdyBKYW1hbCBz
dWdnZXN0ZWQgdG8gaGF2ZSBza2lwX3N3IGZvciBhY3Rpb25zLCBidXQgaXQNCj4+Pj5jb21wbGlj
YXRlcyB0aGUgY29kZSBhbmQgSSdtIHN0aWxsIG5vdCBlbnRpcmVseSB1bmRlcnN0YW5kIHdoeSBp
dCBpcw0KPm5lY2Vzc2FyeS4NCj4+Pj5BZnRlciBhbGwsIGFjdGlvbiBjYW4gb25seSBnZXQgYXBw
bGllZCB0byBhIHBhY2tldCBpZiB0aGUgcGFja2V0IGhhcw0KPj4+PmJlZW4gbWF0Y2hlZCBieSBz
b21lIGZpbHRlciBhbmQgZmlsdGVycyBhbHJlYWR5IGhhdmUgc2tpcCBzdy9odw0KPj4+PmNvbnRy
b2xzLiBGb3Jnb2luZyBhY3Rpb24gc2tpcF9zdyBmbGFnIHdvdWxkOg0KPj4+Pg0KPj4+Pi0gQWxs
ZXZpYXRlIHRoZSBuZWVkIHRvIHZhbGlkYXRlIHRoYXQgZmlsdGVyIGFuZCBhY3Rpb24gZmxhZ3Mg
YXJlIGNvbXBhdGlibGUuDQo+Pj4+KHRyeWluZyB0byBvZmZsb2FkIGZpbHRlciB0aGF0IHBvaW50
cyB0byBleGlzdGluZyBza2lwX2h3IGFjdGlvbg0KPj4+PndvdWxkIGp1c3QgZmFpbCBiZWNhdXNl
IHRoZSBkcml2ZXIgd291bGRuJ3QgZmluZCB0aGUgYWN0aW9uIHdpdGgNCj4+Pj5wcm92aWRlZCBp
ZCBpbiBpdHMgdGFibGVzKQ0KPj4+Pg0KPj4+Pi0gUmVtb3ZlIHRoZSBuZWVkIHRvIGFkZCBtb3Jl
IGNvbmRpdGlvbmFscyBpbnRvIFRDIHNvZnR3YXJlIGRhdGEgcGF0aA0KPj4+PmluIHBhdGNoIDQu
DQo+Pj4+DQo+Pj4+V0RZVD8NCj4+PkFzIHdlIGRpc2N1c3NlZCB3aXRoIEphbWFsLCB3ZSB3aWxs
IGtlZXAgdGhlIGZsYWcgb2Ygc2tpcF9zdyBhbmQgd2UNCj4+Pm5lZWQgdG8gbWFrZSBleGFjdGx5
IG1hdGNoIGZvciB0aGUgYWN0aW9ucyB3aXRoIGZsYWdzIGFuZCB0aGUgZmlsdGVyDQo+Pj5zcGVj
aWZpYyBhY3Rpb24gd2l0aCBpbmRleC4NCj4+Pj4NCj4+Pj4+ICBpbnQgdGNmX2V4dHNfdmFsaWRh
dGUoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgdGNmX3Byb3RvICp0cCwNCj4+Pj4+IHN0cnVjdCBu
bGF0dHINCj4+PioqdGIsDQo+Pj4+PiAgCQkgICAgICBzdHJ1Y3QgbmxhdHRyICpyYXRlX3Rsdiwg
c3RydWN0IHRjZl9leHRzICpleHRzLA0KPj4+Pj4gIAkJICAgICAgdTMyIGZsYWdzLCBzdHJ1Y3Qg
bmV0bGlua19leHRfYWNrICpleHRhY2spIEBAIC0zMDY2LDYNCj4+Pj4rMzA4OSw5DQo+Pj4+PiBA
QCBpbnQgdGNmX2V4dHNfdmFsaWRhdGUoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgdGNmX3Byb3Rv
ICp0cCwNCj4+Pj4+IHN0cnVjdCBubGF0dHINCj4+Pj4qKnRiLA0KPj4+Pj4gIAkJCQlyZXR1cm4g
ZXJyOw0KPj4+Pj4gIAkJCWV4dHMtPm5yX2FjdGlvbnMgPSBlcnI7DQo+Pj4+PiAgCQl9DQo+Pj4+
PiArDQo+Pj4+PiArCQlpZiAoIXRjZl9leHRzX3ZhbGlkYXRlX2FjdGlvbnMoZXh0cywgZmxhZ3Mp
KQ0KPj4+Pj4gKwkJCXJldHVybiAtRUlOVkFMOw0KPj4+Pj4gIAl9DQo+Pj4+PiAgI2Vsc2UNCj4+
Pj4+ICAJaWYgKChleHRzLT5hY3Rpb24gJiYgdGJbZXh0cy0+YWN0aW9uXSkgfHwgZGlmZiAtLWdp
dA0KPj4+Pj4gYS9uZXQvc2NoZWQvY2xzX2Zsb3dlci5jIGIvbmV0L3NjaGVkL2Nsc19mbG93ZXIu
YyBpbmRleA0KPj4+Pj4gZWI2MzQ1YTAyN2UxLi41NWY4OWYwZTM5M2UgMTAwNjQ0DQo+Pj4+PiAt
LS0gYS9uZXQvc2NoZWQvY2xzX2Zsb3dlci5jDQo+Pj4+PiArKysgYi9uZXQvc2NoZWQvY2xzX2Zs
b3dlci5jDQo+Pj4+PiBAQCAtMjAzNSw3ICsyMDM1LDggQEAgc3RhdGljIGludCBmbF9jaGFuZ2Uo
c3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QNCj4+Pj4+IHNrX2J1ZmYNCj4+Pj4qaW5fc2tiLA0KPj4+
Pj4gIAl9DQo+Pj4+Pg0KPj4+Pj4gIAllcnIgPSBmbF9zZXRfcGFybXMobmV0LCB0cCwgZm5ldywg
bWFzaywgYmFzZSwgdGIsIHRjYVtUQ0FfUkFURV0sDQo+Pj4+PiAtCQkJICAgdHAtPmNoYWluLT50
bXBsdF9wcml2LCBmbGFncywgZXh0YWNrKTsNCj4+Pj4+ICsJCQkgICB0cC0+Y2hhaW4tPnRtcGx0
X3ByaXYsIGZsYWdzIHwgZm5ldy0+ZmxhZ3MsDQo+Pj4+PiArCQkJICAgZXh0YWNrKTsNCj4+Pj4N
Cj4+Pj5BcmVuJ3QgeW91IG9yLWluZyBmbGFncyBmcm9tIHR3byBkaWZmZXJlbnQgcmFuZ2VzIChU
Q0FfQ0xTX0ZMQUdTXyoNCj4+Pj5hbmQNCj4+Pj5UQ0FfQUNUX0ZMQUdTXyopIHRoYXQgbWFwIHRv
IHNhbWUgYml0cywgb3IgYW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCj4+Pj5UaGlzIGlzbid0IGV4
cGxhaW5lZCBpbiBjb21taXQgbWVzc2FnZSBzbyBpdCBpcyBoYXJkIGZvciBtZSB0bw0KPj4+PnVu
ZGVyc3RhbmQgdGhlIGlkZWEgaGVyZS4NCj4+PlllcywgYXMgeW91IHNhaWQgd2UgdXNlIFRDQV9D
TFNfRkxBR1NfKiBvciBUQ0FfQUNUX0ZMQUdTXyogZmxhZ3MgdG8NCj4+PnZhbGlkYXRlIHRoZSBh
Y3Rpb24gZmxhZ3MuDQo+Pj5BcyB5b3Uga25vdywgdGhlIFRDQV9BQ1RfRkxBR1NfKiBpbiBmbGFn
cyBhcmUgc3lzdGVtIGZsYWdzKGluIGhpZ2ggMTYNCj4+PmJpdHMpIGFuZCB0aGUgVENBX0NMU19G
TEFHU18qIGFyZSB1c2VyIGZsYWdzKGluIGxvdyAxNiBiaXRzKSwgc28gdGhleQ0KPj4+d2lsbCBu
b3QgYmUgY29uZmxpY3QuDQo+DQo+SW5kZWVkLCBjdXJyZW50bHkgYXZhaWxhYmxlIFRDQV9DTFNf
RkxBR1NfKiBmaXQgaW50byBmaXJzdCAxNiBiaXRzLCBidXQgdGhlIGZpZWxkDQo+aXRzZWxmIGlz
IDMyIGJpdHMgYW5kIHdpdGggYWRkaXRpb24gb2YgbW9yZSBmbGFncyBpbiB0aGUgZnV0dXJlIGhp
Z2hlciBiaXRzIG1heQ0KPnN0YXJ0IHRvIGJlIHVzZWQgc2luY2UgVENBX0NMU19GTEFHU18qIGFu
ZA0KPlRDQV9BQ1RfRkxBR1NfKiBhcmUgaW5kZXBlbmRlbnQgc2V0cy4NClRoYW5rcywgd2Ugd2ls
bCB1c2UgYSBzaW5nbGUgcGFyYW1ldGVyIGFzIHRoZSBmaWx0ZXIgZmxhZy4NCj4NCj4+PkJ1dCBJ
IHRoaW5rIHlvdSBzdWdnZXN0aW9uIGFsc28gbWFrZXMgc2Vuc2UgdG8gdXMsIGRvIHlvdSB0aGlu
ayB3ZQ0KPj4+bmVlZCB0byBwYXNzIGEgc2luZ2xlIGZpbHRlciBmbGFnIHRvIG1ha2UgdGhlIHBy
b2Nlc3MgbW9yZSBjbGVhcj8NCj4+IEFmdGVyIGNvbnNpZGVyYXRpb24sIEkgdGhpbmsgaXQgaXMg
YmV0dGVyIHRvIHNlcGFyYXRlIENMUyBmbGFncyBhbmQgQUNUIGZsYWdzLg0KPj4gU28gd2Ugd2ls
bCBwYXNzIENMUyBmbGFncyBhcyBhIHNlcGFyYXRlIGZsYWdzLCB0aGFua3MuDQo+DQo+UGxlYXNl
IGFsc28gdmFsaWRhdGUgaW5zaWRlIHRjZl9hY3Rpb25faW5pdCgpIGluc3RlYWQgb2YgY3JlYXRp
bmcgbmV3DQo+dGNmX2V4dHNfdmFsaWRhdGVfYWN0aW9ucygpIGZ1bmN0aW9uLCBpZiBwb3NzaWJs
ZS4gSSB0aGluayB0aGlzIHdpbGwgbGVhZCB0byBjbGVhbmVyDQo+YW5kIG1vcmUgc2ltcGxlIGNv
ZGUuDQpUaGFua3MsIHdlIHdpbGwgY29uc2lkZXIgdG8gaW1wbGVtZW50IHRoZSB2YWxpZGF0aW9u
IGluc2lkZSB0Y2ZfYWN0aW9uX2luaXQoKS4NCj4NCj4+Pj4NCj4+Pj4+ICAJaWYgKGVycikNCj4+
Pj4+ICAJCWdvdG8gZXJyb3V0Ow0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQv
Y2xzX21hdGNoYWxsLmMgYi9uZXQvc2NoZWQvY2xzX21hdGNoYWxsLmMNCj4+Pj4+IGluZGV4IDI0
ZjAwNDZjZTBiMy4uMDBiNzZmYmMxZGNlIDEwMDY0NA0KPj4+Pj4gLS0tIGEvbmV0L3NjaGVkL2Ns
c19tYXRjaGFsbC5jDQo+Pj4+PiArKysgYi9uZXQvc2NoZWQvY2xzX21hdGNoYWxsLmMNCj4+Pj4+
IEBAIC0yMjYsOCArMjI2LDggQEAgc3RhdGljIGludCBtYWxsX2NoYW5nZShzdHJ1Y3QgbmV0ICpu
ZXQsIHN0cnVjdA0KPj4+Pj4gc2tfYnVmZg0KPj4+Pippbl9za2IsDQo+Pj4+PiAgCQlnb3RvIGVy
cl9hbGxvY19wZXJjcHU7DQo+Pj4+PiAgCX0NCj4+Pj4+DQo+Pj4+PiAtCWVyciA9IG1hbGxfc2V0
X3Bhcm1zKG5ldCwgdHAsIG5ldywgYmFzZSwgdGIsIHRjYVtUQ0FfUkFURV0sIGZsYWdzLA0KPj4+
Pj4gLQkJCSAgICAgZXh0YWNrKTsNCj4+Pj4+ICsJZXJyID0gbWFsbF9zZXRfcGFybXMobmV0LCB0
cCwgbmV3LCBiYXNlLCB0YiwgdGNhW1RDQV9SQVRFXSwNCj4+Pj4+ICsJCQkgICAgIGZsYWdzIHwg
bmV3LT5mbGFncywgZXh0YWNrKTsNCj4+Pj4+ICAJaWYgKGVycikNCj4+Pj4+ICAJCWdvdG8gZXJy
X3NldF9wYXJtczsNCj4+Pj4+DQo+Pj4+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc191MzIu
YyBiL25ldC9zY2hlZC9jbHNfdTMyLmMgaW5kZXgNCj4+Pj4+IDQyNzI4MTQ0ODdmMC4uZmM2NzBj
YzQ1MTIyIDEwMDY0NA0KPj4+Pj4gLS0tIGEvbmV0L3NjaGVkL2Nsc191MzIuYw0KPj4+Pj4gKysr
IGIvbmV0L3NjaGVkL2Nsc191MzIuYw0KPj4+Pj4gQEAgLTg5NSw3ICs4OTUsOCBAQCBzdGF0aWMg
aW50IHUzMl9jaGFuZ2Uoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QNCj4+Pj4+IHNrX2J1ZmYNCj4+
Pj4qaW5fc2tiLA0KPj4+Pj4gIAkJCXJldHVybiAtRU5PTUVNOw0KPj4+Pj4NCj4+Pj4+ICAJCWVy
ciA9IHUzMl9zZXRfcGFybXMobmV0LCB0cCwgYmFzZSwgbmV3LCB0YiwNCj4+Pj4+IC0JCQkJICAg
IHRjYVtUQ0FfUkFURV0sIGZsYWdzLCBleHRhY2spOw0KPj4+Pj4gKwkJCQkgICAgdGNhW1RDQV9S
QVRFXSwgZmxhZ3MgfCBuZXctPmZsYWdzLA0KPj4+Pj4gKwkJCQkgICAgZXh0YWNrKTsNCj4+Pj4+
DQo+Pj4+PiAgCQlpZiAoZXJyKSB7DQo+Pj4+PiAgCQkJdTMyX2Rlc3Ryb3lfa2V5KG5ldywgZmFs
c2UpOw0KPj4+Pj4gQEAgLTEwNjAsOCArMTA2MSw4IEBAIHN0YXRpYyBpbnQgdTMyX2NoYW5nZShz
dHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdA0KPj4+PnNrX2J1ZmYgKmluX3NrYiwNCj4+Pj4+ICAJfQ0K
Pj4+Pj4gICNlbmRpZg0KPj4+Pj4NCj4+Pj4+IC0JZXJyID0gdTMyX3NldF9wYXJtcyhuZXQsIHRw
LCBiYXNlLCBuLCB0YiwgdGNhW1RDQV9SQVRFXSwgZmxhZ3MsDQo+Pj4+PiAtCQkJICAgIGV4dGFj
ayk7DQo+Pj4+PiArCWVyciA9IHUzMl9zZXRfcGFybXMobmV0LCB0cCwgYmFzZSwgbiwgdGIsIHRj
YVtUQ0FfUkFURV0sDQo+Pj4+PiArCQkJICAgIGZsYWdzIHwgbi0+ZmxhZ3MsIGV4dGFjayk7DQo+
Pj4+PiAgCWlmIChlcnIgPT0gMCkgew0KPj4+Pj4gIAkJc3RydWN0IHRjX3Vfa25vZGUgX19yY3Ug
KippbnM7DQo+Pj4+PiAgCQlzdHJ1Y3QgdGNfdV9rbm9kZSAqcGluczsNCg0K
