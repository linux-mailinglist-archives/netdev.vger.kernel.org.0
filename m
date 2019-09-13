Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA84B17C1
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 06:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfIMEdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 00:33:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:47069 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfIMEdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 00:33:16 -0400
Received: by mail-qk1-f196.google.com with SMTP id 201so26821433qkd.13;
        Thu, 12 Sep 2019 21:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T0dCPF8vk9ULuKJw0AOHaH0QHgTU+BgYYbjonrk1USU=;
        b=il3H5WUXtFnQepZZDwMXvFOv3EozGsv9JoWDtJwoqHUmZnOUkFDbZo4Yifs6SWHLnD
         qZzj/OHw1kqgev3L6W1syp4Lgj2/aLnC/ODFM5SykbyFlit7RUsxYA9hTRvKTr/CTE92
         Ikzrdf1oDoOnSkV4S4Ji30CruPFMWeWM9TL5hS/ErlE3gRim/+6IZqQfaD/6xepuVvUY
         QdC9PdtnWgnHagkwHXihgwpCePfLq2VjWBWd4dKNOMEt/rVRs5F6Epu2BGlgEsMT2bQw
         Eno2Nl31BxlOi80uIzxYX7yEUVQT6otiLUbLIyJpJ31WJ3UvBWiQA62BKj/HxLNMPhlV
         rI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T0dCPF8vk9ULuKJw0AOHaH0QHgTU+BgYYbjonrk1USU=;
        b=YG6lNGGI9N/uHmBCw5mI4nuHvHY/YU0mwbZNdolJ19sF33g4fTMuRj8na3UEJzbf8g
         UIScR8r6YWWq3KV/GtySH3xXzs7hDa6DUzaFu/EnwN8/G8hTNtiwULBixB9C+0xV2EOT
         OLy3xTfsRvwbqSXuEloxkLkzm24saJFeTcx252AFesbXlsUixIF3gNODU3gQ+8waCfQa
         9uXTrwvMM4lzHaRImCQsyFcin0tJ7zOoblG1p7GghKOpNVuCJ8ywuYcKVLL0ax76aERf
         9UFnaznD5aHa5cnyQprPWHYpK7JJ1BvAcviZhtdvl5JWOMEQCSDKYE3/nh0s9K+tFavo
         bCGg==
X-Gm-Message-State: APjAAAU7i/fby1dMy+yRCTBDL1ullqtXBOi3p1fjGS+nQ7NRnoz5mxiE
        eiCjMp7e+7uOLzTfqHMswpbZHlk5zY2uRZ7p8qM=
X-Google-Smtp-Source: APXvYqxTHK4eng6Pb63g05ufEgjuuCkKruliwdcCR4NYaO0aLVa36LCNge9zGWOZ81PHLI0hGxOwJWnM/XWsRCbTXcg=
X-Received: by 2002:a37:4b02:: with SMTP id y2mr44721354qka.493.1568349194998;
 Thu, 12 Sep 2019 21:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190911172435.21042-1-ciara.loftus@intel.com> <20190911172435.21042-2-ciara.loftus@intel.com>
In-Reply-To: <20190911172435.21042-2-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Sep 2019 06:33:01 +0200
Message-ID: <CAJ+HfNhuhyjRXoTXLhR3CbzhvYZZNZXYcbPxYAokL7HuDT6nAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] ixgbe: fix xdp handle calculations
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Kevin Laatz <kevin.laatz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Sep 2019 at 19:27, Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Commit 7cbbf9f1fa23 ("ixgbe: fix xdp handle calculations") reintroduced
> the addition of the umem headroom to the xdp handle in the ixgbe_zca_free=
,
> ixgbe_alloc_buffer_slow_zc and ixgbe_alloc_buffer_zc functions. However,
> the headroom is already added to the handle in the function
> ixgbe_run_xdp_zc. This commit removes the latter addition and fixes the
> case where the headroom is non-zero.
>
> Fixes: 7cbbf9f1fa23 ("ixgbe: fix xdp handle calculations")
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index ad802a8909e0..5ed8b5a257cf 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -145,7 +145,7 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *ada=
pter,
>  {
>         struct xdp_umem *umem =3D rx_ring->xsk_umem;
>         int err, result =3D IXGBE_XDP_PASS;
> -       u64 offset =3D umem->headroom;
> +       u64 offset;

...and same comment as from the i40e patch: Reverse xmas tree, please.


Cheers,
Bj=C3=B6rn

>         struct bpf_prog *xdp_prog;
>         struct xdp_frame *xdpf;
>         u32 act;
> @@ -153,7 +153,7 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *ada=
pter,
>         rcu_read_lock();
>         xdp_prog =3D READ_ONCE(rx_ring->xdp_prog);
>         act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> -       offset +=3D xdp->data - xdp->data_hard_start;
> +       offset =3D xdp->data - xdp->data_hard_start;
>
>         xdp->handle =3D xsk_umem_adjust_offset(umem, xdp->handle, offset)=
;
>
> --
> 2.17.1
>
