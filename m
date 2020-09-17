Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97426E3A3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIQSby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:31:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbgIQSbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600367476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=zxw5d90miAtxM8P5wNzW5NeHRvhoE+uodlDdPhwXToA=;
        b=UAzuDRoF0HEegSijiIoUnDz8UFt3Yphkz35m4TUVQsgrKnc1ztkS195hYwuhwiYSdWEVpX
        +vbMXTfFXUEqKiycBkt32Qkasz1bvfqd7fXQfFwgn02rN+ON8RzgsZX24SWxUzUPfL1Zec
        HhoNyxvCWsp/bZpdsvtMWIyVwsyHhsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-xzXlq8dcMj2zp5Fb-3iqug-1; Thu, 17 Sep 2020 14:31:12 -0400
X-MC-Unique: xzXlq8dcMj2zp5Fb-3iqug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A108B1017DD1;
        Thu, 17 Sep 2020 18:31:10 +0000 (UTC)
Received: from [10.10.112.95] (ovpn-112-95.rdu2.redhat.com [10.10.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 989EF73665;
        Thu, 17 Sep 2020 18:31:08 +0000 (UTC)
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <9a73ab21-1ad6-9a08-b7e7-53ef85649563@redhat.com>
Date:   Thu, 17 Sep 2020 14:31:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917112359.00006e10@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KuyjQ2f6cyatlvQOCElcrdtVdI72uU5jx"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KuyjQ2f6cyatlvQOCElcrdtVdI72uU5jx
Content-Type: multipart/mixed; boundary="CgNCe2qqWcbuAbVd5xdXNH1TGSYkm4r5h"

--CgNCe2qqWcbuAbVd5xdXNH1TGSYkm4r5h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/17/20 2:23 PM, Jesse Brandeburg wrote:
> Nitesh Narayan Lal wrote:
>
>> In a realtime environment, it is essential to isolate unwanted IRQs from
>> isolated CPUs to prevent latency overheads. Creating MSIX vectors only
>> based on the online CPUs could lead to a potential issue on an RT setup
>> that has several isolated CPUs but a very few housekeeping CPUs. This is
>> because in these kinds of setups an attempt to move the IRQs to the
>> limited housekeeping CPUs from isolated CPUs might fail due to the per
>> CPU vector limit. This could eventually result in latency spikes because
>> of the IRQ threads that we fail to move from isolated CPUs.
>>
>> This patch prevents i40e to add vectors only based on available
>> housekeeping CPUs by using num_housekeeping_cpus().
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> The driver changes are straightforward, but this isn't the only driver
> with this issue, right?

Indeed, I was hoping to modify them over the time with some testing.

>   I'm sure ixgbe and ice both have this problem
> too, you should fix them as well, at a minimum, and probably other
> vendors drivers:

Sure, I can atleast include ixgbe and ice in the next posting if that makes
sense.
The reason I skipped them is that I was not very sure about the right way t=
o
test these changes.

>
> $ rg -c --stats num_online_cpus drivers/net/ethernet
> ...
> 50 files contained matches
>
> for this patch i40e
> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
--=20
Thanks
Nitesh


--CgNCe2qqWcbuAbVd5xdXNH1TGSYkm4r5h--

--KuyjQ2f6cyatlvQOCElcrdtVdI72uU5jx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9jq2sACgkQo4ZA3AYy
ozl9Gg/9GwNwBWC1b1qa6LfgFjF0OJqwQ5Or3MrysX70TLodlEvzhtpV2SbTn2md
b0pkwoeSZLcYmdDwtxB63o2MPrTWtE6ccNkQTyF1/TZGzxMTHboaDKDXl0IiX7AP
5Xp1rmpufTxdDQYt1pnfWQc+Ao4iIcP2k1liXPsy4Zz08+ljnO3YcUmdd+8ccTWT
XWGXZCyHAY3HoRYAsEI9mmULph65fp23k6LKgetozWRe0PHSdt21GRgO54sywtvn
JqC5OZTuAWNzzXU1lU6uCp1QXOayn9ZhBr/1+YFI72GcO0fonucZBN0HczbJXiq3
Ej8mdoT6yY0syKvnYAllBAf802qbxSE1Rp6iYlDovym1z7hfo9PlLgjDThZSXyGJ
0BTQqW5CIrznLozhkn2i5kTbEJsUmiyV255jyX6Z7c3WzJUbJTLgcX4IxYuNrzgz
5glxdoitBkDrUrJj106ZtekPMSyyDWuPwB65nZT+k48HB5p9Os1GKF4rn/uCEj2E
r3MgBYvg/E6l8IJHBXxN4h/IR70N+xq3CkShWs5FjslpiLdRjT1VpeyCdRb5yRwQ
sjOkv9JQhO+JTrsf4/mXBvwI0tbqaQK9r3xDNJhSfkg9VHplHnyiWm2aKxZxh3an
0VbnhaDk9CJ0I8/01lJ/JJGHVgfPofTZLLFxb8l2WlLJLHkDqQk=
=klHd
-----END PGP SIGNATURE-----

--KuyjQ2f6cyatlvQOCElcrdtVdI72uU5jx--

