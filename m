Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FF94E59F1
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 21:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbiCWUgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 16:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiCWUgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 16:36:47 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F4A269;
        Wed, 23 Mar 2022 13:35:15 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bu29so4730526lfb.0;
        Wed, 23 Mar 2022 13:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=yvypnLVjCrWy5spCJBsgRPFJn4U1BSlCRE6N0KMRzWU=;
        b=TLCkjNe8KY46ih5qA1GtmMXB57U6LTd+kdCmexWzAF2WwlSu8eaRgtGVcQ78s6Fxt6
         v3FksA3mvB8IXngY9316GUf0riflRzNyWD1veXCWM2cC7Vn02ybuO77PPQ969CAXZrCv
         7HCFbAahuIavcEEGqYQFW0cuBrQ0Rb1pI9yx0NXRvNLb8ZHShXFgwtM+LQi5O9Lo/NrC
         GcQ/l45g21PIH0SUSMRE2WQ+V5Jmalr/RudVM9cakXi/HUzxTCNwVaN/h+g/rcgn4KU7
         lRy0nlzgOAlS31WeN6/eSk+qukjydsyO4D/XKLkVZBJA3jhXhMpM0KjjJoztSuka612j
         guBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=yvypnLVjCrWy5spCJBsgRPFJn4U1BSlCRE6N0KMRzWU=;
        b=bK+FxVho9ywvRsjK3JR5BcQf+wk0ab+O7oOskBVC0pcb+HrOv/OrFDHqoAtA0zFS4+
         veWKXmbJpRvMlirO+FxotVxKWJelZK48MxBTPsztoK3iephnjclWfe4llvZliMt3w9tI
         U6wx54hNJ5wYJIUMvrrDhfglJO+d2Wh1iQRkEIbHWlqNJW9b/42g5uVwT9QG8jdDYlGi
         xdr02DSv39Y+E3Fksw7ivN+8akyusQh9FoFJLjOXuAKkwpip0cBgUARzMfo1mNuWX5rQ
         xb7YiOtGL3O/vXpLE+kR70gJn88eeXnTPSoebqcAN/RHGT0NOxHnVDpNwmVT+jiG7vXQ
         4f7w==
X-Gm-Message-State: AOAM531xR3YlZ6bJLSoA6HwyrUSHxKrhAQAW4QiwC+0sNIgqwpok56zh
        AEwsKzGvohThS2jfF64YwAg=
X-Google-Smtp-Source: ABdhPJwfztJuCDhkEzxS/JcI1aU8U4w5CymWH04dRCfYpin0MrgEuXHRoMGZo+rV0KHOBUfj7AIzAg==
X-Received: by 2002:a05:6512:2348:b0:44a:3134:7d52 with SMTP id p8-20020a056512234800b0044a31347d52mr1164464lfu.207.1648067713945;
        Wed, 23 Mar 2022 13:35:13 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.145])
        by smtp.gmail.com with ESMTPSA id c22-20020ac24156000000b0044846901eabsm89637lfi.24.2022.03.23.13.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:35:13 -0700 (PDT)
Message-ID: <f35435f3-13bd-2985-bfdd-b693388e49a0@gmail.com>
Date:   Wed, 23 Mar 2022 23:35:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v3] can: mcba_usb: properly check endpoint type
Content-Language: en-US
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
References: <CAMZ6RqKn4E9wstZF1xbefBaR3AbcORq60KXvxUTCSH8dZ+Cxag@mail.gmail.com>
 <20220313100903.10868-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220313100903.10868-1-paskripkin@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wuJb3knIS3Bcn2sAl3RLDNAC"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wuJb3knIS3Bcn2sAl3RLDNAC
Content-Type: multipart/mixed; boundary="------------zMAyY88wsciZQYHPRhRowlKy";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
 davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Message-ID: <f35435f3-13bd-2985-bfdd-b693388e49a0@gmail.com>
Subject: Re: [PATCH v3] can: mcba_usb: properly check endpoint type
References: <CAMZ6RqKn4E9wstZF1xbefBaR3AbcORq60KXvxUTCSH8dZ+Cxag@mail.gmail.com>
 <20220313100903.10868-1-paskripkin@gmail.com>
In-Reply-To: <20220313100903.10868-1-paskripkin@gmail.com>

--------------zMAyY88wsciZQYHPRhRowlKy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xMy8yMiAxMzowOSwgUGF2ZWwgU2tyaXBraW4gd3JvdGU6DQo+IFN5emJvdCByZXBv
cnRlZCB3YXJuaW5nIGluIHVzYl9zdWJtaXRfdXJiKCkgd2hpY2ggaXMgY2F1c2VkIGJ5IHdy
b25nDQo+IGVuZHBvaW50IHR5cGUuIFdlIHNob3VsZCBjaGVjayB0aGF0IGluIGVuZHBvaW50
IGlzIGFjdHVhbGx5IHByZXNlbnQgdG8NCj4gcHJldmVudCB0aGlzIHdhcm5pbmcNCj4gDQo+
IEZvdW5kIHBpcGVzIGFyZSBub3cgc2F2ZWQgdG8gc3RydWN0IG1jYmFfcHJpdiBhbmQgY29k
ZSB1c2VzIHRoZW0gZGlyZWN0bHkNCj4gaW5zdGVhZCBvZiBtYWtpbmcgcGlwZXMgaW4gcGxh
Y2UuDQo+IA0KPiBGYWlsIGxvZzoNCj4gDQo+IHVzYiA1LTE6IEJPR1VTIHVyYiB4ZmVyLCBw
aXBlIDMgIT0gdHlwZSAxDQo+IFdBUk5JTkc6IENQVTogMSBQSUQ6IDQ5IGF0IGRyaXZlcnMv
dXNiL2NvcmUvdXJiLmM6NTAyIHVzYl9zdWJtaXRfdXJiKzB4ZWQyLzB4MThhMCBkcml2ZXJz
L3VzYi9jb3JlL3VyYi5jOjUwMg0KPiBNb2R1bGVzIGxpbmtlZCBpbjoNCj4gQ1BVOiAxIFBJ
RDogNDkgQ29tbToga3dvcmtlci8xOjIgTm90IHRhaW50ZWQgNS4xNy4wLXJjNi1zeXprYWxs
ZXItMDAxODQtZzM4ZjgwZjQyMTQ3ZiAjMA0KPiBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5k
YXJkIFBDIChRMzUgKyBJQ0g5LCAyMDA5KSwgQklPUyAxLjE0LjAtMiAwNC8wMS8yMDE0DQo+
IFdvcmtxdWV1ZTogdXNiX2h1Yl93cSBodWJfZXZlbnQNCj4gUklQOiAwMDEwOnVzYl9zdWJt
aXRfdXJiKzB4ZWQyLzB4MThhMCBkcml2ZXJzL3VzYi9jb3JlL3VyYi5jOjUwMg0KPiAuLi4N
Cj4gQ2FsbCBUcmFjZToNCj4gICA8VEFTSz4NCj4gICBtY2JhX3VzYl9zdGFydCBkcml2ZXJz
L25ldC9jYW4vdXNiL21jYmFfdXNiLmM6NjYyIFtpbmxpbmVdDQo+ICAgbWNiYV91c2JfcHJv
YmUrMHg4YTMvMHhjNTAgZHJpdmVycy9uZXQvY2FuL3VzYi9tY2JhX3VzYi5jOjg1OA0KPiAg
IHVzYl9wcm9iZV9pbnRlcmZhY2UrMHgzMTUvMHg3ZjAgZHJpdmVycy91c2IvY29yZS9kcml2
ZXIuYzozOTYNCj4gICBjYWxsX2RyaXZlcl9wcm9iZSBkcml2ZXJzL2Jhc2UvZGQuYzo1MTcg
W2lubGluZV0NCj4gDQo+IFJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IHN5emJvdCszYmMxZGNl
MGNjMDA1MmQ2MGZkZUBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IEZpeGVzOiA1MWYz
YmFhZDdkZTkgKCJjYW46IG1jYmFfdXNiOiBBZGQgc3VwcG9ydCBmb3IgTWljcm9jaGlwIENB
TiBCVVMgQW5hbHl6ZXIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBTa3JpcGtpbiA8cGFz
a3JpcGtpbkBnbWFpbC5jb20+DQo+IFJldmlld2VkLWJ5OiBWaW5jZW50IE1haWxob2wgPG1h
aWxob2wudmluY2VudEB3YW5hZG9vLmZyPg0KDQpnZW50bGUgcGluZy4gbG9va3MgbGlrZSB0
aGlzIHBhdGNoIGdvdCBzb21laG93IGxvc3QNCg0KDQoNCg0KV2l0aCByZWdhcmRzLA0KUGF2
ZWwgU2tyaXBraW4NCg==

--------------zMAyY88wsciZQYHPRhRowlKy--

--------------wuJb3knIS3Bcn2sAl3RLDNAC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmI7hH8FAwAAAAAACgkQbk1w61LbBA2A
7w//UDuGW6KEDfBJmFHbEIeC19pI4v2v1q8B6LWq0TEhvK9afaiDdereDT4g36kpAJQdq36oHr5m
WychvLnb9QWMZaGR/vT4UyRIlC7G+LRcdJZP0aIhaLMr2QxQzlZ+WeGHVP5vlNUaByCeCjO7r79O
f0OB9G3TyBA976RkG2kY1TxutGEH537aEC8+VllnBibB8ysKRfU1bNBd8kcoN0zmcvcXkVfvxYIW
wtc4nLaKUzQmT3RbIiIxkZylK04e1XR0cAeGeZG0TC9sv+ASXlZLLb6wUsGMox4LvSMp9InuT9JX
AqXjK3cTbSIOW5NMy27w14nFFVTX3eBX0X9Z/nquwEojo9IiRwZwrC5ZRb742X/nQsoFa/Ou9IQM
VZRRgWWBMMh5e2NvmxcKiIHMgIoXHq+pOMaSH7rpxb1fNl1CihgrmixKdfxVVz8EAmclzf1csOVh
QEBdl2Uvhyr5kYq/Yw0hoi6FHhCxL/FHZHp7KFaGpRBXH3akzq/6yS1OPn/Q8fhnJpiIOWobwR95
0dwI+3N8O+e9bYzcxfH34qZcFYrlCiuh/Xdnpwdu3i1Eq1XmYitrYJ6KcvHfpxgjBH+wmJB7I8/s
HqDThr1md9FM6N27zRL9po77M3qit1+krSvYxlhnrz2KiDYBVn8Idj8n1jJUmPwHZG812gqFYR2k
Ens=
=RjdE
-----END PGP SIGNATURE-----

--------------wuJb3knIS3Bcn2sAl3RLDNAC--
