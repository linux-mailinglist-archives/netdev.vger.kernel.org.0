Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5A651E140
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354623AbiEFVlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbiEFVli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:41:38 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FBF6EC71
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 14:37:54 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n10so16736701ejk.5
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 14:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IhMmmyiCbfTajTm1I2je9SC8UCZMWfjdAhbEn27Gcu8=;
        b=AWqypfa36ems7mytxD5GjR5vF+dX1BAwOWIA3+rKaA6CrhCyxLwKV+YJ/aX/r1dXvP
         YzzEENJOc9Uxdzqa5TOfDHSaF8+AmyrhluRqvW57yb8xIUsPzwSb/cURIMmF8vVWDin5
         veRePezPGwy77sGhTZ5sqwtaFq/SnW3izhhnWMuDLVYxDawwTdc8tNNU7dkc0GoW4iiE
         5H8MnEPN2g9BcHedtKwqhdj+TlAfmaeCN1rYQ6LwWDCf21nHtGVzigmsdKgUhBxw4Fid
         4cr5x9SfOrm4c7Qk/VpB/whDG8mhsL7NOxUw+9j+vILxe66s97VfjfMtvBWGUxUR+09u
         psCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhMmmyiCbfTajTm1I2je9SC8UCZMWfjdAhbEn27Gcu8=;
        b=l1kyT3GC7eHN/9iIAbwF4aNpgUHEagjcmoz1/bp5rpPTyGok8b80GXQ45G3grAjfci
         2DpZ1ornfuzZnA4hpmRGjQJI4goNjc/rtNu3xP7gi5SfQjgbY1RbCGMgAn1s7XvKx6bz
         T3nXPFo0DbtmQHFlDKm3wv7cNr5vAogFtoqDwTjUoetMJ6365c0w7UnttGShU6bO4PMt
         uj4qCZvtxGv2srWIFGYPrWPi868GPp5Eb3VbYitB82L2Ahd9sSAWlMWnLniiKKPwpFCd
         qfFQmvOre+OJVG411WibFHR3LsJcbdnoyC2ZMW6kp/p5MtlVSH6rVEMRwQeQZaUUWtTn
         WdpA==
X-Gm-Message-State: AOAM533KxVgRNXbENxpUWRcDhCO1WWavtN6LXNAz9IsYlsdmZ3XQV5ND
        KC766oIkiLOS+oQ/g8UKmnK9kPMGZfg/bdPM8fs=
X-Google-Smtp-Source: ABdhPJw/pTlaC3ydNkXnisZ+MCL3aOLk2998J8xXrSsimcnubhGak+BA+1mvK47Vh0Nc6jNfOthvL50XNnIMvtyilnM=
X-Received: by 2002:a17:907:d29:b0:6f4:87d4:ecad with SMTP id
 gn41-20020a1709070d2900b006f487d4ecadmr4694859ejc.166.1651873073012; Fri, 06
 May 2022 14:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-3-eric.dumazet@gmail.com> <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
 <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
In-Reply-To: <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 May 2022 14:37:41 -0700
Message-ID: <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
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

On Fri, May 6, 2022 at 2:20 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 6, 2022 at 1:48 PM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > > From: Coco Li <lixiaoyan@google.com>
> > >
> > > This enables ipv6/TCP stacks to build TSO packets bigger than
> > > 64KB if the driver is LSOv2 compatible.
> > >
> > > This patch introduces new variable gso_ipv6_max_size
> > > that is modifiable through ip link.
> > >
> > > ip link set dev eth0 gso_ipv6_max_size 185000
> > >
> > > User input is capped by driver limit (tso_max_size)
> > >
> > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >
> > So I am still not a fan of adding all this extra tooling to make an
> > attribute that is just being applied to one protocol. Why not just
> > allow gso_max_size to extend beyond 64K and only limit it by
> > tso_max_size?
>
> Answer is easy, and documented in our paper. Please read it.

I have read it.

> We do not want to enable BIG TCP for IPv4, this breaks user space badly.
>
> I do not want to break tcpdump just because some people think TCP just works.

The changes I suggested don't enable it for IPv4. What your current
code is doing now is using dev->gso_max_size and if it is the correct
IPv6 type you are using dev->gso_ipv6_max_size. What I am saying is
that instead of adding yet another netdev control you should just make
it so that we retain existing behavior when gso_max_size is less than
GSO_MAX_SIZE, and when it exceeds it all non-ipv6 types max out at
GSO_MAX_SIZE and only the ipv6 type packets use gso_max_size when you
exceed GSO_MAX_SIZE.

The big thing I am not a fan of is adding protocol level controls down
in the link level interface. It makes things confusing. For example,
say somebody has existing scripts to limit the gso_max_size and they
were using IPv6 and your new control is added. Suddenly the
gso_max_size limitations they were setting won't be applied because
you split things up at the protocol level.
