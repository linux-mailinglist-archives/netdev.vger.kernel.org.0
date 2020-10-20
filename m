Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26F0294055
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394516AbgJTQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730196AbgJTQSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 12:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603210714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=//ISF/5bPLJy2Biv75rT7McDHPt/dfWVCN9FHOl7fpw=;
        b=azYsIIIU8KPvdPLjG00JPix3aVzvlKZlHnRRhINH/RsMqvZB/uXdVoTkRm6GmXeF0N8lWh
        eSKsaLxZEkfUdAXdMjJVjGeXFoq6ku76oESWV8AD3jDwCkT3QJQ/CzGe50isPtZBaY40JA
        RL9APoqDCMKT+snD0PDvwjk1mlw8tIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-YuO_PyVmNAyF-qdI1cgTAw-1; Tue, 20 Oct 2020 12:18:32 -0400
X-MC-Unique: YuO_PyVmNAyF-qdI1cgTAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 173FB803624;
        Tue, 20 Oct 2020 16:18:30 +0000 (UTC)
Received: from [10.10.115.117] (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E9935C1C2;
        Tue, 20 Oct 2020 16:18:24 +0000 (UTC)
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
        lgoncalv@redhat.com
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <87v9f57zjf.fsf@nanos.tec.linutronix.de>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFl4pQoBEADT/nXR2JOfsCjDgYmE2qonSGjkM1g8S6p9UWD+bf7YEAYYYzZsLtbilFTe
 z4nL4AV6VJmC7dBIlTi3Mj2eymD/2dkKP6UXlliWkq67feVg1KG+4UIp89lFW7v5Y8Muw3Fm
 uQbFvxyhN8n3tmhRe+ScWsndSBDxYOZgkbCSIfNPdZrHcnOLfA7xMJZeRCjqUpwhIjxQdFA7
 n0s0KZ2cHIsemtBM8b2WXSQG9CjqAJHVkDhrBWKThDRF7k80oiJdEQlTEiVhaEDURXq+2XmG
 jpCnvRQDb28EJSsQlNEAzwzHMeplddfB0vCg9fRk/kOBMDBtGsTvNT9OYUZD+7jaf0gvBvBB
 lbKmmMMX7uJB+ejY7bnw6ePNrVPErWyfHzR5WYrIFUtgoR3LigKnw5apzc7UIV9G8uiIcZEn
 C+QJCK43jgnkPcSmwVPztcrkbC84g1K5v2Dxh9amXKLBA1/i+CAY8JWMTepsFohIFMXNLj+B
 RJoOcR4HGYXZ6CAJa3Glu3mCmYqHTOKwezJTAvmsCLd3W7WxOGF8BbBjVaPjcZfavOvkin0u
 DaFvhAmrzN6lL0msY17JCZo046z8oAqkyvEflFbC0S1R/POzehKrzQ1RFRD3/YzzlhmIowkM
 BpTqNBeHEzQAlIhQuyu1ugmQtfsYYq6FPmWMRfFPes/4JUU/PQARAQABtCVOaXRlc2ggTmFy
 YXlhbiBMYWwgPG5pbGFsQHJlZGhhdC5jb20+iQI9BBMBCAAnBQJZeKUKAhsjBQkJZgGABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEKOGQNwGMqM56lEP/A2KMs/pu0URcVk/kqVwcBhU
 SnvB8DP3lDWDnmVrAkFEOnPX7GTbactQ41wF/xwjwmEmTzLrMRZpkqz2y9mV0hWHjqoXbOCS
 6RwK3ri5e2ThIPoGxFLt6TrMHgCRwm8YuOSJ97o+uohCTN8pmQ86KMUrDNwMqRkeTRW9wWIQ
 EdDqW44VwelnyPwcmWHBNNb1Kd8j3xKlHtnS45vc6WuoKxYRBTQOwI/5uFpDZtZ1a5kq9Ak/
 MOPDDZpd84rqd+IvgMw5z4a5QlkvOTpScD21G3gjmtTEtyfahltyDK/5i8IaQC3YiXJCrqxE
 r7/4JMZeOYiKpE9iZMtS90t4wBgbVTqAGH1nE/ifZVAUcCtycD0f3egX9CHe45Ad4fsF3edQ
 ESa5tZAogiA4Hc/yQpnnf43a3aQ67XPOJXxS0Qptzu4vfF9h7kTKYWSrVesOU3QKYbjEAf95
 NewF9FhAlYqYrwIwnuAZ8TdXVDYt7Z3z506//sf6zoRwYIDA8RDqFGRuPMXUsoUnf/KKPrtR
 ceLcSUP/JCNiYbf1/QtW8S6Ca/4qJFXQHp0knqJPGmwuFHsarSdpvZQ9qpxD3FnuPyo64S2N
 Dfq8TAeifNp2pAmPY2PAHQ3nOmKgMG8Gn5QiORvMUGzSz8Lo31LW58NdBKbh6bci5+t/HE0H
 pnyVf5xhNC/FuQINBFl4pQoBEACr+MgxWHUP76oNNYjRiNDhaIVtnPRqxiZ9v4H5FPxJy9UD
 Bqr54rifr1E+K+yYNPt/Po43vVL2cAyfyI/LVLlhiY4yH6T1n+Di/hSkkviCaf13gczuvgz4
 KVYLwojU8+naJUsiCJw01MjO3pg9GQ+47HgsnRjCdNmmHiUQqksMIfd8k3reO9SUNlEmDDNB
 XuSzkHjE5y/R/6p8uXaVpiKPfHoULjNRWaFc3d2JGmxJpBdpYnajoz61m7XJlgwl/B5Ql/6B
 dHGaX3VHxOZsfRfugwYF9CkrPbyO5PK7yJ5vaiWre7aQ9bmCtXAomvF1q3/qRwZp77k6i9R3
 tWfXjZDOQokw0u6d6DYJ0Vkfcwheg2i/Mf/epQl7Pf846G3PgSnyVK6cRwerBl5a68w7xqVU
 4KgAh0DePjtDcbcXsKRT9D63cfyfrNE+ea4i0SVik6+N4nAj1HbzWHTk2KIxTsJXypibOKFX
 2VykltxutR1sUfZBYMkfU4PogE7NjVEU7KtuCOSAkYzIWrZNEQrxYkxHLJsWruhSYNRsqVBy
 KvY6JAsq/i5yhVd5JKKU8wIOgSwC9P6mXYRgwPyfg15GZpnw+Fpey4bCDkT5fMOaCcS+vSU1
 UaFmC4Ogzpe2BW2DOaPU5Ik99zUFNn6cRmOOXArrryjFlLT5oSOe4IposgWzdwARAQABiQIl
 BBgBCAAPBQJZeKUKAhsMBQkJZgGAAAoJEKOGQNwGMqM5ELoP/jj9d9gF1Al4+9bngUlYohYu
 0sxyZo9IZ7Yb7cHuJzOMqfgoP4tydP4QCuyd9Q2OHHL5AL4VFNb8SvqAxxYSPuDJTI3JZwI7
 d8JTPKwpulMSUaJE8ZH9n8A/+sdC3CAD4QafVBcCcbFe1jifHmQRdDrvHV9Es14QVAOTZhnJ
 vweENyHEIxkpLsyUUDuVypIo6y/Cws+EBCWt27BJi9GH/EOTB0wb+2ghCs/i3h8a+bi+bS7L
 FCCm/AxIqxRurh2UySn0P/2+2eZvneJ1/uTgfxnjeSlwQJ1BWzMAdAHQO1/lnbyZgEZEtUZJ
 x9d9ASekTtJjBMKJXAw7GbB2dAA/QmbA+Q+Xuamzm/1imigz6L6sOt2n/X/SSc33w8RJUyor
 SvAIoG/zU2Y76pKTgbpQqMDmkmNYFMLcAukpvC4ki3Sf086TdMgkjqtnpTkEElMSFJC8npXv
 3QnGGOIfFug/qs8z03DLPBz9VYS26jiiN7QIJVpeeEdN/LKnaz5LO+h5kNAyj44qdF2T2AiF
 HxnZnxO5JNP5uISQH3FjxxGxJkdJ8jKzZV7aT37sC+Rp0o3KNc+GXTR+GSVq87Xfuhx0LRST
 NK9ZhT0+qkiN7npFLtNtbzwqaqceq3XhafmCiw8xrtzCnlB/C4SiBr/93Ip4kihXJ0EuHSLn
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
Date:   Tue, 20 Oct 2020 12:18:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87v9f57zjf.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="voyFYqkjEIrtHpmCHhhnE9GN9KYY2UWjo"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--voyFYqkjEIrtHpmCHhhnE9GN9KYY2UWjo
Content-Type: multipart/mixed; boundary="O6c5NIYCH5bo8S4dm3sNiwp7j8zkl2uGm"

--O6c5NIYCH5bo8S4dm3sNiwp7j8zkl2uGm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/20/20 10:16 AM, Thomas Gleixner wrote:
> On Mon, Sep 28 2020 at 14:35, Nitesh Narayan Lal wrote:
>> =20
>> +=09hk_cpus =3D housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
>> +
>> +=09/*
>> +=09 * If we have isolated CPUs for use by real-time tasks, to keep the
>> +=09 * latency overhead to a minimum, device-specific IRQ vectors are mo=
ved
>> +=09 * to the housekeeping CPUs from the userspace by changing their
>> +=09 * affinity mask. Limit the vector usage to keep housekeeping CPUs f=
rom
>> +=09 * running out of IRQ vectors.
>> +=09 */
> This is not true for managed interrupts. The interrupts affinity of
> those cannot be changed by user space.

Ah Yes. Perhaps
s/IRQs/non-managed IRQ ?

>
>> +=09if (hk_cpus < num_online_cpus()) {
>> +=09=09if (hk_cpus < min_vecs)
>> +=09=09=09max_vecs =3D min_vecs;
>> +=09=09else if (hk_cpus < max_vecs)
>> +=09=09=09max_vecs =3D hk_cpus;
>> +=09}
> So now with that assume a 16 core machine (HT off for simplicity)
>
> 17 Requested interrupts (1 general, 16 queues)
>
> Managed interrupts will allocate
>
>    1  general interrupt which is free movable by user space
>    16 managed interrupts for queues (one per CPU)
>
> This allows the driver to have 16 queues, i.e. one queue per CPU. These
> interrupts are only used when an application on a CPU issues I/O.

Correct.

>
> With the above change this will result
>
>    1  general interrupt which is free movable by user space
>    1  managed interrupts (possible affinity to all 16 CPUs, but routed
>       to housekeeping CPU as long as there is one online)
>
> So the device is now limited to a single queue which also affects the
> housekeeping CPUs because now they have to share a single queue.
>
> With larger machines this gets even worse.

Yes, the change can impact the performance, however, if we don't do that we
may have a latency impact instead. Specifically, on larger systems where
most of the CPUs are isolated as we will definitely fail in moving all of t=
he
IRQs away from the isolated CPUs to the housekeeping.

>
> So no. This needs way more thought for managed interrupts and you cannot
> do that at the PCI layer.

Maybe we should not be doing anything in the case of managed IRQs as they
are anyways pinned to the housekeeping CPUs as long as we have the
'managed_irq' option included in the kernel cmdline.

>  Only the affinity spreading mechanism can do
> the right thing here.

I can definitely explore this further.

However, IMHO we would still need a logic to prevent the devices from
creating excess vectors.

Do you agree?

>
> Thanks,
>
>         tglx
>
--=20
Thanks
Nitesh


--O6c5NIYCH5bo8S4dm3sNiwp7j8zkl2uGm--

--voyFYqkjEIrtHpmCHhhnE9GN9KYY2UWjo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+PDc8ACgkQo4ZA3AYy
oznRhRAAhjdJWY29+gVw+tD81awhLqlexIAITkH/Zd3k+hZWqHHYSfHTtZK3MPod
TJxki1CPSQSkJB0FmMZKAKzHs63YE5gn7fXqKVqj5pX1J1Cl1QhDkX+MJxrwiUeT
P2fBWj2zhVkdqVFJVqXxTK6jf19IFiZ+smuvx7irL0OuD1rj9+aHI3u8bhY6Ca+M
R6qzqe4n2EwOZ5yj8gQSHsXxvL4jAabALOvAHH5u6PYG1Xf+7vNSjPhOixGp0VFo
ef7QXkQHLqBxJviZaop8k8S3AMKzj4M4+4LNrDNw1YmDjMO9y/B0d9pLnXLTWWgx
W+sRQ2QmvCpZb0uEMJr3KhoDzqTGBxvIUv7J2m77O9+CJCeA1l/bEaK7KOc3PGDe
I7yGO7SkeWMx9eIfbyT4b1ggGcFtICgZddLIuMsnAlR4ndIpkpkdF8DonAHM6lcJ
Eda1Lxlge0UjeIbsj8T/Sd2sUzi/L3e59tXsEvch7g0Riis0IXf7s/gGY6hod+GH
cnUG/QO61S7fNT2qhgIDhOaRl7PC6euRvMaCvEHGov/2XrSD3SMPhaPYRb+h3TFs
97i9XSAhN0/Xx3HdLfN3yOtkV6dMiVa6+8jej0fvEvMLTraDKfanhh/7OkjXI9V5
+IJyY1aWNwYYLVYPFXAuPXygxG1RtfwWp2P/NS399+GPHR5efHk=
=TKnt
-----END PGP SIGNATURE-----

--voyFYqkjEIrtHpmCHhhnE9GN9KYY2UWjo--

