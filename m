Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0EE2494C7
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHSGA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgHSGA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:00:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A19CC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 23:00:57 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597816855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Su9AzmrEvGIiIk6KMVGf8fs5CVs2iz8ru9IP2bPyigA=;
        b=ImtWz7KSODD9QE3kf9T2FsMIradLZ9p63SwQXNCDgxTb2fNbUZOXX/7KcLvtZOOC7yip1p
        tAkT9D13FvF//Jl1o83VhFPq6VQBxzVlxJqcCyG2VucPFDLqik3N5bVomFSSaCE9BWQ8kz
        3G1E6SCW/dNXKOSAlNbf/WrFGua+MWp6ruXZAxPky6zy3+XgBjvxTGFOQt1kxFa0JCODrF
        da89FjhbcvFYM+RBRPlUjI1ueIISUR9GsCl+Y6/tFePuEnkE2wzY5imEBV+4KKlKp7Pqzg
        U9Xv+WQaMp6BGrS66nMbaga9Sfsq5MTPwFItZPitOz7ra1Pj1aZ9Q1CuAPSjUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597816855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Su9AzmrEvGIiIk6KMVGf8fs5CVs2iz8ru9IP2bPyigA=;
        b=l0HKVQhxOus3pQYxX5lGYwI80S+j7XhUcXRhwD1eLuFo77+lTOFpiN8IaTN+2tFleUcqLu
        kDQ7slKrKgZTJBAQ==
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v4 3/9] net: dsa: mv88e6xxx: Use generic helper function
In-Reply-To: <20200818104305.GB1551@shell.armlinux.org.uk>
References: <20200818103251.20421-1-kurt@linutronix.de> <20200818103251.20421-4-kurt@linutronix.de> <20200818104305.GB1551@shell.armlinux.org.uk>
Date:   Wed, 19 Aug 2020 08:00:54 +0200
Message-ID: <87imdfb2eh.fsf@kurt>
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

On Tue Aug 18 2020, Russell King - ARM Linux admin wrote:
> On Tue, Aug 18, 2020 at 12:32:45PM +0200, Kurt Kanzenbach wrote:
>> -static int is_pdelay_resp(u8 *msgtype)
>> +static int is_pdelay_resp(const struct ptp_header *hdr)
>>  {
>> -	return (*msgtype & 0xf) =3D=3D 3;
>> +	return (hdr->tsmt & 0xf) =3D=3D 3;
>
> Forgive my ignorance about PTPv1, but does PTPv1 have these as well?

pdelay is PTP v2 specific.=20

> Is there a reason not to use the helper introduced in patch 2 here?

Yes, it doesn't have to be. This driver only deals with PTP v2.

> Should we have definitions for the message types?

That is something one can think of. At the moment there are not many
users though.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl88wBYACgkQeSpbgcuY
8Ka63BAA1qjU8ZbyxLNimAvI2wOCwKlgyP0jQs6dWFCEgXhC2whZAaGSvD9X9HQL
kI5pxd3a4RVK6QjDqMU+uvhbD3deDaJ1XC5Niku2iE7TLCbC3Aos/c7RjEKRNXWk
iRLlCKHnnLHXALHpVTet9Yi1GlkmRusARzkQXynYP1iH7WZfRknqsQUzuPU2X8fC
dcoHd/JaJXf6nuhrzlQfMGIJhx2humhPO5807ELtnBmN91gXenjyxMYIFEj5LP1E
BwcTDZl85UpZ6aNutkToz5e9la8UjEHM5ACZO45EqPGM/XvNtwQp0lMMkT5/4VrE
SLlbhz0pOX9AqRFz5sYgG2E7TM1jXxTYDN/u9awPqBsoyoaL+ARHzsb9Uw2G9rGW
QzGxwIFDa46SDNAX1934kJ4qJRYyVwPAKCg43UFxsjnvjomNVP6C+X10gzXoCAEn
AiNdr/s4Ap6JMUWMC40e4i83HiSQzRJni67bwVNiBLAbQHofi9LBK8F+WQPhMY/Y
02XyiLSLADN4omFO+qXqyVEtO11RVs78OvX3oNpMQoGg2eI6BLO8qQKSoHswtVs0
9wPeXvOQQvwOvyl3KPn4atvK8tBKDMciffUNzYBt6J1zPmNZnD1WfYaub/eOQgfn
5VgFXeIYL6AGoEP1Xl/njwGBR9vAOYAJR0a1zQfcK7zniKB88WE=
=4oYX
-----END PGP SIGNATURE-----
--=-=-=--
