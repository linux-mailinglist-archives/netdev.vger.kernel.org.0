Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133672953CF
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505713AbgJUVES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:04:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505706AbgJUVER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603314254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0YUWo4bZCexSnwTeOfkLwPeIOKqXO7B7hpyZe6AULyI=;
        b=RdC9nW+lvSJwcVcGLdZqvJdndegSrQtuzfEm96Nq/giY/TuoMZ8x1CwQG5VY47oR0QLS00
        03BdwLVSOmAN3TevqxNp0z4ONeRj2EUvdvzOU7SyuPBaCTrZG7H2VNMzFyGawDAnazD4Qz
        7JYH6aNCG0WAOixl3HYnO+4Y8a4uR8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-Hc3Fxz0DPIG6xn3tdr7GgA-1; Wed, 21 Oct 2020 17:04:12 -0400
X-MC-Unique: Hc3Fxz0DPIG6xn3tdr7GgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74FC9800050;
        Wed, 21 Oct 2020 21:04:09 +0000 (UTC)
Received: from [10.10.115.73] (ovpn-115-73.rdu2.redhat.com [10.10.115.73])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 993DB5C1C7;
        Wed, 21 Oct 2020 21:04:03 +0000 (UTC)
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Dave Miller <davem@davemloft.net>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <87v9f57zjf.fsf@nanos.tec.linutronix.de>
 <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
 <87lfg093fo.fsf@nanos.tec.linutronix.de>
 <877drj72cz.fsf@nanos.tec.linutronix.de>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <9fa39be6-45ab-01a6-86b0-b077f368f4cf@redhat.com>
Date:   Wed, 21 Oct 2020 17:04:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <877drj72cz.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="19tJzs4pDB5hORMaKvDJ8V6aBKOyjfvgw"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--19tJzs4pDB5hORMaKvDJ8V6aBKOyjfvgw
Content-Type: multipart/mixed; boundary="fpjpftGGct6Kgqold4nIRFi6tHAQ5oppN"

--fpjpftGGct6Kgqold4nIRFi6tHAQ5oppN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/21/20 4:25 PM, Thomas Gleixner wrote:
> On Tue, Oct 20 2020 at 20:07, Thomas Gleixner wrote:
>> On Tue, Oct 20 2020 at 12:18, Nitesh Narayan Lal wrote:
>>> However, IMHO we would still need a logic to prevent the devices from
>>> creating excess vectors.
>> Managed interrupts are preventing exactly that by pinning the interrupts
>> and queues to one or a set of CPUs, which prevents vector exhaustion on
>> CPU hotplug.
>>
>> Non-managed, yes that is and always was a problem. One of the reasons
>> why managed interrupts exist.
> But why is this only a problem for isolation? The very same problem
> exists vs. CPU hotplug and therefore hibernation.
>
> On x86 we have at max. 204 vectors available for device interrupts per
> CPU. So assumed the only device interrupt in use is networking then any
> machine which has more than 204 network interrupts (queues, aux ...)
> active will prevent the machine from hibernation.

Yes, that is indeed the case.

>
> Aside of that it's silly to have multiple queues targeted at a single
> CPU in case of hotplug. And that's not a theoretical problem.  Some
> power management schemes shut down sockets when the utilization of a
> system is low enough, e.g. outside of working hours.
>
> The whole point of multi-queue is to have locality so that traffic from
> a CPU goes through the CPU local queue. What's the point of having two
> or more queues on a CPU in case of hotplug?
>
> The right answer to this is to utilize managed interrupts and have
> according logic in your network driver to handle CPU hotplug. When a CPU
> goes down, then the queue which is associated to that CPU is quiesced
> and the interrupt core shuts down the relevant interrupt instead of
> moving it to an online CPU (which causes the whole vector exhaustion
> problem on x86). When the CPU comes online again, then the interrupt is
> reenabled in the core and the driver reactivates the queue.

IIRC then i40e does have something like that where it suspends all IRQs
before hibernation and restores them when the CPU is back online.

I am not particularly sure about the other drivers.

This brings me to another discussion that Peter initiated that is to
perform the proposed restriction without any condition for all non-managed
IRQs.

Something on the lines:

+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!pci_is_managed(dev))
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 max_vecs =3D clamp(hk_cpus, min_vecs, max_vecs);


I am not particularly sure about this because I am not sure what kind of
performance penalty this will have on the drivers in general and if
that will be acceptable at all. Any thoughts?

However, this still doesn't solve the generic problem, and an ideal solutio=
n
will be something that you suggested.

Will it be sensible to think about having a generic API that can be
consumed by all the drivers and that can do both the things you mentioned?

>
> Thanks,
>
>         tglx
>
>
>
--=20
Thanks
Nitesh


--fpjpftGGct6Kgqold4nIRFi6tHAQ5oppN--

--19tJzs4pDB5hORMaKvDJ8V6aBKOyjfvgw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+QokEACgkQo4ZA3AYy
ozm8/BAAw3Ss+bADPfbH0Btpugh729jC6rE1B3DjGvzYJ31x04H+qfcbMeyAMoUB
p+JMNfMAINsS2QgwgzC5sEP825/CWCxpMsWDpjYjaxegrC+4KW/uWlRtTddYoDlU
vjJclY7406kHZr+djsB6kiPVJPxxsYhtsgUh0bsGrOpLHj3M6q5QmwF9eRQPuJgn
xt7IEM+xtL/0S/QiHPOMIfRbMeAouYO9eeXMRDiCHL/uADwFHz6j8MSOpwZJ9zBk
gpS/3ly0cL8t1sU1k36OE7V+oelMzqt1DTIv/KF9/LEhPeb7+Np/R2MGWrrYDAPv
4b8PzJCgC6uCaKQMIsqi9nciTogeTibOUKoh5PCdeRv86cDj815NqSeiRVCOaWuT
xUGPQgrWIQzPMN4fdt7Ile6lRVv4e8wlRdgAMlBcW4gFamp97zyzcUHTZ957hOWE
AKHWDUZizoaOPiL6hIHTGkHljv6uvVv5lv6+UlZz+fR9ArRYSZ8Y2BibBj/GRLqR
IQD5BWjXNcq9izSNESPd6ionkxosjF8dmlP4PpZBMwwRfZ4toWLaDQvhfF7L5ODO
aSqfFsdqSeZBDbB4zy6QpOmTraLKHly0cE4gD408BGbySJn8FoNXb7be/hNWQfJN
F74wifFccM4/h26iT1M/EPn3R9h2y7keMrRL1p5OosZHKTRi9Bo=
=oi9x
-----END PGP SIGNATURE-----

--19tJzs4pDB5hORMaKvDJ8V6aBKOyjfvgw--

