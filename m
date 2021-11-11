Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D785444DC24
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 20:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhKKT0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 14:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbhKKT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 14:26:32 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2334FC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 11:23:43 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w1so28266300edd.10
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 11:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85kEHZWkjtuDK6yqCbTl1Z0J0F6VcjHE/JlxE5FBod4=;
        b=igTlyTIhnN0xKSsbmvUBpLx03D6d6jxDSMzpdWaKmLv9+sbqBAg88CSMaG8AedFnt3
         YGlr1yIZ7O/BIuXnZQA/rFX7lqXe/7Cfg/72S8G5tp56axab3Nib1Pc2RGCKHjupSmuh
         ADzD5G6k5bYztXZRNHm8ZSgoNgkTDpnRVVOk0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85kEHZWkjtuDK6yqCbTl1Z0J0F6VcjHE/JlxE5FBod4=;
        b=EgWnRyFmsqcOjO6XPVVqQAUGukmYsRgnjwwcI2voTavb65C7jDccnrNiQz3DBzV+4N
         7LVJ2MHh+7D8IpMHftIkmwDrsARbkk3mzQtHBJZM8y4BZI4yWIDMuMHoIjoAhcn3ydZT
         5Vn9eTatfHLTGeimSP6f4DHpzMAjw+NtY9XLwY8PMsC10mwBjmzo6B0peXBerapz1t/u
         3cJ9Oy+kcFEDHoIwRiNPUSaE6rk61danf8EWaXxfvjoy5Qqqwx9dXlgP+WHI9lONcLMm
         YLHDnPgQpTgv7xJWr/YCsp/0x8UmYeT+CCWgDuIGgoeDNqTLYPiuvKYflgfNReH8fcQx
         CRJg==
X-Gm-Message-State: AOAM530F3fppa5WpfDoGkUBWARLHIW3kDgkGuLPoX85nSvNPnDLBSr9R
        WQbY/EgKdkRUS5/x0Arbz4a/TD4PNKllHtvbcNf5pA==
X-Google-Smtp-Source: ABdhPJwp1L5UV6zdpA7LXFhFK4/SKCe2CM9N9kdChogAphSaZrOttEUlHhNSA7UGPsMznKt46Y0h5i7IDMw2gWAxn+g=
X-Received: by 2002:a05:6402:2791:: with SMTP id b17mr12814022ede.28.1636658621721;
 Thu, 11 Nov 2021 11:23:41 -0800 (PST)
MIME-Version: 1.0
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com> <1f4b9028-8dec-0b14-105a-3425898798c9@gmail.com>
In-Reply-To: <1f4b9028-8dec-0b14-105a-3425898798c9@gmail.com>
From:   Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date:   Thu, 11 Nov 2021 22:23:29 +0300
Message-ID: <CAJqdLrqvNYm1YTA-dgGsrjsPG6efA8nsUCQLKmGXqoDM+dfpRQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 10:13 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/11/21 9:02 AM, Alexander Mikhalitsyn wrote:
> > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > index 5888492a5257..c15e591e5d25 100644
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -417,6 +417,9 @@ struct rtnexthop {
> >  #define RTNH_COMPARE_MASK    (RTNH_F_DEAD | RTNH_F_LINKDOWN | \
> >                                RTNH_F_OFFLOAD | RTNH_F_TRAP)
> >
> > +/* these flags can't be set by the userspace */
> > +#define RTNH_F_REJECT_MASK   (RTNH_F_DEAD | RTNH_F_LINKDOWN)
> > +
> >  /* Macros to handle hexthops */
>
> Userspace can not set any of the flags in RTNH_COMPARE_MASK.

Hi David,

thanks! So, I have to prepare a patch which fixes current checks for rtnh_flags
against RTNH_COMPARE_MASK. So, there is no need to introduce a separate
RTNH_F_REJECT_MASK.
Am I right?

Regards,
Alex
