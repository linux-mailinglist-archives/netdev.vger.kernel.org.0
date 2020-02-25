Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AA916F105
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBYVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:20:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgBYVUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:20:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A42C13EC669B;
        Tue, 25 Feb 2020 13:20:44 -0800 (PST)
Date:   Tue, 25 Feb 2020 13:20:41 -0800 (PST)
Message-Id: <20200225.132041.1071108395246034738.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [patch net-next] iavf: use tc_cls_can_offload_basic() instead
 of chain check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <469b51add666cf3df7381b6409a3972c70024c12.camel@intel.com>
References: <20200225121023.6011-1-jiri@resnulli.us>
        <469b51add666cf3df7381b6409a3972c70024c12.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 13:20:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmVmZiBLaXJzaGVyIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+DQpEYXRlOiBU
dWUsIDI1IEZlYiAyMDIwIDEzOjE1OjQ2IC0wODAwDQoNCj4gT24gVHVlLCAyMDIwLTAyLTI1IGF0
IDEzOjEwICswMTAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4gRnJvbTogSmlyaSBQaXJrbyA8amly
aUBtZWxsYW5veC5jb20+DQo+PiANCj4+IExvb2tzIGxpa2UgdGhlIGlhdmYgY29kZSBhY3R1YWxs
eSBleHBlcmllbmNlZCBhIHJhY2UgY29uZGl0aW9uLCB3aGVuDQo+PiBhDQo+PiBkZXZlbG9wZXIg
dG9vayBjb2RlIGJlZm9yZSB0aGUgY2hlY2sgZm9yIGNoYWluIDAgd2FzIHB1dCB0byBoZWxwZXIu
DQo+PiBTbyB1c2UgdGNfY2xzX2Nhbl9vZmZsb2FkX2Jhc2ljKCkgaGVscGVyIGluc3RlYWQgb2Yg
ZGlyZWN0IGNoZWNrIGFuZA0KPj4gbW92ZSB0aGUgY2hlY2sgdG8gX2NiKCkgc28gdGhpcyBpcyBz
aW1pbGFyIHRvIGk0MGUgY29kZS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSmlyaSBQaXJrbyA8
amlyaUBtZWxsYW5veC5jb20+DQo+IA0KPiBBY2tlZC1ieTogSmVmZiBLaXJzaGVyIDxqZWZmcmV5
LnQua2lyc2hlckBpbnRlbC5jb20+DQo+IA0KPiBHbyBhaGVhZCBhbmQgcGljayB0aGlzIHVwIERh
dmUsIHRoYW5rcyENCg0KSG1tbSwgSmlyaSB0aGlzIGRvZXNuJ3QgY29tcGlsZT8NCg0KICBDQyBb
TV0gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9tYWluLm8NCmRyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9tYWluLmM6IEluIGZ1bmN0aW9uIKFpYXZmX3Nl
dHVwX3RjX2Jsb2NrX2NiojoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9t
YWluLmM6MzA4OTo3OiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24goXRj
X2Nsc19jYW5fb2ZmbG9hZF9iYXNpY6I7IGRpZCB5b3UgbWVhbiChdGNfY2xzX2NvbW1vbl9vZmZs
b2FkX2luaXSiPyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0NCiAgaWYg
KCF0Y19jbHNfY2FuX29mZmxvYWRfYmFzaWMoYWRhcHRlci0+bmV0ZGV2LCB0eXBlX2RhdGEpKQ0K
ICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KICAgICAgIHRjX2Nsc19jb21tb25fb2Zm
bG9hZF9pbml0DQoNCk1heWJlIGl0IGRvZXMgZGVwZW5kIHVwb24gc29tZXRoaW5nIGluIHRoZSB0
YyBmaWx0ZXIgcGF0Y2ggc2VyaWVzPw0K
