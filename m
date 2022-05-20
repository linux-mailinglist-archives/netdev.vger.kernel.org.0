Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C728852F4C0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353569AbiETVG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353566AbiETVGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:06:25 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8A67DE21;
        Fri, 20 May 2022 14:06:19 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id br17so4026034lfb.2;
        Fri, 20 May 2022 14:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=I0/LR1u9ynNadGu5tggcJqg3L+3503cJwrgFleP8Nlc=;
        b=cTCFBLfwZ2h0RBCR4FhJsFHLuH31u3G82j10U05tAXqjmrva6a4XLJf8L7DFoTS/CZ
         t+L8ag1j9Px3pCSDkTjHVSfXTB+z+p9WunksYw0I2euuPNt8S/210Ke+sRPVxnIsS96u
         PrmOh/F/CohBjON9kkF8IMMr/pRArDFanlGFctyQO/MbTCQ/YIcmhKXYWSC/BE8vsrvh
         Lf5MdM1wA4jU6gFF79dMMeghyC9elusXXhj4SrpZFilCcfT28qhHzEnT9X3XKQOC64ep
         moALfhXWKlwLK0NiMlUceJN3p9TGuMv2PB4NzB/ESU4qi7hu4EwE96KEp6zbWmhAoxqI
         NMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=I0/LR1u9ynNadGu5tggcJqg3L+3503cJwrgFleP8Nlc=;
        b=kOCy/KfKoB2CQKlNBBw/TtCIQbB1I2F0MJhfTgbYZklC3bfF8lmYHO1TYq9+z6+cib
         ke/EV6uEyy9Cc9YG/UEe1L4B46UmnYjdBeAjZ4O+0mAjpUdekul2WOv+9esPnLlmcH61
         dxuuc91yOeDCeevEH4whgTSJukhoqdXddv7a/RxojD2Si7Ag4OO6NTtRFJuWMWn2Gxe3
         h01STkvyMeoAV3YE95dVUrfrnWhn7oiNhBALkFGbW+1ftsbxaBr/BVINuPjd7jTEn+qD
         6R4ksheFHDnOPGm6+Ir6r5Fr/lhOIkYfTef3ImLbJPEY+l4tIZCN+ypqPYHT+o/2iOK0
         dQuQ==
X-Gm-Message-State: AOAM530dTq360PSGQIjMwhQXUiMxe4QyAlYAn6wxl1ppEkfssmJ3Ty8M
        LD3Ffpr3zx84D44RXD6p8NQ=
X-Google-Smtp-Source: ABdhPJy5vRN5AeEfNxfYw4R5s1Plx4W8xjumOXOSk6AOIny2Drk8waP/R/peTyUi8i08yarPFUFj/Q==
X-Received: by 2002:a05:6512:5cb:b0:472:f7e:a5f5 with SMTP id o11-20020a05651205cb00b004720f7ea5f5mr8027754lfo.358.1653080777901;
        Fri, 20 May 2022 14:06:17 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.4])
        by smtp.gmail.com with ESMTPSA id b17-20020ac247f1000000b004744bfd620fsm787093lfp.236.2022.05.20.14.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 14:06:17 -0700 (PDT)
Message-ID: <01a941bf-400a-b555-a67d-7b6bed44a53b@gmail.com>
Date:   Sat, 21 May 2022 00:06:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] net: ocelot: fix wront time_after usage
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220519204017.15586-1-paskripkin@gmail.com>
 <YoeMW+/KGk8VpbED@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YoeMW+/KGk8VpbED@lunn.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------caAMiWf062mI1cghvHNzgMk3"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------caAMiWf062mI1cghvHNzgMk3
Content-Type: multipart/mixed; boundary="------------8B794hshaA4KPTW7ASRwuwK4";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
 alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 dan.carpenter@oracle.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <01a941bf-400a-b555-a67d-7b6bed44a53b@gmail.com>
Subject: Re: [PATCH] net: ocelot: fix wront time_after usage
References: <20220519204017.15586-1-paskripkin@gmail.com>
 <YoeMW+/KGk8VpbED@lunn.ch>
In-Reply-To: <YoeMW+/KGk8VpbED@lunn.ch>

--------------8B794hshaA4KPTW7ASRwuwK4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgQW5kcmV3LA0KDQpPbiA1LzIwLzIyIDE1OjQwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVGh1LCBNYXkgMTksIDIwMjIgYXQgMTE6NDA6MTdQTSArMDMwMCwgUGF2ZWwgU2tyaXBr
aW4gd3JvdGU6DQo+PiBBY2NpZGVudGFsbHkgbm90aWNlZCwgdGhhdCB0aGlzIGRyaXZlciBp
cyB0aGUgb25seSB1c2VyIG9mDQo+PiB3aGlsZSAodGltZXJfYWZ0ZXIoamlmZmllcy4uLikp
Lg0KPj4gDQo+PiBJdCBsb29rcyBsaWtlIHR5cG8sIGJlY2F1c2UgbGlrZWx5IHRoaXMgd2hp
bGUgbG9vcCB3aWxsIGZpbmlzaCBhZnRlciAxc3QNCj4+IGl0ZXJhdGlvbiwgYmVjYXVzZSB0
aW1lX2FmdGVyKCkgcmV0dXJucyB0cnVlIHdoZW4gMXN0IGFyZ3VtZW50IF9pcyBhZnRlcl8N
Cj4+IDJuZCBvbmUuDQo+PiANCj4+IEZpeCBpdCBieSBuZWdhdGluZyB0aW1lX2FmdGVyIHJl
dHVybiB2YWx1ZSBpbnNpZGUgd2hpbGUgbG9vcHMgc3RhdGVtZW50DQo+IA0KPiBBIGJldHRl
ciBmaXggd291bGQgYmUgdG8gdXNlIG9uZSBvZiB0aGUgaGVscGVycyBpbiBsaW51eC9pb3Bv
bGwuaC4NCj4gDQo+IFRoZXJlIGlzIGEgc2Vjb25kIGJ1ZyBpbiB0aGUgY3VycmVudCBjb2Rl
Og0KPiANCj4gc3RhdGljIGludCBvY2Vsb3RfZmRtYV93YWl0X2NoYW5fc2FmZShzdHJ1Y3Qg
b2NlbG90ICpvY2Vsb3QsIGludCBjaGFuKQ0KPiB7DQo+IAl1bnNpZ25lZCBsb25nIHRpbWVv
dXQ7DQo+IAl1MzIgc2FmZTsNCj4gDQo+IAl0aW1lb3V0ID0gamlmZmllcyArIHVzZWNzX3Rv
X2ppZmZpZXMoT0NFTE9UX0ZETUFfQ0hfU0FGRV9USU1FT1VUX1VTKTsNCj4gCWRvIHsNCj4g
CQlzYWZlID0gb2NlbG90X2ZkbWFfcmVhZGwob2NlbG90LCBNU0NDX0ZETUFfQ0hfU0FGRSk7
DQo+IAkJaWYgKHNhZmUgJiBCSVQoY2hhbikpDQo+IAkJCXJldHVybiAwOw0KPiAJfSB3aGls
ZSAodGltZV9hZnRlcihqaWZmaWVzLCB0aW1lb3V0KSk7DQo+IA0KPiAJcmV0dXJuIC1FVElN
RURPVVQ7DQo+IH0NCj4gDQo+IFRoZSBzY2hlZHVsZXIgY291bGQgcHV0IHRoZSB0aHJlYWQg
dG8gc2xlZXAsIGFuZCBpdCBkb2VzIG5vdCBnZXQgd29rZW4NCj4gdXAgZm9yIE9DRUxPVF9G
RE1BX0NIX1NBRkVfVElNRU9VVF9VUy4gRHVyaW5nIHRoYXQgdGltZSwgdGhlIGhhcmR3YXJl
DQo+IGhhcyBkb25lIGl0cyB0aGluZywgYnV0IHlvdSBleGl0IHRoZSB3aGlsZSBsb29wIGFu
ZCByZXR1cm4gLUVUSU1FRE9VVC4NCj4gDQo+IGxpbnV4L2lvcG9sbC5oIGhhbmRsZXMgdGhp
cyBjb3JyZWN0bHkgYnkgdGVzdGluZyB0aGUgc3RhdGUgb25lIG1vcmUNCj4gdGltZSBhZnRl
ciB0aGUgdGltZW91dCBoYXMgZXhwaXJlZC4NCj4gDQoNCkkgd2Fzbid0IGF3YXJlIGFib3V0
IHRoZXNlIG1hY3Jvcy4gVGhhbmtzIGZvciBwb2ludGluZyBvdXQgdG8gdGhhdCBoZWFkZXIh
DQoNCldpbGwgc2VuZCB2MiBzb29uLA0KDQoNCg0KV2l0aCByZWdhcmRzLA0KUGF2ZWwgU2ty
aXBraW4NCg==

--------------8B794hshaA4KPTW7ASRwuwK4--

--------------caAMiWf062mI1cghvHNzgMk3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmKIAsgFAwAAAAAACgkQbk1w61LbBA2Q
NhAAoR3iq/YyS89hLPJPJUHPQ7sImgIGnDs6CIBAXwIXSI2gM6CL437EpbnMeTskG6zjpRxtW4M4
GKIHtNBdfhSK/yLcBr+ZCyhvB+GbyUzq1QVLy1IlCNtKseLHLTuzu+syC+A89hPgE+87cW0lLA3H
frubZAYspDPkrXVI7sZXA0iDDZQAhn8ZBrCFSN7uHeOX5Y4LPugYXfPvPl5kxn55ubfUcTQZrTRo
sio8wYeddiD+kocLfxlequCIlrd7d7PR2NZo0TQWQgjbPvB1Ir60GogTpxC8IQCIl5Hn082CDH1F
3ktF3eWvbKHOQxmAnbhzifdGvxnyUAycmAdk8jAE/wSU71nG43BGQUEC35LppXbhiv+d7TnU9VNM
D4TOeqkdp+RRrzEQBRBNODOk7KnpwWr0WfT7kbud+CU8AeaWYMsP6hH/dFnJ1F9OGtCwMHwtyfVC
DlvhOgUdSIueL061/+tV0D6UQFy89e46KMh78jbj3WBAhlAPlKzB+2umZksoZtUEFj2XkgJu6xNn
fagvUjtNKyc8tOMwZ9bXvQT4GXkUex1Be5UogEG04yHE1uzk4NGjjivkzgY2lCwMfE1/kuto2NJH
Pw6C7Hgh27doihvwoYm9Ru1RGUTVJgxSBVmRq3fD5IjSDbb2C+SYOuiySMWd3LLZkyfLfDDkF1vI
jck=
=5814
-----END PGP SIGNATURE-----

--------------caAMiWf062mI1cghvHNzgMk3--
