Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2E56DF93E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjDLPC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjDLPC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:02:27 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13383DC;
        Wed, 12 Apr 2023 08:02:26 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id h198so18553520ybg.12;
        Wed, 12 Apr 2023 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681311745; x=1683903745;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fb/hrMpWmod5eDn2r5u9iuaYuz4x9DdXJpN5xVKf0r8=;
        b=gJO060poeQQaI+xxCB54ch1IabTjPkvIUQ72oUiKp+EV+ZbQu/ZjDo/G8Lt2sH5fEC
         j8nBayJGT/IEoU6by+litK4n4SAF/birLQ1Fp8x4kIT6Qmr81QkG8D+qWsLpcjmNu5tc
         iFrsqckG5XVKDaRTnO1XWd9BzYcw+NVbjx/txj8ReQQVj2PiyRzmh6jiBM2/thm10c/y
         t+sJpPKD1PYOd3pJOLulGcXLfgMH3fbYaeoecXbVzWR9k6DqAPp3TZjVKEgY/ftG/SYQ
         muXyfCvf+I3n7fXFIf20TdLekMgtcHd0yobUhgb7Bwe1UNuFakAMDfyJ64of4cZHrCOu
         yoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681311745; x=1683903745;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fb/hrMpWmod5eDn2r5u9iuaYuz4x9DdXJpN5xVKf0r8=;
        b=NWe50wa/yc2xS6PwEBFZFKP2+4GIewIFNs7GmICFPNkJaGAj5f/UTHcHqNdmpfMCW/
         tFiJ+t+WVdjIGADv8pN3XnTmYSqu57MYBvFuQKoKVe7ogF5AyEofidqjEHQ/UXLfTJmx
         iwxKB84lUri+msrVrwv+AqTArY00v5DoRS2r/GgGEtSoFSFgZLQPEG1K92Vaxs7fw9aS
         OLLYiubEBT7exvTxW1WuV4ovZr2uEYGrK9RzSNAa1o9zLRThcvsArBYYt2halv3Zp8Mk
         ZeuPDgRfvzk2yWIKrbsTuYtVMdjQD+I/zSXt+vuHkQeO+gZ8CzYV5kIlvqkQs+q6MQSG
         QQsw==
X-Gm-Message-State: AAQBX9f1+IA6pccbiiUC/jJvD3oTE1KpzMQhvlquwuyCj1Xt4l2wLXIX
        IOAsGX/SE8+I4HR0K6RF/k8l4PCH5r+8i6gPVzw=
X-Google-Smtp-Source: AKy350bskx3m/N8JdTwSvkMUCyNbEWVYO6Gy/bnZZH/M1tM7Yx+EJ8SZHDl+NisCN99VMVzHM7tCkUGgS03zI5U1Ix0=
X-Received: by 2002:a25:d657:0:b0:b76:ae61:b68b with SMTP id
 n84-20020a25d657000000b00b76ae61b68bmr9219687ybg.5.1681311745171; Wed, 12 Apr
 2023 08:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230410120629.642955-1-kal.conley@dectris.com>
 <20230410120629.642955-3-kal.conley@dectris.com> <CAJ8uoz0NczOxbs7xqwC4B9YDP5fN1oECBi53yHoaZbvTxcm_fg@mail.gmail.com>
 <CAHApi-kp5FVfHm4tVObbOz7yu6o7PjaFLw8XgLB0OFY=pSuaKg@mail.gmail.com>
In-Reply-To: <CAHApi-kp5FVfHm4tVObbOz7yu6o7PjaFLw8XgLB0OFY=pSuaKg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 12 Apr 2023 17:02:14 +0200
Message-ID: <CAJ8uoz3=hPW7sTzq=aroZkrOdQSNfjZjEQHQRe0uZmKSHnDkNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 2/4] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 12 Apr 2023 at 16:30, Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> > > -       pool->unaligned = unaligned;
> > >         pool->frame_len = umem->chunk_size - umem->headroom -
> > >                 XDP_PACKET_HEADROOM;
> > > +       pool->unaligned = unaligned;
> >
> > nit: This change is not necessary.
>
> Do you mind if we keep it? It makes the assignments better match the
> order in the struct declaration.

Do not mind.

> > > -static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
> > > +static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, u32 page_size)
> > >  {
> > >         u32 i;
> > >
> > > -       for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> > > -               if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> > > +       for (i = 0; i + 1 < dma_map->dma_pages_cnt; i++) {
> >
> > I think the previous version is clearer than this new one.
>
> I like using `i + 1` since it matches the subscript usage. I'm used to
> writing it like this for SIMD code where subtraction may wrap if the
> length is unsigned, that doesn't matter in this case though. I can
> restore the old way if you want.

Please restore it in that case. I am not used to SIMD code :-).
