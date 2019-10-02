Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3295C45A0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfJBBiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:38:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729750AbfJBBiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:38:22 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7505414DB52E6;
        Tue,  1 Oct 2019 18:38:21 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:38:20 -0400 (EDT)
Message-Id: <20191001.213820.377414760480275548.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, shahjada@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix out-of-bounds MSI-X info array access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569883077-15909-1-git-send-email-vishal@chelsio.com>
References: <1569883077-15909-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:38:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVmlzaGFsIEt1bGthcm5pIDx2aXNoYWxAY2hlbHNpby5jb20+DQpEYXRlOiBUdWUsICAx
IE9jdCAyMDE5IDA0OjA3OjU3ICswNTMwDQoNCj4gV2hlbiBmZXRjaGluZyBmcmVlIE1TSS1YIHZl
Y3RvcnMgZm9yIFVMRHMsIGNoZWNrIGZvciB0aGUNCj4gZXJyb3IgY29kZSBiZWZvcmUgYWNjZXNz
aW5nIE1TSS1YIGluZm8gYXJyYXkuIE90aGVyd2lzZSwNCj4gYW4gb3V0LW9mLWJvdW5kcyBhY2Nl
c3MgaXMgYXR0ZW1wdGVkLCB3aGljaCByZXN1bHRzIGluDQo+IGtlcm5lbCBwYW5pYy4NCj4gDQo+
IEZpeGVzOiA5NGNkYjhiYjk5M2EgKCJjeGdiNDogQWRkIHN1cHBvcnQgZm9yIGR5bmFtaWMgYWxs
b2NhdGlvbiBvZg0KPiByZXNvdXJjZXMgZm9yIFVMRCIpDQoNClBsZWFzZSBkbyBub3Qgc3BsaXQg
Rml4ZXM6IHRhZ3Mgb250byBtdWx0aXBsZSBsaW5lcy4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBTaGFo
amFkYSBBYnVsIEh1c2FpbiA8c2hhaGphZGFAY2hlbHNpby5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IFZpc2hhbCBLdWxrYXJuaSA8dmlzaGFsQGNoZWxzaW8uY29tPg0KDQpUaGlzIHBhdGNoIGFkZHMg
YSBuZXcgd2FybmluZzoNCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvY2hlbHNpby9jeGdiNC9jeGdi
NF91bGQuYzogSW4gZnVuY3Rpb24goWN4Z2I0X3JlZ2lzdGVyX3VsZKI6DQpkcml2ZXJzL25ldC9l
dGhlcm5ldC9jaGVsc2lvL2N4Z2I0L2N4Z2I0X3VsZC5jOjE3OToyNjogd2FybmluZzogoWJtYXBf
aWR4oiBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rpb24gWy1XbWF5YmUt
dW5pbml0aWFsaXplZF0NCiAgICByeHFfaW5mby0+bXNpeF90YmxbaV0gPSBibWFwX2lkeDsNCiAg
ICB+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Xn5+fn5+fn5+fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
Y2hlbHNpby9jeGdiNC9jeGdiNF91bGQuYzoxNDE6MTQ6IG5vdGU6IKFibWFwX2lkeKIgd2FzIGRl
Y2xhcmVkIGhlcmUNCiAgaW50IGksIGVyciwgYm1hcF9pZHgsIG1zaV9pZHgsIHF1ZV9pZHggPSAw
Ow0KICAgICAgICAgICAgICBefn5+fn5+fg0K
