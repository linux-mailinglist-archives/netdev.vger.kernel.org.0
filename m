Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8994B50D21A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 15:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiDXNuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiDXNuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:50:00 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C503716C176
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 06:46:59 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id q75so9100858qke.6
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 06:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8dwBFVIXy534bKGTyyuJDK1gwkEa8o2qP7YdajUgu+g=;
        b=FDkvAgGJ0PNObM/pCjxbWmTzNac5Abl0qKcS/HIco9/IQWF/WCLCbIi0rOXELA4qn6
         lSTMqWF/bEQROUJqEOEpx+Uu7nWjFz6463+8HYFmn2ETfkEngvRqkpU12Pt6zhzL5rCS
         bKn+Hq0lzHn3XLpvDTHWBTtOl23F5TLp/BIbL9qiExOPLM+0yQ7IibHzl7UhhFMMMeSe
         1ndmRdGC1it3S3VickSXM/DIn0qUXIAS7FpajpuxwlJX2GprH32Y/I89kV+Xz/FxtsUc
         j0GnQL7hHBHwNvOw5tVhUFpaWNCWr3AvacGSUv8LJ/hyFhEpExE1LWvaU4MxoOcUoqVv
         +6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8dwBFVIXy534bKGTyyuJDK1gwkEa8o2qP7YdajUgu+g=;
        b=0P9C8PdJGK/eQynhgu64rRzL88JQWvvUCKnGcF/vm9IckNhvGtsDJSJFHzn/Nik085
         2pj1PKiE7rU7nRULOztAuldhqRqc+S0ASfQQi8woLpQ8k7lJ80Qr1HmThspBp6l9oTQO
         9yLJIfbX8GPG8w9kpzOb8gpKVFjRdIpRc5uXkSiO6WpZiaRgZwSS5ZqiLzCPiJabwkaQ
         TQqe/TQuIsBJ6GIW6gCvPlVxFiKqo1wVgEdEvLwYi0UpZToZkG87uVheA+Jd9tr0y6rB
         zcBwTYBcF2wGWVOQGtKrVzHJleo65fXaQZrLXybNtCvs/DdTO9jxiQGFi3zjN7An7K+4
         IxcQ==
X-Gm-Message-State: AOAM531KDZZ5imjAtIJxQ1nIXOyfZYjUyJSkqjMgNhcaV1uq+nV4URrO
        D5v7d0WrM58F/L6Fb7S2apQTV/9mXu8=
X-Google-Smtp-Source: ABdhPJwkjb39nEs/Ze1rM0scEBviQEPZI5TwLdXZP0etwYr676pp2I22ggDFk2Oc2buFmVt5M4qe5g==
X-Received: by 2002:a05:620a:1654:b0:69c:7035:b31f with SMTP id c20-20020a05620a165400b0069c7035b31fmr7628282qko.546.1650808018912;
        Sun, 24 Apr 2022 06:46:58 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id w22-20020a05622a135600b002f3677c36d1sm573401qtk.27.2022.04.24.06.46.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 06:46:57 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id r189so22707158ybr.6
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 06:46:57 -0700 (PDT)
X-Received: by 2002:a05:6902:10c2:b0:645:192e:1a88 with SMTP id
 w2-20020a05690210c200b00645192e1a88mr13139818ybu.117.1650808016622; Sun, 24
 Apr 2022 06:46:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220420082758.581245-1-liuhangbin@gmail.com> <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
 <YmDCHI330AUfcYKa@Laptop-X1> <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
 <YmIOLBihyeLy+PCS@Laptop-X1> <CA+FuTSfzcAUXrxzbLd-MPctTyLu8USJQ4gvsqPBfLpA+svYMYA@mail.gmail.com>
 <YmS2Gd6c1b+o5nyR@Laptop-X1>
In-Reply-To: <YmS2Gd6c1b+o5nyR@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 24 Apr 2022 09:46:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe7zNmJ0JpouMoCFrt5AR19HJQVzDsB3BK46A9rNfowYw@mail.gmail.com>
Message-ID: <CA+FuTSe7zNmJ0JpouMoCFrt5AR19HJQVzDsB3BK46A9rNfowYw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 10:31 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Fri, Apr 22, 2022 at 05:39:48PM -0400, Willem de Bruijn wrote:
> > > If we split skb_probe_transport_header() from packet_parse_headers() and
> > > move it before calling virtio_net_hdr_* function in packet_snd(). Should
> > > we do the same for tpacket_snd(), i.e. move skb_probe_transport_header()
> > > after the virtio_net_hdr_* function?
> >
> > That sounds like the inverse: "move after" instead of "move before"?
>
> That's for "split packet_parse_headers()" option.
>
> >
> > But I thought the plan was to go back to your last patch which brings
> > packet_snd in line with tpacket_snd by moving packet_parse_headers in
> > its entirety before virtio_net_hdr_*?
>
> Yes, exactly.
>
> > > So my conclusion is. There is no need to split packet_parse_headers(). Move
> > > packet_parse_headers() before calling virtio_net_hdr_* function in packet_snd()
> > > should be safe.
> >
> > Ack. Sorry if my last response was not entirely clear on this point.
>
> Thanks a lot for your review. Do you think if I need to re-post the patch?
> Or will you give an Acked-by for this one?

Please resubmit. And then please also add the comment about tap having
the same path.

>
> Hangbin
