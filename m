Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D2293EE6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408273AbgJTOjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:39:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408266AbgJTOjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603204792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=aXeK3MLG2P9hCoKS0ZUCwbeeMhEvndXiQQp3FyBsgNA=;
        b=Snjc9LLdNsm97dw1wDQau5+y9C05RV9CIOPVRag4gf6fJT6S+0uP7161Ue8f1FdFVatUz7
        zW1iyPP4pcvkFMGEipsatsDmpDCLQB0AfOl6KsCMC8GmtX9bYmv/dZk4XKF1/cHw3XUC+y
        t/pb7xteYRZKuMQTHx+3cHdoGDN2WEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-isivksn0OO2VBilmEa1GmQ-1; Tue, 20 Oct 2020 10:39:50 -0400
X-MC-Unique: isivksn0OO2VBilmEa1GmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C1831074658;
        Tue, 20 Oct 2020 14:39:47 +0000 (UTC)
Received: from [10.10.115.117] (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B635855771;
        Tue, 20 Oct 2020 14:39:40 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
Date:   Tue, 20 Oct 2020 10:39:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201020134128.GT2628@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ja5fa0lNIQnbJpPC6unqZMHfvmyf2P2Yc"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ja5fa0lNIQnbJpPC6unqZMHfvmyf2P2Yc
Content-Type: multipart/mixed; boundary="4cXLyrruUsKXa5wZgbxCmAFIlt5DOlG5Q"

--4cXLyrruUsKXa5wZgbxCmAFIlt5DOlG5Q
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/20/20 9:41 AM, Peter Zijlstra wrote:
> On Tue, Oct 20, 2020 at 09:00:01AM -0400, Nitesh Narayan Lal wrote:
>> On 10/20/20 3:30 AM, Peter Zijlstra wrote:
>>> On Mon, Oct 19, 2020 at 11:00:05AM -0300, Marcelo Tosatti wrote:
>>>>> So I think it is important to figure out what that driver really want=
s
>>>>> in the nohz_full case. If it wants to retain N interrupts per CPU, an=
d
>>>>> only reduce the number of CPUs, the proposed interface is wrong.
>>>> It wants N interrupts per non-isolated (AKA housekeeping) CPU.
>>> Then the patch is wrong and the interface needs changing from @min_vecs=
,
>>> @max_vecs to something that expresses the N*nr_cpus relation.
>> Reading Marcelo's comment again I think what is really expected is 1
>> interrupt per non-isolated (housekeeping) CPU (not N interrupts).
> Then what is the point of them asking for N*nr_cpus when there is no
> isolation?
>
> Either everybody wants 1 interrupts per CPU and we can do the clamp
> unconditionally, in which case we should go fix this user, or they want
> multiple per cpu and we should go fix the interface.
>
> It cannot be both.

Based on my understanding I don't think this is consistent, the number
of interrupts any driver can request varies to an extent that some
consumer of this API even request just one interrupt for its use.

This was one of the reasons why I thought of having a conditional
restriction.

But I agree there is a lack of consistency.

--=20
Nitesh


--4cXLyrruUsKXa5wZgbxCmAFIlt5DOlG5Q--

--Ja5fa0lNIQnbJpPC6unqZMHfvmyf2P2Yc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+O9qsACgkQo4ZA3AYy
oznNiA//T1P40BotFV/00IHw14ql/ry4mKi2+1l43JAkn0xcu5PnoQXpJaXcsIO/
wXdMiHmX4gHeaRvAs+SWrN9hh5hU1ItulrSKbF4iu1lOBGn739AI5yrgdBDOvccR
mQDQ79vuj794T9NOomdo1PnfbA0dFvTfpSwAx76QYhXyH3OYO4lTjeSZKQ1kswYd
3mUFF3IM0Wh96e2e22L2KwWFhsNkWuJO7V8XlfNPs5qVVMCZ6rYJHRp7rYBaH6Ri
ZkLHlAsoEpd+8FNI0EXDkQsEPhNDuTZ93iD4LwkCbpJsXQzpcwlGp/02jbMUDwZG
yAWZ1C2XDF3tj9Sd7zXnauBk8CWwFLZnnCoXtsvrbGeleNqevbB1zJxbM1/O/i3p
FPqQMv5tlyZDvtCA8kX5kPKZa1rRVPNCE42RHUntxY41qK+ttO6HzAMW3UdLvsBs
YxtYB4Ovwa56xL3ezXj87hcoXW2I4Ufhg19uWUsPkMtleXRlOPBwZNcQ2/B1CA6G
sMHVVIcuTLJJOtLPEWLILxV3PGcc1zm7mpOrBws24D0SnNrUCSq8tmfBnyjM1w/Y
2sTxeJPw5DlOnFn8b5sUwkPXqIbrdEnXTzh1mbchEyJ9Qh6TbRWh868HKSIL6/OM
uG2n7Ci6OVp+vJfs0p+hAVuBXUcRz8Z9ge2nsThMtPreyamxfR0=
=9QDL
-----END PGP SIGNATURE-----

--Ja5fa0lNIQnbJpPC6unqZMHfvmyf2P2Yc--

