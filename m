Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFA46A91F1
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 08:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCCHt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 02:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCCHt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 02:49:58 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973151B2DB;
        Thu,  2 Mar 2023 23:49:56 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PSg6T1GlCz16P0r;
        Fri,  3 Mar 2023 15:47:13 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 15:49:54 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2507.021;
 Fri, 3 Mar 2023 15:49:54 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf] bpf, sockmap: fix an infinite loop error when len is
 0 in tcp_bpf_recvmsg_parser()
Thread-Topic: [PATCH bpf] bpf, sockmap: fix an infinite loop error when len is
 0 in tcp_bpf_recvmsg_parser()
Thread-Index: AQHZR315G6w0F5D1P0O7gAu4Ybh6167jimKAgASdD4CAAImacA==
Date:   Fri, 3 Mar 2023 07:49:54 +0000
Message-ID: <7073a9a93be94a0cb694b58acbe36fa7@huawei.com>
References: <20230223120212.1604148-1-liujian56@huawei.com>
 <63fdbd07b3593_5f4ac208eb@john.notmuch>
 <CAADnVQLs=Cc06Pvu+zcXxSsB4zxsJm2DT-6me6NLm1hEjfDkTw@mail.gmail.com>
In-Reply-To: <CAADnVQLs=Cc06Pvu+zcXxSsB4zxsJm2DT-6me6NLm1hEjfDkTw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGVpIFN0YXJvdm9p
dG92IFttYWlsdG86YWxleGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbV0NCj4gU2VudDogRnJpZGF5
LCBNYXJjaCAzLCAyMDIzIDM6MDQgUE0NCj4gVG86IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3Rh
YmVuZEBnbWFpbC5jb20+DQo+IENjOiBsaXVqaWFuIChDRSkgPGxpdWppYW41NkBodWF3ZWkuY29t
PjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgU2l0bmlja2kg
PGpha3ViQGNsb3VkZmxhcmUuY29tPjsgRGF2aWQgUy4NCj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsgRGF2aWQgQWhlcm4gPGRzYWhlcm5Aa2VybmVsLm9yZz47IEpha3ViDQo+IEtpY2lu
c2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBB
bGV4ZWkNCj4gU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPjsgQ29uZyBXYW5nIDxjb25nLndh
bmdAYnl0ZWRhbmNlLmNvbT47DQo+IERhbmllbCBCb3JrbWFubiA8ZGFuaWVsQGlvZ2VhcmJveC5u
ZXQ+OyBOZXR3b3JrIERldmVsb3BtZW50DQo+IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgYnBm
IDxicGZAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGJwZl0gYnBmLCBz
b2NrbWFwOiBmaXggYW4gaW5maW5pdGUgbG9vcCBlcnJvciB3aGVuIGxlbiBpcyAwDQo+IGluIHRj
cF9icGZfcmVjdm1zZ19wYXJzZXIoKQ0KPiANCj4gT24gVHVlLCBGZWIgMjgsIDIwMjMgYXQgMTI6
MzbigK9BTSBKb2huIEZhc3RhYmVuZA0KPiA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPiB3cm90
ZToNCj4gPg0KPiA+IExpdSBKaWFuIHdyb3RlOg0KPiA+ID4gV2hlbiB0aGUgYnVmZmVyIGxlbmd0
aCBvZiB0aGUgcmVjdm1zZyBzeXN0ZW0gY2FsbCBpcyAwLCB3ZSBnb3QgdGhlDQo+ID4gPiBmbG9s
bG93aW5nIHNvZnQgbG9ja3VwIHByb2JsZW06DQo+ID4gPg0KPiA+ID4gd2F0Y2hkb2c6IEJVRzog
c29mdCBsb2NrdXAgLSBDUFUjMyBzdHVjayBmb3IgMjdzISBbYS5vdXQ6NjE0OV0NCj4gPiA+IENQ
VTogMyBQSUQ6IDYxNDkgQ29tbTogYS5vdXQgS2R1bXA6IGxvYWRlZCBOb3QgdGFpbnRlZCA2LjIu
MCsgIzMwDQo+ID4gPiBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChRMzUgKyBJQ0g5
LCAyMDA5KSwgQklPUyAxLjE1LjAtMQ0KPiA+ID4gMDQvMDEvMjAxNA0KPiA+ID4gUklQOiAwMDEw
OnJlbW92ZV93YWl0X3F1ZXVlKzB4Yi8weGMwDQo+ID4gPiBDb2RlOiA1ZSA0MSA1ZiBjMyBjYyBj
YyBjYyBjYyAwZiAxZiA4MCAwMCAwMCAwMCAwMCA5MCA5MCA5MCA5MCA5MCA5MA0KPiA+ID4gOTAg
OTAgOTAgOTAgOTAgOTAgOTAgOTAgOTAgOTAgZjMgMGYgMWUgZmEgMGYgMWYgNDQgMDAgMDAgNDEg
NTcgPDQxPg0KPiA+ID4gNTYgNDEgNTUgNDEgNTQgNTUgNDggODkgZmQgNTMgNDggODkgZjMgNGMg
OGQgNmIgMTggNGMgOGQgNzMgMjANCj4gPiA+IFJTUDogMDAxODpmZmZmODg4MTFiNTk3OGI4IEVG
TEFHUzogMDAwMDAyNDYNCj4gPiA+IFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODgx
MWE3ZDM3ODAgUkNYOiBmZmZmZmZmZmI3YTRkNzY4DQo+ID4gPiBSRFg6IGRmZmZmYzAwMDAwMDAw
MDAgUlNJOiBmZmZmODg4MTFiNTk3OTA4IFJESTogZmZmZjg4ODExNTQwODA0MA0KPiA+ID4gUkJQ
OiAxZmZmZjExMDIzNmIyZjFiIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IGZmZmY4ODgxMWE3
ZDM3ZTcNCj4gPiA+IFIxMDogZmZmZmVkMTAyMzRmYTZmYyBSMTE6IDAwMDAwMDAwMDAwMDAwMDEg
UjEyOiBmZmZmODg4MTExNzliODAwDQo+ID4gPiBSMTM6IDAwMDAwMDAwMDAwMDAwMDEgUjE0OiBm
ZmZmODg4MTFhN2QzOGE4IFIxNTogZmZmZjg4ODExYTdkMzdlMA0KPiA+ID4gRlM6ICAwMDAwN2Y2
ZmI1Mzk4NzQwKDAwMDApIEdTOmZmZmY4ODgyMzcxODAwMDAoMDAwMCkNCj4gPiA+IGtubEdTOjAw
MDAwMDAwMDAwMDAwMDANCj4gPiA+IENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAw
MDAwMDAwODAwNTAwMzMNCj4gPiA+IENSMjogMDAwMDAwMDAyMDAwMDAwMCBDUjM6IDAwMDAwMDAx
MGI2YmEwMDIgQ1I0OiAwMDAwMDAwMDAwMzcwZWUwDQo+ID4gPiBEUjA6IDAwMDAwMDAwMDAwMDAw
MDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMA0KPiA+ID4gRFIz
OiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAwMDAw
MDA0MDANCj4gPiA+IENhbGwgVHJhY2U6DQo+ID4gPiAgPFRBU0s+DQo+ID4gPiAgdGNwX21zZ193
YWl0X2RhdGErMHgyNzkvMHgyZjANCj4gPiA+ICB0Y3BfYnBmX3JlY3Ztc2dfcGFyc2VyKzB4M2M2
LzB4NDkwDQo+ID4gPiAgaW5ldF9yZWN2bXNnKzB4MjgwLzB4MjkwDQo+ID4gPiAgc29ja19yZWN2
bXNnKzB4ZmMvMHgxMjANCj4gPiA+ICBfX19fc3lzX3JlY3Ztc2crMHgxNjAvMHgzZDANCj4gPiA+
ICBfX19zeXNfcmVjdm1zZysweGYwLzB4MTgwDQo+ID4gPiAgX19zeXNfcmVjdm1zZysweGVhLzB4
MWEwDQo+ID4gPiAgZG9fc3lzY2FsbF82NCsweDNmLzB4OTANCj4gPiA+ICBlbnRyeV9TWVNDQUxM
XzY0X2FmdGVyX2h3ZnJhbWUrMHg3Mi8weGRjDQo+ID4gPg0KPiA+ID4gVGhlIGxvZ2ljIGluIHRj
cF9icGZfcmVjdm1zZ19wYXJzZXIgaXMgYXMgZm9sbG93czoNCj4gPiA+DQo+ID4gPiBtc2dfYnl0
ZXNfcmVhZHk6DQo+ID4gPiAgICAgICBjb3BpZWQgPSBza19tc2dfcmVjdm1zZyhzaywgcHNvY2ss
IG1zZywgbGVuLCBmbGFncyk7DQo+ID4gPiAgICAgICBpZiAoIWNvcGllZCkgew0KPiA+ID4gICAg
ICAgICAgICAgICB3YWl0IGRhdGE7DQo+ID4gPiAgICAgICAgICAgICAgIGdvdG8gbXNnX2J5dGVz
X3JlYWR5Ow0KPiA+ID4gICAgICAgfQ0KPiA+ID4NCj4gPiA+IEluIHRoaXMgY2FzZSwgImNvcGll
ZCIgYWx3YXkgaXMgMCwgdGhlIGluZmluaXRlIGxvb3Agb2NjdXJzLg0KPiA+ID4NCj4gPiA+IEFj
Y29yZGluZyB0byB0aGUgTGludXggc3lzdGVtIGNhbGwgbWFuIHBhZ2UsIDAgc2hvdWxkIGJlIHJl
dHVybmVkIGluDQo+ID4gPiB0aGlzIGNhc2UuIFRoZXJlZm9yZSwgaW4gdGNwX2JwZl9yZWN2bXNn
X3BhcnNlcigpLCBpZiB0aGUgbGVuZ3RoIGlzDQo+ID4gPiAwLCBkaXJlY3RseSByZXR1cm4uDQo+
ID4gPg0KPiA+ID4gQWxzbyBtb2RpZnkgc2V2ZXJhbCBvdGhlciBmdW5jdGlvbnMgd2l0aCB0aGUg
c2FtZSBwcm9ibGVtLg0KPiA+ID4NCj4gPiA+IEZpeGVzOiAxZjViZTZiM2IwNjMgKCJ1ZHA6IElt
cGxlbWVudCB1ZHBfYnBmX3JlY3Ztc2coKSBmb3Igc29ja21hcCIpDQo+ID4gPiBGaXhlczogOTgy
NWQ4NjZjZTBkICgiYWZfdW5peDogSW1wbGVtZW50IHVuaXhfZGdyYW1fYnBmX3JlY3Ztc2coKSIp
DQo+ID4gPiBGaXhlczogYzVkMjE3N2E3MmExICgiYnBmLCBzb2NrbWFwOiBGaXggcmFjZSBpbiBp
bmdyZXNzIHJlY2VpdmUNCj4gPiA+IHZlcmRpY3Qgd2l0aCByZWRpcmVjdCB0byBzZWxmIikNCj4g
PiA+IEZpeGVzOiA2MDQzMjZiNDFhNmYgKCJicGYsIHNvY2ttYXA6IGNvbnZlcnQgdG8gZ2VuZXJp
YyBza19tc2cNCj4gPiA+IGludGVyZmFjZSIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgSmlh
biA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+ID4gPiAtLS0NCj4gPg0KPiA+IFRoYW5rcy4NCj4g
Pg0KPiA+IEFja2VkLWJ5OiBKb2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21haWwuY29t
Pg0KPiANCj4gVGhhbmtzIEpvaG4uDQo+IA0KPiBMaXUsDQo+IA0KPiBjb3VsZCB5b3UgcGxlYXNl
IGNoYW5nZSBpZiAobGVuID09IDApIHRvIGlmICghbGVuKSBhbmQgcmVzcGluIHdpdGggSm9obidz
IGFjay4NCj4gVGhhbmtzDQpPa2F5LCBJIHdpbGwgc2VuZCB2Mi4gDQpUaGFua3MuDQo=
