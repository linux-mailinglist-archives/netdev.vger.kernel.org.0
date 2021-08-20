Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2373F2A2F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 12:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbhHTKiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 06:38:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49904 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbhHTKiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 06:38:17 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by linux.microsoft.com (Postfix) with ESMTPSA id B03AC20C33D3;
        Fri, 20 Aug 2021 03:37:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B03AC20C33D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629455859;
        bh=iZCuOLADbbT0RFS8G7uJNKKtYP+HH+o4bNtsW00FGJ0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mSOgJE8smxwaE9vG5d4E8Fekp43ctCKD8sFTOFnKNfzZyaRConcmUjNjAdnRC0HVk
         N7r64P+EcCSC/wfMMLQ0uaAdl1Nm/DhrAGd2VjpemsBPwzrh+GpNVvVFPXZbJ/T5XP
         N/DTAfvgiP1lBoiFj/7DemMsJDh0eh+Usx/Q7ff8=
Received: by mail-pj1-f51.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so683719pjx.5;
        Fri, 20 Aug 2021 03:37:39 -0700 (PDT)
X-Gm-Message-State: AOAM531stapqmUIVYAdUGRy+NWW6Yx+dMGe9BRNjnn36JwCl/HkO0GHv
        kot4X9MHay0Ri5MvnVkHfzSnfksJlu5XSGZV7oM=
X-Google-Smtp-Source: ABdhPJyzdRc+FIVwfLSPCZCE1K/bGkGNbPCFuO7BPwZm5dc/PmNHPKsmvy994saRreKZsDdKndQkWHmeI8U48eO5tLI=
X-Received: by 2002:a17:903:4095:b029:12d:315e:5f0d with SMTP id
 z21-20020a1709034095b029012d315e5f0dmr15804610plc.19.1629455859101; Fri, 20
 Aug 2021 03:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROmOQ+4Kqukgd6z@orome.fritz.box>
 <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com> <87o8a49idp.wl-maz@kernel.org>
 <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com> <20210812121835.405d2e37@linux.microsoft.com>
 <874kbuapod.wl-maz@kernel.org> <CAFnufp2=1t2+fmxyGJ0Qu3Z+=wRwAX8faaPvrJdFpFeTS3J7Uw@mail.gmail.com>
 <87wnohqty1.wl-maz@kernel.org>
In-Reply-To: <87wnohqty1.wl-maz@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 20 Aug 2021 12:37:03 +0200
X-Gmail-Original-Message-ID: <CAFnufp3xjYqe_iVfbmdjz4-xN2UX_oo3GUw4Z4M_q-R38EN+uQ@mail.gmail.com>
Message-ID: <CAFnufp3xjYqe_iVfbmdjz4-xN2UX_oo3GUw4Z4M_q-R38EN+uQ@mail.gmail.com>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 6:29 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 12 Aug 2021 12:18:48 +0100,
> Matteo Croce <mcroce@linux.microsoft.com> wrote:
> >
> > [1  <text/plain; UTF-8 (7bit)>]
> > On Thu, Aug 12, 2021 at 1:05 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 12 Aug 2021 11:18:35 +0100,
> > > Matteo Croce <mcroce@linux.microsoft.com> wrote:
> > > >
> > > > On Thu, 12 Aug 2021 10:48:03 +0200
> > > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >
> > > > >
> > > > >
> > > > > On 8/11/21 4:16 PM, Marc Zyngier wrote:
> > > > > > On Wed, 11 Aug 2021 13:53:59 +0100,
> > > > > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > > > >
> > > > > >> Are you sure you do not need to adjust stmmac_set_bfsize(),
> > > > > >> stmmac_rx_buf1_len() and stmmac_rx_buf2_len() ?
> > > > > >>
> > > > > >> Presumably DEFAULT_BUFSIZE also want to be increased by NET_SKB_PAD
> > > > > >>
> > > > > >> Patch for stmmac_rx_buf1_len() :
> > > > > >>
> > > > > >> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > > > >> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c index
> > > > > >> 7b8404a21544cf29668e8a14240c3971e6bce0c3..041a74e7efca3436bfe3e17f972dd156173957a9
> > > > > >> 100644 --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c +++
> > > > > >> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c @@ -4508,12
> > > > > >> +4508,12 @@ static unsigned int stmmac_rx_buf1_len(struct
> > > > > >> stmmac_priv *priv, /* First descriptor, not last descriptor and
> > > > > >> not split header */ if (status & rx_not_ls)
> > > > > >> -               return priv->dma_buf_sz;
> > > > > >> +               return priv->dma_buf_sz - NET_SKB_PAD -
> > > > > >> NET_IP_ALIGN;
> > > > > >>         plen = stmmac_get_rx_frame_len(priv, p, coe);
> > > > > >>
> > > > > >>         /* First descriptor and last descriptor and not split
> > > > > >> header */
> > > > > >> -       return min_t(unsigned int, priv->dma_buf_sz, plen);
> > > > > >> +       return min_t(unsigned int, priv->dma_buf_sz - NET_SKB_PAD
> > > > > >> - NET_IP_ALIGN, plen); }
> > > > > >>
> > > > > >>  static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
> > > > > >
> > > > > > Feels like a major deficiency of the original patch. Happy to test a
> > > > > > more complete patch if/when you have one.
> > > > >
> > > > > I wont have time in the immediate future.
> > > > >
> > > > > Matteo, if you do not work on a fix, I suggest we revert
> > > > >  a955318fe67ec0d962760b5ee58e74bffaf649b8 stmmac: align RX buffers
> > > > >
> > > > > before a more polished version can be submitted.
> > > > >
> > > >
> > > > Better to use stmmac_rx_offset() so to have the correct length when
> > > > using XDP. Also, when XDP is enabled, the offset was
> > > > XDP_PACKET_HEADROOM (i.e. 256 bytes) even before the change, so it
> > > > could be already broken. Mark, can you try on the Jetson TX2 by
> > > > attaching an XDP program and see if it works without my change?
> > >
> > > Sorry, you'll have to hold my hand here, as I know exactly nothing
> > > about XDP....
> > >
> >
> > Attach the attached object with:
> >
> > ip link set eth0 xdp object passall.o
> >
> > This is an empty XDP program, its source:
> >
> > __attribute__((section("prog"), used))
> > int xdp_main(struct xdp_md *ctx)
> > {
> >        return XDP_PASS;
> > }
> >
> > Every packet will pass untouched, but the offset will be shifted from
> > 0 to 256 bytes, which could trigger the problem anyway:
>
> Nope. On 5.13, which doesn't have the issue, adding this payload
> doesn't result in any problem and the whole thing is rock solid.
>
> >
> > > > A possible fix, which takes in account also the XDP headroom for
> > > > stmmac_rx_buf1_len() only could be (only compile tested, I don't have
> > > > the hardware now):
> > >
> > > However, this doesn't fix my issue. I still get all sort of
> > > corruption. Probably stmmac_rx_buf2_len() also need adjusting (it has
> > > a similar logic as its buf1 counterpart...)
> > >
> > > Unless you can fix it very quickly, and given that we're towards the
> > > end of the cycle, I'd be more comfortable if we reverted this patch.
> > >
> >
> > Can it be that the HW can't do DMA on an address which is not word aligned?
> > What if you replace NET_SKB_PAD with, let's say, 8?
>
> With this:
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index fcdb1d20389b..244aa6579ef4 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -341,7 +341,7 @@ static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
>         if (stmmac_xdp_is_enabled(priv))
>                 return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
>
> -       return NET_SKB_PAD + NET_IP_ALIGN;
> +       return 8 + NET_IP_ALIGN;
>  }
>
>  void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
>
> I don't see the system corrupting packets anymore. Is that exactly
> what you had in mind? This really seems to point to a basic buffer
> overflow.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Sorry, I meant something like:

-       return NET_SKB_PAD + NET_IP_ALIGN;
+       return 8;

I had some hardware which DMA fails if the receive buffer was not word
aligned, but this seems not the case, as 8 + NET_IP_ALIGN = 10, and
it's not aligned too.

-- 
per aspera ad upstream
