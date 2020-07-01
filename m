Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D121155E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgGAVuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAVuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:50:23 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90B8C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 14:50:23 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l6so23761658qkc.6
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 14:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wre+NCOWfqDcGEuAZWj0WO3i5kOMCKa9whNnifx7670=;
        b=Kc86N7tg+XATbNnfCULeeRFKefA5v6URrhh3pHB+2Ov8aCnO5xhjG25bpD1wdjZKQI
         juiYHhFLQ/dOvaZzp6WGEhfx0/dxiOvVOQRyV7OoC/7Vp7Hurg38tRB2l3Si1B/WaVFN
         tev8UOrWQjhB9Ccj5gp0ggGueVnl71hPjrrBJXZpUnv6No8DhW9+lw6RC4v96GH2SI2z
         kjhjt85H+/K2SII3NR/jfCdC4wCOcZtI0GF24D8cw3VYrK8SK2TFudvsavmCfHLimD0M
         qOMKqQLFKARfk/iK4NnlNjb2zauQFPAAXmfOGUTF4BeAzu2c5cK8aE73GaUb6oiKNhaZ
         vLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wre+NCOWfqDcGEuAZWj0WO3i5kOMCKa9whNnifx7670=;
        b=muCyys2awmJxpjNL3lMfAM2cJbR+4b+i51tVMrhEevb3AkrlNsCwr+ZasGM+PkOI+z
         kprOY+uZ1XMOXnSOWUXxvrboOHwysOKp0/Okeosn9nDGrNzP77bmNnBq/PCxA4tImpiw
         9xe3m5OKs2+onNzCnw2bqw+cD8AmHkb9Exk1GYLh1qE7d7SjDAzwdGRb3q+/8B+IRaRi
         yPKo3oV/UO/pJYVqMZ9IQrVomuBqIiij/VqZb8HnEGm1LZUI2w0CUhRlbHoWwNuqE7EO
         11juyXch5vDP6Jccla7xxhp7wd3YVPtLNZu7sGUYO48dAsz4TpToec39T3QkpRiRjih9
         qpnA==
X-Gm-Message-State: AOAM531cOPGxE4NzpdHE2Jy/uLpmiOD5dl9E4MDzUiHL7wnhtBk/9K8w
        SiFEu9ht3ejWtSf5femqH1L3nsx4
X-Google-Smtp-Source: ABdhPJwnLQthDCtEMvosn3uOYCXEl+cs6LK1U08vnk5vpXbgQKOkmqyAWwi43+GdEQO4iMH0kw32dQ==
X-Received: by 2002:a05:620a:1282:: with SMTP id w2mr26332025qki.196.1593640222063;
        Wed, 01 Jul 2020 14:50:22 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id e37sm7033901qtk.94.2020.07.01.14.50.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 14:50:20 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id e197so8688829yba.5
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 14:50:20 -0700 (PDT)
X-Received: by 2002:a25:6885:: with SMTP id d127mr30091452ybc.165.1593640220170;
 Wed, 01 Jul 2020 14:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com> <CA+FuTSerdsJAPSVnNC5DWZzoCHfCB6RO3ZSOxOLmesE5w4bytg@mail.gmail.com>
In-Reply-To: <CA+FuTSerdsJAPSVnNC5DWZzoCHfCB6RO3ZSOxOLmesE5w4bytg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Jul 2020 17:49:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe=VXHdLVEn1NNmgPxV_6Wno-N0406RVkjUoLuTZ8ZmMA@mail.gmail.com>
Message-ID: <CA+FuTSe=VXHdLVEn1NNmgPxV_6Wno-N0406RVkjUoLuTZ8ZmMA@mail.gmail.com>
Subject: Re: [PATCH net] ip: Fix SO_MARK in RST, ACK and ICMP packets
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 5:26 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Jul 1, 2020 at 4:00 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > When no full socket is available, skbs are sent over a per-netns
> > control socket. Its sk_mark is temporarily adjusted to match that
> > of the real (request or timewait) socket or to reflect an incoming
> > skb, so that the outgoing skb inherits this in __ip_make_skb.
> >
> > Introduction of the socket cookie mark field broke this. Now the
> > skb is set through the cookie and cork:
> >
> > <caller>                # init sockc.mark from sk_mark or cmsg
> > ip_append_data
> >   ip_setup_cork         # convert sockc.mark to cork mark
> > ip_push_pending_frames
> >   ip_finish_skb
> >     __ip_make_skb       # set skb->mark to cork mark
> >
> > But I missed these special control sockets. Update all callers of
> > __ip(6)_make_skb that were originally missed.
> >
> > For IPv6, the same two icmp(v6) paths are affected. The third
> > case is not, as commit 92e55f412cff ("tcp: don't annotate
> > mark on control socket from tcp_v6_send_response()") replaced
> > the ctl_sk->sk_mark with passing the mark field directly as a
> > function argument. That commit predates the commit that
> > introduced the bug.
> >
> > Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > Reported-by: Martin KaFai Lau <kafai@fb.com>
>
> I spotted another missing case, in ping_v6_sendmsg. Will have to send a v2.

Turns out, that case is indeed missing, but never existed in the first place.
I can send a separate patch to net-next to add it.

That means that this patch is good as is.
