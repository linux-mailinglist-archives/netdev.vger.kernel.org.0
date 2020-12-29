Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEECD2E72EB
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 19:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL2SLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 13:11:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgL2SLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 13:11:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609265394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ueyI+cWoH67BxlB2tzBM71S76RsMBcue4/o5aXgZcWA=;
        b=dI5oXYPUYKTnEFwqzA6wpWmJqCnlRq0Lzvy/hBdLC0dOFOYu68Jj3YIldiGSUOlZ2xa7cS
        mUtolVOW3GCI4s0xPFAdowWP2OSt/CB7rdlU6HykT/iLDvX5bBKm8y/ilu8P1LlrOqCABd
        uSNyAA/IEP+IbBOdn9FFNi4dVgCAYHU=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-qSaGl2iZOr6yOKow9KfxWw-1; Tue, 29 Dec 2020 13:09:52 -0500
X-MC-Unique: qSaGl2iZOr6yOKow9KfxWw-1
Received: by mail-yb1-f199.google.com with SMTP id g17so24920469ybh.5
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 10:09:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueyI+cWoH67BxlB2tzBM71S76RsMBcue4/o5aXgZcWA=;
        b=G+Pt29IYMXhZAP3F5OLOZgPLOOCeYYOz3Sd/TBbYS3+qCwsxOeMM5QUfsPSO2kXRS6
         eVH7gsDBX9rLs5F1qhjQw07KwBBujk0/5Rq2YZXqN01Qu4iktYp6iBwMCc9Bheef2H9F
         Ao6slLMlbcYglqxZnl9P1qiXzn16eOKEwlAVpqyGzla2Q7XqwWu/SaLF7+bUn2v+HmV8
         tI/lQIU7KujLzNa7LlRiiGw6whRyKNgWEOlIuqQ2Tpj3okrnRpdz1Cw0jXLZ1pxx+sFJ
         7bRLHV4syQwNYVcOKIyKEeh6WWYNJXFwwx5IS5F/6dqXIMI+xPzaChUuqprXSk00zbJj
         TnzA==
X-Gm-Message-State: AOAM530djVFNfqV7kLbH4upb/W2OW/+56cxMA3HfXl5LiqxYjgOj0DHY
        dB2T41HD4xEyCuGD/nUhuMFe2qxImnQfgTokhe+66c4L/Lm0ZQoTXRnCtgNOGNdNCgDKm1pezL7
        cHZ8PCejsmcTJErqU50Q8f07+A6S5h7NP
X-Received: by 2002:a25:260f:: with SMTP id m15mr74957603ybm.43.1609265392259;
        Tue, 29 Dec 2020 10:09:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLUkb+cXPdJE5ZQ0eZ0Wfwhu0qSSc+HcpLS8Wk6aqHyigAzVKwNORGm77nlJWES0hP9a30j3xIOPCXzIeSLoA=
X-Received: by 2002:a25:260f:: with SMTP id m15mr74957576ybm.43.1609265392025;
 Tue, 29 Dec 2020 10:09:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608670965.git.lorenzo@kernel.org> <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
 <63bcde67-4124-121d-e96a-066493542ca9@iogearbox.net>
In-Reply-To: <63bcde67-4124-121d-e96a-066493542ca9@iogearbox.net>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Tue, 29 Dec 2020 19:09:41 +0100
Message-ID: <CAJ0CqmVsr=cv+0ndg3g4RDqVmKt=X6qQ7sbArNVrB+98e_3Sag@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +                     hard_start = page_address(rx_buffer->page) +
> > +                                  rx_buffer->page_offset - offset;
> > +                     xdp_prepare_buff(&xdp, hard_start, offset, size, true);
> >   #if (PAGE_SIZE > 4096)
> >                       /* At larger PAGE_SIZE, frame_sz depend on len size */
> >                       xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, size);

Hi Daniel,

thx for the review.

> [...]
> The design is very similar for most of the Intel drivers. Why the inconsistency on
> ice driver compared to the rest, what's the rationale there to do it in one but not
> the others? Generated code better there?

I applied the same logic for the ice driver but the code is just
slightly different.

>
> Couldn't you even move the 'unsigned int offset = xyz_rx_offset(rx_ring)' out of the
> while loop altogether for all of them? (You already use the xyz_rx_offset() implicitly
> for most of them when setting xdp.frame_sz.)
>

We discussed moving "offset = xyz_rx_offset(rx_ring)" out of the while
loop before but Saeed asked to address it in a dedicated series since
it is a little bit out of the scope. I have no strong opinion on it,
do you prefer to address it directly here?

Regards,
Lorenzo

> Thanks,
> Daniel
>

