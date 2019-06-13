Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F4943A46
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbfFMPUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:20:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39165 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732119AbfFMM7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:59:05 -0400
Received: by mail-qk1-f194.google.com with SMTP id i125so12637957qkd.6;
        Thu, 13 Jun 2019 05:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x96K3+yL4WoUgnEbirvBaQSKr83c32+ERLs1LIKkwik=;
        b=aiuyJuLRNLVdQzLYuGRJtnZRYInh5hhIMPa9LjwLM63yX5CvsZQOsbo+GnFEoD248a
         xaRDOKNFcdUCWH12pQ78N2OCNqhp5fQ1vhYdmaL52Byr5RcQgY3zzmYRC+GqrwvNh1i2
         U3iy8D3vwWbsgUyVLdUSEdxyPyFawJ4vLVeSzCBdiH4Afu1t44qeoeC8kHErEK5LjkeS
         M1SjVwuK8jlGWYuLug+WQfY7pIoQVqan5O6Se+d9f8PUe+ptLDddhZnHBYBjrFAyo+O6
         I6vhAj6qXFcui42Shut0MN0K2oJsJdLRJZ/DB3qJ7tEatNUDG7yUcyW2qjJd7ImsO6S5
         Frow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x96K3+yL4WoUgnEbirvBaQSKr83c32+ERLs1LIKkwik=;
        b=rNNa2CBuh9DSX7ZP9ZjQEsC/IJhd2JUkOZ2xsYZonL43mxgeUSNmVmHgTKDlL9uPlD
         i9+Srdi4Wmok4JzdgP+qedXLL/hkv9rY2q8x24yPs8pLIavUkaBtTAyCOCogT/v/IKir
         9g2R09JYchMfFI6dD5ryrJT29Inqu9f1Qvg8Yz5RgHGUk01OQ6JVSKrNGptgHDigk5wS
         tCNrDRKz5/Mw0kLp7gp+X4WG164lWKnxDcvIskdNxCMtL8Q0b1iHPL0PDCyqY6pyiCzf
         tIqamcrHa5iX0+5jKHuFK1mWGxamaDWW2GgWNeVVe1ejQ4tD7asMRJLD++ZD3ZRNzg57
         zF6A==
X-Gm-Message-State: APjAAAWef74yfLEdsfcLHgpBMIewxwgBU2PWch8zGLH2RdV9JvQbjSxL
        V5LhE0H8rhlxdMUm7dDxrf2sQSO+wsRod+FZMyg=
X-Google-Smtp-Source: APXvYqz95RLzseryKJga4Si/42Zv1IRKHwAbyL/zJWk/rxwWn71NzSoi+u8mr0d/R73URdZIhnQpog6X9ga57gdswoo=
X-Received: by 2002:a37:7786:: with SMTP id s128mr70800782qkc.63.1560430743646;
 Thu, 13 Jun 2019 05:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612134805.3bf4ea25@cakuba.netronome.com>
In-Reply-To: <20190612134805.3bf4ea25@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 14:58:52 +0200
Message-ID: <CAJ+HfNh3KcoZC5W6CLgnx2tzH41Kz11Zs__2QkOKF+CyEMzdMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 at 22:49, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 12 Jun 2019 15:56:33 +0000, Maxim Mikityanskiy wrote:
> > UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
> > half of the available amount of RX queues are regular queues, and the
> > upper half are XSK RX queues.
>
> If I have 32 queues enabled on the NIC and I install AF_XDP socket on
> queue 10, does the NIC now have 64 RQs, but only first 32 are in the
> normal RSS map?
>

Additional, related, question to Jakub's: Say that I'd like to hijack
all 32 Rx queues of the NIC. I create 32 AF_XDP socket and attach them
in zero-copy mode to the device. What's the result?

> > The patch "xsk: Extend channels to support combined XSK/non-XSK
> > traffic" was dropped. The final patch was reworked accordingly.
>
> The final patches has 2k LoC, kind of hard to digest.  You can also
> post the clean up patches separately, no need for large series here.
