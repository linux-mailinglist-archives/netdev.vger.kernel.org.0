Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1F464F3E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 14:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbhLAOAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:00:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234728AbhLAOAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638367046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O/UOa7HQhaqGIVjrBTgj692QrJIuGRD0Esan2D2aSxI=;
        b=Go2IzmC1mOwirko3HA4/d5sSncjPiMKAQ/L4NB0LQDsrdzSBMAVDm8Oq2TML6JWCKk0ewb
        l6s58A7JSpexjVEP/ZwpxAPOYCXg3yH6npTJoYN42n8eoW6Km9SF0qGu1zdpS019XlqZaH
        RLf1rYMXiozOGtiH85wMsGFDMK+gUNU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-o-XGM77YO02NNu2QqSQz6g-1; Wed, 01 Dec 2021 08:57:24 -0500
X-MC-Unique: o-XGM77YO02NNu2QqSQz6g-1
Received: by mail-ed1-f71.google.com with SMTP id k7-20020aa7c387000000b003e7ed87fb31so20491526edq.3
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 05:57:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O/UOa7HQhaqGIVjrBTgj692QrJIuGRD0Esan2D2aSxI=;
        b=4pAg/3BQh2Lfm3ypi36+f+sQk6/J677UcKKCwxQQ/OgP3wgeBscH9XrM++VJtxkctx
         EBuNH2TfHocmKydD/ExW2/khlWOLr90xJ9sETgO8aPyr/dh1y5sbay62RqpuL5iclbkn
         EBvUXLIxeieb4ydwQr4FIklSvwGAuN91+ukFl4rjE2NzNUchMUVjAUJpeWoSX3UXB/9x
         jAm7pvAcUFrzzcTtXQAgwbJ0DHw13FymWK3nIU/uf7R34gXE8zWE3wwdfFkleUYNxH3q
         lwBK/Q119aTF5ZzKtbMA3B14V/r0OsA575aIBQbdUKKmuyvDTkK/9LqpKt1tFUMlGaEP
         kWTA==
X-Gm-Message-State: AOAM532PGUryfIUsaGTjSvxEskn9r/qhOrSW0Zi2aezsyP0fEaU4eVKk
        XGa4fuLym0N90uDd96S/WZ3v7iLee0peGbh2Dpn+G8StXQ6W7KVjzhgYu4ZVlPXyTBuuQmtF+RU
        LlXz4zsJEza0nrQfy
X-Received: by 2002:a05:6402:4251:: with SMTP id g17mr8787696edb.89.1638367043665;
        Wed, 01 Dec 2021 05:57:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVvlu8YyWvLJQ5Dewd5t9OPa0SdoUXtlTdY0mr43y3UwGNmdIuCWjPU3TIEU1IP7N+ez4WwA==
X-Received: by 2002:a05:6402:4251:: with SMTP id g17mr8787642edb.89.1638367043415;
        Wed, 01 Dec 2021 05:57:23 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id h10sm13824611edj.1.2021.12.01.05.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 05:57:22 -0800 (PST)
Date:   Wed, 1 Dec 2021 14:57:20 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com, lorenzo@kernel.org
Subject: Re: [PATCH v19 bpf-next 00/23] mvneta: introduce XDP multi-buffer
 support
Message-ID: <Yad/QE+3gW3u64hc@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4xQfIAK8oijUNQ6X"
Content-Disposition: inline
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4xQfIAK8oijUNQ6X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

@Alexei and @Daniel,

there is a trivial conflict with bpf_loop helper (because the series was not
merged when I posted v19):

commit e6f2dd0f80674e9d5960337b3e9c2a242441b326
Author: Joanne Koong <joannekoong@fb.com>
Date:   Mon Nov 29 19:06:19 2021 -0800

    bpf: Add bpf_loop helper

Do you want me to post v20 after waiting for some more feedbacks on v19?

Regards,
Lorenzo

>=20
> [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu=
-and-rx-zerocopy
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp=
-multi-buffer01-design.org
> [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to=
-a-NIC-driver (XDPmulti-buffers section)
>=20
> Eelco Chaudron (3):
>   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
>   bpf: add multi-buffer support to xdp copy helpers
>   bpf: selftests: update xdp_adjust_tail selftest to include
>     multi-buffer
>=20
> Lorenzo Bianconi (19):
>   net: skbuff: add size metadata to skb_shared_info for xdp
>   xdp: introduce flags field in xdp_buff/xdp_frame
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
>   net: mvneta: simplify mvneta_swbm_add_rx_fragment management
>   net: xdp: add xdp_update_skb_shared_info utility routine
>   net: marvell: rely on xdp_update_skb_shared_info utility routine
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf
>     program
>   net: mvneta: enable jumbo frames if the loaded XDP program support mb
>   bpf: introduce bpf_xdp_get_buff_len helper
>   bpf: move user_size out of bpf_test_init
>   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
>   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
>     signature
>   libbpf: Add SEC name for xdp_mb programs
>   net: xdp: introduce bpf_xdp_pointer utility routine
>   bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
>   bpf: selftests: add CPUMAP/DEVMAP selftests for xdp multi-buff
>   xdp: disable XDP_REDIRECT for xdp multi-buff
>=20
> Toke Hoiland-Jorgensen (1):
>   bpf: generalise tail call map compatibility check
>=20
>  drivers/net/ethernet/marvell/mvneta.c         | 204 +++++++++------
>  include/linux/bpf.h                           |  32 ++-
>  include/linux/skbuff.h                        |   1 +
>  include/net/xdp.h                             | 108 +++++++-
>  include/uapi/linux/bpf.h                      |  30 +++
>  kernel/bpf/arraymap.c                         |   4 +-
>  kernel/bpf/core.c                             |  28 +-
>  kernel/bpf/cpumap.c                           |   8 +-
>  kernel/bpf/devmap.c                           |   3 +-
>  kernel/bpf/syscall.c                          |  25 +-
>  kernel/trace/bpf_trace.c                      |   3 +
>  net/bpf/test_run.c                            | 115 ++++++--
>  net/core/filter.c                             | 246 +++++++++++++++++-
>  net/core/xdp.c                                |  78 +++++-
>  tools/include/uapi/linux/bpf.h                |  30 +++
>  tools/lib/bpf/libbpf.c                        |   8 +
>  .../bpf/prog_tests/xdp_adjust_frags.c         |  96 +++++++
>  .../bpf/prog_tests/xdp_adjust_tail.c          | 118 +++++++++
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 ++++++++---
>  .../bpf/prog_tests/xdp_cpumap_attach.c        |  65 ++++-
>  .../bpf/prog_tests/xdp_devmap_attach.c        |  56 ++++
>  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
>  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>  .../bpf/progs/test_xdp_update_frags.c         |  42 +++
>  .../bpf/progs/test_xdp_with_cpumap_helpers.c  |   6 +
>  .../progs/test_xdp_with_cpumap_mb_helpers.c   |  27 ++
>  .../bpf/progs/test_xdp_with_devmap_helpers.c  |   7 +
>  .../progs/test_xdp_with_devmap_mb_helpers.c   |  27 ++
>  29 files changed, 1350 insertions(+), 212 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_fra=
gs.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_fra=
gs.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpuma=
p_mb_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devma=
p_mb_helpers.c
>=20
> --=20
> 2.31.1
>=20

--4xQfIAK8oijUNQ6X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYad/QAAKCRA6cBh0uS2t
rGCSAP9c0gsOLve4H12fcYwKDq9NuEIT9kTTD9NaortyuX6CCwD/WjYeb3Labh5N
CkAxSmebPw+llWa+pqTNLwczyxGCuwM=
=xwn3
-----END PGP SIGNATURE-----

--4xQfIAK8oijUNQ6X--

