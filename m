Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A55A31BD
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfH3IA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:00:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:24868 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfH3IA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 04:00:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 01:00:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,446,1559545200"; 
   d="asc'?scan'208";a="197984393"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga001.fm.intel.com with ESMTP; 30 Aug 2019 01:00:24 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
In-Reply-To: <20190829172848.GC2166@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com> <20190829095825.2108-2-felipe.balbi@linux.intel.com> <20190829172509.GB2166@localhost> <20190829172848.GC2166@localhost>
Date:   Fri, 30 Aug 2019 11:00:20 +0300
Message-ID: <87r253ulpn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Richard Cochran <richardcochran@gmail.com> writes:
> Adding davem onto CC...
>
> On Thu, Aug 29, 2019 at 12:58:25PM +0300, Felipe Balbi wrote:
>> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
>> index 98ec1395544e..a407e5f76e2d 100644
>> --- a/drivers/ptp/ptp_chardev.c
>> +++ b/drivers/ptp/ptp_chardev.c
>> @@ -177,9 +177,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int =
cmd, unsigned long arg)
>>  			err =3D -EFAULT;
>>  			break;
>>  		}
>> -		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
>> -				|| req.perout.rsv[2] || req.perout.rsv[3])
>> -			&& cmd =3D=3D PTP_PEROUT_REQUEST2) {
>> +		if ((req.perout.rsv[0] || req.perout.rsv[1] || req.perout.rsv[2]
>> +			|| req.perout.rsv[3]) && cmd =3D=3D PTP_PEROUT_REQUEST2) {
>
> Please check that the reserved bits of req.perout.flags, namely
> ~PTP_PEROUT_ONE_SHOT, are clear.

Actually, we should check more. PEROUT_FEATURE_ENABLE is still valid
here, right? So are RISING and FALLING edges, no?

>
>>  			err =3D -EINVAL;
>>  			break;
>>  		} else if (cmd =3D=3D PTP_PEROUT_REQUEST) {
>> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clo=
ck.h
>> index 039cd62ec706..95840e5f5c53 100644
>> --- a/include/uapi/linux/ptp_clock.h
>> +++ b/include/uapi/linux/ptp_clock.h
>> @@ -67,7 +67,9 @@ struct ptp_perout_request {
>>  	struct ptp_clock_time start;  /* Absolute start time. */
>>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>>  	unsigned int index;           /* Which channel to configure. */
>> -	unsigned int flags;           /* Reserved for future use. */
>> +
>> +#define PTP_PEROUT_ONE_SHOT BIT(0)
>> +	unsigned int flags;
>
> @davem  Any CodingStyle policy on #define within a struct?  (Some
> maintainers won't allow it.)

seems like this should be defined together with the other flags? If
that's the case, it seems like we would EXTTS and PEROUT masks.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1o15QACgkQzL64meEa
mQY0jBAA1zCKLgKpD6T5AY9iNnfG+uJQm7wlFLkhxf6nmWqVOIDXeKKqTKlY6t/U
SRcyjH5aEUM+r4sWHlkC3nue7fyI4I492bxe/ToBgUnkifGsc55/PtZCaRrIvh6H
crSnwiG/+dA9LlI6nI1woq1Rd/AcUwJ6SAV8zHjUyWWo3/Pp7XJUwM9LRF10jrVj
WG8OGKNhmFoCSn0esIyzFRaTGPUDEycQ7MjfhBDlaRca/pL60N4Y/e0Q+K2h5zSt
tQU9Qa6NsyPBqYWMYR2+vAIBNq8pWAXnebYH3UbViAPOSDBLeFE8CezcAefZVgc7
n5xYHMhRZgZKLG1QaD2jBysh0yFOGYDX0vY4hYUQeucgJUU3ksZtSVIAphupoxh3
xjgvGN77ZxDUkQmwOmNfu2nEgYILdiSHuyOjFqmynFpDO2e0Dc4BafiNN4DjaRjI
XrJREEgPGU6ck4FtVtQ1+22yxusNk2nqpAe5v5IDCbqZ7jmVgWiOqZGdJUhoqhIG
KBWMM/UoA1ft5SdZvKidvZf0TIYsfCjAA9eEOgiRBf1CBRISmA51WJzL/uSSc+Qv
mLeFHjwN/UdxO30fMDmjXxS86/6J1o6qQ1/8nZBbGSW6O3FqiUiR8sA7wW8j8gZE
RQaXWTQmIeRCoPVqsJn0whIo9eOsL1t7N5Bkv1+ZsmBkioKHaVQ=
=KWTp
-----END PGP SIGNATURE-----
--=-=-=--
