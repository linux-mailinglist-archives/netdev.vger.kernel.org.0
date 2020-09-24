Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2723D277B25
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgIXVjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:39:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgIXVjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 17:39:23 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600983560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=4eYx2adougRmO6mXBQxS+3jgL7biIs5NBsuk2ViDvrQ=;
        b=eb6M/1q7wuZ+H8kX07+1/0BQRuNEC50AvdWfNz0UdHdqzD/MAIwLuFuDbfKTAEwMA3nGvZ
        z76m3MEli36jCJLHA40I220jNfXELoTF6bPE75Ni5w8M91CwJOuNJ9OsNRPPOoUKrP2Goe
        nMoGYyvMMRhIg5CL+uqhHnBtJ8VXzQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-p_J92l7gNKKx-XRhSsitng-1; Thu, 24 Sep 2020 17:39:18 -0400
X-MC-Unique: p_J92l7gNKKx-XRhSsitng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 503A081F03C;
        Thu, 24 Sep 2020 21:39:16 +0000 (UTC)
Received: from [10.10.115.120] (ovpn-115-120.rdu2.redhat.com [10.10.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 056BF1002C07;
        Thu, 24 Sep 2020 21:39:09 +0000 (UTC)
Subject: Re: [PATCH v2 4/4] PCI: Limit pci_alloc_irq_vectors as per
 housekeeping CPUs
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
References: <20200924204535.GA2337207@bjorn-Precision-5520>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <493a6fe5-f33f-85b2-6149-809f3cb4390f@redhat.com>
Date:   Thu, 24 Sep 2020 17:39:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924204535.GA2337207@bjorn-Precision-5520>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BDL0z9iH3vAdESVRZCTIUT2hpLdfAYevK"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BDL0z9iH3vAdESVRZCTIUT2hpLdfAYevK
Content-Type: multipart/mixed; boundary="NMw72KAobuYLvXJJvBDrYvObo65DuMClI"

--NMw72KAobuYLvXJJvBDrYvObo65DuMClI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/24/20 4:45 PM, Bjorn Helgaas wrote:
> Possible subject:
>
>   PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs

Will switch to this.

>
> On Wed, Sep 23, 2020 at 02:11:26PM -0400, Nitesh Narayan Lal wrote:
>> This patch limits the pci_alloc_irq_vectors, max_vecs argument that is
>> passed on by the caller based on the housekeeping online CPUs (that are
>> meant to perform managed IRQ jobs).
>>
>> A minimum of the max_vecs passed and housekeeping online CPUs is derived
>> to ensure that we don't create excess vectors as that can be problematic
>> specifically in an RT environment. In cases where the min_vecs exceeds t=
he
>> housekeeping online CPUs, max vecs is restricted based on the min_vecs
>> instead. The proposed change is required because for an RT environment
>> unwanted IRQs are moved to the housekeeping CPUs from isolated CPUs to
>> keep the latency overhead to a minimum. If the number of housekeeping CP=
Us
>> is significantly lower than that of the isolated CPUs we can run into
>> failures while moving these IRQs to housekeeping CPUs due to per CPU
>> vector limit.
> Does this capture enough of the log?
>
>   If we have isolated CPUs dedicated for use by real-time tasks, we
>   try to move IRQs to housekeeping CPUs to reduce overhead on the
>   isolated CPUs.

How about:
"
If we have isolated CPUs or CPUs running in nohz_full mode for the purpose
of real-time, we try to move IRQs to housekeeping CPUs to reduce latency
overhead on these real-time CPUs.
"

What do you think?

>
>   If we allocate too many IRQ vectors, moving them all to housekeeping
>   CPUs may exceed per-CPU vector limits.
>
>   When we have isolated CPUs, limit the number of vectors allocated by
>   pci_alloc_irq_vectors() to the minimum number required by the
>   driver, or to one per housekeeping CPU if that is larger

I think this is good, I can adopt this.

> .
>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  include/linux/pci.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 835530605c0d..cf9ca9410213 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -38,6 +38,7 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/io.h>
>>  #include <linux/resource_ext.h>
>> +#include <linux/sched/isolation.h>
>>  #include <uapi/linux/pci.h>
>> =20
>>  #include <linux/pci_ids.h>
>> @@ -1797,6 +1798,20 @@ static inline int
>>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>>  =09=09      unsigned int max_vecs, unsigned int flags)
>>  {
>> +=09unsigned int hk_cpus =3D hk_num_online_cpus();
>> +
>> +=09/*
>> +=09 * For a real-time environment, try to be conservative and at max on=
ly
>> +=09 * ask for the same number of vectors as there are housekeeping onli=
ne
>> +=09 * CPUs. In case, the min_vecs requested exceeds the housekeeping
>> +=09 * online CPUs, restrict the max_vecs based on the min_vecs instead.
>> +=09 */
>> +=09if (hk_cpus !=3D num_online_cpus()) {
>> +=09=09if (min_vecs > hk_cpus)
>> +=09=09=09max_vecs =3D min_vecs;
>> +=09=09else
>> +=09=09=09max_vecs =3D min_t(int, max_vecs, hk_cpus);
>> +=09}
> Is the below basically the same?
>
> =09/*
> =09 * If we have isolated CPUs for use by real-time tasks,
> =09 * minimize overhead on those CPUs by moving IRQs to the
> =09 * remaining "housekeeping" CPUs.  Limit vector usage to keep
> =09 * housekeeping CPUs from running out of IRQ vectors.
> =09 */

How about the following as a comment:

"
If we have isolated CPUs or CPUs running in nohz_full mode for real-time,
latency overhead is minimized on those CPUs by moving the IRQ vectors to
the housekeeping CPUs. Limit the number of vectors to keep housekeeping
CPUs from running out of IRQ vectors.

"

> =09if (housekeeping_cpus < num_online_cpus()) {
> =09=09if (housekeeping_cpus < min_vecs)
> =09=09=09max_vecs =3D min_vecs;
> =09=09else if (housekeeping_cpus < max_vecs)
> =09=09=09max_vecs =3D housekeeping_cpus;
> =09}

The only reason I went with hk_cpus instead of housekeeping_cpus is because
at other places in the kernel I found a similar naming convention (eg.
hk_mask, hk_flags etc.).
But if housekeeping_cpus makes things more clear, I can switch to that
instead.

Although after Frederic and Peter's suggestion the previous call will chang=
e
to something like:

"
housekeeping_cpus =3D housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
"

Which should still falls in the that 80 chars per line limit.

>
> My comment isn't quite right because this patch only limits the number
> of vectors; it doesn't actually *move* IRQs to the housekeeping CPUs.

Yeap it doesn't move IRQs to the housekeeping CPUs.

> I don't know where the move happens (or maybe you just avoid assigning
> IRQs to isolated CPUs, and I don't know how that happens either).

This can happen in the userspace, either manually or by some application
such as tuned.

>
>>  =09return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags=
,
>>  =09=09=09=09=09      NULL);
>>  }
>> --=20
>> 2.18.2
>>
--=20
Thanks
Nitesh


--NMw72KAobuYLvXJJvBDrYvObo65DuMClI--

--BDL0z9iH3vAdESVRZCTIUT2hpLdfAYevK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9tEfsACgkQo4ZA3AYy
oznJGg/8DS6jCI09TtnpD4mtCtrb2spnGkcp1Td/junReGQDOvhq9eLL0UTPM9jn
5qJvhYT+TWZxcNWe13E0fVk7T5ShyBMTdwivmaOag38QpbbMIJhoPcbVJaXhuryq
Vzt0KGblz5XHJA8BtJRSlCNMTWw2FTdQGxVTcbxcN/OIJ+nzOEAJpnrogB0lUYJ9
mnFlipqxpAOYksbzLzR51MbeC4I/3uIJL6RXGzxDIePkZcOuRef7UCFH5lqaVMcE
Qx+DRRuqfxekr9U6hLwnWcpKX667JnbpXGXhlgQesL2QY7Fh3NjM7qz6vwTUJfJr
x8h0+7quS5ArTixkWJO880nfaptvMrbtpphMfSvEj0HPeQiY9Uwx3eySZlLvBwqH
1yCdcCG0hM9dvu+h5DIZ/0I9aeDD0naYOMBVnJrr1LcRLebmBxDq/p8/QpmH4MUu
0sXGEcsi3mnFxpM0A1x2kKthde4y3HLMJkIm4lxwVrxrBEwJ52zURTiUFRpCdIpt
qubSLpxWn2znF7I+A4kmlZrM830jb1w1Ih18O8IJcHVzNXu2aWZwrXaFzoMR/cYP
q3ZMd2zukrOJYdCa5GbxGme6+P8PvlDrnefJu9XUk7o1ysrhQDmDFG1EdvCnyqd7
X6bxPR4GlltYIZOCFjzuYLB8IOQzTPHmreLfFsmM6HivE7NgR7w=
=gRXS
-----END PGP SIGNATURE-----

--BDL0z9iH3vAdESVRZCTIUT2hpLdfAYevK--

