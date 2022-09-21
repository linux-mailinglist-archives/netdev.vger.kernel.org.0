Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD35BFEED
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiIUN1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIUN1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:27:10 -0400
Received: from m1564.mail.126.com (m1564.mail.126.com [220.181.15.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57EBE796BE
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=eR3qo
        1izq/7c7trHoKx4jvzufr7qj19LpHfaBsAIcRs=; b=CLF2wG6UA/CHt2RAz1V2W
        9egUeTqrM7FJ1p7CGMNGFHG9pBY8qvv5qPS/3+zujfI7+CPrjGUxdDbghEnoS58p
        ZvseVr9HTGEl2g6J1MRvjP3MOyUyu/cRrJPTQNqumhqYrNTyVF73r35cMjH5zAsG
        yL/0KqefQjDuJlM2m4yesE=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr64
 (Coremail) ; Wed, 21 Sep 2022 21:26:17 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Wed, 21 Sep 2022 21:26:17 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] net: marvell: Fix refcounting bugs in
 prestera_port_sfp_bind()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220921053635.06ad8511@kernel.org>
References: <20220915040655.4007281-1-windhl@126.com>
 <20220920174529.3e8e106d@kernel.org>
 <5722f6ba.6204.1835f4924aa.Coremail.windhl@126.com>
 <20220921053635.06ad8511@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <31763e3d.79d2.183603a4e29.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMqowAAXH3P6ECtjdbR0AA--.7927W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgCDF1-HZ3h4JAABsU
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKQXQgMjAyMi0wOS0yMSAyMDozNjozNSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToKPk9uIFdlZCwgMjEgU2VwIDIwMjIgMTc6MDI6NTIgKzA4MDAgKENTVCkgTGlh
bmcgSGUgd3JvdGU6Cj4+IEF0IDIwMjItMDktMjEgMDg6NDU6MjksICJKYWt1YiBLaWNpbnNraSIg
PGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6Cj4+ID5PbiBUaHUsIDE1IFNlcCAyMDIyIDEyOjA2OjU1
ICswODAwIExpYW5nIEhlIHdyb3RlOiAgCj4+ID4+IEluIHByZXN0ZXJhX3BvcnRfc2ZwX2JpbmQo
KSwgdGhlcmUgYXJlIHR3byByZWZjb3VudGluZyBidWdzOgo+PiA+PiAoMSkgd2Ugc2hvdWxkIGNh
bGwgb2Zfbm9kZV9nZXQoKSBiZWZvcmUgb2ZfZmluZF9ub2RlX2J5X25hbWUoKSBhcwo+PiA+PiBp
dCB3aWxsIGF1dG9tYWl0Y2FsbHkgZGVjcmVhc2UgdGhlIHJlZmNvdW50IG9mICdmcm9tJyBhcmd1
bWVudDsKPj4gPj4gKDIpIHdlIHNob3VsZCBjYWxsIG9mX25vZGVfcHV0KCkgZm9yIHRoZSBicmVh
ayBvZiB0aGUgaXRlcmF0aW9uCj4+ID4+IGZvcl9lYWNoX2NoaWxkX29mX25vZGUoKSBhcyBpdCB3
aWxsIGF1dG9tYXRpY2FsbHkgaW5jcmVhc2UgYW5kCj4+ID4+IGRlY3JlYXNlIHRoZSAnY2hpbGQn
Lgo+PiA+PiAKPj4gPj4gRml4ZXM6IDUyMzIzZWY3NTQxNCAoIm5ldDogbWFydmVsbDogcHJlc3Rl
cmE6IGFkZCBwaHlsaW5rIHN1cHBvcnQiKQo+PiA+PiBTaWduZWQtb2ZmLWJ5OiBMaWFuZyBIZSA8
d2luZGhsQDEyNi5jb20+ICAKPj4gPgo+PiA+UGxlYXNlIHJlcG9zdCBhbmQgQ0MgYWxsIHRoZSBh
dXRob3JzIG9mIHRoZSBwYXRjaCB1bmRlciBGaXhlcy4gIAo+PiAKPj4gVGhhbmtzIGZvciB5b3Vy
IHJlcGx5LCBKYWt1Ygo+PiAKPj4gQXMgSSB3YXMgdGhlIG9ubHkgb25lIGF1dGhvciwgeW91IG1l
YW4gZm9sbG93aW5nIHRhZyBmb3JtYXQ6Cj4+IAo+PiAiIgo+PiBGaXhlczogNTIzMjNlZjc1NDE0
ICgibmV0OiBtYXJ2ZWxsOiBwcmVzdGVyYTogYWRkIHBoeWxpbmsgc3VwcG9ydCIpCj4+IENDOiBM
aWFuZyBIZSA8d2luZGhsQDEyNi5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IExpYW5nIEhlIDx3aW5k
aGxAMTI2LmNvbT4KPgo+Tm8sIG5vLCBDQyB0aGUgYXV0aG9ycyBvZiB0aGUgcGF0Y2ggdW5kZXIg
Zml4ZXMsIHdoaWNoIGlzIHRvIHNheSAtCj50aGUgcGF0Y2ggd2hpY2ggaW50cm9kdWNlZCB0aGUg
cHJvYmxlbS4gVGhlIGZpeGVzIHRhZyB5b3UgaGF2ZSBpczoKPgo+Rml4ZXM6IDUyMzIzZWY3NTQx
NCAoIm5ldDogbWFydmVsbDogcHJlc3RlcmE6IGFkZCBwaHlsaW5rIHN1cHBvcnQiKQo+Cj5zbzoK
Pgo+Y29tbWl0IDUyMzIzZWY3NTQxNGQ2MGIxN2Y2ODMwNzY4MzNlYjU1YTZiZmZhMmIKPkF1dGhv
cjogT2xla3NhbmRyIE1henVyIDxvbGVrc2FuZHIubWF6dXJAcGx2aXNpb24uZXU+Cj5EYXRlOiAg
IFR1ZSBKdWwgMTkgMTM6NTc6MTYgMjAyMiArMDMwMAo+Cj4gICAgbmV0OiBtYXJ2ZWxsOiBwcmVz
dGVyYTogYWRkIHBoeWxpbmsgc3VwcG9ydAo+ICAgIAo+ICAgIEZvciBTRlAgcG9ydCBwcmVzdGVy
YSBkcml2ZXIgd2lsbCB1c2Uga2VybmVsCj4gICAgcGh5bGluayBpbmZyYXN0dWN0dXJlIHRvIGNv
bmZpZ3VyZSBwb3J0IG1vZGUgYmFzZWQgb24KPiAgICB0aGUgbW9kdWxlIHRoYXQgaGFzIGJlZWQg
aW5zZXJ0ZWQKPiAgICAKPiAgICBDby1kZXZlbG9wZWQtYnk6IFlldmhlbiBPcmxvdiA8eWV2aGVu
Lm9ybG92QHBsdmlzaW9uLmV1Pgo+ICAgIFNpZ25lZC1vZmYtYnk6IFlldmhlbiBPcmxvdiA8eWV2
aGVuLm9ybG92QHBsdmlzaW9uLmV1Pgo+ICAgIENvLWRldmVsb3BlZC1ieTogVGFyYXMgQ2hvcm55
aSA8dGFyYXMuY2hvcm55aUBwbHZpc2lvbi5ldT4KPiAgICBTaWduZWQtb2ZmLWJ5OiBUYXJhcyBD
aG9ybnlpIDx0YXJhcy5jaG9ybnlpQHBsdmlzaW9uLmV1Pgo+ICAgIFNpZ25lZC1vZmYtYnk6IE9s
ZWtzYW5kciBNYXp1ciA8b2xla3NhbmRyLm1henVyQHBsdmlzaW9uLmV1Pgo+ICAgIFNpZ25lZC1v
ZmYtYnk6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4KPgoKPkkgd2FzIGFz
a2luZyB0byBhbHNvIENDIFlldmhlbiBhbmQgT2xla3NhbmRyLiBUYXJhcyBzZWVtcyBhbHJlYWR5
IENDZWQuCgoKVGhhbmtzIHZlcnkgbXVjaCwgSSB3aWxsIGZvbGxvdyB0aGlzIHJ1bGUgaW4gbXkg
ZnV0dXJlIHBhdGNoZXMuCgpMaWFuZw==
