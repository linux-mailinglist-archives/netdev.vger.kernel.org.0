Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18D9506F8C
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344219AbiDSN73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344509AbiDSN7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:59:25 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13E938BE9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:56:41 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 204so7442723qkg.5
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZkyYghRCM6NN1bxcGAJI+XSXJeWJUcrbGzjK/o46+BA=;
        b=fLGJJK8l17FO2RP0wAoLOOlbMW1xVpJXB1wxoVgetBwcJQ3z/osj1Dm+VMB7Gn5Kbf
         r9L4lKS87Qnt/DwbgUONGZDh5LztZrY4voP1HALGhJZgMnaCqlxXde4pu9NuxA0QCUhk
         DVsK0v26hgIRDmCZvPWUzUMUxHA8R5YeUPRu4OD1vsldQzAiSZj9UkSRCY5s7q1BVaWm
         e1iXnkVaXeMaK10Om44rsFJ0GCmbTx1WBcz7nu65dn9xnTwmZuhhEyFpHm2LqI/iYhLP
         M3X5xSgpyDMtt0A1J4Um3jXpj3B1b8F4XUFOKdQlDmHyKWmz5oLUZrPyUdK8nvnsERkd
         E1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZkyYghRCM6NN1bxcGAJI+XSXJeWJUcrbGzjK/o46+BA=;
        b=s7BM3qtY5T6+5lbeDgr3P9Y7dikqKh9hfCREOOUUEw1tSN8FzFllkSV2rCoiPgePbT
         /JY45cpJN6qouYF2rgEAwp/ZIlZBGLN00EI1vz3QWsf54U1IvIm0mlaet70F6B+k8UAh
         ALDF9M015bfU3Yb0p3zAgP5bwcie5ujkBEchFLI20K31thhYi+ODaQC2NLvu9lKSewEi
         j14Xtpv+iYaOKXSF9FJ60MhPEhUTs/IaLKGAiSzdf8yKk5ycoXTCfwJzJJtRisGZjLqz
         A+3OWq0zAw1l9nsBYKPuYYFx/5SChdIXAxtfiQNa7Ut0O3eBiZGHnFlQPJ3OaXG7kq4s
         wSrQ==
X-Gm-Message-State: AOAM533imcC6LVyioySbX40qR6OdiA52LvM10sTAG5gR6yWyateMVDjd
        BtijWEOErXRyZBwiu4pvtVWw0sjD1eU=
X-Google-Smtp-Source: ABdhPJzTSUa9oybezTvKd74MNtCjnnmLwHarVpusTjnHJyN3pqpYVUCgg7BGXhrli0RIDl79R0qlNg==
X-Received: by 2002:a37:a758:0:b0:69c:8140:195f with SMTP id q85-20020a37a758000000b0069c8140195fmr9686120qke.32.1650376600763;
        Tue, 19 Apr 2022 06:56:40 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id u5-20020a05622a198500b002f1f02b7465sm50656qtc.17.2022.04.19.06.56.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 06:56:39 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id f38so31196351ybi.3
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:56:38 -0700 (PDT)
X-Received: by 2002:a5b:247:0:b0:624:4d24:94ee with SMTP id
 g7-20020a5b0247000000b006244d2494eemr14673744ybp.197.1650376598119; Tue, 19
 Apr 2022 06:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220418044339.127545-1-liuhangbin@gmail.com> <20220418044339.127545-2-liuhangbin@gmail.com>
 <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com> <Yl4mU0XLmPukG0WO@Laptop-X1>
In-Reply-To: <Yl4mU0XLmPukG0WO@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 19 Apr 2022 09:56:02 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfBU7ck91ayf_t9=7eRGJZHuWSeXzX2SxFAQMPSitY9SA@mail.gmail.com>
Message-ID: <CA+FuTSfBU7ck91ayf_t9=7eRGJZHuWSeXzX2SxFAQMPSitY9SA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/af_packet: adjust network header position for
 VLAN tagged packets
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Flavio Leitner <fbl@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>
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

On Mon, Apr 18, 2022 at 11:02 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Mon, Apr 18, 2022 at 11:38:14AM -0400, Willem de Bruijn wrote:
> > Strictly speaking VLAN tagged GSO packets have never been supported.
>
> OK, I thought we just forgot to handle the VLAN header for RAW af socket.
> As in the later path skb_mac_gso_segment() deal with VLAN correctly.
>
> If you think this should be a new feature instead of fixes. I can remove the
> fixes tag and re-post it to net-next, as you said.
>
> > The only defined types are TCP and UDP over IPv4 and IPv6:
> >
> >   define VIRTIO_NET_HDR_GSO_TCPV4        1       /* GSO frame, IPv4 TCP (TSO) */
> >   define VIRTIO_NET_HDR_GSO_UDP          3       /* GSO frame, IPv4 UDP (UFO) */
> >   define VIRTIO_NET_HDR_GSO_TCPV6        4       /* GSO frame, IPv6 TCP */
> >
> > I don't think this is a bug, more a stretching of the definition of those flags.
>
> I think VLAN is a L2 header, so I just reset the network header position.
>
> I'm not familiar with virtio coded. Do you mean to add a new flag like VIRTIO_NET_HDR_GSO_VLAN?
> > > @@ -3055,11 +3068,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
> > >                 virtio_net_hdr_set_proto(skb, &vnet_hdr);
> > >         }
> > >
> > > -       packet_parse_headers(skb, sock);
> > > -
> > > -       if (unlikely(extra_len == 4))
> > > -               skb->no_fcs = 1;
> > > -
> >
> > Moving packet_parse_headers before or after virtio_net_hdr_to_skb may
> > have additional subtle effects on protocol detection.
> >
> > I think it's probably okay, as tpacket_snd also calls in the inverse
> > order. But there have been many issues in this codepath.
>
> Yes
>
> >
> > We should also maintain feature consistency between packet_snd,
> > tpacket_snd and to the limitations of its feature set to
> > packet_sendmsg_spkt. The no_fcs is already lacking in tpacket_snd as
> > far as I can tell. But packet_sendmsg_spkt also sets it and calls
> > packet_parse_headers.
>
> Yes, I think we could fix the tpacket_snd() in another patch.
>
> There are also some duplicated codes in these *_snd functions.
> I think we can move them out to one single function.

Please don't refactor this code. It will complicate future backports
of stable fixes.

> > Because this patch touches many other packets besides the ones
> > intended, I am a bit concerned about unintended consequences. Perhaps
>
> Yes, makes sense.
>
> > stretching the definition of the flags to include VLAN is acceptable
> > (unlike outright tunnels), but even then I would suggest for net-next.
>
> As I asked, I'm not familiar with virtio code. Do you think if I should
> add a new VIRTIO_NET_HDR_GSO_VLAN flag? It's only a L2 flag without any L3
> info. If I add something like VIRTIO_NET_HDR_GSO_VLAN_TCPV4/TCPV6/UDP. That
> would add more combinations. Which doesn't like a good idea.

I would prefer a new flag to denote this type, so that we can be
strict and only change the datapath for packets that have this flag
set (and thus express the intent).

But the VIRTIO_NET_HDR types are defined in the virtio spec. The
maintainers should probably chime in.
