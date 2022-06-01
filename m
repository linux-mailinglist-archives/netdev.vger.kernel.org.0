Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8CB53A987
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiFAPEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 11:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiFAPEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 11:04:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B933ED3A;
        Wed,  1 Jun 2022 08:04:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f21so4338283ejh.11;
        Wed, 01 Jun 2022 08:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vUeielUxwdqidWMyUmw+vl1VOUA69C9db3W/HKcLxII=;
        b=QLzwaCktchB6dQB8ixSjWDYooq4Cwu4lo2Ynlz2YG0A/01Vrw9hFG0mp/sV60eXFx2
         E6l5oYW1CHlruCfXbKpLZUcJgYXjyzwjJFXVvjrHLXZ/U6XcGtJJKw9NbDqGTbFqrgkL
         3uzzlAh+yXoeXDpAZwUnQUV6P2oswmm5s8+D48EQzhjHevzG08nQ/CFT5lSLXVJmr+oC
         1pU2b5h7V34fI9nJM+Ex7JSGNhPcVdH8r/8ZURpjOqbOK05UjX2mpUXRFholPqe8R5ex
         hB2v98VrQ7zWcoRZaFSTQ0XpNS5xOFAJwjQoama+B61T5tHIw5nTCCssWlzLjPqpCCtI
         J/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vUeielUxwdqidWMyUmw+vl1VOUA69C9db3W/HKcLxII=;
        b=RXkeNZllNlmfXiL90+s8I9enKuJr3UDehKogvjR9DyKTv7QObB2X+XRJTfBH+eo26q
         y7CQqhC5kiB/U6hP7+wwlLAFtk6gHaXJa/1e0D10vHp/KV5JLH30QyIT9Bkhai01d4sq
         8gLT+qpldZaXvpfl/VThYjRhHADNl/eNC+A05P3weY1+A86nwUVp1xATfwOQyRZuanrB
         xnHqiZR21mQG87orTJuLWOKXox5mF7LtBU2PxcFLxDtWnK6cDbpoILabK7Uf90gVCYsQ
         SzEZgH5t7GYA8kT/GKD8WLXuzWXn7/0DlONCYCRwoF1qQsHXUkAF+o1h4+w2rq/SFyGQ
         ySTw==
X-Gm-Message-State: AOAM532cHvpokb8s+0whkxWCrfAn1+j3NWlbWPfM9C0aWak/N4VbbQXo
        T6y4oDPENhRy1HV2cemjVo3nOj8Rmgjz1cih+lw=
X-Google-Smtp-Source: ABdhPJyeAXR2TVzyrcTWpKLgVUPF0TRmXl0lbPdygeZ4MBGT+a+e5Ru8EvCgLYTsVnom613+/RkqqmzVpltChA3HBP0=
X-Received: by 2002:a17:907:8a25:b0:6fe:ff5b:81f8 with SMTP id
 sc37-20020a1709078a2500b006feff5b81f8mr329219ejc.184.1654095869835; Wed, 01
 Jun 2022 08:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220531081412.22db88cc@kernel.org> <1654011382-2453-1-git-send-email-chen45464546@163.com>
 <20220531084704.480133fa@kernel.org> <CAKgT0UfQsbAzsJ1e__irHY2xBRevpB9m=FBYDis3C1fMua+Zag@mail.gmail.com>
 <3498989.c69f.1811f41186e.Coremail.chen45464546@163.com>
In-Reply-To: <3498989.c69f.1811f41186e.Coremail.chen45464546@163.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 1 Jun 2022 08:04:17 -0700
Message-ID: <CAKgT0UdoGJ_dG9vZ3aqQhTagCGf_J3H9A8yJbO5mWCgrt6vd4Q@mail.gmail.com>
Subject: Re: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
To:     =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 5:33 AM =E6=84=9A=E6=A0=91 <chen45464546@163.com> wr=
ote:
>
> At 2022-06-01 01:28:59, "Alexander Duyck" <alexander.duyck@gmail.com> wro=
te:
> >On Tue, May 31, 2022 at 8:47 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Tue, 31 May 2022 23:36:22 +0800 Chen Lin wrote:
> >> > At 2022-05-31 22:14:12, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >> > >On Tue, 31 May 2022 22:41:12 +0800 Chen Lin wrote:
> >> > >> The sample code above cannot completely solve the current problem=
.
> >> > >> For example, when fragsz is greater than PAGE_FRAG_CACHE_MAX_SIZE=
(32768),
> >> > >> __page_frag_cache_refill will return a memory of only 32768 bytes=
, so
> >> > >> should we continue to expand the PAGE_FRAG_CACHE_MAX_SIZE? Maybe =
more
> >> > >> work needs to be done
> >> > >
> >> > >Right, but I can think of two drivers off the top of my head which =
will
> >> > >allocate <=3D32k frags but none which will allocate more.
> >> >
> >> > In fact, it is rare to apply for more than one page, so is it necess=
ary to
> >> > change it to support?
> >>
> >> I don't really care if it's supported TBH, but I dislike adding
> >> a branch to the fast path just to catch one or two esoteric bad
> >> callers.
> >>
> >> Maybe you can wrap the check with some debug CONFIG_ so it won't
> >> run on production builds?
> >
> >Also the example used here to define what is triggering the behavior
> >is seriously flawed. The code itself is meant to allow for order0 page
> >reuse, and the 32K page was just an optimization. So the assumption
> >that you could request more than 4k is a bad assumption in the driver
> >that is making this call.
> >
> >So I am in agreement with Kuba. We shouldn't be needing to add code in
> >the fast path to tell users not to shoot themselves in the foot.
> >
> >We already have code in place in __netdev_alloc_skb that is calling
> >the slab allocator if "len > SKB_WITH_OVERHEAD(PAGE_SIZE)". We could
> >probably just add a DEBUG wrapped BUG_ON to capture those cases where
> >a driver is making that mistake with __netdev_alloc_frag_align.
>
> Thanks for the clear explanation.
> The reality is that it is not easy to capture the drivers that make such =
mistake.
> Because memory corruption usually leads to errors on other unrelated modu=
les.
> Not long ago, we have spent a lot of time and effort to locate a issue th=
at
> occasionally occurs in different kernel modules, and finally find the roo=
t cause is
> the improper use of this netdev_alloc_frag interface in DPAA net driver f=
rom NXP.
> It's a miserable process.
>
> I also found that some net drivers in the latest Linux version have this =
issue.
> Like:
> 1. netdev_alloc_frag "len" may larger than PAGE_SIZE
> #elif (PAGE_SIZE >=3D E1000_RXBUFFER_4096)
>                 adapter->rx_buffer_len =3D PAGE_SIZE;
> #endif
>
> static unsigned int e1000_frag_len(const struct e1000_adapter *a)
> {
>         return SKB_DATA_ALIGN(a->rx_buffer_len + E1000_HEADROOM) +
>                 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> }
>
> static void *e1000_alloc_frag(const struct e1000_adapter *a)
> {
>         unsigned int len =3D e1000_frag_len(a);
>         u8 *data =3D netdev_alloc_frag(len);
> }
> "./drivers/net/ethernet/intel/e1000/e1000_main.c" 5316  --38%--

So there isn't actually a bug in this code. Specifically the code is
split up between two paths. The first code block comes from the jumbo
frames path which creates a fraglist skb and will memcpy the header
out if I recall correctly. The code from the other two functions is
from the non-jumbo frames path which has restricted the length to
MAXIMUM_ETHERNET_VLAN_SIZE.

> 2. netdev_alloc_frag "ring->frag_size" may larger than (4096 * 3)
>
> #define MTK_MAX_LRO_RX_LENGTH           (4096 * 3)
>         if (rx_flag =3D=3D MTK_RX_FLAGS_HWLRO) {
>                 rx_data_len =3D MTK_MAX_LRO_RX_LENGTH;
>                 rx_dma_size =3D MTK_HW_LRO_DMA_SIZE;
>         } else {
>                 rx_data_len =3D ETH_DATA_LEN;
>                 rx_dma_size =3D MTK_DMA_SIZE;
>         }
>
>         ring->frag_size =3D mtk_max_frag_size(rx_data_len);
>
>         for (i =3D 0; i < rx_dma_size; i++) {
>                 ring->data[i] =3D netdev_alloc_frag(ring->frag_size);
>                 if (!ring->data[i])
>                         return -ENOMEM;
>         }
> "drivers/net/ethernet/mediatek/mtk_eth_soc.c" 3344  --50%--
>
> I will try to fix these drivers later.

This one I don't know as much about, and it does appear to contain a
bug. What it should be doing is a check before doing the
netdev_alloc_frag call to verify if it is less than 4K then it uses
netdev_alloc_frag, if it is greater then it needs to use alloc_pages.

> Even experienced driver engineers may use this netdev_alloc_frag
> interface incorrectly.
> So I thought it is best to provide some prompt information of usage
> error inside the netdev_alloc_frag, or it's OK to report such mistake
> during system running which may caused by fragsz varies(exceeded page siz=
e).
>
> Now, as you and Kuba mentioned earlier, "do not add code in fast path".
>
> Can we just add code to the relatively slow path to capture the mistake
> before it lead to memory corruption?
> Like:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e6f211d..ac60a97 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5580,6 +5580,7 @@ void *page_frag_alloc_align(struct page_frag_cache =
*nc,
>                 /* reset page count bias and offset to start of new frag =
*/
>                 nc->pagecnt_bias =3D PAGE_FRAG_CACHE_MAX_SIZE + 1;
>                 offset =3D size - fragsz;
> +               BUG_ON(offset < 0);
>         }
>
>         nc->pagecnt_bias--;
>


I think I could be onboard with a patch like this. The test shouldn't
add more than 1 instruction since it is essentially just a jump if
signed test which will be performed after the size - fragsz check.

> Additional, we may modify document to clearly indicate the limits of the
> input parameter fragsz.
> Like:
> diff --git a/Documentation/vm/page_frags.rst b/Documentation/vm/page_frag=
s.rst
> index 7d6f938..61b2805 100644
> --- a/Documentation/vm/page_frags.rst
> +++ b/Documentation/vm/page_frags.rst
> @@ -4,7 +4,7 @@
>  Page fragments
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> -A page fragment is an arbitrary-length arbitrary-offset area of memory
> +A page fragment is an arbitrary-length(must <=3D PAGE_SIZE) arbitrary-of=
fset area of memory
>  which resides within a 0 or higher order compound page.

The main thing I would call out about the page fragment is that it
should be less than an order 0 page in size, ideally at least half a
page to allow for reuse even in the case of order 0 pages. Otherwise
it is really an abuse of the interface as it isn't really meant to be
allocating 1 fragment per page since the efficiency will drop pretty
significantly as memory becomes fragmented and it becomes harder to
allocate higher order pages. It would essentially just become
alloc_page with more overhead.
