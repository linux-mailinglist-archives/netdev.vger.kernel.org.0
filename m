Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE8C27FC1A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgJAI7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 04:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgJAI73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:59:29 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4599DC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 01:59:29 -0700 (PDT)
Received: from [IPv6:2a02:8010:6359:1:28b7:b31f:54ed:5afa] (unknown [IPv6:2a02:8010:6359:1:28b7:b31f:54ed:5afa])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 4AC3C7EBB6;
        Thu,  1 Oct 2020 09:59:27 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601542767; bh=54o+rjcQCNgXAoPAo06NGvn06wbXmN7sz/igcoBKY8M=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20net-next=200/6]=20l2tp:=20add=20ac/pppo
         e=20driver|To:=20Tom=20Parkin=20<tparkin@katalix.com>,=20netdev@vg
         er.kernel.org|References:=20<20200930210707.10717-1-tparkin@katali
         x.com>|From:=20James=20Chapman=20<jchapman@katalix.com>|Message-ID
         :=20<34026662-1db6-c9b4-f523-e1a9cc869c80@katalix.com>|Date:=20Thu
         ,=201=20Oct=202020=2009:59:26=20+0100|MIME-Version:=201.0|In-Reply
         -To:=20<20200930210707.10717-1-tparkin@katalix.com>;
        b=jwKmXdeAoquyjF0ucRTqUh8rdixPpP0blrwJLyP4KKz48fXWOi/Ra6qyRgiMmZq7A
         A1OEbGJy4XrBfM/vBv7LZvM9vsHyIAhUpuITS8ejLgLK0d+yFkF5fQSaTHhXIgaZoP
         UHwLgdsNJMYzMS9/lJY3k49M3VYSv8pvTtWxaxWLD8O63YLiFcjM3zcF9OTQYiUW8e
         jHCJ0ka3B1Lz4bK9yfCl6fK0tjlOVMduIjp5DAASQsmJKeKcZYbY56iY9TvuwzQ1F3
         mUcfXZ0qnmJBGE/5kDU4X+TjZgEbp9PLk1rPnRreWpz/EB43iDaPsU7eB5/3X5pBpL
         6eK3piV62oWsA==
Subject: Re: [PATCH net-next 0/6] l2tp: add ac/pppoe driver
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
References: <20200930210707.10717-1-tparkin@katalix.com>
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
Message-ID: <34026662-1db6-c9b4-f523-e1a9cc869c80@katalix.com>
Date:   Thu, 1 Oct 2020 09:59:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2020 22:07, Tom Parkin wrote:
> L2TPv2 tunnels are often used as a part of a home broadband connection,=

> using a PPP link to connect the subscriber network into the Internet
> Service Provider's network.
>
> In this scenario, PPPoE is widely used between the L2TP Access
> Concentrator (LAC) and the subscriber.  The LAC effectively acts as a
> PPPoE server, switching PPP frames from incoming PPPoE packets into an
> L2TP session.  The PPP session is then terminated at the L2TP Network
> Server (LNS) on the edge of the ISP's IP network.
>
> This patchset adds a driver to the L2TP subsystem to support this mode
> of operation.
>
> The new driver, l2tp_ac_pppoe, adds support for the existing pseudowire=

> type L2TP_PWTYPE_PPP_AC, and is instantiated using the existing L2TP
> netlink L2TP_CMD_SESSION_CREATE.  It is expected to be used as follows:=

>
>  * A userspace PPPoE daemon running on the LAC handles the PPPoE
>    discovery process up to the point of assigning a PPPoE session ID an=
d
>    sending the PADS packet to the PPPoE peer to establish the PPPoE
>    session.
>  * Userspace code running on the LAC then instantiates an L2TP tunnel
>    and session with the LNS using the L2TP control protocol.
>  * Finally, the data path for PPPoE session frames through the L2TP
>    session to the LAC is instantiated by sending a genetlink
>    L2TP_CMD_SESSION_CREATE command to the kernel, including
>    the PPPoE-specific metadata required for L2TP_PWTYPE_PPP_AC sessions=

>    (this is documented in the patch series commit comments).
>
> Supporting this driver submission we have two examples of userspace
> projects which use L2TP_PWTYPE_PPP_AC:
>
>  * https://github.com/katalix/l2tp-ktest
>
>    This is a unit-test suite for the kernel L2TP subsystem which has
>    been updated to include basic lifetime and datapath tests for
>    l2tp_ac_pppoe.
>
>    The new tests are automatically enabled when l2tp_ac_pppoe
>    availability is detected, and hence support for l2tp_ac_pppoe is on
>    the master branch of the git repository.
>
>  * https://github.com/katalix/go-l2tp
>
>    This is a Go library for building L2TP applications on Linux, and
>    includes a suite of example daemons which utilise the library.
>
>    The daemon kpppoed implements the PPPoE discovery protocol, and spaw=
ns
>    an instance of a daemon kl2tpd which handles the L2TP control protoc=
ol
>    and instantiates the kernel data path.
>
>    The code utilising l2tp_ac_pppoe is on the branch tp_002_pppoe_1
>    pending merge of this patchset in the kernel.
>
> Notes on the patchset itself:
>
>  * Patches 1-4 lay groundwork for the addition of the new driver, makin=
g
>    tweaks to the l2tp netlink code to allow l2tp_ac_pppoe to access the=

>    netlink attributes it requires.
>  * Patch 5 adds the new driver itself and hooks it into the kernel
>    configuration and build system.
>  * Patch 6 updates the l2tp documentation under Documentation/ to
>    include information about the new driver.
>
> Tom Parkin (6):
>   l2tp: add netlink info to session create callback
>   l2tp: tweak netlink session create to allow L2TPv2 ac_pppoe
>   l2tp: allow v2 netlink session create to pass ifname attribute
>   l2tp: add netlink attributes for ac_ppp session creation
>   l2tp: add ac_pppoe pseudowire driver
>   docs: networking: update l2tp.rst to document PPP_AC pseudowires
>
>  Documentation/networking/l2tp.rst |  69 +++--
>  include/uapi/linux/l2tp.h         |   2 +
>  net/l2tp/Kconfig                  |   7 +
>  net/l2tp/Makefile                 |   1 +
>  net/l2tp/l2tp_ac_pppoe.c          | 446 ++++++++++++++++++++++++++++++=

>  net/l2tp/l2tp_core.h              |   4 +-
>  net/l2tp/l2tp_eth.c               |   3 +-
>  net/l2tp/l2tp_netlink.c           |  20 +-
>  net/l2tp/l2tp_ppp.c               |   3 +-
>  9 files changed, 527 insertions(+), 28 deletions(-)
>  create mode 100644 net/l2tp/l2tp_ac_pppoe.c
>
Reviewed-by: James Chapman <jchapman@katalix.com>


