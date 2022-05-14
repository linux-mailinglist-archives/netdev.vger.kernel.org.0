Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45C952732A
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 18:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiENQvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 12:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiENQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 12:51:18 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A88E65DF;
        Sat, 14 May 2022 09:51:17 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id d19so19350027lfj.4;
        Sat, 14 May 2022 09:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=pS1wtzs1IwDDz2mD9jlYi8ZaLWHZtdCebfHrT1hZXBo=;
        b=OfAgFgrL+gGwZNOmkEHt31hAez5ZveQYLav4JgJ7tWsKIRdYPiypkwXpHCnzbKV9f0
         LBaFX7a5KwBDW+gXtcAqMXXLPLmb8G54IA125cVr5AdCJEHvbxYQ3RALtYgik9e90Svv
         qDDPlLnlftQanfSsJ62ZfCDnlBX37z5KNPmPx7GXjxOyCJDsXRPig7FUudup6FlmcGVg
         RkXq7NgU+INdXeICViOC8AqqUbCEPoCMsuozzxlSPL+KLoGVd+AtBkzX5s6pRv1ydYma
         otllMj6zNzfJN/wvwEooGj6O9seN2ww28ouKpxBdEZ54t/QMdv+7c+9pjIq1M9HF2BJd
         glew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=pS1wtzs1IwDDz2mD9jlYi8ZaLWHZtdCebfHrT1hZXBo=;
        b=yA4SxuzWsbGQmvahWgfChjo4vlWF+o4b8uXHq7xnmQ2ruRkBIcORm/5DeN4jNDdUXm
         GNycJ44+Vl4mokzx3mfy83DyrYZD7UrTSDGCfwnAlTKARLXJtXgJ6+1oUNFc0dOecRYv
         yohvhm2gO3MceUYZrdJyT3pONEEGlKYaMaZz3TMyT2urAgGvdq9MgnKAj+Y+/X0TyhnV
         kS1j6nmgCAguFgV0Vc3I4iJLtGqtpWx2Tdw31Y4LnE1VLJas9PMKOvPboU/GIpK/rk0n
         OI+CAtRgIErleOjYMAinKrkCiEHZE966Ptg3z51n3kd8XkqBt22vPwO/uQ8pBouw5JIn
         VW8w==
X-Gm-Message-State: AOAM5331zyVrwdiCzBVKPKNwg1SJ5LPNHx+3j4hlwZ+rb9oxGWLmFk+x
        +6u+ujdpXHga/WDUFTNWBeA=
X-Google-Smtp-Source: ABdhPJznPOMZRHAkML7VWPie0XfpP1Fe/NYk1Tpritfm+qrnp71p9+LpOkAGvUwIRNktdBlyQ6HLqw==
X-Received: by 2002:a19:914b:0:b0:472:10c:84ae with SMTP id y11-20020a19914b000000b00472010c84aemr7030255lfj.572.1652547075248;
        Sat, 14 May 2022 09:51:15 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.216])
        by smtp.gmail.com with ESMTPSA id v5-20020ac25925000000b0047255d211a2sm756385lfi.209.2022.05.14.09.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 09:51:14 -0700 (PDT)
Message-ID: <ebf3adc8-3e33-7ef3-e74d-29a32640972f@gmail.com>
Date:   Sat, 14 May 2022 19:51:12 +0300
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
References: <20220514133234.33796-1-k.kahurani@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220514133234.33796-1-k.kahurani@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0cILCLmmlWJTpGId7T5QmWPf"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0cILCLmmlWJTpGId7T5QmWPf
Content-Type: multipart/mixed; boundary="------------0P0tWxYVtMRXZyKgCjwtnX00";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org
Cc: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
 davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com, arnd@arndb.de,
 dan.carpenter@oracle.com
Message-ID: <ebf3adc8-3e33-7ef3-e74d-29a32640972f@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220514133234.33796-1-k.kahurani@gmail.com>
In-Reply-To: <20220514133234.33796-1-k.kahurani@gmail.com>

--------------0P0tWxYVtMRXZyKgCjwtnX00
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgRGF2aWQsDQoNCk9uIDUvMTQvMjIgMTY6MzIsIERhdmlkIEthaHVyYW5pIHdyb3RlOg0K
PiBSZWFkcyB0aGF0IGFyZSBsZXNzZXIgdGhhbiB0aGUgcmVxdWVzdGVkIHNpemUgbGVhZCB0
byB1bmluaXQtdmFsdWUgYnVncy4NCj4gSW4gdGhpcyBwYXJ0aWN1bGFyIGNhc2UgYSB2YXJp
YWJsZSB3aGljaCB3YXMgc3VwcG9zZWQgdG8gYmUgaW5pdGlhbGl6ZWQNCj4gYWZ0ZXIgYSBy
ZWFkIGlzIGxlZnQgdW5pbml0aWFsaXplZCBhZnRlciBhIHBhcnRpYWwgcmVhZC4NCj4gDQo+
IFF1YWxpZnkgc3VjaCByZWFkcyBhcyBlcnJvcnMgYW5kIGhhbmRsZSB0aGVtIGNvcnJlY3Rs
eSBhbmQgd2hpbGUgYXQgaXQNCj4gY29udmVydCB0aGUgcmVhZGVyIGZ1bmN0aW9ucyB0byBy
ZXR1cm4gemVybyBvbiBzdWNjZXNzIGZvciBlYXNpZXIgZXJyb3INCj4gaGFuZGxpbmcuDQo+
IA0KPiBGaXhlczogZTJjYTkwYzI3NmUxICgiYXg4ODE3OV8xNzhhOiBBU0lYIEFYODgxNzlf
MTc4QSBVU0IgMy4wLzIuMCB0byBnaWdhYml0IGV0aGVybmV0IGFkYXB0ZXIgZHJpdmVyIikN
Cj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgS2FodXJhbmkgPGsua2FodXJhbmlAZ21haWwuY29t
Pg0KPiBSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBzeXpib3QrZDNkYmRmMzFmYmU5ZDhmNWYz
MTFAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPiAtLS0NCg0KPC0tLSBoZXJlICgqKQ0K
DQo+ICAgZHJpdmVycy9uZXQvdXNiL2F4ODgxNzlfMTc4YS5jIHwgMjgxICsrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyMjcgaW5zZXJ0
aW9ucygrKSwgNTQgZGVsZXRpb25zKC0pDQo+IA0KDQpJIGRvbid0IHNlZSBhbnkgZXJyb3Ig
aW4gdGhhdCBwYXRjaCwgYnV0IEkgaGFkIHRvIGZpbmQgcHJldmlvdXMgdmVyc2lvbnMgDQpv
ZiB0aGF0IHBhdGNoIGluIG15IGluYm94Lg0KDQpVc3VhbGx5IG5ldyB2ZXJzaW9ucyBvZiBz
aW5nbGUgcGF0Y2hlcyBhcmUgbGlua2VkIGluIG9uZSB0aHJlYWQgYW5kIGhhdmUgDQphIHZl
cnNpb24gbnVtYmVyIGluIGEgdGl0bGUuIFlvdSBjYW4gZ2VuZXJhdGUgcGF0Y2ggd2l0aCB2
ZXJzaW9uIHVzaW5nIA0KLXYgb3B0aW9uIG9mIGdpdCBmb3JtYXQtcGF0Y2ggbGlrZToNCg0K
JCBnaXQgZm9ybWF0LXBhdGNoIC12MiBIRUFEfg0KDQpBbmQgeW91IGNhbiBzZW5kIG5ldyB2
ZXJzaW9uIGFzIHJlcGx5IHVzaW5nIC0taW4tcmVwbHk9IG9wdGlvbiBvZiBnaXQgDQpzZW5k
LWVtYWlsLiBJdCBoZWxwcyBhIGxvdCB3aXRoIGZpbmRpbmcgcHJldmlvdXMgdmVyc2lvbiwg
c2luY2UgYWxsIA0KdmVyc2lvbiBhcmUgbGlua2VkIGluIG9uZSB0aHJlYWQNCg0KQW5kIGFs
bCB1cGRhdGVzIGZyb20gdmVyc2lvbiB0byB2ZXJzaW9uIHNob3VsZCBiZSBwdXQgdW5kZXIg
LS0tICgqKSwgDQpzaW5jZSBpdCdzIGhhcmQgdG8gcmVtZW1iZXIgd2h5IHByZXZpb3VzIHZl
cnNpb24gd2FzIHJlamVjdGVkLg0KDQoNCj4gIAkJanRpbWVvdXQgPSBqaWZmaWVzICsgZGVs
YXk7DQo+ICAJCWRvIHsNCj4gLQkJCWF4ODgxNzlfcmVhZF9jbWQoZGV2LCBBWF9BQ0NFU1Nf
TUFDLCBBWF9TUk9NX0NNRCwNCj4gLQkJCQkJIDEsIDEsICZidWYpOw0KPiArCQkJcmV0ID0g
YXg4ODE3OV9yZWFkX2NtZChkZXYsIEFYX0FDQ0VTU19NQUMsIEFYX1NST01fQ01ELA0KPiAr
CQkJCQkgICAgICAgMSwgMSwgJmJ1Zik7DQo+ICsJCQlpZiAocmV0KSB7DQo+ICsJCQkJbmV0
ZGV2X2RiZyhkZXYtPm5ldCwNCj4gKwkJCQkJICAgIkZhaWxlZCB0byByZWFkIFNST01fQ01E
OiAlZFxuIiwNCj4gKwkJCQkJICAgcmV0KTsNCj4gKwkJCQlyZXR1cm4gcmV0Ow0KPiArCQkJ
fQ0KPiAgDQo+ICAJCQlpZiAodGltZV9hZnRlcihqaWZmaWVzLCBqdGltZW91dCkpDQo+ICAJ
CQkJcmV0dXJuIC1FSU5WQUw7DQo+ICANCj4gIAkJfSB3aGlsZSAoYnVmICYgRUVQX0JVU1kp
Ow0KDQpJIHRoaW5rLCB0aGlzIGNoYW5nZSBtaWdodCBiZSBkYW5nZXJvdXMuIE1heWJlIGl0
IHNob3VsZCBiZSBkb25lIGluIHRoZSANCnNhbWUgd2F5IGFzIGluIGFzaXggZHJpdmVyIFsx
XS4gQ29kZSBwb2xscyBmb3Igc29tZSByZWdpc3RlciBhZnRlciBhIA0Kd3JpdGUgYW5kIG1h
eWJlIG5vbi1mYXRhbCByZWFkIGVycm9yIG1pZ2h0IG9jY3VyIGhlcmUuDQoNCkp1c3QgbXkg
dGhvdWdodHMsIEkgZG9uJ3Qga25vdyBhbnl0aGluZyBhYm91dCB0aGF0IGRldmljZSA6KQ0K
DQoNCj4gKwkJcmV0ID0gYXg4ODE3OV9yZWFkX2NtZChkZXYsIEFYX0FDQ0VTU19NQUMsIEFY
X05PREVfSUQsIEVUSF9BTEVOLA0KPiArCQkJCSAgICAgICBFVEhfQUxFTiwgbWFjKTsNCj4g
Kw0KPiArCQlpZiAocmV0KQ0KPiArCQkJbmV0ZGV2X2RiZyhkZXYtPm5ldCwgIkZhaWxlZCB0
byByZWFkIE5PREVfSUQ6ICVkIiwgcmV0KTsNCj4gKwkJZWxzZQ0KPiArCQkJbmV0aWZfZGJn
KGRldiwgaWZ1cCwgZGV2LT5uZXQsDQo+ICsJCQkJICAiTUFDIGFkZHJlc3MgcmVhZCBmcm9t
IEFTSVggY2hpcCIpOw0KDQpNYXliZSBhbHNvIHVzZSBgbmV0aWZfZGJnYCBoZXJlPy4uLiBU
aGVyZSBzaG91bGQgYmUgYSByZWFzb24gd2h5IGl0IHdhcyANCnVzZWQgaGVyZSBpbiB0aGUg
Zmlyc3QgcGxhY2UuIE9yIHNob3VsZCBub3QgOikNCg0KQW55d2F5LCBpZiBzb21lb25lIHdp
bGwgc2F5IHRoYXQgYmFpbGluZyBvdXQgZnJvbSB3aGlsZSBsb29wIG9uIGFueSANCmVycm9y
IGlzIE9LIGZlZWwgZnJlZSB0byBhZGQNCg0KUmV2aWV3ZWQtYnk6IFBhdmVsIFNrcmlwa2lu
IDxwYXNrcmlwa2luQGdtYWlsLmNvbT4NCg0KDQoNClsxXSANCmh0dHBzOi8vZWxpeGlyLmJv
b3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvZHJpdmVycy9uZXQvdXNiL2FzaXhfY29t
bW9uLmMjTDc4DQoNCg0KV2l0aCByZWdhcmRzLA0KUGF2ZWwgU2tyaXBraW4NCg==

--------------0P0tWxYVtMRXZyKgCjwtnX00--

--------------0cILCLmmlWJTpGId7T5QmWPf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJ/3gAFAwAAAAAACgkQbk1w61LbBA0W
mw/+O76ErrFXVhA2Lpz+tCEplaWuszzrd553T7IlHED3aVE4p0qtyIv8LYjn+mE9D+3KAOfOuI+t
BqkX7KR85/mgbxBQrYFCxrnD+192FBKBoGqKRMhi4gpmeiMpvzYyY8YJGMMg5cHWk4JpmXnq0FtV
HHBpIg+4jSmrBzyVWVN7x5QETVXT3Qfc3zBPTIqsm3nvu7yIqV8fUBTFxLPKavITv/jwCsCw3cFk
/ucVUOuhDKaKrD9Ux21C1Q5VXm5Z7CiGg9bmUimcI7ipuAWo1wlWEAkp6oyO2QySk7L9KFBpSz0V
IumgGN6BsHb4e5oDd9PQvxLqdK0TpuZB2EMmeZQBY9iDPnwCiB1HXR5fzrsLC06ZoYIKvfeb3JFy
4w2VZcM3ZpImjpi7aMG6nOofjC27mLBE9yP9dpV4rEjkKJbNQLFkkAI06qDT1Sz0EGPeYJGDdaTp
hzP+k4Nd1q95yOEjzwlbjP+m9QSMSSS2jLmKTfJj8YJpawaJDt0n1hjSrZboc9PM52cERy0soJtN
p3m3xuI0Gsjpo9HWxdcSeus/XaOVPOO76beJaKdL2ddLHgZOJibY/mk4nOh7pUrlJpn3LbDuxs7u
tXhSrK5hXUFwW8w3coib+WYz9aDlY84U3W0EVWka2FgPYNCD8fxywWSy58xV4YoUytqJNHzaQyCu
+Vg=
=Pfq8
-----END PGP SIGNATURE-----

--------------0cILCLmmlWJTpGId7T5QmWPf--
