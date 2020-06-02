Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE431EC118
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFBRhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBRhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:37:40 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F58C05BD1E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 10:37:40 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b11so11343230qtt.3
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 10:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EXuKs/ZrhAnv+laNRxA/w5a8bqOks5gwI8BCofPUoP4=;
        b=K1kKD74NXq9TQWEP0sN+piMgV5Qov4NszLh2L4gD2NHoMGAbTTKafgW22Mho7nLrzg
         uKvxUOq+OPaLhktD9N6CuXEPpx5kAtHiXz4fW5qZpuQPShjxhb8LJ1foAE9oqTFsz5GR
         ZIlsETRWogZ1GHXT4X8iqVRjmMggoNxpNiew/BUvETXCOR0lUHiHEjJCw72q6OlDXq0G
         mOaz/TabGjB/zEY2sRVSMN7k/Z5ntlE6anJO2/FIzfE4rq/2lBENct4nUcTuNNUe0j5/
         X8RG4ovMuJX29Iql1ICFQnxEYfC26V6DFRF2s488ZoxSA9VwOqRLFXF6Xip0/PqH8VWc
         bNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EXuKs/ZrhAnv+laNRxA/w5a8bqOks5gwI8BCofPUoP4=;
        b=knvyMty7bA7plcwC190AgrXeyFtpI3QRJmHpSk/EZH3RPSmszWSoMw/V6grkEnb56n
         OQEq2H9fbzqJlhPlHHvNwBf6bdcVihe/yMnjb9cR/JIQizm8Ztwhu5hHNQfjR8vcYSbo
         nyc3ChgLT4pMFtvXITNr03AOE3gmqTQOU+x/60S43LpKWITXJQNN6K7VVdx/digcu/B8
         M8jP9eV4O7C0xZkVd5F51hENDVO9z4Kdv0ldOwVMuIm8Sim7QrPXzx4AJB67NFLmDW4K
         isuUEqqWBGde8yKmV8gCrUHhRiJC1SNvJa022vkgpGCGa194T3OHU8AsvoZoWXt/gIUx
         F7og==
X-Gm-Message-State: AOAM5332IHyrvdjQkptYC13tzjCTh7eH4b8O7KOjZLg9EQms+mpQaLDK
        5CVXCzms6oz0UNZjVQ1Ja0fKjbgk
X-Google-Smtp-Source: ABdhPJyjooL68bm1DBVXMe4pH3OgUNinBpgOB6PbitUjQ4tAA1SiojvSkhM/ePB6ZazuYLD6Rhg7KQ==
X-Received: by 2002:ac8:7cd:: with SMTP id m13mr28187906qth.332.1591119459456;
        Tue, 02 Jun 2020 10:37:39 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id l19sm3137045qtq.13.2020.06.02.10.37.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 10:37:38 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id j8so7423503ybj.12
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 10:37:38 -0700 (PDT)
X-Received: by 2002:a25:f413:: with SMTP id q19mr45233147ybd.178.1591119457607;
 Tue, 02 Jun 2020 10:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080535.1427-1-victor@inliniac.net> <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
 <b0a9d785-9d5e-9897-b051-6d9a1e8f914e@inliniac.net>
In-Reply-To: <b0a9d785-9d5e-9897-b051-6d9a1e8f914e@inliniac.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jun 2020 13:37:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
Message-ID: <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] af-packet: new flag to indicate all csums are good
To:     Victor Julien <victor@inliniac.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Drozdov <al.drozdov@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 1:03 PM Victor Julien <victor@inliniac.net> wrote:
>
> On 02-06-2020 16:29, Willem de Bruijn wrote:
> > On Tue, Jun 2, 2020 at 4:05 AM Victor Julien <victor@inliniac.net> wrote:
> >>
> >> Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
> >> that the driver has completely validated the checksums in the packet.
> >>
> >> The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
> >> in that the new flag will only be set if all the layers are valid,
> >> while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.
> >
> > transport, not ip checksum.
>
> Allow me a n00b question: what does transport refer to here? Things like
> ethernet? It isn't clear to me from the doc.

The TCP/UDP/.. transport protocol checksum.

> (happy to follow up with a patch to clarify the doc when I understand
> things better)
>
> > But as I understand it drivers set CHECKSUM_COMPLETE if they fill in
> > skb->csum over the full length of the packet. This does not
> > necessarily imply that any of the checksum fields in the packet are
> > valid yet (see also skb->csum_valid). Protocol code later compares
> > checksum fields against this using __skb_checksum_validate_complete and friends.
> >
> > But packet sockets may be called before any of this, however. So I wonder
> > how valid the checksum really is right now when setting TP_STATUS_CSUM_VALID.
> > I assume it's correct, but don't fully understand where the validation
> > has taken place..
>
> I guess I'm more confused now about what TP_STATUS_CSUM_VALID actually
> means. It sounds almost like the opposite of TP_STATUS_CSUMNOTREADY, but
> I'm not sure I understand what the value would be.
>
> It would be great if someone could help clear this up. Everything I
> thought I knew/understood so far has been proven wrong, so I'm not too
> confident about my patch anymore...

Agreed that we should clear this up.

> > Similar to commit 682f048bd494 ("af_packet: pass checksum validation
> > status to the user"), please update tpacket_rcv and packet_rcv.
>
> Ah yes, good catch. Will add it there as well.
>
> > Note also that net-next is currently closed.
>
> Should I hold off on sending a v3 until it reopens?

Yep, thanks. You can always check
http://vger.kernel.org/~davem/net-next.html when unsure.
