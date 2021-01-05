Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A56E2EA927
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbhAEKtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbhAEKtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:49:03 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C9CC061794;
        Tue,  5 Jan 2021 02:48:23 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id t8so27769681iov.8;
        Tue, 05 Jan 2021 02:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=f7IHiDEWjSHm9FI3W8jx+UQ9X1MEsxwuqh4KdUyRC2w=;
        b=H8WcjQs0Qs0BLnlHEB4QdW5YniI+JWJkjRE+GguZFV5zQ5b2vUzoMnqCuiLQzb7XRw
         1aoogupqG9sq8j8mc3PqDp2dd3qtUsU449LTaN1jNHOpami80u06GcHysJu+3xAQ43X5
         H5KTn5aCZfxXEoB4Aw1IzCbPBF/I0H5bExfUPGOSwmzYw6S4qCTDiujgcbCD7Ac/VrA0
         dG45rtjQHjcaezxB1cZmJNViagqC+BUay7Jt6DUDd+HgKkeqx2DxWyfzwAQX604/Kbik
         dyFpBKfKXIhf+5oSSp84capojB9Z+CYpF0awqu43eUxZg4F/0h20XbJCugOUCuN2c4Kk
         8X+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=f7IHiDEWjSHm9FI3W8jx+UQ9X1MEsxwuqh4KdUyRC2w=;
        b=EUS7o7WBR6TWJ/N6ptUSYGerxJXsrCUiB0IuYh6Da81bmsVoGelyyXqdL7XhGGW7ud
         lXE52ZiIGrZH4zQ9OZWbvwRQtatARzKstkXObByqvA/sufwiXs9h/Poy+9qP8rRn7nmn
         dScU59iBTJzVUN8ywOMmpUBZ8pVceIHz7NHv7z1G/hn0OQICRtlAuz/1onNx4coioKuR
         NIOy4j6rB3jMHN8pGp8DnlzmmC/d4AI7TwoMxjkqN766eosbo4dEJov5nFcK/vPdGOBa
         WvulD5bpqz0ChM4Unt7JvJgjZzFD/Sl7XUBqY750MYaeisw3Hy/EJCbs/nLae5Xha2aN
         qeNg==
X-Gm-Message-State: AOAM531lKNlNfUFmVddxisFefMvAefddB04DpepY322DjfBFQ5Ht61h8
        P5u7E8odKlMbhmbaBa2q5ps=
X-Google-Smtp-Source: ABdhPJwchgv/SEHmnGLoaLlm5nHLvtL7vVMU6w3sJOuAV6wVin9zM+GAfRb8qs3CDw/AavgLb+c+MQ==
X-Received: by 2002:a6b:1451:: with SMTP id 78mr63096028iou.102.1609843702489;
        Tue, 05 Jan 2021 02:48:22 -0800 (PST)
Received: from Gentoo ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id r3sm42612152ilt.76.2021.01.05.02.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:48:21 -0800 (PST)
Date:   Tue, 5 Jan 2021 16:18:30 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
Message-ID: <X/RD/pll4UoRJG0w@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, zhengbin13@huawei.com,
        baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
 <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mxo3TOh/lWoLSvis"
Content-Disposition: inline
In-Reply-To: <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mxo3TOh/lWoLSvis
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 21:33 Tue 05 Jan 2021, Julian Calaby wrote:
>Hi Bhaskar,
>
>On Tue, Jan 5, 2021 at 9:19 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>>
>> s/defautly/de-faulty/p
>>
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> index c948dafa0c80..7d02d8abb4eb 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> @@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
>>         u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);
>>
>>         /*beacon packet will only use the first
>> -        *descriptor defautly,and the own may not
>> +        *descriptor de-faulty,and the own may not
>
>Really? "de-faultly" isn't any better than "defaultly" and in fact
>it's even worse as it breaks up the word "default".
>
hey, it was written as "defautly" ...and that was simple spelling mistake ..
so,corrected it.

>This change doesn't make sense and the comment really needs to be
>completely re-written by someone who understands what's going on here
>as it barely makes sense.
>
>Thanks,
>
>--
>Julian Calaby
>
>Email: julian.calaby@gmail.com
>Profile: http://www.google.com/profiles/julian.calaby/

--mxo3TOh/lWoLSvis
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl/0Q/sACgkQsjqdtxFL
KRVnggf+LI5YVDBgYgJa2h+GqRVOCTfIbH6pFoe8xBfO0OMeDyHWxcOMxuk5L4Zo
7+Ty8UBg4wbCApOe/7afVYIxB9IRbdhMZlQX/qxIZu3Q31uOBWh5XcsPMSaZKwAx
OiO2E8sKE0watERCUgMh12vxdcdIq8wJQvGrbo1Q1s1p/eAIRyixAtlS4/zD1XeT
XvqO5S5AhyixkLOb9QoLzMX6pBYZOKPWPiCWdiNJBqIv2/uCTHY97Q0ioMXbTpTT
do0KU4ftKqGAfv8I5V4vC2xk5IS/KIHHFW5P6FnduI025jOFJCzYT6JupCR/ZXCh
y9angUSSckQ9mBnrgIc4XSFfQaAbBA==
=LLZj
-----END PGP SIGNATURE-----

--mxo3TOh/lWoLSvis--
