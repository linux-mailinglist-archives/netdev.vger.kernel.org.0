Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729B52CBADC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgLBKok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:44:40 -0500
Received: from mail.katalix.com ([3.9.82.81]:47344 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLBKoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 05:44:39 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2020 05:44:38 EST
Received: from [IPv6:2a02:8010:6359:1:59c9:fe55:1b56:b0e1] (unknown [IPv6:2a02:8010:6359:1:59c9:fe55:1b56:b0e1])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 3E5699155F;
        Wed,  2 Dec 2020 10:34:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606905283; bh=odupBSVqzPygWae6Rs1dQ2Rx3GDGpRjvxADr3aVnKsI=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20v2=20net-next=200/2]=20add=20ppp_generi
         c=20ioctl(s)=20to=20bridge=0D=0A=20channels|To:=20Tom=20Parkin=20<
         tparkin@katalix.com>,=20netdev@vger.kernel.org|Cc:=20gnault@redhat
         .com|References:=20<20201201115250.6381-1-tparkin@katalix.com>|Fro
         m:=20James=20Chapman=20<jchapman@katalix.com>|Message-ID:=20<389f9
         a36-28ef-1bb6-e7bb-ea9f597e29f0@katalix.com>|Date:=20Wed,=202=20De
         c=202020=2010:34:43=20+0000|MIME-Version:=201.0|In-Reply-To:=20<20
         201201115250.6381-1-tparkin@katalix.com>;
        b=LvuRGqA2zHxNAvpCl2x33j8OPFhr/Zfkef+wFMD0riwvRuUg4QPFlLviZmpyGASWH
         2cYtb/xG478F0lBSRT35GzUesj4JSFVm+0EFH2AjmaFo9v2F8dm78I+DdcZJvmkJtt
         SDdo9/OWB+m2B+cJG0m7N45m7iU78SXHNHGywsahidSFXYQ/6eouJk/UEEgXGlJX5b
         M3p2bjdlQZbkyIqUkcVBBl+PqM0+E4OQV5m+cj9ublivU5jJmrOjN/rDm6YYrEp5N8
         CgHtUO+ZJ1v0kIuUpoHzRAJgT7cs68D85c4z7nxIhOaF+crbsUsI16ANx/JBLt4Hia
         cf4WMbVzRqcaA==
Subject: Re: [PATCH v2 net-next 0/2] add ppp_generic ioctl(s) to bridge
 channels
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
Cc:     gnault@redhat.com
References: <20201201115250.6381-1-tparkin@katalix.com>
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <389f9a36-28ef-1bb6-e7bb-ea9f597e29f0@katalix.com>
Date:   Wed, 2 Dec 2020 10:34:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201201115250.6381-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2020 11:52, Tom Parkin wrote:
> Following on from my previous RFC[1], this series adds two ioctl calls
> to the ppp code to implement "channel bridging".
>
> When two ppp channels are bridged, frames presented to ppp_input() on
> one channel are passed to the other channel's ->start_xmit function for
> transmission.
>
> The primary use-case for this functionality is in an L2TP Access
> Concentrator where PPP frames are typically presented in a PPPoE session
> (e.g. from a home broadband user) and are forwarded to the ISP network in
> a PPPoL2TP session.
>
> The two new ioctls, PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN form a
> symmetric pair.
>
> Userspace code testing and illustrating use of the ioctl calls is
> available in the go-l2tp[2] and l2tp-ktest[3] repositories.
>
> [1]. Previous RFC series:
>
> https://lore.kernel.org/netdev/20201106181647.16358-1-tparkin@katalix.com/
>
> [2]. go-l2tp: a Go library for building L2TP applications on Linux
> systems. Support for the PPPIOCBRIDGECHAN ioctl is on a branch:
>
> https://github.com/katalix/go-l2tp/tree/tp_002_pppoe_2
>
> [3]. l2tp-ktest: a test suite for the Linux Kernel L2TP subsystem.
> Support for the PPPIOCBRIDGECHAN ioctl is on a branch:
>
> https://github.com/katalix/l2tp-ktest/tree/tp_ac_pppoe_tests_2
>
> Changelog:
>
> v2:
>     * Add missing __rcu annotation to struct channel 'bridge' field in
>       order to squash a sparse warning from a C=1 build
>     * Integrate review comments from gnault@redhat.com
>     * Have ppp_unbridge_channels return -EINVAL if the channel isn't
>       part of a bridge: this better aligns with the return code from
>       ppp_disconnect_channel.
>     * Improve docs update by including information on ioctl arguments
>       and error return codes.
>
> Tom Parkin (2):
>   ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls
>   docs: update ppp_generic.rst to document new ioctls
>
>  Documentation/networking/ppp_generic.rst |   9 ++
>  drivers/net/ppp/ppp_generic.c            | 143 ++++++++++++++++++++++-
>  include/uapi/linux/ppp-ioctl.h           |   2 +
>  3 files changed, 152 insertions(+), 2 deletions(-)
>
Reviewed-by: James Chapman <jchapman@katalix.com>


