Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB083B475C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFYQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhFYQ0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 12:26:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3980C061574;
        Fri, 25 Jun 2021 09:23:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h11so11190824wrx.5;
        Fri, 25 Jun 2021 09:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g914Jjm76QsmLVzeN/lBb1BZS1C8GkhpCRu0Pq7q75E=;
        b=SoLoLOHnCqCbQCdAkcczjM79YmdaNPTznGvfYDzVmuKG7s+zQkyxTzG1Ckfb8JrQ4M
         8GrgTBm/R7Zxa/vLSHP/2C2dPa2O52VfylggeRuNFezB+CUkCUoCTDdZxlDwhGt1CUKf
         rNwbs4gcH5dR7QMhdiyR282jp8FeTApu3cjgDEGzUP28cSMLhB9dxZ6+JuDGb2Rzjbm2
         YI/WQFPpQJvrMAxC8BufCqsC7GwfmKlXDiRgXwCt0igaW3+ABy7JhzKBpmBtO2CtUBE6
         xSq7106lNJ2rM/PDywsuNtuh67nPIyNun+eS/c0krzfuG5ydubDCmyA2O3pmzY3/3pGn
         q4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g914Jjm76QsmLVzeN/lBb1BZS1C8GkhpCRu0Pq7q75E=;
        b=b1BsRAqOex/Is1Fg+GqZXYaX7eSn/3zt+CbDaQZ/jCgKHu1R4CbgSrnHL8xTCl1r7+
         yDmyTwnVxmgH7+P7RbNAoCHZNcQr/XYkEv56jHr3bvMkIQB4yDe4HxAUZwaMJQsf02I5
         swXJ7MqtcOZHj5H69d/8B93fse3Tp0okpVx81HGrvpbwVS9L2YlgeSsKO5dDrChpGckh
         SWqzifm2fjujIrnq5lVbiFylgZvPQgzvKHPtAiRTHdQ1015Jk8ebUh/RKE23OgKUl8gx
         thDDncYXtoi+iV4ihqE2zJtOUKHDQCkWLHSEiQ4adgpS2uK1zIrnOwphLUfqc9Jl738j
         YO+Q==
X-Gm-Message-State: AOAM533UxCviUnkB8SVrSA/5HmizZN87K/a70RWLid5k1Gos3nQ4x6L/
        20+a/u0rjgWBjSyQZOPd5JS/RLse2wWhSvYx77Q=
X-Google-Smtp-Source: ABdhPJyzYaRKjxo/PWr9IyRPuS2hD+Vyd08Bp2R15bnDNVjDujmAvsm3S76Q9GOfupBttyOwNUz/uif13J//ClIKQ9Y=
X-Received: by 2002:a05:6000:1acb:: with SMTP id i11mr11923562wry.120.1624638231527;
 Fri, 25 Jun 2021 09:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624549642.git.lucien.xin@gmail.com> <08344e5d9b0eb31c1b777f44cd1b95ecdde5a3d6.1624549642.git.lucien.xin@gmail.com>
 <YNUtWejWC4ftv0DA@horizon.localdomain>
In-Reply-To: <YNUtWejWC4ftv0DA@horizon.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 25 Jun 2021 12:23:41 -0400
Message-ID: <CADvbK_dFw+FLV7yRd9R_xkUotWXe8=r2ptyaQmTjghvLQ9VE9Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sctp: do black hole detection in search
 complete state
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        David Laight <david.laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 9:11 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Jun 24, 2021 at 11:48:08AM -0400, Xin Long wrote:
> > @@ -333,13 +328,15 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
> >               t->pl.probe_size += SCTP_PL_MIN_STEP;
> >               if (t->pl.probe_size >= t->pl.probe_high) {
> >                       t->pl.probe_high = 0;
> > +                     t->pl.raise_count = 0;
> >                       t->pl.state = SCTP_PL_COMPLETE; /* Search -> Search Complete */
> >
> >                       t->pl.probe_size = t->pl.pmtu;
> >                       t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
> >                       sctp_assoc_sync_pmtu(t->asoc);
> >               }
> > -     } else if (t->pl.state == SCTP_PL_COMPLETE) {
> > +     } else if (t->pl.state == SCTP_PL_COMPLETE && ++t->pl.raise_count == 30) {
>
> Please either break the condition into 2 lines or even in 2 if()s. The
> ++ operator here can easily go unnoticed otherwise.
will change it to:
        } else if (t->pl.state == SCTP_PL_COMPLETE) {
                t->pl.raise_count++;
                if (t->pl.raise_count == 30) {

Thanks.
>
> > +             /* Raise probe_size again after 30 * interval in Search Complete */
> >               t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
> >               t->pl.probe_size += SCTP_PL_MIN_STEP;
> >       }
> > --
> > 2.27.0
> >
