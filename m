Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9DA527386
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiENS5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 14:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiENS53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 14:57:29 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6737713EAB;
        Sat, 14 May 2022 11:57:28 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bu29so19752722lfb.0;
        Sat, 14 May 2022 11:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=VcZ0K/HABOBpNg5qwPzNTHUhB6Ih4PJocbOaokSkdbU=;
        b=befeZJVeFiT0K47OOVO13e9GiWK4MTEvmYNodrqcOZCnBxHtcCWzqgRb3ADIyfKl8E
         K0Jf58GJgeimuuIB4K5uckv/Dy45LuXBpQv+2e+m5WMxwRQnh6Kmzgiy0OVB1DMpWkLV
         yCHNwZp5FOuoBC9DlQBnI5EFQkPG+1/MAcw7rSZbFoOTBXmGv+u7QttQyolhX4PFquoX
         3JGySxvCTzNKEz7cR2UW4tekdBxHSYdd/+epVr9q/h6JHc2v4qVNJw2KiWRmrqjeohN7
         f8yGWXC1hQozGmCmdl2vAv1fIjZ4Ve32GWAGVji+04Kk6Q+ChTssw1BFEE5l9hkGw3+p
         63ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=VcZ0K/HABOBpNg5qwPzNTHUhB6Ih4PJocbOaokSkdbU=;
        b=CxbuHeqWSFAlcZPwTXrx99vSUNn0+ixAunk1Z2NdqDFsZDXIEJtzC+01lZUdUJIOmM
         QrbX7u+f1vZ/YtJniL+C+sunQzA0e8rYOEcote9OU2uMm1L5X6IetPJrPL2txWoqNzPw
         4vxU5CN3OTP7GZ75eLjWFtPONUihicFJtblPpCMjhNjOi0zxR7ZOo7wzdUxou56mdrH8
         ZkcPYMwT0GqVulEHsps9rQUjlT/sHG4TO2/BSBcGyuWC2SPhAJN1NNVtkBah490vB+Ai
         1jXrDiVPr4msqYUs54giUEMgp8wk/pwPldtZlLszwmWY80S1tlmuKllp7Tekjo6CFa3D
         Pp1w==
X-Gm-Message-State: AOAM531m+HLFuROe5VwYlOGKO6j1rew5hcHKKv+PAATSpjq/ZAGbKDx5
        FvsrEK3v180BfkehgytD5eY=
X-Google-Smtp-Source: ABdhPJyK0AsLodqWpRxHxp0fTOcAa4In9FCcLY7qU9ZXjetFqZs9p9ZXfG0SaQL5Ikjk3Qh2ooUNCw==
X-Received: by 2002:a05:6512:613:b0:472:4169:1907 with SMTP id b19-20020a056512061300b0047241691907mr7440433lfe.189.1652554646755;
        Sat, 14 May 2022 11:57:26 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.216])
        by smtp.gmail.com with ESMTPSA id y27-20020a2e545b000000b0024f3d1daef3sm910774ljd.123.2022.05.14.11.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 11:57:25 -0700 (PDT)
Message-ID: <df7417a9-4338-487b-b8ff-8defe3d102a5@gmail.com>
Date:   Sat, 14 May 2022 21:57:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de
References: <20220514133234.33796-1-k.kahurani@gmail.com>
 <ebf3adc8-3e33-7ef3-e74d-29a32640972f@gmail.com>
 <20220514185425.GI4009@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220514185425.GI4009@kadam>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------y0vZHTmRUcI6FxZ3LnIVkcIq"
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
--------------y0vZHTmRUcI6FxZ3LnIVkcIq
Content-Type: multipart/mixed; boundary="------------sXZEUuXPW0MKh006kPdTvwLw";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org,
 syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com, davem@davemloft.net,
 jgg@ziepe.ca, kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, phil@philpotter.co.uk,
 syzkaller-bugs@googlegroups.com, arnd@arndb.de
Message-ID: <df7417a9-4338-487b-b8ff-8defe3d102a5@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220514133234.33796-1-k.kahurani@gmail.com>
 <ebf3adc8-3e33-7ef3-e74d-29a32640972f@gmail.com>
 <20220514185425.GI4009@kadam>
In-Reply-To: <20220514185425.GI4009@kadam>

--------------sXZEUuXPW0MKh006kPdTvwLw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgRGFuLA0KDQpPbiA1LzE0LzIyIDIxOjU0LCBEYW4gQ2FycGVudGVyIHdyb3RlOg0KPiBP
biBTYXQsIE1heSAxNCwgMjAyMiBhdCAwNzo1MToxMlBNICswMzAwLCBQYXZlbCBTa3JpcGtp
biB3cm90ZToNCj4+IEFuZCB5b3UgY2FuIHNlbmQgbmV3IHZlcnNpb24gYXMgcmVwbHkgdXNp
bmcgLS1pbi1yZXBseT0gb3B0aW9uIG9mIGdpdA0KPj4gc2VuZC1lbWFpbC4gSXQgaGVscHMg
YSBsb3Qgd2l0aCBmaW5kaW5nIHByZXZpb3VzIHZlcnNpb24sIHNpbmNlIGFsbCB2ZXJzaW9u
DQo+PiBhcmUgbGlua2VkIGluIG9uZSB0aHJlYWQNCj4gDQo+IFRoaXMgaXMgZGlzY291cmFn
ZWQgdGhlc2UgZGF5cy4gIEl0IG1ha2VzIGZvciBsb25nIGNvbmZ1c2luZyB0aHJlYWRzLg0K
PiBCdXQgbW9yZSBpbXBvcnRhbnRseSwgaXQgYXBwYXJlbnRseSBtZXNzZXMgdXAgcGF0Y2h3
b3JrLg0KPiANCg0KT2ssIGJ1dCBhdCBsZWFzdCBsZWF2aW5nIGEgbGluayB0byB0aGUgcHJl
dmlvdXMgdmVyc2lvbihzKSBzZWVtcyANCnJlYXNvbmFibGUuDQoNCg0KDQoNCldpdGggcmVn
YXJkcywNClBhdmVsIFNrcmlwa2luDQo=

--------------sXZEUuXPW0MKh006kPdTvwLw--

--------------y0vZHTmRUcI6FxZ3LnIVkcIq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJ/+5QFAwAAAAAACgkQbk1w61LbBA1D
zg//bwFbdRzmu01//OfolrDMIP/u++c1qibijH1OBzGc6fvjlehfK8LT/NhjLiFJl4RUAKn6V0/y
mvP7dDwb6mXkz2QKe12vmj7FnhZBcnldqa/Tq7+N6hXj0LY3bfOc+XvRtxno/JSiWW24KK6+ju+x
c1q+o5roB4kZL3vPBVf4MZuUaJGaL6JCCZjywLT4VULF03WJPNTVW39sZ7OiBvf8hWwiybSVchTZ
xUnCkJPg3Ir+izYkJdYMdzh3ubBXAsGrKG9rlOyAVEbQxhtUao8zMNjuXdO3SinlTC4MViPuUdHO
EJEYDs2tcqEh7sBbn2sdnVtJH3QeDWkvgo9ZhmGf66EzZ5FxqZP81aBypJ1AyjMfWGjpS38Ms8vc
prvk/vJblO8zjU+UouFrs/Y4jpuXGOkvLY0D98rDg0TvDBwR7LftltpPq9V3jnfDkiyCyVeMddwY
9cn6WGzW3r0SlQ0jLIgZBlnXTclh0tGvqEKHL3bJ/hFmpq4PryFo8YJA4cbZmJm7eOo88WsBBDnk
/gq5SyOTxxnpb4shqQGc77enFohqniPII+Wx7MR+AcAkRNvRU7xh148WmHU7m8RBedsMBa9Uf9qF
2DGe1x+pxKkv8qn3067HsZ6O0dLP7bofzKEMcr+fM3o9yFTkrg7Eq7LaiBeyMG1rUnmD8GXH6rpi
KHc=
=Qd3v
-----END PGP SIGNATURE-----

--------------y0vZHTmRUcI6FxZ3LnIVkcIq--
