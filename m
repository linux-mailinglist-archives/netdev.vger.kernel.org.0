Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E61E29700E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464367AbgJWNLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S372434AbgJWNLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603458679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ndpmUdrqPfRnQOR1QB66RbMcult4c4e6pOI15l755so=;
        b=Q10pBcowzdk8R7Rnu/0jI+LYNUycUO1l/I10rz9gY/KSbc0jJ5luTTK1YBhYJ0/QHSzZcJ
        9sE/z7K9WQwNnoMdLdV+j5BC7FSnjVYYjvQiH8k6nZYvP+Hdpdb/yZkoBKBFJAm34JKKP9
        JabJE504HH7bbmXGJkYnUBwXwnTip/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-J-0kNpkgOtKEnQ0ViZRblw-1; Fri, 23 Oct 2020 09:11:14 -0400
X-MC-Unique: J-0kNpkgOtKEnQ0ViZRblw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C622C81EE66;
        Fri, 23 Oct 2020 13:11:10 +0000 (UTC)
Received: from [10.10.113.74] (ovpn-113-74.rdu2.redhat.com [10.10.113.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C6C64D75F;
        Fri, 23 Oct 2020 13:10:43 +0000 (UTC)
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, helgaas@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
References: <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
 <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
 <20201023085826.GP2611@hirez.programming.kicks-ass.net>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
Date:   Fri, 23 Oct 2020 09:10:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201023085826.GP2611@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oQlDKWr9GNJpxItvUxtXry58hfGBQpQgR"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oQlDKWr9GNJpxItvUxtXry58hfGBQpQgR
Content-Type: multipart/mixed; boundary="eL5tY0q3165KuTjpbfwfXLhzBvxhWkdwC"

--eL5tY0q3165KuTjpbfwfXLhzBvxhWkdwC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/23/20 4:58 AM, Peter Zijlstra wrote:
> On Thu, Oct 22, 2020 at 01:47:14PM -0400, Nitesh Narayan Lal wrote:
>
>> Hi Peter,
>>
>> So based on the suggestions from you and Thomas, I think something like =
the
>> following should do the job within pci_alloc_irq_vectors_affinity():
>>
>> + =C2=A0 =C2=A0 =C2=A0 if (!pci_is_managed(dev) && (hk_cpus < num_online=
_cpus()))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_vecs =3D clamp(hk=
_cpus, min_vecs, max_vecs);
>>
>> I do know that you didn't like the usage of "hk_cpus < num_online_cpus()=
"
>> and to an extent I agree that it does degrade the code clarity.
> It's not just code clarity; I simply don't understand it. It feels like
> a band-aid that breaks thing.
>
> At the very least it needs a ginormous (and coherent) comment that
> explains:
>
>  - the interface
>  - the usage
>  - this hack

That make sense.

>
>> However, since there is a certain inconsistency in the number of vectors
>> that drivers request through this API IMHO we will need this, otherwise
>> we could cause an impact on the drivers even in setups that doesn't
>> have any isolated CPUs.
> So shouldn't we then fix the drivers / interface first, to get rid of
> this inconsistency?
>

Considering we agree that excess vector is a problem that needs to be
solved across all the drivers and that you are comfortable with the other
three patches in the set. If I may suggest the following:

- We can pick those three patches for now, as that will atleast fix a
=C2=A0 driver that is currently impacting RT workloads. Is that a fair
=C2=A0 expectation?

- In the meanwhile, I will start looking into individual drivers that
=C2=A0 consume this API to find out if there is a co-relation that can be
=C2=A0 derived between the max_vecs and number of CPUs. If that exists then=
 I
=C2=A0 can go ahead and tweak the API's max_vecs accordingly. However, if t=
his
=C2=A0 is absolutely random then I can come up with a sane comment
=C2=A0 before this check that covers the list of items you suggested.

- I also want to explore the comments made by Thomas which may take
=C2=A0 some time.


--=20
Thanks
Nitesh


--eL5tY0q3165KuTjpbfwfXLhzBvxhWkdwC--

--oQlDKWr9GNJpxItvUxtXry58hfGBQpQgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+S1lIACgkQo4ZA3AYy
ozlo6xAAsLMkK9fG19Pf0OQkWpGzytSKDlGVOP/j0XAG6zJIEIlyAgGH0cPUI8WN
ywYxTHZ8fval3yl0FkD85oOUKPW9dGdu8tOdJG3By8m3i2xNRX6QFLCR/QTGMaZI
2JPMCmldC+yqzGLCGyWvAUNzMVqCwr4EVTg0uMiEA3TvTlhebHnAZy6un86yC/64
Sscd5xkHZVu28srnr/nT73/2XRF+10ewJ3dASVOXtLw8nW0ct4q4oGxeYxd8Ek09
FOkz2ENLbAk+K56CotPfYFnbtse0zuSqAr6mIm1wecqFUDUSZKm5UOn1bpMUFtcs
Et8p2pncdVhajosuwfpb4lDoYcvrYfYf+FYzqBFGIy4hzfgPJfMCsXgCS7IMGgOf
yTahwivWQcYr0PrlCmEfrRpRmaiyoep4v1M3TEngSqtAV4n/amFuiOsKqpIzBsMe
QBWaYNtwNNasO3HoaPuB34BICMJFDe4av6BtG0LWzmti3FumwBkqrdfjmcBMdv7b
AuY2DG5L8nLaHE8SdTMAgXRuPAp5JFnUifk7JUeommDJx620maU6PFUHM5O7Lx9j
YPUwGboG/E9q8fEgj4aIXnsx2w1cQcyvxt0JLevDBwmK5K7jHJi6SJDe/1BM17T4
hs399A5FGySMlA9L6G+YXYs6DsJqo30M2sGeYopzVNSWabEetu8=
=gv+7
-----END PGP SIGNATURE-----

--oQlDKWr9GNJpxItvUxtXry58hfGBQpQgR--

