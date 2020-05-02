Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D71C28FC
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgEBXik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgEBXij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:38:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC24C061A0C;
        Sat,  2 May 2020 16:38:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA81515163F03;
        Sat,  2 May 2020 16:38:38 -0700 (PDT)
Date:   Sat, 02 May 2020 16:38:37 -0700 (PDT)
Message-Id: <20200502.163837.822343488746704553.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 01/13] net/smc: first part of add link
 processing as SMC client
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200502123552.17204-2-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
        <20200502123552.17204-2-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:38:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2Fyc3RlbiBHcmF1bCA8a2dyYXVsQGxpbnV4LmlibS5jb20+DQpEYXRlOiBTYXQsICAy
IE1heSAyMDIwIDE0OjM1OjQwICswMjAwDQoNCj4gK3N0YXRpYyB2b2lkIHNtY19sbGNfcHJvY2Vz
c19jbGlfYWRkX2xpbmsoc3RydWN0IHNtY19saW5rX2dyb3VwICpsZ3IpDQo+ICt7DQo+ICsJc3Ry
dWN0IHNtY19sbGNfcWVudHJ5ICpxZW50cnk7DQo+ICsNCj4gKwlxZW50cnkgPSBzbWNfbGxjX2Zs
b3dfcWVudHJ5X2NscigmbGdyLT5sbGNfZmxvd19sY2wpOw0KPiArDQo+ICsJbXV0ZXhfbG9jaygm
bGdyLT5sbGNfY29uZl9tdXRleCk7DQo+ICsJc21jX2xsY19jbGlfYWRkX2xpbmsocWVudHJ5LT5s
aW5rLCBxZW50cnkpOw0KPiArCW11dGV4X3VubG9jaygmbGdyLT5sbGNfY29uZl9tdXRleCk7DQo+
ICt9DQo+ICsNCj4gIC8qIHdvcmtlciB0byBwcm9jZXNzIGFuIGFkZCBsaW5rIG1lc3NhZ2UgKi8N
Cg0KWW91IG11c3QgbWFrZSBzdXJlIHRoZSBjb21waWxhdGlvbiBzdWNjZWVkcyB3aXRob3V0IHdh
cm5pbmdzIGFmdGVyIGVhY2gNCmFuZCBldmVyeSBwYXRjaCBpbiB5b3VyIHBhdGNoIHNlcmllcy4N
Cg0KSGVyZSB5b3UgYXJlIGFkZGluZyBhIHN0YXRpYyBmdW5jdGlvbiB3aGljaCBpcyBjb21wbGV0
ZWx5IHVudXNlZCBzbyBJIGtub3cNCnRoZSBjb21waWxlciB3aWxsIHdhcm4gd2l0aG91dCBldmVu
IGJ1aWxkIHRlc3RpbmcgdGhpcyBwYXRjaC4NCg0KQW5kIHRoaXMgd2FzIGRvbmUgaW4gdGhlIHBy
ZXZpb3VzIHBhdGNoIHNlcmllcyBhcyB3ZWxsLCB3aGljaCBJIHdpbGwNCmZpeCB1cCByaWdodCBu
b3c6DQoNCm5ldC9zbWMvc21jX2xsYy5jOjU0NDoxMjogd2FybmluZzogoXNtY19sbGNfYWxsb2Nf
YWx0X2xpbmuiIGRlZmluZWQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1mdW5jdGlvbl0NCiBzdGF0
aWMgaW50IHNtY19sbGNfYWxsb2NfYWx0X2xpbmsoc3RydWN0IHNtY19saW5rX2dyb3VwICpsZ3Is
DQogICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+DQoNCkkgZ2V0IHRoZSBmZWVsaW5n
LCBzZWVpbmcgYWxsIG9mIHRoaXMsIHRoYXQgeW91IGFyZSBzcGxpdHRpbmcgdXAgdGhlDQpwYXRj
aCBzZXQgcHJvcGVybHkgb25seSBiZWNhdXNlIEkgZmlybWx5IHJlcXVpcmVkIHlvdSB0byBkbyBz
by4gIFRoaXMNCmVmZm9ydCBsb29rcyBoYWxmIGhlYXJ0ZWQgYW5kIGJlaW5nIGRvbmUgcmVsdWN0
YW50bHkuDQoNClBsZWFzZSBjbGVhbiBhbGwgb2YgdGhpcyB1cCBhbmQgc3VibWl0IHRoZXNlIGNo
YW5nZXMgY2xlYW5seSBhbmQNCnByb3Blcmx5LCB0aGFuayB5b3UuDQo=
