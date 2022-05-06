Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B1351E100
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444407AbiEFV0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiEFV0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:26:39 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2753E5B884
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 14:22:55 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2f83983782fso94729417b3.6
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 14:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZSjtY0jHJKGaMlS/MHNxrZvt1DEB0mACyUYZ4iwOEtE=;
        b=MXDTwAQXR+6PTu+aXvVWpHBO/Im7kumYm8VEuVR+slOnbVYX3M/r18ensukc1uAF1T
         BZFBuVGgbu8ben2HxXZFdbBZh9O30fDmFBSpBhXufQKIMRV2gIV8Vni4yakGJQeaegDM
         dxy95dvEt2v4VHg8PX3i4expPwgpRS9GJ8YBfEHwPBH/a4iotC7dzQ1bxxhQNjGGNect
         Rfgn94LoKxj5//bZHs+FQRdds6HM/RosTooXJURjJ3b7D1gmjHjZUo5Ce3P9GlZJa55M
         umbngM1y+iKjkHKY58zZ8B9ciB0y9s34aKFjlZoi0Vf79h/vTPcKZchXQS/TnNzz9Qzc
         VLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZSjtY0jHJKGaMlS/MHNxrZvt1DEB0mACyUYZ4iwOEtE=;
        b=Lj0le/IfnoIT86XP0KfpesOBAwNqLCBj4gCi7fwMbBF5o3LO96wqqYl+4kubRwnQza
         1AOGJI6LPXpTwSXQAqwOHpjH4R8KKg8jsqXvNg2OvLUSZOr12Bj5QyoyA/pDcGNIgPBv
         uczHjmSdvqo7amd2krdo0dweXKfglFUrJRi/s+wHXnvOt1YlrZsovamit9VvcB2KrlAC
         vDej15Gdn4WjyUt1ENhXSNPWcrYPX4MZCsJlE76mlFUxI8oUW9gFAzF3CX185aMQXl5y
         KiLlaCYCpW9VTJJ+STpbmg8whVJcSRf32WesMO0P7igs0Yv9lt9md6ZLQHenT5F1UbYJ
         k0BA==
X-Gm-Message-State: AOAM530KZb3g7HLXOriVLPCeI1MHwIVTr8vBHBpx/ip2/vnV7tXceCMq
        U4nIqgqoP9oOF80ksi454XNKYhJZWGi49KpegZUBTw==
X-Google-Smtp-Source: ABdhPJzDpqdQz4WyWFPj3dLKrk2REccW9Ett/mqCL53FjgrSCae3gY1Pgrf8/w8rkw1FLzPV+ahOPfcFfR3Eamba6yM=
X-Received: by 2002:a81:4f0c:0:b0:2f8:46f4:be90 with SMTP id
 d12-20020a814f0c000000b002f846f4be90mr4566711ywb.332.1651872174094; Fri, 06
 May 2022 14:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-8-eric.dumazet@gmail.com> <b75489431902bd73fcefd4da2e81e39eec8cc667.camel@gmail.com>
In-Reply-To: <b75489431902bd73fcefd4da2e81e39eec8cc667.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 14:22:43 -0700
Message-ID: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 07/12] ipv6: add IFLA_GRO_IPV6_MAX_SIZE
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
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

On Fri, May 6, 2022 at 2:06 PM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > Enable GRO to have IPv6 specific limit for max packet size.
> >
> > This patch introduces new dev->gro_ipv6_max_size
> > that is modifiable through ip link.
> >
> > ip link set dev eth0 gro_ipv6_max_size 185000
> >
> > Note that this value is only considered if bigger than
> > gro_max_size, and for non encapsulated TCP/ipv6 packets.
> >
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> This is another spot where it doesn't make much sense to me to add yet
> another control. Instead it would make much more sense to simply remove
> the cap from the existing control and simply add a check that caps the
> non-IPv6 protocols at GRO_MAX_SIZE.

Can you please send a diff on top of our patch series ?

It is kind of hard to see what you want, and _why_ you want this.

Note that GRO_MAX_SIZE has been replaced by dev->gro_max_size last year.

Yes, yet another control, but some people want more control than others I guess.
