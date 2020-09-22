Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC727391E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 05:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgIVDIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 23:08:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbgIVDIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 23:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600744109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=56SiaiFmcx0WZ7W7/RYC3m7L4WpINiOIKf5/ZUx5d1E=;
        b=Ov5Dg5V8tSeZWzHwJ8/DNO1RtG26bnDHAX2kUU3f95jy16uH1L6NgxDGYko/G4Idc/iyYs
        OTGuQFZxo/cl6Td01Vvlrvy29quuTFpEj6md78b2pIrFU4YQNJTPMcFPXxSUEw4QFsevzy
        qAsvxRqURgIqRsdBfzKi/4scYl8EE90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-xKMccpLTMruVsLaHcdSSZg-1; Mon, 21 Sep 2020 23:08:25 -0400
X-MC-Unique: xKMccpLTMruVsLaHcdSSZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB680807333;
        Tue, 22 Sep 2020 03:08:23 +0000 (UTC)
Received: from [10.10.115.46] (ovpn-115-46.rdu2.redhat.com [10.10.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 808602633C;
        Tue, 22 Sep 2020 03:08:21 +0000 (UTC)
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
To:     Frederic Weisbecker <frederic@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com> <20200921225834.GA30521@lenoir>
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
Message-ID: <65513ee8-4678-1f96-1850-0e13dbf1810c@redhat.com>
Date:   Mon, 21 Sep 2020 23:08:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200921225834.GA30521@lenoir>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oKDFpOFbxY7K0uJXqzOfR5adtfOqHM0cY"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oKDFpOFbxY7K0uJXqzOfR5adtfOqHM0cY
Content-Type: multipart/mixed; boundary="0jeSKN7YbEcXkMb4OWyQ21AuKmUGsoZ1L"

--0jeSKN7YbEcXkMb4OWyQ21AuKmUGsoZ1L
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/21/20 6:58 PM, Frederic Weisbecker wrote:
> On Thu, Sep 17, 2020 at 11:23:59AM -0700, Jesse Brandeburg wrote:
>> Nitesh Narayan Lal wrote:
>>
>>> In a realtime environment, it is essential to isolate unwanted IRQs fro=
m
>>> isolated CPUs to prevent latency overheads. Creating MSIX vectors only
>>> based on the online CPUs could lead to a potential issue on an RT setup
>>> that has several isolated CPUs but a very few housekeeping CPUs. This i=
s
>>> because in these kinds of setups an attempt to move the IRQs to the
>>> limited housekeeping CPUs from isolated CPUs might fail due to the per
>>> CPU vector limit. This could eventually result in latency spikes becaus=
e
>>> of the IRQ threads that we fail to move from isolated CPUs.
>>>
>>> This patch prevents i40e to add vectors only based on available
>>> housekeeping CPUs by using num_housekeeping_cpus().
>>>
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> The driver changes are straightforward, but this isn't the only driver
>> with this issue, right?  I'm sure ixgbe and ice both have this problem
>> too, you should fix them as well, at a minimum, and probably other
>> vendors drivers:
>>
>> $ rg -c --stats num_online_cpus drivers/net/ethernet
>> ...
>> 50 files contained matches
> Ouch, I was indeed surprised that these MSI vector allocations were done
> at the driver level and not at some $SUBSYSTEM level.
>
> The logic is already there in the driver so I wouldn't oppose to this ver=
y patch
> but would a shared infrastructure make sense for this? Something that wou=
ld
> also handle hotplug operations?
>
> Does it possibly go even beyond networking drivers?

From a generic solution perspective, I think it makes sense to come up with=
 a
shared infrastructure.
Something that can be consumed by all the drivers and maybe hotplug operati=
ons
as well (I will have to further explore the hotplug part).

However, there are RT workloads that are getting affected because of this
issue, so does it make sense to go ahead with this per-driver basis approac=
h
for now?

Since a generic solution will require a fair amount of testing and
understanding of different drivers. Having said that, I can definetly start
looking in that direction.

Thanks for reviewing.

> Thanks.
>
>> for this patch i40e
>> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
--=20
Nitesh


--0jeSKN7YbEcXkMb4OWyQ21AuKmUGsoZ1L--

--oKDFpOFbxY7K0uJXqzOfR5adtfOqHM0cY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9paqQACgkQo4ZA3AYy
ozm5FA//Q0Z1C8cHYE+V2T9l32k2cMBP9lWb4o9X8NISq9YeLyWLNM8u22H/FzTm
15TIcE7Ypv9WdrZkPM4iB1iHN3St7z9LxZs5QhFz1aMYonXG9W9GfyQ1YEs3hQHz
obUAaOoPGGSttmgAwWz7AcxPiZ2tpZuPJ3Aq+3MZ3VWNGs14I79OyfKxT/GShg+w
TTOiYXsW+BjFiz3ZUi4VKpGacCv83Qz603VBFIbxCQmTFh8OCIiWiRd6lDRrBdEr
e/gU23GS+p/9IGrNjdjgFnRgKCHLp06xd6czVJK1OABNiJhdfETkQB3quKWCWcUF
T0WTcSowqSNwhRXsMYD4uQnH/xdPGNGgg4Il/qjLkMnMsxTDerCJSGMPGGRW+/uK
ipByG2Pp3kevLqtpu3tPKiq6sXojLLvPkslpjC8YEb/kRzCAlFtGOOJQoOmxa19A
LtxJfN/pMXBIBL6X7vH7SHI7RzAlFr5EJud+n+2F8h/uPBKtCdTCdAcMkDhTl3P0
SWXY7ufGbFrB/EzqJblJbB+4ceC7iHvcTq+A1u8SwF0vQ/4A+k9aS1AMD3QwW7LI
xu7f077f7zz8IqclvQYvwoeO0EJlLaeKvfhcOrpKkIBK2e6aXXPgivFNhObs8ak3
aIxSx831J4vuDbXwLKTL+t1CK0kpTy+TOGSkblnxT3BwpIdcWLQ=
=CGoR
-----END PGP SIGNATURE-----

--oKDFpOFbxY7K0uJXqzOfR5adtfOqHM0cY--

