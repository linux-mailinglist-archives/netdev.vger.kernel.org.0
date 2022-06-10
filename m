Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B3C546C6C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347459AbiFJSeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343749AbiFJSeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:34:17 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE943A197;
        Fri, 10 Jun 2022 11:34:14 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w20so22463140lfa.11;
        Fri, 10 Jun 2022 11:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=Td0R3t3stlrFuoc5AD+N+ZRTByfJv4rsuycWaw56p1A=;
        b=M+O7c6wAz/QAnC/nmDukd2XfS0R5V4AvIm5kzNQT53taxzhFLV1F+pWsMzgSgqQ95a
         qbjQym1THJ1I0q8jMCBVbdVEG9OTZIabCbuAdvE/Dk2rg16ahpmMR6Bb08g10PGeNBdP
         /OJfOyV4io52v1ga4dwyp2/q5fJ6WBsSoFfPDLHURt7nvYU2ngFyoXdZwUidIpCnpZtb
         id2Cp+/in12c0G7ahbnN772VJmqOePiFnt18ilgy2+1o+4qhMLADzcqcaHqyUNtlSu89
         w8M3uiKudxdNF7BOa5uQMbQLCWOBKw6YX/g/HDwW9YakAQjQ1WhKsNlA8SA8AR3llb8k
         vGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=Td0R3t3stlrFuoc5AD+N+ZRTByfJv4rsuycWaw56p1A=;
        b=AKn1aLTii7hxDkhU2c7FuXb+VI1OQNQ4wONMDpk/Juop6IAg5BtqBkiYYHOsdhEQZ8
         wwSpCB2iGkMwCgrGsrwuO0RwS/uCvmcQPw5lrOBu0vHpug8Xb9cVrRv8PduVkZtQZx7D
         sU+ySUhIKXD2KDXosqQkTO3yCdeYged4LRIIVTyi99tnt6lNhElGkbVit0aZ4F2M0uwO
         i8/rizGXZ8DKd6dmY6ja9QmIdkGc2MpDbdy6rO5GjPk0V7spOnoWlU8XG/hldQAipfur
         TPBj2Oe09ppRaqi6yTARhDsmcsOuH8lIjVQDLDkrKLofc3+tHYWXE1kX5WB9jmPfrcrZ
         UlQw==
X-Gm-Message-State: AOAM532NMwKNyGwTJZadfZCMdJv5L2RSSSCU7LVewMOOTFq4ddVeOCj9
        Rhjql6U4OMpg1d6zFBak2Rk=
X-Google-Smtp-Source: ABdhPJwxvZ9XQIg92Xshrx1HI7I0JfdZk6TXoKpXyZAZ0ZTw8pU1Kk6BQTgobVBGC8foyBO8yqXU5A==
X-Received: by 2002:a05:6512:1512:b0:478:c2b5:188f with SMTP id bq18-20020a056512151200b00478c2b5188fmr48985464lfb.501.1654886052830;
        Fri, 10 Jun 2022 11:34:12 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.27])
        by smtp.gmail.com with ESMTPSA id r10-20020a2e8e2a000000b0024f3d1daee3sm12706ljk.107.2022.06.10.11.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 11:34:12 -0700 (PDT)
Message-ID: <dabcbe61-5d77-7290-efd5-3fe71ca60640@gmail.com>
Date:   Fri, 10 Jun 2022 21:34:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Takashi Iwai <tiwai@suse.de>
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, senthilkumar@atheros.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
 <87bkv0vg2p.wl-tiwai@suse.de> <87r13w2wxq.fsf@toke.dk>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <87r13w2wxq.fsf@toke.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0jB3p0Ve8i8IMP2RDfqvdeBm"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0jB3p0Ve8i8IMP2RDfqvdeBm
Content-Type: multipart/mixed; boundary="------------Q08vFIqJReFpWrj32M55SHWr";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
 Takashi Iwai <tiwai@suse.de>
Cc: kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, senthilkumar@atheros.com, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+03110230a11411024147@syzkaller.appspotmail.com,
 syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Message-ID: <dabcbe61-5d77-7290-efd5-3fe71ca60640@gmail.com>
Subject: Re: [PATCH v5 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
 <87bkv0vg2p.wl-tiwai@suse.de> <87r13w2wxq.fsf@toke.dk>
In-Reply-To: <87r13w2wxq.fsf@toke.dk>

--------------Q08vFIqJReFpWrj32M55SHWr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgVG9rZSwNCg0KT24gNi8xMC8yMiAyMTozMCwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu
IHdyb3RlOg0KPiANCj4gSW4gZ2VuZXJhbCwgaWYgYSBwYXRjaCBpcyBtYXJrZWQgYXMgImNo
YW5nZXMgcmVxdWVzdGVkIiwgdGhlIHJpZ2h0IHRoaW5nDQo+IHRvIGRvIGlzIHRvIGJ1ZyB0
aGUgc3VibWl0dGVyIHRvIHJlc3VibWl0LiBXaGljaCBJIGd1ZXNzIHlvdSBqdXN0IGRpZCwN
Cj4gc28gaG9wZWZ1bGx5IHdlJ2xsIGdldCBhbiB1cGRhdGUgc29vbiA6KQ0KPiANCg0KDQpJ
IGFncmVlIGhlcmUuIFRoZSBidWlsZCBmaXggaXMgdHJpdmlhbCwgSSBqdXN0IHdhbnRlZCB0
byByZXBseSB0byBIaWxsZiANCmxpa2UgMiB3ZWVrcyBhZ28sIGJ1dCBhbiBlbWFpbCBnb3Qg
bG9zdCBpbiBteSBpbmJveC4NCg0KU28sIGkgZG9uJ3Qga25vdyB3aGF0IGlzIGNvcnJlY3Qg
dGhpbmcgdG8gZG8gcm46IHdhaXQgZm9yIEhpbGxmJ3MgcmVwbHkgDQpvciB0byBxdWlja2x5
IHJlc3BpbiB3aXRoIGJ1aWxkIGVycm9yIGFkZHJlc3NlZD8NCg0KDQoNCg0KV2l0aCByZWdh
cmRzLA0KUGF2ZWwgU2tyaXBraW4NCg==

--------------Q08vFIqJReFpWrj32M55SHWr--

--------------0jB3p0Ve8i8IMP2RDfqvdeBm
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmKjjqMFAwAAAAAACgkQbk1w61LbBA0U
LQ/9EJQFm18B4dJUuICPKFDPWSyhvOMElEKNioz2RBEUEDvb1Isp0+LCmG2fGNHSzia45QGzmXkK
C0YXapWCZNiQMxEwDOdfk2TeQeaf4Dm6d9BWi5YttJ0TVdiSKR/YxrG2banIrn0S4fgv8szfLVT0
G9lxPrTwuZOVQpmIjNkSFcZQFzVIPwCQpMfjucZZpPYlvq/BY7goo3zgdM1OJKKFWgpT39n9K0T+
/j7sjP+UujuIc2UPBAH2lCINLA5T8xJar+Qf4fb2gahWoeguXvyLjX+BTpVdfDvi4T/cVWOth/I2
wdnUgBchZrn5QB6Cq/1F2TZ6WBaLOdbKdH+muOz+DcVJdaMR1HtCazSTZ101f7jA7+9FeGBDx4HN
YZIItcDHv8zi9QWwelFp8FwvHuwQ0gn7z67/RxqqpZfhz40J392LiAPCQ2/qSe++Jmx+8bIRQ/Z7
Au2mAUITYE+f/1MSDSewQDS8akUZKsT3zXGyMGfKMV9l0H/utOfYUU3p8gYQD/7qCx8yd/iMU8li
3FNjDNQ6r57wE94OTfeamnN244kDzWWuKfvgUHh092TaY4fQPVoeUThWe0zDjKd4I8OkNj4dmZBi
rne0lPTdaSe+2VeA2hmgwQGzFhtGSuhL0nPGVUJUgO/1nms3azvcDJcd7Jw0UzfZtitJb5T20v+Z
vJE=
=Dvpf
-----END PGP SIGNATURE-----

--------------0jB3p0Ve8i8IMP2RDfqvdeBm--
