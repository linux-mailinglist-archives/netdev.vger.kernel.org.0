Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55782260C0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGTNXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGTNXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:23:39 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FC4C061794;
        Mon, 20 Jul 2020 06:23:38 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a17so8473291vsq.6;
        Mon, 20 Jul 2020 06:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/6DloG2b0r9CUqLKLWeciEJEXdPx3rqElZz2QEFevOg=;
        b=Y1lnxgFo9H6d4l4Aqpv9Mcc1TgPSgFIwL5RO7on41cQVl9/DNZMoCpY1On4/1ZymEc
         AMZHJHw5mNsry96EhHRCHE1velwxCy/+ujwKRpW24S7KPOVqptWZKsl3PVYCnH9oPut8
         gzlljtBNQIKEwOSUKUFA4ntcDe9RTEql4W6Eq3RE9W7EMnDM78OjxZhbOWz0c/vcsxUs
         5vlcpOJ8VRmjq7JinFfcmNj8z6ZqRuKdRWrwQpru4SMjqfW1H5WThyxSNqFsV5QGvHhH
         GQeJtX3rn5m7DdN0mwV5mk3YMr6t8fkrF8zwyLYCo/rV15yeyetADroAK0g8E5LJJerr
         Mv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/6DloG2b0r9CUqLKLWeciEJEXdPx3rqElZz2QEFevOg=;
        b=hZO7D+Wqbefri/hEVAOEjRnSjIYFS5tYLcNuyQCvGc0Ia5Tik6ej4k4Z1rs1YtidbP
         zt1PR0Vv/GLmVB3jTlNgtsIjIgQuBnUSxZt7qrwAZviJh6LYyWc0e4R/TtsYdmWQScpR
         x8YC0NSajgoM+NjgUiesc4+rPEhjKkAx4Yx0OUC49pRcyXYOgts0q26loxOOqGIk0uZ2
         v87Uy3WYFuZNFg+Fn/lAU7DRMkGhz25H9RPup/t/6+ojzZcpC7wjAACSihDyHzCuu5bG
         CmCztPVQr44qycgy1kFrOjF0gFjOgxx4a0wcW3bfNY9Rwzt78ebapsiNxUVyUPcLwo0S
         VrSw==
X-Gm-Message-State: AOAM531B2MitSiyV+F36ovM7WBnubmmrhxE1R/6So9txeYT+gK4lUjYj
        2gfeor8pp06Eci3iLMdaBMxciBZ2S0NLIRPtbTk=
X-Google-Smtp-Source: ABdhPJw/DLry+B6SgDHJh8lxN/bTXWUPhnY1HfGc9wOE4MEE0/VuSha/XRneMkeHrshmyziIfD3wX/a9ORHN120Ahpk=
X-Received: by 2002:a67:ed59:: with SMTP id m25mr16254532vsp.218.1595251418042;
 Mon, 20 Jul 2020 06:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <1595236694-12749-5-git-send-email-magnus.karlsson@intel.com> <202007201930.0SiyJL6b%lkp@intel.com>
In-Reply-To: <202007201930.0SiyJL6b%lkp@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Jul 2020 15:23:26 +0200
Message-ID: <CAJ8uoz1ReofjQQRpqKa80P1L93SRsdAPPLcEJsuaOpXzq5_=yg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 04/14] xsk: move fill and completion rings to
 buffer pool
To:     kernel test robot <lkp@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        kbuild-all@lists.01.org, bpf <bpf@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 2:21 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Magnus,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on bpf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Magnus-Karlsson/xsk-supp=
ort-shared-umems-between-devices-and-queues/20200720-180143
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git =
master
> config: alpha-allmodconfig (attached as .config)
> compiler: alpha-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-9.3.0 make.cros=
s ARCH=3Dalpha
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    net/xdp/xsk_diag.c: In function 'xsk_diag_put_stats':
> >> net/xdp/xsk_diag.c:88:70: error: 'struct xdp_umem' has no member named=
 'fq'
>       88 |  du.n_fill_ring_empty =3D xs->umem ? xskq_nb_queue_empty_descs=
(xs->umem->fq) : 0;
>          |                                                               =
       ^~

Thank you Mr LKP robot. Yes, bisectability is broken in patch 3. Will spin =
a v4.

/Magnus

> vim +88 net/xdp/xsk_diag.c
>
> a36b38aa2af611 Bj=C3=B6rn T=C3=B6pel  2019-01-24  80
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  81  static int xsk_diag_put_stats=
(const struct xdp_sock *xs, struct sk_buff *nlskb)
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  82  {
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  83      struct xdp_diag_stats du =
=3D {};
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  84
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  85      du.n_rx_dropped =3D xs->r=
x_dropped;
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  86      du.n_rx_invalid =3D xskq_=
nb_invalid_descs(xs->rx);
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  87      du.n_rx_full =3D xs->rx_q=
ueue_full;
> 0d80cb4612aa32 Ciara Loftus 2020-07-08 @88      du.n_fill_ring_empty =3D =
xs->umem ? xskq_nb_queue_empty_descs(xs->umem->fq) : 0;
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  89      du.n_tx_invalid =3D xskq_=
nb_invalid_descs(xs->tx);
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  90      du.n_tx_ring_empty =3D xs=
kq_nb_queue_empty_descs(xs->tx);
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  91      return nla_put(nlskb, XDP=
_DIAG_STATS, sizeof(du), &du);
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  92  }
> 0d80cb4612aa32 Ciara Loftus 2020-07-08  93
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
