Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002893CB9CD
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbhGPPaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:30:04 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:39417
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S233094AbhGPPaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:30:03 -0400
Received: by ajax-webmail-mail-app3 (Coremail) ; Fri, 16 Jul 2021 23:26:47
 +0800 (GMT+08:00)
X-Originating-IP: [183.159.168.36]
Date:   Fri, 16 Jul 2021 23:26:47 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   LinMa <3160105373@zju.edu.cn>
To:     "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "Desmond Cheong Zhi Xi" <desmondcheongzx@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: Re: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock
 section
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <e07c5bbf-115c-6ffa-8492-7b749b9d286b@i-love.sakura.ne.jp>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
 <CABBYNZJKWktRo1pCMdafAZ22sE2ZbZeMuFOO+tHUxOtEtTDTeA@mail.gmail.com>
 <674e6b1c.4780d.17aa81ee04c.Coremail.linma@zju.edu.cn>
 <2b0e515c-6381-bffe-7742-05148e1e2dcb@gmail.com>
 <4b955786-d233-8d3f-4445-2422c1daf754@gmail.com>
 <e07c5bbf-115c-6ffa-8492-7b749b9d286b@i-love.sakura.ne.jp>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4bd89382.4d087.17aafed62b1.Coremail.3160105373@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgCHODw4pfFgyyqBAQ--.45359W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUIElNG3Df-vAAAsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gZXZlcnlvbmUsCgpTb3JyeSwgaXQncyBteSBmYXVsdCB0byBjYXVzZSB0aGUgbWlzdW5k
ZXJzdGFuZGluZy4KCkFzIEkga2VlcCBtZW50aW9uaW5nICJoY2lfc29ja19zZW5kbXNnKCkiIGlu
c3RlYWQgb2YgImhjaV9zb2NrX2JvdW5kX2lvY3RsKCkiLiBJbiBmYWN0LCBib3RoIHRoZXNlIHR3
byBmdW5jdGlvbnMgYXJlIGFibGUgdG8gY2F1c2UgdGhlIHJhY2UuCgo+ID4+Cj4gPiAKPiA+IE15
IGJhZCwgd2FzIHRoaW5raW5nIG1vcmUgYWJvdXQgdGhlIHByb2JsZW0gYW5kIG5vdGljZWQgeW91
ciBwb2Mgd2FzIGZvciBoY2lfc29ja19zZW5kbXNnLAo+ID4gbm90IGhjaV9zb2NrX2Rldl9ldmVu
dC4KPiAKPiBJIGRpZG4ndCBjYXRjaCB0aGlzIHBhcnQuIEFyZSB5b3UgdGFsa2luZyBhYm91dCBh
IGRpZmZlcmVudCBwb2M/Cj4gQXMgZmFyIGFzIEknbSBhd2FyZSwgZXhwLmMgaW4gUE9DLnppcCB3
YXMgZm9yIGhjaV9zb2NrX2JvdW5kX2lvY3RsKEhDSVVOQkxPQ0tBRERSKS4KPiAKPiBoY2lfc29j
a19ib3VuZF9pb2N0bChIQ0lVTkJMT0NLQUREUikgKHdoaWNoIGlzIGNhbGxlZCBiZXR3ZWVuIGxv
Y2tfc29jaygpIGFuZCByZWxlYXNlX3NvY2soKSkKPiBjYWxscyBjb3B5X2Zyb21fdXNlcigpIHdo
aWNoIG1pZ2h0IGNhdXNlIHBhZ2UgZmF1bHQsIGFuZCB1c2VyZmF1bHRmZCBtZWNoYW5pc20gYWxs
b3dzIGFuIGF0dGFja2VyCj4gdG8gc2xvd2Rvd24gcGFnZSBmYXVsdCBoYW5kbGluZyBlbm91Z2gg
dG8gaGNpX3NvY2tfZGV2X2V2ZW50KEhDSV9ERVZfVU5SRUcpIHRvIHJldHVybiB3aXRob3V0Cj4g
d2FpdGluZyBmb3IgaGNpX3NvY2tfYm91bmRfaW9jdGwoSENJVU5CTE9DS0FERFIpIHRvIGNhbGwg
cmVsZWFzZV9zb2NrKCkuIFRoaXMgcmFjZSB3aW5kb3cKPiByZXN1bHRzIGluIFVBRiAoZG9lc24n
dCBpdCwgTGluTWE/KS4KPiAKCllvdXIgdW5kZXJzdGFuZGluZyBhYm92ZSBpcyBxdWl0ZSByaWdo
dC4gSW4gYWRkaXRpb24sIGJlY2F1c2UgdGhlIGhjaV9zb2NrX3NlbmRtc2coKSBjYWxscyB0aGUg
bWVtY3B5X2Zyb21fbXNnKC4uLiksIHdoaWNoIGFsc28gaW4gZmFjdCBmZXRjaCBkYXRhIGZyb20g
dXNlcnNwYWNlIG1lbW9yeSwgdGhlIHVzZXJmYXVsdGZkIGNhbiB0YWtlIGVmZmVjdCBhcyB3ZWxs
LgoKKFdoZW4gd3JpdGluZyB0aGUgZXhwbG9pdCBmb3IgdGhpcyBDVkUsIHRoZSBoY2lfc29ja19z
ZW5kbXNnKCkgaXMgbXVjaCB1c2VmdWwuLi4gc28gSSByZWNlbnRseSBrZWVwIG1lbnRpb25pbmcg
dGhpcyBmdW5jdGlvbikKClJlZ2FyZHMKTGluIE1h
