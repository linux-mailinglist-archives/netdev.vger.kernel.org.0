Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F34D2DA25A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503609AbgLNVJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503400AbgLNVIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:08:41 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A720BC0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:07:58 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id r24so9762350vsg.10
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrnBXLh85eCcaKcmKlrdbfBci6LTJfWBSygszlifr90=;
        b=qq1DNX6ZjCZTaipmDfeUvqB37/bB8dOFulwga0/dr8Lnn2X/ntBL4qb+N0BvpdFvPt
         soA60ZQERyDlTd0f5609S0LIRU5B4XvjOXmrdYf3idJVfUIdpaa5hIuzpC16tQRklYV/
         1rBWykg0mGtA+GH0lkRz2Ewxeg4FRVYmzg3HOM8+k3BNTArIjOWd4PMapV1YEXQ5pB+E
         2YH3G+i79KZYyF7l1ifhGS1w+oOqOuuQDIQ4mQPHt/clluQ1gJ+FiFtU8rzph9mwyYKz
         L9gJaMN+6jeGjSnVcDg01IzRAwLj93WUTtt52HYAqs9xHHBMaT7cAknH7kydj8x3/Xyc
         OMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrnBXLh85eCcaKcmKlrdbfBci6LTJfWBSygszlifr90=;
        b=qbimrWVYPRbzSRhfz6jRqmaAVZzsFaRlpD79r5TMseD/xKmCSJa6jrBMaEYsg6/kos
         vTCs9Ouoqzxt7WwcwKyY03zPCK2JoiuRPNdciSyv9pNqtjIF05O7vtNXXmWaOQqFdS/s
         MZWxfhZpNYUDJt4ZHts9t8SwjD/cadKAVrbv97/I3bppk2o9TM/EB5YT9SBLNQe8ng5y
         QtnL9hb9Ppfhtqp/pEmNIesuC3Fxz/IMDhofr+Q0M6zb2OpnOdxhQjH8HRDlU2W33WfU
         LH7NqF5245ofT9zLW6Nliy00D2DvcFnCisXhHitt6hieJEeYBvc0VXeK7WPZuX+3pyxW
         g+hw==
X-Gm-Message-State: AOAM532FvLWPNtsi1XeHrERu1L4m6WPshdvhqLtxqPmCQ7i8aifwes44
        IGfoXm1cqiim3LhFYjDlsxdDez4e2ps=
X-Google-Smtp-Source: ABdhPJywfre6s1iqSc0H1MVFETZnuqCu8eiW7YZ+m40+OAya+6atd//a2JSpuE5FJ09NdyP9zAWv/w==
X-Received: by 2002:a67:6304:: with SMTP id x4mr4353860vsb.23.1607980077438;
        Mon, 14 Dec 2020 13:07:57 -0800 (PST)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id o192sm2477135vko.19.2020.12.14.13.07.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 13:07:56 -0800 (PST)
Received: by mail-vs1-f46.google.com with SMTP id z16so9775071vsp.5
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:07:56 -0800 (PST)
X-Received: by 2002:a05:6102:1173:: with SMTP id k19mr25216754vsg.51.1607980075808;
 Mon, 14 Dec 2020 13:07:55 -0800 (PST)
MIME-Version: 1.0
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
 <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com> <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
 <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
 <98675d3c-62fb-e175-60d6-c1c9964af295@virtuozzo.com> <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
 <20201214125430.244c9359@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214125430.244c9359@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 14 Dec 2020 16:07:19 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdHAEL1yoMoFJqDuh7ivXUp17EmXeYY-KFxobY9Hmfb4Q@mail.gmail.com>
Message-ID: <CA+FuTSdHAEL1yoMoFJqDuh7ivXUp17EmXeYY-KFxobY9Hmfb4Q@mail.gmail.com>
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 3:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 13 Dec 2020 20:59:54 -0500 Willem de Bruijn wrote:
> > On Sun, Dec 13, 2020 at 2:37 PM Vasily Averin <vvs@virtuozzo.com> wrote:
> > > >> On 12/11/20 6:37 PM, Vasily Averin wrote:
> > > >>> It seems for me the similar problem can happen in __skb_trim_rcsum().
> > > >>> Also I doubt that that skb_checksum_start_offset(skb) checks in
> > > >>> __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
> > > >>> becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
> > > >>> Could somebody confirm it?
> > > >>
> > > >> I've rechecked the code and I think now that other places are not affected,
> > > >> i.e. skb_push_rcsum() only should be patched.
> > > >
> > > > Thanks for investigating this. So tun was able to insert a packet with
> > > > csum_start + csum_off + 2 beyond the packet after trimming, using
> > > > virtio_net_hdr.csum_...
> > > >
> > > > Any packet with an offset beyond the end of the packet is bogus
> > > > really. No need to try to accept it by downgrading to CHECKSUM_NONE.
> > >
> > > Do you mean it's better to force pskb_trim_rcsum() to return -EINVAL instead?
> >
> > I would prefer to have more strict input validation in
> > tun/virtio/packet (virtio_net_hdr_to_skb), rather than new checks in
> > the hot path. But that is a larger change and not feasible
> > unconditionally due to performance impact and likely some false
> > positive drops. So out of scope here.
>
> Could you please elaborate? Is it the case that syzbot constructed some
> extremely convoluted frame to trigger this?

Somewhat convoluted, yes. A packet with a checksum offset beyond the
end of the ip packet.

skb_partial_csum_set (called from virtio_net_hdr_to_skb) verifies that
the offsets are within the linear buffer passed from userspace, but
without protocol parsing we don't know at that time that the offset is
beyond the end of the packet.

> Otherwise the validation
> at the source would work as well, no?

The problem with validation is two fold: it may add noticeable cost to
the hot path and it may have false positives: packets that the flow
dissector cannot fully dissect, but which are harmless and were
previously accepted.

I do want to add such strict source validation based on flow
dissection, but as an opt-in (sysctl) feature.

> Does it actually trigger upstream? The linked syzbot report is for 4.14
> but from the commit description it sounds like the problem should repro
> rather reliably.

From the description, I would assume so, too. Haven't tested.
