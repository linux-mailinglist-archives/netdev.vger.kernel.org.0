Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293386E959B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjDTNPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjDTNPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:15:34 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2D5659A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 06:15:00 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3e8eaa02e17so2962641cf.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 06:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681996499; x=1684588499;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0iAU0DKxulVVLxVXuAb/4V9p4pg2oU48HHk9LlZTlHs=;
        b=QCvPgzlA7aa2AkAsY4VhNUVbdHhhWIlkYTsyt2DS+LLI1XjH6dc5tGEqRPfihhRMF7
         yB8l+n29NsXgUqUyd1vkKZ38NHR7PWhWmqDrdVZf0TAALe3CzTLR+w1GVBo2dMC+y35V
         RWaC7Jejs0enRJlP6sH1dU7X4U3P6wCsKh9OAAZ8EuPHNVI4PWErFkg4gqfdxcE4QKTa
         JHPkgjeFIaPt1kt7lXEh4WW87clSvA9M0CZBdWUixMc9qFvMNVw5WcNePgp2UDoCDwql
         4KZHANEjvh/f8UBkBKP3TINvZ6LhbJWaPENZps6k5qUrvGJEWREeB0iadXTrkqfeun9L
         3C6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681996499; x=1684588499;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0iAU0DKxulVVLxVXuAb/4V9p4pg2oU48HHk9LlZTlHs=;
        b=CId5l0LWYokWkt+x3XcOpUlMTk/pKF2FYewVazIGEXnpA2DnBd2u/J0zZIqwG9Cx1U
         0YzhM1Hw/49PM3bEKi1A0r9zEEKbgzOew4rzfuDI0T0HvhPv7UCdepk9JDEGqL5DGds5
         7XsfYmGODsyQpA93DrBxvnPIbhOV9d5qNQzMVSe70JuMMwkn2H7b2ljF8JGlTJPeFTOt
         y5ACLowAuBXfmWUmUOx9/lcgfBmKGJgNIiBQhu0DZhV3rb6V7oSYs3n/4T2vOoq55Rvg
         4EUSkGunJdyZH4z3IA0fw70s7dvdmvopSY8FZZ95Af4KaaVl0CsyJcaPvg0olp25lGnN
         hR1w==
X-Gm-Message-State: AAQBX9eSpsdvh4YaaRhGfcFRMyuuBDj1ECLVTl834KxLu2p4mU6AvsVe
        XlNkOvUxUQYjOrDiV6lQ+C0=
X-Google-Smtp-Source: AKy350YqxlkjHRwNNub4P9XhoPV/KybOpvMXGyVMYZG2vOmx2uc4pz4dMz4LW2EldNcrUMjFT2tpjw==
X-Received: by 2002:ac8:570d:0:b0:3bf:c407:10c6 with SMTP id 13-20020ac8570d000000b003bfc40710c6mr1954209qtw.13.1681996499157;
        Thu, 20 Apr 2023 06:14:59 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id a17-20020ae9e811000000b0074dffd87947sm419022qkg.62.2023.04.20.06.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 06:14:58 -0700 (PDT)
Date:   Thu, 20 Apr 2023 09:14:58 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller@googlegroups.com, willemb@google.com
Message-ID: <64413ad24900e_303b5294c8@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230420033013.45693-1-kuniyu@amazon.com>
References: <6440a157b6113_128322942d@willemb.c.googlers.com.notmuch>
 <20230420033013.45693-1-kuniyu@amazon.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > Actually, the skb_clone in __skb_tstamp_tx should already release
> > > > the reference on the ubuf.
> > > > 
> > > > With the same mechanism that we rely on for packet sockets, e.g.,
> > > > in dev_queue_xmit_nit.
> > > > 
> > > > skb_clone calls skb_orphan_frags calls skb_copy_ubufs for zerocopy
> > > > skbs. Which creates a copy of the data and calls skb_zcopy_clear.
> > > > 
> > > > The skb that gets queued onto the error queue should not have a
> > > > reference on an ubuf: skb_zcopy(skb) should return NULL.
> > > 
> > > Exactly, so how about this ?
> > > 
> > > ---8<---
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 768f9d04911f..0fa0b2ac7071 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5166,6 +5166,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> > >  	if (!skb)
> > >  		return;
> > >  
> > > +	if (skb_zcopy(skb) && skb_copy_ubufs(skb, GFP_ATOMIC))
> > > +		return;
> > > +
> > >  	if (tsonly) {
> > >  		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
> > >  					     SKBTX_ANY_TSTAMP;
> > > ---8<---
> > > 
> > 
> > What I meant was that given this I don't understand how a packet
> > with ubuf references gets queued at all.
> > 
> > __skb_tstamp_tx does not queue orig_skb. It either allocates a new
> > skb or calls skb = skb_clone(orig_skb).
> > 
> > That existing call internally calls skb_orphan_frags and
> > skb_copy_ubufs.
> 
> No, skb_orphan_frags() does not call skb_copy_ubufs() here because
> msg_zerocopy_alloc() sets SKBFL_DONT_ORPHAN for orig_skb.
> 
> So, we need to call skb_copy_ubufs() explicitly if skb_zcopy(skb).
> 
> > 
> > So the extra test should not be needed. Indeed I would be surprised if
> > this triggers:
> 
> And this actually triggers.

Oh right, I confused skb_orphan_frags and skb_orphan_frags_rx.

We need to add a call to that, the same approach used for looping in
__netif_receive_skb_core and packet sockets in deliver_skb and
dev_queue_xmit_nit.

@@ -5160,6 +5160,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
                        skb = alloc_skb(0, GFP_ATOMIC);
        } else {
                skb = skb_clone(orig_skb, GFP_ATOMIC);
+
+               if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
+                       return;
        }
        if (!skb)
                return;

