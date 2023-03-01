Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698BA6A6822
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 08:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCAHbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 02:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCAHbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 02:31:44 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A32D38670;
        Tue, 28 Feb 2023 23:31:39 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id u6so7836852ilk.12;
        Tue, 28 Feb 2023 23:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677655899;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cA9e8/pgl41EFE22L39O9fSD47XJ0DSsdizMlEKntBQ=;
        b=N8zd4uQF1Om8ZyCO7xUdJYqT8UxltYGw3AvczEjCwpj0WzZIZHWw1j1FS5zjiJ0e0R
         Zxuyz1ml/Xnbo1PpYzDUcGeHqlgt7+M+oaqV4MrfJiQsyxUfLHE9RZzxKG3En49vchu7
         lpPHJgTS8TXBBv7gttgZGGcvKgniNwWiluSaKwUHXIIzJ5jyt8nhFbau+w4WOAvQka1G
         NUj1wY793eTwFUIbrEKhHdI3yvr++lIT7TICT/v5yge28CYLWd3v+KGsxmSvu4yJXKLI
         Mmd5q6N+/i2Lygk6txtIYP4oDYnGCtxaiz/WMkr+glHif0uLmmllM7ZUyCY4C6Ivjphw
         MalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677655899;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cA9e8/pgl41EFE22L39O9fSD47XJ0DSsdizMlEKntBQ=;
        b=T8l+ZC0Yz/nF+ZdoW+jCCBxv97r9PC3s/fozU6GONlfC21mdmJ2FZ5PnRE2Z/hZ5QT
         mE29vGlIfM4atjnvUtKnfIsN4Yd3EQmm6+Gb+kuJbk3yjneXLb4ohgHScUTy6lktAZQF
         4OEf9KlV98W4wZO1r6Byd4ToFUFDuKHRBkTI1if+XhX/1cYS7Wtvxcb0VOoXfBj1QnFQ
         biG7Pj0CgZuSYEEizPwtTDp32HMFMq4YDztz3ZhgnU9eoTs+E7CUCg8pjPLka6jMAE+o
         hB6wH6LGxImqZAiscMfk4qbN1wjKeilg9NbIWwNcv6XeNU4LTZabuoFSoxMDZ8CemhnU
         LfoQ==
X-Gm-Message-State: AO0yUKUnFdi6bGztXBgUgyxPESxrjyoIyY/tIr8OtaGEx7nzu+nrF1YM
        ksz1LrHir1IYikhVlXfZsmz0MKhDh9Q2ww==
X-Google-Smtp-Source: AK7set+b1UzIG1sF/QAMlti3+OK/NOFNrDqrd1VrBcqc7Ue2HTA8Kn1UNaWixD/xOat+ZVCED/B9nA==
X-Received: by 2002:a05:6e02:20ee:b0:315:365d:534f with SMTP id q14-20020a056e0220ee00b00315365d534fmr5097938ilv.19.1677655898851;
        Tue, 28 Feb 2023 23:31:38 -0800 (PST)
Received: from ?IPv6:2003:f6:ef05:8700:853c:3ba5:d710:3c1d? (p200300f6ef058700853c3ba5d7103c1d.dip0.t-ipconnect.de. [2003:f6:ef05:8700:853c:3ba5:d710:3c1d])
        by smtp.gmail.com with ESMTPSA id j21-20020a02cc75000000b003aabed37b1bsm3525744jaq.175.2023.02.28.23.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 23:31:38 -0800 (PST)
Message-ID: <8f1b8b57a963d457714e2ea008761f05d8848814.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] net: phy: adin: Add flags to allow disabling of
 fast link down
From:   Nuno =?ISO-8859-1?Q?S=E1?= <noname.nuno@gmail.com>
To:     Ken Sloat <ken.s@variscite.com>
Cc:     pabeni@redhat.com, edumazet@google.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 01 Mar 2023 08:33:32 +0100
In-Reply-To: <20230228184956.2309584-1-ken.s@variscite.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
         <20230228184956.2309584-1-ken.s@variscite.com>
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

T24gVHVlLCAyMDIzLTAyLTI4IGF0IDEzOjQ5IC0wNTAwLCBLZW4gU2xvYXQgd3JvdGU6Cj4gIkVu
aGFuY2VkIExpbmsgRGV0ZWN0aW9uIiBpcyBhbiBBREkgUEhZIGZlYXR1cmUgdGhhdCBhbGxvd3Mg
Zm9yCj4gZWFybGllcgo+IGRldGVjdGlvbiBvZiBsaW5rIGRvd24gaWYgY2VydGFpbiBzaWduYWwg
Y29uZGl0aW9ucyBhcmUgbWV0LiBBbHNvCj4ga25vd24KPiBvbiBvdGhlciBQSFlzIGFzICJGYXN0
IExpbmsgRG93biwiIHRoaXMgZmVhdHVyZSBpcyBmb3IgdGhlIG1vc3QgcGFydAo+IGVuYWJsZWQg
YnkgZGVmYXVsdCBvbiB0aGUgUEhZLiBUaGlzIGlzIG5vdCBzdWl0YWJsZSBmb3IgYWxsCj4gYXBw
bGljYXRpb25zCj4gYW5kIGJyZWFrcyB0aGUgSUVFRSBzdGFuZGFyZCBhcyBleHBsYWluZWQgaW4g
dGhlIEFESSBkYXRhc2hlZXQuCj4gCj4gVG8gZml4IHRoaXMsIGFkZCBvdmVycmlkZSBmbGFncyB0
byBkaXNhYmxlIGZhc3QgbGluayBkb3duIGZvcgo+IDEwMDBCQVNFLVQKPiBhbmQgMTAwQkFTRS1U
WCByZXNwZWN0aXZlbHkgYnkgY2xlYXJpbmcgYW55IHJlbGF0ZWQgZmVhdHVyZSBlbmFibGUKPiBi
aXRzLgo+IAo+IFRoaXMgbmV3IGZlYXR1cmUgd2FzIHRlc3RlZCBvbiBhbiBBRElOMTMwMCBidXQg
YWNjb3JkaW5nIHRvIHRoZQo+IGRhdGFzaGVldCBhcHBsaWVzIGVxdWFsbHkgZm9yIDEwMEJBU0Ut
VFggb24gdGhlIEFESU4xMjAwLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEtlbiBTbG9hdCA8a2VuLnNA
dmFyaXNjaXRlLmNvbT4KPiAtLS0KPiBDaGFuZ2VzIGluIHYyOgo+IMKgLUNoYW5nZSAiRkxEIiBu
b21lbmNsYXR1cmUgdG8gY29tbW9ubHkgdXNlZCAiRmFzdCBMaW5rIERvd24iIHBocmFzZQo+IGlu
Cj4gwqDCoMKgIHNvdXJjZSBjb2RlIGFuZCBiaW5kaW5ncy4gQWxzbyBkb2N1bWVudCB0aGlzIGlu
IHRoZSBjb21taXQKPiBjb21tZW50cy4KPiDCoC1VdGlsaXplIHBoeV9jbGVhcl9iaXRzX21tZCgp
IGluIHJlZ2lzdGVyIGJpdCBvcGVyYXRpb25zLgo+IAo+IMKgZHJpdmVycy9uZXQvcGh5L2FkaW4u
YyB8IDQzCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gwqAx
IGZpbGUgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9waHkvYWRpbi5jIGIvZHJpdmVycy9uZXQvcGh5L2FkaW4uYwo+IGluZGV4IGRhNjUyMTVk
MTliYi4uMGJhYjdlNGQzZTI5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMK
PiArKysgYi9kcml2ZXJzL25ldC9waHkvYWRpbi5jCj4gQEAgLTY5LDYgKzY5LDE1IEBACj4gwqAj
ZGVmaW5lIEFESU4xMzAwX0VFRV9DQVBfUkVHwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAweDgwMDAKPiDCoCNkZWZpbmUgQURJTjEzMDBfRUVFX0FEVl9SRUfCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4ODAwMQo+IMKgI2RlZmluZSBBRElOMTMwMF9F
RUVfTFBBQkxFX1JFR8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoDB4ODAwMgo+ICsjZGVmaW5lIEFESU4xMzAwX0ZMRF9FTl9SRUfCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4OEUyNwo+ICsjZGVmaW5l
wqDCoCBBRElOMTMwMF9GTERfUENTX0VSUl8xMDBfRU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBCSVQoNykKPiArI2RlZmluZcKgwqAgQURJTjEzMDBfRkxEX1BDU19FUlJfMTAw
MF9FTsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBCSVQoNikKPiArI2RlZmluZcKg
wqAgQURJTjEzMDBfRkxEX1NMQ1JfT1VUX1NUVUNLXzEwMF9FTsKgwqDCoEJJVCg1KQo+ICsjZGVm
aW5lwqDCoCBBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RVQ0tfMTAwMF9FTsKgwqBCSVQoNCkKPiAr
I2RlZmluZcKgwqAgQURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDBfRU7CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoEJJVCgzKQo+ICsjZGVmaW5lwqDCoCBBRElOMTMwMF9GTERfU0xDUl9JTl9a
REVUXzEwMDBfRU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBCSVQoMikKPiArI2RlZmluZcKgwqAg
QURJTjEzMDBfRkxEX1NMQ1JfSU5fSU5WTERfMTAwX0VOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
QklUKDEpCj4gKyNkZWZpbmXCoMKgIEFESU4xMzAwX0ZMRF9TTENSX0lOX0lOVkxEXzEwMDBfRU7C
oMKgwqBCSVQoMCkKPiDCoCNkZWZpbmUgQURJTjEzMDBfQ0xPQ0tfU1RPUF9SRUfCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDk0MDAKPiDCoCNkZWZpbmUg
QURJTjEzMDBfTFBJX1dBS0VfRVJSX0NOVF9SRUfCoMKgwqDCoMKgwqDCoMKgwqDCoDB4YTAwMAo+
IMKgCj4gQEAgLTUwOCw2ICs1MTcsMzYgQEAgc3RhdGljIGludCBhZGluX2NvbmZpZ19jbGtfb3V0
KHN0cnVjdCBwaHlfZGV2aWNlCj4gKnBoeWRldikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFESU4xMzAwX0dFX0NMS19DRkdfTUFT
Sywgc2VsKTsKPiDCoH0KPiDCoAo+ICtzdGF0aWMgaW50IGFkaW5fZmFzdF9kb3duX2Rpc2FibGUo
c3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikKPiArewo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBk
ZXZpY2UgKmRldiA9ICZwaHlkZXYtPm1kaW8uZGV2Owo+ICvCoMKgwqDCoMKgwqDCoGludCByYzsK
PiArCj4gK8KgwqDCoMKgwqDCoMKgaWYgKGRldmljZV9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LCAi
YWRpLGRpc2FibGUtZmFzdC1kb3duLQo+IDEwMDBiYXNlLXQiKSkgewo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqByYyA9IHBoeV9jbGVhcl9iaXRzX21tZChwaHlkZXYsIE1ESU9fTU1E
X1ZFTkQxLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBBRElOMTMwMF9GTERfRU5fUkVHLAo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IEFESU4xMzAwX0ZMRF9QQ1NfRVJSXzEwMDBfRU4g
fAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IEFESU4xMzAwX0ZMRF9TTENSX09VVF9TVFVD
S18xMDAwX0VOIHwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAKPiBBRElOMTMwMF9GTERfU0xD
Ul9JTl9aREVUXzEwMDBfRU4gfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IEFESU4xMzAw
X0ZMRF9TTENSX0lOX0lOVkxEXzEwMDBfRU4pOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAocmMgPCAwKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIHJjOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gK8KgwqDCoMKgwqDC
oMKgaWYgKGRldmljZV9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LCAiYWRpLGRpc2FibGUtZmFzdC1k
b3duLQo+IDEwMGJhc2UtdHgiKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBw
aHlfY2xlYXJfYml0c19tbWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMSwKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgQURJTjEzMDBfRkxEX0VOX1JFRywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgQURJTjEzMDBfRkxEX1BDU19FUlJfMTAwX0VOCj4gfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoAo+IEFESU4xMzAwX0ZMRF9TTENSX09VVF9TVFVDS18xMDBfRU4gfAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoAo+IEFESU4xMzAwX0ZMRF9TTENSX0lOX1pERVRfMTAwX0VOIHwKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAKPiBBRElOMTMwMF9GTERfU0xDUl9JTl9JTlZMRF8xMDBfRU4p
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocmMgPCAwKQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+ICvCoMKg
wqDCoMKgwqDCoH0KClRoaXMgaXMgbm90IGV4YWN0bHkgd2hhdCBJIGhhZCBpbiBtaW5kLi4uIEkg
d2FzIHN1Z2dlc3Rpbmcgc29tZXRoaW5nCmxpa2UgY2FjaGluZyB0aGUgY29tcGxldGUgImJpdHMg
d29yZCIgaW4gYm90aCBvZiB5b3VyIGlmKCkgc3RhdGVtZW50cwphbmQgdGhlbiBqdXN0IGNhbGxp
bmcgcGh5X2NsZWFyX2JpdHNfbW1kKCkgb25jZS4gSWYgSSdtIG5vdCBtaXNzaW5nCnNvbWV0aGlu
ZyBvYnZpb3VzLCBzb21ldGhpbmcgbGlrZSB0aGlzOgoKdTE2IGJpdHMgPSAwOyAvL29yIGFueSBv
dGhlciBuYW1lIG1vcmUgYXBwcm9wcmlhdGUKCmlmIChkZXZpY2VfcHJvcGVydHlfcmVhZF9ib29s
KC4uLikpCgliaXRzID0gQURJTjEzMDBfRkxEX1BDU19FUlJfMTAwMF9FTiB8IC4uLgoKaWYgKGRl
dmljZV9wcm9wZXJ0eV9yZWFkX2Jvb2woKSkKCWJpdHMgfD0gLi4uCgppZiAoIWJpdHMpCglyZXR1
cm4gMDsKCnJldHVybiBwaHlfY2xlYXJfYml0c19tbWQoKTsKCkRvZXMgdGhpcyBzb3VuZCBzYW5l
IHRvIHlvdT8KCkFueXdheXMsIHRoaXMgaXMgYWxzbyBub3QgYSBiaWcgZGVhbC4uLgoKLSBOdW5v
IFPDoQoK

