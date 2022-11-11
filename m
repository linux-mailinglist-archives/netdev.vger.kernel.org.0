Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532D66263DE
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiKKVwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiKKVvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:51:50 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3A66B203
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:51:49 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id bj12so15374354ejb.13
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xqBtcsvDeEWWOpM+1qo9MOf1anVXnbIYJVdxVBTcKLY=;
        b=MQrxGaseJkMJrHZYwU2uJ+bVa11S2lvKq6AxAuMZ6IIJkNOSiLAnhfIi/YCvyWhit/
         8qob01LIq5KeeOqozJa48/irCqALxomw1TzQGsRk1sVlaRVugFvVuIREBeWdRahOVohm
         /juXl8pWN1h2av9shofKM1/PMp9z1/xZKERfjb9k0itTYoFe4wn9eFz+30v9gWeDLhuA
         EQBdX3KeuFs5ETnI7flsJ21iM+iTwE37gyLd0I6XU/0feTNEpTeLNEjkbMwVkYQPtVLt
         22SGmzUYKQx6AzAeawiANFaiLYkTPBWHnaPF/Mk9ovpMKmHnN0ky3B9aKkRS7y8ULJ2H
         r7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqBtcsvDeEWWOpM+1qo9MOf1anVXnbIYJVdxVBTcKLY=;
        b=U8p0CyS5a1UEn7qNcA5wN4Q3e8k0aPk4QAtI3gxA8zpqa5AtpqCKv3Eh1eaaAy9koe
         lY9BUrT/oZvJfuHKUUn4lLrJ8Iqr5Mby+R0BNG0CNGEACgOfO0xgfiyJhV4xS/IO+eHd
         pIET1ZUodWtivHYysHwKZpgS4IO3jrLVONkVAbxE/eTz4X/zlxFfxuOA0Q0Ep9LT99zN
         B8Uz5JRaGSdy1Y1bQeq4R3jAXVP85SXj/Ev0Dg8dUgz4czRUBGLWsxcUDKTiseSqy6R8
         V0DWR8GZ5tEUUXn+dyWq2gxdCSj5rxXnGZLGDCGDzo4GYfVYKVjz8Xzkb45S93QVzfId
         4UXA==
X-Gm-Message-State: ANoB5pkIlZfPLQWjJamSlS8HPMc8LWoHj+ssEs/M/0xVDabhQ42Lyy0h
        6rWcHEz1TH2/NkYCttV4/zOdygK/q5y4BioUTfk=
X-Google-Smtp-Source: AA0mqf598BzoPOJvQOoS/2QkDlL8Kaq+/DQ9MzBD1bsiED2isbNDocZ/agybpoKqUuh2jNeuUplmOL/KECp555ad+/U=
X-Received: by 2002:a17:906:a00e:b0:782:2d3e:6340 with SMTP id
 p14-20020a170906a00e00b007822d3e6340mr3483911ejy.234.1668203508282; Fri, 11
 Nov 2022 13:51:48 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-2-dnlplm@gmail.com>
 <20221111090720.278326d1@kernel.org>
In-Reply-To: <20221111090720.278326d1@kernel.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 11 Nov 2022 22:51:37 +0100
Message-ID: <CAGRyCJF0v8M3Ebd3tSnLpWeB6K5pOtWvbhd1tzOnTE8ZHs4r0w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Il giorno ven 11 nov 2022 alle ore 18:07 Jakub Kicinski
<kuba@kernel.org> ha scritto:
>
> On Wed,  9 Nov 2022 19:02:47 +0100 Daniele Palmas wrote:
> > Add the following ethtool tx aggregation parameters:
> >
> > ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE
> > Maximum size of an aggregated block of frames in tx.
>
> perhaps s/size/bytes/ ? Or just mention bytes in the doc? I think it's
> the first argument in coalescing expressed in bytes, so to avoid
> confusion we should state that clearly.

Right, better to have the word bytes to make it clear.

>
> > ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES
> > Maximum number of frames that can be aggregated into a block.
> >
> > ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME
> > Time in usecs after the first packet arrival in an aggregated
> > block for the block to be sent.
>
> Can we add this info to the ethtool-netlink.rst doc?
>
> Can we also add a couple of sentences describing what aggregation is?
> Something about copying the packets into a contiguous buffer to submit
> as one large IO operation, usually found on USB adapters?
>
> People with very different device needs will read this and may pattern
> match the parameters to something completely different like just
> delaying ringing the doorbell. So even if things seem obvious they are
> worth documenting.
>

Sure, I'll take care of documenting this better.

> > diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> > index d578b8bcd8a4..a6f115867648 100644
> > --- a/Documentation/networking/ethtool-netlink.rst
> > +++ b/Documentation/networking/ethtool-netlink.rst
> > @@ -1001,6 +1001,9 @@ Kernel response contents:
> >    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> >    ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
> >    ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
> > +  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE``      u32     max aggr packets size, Tx
> > +  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES``    u32     max aggr packets, Tx
> > +  ``ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME``    u32     time (us), aggr pkts, Tx
>
> nit: perhaps move _aggr before the specifics? e.g.
>
>  ETHTOOL_A_COALESCE_TX_AGGR_MAX_SIZE
>  ETHTOOL_A_COALESCE_TX_AGGR_USECS_TIME
>

Ack.

> FWIW I find that the easiest way to do whole-sale renames in a series
> is to generate the patches as .patch files, run sed on those, and apply
> them back on a fresh branch. Rebasing is a PITA with renames.
>

Thanks for the advice.

> Other then these nit picks - looks very reasonable :)

Thanks for the review!

Regards,
Daniele
