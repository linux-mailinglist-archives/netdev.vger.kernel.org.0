Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2194005F3
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350002AbhICTj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 15:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349849AbhICTj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 15:39:58 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AECC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 12:38:57 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u14so161109ejf.13
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 12:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVgg5l8nV72tzE4xBmoGbb7jSjpXqTztea2lVaWTzj4=;
        b=XZd5NCKuefsXxnlW19GtZHH0x20eoJ0Q+1ETeKlJVaPIW472U9ZPdXDU2z5vMrw1F+
         +MesMMbqWvb9oSDA5wGV/UnB2fKHjJ9dx9Mbv5eFa7b+Vg1MJYr7Mu8HHtAP3AK5/5rK
         s5D6vRSNV2/eQ4pcdQHPvsIhroBF0Kee/bHPwjHAPGUylAboat1Aoe3HAzoyVvHjmm5R
         j4fr8oitJylAmR6S2POUNWK9JVpvTh0LOLWIl5/ORNdm2bZ6qyxlAhr0+SYjHWt0HoVB
         brmM4cpQIgXX77TuCabJZEctFxOf1szE7wc9rfHDiWWXquIFcwhJrR+yy5C3QK8eEOra
         lvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVgg5l8nV72tzE4xBmoGbb7jSjpXqTztea2lVaWTzj4=;
        b=D3tk9zn8WO7lQZtZwyePc/ZLj8i/hV0fz+nhMPkYB+TjI1Udz5JVAooZ2E4bz2cfnV
         RWDNR0pk1YX+skxzM13o4Zrxa9WG8MdkRZ+Zl2/hXDfs0quGF6coAeXYFzTYUl1yE2dR
         eIJcZI0l0WXnCHbEXxGQN5aI1b1K7S9r/QwsKzcMNClS11hyF5h7uaqqDLaug7RY48j8
         k9Osuj04BeDdOnxdA1oWQoJ+weWmzQaLyxJlDTTpzz3tclBpf1tr8xdIvxZ9+Avsss34
         cPBNGO81g5snaI0M9KReFSwbJifigYqsaHQuHHr5npvwdsBimLKXXc8I0YPG4jv/oF8U
         TKMQ==
X-Gm-Message-State: AOAM533XZDjJ7oHss+PEsVSrBCr2QStBCfYeAvmPxYFum3VYOSgzCntK
        V5SapU8hI3ut3l1pj3fwha908Ha71JFV9A==
X-Google-Smtp-Source: ABdhPJz0yahheDxZeichdaDB/WUsx3XHyG4mFCv+S/MQXd6Evh4XAlF6gkeELls+/9ugSO3wo8Iz9Q==
X-Received: by 2002:a17:906:b84a:: with SMTP id ga10mr490792ejb.143.1630697936255;
        Fri, 03 Sep 2021 12:38:56 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id d3sm52749ejw.18.2021.09.03.12.38.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 12:38:55 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so231504wml.3
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 12:38:54 -0700 (PDT)
X-Received: by 2002:a1c:210a:: with SMTP id h10mr362069wmh.117.1630697934322;
 Fri, 03 Sep 2021 12:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com> <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
In-Reply-To: <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 3 Sep 2021 15:38:17 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
Message-ID: <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > The issue is drivers with NETIF_F_HW_CSUM would be expecting a
> > > reasonable csum_start and csum_offset. If the hardware is only
> > > advertising that and we are expecting it to offload the checksum we
> > > should probably be doing some sort of validation on user derived
> > > inputs to make sure that they aren't totally ridiculous as is the case
> > > here where the original issue was that the csum_start wasn't even in
> > > the packet data.
> > >
> > > Would it maybe make sense to look at reverting the earlier fixes and
> > > instead updating skb_partial_csum_set so that we cannot write a
> > > csum_start value that is less than the start of skb->data? That way we
> > > are addressing this at the source instead of allowing the garbage data
> > > to propagate further down the stack and having to drop it at the
> > > driver level which is going to have us playing whack a mole trying to
> > > fix it where it pops up. It seems like we are already validating the
> > > upper bounds for these values in that function so why not validate the
> > > lower bounds as well?
> >
> > skb_partial_csum_set verifies that csum_start is within bounds
> > at the time it is called. The offset passed from userspace is
> > an unsigned int added to skb_headroom(skb), so >= skb->data.
> >
> > The issue is with ipgre_xmit calling skb_pull. Only then does it
> > become out of bounds. From what I saw, pulling headers like
> > that is very rare in the transmit path. Indeed, I did not see it in
> > any other tunnels. We could instrument each of these directly,
> > but at non-trivial cost.
>
> So there are some positives and negatives to addressing this in
> ipgre_xmit. Specifically if we address it before the pull we could do
> some other quick checks to verify the offset. If the offset and start
> are both in the region to be pulled we could just drop the offload,

These cases would currently crash the kernel. They are so clearly bad
input that I would not even try to start accommodating them. Drop
them.

> whereas if the offset is stored somewhere in the unstripped data we
> could then drop the packet and count it as a drop without having to
> modify the frame via the skb_pull.

This is a broader issue that userspace can pass any csum_start as long
as it is within packet bounds. We could address it here specifically
for the GRE header. But that still leaves many potentially bad offsets
further in the packet in this case, and all the other cases. Checking
that specific header seems a bit arbitrary to me, and might actually
give false confidence.

We could certainly move the validation from gre_handle_offloads to
before skb_pull, to make it more obvious *why* the check exists.

> > The negative underflow and kernel crash is very specific to
> > lco_csum, which calculates the offset between csum_offset
> > and transport_offset. Standard checksum offset doesn't.
> >
> > One alternative fix, then, would be to add a negative overflow
> > check in lco_csum itself.
> > That only has three callers and unfortunately by the time we hit
> > that for GRE in gre_build_header, there no longer is a path to
> > cleanly dropping the packet and returning an error.
>
> Right. We could find the problem there but it doesn't solve the issue.
> The problem is the expectation that the offset exists in the area
> after the checksum for the tunnel header, not before.
>
> > I don't find this bad input whack-a-mole elegant either. But I
> > thought it was the least bad option..
>
> The part that has been confusing me is how the virtio_net_hdr could
> have been pointing as the IP or GRE headers since they shouldn't have
> been present on the frame provided by the userspace. I think I am
> starting to see now.
>
> So in the case of af_packet it looks like it is calling
> dev_hard_header which calls header_ops->create before doing the
> virtio_net_hdr_to_skb call. Do I have that right?

Mostly yes. That is the case for SOCK_DGRAM. For SOCK_RAW, the caller
is expected to have prepared these headers.

Note that for the ip_gre device to have header_ops, this will be
ipgre_header_ops, which .create member function comment starts with
"/* Nice toy. Unfortunately, useless in real life :-)". We recently
had a small series of fixes related to this special case and packet
sockets, such as commit fdafed459998 ("ip_gre: set
dev->hard_header_len and dev->needed_headroom properly"). This case of
a GRE device that receives packets with outer IP + GRE headers is out
of the ordinary.

> Maybe for those
> cases we need to look at adding an unsigned int argument to
> virtio_net_hdr_to_skb in which we could pass 0 for the unused case or
> dev->hard_header_len in the cases where we have something like
> af_packet that is transmitting over an ipgre tunnel. The general idea
> is to prevent these virtio_net_hdr_to_skb calls from pointing the
> csum_start into headers that userspace was not responsible for
> populating.

One issue with that is that dev->hard_header_len itself is imprecise
for protocols with variable length link layer headers. There, too, we
have had a variety of bug fixes in the past.

It also adds cost to every user of virtio_net_hdr, while we only know
one issue in a rare case of the IP_GRE device.
