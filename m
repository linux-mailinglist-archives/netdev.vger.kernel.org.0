Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5169A31B2
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfH3H6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:58:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:57377 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfH3H6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 03:58:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 00:58:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,446,1559545200"; 
   d="asc'?scan'208";a="381931845"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga006.fm.intel.com with ESMTP; 30 Aug 2019 00:57:59 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PTP: introduce new versions of IOCTLs
In-Reply-To: <20190829172113.GA2166@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com> <20190829172113.GA2166@localhost>
Date:   Fri, 30 Aug 2019 10:57:55 +0300
Message-ID: <87tv9zulto.fsf@gmail.com>
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
>> @@ -139,11 +141,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned in=
t cmd, unsigned long arg)
>>  		break;
>>=20=20
>>  	case PTP_EXTTS_REQUEST:
>> +	case PTP_EXTTS_REQUEST2:
>> +		memset(&req, 0, sizeof(req));
>> +
>>  		if (copy_from_user(&req.extts, (void __user *)arg,
>>  				   sizeof(req.extts))) {
>>  			err =3D -EFAULT;
>>  			break;
>>  		}
>> +		if ((req.extts.flags || req.extts.rsv[0] || req.extts.rsv[1])
>> +			&& cmd =3D=3D PTP_EXTTS_REQUEST2) {
>> +			err =3D -EINVAL;
>> +			break;
>> +		} else if (cmd =3D=3D PTP_EXTTS_REQUEST) {
>> +			req.extts.flags =3D 0;
>
> This still isn't quite right.  Sorry that was my fault.
>
> The req.extts.flags can be (PTP_ENABLE_FEATURE | PTP_RISING_EDGE |
> PTP_FALLING_EDGE), and ENABLE is used immediately below in this case.
>
> Please #define those bits into a valid mask, and then:
>
> - for PTP_EXTTS_REQUEST2 check that ~mask is zero, and
> - for PTP_EXTTS_REQUEST clear the ~mask bits for the drivers.=20
>
> Thanks again for cleaning this up!

good point. This will actually reduce the size of the patch 2.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1o1wMACgkQzL64meEa
mQbDew/8DWmKxzYX8IhPyw6YmM+i3b0kv5RlGKOYOqGtkO8iVjIB2jSPFt+754dx
lYonGzZjiRrZ31OQNscDHRfOJ89S6oC4WvGraOZiSEBh29qFg/SJ+BglUqaJDFW5
v38sir9P/70aiCv8C7SWPC+dzlQ4xkVvzLwXSZidDUXmxun/2G1fxZhkQDWtXROq
fgprli6RBgeYN4HkpmdSSxbC5AwQJmuz/yEGRX5R1pGZaL0zhQERTVd3+eM8bbRQ
IJDqeQyZmRO9HkgnK9uvoqRpVc4F7nJ3CKd46Kfn5N8aa3saJXC1HW2LAlJJykB4
3ZwYEApO+fw/j04O+AYYX+3NZ/qXGymKmaiUJUbPd2zmIeM4gOqfpZRtKX86A3aU
U6I7KKfaBbee7gbkC64NnFSRaIBZJWQLPEMqrQpYTmDgsJTT5Atu9Oe1U+xqyn9p
fWBowyY6B9IexxmGWjSlfdbEbZNNA7FxMs4XH4GwSlZWaBhG2slAacu3S2y1HPnq
Bat2diD7gWrkRwfcbYnrvp/8DDXqZJ/xp6JB1dNta0AAnVflW043/0ai7DE395JZ
jAZoOkUuHr8YNcKSs3rk/fMaXNY9oiX/1+Rus1Pdrf/LvWh4WfwD+KYotS+jxZsw
Zby4phO8t9E4fEbzzcRRFjj2gMdPBO3QtKCDyxZS8RGmoPztzrA=
=FFVY
-----END PGP SIGNATURE-----
--=-=-=--
