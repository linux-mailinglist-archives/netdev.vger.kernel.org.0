Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F52257DB4
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgHaPkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgHaPkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:40:05 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90CDC061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:40:05 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id q19so6312626qtp.0
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc:content-transfer-encoding;
        bh=RQc4Gs8J/BBaaNWki/LzPLoPNRQPIMBktg43/BOIc6c=;
        b=K2JOWsHrTvM49drsZ/+zbvutbvLOe58gPbLjsugL7glKmq/OlNbQHzCIjqDyd5v8dt
         +LfvBbu2nt0p75fvY+Q83x8o0hcDdEl5dVq5ijXtPrdIzHOdBwBYPXxhdPS2wp5hwnod
         LuWtoNjZMYVMOfWags2o94HPjIljPpetfQZj/7OKYxUz3lwClHYEEwwHI/NH6KlccVKc
         0sIajgXblSFYbcc5WmGEoXkFj14Kw8BBkOjQoiKDZcw1kzL8wuFeSSzLlt2zz/XEEhIl
         oLe9enHSMVOoke63PDxoCrLAHGGUAgXItbH47fe9WKqmrGT1nIQoguJwZX/8I+oRfHG7
         9kEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=RQc4Gs8J/BBaaNWki/LzPLoPNRQPIMBktg43/BOIc6c=;
        b=LsbCx1/xJ3fR1VJtQgmMVrv8SuPXGNL+az7VehoUP81YWOISQQwpScdgdJRi8mxVRM
         g8oUb+vk/EYWfLYmUkU52I4ao83lmJYAbJwwUTc3Pv6tFP/0S5atVVPtor14eRwEkuiB
         DCADJzQYSyvQpSDSxYqgSGoPCTD2zUJPI2j7PBlxSVqvb7chhIA/UY6qKSWX0tWgs24i
         aXh3C/pVCxdz3hKr4bwg9Qw6nyrj0y6TyFg5EAMW54uofYwV4PmXPd/FvtqfJVkCRZUW
         XJjSZ0pGIao0TV9Dd6fVOuEwfmmysfvTr4SoRqnqEQ6ek3nc8gzA3PI475zrqWj1juza
         uDXg==
X-Gm-Message-State: AOAM532wrQiDyXFQr9I/FY8PTcYxu2ABUtkuVCfHmF1kr2HqQCpTe85b
        W86PYHEiIRFzIh/acLG9x5hqjjo=
X-Google-Smtp-Source: ABdhPJy1aF1NnWBJMtyGyCGlP3UckuV+Pr3gioDY7uAWMnJ3esFkXN/9GH2DA4YvFhR31RWQgcwQlwc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:1742:: with SMTP id
 dc2mr1606574qvb.90.1598888402770; Mon, 31 Aug 2020 08:40:02 -0700 (PDT)
Date:   Mon, 31 Aug 2020 08:40:01 -0700
In-Reply-To: <874koma34d.fsf@toke.dk>
Message-Id: <20200831154001.GC48607@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-5-sdf@google.com>
 <874koma34d.fsf@toke.dk>
Subject: Re: [PATCH bpf-next v3 4/8] libbpf: implement bpf_prog_find_metadata
From:   sdf@google.com
To:     "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDgvMjgsIFRva2UgSO+/vWlsYW5kLUrvv71yZ2Vuc2VuIHdyb3RlOg0KPiBTdGFuaXNsYXYg
Rm9taWNoZXYgPHNkZkBnb29nbGUuY29tPiB3cml0ZXM6DQoNCj4gPiBUaGlzIGlzIGEgbG93LWxl
dmVsIGZ1bmN0aW9uIChoZW5jZSBpbiBicGYuYykgdG8gZmluZCBvdXQgdGhlIG1ldGFkYXRhDQo+
ID4gbWFwIGlkIGZvciB0aGUgcHJvdmlkZWQgcHJvZ3JhbSBmZC4NCj4gPiBJdCB3aWxsIGJlIHVz
ZWQgaW4gdGhlIG5leHQgY29tbWl0cyBmcm9tIGJwZnRvb2wuDQo+ID4NCj4gPiBDYzogVG9rZSBI
77+9aWxhbmQtSu+/vXJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCj4gPiBDYzogWWlGZWkgWmh1
IDx6aHV5aWZlaTE5OTlAZ21haWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBG
b21pY2hldiA8c2RmQGdvb2dsZS5jb20+DQo+ID4gLS0tDQo+ID4gIHRvb2xzL2xpYi9icGYvYnBm
LmMgICAgICB8IDc0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4g
PiAgdG9vbHMvbGliL2JwZi9icGYuaCAgICAgIHwgIDEgKw0KPiA+ICB0b29scy9saWIvYnBmL2xp
YmJwZi5tYXAgfCAgMSArDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgNzYgaW5zZXJ0aW9ucygrKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvYnBmLmMgYi90b29scy9saWIvYnBm
L2JwZi5jDQo+ID4gaW5kZXggNWY2YzU2NzZjYzQ1Li4wMWMwZWRlMTYyNWQgMTAwNjQ0DQo+ID4g
LS0tIGEvdG9vbHMvbGliL2JwZi9icGYuYw0KPiA+ICsrKyBiL3Rvb2xzL2xpYi9icGYvYnBmLmMN
Cj4gPiBAQCAtODg1LDMgKzg4NSw3NyBAQCBpbnQgYnBmX3Byb2dfYmluZF9tYXAoaW50IHByb2df
ZmQsIGludCBtYXBfZmQsDQo+ID4NCj4gPiAgCXJldHVybiBzeXNfYnBmKEJQRl9QUk9HX0JJTkRf
TUFQLCAmYXR0ciwgc2l6ZW9mKGF0dHIpKTsNCj4gPiAgfQ0KPiA+ICsNCj4gPiAraW50IGJwZl9w
cm9nX2ZpbmRfbWV0YWRhdGEoaW50IHByb2dfZmQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBicGZf
cHJvZ19pbmZvIHByb2dfaW5mbyA9IHt9Ow0KPiA+ICsJc3RydWN0IGJwZl9tYXBfaW5mbyBtYXBf
aW5mbzsNCj4gPiArCV9fdTMyIHByb2dfaW5mb19sZW47DQo+ID4gKwlfX3UzMiBtYXBfaW5mb19s
ZW47DQo+ID4gKwlpbnQgc2F2ZWRfZXJybm87DQo+ID4gKwlfX3UzMiAqbWFwX2lkczsNCj4gPiAr
CWludCBucl9tYXBzOw0KPiA+ICsJaW50IG1hcF9mZDsNCj4gPiArCWludCByZXQ7DQo+ID4gKwlp
bnQgaTsNCj4gPiArDQo+ID4gKwlwcm9nX2luZm9fbGVuID0gc2l6ZW9mKHByb2dfaW5mbyk7DQo+
ID4gKw0KPiA+ICsJcmV0ID0gYnBmX29ial9nZXRfaW5mb19ieV9mZChwcm9nX2ZkLCAmcHJvZ19p
bmZvLCAmcHJvZ19pbmZvX2xlbik7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7
DQo+ID4gKw0KPiA+ICsJaWYgKCFwcm9nX2luZm8ubnJfbWFwX2lkcykNCj4gPiArCQlyZXR1cm4g
LTE7DQo+ID4gKw0KPiA+ICsJbWFwX2lkcyA9IGNhbGxvYyhwcm9nX2luZm8ubnJfbWFwX2lkcywg
c2l6ZW9mKF9fdTMyKSk7DQo+ID4gKwlpZiAoIW1hcF9pZHMpDQo+ID4gKwkJcmV0dXJuIC0xOw0K
PiA+ICsNCj4gPiArCW5yX21hcHMgPSBwcm9nX2luZm8ubnJfbWFwX2lkczsNCj4gPiArCW1lbXNl
dCgmcHJvZ19pbmZvLCAwLCBzaXplb2YocHJvZ19pbmZvKSk7DQo+ID4gKwlwcm9nX2luZm8ubnJf
bWFwX2lkcyA9IG5yX21hcHM7DQo+ID4gKwlwcm9nX2luZm8ubWFwX2lkcyA9IHB0cl90b191NjQo
bWFwX2lkcyk7DQo+ID4gKwlwcm9nX2luZm9fbGVuID0gc2l6ZW9mKHByb2dfaW5mbyk7DQo+ID4g
Kw0KPiA+ICsJcmV0ID0gYnBmX29ial9nZXRfaW5mb19ieV9mZChwcm9nX2ZkLCAmcHJvZ19pbmZv
LCAmcHJvZ19pbmZvX2xlbik7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCWdvdG8gZnJlZV9tYXBf
aWRzOw0KPiA+ICsNCj4gPiArCXJldCA9IC0xOw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IHByb2df
aW5mby5ucl9tYXBfaWRzOyBpKyspIHsNCj4gPiArCQltYXBfZmQgPSBicGZfbWFwX2dldF9mZF9i
eV9pZChtYXBfaWRzW2ldKTsNCj4gPiArCQlpZiAobWFwX2ZkIDwgMCkgew0KPiA+ICsJCQlyZXQg
PSAtMTsNCj4gPiArCQkJZ290byBmcmVlX21hcF9pZHM7DQo+ID4gKwkJfQ0KPiA+ICsNCj4gPiAr
CQltZW1zZXQoJm1hcF9pbmZvLCAwLCBzaXplb2YobWFwX2luZm8pKTsNCj4gPiArCQltYXBfaW5m
b19sZW4gPSBzaXplb2YobWFwX2luZm8pOw0KPiA+ICsJCXJldCA9IGJwZl9vYmpfZ2V0X2luZm9f
YnlfZmQobWFwX2ZkLCAmbWFwX2luZm8sICZtYXBfaW5mb19sZW4pOw0KPiA+ICsJCXNhdmVkX2Vy
cm5vID0gZXJybm87DQo+ID4gKwkJY2xvc2UobWFwX2ZkKTsNCj4gPiArCQllcnJubyA9IHNhdmVk
X2Vycm5vOw0KPiA+ICsJCWlmIChyZXQpDQo+ID4gKwkJCWdvdG8gZnJlZV9tYXBfaWRzOw0KDQo+
IElmIHlvdSBnZXQgdG8gdGhpcyBwb2ludCBvbiB0aGUgbGFzdCBlbnRyeSBpbiB0aGUgbG9vcCwg
cmV0IHdpbGwgYmUgMCwNCj4gYW5kIGFueSBvZiB0aGUgY29udGludWUgc3RhdGVtZW50cyBiZWxv
dyB3aWxsIGVuZCB0aGUgbG9vcCwgY2F1c2luZyB0aGUNCj4gd2hvbGUgZnVuY3Rpb24gdG8gcmV0
dXJuIDAuIFdoaWxlIHRoaXMgaXMgbm90IHRlY2huaWNhbGx5IGEgdmFsaWQgSUQsIGl0DQo+IHN0
aWxsIHNlZW1zIG9kZCB0aGF0IHRoZSBmdW5jdGlvbiByZXR1cm5zIC0xIG9uIGFsbCBlcnJvciBj
b25kaXRpb25zDQo+IGV4Y2VwdCB0aGlzIG9uZS4NCg0KPiBBbHNvLCBpdCB3b3VsZCBiZSBnb29k
IHRvIGJlIGFibGUgdG8gdW5hbWJpZ3VvdXNseSBkaXN0aW5ndWlzaCBiZXR3ZWVuDQo+ICJ0aGlz
IHByb2dyYW0gaGFzIG5vIG1ldGFkYXRhIGFzc29jaWF0ZWQiIGFuZCAic29tZXRoaW5nIHdlbnQg
d3JvbmcNCj4gd2hpbGUgcXVlcnlpbmcgdGhlIGtlcm5lbCBmb3IgbWV0YWRhdGEgKGUuZy4sIHBl
cm1pc3Npb24gZXJyb3IpIi4gU28NCj4gc29tZXRoaW5nIHRoYXQgYW1vdW50cyB0byBhIC1FTk9F
TlQgcmV0dXJuOyBJIGd1ZXNzIHR1cm5pbmcgYWxsIHJldHVybg0KPiB2YWx1ZXMgaW50byBuZWdh
dGl2ZSBlcnJvciBjb2RlcyB3b3VsZCBkbyB0aGF0IChhbmQgYWxzbyBkbyBhd2F5IHdpdGgNCj4g
dGhlIG5lZWQgZm9yIHRoZSBzYXZlZF9lcnJubyBkYW5jZSBhYm92ZSksIGJ1dCBpZCBkb2VzIGNs
YXNoIGEgYml0IHdpdGgNCj4gdGhlIGNvbnZlbnRpb24gaW4gdGhlIHJlc3Qgb2YgdGhlIGZpbGUg
KHdoZXJlIGFsbCB0aGUgb3RoZXIgZnVuY3Rpb25zDQo+IGp1c3QgcmV0dXJuIC0xIGFuZCBzZXQg
ZXJybm8pLi4uDQpHb29kIHBvaW50LiBJIHRoaW5rIEkgY2FuIGNoYW5nZSB0aGUgZnVuY3Rpb24g
c2lnbmF0dXJlIHRvOg0KDQoJaW50IGJwZl9wcm9nX2ZpbmRfbWV0YWRhdGEoaW50IHByb2dfZmQs
IGludCAqbWFwX2lkKQ0KDQpBbmQgZXhwbGljaXRseSByZXR1cm4gbWFwX2lkIHZpYSBhcmd1bWVu
dC4gVGhlbiB0aGUgcmV0IGNhbiBiZSB1c2VkIGFzDQotMS8wIGVycm9yIGFuZCBJIGNhbiBzZXQg
ZXJybm8gYXBwcm9wcmlhdGVseSB3aGVyZSBpdCBtYWtlcyBzZW5zZS4NClRoaXMgd2lsbCBiZXR0
ZXIgbWF0Y2ggdGhlIGNvbnZlbnRpb24gd2UgaGF2ZSBpbiB0aGlzIGZpbGUuDQoNCldpbGwgcmVz
cGluIHY0IGxhdGVyIHRoaXMgd2VlayB0byBnaXZlIHBlb3BsZSBvcHBvcnR1bml0eSB0byBsb29r
IGF0IHRoZQ0Kb3RoZXIgcGF0Y2hlcyBpbiB0aGUgc2VyaWVzLiBUaGFua3MhDQo=
