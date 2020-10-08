Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3567287E28
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgJHVkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:40:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727155AbgJHVkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602193250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=WcXXjV46s1bUQqy4uPRXgKfYRGboA2UeGxiflOgLZl8=;
        b=fCwWoAdeav1wlDaLfLE6R+MqopjT0mJciE2l6Jl2cPK48YGJVAm+bhm0jSZ/ekBX9Fe7ht
        gdSD9NBHiVCbqaLxJyiaLtEAlOLDeN4EnW1GDS6yiuCGWF5L8Jbs8/FjJbrVAAN644MFk7
        ZfC8eBui14saRqj0dWGQFKjWJx8P35g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-NWkLUk2COMq4KN2q7EFluw-1; Thu, 08 Oct 2020 17:40:47 -0400
X-MC-Unique: NWkLUk2COMq4KN2q7EFluw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AF0210BBEC3;
        Thu,  8 Oct 2020 21:40:44 +0000 (UTC)
Received: from [10.10.116.35] (ovpn-116-35.rdu2.redhat.com [10.10.116.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B13A5D9E8;
        Thu,  8 Oct 2020 21:40:38 +0000 (UTC)
Subject: Re: [PATCH v4 0/4] isolation: limit msix vectors to housekeeping CPUs
To:     Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20201001154949.GA7303@lothringen>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <9c55624f-2a01-b71c-7f66-3747cb844e5a@redhat.com>
Date:   Thu, 8 Oct 2020 17:40:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201001154949.GA7303@lothringen>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="heeEo5bPSt8tDxfLevOi2iHjIVyCmRRtx"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--heeEo5bPSt8tDxfLevOi2iHjIVyCmRRtx
Content-Type: multipart/mixed; boundary="UTa52EjRe2zfZcHcSODI6jAoxYBPRp7mX"

--UTa52EjRe2zfZcHcSODI6jAoxYBPRp7mX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/1/20 11:49 AM, Frederic Weisbecker wrote:
> On Mon, Sep 28, 2020 at 02:35:25PM -0400, Nitesh Narayan Lal wrote:
>> Nitesh Narayan Lal (4):
>>   sched/isolation: API to get number of housekeeping CPUs
>>   sched/isolation: Extend nohz_full to isolate managed IRQs
>>   i40e: Limit msix vectors to housekeeping CPUs
>>   PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
>>
>>  drivers/net/ethernet/intel/i40e/i40e_main.c |  3 ++-
>>  drivers/pci/msi.c                           | 18 ++++++++++++++++++
>>  include/linux/sched/isolation.h             |  9 +++++++++
>>  kernel/sched/isolation.c                    |  2 +-
>>  4 files changed, 30 insertions(+), 2 deletions(-)
> Acked-by: Frederic Weisbecker <frederic@kernel.org>
>
> Peter, if you're ok with the set, I guess this should go through
> the scheduler tree?
>
> Thanks.

Hi Peter,

I wanted follow up to check if you have any concerns/suggestions that I
should address in this patch-set before this can be picked?

--=20
Thanks
Nitesh


--UTa52EjRe2zfZcHcSODI6jAoxYBPRp7mX--

--heeEo5bPSt8tDxfLevOi2iHjIVyCmRRtx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9/h1QACgkQo4ZA3AYy
oznxaxAAq437n/C4ULMSr9ziKrTkK3qofMr7jMAxbHIMUU4kLdFunyz7EJUoVsap
z/hyYjVBVBnHsdMiOFLT1uZHAcgDP4bxDkMr6iI8514eu0pYRlrRvifAZZ36+ZXw
RCc/WnxPWodTp1793s3pCp25IghplWBLvGHVxQ49vtI++FGErB0J2eHVzPY6wtK4
PMX0Nu2kAf3wiD36aS3HHlLwNSdCtuLL5xgctOfu/SU3ksmWSHyAy7yWmLyUce1G
SYiIOCMG/nlavgdYEu6k/jiFOGhuPlBMWUvVGgyjlvpxEIx0+nCOu84A7cz6Zv0q
AajATl37Lvex3kBYQz+ffZh514pBeVuYIhBFsO2ZRn5t0I3eK2Q46BwjK+iJzMft
zvR0BZkZHFUHETFF6DHcs8k7iymCBjLAlF3XWohPu0sRsY9C70tNzNgi3fW63yLn
SQiggHg+AsefRE6N0a4k0KSlbBr+lz8o6IhJnHWmwVQi5islK1JvbOkCOnaPXla6
nrjxaq4c3uUSOuIrWPKacbRoLMnOECxQEzpRZ46XhTyJ1Xc5rpUUQlXasftTO5X/
3Kbwix7VsiIuyl0kzOkdsv+6jE0TMUZg4Rg6tApa89/iOGsN5PGZwd+2R94VqnYp
nulQKS+oAZkYlJmNF6X/1H1XJNNsGofeMYHISHoF3isaRVolJ8E=
=4dfe
-----END PGP SIGNATURE-----

--heeEo5bPSt8tDxfLevOi2iHjIVyCmRRtx--

