Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD292B6ED0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgKQThH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgKQThG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:37:06 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441A5C0613CF;
        Tue, 17 Nov 2020 11:37:06 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 35so6645187ple.12;
        Tue, 17 Nov 2020 11:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EsKMgiMbqjjn8lhbzXsxLvTtdHlwwQ9uUywE8ZAoO/0=;
        b=aZAJTEam+/Ie5FUpB3/MFwaTB/er0HmqsZCVMOdfbiOZoErxM8Qe0JrtzAgeuptL7q
         C7DKw5ghrp4tIcsPhEUAbb3wmiXN61Du/WiL3QWW1qqEHwSK1Y0rx+Fk1wNChnpcRimY
         S67blHW8RJl+PiWLplgo3nlwIt86GW/Y86BPqjsRFijHeD8yloVOneW97bTWTJv3/xHA
         rFK7NhOq56APaSeEu4tXJ5Y+mkhamnQKORj1oY+tzvS8XIlTiH47wubyhwrYgIv4jBoq
         tgDOxMXCRWna8zfw5OY2wh5bu7lUv8deb4k4kte+tI2Dpb3vzqx3vyKenVrHTaw2RYOP
         pTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EsKMgiMbqjjn8lhbzXsxLvTtdHlwwQ9uUywE8ZAoO/0=;
        b=tjsIYo18+fw24C9GfilrY7l2OxcZAPH7B00fhO6qTdEi5dvl1Q1zswIJE6dDYyKy8g
         nNwDBtFpt75zgJ7vR61ICHnYTkh9YPfQ48JaGGFxXti+Bp/Q3fqHUn8ehAuVvxbCk1tt
         pB/l8ataxt4N/tHbV99X4DUFDH7K3FGFohPUHt2srhSY2KVTnc8lveZhHbaXmov744Pk
         P92Rw41Is2gp87/5xsOWdoGFI/2F8X4Izt6USQymRTpJX49pnJBJmPMXPanib/jGwp0l
         3UlUfgYoUQwNZlQ0GEAXCCC++o6aZ+/SfQQdvA2tPUGyjqQfL8WQWoIKeJ7u632ZBtXc
         fVQQ==
X-Gm-Message-State: AOAM530hSbTV/2VK7OneJngVLmWC4Yp0VeHb5H/BG6BVnsydLCCTd4M6
        lPXdq6/JQxq7ARfG7A1XtmQJ6BsAu356T/msaDQ=
X-Google-Smtp-Source: ABdhPJzL5bpygHMA2bce86IQP8EK3HBvnwXKbDhBG4F20h5EhGntaUWRXAPv6WC3K5iQWujj3b0oEGwsV6VGml4c92s=
X-Received: by 2002:a17:90b:208:: with SMTP id fy8mr606225pjb.204.1605641825763;
 Tue, 17 Nov 2020 11:37:05 -0800 (PST)
MIME-Version: 1.0
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
 <1605525167-14450-5-git-send-email-magnus.karlsson@gmail.com> <5fb41f6ae195_310220813@john-XPS-13-9370.notmuch>
In-Reply-To: <5fb41f6ae195_310220813@john-XPS-13-9370.notmuch>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 17 Nov 2020 20:36:54 +0100
Message-ID: <CAJ8uoz3kKqxReJxsT_asecnF==QwRfbVZ81mEoMDgyxSFHO8Kg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/5] xsk: introduce batched Tx descriptor interfaces
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anthony.l.nguyen@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 8:07 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Introduce batched descriptor interfaces in the xsk core code for the
> > Tx path to be used in the driver to write a code path with higher
> > performance. This interface will be used by the i40e driver in the
> > next patch. Though other drivers would likely benefit from this new
> > interface too.
> >
> > Note that batching is only implemented for the common case when
> > there is only one socket bound to the same device and queue id. When
> > this is not the case, we fall back to the old non-batched version of
> > the function.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  include/net/xdp_sock_drv.h |  7 ++++
> >  net/xdp/xsk.c              | 57 +++++++++++++++++++++++++++++
> >  net/xdp/xsk_queue.h        | 89 +++++++++++++++++++++++++++++++++++++++-------
> >  3 files changed, 140 insertions(+), 13 deletions(-)
> >
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
> > +
> > +u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *descs,
> > +                                u32 max_entries)
> > +{
> > +     struct xdp_sock *xs;
> > +     u32 nb_pkts;
> > +
> > +     rcu_read_lock();
> > +     if (!list_is_singular(&pool->xsk_tx_list)) {
> > +             /* Fallback to the non-batched version */
>
> I'm going to ask even though I believe its correct.
>
> If we fallback here and then an entry is added to the list while we are
> in the fallback logic everything should still be OK, correct?

Yes, the fallback function can handle all cases.

> > +             rcu_read_unlock();
> > +             return xsk_tx_peek_release_fallback(pool, descs, max_entries);
> > +     }
> > +
> > +     xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
> > +     if (!xs) {
> > +             nb_pkts = 0;
> > +             goto out;
> > +     }
> > +
> > +     nb_pkts = xskq_cons_peek_desc_batch(xs->tx, descs, pool, max_entries);
> > +     if (!nb_pkts) {
> > +             xs->tx->queue_empty_descs++;
> > +             goto out;
> > +     }
> > +
> > +     /* This is the backpressure mechanism for the Tx path. Try to
> > +      * reserve space in the completion queue for all packets, but
> > +      * if there are fewer slots available, just process that many
> > +      * packets. This avoids having to implement any buffering in
> > +      * the Tx path.
> > +      */
> > +     nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, descs, nb_pkts);
> > +     if (!nb_pkts)
> > +             goto out;
> > +
> > +     xskq_cons_release_n(xs->tx, nb_pkts);
> > +     __xskq_cons_release(xs->tx);
> > +     xs->sk.sk_write_space(&xs->sk);
> > +
> > +out:
> > +     rcu_read_unlock();
> > +     return nb_pkts;
> > +}
> > +EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
> > +
