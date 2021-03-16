Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D405E33D006
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhCPIil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbhCPIiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:38:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71499C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:38:16 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615883894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m6XjI+1nW46nBLw7Ru2pcu2XzMQqn6lEhRibvsJPPsI=;
        b=AOuZyokPlWLcwXa+Nu1NFhuZj6EzSN8cK+FoUtHh6PlSz6o7ORF2lqJBfAqMsj2KRoRhRo
        w47tsNZvZs/x6Q1br9L7Is6a6Oqu1fi5RZvkXgW2N7/8L8J/gDAotD9TuWw47eXFNgVUS7
        0ulNCaTjO8akTQIcPt8A9FvZ4VGrSMxJ7vsUhgOOGg/7AkG1GO7NtG3xgWw6kcW2Bdolsk
        wMQ+cP23HfjYQ9FyJO9unxcuxWkIIFaXBic7yIXJhRTTbCs5WnQogUxdNMyXj4sNfIoPNR
        +Gd+xpLFEsp7kpf43LMXtFd8My6LZVJszq1Z4ysXLT84V9J/Qh1hMecRaZn7rQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615883894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m6XjI+1nW46nBLw7Ru2pcu2XzMQqn6lEhRibvsJPPsI=;
        b=ox+G2mEzZcaxuEifRXvVvnpLqtc3QGsDtuzjPQ4puqyiqm3Ocun+41QIHT/k5XCVXbUGDI
        cedc9ckgbo/BGPAw==
To:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Offload bridge port flags
In-Reply-To: <20210315213413.k4td2urqxl2sqflg@skbuf>
References: <20210314125208.17378-1-kurt@kmk-computers.de> <20210315200813.5ibjembguad2qnk7@skbuf> <87lfao88d3.fsf@kmk-computers.de> <20210315213413.k4td2urqxl2sqflg@skbuf>
Date:   Tue, 16 Mar 2021 09:38:04 +0100
Message-ID: <87r1kfmr2r.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Mar 15 2021, Vladimir Oltean wrote:
> On Mon, Mar 15, 2021 at 09:33:44PM +0100, Kurt Kanzenbach wrote:
>> On Mon Mar 15 2021, Vladimir Oltean wrote:
>> > On Sun, Mar 14, 2021 at 01:52:08PM +0100, Kurt Kanzenbach wrote:
>> >> +	if (enable)
>> >> +		val &=3D ~HR_PTCFG_UUC_FLT;
>> >> +	else
>> >> +		val |=3D HR_PTCFG_UUC_FLT;
>> >
>> > What does 'unknown unicast filtering' mean/do, exactly?
>> > The semantics of BR_FLOOD are on egress: all unicast packets with an
>> > unknown destination that are received on ports from this bridging doma=
in
>> > can be flooded towards port X if that port has flooding enabled.
>> > When I hear "filtering", I imagine an ingress setting, am I wrong?
>>=20
>> It means that frames without matching fdb entries towards this port are
>> discarded.
>
> The phrasing is still not crystal clear, sorry.
> You have a switch with 2 user ports, lan0 and lan1, and one CPU port.
> lan0 and lan1 are under br0. lan0 has 'unknown unicast filtering'
> disabled, lan1 has it enabled, and the CPU port has it disabled.
> You receive a packet from lan0 towards an unknown unicast destination.
> Is the packet discarded or is it sent to the CPU port?

It's sent to the CPU port. Anyway, I'll double check it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmBQbmwACgkQeSpbgcuY
8KZBvg/+J8RP8O8ToBT5qWTlqZhH2KTAUOTv8JzQO8mjrIdtK4uQtrop0rvR0lxS
8DCaUu9V4Ca7zIa5XJileO0UxA8k7hUomtRyp9taoGhhlAZaX6EBqGT9eHyMFE6z
bnktgwGr0GwTFQIJxVoKz35U88kNHF1GazKVNQZ46uSmVKU6z8CPSCG60hQ1cwLQ
2e954rk+siGwVnr42uHQQKswdCcl/UnSrsyUZYQ4nJYtDqfKWKULuvTuH5JZZgwT
wmAQTv+418uYL/a6HdJBb9ohtYR94BDeIZw0/qj30+CAEpttsnn9hcZpBZYAukB2
mk6LQWVJFvpeiGMXKh6UTCcTW/srFCWGoy+2EspIhDc9CpbN/kmsgs9ATGwPOYrr
gOPdLTibU8sLQPDn46ChsfEXq1lyMEds0BfHWLLGsCoOxogmuX7KF8p9u6sKH81X
cvx/4B6XWfP8LZBSfYzI16yVobyZEx/GCk8n66e+bBpM8b9Qd7fhAUI2MRltteRX
X0uEm5dLtrIHMKTPZrVodQ3jxhL+VRe4DBp2h31Qnh8iV8MR3wUspblTP3FsAtLm
7/L5ALVwCwdDAZotNgZSuAcOkaV0dhlwWBKFZIzFS7wU7QL987cJYbJxUglGigqj
JXtm6Tx9aEaFF/sJy5tEpUjMgqYFt2x7g+4Z/PJdxrgDdzGicnI=
=r8wR
-----END PGP SIGNATURE-----
--=-=-=--
