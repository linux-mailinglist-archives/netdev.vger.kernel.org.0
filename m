Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF9C5B93E1
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiIOFO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIOFOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:14:51 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CF115A38
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 22:14:50 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id e68so16957059pfe.1
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 22:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=QcMGBXDRBBZJSGaerWnru9bzxwV8hCMkljMjrSB40r0=;
        b=o8xV8nKtEKAbxr0WFUn0Bx4nbEG40n0ZeV0JxTcYUmu+DkJY5M33y1RSa3g0nZCRUM
         JzFN3rfcrD6NOFKW2xlrBwSEvm4z8VkEys1zvw0HcnPLTXZMfZrX5PtMCcO2rEv4bGol
         T4K7nHBVzDHTSwEJxGhf32pugW3Rx64iSlZz7Lu6j3yylt7dgHZFBsZkF9BYVZSG2D6G
         6HOQU9T5t54RewsHIG7kJY8DnGZXinwL8LzQakjGSGi1SF4B1AYEWwI5M5MLD7E+K8/7
         bEj+CjZDKYEe6523Cpk7aggYpZJ82rmijPCYutkfwDOYiaD1mSOrGJzcitMsRgVSDaIx
         Z0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QcMGBXDRBBZJSGaerWnru9bzxwV8hCMkljMjrSB40r0=;
        b=4oLuFjVLDYF6guY0G4BpK/X+FlPcV0no0BxSoEXKh08hNFOqT34OSKTQNC44Tr6o5d
         bd1SSJn6hKtkYOpMpaPu3AAcx4e7uLVeMXvIM+xFox8oTg0jkgTdljF9wJt8IrJMWbP6
         vXUiOfKSDlmbcuRZ8blCkHqLIi5OOkH0gFd009LPvUTNuEMCxw91+Ga2JVp5pyuVkMar
         rT3IU/3daRocP4SKs4PZs6uLUlJb8+9YMwhSIgnEILFW24/dMbHCYUYuu31uWBYjp032
         4hNdjRTUs+2l6hA5oLM/npf+M0gSZYQlR/dRR++NN/MlacbWCo1IhqHKJRXPZYgUIRT0
         7IKw==
X-Gm-Message-State: ACgBeo01ycq8UNmwEYLIjFqCnT2JUbU7J5U6q20cgIws9kyV8LZtfQP1
        tUpTJhneS0Exu/Mf39vpxMMgNLKjOuSeHEThEi0=
X-Google-Smtp-Source: AA6agR5VyJMfgqMkDy5N+vonuNnfoND8kJCjCV8WKt49J9C8LMxhS4yqUafjtBch/S9/pHyoStivFAK/Tmy4PY/J4RI=
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id
 v8-20020a655688000000b003c21015988emr34826090pgs.280.1663218889528; Wed, 14
 Sep 2022 22:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220906052129.104507-1-saeed@kernel.org> <20220906052129.104507-8-saeed@kernel.org>
 <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com> <20220914203849.fn45bvuem2l3ppqq@sx1>
In-Reply-To: <20220914203849.fn45bvuem2l3ppqq@sx1>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 15 Sep 2022 10:44:37 +0530
Message-ID: <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com>
Subject: Re: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, liorna@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, antoine.tenart@bootlin.com,
        Subbaraya Sundeep <sbhatta@marvell.com>, naveenm@marvell.com,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
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

On Thu, Sep 15, 2022 at 2:08 AM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> On 14 Sep 20:09, sundeep subbaraya wrote:
> >Hi Saeed and Lior,
> >
> >Your mdo_ops can fail in the commit phase and do not validate input
> >params in the prepare phase.
> >Is that okay? I am developing MACSEC offload driver for Marvell CN10K
>
> It's ok since i think there is no reason to have the two steps system ! it
> doesn't make any sense to me ! prepare and commit are invoked consecutively
> one after the other for all mdo_ops and in every offload flow, with no extra
> step in between! so it's totally redundant.
>
> when i reviewed the series initially i was hesitant to check params
> on prepare step but i didn't see any reason since commit can still fail in
> the firmware anyways and there is nothing we can do about it !

Yes, same with us where messages sent to the AF driver can fail in the
commit phase.

> so we've decide to keep all the flows in one context for better readability
> and since the prepare/commit phases are confusing.
>
Okay. I will do the whole init in the prepare phase only and return 0
in the commit phase.

> >and I had to write some clever code
> >to honour that :). Please someone help me understand why two phase
> >init was needed for offloading.
> >
>
> I don't know, let's ask the original author, Antoine ?
> CC: Antoine Tenart <atenart@kernel.org>

Thanks. I added antoine.tenart@bootlin.com in my previous mail but bounced back.

Sundeep
>
>
