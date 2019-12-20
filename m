Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9E12751C
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 06:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfLTFVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 00:21:53 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36139 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfLTFVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 00:21:53 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so6035555lfe.3;
        Thu, 19 Dec 2019 21:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=03PtfnLGGnAyQvgUuAnVt5GRf0St1uJofzRe3SMVv6U=;
        b=X5ZfcQL+QX4lQufRyONkb7KbSPBlLLxCZxr234USX6j+vadAwC1k283HKD3W5xGjE/
         gPz9J7T8kHjav+VDQf/mEu5m2gYsltsHa56tjAr3wZnKm/F23N9GXZ5BTIXpEPLSNhW1
         RU7fRAbj+enRMeQ9W4JjFB0UZAK9VhEVgo8/wB8+bT19am5AvUZNXHba4Ki5UGhVUlpR
         WkI+YwefSxCy4HD6zPtfKk1tKemOLtht5OxONQzyPVpnp2fi49LtPZYb/aSAA4BSkX4U
         NatPtCpbNEk8jRlchfXoYcX2IAdeAbzV54xO0uUCW/IqT7P1uqDN0VOmjtwv3dZ1Oxr/
         dFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=03PtfnLGGnAyQvgUuAnVt5GRf0St1uJofzRe3SMVv6U=;
        b=BagctX6oo5lf7IKYDtfmw71EAVS7WIg6yr13NpgGsswckdhP4w9CDcE5TbhQMkppqb
         N3OJxUoVLBGgiAVa4JRWSvc2x2sx04nqs5tnVBZMcTNHetNxh+sZmTbjeR2EFoY/e/R2
         gbkgtNkxH9uKWcmLiGmQYnhG1ioKWWYgnhSfOxrZtXr71RVfSWAYuIJ8dqIBuufrEIYi
         nk/V/f7FDlsZAfaobbez9DbmNuWaS8QnqrWLliobH87VWN1nsBA9zjAtObZrXf5m+zBr
         JKw76Ggeh8P9YRkOZwxVvwHJBVrtnbY5Ff8FpS4cHwk5o5k9jwIo6qccZmBeQToScAZy
         v2mg==
X-Gm-Message-State: APjAAAWKY+AjtCH5XSxt5MY9VmzkK6gFP6dVNn/cN43GMi+Y6ASvCs+K
        /s7iz/MJepDfVvX0zIsFRC+B/UZlfPH7OTGFAHM=
X-Google-Smtp-Source: APXvYqxypej6qqCW8dosM7Jg0IUqE/Fn34L4eT3AZX9qRDgb1HCVTIjVs/8IE3wCLx0VOVmOJz7Y9adm0d2wx8mA5Zs=
X-Received: by 2002:ac2:44d9:: with SMTP id d25mr7953219lfm.15.1576819311517;
 Thu, 19 Dec 2019 21:21:51 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
In-Reply-To: <20191219061006.21980-1-bjorn.topel@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 19 Dec 2019 21:21:39 -0800
Message-ID: <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 10:10 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> This series aims to simplify the XDP maps and
> xdp_do_redirect_map()/xdp_do_flush_map(), and to crank out some more
> performance from XDP_REDIRECT scenarios.
>
> The first part of the series simplifies all XDP_REDIRECT capable maps,
> so that __XXX_flush_map() does not require the map parameter, by
> moving the flush list from the map to global scope.
>
> This results in that the map_to_flush member can be removed from
> struct bpf_redirect_info, and its corresponding logic.
>
> Simpler code, and more performance due to that checks/code per-packet
> is moved to flush.
>
> Pre-series performance:
>   $ sudo taskset -c 22 ./xdpsock -i enp134s0f0 -q 20 -n 1 -r -z
>
>    sock0@enp134s0f0:20 rxdrop xdp-drv
>                   pps         pkts        1.00
>   rx              20,797,350  230,942,399
>   tx              0           0
>
>   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
>
>   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
>   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
>   XDP-RX          20      7723038        0           0
>   XDP-RX          total   7723038        0
>   cpumap_kthread  total   0              0           0
>   redirect_err    total   0              0
>   xdp_exception   total   0              0
>
> Post-series performance:
>   $ sudo taskset -c 22 ./xdpsock -i enp134s0f0 -q 20 -n 1 -r -z
>
>    sock0@enp134s0f0:20 rxdrop xdp-drv
>                   pps         pkts        1.00
>   rx              21,524,979  86,835,327
>   tx              0           0
>
>   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
>
>   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
>   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
>   XDP-RX          20      7840124        0           0
>   XDP-RX          total   7840124        0
>   cpumap_kthread  total   0              0           0
>   redirect_err    total   0              0
>   xdp_exception   total   0              0
>
> Results: +3.5% and +1.5% for the ubenchmarks.
>
> v1->v2 [1]:
>   * Removed 'unused-variable' compiler warning (Jakub)
>
> [1] https://lore.kernel.org/bpf/20191218105400.2895-1-bjorn.topel@gmail.c=
om/

My understanding that outstanding discussions are not objecting to the
core ideas
of the patch set, hence applied. Thanks
