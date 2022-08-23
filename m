Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFE59EF55
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiHWWkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiHWWkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:40:31 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1F67F120
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:40:30 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r6so2457959qtx.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tEiLJXVAHrmzpiMmXdTWCj0bWAxM/BiRch8Q/bqnYmk=;
        b=jBJzeUECgQGXkoNFKntIAAPAREE9RPYeNUWJHUPmQ/g5fq36oab9p6G1yz5EhggPnD
         M/gMBVtm4LQVcfOWZonv++4X8z7YTyCijVrWLfADoEUitsc3TFtRv7ZcV/dh7nGC7QaN
         Z6nYRCVXCLmXGILUga1vNLgtk3gYTeJ/pYRlcOIbKYMupLDQOsRSwP2ACh2nz7D0dOpe
         oi4CUBXGdwBqxd7pkdHJases9yS5TSVDJncB6ddAl3zJ4mhgsYsUdFJjXfBguu5FUgGe
         nGHN4qIWTGF+cDnUgK7BLC8xUNzUDi3mULQV3dWHBk0V5PYOcL2K1Mio06GHdoktB8xm
         ugGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tEiLJXVAHrmzpiMmXdTWCj0bWAxM/BiRch8Q/bqnYmk=;
        b=7E08KnRMIVoX9LpzVrVXEs2HmFOst1TqJLYs1Mhs/0bXTg+PrszaR3K2aeia3V9PU/
         ACeyMH5gWCMHyAvB9ckqKK/cAQ0UKGTkq2G1xCP5Ez/Om9vmGfJ8p4d7zefF9mzxCa5r
         z0N5XLyqVZVofXBKozIMhcGZTV8gHKlDDLpIeFR1aoNvdVOPNdXx1iZHvePWp8Bhc5lx
         inszljzJnXhKojWtCf40MKMhn5qldWaUw1R50cogVN/cJzSmTRyj9QJwy9Tbn/Z3VUAi
         cbNloK0W4+cK/erVdPdk52dwfErL4aRnrXnEtv5n1rRiRgwFuEjUZBdqDo74FhhrVJr2
         7uUg==
X-Gm-Message-State: ACgBeo0Bmdw/C59B0odDAkA7nxgsLwtbwbzzZAoy9RsxOJKwtTQY4mBe
        MaC2b98N7Q95Zm99Y34VsTD00HWN5kWewcIADiZJWw==
X-Google-Smtp-Source: AA6agR7gVGAbTsKsk9f5QVA8cPqXqnevBxyh0LPoOpi923lw/ByTStCTGDQPYm3f5HMzI+jmpjFFR6/wziEREhpHdNs=
X-Received: by 2002:a05:622a:244f:b0:344:7c4f:5a94 with SMTP id
 bl15-20020a05622a244f00b003447c4f5a94mr21358999qtb.563.1661294429365; Tue, 23
 Aug 2022 15:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220818170005.747015-1-dima@arista.com> <20220818170005.747015-20-dima@arista.com>
 <01f8616c-2904-42f1-1e59-ca4c71f7a9bd@gmail.com>
In-Reply-To: <01f8616c-2904-42f1-1e59-ca4c71f7a9bd@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 23 Aug 2022 15:40:18 -0700
Message-ID: <CA+HUmGjYkiOmpMUA1JMeC7q4AX=xOo3B=AtTbQabJdbSJmaoQg@mail.gmail.com>
Subject: Re: [PATCH 19/31] net/tcp: Add TCP-AO SNE support
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 7:50 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> On 8/18/22 19:59, Dmitry Safonov wrote:
> > Add Sequence Number Extension (SNE) extension for TCP-AO.
> > This is needed to protect long-living TCP-AO connections from replaying
> > attacks after sequence number roll-over, see RFC5925 (6.2).
>
> > +#ifdef CONFIG_TCP_AO
> > +     ao = rcu_dereference_protected(tp->ao_info,
> > +                                    lockdep_sock_is_held((struct sock *)tp));
> > +     if (ao) {
> > +             if (ack < ao->snd_sne_seq)
> > +                     ao->snd_sne++;
> > +             ao->snd_sne_seq = ack;
> > +     }
> > +#endif
> >       tp->snd_una = ack;
> >   }
>
> ... snip ...
>
> > +#ifdef CONFIG_TCP_AO
> > +     ao = rcu_dereference_protected(tp->ao_info,
> > +                                    lockdep_sock_is_held((struct sock *)tp));
> > +     if (ao) {
> > +             if (seq < ao->rcv_sne_seq)
> > +                     ao->rcv_sne++;
> > +             ao->rcv_sne_seq = seq;
> > +     }
> > +#endif
> >       WRITE_ONCE(tp->rcv_nxt, seq);
>
> It should always be the case that (rcv_nxt == rcv_sne_seq) and (snd_una
> == snd_sne_seq) so the _sne_seq fields are redundant. It's possible to
> avoid those extra fields.

There are cases where rcv_nxt and snd_una are set outside of
tcp_rcv_nxt_update() and tcp_snd_una_update(), mostly during the
initial handshake, so those cases would have to be taken care of
explicitly, especially wrt rollovers.
I see your point though, there may be a potential for some cleaning
up here.

Francesco
