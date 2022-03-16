Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA3E4DA962
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352652AbiCPEnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiCPEnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:43:12 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7BF39157;
        Tue, 15 Mar 2022 21:41:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id gb39so1776765ejc.1;
        Tue, 15 Mar 2022 21:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LSi032MPexBwSWAjYpSegRnuljthXgeCqq+PcOZ1jg=;
        b=YBE4Ai8U/I5SX9Lef5WYrZ5sA03D8ACjb9/Rl3M2qfrpjg2rFys22EjOmgXaRlqGml
         YV9M1ev2Yf3b1lKarKDS4YieeUP3VHX3NC1RFVGdpcXWmeuxi4SIiZp4a8jYCTnZWkhv
         KEQLh/wh/TNizdeANkrWgRTHnOUF6/8tcyJ3M6FuxPv5uJ2gfsMC4bL97UoiCvA7wHYr
         BiR9gGoZ8/DLNdiKlP7LK7J5U2oVWbuuOgqJt2WbXJne370UxFgVy8XWx/9kbTzhVUVz
         RSKJyGgVw+6AtWXXrPpuhRgWi5hmzDjgRbuo5ApG18Ym9/AEWaUAQzj2kOdBhiP1CqJh
         c18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LSi032MPexBwSWAjYpSegRnuljthXgeCqq+PcOZ1jg=;
        b=5INFWb1DW2PTgXlhbpCS8MOIvM+BWasqKM6cmdnMkwXKxFKHZx1fC1911Iznv52MsI
         hDzsbpnu5zHF0Yh+piWTfK5XVEIzhhLu3/vi4+08rF3FVPHF63oYWas/Vrt2MRGQ8Xtq
         G6mYy/pSe5LN4BDQacacHvCbNob3Xjmr+KoOop4roAE2PaCImI3xpifQR3GVuMziocvX
         Gm0O2+ohi5ZpmDougRo6HN5QiQsuqpzzOQ9MdMVCVqn1G0QT7fHTta/0vclI7L56VNTn
         /XyGjuum4wIY5HXtQrXhox59BqHUFzOcgCmCHnkInIC4EZe/WfUyK6rqSr80BBOb9lYS
         4RQw==
X-Gm-Message-State: AOAM532VQPLrhrvdH0iTCLioxRDniltVZtMKdpOBPCbCeh0wGIqS53Pu
        6svaFVJvGCzPW+4u7HC0Fv3kdC2NqrhoW6gRWns=
X-Google-Smtp-Source: ABdhPJwNZojp0VKsLt8cCUdmYKh/ks79gZzbWmAePBuCNAEOBIl6+S3JADvWJuER0SYIT/bNbmQq6Y/hvUZ/QkImo28=
X-Received: by 2002:a17:906:6a11:b0:6d7:76cc:12f6 with SMTP id
 qw17-20020a1709066a1100b006d776cc12f6mr25500385ejc.456.1647405717221; Tue, 15
 Mar 2022 21:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220314133312.336653-1-imagedong@tencent.com>
 <20220314133312.336653-2-imagedong@tencent.com> <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Mar 2022 12:41:45 +0800
Message-ID: <CADxym3YQZHwYSvg-ikH8N2iH3tBwAxusCsLHDMtCUjQj2h_chg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to gre_rcv()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
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

On Wed, Mar 16, 2022 at 11:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Mar 2022 21:33:10 +0800 menglong8.dong@gmail.com wrote:
> > +     reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >       if (!pskb_may_pull(skb, 12))
> >               goto drop;
>
> REASON_HDR_TRUNC ?

I'm still not sure about such a 'pskb_pull' failure, whose reasons may be
complex, such as no memory or packet length too small. I see somewhere
return a '-NOMEM' when skb pull fails.

So maybe such cases can be ignored? In my opinion, not all skb drops
need a reason.


>
> >       ver = skb->data[1]&0x7f;
> > -     if (ver >= GREPROTO_MAX)
> > +     if (ver >= GREPROTO_MAX) {
> > +             reason = SKB_DROP_REASON_GRE_VERSION;
>
> TBH I'm still not sure what level of granularity we should be shooting
> for with the reasons. I'd throw all unexpected header values into one
> bucket, not go for a reason per field, per protocol. But as I'm said
> I'm not sure myself, so we can keep what you have..
>
> >               goto drop;
> > +     }
> >
> >       rcu_read_lock();
> >       proto = rcu_dereference(gre_proto[ver]);
> > -     if (!proto || !proto->handler)
> > +     if (!proto || !proto->handler) {
> > +             reason = SKB_DROP_REASON_GRE_NOHANDLER;
>
> I think the ->handler check is defensive programming, there's no
> protocol upstream which would leave handler NULL.
>
> This is akin to SKB_DROP_REASON_PTYPE_ABSENT, we can reuse that or add
> a new reason, but I'd think the phrasing should be kept similar.

With the handler not NULL, does it mean the gre version is not supported here,
and this 'SKB_DROP_REASON_GRE_NOHANDLER' can be replaced with
SKB_DROP_REASON_GRE_VERSION above?

>
> >               goto drop_unlock;
> > +     }
> >       ret = proto->handler(skb);
