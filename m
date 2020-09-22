Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67385274390
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIVNz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:55:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVNzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600782920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=jdEJ0y8H2IADTtde1QqqSnKCJ1vHwxBCZrJ7EWnb5qs=;
        b=PsLa8aNjRhFnXi0dfQG+l+5wJk7jn1FBRwd8TaBF8xHXpoMyj4JWb48wqxUjt+ksGvm7yl
        qlUIp/nzeTLmTpuhpnnhwI19dezt7w2tCOm2BW4b58gvMC2p1+8x4tBPz2qD5eBPoUHvi3
        emTSV0NFirdWdvvOgyup6F5lHiRhLZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-DyZmYKtJOrGgV6nprKQK0Q-1; Tue, 22 Sep 2020 09:55:15 -0400
X-MC-Unique: DyZmYKtJOrGgV6nprKQK0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5E3D800400;
        Tue, 22 Sep 2020 13:55:13 +0000 (UTC)
Received: from [10.10.115.78] (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29AE827C21;
        Tue, 22 Sep 2020 13:55:00 +0000 (UTC)
Subject: Re: [RFC][Patch v1 3/3] PCI: Limit pci_alloc_irq_vectors as per
 housekeeping CPUs
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>, frederic@kernel.org,
        bhelgaas@google.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-4-nitesh@redhat.com>
 <20200910192208.GA24845@fuller.cnet>
 <cfdf9186-89a4-2a29-9bbb-3bf3ffebffcd@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <75a398cd-2050-e298-d718-eb56d4910133@redhat.com>
Date:   Tue, 22 Sep 2020 09:54:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <cfdf9186-89a4-2a29-9bbb-3bf3ffebffcd@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QUlCYZirVSnzLEka9GGa8MU8J8LhWkkvL"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QUlCYZirVSnzLEka9GGa8MU8J8LhWkkvL
Content-Type: multipart/mixed; boundary="FcDyyLvNvIuwxqbIsEYXJONQcvkR6PsHT"

--FcDyyLvNvIuwxqbIsEYXJONQcvkR6PsHT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/10/20 3:31 PM, Nitesh Narayan Lal wrote:
> On 9/10/20 3:22 PM, Marcelo Tosatti wrote:
>> On Wed, Sep 09, 2020 at 11:08:18AM -0400, Nitesh Narayan Lal wrote:
>>> This patch limits the pci_alloc_irq_vectors max vectors that is passed =
on
>>> by the caller based on the available housekeeping CPUs by only using th=
e
>>> minimum of the two.
>>>
>>> A minimum of the max_vecs passed and available housekeeping CPUs is
>>> derived to ensure that we don't create excess vectors which can be
>>> problematic specifically in an RT environment. This is because for an R=
T
>>> environment unwanted IRQs are moved to the housekeeping CPUs from
>>> isolated CPUs to keep the latency overhead to a minimum. If the number =
of
>>> housekeeping CPUs are significantly lower than that of the isolated CPU=
s
>>> we can run into failures while moving these IRQs to housekeeping due to
>>> per CPU vector limit.
>>>
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>> ---
>>>  include/linux/pci.h | 16 ++++++++++++++++
>>>  1 file changed, 16 insertions(+)
>>>
>>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>>> index 835530605c0d..750ba927d963 100644
>>> --- a/include/linux/pci.h
>>> +++ b/include/linux/pci.h
>>> @@ -38,6 +38,7 @@
>>>  #include <linux/interrupt.h>
>>>  #include <linux/io.h>
>>>  #include <linux/resource_ext.h>
>>> +#include <linux/sched/isolation.h>
>>>  #include <uapi/linux/pci.h>
>>> =20
>>>  #include <linux/pci_ids.h>
>>> @@ -1797,6 +1798,21 @@ static inline int
>>>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>>>  =09=09      unsigned int max_vecs, unsigned int flags)
>>>  {
>>> +=09unsigned int num_housekeeping =3D num_housekeeping_cpus();
>>> +=09unsigned int num_online =3D num_online_cpus();
>>> +
>>> +=09/*
>>> +=09 * Try to be conservative and at max only ask for the same number o=
f
>>> +=09 * vectors as there are housekeeping CPUs. However, skip any
>>> +=09 * modification to the of max vectors in two conditions:
>>> +=09 * 1. If the min_vecs requested are higher than that of the
>>> +=09 *    housekeeping CPUs as we don't want to prevent the initializat=
ion
>>> +=09 *    of a device.
>>> +=09 * 2. If there are no isolated CPUs as in this case the driver shou=
ld
>>> +=09 *    already have taken online CPUs into consideration.
>>> +=09 */
>>> +=09if (min_vecs < num_housekeeping && num_housekeeping !=3D num_online=
)
>>> +=09=09max_vecs =3D min_t(int, max_vecs, num_housekeeping);
>>>  =09return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flag=
s,
>>>  =09=09=09=09=09      NULL);
>>>  }
>> If min_vecs > num_housekeeping, for example:
>>
>> /* PCI MSI/MSIx support */
>> #define XGBE_MSI_BASE_COUNT     4
>> #define XGBE_MSI_MIN_COUNT      (XGBE_MSI_BASE_COUNT + 1)
>>
>> Then the protection fails.
> Right, I was ignoring that case.
>
>> How about reducing max_vecs down to min_vecs, if min_vecs >
>> num_housekeeping ?
> Yes, I think this makes sense.
> I will wait a bit to see if anyone else has any other comment and will po=
st
> the next version then.
>

Are there any other comments/concerns on this patch that I need to address =
in
the next posting?

--=20
Nitesh


--FcDyyLvNvIuwxqbIsEYXJONQcvkR6PsHT--

--QUlCYZirVSnzLEka9GGa8MU8J8LhWkkvL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9qAjIACgkQo4ZA3AYy
ozk33w//QnSYbMCUx+8+VUAoHYDuyHaWIzzfcxjcrd9UXCQMI6hqcnoXfTx4yZxi
daHkOR3jQPzlAZskWRCe1HHQsvkSFSJa8Ux1SbtB+JW1jSJgDWB6trt43GlrZN02
tyzNDfqYpFEwxdXzjYQcAp9eWuRzo0KDojWQ0FJyL2Rqgc7U4CNA2W0DsTx/lZUP
UQMc4nbdBLwYd9RwZn/MKyrT3WCGgGnHLVx8nmUsvX5kH+jI9Z71csbN2kX3AhiF
sVZuYY4Xmqf+hbFmbXynN0af/WijUrNWFh3KRpOtMVBtErPO5E6CN90kq3xOs5zT
ngd4Zku2WydJptrZPprLPDMcyfQZjzbggfneW1+jTnI1r3PLiQMzUfG5AWo8YhZP
HEPZ6J7bjqr+pfYzSUIB5WkuRO6S3nEIBLN0mpR62Ss3WUz73/HakQaFrKdulJR+
yFSF/5+CYxSzn8CNM2XWGPCgU9BFIiJy5koUsJYtjpsxcnSApxINtYK4Zsb43Xht
V6ki3CY7ZNtaDVQGpdmWa/wqOuC/Sb4grdTCMMygp/Cv0RbNTCCN8n7XQcRwnfIP
1sSCnuqxKcAwvcXMOfRLCA9niM3cxfeBhauL+YzfkowM5GDvrHbZ/uqO0SMWy6cL
zqrMEiblm5ycee1ajc0shb3SV8Uf/gIZv5hOMLtHHZSSXoXmV2o=
=92yK
-----END PGP SIGNATURE-----

--QUlCYZirVSnzLEka9GGa8MU8J8LhWkkvL--

