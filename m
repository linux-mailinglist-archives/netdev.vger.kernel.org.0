Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E802A1880
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgJaPSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgJaPSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:18:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465ABC0617A6;
        Sat, 31 Oct 2020 08:18:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g19so551570pji.0;
        Sat, 31 Oct 2020 08:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mLzT6QGTE83fEkxuNpICmgL4EvPWjwnryRpzbYm7G4k=;
        b=iRgeV/jDMsVePzUKmK8sxDTB/AZjjoWaN8rXs/RS9difAaq2fiEtRARx99S53PQRDj
         4qyQuhTP98rxFYE5pshR0y2W3nLQNL155EOBXyKhIE9BZ5KekCxaVheA0stQBsYhz2CQ
         0YOr815YxwPycNsFrIMv26z2kU9a9IKTyfZ0xg0oD7CRvTXXjHmTf90znWE7Tp/GEaLc
         SMbD8dh6bRXLIAWZFHiRXOeb6v6g2pA2G39eQZFigmh8421x8KbCjugQGGSx6eGnp/wR
         Fyr5CR95GS+D44Hp1NDqwAEhiGyGl7pCZ6CbuVKCC0SGD84dOqJghfnPVUoMNIfP8pHh
         Q2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mLzT6QGTE83fEkxuNpICmgL4EvPWjwnryRpzbYm7G4k=;
        b=nd0Oq9bH+6XW3Q3RS7wV6hGkS6QELlhey7pe9YTOyQcNojnRnsa51AiCiOqKpI402Q
         bSnBjag842v0iA+e5r0MAudldxF0P/79d7ZebVUXkY1VDcZcOcwfLnBq6jDdI5PyqmI9
         UwnklUh7V1jwL8hO6AN0S7IvK/sRtm3yieKIrYd2kzMm0MdXWIYtnpZStREyiPQ6QXjF
         tn7yNwX1OQlr7BPfIKaGnNJm/3kJLoZYlFn1zPAobhWRGgLvJhnhkZTB2otGw3nXKWQf
         G7gs8extctI12TVutNu244aQIKQW5lAs7K5B7er+UIGML29nElPWsTqwhJ4xR1E9IY4Y
         2e2w==
X-Gm-Message-State: AOAM530kYHzMYvlDC+cAJvnyqz7XsdmPsEbYqwF3no9JavU1pRe1yDn0
        sc0t5EMNBEtxHO7131dNUqTirLNMqRYn2nl6IdU=
X-Google-Smtp-Source: ABdhPJxxnjEpqBeLzMlt3yaXj5TO7pu26caYl3Lry9+QcsjkHtugRNGdl1ykslR+6SLDsdRWtEkAa5MmbxM7BiHtC/w=
X-Received: by 2002:a17:90a:3e02:: with SMTP id j2mr1325637pjc.210.1604157516184;
 Sat, 31 Oct 2020 08:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
 <20201031004918.463475-2-xie.he.0141@gmail.com> <CA+FuTSfKzKZ02st-enPfsgaQwTunPrmyK2x2jobZrWGb16KN0w@mail.gmail.com>
In-Reply-To: <CA+FuTSfKzKZ02st-enPfsgaQwTunPrmyK2x2jobZrWGb16KN0w@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 31 Oct 2020 08:18:25 -0700
Message-ID: <CAJht_EOhnrBG3R8vJS559nugtB0rHVNBdM_ypJWiAN_kywevrg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 7:33 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > - rx_error:
> > +rx_error:
> >         frad->stats.rx_errors++; /* Mark error */
> > +rx_drop:
> >         dev_kfree_skb_any(skb);
> >         return NET_RX_DROP;
>
> I meant that I don't think errors should be double counted in rx_error
> and rx_drop. It is fine to count drops as either.

OK. Can we do that in another patch? Because I feel this would make
the code a little bit more complex. Let's keep this patch as only a
simple clean-up.

> Especially without that, I'm not sure this and the follow-on patch add
> much value. Minor code cleanups complicate backports of fixes.

To me this is necessary, because I feel hard to do any development on
un-cleaned-up code. I really don't know how to add my code without
these clean-ups, and even if I managed to do that, I would not be
happy with my code.
