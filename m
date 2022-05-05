Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3851C8B4
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 21:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384887AbiEETNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376888AbiEETNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:13:30 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04214EDDE;
        Thu,  5 May 2022 12:09:49 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t25so9014763lfg.7;
        Thu, 05 May 2022 12:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=95r8yUTj2H1m8JRx9bOkdg77cwQCDoRvR/+l/UIoyJ4=;
        b=Dm5wM9hZ9u8lEUCIPdXFUtwIig97WpDmFrVoWrSpy7KBBDptnPwD117188AkTu+RoT
         QvVIiPJemLXZLElpuXUQqZa8K1Q6tFrt1ci9ItQvqQuYs5unjXBC1eIxyFs2Rt+uxgjA
         mkffEdUBwt4/RqFihQvTByVJp/L8vW2H057AjFDkGEmc0BmHt9I3hK/4eFzgqJvjErCT
         9ECrRCAHmPy2Nc42gDjMaq+6VQ0wzBdMJkTWZ9ru6VdGGuD7sS48ywGgTF2udX7Ochyy
         fO3TcZD2D5A/ntwJY13cUS2w8p4+BiljLXSo9oBpf5p3liHNE1Ee6e76kQKfoTglW0aT
         WhQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=95r8yUTj2H1m8JRx9bOkdg77cwQCDoRvR/+l/UIoyJ4=;
        b=cPALJqHmwRP2bYOhnkqULmSPUk82n+/ijG36F3OTfaYKXD3ZeKFEDvRPhoL544vJ6p
         6htwtaTRe05xLe9iyt+Nc6NUMatI17V4lO8yhLB9VAO2VlsgX9qpM2sXeNm89mLNhUvu
         ikcUORHzM2e9giiEImvJMTN20oZOm/n1FzjWStftgSs1b2Hjjb3wVQJ2LWDYPKUP0qJb
         9dGQdOLw60Nram1odoFhwevxYxqzg7xEp/eywlZKGbMmCiy8dPnyVlMTjeQoTVFA67H3
         g6sdQFeHYBVgU8F2Wd0jQ5Y+b/QDscbHG/UjXIKGdcZ6IN5uoItdx9ha9y82/csuyPsW
         IjqA==
X-Gm-Message-State: AOAM532AjY5UV0O4gr5KWOLMUz1Ftpk8jiLPzaE2Qw64Qa6qjOy7I1Bc
        KEKoTpPRIjDCb+LDkft6ZIZq5+vCPpQ=
X-Google-Smtp-Source: ABdhPJzs2WyDQbVtkHEsX9Z/BuUrxD5bCXGbt9D11Q0Vh136PQNvEb5nQvILOkyKI5Gxq0zNsSd5mQ==
X-Received: by 2002:a05:6512:22d5:b0:473:a527:717 with SMTP id g21-20020a05651222d500b00473a5270717mr11084254lfu.510.1651777787788;
        Thu, 05 May 2022 12:09:47 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.246.114])
        by smtp.gmail.com with ESMTPSA id s6-20020a2eb8c6000000b0024f3d1daea2sm312947ljp.42.2022.05.05.12.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 12:09:47 -0700 (PDT)
Message-ID: <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
Date:   Thu, 5 May 2022 22:09:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
 <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------RwO6X2hG0PGwvossowR4eaBq"
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------RwO6X2hG0PGwvossowR4eaBq
Content-Type: multipart/mixed; boundary="------------BuTCYHRj8nx9zy0QljTTmpW0";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
 ath9k-devel@qca.qualcomm.com, kvalo@kernel.org, davem@davemloft.net,
 kuba@kernel.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+03110230a11411024147@syzkaller.appspotmail.com,
 syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Message-ID: <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
 <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
In-Reply-To: <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>

--------------BuTCYHRj8nx9zy0QljTTmpW0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgVGV0c3VvLA0KDQpPbiA1LzIvMjIgMDk6MTAsIFRldHN1byBIYW5kYSB3cm90ZToNCj4+
IEFuZCB3ZSBjYW4gbWVldCBOVUxMIGRlZmVyIGV2ZW4gaWYgd2UgbGVhdmUgZHJ2X3ByaXYg
PSBwcml2IGluaXRpYWxpemF0aW9uDQo+PiBvbiBpdCdzIHBsYWNlLg0KPiANCj4gSSBkaWRu
J3QgY2F0Y2ggdGhlIGxvY2F0aW9uLiBBcyBsb25nIGFzICJodGNfaGFuZGxlLT5kcnZfcHJp
diA9IHByaXY7IiBpcyBkb25lDQo+IGJlZm9yZSBjb21wbGV0ZV9hbGwoJmhpZl9kZXYtPmZ3
X2RvbmUpIGlzIGRvbmUsIGlzIHNvbWV0aGluZyB3cm9uZz8NCj4gDQoNCkkgZG9uJ3QgcmVh
bGx5IHJlbWVtYmVyIHdoeSBJIHNhaWQgdGhhdCwgYnV0IGxvb2tzIGxpa2UgSSBqdXN0IGhh
dmVuJ3QgDQpvcGVuZWQgY2FsbGJhY2tzJyBjb2RlLg0KDQpNeSBwb2ludCB3YXMgdGhhdCBt
eSBwYXRjaCBkb2VzIG5vdCBjaGFuZ2UgdGhlIGxvZ2ljLCBidXQgb25seSBmaXhlcyAyIA0K
cHJvYmxlbXM6IFVBRiBhbmQgTlVMTCBkZXJlZi4NCg0KDQoNCg0KV2l0aCByZWdhcmRzLA0K
UGF2ZWwgU2tyaXBraW4NCg==

--------------BuTCYHRj8nx9zy0QljTTmpW0--

--------------RwO6X2hG0PGwvossowR4eaBq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJ0IPkFAwAAAAAACgkQbk1w61LbBA0T
Qw//S89A5hXZn0QKDeJ5BiOPpbcWphz7JnMepW4YZ3+c0PSVsOJYnuTGuJP4ZgLCY2Xhlz555CiS
CIG5CzUAPvisnD2hSVFZd6AxHNgbRi6L9kLzkmYcIdRDBCOHz9/BXyG8+SUQYI9aBGzAWAf6INpl
Ox1cK9fAkWOPR52tEs5ee3bS82jWftq5Gej5HuXH/OOueDxcRDrvRon/qi8fEe61S4jGUNcPDJIN
KX/uwWc6UeRWxtw7nl+r28eTLQbU228QR51bn3/rAPlMJ3B/x0lPhl06kuxonskvjY0ZYNZuXvzT
S5swHOw1VwBbfSfSGBGiNrdzRKvEaygNGGW2NF6FrCkEnYNgykZTv1XuBPaE+E+ICxvPGrhe7X9P
GFNBAj0Uktl0ULeEXnPjv93sXtZNjy+sz+cK7gcV7Cfb6JuW+myT59zVJBRc2oQJjY905mgtO820
2CZiBO9Jn18i/VIchONjl62f31aZBblvgejXA69mpco3LIBLUoQ6N57HNp5iUwxZIJxgcBupnheH
O33BAnFZ6n56OCe4bdRX/nvG7m9ETfpX7m4OOg3V+AEVbc+4aNUz8NK/z9U1ufK6yVQXqj6tuJ/J
L/aLqJGdb8pGay4nzlmxEypPalLPDhg2U6KIxbasjTKS+u5qHsAm2u/Umnt3Yk/L/hMde+hal+N0
OzI=
=P47m
-----END PGP SIGNATURE-----

--------------RwO6X2hG0PGwvossowR4eaBq--
