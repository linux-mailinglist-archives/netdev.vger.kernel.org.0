Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B0C8D6C8
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfHNPAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:00:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44713 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHNPAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:00:02 -0400
Received: by mail-ot1-f66.google.com with SMTP id w4so7968454ote.11;
        Wed, 14 Aug 2019 08:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mqYnljBZWJ9CSU4xNm5KnWlCC0kHqslp4DIAsr09jT0=;
        b=Bp4LLyGrIdsRWVPZEAy7Y88iJcA2V/WKLgjXRWhwwUTTWTT2rfBu1i/Eavvr4H5HFY
         20G1Jy8DOxPO6vZhyRvw9P1FlsZd7DDLIjjOQwkDQmd9QBIIhqc3TSYtRTTUo5NCWQrj
         BgHJOfuP5CX7WE3i4vK68LjoxvpYacbchTVSUhxmuyc4p6NOsd46SwTZ74+z9na2GzpN
         YT6gpQt1ldXvTZV637WBhNsWz8YWU2cOrb1u9z/VXhnHCBhOiJzdCr+LgxcOnzV3wmkI
         kfRMHDPEopjCFpxIJjDd9v2vURHny479/bqtgKH7LKGe50SbmwOKcBVgxXRQxuNCCVCj
         8a+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mqYnljBZWJ9CSU4xNm5KnWlCC0kHqslp4DIAsr09jT0=;
        b=UApbIJpyfHaTnIJiepNHMDWdWxwZXl1ZMseJLGwq7ZIKbCk3rsQxfXhAeDxu8dQX2j
         KxrP5v14uLZgJOSW3gCKfi53rwrHHB+bnGGg/sk6r3C0fmT3sJkX3/W7+8hP9jXJZXOx
         DoQytWTLq/B2IXL5VKurXjRwY+iXdsTXGBxdv/bsO9IJUNUTYtpe3UKjqINm8PvmkAOb
         ru4FOcurphsuRYztuJwBVbzO2skJV3MC1ii/7CjfkM8ZRbPqyY6XnGeNNoWcLig50Rf0
         BK1F32G8sMJEM+vpIalHZjDfYBAV0ESeJB4XjgnizqAr/NaKJ10J5NzfUHsY8JKD6tIr
         ydag==
X-Gm-Message-State: APjAAAVe8h0FvaS7zsHvntjABkC7srG+uf/RaOkf92JGa1m9wvH9MoDt
        OnQQwXpcHvzSWy/yJYWqzFz3jKDrQtgnTl5H4KM=
X-Google-Smtp-Source: APXvYqyzISvYx9KXXQMPCWFPWDem0P2xD3aWYJvKHkMRJW+c9ClkjsSF8s7cuJgUoPd67VAQ1gn/OKcDsOQskRjX7kY=
X-Received: by 2002:a9d:5e19:: with SMTP id d25mr4093379oti.192.1565794801058;
 Wed, 14 Aug 2019 08:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-4-git-send-email-magnus.karlsson@intel.com> <3B2C7C21-4AAC-4126-A31D-58A61D941709@gmail.com>
In-Reply-To: <3B2C7C21-4AAC-4126-A31D-58A61D941709@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 14 Aug 2019 16:59:49 +0200
Message-ID: <CAJ8uoz0Tnb=i-LkGqLU87be9BuYqxmu2pN1Mte0UEWA2+f8bTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/8] i40e: add support for AF_XDP need_wakeup feature
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bpf <bpf@vger.kernel.org>, bruce.richardson@intel.com,
        ciara.loftus@intel.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Ye Xiaolong <xiaolong.ye@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Kevin Laatz <kevin.laatz@intel.com>,
        ilias.apalodimas@linaro.org, Kiran <kiran.patil@intel.com>,
        axboe@kernel.dk,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 4:48 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:
>
> > This patch adds support for the need_wakeup feature of AF_XDP. If the
> > application has told the kernel that it might sleep using the new bind
> > flag XDP_USE_NEED_WAKEUP, the driver will then set this flag if it has
> > no more buffers on the NIC Rx ring and yield to the application. For
> > Tx, it will set the flag if it has no outstanding Tx completion
> > interrupts and return to the application.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index d0ff5d8..42c9012 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -626,6 +626,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring
> > *rx_ring, int budget)
> >
> >       i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
> >       i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
> > +
> > +     if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
> > +             if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
> > +                     xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
> > +             else
> > +                     xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
> > +
> > +             return (int)total_rx_packets;
> > +     }
> >       return failure ? budget : (int)total_rx_packets;
>
> Can you elaborate why we're not returning the total budget on failure
> for the wakeup case?

In the non need_wakeup case (the old behavior), when allocation fails
from the fill queue we want to retry right away basically busy
spinning on the fill queue until we find at least one entry and then
go on processing packets. Works well when the app and the driver are
on different cores, but a lousy strategy when they execute on the same
core. That is why in the need_wakeup feature case, we do not return
the total budget if there is a failure. We will just come back at a
later point in time from a syscall since the need_wakeup flag will
have been set and check the fill queue again. We do not want a
busy-spinning behavior in this case.

Thanks: Magnus
