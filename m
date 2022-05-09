Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDA152039F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiEIRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiEIRcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:32:43 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171FC27EB8B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:28:48 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id e12so26211161ybc.11
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61SZqzfhC1uilz9nnexbgLRYlQIMxZUqKVnwcXO5I78=;
        b=g8ss6BhkGQ4P2Ykj2uMnLx/E7G3sxXrO8ZAAiTMrxKoZAFNeDdsUzON1dZp/pvS4gk
         JahX1SsLLUeRE0IMPV58crmBz0HCeArs8Rw/X4VRKvxt1EWdbLHWp0QmLxGVFcZZTNaf
         O+JRRcv7ITUpYLr2THAJ860CpII8EGqEZu1Inn92o0VVXK2Gp33CEDzt9SuhGuXy4thb
         XTDKnPJ9ras3UiW7rEJKtfuNFREJWi1A9/e8QRRD3XtDOa1Yl4Sno3LTx6FU2TBzngcX
         J/t0EGAmctpHlmgxic/PrxxW6Wnt2T9gwfMdou5WpVE9gQiJyihBHbIYsNJjfgLYg7Ma
         gZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61SZqzfhC1uilz9nnexbgLRYlQIMxZUqKVnwcXO5I78=;
        b=el7KkeAR7I2+RrCKvpkUN/3q58owwJaQmxkErWYnYP1VeUBtruEy1/3t8TstyPmNte
         dbPjQg99qTZvl6yf5kg61ocJGt9VkqZDsTPLcZs2HtAcjxRcCCm5AohDIpY9oSXNOn0S
         /vuNm8mYpHm+otCjgSdSsZh8bQRLuO2oA0g2jb04kfBGnxQ5BAGSmgc6ayY3dKkndC7u
         ymFo7jiiWdv15WGQodx/p73t1jONSkKnrLaQ1Icn+ZPuoSNiFUJbg1AzHSmUU6otN70R
         uCfiCP3URfmxEPERsu2OhQtQEROKo2JjLI5+YmMvmHs8K13F78zO6rV6kobKYaaX+5HI
         UDdQ==
X-Gm-Message-State: AOAM531757H4FlJyyHitxzxjebGYyW2ksLOkWhAhWRtYGkc5HeP005lu
        rTM8v8cDvcSqnlPUq6mi5MQcNHbN/SmCZwgU/gwurw==
X-Google-Smtp-Source: ABdhPJwJbU4bbTWqIKURvQky9Thtzn43V90zME7rph6Idcg0fnwLgMpXEgSTCicxVR5eXKBxF01Zqhuf+VHubZtfl3E=
X-Received: by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr14511610ybx.387.1652117327026; Mon, 09
 May 2022 10:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220509165716.745111-1-eric.dumazet@gmail.com> <20220509102059.26f1f16f@kernel.org>
In-Reply-To: <20220509102059.26f1f16f@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 10:28:35 -0700
Message-ID: <CANn89iLrXUbz8J8dSZ29yDqx+uFR7kBBLbTrLkbSn4G+CZn2nQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: warn if transport header was not set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  9 May 2022 09:57:16 -0700 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Make sure skb_transport_header() and skb_transport_offset() uses
> > are not fooled if the transport header has not been set.
> >
> > This change will likely expose existing bugs in linux networking stacks.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/skbuff.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index d58669d6cb91aa30edc70d59a0a7e9d4e2298842..043c59fa0bd6d921f2d2e211348929681bfce186 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -2804,6 +2804,7 @@ static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
> >
> >  static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
> >  {
> > +     WARN_ON_ONCE(!skb_transport_header_was_set(skb));
> >       return skb->head + skb->transport_header;
> >  }
> >
>
> This is for prod or for syzbot?
>
> What are your feelings on putting this under a kconfig?
>
> We already have a #ifdef DEBUG in skb_checksum_none_assert()
> we could generalize that into some form of kconfig-gated
> SKB_CHECK(). Kconfig-gated so that people don't feel self-conscious
> about using it. I wrote such a patch a few times already but never
> sent it.

Sure, we can add a CONFIG_DEBUG_NET, I think it has been suggested in the past.
Then we can ask syzbot teams to turn on this option.

I will send a series with this.
