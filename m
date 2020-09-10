Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF28264F00
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgIJTcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728005AbgIJTcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599766327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=n3ZX3FM+OHTZE8GRqFEqVKUqxyj7rJoV+yf6LuEY0nk=;
        b=i5/8muUr5BoOQ1oTP0Om1XEY0gRCGUx7b9/uSCNOqvWiZ7ARYqJ97HfXe13LBtEpO4fMr3
        +IdrEpyRIKuXdfW/kCUowiLzL25sIjvAvJqTQe0o0HSjSs1iamxN1SBz921EqfAmQdvj8N
        UciiY8hit8lJUCeEAsRCMM1/tSPmHUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-wYDXwM_pOyug0sKvvsT3Xg-1; Thu, 10 Sep 2020 15:32:04 -0400
X-MC-Unique: wYDXwM_pOyug0sKvvsT3Xg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B8A518BA28C;
        Thu, 10 Sep 2020 19:32:02 +0000 (UTC)
Received: from [10.10.115.84] (ovpn-115-84.rdu2.redhat.com [10.10.115.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EAC85D9F3;
        Thu, 10 Sep 2020 19:31:59 +0000 (UTC)
Subject: Re: [RFC][Patch v1 3/3] PCI: Limit pci_alloc_irq_vectors as per
 housekeeping CPUs
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-4-nitesh@redhat.com>
 <20200910192208.GA24845@fuller.cnet>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <cfdf9186-89a4-2a29-9bbb-3bf3ffebffcd@redhat.com>
Date:   Thu, 10 Sep 2020 15:31:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200910192208.GA24845@fuller.cnet>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Nn7UuK1yQjSSr1T9L7Zv8zociIvpUvuk0"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nn7UuK1yQjSSr1T9L7Zv8zociIvpUvuk0
Content-Type: multipart/mixed; boundary="ZCBAnGu3RVN93jfDVzyjk8jPhXft6veOQ"

--ZCBAnGu3RVN93jfDVzyjk8jPhXft6veOQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/10/20 3:22 PM, Marcelo Tosatti wrote:
> On Wed, Sep 09, 2020 at 11:08:18AM -0400, Nitesh Narayan Lal wrote:
>> This patch limits the pci_alloc_irq_vectors max vectors that is passed o=
n
>> by the caller based on the available housekeeping CPUs by only using the
>> minimum of the two.
>>
>> A minimum of the max_vecs passed and available housekeeping CPUs is
>> derived to ensure that we don't create excess vectors which can be
>> problematic specifically in an RT environment. This is because for an RT
>> environment unwanted IRQs are moved to the housekeeping CPUs from
>> isolated CPUs to keep the latency overhead to a minimum. If the number o=
f
>> housekeeping CPUs are significantly lower than that of the isolated CPUs
>> we can run into failures while moving these IRQs to housekeeping due to
>> per CPU vector limit.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  include/linux/pci.h | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 835530605c0d..750ba927d963 100644
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
>> @@ -1797,6 +1798,21 @@ static inline int
>>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>>  =09=09      unsigned int max_vecs, unsigned int flags)
>>  {
>> +=09unsigned int num_housekeeping =3D num_housekeeping_cpus();
>> +=09unsigned int num_online =3D num_online_cpus();
>> +
>> +=09/*
>> +=09 * Try to be conservative and at max only ask for the same number of
>> +=09 * vectors as there are housekeeping CPUs. However, skip any
>> +=09 * modification to the of max vectors in two conditions:
>> +=09 * 1. If the min_vecs requested are higher than that of the
>> +=09 *    housekeeping CPUs as we don't want to prevent the initializati=
on
>> +=09 *    of a device.
>> +=09 * 2. If there are no isolated CPUs as in this case the driver shoul=
d
>> +=09 *    already have taken online CPUs into consideration.
>> +=09 */
>> +=09if (min_vecs < num_housekeeping && num_housekeeping !=3D num_online)
>> +=09=09max_vecs =3D min_t(int, max_vecs, num_housekeeping);
>>  =09return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags=
,
>>  =09=09=09=09=09      NULL);
>>  }
> If min_vecs > num_housekeeping, for example:
>
> /* PCI MSI/MSIx support */
> #define XGBE_MSI_BASE_COUNT     4
> #define XGBE_MSI_MIN_COUNT      (XGBE_MSI_BASE_COUNT + 1)
>
> Then the protection fails.

Right, I was ignoring that case.

>
> How about reducing max_vecs down to min_vecs, if min_vecs >
> num_housekeeping ?

Yes, I think this makes sense.
I will wait a bit to see if anyone else has any other comment and will post
the next version then.

>
--=20
Nitesh


--ZCBAnGu3RVN93jfDVzyjk8jPhXft6veOQ--

--Nn7UuK1yQjSSr1T9L7Zv8zociIvpUvuk0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9afy0ACgkQo4ZA3AYy
oznj9BAArL9Lf/r9SlX2R5OaGs0NE/EhttYtOxiYlsFeXOilO9r2R6nGJLhzEAuz
/kmYx2xbVqKyYhJE5qNOO365aiATxu6ZNZixN90++dwGrtj4IjA0Wqdy71IAiW8/
G4jB1UqF2WxA2KWGjaSrIGYfIYXW3J0AukTBxrXcRpEjEp3v5RHBJJwJou7lfEG8
ReQrw57XiS01TzqImv4Ki1g+cD2Iw7Y06b8tes2R9eyZNXwb7AdzZNlw3U0aB+lJ
q1ufx5Uya6Q5sVTDxrZ4emeCfFl3g8bQrdV1jXrGudVtR/CuzLtmvzQIAw/RNZiw
y8uuQHd8KBFy0m7Diwt/gR671t4Wu3I8p+zcdVqsS29k2hTmFxZCLSgG8SCzpH2u
1dyl3ZrM5Sj/nGJNFkUzNQDxyhVgjOD9I71utncTlXkv9oYbN8GtslviGLje4Hej
lLoLsQ/tBMJrmi5VZMVGGMlMRMoyIaMb9f8/7axUxgqu/2IMp34+LABSgiNArTjS
w9PdZNS2XlesqzQ2xTLhwPY1lDAQisIaXxFoZwjNr60a9zbwJdU8Hn/ChlhPe899
HPJs2UrKiNazPSafQcxaTuy5gZSmhoICx6CtxKJPz2hDS8ZV+itz2lB18sivia3g
7YCQe7IYYZbup61jJj7M6EbhXHhUbGxnPshRGSYpmHbti5h0pzY=
=RA8s
-----END PGP SIGNATURE-----

--Nn7UuK1yQjSSr1T9L7Zv8zociIvpUvuk0--

