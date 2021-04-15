Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A8360925
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 14:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhDOMRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 08:17:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59698 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhDOMRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 08:17:02 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618488998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8i7b4mBlEgaESrmLRVp1HQxG++cCPSc6OtknPI/zOQ=;
        b=d04iDxqa7GQot9UhuNz2kn4hnMWF+aOQkOnu3wLjrbtzODV8luCkNKR1gTdauJeXBM82+f
        uuYboZd2ELCCXeYPDYx3m+pbQE+T4DiYTIRuJxLbdcBJXn1OQnyVZYrt7nDSktKu9p2UnR
        U/6bczP6vW5BSQ5NoGqVQ3dok8TTzt77nfr3El2tG0kvsWS6ZGara6ZAeOfKb19aDgqKhg
        v5ZrADtiCzwlgDzes9Rl5la1CfDfkJnUhmrje1DIIuC6ItHst5vAl/b+SHqeFhOtDFWBpg
        NKbhOlk6q1KK0FJPG/us/GXDTuHElgKgwaSwLt5OyNJl0MDpn7+meuDjhs8+fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618488998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8i7b4mBlEgaESrmLRVp1HQxG++cCPSc6OtknPI/zOQ=;
        b=tDGZPdPVTqxqRjggQ7l0XiEzA8AzTTCyVtNQyzUCLjsiseO+wFU2G5DlBjQLdzRQlDdfyr
        g74qMKdFfkXRRTBg==
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net] igb: Fix XDP with PTP enabled
In-Reply-To: <20210415140438.60221f21@carbon>
References: <20210415092145.27322-1-kurt@linutronix.de> <20210415140438.60221f21@carbon>
Date:   Thu, 15 Apr 2021 14:16:36 +0200
Message-ID: <874kg7hhej.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Apr 15 2021, Jesper Dangaard Brouer wrote:
> On Thu, 15 Apr 2021 11:21:45 +0200
> Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
>> When using native XDP with the igb driver, the XDP frame data doesn't po=
int to
>> the beginning of the packet. It's off by 16 bytes. Everything works as e=
xpected
>> with XDP skb mode.
>>=20
>> Actually these 16 bytes are used to store the packet timestamps. Therefo=
re, pull
>> the timestamp before executing any XDP operations and adjust all other c=
ode
>> accordingly. The igc driver does it like that as well.
>>=20
>> Tested with Intel i210 card and AF_XDP sockets.
>
> Doesn't the i210 card use the igc driver?
> This change is for igb driver.

Nope. igb is for i210 and igc is for the newer Intel i225 NICs.

|01:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connec=
tion (rev 03)
|[...]
|        Kernel driver in use: igb
|        Kernel modules: igb

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB4LqQACgkQeSpbgcuY
8KaoBg//a9XcbfhzKEgjiDZBhuhZz94UXxYnGdzMDXwBYfRPHMCVS/Ck2dp93J42
5SZtzICTcJ0j0/v9af0YbYUyMaObglMWrg2llYyCvmRbq9Q8Zb/6Av+GzjsCBHKJ
E76Cj6KGyfdT5z4ijhFUUmqLAFECNiyjP2TVL6DZmhRs4EHI7WeA7E4aGYzuiOmM
M/aqkaOL+wsDyZLkvPPMQGuDyWI83m+4DPfflOBwWLt422nm3trRnG0awAGkBwch
LNkRneWaFMSQy4fgJIsa7QZcmnhFOM9Ro2suwcmZkH7gt2A5m5nL9zZqe9FxW2zG
oHgvSJPUKWC+CTaQ2KwBsBRfPXtAGBqgkNFFjEy7Vk+VK4fKaWtX4sQ/S1U37D8Z
LNINpIPas4b4ogLujIU9DHa57QhEjDXNMTgSzQQX4MQc1DoO2knIPf+R0HDjqEe6
5Ppu0V70Nssz+g3iPhWdcxdqi1d0CTjxGiSfPS585ru/1SlqBV11nou9q5qxXVMw
QaJy1aWED+VEFUoMP58XJ+scepJYZwd2jqP+qhz2OmuoF/iIRW/+kkYrHVLO0TZq
Y7yQYQOK5E5+n9K8NYL1Kzcoo02vVb7kCEY05szXg2q4vNjOlTidgZn6BOECRsb8
NaU2cPHMfdXDZM6/p4gNt4jcYcanp3Tp9fxkK3gaog9iEMC2tDU=
=PbrL
-----END PGP SIGNATURE-----
--=-=-=--
