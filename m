Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E374CA68
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbfFTJNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:13:36 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41327 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfFTJNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:13:36 -0400
Received: by mail-qk1-f194.google.com with SMTP id c11so1401664qkk.8;
        Thu, 20 Jun 2019 02:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X6bKwZxURv5deJWTCBXduGArgXHOHNe9PzEhrDNybaw=;
        b=LjHiGkCQgGrOCV9VPwsq0TFHizch7kzd1nmyInQGvD7MdWCl7jTWNrw3fMPtK+VoN2
         GtTee4zKmCUKG+F1C46YrOMrqxVmA6vb5pzt+MmF/V1zlM0QatZm5flLvPat15yrJKsC
         CmDAJ5CnxJTsTEzolLefmc6GkFz3lcR3hWRy7IN6EA+0GnlryYOoI1E7kB5w9baYHkU0
         tzmerJ1QyJtRugAfGvik0NLu5OiBpZZgG4PcAt0LZp4fM4Fpbaywb339Q9ZAJ6c6SiYX
         /D3/YBQzbQWCBq/hofyunFugRPms8k8Vl/tmOq71TRt51Hy8u4NXAPSzlvfPggOeyWCZ
         +uRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X6bKwZxURv5deJWTCBXduGArgXHOHNe9PzEhrDNybaw=;
        b=TaE+OypZS5kfpxGNVEMWdbCAWVNPBazPI680mparUMVn+weoaTrfraLyr4G+DgnRcf
         3hNi4DkEMEBiiN/mbBBwU2H19ZbE9CJScmzUxOLbKzx0KghY5ISg+78KJrCLvNvOUYQh
         nSNWmQRWCJ6OSgOI2f7PGqOurtGGZeIOcVrJtyF+BFE3PTFN4oLuqz3RCVFP6r7L+1w1
         VP6oNi5b64AogQp7Nj5rPb1GVrkJI5C/RzO/dMMUJQyG5sbOk7ZW8GE2gtQfj4clZJYD
         tsioxn3X844q+D9MWqdrrhBmQX1WdjzxKhgh2G2q9qrrcb8dwDnBZgLgrsYxPGwUfrIP
         jYqQ==
X-Gm-Message-State: APjAAAXDfErkVevs4kgkhJCC1GEPyhx59JKgSNK+k/PVQxaWVgK8A2lf
        PmnCd3Nys6p2M6VfBZ/BZ3Q1nfsssg5PReTSCko=
X-Google-Smtp-Source: APXvYqyRSSmVWRdQ+mFdOeY83EeFv/xT4VmqNVjx51xDnWaiiLYQ21KYkAyRUuO8XiejeNfl6ZgMKynq8mEbWvyLUuY=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr106160992qkj.39.1561022014963;
 Thu, 20 Jun 2019 02:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190618120024.16788-1-maximmi@mellanox.com>
In-Reply-To: <20190618120024.16788-1-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 20 Jun 2019 11:13:23 +0200
Message-ID: <CAJ+HfNia-vUv7Eumfs8aMYGGkxPbbUQ++F+BQ=9C1NtP0Jt3hA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 at 14:00, Maxim Mikityanskiy <maximmi@mellanox.com> wro=
te:
>
> This series contains improvements to the AF_XDP kernel infrastructure
> and AF_XDP support in mlx5e. The infrastructure improvements are
> required for mlx5e, but also some of them benefit to all drivers, and
> some can be useful for other drivers that want to implement AF_XDP.
>
> The performance testing was performed on a machine with the following
> configuration:
>
> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
>
> The results with retpoline disabled, single stream:
>
> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
> rxdrop: 12.2 Mpps
> l2fwd: 9.4 Mpps
>
> The results with retpoline enabled, single stream:
>
> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
> rxdrop: 9.9 Mpps
> l2fwd: 6.8 Mpps
>
> v2 changes:
>
> Added patches for mlx5e and addressed the comments for v1. Rebased for
> bpf-next.
>
> v3 changes:
>
> Rebased for the newer bpf-next, resolved conflicts in libbpf. Addressed
> Bj=C3=B6rn's comments for coding style. Fixed a bug in error handling flo=
w in
> mlx5e_open_xsk.
>
> v4 changes:
>
> UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
> half of the available amount of RX queues are regular queues, and the
> upper half are XSK RX queues. The patch "xsk: Extend channels to support
> combined XSK/non-XSK traffic" was dropped. The final patch was reworked
> accordingly.
>
> Added "net/mlx5e: Attach/detach XDP program safely", as the changes
> introduced in the XSK patch base on the stuff from this one.
>
> Added "libbpf: Support drivers with non-combined channels", which aligns
> the condition in libbpf with the condition in the kernel.
>
> Rebased over the newer bpf-next.
>
> v5 changes:
>
> In v4, ethtool reports the number of channels as 'combined' and the
> number of XSK RX queues as 'rx' for mlx5e. It was changed, so that 'rx'
> is 0, and 'combined' reports the double amount of channels if there is
> an active UMEM - to make libbpf happy.
>
> The patch for libbpf was dropped. Although it's still useful and fixes
> things, it raises some disagreement, so I'm dropping it - it's no longer
> useful for mlx5e anymore after the change above.
>

Just a heads-up: There are some checkpatch warnings (>80 chars/line)
for the mlnx5 driver parts, and the series didn't apply cleanly on
bpf-next for me.

I haven't been able to test the mlnx5 parts.

Parts of the series are unrelated/orthogonal, and could be submitted
as separate series, e.g. patches {1,7} and patches {3,4}. No blockers
for me, though.

Thanks for the hard work!

For the series:
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
