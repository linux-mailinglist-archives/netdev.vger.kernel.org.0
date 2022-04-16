Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6EA503635
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiDPLIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiDPLID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:08:03 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56193B562;
        Sat, 16 Apr 2022 04:05:23 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bu29so17539331lfb.0;
        Sat, 16 Apr 2022 04:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=Wci9Il7J8wetpC5RlZmMGn0bKOP3JvqUfYp7PT1EcdY=;
        b=p+GdkZdzQe66I94lVpn/DDQKK/AJSohoyNsdgy23xL+fTDaymcjN9KGZ4brakcSYzB
         OUIeP1xSFjdxDUCqkavCJEsi98rebGXS1WU7YM20omcdoeue7hdankdu3BPpcjwJzdUa
         QfVeSNN0+bd9eN4LW8pSmJk9LT6FVKEvtb6BRQVHEhkSC9SfUMSWIZ2m4V244NeNt1TO
         GCYTYJbdbsIkce5T0Iu5Fc7/COrKL7GLQKdas0cHTtljtqAAw79ezKX28rLBv9y/3HjG
         HJ3ASDC9YG95mGPEHn3U8ANZ7OO2QxEbnj8ymw/d+eLys+0Ol0r4g+8AxFbT1oImwxPK
         CCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=Wci9Il7J8wetpC5RlZmMGn0bKOP3JvqUfYp7PT1EcdY=;
        b=tgtUXUFN4/yiXOR8O78DhCZBh4bXtgWFTK/YIAnQ3X3+siUxiPWrG++ZbZoH+j1BzX
         GScXrTFE36vihBFYpB925Rsr8YTJ7GCTCDxaQtk8D3n3dABpnssmPLsN0LozldASmNW8
         DCye4xVHzJVjQSDPjuFF3hc3WTTg2LhCORZYy9d5WRudJAqBcDVaBjdUoUc/8lAFilvd
         OnAYc2eDNUKfynkGXkHN8KGoBNREhd5W3Bm2vxB2xw58pHUIsvN1QSbruTrFF8O3SiQY
         1jUri5GxkaWbW1J/JrEdZE03q2w6tzXd9VXEemoWkIOvAzmI3x325o/ngjBwRzCA7apk
         4fHA==
X-Gm-Message-State: AOAM530RfuG5sGxfeXopxpREyZQOlEqWinBJWDe6GpbLuh5NmPdQhrD1
        TVwXzPLjq+md/4GWS1MlKmw=
X-Google-Smtp-Source: ABdhPJw2OzWAPBuRLcjVHf5R4/N2Qk2L1Px0hMpSOSQ+7Ss/MNXcpj0bTphY2yEuV9FUTOVdeyIyKw==
X-Received: by 2002:a05:6512:1195:b0:44a:6ec3:4fe7 with SMTP id g21-20020a056512119500b0044a6ec34fe7mr2070990lfr.395.1650107121614;
        Sat, 16 Apr 2022 04:05:21 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.17])
        by smtp.gmail.com with ESMTPSA id k38-20020a05651c062600b0024da9b13e91sm359255lje.103.2022.04.16.04.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 04:05:20 -0700 (PDT)
Message-ID: <13bcf1cc-b75c-93d0-49cc-ecb99e291ee7@gmail.com>
Date:   Sat, 16 Apr 2022 14:05:19 +0300
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
 boundary="------------bI9o000ynnXmHdQv1XVQp1Hz"
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
--------------bI9o000ynnXmHdQv1XVQp1Hz
Content-Type: multipart/mixed; boundary="------------p9yASZ0dxDT0nWMmSaPSa6si";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org
Cc: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
 davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com, arnd@arndb.de,
 dan.carpenter@oracle.com
Message-ID: <13bcf1cc-b75c-93d0-49cc-ecb99e291ee7@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220416074817.571160-1-k.kahurani@gmail.com>
In-Reply-To: <20220416074817.571160-1-k.kahurani@gmail.com>

--------------p9yASZ0dxDT0nWMmSaPSa6si
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgRGF2aWQsDQoNCkFsbW9zdCBwZXJmZWN0LCBwbGVhc2Ugc2VlIG9uZSBjb21tZW50IGlu
bGluZQ0KDQpPbiA0LzE2LzIyIDEwOjQ4LCBEYXZpZCBLYWh1cmFuaSB3cm90ZToNCj4gUmVh
ZHMgdGhhdCBhcmUgbGVzc2VyIHRoYW4gdGhlIHJlcXVlc3RlZCBzaXplIGxlYWQgdG8gdW5p
bml0LXZhbHVlIGJ1Z3MuDQo+IEluIHRoaXMgcGFydGljdWxhciBjYXNlIGEgdmFyaWFibGUg
d2hpY2ggd2FzIHN1cHBvc2VkIHRvIGJlIGluaXRpYWxpemVkDQo+IGFmdGVyIGEgcmVhZCBp
cyBsZWZ0IHVuaW5pdGlhbGl6ZWQgYWZ0ZXIgYSBwYXJ0aWFsIHJlYWQuDQo+IA0KPiBRdWFs
aWZ5IHN1Y2ggcmVhZHMgYXMgZXJyb3JzIGFuZCBoYW5kbGUgdGhlbSBjb3JyZWN0bHkgYW5k
IHdoaWxlIGF0IGl0DQo+IGNvbnZlcnQgdGhlIHJlYWRlciBmdW5jdGlvbnMgdG8gcmV0dXJu
IHplcm8gb24gc3VjY2VzcyBmb3IgZWFzaWVyIGVycm9yDQo+IGhhbmRsaW5nLg0KPiANCj4g
Rml4ZXM6IGUyY2E5MGMyNzZlMSAoImF4ODgxNzlfMTc4YTogQVNJWCBBWDg4MTc5XzE3OEEg
VVNCIDMuMC8yLjAgdG8NCj4gZ2lnYWJpdCBldGhlcm5ldCBhZGFwdGVyIGRyaXZlciIpDQo+
IFNpZ25lZC1vZmYtYnk6IERhdmlkIEthaHVyYW5pIDxrLmthaHVyYW5pQGdtYWlsLmNvbT4N
Cj4gUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTogc3l6Ym90K2QzZGJkZjMxZmJlOWQ4ZjVmMzEx
QHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4gLS0tDQoNCltjb2RlIHNuaXBdDQoNCj4g
ICANCj4gQEAgLTQxNiw3ICs0NDEsNyBAQCBheDg4MTc5X3BoeV93cml0ZV9tbWRfaW5kaXJl
Y3Qoc3RydWN0IHVzYm5ldCAqZGV2LCB1MTYgcHJ0YWQsIHUxNiBkZXZhZCwNCj4gICAJcmV0
ID0gYXg4ODE3OV93cml0ZV9jbWQoZGV2LCBBWF9BQ0NFU1NfUEhZLCBBWDg4MTc5X1BIWV9J
RCwNCj4gICAJCQkJTUlJX01NRF9EQVRBLCAyLCAmZGF0YSk7DQo+ICAgDQo+IC0JaWYgKHJl
dCA8IDApDQo+ICsJaWYgKHJldCkNCj4gICAJCXJldHVybiByZXQ7DQo+ICAgDQoNCkkgdGhp
bmssIHlvdSBkaWRuJ3QgbWVhbiB0byBkbyBzby4gYXg4ODE3OV93cml0ZV9jbWQoKSByZXR1
cm5zIG51bWJlciBvZiANCmJ5dGVzIHdyaXR0ZW4sIHNvIHlvdSBhcmUgY2hhbmdpbmcgdGhl
IGxvZ2ljIGhlcmUuIEFuZCB3cml0ZSBjYWxsIGlzIG5vdCANCnJlbGF0ZWQgdG8gdW5pbml0
IHZhbHVlIGJ1Z3MNCg0KDQoNCg0KDQpXaXRoIHJlZ2FyZHMsDQpQYXZlbCBTa3JpcGtpbg0K


--------------p9yASZ0dxDT0nWMmSaPSa6si--

--------------bI9o000ynnXmHdQv1XVQp1Hz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJaou8FAwAAAAAACgkQbk1w61LbBA00
Jg//Q+sdmnfH53LV6rL7oisgCo74KI172/u+N2Wc3iJQR+AkSm5g8+ncTeGWGLz3PY2OJmfBJ8dA
J+1xP8StPUFdxfQbqxCvaUrlANu6DT0XAjSEoqnUvfbgFRH/dddtiqB+XLHZkGt7UB/t7a/rTwYm
yGt6YQsxZ6TBWp7TANVIq15oIrX5sw9wsOjWbkZKO6wsQkrOr/yGCWnAmGxzhEIQXDUWbkZn/bBR
laDEmE1BAChD8G3xXSOashAX9PyKbG2ww/HHHiwJKW2UhgxeSuSSYICkKA5hZr86DFvTc0WSAXA2
+LKt6+AWpOrgtOSeJsj0Y1z9Fb5ZKRjSJJFytyGeqxG7kLudvEB00UcoAqWJoj8fAeGvZ0vZSgUo
59w9W5euaYUD1zfMPpSLVC0uBN6uwQT8+7/xax4rs2YsDMJeQJEsjd9im/fFc6eoJxvSDL6HROj8
M+PXaAzIAC1OoqlaSDJz7vL1JBmAFHwvv7vY7bv+zExKUQKxYeO1BuGt6TRGRx0+8vzr7vIiEXIC
3pxTM+8px0DDWht5DLmvo7u2KBJQqI3MjfyS6lm82KkSUhHE4ydcDdoG0Nqrynw3B7hrSqom8bBe
lHHnnxMZ6+6bA8aILo+EDxp/OtVTZJj++5yv7wV4Ax+HYspKhG5K93jP8la54yfGNdfrVJy8qhEm
EAw=
=vWHq
-----END PGP SIGNATURE-----

--------------bI9o000ynnXmHdQv1XVQp1Hz--
