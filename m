Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2B52344D3
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 13:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbgGaLsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 07:48:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57556 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732512AbgGaLs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 07:48:29 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596196106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TQ1Tv4NckxQYCKhK0EI+eZojGl6CAXWCJUQbd0mJQj4=;
        b=GWCKx/fUc95zdYYwQVydFqExSFOHUkTg5+yFtLjyCfsehNT8ql8h0P1WTOqhlrVeyzLexy
        vr/kU2uYQ/0zNnILMcCU7sHZBIHHoAuAS+DNvpx77IIZoKpVGfOiDbYVYFGNtqGbvfqUll
        //euFwnU0/7VPWqJLFYzpTluDTi+B+t1EzQS2RCwB/x4cjCpcoD2ZO+/pzffX5ltuFgVSC
        VsEtiK2PPtbQiLWvjOxuNphcWBIpXpULJBYF/z35LZ34UIBhRzNHebUJvr406KViMWkQGO
        KXO3WEYEHngO5c5RtMP6AuseESykO0sbNes5XiDOVisNoTq4a5hhSEe2tMS+Lg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596196106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TQ1Tv4NckxQYCKhK0EI+eZojGl6CAXWCJUQbd0mJQj4=;
        b=uB3KbJ6U7COJeSVv43Wf8fukYElxOfT3vbWfEGCKrlutgxAZvdAUi79CT1ceg8CtrM3QRQ
        VTspLvWkVlEzfjAg==
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
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
In-Reply-To: <CAK8P3a2G7YJqzwrLDnDDO3ZUtNvyBSyun=6NjY3M2KS0Wr1ubg@mail.gmail.com>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-6-kurt@linutronix.de> <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com> <87ime5ny3e.fsf@kurt> <CAK8P3a2G7YJqzwrLDnDDO3ZUtNvyBSyun=6NjY3M2KS0Wr1ubg@mail.gmail.com>
Date:   Fri, 31 Jul 2020 13:48:25 +0200
Message-ID: <87lfiz29di.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Jul 30 2020, Arnd Bergmann wrote:
> On Thu, Jul 30, 2020 at 11:41 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>> On Thu Jul 30 2020, Grygorii Strashko wrote:
>> > On 30/07/2020 11:00, Kurt Kanzenbach wrote:
>> >> +    msgtype = ptp_get_msgtype(hdr, ptp_class);
>> >> +    seqid   = be16_to_cpu(hdr->sequence_id);
>> >
>> > Is there any reason to not use "ntohs()"?
>>
>> This is just my personal preference, because I think it's more
>> readable. Internally ntohs() uses be16_to_cpu(). There's no technical
>> reason for it.
>
> I think for traditional reasons, code in net/* tends to use ntohs()
> while code in drivers/*  tends to use be16_to_cpu().
>
> In drivers/net/* the two are used roughly the same, though I guess
> one could make the argument that be16_to_cpu() would be
> more appropriate for data structures exchanged with hardware
> while ntohs() makes sense on data structures sent over the
> network.

I see, makes sense. I could simply keep it the way it was, or?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8kBQkACgkQeSpbgcuY
8KbbYQ//QWCem+UJXTJfrRfjT9qzu7KdXqGGVojU9tsHBPJ56ZIj4tOHVWxsUqqs
rnIDWUMPuhXBfW0s56XIogtkLa9Spz4Ahx6aoo0T4fou6graPfRh0aNiRe3cj1As
JkUzaHqJXEvtceVfhJNcS4mEVHlwWKR1e/P7gW2s+RXVwW/oE6eMR3bQdx8eCSk9
5HEaRpymD1Bv0WjDnyuU3OI4uxVBO/fSBQpys1aSGiJZGOf2fSQe20RxfqmM/OBT
y6DBsJH6VUp8PVZ1uo79IqkxHYdkxFUaX+u4TEuAEBVi9LQKvp9+aBVhTm2fCZJ4
qqkshYuEGSg3IQbA8L9w72IZBc9Aio8xqpPdcLUQkvbi9qB3535Ff700edjCsEZV
UTwgSyCLfHJDJ2Ew5F6DTaOgHH4Bu/Jy8JxC/WmLp5mz/GkWtaEbfMKI+yC2paCM
TZa9m3PjBatpE72Z4/4szM3WAJul4kJD/f1BAiUgLwDlDyutgV0FIxwEd/UGoZ1Z
QPpaMV4s+tILsI1y8L0lJE4PAsav10DR633qJJhCocY7f9Tz6a4eYaTpunAtI6fU
hPS7/rGT4iSgP4WvoPNExV6RRpNSBmge4FRErLd4oOUn85V34wfLtocBLSCOcmfL
A0zlPNk0fWIAPT1UsmttwLOfivAmnbT4h4t0OT4v0xT5MptvY5E=
=xEUA
-----END PGP SIGNATURE-----
--=-=-=--
