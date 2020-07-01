Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66978210115
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgGAApz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgGAApy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:45:54 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A6C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:45:54 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q198so20639702qka.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aAnKHlp3Vwgryni2mlecr0gFWDxmLoB2LsXqdgSpznQ=;
        b=aF+W8dH68GXJ7Uaj2V9lg4Ys/wlC57c6JoTFEylCsZwSKhyXl2bOa1Vh3I/8zmjdMO
         JhYVu0yweMqKjgewxJkalYKrzebQo7MF4oNCs7EZSQIkUayhItd6xXNXbpl1EV6ERa8k
         HHIp/efoAiH88cqPgXfW0UBsjzr+zCbxTc3ye7qJBAjNLOjnZRKqPNoAj4wD8TE6+dSz
         RK3UB5pXIVBgcWn4GYlnOmkkItPDRttXd2CKLpasKxED6XIWIHC5jaKcSb4eNAuQGz7H
         wItRfOQIM8kPRKX/btWrM9V0sR7X4v8POZa4ZFBG+D/wbBioUAu/r4+4Q+sOrowVu7FI
         4QZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aAnKHlp3Vwgryni2mlecr0gFWDxmLoB2LsXqdgSpznQ=;
        b=YIgcCtcvrbpgTOqwGTj4rLdz1H6OCTWHc2DWBmcHj06YvsowK5WQ8HSfsj0dMvB7nv
         wgWxfQ/GxPALW1EcGDFTuQZkty5OTQrpHBdQa1RJGL6TznswGJN9ZUTRlFQ4fHcJYn+J
         zAinAbtdmUJ8w5jfSKREoQMNp2gvvVaaeX9aYamLJgebcJkaVhP74Os92D11Y5+WfZeX
         ulSkJVP7gcyV6r8J504/SBalxbExPS6KECsfmUWNbMRFvCTxccMrTm0R7Ccr1IiCh7vR
         Bl+pETNvXbPPhQdb6fsY/NoDDwGgqAe8ULiI0p1mJh3ElZ73k1jBIu9V2UL7HlFF8ofa
         62vw==
X-Gm-Message-State: AOAM532Rklic3qH0RwtZZdtxD/9wCEyXNlE3xwwhwV3YNvbawAcK33HZ
        PS14QHKM80d0IHUWFNR/zRIdY7Jg
X-Google-Smtp-Source: ABdhPJyaqk8Ac12N/kND8ZgaypyreGS1iMoZKQ3BWbDpq4XrFcL919g78Tjzzgj8KJQGJJQBmKselA==
X-Received: by 2002:ae9:ea13:: with SMTP id f19mr17020970qkg.331.1593564353012;
        Tue, 30 Jun 2020 17:45:53 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id c189sm4473737qkb.8.2020.06.30.17.45.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 17:45:52 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id y13so11058953ybj.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:45:51 -0700 (PDT)
X-Received: by 2002:a25:df81:: with SMTP id w123mr36073524ybg.428.1593564351245;
 Tue, 30 Jun 2020 17:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200630221833.740761-1-kafai@fb.com> <CA+FuTSdbdmvsAZKwUW7AKwfGWDcs5Wff5GoksErzMcmC_2EwRA@mail.gmail.com>
 <20200630234540.2em5gcjthb2lh3x6@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200630234540.2em5gcjthb2lh3x6@kafai-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jun 2020 20:45:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTSetERjsvP=M1VhQeMZ7W_L4PjCM19URh4fA+PwSJu1rdg@mail.gmail.com>
Message-ID: <CA+FuTSetERjsvP=M1VhQeMZ7W_L4PjCM19URh4fA+PwSJu1rdg@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: tcp: Fix SO_MARK in RST and ACK packet
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:46 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jun 30, 2020 at 07:20:46PM -0400, Willem de Bruijn wrote:
> > On Tue, Jun 30, 2020 at 6:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > When testing a recent kernel (5.6 in our case), the skb->mark of the
> > > IPv4 TCP RST pkt does not carry the mark from sk->sk_mark.  It is
> > > discovered by the bpf@tc that depends on skb->mark to work properly.
> > > The same bpf prog has been working in the earlier kernel version.
> > > After reverting commit c6af0c227a22 ("ip: support SO_MARK cmsg"),
> > > the skb->mark is set and seen by bpf@tc properly.
> > >
> > > We have noticed that in IPv4 TCP RST but it should also
> > > happen to the ACK based on tcp_v4_send_ack() is also depending
> > > on ip_send_unicast_reply().
> > >
> > > This patch tries to fix it by initializing the ipc.sockc.mark to
> > > fl4.flowi4_mark.
> > >
> > > Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  net/ipv4/ip_output.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > > index 090d3097ee15..033512f719ec 100644
> > > --- a/net/ipv4/ip_output.c
> > > +++ b/net/ipv4/ip_output.c
> > > @@ -1703,6 +1703,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
> > >         sk->sk_bound_dev_if = arg->bound_dev_if;
> > >         sk->sk_sndbuf = sysctl_wmem_default;
> > >         sk->sk_mark = fl4.flowi4_mark;
> > > +       ipc.sockc.mark = fl4.flowi4_mark;
> > >         err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
> > >                              len, 0, &ipc, &rt, MSG_DONTWAIT);
> > >         if (unlikely(err)) {
> >
> > Yes, this total sense. I missed these cases.
> >
> > Slight modification, the line above then no longer needs to be set.
> > That line was added in commit bf99b4ded5f8 ("tcp: fix mark propagation
> > with fwmark_reflect enabled"). Basically, it pretends that the socket
> > has a mark associated, but sk here is always the (netns) global
> > control sock. So your BPF program was depending on fwmark_reflect?
> Make sense.  I was also tempting to remove the line above.
> Thanks for the commit pointer.
>
> No, the BPF program does not depend on fwmark_reflect.  It depends
> on the sk->sk_mark set by a user space process.

Then I don't fully understand, as ip_send_unicast_reply is only called
with the per-netns percpu ctl_sk.

> I was also considering to do ipcm_init_sk() but then rolled back
> because of the global control sock here.
>
> >
> > ipv6 seems to work differently enough not to have this problem,
> > tcp_v6_send_response passing fl6.flowi6_mark directly to ip6_xmit.
> > This was added in commit commit 92e55f412cff ("tcp: don't annotate
> > mark on control socket from tcp_v6_send_response()").
> Correct. IPv6 does it differently, so the same problem is
> not observed in IPv6.
>
> >
> > But I do see the same pattern where a socket mark is set from a
> > reflected value in icmp_reply and __icmp_send. Those almost certainly
> > need updating too. I can do that separately if you prefer. I even
> > placed ipcm_init right below this sk_mark initialization without
> > considering ipcm_init_sk. D'oh.
> Good point.  I think it will only be a few lines change altogether,
> so it makes little sense to break up the fix.  I will toss mine and
> wait for yours ;)

Will do. Want to double check my initial rushed reading first.

> Thanks for your help!

Not at all. Apologies for the breakage.. Thanks for the initial fix!
