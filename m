Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA0C55757
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732936AbfFYSoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:44:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44723 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731361AbfFYSoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:44:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so9917955pfe.11
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Fbh/+qgP4LBddXodFMfI0tKPb3y0XNzyf5BEgokE7RU=;
        b=dF6QkZWbwmtpecHu27CQ+3q4CePL38FBsSXQAPj8r2Er3XKRMYUrIEcAgQIQiOdrzy
         QvSl+YTgA8JULoxkIQAWD4mbNCeT3252Mml6EM7/fljlUExDsRlglCJ5klEEOva02b2T
         FVKKKznJ2Uri6Yd5VQ4/PVYYOa/HwsZWvfBisnzLOtAwkoYDV0cnywiF4LmFHjz8TIKR
         6uFlzRT1yndPfXITPCGzREVtj/1FYB35QU3XDCGfavja3vlLdBXwzEzGGt0YKRzlRav4
         G0FoT2gUqd38wBpMuL1BaDHsc1Vnq8A/G9f75ds6AAQTiUi/SibqElx3bqjbazBCnf2q
         VAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Fbh/+qgP4LBddXodFMfI0tKPb3y0XNzyf5BEgokE7RU=;
        b=Zn5Kv10RMiEWFoh3CurFLFmbaYBSMaHiSNFoTfl1rsFkrcMVx/7MlFHGs21yJBCI+B
         jdp2PW01/WKlXj3wv/xynIgwYYMkccFuDroeU8iN5MnXGlotGsr6ZayPahIN59sl63xF
         HzpshQeXrcjiu2yEGVZS/ej43D1MZLdamzTGjgpDmuZMZ00r3hClJMgFaCGPGv3+ipCy
         EpqkP5CX0111apRsKPvjamQfMCzYJIsfs0nPEogaz1BaBAztzKx7ihD3DTDJ8mGNYIje
         hpj/LQqsP48Qclu5LgfTSSCxR97KJd9W5B2Go5hHMWb+aEj98FKSXSyNqR+RscMnsFvK
         7NwA==
X-Gm-Message-State: APjAAAX5ore8ipGwPo1hbmSo41o6qhjA3nyCV89d3N0UlnXRoBXopdzW
        i7K3dH535VbFC2XNMZIIou4=
X-Google-Smtp-Source: APXvYqxxisUGgmYPspgwA5mwlBmuVZwDePacu53JwzADQRBuh9kk4QYe+miKZcFkM8nnNmo1Ei7V3w==
X-Received: by 2002:a17:90a:33c4:: with SMTP id n62mr359185pjb.28.1561488244928;
        Tue, 25 Jun 2019 11:44:04 -0700 (PDT)
Received: from [172.20.52.61] ([2620:10d:c090:200::3:e848])
        by smtp.gmail.com with ESMTPSA id b36sm3563049pjc.16.2019.06.25.11.44.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 11:44:03 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        bpf@vger.kernel.com, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Date:   Tue, 25 Jun 2019 11:44:01 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
In-Reply-To: <20190620083924.1996-1-kevin.laatz@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 Jun 2019, at 1:39, Kevin Laatz wrote:

> This patchset adds the ability to use unaligned chunks in the XDP 
> umem.
>
> Currently, all chunk addresses passed to the umem are masked to be 
> chunk
> size aligned (default is 2k, max is PAGE_SIZE). This limits where we 
> can
> place chunks within the umem as well as limiting the packet sizes that 
> are
> supported.
>
> The changes in this patchset removes these restrictions, allowing XDP 
> to be
> more flexible in where it can place a chunk within a umem. By relaxing 
> where
> the chunks can be placed, it allows us to use an arbitrary buffer size 
> and
> place that wherever we have a free address in the umem. These changes 
> add the
> ability to support jumboframes and make it easy to integrate with 
> other
> existing frameworks that have their own memory management systems, 
> such as
> DPDK.

I'm a little unclear on how this should work, and have a few issues 
here:

  1) There isn't any support for the user defined umem->headroom

  2) When queuing RX buffers, the handle (aka umem offset) is used, 
which
     points to the start of the buffer area.  When the buffer appears in
     the completion queue, handle points to the start of the received 
data,
     which might be different from the buffer start address.

     Normally, this RX address is just put back in the fill queue, and 
the
     mask is used to find the buffer start address again.  This no 
longer
     works, so my question is, how is the buffer start address 
recomputed
     from the actual data payload address?

     Same with TX - if the TX payload isn't aligned in with the start of
     the buffer, what happens?

  3) This appears limited to crossing a single page boundary, but there
     is no constraint check on chunk_size.
-- 
Jonathan

>
> Structure of the patchset:
> Patch 1:
>   - Remove unnecessary masking and headroom addition during zero-copy 
> Rx
>     buffer recycling in i40e. This change is required in order for the
>     buffer recycling to work in the unaligned chunk mode.
>
> Patch 2:
>   - Remove unnecessary masking and headroom addition during
>     zero-copy Rx buffer recycling in ixgbe. This change is required in
>     order for the  buffer recycling to work in the unaligned chunk 
> mode.
>
> Patch 3:
>   - Adds an offset parameter to zero_copy_allocator. This change will
>     enable us to calculate the original handle in zca_free. This will 
> be
>     required for unaligned chunk mode since we can't easily mask back 
> to
>     the original handle.
>
> Patch 4:
>   - Adds the offset parameter to i40e_zca_free. This change is needed 
> for
>     calculating the handle since we can't easily mask back to the 
> original
>     handle like we can in the aligned case.
>
> Patch 5:
>   - Adds the offset parameter to ixgbe_zca_free. This change is needed 
> for
>     calculating the handle since we can't easily mask back to the 
> original
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
>     and buffer recycling for unaligned mode. Passing in a buffer size 
> will
>     allow the application to use unaligned chunks with the unaligned 
> chunk
>     mode. Since we are now using unaligned chunks, we need to recycle 
> our
>     buffers in a slightly different way.
>
> Patch 10:
>   - Adds hugepage support to the xdpsock application
>
> Patch 11:
>   - Documentation update to include the unaligned chunk scenario. We 
> need
>     to explicitly state that the incoming addresses are only masked in 
> the
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
>  samples/bpf/xdpsock_user.c                    | 99 
> ++++++++++++++-----
>  tools/include/uapi/linux/if_xdp.h             |  4 +
>  tools/lib/bpf/xsk.c                           |  7 ++
>  tools/lib/bpf/xsk.h                           |  2 +
>  16 files changed, 241 insertions(+), 86 deletions(-)
>
> -- 
> 2.17.1
