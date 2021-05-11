Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC98379C1B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 03:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhEKBed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 21:34:33 -0400
Received: from m1326.mail.163.com ([220.181.13.26]:8800 "EHLO
        m1326.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhEKBec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 21:34:32 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2021 21:34:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=pX0W9
        wuwf/tF+3wemWI5zkKp/yqjIIzDzOY7/OEuSQs=; b=ojlPlmQVsBNtNCUIjHnjR
        cZalyyp1caF1fA2b1zbXhOt/s/15xLONQulg/3eyK9pDtb3EtjianxIE5bapgP8n
        0CxN8YqwZ0TrWjWzCtspGl4ApMrDTgzyT0hHLUjMeN/TKu1DvqHWG/pBBzlrcSLe
        KySbSwpVXo+0R2Gryeophs=
Received: from meijusan$163.com ( [117.131.86.42] ) by ajax-webmail-wmsvr26
 (Coremail) ; Tue, 11 May 2021 09:18:04 +0800 (CST)
X-Originating-IP: [117.131.86.42]
Date:   Tue, 11 May 2021 09:18:04 +0800 (CST)
From:   meijusan <meijusan@163.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] net/ipv4/ip_fragment:fix missing Flags reserved bit
 set in iphdr
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn 163com
In-Reply-To: <20210507155900.43cd8200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210506145905.3884-1-meijusan@163.com>
 <20210507155900.43cd8200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <1368d6c3.bd1.1795900a467.Coremail.meijusan@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: GsGowAA3eNdM25lgWE7gAA--.47834W
X-CM-SenderInfo: xphly3xvdqqiywtou0bp/1tbiFgyPHl44P95hDgAAsj
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjEtMDUtMDggMDY6NTk6MDAsICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9y
Zz4gd3JvdGU6Cj5PbiBUaHUsICA2IE1heSAyMDIxIDIyOjU5OjA1ICswODAwIG1laWp1c2FuIHdy
b3RlOgo+PiBpcCBmcmFnIHdpdGggdGhlIGlwaGRyIGZsYWdzIHJlc2VydmVkIGJpdCBzZXQsdmlh
IHJvdXRlcixpcCBmcmFnIHJlYXNtIG9yCj4+IGZyYWdtZW50LGNhdXNpbmcgdGhlIHJlc2VydmVk
IGJpdCBpcyByZXNldCB0byB6ZXJvLgo+PiAKPj4gS2VlcCByZXNlcnZlZCBiaXQgc2V0IGlzIG5v
dCBtb2RpZmllZCBpbiBpcCBmcmFnICBkZWZyYWcgb3IgZnJhZ21lbnQuCj4+IAo+PiBTaWduZWQt
b2ZmLWJ5OiBtZWlqdXNhbiA8bWVpanVzYW5AMTYzLmNvbT4KPgo+Q291bGQgeW91IHBsZWFzZSBw
cm92aWRlIG1vcmUgYmFja2dyb3VuZCBvbiB3aHkgd2UnZCB3YW50IHRvIGRvIHRoaXM/Cgo+UHJl
ZmVyYWJseSB3aXRoIHJlZmVyZW5jZXMgdG8gcmVsZXZhbnQgKG5vbi1BcHJpbCBGb29scycgRGF5
KSBSRkNzLgoKW2JhY2tncm91bmRdCnRoZSBTaW1wbGUgbmV0d29yayB1c2FnZSBzY2VuYXJpb3M6
IHRoZSBvbmUgUEMgc29mdHdhcmU8LS0tPmxpbnV4IHJvdXRlcihMMykvbGludXggYnJpZGVnZShM
MixicmlkZ2UtbmYtY2FsbC1pcHRhYmxlcyk8LS0tPnRoZSBvdGhlciBQQyBzb2Z0d2FyZQoxKXRo
ZSBQQyBzb2Z0d2FyZSBzZW5kIHRoZSBpcCBwYWNrZXQgd2l0aCB0aGUgaXBoZHIgZmxhZ3MgcmVz
ZXJ2ZWQgYml0IGlzIHNldCwgd2hlbiBpcCBwYWNrZXQobm90IGZyYWdtZW50cyApIHZpYSB0aGUg
b25lIGxpbnV4IHJvdXRlci9saW51eCBicmlkZ2UsYW5kIHRoZSBpcGhkciBmbGFncyByZXNlcnZl
ZCBiaXQgaXMgbm90IG1vZGlmaWVkOwoyKWJ1dCB0aGUgaXAgZnJhZ21lbnRzIHZpYSByb3V0ZXIs
dGhlIGxpbnV4IElQIHJlYXNzZW1ibHkgb3IgZnJhZ21lbnRhdGlvbiAsY2F1c2luZyB0aGUgcmVz
ZXJ2ZWQgYml0IGlzIHJlc2V0IHRvIHplcm8sV2hpY2ggbGVhZHMgdG8gVGhlIG90aGVyIFBDIHNv
ZnR3YXJlIGRlcGVuZGluZyBvbiB0aGUgcmVzZXJ2ZWQgYml0IHNldCAgcHJvY2VzcyB0aGUgUGFj
a2V0IGZhaWxlZC4KW3JmY10KUkZDNzkxCkJpdCAwOiByZXNlcnZlZCwgbXVzdCBiZSB6ZXJvClJG
QzM1MTQKSW50cm9kdWN0aW9uIFRoaXMgYml0ICwgYnV0IFRoZSBzY2VuZSBzZWVtcyBkaWZmZXJl
bnQgZnJvbSB1c6Osd2UgZXhwZWN0IEtlZXAgcmVzZXJ2ZWQgYml0IHNldCBpcyBub3QgbW9kaWZp
ZWQgd2hlbiBmb3J3YXJkIHRoZSBsaW51eCByb3V0ZXIKCgoKCgo=
