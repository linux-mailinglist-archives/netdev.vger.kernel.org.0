Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFAC50366E
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 14:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiDPL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiDPL4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:56:20 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925401839D;
        Sat, 16 Apr 2022 04:53:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id k5so17560546lfg.9;
        Sat, 16 Apr 2022 04:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=IfsWwKk1MQPrbepjpxLLLpKqazt3VMDLNqEU+ElHWhI=;
        b=c4veQ9UoLzC3cLwOJlYMEO0oguyevxFpjgYdIObPKopJIA7wqp85O2YsgOnHY4aAnX
         wqH+G2xTUCHnb3bFyeyDcp0D1w7W3iTvmT/8MyQe/LgwIzgZTU0u/T6zFEy313qgs4r1
         iqIzVY5RaEw+195c8AA03Ll693w2yHarRrYuwwKIwuQ9Ly82rMvjbruPbgY6fjyvIJQN
         erbN4ic2vwzDJo6Xwm2r1ZQNJR1hOPN8B5Hy/pZxAvks47l9v5CskcpF5PDJs9W+9Kyh
         yeDxQ3fG/odDOgR5CRgrmK87JJAHq1p607uua44L0LQ9sEODTSu1hztVTRbHFx0cSqaF
         plfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=IfsWwKk1MQPrbepjpxLLLpKqazt3VMDLNqEU+ElHWhI=;
        b=pe/Wu4EryU4ux6lof2FqGM7ZIJiHQKHXWlf7HyNVff6bGN1qRF4/8VCd8kW/Xfe/G5
         x6xXhOYKPUCEEDKNecSIILv1gzWGt+zo9aSyXAWp++qvLoaeyuKWwct6gIo0Z1VMzVOj
         GayhIrGOObb4ZRMGwVSb1LCnkj9ej2tm+yQ4EQOLd1FHU38M0VO5rSuTBRqs8ew2s5x5
         RjiOtjdOF6w7/eXYd2eSn9eQIL7QtwD5t14qfTLZQEWth4cPK/5ixixX4cbNe77WXgag
         EryhhR+n2WzUKCAPl6Ln7QtOwDqqwXYsTPMwBzYuOOZp6fuovVfmLALmoUWUt8MsLmyG
         mdeA==
X-Gm-Message-State: AOAM533PUB/gJb7E+WDEYnDU+w1KKCmSZipMNm37cUTh2aoqY5UP5Yis
        33bih99Tf4O7e28N/sjUeDY=
X-Google-Smtp-Source: ABdhPJyk2G4zCEyfRsfMaU/qZzZpgChnosUGy6D2jVntxoPWXSKMcbCnbeyBi4Qw2+IWrBLvh82Vsg==
X-Received: by 2002:a05:6512:3f92:b0:447:769c:1b2c with SMTP id x18-20020a0565123f9200b00447769c1b2cmr2243783lfa.387.1650110026837;
        Sat, 16 Apr 2022 04:53:46 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.17])
        by smtp.gmail.com with ESMTPSA id d12-20020ac241cc000000b004437eab8187sm646443lfi.73.2022.04.16.04.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 04:53:46 -0700 (PDT)
Message-ID: <18f52ad1-0928-389c-46fc-dd050b73a4cd@gmail.com>
Date:   Sat, 16 Apr 2022 14:53:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Content-Language: en-US
To:     David Kahurani <k.kahurani@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220416074817.571160-1-k.kahurani@gmail.com>
 <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
 <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HBlPS3SMKe911ViC3IFP3Gdt"
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
--------------HBlPS3SMKe911ViC3IFP3Gdt
Content-Type: multipart/mixed; boundary="------------m8Ad4gUM9m3PSOTYqtSiBF3h";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: David Kahurani <k.kahurani@gmail.com>
Cc: netdev@vger.kernel.org,
 syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
 davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 Phillip Potter <phil@philpotter.co.uk>, syzkaller-bugs@googlegroups.com,
 arnd@arndb.de, Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <18f52ad1-0928-389c-46fc-dd050b73a4cd@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220416074817.571160-1-k.kahurani@gmail.com>
 <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
 <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>
In-Reply-To: <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>

--------------m8Ad4gUM9m3PSOTYqtSiBF3h
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgRGF2aWQsDQoNCk9uIDQvMTYvMjIgMTQ6NDksIERhdmlkIEthaHVyYW5pIHdyb3RlOg0K
Pj4gPiBAQCAtMTMwMyw4ICsxNDQ4LDEyIEBAIHN0YXRpYyB2b2lkIGF4ODgxNzlfZ2V0X21h
Y19hZGRyKHN0cnVjdCB1c2JuZXQgKmRldikNCj4+ID4gICAgICAgICAgICAgICBuZXRpZl9k
YmcoZGV2LCBpZnVwLCBkZXYtPm5ldCwNCj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
Ik1BQyBhZGRyZXNzIHJlYWQgZnJvbSBkZXZpY2UgdHJlZSIpOw0KPj4gPiAgICAgICB9IGVs
c2Ugew0KPj4gPiAtICAgICAgICAgICAgIGF4ODgxNzlfcmVhZF9jbWQoZGV2LCBBWF9BQ0NF
U1NfTUFDLCBBWF9OT0RFX0lELCBFVEhfQUxFTiwNCj4+ID4gLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIEVUSF9BTEVOLCBtYWMpOw0KPj4gPiArICAgICAgICAgICAgIHJldCA9
IGF4ODgxNzlfcmVhZF9jbWQoZGV2LCBBWF9BQ0NFU1NfTUFDLCBBWF9OT0RFX0lELCBFVEhf
QUxFTiwNCj4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVUSF9B
TEVOLCBtYWMpOw0KPj4gPiArDQo+PiA+ICsgICAgICAgICAgICAgaWYgKHJldCkNCj4+ID4g
KyAgICAgICAgICAgICAgICAgICAgIG5ldGRldl9kYmcoZGV2LT5uZXQsICJGYWlsZWQgdG8g
cmVhZCBOT0RFX0lEOiAlZCIsIHJldCk7DQo+PiA+ICsNCj4+ID4gICAgICAgICAgICAgICBu
ZXRpZl9kYmcoZGV2LCBpZnVwLCBkZXYtPm5ldCwNCj4+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgIk1BQyBhZGRyZXNzIHJlYWQgZnJvbSBBU0lYIGNoaXAiKTsNCj4+ID4gICAgICAg
fQ0KPj4NCj4+DQo+PiBUaGlzIG1lc3NhZ2Ugc2VxdWVuY2UgaXMgY29uZnVzaW5nLg0KPj4N
Cj4+IEluIGNhc2Ugb2YgYXg4ODE3OV9yZWFkX2NtZCgpIGZhaWx1cmUgbWFjIHJlYWQgZnJv
bSBkZXZpY2UgYWN0dWFsbHkNCj4+IGZhaWxlZCwgYnV0IG1lc3NhZ2Ugc2F5cywgdGhhdCBp
dCB3YXMgc3VjY2Vzc2Z1bGx5IGZpbmlzaGVkLg0KPiANCj4gSSBzdXBwb3NlIHRoZSBjb2Rl
IHNob3VsZCByZXR1cm4gaW4gY2FzZSBvZiBhbiBlcnJvciB0aGF0IHdheSB0aGUgbmV4dA0K
PiBtZXNzYWdlIGRvZXMgbm90IGdldCBleGVjdXRlZC4NCj4gDQoNCk5vLCB0aGlzIHdpbGwg
YnJlYWsgdGhlIGRyaXZlci4gVGhpcyBmdW5jdGlvbiBzaG91bGQgc2V0IG1hYyBhZGRyZXNz
IGluIA0KbmV0ZGV2IHN0cnVjdHVyZSBhbmQgaWYgcmVhZCBmcm9tIGRldmljZSBmYWlscyBj
b2RlIGNhbGxzDQoNCglldGhfaHdfYWRkcl9zZXQoZGV2LT5uZXQsIG1hYyk7DQoNCndoaWNo
IHdpbGwgZ2VuZXJhdGUgcmFuZG9tIG1hYyBhZGRyLiBJLmUuIHJlYWQgZmFpbHVyZSBpcyBu
b3QgY3JpdGljYWwgDQppbiB0aGF0IGZ1bmN0aW9uDQoNClNvLCBubyBuZWVkIHRvIHJldHVy
biB3aXRoIGFuIGVycm9yLCBqdXN0IGRvbid0IHByaW50IGNvbmZ1c2luZyBtZXNzYWdlcyA6
KQ0KDQoNCg0KDQpXaXRoIHJlZ2FyZHMsDQpQYXZlbCBTa3JpcGtpbg0K

--------------m8Ad4gUM9m3PSOTYqtSiBF3h--

--------------HBlPS3SMKe911ViC3IFP3Gdt
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJarkgFAwAAAAAACgkQbk1w61LbBA0A
5g/+MBT5VAslgsAG4HmdPXeAfSaEMPE34fJgs3YHoFMhnGnDyHujk7iCRqVi1/0HkajvugRy04K+
Cqbm0d4JtYsFjJlGUkE/+QWSYgo79ds2vagnYd02zGMZP7B7O/3aBMPKGWjBPzur9uyKl6RoILeN
Z4qs5xfki6mBUmnzFvRYPdbvkn3YNRkeLU9J3xaaW1VRYb4bGBSrEbyqeueVGVlfjAdzEijb6laO
zgV+BwX60r6NYvWTgtmTTUcuVTGbcBBaUvPEw/67eUEpstpKuVJnfPYp+X/WYvY3Klde8eUcMgtq
2TcLSVPDYHfcj05wSEW7VKeMaANVRrIzlD1Cv7oApK14DYkGk8XAbPyvnInEe7gMVlHBUtSJjDNr
fM/5Uknck3dW7DBLCrRTgL/+jJKKDA9lddWWoOw6cjqmAT+JrD+KFSR3z2pgeJfCuSSj4BRb9S5Q
fc76kToF0onaXo0xY7qE0E/m2yGaTmhCvb/uTPzWTB/xY+qfdW0T11XlctpDIpF0XiEahBvMAix9
mzu698xuYVzX0UXUtvaZ1uHPP4YK2lkXdRNo7K+73SibUVOm6T7Z8I+bsLvi+4BRYOO2JcR0jHLZ
FWeMbgWLejrz4H++kIhp0Tf1GDTYcwtYtfrX/sTNKC895L4HUp7BlNMjKSOjQ441u0K2UF9LYYpx
+r0=
=eoDM
-----END PGP SIGNATURE-----

--------------HBlPS3SMKe911ViC3IFP3Gdt--
