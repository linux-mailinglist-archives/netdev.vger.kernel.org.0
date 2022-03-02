Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFB94C9C71
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 05:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbiCBE0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 23:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbiCBE0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 23:26:32 -0500
X-Greylist: delayed 574 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 20:25:38 PST
Received: from mail11.tencent.com (mail11.tencent.com [14.18.178.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03BD5F268;
        Tue,  1 Mar 2022 20:25:38 -0800 (PST)
Received: from EX-SZ021.tencent.com (unknown [10.28.6.73])
        by mail11.tencent.com (Postfix) with ESMTP id 9CAF56618A;
        Wed,  2 Mar 2022 12:16:01 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1646194561;
        bh=Hh/LTWOBRc1U/0gk6/uXxhWvp+NLYixqJ2mxcMI1D80=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=lNU+f9f4JC1pGbugXBprdtWRSrTjDQW1H6b6knUgTBM0YBFlupywAcM6HQwdQZ6lz
         YOBDznHQ0sNQdg0GyHHmD8QmqiJKd8E2mspqb5XlpbxlVE4eRcqqDOH1WmUWCJFtV5
         8MSK/D29gBg0SHHywxzyDbZ9okdo1JWxJE15tljU=
Received: from EX-SZ085.tencent.com (10.28.6.58) by EX-SZ021.tencent.com
 (10.28.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 2 Mar 2022
 12:16:01 +0800
Received: from EX-SZ079.tencent.com (10.28.6.51) by EX-SZ085.tencent.com
 (10.28.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 2 Mar 2022
 12:16:01 +0800
Received: from EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7]) by
 EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7%3]) with mapi id
 15.01.2242.008; Wed, 2 Mar 2022 12:16:01 +0800
From:   =?utf-8?B?aW1hZ2Vkb25nKOiRo+aipum+mSk=?= <imagedong@tencent.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "Dongli Zhang" <dongli.zhang@oracle.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [Internet]Re: [PATCH net-next v4 4/4] net: tun: track dropped skb
 via kfree_skb_reason()
Thread-Topic: [Internet]Re: [PATCH net-next v4 4/4] net: tun: track dropped
 skb via kfree_skb_reason()
Thread-Index: AQHYLeBMbFEuNq1JGEab9FoiGsFbYayq6Z+AgACTEgA=
Date:   Wed, 2 Mar 2022 04:16:01 +0000
Message-ID: <7991329A-DC69-4A6D-925D-33866EF5FB7E@tencent.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
 <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2071f8a0-148d-96fa-75b9-8277c2f87287@gmail.com>
In-Reply-To: <2071f8a0-148d-96fa-75b9-8277c2f87287@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [9.218.225.2]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D494B6775D7F1845A7C15D8883DE8DF2@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMjIvMy8yIEFNIDExOjI577yM4oCcRGF2aWQgQWhlcm7igJ08ZHNhaGVybkBnbWFp
bC5jb20+IHdyaXRlOg0KDQo+T24gMy8xLzIyIDc6NTAgUE0sIEpha3ViIEtpY2luc2tpIHdyb3Rl
Og0KPj4gT24gU2F0LCAyNiBGZWIgMjAyMiAwMDo0OToyOSAtMDgwMCBEb25nbGkgWmhhbmcgd3Jv
dGU6DQo+Pj4gKwlTS0JfRFJPUF9SRUFTT05fU0tCX1BVTEwsCS8qIGZhaWxlZCB0byBwdWxsIHNr
X2J1ZmYgZGF0YSAqLw0KPj4+ICsJU0tCX0RST1BfUkVBU09OX1NLQl9UUklNLAkvKiBmYWlsZWQg
dG8gdHJpbSBza19idWZmIGRhdGEgKi8NCj4+IA0KWy4uLl0NCj4+PiAgCVNLQl9EUk9QX1JFQVNP
Tl9ERVZfSERSLAkvKiB0aGVyZSBpcyBzb21ldGhpbmcgd3Jvbmcgd2l0aA0KPj4+ICAJCQkJCSAq
IGRldmljZSBkcml2ZXIgc3BlY2lmaWMgaGVhZGVyDQo+Pj4gIAkJCQkJICovDQo+Pj4gKwlTS0Jf
RFJPUF9SRUFTT05fREVWX1JFQURZLAkvKiBkZXZpY2UgaXMgbm90IHJlYWR5ICovDQo+PiANCj4+
IFdoYXQgaXMgcmVhZHk/IGxpbmsgaXMgbm90IHVwPyBwZWVyIG5vdCBjb25uZWN0ZWQ/IGNhbiB3
ZSBleHBhbmQ/DQo+DQo+QXMgSSByZWNhbGwgaW4gdGhpcyBjYXNlIGl0IGlzIHRoZSB0ZmlsZSBm
b3IgYSB0dW4gZGV2aWNlIGRpc2FwcGVhcmVkIC0NCj5pZS4sIGEgcmFjZSBjb25kaXRpb24uDQoN
ClRoaXMgc2VlbXMgaXMgdGhhdCB0dW4gaXMgbm90IGF0dGFjaGVkIHRvIGEgZmlsZSAodGhlIHR1
biBkZXZpY2UgZmlsZQ0KaXMgbm90IG9wZW5lZD8pIE1heWJlIFRBUF9VTkFUVEFDSEVEIGlzIG1v
cmUgc3VpdGFibGUgOikNCg0KDQo=
