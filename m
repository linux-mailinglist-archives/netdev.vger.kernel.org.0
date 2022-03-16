Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D374DA96F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353555AbiCPEzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiCPEzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:55:07 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4568E63B5;
        Tue, 15 Mar 2022 21:53:53 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id z92so326797ede.13;
        Tue, 15 Mar 2022 21:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=41YwHIyQhhABsWKolXViBdA4qfj7HWFBVUZuRnZ9ebw=;
        b=G5i4NaZmSnON7Pt2nuo+i1Slf32ZSPwuR5364bs8hGhRGWn3PbXL9Zg0A0TLP80x+f
         RjhdvIIj2xQC4WKeW5RAZ7/4Ec85tV+Uf+w3NMgJwjbo2x0XX1uwCGLKi4+hhdZPUZWw
         68SKxC+NUgC57PbZen5huHI0TLmCHmlgrlyyRyyQ/emsWzltylGSHvofaTG+udr/FHJe
         f/89x01xJO9oZV3ZNJn9qzp+szdzA2bm6ma9oQfr+34otjsQqnn4x8ev7JKBe8D9qVum
         yn/x3uV6zi3XX1FrV2/AUUag43QlK4FkwLQjKSaGixExQqUxGkjISn5SsebIVtJdKPBr
         MuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=41YwHIyQhhABsWKolXViBdA4qfj7HWFBVUZuRnZ9ebw=;
        b=eZbIYejXnDsl43ZIM6FMIXMGunS/yuNIo1icvgAKDm3MFvoxDytWgM/nTN0n3mYqSb
         bUm4vmvYM6e1D48mVzScFQQ5CAX6U+AWG2EP+Lf5V3GDnZ5vZ7GaZXBELPgEFKDiqmHG
         67GwIjm9D5VffzI0Qc9g4zW59P4vDHbRkc3/VPFkRlQwjYTl1VYq9X7lghapA7lwXvIh
         Jhg5nTlwc0tNY2ybneQbC0eO51zfbQEn9FgZVmhXfk9k+ojUQ4D9Z6CLYX2O2Ffkh9Jg
         /j7f+5+rtLg8LjWndqFKQaHtpYl+tLzUhAuEjIhQYDyTwO1cipgU/woCYVNuDC42Fzxz
         WwqA==
X-Gm-Message-State: AOAM5327VnS0QdZqym2gv4vfJWaxCWrrf/MVuKrhbYlZ279y3T6846IC
        6ofqfQTchxyDZwgUZOCAfbnMfVy+mLwML3SfMAaKCwd4
X-Google-Smtp-Source: ABdhPJxRm4wiWdp6aLQuzmKSGhVhn18voDkJlxb+0dq30uCkDGVoW9B41Ti9WB+V1RLtHSDdwZQ9yJkB1yNgBTqUtvY=
X-Received: by 2002:a05:6402:11d2:b0:418:ea25:976b with SMTP id
 j18-20020a05640211d200b00418ea25976bmr545269edw.310.1647406431901; Tue, 15
 Mar 2022 21:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220314133312.336653-1-imagedong@tencent.com>
 <20220314133312.336653-2-imagedong@tencent.com> <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
In-Reply-To: <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Mar 2022 12:53:40 +0800
Message-ID: <CADxym3bK09hm2zn8yRU5g9fm=MhN7j9xZAjJEoV6_wpuvs9o-w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to gre_rcv()
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 11:49 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/15/22 9:08 PM, Jakub Kicinski wrote:
> > On Mon, 14 Mar 2022 21:33:10 +0800 menglong8.dong@gmail.com wrote:
> >> +    reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >>      if (!pskb_may_pull(skb, 12))
> >>              goto drop;
> >
> > REASON_HDR_TRUNC ?
> >
> >>      ver = skb->data[1]&0x7f;
> >> -    if (ver >= GREPROTO_MAX)
> >> +    if (ver >= GREPROTO_MAX) {
> >> +            reason = SKB_DROP_REASON_GRE_VERSION;
> >
> > TBH I'm still not sure what level of granularity we should be shooting
> > for with the reasons. I'd throw all unexpected header values into one
> > bucket, not go for a reason per field, per protocol. But as I'm said
> > I'm not sure myself, so we can keep what you have..
>
> I have stated before I do not believe every single drop point in the
> kernel needs a unique reason code. This is overkill. The reason augments
> information we already have -- the IP from kfree_skb tracepoint.

Is this reason unnecessary? I'm not sure if the GRE version problem should
be reported. With versions not supported by the kernel, it seems we
can't get the
drop reason from the packet data, as they are fine. And previous seems not
suitable here, as it is a L4 problem.

I'll remove the reason here if there is no positive reply.

Thanks!
Menglong Dong
>
> >
> >>              goto drop;
> >> +    }
> >>
> >>      rcu_read_lock();
> >>      proto = rcu_dereference(gre_proto[ver]);
> >> -    if (!proto || !proto->handler)
> >> +    if (!proto || !proto->handler) {
> >> +            reason = SKB_DROP_REASON_GRE_NOHANDLER;
> >
> > I think the ->handler check is defensive programming, there's no
> > protocol upstream which would leave handler NULL.
> >
> > This is akin to SKB_DROP_REASON_PTYPE_ABSENT, we can reuse that or add
> > a new reason, but I'd think the phrasing should be kept similar.
> >
> >>              goto drop_unlock;
> >> +    }
> >>      ret = proto->handler(skb);
>
