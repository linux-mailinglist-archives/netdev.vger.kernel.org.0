Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1BB1DDC3F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgEVAh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgEVAh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:37:57 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB367C061A0E;
        Thu, 21 May 2020 17:37:56 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id l15so10200554lje.9;
        Thu, 21 May 2020 17:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AkEgabl395huzWseTgtw/Io+3EYGdXqhwE0PaeGRpPE=;
        b=K3OGjNL3WnMdDVfRNisejDDSY5BuKO3/T+xNSsg2sR4UqjAhvBgcNMqQ33XM14UYgY
         PXPChTvNMIY10uBgFZzgRJ5NqMKV+aMWMvLY4NLKWMyWI6HxanY1ZnOAYvAjvuQAkaPU
         vIH+xU4aK9YkuxRaeS/xgRNABTb1rogRsb1eOpqt97pcpXYcvmDsgxPslyPNgFLX+sma
         Kuaoz5FfJ9Q06egsIykzAJBOmuBYA8PIFo5o83jcurV0RQ/EC4DDJSyFrmldWHehfm7f
         oqYYJDKtd+0v7TOsnWfX0UhwDk6ITH7yi99oRQGKrAOOxujryXScqgbS1FpSkXB4Ejnl
         Qsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AkEgabl395huzWseTgtw/Io+3EYGdXqhwE0PaeGRpPE=;
        b=eJUehd4IhqXh/2BqwkBf0IEEeXgIh1oErhh7uFgx4SQkcK4YXNDZ/+xml6+kVlQg8y
         D6SFmZ6ju5hlLUgZuejtbdKuLwx5uMaFBYUm3bgk9Vhb8ZAYdzl0N+XkEaCJkb2IG+TG
         crrVEa70oBRktDBO/zv8hmmgP7Uz8NGVwD/cxcrhlxv0fcYAtKFyq4jeP0HeyFII0Vie
         +lPrnulV2mCh8JyRHcDic2pFLGATRSlALjlwx8mDOkXZI0OJoqLBg0Zi8XnRz7XV9Rfi
         087mEy4UCtPwVlMKRRnl+7hsEbXoNSqlLfppgFvMwNLk3r6FBWIaoILnfV2m7/W/oyDD
         OdKQ==
X-Gm-Message-State: AOAM533T1iW0RaKt/jPRipZzXsgJlZj4N/IHORRtaRa+Lsi6UUm7Tn3P
        FcNXZmMYUnCPsEKiLCpTLUc7vcoYkJMQYimHuxA=
X-Google-Smtp-Source: ABdhPJxlGC7cr4vKZskD141bQSRpOEj3o0jlZz95RQ4Mjtaxg5FU4uR5XStTAuzre3pESBVxXQvrMGNtuTtMVtc3qEQ=
X-Received: by 2002:a05:651c:2de:: with SMTP id f30mr4283989ljo.450.1590107874835;
 Thu, 21 May 2020 17:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 May 2020 17:37:43 -0700
Message-ID: <CAADnVQJTPUNUmVvSmQMdbPeNU90gS69_Y7gWBKh+3masJX_xkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/15] Introduce AF_XDP buffer allocation API
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:21 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Driver adoption for AF_XDP has been slow. The amount of code required
> to proper support AF_XDP is substantial and the driver/core APIs are
> vague or even non-existing. Drivers have to manually adjust data
> offsets, updating AF_XDP handles differently for different modes
> (aligned/unaligned).
>
> This series attempts to improve the situation by introducing an AF_XDP
> buffer allocation API. The implementation is based on a single core
> (single producer/consumer) buffer pool for the AF_XDP UMEM.
>
> A buffer is allocated using the xsk_buff_alloc() function, and
> returned using xsk_buff_free(). If a buffer is disassociated with the
> pool, e.g. when a buffer is passed to an AF_XDP socket, a buffer is
> said to be released. Currently, the release function is only used by
> the AF_XDP internals and not visible to the driver.
>
> Drivers using this API should register the XDP memory model with the
> new MEM_TYPE_XSK_BUFF_POOL type, which will supersede the
> MEM_TYPE_ZERO_COPY type.
>
> The buffer type is struct xdp_buff, and follows the lifetime of
> regular xdp_buffs, i.e.  the lifetime of an xdp_buff is restricted to
> a NAPI context. In other words, the API is not replacing xdp_frames.
>
> DMA mapping/synching is folded into the buffer handling as well.
>
> @JeffK The Intel drivers changes should go through the bpf-next tree,
>        and not your regular Intel tree, since multiple (non-Intel)
>        drivers are affected.
>
> The outline of the series is as following:
>
> Patch 1 is a fix for xsk_umem_xdp_frame_sz().
>
> Patch 2 to 4 are restructures/clean ups. The XSKMAP implementation is
> moved to net/xdp/. Functions/defines/enums that are only used by the
> AF_XDP internals are moved from the global include/net/xdp_sock.h to
> net/xdp/xsk.h. We are also introducing a new "driver include file",
> include/net/xdp_sock_drv.h, which is the only file NIC driver
> developers adding AF_XDP zero-copy support should care about.
>
> Patch 5 adds the new API, and migrates the "copy-mode"/skb-mode AF_XDP
> path to the new API.
>
> Patch 6 to 11 migrates the existing zero-copy drivers to the new API.
>
> Patch 12 removes the MEM_TYPE_ZERO_COPY memory type, and the "handle"
> member of struct xdp_buff.
>
> Patch 13 simplifies the xdp_return_{frame,frame_rx_napi,buff}
> functions.
>
> Patch 14 is a performance patch, where some functions are inlined.
>
> Finally, patch 15 updates the MAINTAINERS file to correctly mirror the
> new file layout.
>
> Note that this series removes the "handle" member from struct
> xdp_buff, which reduces the xdp_buff size.
>
> After this series, the diff stat of drivers/net/ is:
>   27 files changed, 419 insertions(+), 1288 deletions(-)
>
> This series is a first step of simplifying the driver side of
> AF_XDP. I think more of the AF_XDP logic can be moved from the drivers
> to the AF_XDP core, e.g. the "need wakeup" set/clear functionality.
>
> Statistics when allocation fails can now be added to the socket
> statistics via the XDP_STATISTICS getsockopt(). This will be added in
> a follow up series.
>
>
> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> As a nice side effect, performance is up a bit as well.
>
>   * i40e: 3% higher pps for rxdrop, zero-copy, aligned and unaligned
>     (40 GbE, 64B packets).
>   * mlx5: RX +0.8 Mpps, TX +0.4 Mpps
>
>
> Changelog
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> v4->v5:
>   * Fix various kdoc and GCC warnings (W=3D1). (Jakub)

Applied to bpf-next. Thanks!
