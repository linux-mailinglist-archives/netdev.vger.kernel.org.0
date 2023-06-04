Return-Path: <netdev+bounces-7787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4CC872184A
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 17:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7481F281170
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B47EF9EE;
	Sun,  4 Jun 2023 15:51:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C95CB9
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 15:51:57 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E4FBB;
	Sun,  4 Jun 2023 08:51:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5147dce372eso5825984a12.0;
        Sun, 04 Jun 2023 08:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685893914; x=1688485914;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iFD29ePbRZ0pdc1KN4jdaiARlqeljkPHj9nsxUP+HD4=;
        b=AQq5SsgOkiD+7anVOHgQAhWSSFQzOkbJEmJQVtoC/YpkM1cjygsyScXylDM11wDO0v
         uuXb4MoBITBA2p2O26EDSCslTI6+JsHR7EzVjNjI8DFu+PDNVkC1ZOLGXTaNqGCpmRC+
         eb3Zl3iQpkYqKiRqkraRPDDvI/nUwcMhwHz/ekLmZf154BQebNHJ5bVgKuwP36iu1gNT
         hZPB9Q4R9VX4ri0YFJV1FbNYyA/Lf3nkWGo4slQ2FeOiAxyf9/EBGxseMeArI4NdI/h9
         lKalUhzY+KLBvrx+qOgWBl2MiYoP8PR/QcGQtme7Tv3LxiO8YyaujNJpPc3ef9sFV/X7
         5n/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685893914; x=1688485914;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iFD29ePbRZ0pdc1KN4jdaiARlqeljkPHj9nsxUP+HD4=;
        b=UOAmN407HhoO7wbr25g/8aDRk1kDpae7HGoe1ICWSmt9/+arBsXnykt+VNeFxHn+ij
         jolzY/VqttuSTm01jkAlIC4GmSiJI95yM3gwVaaEwbewPf80bEfi7nVnlJGFVpzESvbD
         hV7EdmHlows5Hd3zs4bVtCphuRGXlrrhrKJnPtTsb1aQW2yEvDcvazbsiiuis8rKLRGB
         oK2GN+UdPGCnf7AJY2FuOVVihulkTpgHMUq4fXLW7UZa/WhTDiqQafQFGiB4zYbB4juj
         MeLeqm9XWV1jzwzbdIkYIKwrjYHcS3GuuQq3iyAn+MJbD8J4yqFQak2+nvb6Zik4+WZY
         sQXw==
X-Gm-Message-State: AC+VfDzj59VMZPcQZMlHLPFzTS/UDOwgOw3VEFzqkh6AKaVB5Zse/u9P
	qhbIO5zBvMA1COUA7zr0eaZdLCdkLLVp8CBR
X-Google-Smtp-Source: ACHHUZ7KvV7Ow2fSp/15iVCocBgV2jLUqozT1UZQPuMSk4PQuiCwvI3F1STwRabLKr2NrSDEYsBaTQ==
X-Received: by 2002:a05:6402:1a38:b0:514:9552:4bf6 with SMTP id be24-20020a0564021a3800b0051495524bf6mr5867193edb.3.1685893913593;
        Sun, 04 Jun 2023 08:51:53 -0700 (PDT)
Received: from giga-mm.home ([2a02:1210:8629:800:82ee:73ff:feb8:99e3])
        by smtp.gmail.com with ESMTPSA id l1-20020a056402028100b00514bcbfd9e0sm2901904edv.46.2023.06.04.08.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 08:51:53 -0700 (PDT)
Message-ID: <56eaf569893c0cd6505b4dc975c4d892f9c96603.camel@gmail.com>
Subject: Re: [PATCH v1 20/43] net: cirrus: add DT support for Cirrus EP93xx
From: Alexander Sverdlin <alexander.sverdlin@gmail.com>
To: Nikita Shubin <nikita.shubin@maquefel.me>, Arnd Bergmann
 <arnd@arndb.de>,  Linus Walleij <linus.walleij@linaro.org>, Hartley Sweeten
 <hsweeten@visionengravers.com>, Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>
Cc: Michael Peters <mpeters@embeddedTS.com>, Kris Bahnsen
 <kris@embeddedTS.com>,  linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,  netdev@vger.kernel.org
Date: Sun, 04 Jun 2023 17:51:52 +0200
In-Reply-To: <20230601054549.10843-2-nikita.shubin@maquefel.me>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
	 <20230601054549.10843-2-nikita.shubin@maquefel.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkhCgpPbiBUaHUsIDIwMjMtMDYtMDEgYXQgMDg6NDUgKzAzMDAsIE5pa2l0YSBTaHViaW4gd3Jv
dGU6Cj4gLSBmaW5kIHJlZ2lzdGVyIHJhbmdlIGZyb20gdGhlIGRldmljZSB0cmVlCj4gLSBnZXQg
ImNvcHlfYWRkciIgZnJvbSB0aGUgZGV2aWNlIHRyZWUKPiAtIGdldCBwaHlfaWQgZnJvbSB0aGUg
ZGV2aWNlIHRyZWUKPiAKPiBTaWduZWQtb2ZmLWJ5OiBOaWtpdGEgU2h1YmluIDxuaWtpdGEuc2h1
YmluQG1hcXVlZmVsLm1lPgoKV29ya3MgZmluZSBvbiBFREI5MzAyCgpUZXN0ZWQtYnk6IEFsZXhh
bmRlciBTdmVyZGxpbiA8YWxleGFuZGVyLnN2ZXJkbGluQGdtYWlsLmNvbT4KCj4gLS0tCj4gCj4g
Tm90ZXM6Cj4gwqDCoMKgIHYwIC0+IHYxOgo+IMKgwqDCoCAKPiDCoMKgwqAgLSBkcm9wcGVkIHBs
YXRmb3JtIGRhdGEgZW50aXJlbHkKPiDCoMKgwqAgLSBkcm9wcGVkIGNvcHlfYWRkcgo+IMKgwqDC
oCAtIHVzZSBwaHktaGFuZGxlIGluc3RlYWQgb2YgdXNpbmcgbm9uLWNvbnZlbnRpb25hbCBwaHkt
aWQKPiAKPiDCoGFyY2gvYXJtL21hY2gtZXA5M3h4L3BsYXRmb3JtLmjCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvbmV0L2V0aGVybmV0L2NpcnJ1cy9lcDkzeHhfZXRoLmMg
fCA2NyArKysrKysrKysrKysrLS0tLS0tLS0tLS0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgMzcgaW5z
ZXJ0aW9ucygrKSwgMzIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21h
Y2gtZXA5M3h4L3BsYXRmb3JtLmggYi9hcmNoL2FybS9tYWNoLWVwOTN4eC9wbGF0Zm9ybS5oCj4g
aW5kZXggNWZiMWI5MTkxMzNmLi4zY2YyMTEzNDkxZDggMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm0v
bWFjaC1lcDkzeHgvcGxhdGZvcm0uaAo+ICsrKyBiL2FyY2gvYXJtL21hY2gtZXA5M3h4L3BsYXRm
b3JtLmgKPiBAQCAtNSw4ICs1LDggQEAKPiDCoAo+IMKgI2lmbmRlZiBfX0FTU0VNQkxZX18KPiDC
oAo+IC0jaW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGF0YS9ldGgtZXA5M3h4Lmg+Cj4gwqAjaW5j
bHVkZSA8bGludXgvcmVib290Lmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kYXRhL2V0
aC1lcDkzeHguaD4KPiDCoAo+IMKgc3RydWN0IGRldmljZTsKPiDCoHN0cnVjdCBpMmNfYm9hcmRf
aW5mbzsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2lycnVzL2VwOTN4eF9l
dGguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NpcnJ1cy9lcDkzeHhfZXRoLmMKPiBpbmRleCA4
NjI3YWIxOWQ0NzAuLjQxMDk2ZDQ4MzBmZiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jaXJydXMvZXA5M3h4X2V0aC5jCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2ly
cnVzL2VwOTN4eF9ldGguYwo+IEBAIC0xNywxMiArMTcsMTEgQEAKPiDCoCNpbmNsdWRlIDxsaW51
eC9pbnRlcnJ1cHQuaD4KPiDCoCNpbmNsdWRlIDxsaW51eC9tb2R1bGVwYXJhbS5oPgo+IMKgI2lu
Y2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPgo+ICsjaW5jbHVkZSA8bGludXgvb2YuaD4K
PiDCoCNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgo+IMKgI2luY2x1ZGUgPGxpbnV4L2lvLmg+Cj4g
wqAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgo+IMKgCj4gLSNpbmNsdWRlIDxsaW51eC9wbGF0Zm9y
bV9kYXRhL2V0aC1lcDkzeHguaD4KPiAtCj4gwqAjZGVmaW5lIERSVl9NT0RVTEVfTkFNRcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgImVwOTN4eC1ldGgiCj4gwqAKPiDCoCNkZWZpbmUg
UlhfUVVFVUVfRU5UUklFU8KgwqDCoMKgwqDCoMKgNjQKPiBAQCAtNzM4LDI1ICs3MzcsNiBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IG5ldF9kZXZpY2Vfb3BzIGVwOTN4eF9uZXRkZXZfb3BzID0gewo+
IMKgwqDCoMKgwqDCoMKgwqAubmRvX3NldF9tYWNfYWRkcmVzc8KgwqDCoMKgPSBldGhfbWFjX2Fk
ZHIsCj4gwqB9Owo+IMKgCj4gLXN0YXRpYyBzdHJ1Y3QgbmV0X2RldmljZSAqZXA5M3h4X2Rldl9h
bGxvYyhzdHJ1Y3QgZXA5M3h4X2V0aF9kYXRhICpkYXRhKQo+IC17Cj4gLcKgwqDCoMKgwqDCoMKg
c3RydWN0IG5ldF9kZXZpY2UgKmRldjsKPiAtCj4gLcKgwqDCoMKgwqDCoMKgZGV2ID0gYWxsb2Nf
ZXRoZXJkZXYoc2l6ZW9mKHN0cnVjdCBlcDkzeHhfcHJpdikpOwo+IC3CoMKgwqDCoMKgwqDCoGlm
IChkZXYgPT0gTlVMTCkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIE5V
TEw7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoGV0aF9od19hZGRyX3NldChkZXYsIGRhdGEtPmRldl9h
ZGRyKTsKPiAtCj4gLcKgwqDCoMKgwqDCoMKgZGV2LT5ldGh0b29sX29wcyA9ICZlcDkzeHhfZXRo
dG9vbF9vcHM7Cj4gLcKgwqDCoMKgwqDCoMKgZGV2LT5uZXRkZXZfb3BzID0gJmVwOTN4eF9uZXRk
ZXZfb3BzOwo+IC0KPiAtwqDCoMKgwqDCoMKgwqBkZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfU0cg
fCBORVRJRl9GX0hXX0NTVU07Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiBkZXY7Cj4gLX0K
PiAtCj4gLQo+IMKgc3RhdGljIGludCBlcDkzeHhfZXRoX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpwZGV2KQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2Owo+IEBAIC03ODgsMjcgKzc2OCw1MSBAQCBzdGF0aWMgaW50IGVwOTN4eF9ldGhfcmVtb3Zl
KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCj4gwqAKPiDCoHN0YXRpYyBpbnQgZXA5M3h4
X2V0aF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQo+IMKgewo+IC3CoMKgwqDC
oMKgwqDCoHN0cnVjdCBlcDkzeHhfZXRoX2RhdGEgKmRhdGE7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0
cnVjdCBuZXRfZGV2aWNlICpkZXY7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBlcDkzeHhfcHJp
diAqZXA7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCByZXNvdXJjZSAqbWVtOwo+ICvCoMKgwqDC
oMKgwqDCoHZvaWQgX19pb21lbSAqYmFzZV9hZGRyOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBk
ZXZpY2Vfbm9kZSAqbnA7Cj4gK8KgwqDCoMKgwqDCoMKgdTMyIHBoeV9pZDsKPiDCoMKgwqDCoMKg
wqDCoMKgaW50IGlycTsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IGVycjsKPiDCoAo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAocGRldiA9PSBOVUxMKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FTk9ERVY7Cj4gLcKgwqDCoMKgwqDCoMKgZGF0YSA9IGRldl9nZXRfcGxhdGRh
dGEoJnBkZXYtPmRldik7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgbWVtID0gcGxhdGZvcm1fZ2V0
X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVNLCAwKTsKPiDCoMKgwqDCoMKgwqDCoMKgaXJx
ID0gcGxhdGZvcm1fZ2V0X2lycShwZGV2LCAwKTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFtZW0g
fHwgaXJxIDwgMCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5Y
SU87Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBkZXYgPSBlcDkzeHhfZGV2X2FsbG9jKGRhdGEpOwo+
ICvCoMKgwqDCoMKgwqDCoGJhc2VfYWRkciA9IGlvcmVtYXAobWVtLT5zdGFydCwgcmVzb3VyY2Vf
c2l6ZShtZW0pKTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoIWJhc2VfYWRkcikgewo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZfZXJyKCZwZGV2LT5kZXYsICJGYWlsZWQgdG8gaW9y
ZW1hcCBldGhlcm5ldCByZWdpc3RlcnNcbiIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gLUVJTzsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDC
oG5wID0gb2ZfcGFyc2VfcGhhbmRsZShwZGV2LT5kZXYub2Zfbm9kZSwgInBoeS1oYW5kbGUiLCAw
KTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoIW5wKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGRldl9lcnIoJnBkZXYtPmRldiwgIlBsZWFzZSBwcm92aWRlIFwicGh5LWhhbmRsZVwi
XG4iKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FTk9ERVY7Cj4g
K8KgwqDCoMKgwqDCoMKgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqBpZiAob2ZfcHJvcGVydHlfcmVh
ZF91MzIobnAsICJyZWciLCAmcGh5X2lkKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBkZXZfZXJyKCZwZGV2LT5kZXYsICJGYWlsZWQgdG8gbG9jYXRlIFwicGh5X2lkXCJcbiIp
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVOT0VOVDsKPiArwqDC
oMKgwqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGRldiA9IGFsbG9jX2V0aGVyZGV2KHNp
emVvZihzdHJ1Y3QgZXA5M3h4X3ByaXYpKTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGRldiA9PSBO
VUxMKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIgPSAtRU5PTUVNOwo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBlcnJfb3V0Owo+IMKgwqDCoMKg
wqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGV0aF9od19hZGRyX3NldChkZXYsIGJhc2Vf
YWRkciArIDB4NTApOwo+ICvCoMKgwqDCoMKgwqDCoGRldi0+ZXRodG9vbF9vcHMgPSAmZXA5M3h4
X2V0aHRvb2xfb3BzOwo+ICvCoMKgwqDCoMKgwqDCoGRldi0+bmV0ZGV2X29wcyA9ICZlcDkzeHhf
bmV0ZGV2X29wczsKPiArwqDCoMKgwqDCoMKgwqBkZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfU0cg
fCBORVRJRl9GX0hXX0NTVU07Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBlcCA9IG5ldGRldl9wcml2
KGRldik7Cj4gwqDCoMKgwqDCoMKgwqDCoGVwLT5kZXYgPSBkZXY7Cj4gwqDCoMKgwqDCoMKgwqDC
oFNFVF9ORVRERVZfREVWKGRldiwgJnBkZXYtPmRldik7Cj4gQEAgLTgyNCwxNSArODI4LDEwIEBA
IHN0YXRpYyBpbnQgZXA5M3h4X2V0aF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBlcnJfb3V0Owo+IMKgwqDC
oMKgwqDCoMKgwqB9Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBlcC0+YmFzZV9hZGRyID0gaW9yZW1h
cChtZW0tPnN0YXJ0LCByZXNvdXJjZV9zaXplKG1lbSkpOwo+IC3CoMKgwqDCoMKgwqDCoGlmIChl
cC0+YmFzZV9hZGRyID09IE5VTEwpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ZGV2X2VycigmcGRldi0+ZGV2LCAiRmFpbGVkIHRvIGlvcmVtYXAgZXRoZXJuZXQgcmVnaXN0ZXJz
XG4iKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyID0gLUVJTzsKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBlcnJfb3V0Owo+IC3CoMKgwqDCoMKgwqDC
oH0KPiArwqDCoMKgwqDCoMKgwqBlcC0+YmFzZV9hZGRyID0gYmFzZV9hZGRyOwo+IMKgwqDCoMKg
wqDCoMKgwqBlcC0+aXJxID0gaXJxOwo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgZXAtPm1paS5waHlf
aWQgPSBkYXRhLT5waHlfaWQ7Cj4gK8KgwqDCoMKgwqDCoMKgZXAtPm1paS5waHlfaWQgPSBwaHlf
aWQ7Cj4gwqDCoMKgwqDCoMKgwqDCoGVwLT5taWkucGh5X2lkX21hc2sgPSAweDFmOwo+IMKgwqDC
oMKgwqDCoMKgwqBlcC0+bWlpLnJlZ19udW1fbWFzayA9IDB4MWY7Cj4gwqDCoMKgwqDCoMKgwqDC
oGVwLT5taWkuZGV2ID0gZGV2Owo+IEBAIC04NTksMTIgKzg1OCwxOCBAQCBzdGF0aWMgaW50IGVw
OTN4eF9ldGhfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKPiDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuIGVycjsKPiDCoH0KPiDCoAo+ICtzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2Rl
dmljZV9pZCBlcDkzeHhfZXRoX29mX2lkc1tdID0gewo+ICvCoMKgwqDCoMKgwqDCoHsgLmNvbXBh
dGlibGUgPSAiY2lycnVzLGVwOTMwMS1ldGgiIH0sCj4gK8KgwqDCoMKgwqDCoMKgeyAvKiBzZW50
aW5lbCAqLyB9Cj4gK307Cj4gK01PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIGVwOTN4eF9ldGhfb2Zf
aWRzKTsKPiDCoAo+IMKgc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgZXA5M3h4X2V0aF9k
cml2ZXIgPSB7Cj4gwqDCoMKgwqDCoMKgwqDCoC5wcm9iZcKgwqDCoMKgwqDCoMKgwqDCoMKgPSBl
cDkzeHhfZXRoX3Byb2JlLAo+IMKgwqDCoMKgwqDCoMKgwqAucmVtb3ZlwqDCoMKgwqDCoMKgwqDC
oMKgPSBlcDkzeHhfZXRoX3JlbW92ZSwKPiDCoMKgwqDCoMKgwqDCoMKgLmRyaXZlcsKgwqDCoMKg
wqDCoMKgwqDCoD0gewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLm5hbWXCoMKg
wqA9ICJlcDkzeHgtZXRoIiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLm9mX21h
dGNoX3RhYmxlID0gZXA5M3h4X2V0aF9vZl9pZHMsCj4gwqDCoMKgwqDCoMKgwqDCoH0sCj4gwqB9
Owo+IMKgCgotLSAKQWxleGFuZGVyIFN2ZXJkbGluLgoK


