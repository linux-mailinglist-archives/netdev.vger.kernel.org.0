Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FD72918C9
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgJRSPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 14:15:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgJRSPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 14:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603044898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=hEG9GYmMEQ7zkuGpQiZgHxQYAFFxtZP/1fc/V0C8o/s=;
        b=YC9jbMZRD+S02OGR3jBJyVbTwbJsR9Ji45K5vQButvO0KyjM1c2EWFkG4OcLATvv2flND9
        KYQQlJ3TtGvrrbg1pm0ywQrmVHqGpM0OUtRyaSFcUyuHtNYvKIjVuGvNqNTRWyNyKoz2SZ
        NNba1cbvRBHpjdreuau4Tj1ROupszR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-PSC10q-uNCqbMkrDHFg-Lw-1; Sun, 18 Oct 2020 14:14:57 -0400
X-MC-Unique: PSC10q-uNCqbMkrDHFg-Lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B13161074643;
        Sun, 18 Oct 2020 18:14:54 +0000 (UTC)
Received: from [10.10.112.216] (ovpn-112-216.rdu2.redhat.com [10.10.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AB8A5D9D2;
        Sun, 18 Oct 2020 18:14:48 +0000 (UTC)
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
Date:   Sun, 18 Oct 2020 14:14:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201016122046.GP2611@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R0cuGxf0KGcVoXq2gczEbvEdgVkWYtM7K"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R0cuGxf0KGcVoXq2gczEbvEdgVkWYtM7K
Content-Type: multipart/mixed; boundary="CdRNgvA4qMp1wKOktCnZv0FH5XpZm3v97"

--CdRNgvA4qMp1wKOktCnZv0FH5XpZm3v97
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/16/20 8:20 AM, Peter Zijlstra wrote:
> On Mon, Sep 28, 2020 at 02:35:29PM -0400, Nitesh Narayan Lal wrote:
>> If we have isolated CPUs dedicated for use by real-time tasks, we try to
>> move IRQs to housekeeping CPUs from the userspace to reduce latency
>> overhead on the isolated CPUs.
>>
>> If we allocate too many IRQ vectors, moving them all to housekeeping CPU=
s
>> may exceed per-CPU vector limits.
>>
>> When we have isolated CPUs, limit the number of vectors allocated by
>> pci_alloc_irq_vectors() to the minimum number required by the driver, or
>> to one per housekeeping CPU if that is larger.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  drivers/pci/msi.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index 30ae4ffda5c1..8c156867803c 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/irqdomain.h>
>>  #include <linux/of_irq.h>
>> +#include <linux/sched/isolation.h>
>> =20
>>  #include "pci.h"
>> =20
>> @@ -1191,8 +1192,25 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev=
 *dev, unsigned int min_vecs,
>>  =09=09=09=09   struct irq_affinity *affd)
>>  {
>>  =09struct irq_affinity msi_default_affd =3D {0};
>> +=09unsigned int hk_cpus;
>>  =09int nvecs =3D -ENOSPC;
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
>> +=09if (hk_cpus < num_online_cpus()) {
>> +=09=09if (hk_cpus < min_vecs)
>> +=09=09=09max_vecs =3D min_vecs;
>> +=09=09else if (hk_cpus < max_vecs)
>> +=09=09=09max_vecs =3D hk_cpus;
> is that:
>
> =09=09max_vecs =3D clamp(hk_cpus, min_vecs, max_vecs);

Yes, I think this will do.

>
> Also, do we really need to have that conditional on hk_cpus <
> num_online_cpus()? That is, why can't we do this unconditionally?


FWIU most of the drivers using this API already restricts the number of
vectors based on the num_online_cpus, if we do it unconditionally we can
unnecessary duplicate the restriction for cases where we don't have any
isolated CPUs.

Also, different driver seems to take different factors into consideration
along with num_online_cpus while finding the max_vecs to request, for
example in the case of mlx5:
MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 MLX5_EQ_VEC_COMP_BASE

Having hk_cpus < num_online_cpus() helps us ensure that we are only
changing the behavior when we have isolated CPUs.

Does that make sense?

>
> And what are the (desired) semantics vs hotplug? Using a cpumask without
> excluding hotplug is racy.

The housekeeping_mask should still remain constant, isn't?
In any case, I can double check this.

>
>> +=09}
>> +
>>  =09if (flags & PCI_IRQ_AFFINITY) {
>>  =09=09if (!affd)
>>  =09=09=09affd =3D &msi_default_affd;
>> --=20
>> 2.18.2
>>
--=20
Thanks
Nitesh


--CdRNgvA4qMp1wKOktCnZv0FH5XpZm3v97--

--R0cuGxf0KGcVoXq2gczEbvEdgVkWYtM7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+MhhYACgkQo4ZA3AYy
ozm+Qw/9GMy/P3pYedJjaZJK7rYcoT7oHCgmKHEnVxehjwGvDPwsY+V4DG0rn1/B
WYvYGIw67UJfekW/M7Z+Zn9ele3Lc1cxD3m1TsSlznD2AfRa4nFot6p7mOCeeR5I
x+sQxIB4bvPIxWPo12/B+Vx8SWE77t5vZylbRXplTFptYaGX5guS+XbsAC8acqkj
yfKYK97LmCtzM4zJ1IkYL8SEY+nFE9AZCvOqECIknb8nj9jtY8AjzYUj9IJZKmxS
WTpzzZIDPYNrFToz1hVwoKxJZxrHNTLj6YP8MMFDJdX+FElUkYB7fHVJfdUXb9k+
0CpmNdbBODOXaBcZlf2Wz9DJSQTO+9wIKNYKyxmD9+A0yonjd/1XtLzhONzU3iI8
4JFIdz6phqv9zgUW+fhJ+LJAJPH4F+eeom1PSSxZjaJxAZ/KUnNol2TYXpZ27b/i
Cbzlhs8w+XKN0XMHKXABDcv7fqp9fCk6Rn8iuXx3q4vJILcaPCILwU0+YgPjn+vF
sqeCGAdAjuk4XtS57rev9uUx0YiFhsv8podbr0zwQqynOXcf4wDNr3acJ4O/55uW
jzYyVcNKIo8+KHOUcf9DtMvTXrf9j6RgSXffY//1SNtS+PzvnfDesO97TjGQrVTH
YqrvQ/geVeUGO4G2tKD8Km6z32PExXm6M9xDANJcnQ5Mcu8LI9M=
=5YYR
-----END PGP SIGNATURE-----

--R0cuGxf0KGcVoXq2gczEbvEdgVkWYtM7K--

