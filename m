Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601F330C8EC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbhBBSDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbhBBSBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:01:43 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02794C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 10:01:04 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id y4so1735919ybk.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 10:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v4jAtr3w+KdVnMekpGEVkBsIg1dKPD9qhThdBp+S/l0=;
        b=FQ7IY4mh+nYpIKM0TbDjFg2JoaOKUnc9PM1kdDo+KL1Cs1mIV97aJhZQ+lnE7/cS35
         6zg+ndi7ZMkt+wtmb6Q3SX8MNhU4CWO/ywhyPnKbD9h/BZn1tiCdQfUXTCASSLEFCUuO
         eO64hfgBrtT2RmtPq+Z8sIgIUez/+rDZ+9QDAmZt17TXIYmA+jNOvqg/vyhB8lo1LNjm
         02fi44eXdzBKISazTQ5JtcuehQzraBZm6DmB2VZNTKlmFFMpSVO7x8OzRiU+Qwj2T0XP
         e/B+CSjLRLcCjeWjUm7ekPX7oBLQU/rYOR4Uo9/qdx1ZOShEw8v5t7sctdwUMgWKih0e
         l65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v4jAtr3w+KdVnMekpGEVkBsIg1dKPD9qhThdBp+S/l0=;
        b=HWuyfRw9kymLStQ+faK+W13E0Z7EU1FHGapwSWs3F7J6/EBBneJZf6ZcswF+kxrlxM
         od33XgysYwQcQhgITztAPTtiEPLMMsTaNUZcj7p9U706E1oowEQndO8Jq1yr/cH/BLFQ
         GkMhqLwBc1NmiSiWWxxD6YJrFLiR2bFeZzBYpCiurN3erb7dfG/hAGaL6/SCPmIvUrJJ
         mVe92lsNREb1uoq9N/SmFNO4ePseJl/fQ8HydzPCUf42z6zyntPJBNwSPUvEQ1nLvJNd
         ssD4Qh/TiPi9mvZlvmPdibe6X0iYJ5u9GKJjqmHecbDBbpOXLgmc6/IkeDAkY44qXnUg
         EdPA==
X-Gm-Message-State: AOAM532pQWeuCp9r81TCqUAuCwhoYz54kXOm/SP6ZAxaoManX6TSS567
        NTXm/9RN8JXz83kgwQuVJwRtQ1qrDzqyUX4gaYQ=
X-Google-Smtp-Source: ABdhPJwkbvEbSU5cXXHfCmdD7X9SOuvrzPZ7/hIWOP+T0GImF/6eC+Xwn+3saCPR12kXniMMzTsP+EZj+GdVvLN5Gvk=
X-Received: by 2002:a25:ba13:: with SMTP id t19mr34846787ybg.129.1612288863285;
 Tue, 02 Feb 2021 10:01:03 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-2-borisp@mellanox.com>
 <20210201173548.GA12960@lst.de>
In-Reply-To: <20210201173548.GA12960@lst.de>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 2 Feb 2021 20:00:51 +0200
Message-ID: <CAJ3xEMjLKoQe_OB_L+w2wwUGck74Gm6=GPA=CK73QpeFbXr7Bw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/21] iov_iter: Introduce new procedures for
 copy to iter/pages
To:     Christoph Hellwig <hch@lst.de>
Cc:     Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        Sagi Grimberg <sagi@grimberg.me>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        axboe@fb.com, Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 7:38 PM Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Feb 01, 2021 at 12:04:49PM +0200, Boris Pismenny wrote:
> > +static __always_inline __must_check
> > +size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
> > +{
> > +     if (unlikely(!check_copy_size(addr, bytes, true)))
> > +             return 0;
> > +     else
> > +             return _ddp_copy_to_iter(addr, bytes, i);
> > +}
>
> No need for the else after a return, and the normal kernel convention
> double underscores for magic internal functions.

ack for the no-else-after-a-return

Re the double underscoring, I was not sure, e.g the non-ddp counterpart
(_copy_to_iter) is single underscored

> But more importantly: does this belong into the generic header without
> and comments what the ddp means and when it should be used?

will look into this, any idea for a more suitable location?

> > +static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
>
> Overly long line.  But we're also looking into generic helpers for
> this kind of things, not sure if they made it to linux-next in the
> meantime, but please check.

This is what I found in linux-next - note sure if you were referring to it

commit 11432a3cc061c39475295be533c3674c4f8a6d0b
Author: David Howells <dhowells@redhat.com>

    iov_iter: Add ITER_XARRAY

> > +size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
> > +{
> > +     const char *from = addr;
> > +     if (unlikely(iov_iter_is_pipe(i)))
> > +             return copy_pipe_to_iter(addr, bytes, i);
> > +     if (iter_is_iovec(i))
> > +             might_fault();
> > +     iterate_and_advance(i, bytes, v,
> > +             copyout(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
> > +             ddp_memcpy_to_page(v.bv_page, v.bv_offset,
> > +                                (from += v.bv_len) - v.bv_len, v.bv_len),
> > +             memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
> > +             )
> > +
> > +     return bytes;
> > +}
>
> This bloats every kernel build, so please move it into a conditionally built file.

ack

>  And please document the whole thing.

ok
