Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BECB525AC5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbiEMEe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 00:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiEMEe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 00:34:56 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA95293B59
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 21:34:55 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2ebf4b91212so78302257b3.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 21:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5LVIDD5gSbyFht1+X/mFQns5ulxp5IA0wB9nApyU1U=;
        b=K4P8d7jWYS8WhCd5J+zAYdlsP0MY22mU3o8yhApu2acQBjxLztzAhCt5ejZ9u8gxX9
         2pJ/ltILnLUsNz9yuCywLE3t0ZjPfwEIHoIjPsWmzg7HOBxEhGE1AP2yEkeu+UpD2VXl
         YgDpCzd1g5AcCtG1UbCi5yWznBGoUilmoai3kYTBBbeOrJtzF1SQAq+EuhR3h43M9l5h
         sX0IWeEMXMQvDTCPkBGDNET9+fVhKMl4IZ27/6QK/LdV7qwjvlPaAE6n7vJ2/LMBPlLW
         Y+B0VrMl3MTzuLBblX8OpVOQRifLqL/UJxc1R0XCnZ1tX/VAIe1Z1SCqj+9UDYUpHiCW
         DwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5LVIDD5gSbyFht1+X/mFQns5ulxp5IA0wB9nApyU1U=;
        b=A8cKu4LKa+f/bMbWIy4bDDfI365WF691oCZqsUa1m6vayLT162uFzhf/3INFWf/rSB
         m9zXFpEkHRb71HZVxMGctSfv4NVx/HYWFOZEctNsyB5XzltjNlD04drOXi5krpeAddBv
         qynsL+GnAFFYHqptv53MwLWCnj2EREWOgLRRu6Y0DxAGJbyblWyN+Nw3ZzOb/h4mQ2pr
         k3zzvn7masrwMQJySZZqN2YgOpWvrGPiYsedXIYf76okwAUJCuSGflRkKn0l7i+4DCg6
         FrexQ/n4UZwuw7TXu5Xci+V2/yio3lF/thO3hSkQlQVesKMkoDAt7arY3ICHDksCtVYz
         wqsA==
X-Gm-Message-State: AOAM530H2KipOwMDdWek5ysHhzzntMTcEq1uLLmbqniQ7fmcZh8uytoU
        tKGNXGvn38Y0rbWWzUY9Nb97RD3rJVjUo/k8bY420WZVdcCx6Xvo
X-Google-Smtp-Source: ABdhPJy/yJmHLJFlznImD7j1VdctCiEWW7WgK8EgIYjBKPFN+CGSp2gYKEzhOrtrF0O6kPyZ0a7qCA9NkzSngd+z/X4=
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr3666109ywj.47.1652416494290; Thu, 12
 May 2022 21:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
 <20220510033219.2639364-14-eric.dumazet@gmail.com> <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
 <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com> <20220513042955.rnid4776hwp556vr@fedora>
In-Reply-To: <20220513042955.rnid4776hwp556vr@fedora>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 21:34:43 -0700
Message-ID: <CANn89iKSs3bwUBho_XEuSBRB+v+iR98OZTrhaSS88D4ZYwCwSA@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
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

On Thu, May 12, 2022 at 9:29 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> On 12 May 11:02, Paolo Abeni wrote:
> >On Thu, 2022-05-12 at 01:40 -0700, Saeed Mahameed wrote:
> >> On 09 May 20:32, Eric Dumazet wrote:
> >> > From: Coco Li <lixiaoyan@google.com>
> >> >
> >> > mlx5 supports LSOv2.
> >> >
> >> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> >> > with JUMBO TLV for big packets.
> >> >
> >> > We need to ignore/skip this HBH header when populating TX descriptor.
> >> >
> >>
> >> Sorry i didn't go through all the documentations or previous discussions,
> >> please bare with me, so why not clear HBH just before calling the
> >> driver xmit ndo ?
> >
> >I guess this way is more efficient: the driver copies IP hdr and TCP
> >hdr directly in the correct/final location into the tx descriptor,
> >otherwise the caller would have to memmove L2/L3 just before the driver
> >copies them again.
> >>
>
> memmove(sizeof(L2/L3)) is not that bad when done only every 64KB+.
> it's going to be hard to repeat this and maintain this across all drivers
> only to get this micro optimization that I doubt it will be even measurable.

We prefer not changing skb->head, this would break tcpdump.

Surely calling skb_cow_head() would incur a cost.

As I suggested, we can respin the series without the mlx5 patch, this
is totally fine for us, if we can avoid missing 5.19 train.
