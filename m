Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948F2160894
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgBQDSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:18:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgBQDSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:18:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4F8E155A0479;
        Sun, 16 Feb 2020 19:18:37 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:18:37 -0800 (PST)
Message-Id: <20200216.191837.828352407289487240.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     jiri@resnulli.us, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        netdev@vger.kernel.org, soukjin.bae@samsung.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net] net: sched: correct flower port blocking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200216.190812.1663746557417341122.davem@davemloft.net>
References: <CAM_iQpU_dbze9u2U+QjasAw6Rg3UPkax-rs=W1kwi3z4d5pwwg@mail.gmail.com>
        <1581697224-20041-1-git-send-email-jbaron@akamai.com>
        <20200216.190812.1663746557417341122.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:18:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogU3VuLCAxNiBG
ZWIgMjAyMCAxOTowODoxMiAtMDgwMCAoUFNUKQ0KDQo+IEZyb206IEphc29uIEJhcm9uIDxqYmFy
b25AYWthbWFpLmNvbT4NCj4gRGF0ZTogRnJpLCAxNCBGZWIgMjAyMCAxMToyMDoyNCAtMDUwMA0K
PiANCj4+IHRjIGZsb3dlciBydWxlcyB0aGF0IGFyZSBiYXNlZCBvbiBzcmMgb3IgZHN0IHBvcnQg
YmxvY2tpbmcgYXJlIHNvbWV0aW1lcw0KPj4gaW5lZmZlY3RpdmUgZHVlIHRvIHVuaW5pdGlhbGl6
ZWQgc3RhY2sgZGF0YS4gX19za2JfZmxvd19kaXNzZWN0KCkgZXh0cmFjdHMNCj4+IHBvcnRzIGZy
b20gdGhlIHNrYiBmb3IgdGMgZmxvd2VyIHRvIG1hdGNoIGFnYWluc3QuIEhvd2V2ZXIsIHRoZSBw
b3J0DQo+PiBkaXNzZWN0aW9uIGlzIG5vdCBkb25lIHdoZW4gd2hlbiB0aGUgRkxPV19ESVNfSVNf
RlJBR01FTlQgYml0IGlzIHNldCBpbg0KPj4ga2V5X2NvbnRyb2wtPmZsYWdzLiBBbGwgY2FsbGVy
cyBvZiBfX3NrYl9mbG93X2Rpc3NlY3QoKSwgemVyby1vdXQgdGhlDQo+PiBrZXlfY29udHJvbCBm
aWVsZCBleGNlcHQgZm9yIGZsX2NsYXNzaWZ5KCkgYXMgdXNlZCBieSB0aGUgZmxvd2VyDQo+PiBj
bGFzc2lmaWVyLiBUaHVzLCB0aGUgRkxPV19ESVNfSVNfRlJBR01FTlQgbWF5IGJlIHNldCBvbiBl
bnRyeSB0bw0KPj4gX19za2JfZmxvd19kaXNzZWN0KCksIHNpbmNlIGtleV9jb250cm9sIGlzIGFs
bG9jYXRlZCBvbiB0aGUgc3RhY2sNCj4+IGFuZCBtYXkgbm90IGJlIGluaXRpYWxpemVkLg0KPj4g
DQo+PiBTaW5jZSBrZXlfYmFzaWMgYW5kIGtleV9jb250cm9sIGFyZSBwcmVzZW50IGZvciBhbGwg
ZmxvdyBrZXlzLCBsZXQncw0KPj4gbWFrZSBzdXJlIHRoZXkgYXJlIGluaXRpYWxpemVkLg0KPj4g
DQo+PiBGaXhlczogNjIyMzA3MTVmZDI0ICgiZmxvd19kaXNzZWN0b3I6IGRvIG5vdCBkaXNzZWN0
IGw0IHBvcnRzIGZvciBmcmFnbWVudHMiKQ0KPj4gQ28tZGV2ZWxvcGVkLWJ5OiBFcmljIER1bWF6
ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIER1bWF6ZXQg
PGVkdW1hemV0QGdvb2dsZS5jb20+DQo+PiBBY2tlZC1ieTogQ29uZyBXYW5nIDx4aXlvdS53YW5n
Y29uZ0BnbWFpbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBCYXJvbiA8amJhcm9uQGFr
YW1haS5jb20+DQo+IA0KPiBBcHBsaWVkIGFuZCBxdWV1ZWQgdXAgZm9yIC1zdGFibGUuDQoNCkFj
dHVhbGx5IHRoaXMgZG9lc24ndCBldmVuIGNvbXBpbGU6DQoNCkluIGZpbGUgaW5jbHVkZWQgZnJv
bSBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYzozMzoNCi4v
aW5jbHVkZS9uZXQvZmxvd19kaXNzZWN0b3IuaDogSW4gZnVuY3Rpb24goWZsb3dfZGlzc2VjdG9y
X2luaXRfa2V5c6I6DQouL2luY2x1ZGUvbmV0L2Zsb3dfZGlzc2VjdG9yLmg6MzU1OjI6IGVycm9y
OiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbiChbWVtc2V0oiBbLVdlcnJvcj1pbXBs
aWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0NCiAgbWVtc2V0KGtleV9jb250cm9sLCAwLCBzaXpl
b2YoKmtleV9jb250cm9sKSk7DQogIF5+fn5+fg0KLi9pbmNsdWRlL25ldC9mbG93X2Rpc3NlY3Rv
ci5oOjM1NToyOiB3YXJuaW5nOiBpbmNvbXBhdGlibGUgaW1wbGljaXQgZGVjbGFyYXRpb24gb2Yg
YnVpbHQtaW4gZnVuY3Rpb24goW1lbXNldKINCi4vaW5jbHVkZS9uZXQvZmxvd19kaXNzZWN0b3Iu
aDozNTU6Mjogbm90ZTogaW5jbHVkZSChPHN0cmluZy5oPqIgb3IgcHJvdmlkZSBhIGRlY2xhcmF0
aW9uIG9mIKFtZW1zZXSiDQouL2luY2x1ZGUvbmV0L2Zsb3dfZGlzc2VjdG9yLmg6OToxOg0KKyNp
bmNsdWRlIDxzdHJpbmcuaD4NCiANCi4vaW5jbHVkZS9uZXQvZmxvd19kaXNzZWN0b3IuaDozNTU6
MjoNCiAgbWVtc2V0KGtleV9jb250cm9sLCAwLCBzaXplb2YoKmtleV9jb250cm9sKSk7DQogIF5+
fn5+fg0K
