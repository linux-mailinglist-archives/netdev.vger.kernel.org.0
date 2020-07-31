Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741A62346A1
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgGaNKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:10:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58096 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgGaNKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:10:40 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596201037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zQ5kBwM5xQDpE3NsvWngxm6+pmYV38KeE5k+EsafdTo=;
        b=a+nu0e9nEYaJe8hYruXDfUCquEupcU3saiCnrUmuLLdqwkkIHGvff6OWcCFf4K6Djrhhv7
        1Se0kl7aTw6d2bYpQC4SCr+LvZ9/u9LaPCKdX0CtFNyONxvgFw7UcopxV9XPfvrLH88opx
        MCdH7oSkzpuKLYLwVMGpXNdeNX/nhdZBKpEoXlAoPChZ/kVWyboAIlIIuoWqd0Z3fPN7FU
        VN5g/CzhnhWkp1T/RUOKvPc8T7Qr3oIpvjPvhtBXZbCygcgEugcN4Yj0/FHCMphaYcT746
        n34Kj4yBwLHwxZc33ZjT0N3V4NeKkgTL2HJ9Yz3xA214EXZx/aT4XqHjKeMP3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596201037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zQ5kBwM5xQDpE3NsvWngxm6+pmYV38KeE5k+EsafdTo=;
        b=Y6LeKWV7Tm75A8hwiyO4d/hAL9+zyYfvREI1L0eT3pEItNWM0h3UrHru4umqkTxOtT0klC
        fjcNHjsCWXYKlhCw==
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v3 5/9] ethernet: ti: am65-cpts: Use generic helper function
In-Reply-To: <f30d3a4f-6cf3-1d46-397e-baa27b3c8ade@ti.com>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-6-kurt@linutronix.de> <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com> <87ime5ny3e.fsf@kurt> <CAK8P3a2G7YJqzwrLDnDDO3ZUtNvyBSyun=6NjY3M2KS0Wr1ubg@mail.gmail.com> <87lfiz29di.fsf@kurt> <f30d3a4f-6cf3-1d46-397e-baa27b3c8ade@ti.com>
Date:   Fri, 31 Jul 2020 15:10:35 +0200
Message-ID: <87ime325kk.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri Jul 31 2020, Grygorii Strashko wrote:
> On 31/07/2020 14:48, Kurt Kanzenbach wrote:
>> On Thu Jul 30 2020, Arnd Bergmann wrote:
>>> On Thu, Jul 30, 2020 at 11:41 AM Kurt Kanzenbach <kurt@linutronix.de> w=
rote:
>>>> On Thu Jul 30 2020, Grygorii Strashko wrote:
>>>>> On 30/07/2020 11:00, Kurt Kanzenbach wrote:
>>>>>> +    msgtype =3D ptp_get_msgtype(hdr, ptp_class);
>>>>>> +    seqid   =3D be16_to_cpu(hdr->sequence_id);
>>>>>
>>>>> Is there any reason to not use "ntohs()"?
>>>>
>>>> This is just my personal preference, because I think it's more
>>>> readable. Internally ntohs() uses be16_to_cpu(). There's no technical
>>>> reason for it.
>>>
>>> I think for traditional reasons, code in net/* tends to use ntohs()
>>> while code in drivers/*  tends to use be16_to_cpu().
>>>
>>> In drivers/net/* the two are used roughly the same, though I guess
>>> one could make the argument that be16_to_cpu() would be
>>> more appropriate for data structures exchanged with hardware
>>> while ntohs() makes sense on data structures sent over the
>>> network.
>>=20
>> I see, makes sense. I could simply keep it the way it was, or?
>
>   I prefer ntohs() as this packet data.

OK. I'll change it in the next iteration.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8kGEsACgkQeSpbgcuY
8Kbw4A//cIz6aLHyGaPMeOOk9gT1qO3MpQFmGqIUViE1SHKR8VxzDH49UTchUBUM
TrYZY1qwpaSDQ1959lnSqIT8rqQ/MrWVpwmqeOqgfXB0qTEYMXuEAhrhZ2PJ9nNO
7aYRg9/4HSrAzx/fyW+kaCiW4tBNw9zKKhyCLwzj9rOhnqAyALRY3EsZzMW7inHH
kAXODyJS3tkF8bbJ7392SEii8VRB6vwYRHRVicIYFtRyFZL83czpfBuv0gZEU3pU
k6FYVt7C6Udj+x7m3cFFQNgvujl0q19oDyEi7DkFGc0741lLwTrMQ/S3UREaTIwR
AvO+7wFO/TnVL5WyI2qalKtShatGkRSo0emgTVqD8fHamuVijK1Tek4eNyRSn167
VOPE1Jpk0NIOw9jD4sRHFq76Va1+LoApQZXLRQfuyP/NLOlnBxlfi2NB8qGW+NoB
OrUmQ05F3Vz+Wfc1/g1WhHp083c1tYn3MnzGL8zkPKuDtiMdhsDXjp9sQib80lVn
PzluX9N/XXYFHD9q8mAMuiDK768h0Zj+nYGRudTICr1F5cQQMy3vywlwv0lC51/+
0OBLkdhc+z+Sm0+FuVPT7ihDoILyTaB8xMt+qYo9ver5Bf90oEGrBIoo5GEQbOTZ
BAbPVSPRQ3EMV+kgiXvP01RvyKKuDU5lDeW+bZfhIDJA5i0m9Rg=
=4FMy
-----END PGP SIGNATURE-----
--=-=-=--
