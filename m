Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2349214BC84
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 16:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgA1PBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 10:01:36 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36501 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgA1PBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 10:01:35 -0500
Received: by mail-yw1-f66.google.com with SMTP id n184so6609263ywc.3
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 07:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CEi/ZYn7lVvzcZABqwZXlvKhHt3lM6U2N3Bh1ZpWCsg=;
        b=jwBu2JKm8ZshXvMs48Esn+vuAzpcxIcCNQ+YBCnHEqzdrnLFVmUBfNI7CHAOpw7Hr1
         mnfrjF6Y1Aansz59KN0aX3SRv+MEa2Y3TXtiu+3cm9JjbXoZ5ZwLM6MQ3/0SiDRng/Qw
         8NihzAXA9FZny6kgFS+tuDV0APFH/FfyZ2sgm5OKyJixPsGCJOQlcjKYAlojfBGwoW1A
         84YnqQMtMfr0k0/SPEsNo6cNdxdTz0eIszJ2FU01H7xBpfSZc6U1HBQ3AJA79fIH+PlY
         BduoRKtfF0RPy242kzRft0KDnTyN0JTx3iUYaVS0mcY/Rbr0ckK7WQa9G/gdSQsKU3qu
         Q7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEi/ZYn7lVvzcZABqwZXlvKhHt3lM6U2N3Bh1ZpWCsg=;
        b=HYdNGP/nrFxNercdIUYG43ipQBkJk+1/iXc/OqSSARtHWOKZENUR4mig4usIO20/7H
         G9OBFHVGZShPtyrPbjVsQAzoBXd700wcIVO/tgNZrY+QjTLrSmmzGn6NxEKthjN0bjxV
         MJTKAk315VXT4WZTkwVSdO804cGt10lOGsp/MLrvnsxs4acjGb766vjJtd45gC6/Wxr2
         ZjEK+6uQseimtAQGYGUgWVPpvlPHouFT8wOidCZrE/y6abM6e0nKtCgqwYUs5LpNxkrN
         0ok4VWzGqVllD2vr/RhQC7lvzx+RsAgmvS1OBYEYWymCEeiWc+Fgi4SS/4xEdfy9cGnn
         ttIw==
X-Gm-Message-State: APjAAAVPnEh8ofUTWERZM31k5iIF3V/5QZCUgexYrjL6yRmyiPK9ZUPP
        kPt47lxx1t/clFnfoC+lrGL4L7o+
X-Google-Smtp-Source: APXvYqwDUUS047oOKgVT9SYxtIDKxtaKvFNUaVO2U7qXGbJD9I92saTxymsNTDNMxkZpqliumUBZnA==
X-Received: by 2002:a81:9b4c:: with SMTP id s73mr17132547ywg.334.1580223686468;
        Tue, 28 Jan 2020 07:01:26 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id g190sm8322018ywd.85.2020.01.28.07.01.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 07:01:25 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id x191so6816156ybg.12
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 07:01:24 -0800 (PST)
X-Received: by 2002:a25:a2d1:: with SMTP id c17mr17689886ybn.492.1580223684151;
 Tue, 28 Jan 2020 07:01:24 -0800 (PST)
MIME-Version: 1.0
References: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com> <2c22b5de7b99cd6b32117f907ea031beb5b59d1e.camel@redhat.com>
In-Reply-To: <2c22b5de7b99cd6b32117f907ea031beb5b59d1e.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 Jan 2020 10:00:47 -0500
X-Gmail-Original-Message-ID: <CA+FuTScZWjZ3wRbM0Bc-4cMhTxWQ4FjbCL8U+Lxt_zoYhBfVjQ@mail.gmail.com>
Message-ID: <CA+FuTScZWjZ3wRbM0Bc-4cMhTxWQ4FjbCL8U+Lxt_zoYhBfVjQ@mail.gmail.com>
Subject: Re: [PATCH net] udp: segment looped gso packets correctly
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        syzbot <syzkaller@googlegroups.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 6:27 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2020-01-27 at 15:40 -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Multicast and broadcast packets can be looped from egress to ingress
> > pre segmentation with dev_loopback_xmit. That function unconditionally
> > sets ip_summed to CHECKSUM_UNNECESSARY.
> >
> > udp_rcv_segment segments gso packets in the udp rx path. Segmentation
> > usually executes on egress, and does not expect packets of this type.
> > __udp_gso_segment interprets !CHECKSUM_PARTIAL as CHECKSUM_NONE. But
> > the offsets are not correct for gso_make_checksum.
> >
> > UDP GSO packets are of type CHECKSUM_PARTIAL, with their uh->check set
> > to the correct pseudo header checksum. Reset ip_summed to this type.
> > (CHECKSUM_PARTIAL is allowed on ingress, see comments in skbuff.h)
> >
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  include/net/udp.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index bad74f7808311..8f163d674f072 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -476,6 +476,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
> >       if (!inet_get_convert_csum(sk))
> >               features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
> >
> > +     if (skb->pkt_type == PACKET_LOOPBACK)
> > +             skb->ip_summed = CHECKSUM_PARTIAL;
> > +
> >       /* the GSO CB lays after the UDP one, no need to save and restore any
> >        * CB fragment
> >        */
>
> LGTM, Thanks!
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>
> Out of sheer curiosity, do you know what was the kernel behaviour
> before the 'fixes' commit ? GSO packet delivered to user-space stillaggregated ?!?

Yes.. I had missed this entire ip_mc_output path when adding
segmentation (clearly).

Your patch fixed that. The other options would be segmenting in
dev_loopback_xmit or outright failing the call in udp_send_skb.
Neither of which is appealing.

Thanks for reviewing!
