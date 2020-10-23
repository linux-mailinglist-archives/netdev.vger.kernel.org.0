Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E413297102
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750184AbgJWN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:58:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S373820AbgJWN6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603461530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=/WCYXn37gQSCs9o7SNYGwIAcYD14xBtSSHAolMAhqvg=;
        b=QgLeO1dCztfCjsoPaCydUHGaXXiDoKGo96uf+sOUjz5NHDN2oxNhasraoQcZjF1PVdsPcy
        S5/uDMToJQJLdkuWKpGT1XzJm5nqgbD4Xr0W28knVAm1WbUwSB2jmKY+taVSsIivIjWudn
        eHolajncQ/cM/AvuXYSVlyYqZFlS3JA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-rYwI2ArmOKuhp6pFy78uNQ-1; Fri, 23 Oct 2020 09:58:45 -0400
X-MC-Unique: rYwI2ArmOKuhp6pFy78uNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD41B1052517;
        Fri, 23 Oct 2020 13:58:30 +0000 (UTC)
Received: from [10.10.113.74] (ovpn-113-74.rdu2.redhat.com [10.10.113.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC92576643;
        Fri, 23 Oct 2020 13:57:54 +0000 (UTC)
Subject: Re: [PATCH v4 2/4] sched/isolation: Extend nohz_full to isolate
 managed IRQs
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
        vincent.guittot@linaro.org, lgoncalv@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-3-nitesh@redhat.com>
 <20201023132505.GZ2628@hirez.programming.kicks-ass.net>
 <20201023132950.GA47962@lothringen>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <804569ba-a980-a4e7-59a7-3ef4ac8660de@redhat.com>
Date:   Fri, 23 Oct 2020 09:57:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201023132950.GA47962@lothringen>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2ktHMrMxseM9vEwdga0WayDwzTpUc1mvq"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2ktHMrMxseM9vEwdga0WayDwzTpUc1mvq
Content-Type: multipart/mixed; boundary="sV1FsSG3oRSUp4QUIelJW8R1co3r99GoG"

--sV1FsSG3oRSUp4QUIelJW8R1co3r99GoG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/23/20 9:29 AM, Frederic Weisbecker wrote:
> On Fri, Oct 23, 2020 at 03:25:05PM +0200, Peter Zijlstra wrote:
>> On Mon, Sep 28, 2020 at 02:35:27PM -0400, Nitesh Narayan Lal wrote:
>>> Extend nohz_full feature set to include isolation from managed IRQS. Th=
is
>> So you say it's for managed-irqs, the feature is actually called
>> MANAGED_IRQ, but, AFAICT, it does *NOT* in fact affect managed IRQs.
>>
>> Also, as per Thomas' earlier points, managed-irqs are in fact perfectly
>> fine and don't need help at at...
>>
>>> is required specifically for setups that only uses nohz_full and still
>>> requires isolation for maintaining lower latency for the listed CPUs.
>>>
>>> Suggested-by: Frederic Weisbecker <frederic@kernel.org>
> Ah and yes there is this tag :-p
>
> So that's my bad, I really thought this thing was about managed IRQ.
> The problem is that I can't find a single documentation about them so I'm
> too clueless on that matter.

I am also confused with this terminology.
So my bad for not taking care of this.

--=20
Thanks
Nitesh


--sV1FsSG3oRSUp4QUIelJW8R1co3r99GoG--

--2ktHMrMxseM9vEwdga0WayDwzTpUc1mvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+S4WEACgkQo4ZA3AYy
ozmJIxAArjWqQ6WQ2t/TL7exwbOlYDx9CJmp6xiTVrQfq6w6GhtPemGgnnUbKjbD
+KR3FTarDxi4Iv6A6SMzZ5m16LIwB0GrCCjrTB+/1kKD1SY3LyYXYujcoq6al1aL
3kcgdNt0cYTI8epiF3tuK/84IU1+tBkURSk8oYN1hQTDudmV/tvvwuSiWFsIT1wW
0G0SXBw6sLDG6tytRrIy/vDvlFi4qhYZ4PDTFpP2O1Z31ghsgQ9+upsf+I6M9+a6
yOhaEECXYGEXuXHFM3Be79qMQB2ho6soAG+v+n3ROEiHTf5dd7aiX8tJtxkntWXo
q8dn1i4arIaYqRr1nIAHSQGNLMadLNq9DCbtn6RIRIf9axBfb816efJupsYv8pjc
AYcTmDNVKFP8b+DWUKd61ATqhu1G51beoyy7PY7El26MIAtPLDIPn3KNBMJQqM/S
lrpo63plXHjYlswlnCIRmXosOXgmLMPGQNxqjSQq+ZMQOAtBsTCOUj7+OIou/u0N
YQhGp4Yoz2Y5ev7jmFHYn3UPL2UD3I8c2gh2cF5H7S7SlcbF+aB5aqV6W2supi5F
Ece5FZDDJ0BnaSJAQbSZOi3Uog/JJUfULNC1Qf4MoHhcd4JGRPXLjPgDEssKKqCZ
YWUDer6QxTH3Dygch0Rwi+QLMl6NlvjpEVyCWrngPXN5B1eW9nY=
=u+sF
-----END PGP SIGNATURE-----

--2ktHMrMxseM9vEwdga0WayDwzTpUc1mvq--

