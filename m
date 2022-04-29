Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA95515822
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381336AbiD2WNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381343AbiD2WNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:13:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886FFDCA8F;
        Fri, 29 Apr 2022 15:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F35FB835F2;
        Fri, 29 Apr 2022 22:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3167C385AC;
        Fri, 29 Apr 2022 22:09:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Np5EIlKu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651270179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9LGudt1GqIizPRQM26b+ZO41MI7PmbOHcHWAXyLKn2Q=;
        b=Np5EIlKucthtGOQfk/DOo4Cq9hKhpGTd3j1zQX5uvwGvLfee0AVTrCAIAJwUmWi6MbJuED
        lK8OB5G0C7/6Kd1kNOO4XtjMyMqsOmq1JxG7vh91pARZGkQjm0hDn3SFKienPToBJcjR9B
        phScaQwnd4E9Fg7qotsSRPkWvtX+zIk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4b85d804 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 22:09:39 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id j2so16867837ybu.0;
        Fri, 29 Apr 2022 15:09:39 -0700 (PDT)
X-Gm-Message-State: AOAM5328dOz+H1YcC3Dbt5wORGST3amTs8TISZu9u00muzdnT1ihjW/2
        h2/8dWNrE8ndzEirXUHnXYXWyuiOd7S9cvWvp4s=
X-Google-Smtp-Source: ABdhPJz3h2nmtdbgmN72dArKaKcdRLlq6+2o1vOXFNkVcyUdfH7HuG/G/dyU/R2fh5iK8eECTVeoY/JFOu9e8wtZpsY=
X-Received: by 2002:a25:b706:0:b0:649:12a0:b18e with SMTP id
 t6-20020a25b706000000b0064912a0b18emr1505746ybj.271.1651270178399; Fri, 29
 Apr 2022 15:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9r_DbZWe4FsfebHSSf_iPctSe5S-w9bU3o8BN43raeURg@mail.gmail.com>
 <20151116203709.GA27178@oracle.com> <CAHmME9pNCqbcoqbOnx6p8poehAntyyy1jQhy=0_HjkJ8nvMQdw@mail.gmail.com>
 <1447712932.22599.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
 <YmszSXueTxYOC41G@zx2c4.com> <04f72c85-557f-d67c-c751-85be65cb015a@gmail.com>
 <YmxTo2hVwcwhdvjO@zx2c4.com> <d9854c74-c209-9ea5-6c76-8390e867521b@gmail.com>
 <CAHmME9qXC-4OPc5xRbC6CQJcpzb96EXzNWAist5A8momYxvVUA@mail.gmail.com> <CANn89iLyNoCRrp6YYdy6kGhM7X2JQ9J4-LfEJCBvhYAv4N+FPA@mail.gmail.com>
In-Reply-To: <CANn89iLyNoCRrp6YYdy6kGhM7X2JQ9J4-LfEJCBvhYAv4N+FPA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 30 Apr 2022 00:09:27 +0200
X-Gmail-Original-Message-ID: <CAHmME9rt_fGfgQSL12Q8CnNdh0Fc-8Z9CBEM9iSNjGCQ_En6Ow@mail.gmail.com>
Message-ID: <CAHmME9rt_fGfgQSL12Q8CnNdh0Fc-8Z9CBEM9iSNjGCQ_En6Ow@mail.gmail.com>
Subject: Re: Routing loops & TTL tracking with tunnel devices
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Sat, Apr 30, 2022 at 12:05 AM Eric Dumazet <edumazet@google.com> wrote:
> I assume you add encap headers to the skb ?

Yes; it's encapsulated in UDP, and under that some short header.
However, everything under that is encrypted. So,

> You could check if the wireguard header is there already, or if the
> amount of headers is crazy.

so it's not quite possible to peer down further to see.

> You also can take a look at CONFIG_SKB_EXTENSIONS infrastructure.

Blech, this involves some kind of per-packet allocation, right? I was
hoping there might be some 6 or 7 or 8 bit field in sk_buff that's not
used anywhere on the TX path that maybe I could overload for this
purpose...

Jason
