Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617C3510C8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbfFXPip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:38:45 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41309 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFXPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:38:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id c11so10074216qkk.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 08:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M/8vPF9WvOW147aOpJHmn3aeyjOXXRZcWaf81TVyXi0=;
        b=WoswxBpLcd/C9MwdGLWFy1YPNHLW7qRx+kZkD1aRtd5wn0QJbUZ+K8F3bZZHjGXoRC
         bpk4h7DJQa+m8qkVMW49Y60UQ3unWWO83RfuBnvVpwekv/RBOylqe1HUbaQuS9zXIk/e
         hiaMmjRO/c5pGO5MLwaXJ1ki41ne5wAbglEGwok73Ygwy7DnYH/VdbZczMIuc5vRC3Iv
         THga4HF12bhhqArE8LWeqiy0YHrcXDMVnfba7crDvELbb+pjRe2dkaAlzSCt/X5r8dtK
         PTRnafDtyLVR3WW+48N51Nz5sqVd92vvmHYY2OPhmECOrrCfO8LwbO3n+IPi7hAMgfSI
         O7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M/8vPF9WvOW147aOpJHmn3aeyjOXXRZcWaf81TVyXi0=;
        b=sXOnF/j2qYVoPcKD2/FSYeNMTbQruglvY4iCcP+V7igcQjsQ1GTrHgFlO704Hh4oBZ
         e8rU8plBAbq+RWseq2CCRYW54Egm2R3RLR6e6QK5Aur55lvIIkb6hZx4de8DyEpH03TC
         TIza/fxUTgp4T9R/CZBDK2ol8hc4ijIbJGO0GdAO6T1jfZ7nXCDSdmrwABg7AeRJ+WGG
         sU43M/AuldWIQpv3EPanHaDpikFu7wA/4JSH5v7ayGkQMDQkNBzHd8y2EaXSZvOtpxJ0
         uOvmvSNDfvSd+FhgQLH50xQbsaXAX+V2OlyrQASBjgsDt+4m+HorpAg3GtSDHF/joMCU
         IvCg==
X-Gm-Message-State: APjAAAW/Lq46T7ffTbOCY8OJzZ12/a7d+jnk3nWna8jlBh4B++rw7LcR
        nx4Gy9jnw0KkYtmpZxR+eNbmt4YPSOYkS5L/ZEE=
X-Google-Smtp-Source: APXvYqypNSE0wid4ZRNAQx1WFMWmhV2s+cygHRPjP32E/x3JYdvEts3wgP/EIfvHUtj3oM9HhYCOPWxfCxMm9CNT+ds=
X-Received: by 2002:a05:620a:48d:: with SMTP id 13mr17490028qkr.493.1561390723974;
 Mon, 24 Jun 2019 08:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190620083924.1996-1-kevin.laatz@intel.com>
In-Reply-To: <20190620083924.1996-1-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 17:38:33 +0200
Message-ID: <CAJ+HfNijp8BgMgiOuohiuqDPz+spAutdG34gUqKzepYo2noE-w@mail.gmail.com>
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf@vger.kernel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 18:55, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patchset adds the ability to use unaligned chunks in the XDP umem.
>
> Currently, all chunk addresses passed to the umem are masked to be chunk
> size aligned (default is 2k, max is PAGE_SIZE). This limits where we can
> place chunks within the umem as well as limiting the packet sizes that ar=
e
> supported.
>
> The changes in this patchset removes these restrictions, allowing XDP to =
be
> more flexible in where it can place a chunk within a umem. By relaxing wh=
ere
> the chunks can be placed, it allows us to use an arbitrary buffer size an=
d
> place that wherever we have a free address in the umem. These changes add=
 the
> ability to support jumboframes and make it easy to integrate with other
> existing frameworks that have their own memory management systems, such a=
s
> DPDK.
>

Thanks for working on this, Kevin and Ciara!

I have some minor comments on the series, but in general I think it's
in good shape!

For some reason the series was submitted twice (at least on my side)?


Thanks,
Bj=C3=B6rn

> Structure of the patchset:
> Patch 1:
>   - Remove unnecessary masking and headroom addition during zero-copy Rx
>     buffer recycling in i40e. This change is required in order for the
>     buffer recycling to work in the unaligned chunk mode.
>
> Patch 2:
>   - Remove unnecessary masking and headroom addition during
>     zero-copy Rx buffer recycling in ixgbe. This change is required in
>     order for the  buffer recycling to work in the unaligned chunk mode.
>
> Patch 3:
>   - Adds an offset parameter to zero_copy_allocator. This change will
>     enable us to calculate the original handle in zca_free. This will be
>     required for unaligned chunk mode since we can't easily mask back to
>     the original handle.
>
> Patch 4:
>   - Adds the offset parameter to i40e_zca_free. This change is needed for
>     calculating the handle since we can't easily mask back to the origina=
l
>     handle like we can in the aligned case.
>
> Patch 5:
>   - Adds the offset parameter to ixgbe_zca_free. This change is needed fo=
r
>     calculating the handle since we can't easily mask back to the origina=
l
>     handle like we can in the aligned case.
>
>
> Patch 6:
>   - Add infrastructure for unaligned chunks. Since we are dealing
>     with unaligned chunks that could potentially cross a physical page
>     boundary, we add checks to keep track of that information. We can
>     later use this information to correctly handle buffers that are
>     placed at an address where they cross a page boundary.
>
> Patch 7:
>   - Add flags for umem configuration to libbpf
>
> Patch 8:
>   - Modify xdpsock application to add a command line option for
>     unaligned chunks
>
> Patch 9:
>   - Addition of command line argument to pass in a desired buffer size
>     and buffer recycling for unaligned mode. Passing in a buffer size wil=
l
>     allow the application to use unaligned chunks with the unaligned chun=
k
>     mode. Since we are now using unaligned chunks, we need to recycle our
>     buffers in a slightly different way.
>
> Patch 10:
>   - Adds hugepage support to the xdpsock application
>
> Patch 11:
>   - Documentation update to include the unaligned chunk scenario. We need
>     to explicitly state that the incoming addresses are only masked in th=
e
>     aligned chunk mode and not the unaligned chunk mode.
>
> Kevin Laatz (11):
>   i40e: simplify Rx buffer recycle
>   ixgbe: simplify Rx buffer recycle
>   xdp: add offset param to zero_copy_allocator
>   i40e: add offset to zca_free
>   ixgbe: add offset to zca_free
>   xsk: add support to allow unaligned chunk placement
>   libbpf: add flags to umem config
>   samples/bpf: add unaligned chunks mode support to xdpsock
>   samples/bpf: add buffer recycling for unaligned chunks to xdpsock
>   samples/bpf: use hugepages in xdpsock app
>   doc/af_xdp: include unaligned chunk case
>
>  Documentation/networking/af_xdp.rst           | 10 +-
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 21 ++--
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  3 +-
>  .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  3 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 21 ++--
>  include/net/xdp.h                             |  3 +-
>  include/net/xdp_sock.h                        |  2 +
>  include/uapi/linux/if_xdp.h                   |  4 +
>  net/core/xdp.c                                | 11 ++-
>  net/xdp/xdp_umem.c                            | 17 ++--
>  net/xdp/xsk.c                                 | 60 +++++++++--
>  net/xdp/xsk_queue.h                           | 60 +++++++++--
>  samples/bpf/xdpsock_user.c                    | 99 ++++++++++++++-----
>  tools/include/uapi/linux/if_xdp.h             |  4 +
>  tools/lib/bpf/xsk.c                           |  7 ++
>  tools/lib/bpf/xsk.h                           |  2 +
>  16 files changed, 241 insertions(+), 86 deletions(-)
>
> --
> 2.17.1
>
