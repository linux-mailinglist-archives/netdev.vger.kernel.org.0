Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BCB6A5B52
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjB1PH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjB1PHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:07:55 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABB523C78;
        Tue, 28 Feb 2023 07:07:50 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o12so41259136edb.9;
        Tue, 28 Feb 2023 07:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677596869;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bAIUBO6sU2Api4vh4jybg1xceOQ8zwudqh16aye/jfY=;
        b=PJfKrMPLuja5UnBhAEWEd6qaw1ommQZcDbBisGF0ByOP0LYZkxu9dKfN1qN4GexXOQ
         wj09orCSNUJhei3dqoddDtZnf98qMKa6CgaIr6FOS6fhHtD4BT8CRav6HLXWWYGFCGbh
         Z5Q4eU38ul2A7h0lxghtre/i9AYgwDbirgHrihiBsz30zMf3SvAb6eZEWL9i9g7S5jU4
         qZT3QBu09fN7YAf6nXnIQl8S1bNBwRl9R6qoD1FUg5fyEM9hsdOZhVrIVdGmqKVXAkD/
         jCJhFFF3gVe57XFs5WyypfipO4aC72IfG5WycKp4vsqtYgPbSAM+cSnGuAdjFJBXAKQh
         21tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677596869;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bAIUBO6sU2Api4vh4jybg1xceOQ8zwudqh16aye/jfY=;
        b=a7r/9HD/YsGaidp6OVMoN/S0XkO1Zl8VhG5FCvNyO06ytZHY2N8xImR/YnY7MUBzk8
         zSrhhNEogv0YMsx/KH163ayFM5DiUz0SGZfxi74vEGjGWKUgbCXi/Y/jYKjPWkgWVLk9
         MMf/zjHtctog9NkGdglQ/fTiEBrYn7Nq0rpN1uUfo0JIkPMYoBbypbOIMzfQNecAPmps
         2585Y1yopY6of5D2xUxkr8TwhTFQ8YUyn8d7q88xFcTzT7R+3ohUu4rUPKOErm02fJjp
         nI5jJ5cV5aNRWHr59L44US8wBQLwNeZXJrYkX/fJJdfb3OZylXWYts82DiSZxcRYQpDI
         MaRQ==
X-Gm-Message-State: AO0yUKUn/aFJQKo7YHkACgLfF6Cczai3dOPseyk/g3rpzHsudOkQex6b
        HaqUrZ58SDcfNfF3oGIgFgg=
X-Google-Smtp-Source: AK7set8WO1N2XZImzXu0pjSZn2vmWRNVeEl8kjRrrdADVazq+03FWAd6xhpeRYmg7hQysvuPGqsDnQ==
X-Received: by 2002:aa7:d1c4:0:b0:4af:8436:2f3c with SMTP id g4-20020aa7d1c4000000b004af84362f3cmr3493069edp.30.1677596868670;
        Tue, 28 Feb 2023 07:07:48 -0800 (PST)
Received: from ?IPv6:2003:f6:ef05:8700:853c:3ba5:d710:3c1d? (p200300f6ef058700853c3ba5d7103c1d.dip0.t-ipconnect.de. [2003:f6:ef05:8700:853c:3ba5:d710:3c1d])
        by smtp.gmail.com with ESMTPSA id kq2-20020a170906abc200b008d2683e24c4sm4631157ejb.69.2023.02.28.07.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 07:07:48 -0800 (PST)
Message-ID: <f5920799e6b0b6b5321ca38eb3b28024dc1be81f.camel@gmail.com>
Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
From:   Nuno =?ISO-8859-1?Q?S=E1?= <noname.nuno@gmail.com>
To:     Ken Sloat <ken.s@variscite.com>
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 28 Feb 2023 16:09:44 +0100
In-Reply-To: <20230228144056.2246114-1-ken.s@variscite.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksCgpUaGFua3MgZm9yIHRoZSBwYXRjaCEgU29tZSBjb21tZW50cyBmcm9tIG15IHNpZGUuLi4K
Ck9uIFR1ZSwgMjAyMy0wMi0yOCBhdCAwOTo0MCAtMDUwMCwgS2VuIFNsb2F0IHdyb3RlOgo+IEVu
aGFuY2VkIGxpbmsgZGV0ZWN0aW9uIGlzIGFuIEFESSBQSFkgZmVhdHVyZSB0aGF0IGFsbG93cyBm
b3IgZWFybGllcgo+IGRldGVjdGlvbiBvZiBsaW5rIGRvd24gaWYgY2VydGFpbiBzaWduYWwgY29u
ZGl0aW9ucyBhcmUgbWV0LiBUaGlzCj4gZmVhdHVyZSBpcyBmb3IgdGhlIG1vc3QgcGFydCBlbmFi
bGVkIGJ5IGRlZmF1bHQgb24gdGhlIFBIWS4gVGhpcyBpcwo+IG5vdCBzdWl0YWJsZSBmb3IgYWxs
IGFwcGxpY2F0aW9ucyBhbmQgYnJlYWtzIHRoZSBJRUVFIHN0YW5kYXJkIGFzCj4gZXhwbGFpbmVk
IGluIHRoZSBBREkgZGF0YXNoZWV0Lgo+IAo+IFRvIGZpeCB0aGlzLCBhZGQgb3ZlcnJpZGUgZmxh
Z3MgdG8gZGlzYWJsZSBlbmhhbmNlZCBsaW5rIGRldGVjdGlvbgo+IGZvciAxMDAwQkFTRS1UIGFu
ZCAxMDBCQVNFLVRYIHJlc3BlY3RpdmVseSBieSBjbGVhcmluZyBhbnkgcmVsYXRlZAo+IGZlYXR1
cmUgZW5hYmxlIGJpdHMuCj4gCj4gVGhpcyBuZXcgZmVhdHVyZSB3YXMgdGVzdGVkIG9uIGFuIEFE
SU4xMzAwIGJ1dCBhY2NvcmRpbmcgdG8gdGhlCj4gZGF0YXNoZWV0IGFwcGxpZXMgZXF1YWxseSBm
b3IgMTAwQkFTRS1UWCBvbiB0aGUgQURJTjEyMDAuCj4gCj4gU2lnbmVkLW9mZi1ieTogS2VuIFNs
b2F0IDxrZW4uc0B2YXJpc2NpdGUuY29tPgo+IC0tLQo+IMKgZHJpdmVycy9uZXQvcGh5L2FkaW4u
YyB8IDM4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gwqAxIGZpbGUg
Y2hhbmdlZCwgMzggaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9w
aHkvYWRpbi5jIGIvZHJpdmVycy9uZXQvcGh5L2FkaW4uYwo+IGluZGV4IGRhNjUyMTVkMTliYi4u
ODgwOWYzZTAzNmE0IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMKPiArKysg
Yi9kcml2ZXJzL25ldC9waHkvYWRpbi5jCj4gQEAgLTY5LDYgKzY5LDE1IEBACj4gwqAjZGVmaW5l
IEFESU4xMzAwX0VFRV9DQVBfUkVHwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAweDgwMDAKPiDCoCNkZWZpbmUgQURJTjEzMDBfRUVFX0FEVl9SRUfCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4ODAwMQo+IMKgI2RlZmluZSBBRElOMTMwMF9FRUVfTFBB
QkxFX1JFR8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4
ODAwMgo+ICsjZGVmaW5lIEFESU4xMzAwX0ZMRF9FTl9SRUfCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4OEUyNwo+ICsjZGVmaW5lwqDCoCBB
RElOMTMwMF9GTERfUENTX0VSUl8xMDBfRU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBCSVQoNykKPiArI2RlZmluZcKgwqAgQURJTjEzMDBfRkxEX1BDU19FUlJfMTAwMF9FTsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBCSVQoNikKPiArI2RlZmluZcKgwqAgQURJ
TjEzMDBfRkxEX1NMQ1JfT1VUX1NUVUNLXzEwMF9FTsKgwqDCoEJJVCg1KQo+ICsjZGVmaW5lwqDC
oCBBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RVQ0tfMTAwMF9FTsKgwqBCSVQoNCkKPiArI2RlZmlu
ZcKgwqAgQURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDBfRU7CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoEJJVCgzKQo+ICsjZGVmaW5lwqDCoCBBRElOMTMwMF9GTERfU0xDUl9JTl9aREVUXzEw
MDBfRU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBCSVQoMikKPiArI2RlZmluZcKgwqAgQURJTjEz
MDBfRkxEX1NMQ1JfSU5fSU5WTERfMTAwX0VOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgQklUKDEp
Cj4gKyNkZWZpbmXCoMKgIEFESU4xMzAwX0ZMRF9TTENSX0lOX0lOVkxEXzEwMDBfRU7CoMKgwqBC
SVQoMCkKPiDCoCNkZWZpbmUgQURJTjEzMDBfQ0xPQ0tfU1RPUF9SRUfCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDk0MDAKPiDCoCNkZWZpbmUgQURJTjEz
MDBfTFBJX1dBS0VfRVJSX0NOVF9SRUfCoMKgwqDCoMKgwqDCoMKgwqDCoDB4YTAwMAo+IMKgCj4g
QEAgLTUwOCw2ICs1MTcsMzEgQEAgc3RhdGljIGludCBhZGluX2NvbmZpZ19jbGtfb3V0KHN0cnVj
dCBwaHlfZGV2aWNlCj4gKnBoeWRldikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFESU4xMzAwX0dFX0NMS19DRkdfTUFTSywgc2Vs
KTsKPiDCoH0KPiDCoAo+ICtzdGF0aWMgaW50IGFkaW5fY29uZmlnX2ZsZF9lbihzdHJ1Y3QgcGh5
X2RldmljZSAqcGh5ZGV2KQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqZGV2
ID0gJnBoeWRldi0+bWRpby5kZXY7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IHJlZzsKPiArCj4gK8Kg
wqDCoMKgwqDCoMKgcmVnID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19NTURfVkVORDEsCj4g
QURJTjEzMDBfRkxEX0VOX1JFRyk7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJlZyA8IDApCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZWc7Cj4gKwo+ICvCoMKgwqDCoMKg
wqDCoGlmIChkZXZpY2VfcHJvcGVydHlfcmVhZF9ib29sKGRldiwgImFkaSxkaXNhYmxlLWZsZC0x
MDAwYmFzZS0KPiB0IikpCgoiYWRpLGRpc2FibGUtZmxkLTEwMDBiYXNlLXR4Ij8KCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlZyAmPSB+KEFESU4xMzAwX0ZMRF9QQ1NfRVJSXzEw
MDBfRU4gfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RVQ0tfMTAwMF9FTgo+IHwK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgQURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDAwX0VOIHwKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQURJ
TjEzMDBfRkxEX1NMQ1JfSU5fSU5WTERfMTAwMF9FTik7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlm
IChkZXZpY2VfcHJvcGVydHlfcmVhZF9ib29sKGRldiwgImFkaSxkaXNhYmxlLWZsZC0xMDBiYXNl
LQo+IHR4IikpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlZyAmPSB+KEFESU4x
MzAwX0ZMRF9QQ1NfRVJSXzEwMF9FTiB8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFESU4xMzAwX0ZMRF9TTENSX09VVF9T
VFVDS18xMDBfRU4gfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBBRElOMTMwMF9GTERfU0xDUl9JTl9aREVUXzEwMF9FTiB8
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIEFESU4xMzAwX0ZMRF9TTENSX0lOX0lOVkxEXzEwMF9FTik7Cj4gKwo+ICvCoMKg
wqDCoMKgwqDCoHJldHVybiBwaHlfd3JpdGVfbW1kKHBoeWRldiwgTURJT19NTURfVkVORDEsCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBB
RElOMTMwMF9GTERfRU5fUkVHLCByZWcpOwoKbml0OiBZb3UgY291bGQgdXNlIHBoeV9jbGVhcl9i
aXRzX21tZCgpIHRvIHNpbXBsaWZ5IHRoZSBmdW5jdGlvbiBhIGJpdC4KCgpZb3UgYWxzbyBuZWVk
IHRvIGFkZCB0aGVzZSBuZXcgcHJvcGVydGllcyB0bzoKCkRvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQvYWRpLGFkaW4ueWFtbAoKCi0gTnVubyBTw6EKCg==

