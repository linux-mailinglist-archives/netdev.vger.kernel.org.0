Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC29E5B88E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfGAKE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:04:56 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33125 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfGAKE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 06:04:56 -0400
Received: by mail-ot1-f65.google.com with SMTP id q20so12884111otl.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 03:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VvjQ+AatnkwTtRURnp0RmzgfSmJxKJJKkKKQF1tSGpg=;
        b=bJE/RgyGz2asCI9ppJg3VYsvcAeozgmyU9DnDPHQMEZD7jG3N8F0JJlU67iq9P+SSM
         YIaFiWrvhWRd8i85zk3K+uS4BMyX+FqhrEglpHxMAO18oxgONmmhZVT3qiREvSCc+3Kx
         owxi46VxN1P2vj/V87B3DMcBNWvrL0FJxypGzuOxUa0rs1GFbkzG4HWjq5vEJOon0sbo
         r1dbuN2EVwLItKEFJoZUff3w4/zxPkL1S2BJxPXxiGEBr/63DcIhl2iI7w41fcrPmnaE
         zRE4gfo6OfS8z2CvggaQS0OKCFmwCJ7SYHSNmIJyWD+l4Cr68FXw7uVi8FO+pH3HcQEQ
         Pjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VvjQ+AatnkwTtRURnp0RmzgfSmJxKJJKkKKQF1tSGpg=;
        b=P+4e4Hj8qbdpmOx+nGdY4IL/72P9Bq8BnbPnpHDL2rV6Jz+1xeiwniIBfssHJ8AGSb
         SCLSXxQH4iSaJAeXtf1h9Sw2KZ3JRUs5YmUL3hU2pnug1j6FyD/cRG08RcoCEn39ASm7
         BbWF5WPZcLBkRTH9FIS+WCwBRcw1r14zOB1HmIBwExvv1W2rtqmWMMoWGc4qMCdZFYQk
         xT1NDeOnWID5EiofGHFPT3uAFEunBC2UshWJNHn4Jo5A25oUg3DGomJ1sVx08lLlGSJv
         UAWIiScuB+qfCrt2DPq7eLhNP9U1lBlEhPuOB0NddZwB7hPu45NC1JqKFLeSc0LAMFDe
         e5+g==
X-Gm-Message-State: APjAAAXFOKuUjiZyQ/Pch9Zs+jyCuX58uGYb7X8sueQtlp/s8obUhc9Z
        CYQrXGPuM+EcE0Z3QLgolZ5Qf0arIk+iPp/ecm8=
X-Google-Smtp-Source: APXvYqyaVhBZXlKGgkePb+mjbo99NOnw00vFMO8IQALarCxwIGYmB3uxRH540yVTT9DBtIaisHZ2squMasxud310+Aw=
X-Received: by 2002:a9d:1909:: with SMTP id j9mr2411871ota.139.1561975495755;
 Mon, 01 Jul 2019 03:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 1 Jul 2019 12:04:44 +0200
Message-ID: <CAJ8uoz03_FehgDo24CKhHSkB4ynfJ4EBikB+frFr5_z9uQmVuQ@mail.gmail.com>
Subject: Re: [PATCH 0/6 bpf-next] xsk: reuseq cleanup
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 12:10 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> Clean up and normalize usage of the recycle queue in order to
> support upcoming TX from RX queue functionality.
>
> Jonathan Lemon (6):
>   Have xsk_umem_peek_addr_rq() return chunk-aligned handles.
>   Clean up xsk reuseq API
>   Always check the recycle stack when using the umem fq.
>   Simplify AF_XDP umem allocation path for Intel drivers.
>   Remove use of umem _rq variants from Mellanox driver.
>   Remove the umem _rq variants now that the last consumer is gone.

Maybe it is just me, but I cannot find patch 6/6. Not in my gmail
account and not in my Intel account. Am I just going insane :-)?

/Magnus

>  drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 86 +++----------------
>  .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 59 ++-----------
>  .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  8 +-
>  .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  7 +-
>  include/net/xdp_sock.h                        | 69 ++-------------
>  net/xdp/xdp_umem.c                            |  2 +-
>  net/xdp/xsk.c                                 | 22 ++++-
>  net/xdp/xsk_queue.c                           | 56 +++++-------
>  net/xdp/xsk_queue.h                           |  2 +-
>  10 files changed, 68 insertions(+), 245 deletions(-)
>
> --
> 2.17.1
>
