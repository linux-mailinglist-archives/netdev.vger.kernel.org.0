Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96244F1AA9
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379114AbiDDVSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379283AbiDDQwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:52:03 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DBB36326;
        Mon,  4 Apr 2022 09:50:06 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id m12so2004120ljp.8;
        Mon, 04 Apr 2022 09:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=HtIQn6mbUkvy4Db2lKHLi0u58C4r0hcTFnmV+40vHMI=;
        b=ffBfSL9S7lBP7oGYKhhwJYKCt+WlpPVR0Z5Hp1t3H+Ca7B13eMjlJoI5v9UixnvQNl
         DqJntxykgUgDm1Y1zl8/y/DXsMVP2A4PmLlbhcmOas7UW6m3/3/VjhqxBmPXAJjuyX6U
         E3/NGMmAyLiYNI1f0Rp3dJWSCu5b9ZmFarWULOZlj/FqcSscs5wiPFqgEs+DhSWgWyO2
         OKAgDCcLlZaxV+eVz3uWZ15gCpeQudKbTQs9+915IqBEFowgelxXMDIVy+/f4jCrK9My
         YDuIXy62GpZp2qBCidWz5e1BZCK/rWpBK+VDsxLU/0iJ5ED7jGl39B0NYR1OLTC9BOLd
         3H0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=HtIQn6mbUkvy4Db2lKHLi0u58C4r0hcTFnmV+40vHMI=;
        b=mSJoL3Q8gDFMoFxAkKX5ky5rg4F/vDPVaRqu7uJnANGpMKBW1E1my1IpMhXvZZbRmk
         qw/zWCYlmSSif0vt9dAdpHIjigZUGN2Cynv2tCw1mtoKuz3Qs+3ZZNWwSiGwfKWv1KKD
         fCUxu0VaeGffU9s10KbROpQ8xjhB9XSft51zPoTSeoqr+CuxWdtqT/uZon5DNculKzFL
         jMw1EkoL0nd1f2t8R5wyK61eIe35Hl4B+4QG9AXpnRazuvjgZEb65XGQgEYo2s8sO4WA
         nwfELS9lP3o77xl2BYT9ENydkS7pL3SfkXqxmjbzeyZk8zVAwZnSPbVzrlPV8gXyTa1q
         yCcA==
X-Gm-Message-State: AOAM530hxGu1WACCGSp/ZcC6t2IgL8EKzDZvKXpNtsuEII3cQbkQ6rk4
        2/L7pGGjFR9HUG8PC93IAvk=
X-Google-Smtp-Source: ABdhPJxVgP7F+AJtnwyoyQSq9NseZz+Zp0eCXIerog3mBc8EfNkYbSagjIYoiZTukq8mvtRLgkO+sQ==
X-Received: by 2002:a05:651c:1543:b0:249:a2bd:4a74 with SMTP id y3-20020a05651c154300b00249a2bd4a74mr287121ljp.375.1649091004189;
        Mon, 04 Apr 2022 09:50:04 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.247])
        by smtp.gmail.com with ESMTPSA id j16-20020a05651231d000b0044a01d1ee94sm1184185lfe.306.2022.04.04.09.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 09:50:03 -0700 (PDT)
Message-ID: <6b6a8f5c-ceb9-ce97-bf79-d7634b433135@gmail.com>
Date:   Mon, 4 Apr 2022 19:50:02 +0300
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
        arnd@arndb.de
References: <20220404151036.265901-1-k.kahurani@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220404151036.265901-1-k.kahurani@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zb90hqoA65mLe8Lt0TvRPB28"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zb90hqoA65mLe8Lt0TvRPB28
Content-Type: multipart/mixed; boundary="------------yNBJ0s1Tiv10MptfS0kvqNS8";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org
Cc: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
 davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com, arnd@arndb.de
Message-ID: <6b6a8f5c-ceb9-ce97-bf79-d7634b433135@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220404151036.265901-1-k.kahurani@gmail.com>
In-Reply-To: <20220404151036.265901-1-k.kahurani@gmail.com>

--------------yNBJ0s1Tiv10MptfS0kvqNS8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgRGF2aWQsDQoNCk9uIDQvNC8yMiAxODoxMCwgRGF2aWQgS2FodXJhbmkgd3JvdGU6DQo+
IFJlYWRzIHRoYXQgYXJlIGxlc3NlciB0aGFuIHRoZSByZXF1ZXN0ZWQgc2l6ZSBsZWFkIHRv
IHVuaW5pdC12YWx1ZSBidWdzLiBRdWFsaWZ5DQo+IHN1Y2ggcmVhZHMgYXMgZXJyb3JzIGFu
ZCBoYW5kbGUgdGhlbSBjb3JyZWN0bHkuDQo+IA0KPiBheDg4MTc5XzE3OGEgMi0xOjAuMzUg
KHVubmFtZWQgbmV0X2RldmljZSkgKHVuaW5pdGlhbGl6ZWQpOiBGYWlsZWQgdG8gcmVhZCBy
ZWcgaW5kZXggMHgwMDAxOiAtNzENCj4gYXg4ODE3OV8xNzhhIDItMTowLjM1ICh1bm5hbWVk
IG5ldF9kZXZpY2UpICh1bmluaXRpYWxpemVkKTogRmFpbGVkIHRvIHJlYWQgcmVnIGluZGV4
IDB4MDAwMjogLTcxDQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09DQo+IEJVRzogS01TQU46IHVuaW5pdC12YWx1ZSBpbiBheDg4MTc5
X2NoZWNrX2VlcHJvbSBkcml2ZXJzL25ldC91c2IvYXg4ODE3OV8xNzhhLmM6MTA3NCBbaW5s
aW5lXQ0KPiBCVUc6IEtNU0FOOiB1bmluaXQtdmFsdWUgaW4gYXg4ODE3OV9sZWRfc2V0dGlu
ZysweDg4NC8weDMwYjAgZHJpdmVycy9uZXQvdXNiL2F4ODgxNzlfMTc4YS5jOjExNjgNCj4g
ICBheDg4MTc5X2NoZWNrX2VlcHJvbSBkcml2ZXJzL25ldC91c2IvYXg4ODE3OV8xNzhhLmM6
MTA3NCBbaW5saW5lXQ0KPiAgIGF4ODgxNzlfbGVkX3NldHRpbmcrMHg4ODQvMHgzMGIwIGRy
aXZlcnMvbmV0L3VzYi9heDg4MTc5XzE3OGEuYzoxMTY4DQo+ICAgYXg4ODE3OV9iaW5kKzB4
ZTc1LzB4MTk5MCBkcml2ZXJzL25ldC91c2IvYXg4ODE3OV8xNzhhLmM6MTQxMQ0KPiAgIHVz
Ym5ldF9wcm9iZSsweDEyODQvMHg0MTQwIGRyaXZlcnMvbmV0L3VzYi91c2JuZXQuYzoxNzQ3
DQo+ICAgdXNiX3Byb2JlX2ludGVyZmFjZSsweGYxOS8weDE2MDAgZHJpdmVycy91c2IvY29y
ZS9kcml2ZXIuYzozOTYNCj4gICByZWFsbHlfcHJvYmUrMHg2N2QvMHgxNTEwIGRyaXZlcnMv
YmFzZS9kZC5jOjU5Ng0KPiAgIF9fZHJpdmVyX3Byb2JlX2RldmljZSsweDNlOS8weDUzMCBk
cml2ZXJzL2Jhc2UvZGQuYzo3NTENCj4gICBkcml2ZXJfcHJvYmVfZGV2aWNlIGRyaXZlcnMv
YmFzZS9kZC5jOjc4MSBbaW5saW5lXQ0KPiAgIF9fZGV2aWNlX2F0dGFjaF9kcml2ZXIrMHg3
OWYvMHgxMTIwIGRyaXZlcnMvYmFzZS9kZC5jOjg5OA0KPiAgIGJ1c19mb3JfZWFjaF9kcnYr
MHgyZDYvMHgzZjAgZHJpdmVycy9iYXNlL2J1cy5jOjQyNw0KPiAgIF9fZGV2aWNlX2F0dGFj
aCsweDU5My8weDhlMCBkcml2ZXJzL2Jhc2UvZGQuYzo5NjkNCj4gICBkZXZpY2VfaW5pdGlh
bF9wcm9iZSsweDRhLzB4NjAgZHJpdmVycy9iYXNlL2RkLmM6MTAxNg0KPiAgIGJ1c19wcm9i
ZV9kZXZpY2UrMHgxN2IvMHgzZTAgZHJpdmVycy9iYXNlL2J1cy5jOjQ4Nw0KPiAgIGRldmlj
ZV9hZGQrMHgxZDNlLzB4MjQwMCBkcml2ZXJzL2Jhc2UvY29yZS5jOjMzOTQNCj4gICB1c2Jf
c2V0X2NvbmZpZ3VyYXRpb24rMHgzN2U5LzB4M2VkMCBkcml2ZXJzL3VzYi9jb3JlL21lc3Nh
Z2UuYzoyMTcwDQo+ICAgdXNiX2dlbmVyaWNfZHJpdmVyX3Byb2JlKzB4MTNjLzB4MzAwIGRy
aXZlcnMvdXNiL2NvcmUvZ2VuZXJpYy5jOjIzOA0KPiAgIHVzYl9wcm9iZV9kZXZpY2UrMHgz
MDkvMHg1NzAgZHJpdmVycy91c2IvY29yZS9kcml2ZXIuYzoyOTMNCj4gICByZWFsbHlfcHJv
YmUrMHg2N2QvMHgxNTEwIGRyaXZlcnMvYmFzZS9kZC5jOjU5Ng0KPiAgIF9fZHJpdmVyX3By
b2JlX2RldmljZSsweDNlOS8weDUzMCBkcml2ZXJzL2Jhc2UvZGQuYzo3NTENCj4gICBkcml2
ZXJfcHJvYmVfZGV2aWNlIGRyaXZlcnMvYmFzZS9kZC5jOjc4MSBbaW5saW5lXQ0KPiAgIF9f
ZGV2aWNlX2F0dGFjaF9kcml2ZXIrMHg3OWYvMHgxMTIwIGRyaXZlcnMvYmFzZS9kZC5jOjg5
OA0KPiAgIGJ1c19mb3JfZWFjaF9kcnYrMHgyZDYvMHgzZjAgZHJpdmVycy9iYXNlL2J1cy5j
OjQyNw0KPiAgIF9fZGV2aWNlX2F0dGFjaCsweDU5My8weDhlMCBkcml2ZXJzL2Jhc2UvZGQu
Yzo5NjkNCj4gICBkZXZpY2VfaW5pdGlhbF9wcm9iZSsweDRhLzB4NjAgZHJpdmVycy9iYXNl
L2RkLmM6MTAxNg0KPiANCg0KSSdkIHBlcnNvbmFsbHkgY3V0IHRoaXMgbG9nIGEgYml0IGFu
ZCB3b3VsZCBhZGQgdGhpcyBwYXJ0IG9mIHRoZSBpbml0aWFsIA0KcmVwb3J0DQoNCkxvY2Fs
IHZhcmlhYmxlIGVlcHJvbS5pIGNyZWF0ZWQgYXQ6DQogIGF4ODgxNzlfY2hlY2tfZWVwcm9t
IGRyaXZlcnMvbmV0L3VzYi9heDg4MTc5XzE3OGEuYzoxMDQ1IFtpbmxpbmVdDQogIGF4ODgx
NzlfbGVkX3NldHRpbmcrMHgyZTIvMHgzMGIwIGRyaXZlcnMvbmV0L3VzYi9heDg4MTc5XzE3
OGEuYzoxMTY4DQogIGF4ODgxNzlfYmluZCsweGU3NS8weDE5OTAgZHJpdmVycy9uZXQvdXNi
L2F4ODgxNzlfMTc4YS5jOjE0MTENCg0KU2luY2UgaXQgc2hvd3MgZXhhY3RseSB3aGVyZSBw
cm9ibGVtIGNvbWVzIGZyb20uDQoNCkkgZG8gbm90IGluc2lzdCwganVzdCBJTU8NCg0KPiBT
aWduZWQtb2ZmLWJ5OiBEYXZpZCBLYWh1cmFuaSA8ay5rYWh1cmFuaUBnbWFpbC5jb20+DQo+
IFJlcG9ydGVkLWJ5OiBzeXpib3QrZDNkYmRmMzFmYmU5ZDhmNWYzMTFAc3l6a2FsbGVyLmFw
cHNwb3RtYWlsLmNvbQ0KPiAtLS0NCg0KSXQncyBpbmRlZWQgYSBidWcgZml4LCBzbyBmaXhl
cyB0YWcgaXMgbmVlZGVkDQoNCkZpeGVzOiBlMmNhOTBjMjc2ZTEgKCJheDg4MTc5XzE3OGE6
IEFTSVggQVg4ODE3OV8xNzhBIFVTQiAzLjAvMi4wIHRvIA0KZ2lnYWJpdCBldGhlcm5ldCBh
ZGFwdGVyIGRyaXZlciIpDQoNCg0KPiAgIGRyaXZlcnMvbmV0L3VzYi9heDg4MTc5XzE3OGEu
YyB8IDI1NSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0NCj4gICAxIGZpbGUg
Y2hhbmdlZCwgMjEzIGluc2VydGlvbnMoKyksIDQyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9heDg4MTc5XzE3OGEuYyBiL2RyaXZlcnMvbmV0
L3VzYi9heDg4MTc5XzE3OGEuYw0KPiBpbmRleCBlMmZhNTZiOTIuLmI1ZTExNGJlZCAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvdXNiL2F4ODgxNzlfMTc4YS5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L3VzYi9heDg4MTc5XzE3OGEuYw0KPiBAQCAtMTg1LDggKzE4NSw5IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3Qgew0KPiAgIAl7NywgMHhjYywgMHg0YywgMHgxOCwgOH0sDQo+
ICAgfTsNCj4gICANCj4gLXN0YXRpYyBpbnQgX19heDg4MTc5X3JlYWRfY21kKHN0cnVjdCB1
c2JuZXQgKmRldiwgdTggY21kLCB1MTYgdmFsdWUsIHUxNiBpbmRleCwNCj4gLQkJCSAgICAg
IHUxNiBzaXplLCB2b2lkICpkYXRhLCBpbnQgaW5fcG0pDQo+ICtzdGF0aWMgaW50IF9fbXVz
dF9jaGVjayBfX2F4ODgxNzlfcmVhZF9jbWQoc3RydWN0IHVzYm5ldCAqZGV2LCB1OCBjbWQs
DQo+ICsJCSAgICAgICAgICAgICAgICAgICAgICAgICAgIHUxNiB2YWx1ZSwgdTE2IGluZGV4
LCB1MTYgc2l6ZSwNCj4gKwkJCQkJICAgdm9pZCAqZGF0YSwgaW50IGluX3BtKQ0KPiAgIHsN
Cj4gICAJaW50IHJldDsNCj4gICAJaW50ICgqZm4pKHN0cnVjdCB1c2JuZXQgKiwgdTgsIHU4
LCB1MTYsIHUxNiwgdm9pZCAqLCB1MTYpOw0KPiBAQCAtMjAxLDkgKzIwMiwxMiBAQCBzdGF0
aWMgaW50IF9fYXg4ODE3OV9yZWFkX2NtZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHU4IGNtZCwg
dTE2IHZhbHVlLCB1MTYgaW5kZXgsDQo+ICAgCXJldCA9IGZuKGRldiwgY21kLCBVU0JfRElS
X0lOIHwgVVNCX1RZUEVfVkVORE9SIHwgVVNCX1JFQ0lQX0RFVklDRSwNCj4gICAJCSB2YWx1
ZSwgaW5kZXgsIGRhdGEsIHNpemUpOw0KPiAgIA0KPiAtCWlmICh1bmxpa2VseShyZXQgPCAw
KSkNCj4gKwlpZiAodW5saWtlbHkocmV0IDwgc2l6ZSkpIHsNCj4gKwkJcmV0ID0gcmV0IDwg
MCA/IHJldCA6IC1FTk9EQVRBOw0KPiArDQo+ICAgCQluZXRkZXZfd2FybihkZXYtPm5ldCwg
IkZhaWxlZCB0byByZWFkIHJlZyBpbmRleCAweCUwNHg6ICVkXG4iLA0KPiAgIAkJCSAgICBp
bmRleCwgcmV0KTsNCj4gKwl9DQo+ICAgDQo+ICAgCXJldHVybiByZXQ7DQo+ICAgfQ0KPiBA
QCAtMjQ5LDE5ICsyNTMsMjYgQEAgc3RhdGljIHZvaWQgYXg4ODE3OV93cml0ZV9jbWRfYXN5
bmMoc3RydWN0IHVzYm5ldCAqZGV2LCB1OCBjbWQsIHUxNiB2YWx1ZSwNCj4gICAJfQ0KPiAg
IH0NCj4gICANCj4gLXN0YXRpYyBpbnQgYXg4ODE3OV9yZWFkX2NtZF9ub3BtKHN0cnVjdCB1
c2JuZXQgKmRldiwgdTggY21kLCB1MTYgdmFsdWUsDQo+IC0JCQkJIHUxNiBpbmRleCwgdTE2
IHNpemUsIHZvaWQgKmRhdGEpDQo+ICtzdGF0aWMgaW50IF9fbXVzdF9jaGVjayBheDg4MTc5
X3JlYWRfY21kX25vcG0oc3RydWN0IHVzYm5ldCAqZGV2LCB1OCBjbWQsDQo+ICsJCSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHUxNiB2YWx1ZSwgdTE2IGluZGV4LCB1MTYgc2l6
ZSwNCj4gKwkJCQkJICAgICAgdm9pZCAqZGF0YSkNCj4gICB7DQo+ICAgCWludCByZXQ7DQo+
ICAgDQo+ICAgCWlmICgyID09IHNpemUpIHsNCj4gICAJCXUxNiBidWY7DQo+ICAgCQlyZXQg
PSBfX2F4ODgxNzlfcmVhZF9jbWQoZGV2LCBjbWQsIHZhbHVlLCBpbmRleCwgc2l6ZSwgJmJ1
ZiwgMSk7DQo+ICsNCj4gKwkJaWYgKHJldCA8IDApDQo+ICsJCQlyZXR1cm4gcmV0Ow0KDQpF
bXB0eSBsaW5lIGFmdGVyIGFzc2lnbm1lbnQgYW5kIGJlZm9yZSBjaGVjayBsb29rcyByZWR1
bmRhbnQuDQoNCj4gICAJCWxlMTZfdG9fY3B1cygmYnVmKTsNCj4gICAJCSooKHUxNiAqKWRh
dGEpID0gYnVmOw0KPiAgIAl9IGVsc2UgaWYgKDQgPT0gc2l6ZSkgew0KPiAgIAkJdTMyIGJ1
ZjsNCj4gICAJCXJldCA9IF9fYXg4ODE3OV9yZWFkX2NtZChkZXYsIGNtZCwgdmFsdWUsIGlu
ZGV4LCBzaXplLCAmYnVmLCAxKTsNCj4gKw0KPiArCQlpZiAocmV0IDwgMCkNCj4gKwkJCXJl
dHVybiByZXQ7DQoNClNhbWUgaGVyZQ0KDQoNCkluIGdlbmVyYWwsIGxvb2tzIGdvb2QsIGJ1
dCwgcGxlYXNlLCBmaXggdXAgaW5kZW50aW5nIGFuZCBvdGhlciBzbWFsbCANCmlzc3Vlcy4N
Cg0KDQoNCg0KV2l0aCByZWdhcmRzLA0KUGF2ZWwgU2tyaXBraW4NCg==

--------------yNBJ0s1Tiv10MptfS0kvqNS8--

--------------zb90hqoA65mLe8Lt0TvRPB28
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJLIboFAwAAAAAACgkQbk1w61LbBA0a
yQ//SjcKkqEm/zVkuz7hYex2jBBmoE2JQoQxqb9meQwzcFZYDE6smVddbKVmrBPQW95Cwa7SQL2y
ozlCMN1PABvHlxg2Y6KkZtukDSbhttn0AANVvmC1o9WmJlVFp1RbONX9G6UkHS1e5V+ruBeDuA8G
PRhyHVGpLxx0KnKHRhwKnae1kpL+s57SXK7zsErb5puR2rl3PmSWt38b4sS1twlLZlc4TP0pVKn4
fqfLHBFOfnCrqrNJzuJr7Bseh3+Ek5BgqYI+LYS6i1Q7oKMFyjyjbPPvXXj7TJwnwuPt71DD4nYC
Ib8HSPF6ZE9wEKSIorKts87pvv6UtYBfLnxQKPFoToxlaX3umJIDtRxXWQ6XtFQMKRzdo+XZ5hag
Rz6jBdktqitw7EmuPiPtSKMPshAtBMBC2AICdViQHlRKr2Ff4yX7WddeE2QXMVjsAT87inWVVDCy
XSzZGSGiP/u6PCBVrBq5wko/7YDPNmUrRgTMqOww9NYf29S1maXtz+leUT0z0DoJypb+Lvx4h6M/
ogXXSVUIYi63XPfMx7CKrkxeE2bJgWLWRHe2WErmi+TRU7RXylnjPEe0WsT8k5qiq5rywSbhYXWx
q5GqxBpf2/f55yJ5NBFJ+1QJXdMM+lAgPl9VhJkbHUNgsgbyN2UOLFd8/ZELasQNyaG4j4kQ8SAC
9Ho=
=8MfJ
-----END PGP SIGNATURE-----

--------------zb90hqoA65mLe8Lt0TvRPB28--
