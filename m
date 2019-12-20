Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD01278E3
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfLTKKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:10:10 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41618 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 05:10:10 -0500
Received: by mail-qk1-f194.google.com with SMTP id x129so7168293qke.8;
        Fri, 20 Dec 2019 02:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=15e0lkCjkPeEZrmYiFOGrDKXMpH42X3ZivF1r0Ic8Vo=;
        b=rJmIcCoD+afgNjcL4JsdOOk9U5U8Jj+nivg30zpv/EX9WnTHjrWz+VcagW/i7RlhMR
         i0bdQqCMw4+4kv3j9xNUeqWfJyMrIndOiDriOol+qRVnuXlz0524kskmeNLPLIYjaA6k
         LJJ1ERY/7MSETSJtDH0hUBECKMKsuci4dZQQ44OC1fjAr/0yLw+fSwUNnpTeacHaVQfI
         5H27VVzByyjh56ISLbkccKnzhGdbOuwpNZlkSct36OEBU/tN3mEg9UAWAyArFfB9WYe6
         GLvPT69Wkt11OLI0hFhsmP7Imcd2YwArCGXSh6hNWFY/OU/HYo7Q5Uj10vdi2yHxl9E0
         XWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=15e0lkCjkPeEZrmYiFOGrDKXMpH42X3ZivF1r0Ic8Vo=;
        b=sSNb7H33YEcBI7VlbMOuvapSO52CbSDDZJNnsrsbaF3c+WhQInsHLxfvGmUsxifgPR
         uzyfd8jO7jhLJu5lTsUvDQ1N/YLlprkFHJ1CUQlMT1vTxYq1/K99P90DjjlNpt2pBTUy
         TISh8Clwp3elEctlv+lZ9wNJUT21uTihjIbm+4vHMsTMgRDxo4NSHsWfPjUm6naEJFp1
         1CcbBK6D6HM1Ovka128cDDXUU89lCl+wfRrSkaGC9a+3G1cAkOJcp4ZK+SrNTzeSxOzk
         +wmkDS8zRsOK5+qZv5APgtopTcervkbF6B5NWV+IATOSqWmYC5wVrF1TlyGhgPObsY6k
         wwJA==
X-Gm-Message-State: APjAAAXwwhMgL3AnLYTb7eA5El6E7s7uMhqQXmfPy/9yLNhi+C7rNaBq
        K/j5q81RcHgKsAPsWHnn/8zbu13BgObw2Ll/C08=
X-Google-Smtp-Source: APXvYqz+BnZucLS15/50NtXUoImnWTOjjv92ldpdv5cA/AKa9hYj5Q3RfybLZyfvPVERJfCwmf8vIrF62+9r28hOdCw=
X-Received: by 2002:a37:63c7:: with SMTP id x190mr12477981qkb.232.1576836608574;
 Fri, 20 Dec 2019 02:10:08 -0800 (PST)
MIME-Version: 1.0
References: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 20 Dec 2019 11:09:57 +0100
Message-ID: <CAJ+HfNh0mGnDnQD0FZqza0oEDZpj+nh_DS=JvWvJMATwsOMJEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/12] xsk: clean up ring access functions
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 at 13:40, Magnus Karlsson <magnus.karlsson@intel.com> w=
rote:
>
> This patch set cleans up the ring access functions of AF_XDP in hope
> that it will now be easier to understand and maintain. I used to get a
> headache every time I looked at this code in order to really understand i=
t,
> but now I do think it is a lot less painful.
>
> The code has been simplified a lot and as a bonus we get better
> performance in nearly all cases. On my new 2.1 GHz Cascade Lake
> machine with a standard default config plus AF_XDP support and
> CONFIG_PREEMPT on I get the following results in percent performance
> increases with this patch set compared to without it:
>
> Zero-copy (-N):
>           rxdrop        txpush        l2fwd
> 1 core:    -2%            0%            3%
> 2 cores:    4%            0%            3%
>
> Zero-copy with poll() (-N -p):
>           rxdrop        txpush        l2fwd
> 1 core:     3%            0%            1%
> 2 cores:   21%            0%            9%
>
> Skb mode (-S):
> Shows a 0% to 5% performance improvement over the same benchmarks as
> above.
>
> Here 1 core means that we are running the driver processing and the
> application on the same core, while 2 cores means that they execute on
> separate cores. The applications are from the xdpsock sample app.
>
> On my older 2.0 Ghz Broadwell machine that I used for the v1, I get
> the following results:
>
> Zero-copy (-N):
>           rxdrop        txpush        l2fwd
> 1 core:     4%            5%            4%
> 2 cores:    1%            0%            2%
>
> Zero-copy with poll() (-N -p):
>           rxdrop        txpush        l2fwd
> 1 core:     1%            3%            3%
> 2 cores:   22%            0%            5%
>
> Skb mode (-S):
> Shows a 0% to 1% performance improvement over the same benchmarks as
> above.
>
> When a results says 21 or 22% better, as in the case of poll mode with
> 2 cores and rxdrop, my first reaction is that it must be a
> bug. Everything else shows between 0% and 5% performance
> improvement. What is giving rise to 22%? A quick bisect indicates that
> it is patches 2, 3, 4, 5, and 6 that are giving rise to most of this
> improvement. So not one patch in particular, but something around 4%
> improvement from each one of them. Note that exactly this benchmark
> has previously had an extraordinary slow down compared to when running
> without poll syscalls. For all the other poll tests above, the
> slowdown has always been around 4% for using poll syscalls. But with
> the bad performing test in question, it was above 25%. Interestingly,
> after this clean up, the slow down is 4%, just like all the other poll
> tests. Please take an extra peek at this so I have not messed up
> something.
>
> The 0% for several txpush results are due to the test bottlenecking on
> a non-CPU HW resource. If I eliminated that bottleneck on my system, I
> would expect to see an increase there too.
>
> Changes v1 -> v2:
> * Corrected textual errors in the commit logs (Sergei and Martin)
> * Fixed the functions that detect empty and full rings so that they
>   now operate on the global ring state (Maxim)
>
> This patch has been applied against commit a352a82496d1 ("Merge branch 'l=
ibbpf-extern-followups'")
>
> Structure of the patch set:
>
> Patch 1: Eliminate the lazy update threshold used when preallocating
>          entries in the completion ring
> Patch 2: Simplify the detection of empty and full rings
> Patch 3: Consolidate the two local producer pointers into one
> Patch 4: Standardize the naming of the producer ring access functions
> Patch 5: Eliminate the Rx batch size used for the fill ring
> Patch 6: Simplify the functions xskq_nb_avail and xskq_nb_free
> Patch 7: Simplify and standardize the naming of the consumer ring
>          access functions
> Patch 8: Change the names of the validation functions to improve
>          readability and also the return value of these functions
> Patch 9: Change the name of xsk_umem_discard_addr() to
>          xsk_umem_release_addr() to better reflect the new
>          names. Requires a name change in the drivers that support AF_XDP
>          zero-copy.
> Patch 10: Remove unnecessary READ_ONCE of data in the ring
> Patch 11: Add overall function naming comment and reorder the functions
>           for easier reference
> Patch 12: Use the struct_size helper function when allocating rings
>
> Thanks: Magnus
>

Very nice cleanup (and performance boost)!

For the series:
Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


> Magnus Karlsson (12):
>   xsk: eliminate the lazy update threshold
>   xsk: simplify detection of empty and full rings
>   xsk: consolidate to one single cached producer pointer
>   xsk: standardize naming of producer ring access functions
>   xsk: eliminate the RX batch size
>   xsk: simplify xskq_nb_avail and xskq_nb_free
>   xsk: simplify the consumer ring access functions
>   xsk: change names of validation functions
>   xsk: ixgbe: i40e: ice: mlx5: xsk_umem_discard_addr to
>     xsk_umem_release_addr
>   xsk: remove unnecessary READ_ONCE of data
>   xsk: add function naming comments and reorder functions
>   xsk: use struct_size() helper
>
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c           |   4 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   2 +-
>  include/net/xdp_sock.h                             |  14 +-
>  net/xdp/xsk.c                                      |  62 ++--
>  net/xdp/xsk_queue.c                                |  15 +-
>  net/xdp/xsk_queue.h                                | 371 +++++++++++----=
------
>  8 files changed, 246 insertions(+), 230 deletions(-)
>
> --
> 2.7.4
