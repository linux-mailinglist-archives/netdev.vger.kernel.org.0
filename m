Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E8733EBD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 08:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfFDGGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 02:06:40 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43712 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDGGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 02:06:40 -0400
Received: by mail-qt1-f196.google.com with SMTP id z24so5270305qtj.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 23:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zBRWHisenNGef1CDid7kHl93EWt0MERJyTzXEdfVmww=;
        b=rFrGwUdPPEOjBlc3biep9CDc334GHoA4x4GqHevvDpnu//+M3VqdK4YkA9aHKVS8yY
         qyopnns47Uf18+I5p+gU340I5yPo2zlyOIwqvlfkknonKmmOruZ2DTk5n0ZdLQpsmJIw
         20y5o6+DfUhTlQ5nHYLErH6yQcB+mU6NXZPOu/GAKaeYd4+GTDoBAOw3QAHlx/WDZ2cS
         f1aUcs9Qyt6TBBsb/0Uh3qazAnTzq+UEKUKyK8K0shEKfY1MTV2jHcxrNa4MyedRkinc
         XLF/VhhVe7N9UY0XTh4qIh8AOuearVW8rDOjFOqsS9ZMjrAK/miYwrvX6Nd42FdDEGoj
         pXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zBRWHisenNGef1CDid7kHl93EWt0MERJyTzXEdfVmww=;
        b=K/odhKzPHN1xWHyHRrRInSDq0M8wOC7HcNHynkyZLqTOwSUgpF5WdnV15hst4SpF8O
         FuyiOqjCAKhxiOFcUUi8KpKhFvjW3V3kt+TnKKAyBxR4QmURd3xmsYw2a2tc59/VOi+p
         sMqqBcCAwlD403aSlRTjyYhVIgTcpKlMRPGMK8oQ1xAtarOW7gACLT73fylTshwBVo9F
         fSg33SBQlKWa/Fy6LPJFXmG+AfDRCBWRarB7/FDn7Ppx6Vg6YKMFuVEXEje9wlSiTD9x
         Lvir1umVHLIJEFliwq1ilD4UEizhlTZ0KOy8SpjQov0vEvIbZwA0vX0fz3bEJ/ybFs9y
         gR8w==
X-Gm-Message-State: APjAAAWxaOu/ROj0Wafaq0i12OAD2wHGQKbnEJCPu6hao7UpTkmOniyU
        t1C/UaeoZy2VUlUjHF1eEeTvrmEecwSEJGlFvPc=
X-Google-Smtp-Source: APXvYqxXlykFgMfSDhRZ4Ba17Y7UMmb1rim+P6Q5wWsHCm2mE5rdT8RVLCmgnH7GjjQHmMTJ1zkyICk6Ei9dHBrIG3I=
X-Received: by 2002:a0c:d610:: with SMTP id c16mr25986608qvj.22.1559628399317;
 Mon, 03 Jun 2019 23:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 4 Jun 2019 08:06:28 +0200
Message-ID: <CAJ+HfNgtQ20Hpag8Y_rmBttrKOxZXGAeLS3ELLr_41+GXsv_7Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/2] Better handling of xskmap entries
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 19:49, Jonathan Lemon <jonathan.lemon@gmail.com> wrot=
e:
>
> v3->v4:
>  - Clarify error handling path.
>
> v2->v3:
>  - Use correct map type.
>
> Jonathan Lemon (2):
>   bpf: Allow bpf_map_lookup_elem() on an xskmap
>   libbpf: remove qidconf and better support external bpf programs.
>

Nice work!

For the series,

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


>  include/net/xdp_sock.h                        |   6 +-
>  kernel/bpf/verifier.c                         |   6 +-
>  kernel/bpf/xskmap.c                           |   4 +-
>  tools/lib/bpf/xsk.c                           | 103 +++++-------------
>  .../bpf/verifier/prevent_map_lookup.c         |  15 ---
>  5 files changed, 39 insertions(+), 95 deletions(-)
>
> --
> 2.17.1
>
