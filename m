Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A994274331
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIVNeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:34:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726591AbgIVNeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:34:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=BjXXS2cvZamNlQHN2YXChkhIYtax6Ed2yLlS1GlHPr4=;
        b=GCF5DemmQOqAfBvbFEaL7QuIS5+G8JAyj/NHjd2xoo1cWs0UguXX0lCu8ecwkHj+p7nC/V
        qbGwz58BKdzdYvipohecAFADOd4vDySrZ5PRTpeLKlxHEx0M59ZpiGV2REvQRml08gRPBV
        4NPELdigVGFh/m8ufmNv23Hi4bPpVPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-EGrRiKfdN_C3nU1nubrAag-1; Tue, 22 Sep 2020 09:34:08 -0400
X-MC-Unique: EGrRiKfdN_C3nU1nubrAag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 295F4425E9;
        Tue, 22 Sep 2020 13:34:06 +0000 (UTC)
Received: from [10.10.115.78] (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABACC614F5;
        Tue, 22 Sep 2020 13:34:03 +0000 (UTC)
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
To:     Frederic Weisbecker <frederic@kernel.org>, bhelgaas@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com> <20200921225834.GA30521@lenoir>
 <65513ee8-4678-1f96-1850-0e13dbf1810c@redhat.com>
 <20200922095440.GA5217@lenoir>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <1b7fba6f-85c3-50d6-a951-78db1ccfd04a@redhat.com>
Date:   Tue, 22 Sep 2020 09:34:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922095440.GA5217@lenoir>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PDZV0yVtrsnz8iCpGtGumojvMZCcYC0xg"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PDZV0yVtrsnz8iCpGtGumojvMZCcYC0xg
Content-Type: multipart/mixed; boundary="x5qKUNoegkyIUmDvOHigPup1eCGwUT80c"

--x5qKUNoegkyIUmDvOHigPup1eCGwUT80c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/22/20 5:54 AM, Frederic Weisbecker wrote:
> On Mon, Sep 21, 2020 at 11:08:20PM -0400, Nitesh Narayan Lal wrote:
>> On 9/21/20 6:58 PM, Frederic Weisbecker wrote:
>>> On Thu, Sep 17, 2020 at 11:23:59AM -0700, Jesse Brandeburg wrote:
>>>> Nitesh Narayan Lal wrote:
>>>>
>>>>> In a realtime environment, it is essential to isolate unwanted IRQs f=
rom
>>>>> isolated CPUs to prevent latency overheads. Creating MSIX vectors onl=
y
>>>>> based on the online CPUs could lead to a potential issue on an RT set=
up
>>>>> that has several isolated CPUs but a very few housekeeping CPUs. This=
 is
>>>>> because in these kinds of setups an attempt to move the IRQs to the
>>>>> limited housekeeping CPUs from isolated CPUs might fail due to the pe=
r
>>>>> CPU vector limit. This could eventually result in latency spikes beca=
use
>>>>> of the IRQ threads that we fail to move from isolated CPUs.
>>>>>
>>>>> This patch prevents i40e to add vectors only based on available
>>>>> housekeeping CPUs by using num_housekeeping_cpus().
>>>>>
>>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>>> The driver changes are straightforward, but this isn't the only driver
>>>> with this issue, right?  I'm sure ixgbe and ice both have this problem
>>>> too, you should fix them as well, at a minimum, and probably other
>>>> vendors drivers:
>>>>
>>>> $ rg -c --stats num_online_cpus drivers/net/ethernet
>>>> ...
>>>> 50 files contained matches
>>> Ouch, I was indeed surprised that these MSI vector allocations were don=
e
>>> at the driver level and not at some $SUBSYSTEM level.
>>>
>>> The logic is already there in the driver so I wouldn't oppose to this v=
ery patch
>>> but would a shared infrastructure make sense for this? Something that w=
ould
>>> also handle hotplug operations?
>>>
>>> Does it possibly go even beyond networking drivers?
>> From a generic solution perspective, I think it makes sense to come up w=
ith a
>> shared infrastructure.
>> Something that can be consumed by all the drivers and maybe hotplug oper=
ations
>> as well (I will have to further explore the hotplug part).
> That would be great. I'm completely clueless about those MSI things and t=
he
> actual needs of those drivers. Now it seems to me that if several CPUs be=
come
> offline, or as is planned in the future, CPU isolation gets enabled/disab=
led
> through cpuset, then the vectors may need some reorganization.

+1

>
> But I don't also want to push toward a complicated solution to handle CPU=
 hotplug
> if there is no actual problem to solve there.

Sure, even I am not particularly sure about the hotplug scenarios.

>  So I let you guys judge.
>
>> However, there are RT workloads that are getting affected because of thi=
s
>> issue, so does it make sense to go ahead with this per-driver basis appr=
oach
>> for now?
> Yep that sounds good.

Thank you for confirming.

>
>> Since a generic solution will require a fair amount of testing and
>> understanding of different drivers. Having said that, I can definetly st=
art
>> looking in that direction.
> Thanks a lot!
>
--=20
Nitesh


--x5qKUNoegkyIUmDvOHigPup1eCGwUT80c--

--PDZV0yVtrsnz8iCpGtGumojvMZCcYC0xg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9p/UoACgkQo4ZA3AYy
ozmWsBAAmDk7hoXzvBimZ9o8XOMTtZm4JymymG60f/Y7/vHbueNuCUG7DmI7mBiS
VJEpIR4SVvwCt0w3E3WzQAmHRyzYNxIKBkpW3p6RaSbBFhuT9nMSKOzELtiBF7AV
o9lfOMjMIiXhVcTKqxhJvIToVC0VaY4FEUvcam7BQG5DO16OCaBOMx6V5nrf5t2F
/+YVmD15dryE/rTvYuwi9AZMGXBCMOq9SwxIr2sD7W5/62E0WQH3fyJInQnpLSbK
xma8IsQaWKTdck2JBNBdBqssg/CRNSz82oHGLv5Tl/+IzUDu+t+Aody5Toq/TYJg
iDidFzqF/mNyqlBxTC8HC++ofuzfPP1UY4wZXB76NoJdbSfDEDwysls55oGsODQl
yUz1Ggaa9wul8Te0uYkezbn3pTWmMWBkWtvt7YVE6gbhWcDnr5YpAMx55/ntjl+C
x9r7UL6J5jRMkYquRO1fkeo5gFB3wQ3d1VYHG1HNo4tAMvxfwNGoL0XVHdFWx0uD
dzlwf8YzTkQVzZjQ8I05XWnm0cf7g2KS3BMBbL7ywUIriV7GGnbCbr0czpfCTeau
IyOY7RdCG6MriQPGfsg3pKY/PwFdh4MOWIRXJoQMVR4Mb1JnTeWQQA5LC3RyOJHR
Lgy78jBtNjDkGg6s7daYqnvpzRrhcu3Cfo04uePLhMsvX2fLGLg=
=OcfM
-----END PGP SIGNATURE-----

--PDZV0yVtrsnz8iCpGtGumojvMZCcYC0xg--

