Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC366E796
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjAQURX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbjAQUNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:13:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FAF13D7D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673982365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MpsO+POA9H7W62udMYHKZqv0nL/aJQ/9aqwMH3QSJQo=;
        b=BgpbT1sjY3inCEEuQvJ+659JPr/sMYfuo453X8L7f+ghlqBa/Y//0h1Qa6yV68xjXMBypw
        hhVCPMOWDaA4O6Uwo6qIhfQ5YYrfK5zXUY781rXnQ3iHhT4ZywJRpMMzMXozzkyuw7ZV8m
        TlG4va2V+x9/W5EykNWZSzriM3YiemA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-1fxyaWpqOuWDTz3jLaNqEA-1; Tue, 17 Jan 2023 14:06:01 -0500
X-MC-Unique: 1fxyaWpqOuWDTz3jLaNqEA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CE691C189A5;
        Tue, 17 Jan 2023 19:06:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-0-29.rdu2.redhat.com [10.22.0.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3373492B00;
        Tue, 17 Jan 2023 19:05:58 +0000 (UTC)
Message-ID: <bce510429d60852b6589b8b9fb1a5c93665a8ec9.camel@redhat.com>
Subject: Re: [PATCH v3 4/4] wifi: libertas: add support for WPS enrollee IE
 in probe requests
From:   Dan Williams <dcbw@redhat.com>
To:     Doug Brown <doug@schmorgal.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 17 Jan 2023 13:05:58 -0600
In-Reply-To: <20230116202126.50400-5-doug@schmorgal.com>
References: <20230116202126.50400-1-doug@schmorgal.com>
         <20230116202126.50400-5-doug@schmorgal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTE2IGF0IDEyOjIxIC0wODAwLCBEb3VnIEJyb3duIHdyb3RlOgo+IEFk
ZCBjb21wYXRpYmlsaXR5IHdpdGggV1BTIGJ5IHBhc3Npbmcgb24gV1BTIGVucm9sbGVlIGluZm9y
bWF0aW9uIGluCj4gcHJvYmUgcmVxdWVzdHMuIElnbm9yZSBvdGhlciBJRXMgc3VwcGxpZWQgaW4g
dGhlIHNjYW4gcmVxdWVzdC4gVGhpcwo+IGFsc28KPiBoYXMgdGhlIGFkZGVkIGJlbmVmaXQgb2Yg
cmVzdG9yaW5nIGNvbXBhdGliaWxpdHkgd2l0aCBuZXdlcgo+IHdwYV9zdXBwbGljYW50IHZlcnNp
b25zIHRoYXQgYWx3YXlzIGFkZCBzY2FuIElFcy4gUHJldmlvdXNseSwgd2l0aAo+IG1heF9zY2Fu
X2llX2xlbiBzZXQgdG8gMCwgc2NhbnMgd291bGQgYWx3YXlzIGZhaWwuCj4gCj4gU3VnZ2VzdGVk
LWJ5OiBEYW4gV2lsbGlhbXMgPGRjYndAcmVkaGF0LmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBEb3Vn
IEJyb3duIDxkb3VnQHNjaG1vcmdhbC5jb20+CgpSZXZpZXdlZC1ieTogRGFuIFdpbGxpYW1zIDxk
Y2J3QHJlZGhhdC5jb20+CgooZG9uJ3Qga25vdyBpZiBJIGNhbi9zaG91bGQgYWNrIGFueXRoaW5n
IGFueW1vcmUsIGdpdmVuIEkgaGF2ZW4ndAp0b3VjaGVkIHRoZSBkcml2ZXIgaW4gbGlrZSA0IHll
YXJzLi4uKQoKPiAtLS0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbGliZXJ0YXMv
Y2ZnLmMgfCA0OAo+ICsrKysrKysrKysrKysrKysrKystLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDQ1
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL21hcnZlbGwvbGliZXJ0YXMvY2ZnLmMKPiBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL21hcnZlbGwvbGliZXJ0YXMvY2ZnLmMKPiBpbmRleCAzZjM1ZGM3YTFkN2QuLmI3MDBjMjEz
ZDEwYyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL2xpYmVydGFz
L2NmZy5jCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9saWJlcnRhcy9jZmcu
Ywo+IEBAIC00NDYsNiArNDQ2LDQxIEBAIHN0YXRpYyBpbnQgbGJzX2FkZF93cGFfdGx2KHU4ICp0
bHYsIGNvbnN0IHU4Cj4gKmllLCB1OCBpZV9sZW4pCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBz
aXplb2Yoc3RydWN0IG1ydmxfaWVfaGVhZGVyKSArIHdwYWllLT5kYXRhbGVuOwo+IMKgfQo+IMKg
Cj4gKy8qIEFkZCBXUFMgZW5yb2xsZWUgVExWCj4gKyAqLwo+ICsjZGVmaW5lIExCU19NQVhfV1BT
X0VOUk9MTEVFX1RMVl9TSVpFwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gK8KgwqDCoMKgwqDCoMKg
KHNpemVvZihzdHJ1Y3QgbXJ2bF9pZV9oZWFkZXIpwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gK8Kg
wqDCoMKgwqDCoMKgICsgMjU2KQo+ICsKPiArc3RhdGljIGludCBsYnNfYWRkX3dwc19lbnJvbGxl
ZV90bHYodTggKnRsdiwgY29uc3QgdTggKmllLCBzaXplX3QKPiBpZV9sZW4pCj4gK3sKPiArwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgbXJ2bF9pZV9kYXRhICp3cHN0bHYgPSAoc3RydWN0IG1ydmxfaWVf
ZGF0YSAqKXRsdjsKPiArwqDCoMKgwqDCoMKgwqBjb25zdCBzdHJ1Y3QgZWxlbWVudCAqd3BzaWU7
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qIExvb2sgZm9yIGEgV1BTIElFIGFuZCBhZGQgaXQgdG8g
dGhlIHByb2JlIHJlcXVlc3QgKi8KPiArwqDCoMKgwqDCoMKgwqB3cHNpZSA9IGNmZzgwMjExX2Zp
bmRfdmVuZG9yX2VsZW0oV0xBTl9PVUlfTUlDUk9TT0ZULAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoAo+IFdMQU5fT1VJX1RZUEVfTUlDUk9TT0ZUX1dQUywKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgaWUsIGllX2xlbik7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCF3cHNpZSkKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8q
IENvbnZlcnQgdGhlIFdQUyBJRSB0byBhIFRMVi4gVGhlIElFIGxvb2tzIGxpa2UgdGhpczoKPiAr
wqDCoMKgwqDCoMKgwqAgKsKgwqAgdTjCoMKgwqDCoMKgIHR5cGUgKFdMQU5fRUlEX1ZFTkRPUl9T
UEVDSUZJQykKPiArwqDCoMKgwqDCoMKgwqAgKsKgwqAgdTjCoMKgwqDCoMKgIGxlbgo+ICvCoMKg
wqDCoMKgwqDCoCAqwqDCoCB1OFtdwqDCoMKgIGRhdGEKPiArwqDCoMKgwqDCoMKgwqAgKiBidXQg
dGhlIFRMViB3aWxsIGxvb2sgbGlrZSB0aGlzIGluc3RlYWQ6Cj4gK8KgwqDCoMKgwqDCoMKgICrC
oMKgIF9fbGUxNsKgIHR5cGUgKFRMVl9UWVBFX1dQU19FTlJPTExFRSkKPiArwqDCoMKgwqDCoMKg
wqAgKsKgwqAgX19sZTE2wqAgbGVuCj4gK8KgwqDCoMKgwqDCoMKgICrCoMKgIHU4W13CoMKgwqAg
ZGF0YQo+ICvCoMKgwqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqDCoHdwc3Rsdi0+aGVhZGVy
LnR5cGUgPSBjcHVfdG9fbGUxNihUTFZfVFlQRV9XUFNfRU5ST0xMRUUpOwo+ICvCoMKgwqDCoMKg
wqDCoHdwc3Rsdi0+aGVhZGVyLmxlbiA9IGNwdV90b19sZTE2KHdwc2llLT5kYXRhbGVuKTsKPiAr
wqDCoMKgwqDCoMKgwqBtZW1jcHkod3BzdGx2LT5kYXRhLCB3cHNpZS0+ZGF0YSwgd3BzaWUtPmRh
dGFsZW4pOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAvKiBSZXR1cm4gdGhlIHRvdGFsIG51bWJlciBv
ZiBieXRlcyBhZGRlZCB0byB0aGUgVExWIGJ1ZmZlcgo+ICovCj4gK8KgwqDCoMKgwqDCoMKgcmV0
dXJuIHNpemVvZihzdHJ1Y3QgbXJ2bF9pZV9oZWFkZXIpICsgd3BzaWUtPmRhdGFsZW47Cj4gK30K
PiArCj4gwqAvKgo+IMKgICogU2V0IENoYW5uZWwKPiDCoCAqLwo+IEBAIC02NzIsMTQgKzcwNywx
NSBAQCBzdGF0aWMgaW50IGxic19yZXRfc2NhbihzdHJ1Y3QgbGJzX3ByaXZhdGUKPiAqcHJpdiwg
dW5zaWduZWQgbG9uZyBkdW1teSwKPiDCoAo+IMKgCj4gwqAvKgo+IC0gKiBPdXIgc2NhbiBjb21t
YW5kIGNvbnRhaW5zIGEgVExWLCBjb25zdGluZyBvZiBhIFNTSUQgVExWLCBhCj4gY2hhbm5lbCBs
aXN0Cj4gLSAqIFRMViBhbmQgYSByYXRlcyBUTFYuIERldGVybWluZSB0aGUgbWF4aW11bSBzaXpl
IG9mIHRoZW06Cj4gKyAqIE91ciBzY2FuIGNvbW1hbmQgY29udGFpbnMgYSBUTFYsIGNvbnNpc3Rp
bmcgb2YgYSBTU0lEIFRMViwgYQo+IGNoYW5uZWwgbGlzdAo+ICsgKiBUTFYsIGEgcmF0ZXMgVExW
LCBhbmQgYW4gb3B0aW9uYWwgV1BTIElFLiBEZXRlcm1pbmUgdGhlIG1heGltdW0KPiBzaXplIG9m
IHRoZW06Cj4gwqAgKi8KPiDCoCNkZWZpbmUgTEJTX1NDQU5fTUFYX0NNRF9TSVpFwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgXAo+IMKgwqDCoMKgwqDCoMKgwqAoc2l6ZW9mKHN0
cnVjdCBjbWRfZHNfODAyXzExX3NjYW4pwqDCoMKgwqDCoMKgXAo+IMKgwqDCoMKgwqDCoMKgwqAg
KyBMQlNfTUFYX1NTSURfVExWX1NJWkXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwK
PiDCoMKgwqDCoMKgwqDCoMKgICsgTEJTX01BWF9DSEFOTkVMX0xJU1RfVExWX1NJWkXCoMKgwqDC
oMKgwqDCoMKgXAo+IC3CoMKgwqDCoMKgwqDCoCArIExCU19NQVhfUkFURVNfVExWX1NJWkUpCj4g
K8KgwqDCoMKgwqDCoMKgICsgTEJTX01BWF9SQVRFU19UTFZfU0laRcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoFwKPiArwqDCoMKgwqDCoMKgwqAgKyBMQlNfTUFYX1dQU19FTlJPTExFRV9U
TFZfU0laRSkKPiDCoAo+IMKgLyoKPiDCoCAqIEFzc3VtZXMgcHJpdi0+c2Nhbl9yZXEgaXMgaW5p
dGlhbGl6ZWQgYW5kIHZhbGlkCj4gQEAgLTcyOCw2ICs3NjQsMTEgQEAgc3RhdGljIHZvaWQgbGJz
X3NjYW5fd29ya2VyKHN0cnVjdCB3b3JrX3N0cnVjdAo+ICp3b3JrKQo+IMKgwqDCoMKgwqDCoMKg
wqAvKiBhZGQgcmF0ZXMgVExWICovCj4gwqDCoMKgwqDCoMKgwqDCoHRsdiArPSBsYnNfYWRkX3N1
cHBvcnRlZF9yYXRlc190bHYodGx2KTsKPiDCoAo+ICvCoMKgwqDCoMKgwqDCoC8qIGFkZCBvcHRp
b25hbCBXUFMgZW5yb2xsZWUgVExWICovCj4gK8KgwqDCoMKgwqDCoMKgaWYgKHByaXYtPnNjYW5f
cmVxLT5pZSAmJiBwcml2LT5zY2FuX3JlcS0+aWVfbGVuKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB0bHYgKz0gbGJzX2FkZF93cHNfZW5yb2xsZWVfdGx2KHRsdiwgcHJpdi0+c2Nh
bl9yZXEtCj4gPmllLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHJp
di0+c2Nhbl9yZXEtCj4gPmllX2xlbik7Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocHJpdi0+
c2Nhbl9jaGFubmVsIDwgcHJpdi0+c2Nhbl9yZXEtPm5fY2hhbm5lbHMpIHsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNhbmNlbF9kZWxheWVkX3dvcmsoJnByaXYtPnNjYW5fd29y
ayk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAobmV0aWZfcnVubmluZyhw
cml2LT5kZXYpKQo+IEBAIC0yMTE0LDYgKzIxNTUsNyBAQCBpbnQgbGJzX2NmZ19yZWdpc3Rlcihz
dHJ1Y3QgbGJzX3ByaXZhdGUgKnByaXYpCj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gwqAK
PiDCoMKgwqDCoMKgwqDCoMKgd2Rldi0+d2lwaHktPm1heF9zY2FuX3NzaWRzID0gMTsKPiArwqDC
oMKgwqDCoMKgwqB3ZGV2LT53aXBoeS0+bWF4X3NjYW5faWVfbGVuID0gMjU2Owo+IMKgwqDCoMKg
wqDCoMKgwqB3ZGV2LT53aXBoeS0+c2lnbmFsX3R5cGUgPSBDRkc4MDIxMV9TSUdOQUxfVFlQRV9N
Qk07Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgd2Rldi0+d2lwaHktPmludGVyZmFjZV9tb2RlcyA9
Cgo=

