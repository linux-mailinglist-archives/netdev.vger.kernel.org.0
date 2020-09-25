Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772D72793A6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYViW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbgIYViW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:38:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gpW0sj/nM7AwMpbkqOmCDPVLocu/rnov7w2AYNtGosY=;
        b=aIoOuHxX3XvopvWqzL1WADRiZPpeKz/LoUlmmywPeA78QRik6BOgV53W1Ln2m/x9/O/Mwv
        EjIJh8szgNzGNED1r9dWYCA8MzVnnU7o+3h5kL96iwFH+bk9fN4UArnf2a4ls+OD14QxDP
        /TjWQSpVg1i3Cmak8WDnaZSNA5hq2BU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-kd5xHqXCP4iz6dgTFozQaQ-1; Fri, 25 Sep 2020 17:38:17 -0400
X-MC-Unique: kd5xHqXCP4iz6dgTFozQaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4D75805EE4;
        Fri, 25 Sep 2020 21:38:14 +0000 (UTC)
Received: from [10.10.114.192] (ovpn-114-192.rdu2.redhat.com [10.10.114.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C07D75577A;
        Fri, 25 Sep 2020 21:38:06 +0000 (UTC)
Subject: Re: [PATCH v3 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
References: <20200925202307.GA2456332@bjorn-Precision-5520>
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
Message-ID: <256490f0-0762-447c-a7be-0e5a6bb04fc4@redhat.com>
Date:   Fri, 25 Sep 2020 17:38:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925202307.GA2456332@bjorn-Precision-5520>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YGhoGpiEK97LlikE5tgeBsj6NKFwnYVHR"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YGhoGpiEK97LlikE5tgeBsj6NKFwnYVHR
Content-Type: multipart/mixed; boundary="Df7GsTEDJLdhut9BI6tcE476jLN1S7Yy0"

--Df7GsTEDJLdhut9BI6tcE476jLN1S7Yy0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/25/20 4:23 PM, Bjorn Helgaas wrote:
> On Fri, Sep 25, 2020 at 02:26:54PM -0400, Nitesh Narayan Lal wrote:
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
>>  include/linux/pci.h | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 835530605c0d..a7b10240b778 100644
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
>> @@ -1797,6 +1798,22 @@ static inline int
>>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>>  =09=09      unsigned int max_vecs, unsigned int flags)
>>  {
>> +=09unsigned int hk_cpus;
>> +
>> +=09hk_cpus =3D housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
> Add blank line here before the block comment.
>
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
>> +=09}
> It seems like you'd want to do this inside
> pci_alloc_irq_vectors_affinity() since that's an exported interface,
> and drivers that use it will bypass the limiting you're doing here.

Good point, few drivers directly use this.
I took a quick look and it seems I may also have to take the pre and the
post vectors into consideration.

>>  =09return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags=
,
>>  =09=09=09=09=09      NULL);
>>  }
>> --=20
>> 2.18.2
>>
--=20
Nitesh


--Df7GsTEDJLdhut9BI6tcE476jLN1S7Yy0--

--YGhoGpiEK97LlikE5tgeBsj6NKFwnYVHR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9uYz0ACgkQo4ZA3AYy
ozkiEBAAvGh1LoOrI92FwWB9mO6IUhqq1kV5fqaTQoQVDCd9xBSPfsWT+gsFaduP
L9udE6raj+9EpQkKdIiqcAL5Csx/8KmvNqbeY/ABw4MAlNxlcc9iBHl3dTvkAw9b
pPeMsNnQiPPt18S/SYvkUsSVD7tb8S334qRmxQqU2RgjzIX9DZINMbXVhrzbCTkJ
gTjsuFAIZyKjw6pHvqc51qWOr91TdMtk3kFyPKSEK5jUGuI36Gmuh38W5o6ZtPuZ
1t9VKvcCODdQE5ehdGN10E7Z0bjDdCkNy+qV3ddgteMr1AHctofL9FbhrAkAIreP
BZxJ9YuFkexkNbAJfUIiItFeQMJ8bEhtqz5kuGuod73HjyNsjXrYWy4sCNSizeBN
QuoMzNgXPNkp++V6Qv1ta36A+pDM/k0A/W0yC91lPhrhJoV/nWClMayOrk2ywINv
H8FtM+Ci0lA6NTVtwDgPVkBe06xgTEENtXQ4EnBxahmJ9DBWDh1N7f1P0J7KYMCB
iwxdkktbb0GcVo7/9oOObfztqO/bEat0Nz3pDhJz0XbnhVHCxDeHwtaMgWO/64UJ
f6X0MJRX9006GFx7Y2iExMzsyKypT0/+49RXOsFkLMXJidNzylG1OjZw7dtg3z5i
Bp9SpF9tRQ3laz3BnyqBuyDbT9EBm4zaUFiQG1ZAv0KqAkAOXVs=
=EFzi
-----END PGP SIGNATURE-----

--YGhoGpiEK97LlikE5tgeBsj6NKFwnYVHR--

