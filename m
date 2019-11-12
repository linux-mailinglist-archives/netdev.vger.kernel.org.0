Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51ACF934C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKLOwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:52:41 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39855 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLOwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:52:40 -0500
Received: by mail-lj1-f193.google.com with SMTP id p18so18135383ljc.6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 06:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zMxQ9/HiBoVmHgdjL1Dea6TBMrXdo7hHLCySnCEmogQ=;
        b=HCajAbdidtsw4278qDsX+KBdupb0mCwkRKzWDvxwtPr0uVx7AP3AsTK7VI7QH43ME+
         3qbMdoX6DF/sfBv8Lmh2/nFm8oFdVOL7VEZ/vGWufN7FuTmVyKLm+wQCC3d+ik21GG5g
         PDuMUSVA4McUzRjX5mWdlcDrcZW4n/1KYyQNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zMxQ9/HiBoVmHgdjL1Dea6TBMrXdo7hHLCySnCEmogQ=;
        b=kk2r1fUjJ//Xk40Xfjb5undR7XjS0p5FwA3KyQO8iORnBV54cTsDTzO25XrkheVirs
         AakX14lNmM+uLcgBuFmXMK9CoCu/GomZXzmOHbtpmlPrAWB7Z161wLB03x9Ub4W57Fqj
         GVQ906/x8GbLEwsxs4qzneoMhI/FmwdOk9b1RLkaUuyaa9Ucn0WeBZQY5dZpDS8NSV0R
         ldT/2yGDokBWygxwqVDzMQIVKhtfShP+R9cTz4oYRKF7LClBhY+iM0uhcFTZ6+nhLFEj
         nUR8kZHKekYXPpnea2NBTJWgIxAloRU9ljV1vvjtBqKx/gVZpLWpsEV5/5pmyowd6eVn
         uHag==
X-Gm-Message-State: APjAAAVpdo7IMhuo8YbWJvqVs1OOvfib60RV8JtHueXELTtWguFN6Ep5
        5t4M1wTxLRyREWDyks8gKHNMYQsuk7ZqunLpo9yQiA==
X-Google-Smtp-Source: APXvYqwqMsztcy5Mg+165AlF5ASR4319ObjY+ke77gSvEtLMeESmNyD8jVL3nabXwv2uf85mJpGcjovZi5EK5iD75EI=
X-Received: by 2002:a2e:9712:: with SMTP id r18mr10190601lji.12.1573570358059;
 Tue, 12 Nov 2019 06:52:38 -0800 (PST)
MIME-Version: 1.0
References: <20191111105100.2992-1-afabre@cloudflare.com> <f58a73a8-631c-a9a1-25e9-a5f0050df13c@solarflare.com>
 <CAOn4ftvqib3y+Gfhq+dS4cUeWQVyGDM+rNeLnoVoYz9O_VLYLA@mail.gmail.com> <6a3705cc-809d-0c7a-d39f-97d61c4ce58c@solarflare.com>
In-Reply-To: <6a3705cc-809d-0c7a-d39f-97d61c4ce58c@solarflare.com>
From:   Arthur Fabre <afabre@cloudflare.com>
Date:   Tue, 12 Nov 2019 14:52:26 +0000
Message-ID: <CAOn4ftuyCNSehwLHTfZkNP27zbMOpBo+7j5N97J31-gxoAdYCQ@mail.gmail.com>
Subject: Re: [PATCH net-next] sfc: trace_xdp_exception on XDP failure
To:     Edward Cree <ecree@solarflare.com>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Charles McLachlan <cmclachlan@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 6:01 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 11/11/2019 17:38, Arthur Fabre wrote:
> > On Mon, Nov 11, 2019 at 5:27 PM Edward Cree <ecree@solarflare.com> wrote:
> >>
> >> On 11/11/2019 10:51, Arthur Fabre wrote:
> >>> diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
> >>> index a7d9841105d8..5bfe1f6112a1 100644
> >>> --- a/drivers/net/ethernet/sfc/rx.c
> >>> +++ b/drivers/net/ethernet/sfc/rx.c
> >>> @@ -678,6 +678,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
> >>>                                 "XDP is not possible with multiple receive fragments (%d)\n",
> >>>                                 channel->rx_pkt_n_frags);
> >>>               channel->n_rx_xdp_bad_drops++;
> >>> +             trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
> >>>               return false;
> >>>       }
> >> AIUI trace_xdp_exception() is improper here as we have not run
> >>  the XDP program (and xdp_act is thus uninitialised).
> >>
> >> The other three, below, appear to be correct.
> >> -Ed
> >>
> >
> > Good point. Do you know under what conditions we'd end up with
> > "fragmented" packets? As far as I can tell this isn't IP
> > fragmentation?
>
> Fragments in this case means that the packet data are spread across
>  multiple RX buffers (~= memory pages).  This should only happen if
>  the RX packet is too big to fit in a single buffer, and when
>  enabling XDP we ensure that the MTU is small enough to prevent
>  that.  So in theory this can't happen if the NIC is functioning
>  correctly.
>
> -Ed

Makes sense, thank you for the explanation.
