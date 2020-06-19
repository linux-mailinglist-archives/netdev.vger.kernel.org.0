Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D852C20035D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgFSIPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgFSIN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:13:26 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB37C06174E;
        Fri, 19 Jun 2020 01:13:25 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmC9L-0003ir-MM; Fri, 19 Jun 2020 10:13:23 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
In-Reply-To: <20200618084614.7ef6b35c@kicinski-fedora-PC1C0HJN>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-4-kurt@linutronix.de> <20200618084614.7ef6b35c@kicinski-fedora-PC1C0HJN>
Date:   Fri, 19 Jun 2020 10:13:22 +0200
Message-ID: <87bllfqxr1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Thu Jun 18 2020, Jakub Kicinski wrote:
> On Thu, 18 Jun 2020 08:40:23 +0200 Kurt Kanzenbach wrote:
>> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>>=20
>> The switch has internal PTP hardware clocks. Add support for it. There a=
re three
>> clocks:
>>=20
>>  * Synchronized
>>  * Syntonized
>>  * Free running
>>=20
>> Currently the synchronized clock is exported to user space which is a go=
od
>> default for the beginning. The free running clock might be exported later
>> e.g. for implementing 802.1AS-2011/2020 Time Aware Bridges (TAB). The sw=
itch
>> also supports cross time stamping for that purpose.
>>=20
>> The implementation adds support setting/getting the time as well as offs=
et and
>> frequency adjustments. However, the clock only holds a partial timeofday
>> timestamp. This is why we track the seconds completely in software (see =
overflow
>> work and last_ts).
>>=20
>> Furthermore, add the PTP multicast addresses into the FDB to forward that
>> packages only to the CPU port where they are processed by a PTP program.
>>=20
>> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>
> Please make sure each patch in the series builds cleanly with the W=3D1
> C=3D1 flags. Here we have:
>
> ../drivers/net/dsa/hirschmann/hellcreek_ptp.c: In function =C3=A2=E2=82=
=AC=CB=9C__hellcreek_ptp_clock_read=C3=A2=E2=82=AC=E2=84=A2:
> ../drivers/net/dsa/hirschmann/hellcreek_ptp.c:30:28: warning: variable =
=C3=A2=E2=82=AC=CB=9Csech=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunuse=
d-but-set-variable]
>    30 |  u16 nsl, nsh, secl, secm, sech;
>       |                            ^~~~
> ../drivers/net/dsa/hirschmann/hellcreek_ptp.c:30:22: warning: variable =
=C3=A2=E2=82=AC=CB=9Csecm=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunuse=
d-but-set-variable]
>    30 |  u16 nsl, nsh, secl, secm, sech;
>       |                      ^~~~
> ../drivers/net/dsa/hirschmann/hellcreek_ptp.c:30:16: warning: variable =
=C3=A2=E2=82=AC=CB=9Csecl=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunuse=
d-but-set-variable]
>    30 |  u16 nsl, nsh, secl, secm, sech;
>       |                ^~~~
>
> Next patch adds a few more.

Sorry, I did test with C=3D1 only. I'll fix it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7sc6IACgkQeSpbgcuY
8Kab/g//bnuFMwcRYTeeq+oslsXbELr8IchBtrL9xstckxXlqpzjmto23W4hbQik
FnpQG+RCeLoE9SiVR9b2KL8ei2zX0uCU/lT5Vq75HycMJoCOuiN27FvuJx3QSVGz
ph/dU6gl1ZZS44vIGMm351MSQX6DRMhm4pXzG9Fmk2Sent2h69gYtHDj/OPFnvze
+625SHxqH+6lDSYTqc7Es/TavKRrLBivlgr6rqm6SVwHUR1pOBACxxjqIHHPionl
hmha5Inzxuy7Qcwi7f1ocaHzq5F4enEtjtr8WbrxoOV6+vRTGQMLcJeO3ixnJtx9
TmHFRgwFkzjzMw1+an3Qn4aKXrB00eIRtQQp7Vdqrg3qFOhrxiZ8iepS5lsahgD6
7HAY9vmZ8OWEwaMEtiR5SBZwbwejRU6RLeyPKnfg/FeJ/nsEQ327O36Uinw6hY2O
jQzI87jmpAO+AE+SPgZjalHw7fnI8GtoGkogkdWdQ1NIGCyfJpH6ewzEVxUob8Ql
/SWeT9tdYWvEYtWvaZ6ovcLhFI5rSbbtIw825buIFDTy2k4pmzYmU17/+DsjI2Jn
8C4GTew37u8g0k/196LHjjgOdYqABqXf0ilYW9bkeu7cIxwG+NnQ7qd+FTuDfmjg
8QncvcSu5LthzwWqWcCQRe3r0rVDX5HPovBoU0s3wKdBz4/Euds=
=7JQD
-----END PGP SIGNATURE-----
--=-=-=--
