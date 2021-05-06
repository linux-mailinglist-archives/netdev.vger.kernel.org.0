Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F33374CD5
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 03:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhEFBZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 21:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEFBZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 21:25:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B8EC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 18:24:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id di13so4219118edb.2
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 18:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YELkKA3xaBKLQ3Nmtr/h7jKRGjI/iY6mkAenZXypyZk=;
        b=eAv8aAszdoaihEvQhvKmP9TSg+F/D6MwM+zst/abRDH95fOuJ4eq4SwZgENzEGw9dC
         Emg9EK8uFof8fodtU/Z+DI4btdyYOAeRqIR/AqCIg+bmg0W42x0q5b0cct2lJbZwbHai
         QDuL4PDqaDZsvEVzhWQoh30V8XgzYEn5rGa/DzJXQMDQgnDGVEkV1YiWLcrrB8i9gPWr
         X5o6Y6yGpW53tMdVXh6AllYRwrFCZHlasWIHgMzBF74u5G1S8XDeNtVaybX70k1pGvwh
         q+1mJ8NOpuwvJ4hCrzLS3WcxMxLH/Dj/gp6KcIEd9lni51S+ipj4nzNYoE70747BVJwP
         7fFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YELkKA3xaBKLQ3Nmtr/h7jKRGjI/iY6mkAenZXypyZk=;
        b=k8pK0gtblE1/jAaUKESx7sto7XrIVMbehskrXQUg++zdD40LovPj6/U5j1/Qynu/JW
         OOnhtJbNWKmXhPwLlZFEI1ETYo17/Z0EBLAxBS3QlQ74u3uyLNLv56l1qkkuwbyNiaNH
         WBMzPgZ9HjonyvgZbZmFL2paG174TgmERCAi8Tn2ZqDizb3fkuRxwFDWSYFBoTGCAsIS
         GEAxLM2qj0TSt6MkODViEdtKyB+rApUMMNdbXZTqOACHSXKmT58H8mgIFtJwXTOsbkYv
         fbxpBiLFCoFdYN+tuvYFUfLjSD/vsGb4EPZ9KaNWBGXi/ogiknseyOAvziXGNkoUr3Zu
         u2dw==
X-Gm-Message-State: AOAM533z9HPMj8HGc+iCHMZq11ME9zSDzMFjQeflcYsuxUVCff2nCpjx
        UORwO1VnHr09JfOUjyXQHxdHnjMdOSs=
X-Google-Smtp-Source: ABdhPJwdzv6TnYF+mPO1KHRl8OYdiE3wEIki7/8AYc+Q8BGjd0BEtbzA/EvUWN/peZ3265hjwZcPEA==
X-Received: by 2002:aa7:d8ce:: with SMTP id k14mr2056547eds.248.1620264272167;
        Wed, 05 May 2021 18:24:32 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id e4sm436435ejh.98.2021.05.05.18.24.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 18:24:31 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id l2so3777844wrm.9
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 18:24:31 -0700 (PDT)
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr1742199wri.327.1620264271044;
 Wed, 05 May 2021 18:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
 <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
 <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
 <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com> <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
In-Reply-To: <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 May 2021 21:23:52 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc=x6bG5O7mveAuNc6EXq3TdiD+nNYYp9rfiZ3frfGziA@mail.gmail.com>
Message-ID: <CA+FuTSc=x6bG5O7mveAuNc6EXq3TdiD+nNYYp9rfiZ3frfGziA@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Richard Sanger <rsanger@wand.net.nz>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 7:42 PM Richard Sanger <rsanger@wand.net.nz> wrote:
>
> On Wed, May 5, 2021 at 2:45 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, May 3, 2021 at 9:22 PM Richard Sanger <rsanger@wand.net.nz> wrote:
> > >
> > > Hi Willem,
> > >
> > > This is to match up with the documented behaviour; see the timestamping section
> > > at the bottom of
> > > https://www.kernel.org/doc/html/latest/networking/packet_mmap.html
> [ ... ]
> >
> > Then this would need a
> >
> > Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring,
> > report which ts we got")
>
> ack, I will resubmit the patch with that as the summary line of the commit
> message.

The fixes tag is not the summary line.

> > I don't fully follow the commit message in that patch for why enabling
> > this unconditionally on Tx is safe:
> >
> [...]
> >
> > But I think the point is that tx packets are not timestamped unless
> > skb_shinfo(skb)->tx_flags holds a timestamp request. Such as for
> > the software timestamps that veth can now generate:
> >
>
> I came to the same understanding, tx timestamping should be disabled unless
> the code calls setsockopt SOL_SOCKET/SO_TIMESTAMPING.
>
> > "
> > static inline void skb_tx_timestamp(struct sk_buff *skb)
> > {
> >         skb_clone_tx_timestamp(skb);
> >         if (skb_shinfo(skb)->tx_flags & SKBTX_SW_TSTAMP)
> >                 skb_tstamp_tx(skb, NULL);
> > }
> > "
> >
> > So unless this packet socket has SOF_TIMESTAMPING_TX_SOFTWARE
> > configured, no timestamps should be recorded for its packets, as tx flag
> > SKBTX_SW_TSTAMP is not set.
>
> You are right, that check is working correctly, I'm mistaken on the trigger of
> this behaviour. It doesn't appear related to aa4e689ed1
> (veth: add software timestamping). In fact, this bug is present in Linux 4.19
> the version before that patch was added, and likely earlier versions too.
>
> I've just verified using printk() that after the call to skb_tx_timestamp(skb)
> in veth_xmit() skb->tstamp == 0 as expected.
>
> However, when skb_tx_timestamp() is called within the packetmmap code path
> skb->tstamp holds a valid time.

Interesting. I had expected veth_xmit to trigger skb_orphan, which
calls the destructor.

But this is no longer true as of commit 9c4c325252c5 ("skbuff:
preserve sock reference when scrubbing the skb.").

As a result, I suppose the skb can enter the next namespace and be
timestamped there if receive timestamps are enabled (this is not
per-socket).

One way to verify, if you can easily recompile a kernel, is to add a
WARN_ON_ONCE(1) to tpacket_destruct_skb to see which path led up to
queuing the completion notification.

> > > This patch corrects the behaviour for the tx path. But, doesn't change the
> > > behaviour on the rx path. The rx path still includes a timestamp (hence
> > > the patch always sets the SOF_TIMESTAMPING_SOFTWARE flag on rx).
> >
> > Right, this patch suppresses reporting of any recorded timestamps. But
> > the system should already be suppressing recording of these
> > timestamps.
> >
> > Assuming you discovered this with a real application: does it call
> > setsockopt SOL_SOCKET/SO_TIMESTAMPING at all?
> >
>
> Yes, I can confirm my code does not setsockopt SO_TIMESTAMPING
> Here is the filtered output of strace
>
> # strace ./test-live -c 1 ring:veth0 2>&1  | grep sock
> socket(AF_PACKET, SOCK_RAW, htons(0 /* ETH_P_??? */)) = 3
> setsockopt(3, SOL_PACKET, PACKET_VERSION, [1], 4) = 0
> setsockopt(3, SOL_PACKET, PACKET_TX_RING, {tp_block_size=1048576,
> tp_block_nr=1, tp_frame_size=4096, tp_frame_nr=256}, 16) = 0
> socket(AF_UNIX, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 4
>
> > It's safe to suppress on the reporting side as extra precaution against
> > spuriously timestamped packets. I just want to understand how these
> > timestamps are even recorded in the first place.
> >
>
> Agreed, if this isn't expected behaviour, how skb->tstamp is getting filled
> with a timestamp remains a mystery to me. I'll report back if I find the
> source.

I think we need to understand exactly what goes on before we apply a
patch. It might just be papering over the problem otherwise.
