Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E036661082C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiJ1Chq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiJ1ChW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:37:22 -0400
X-Greylist: delayed 610 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Oct 2022 19:36:16 PDT
Received: from mail11.tencent.com (mail11.tencent.com [14.18.178.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE613B94C;
        Thu, 27 Oct 2022 19:36:15 -0700 (PDT)
Received: from EX-SZ021.tencent.com (unknown [10.28.6.73])
        by mail11.tencent.com (Postfix) with ESMTP id 9A31AFC243;
        Fri, 28 Oct 2022 10:26:03 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1666923963;
        bh=mq4xcMZnNEdLW9K1G+htd2EuI3/uCxcOtNBIoBB/1eM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=OaI6vm+FOf28i6MLGNOw2fXHvhBQYbFhG5ETsmndHRL9kQjcpbfKvYqOnKdcWIIok
         6m5OEDrOYR0OSXrOHhoxtIPSmEWw8EwZTR48no5ixnMPKAuXFpahRyOufNDgZFjznN
         Uwqv0vnhlE4m03n8JBC7ObzF4OXp8V13zLnER0O0=
Received: from EX-SZ044.tencent.com (10.28.6.95) by EX-SZ021.tencent.com
 (10.28.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 28 Oct
 2022 10:26:03 +0800
Received: from EX-SZ079.tencent.com (10.28.6.51) by EX-SZ044.tencent.com
 (10.28.6.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 28 Oct
 2022 10:26:03 +0800
Received: from EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7]) by
 EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7%3]) with mapi id
 15.01.2242.008; Fri, 28 Oct 2022 10:26:03 +0800
From:   =?utf-8?B?aW1hZ2Vkb25nKOiRo+aipum+mSk=?= <imagedong@tencent.com>
To:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ian Rogers <irogers@google.com>
CC:     Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        "robh@kernel.org" <robh@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [Internet]Re: [PATCH net-next v2] net: skb: export skb drop
 reaons to user by TRACE_DEFINE_ENUM
Thread-Topic: [Internet]Re: [PATCH net-next v2] net: skb: export skb drop
 reaons to user by TRACE_DEFINE_ENUM
Thread-Index: AQHYvuLAVe6ABTJa/k+UhBq0aJou7K3QZlkAgFHISgCAAANggIAADHUAgAEtAQA=
Date:   Fri, 28 Oct 2022 02:26:02 +0000
Message-ID: <82699D69-00C8-4C0B-BEA2-32284EB63B63@tencent.com>
References: <20220902141715.1038615-1-imagedong@tencent.com>
 <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
 <20220905103808.434f6909@gandalf.local.home>
 <CANn89i+qp=gmhx_1b+=hEiHA7yNGkfh46YPKhUc9GFbtNYBZrA@mail.gmail.com>
 <20221027114407.6429a809@gandalf.local.home>
 <CANn89iL7EvdBhZGtxDOATeznLUwVaFm2gf4XCYeMPXE5CR=BTw@mail.gmail.com>
In-Reply-To: <CANn89iL7EvdBhZGtxDOATeznLUwVaFm2gf4XCYeMPXE5CR=BTw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.16.15]
Content-Type: text/plain; charset="utf-8"
Content-ID: <816DBFA9BBEF374DBEAB7D746EB3487D@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAyMDIyLzEwLzI4IDAwOjI577yM4oCcRXJpYyBEdW1hemV04oCdPGVkdW1hemV0QGdvb2ds
ZS5jb20+IHdyaXRlOg0KPiANCj4gT24gVGh1LCBPY3QgMjcsIDIwMjIgYXQgODo0MyBBTSBTdGV2
ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+ID4NCj4gPiBPbiBUaHUs
IDI3IE9jdCAyMDIyIDA4OjMyOjAyIC0wNzAwDQo+ID4gRXJpYyBEdW1hemV0IDxlZHVtYXpldEBn
b29nbGUuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gVGhpcyBzZWVtcyBicm9rZW4gYWdhaW4gKHRy
aWVkIG9uIGxhdGVzdCBuZXQtbmV4dCB0cmVlKQ0KPiA+ID4NCj4gPiA+IHBlcmYgc2NyaXB0DQo+
ID4NCj4gPiBEbyB5b3UgYWxzbyBoYXZlIHRoZSBsYXRlc3QgcGVyZiBhbmQgdGhlIGxhdGVzdCBs
aWJ0cmFjZWV2ZW50IGluc3RhbGxlZD8NCj4gPg0KPiANCj4gSSB0cmllZCBhIG1vcmUgcmVjZW50
IHBlcmYgYmluYXJ5IHdlIGhhdmUsIGJ1dCBpdCBpcyBhbHNvIG5vdCByaWdodC4NCj4gDQo+IEkg
Z3Vlc3MgSSB3aWxsIGhhdmUgdG8gcmVxdWVzdCBhIG5ldyBwZXJmIGJpbmFyeSBhdCBHb29nbGUg
Oi8NCj4gDQoNCkVubm4uLi5JIGp1c3QgaGF2ZSBhIHRyeSwgYW5kIGl0IHNlZW1zIGZpbmU6DQoN
CnN1ZG8gcGVyZiBzY3JpcHQNCiAgICAgICAgIHN3YXBwZXIgICAgIDAgWzA0OV0gNDAxNDYwLjEz
ODA3ODogc2tiOmtmcmVlX3NrYjogc2tiYWRkcj0weGZmZmY4ODgxMDc2ZDI0MDAgcHJvdG9jb2w9
MjA0OCBsb2NhdGlvbj0weGZmZmZmZmZmODFkODY1NDYgcmVhc29uOiBUQ1BfSU5WQUxJRF9TRVFV
RU5DRQ0KICAgICAgICAgICAgICBuYyA0Mjk0MTggWzAwNl0gNDAxNDY1LjY1MjI4Mjogc2tiOmtm
cmVlX3NrYjogc2tiYWRkcj0weGZmZmY4ODgxZWE2NmNmMDAgcHJvdG9jb2w9MCBsb2NhdGlvbj0w
eGZmZmZmZmZmODFlMGI0OGYgcmVhc29uOiBOT1RfU1BFQ0lGSUVEDQogICAgICAgICAgICAgIG5j
IDQyOTQxOCBbMDA2XSA0MDE0NjUuNjUyMjkzOiBza2I6a2ZyZWVfc2tiOiBza2JhZGRyPTB4ZmZm
Zjg4ODFlYTY2Y2YwMCBwcm90b2NvbD0wIGxvY2F0aW9uPTB4ZmZmZmZmZmY4MWUwYjQ4ZiByZWFz
b246IE5PVF9TUEVDSUZJRUQNCiAgICAgICAgICAgICAgbmMgNDI5NDE4IFswMDZdIDQwMTQ2NS42
NTI1Mzg6IHNrYjprZnJlZV9za2I6IHNrYmFkZHI9MHhmZmZmODg4MTMzYzAxNGU4IHByb3RvY29s
PTIwNDggbG9jYXRpb249MHhmZmZmZmZmZjgxZDk4M2ExIHJlYXNvbjogTk9fU09DS0VUDQoNClRo
ZSB2ZXJzaW9uIG9mIHRoZSBwZXJmIEkgdXNlZCBpcyA2LjAuMy0xOg0KDQogIHN1ZG8gYXB0IGlu
Zm8gbGludXgtcGVyZg0KICBQYWNrYWdlOiBsaW51eC1wZXJmDQogIFZlcnNpb246IDYuMC4zLTEN
Cg0KDQpUaGFua3MhDQpNZW5nbG9uZyBEb25nDQoNCj4gcGVyZjUgc2NyaXB0DQo+ICAgICAgICAg
IHN3YXBwZXIgICAgIDAgWzAzMF0gIDQxNDcuNzA0NjA2OiBza2I6a2ZyZWVfc2tiOiBbVU5LTk9X
TiBFVkVOVF0NCj4gIGt3b3JrZXIvMzA6MS1ldiAgIDMwOCBbMDMwXSAgNDE0Ny43MDQ2MTU6IHNr
YjprZnJlZV9za2I6IFtVTktOT1dOIEVWRU5UXQ0KPiAgICAgICAgICBzd2FwcGVyICAgICAwIFsw
MzBdICA0MTQ4LjA0ODE3Mzogc2tiOmtmcmVlX3NrYjogW1VOS05PV04gRVZFTlRdDQo+ICBrd29y
a2VyLzMwOjEtZXYgICAzMDggWzAzMF0gIDQxNDguMDQ4MTc5OiBza2I6a2ZyZWVfc2tiOiBbVU5L
Tk9XTiBFVkVOVF0NCj4gICAgICAgICAgc3dhcHBlciAgICAgMCBbMDA4XSAgNDE0OC4wNDg3NzM6
IHNrYjprZnJlZV9za2I6IFtVTktOT1dOIEVWRU5UXQ0KPiAgICAgICAgICBzd2FwcGVyICAgICAw
IFswMzBdICA0MTQ4LjExMjI3MTogc2tiOmtmcmVlX3NrYjogW1VOS05PV04gRVZFTlRdDQo+ICBr
d29ya2VyLzMwOjEtZXYgICAzMDggWzAzMF0gIDQxNDguMTEyMjgwOiBza2I6a2ZyZWVfc2tiOiBb
VU5LTk9XTiBFVkVOVF0NCj4gICAgICAgICAgc3dhcHBlciAgICAgMCBbMDMwXSAgNDE0OC43MjAx
NDk6IHNrYjprZnJlZV9za2I6IFtVTktOT1dOIEVWRU5UXQ0KPiAga3dvcmtlci8zMDoxLWV2ICAg
MzA4IFswMzBdICA0MTQ4LjcyMDE1NTogc2tiOmtmcmVlX3NrYjogW1VOS05PV04gRVZFTlRdDQo+
ICAgICAgICAgIHN3YXBwZXIgICAgIDAgWzAzMF0gIDQxNDkuMDcyMTQxOiBza2I6a2ZyZWVfc2ti
OiBbVU5LTk9XTiBFVkVOVF0NCj4gIGt3b3JrZXIvMzA6MS1ldiAgIDMwOCBbMDMwXSAgNDE0OS4w
NzIxNDk6IHNrYjprZnJlZV9za2I6IFtVTktOT1dOIEVWRU5UXQ0KDQo=
