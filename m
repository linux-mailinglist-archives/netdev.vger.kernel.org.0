Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B0429293E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgJSOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:25:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728913AbgJSOZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603117537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=MT/WNqC6EgLiO4GkBuuIgykI1RT/PfUPjn74i6i4TYo=;
        b=a4L75s8ClPtgGaXYK+3/+iq7TM/5MUOZBFO49ejuJNT8DysnK+4qarZz09OKA65xnhe3vM
        56XB2xWXf4iFGsbhOFcnf95ErGqPoXLptiRS30ko31Khm5I/Y2S848+NF91Jp27DUfiqjG
        a1DqHwKHUi/1o9hRmS7yHUJD6n3YzcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-CNAgqwshNBGyahbJdOcaJA-1; Mon, 19 Oct 2020 10:25:35 -0400
X-MC-Unique: CNAgqwshNBGyahbJdOcaJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1555818B6458;
        Mon, 19 Oct 2020 14:25:30 +0000 (UTC)
Received: from [10.10.115.9] (ovpn-115-9.rdu2.redhat.com [10.10.115.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A85425D9EF;
        Mon, 19 Oct 2020 14:25:15 +0000 (UTC)
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
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
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <48a2a9a1-d664-6770-e088-27a7786e0f7b@redhat.com>
Date:   Mon, 19 Oct 2020 10:25:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201019140005.GB17287@fuller.cnet>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tWEQL0MQ6sfQOw0wFm7bzfs6AmDdw7Dc7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tWEQL0MQ6sfQOw0wFm7bzfs6AmDdw7Dc7
Content-Type: multipart/mixed; boundary="dqzUao2zxl46IcY3BVznZvZYz5G7v1wy1"

--dqzUao2zxl46IcY3BVznZvZYz5G7v1wy1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/19/20 10:00 AM, Marcelo Tosatti wrote:
> On Mon, Oct 19, 2020 at 01:11:37PM +0200, Peter Zijlstra wrote:
>> On Sun, Oct 18, 2020 at 02:14:46PM -0400, Nitesh Narayan Lal wrote:

[...]

>>>> Also, do we really need to have that conditional on hk_cpus <
>>>> num_online_cpus()? That is, why can't we do this unconditionally?
>>> FWIU most of the drivers using this API already restricts the number of
>>> vectors based on the num_online_cpus, if we do it unconditionally we ca=
n
>>> unnecessary duplicate the restriction for cases where we don't have any
>>> isolated CPUs.
>> unnecessary isn't really a concern here, this is a slow path. What's
>> important is code clarity.

Right, I can skip that check then.

>>
>>> Also, different driver seems to take different factors into considerati=
on
>>> along with num_online_cpus while finding the max_vecs to request, for
>>> example in the case of mlx5:
>>> MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 MLX5_EQ_VEC_COMP_BASE
>>>
>>> Having hk_cpus < num_online_cpus() helps us ensure that we are only
>>> changing the behavior when we have isolated CPUs.
>>>
>>> Does that make sense?
>> That seems to want to allocate N interrupts per cpu (plus some random
>> static amount, which seems weird, but whatever). This patch breaks that.
> On purpose. For the isolated CPUs we don't want network device=20
> interrupts (in this context).
>
>> So I think it is important to figure out what that driver really wants
>> in the nohz_full case. If it wants to retain N interrupts per CPU, and
>> only reduce the number of CPUs, the proposed interface is wrong.
> It wants N interrupts per non-isolated (AKA housekeeping) CPU.
> Zero interrupts for isolated interrupts.

Right, otherwise we may end up in a situation where we run out of per CPU
vectors while we move the IRQs from isolated CPUs to housekeeping.


--=20
Thanks
Nitesh


--dqzUao2zxl46IcY3BVznZvZYz5G7v1wy1--

--tWEQL0MQ6sfQOw0wFm7bzfs6AmDdw7Dc7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+NocoACgkQo4ZA3AYy
oznqZg/7Ba39pu3NNBm56g84DMb36tVrJu7NGjL1p/BI+UMF6RMW/6BAK5zLJX0t
To4aDzAVptZcfUHW8S5Xqfk94ElvXB8eV65pqd3/iNpATBYQfJhTxz4iTb5/wc6Y
uDKrPyCqbBQzzX9MAcO2LRE84q1tmepHsqtXvTGHKXniZA/6R0jtur4fmPiESbwZ
MchNGZidx9EMHz3uh3K1RChZtygCjt7zlWjJL/3BAlnNZSatoQ4RJb2jOJ9LsE99
iuv7wXx6CK1bH6YWi7tH3GWzgLIgMO8Tmilhj4mGN25ltKFsLU4s0NI+qn3QaLIZ
x2w9oym5FBS6MgPg4j25ClCHW0DMKGvaHts0i2pkQN54L37RqJPdY+xpyISxvb5c
c6CC0u3fe0WhCHJMQJoiFVi5KTzNCFEze0gCAzZCGSl88b8VSzABIV6ASCaZb9rN
N5KcEIfEcHPohf9d82iwi3w9qg/t3SeIscykei+h4qQfPXtbI4KHUd7E9PoCdryE
/w4d3jUZAV4t5LKbBCAZzOUciZufiVBOzxEldgwfcSfOMWqj3ESkzhjgfj2NTHNV
mItfwmyOg/p/hbFadCRhvmYl7mtNbX8VF+POHPxb8MnlItt5ZifpEerhHEhuZ4Ur
ifigoCEuMCVvs8XgjRiJ2q/cjkJRG5D/3NqxPXoVMPdnyGOi/L0=
=mjOW
-----END PGP SIGNATURE-----

--tWEQL0MQ6sfQOw0wFm7bzfs6AmDdw7Dc7--

