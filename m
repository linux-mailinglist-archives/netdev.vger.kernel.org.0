Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10FA474577
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhLNOqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbhLNOqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:46:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A844C061574;
        Tue, 14 Dec 2021 06:46:31 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gj24so530234pjb.0;
        Tue, 14 Dec 2021 06:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIVCmsuAMVImfriiYow8c1qDhI05Ehf9vFjNjkmAmtM=;
        b=gawJlSLJAMBNqBeAsSK57x0uKhwlYQRI8jtsSjQ0BDq9mHT6uHpzoyrBcy3D3BJVqA
         /Ysvgur2G5iht8txUsgEZZ34c94dJSkL/W0CWJ5bUex9dekd2T61Za5TmuGuzv+MnrHe
         mlnA/94cORuogMyWgMc3eOm6RYHtCbN8hrlEWxYdWprDXi9mdNicy2f8nGgaR/6ALtyJ
         PvTIKyJiF6K/Fk/J16p4yCrq2YMD+RDTbfiXEQJTduUkkcj1fqiDq4wEIVQacrgtOgzb
         vZIsC1HvF+XgQ01CPonvcLnRjVyKX7x8+HwWcvaJXvT2Y4h8EvlXF+wP+zjf1slCc8GP
         t5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIVCmsuAMVImfriiYow8c1qDhI05Ehf9vFjNjkmAmtM=;
        b=YbgQtSwhxbE/40fcRrjrsogHE3ZEDFEnt4Hm+OKfjdGrr8XRos+6lrxEJoFjqRm00+
         auTjx9+PzWANuRYbDM7gLCcS1pPFrgdqgYLwzpZNpGamC952UG0ByMsTbXUZGdzesnoR
         rjW5Bi9BZuaqXV53xcCD3uI93bLuWKk5OE4aZSh0Pq6FfrBJBBGqQVanwt9aUtY3eWZ5
         dqaIZ5eHaRRLGG0USfJKcWXE18eyT+hjRtFHgbD3vxoUEe0eLOE82tSh2TOTHFrp7kQD
         6tjx67oRl+tfaaYFQcUvwORC4+JRkw5Bq6UpNibIzhA6n8IkWU83N+CgW2SlqVX4fVyd
         I9QA==
X-Gm-Message-State: AOAM533wJd3triq7fuJIcuXMswb4CauUAfXIFVpAM2RC+NzCrthCgQEW
        JLisUKNRWB1p8usXK0DFlG0O+mzxNTdrdsfaLuUgtxAU2km8TXWb
X-Google-Smtp-Source: ABdhPJxVWeGKAMAekRtLG64jFT56xxyEr62immDtXUwhTaUHaatqeQEA8PlVYLwpgyLj/7nWlsLN3VbJgy7iLN2yU8Y=
X-Received: by 2002:a17:90b:3b8d:: with SMTP id pc13mr5904614pjb.112.1639493190905;
 Tue, 14 Dec 2021 06:46:30 -0800 (PST)
MIME-Version: 1.0
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 14 Dec 2021 15:46:19 +0100
Message-ID: <CAJ8uoz0Fb-hciySWAy79X2d_H=oUddbFGCm3RUAtRYhUQ5-K5w@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 intel-net 0/6] ice: xsk: Rx
 processing fixes
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        elza.mathew@intel.com,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 4:31 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Hi there,
> it seems that previous [0] Rx fix was not enough and there are still
> issues with AF_XDP Rx ZC support in ice driver. Elza reported that for
> multiple XSK sockets configured on a single netdev, some of them were
> becoming dead after a while. We have spotted more things that needed to
> be addressed this time. More of information can be found in particular
> commit messages.
>
> v2 has a diff around only patch 2:
> - use array_size() in memsets (Alexandr)
> - remove unnecessary ternary operator from ice_alloc_rx_buf{, _zc}()
>   (Alexandr)
> - respect RCT in ice_construct_skb_zc() (Alexandr)
> - fix kdoc issue (Anthony)
>
> It also carries Alexandr's patch that was sent previously which was
> overlapping with this set.
>
> Thanks,
> Maciej
>
> [0]: https://lore.kernel.org/bpf/20211129231746.2767739-1-anthony.l.nguyen@intel.com/

Thank you so much for all these fixes Maciej and Alexandr!

BTW, ice zero-copy support in bpf and bpf-next does not work at all
without this patch set, so need to get this in as soon as possible.
net and net-next might not work either, but have not tried.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Alexander Lobakin (1):
>   ice: remove dead store on XSK hotpath
>
> Maciej Fijalkowski (5):
>   ice: xsk: return xsk buffers back to pool when cleaning the ring
>   ice: xsk: allocate separate memory for XDP SW ring
>   ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
>   ice: xsk: allow empty Rx descriptors on XSK ZC data path
>   ice: xsk: fix cleaned_count setting
>
>  drivers/net/ethernet/intel/ice/ice_base.c | 17 ++++++
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 19 ++++---
>  drivers/net/ethernet/intel/ice/ice_txrx.h |  1 -
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 66 +++++++++++------------
>  4 files changed, 62 insertions(+), 41 deletions(-)
>
> --
> 2.33.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
