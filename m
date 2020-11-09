Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03D2ABF7F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgKIPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbgKIPLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:11:17 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFE0C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 07:11:17 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id u24so597544vsl.9
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 07:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYiJTfid3c2VSwIcUoPCS8VcFNiHSUWukudJallmnY8=;
        b=uPcl22v0JpabOytW3XEd6mROLzVDC7DraKRBzlw/LY4KHkh3chFxjZ9YfpsieRciM7
         SePQXYCQ1M162mvqMpMYT0PmWsz1BC6ioJJxZlZIeQPYCwW+y2NWzf+1sZFkgHgfs+uB
         8PirgfrgxPFRDT9PGEbnKvQJTVAk2h195yQzlfTi3BJuXyaIF97HvM8lMwivfCWTMI4c
         CaS8htvJE5tBr0cve31QV2CQjHkz+CxrrJ8MnYTxUR4oMoQDFvYI0Xp2EfCruSuPE3sI
         /M+o09/cMUcP2nc9PI9WaU4X52lop0EJwT92LHwTBz5vIorZx7h4lJ5HLwM5O9av8J90
         U7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYiJTfid3c2VSwIcUoPCS8VcFNiHSUWukudJallmnY8=;
        b=ejNy4gDY7Mhc3/xYRPSQifVjKhFIUzEfJoxa2aMqY5k1kiY0tTmMuswhxFL5VJcO3b
         hkZVfUkq3MuItPRLIdulQ35Jy6n6xInjYKJZW2rm+YzRkU5sSydaMFKDdXLgWHP3iVtL
         edgROVs+qq/XT29iem+gh0hHSj8u4mtRUDvb/VOxFlVIXQkaxQs6lCuEfOPRT2RoRnNi
         ptaat1qc4ggyuLOWkoGhBpqEaWmNRoXq+wP+PLpphFsk5WHXXoqWJASpCcbq73DgRBOR
         Ay0LSJYvv6TmzxdMT/9/WzxbuCGIHQC2K2yjTkNT/wi/2czDgLbbrJVA54ZRPa6gl+a5
         LEbQ==
X-Gm-Message-State: AOAM532cnt3XIZJ7V0w0WksCD6VeEbzma8qTOJBBekxT952/hiBsL0JF
        WEk8I7QUIDGr/6YQ+Pld51gvhqEz4Qw=
X-Google-Smtp-Source: ABdhPJyMS0eIf1+QFCoxd3lszXJyFsd7A0kSCNn3JM3mm2UXNfWpBSwKmhgbH2n4mZbtqe1/3BBENw==
X-Received: by 2002:a67:ef49:: with SMTP id k9mr7952481vsr.25.1604934675463;
        Mon, 09 Nov 2020 07:11:15 -0800 (PST)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id f195sm1269201vka.21.2020.11.09.07.11.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 07:11:14 -0800 (PST)
Received: by mail-vs1-f52.google.com with SMTP id r14so5122880vsa.13
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 07:11:14 -0800 (PST)
X-Received: by 2002:a05:6102:240f:: with SMTP id j15mr8473800vsi.22.1604934674019;
 Mon, 09 Nov 2020 07:11:14 -0800 (PST)
MIME-Version: 1.0
References: <20201103104133.GA1573211@tws> <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
 <dc8f00ff-d484-f5cf-97a3-9f6d8984160e@gmail.com> <CA+FuTSeqv=SJ=5sXCrWWiA=nUnLvCgX4wjcoqZm93VSyJQO1jg@mail.gmail.com>
 <66145819-f0aa-794f-4045-1c203b260f47@gmail.com>
In-Reply-To: <66145819-f0aa-794f-4045-1c203b260f47@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 9 Nov 2020 10:10:37 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdSZxiikn2vN_YH=KpmJ2un0PjK7T9qUQwHi6OSfbTMmA@mail.gmail.com>
Message-ID: <CA+FuTSdSZxiikn2vN_YH=KpmJ2un0PjK7T9qUQwHi6OSfbTMmA@mail.gmail.com>
Subject: Re: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 4:05 AM Oliver Herms
<oliver.peter.herms@gmail.com> wrote:
>
>
> On 04.11.20 20:52, Willem de Bruijn wrote:
> >>>> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> >>>
> >>> How did you arrive at this SHA1?
> >> I think the legacy usage of hard_header_len in ipv6/sit.c was overseen in c54419321455.
> >> Please correct me if I'm wrong.
> >
> > I don't see anything in that patch assign or modify hard_header_len.
> >
> It's not assigning or modifying it but changing expectations about how dev->hard_header_len is to be used.
>
> The patch changed the MTU calculation from:
> mtu = dst_mtu(&rt->dst) - dev->hard_header_len - tunnel->hlen;
>
> to this:
> mtu = dst_mtu(&rt->dst) - dev->hard_header_len - sizeof(struct iphdr);
>
> Later is became this (in patch 23a3647. This is the current implementation.):
> mtu = dst_mtu(&rt->dst) - dev->hard_header_len - sizeof(struct iphdr) - tunnel_hlen;
>
> Apparently the initial usage of dev->hard_header_len was that it contains the length
> of all headers before the tunnel payload. c54419321455 changed it to assuming dev->hard_header_len
> does not contain the tunnels outter IP header. Thus I think the bug was introduced by c54419321455.

And the only header in the case of SIT is that outer ip header. Got it, thanks.

Overly conservative MTU calculation is one issue. Packet sockets also
expect read/write link layer access with SOCK_RAW, which does not work
correctly for sit. I'm not sure that it ever did.

The chosen commit predates all stable trees, which is the most important point.

Acked-by: Willem de Bruijn <willemb@google.com>

Could ip6 tunnels have the same issue? In ip6_tnl_dev_init_gen,

        dev->hard_header_len = LL_MAX_HEADER + t_hlen;
