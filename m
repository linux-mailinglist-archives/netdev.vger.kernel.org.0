Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78311C9D91
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgEGVlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgEGVlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 17:41:06 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B26C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 14:41:06 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g185so1144891qke.7
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 14:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YTQJT/fxeevAlOJFPao4rf9jVkwmCDM4rfm17MXuzZ4=;
        b=eU3oiVbFhC/bPbb1eJ/AhIm4t/B+Lg+Aam15M3CE6QcfiAbURifJb0HhQq1K8crN+P
         fUJdWgj7h+1tG6T8sAfNrVu4cIp60372gn6pDY/uQWW7LD8tPgA2BACvukJu8qzuu3EN
         BvwmLJ2hpUGUfP0ohC0ooYb+KpA8K0TXbvXccxVPwc7FH+JhrI5w3VMuC8zpOQ4omcrX
         CdjGdvS5wraMqf7XqDDD4NuI74A3eyvzUfpvXHuguS65qCpAgGoxduskEj4CYYbmakBj
         h4U82C6yRErfmLPOhv6TUYkF9wk0aAZXfbPdxiv7N/ftD4NxUXaT7AbDJ2sAZ1qzydmb
         wmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YTQJT/fxeevAlOJFPao4rf9jVkwmCDM4rfm17MXuzZ4=;
        b=VdDeMGAq3zon+LpUuVyV2CK3ApZtDrhXXvzAtpjPgD79ukqZAY4sxE/NUfeEpkkZGe
         n5KHsWdSgeGMeZaAeHBXrIHwsKRSl5VHPFeRg5r82pf2KBzoMJNrZfeGiJXS09/eD8lX
         +XnxDVx3IKP6XPxgDRMRtzNYs6UU0n9igeft0rfYANb2VlpidhHr9A5gCyGDDVRy2qwx
         cZG13O+zpjvmr+5mwLObk962r7z6/X3vMHa7RRN36tIF+05xbCZhcn19F9d7JbbzPo/w
         VwHwYRm4o/+961djAlyrqrFpXRkPQIDIr3yNNbH54h7bUcZGqclS5jDmaNqRPDvLCh4f
         pFgA==
X-Gm-Message-State: AGi0PuZv6l/M2M1M+Q3pxwz8WS2P3AO27xTLO6W2HIp/iOcB+a5ytTUk
        l5ObeSb1h6JkFa+Zu3o8tilW+M53
X-Google-Smtp-Source: APiQypL4wK5/h1Gj2FNqf4K+JxUf7/QIyHSpahLnCsyI5VMGZ0Zlsq8DkRfQtXSZNUU16e+m5V8igg==
X-Received: by 2002:a05:620a:110d:: with SMTP id o13mr9325160qkk.212.1588887664719;
        Thu, 07 May 2020 14:41:04 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id y3sm5227092qkc.4.2020.05.07.14.41.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 14:41:03 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id i16so3706715ybq.9
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 14:41:03 -0700 (PDT)
X-Received: by 2002:a25:afd0:: with SMTP id d16mr26029521ybj.441.1588887662986;
 Thu, 07 May 2020 14:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200504162948.4146-1-kelly@onechronos.com> <CA+FuTSco8n3CFJ78RF_rTLCoGd5=haFxrrOKHhuD6UdyApC+Rg@mail.gmail.com>
In-Reply-To: <CA+FuTSco8n3CFJ78RF_rTLCoGd5=haFxrrOKHhuD6UdyApC+Rg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 May 2020 17:40:24 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeDRPh2XEa6QnKYX-ROdBEhaQ0W-ak9z3npZKn7mQuHyA@mail.gmail.com>
Message-ID: <CA+FuTSeDRPh2XEa6QnKYX-ROdBEhaQ0W-ak9z3npZKn7mQuHyA@mail.gmail.com>
Subject: Re: [PATCH] net: tcp: fix rx timestamp behavior for tcp_recvmsg
To:     Kelly Littlepage <kelly@onechronos.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Iris Liu <iris@onechronos.com>,
        Mike Maloney <maloney@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 4:23 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 4, 2020 at 12:30 PM Kelly Littlepage <kelly@onechronos.com> wrote:
> >
> > Timestamping cmsgs are not returned when the user buffer supplied to
> > recvmsg is too small to copy at least one skbuff in entirety.
>
> In general a tcp reader should not make any assumptions on
> packetization of the bytestream, including the number of skbs that
> might have made up the bytestream.
>
> > Support
> > for TCP rx timestamps came from commit 98aaa913b4ed ("tcp: Extend
> > SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which noted that the cmsg
> > should "return the timestamp corresponding to the highest sequence
> > number data returned." The commit further notes that when coalescing
> > skbs code should "maintain the invariant of returning the timestamp of
> > the last byte in the recvmsg buffer."
>
> This states that if a byte range spans multiple timestamps, only the
> last one is returned.
>
> > This is consistent with Section 1.4 of timestamping.txt, a document that
> > discusses expected behavior when timestamping streaming protocols. It's
> > worth noting that Section 1.4 alludes to a "buffer" in a way that might
> > have resulted in the current behavior:
> >
> > > The SO_TIMESTAMPING interface supports timestamping of bytes in a
> > bytestream. Each request is interpreted as a request for when the entire
> > contents of the buffer has passed a timestamping point....In practice,
> > timestamps can be correlated with segments of a bytestream consistently,
> > if both semantics of the timestamp and the timing of measurement are
> > chosen correctly....For bytestreams, we chose that a timestamp is
> > generated only when all bytes have passed a point.
> >
> > An interpretation of skbs as delineators for timestamping points makes
> > sense for tx timestamps but poses implementation challenges on the rx
> > side. Under the current API unless tcp_recvmsg happens to return bytes
> > copied from precisely one skb there's no useful mapping from bytes to
> > timestamps. Some sequences of reads will result in timestamps getting
> > lost
>
> That's a known caveat, see above. This patch does not change that.
>
> > and others will result in the user receiving a timestamp from the
> > second to last skb that tcp_recvmsg copied from instead of the last.
>
> On Tx, the idea was to associate a timestamp with the last byte in the
> send buffer, so that a timestamp for this seqno informs us of the
> upper bound on latency of all bytes in the send buffer.
>
> On Rx, we currently return the timestamp of the last skb of which the
> last byte is read, which is associated with a byte in the recv buffer,
> but it is not necessarily the last one. Nor the first. As such it is
> not clear what it defines.
>
> Your patch addresses this by instead always returning the timestamp
> associated with the last byte in the recv buffer. The same timestamp
> could then be returned again for a subsequent recv call, if the entire
> recv buffer is filled from the same skb. Which is fine.
>
> That sounds correct to me.

Due to my earlier comments the patch is no longer on patchwork. Can
you please resubmit it.

But to be clear, the code looks good to me. Please add

Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")

The commit message can perhaps be a bit shorter. They key points are

1. the stated intent of the original commit is to "return the
timestamp corresponding to the highest sequence number data returned."
2. the current implementation returns the timestamp for the last byte
of the last fully read skb, which is not necessarily the last byte in
the recv buffer.
3. that this patch converts behavior to the original definition.

Previous draft versions of the patch recorded the timestamp before
label skip_copy, which also matches this behavior.

I took a quick look at the selftests under
tools/testing/selftests/net, but they don't test for this specific
behavior. Given that test code should make no assumptions on
packetization, it is also not that straightforward to test in a robust
manner.


>
> > The
> > proposed change addresses both problems while remaining consistent with
> > 1.4 and the wording of commit 98aaa913b4ed ("tcp: Extend
> > SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg").
> >
> > Co-developed-by: Iris Liu <iris@onechronos.com>
> > Signed-off-by: Iris Liu <iris@onechronos.com>
> > Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
> > ---
> >  net/ipv4/tcp.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 6d87de434377..e72bd651d21a 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2154,13 +2154,15 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
> >                         tp->urg_data = 0;
> >                         tcp_fast_path_check(sk);
> >                 }
> > -               if (used + offset < skb->len)
> > -                       continue;
> >
> >                 if (TCP_SKB_CB(skb)->has_rxtstamp) {
> >                         tcp_update_recv_tstamps(skb, &tss);
> >                         cmsg_flags |= 2;
> >                 }
> > +
> > +               if (used + offset < skb->len)
> > +                       continue;
> > +
> >                 if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
> >                         goto found_fin_ok;
> >                 if (!(flags & MSG_PEEK))
> > --
> > 2.26.2
