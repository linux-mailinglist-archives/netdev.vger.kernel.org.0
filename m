Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4490334D782
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhC2SnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhC2Sm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:42:58 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE7C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:42:57 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u21so20967355ejo.13
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sglTfesItxI98B5fUI3IH9M39gRJlLKipP1pa3KerZY=;
        b=bL73FfLmZlAIWD1Ro9CzVAqH6qv2ZutwcaLy5y580CUBHUcRgaLmGLP2E/iPh2JDZF
         DHCFzU7vsRGW+ieqWmBywW6uRm0lFwen0Dqrs9La2ARkqshJHs8aBqVtzB4VqrvKqbKY
         NsaEKa63tMyzpdu64RZMo7hUf7Yj6eyp/KS74PbCbxd5SpsIVr3I++CbGl1SlT0s4jiV
         v7qDvXs4grFi7ZDbJOLAiRyI23HgOosGx9eJTLQ9KPomiqF4RvY8XX6OMiFJhd/xaBmq
         uYiJjBS8hhzIA5TMPEmSH0yO3QTXnGKmY6ZjtNw3SE0SQ2alLZhLp2pM507rA85lfxAm
         iCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sglTfesItxI98B5fUI3IH9M39gRJlLKipP1pa3KerZY=;
        b=rWgu5Z2iUxhxiWyQUtsqWiGvT+bH0oURAcnUaIT473ISdcyMm6E8L/EHHGxflkj4JA
         sB1+J5Tf8BaptBB5bFqRWVsp0MDBemAzk5tK/T+y2Mjcc8vhZ4vFgVFybmhqndkFLLm+
         U3WR0nNKVQTBcaGWHoPTY8aScGgJoSmA58DweqSGWyv/R/LQlf+QM284d+ra3w51injc
         3ot8QdsTucRJaalQIXmhjTxmeoZj6mDEABdFlvU8GgBua2Fv2B66H3qBC6Krga33FsVX
         o+MD7raoCefd7lbtR1baTQg0jC2nLbrm+hp/C0+ivn3ooVEiwxGaYq6jYkHlhsxypefV
         kqHg==
X-Gm-Message-State: AOAM531uXQBd2sYiLOdeRGNUgjkvJodqjwu1MDIt6aEF5CjGcuVrUrYe
        slRrZw+EDPq/2VNOSdHvn21UViNQpTs=
X-Google-Smtp-Source: ABdhPJzP1AyisfEb/pmy4Ng0dAydn9+3pqNGP9rr5K14ALg3dH1w/yC7V6MHl4LlQ6JDrhi10rV01A==
X-Received: by 2002:a17:906:a44f:: with SMTP id cb15mr29306547ejb.420.1617043376238;
        Mon, 29 Mar 2021 11:42:56 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id ci22sm5529994ejc.54.2021.03.29.11.42.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 11:42:55 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so19413wma.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:42:55 -0700 (PDT)
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr389427wmg.87.1617043375132;
 Mon, 29 Mar 2021 11:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
 <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
 <CA+FuTSeBRCDcu7uKp9=7UZWR3zmSrk41ArqrseW9jHYgK+WPpg@mail.gmail.com> <065c20b62c479ecd2a9d3bb7bf36de1ac8390a55.camel@gmail.com>
In-Reply-To: <065c20b62c479ecd2a9d3bb7bf36de1ac8390a55.camel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Mar 2021 14:42:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTScRE4JpkNVsn=sNkNoTh=FR9Ey_92qpXus3JmWTELFhMA@mail.gmail.com>
Message-ID: <CA+FuTScRE4JpkNVsn=sNkNoTh=FR9Ey_92qpXus3JmWTELFhMA@mail.gmail.com>
Subject: Re: [PATCH net-next V5 6/6] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 2:34 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> On Sun, 2021-03-28 at 13:00 -0400, Willem de Bruijn wrote:
> > On Wed, Mar 24, 2021 at 2:20 PM Andreas Roeseler
> > <andreas.a.roeseler@gmail.com> wrote:
> > >
> >
> > > +       if (!ext_hdr || !iio)
> > > +               goto send_mal_query;
> > > +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio-
> > > >extobj_hdr))
> > > +               goto send_mal_query;
> > > +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio-
> > > >extobj_hdr);
> >
> > As asked in v3: this can have negative overflow?
>
> The line above checks that iio->extobj_hdr.length is greater than the
> size of iio->extobj_hdr.

Completely missed that, clearly. Thanks, that's great, then.
