Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A399C88F0C
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfHKCIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 22:08:17 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:35738 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfHKCIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 22:08:16 -0400
Received: by mail-ed1-f47.google.com with SMTP id w20so100118748edd.2;
        Sat, 10 Aug 2019 19:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=RP1LWzRuajmzKFCHqaSzfx+dlpKjssOccTd/Pg6x94Y=;
        b=pQjStUAk0dXclB0KaZ5iJOIZg/GStMfNwGg/nnbV0Wr22jGRxiYitMBnCG7pRajOli
         cSV1alOcJZo+PSeV/5gjPa2B6ILKlykPwk71yLM1Hm05nY01A1jfJkJTemW3dGZvQPcm
         ofwqKDap4EFyrqQ+DjUhVgWHqULDNNct3W+gRL57gWIBTPZkiPOT/im8t6viMOfFEamr
         ZBUgisBezf7qM7U4KS9r20g0qn9kmCHZ7t0/FBps2W2r8Vs/fW0TDcLCTkzqQ+FMWf6d
         jgbLGRZtDQKpV8jAyLbVstsG9HASAgVnMsVPpF/QUllbQaIKOxuvPQ7ZwJ8hIGd6jye4
         hfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to;
        bh=RP1LWzRuajmzKFCHqaSzfx+dlpKjssOccTd/Pg6x94Y=;
        b=tI/5zxMTfN2op9xKywLmVfaTjUovPnZCcAz9i4HhpuM2dunhGOOrDwB/PC48tXMHtX
         asAZCt102Ki4KiHyPad9ZEAH3xNviFdTfcLYJBN/XTnTHDtUeBubZgz2G144qnxLOTV/
         YVInI4s3Sy7GDxRFOIDbyS6wX1ieDUz+xMGjyUYPsmPeb7Srx42LHnEQ2gMtTUWdVIE6
         jN9x0uPEw34gbZWsjzjQgmFQT4u3XtOi+qYs9+dfVxS+5a3dbNcpssr/kk5MeLcv104T
         0f3rvJjXDd4hNjpdx/cq4FsmycR7km/3f7xxbEO6fkL3eXh8SctImUxXfW3Vxx7EkVS1
         sc2g==
X-Gm-Message-State: APjAAAWG7gU8Se6MswIbubUceCGqP6+LlolgXBnsgFflYY3/7s9AtK9V
        b07YU8+yttv7mkYmiq8pZwKSjNSiatbOqgrcadar/kflFeo=
X-Google-Smtp-Source: APXvYqxexoPqWF5fiyg/W6Z7Mdxv3GsVnhy2+mXXdUwsH61CiLb2bcrPo/hfsa7DE1sdN3yYs5VC0l6oFTW5CFOqewQ=
X-Received: by 2002:a50:de08:: with SMTP id z8mr9025845edk.121.1565489294608;
 Sat, 10 Aug 2019 19:08:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:2001:0:0:0:0 with HTTP; Sat, 10 Aug 2019 19:08:13
 -0700 (PDT)
In-Reply-To: <CABVa4NgWMkJuyB1P5fwQEYHwqBRiySE+fGQpMKt8zbp+xJ8+rw@mail.gmail.com>
References: <CABVa4NgWMkJuyB1P5fwQEYHwqBRiySE+fGQpMKt8zbp+xJ8+rw@mail.gmail.com>
From:   James Nylen <jnylen@gmail.com>
Date:   Sun, 11 Aug 2019 02:08:13 +0000
Message-ID: <CABVa4NhutjvHPbyaxNeVpJjf-RMJdwEX-Yjk4bkqLC1DN3oXPA@mail.gmail.com>
Subject: [PATCH] `iwlist scan` fails with many networks available
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000004e2b98058fcde157"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004e2b98058fcde157
Content-Type: text/plain; charset="UTF-8"

In 5.x it's still possible for `ieee80211_scan_results` (`iwlist
scan`) to fail when too many wireless networks are available.  This
code path is used by `wicd`.

Previously: https://lkml.org/lkml/2017/4/2/192

I've been applying this updated patch to my own kernels since 2017 with
no issues.  I am sure it is not the ideal way to solve this problem, but
I'm making my fix available in case it helps others.

Please advise on next steps or if this is a dead end.

--0000000000004e2b98058fcde157
Content-Type: text/plain; charset="US-ASCII"; name="wireless-scan-less-e2big.diff"
Content-Disposition: attachment; filename="wireless-scan-less-e2big.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

Y29tbWl0IDhlODBkY2IwZGY3MWFjOGY1ZDM2NDBiY2RiMWJiYTljNzY5M2Q2M2EKQXV0aG9yOiBK
YW1lcyBOeWxlbiA8am55bGVuQGdtYWlsLmNvbT4KRGF0ZTogICBXZWQgQXByIDI2IDE0OjM4OjU4
IDIwMTcgKzAyMDAKCiAgICBIYWNrOiBNYWtlIGBpZWVlODAyMTFfc2Nhbl9yZXN1bHRzYCAoYGl3
bGlzdCBzY2FuYCkgcmV0dXJuIGxlc3MgRTJCSUcKICAgIAogICAgU2VlOiBodHRwczovL2xrbWwu
b3JnL2xrbWwvMjAxNy80LzIvMTkyCiAgICAKICAgIChhbmQgYnJhbmNoIGBqY24vaGFjay93aXJl
bGVzcy1zY2FuLW5vLWUyYmlnYCkKICAgIAogICAgVGhpcyBzaG91bGQgcmVhbGx5IGJlIGRvbmUg
d2l0aCBhIGJpZ2dlciBsaW1pdCBpbnNpZGUgdGhlIGBpd2xpc3RgIGNvZGUKICAgIGluc3RlYWQs
IGlmIHBvc3NpYmxlIChvciBldmVuIGJldHRlcjogbW9kaWZ5IGB3aWNkYCB0byB1c2UgYGl3IHNj
YW5gCiAgICBpbnN0ZWFkKS4KCmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3Mvc2Nhbi5jIGIvbmV0
L3dpcmVsZXNzL3NjYW4uYwppbmRleCAyMWJlNTZiMzEyOGUuLjA4ZmE5Y2I2OGY1OSAxMDA2NDQK
LS0tIGEvbmV0L3dpcmVsZXNzL3NjYW4uYworKysgYi9uZXQvd2lyZWxlc3Mvc2Nhbi5jCkBAIC0x
Njk5LDYgKzE2OTksNyBAQCBzdGF0aWMgaW50IGllZWU4MDIxMV9zY2FuX3Jlc3VsdHMoc3RydWN0
IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNlICpyZGV2LAogCQkJCSAgc3RydWN0IGl3X3JlcXVl
c3RfaW5mbyAqaW5mbywKIAkJCQkgIGNoYXIgKmJ1Ziwgc2l6ZV90IGxlbikKIHsKKwljaGFyICpt
YXliZV9jdXJyZW50X2V2OwogCWNoYXIgKmN1cnJlbnRfZXYgPSBidWY7CiAJY2hhciAqZW5kX2J1
ZiA9IGJ1ZiArIGxlbjsKIAlzdHJ1Y3QgY2ZnODAyMTFfaW50ZXJuYWxfYnNzICpic3M7CkBAIC0x
NzA5LDE0ICsxNzEwLDI5IEBAIHN0YXRpYyBpbnQgaWVlZTgwMjExX3NjYW5fcmVzdWx0cyhzdHJ1
Y3QgY2ZnODAyMTFfcmVnaXN0ZXJlZF9kZXZpY2UgKnJkZXYsCiAKIAlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGJzcywgJnJkZXYtPmJzc19saXN0LCBsaXN0KSB7CiAJCWlmIChidWYgKyBsZW4gLSBjdXJy
ZW50X2V2IDw9IElXX0VWX0FERFJfTEVOKSB7Ci0JCQllcnIgPSAtRTJCSUc7CisJCQkvLyBCdWZm
ZXIgdG9vIHNtYWxsIHRvIGhvbGQgYW5vdGhlciBCU1MuICBPbmx5IHJlcG9ydAorCQkJLy8gYW4g
ZXJyb3IgaWYgd2UgaGF2ZSBub3QgeWV0IHJlYWNoZWQgdGhlIG1heGltdW0KKwkJCS8vIGJ1ZmZl
ciBzaXplIHRoYXQgYGl3bGlzdGAgY2FuIGhhbmRsZS4KKwkJCWlmIChsZW4gPCAweEZGRkYpIHsK
KwkJCQllcnIgPSAtRTJCSUc7CisJCQl9CiAJCQlicmVhazsKIAkJfQotCQljdXJyZW50X2V2ID0g
aWVlZTgwMjExX2JzcygmcmRldi0+d2lwaHksIGluZm8sIGJzcywKLQkJCQkJICAgY3VycmVudF9l
diwgZW5kX2J1Zik7Ci0JCWlmIChJU19FUlIoY3VycmVudF9ldikpIHsKLQkJCWVyciA9IFBUUl9F
UlIoY3VycmVudF9ldik7CisJCW1heWJlX2N1cnJlbnRfZXYgPSBpZWVlODAyMTFfYnNzKCZyZGV2
LT53aXBoeSwgaW5mbywgYnNzLAorCQkJCQkgICAgICAgICBjdXJyZW50X2V2LCBlbmRfYnVmKTsK
KwkJaWYgKElTX0VSUihtYXliZV9jdXJyZW50X2V2KSkgeworCQkJZXJyID0gUFRSX0VSUihtYXli
ZV9jdXJyZW50X2V2KTsKKwkJCWlmIChlcnIgPT0gLUUyQklHKSB7CisJCQkJLy8gTGFzdCBCU1Mg
ZmFpbGVkIHRvIGNvcHkgaW50byBidWZmZXIuICBBcworCQkJCS8vIGFib3ZlLCBvbmx5IHJlcG9y
dCBhbiBlcnJvciBpZiBgaXdsaXN0YCB3aWxsCisJCQkJLy8gcmV0cnkgYWdhaW4gd2l0aCBhIGxh
cmdlciBidWZmZXIuCisJCQkJaWYgKGxlbiA+PSAweEZGRkYpIHsKKwkJCQkJZXJyID0gMDsKKwkJ
CQl9CisJCQl9CiAJCQlicmVhazsKKwkJfSBlbHNlIHsKKwkJCWN1cnJlbnRfZXYgPSBtYXliZV9j
dXJyZW50X2V2OwogCQl9CiAJfQogCXNwaW5fdW5sb2NrX2JoKCZyZGV2LT5ic3NfbG9jayk7Cg==
--0000000000004e2b98058fcde157--
