Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B85550363F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiDPLMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiDPLMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:12:40 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0D4AD133;
        Sat, 16 Apr 2022 04:10:05 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id k5so17459324lfg.9;
        Sat, 16 Apr 2022 04:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=WB4+/QFKrNI2ywCG/GzNlM3DCuj5PqjLAYqkAja7LNQ=;
        b=eQFEvZGK1REM/iYJ7t3YApZEf9rPnXCuY8ghxes2VWwUXBKzydLKBWFFPpJuYndvYr
         +e8EhVXML4xiOCJ/wPAIiBa+yKAj8zcLO3hxFcYL/Z4FDl4KQ6uLs8l5v+tAxja33uXS
         APHwJLopceBqaGRLnzuuY9JtoEtrgnkdAxOpRAWB5r1sm0oLkDt2TbHXed5Zm89cekU7
         V9vcj24cw6AsGhsbdjTaPOiSjJi/lLBfzWWhqCNNK6OHm9e3Y2NLunNqDS9xgpyEc0LD
         kEwAKxlwkBIa9sDlgLXW7h9O750B5sy97cm+YRCjQt4fc61vFhcQAX6XNv5jKoDDgo9y
         3sDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=WB4+/QFKrNI2ywCG/GzNlM3DCuj5PqjLAYqkAja7LNQ=;
        b=NMQy74sKvRcKCj2LxHjg+ffm4GUgMwDwmtGBKtct+tNhgoCoqdWe0DSrwG3s6hxGbt
         kBADxOQyh+bDzdfgOaI9VwKeU5QilqdNPBIJ+g+dBKe5ZjQrBUqvB0yxszSQF6sDaq3K
         bUtw0HU0Z7seA3wOSYFNCrhMLVNBi9pAWLnnbs/XM0JN3Q9lmzGohGhC7CF7R/g7AfaM
         CzLV/Z/UlJzEdyYd7mFnogKEIE6rYMlNV0nia16uWKWwaNLwmyAmIj/Wh88fPeWEdZ5e
         6Fd0hCIto2UnxcYr4fmiorZUd9AxogOifdcbtokIkG3mHq4FajRI6Sqfj2yqUj1ZXWKa
         fJag==
X-Gm-Message-State: AOAM532fWAJRQE0+avBgINWLh+C4doI0EesYQj8uuLwkgPgKdPJLMTvG
        JcKZt8QiouX6GNQ8UjtBbNk=
X-Google-Smtp-Source: ABdhPJzay9IdzNfAP4GnLTie2+6uI6ofL7xWiBnDDXbJfZbV05tiRSwdVw4hAl2ShXJQIk7NPz/NbA==
X-Received: by 2002:ac2:5223:0:b0:448:5100:e427 with SMTP id i3-20020ac25223000000b004485100e427mr2150728lfl.87.1650107403960;
        Sat, 16 Apr 2022 04:10:03 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.17])
        by smtp.gmail.com with ESMTPSA id x22-20020a2e9c96000000b0024da6072587sm433287lji.80.2022.04.16.04.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 04:10:03 -0700 (PDT)
Message-ID: <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
Date:   Sat, 16 Apr 2022 14:10:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Content-Language: en-US
To:     David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de, dan.carpenter@oracle.com
References: <20220416074817.571160-1-k.kahurani@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220416074817.571160-1-k.kahurani@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------x70JgzBdQ5jV31EERnjUlnC7"
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------x70JgzBdQ5jV31EERnjUlnC7
Content-Type: multipart/mixed; boundary="------------1qnCSQxy3NKX4amAmcXuvQ5M";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org
Cc: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
 davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com, arnd@arndb.de,
 dan.carpenter@oracle.com
Message-ID: <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220416074817.571160-1-k.kahurani@gmail.com>
In-Reply-To: <20220416074817.571160-1-k.kahurani@gmail.com>

--------------1qnCSQxy3NKX4amAmcXuvQ5M
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgRGF2aWQsDQoNCm9uZSBtb3JlIHNtYWxsIGNvbW1lbnQNCg0KT24gNC8xNi8yMiAxMDo0
OCwgRGF2aWQgS2FodXJhbmkgd3JvdGU6DQo+IFJlYWRzIHRoYXQgYXJlIGxlc3NlciB0aGFu
IHRoZSByZXF1ZXN0ZWQgc2l6ZSBsZWFkIHRvIHVuaW5pdC12YWx1ZSBidWdzLg0KPiBJbiB0
aGlzIHBhcnRpY3VsYXIgY2FzZSBhIHZhcmlhYmxlIHdoaWNoIHdhcyBzdXBwb3NlZCB0byBi
ZSBpbml0aWFsaXplZA0KPiBhZnRlciBhIHJlYWQgaXMgbGVmdCB1bmluaXRpYWxpemVkIGFm
dGVyIGEgcGFydGlhbCByZWFkLg0KPiANCj4gUXVhbGlmeSBzdWNoIHJlYWRzIGFzIGVycm9y
cyBhbmQgaGFuZGxlIHRoZW0gY29ycmVjdGx5IGFuZCB3aGlsZSBhdCBpdA0KPiBjb252ZXJ0
IHRoZSByZWFkZXIgZnVuY3Rpb25zIHRvIHJldHVybiB6ZXJvIG9uIHN1Y2Nlc3MgZm9yIGVh
c2llciBlcnJvcg0KPiBoYW5kbGluZy4NCj4gDQo+IEZpeGVzOiBlMmNhOTBjMjc2ZTEgKCJh
eDg4MTc5XzE3OGE6IEFTSVggQVg4ODE3OV8xNzhBIFVTQiAzLjAvMi4wIHRvDQo+IGdpZ2Fi
aXQgZXRoZXJuZXQgYWRhcHRlciBkcml2ZXIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBL
YWh1cmFuaSA8ay5rYWh1cmFuaUBnbWFpbC5jb20+DQo+IFJlcG9ydGVkLWFuZC10ZXN0ZWQt
Ynk6IHN5emJvdCtkM2RiZGYzMWZiZTlkOGY1ZjMxMUBzeXprYWxsZXIuYXBwc3BvdG1haWwu
Y29tDQo+IC0tLQ0KDQpbY29kZSBzbmlwXQ0KDQo+IEBAIC0xMjk1LDYgKzE0MzksNyBAQCBz
dGF0aWMgaW50IGF4ODgxNzlfbGVkX3NldHRpbmcoc3RydWN0IHVzYm5ldCAqZGV2KQ0KPiAg
IHN0YXRpYyB2b2lkIGF4ODgxNzlfZ2V0X21hY19hZGRyKHN0cnVjdCB1c2JuZXQgKmRldikN
Cj4gICB7DQo+ICAgCXU4IG1hY1tFVEhfQUxFTl07DQo+ICsJaW50IHJldDsNCj4gICANCj4g
ICAJbWVtc2V0KG1hYywgMCwgc2l6ZW9mKG1hYykpOw0KPiAgIA0KPiBAQCAtMTMwMyw4ICsx
NDQ4LDEyIEBAIHN0YXRpYyB2b2lkIGF4ODgxNzlfZ2V0X21hY19hZGRyKHN0cnVjdCB1c2Ju
ZXQgKmRldikNCj4gICAJCW5ldGlmX2RiZyhkZXYsIGlmdXAsIGRldi0+bmV0LA0KPiAgIAkJ
CSAgIk1BQyBhZGRyZXNzIHJlYWQgZnJvbSBkZXZpY2UgdHJlZSIpOw0KPiAgIAl9IGVsc2Ug
ew0KPiAtCQlheDg4MTc5X3JlYWRfY21kKGRldiwgQVhfQUNDRVNTX01BQywgQVhfTk9ERV9J
RCwgRVRIX0FMRU4sDQo+IC0JCQkJIEVUSF9BTEVOLCBtYWMpOw0KPiArCQlyZXQgPSBheDg4
MTc5X3JlYWRfY21kKGRldiwgQVhfQUNDRVNTX01BQywgQVhfTk9ERV9JRCwgRVRIX0FMRU4s
DQo+ICsJCQkJICAgICAgIEVUSF9BTEVOLCBtYWMpOw0KPiArDQo+ICsJCWlmIChyZXQpDQo+
ICsJCQluZXRkZXZfZGJnKGRldi0+bmV0LCAiRmFpbGVkIHRvIHJlYWQgTk9ERV9JRDogJWQi
LCByZXQpOw0KPiArDQo+ICAgCQluZXRpZl9kYmcoZGV2LCBpZnVwLCBkZXYtPm5ldCwNCj4g
ICAJCQkgICJNQUMgYWRkcmVzcyByZWFkIGZyb20gQVNJWCBjaGlwIik7DQo+ICAgCX0NCg0K
DQpUaGlzIG1lc3NhZ2Ugc2VxdWVuY2UgaXMgY29uZnVzaW5nLg0KDQpJbiBjYXNlIG9mIGF4
ODgxNzlfcmVhZF9jbWQoKSBmYWlsdXJlIG1hYyByZWFkIGZyb20gZGV2aWNlIGFjdHVhbGx5
IA0KZmFpbGVkLCBidXQgbWVzc2FnZSBzYXlzLCB0aGF0IGl0IHdhcyBzdWNjZXNzZnVsbHkg
ZmluaXNoZWQuDQoNCg0KDQoNCg0KV2l0aCByZWdhcmRzLA0KUGF2ZWwgU2tyaXBraW4NCg==


--------------1qnCSQxy3NKX4amAmcXuvQ5M--

--------------x70JgzBdQ5jV31EERnjUlnC7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJapAoFAwAAAAAACgkQbk1w61LbBA2d
NQ/+LRLQ+4EWTwl4i14awbRI8pi8zuwIgTzqbsdj2ihlIVPcSLl0cOf/3zZUpgMKWgUsl5JUJolj
+W5JVmpZ5QBmAOUEN46P5waH1wnYOI+cab8hkNGPRNEPbO6tj5kKRAnjBkHEtqyHJaLs9UVEiwp4
RYZV3Zl6I3S8XL3NAMGt/mXwhEUeHHE7RYD0eSxjRnEI3UieSRni6XxrduEguxURLQZCJPTyHkji
ZXinqDnpsF/3zKamcpV9X9AJaVGR71xZP9/6cUh4AguzTC4eOppcb600/vKajzmV4jnS2S/UYIXH
NfLpVkp5uS9RYttqQYz6u1fmMi7Add4Kp554qj603TWyUCBQUwVnYEkMXXWJdByIeAVSDamvPFDg
C/5WumweoSOiRhBsqJ3pA3wKar5C5C+PE8/C3qUfydczCZ0o6K5pUzgaFqz1m85xv9v7k/+iWYyc
9l/CcwdIqnkaGed0DtwOtfQlvmzqW+bTS8Qa6asftjTJ8HC55wj2lQIeWJ9lMBZGwvugtyrJ5vMu
45KVO4CKafRkSYwratiIFgYu8LzEmIzco1Eyj94+KSV1vKvGNew8h4d4uVYriWnTY6F0UjgTbo0A
YzC8IwgCFgpIphdzJIUTvVEs6p+9CSR8+Fg8wbyNVCWSaOTTYRgDE8n/NXSqZv31/xwX+2mf2X5N
TxA=
=bUPz
-----END PGP SIGNATURE-----

--------------x70JgzBdQ5jV31EERnjUlnC7--
