Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680E651E238
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444484AbiEFWuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444451AbiEFWuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:50:21 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259EA6A018
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:46:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g20so10213387edw.6
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bwNSJFLdrAt1Nq95iRFhX7Hck4H4kvz0KH+SBtf25ls=;
        b=AnemQI3dWIpo2rhiZSHSW2ucyjJ1QZl2WfTVewXMsdc6yABZnTxMjTBjXanL2YYGps
         weZb+Zq9EZbtyFR8EhbzMamGxSx4xrgDboCrbpLh3RimsbwmHtrF3UaSALWJDk1REmVk
         9dQ5oz7Ji13rVCj5jSK1Iai8H9CZpfqGRvRrzyqKodGZ9R/0avLx4dU3HiG5pJNvq7rK
         xHBETQ3x/r51vIPWhdNQqf3ix16KgF9oW5GcKf7BihPeEYHLB3ScJrU/8VeNH0ReyxgI
         LC1ek6hfUd5jI5eVAO9f8YwOAkaXbokyVQfrnPhW14I32RdzEl8hRcigIleWuQ65D8v5
         yIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bwNSJFLdrAt1Nq95iRFhX7Hck4H4kvz0KH+SBtf25ls=;
        b=CWWmTIxlEbtSRTsIq1WMBV2g1XAtasRgoqJJQrgDbJjyuZgfbWgOVsHIEMDIxBw908
         HvXxzPEbyjB8lyKkBjSTv1yD3LKASKd76FlbSTvHBn/aOYN+RqHHrq3ZFf4HpQnOiZim
         dFI+6FdjsvxUrzqWtLr+CtjcZ6f5EWscEr7rB2RzWsBUHI8wA5abwyT0xiB9a2vFSSNY
         /yhxDv88wCZhsvL0VNG7sgf9azue5AL23d0aettRfPxAk8o1yPIOzvaEBhotqYc+DrTx
         TlNiGoQo5P8h1gTP7rFt8Ol4XIY56PCzggD2mFLOgOTNR1qQAq3+XsRHBizxwC5WslaY
         H12w==
X-Gm-Message-State: AOAM530QDxvv6D28OZdANJK/AMR0wdGmarQSCo2Ep016Jy5u/qakFFdl
        ID6Zbk66qAEArR6uFB2seowebNGnerjKJkvu5bk=
X-Google-Smtp-Source: ABdhPJw+sQOfwGYrRAMcfN7SQIR4ubMLJehzWU26qjq9/3QsUTVK+lcdCBoz5ApiOSNoAi4LiWBHnwY9ET1juRH2VEA=
X-Received: by 2002:a05:6402:2932:b0:425:d7b3:e0d1 with SMTP id
 ee50-20020a056402293200b00425d7b3e0d1mr5863351edb.141.1651877195627; Fri, 06
 May 2022 15:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-3-eric.dumazet@gmail.com> <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
 <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
 <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com>
 <CANn89i+f0PGo86pD4XGS4FpjkcHwh-Nb2=r5D6=jp2jbgTY+nw@mail.gmail.com>
 <CAKgT0UfyUdPmYdShoadHorXX=Xene9WcEPQp2j2SPo-KyHQtWA@mail.gmail.com> <20220506152640.54b9d0ab@kernel.org>
In-Reply-To: <20220506152640.54b9d0ab@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 May 2022 15:46:24 -0700
Message-ID: <CAKgT0Uc=UXrcXDPsOAN0Ti9u6V=tT6jNr0ktex37W-SPNMXc-g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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

On Fri, May 6, 2022 at 3:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 6 May 2022 15:16:21 -0700 Alexander Duyck wrote:
> > On Fri, May 6, 2022 at 2:50 PM Eric Dumazet <edumazet@google.com> wrote:
> > > gso_max_size can not exceed GSO_MAX_SIZE.
> > > This will break many drivers.
> > > I do not want to change hundreds of them.
> >
> > Most drivers will not be impacted because they cannot exceed
> > tso_max_size. The tso_max_size is the limit, not GSO_MAX_SIZE. Last I
> > knew this patch set is overwriting that value to increase it beyond
> > the legacy limits.
> >
> > Right now the check is:
> > if (max_size > GSO_MAX_SIZE || max_size > dev->tso_max_size)
> >
> > What I am suggesting is that tso_max_size be used as the only limit,
> > which is already defaulted to cap out at TSO_LEGACY_MAX_SIZE. So just
> > remove the "max_size > GSO_MAX_SIZE ||" portion of the call. Then when
> > you call netif_set_tso_max_size in the driver to enable jumbograms you
> > are good to set gso_max_size to something larger than the standard
> > 65536.
>
> TBH that was my expectation as well.
>
> Drivers should not pay any attention to dev->gso_* any longer.

Right. However, there are a few protocol items that it looks like do
need to be addressed as SCTP and FCoE appear to be accessing it raw
without any wrappers. So there will be more work than what I called
out to deal with as those would probably need to be wrapped in a min()
function call using the legacy max.

I can take a look at generating the patches if we really want to go
down that route, but it will take me a day or two to get it coded up
as I don't have a ton of free time to work on side projects.
