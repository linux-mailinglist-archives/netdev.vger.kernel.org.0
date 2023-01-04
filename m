Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A98365DB86
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbjADRtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239803AbjADRtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:49:14 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B35FD08;
        Wed,  4 Jan 2023 09:49:14 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk9so84271669ejc.3;
        Wed, 04 Jan 2023 09:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bq5T3H7ajPyPQ9vioDE0tfMvtiYQIDdq9hBdspYl9j0=;
        b=CsPmMx+Q8xRhbNWd8KXeVRAKH0EU5k3rTIdnWRqva1tIJPxI1RBQGAz6rUO4ieDl2j
         D/equzfgg+UmrQVjuz1hEl3E03Xc7L6ITI2RtG0vwVboO9oSbcuKtaAVP3cZyqlkCHJ1
         2x97dl5O9lwKK3bUIysfz4OJDOn4OTobQd+bvFagZB/BRKhcEoiBRJ5+9ZAXz6B9FHMw
         289gs0mdZB40AKhClGPTmmG3aSE0MLyuo1nHqSNO/wY5estDyMW0AoB60nKMLfgM6KnJ
         FYI857FWXYCkbICNc4XI0j4agRAAVsiae7BuiQYtCFmlbELjHsNmGY2D3gNf8FCERPav
         wZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bq5T3H7ajPyPQ9vioDE0tfMvtiYQIDdq9hBdspYl9j0=;
        b=j9xj2Kq+zDyAndNUdgboRb1Erlr0/X4Xi59//tco6pFv98mvYiiUgV06Jl09p+DNmB
         w8HoWTV4xOqiaEgVHb0za7znP9tZmk+a+GyGxxl5SK2HQT8rAKlZVwWFsgkw4dzC7Ji2
         vR1oDZD46rj162yvrvTg4X0pKFmVRYX67tM3txfKReQBA4z/OxdCCZANSxzbEIGSYql9
         T95GgIYHepZ5lL3GcAZ9F1LGgG6fZqlhpBlEwE9/eUqlwXVCJCpDSIz6+ugbnJWlWvNX
         PS4Y9fL7Xf9JS3J5Uz/FyDvWpeg9FUKDZf84RG/GRd3w4GQfJ33qysOZZK+GoPAXpAvc
         i6vA==
X-Gm-Message-State: AFqh2kqro2ehjjZDh8Y+kiczGTXHEKBcQwmS8RXb1UxPyEQkJV4P4/FG
        890D7N/Q4vwJYs6ACehYaKocanIViucpvrxEo/A=
X-Google-Smtp-Source: AMrXdXuToPpAs4ZdULVqHtWdd9HVfH4ODJ/5O6IJKp3PSiQVG35IqVIlPTl9GLLWstbDdszTCZHL1e0p2R8lvdEbcqU=
X-Received: by 2002:a17:907:7e9b:b0:7ad:a2e9:a48c with SMTP id
 qb27-20020a1709077e9b00b007ada2e9a48cmr3541600ejc.77.1672854552640; Wed, 04
 Jan 2023 09:49:12 -0800 (PST)
MIME-Version: 1.0
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com> <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
 <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com> <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
 <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
 <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com> <CAFBinCC9sNvQJcu-SOSrFmo4sCx29K6KwXnc-O6MX9TJEHtXYg@mail.gmail.com>
 <662e2f820e7a478096dd6e09725c093a@AcuMS.aculab.com>
In-Reply-To: <662e2f820e7a478096dd6e09725c093a@AcuMS.aculab.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 4 Jan 2023 18:49:01 +0100
Message-ID: <CAFBinCCTa47SRjNHbMB3t2zjiE5Vh1ZQrgT3G38g9g_-mzvh6w@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
To:     David Laight <David.Laight@aculab.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005f1bc105f173cdb2"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005f1bc105f173cdb2
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 4, 2023 at 5:31 PM David Laight <David.Laight@aculab.com> wrote:
[...]
> > > What you may want to do is add compile-time asserts for the
> > > sizes of the structures.
> > Do I get you right that something like:
> >   BUILD_BUG_ON(sizeof(rtw8821c_efuse) != 256);
> > is what you have in mind?
>
> That looks like the one...
I tried this (see the attached patch - it's just meant to show what I
did, it's not meant to be applied upstream).
With the attached patch but no other patches this makes the rtw88
driver compile fine on 6.2-rc2.

Adding __packed to struct rtw8723d_efuse changes the size of that
struct for me (I'm compiling for AArch64 / ARM64).
With the packed attribute it has 267 bytes, without 268 bytes.

Do you have any ideas as to why that is?


Best regards,
Martin

--0000000000005f1bc105f173cdb2
Content-Type: text/x-patch; charset="US-ASCII"; name="add-build-bug-on.patch"
Content-Disposition: attachment; filename="add-build-bug-on.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lchy60110>
X-Attachment-Id: f_lchy60110

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2Qu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2QuYwppbmRleCAy
ZDJmNzY4YmFlMmUuLjQ3MzkyZDcyMmY4ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnR3ODgvcnR3ODcyM2QuYwpAQCAtMjIyLDYgKzIyMiw4IEBAIHN0YXRpYyBpbnQgcnR3
ODcyM2RfcmVhZF9lZnVzZShzdHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LCB1OCAqbG9nX21hcCkKIAlz
dHJ1Y3QgcnR3ODcyM2RfZWZ1c2UgKm1hcDsKIAlpbnQgaTsKIAorCUJVSUxEX0JVR19PTihzaXpl
b2YoKm1hcCkgIT0gMjY4KTsKKwogCW1hcCA9IChzdHJ1Y3QgcnR3ODcyM2RfZWZ1c2UgKilsb2df
bWFwOwogCiAJZWZ1c2UtPnJmZV9vcHRpb24gPSAwOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIxYy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OC9ydHc4ODIxYy5jCmluZGV4IDE3ZjgwMGY2ZWZiZC4uZWUwZjRhMDg1NmQ1
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjFj
LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIxYy5jCkBA
IC00NSw2ICs0NSw4IEBAIHN0YXRpYyBpbnQgcnR3ODgyMWNfcmVhZF9lZnVzZShzdHJ1Y3QgcnR3
X2RldiAqcnR3ZGV2LCB1OCAqbG9nX21hcCkKIAlzdHJ1Y3QgcnR3ODgyMWNfZWZ1c2UgKm1hcDsK
IAlpbnQgaTsKIAorCUJVSUxEX0JVR19PTihzaXplb2YoKm1hcCkgIT0gNTEyKTsKKwogCW1hcCA9
IChzdHJ1Y3QgcnR3ODgyMWNfZWZ1c2UgKilsb2dfbWFwOwogCiAJZWZ1c2UtPnJmZV9vcHRpb24g
PSBtYXAtPnJmZV9vcHRpb247CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0dzg4L3J0dzg4MjJiLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4
L3J0dzg4MjJiLmMKaW5kZXggNzRkZmI4OWIyYzk0Li4wZGViMDI5MjQxMTQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmIuYworKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJiLmMKQEAgLTM4LDYgKzM4LDgg
QEAgc3RhdGljIGludCBydHc4ODIyYl9yZWFkX2VmdXNlKHN0cnVjdCBydHdfZGV2ICpydHdkZXYs
IHU4ICpsb2dfbWFwKQogCXN0cnVjdCBydHc4ODIyYl9lZnVzZSAqbWFwOwogCWludCBpOwogCisJ
QlVJTERfQlVHX09OKHNpemVvZigqbWFwKSAhPSA1MTIpOworCiAJbWFwID0gKHN0cnVjdCBydHc4
ODIyYl9lZnVzZSAqKWxvZ19tYXA7CiAKIAllZnVzZS0+cmZlX29wdGlvbiA9IG1hcC0+cmZlX29w
dGlvbjsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3
ODgyMmMuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmMuYwpp
bmRleCA5NjRlMjc4ODdmZTIuLjk4MGM1MDIwNmMyMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyYy5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmMuYwpAQCAtNDEsNiArNDEsOCBAQCBzdGF0aWMgaW50
IHJ0dzg4MjJjX3JlYWRfZWZ1c2Uoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwgdTggKmxvZ19tYXAp
CiAJc3RydWN0IHJ0dzg4MjJjX2VmdXNlICptYXA7CiAJaW50IGk7CiAKKwlCVUlMRF9CVUdfT04o
c2l6ZW9mKCptYXApICE9IDQxMCk7CisKIAltYXAgPSAoc3RydWN0IHJ0dzg4MjJjX2VmdXNlICop
bG9nX21hcDsKIAogCWVmdXNlLT5yZmVfb3B0aW9uID0gbWFwLT5yZmVfb3B0aW9uOwo=
--0000000000005f1bc105f173cdb2--
