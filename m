Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CFB402FCC
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 22:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346504AbhIGUfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 16:35:50 -0400
Received: from mail-bn8nam08on2085.outbound.protection.outlook.com ([40.107.100.85]:22153
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345402AbhIGUfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 16:35:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id8V1HLJu9ojG9dLmTyB5WVU/85yzaa+KoDraSJHk+lwAe0uNvtvCLvODfh+j5+hIH833N/5BmfufGSVlfypobJwYjDFIS5ex6nO1WSIQ288/rzFoxh4tYXKdh6sqrAWFGdald+NQpunyqMksrYcXcTLUufeensr8B7AYbXUj6SonETikLZ0VrNx1v4ZEnl/u54/5U47kgKMsnCMNqT9obvuZqti+DuxG2yl73T6zeISAG6rtgQLT/18j3SMsCZE5XriNMjSI7l7pRmgiDNc5wms5zgzt28kbtcPzx01tsy5IGIyWAmaEm8YxTwi4QMozoEbPGNzpuqPgwgL0cM1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ynLkxv3NIrrxiWpcMFHjFRbirpgcG7VhlHz8Qti3xtU=;
 b=BUcFXsj5kjlqmUXeKbBAkrdttXp+09R3s0dc8bGXkgcFQxdpnNOR/S8sPkYzNNgK14/3CLC9qbl2FK+Gmv6Nb0RqkFzy0zPs9SJ38wS+swIFVcxCpJRGu+QXuqyNFqQ2waoZPn/y3mv6vPhUT0pQMso7XL6hQtVFcQGSLBPCU2ONSHt1Kser9Vq5aWwELC/1RXgz4W+UetKnkE54ly3r61D1NnEQy5/9AKTXhA7wDg5JDCWJ4oGmPMiV9iqn9pwIFfuqkQv8zgdfg5LrmO+QvfSpwm0I85yPvB08yc8SeZDyrmrqD78w6xm9ujufq4F81XIRNbmHL/XSI+lsgVwe2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynLkxv3NIrrxiWpcMFHjFRbirpgcG7VhlHz8Qti3xtU=;
 b=X86krDAkw8Wn4+GeiXwXn51eWbUjm+aNzhR7WN3dMTtEF4v1or5uOr3eFkWsRdrmsinEn0Wj5q8ddfm9OcTlIBO7++PHU6tu1KKV23glZN963OkzghRKIF3DAvgxGHgkimXry5PY3//hQkpdldv7AbWdIBqMvKHHbBjty6wawpjxm1feDOKWWKaHRIbSeYx/sSfFbrqJJfUEWl3xSGAuezldLhBhs57rV4NJrxJaofafMNQqLlniMRWyuIFHTgArjFcM4Cm81G13qAjhtE0OFv57KRKTM1j+cNUEzJTykbG+IDA6Tld0fUlaMOO5l/Ikcr0jMEiKCaiUaS/9gH4tqw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3304.namprd12.prod.outlook.com (2603:10b6:a03:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 20:34:39 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::5815:52a1:6171:e70]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::5815:52a1:6171:e70%9]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 20:34:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "natechancellor@gmail.com" <natechancellor@gmail.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "naresh.kamboju@linaro.org" <naresh.kamboju@linaro.org>
Subject: Re: bridge.c:157:11: error: variable 'err' is used uninitialized
 whenever 'if' condition is false
Thread-Topic: bridge.c:157:11: error: variable 'err' is used uninitialized
 whenever 'if' condition is false
Thread-Index: AQHXov8xBdmTjnOilkS6FVSmdyRdz6uXNaGAgAAPlYCAAcRZAA==
Date:   Tue, 7 Sep 2021 20:34:39 +0000
Message-ID: <452cbfe701b1373c871ba584ef4b249a59d8edd6.camel@nvidia.com>
References: <CA+G9fYsV7sTfaefGj3bpkvVdRQUeiWCVRiu6ovjtM=qri-HJ8g@mail.gmail.com>
         <CAHk-=wjJ-nr87H_o8y=Gx=DJYPTkxtXz_c=pj_GNdL+XRUMNgQ@mail.gmail.com>
         <ygnhk0jtwqs6.fsf@nvidia.com>
In-Reply-To: <ygnhk0jtwqs6.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d226715c-7bf9-4546-cbff-08d9723eea6e
x-ms-traffictypediagnostic: BYAPR12MB3304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3304E70C061C883B7742B109B3D39@BYAPR12MB3304.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BA+vGTsUr3IAKDUelwmL3RXelBtc4vMB08Sr3BDNxnj4SLB5tE/ZQGKrd+p/oIWrE0bbtutKTqBFJ8h3R5/+u/EqZ4JxmPrMQhFprtq4fr+qkB4ceBTU6Wa2aosRUU/EzQmjgpK92WFWJvZWS2/CtzIhZ5cIdZARU3tl6t1Ew3VuQdMVYc6L9vVhoU95n/Ia2BSOpx5Xs1+IZnP7QpExtfo2oLpNXu/6pPaJjLmjbXPPeqk3EYnspT9yC+sdM1mTKLx+ziftQYBtSCNMYPFJRUNfNG2DfIIBXQXLKOMLLPMvQiycwBCVygkeEMWtAUTazMWZpl2oqBI+GbUZtTeFBh8x0U+rs0ElzD4EFjgeF9B0OAP44QKp4s8UnRDi9MKTVnst33Qspb884quJuq32GuKGL48M1YeQvpaR6OcokivSamqVMUZ5EAJME/cRexQ3apaJRao9ltEeS5aC8YCAz6akHYh0JkjXyMZZK3Dhhz7gaeC7n10A1UZk6/nt6EcjyPWehmiAvQz6pG4KkHtYAaEGmC2HjGq2kNoQbCL3z89xwDXvMyy7+4ZHws8O2aAB3NOsJ5Rlc6l+RDl0280MoIR8sK72veYGs6Tr1XyoSicCtCvz8+D5AQYd59drgdQKTX2QkhJEsaSFvJmG19HkTCfA0XAIkvTwAcGAgtY+PdeZb23+3OGkhqqnfGj95FVBucXWW4Ub1aG/XC472DYiXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(6512007)(186003)(8936002)(71200400001)(83380400001)(5660300002)(26005)(54906003)(4326008)(316002)(38070700005)(2906002)(110136005)(76116006)(6486002)(6636002)(66446008)(66946007)(66476007)(64756008)(36756003)(122000001)(38100700002)(6506007)(53546011)(4744005)(8676002)(478600001)(2616005)(66556008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU4yWTQ1SjlnNGpNVjg3MUg2ZERiVDg2N1luMmZXS1N4Y1FMZE82SzhMYmps?=
 =?utf-8?B?OGR3bm5Ca2JublZqOG5tZDFFWEVmaVpnNEFpSEZQTnNXczhXS0JmMWNya1RL?=
 =?utf-8?B?T2wvdFgzcDZKQVJ1bjF2V0V6TjlpWGZxZVdKSVpvazFMZWVURytJdnRlS3lS?=
 =?utf-8?B?U2VCV2VwVUdJMGh4cG0ya1VmQ2ZnSWZQd09RQ1BsTFhKL001TzJJdGtTV2Vk?=
 =?utf-8?B?RXNMemxCa0hoampseUtCYVJkRC9qOHl6b1NtNEVNanYyek8yRDFpVkhiT2Jz?=
 =?utf-8?B?QWtzR2EwSU9MUmMxRGhORTZ5RWRSOWhDaFhYUWdGVFZ4Vkl3dkNxWXpyS05O?=
 =?utf-8?B?NG5scklRVEp4WHgwWUdlVHNrNFRYZjRRWUorTjJDZHQ2cjUvbG05MWdoUjJ1?=
 =?utf-8?B?QkpHdnlWbUdWb3BOcUtZTkw1ejFIaUphdUVlNUlGZG9odWMxMzk2U2kvSSs2?=
 =?utf-8?B?TlY1YW13TDR3eFV5U0hvNGt5aEdreGRSYVNrM0kwME5IMVZiQjVHbWp5NUNJ?=
 =?utf-8?B?cEFxMTJKQm5PZVBHdVdtQTlYR3U4MHlJMnhLc2RUSm45MGlWU0lnQksrQ1dl?=
 =?utf-8?B?YzdDdCtLR0NhVGVoYnBrc0NaVWYyNDNKT1BhWWVqY2xGbXVGVEY4NzR5R0pn?=
 =?utf-8?B?VU9YR1R3c2FIWndKMVp4aFF5aVl0Tm8xVVJhNTJmb0lUSytrV3FreFhBUTZz?=
 =?utf-8?B?UTJobGxLL052dk50dkxrM3JWNmZOM1kzeGJIdUY4YTdKeFVwSk5VNWZXVEpD?=
 =?utf-8?B?N3Q2TEhDbEVObm1zbkluVVBkWURSakdXZDd2TlFEOGtuSjltVjJzUFUrdjBZ?=
 =?utf-8?B?MHVjQ1ZHQ1A5T0g0WktweEtuNUpVVG5LRFlFM0F0Y0xOTTFxYlJiMmkwWTZo?=
 =?utf-8?B?STY4cnZ4aGpzRm1lK1hVbkxzTGMwZVdKQWZLL0tod1Mzd1BweEhDVGZkekRq?=
 =?utf-8?B?S01peittb0VXN0ljNWFPS09XWW5pcXNLbTgwY2FCbmFmdUdteWo0QmUxUHdy?=
 =?utf-8?B?Y2lnVENodWhBdXdYQlJiTXgyWlVraVNhODRUamJvc0FJR2Z5aXd0VlFFcmx0?=
 =?utf-8?B?YXM4Z2IwaG5UYXgwem9aK0R5Um5JY2V4NWN0VHdENXJFOEd1MXlzUkQwb04r?=
 =?utf-8?B?SS9MWnJxSmtYTkc4akJiWDBFUzE1R3pEemkwZXQvQlNwT3RMQ2JZRHB3akZ0?=
 =?utf-8?B?b2Nyc0Nzc2Zlb2tWQnE3OFJkWDlUVks4YWw1SjdGUlBWZDdnRzVJbXpXeXVW?=
 =?utf-8?B?ZHUvbWVBSmtiRlpZaTJaeTRHTnE0dllqR3B0ZnMvaTBKa2J4MXpqd3BqQTll?=
 =?utf-8?B?TGFjRWwydzZKbnpmbGY1R3pJM2VJVzN2RHh5UERsdEw4L21hcGxKRXRYTno5?=
 =?utf-8?B?NTh0N1g2QmpBQ0ZORDIydzBYUHk3OWZ1d2cwMHRmZUF3aDFPb2FDSHFpemlw?=
 =?utf-8?B?U3VyZGlOaVV4VGZKdzRVSFdVQUZFbXY1YVZqaEFYU3FpZ2JDd2I2UUNwcjB3?=
 =?utf-8?B?WlVyRW53cGwrdzB6N3Y0dVlSTmNUclRRbUQ0dXRwallrNTFRT0I3M2s3Wlcy?=
 =?utf-8?B?aG1DbGc5d2hOck9jT0RWV0lSbVNzMno5dWsvQWpkYTRlV0t2cTUzaTl3UjFN?=
 =?utf-8?B?bk9Selkxb3orR2Y2N3pXQzFRVnlDeXJqRVUwZndZQ1E4bk43K1doV1ZWbkkx?=
 =?utf-8?B?N1VHUFcwMjJMU2NycW1GR2xCMFZVU1JHYXFDOVAwbWRpMVNQZG1ObHhZdUh1?=
 =?utf-8?B?UFpIZy9KTytOWWUxMjhRWHREMS8zVTlVNHBKYTBwUEdENm41UEdIVGZ5bU9h?=
 =?utf-8?B?TzFva05kbGV3Q3ZuT1d1Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <246078A199A5DA42A3069513A9E1078A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d226715c-7bf9-4546-cbff-08d9723eea6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 20:34:39.5517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W4bqpuogfcL1L5aiGp/bwxncJngVxmgyRAmSejG496lo3kNcg/BVkzqOGWKN0HSurFcBoa1L+1b5lcpTZ2zQZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA5LTA2IGF0IDIwOjM1ICswMzAwLCBWbGFkIEJ1c2xvdiB3cm90ZToNCj4g
T24gTW9uIDA2IFNlcCAyMDIxIGF0IDE5OjM5LCBMaW51cyBUb3J2YWxkcw0KPiA8dG9ydmFsZHNA
bGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiA+IE9uIE1vbiwgU2VwIDYsIDIwMjEgYXQg
MjoxMSBBTSBOYXJlc2ggS2FtYm9qdQ0KPiA+IDxuYXJlc2gua2FtYm9qdUBsaW5hcm8ub3JnPiB3
cm90ZToNCj4gPiA+IA0KPiA+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3JlcC9icmlkZ2UuYzoxNTc6MTE6DQo+ID4gPiBlcnJvcjoNCj4gPiA+IHZhcmlhYmxl
ICdlcnInIGlzIHVzZWQgdW5pbml0aWFsaXplZCB3aGVuZXZlciAnaWYnIGNvbmRpdGlvbiBpcw0K
PiA+ID4gZmFsc2UNCj4gPiANCj4gPiBUaGF0IGNvbXBpbGVyIHdhcm5pbmcgKG5vdyBlcnJvcikg
c2VlbXMgdG8gYmUgZW50aXJlbHkgdmFsaWQuDQo+IA0KPiBJIGFncmVlLCB0aGlzIGlzIGEgcmVh
bCBpc3N1ZS4gSXQgaGFkIGJlZW4gcmVwb3J0ZWQgYmVmb3JlIGFuZCBteSBmaXgNCj4gZm9yIGl0
IHdhcyBzdWJtaXR0ZWQgYnkgU2FlZWQgbGFzdCB3ZWVrIGJ1dCB3YXNuJ3QgYWNjZXB0ZWQgc2lu
Y2UgaXQNCj4gd2FzDQo+IHBhcnQgb2YgbGFyZ2VyIHNlcmllcyB0aGF0IGFsc28gaW5jbHVkZWQg
ZmVhdHVyZXMgYW5kIG5ldC1uZXh0IGhhZA0KPiBhbHJlYWR5IGJlZW4gY2xvc2VkIGJ5IHRoYXQg
dGltZS4gQXMgZmFyIGFzIEkgdW5kZXJzdGFuZCBpdCBpcw0KPiBwZW5kaW5nDQo+IHN1Ym1pc3Np
b24gdG8gbmV0IGFzIHBhcnQgb2Ygc2VyaWVzIG9mIGJ1ZyBmaXhlcy4gU29ycnkgZm9yIHRoZQ0K
PiBkZWxheS4NCj4gDQo+IA0KDQp5ZXMsIHRoZSBmaXggd2lsbCBiZSBzdWJtaXR0ZWQgc2hvcnRs
eSB0byBuZXQvcmMgYnJhbmNoLg0KZHVlIHRvIGJhZCBuZXQtbmV4dCB0aW1pbmcgdGhlIHBhdGNo
IGNvdWxkbid0IG1ha2UgaXQgdG8gLW5leHQuDQoNCg==
