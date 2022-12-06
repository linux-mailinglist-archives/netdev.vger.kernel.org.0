Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A86644E00
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiLFVdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLFVdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:33:38 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEE53FB8A;
        Tue,  6 Dec 2022 13:33:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGtOaW+v+261Q4VxGG+lsd0rG4v9LZFzABI70EzhGcwut/w3o6CCoLwwQQGbjkopIPpOtDzk7bKk4oln98x1qe3dj+JpoBpfigUWSiPvO0E0RBSIEavFE1W0Pr8hNXN20zSAHUprFmG4tcDGFzWqrNDvM2xF+oe61Xm8HdSLYTQv6EkwaqM0bZVwON++H0Rphy0QZiQtg64Hzql1t8VhmeCr2VZ4kYGMiDV642lHhCLZbNxjlj6kFCJhc33W6fpOcysoNvNbaSr8icM3bnbt7Wowgln5s6QuHB8VqXO8nOvNWm2KdJdNz6PYU+QOycduozI5ba16sX2OzNtUu1MRRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4n4kk0dFATUfH0uRslde54m+xvg8Sg3FkBpoc/c6Q6E=;
 b=RL4YIz7HB34z7oZP06I/dK4T2pB1eoq7JZowsTbPU0WnuW3pycHhq61MwmhtwdXAxe2u020OkbU21W8MO4uFBnW1pW5FJA79+2e5BPCQtdt4vLLmdE3I0fUObDaCVw1s0fO++B+dT0zpHEb+irsH8yi+wx+UZrRMaZ2XqlFJ9ZSkXgi+crb/PsNzO8k0DsxJ9SwnzrYpRQptCY36L10E0SxJHzKjoGerjUbs8iRXSDMoeGLELmZZpeWjD8QoX2l1qHCCZqDWxGZg7m6DCjahErNmOEvghN4KDXjJyKqfSCAj1CD2nc9LC4lNkaqmZu/kZIqnFyWuC4fv+7TJ5l4QQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n4kk0dFATUfH0uRslde54m+xvg8Sg3FkBpoc/c6Q6E=;
 b=nJGlATuVaniVkXr9nI3vZftdfPLt5UjfT8856sZGwmOig0sj+hqnFaX1CoqWZSbxOnELuEilvOcfhokvaOzo/CCz/Z5OT5najuqMXULvqLNJvzX7qCpCz5RI2Rdys3OkfIHpyCKJwu6oEXN5N58N1nw56m4smrBtMbE/AAcdDdI4iselhXybJ5B3AdvwE4e2WKPx57AhCv3zpnlhxmcZlBDzhljT0WTOZE4y4+L2oOsS0tdbEBOBT8HT8ZsM4Xc3Lsb7q5mPNDQg4c8E8q02VPX/nyz97ncW/SnrbVV7DYntyXRkhdmyRkidBW4N8ygSeE3lBm5UyzBVBot0mFbggA==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SJ0PR12MB7083.namprd12.prod.outlook.com (2603:10b6:a03:4ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 21:33:34 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 21:33:34 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>, Jiri Pirko <jiri@resnulli.us>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] macsec: Add support for IFLA_MACSEC_OFFLOAD
 in the netlink layer
Thread-Topic: [PATCH net-next v2] macsec: Add support for IFLA_MACSEC_OFFLOAD
 in the netlink layer
Thread-Index: AQHZCVDs24uPKOd80Uu6z2zKKF6Xb65glBqAgAAy6WCAABWJgIAAK1oAgABZ/1A=
Date:   Tue, 6 Dec 2022 21:33:34 +0000
Message-ID: <IA1PR12MB6353D1AC508A6AD193E4A629AB1B9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221206085757.5816-1-ehakim@nvidia.com>
 <Y48IVReEUBmQza81@nanopsycho>
 <IA1PR12MB6353D358E112EE09C4DD770CAB1B9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <Y49FGzwBdyC/xHxH@nanopsycho> <Y49peLs4FJSFW1HR@hog>
In-Reply-To: <Y49peLs4FJSFW1HR@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SJ0PR12MB7083:EE_
x-ms-office365-filtering-correlation-id: 70d3f101-44be-4cde-9fb1-08dad7d1877e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ACE5mtonT15sYGUL7heaQNE7uR4QTNMlMDDIbW/aNzJ7tyb0gPrWsvUjmR6DIbdzdp9w8hpt/DHSw7jlegaT7PDIH+rcpj3QuXorVZ32K/L1K7CcHko1GtA5rrY3u7AkIcAHShUdSGH7HMIabW2qO3xzvPRr6qxGnPwAk6rkNxzqyfeMgJ3VawEbHSGu1BFcyMghnKgCunZlQd64OjFuOdwAXUVoLjCTF5yXZvC0mbTNT/Y5yDiH3FSofTtRlZfUPF4JaYbEoN3s5Q1qFRBk0mTz/Bc7zzBoTlb1UfqXzcJ2DfRYgQ5rE6gkjplwsujFBDMP2LxwuWGsee/EjN6D0OKmEWeZDSg44Rq8J4Ww0w06MPsRUKKuubfqQP9KfolXBkqMj288VYkqQCiKgzGwJGsesEx/WwL6sj614mwoS0RGSsttByMd4ca6jNfd7ipJ0rVEES3qpEEq2PRmOCr/wIcdacUu29r50wLdCM706xTadUxdrkHoopsq+/Dg3mlGvzYBd+iop9jDQm6cvipKteta7hFT+NVss8rcV198VLB+egmNgljbZoamJggGBlgYIr9pXEaExHVhpXY0+LiOLDsSe+RjsjnLN9evjjFjYOs3kgzuXvyOyWMbnZYx2C4OCogqkxul9eKaUNk6O/H/lg21vgpnQ58wNVHkCwb/oFzOP8gDdGgXsTeTOSANbl4al/PkV8CZgnYDtARUfMbwVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199015)(5660300002)(86362001)(8936002)(4326008)(41300700001)(33656002)(2906002)(38070700005)(122000001)(83380400001)(66476007)(54906003)(66446008)(316002)(76116006)(66556008)(110136005)(66946007)(71200400001)(38100700002)(55016003)(52536014)(8676002)(478600001)(6506007)(7696005)(26005)(53546011)(186003)(9686003)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3ZqNlJUVVUrUUFoV2ZZSTgyTGRaTmMxUk5rR0dnYmRUOUhnS0puZWZwM0Rn?=
 =?utf-8?B?TFhnSE5YT3AvYXBwNjg3T1kyVHcxNEZRTzBhdGtUS1ZDMmkwQmFZYk5BOGtY?=
 =?utf-8?B?WWZnVWRHNzdVYkwyM2dEbTQ5Rlo0Y2ZHZWxpMEcrRkkrUWpXQjdDWnhXWVpt?=
 =?utf-8?B?UFl3dEYzNjl5cGFOdGVFZHR2VThkcHlRaVpkSEc2bHNPSzBvVTd5Qmh0aFRT?=
 =?utf-8?B?Zjk3K21kT0ZuN3didzZwSkZpR08vZTVjODdEcWZkR0RGWTNCTSsrUytBeWgw?=
 =?utf-8?B?RzRNZFBrbkxMMkIyandsRjFZTWducjBkMzVrTFBmT2RNc2lPdHJWUGxjRC9P?=
 =?utf-8?B?alBva043RmdNSkJPQzJQUUQwT0hKeU9IWTg3SlN1TWp1WjRMeGhIU3czNm5J?=
 =?utf-8?B?Uzl5d1huTG52bHNYQWRNYjBDY2h2QTVJd3NzQS9zSDdmRjFyOHBFMjJEN3lI?=
 =?utf-8?B?SGFadmhLNG96ZEtnM0F5TDBHS3hCdmlGd0ZYdWtwVmg1WmcwQi93aElNZkFl?=
 =?utf-8?B?T0Izd3JhME5SZHZ6VTBiVUUzd25NQUt4MXdKQk5TT04zcituOHJKWVJEQkps?=
 =?utf-8?B?cUlVMDZpZllBdStHT1pmUGxFVTFaMU9ORnUrT2F5Y01nYzFZSGxvL3Vma2d0?=
 =?utf-8?B?TUNHc0tNU3pwYm5VMVA1MUs5VkFqeXRjYzJMOTNuUktseWhMZlpNd1NmaUhG?=
 =?utf-8?B?anp5U2liaXlOU0l5RTRiUzNHRmc5ZFF5VVU4RGVLVWdCYzVPNzhqOWtMRXVt?=
 =?utf-8?B?bWVRTlM5eGxOcVFFNmVQQ1E5MnRUR2hXSGlGRStDcWVqWVI2VDB5VElqcDVU?=
 =?utf-8?B?RUlhZ3oxTjlVZ0g4TkNrQnRJT1h3Y01VZ0VuZFY4UzhHUHo4a1U2amh4VnJE?=
 =?utf-8?B?THFVQ1NvZ1lmelJTdnl2ZHB2dk9pMWZlbFFCcEEyOUNBN0w1Qk9sRWkzVDVn?=
 =?utf-8?B?L2crVFZwRzhTbTJ5akV2SWlpbHNDMmZzRko2VEJuK3JSamZiNy9qR3gwNW95?=
 =?utf-8?B?cVlwYlg3d1ZucDNjdFl4TmNZeWFrMVNNeGhPdFhJdm9qVUN5cHphdUxnM1p0?=
 =?utf-8?B?QVZraFJnRkptOGRhNDFRdXlPRFlMbVlzaERsM25ScVpKdXB0bExEREpRSDI4?=
 =?utf-8?B?WVRnS0JVTjJWN09zRndyVXRQMTd2Rms1Y2s1dVJkVTNwNkh6M3ZDdVV6c1Fz?=
 =?utf-8?B?WjFwVXFkTUd2ck44blBia3dOR0IwZWJCNGtrZ1Z5MGozcmpjaVdFRllBUWpo?=
 =?utf-8?B?OG1ZZXRnNS9RcEo1MmJDaUdzUHlBdjMwaFpLWXZUQjErdXFxRzl0SWh2YTRu?=
 =?utf-8?B?cHNDNE1jS3VSR2hNOWFQa3lPY1BVT3ZLeEtJOS9qRmlTSmVDSSszd01hRWVl?=
 =?utf-8?B?OCtNdW41N3RzcEtVVmZvQkJzL1p4a0VoNXZ3VWNraTlIT29lRzBmQjIydXJY?=
 =?utf-8?B?cHhSRG5sTlZqeXFRdGxRYXJzY21aSTNGVEZkNDg0Qk5JRnNsYSswTzk5WCt4?=
 =?utf-8?B?azhpNjdBdnpOOGVHdklVWDBiVUJlUkhTdzc1NGV6bEs0V3JJdjlzZW5CR2M1?=
 =?utf-8?B?UWlmeEhQTWtSaWZQdC9zRDNFWDF0TFd2SU5WZ3NGZHMvK1lRZlNZZUtLc21k?=
 =?utf-8?B?eGduMklPamtRSitOenZZdWoxcHRaU0RQbmhubFlYVW81cE5mc2NrUXZBUE1O?=
 =?utf-8?B?RmxlSlZnRlhkU05PbWVXdVVXZHdndkVCRGp4bjNPWVVIU3NrQjJpcmRKV01s?=
 =?utf-8?B?c2FaTk1KRGZpcEhIc1NKdEdaZDc3UjM3RUc1bEVHWVpsK3ZLdXJoYzQ4cUp4?=
 =?utf-8?B?ZncxbDMzTDZwOFNCeGJrV1U3V2g4TjBYcStsTUN1VTlMS1hoV3V5b01yTllp?=
 =?utf-8?B?eXRsaHdseXB3NVlUWE5IdTZ3N3pMakFzdXMzLzhaUTUvK1JhUDhEeFV3UUxo?=
 =?utf-8?B?cmhsZ2hlL01EVmRNVGdia1VucEpJWDhROXY0MElkWjFRa1lOMlJ5R3c1Yndr?=
 =?utf-8?B?VVRndVFLZDdTRy9pMG9VeXpvYXVKQXNaWmx2bDVyWmIzZFpCTW9vd2E5Sit1?=
 =?utf-8?B?K3JVYzNycWNzMVdJc2lFd21oc0FadWNuNnQwUkxQNnFxZCt1NGtkYzNxS3h3?=
 =?utf-8?Q?d+3s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d3f101-44be-4cde-9fb1-08dad7d1877e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 21:33:34.7080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: neu06gDG4xbuVAdYEcG+uyHMi5VGnLcLyUas6pVcK9WvfqXtE4XxRfnAKCaPNn3g0HdNAiT3xDcyRdEZXC4SQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7083
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFR1ZXNkYXksIDYgRGVjZW1iZXIgMjAyMiAx
ODoxMQ0KPiBUbzogSmlyaSBQaXJrbyA8amlyaUByZXNudWxsaS51cz4NCj4gQ2M6IEVtZWVsIEhh
a2ltIDxlaGFraW1AbnZpZGlhLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFJh
ZWQNCj4gU2FsZW0gPHJhZWRzQG52aWRpYS5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVt
YXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJd
IG1hY3NlYzogQWRkIHN1cHBvcnQgZm9yIElGTEFfTUFDU0VDX09GRkxPQUQNCj4gaW4gdGhlIG5l
dGxpbmsgbGF5ZXINCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxp
bmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gMjAyMi0xMi0wNiwgMTQ6MzU6MjMgKzAxMDAs
IEppcmkgUGlya28gd3JvdGU6DQo+ID4gVHVlLCBEZWMgMDYsIDIwMjIgYXQgMDE6MzE6NTRQTSBD
RVQsIGVoYWtpbUBudmlkaWEuY29tIHdyb3RlOg0KPiA+ID4+IFR1ZSwgRGVjIDA2LCAyMDIyIGF0
IDA5OjU3OjU3QU0gQ0VULCBlaGFraW1AbnZpZGlhLmNvbSB3cm90ZToNCj4gPiA+PiA+RnJvbTog
RW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiA+ID4+ID4NCj4gPiA+PiA+VGhpcyBh
ZGRzIHN1cHBvcnQgZm9yIGNvbmZpZ3VyaW5nIE1hY3NlYyBvZmZsb2FkIHRocm91Z2ggdGhlDQo+
ID4gPj4NCj4gPiA+PiBUZWxsIHRoZSBjb2RlYmFzZSB3aGF0IHRvIGRvLiBCZSBpbXBlcmF0aXZl
IGluIHlvdXIgcGF0Y2gNCj4gPiA+PiBkZXNjcmlwdGlvbnMgc28gaXQgaXMgY2xlYXIgd2hhdCBh
cmUgdGhlIGludGVuc2lvbnMgb2YgdGhlIHBhdGNoLg0KPiA+ID4NCj4gPiA+QWNrDQo+ID4gPg0K
PiA+ID4+DQo+ID4gPj4NCj4gPiA+PiA+bmV0bGluayBsYXllciBieToNCj4gPiA+PiA+LSBDb25z
aWRlcmluZyBJRkxBX01BQ1NFQ19PRkZMT0FEIGluIG1hY3NlY19maWxsX2luZm8uDQo+ID4gPj4g
Pi0gSGFuZGxpbmcgSUZMQV9NQUNTRUNfT0ZGTE9BRCBpbiBtYWNzZWNfY2hhbmdlbGluay4NCj4g
PiA+PiA+LSBBZGRpbmcgSUZMQV9NQUNTRUNfT0ZGTE9BRCB0byB0aGUgbmV0bGluayBwb2xpY3ku
DQo+ID4gPj4gPi0gQWRqdXN0aW5nIG1hY3NlY19nZXRfc2l6ZS4NCj4gPiA+Pg0KPiA+ID4+IDQg
cGF0Y2hlcyB0aGVuPw0KPiA+ID4NCj4gPiA+QWNrLCBJIHdpbGwgY2hhbmdlIHRoZSBjb21taXQg
bWVzc2FnZSB0byBiZSBpbXBlcmF0aXZlIGFuZCB3aWxsIHJlcGxhY2UgdGhlIGxpc3QNCj4gd2l0
aCBhIGdvb2QgZGVzY3JpcHRpb24uDQo+ID4gPkkgc3RpbGwgYmVsaWV2ZSBpdCBzaG91bGQgYmUg
YSBvbmUgcGF0Y2ggc2luY2Ugc3BsaXR0aW5nIHRoaXMgY291bGQgYnJlYWsgYSBiaXNlY3QNCj4g
cHJvY2Vzcy4NCj4gPg0KPiA+IFdlbGwsIHdoZW4geW91IHNwbGl0LCB5b3UgaGF2ZSB0byBtYWtl
IHN1cmUgeW91IGRvbid0IGJyZWFrIGJpc2VjdGlvbiwNCj4gPiBhbHdheXMuIFBsZWFzZSB0cnkg
dG8gZmlndXJlIHRoYXQgb3V0Lg0KPiANCj4gSSB0aGluayB0aGlzIGNhbiBiZSBzcGxpdCBwcmV0
dHkgbmljZWx5IGludG8gMyBwYXRjaGVzOg0KPiAgLSBhZGQgSUZMQV9NQUNTRUNfT0ZGTE9BRCB0
byBtYWNzZWNfcnRubF9wb2xpY3kgKHByb2JhYmx5IGZvciBuZXQNCj4gICAgd2l0aCBhIEZpeGVz
IHRhZyBvbiB0aGUgY29tbWl0IHRoYXQgaW50cm9kdWNlZCBJRkxBX01BQ1NFQ19PRkZMT0FEKQ0K
PiAgLSBhZGQgb2ZmbG9hZCB0byBtYWNzZWNfZmlsbF9pbmZvL21hY3NlY19nZXRfc2l6ZQ0KPiAg
LSBhZGQgSUZMQV9NQUNTRUNfT0ZGTE9BRCBzdXBwb3J0IHRvIGNoYW5nZWxpbmsNCj4gDQo+IFRo
ZSBzdWJqZWN0IG9mIHRoZSBsYXN0IHBhdGNoIHNob3VsZCBhbHNvIG1ha2UgaXQgY2xlYXIgdGhh
dCBpdCdzIG9ubHkgYWRkaW5nDQo+IElGTEFfTUFDU0VDX09GRkxPQUQgdG8gY2hhbmdlbGluay4g
QXMgaXQncyB3cml0dGVuLCBzb21lb25lIGNvdWxkIGFzc3VtZQ0KPiB0aGVyZSdzIG5vIHN1cHBv
cnQgYXQgYWxsIHZpYSBydG5sIG9wcyBhbmQgd29uZGVyIHdoeSB0aGlzIHBhdGNoIGlzbid0IGRv
aW5nIGFueXRoaW5nDQo+IHRvIG5ld2xpbmssIGFuZCB3aGV0aGVyL3doeSB0aGlzIElGTEFfTUFD
U0VDX09GRkxPQUQgYWxyZWFkeSBleGlzdHMuDQoNCkFjayAsIEkgd2lsbCBzcGxpdCB0aGUgcGF0
Y2ggYW4gc2VuZCB0aGUgbmV3IHBhdGNoZXMuDQoNCj4gLS0NCj4gU2FicmluYQ0KDQo=
