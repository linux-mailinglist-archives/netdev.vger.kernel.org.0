Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693BD244C4C
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgHNPph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgHNPpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:45:33 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1378C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 08:45:32 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id k25so4863342vsm.11
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQZzIw/ZCPBQIBTWVJ/QTuh1ruI6/xC6sQhY9LnkgaM=;
        b=dFAkiefpcJ4gc/AAN59D2Bcqi5RMedv9ORvbtUfT55oz/42XK0JOiGXUU+RCxoZl35
         IdpVK/faoeJt/YZPtUkXOO9aoMCwkpydg93VWuQEr3+lj6opxSXZOdFDxERZssC1bOXa
         KjyUE7cV+0TgtQu12uXXFCYfekU4pYzJ7jqyleRlISfqlTHeffNf74r4AmyDWd5nnwa4
         Q4H/oIOogeu+gCMutWjOcRjyN4E16dg2m0UHCbi16C5w65dJjZuZVHNsx0W/OjRl/ikk
         /4ihBV/oWTHR4M9+iib5qEhH1DUz66cwnEYxl5r70BYTs630Ey/WVvyYIqK4Q+QORVhQ
         N0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQZzIw/ZCPBQIBTWVJ/QTuh1ruI6/xC6sQhY9LnkgaM=;
        b=R6c5AIZAvLWuW5+AelSLtqMnNqw4cIz54Y39mF/L5IbFl0cfKauOdgCDpQrGeUGt2M
         E95/0PGuRUr2CitEaxTd+eG8Yxx7WD/dWhVK8H4t0KPZvgQZS1CT9coefmXJWpZLWGcU
         XNZw5gxA0EbAzr76Oe+5b1NwiKWUMSInjDbVa4s7hb3gxHxqSqM57F6s2VBvjgvlrUtV
         4oGNWzVPih0Y/Mvg5vDji3jsJRKphqDIhSzVSAdzRQfGZCeMG1a9TPsFoAm8bn0Jxlz8
         EPYshJ8UZaTGKpyshSA5/HEFDee0EoahfQIzcNdSoy73oZ2Zk0I7y2MSi1dK2wp1UCr0
         MAEg==
X-Gm-Message-State: AOAM532uWZhnaKFJu45FOm6QM/+joOd5EVu09RQ/MIe7mL+6t/h5jfL6
        3y4zQl7wiC/2uKOzeyfePf2msH1cmoKk7Q==
X-Google-Smtp-Source: ABdhPJyTrYRhzbElzXs47pCa56IzsR+yV6yu3QVDsHzIxpu59onAlOGlz99BmnYTiF03ARLhXMwbDg==
X-Received: by 2002:a67:cd10:: with SMTP id u16mr1937870vsl.152.1597419931616;
        Fri, 14 Aug 2020 08:45:31 -0700 (PDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id u82sm1031727vsc.1.2020.08.14.08.45.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2020 08:45:30 -0700 (PDT)
Received: by mail-vs1-f49.google.com with SMTP id j188so4891003vsd.2
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 08:45:30 -0700 (PDT)
X-Received: by 2002:a05:6102:517:: with SMTP id l23mr1899215vsa.114.1597419929742;
 Fri, 14 Aug 2020 08:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <84f3ed74e9de4422933bc6a642890697@huawei.com>
In-Reply-To: <84f3ed74e9de4422933bc6a642890697@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 14 Aug 2020 17:44:53 +0200
X-Gmail-Original-Message-ID: <CA+FuTSd+wGq2V2G1uDBdmyUGe1cquBXdVtSW_7BCwYQEd8E3ag@mail.gmail.com>
Message-ID: <CA+FuTSd+wGq2V2G1uDBdmyUGe1cquBXdVtSW_7BCwYQEd8E3ag@mail.gmail.com>
Subject: Re: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or
 RAW uarg
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 10:17 AM linmiaohe <linmiaohe@huawei.com> wrote:
>
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> >On Thu, Aug 13, 2020 at 1:59 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
> >>
> >> The var extra_uref is introduced to pass the initial reference taken
> >> in sock_zerocopy_alloc to the first generated skb. But now we may fail
> >> to pass the initial reference with newly allocated UDP or RAW uarg
> >> when the skb is zcopied.
> >
> >extra_uref is true if there is no previous skb to append to or there is a previous skb, but that does not have zerocopy data associated yet (because the previous call(s) did not set MSG_ZEROCOPY).
> >
> >In other words, when first (allocating and) associating a zerocopy struct with the skb.
>
> Many thanks for your explaination. The var extra_uref plays the role as you say. I just borrowed the description of var extra_uref from previous commit log here.
>
> >
> >> -               extra_uref = !skb_zcopy(skb);   /* only ref on new uarg */
> >> +               /* Only ref on newly allocated uarg. */
> >> +               if (!skb_zcopy(skb) || (sk->sk_type != SOCK_STREAM && skb_zcopy(skb) != uarg))
> >> +                       extra_uref = true;
> >
> >SOCK_STREAM does not use __ip_append_data.
> >
> >This leaves as new branch skb_zcopy(skb) && skb_zcopy(skb) != uarg.
> >
> >This function can only acquire a uarg through sock_zerocopy_realloc, which on skb_zcopy(skb) only returns the existing uarg or NULL (for not SOCK_STREAM).
> >
> >So I don't see when that condition can happen.
> >
>
> On skb_zcopy(skb), we returns the existing uarg iff (uarg->id + uarg->len == atomic_read(&sk->sk_zckey)) in sock_zerocopy_realloc. So we may get a newly allocated
> uarg via sock_zerocopy_alloc(). Though we may not trigger this codepath now, it's still a potential problem that we may missed the right trace to uarg.

I don't think that can happen.

The question is when this branch is false

                next = (u32)atomic_read(&sk->sk_zckey);
                if ((u32)(uarg->id + uarg->len) == next) {

I cannot come up with a case. I think it might be vestigial. The goal
is to ensure to append only a consecutive range of notification IDs.
Each notification ID corresponds to a sendmsg invocation with
MSG_ZEROCOPY. In both TCP and UDP with corking, data is ordered and
access to changes to these fields happen together as a transaction:

                /* realloc only when socket is locked (TCP, UDP cork),
                 * so uarg->len and sk_zckey access is serialized
                 */
