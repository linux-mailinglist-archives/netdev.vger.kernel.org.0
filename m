Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30273251B31
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHYOsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:48:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50514 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHYOs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 10:48:27 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598366904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NhozcRiSk9TRKJ8CHvRx3nzWReQ8VTKS10wrtlWnEGk=;
        b=ONPRsiCldQS7HOmEvqU3RKKeLSuRti974gBs3kojojhxyaZZR6unKHyUITbqa1jM2WlKOS
        3u8E6RnYzkLvm+mNUPi4KgbSq2VE+3Qej61gEgL2bjaCKg+ecHiVr8NKLyv+zXdAochg//
        D3U93KF1JogMKVqTpmgKlDrP1PQ/2+47j2E6uc9hGG5J+yW/l8eREr/yW0Nk4MkDHmpwqf
        9yqingX1xMd+Ko1gDRRgxritgfh+FfdfEebBCwQ6/KyRYe7OktfshOSYJIPbQy+3amQBN6
        PFW2rVTYnntgPkYQImtEHxpIGUKerz5Ni8MXYLp4i/eS5j6l1DTg2mxGf/nUHw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598366904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NhozcRiSk9TRKJ8CHvRx3nzWReQ8VTKS10wrtlWnEGk=;
        b=evMqEEGKL2gESegLl4cXb3HFIl61x3E0NCF/WSZmYE3DEnEwzDBx9K7NH04DMGzGKXhNZb
        wmCRnQE5P3hBz2DQ==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200825135615.GR2588906@lunn.ch>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-3-kurt@linutronix.de> <20200824224450.GK2403519@lunn.ch> <87eenv14bt.fsf@kurt> <20200825135615.GR2588906@lunn.ch>
Date:   Tue, 25 Aug 2020 16:48:19 +0200
Message-ID: <87h7sqzsr0.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Aug 25 2020, Andrew Lunn wrote:
> I agree with the check here. The question is about the compatible
> string. Should there be a more specific compatible string as well as
> the generic one?
>
> There have been a few discussions about how the Marvell DSA driver
> does its compatible string. The compatible string tells you where to
> find the ID register, not what value to expect in the ID register. The
> ID register can currently be in one of three different locations. Do
> all current and future Hellcreak devices have the same value for
> HR_MODID_C?  If not, now is a good time to add a more specific
> compatible string to tell you where to find the ID register.
>
>> My plan was to extend this when I have access to other
>> revisions. There will be a SPI variant as well. But, I didn't want to
>> implement it without the ability to test it.
>
> Does the SPI variant use the same value for HR_MODID_C?  Maybe you
> need a different compatible, maybe not, depending on how the driver is
> structured.
>
> The compatible string is part of the ABI. So thinking about it a bit
> now can make things easier later. I just want to make sure you have
> thought about this.

I totally agree. The Marvell solution seems to work. For all current
devices the module ID is located at 0x00. Depending on the chip ID the
different properties can be configured later. The SPI variant will have
a different module ID. Anyhow, I'll ask how this will be handled for
future devices and in general.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9FJLMACgkQeSpbgcuY
8KZEgQ/5AfTcP1BkSGUoLEuxLDEgpD39SvhIEFQS4oTudWmbT80W+UnSbGM39DpX
4hY1tAMnq13jd9v2QQHSteCNPZ3ODKWs0/Oa4LoE1+019jSkmFDG3ZThTi8evr9+
+kcnDJ8SpQxLb5KfHQrZJtj7tdxjFySP40arQI3W7kqOXHA+jxOOglM6VcJF1oR2
00SUzrLxK2kupnsg+OJ0CktCyFGymlCG2aHYIcopAqebUCyXTwO4BCiSwTzIuD3+
cD2oN8eXnEdbb+t14xPBFOzaxZupdRl31QRQ3z0WoJ+Bswh4nm6qIIxGEEzCzczI
2CLvn5mwtHlVWTwxId3tQS4L9h/jUKx2jXKJ93N1sW83suqW5vEH7VOUxI9haoHm
EcIzZYEmESEAseve3PxVzZnnXZ+3E883TwJEOtbyO4eqn0sbCn5o50+VPYm/0h3p
SO09xU+OMC80LiotFeJ2nWTaH69ZHZaZod+83g/yBFrZZd3NO0t6W8PrBZZ4rQ36
aWH0cn/mbyAHZLMd9nxVAwcfZMcx19VbdI8iUAKkl0wp1StXXLC7LsBWCjONDltp
cQDtE+MqLnouBBRtCov7o5U/ektg/PzOjZBtBURZ2ZP6Fzib+3N4dMPr1kuBmsVV
KTlC+sFWuuCAVFywtFAoJ3bSORQ8FHlw75RX7/2i4+e7g2GW0RE=
=BCe/
-----END PGP SIGNATURE-----
--=-=-=--
